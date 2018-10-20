#! /usr/bin/perl

#This program parse multi-line FASTA file into single line fasta file.
#Author: Anurag Raj [anurag.raj@igib.in]

use strict;
use warnings;

# Usage information
die "Usage: $0 <fasta-file> <output-file>\n", if (@ARGV != 2);

#taking user input
my ($infile,$outfile) = @ARGV;

#opening input and output file using file handler
open (IN,"$infile") or die "Cannot open $infile: $!";
open (OUT,">$outfile") or die "Cannot open $outfile: $!";

#defining variables
my ($header, $seq) = '';

#parsing file
while(my $line = <IN>){	
	chomp $line;
	if($line =~ /^>/){
		if($header ne ''){
			print OUT "$header\n$seq\n";
			$seq = '';
		}
		$header = $line;
	}else{
		$seq .= $line;
	}
	if (eof(IN)){
		print OUT "$header\n$seq\n";
	}
}
#closing file handlers
close IN;
close OUT;
