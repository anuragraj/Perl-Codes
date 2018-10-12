#! usr/bin/perl

use strict;
use warnings;

#Author:Anurag Raj()

###########################################
##USAGE##
#perl atc_parser.pl input_filename output_filename
###########################################

#taking inputs of filenames from command
my $infile = $ARGV[0]; #Input file
my $outfile = $ARGV[1];

print "Program intiated. Processing input file: $infile\n";

#opening file
open(IN, $infile) or die ("Error: Cannot open file $infile!!!\n");
open(OUT, ">$outfile") or die ("cannot write to output file $outfile: $!\n");

#skipping header
my $header =  <IN>;
#printing header
print OUT "label\tk\ttier1\ttier2\ttier3\ttier4\n";
#defining variable
my ($tier1,$tier2, $tier3, $tier4);

#processing file
while(my $line = <IN>){
	chomp $line;
    $line =~ s/"//g; #removing double quotes
    my ($data1, $data2) = $line =~ /(.*)\t(\S+)/; #splitting line for label and k
    chomp $data2;

    if($data2 =~ /^nd/){
        my @dataND = split(/-/,$data1,2);   #splitting tier data
        chop $dataND[0];
        $dataND[1] =~ s/^\s//;

        if(length($dataND[0]) eq 1){
            $tier1 = $dataND[1];
        }elsif(length($dataND[0]) eq 3){
            $tier2 = $dataND[1];
        }elsif(length($dataND[0]) eq 4){
            $tier3 = $dataND[1];
        }elsif(length($dataND[0]) eq 5){
            $tier4 = $dataND[1];
        }
    }else{
        print OUT "$data1\t$data2\t$tier1\t$tier2\t$tier3\t$tier4\n";
    }
}
#closing file handler
close IN;
close OUT;

print "Job completed. Check output in File: $outfile\n";

exit;