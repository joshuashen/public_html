#! /usr/bin/env python

# BETA VERSION--may not work with all fasta files, with gl contigs, with fasta files
# with chr in front of the contig names
# improvements to come

import re
import string
from optparse import OptionParser

def getGCPercentL(window_l, fasta_file):
    GCregex = re.compile(r"G|C")
    GCPercent_l = [] 
    contig_offset_d = getContigOffsetD(fasta_file)    
    for window in window_l:
        contig = window[0]
        startbase = window[1]
        endbase = window[2]
        number_bases = endbase - startbase + 1
        sequence = getSequence(contig, startbase, endbase, contig_offset_d)
        GCPercent_l.append(window + 
            [round( 100 * len (GCregex.findall(sequence)) /
                    float (number_bases) ) / 100.0  ])
    return GCPercent_l


# given a bedfile with coordinates for exonic regions, returns a list
# of those regions.  because the chromEnd of a feature in a bed file list
# is not included in the exonic region, the chromEnd in the bedfile
# is reduced by 1.
# the list returned is in the format [['1', 14642, 14881], ['1', 14943, 15062],...]
def getExonL(bedfile):
    exons_BED_ob = BEDFileOb(fn = bedfile)
    exon_l = []
    for r in exons_BED_ob:
        exon_l.append([r.getStartPos_t()[0], r.getStartPos_t()[1],\
            r.getEndPos_t()[1] - 1])
    return exon_l

def getSequence(contig, startbase, endbase, contig_offset_d):
    with open(fasta_file, 'rb') as fh:       
        start = contig_offset_d[contig] + startbase + startbase / 60
        end = contig_offset_d[contig] + endbase + endbase / 60
        fh.seek(start)
        sequence = fh.read(end - start + 1)           
    return string.replace(sequence, '\n', '')

def getContigLength_d():
    FAI = REF_PATH + ".fai"
    FAI_ob = FAIFileOb(fn = FAI)
    contig_length_d = {}
    for FAIline in FAI_ob:
        contig_length_d[FAIline.getContig()] = FAIline.getLength()
    return contig_length_d

def getContigOffsetD(fasta_file):
    FAI = fasta_file + ".fai"
    FAI_ob = FAIFileOb(fn = FAI)
    contig_offset_d = {}
    for FAIline in FAI_ob:
        contig_offset_d[FAIline.getContig()] = FAIline.getOffset()
    return contig_offset_d

def writeListToFile(l, path):
    new_list = []
    for line in l:
        new_list.append("\t".join([str(f) for f in line]))
    with open(path, 'wb') as fh:
        fh.write("\n".join([line for line in new_list]))

# improve this function so it can accommodate files with headers
def readListFromFile(path, field_l):
    output_l = []
    with open(path, 'rb') as fh:
        for line in csv.reader(fh, delimiter = '\t'):
            #import pdb; pdb.set_trace()
            output_l.append([line[i] for i in field_l])
    return output_l

