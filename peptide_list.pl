#! /usr/bin/perl

##peptide_list: The program find the all peptides of Protein id and list their project ids.
##Author: Anurag Raj
##Date:08-Nov-2018

use strict;
use warnings;

# Usage information
die "Usage: $0 <result-dir> <protein-id> <output-file>\n", if (@ARGV != 3);

#taking user input
my ($indir,$proteinID,$outfile) = @ARGV;

print "The peptide listing program for Protein $proteinID started...\n";

#array to store project IDs
my @ids;
#hash to store peptides 
my %peptides;
#hash to store pxd id list
my %pxd;

#opening input and output file using file handler
open (OUT,">$outfile") or die "Cannot open $outfile: $!";
opendir(DIRC, $indir) or die ("cannot open dir $indir");

#read all files
my @files=(readdir(DIRC));
#fetch files containing protein id wise result
my @infiles = grep(/result_proteins_customdb(.*).tsv/, @files);

print "\nFollowing files will be searched:\n";
foreach my $name(@infiles){
	print "$name\n";
}


#looping all the selected files
foreach my $filename (@infiles){
	my $file = "$indir/$filename";
	my @filenameID = split(/_/,$filename);
	$filenameID[3] =~ s/\.tsv//;
	#hash for adding unique project id in hash peptides
	$pxd{$filenameID[3]}=undef;

	#reading files one by one
	open (IN, '<', $file) or die "Can't open $file : $!\n";
	my $header = <IN>;
	while(my $line = <IN>){
		chomp $line;
		#finding the protein id
		my @data = split(/\t/,$line);
		if ($data[0] =~ /$proteinID/){
			my @unique_peptides = split(/;/,$data[1]) if $data[1] ne '';
			my @shared_peptides = split(/;/,$data[4]) if $data[4] ne '';
			my @merged_peptides = (@unique_peptides, @shared_peptides);
			foreach (@merged_peptides){
				$peptides{$_}{$filenameID[3]}=undef;
			}
		}
	}
	close IN;
}

#getting all pxd id in array
my @pxdid = keys %pxd;
#printing header of output file
print OUT "peptides\t",join("\t",@pxdid),"\n";
#printing the output to file
foreach my $pep (keys %peptides) {
	my $value = "";
	foreach my $id (@pxdid){
		if(exists $peptides{$pep}{$id}){
			$value .= "1\t";
		}else{
			$value .= "0\t";
		}
	}
	print OUT "$pep\t$value\n"; 
}

print "\n\n Job completed. Check result in $outfile.\n";

#closing file handlers
close OUT;
close DIRC;

exit;