#! /usr/bin/perl
#This program translate sequences in three frame seqeunces.
#Author: Anurag Raj [anurag.raj@igib.in]
#date: April 11 2021

# Perl modules necessaries for the correct working of the script
use strict;
use warnings;

use Bio::SeqIO;
use Bio::Seq;
use Bio::Tools::CodonTable;

my $SCRIPT_NAME = fileparse($0);
my $DESCRIPTION = "Translate sequences in three frame seqeunces from fasta file.";
my $AUTHOR = "Anurag Raj [anurag.raj\@igib.in]";

# Usage information
die "Usage: $0 <fasta-file>\n", if (@ARGV != 1);

#subroutines to genrate ORFs and print to file
sub peptides{
    my ($string,$header) = @_;
    my @data = split(/\*/,$string);
    my $i = 1;
    foreach my $seq(@data){
        if(length($seq)>=50){
            print ">$header.$i\n$seq\n";
            $i++;
        }
    }
}

#taking FASTA input file
my $infile = $ARGV[0];

#creating object to read sequences
my $seqio = Bio::SeqIO -> new(-file => "$infile", -format => 'Fasta');

#processing each sequences one by one
while(my $seq = $seqio -> next_seq){
	my $header = $seq -> id;
	
	my $prot_obj1 = $seq-> translate(-frame => 0, -terminator => '');
	my $prot_seq1 = $prot_obj1 -> seq;
	peptides($prot_seq1,"$header.1");
	
	my $prot_obj2 = $seq-> translate(-frame => 1, -terminator => '');
	my $prot_seq2 = $prot_obj2 -> seq;
	peptides($prot_seq2,"$header.2");
	
	my $prot_obj3 = $seq-> translate(-frame => 2, -terminator => '');
	my $prot_seq3 = $prot_obj3 -> seq;
	peptides($prot_seq3,"$header.3");
	
}

print "Translation Job completed.\n";

exit;