# object for handling files in various position-indexed file formats
# files can be loaded into memory or read from disk based on the memory_flag
# accommodates files with one record per genomic position (e.g. pileup) and files with multiple records (e.g., vcf, sam)  
# for files with multiple records it is preferable to iterate through the file; altough records can be accessed with a position tuple (returns a list of records) or a position tuple plus an index (returns a single record)
# (change disk methods so they read a chunk from the file at once instead of one line at a time?)
class GeneFileOb(object):
    def __init__(self, fn, line_type, memory_flag = True,\
                 header_symbol = None, index_flag = False,\
                 one_record_per_pos_flag = True):
        self.memory_flag = memory_flag
        self.one_record_per_pos_flag = one_record_per_pos_flag 
        self.header_symbol = header_symbol
        self.fn = fn
        self.line_type = line_type
        if self.memory_flag:
            self.d = self.get_line_d()
            self.length = len(self.d)
        else:
            self.current_contig = ""
            self.current_pos = -1
            self.current_index = 0
            self.fh = open(self.fn, "rb")
            self.index_flag = index_flag
            if index_flag:
                self.getContigPosD()
            else:
                self.length = None   
    
    def __len__(self):
        if self.length == None:
            self.getContigPosD()
            index.flag = True
        return self.length
    
    def get_all_lines_l(self):
        with open(self.fn, 'rb') as fh:
            if self.header_symbol != None:
                next_line = fh.readline()
                while next_line.startswith(self.header_symbol):
                     next_line = fh.readline()
                return [next_line] + fh.readlines()
            else:
                return fh.readlines()
                
    def get_line_d(self):
        line_d = {} 
        line_l = self.get_all_lines_l()
        if self.one_record_per_pos_flag:
            for line in line_l:
                pos_t = self.line_type(line).getPos_t()
                line_d[pos_t] = self.line_type(line)
        else:
            last_pos_t = ("", 0)
            for line in line_l:
                pos_t = self.line_type(line).getPos_t() 
                if pos_t != last_pos_t:
                    counter = 0
                    line_d[(pos_t, counter)] = self.line_type(line)
                    last_pos_t = pos_t
                elif pos_t == last_pos_t:
                    counter += 1
                    line_d[(pos_t, counter)] = self.line_type(line)
        return line_d 

    def __iter__(self):
        if self.memory_flag:
            return self.memoryLineIter()
        else:
            return self.diskLineIter()

    def memoryLineIter(self):
        line_l = sorted(self.d.values(), cmp = lambda x,y: cmp(x.getPos_t(), y.getPos_t()))
        for l in line_l:
            yield l

    def diskLineIter(self):
        self.fh.seek(0)
        next_line = self.fh.readline()
        if self.header_symbol != None:
            while next_line.startswith(self.header_symbol):
                next_line = self.fh.readline()
        while len(next_line) != 0:
            yield self.line_type(next_line)
            next_line = self.fh.readline()

    def memoryGetItem(self, key):
        if self.one_record_per_pos_flag:
            if key in self.d:
                return self.d[key]
            else:
                return None
        else:
            if len(key[0]) == 1:
                l = []
                counter = 0
                while (key, counter) in self_d:
                    l.append(self.d[(key, counter)])
                    counter += 1
                if len(l) == 0:
                    return None
                else:
                    return l
            else:
                if key in self.d:
                    return self.d[key] 
                else:
                    return None
                    
    def diskGetItem(self, key):
        if self.one_record_per_pos_flag:
            pos_t = key
            if self.current_contig != pos_t[0] or\
              self.current_contig == pos_t[0] and self.current_pos > pos_t[1]:
                if not self.index_flag:
                    self.getContigPosD()
                    self.index_flag = True
                if pos_t[0] in self.contig_pos_d:
                    self.fh.seek(self.contig_pos_d[pos_t[0]])
                    self.current_pos = 0
                    self.current_contig = pos_t[0]
                else:
                    return None
            while self.current_contig  == pos_t[0] and self.current_pos < pos_t[1]:
                self.current_line = self.fh.readline()
                if len(self.current_line) == 0:
                    return None
                (self.current_contig, self.current_pos) = \
                    self.line_type(next_line).getPos_t()
            if (self.current_contig, self.current_pos) == pos:
                return self.line_type(self.current_line)
            else:
                return None
        elif len(key[0]) == 1:
            pos_t = key
            if self.current_contig != pos_t[0] or\
              self.current_contig == pos_t[0] and self.current_pos > pos_t[1] or\
              (self.current_contig, self.current_pos) == pos_t and\
               self.current_index > 0:
                if not self.index_flag:
                    self.getContigPosD()
                    self.index_flag = True
                if pos_t[0] in self.contig_pos_d:
                    self.fh.seek(self.contig_pos_d[pos_t[0]])
                    self.current_pos = 0
                    self.current_contig = pos_t[0]
                else:
                    return None
            while self.current_contig  == pos_t[0] and self.current_pos < pos_t[1]:
                self.current_line = self.fh.readline()
                if len(self.current_line) == 0:
                    return None
                (self.current_contig, self.current_pos) = \
                    self.line_type(self.current_line).getPos_t()
            l = []
            while (self.current_contig, self.current_pos) == pos_t:
                
                l.append(self.line_type(self.current_line))
                self.current_line = self.fh.readline()
                if len(self.current_line) == 0:
                    return l
                (self.current_contig, self.current_pos) = \
                  self.line_type(next_line).getPos_t()
            if len(l) == 0:
                return None
            else:
                return l
        elif len(key[0]) == 2:
            pass
            # TO DO TO DO TO DO    
                    
    def __getitem__(self, key):
        if self.memory_flag:
            return self.memoryGetItem(key)
        else:
            return self.diskGetItem(key)
    # if user tries random access on a file in disk mode, program creates an index first so it knows where the various contigs are
    def getContigPosD(self):
        self.contig_pos_d = {}
        self.fh.seek(0)
        self.current_file_pos = self.fh.tell()
        next_line = self.fh.readline()
        if self.header_symbol != None:
            while next_line.startswith(self.header_symbol):
                self.current_file_pos = self.fh.tell()
                next_line = self.fh.readline()
        (self.current_contig, self.current_pos) = \
                      self.line_type(next_line).getPos_t()
        self.contig_pos_d[self.current_contig] = self.current_file_pos
        current_contig = self.current_contig
        self.current_file_pos = self.fh.tell()
        next_line = self.fh.readline()
        counter = 1
        while len(next_line) != 0:
            counter += 1
            (self.current_contig, self.current_pos) = \
                      self.line_type(next_line).getPos_t()
            if self.current_contig != current_contig:
                self.contig_pos_d[self.current_contig] = \
                   self.current_file_pos
                current_contig = self.current_contig
            self.current_file_pos = self.fh.tell()
            next_line = self.fh.readline()
        self.length = counter   
        self.fh.seek(0)
        self.current_contig = ""
        self.current_pos = 0
