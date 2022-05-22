#! /usr/bin/perl

#This program extract sequences using the IDs from fasta file.
#Author: Anurag Raj [anurag.raj@igib.in]
#date: Sep 1 2019

# Perl modules necessaries for the correct working of the script
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my $SCRIPT_NAME = fileparse($0);
my $DESCRIPTION = "Extract sequences using the IDs from fasta file.";
my $AUTHOR = "Anurag Raj [anurag.raj\@igib.in]";

# Usage information
#die "Usage: $0 <fasta-file> <output-file>\n", if (@ARGV != 2);


#defining variables
my ($infile,$outfile, $listfile);

GetOptions(
	'h|help|?' =>  \&usage,
	'f|fasta=s' => \$infile,
	'l|list=s' => \$listfile,
	'o|output=s' => \$outfile,
	'<>' => \&usage,
);


# Usage help
sub usage {
	print "------------------------------------------------------\n";
	print "$SCRIPT_NAME\n";
	print "------------------------------------------------------\n";
	print "\nScript by $AUTHOR\n";
	print "Description: $DESCRIPTION\n";
	print "Usage: ";
	print "$SCRIPT_NAME -f <fasta-file> -l <list-file> -o <output-file>\n";
	print "\nOptions:\n";
	print "  -f <fasta-file>\tfile with fasta sequences.\n";
	print "  -l <list-file>\tfile with sequence IDs.\n";
	print "  -o <file>\t\tOutput file name.\n";
	print "  -h\t\t\tHelp.\n";
	print "\n";
	exit;
}

# Prints usage help if no input file is specified
if (!defined($infile)){
	print "\nERROR: You must specify FASTA input files.\n\n";
	usage();
	exit;
}


# Prints usage help if no list file is specified
if (!defined($listfile)){
	print "\nERROR: You must specify list file with sequence IDs.\n\n";
	usage();
	exit;
}


# Prints usage help if no output file is specified
if (!defined($outfile)){
	print "\nERROR: You must specify FASTA output files.\n\n";
	usage();
	exit;
}

#HASH to store list IDs
my %IDhash;

#to count total list IDs
my $x = 0;


open(IN1, $listfile) or die ("Cannot open file: $listfile!!!\n");
while(my $id = <IN1>){
    chomp $id;
    $id =~ s/\s+$//;
    $id =~ s/>//;
    $IDhash{$id} = ();
    $x++;
}
close IN;


#opening input and output file using file handler
open (IN,"$infile") or die "Cannot open file: $infile: $!";
open (OUT,">$outfile") or die "Cannot open file: $outfile: $!";

#defining variables
my ($header, $seq) = '';

#for counting fetched ID
my $n = 0 ;

#parsing file
while(my $line = <IN>){	
	chomp $line;
	if($line =~ /^>/){
		if($header ne ''){
			my $hID = $header;
			$hID =~ s/\s+$//;
    		$hID =~ s/>//;
			if (exists $IDhash{$hID}){
				print OUT "$header\n$seq\n";
				$n++;
			}
			$seq = '';
		}
		$header = $line;
	}else{
		$seq .= $line;
	}
	if (eof(IN)){
		my $hID = $header;
		$hID =~ s/\s+$//;
    	$hID =~ s/>//;
		if (exists $IDhash{$hID}){
				print OUT "$header\n$seq\n";
				$n++;
			}
	}
}
#closing file handlers
close IN;
close OUT;

print "Job Completed.\nTotal $n sequences out of $x are fetched.\n";

exit;