# the GeneLineOb objects know how to parse the lines in the various formats
class GeneLineOb(object):
    pass

       
class BEDLineOb(GeneLineOb):
    def __init__(self, line):
        self.line = line
        self.fields = re.split('\t', line)
    def getStartPos_t(self):
        return (str(self.fields[0]), int(self.fields[1]))
    def getEndPos_t(self):
        return (str(self.fields[0]), int(self.fields[2]))
    def getPos_t(self):
        return self.getStartPos_t()

class BEDFileOb(GeneFileOb):
    def __init__(self, fn = None, line_type = BEDLineOb,\
                 memory_flag = True, header_symbol = None,\
                 index_flag = False, one_record_per_pos_flag = False):
        super(BEDFileOb, self).__init__(fn = fn, line_type = line_type,\
              memory_flag = memory_flag, header_symbol = header_symbol,\
              index_flag = index_flag,\
              one_record_per_pos_flag = one_record_per_pos_flag)
    def __getitem__(self, key):
        return super(BEDFileOb, self).__getitem__(key)

class FAILineOb(GeneLineOb):
    def __init__(self, line):
        self.line = line
        self.fields = re.split('\t', line)
    def getPos_t(self):
        return (str(self.fields[0]), 0)
    def getOffset(self):
        return int(self.fields[2])
    def getContig(self):
        return str(self.fields[0])
    def getLength(self):
        return int(self.fields[1])
    def isNumeric(self):
        return str(self.fields[0]).isdigit()

class FAIFileOb(GeneFileOb):
    def __init__(self, fn = None, line_type = FAILineOb,\
                 memory_flag = True, header_symbol = None,\
                 index_flag = False, one_record_per_pos_flag = False):
        super(FAIFileOb, self).__init__(fn = fn, line_type = line_type,\
              memory_flag = memory_flag, header_symbol = header_symbol,\
              index_flag = index_flag,\
              one_record_per_pos_flag = one_record_per_pos_flag)
    def __getitem__(self, key):
        return super(FAIFileOb, self).__getitem__(key)

if __name__ == "__main__":
	parser = OptionParser()
	(options, args) = parser.parse_args()
	bed_file = args[0]
	fasta_file = args[1]
	output_file = args[2]
	exon_l = getExonL(bed_file)
	gc = getGCPercentL(exon_l, fasta_file)
	writeListToFile(gc, output_file)	
