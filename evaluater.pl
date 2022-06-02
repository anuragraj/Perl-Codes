#! usr/bin/perl

use strict;
use warnings;

#This code is written to evaluate sheet with provided answer from participant of quiz.
#This is for genomic variation test quiz and provide marks as decided.
#Author: Anurag Raj
#Date: 31st Jan 2021

#taking inputs of filenames from command
my $infile1 = $ARGV[0];	#input_answer
my $infile2 = $ARGV[1]; #input_response
my $outfile = $ARGV[2]; #marking results

#reading input file to perform test
open (IN, $infile1) or die "Can't open $infile1\n";
open (OUT, ">$outfile") or die "Can't write $outfile\n";

#hash for correct response
my %answer;
my $answer_header = <IN>;

#codes list for responses
my %codes;
@codes{qw(A1 B1 C1 D1 E1 F1 G1 H1 I1 J1 K1 L1 M1 N1 O1 P1 Q1 R1 S1 T1 U1 V1 W1 X1 Y1 Z1 A2 B2 C2 D2 E2 F2 G2 H2 I2 J2 K2 L2 M2 N2 O2 P2 Q2 R2 S2 T2 U2 V2 W2 X2 Y2 Z2 A3 B3 C3 D3 E3 F3 G3 H3 I3 J3 K3 L3 M3 N3 O3 P3 Q3 R3 S3 T3 U3 V3 W3 X3 Y3 Z3 A4 B4 C4)} = ();


#reading correct answers
while(my $line = <IN>){
    chomp $line;
    my @data = split(",", $line);
    $answer{uc($data[0])}{lc($data[1])} = $data[2];

}
close IN;

use Data::Dumper;
#print Dumper \%answer;
#exit;

#checking participants response
open (IN, $infile2) or die "Can't open $infile2\n";
my $response_header = <IN>;

#line counting
my $l = 2;

while(my $line = <IN>){
    chomp $line;
    my @data = split("\t", $line);
    my $len_res = 22; #scalar(@data);

    my $email = $data[0];
    my $name = $data[1];
    my $code = uc($data[2]);

    #check code given by particiapnt
    if(exists $codes{$code}){
        
        my $final_score = "";
        my $variant_flag = 0;

        #checking each response of one participant
        for(my $i=3; $i <= $len_res; $i=$i+2){
            
            my $variant = lc($data[$i]);
            $variant =~ s/ //g;
            my $response = $data[$i+1];
            if(exists $answer{$code}{$variant}){
                #matched
                if($response ne ""){
                    #scoring 
                    my $correct_response = $answer{$code}{$variant};
                    my $score = scorer($response, $correct_response);
                    $final_score = join(",", $final_score, $score);
                }else{
                    my $score = 0;
                    $final_score = join(",", $final_score, $score);
                }
                
            }else{
                print "Variant not matched for code $code in line $l Col(",$i+1,")!! : $variant\n";
                $variant_flag = 1;
                #exit;
            }
        }

        if($variant_flag == 0){
            print OUT "$email,$name,$code$final_score\n";
        }
        

    }else{
        #code not matched
        print "Code '$code' not matched in line $l!!\n";
        #exit;
    }
    
    

    $l++;
}
close IN;
close OUT;

#------------------------#
# subroutine for scoring #
#------------------------#
sub scorer{
    my $response = uc(shift);
    my $correct_response = uc(shift);

    my @data_cr = split(";", $correct_response);
    my $count_cr = scalar(@data_cr);

    #flag for matching
    my $absent = 0;
    my $present = 0;

    foreach my $att (@data_cr){
        if(index($response, $att) != -1){
            #attr found
            $present = 1;
        }else{
            #attr absent
            $absent = 1;
        }
    }

    my $marks = 0;

    if($present == 1 and $absent == 0){
        #full marks
        $marks = 5;
    }elsif($present == 1 and $absent == 1){
        #half marks
        $marks = 2.5;
    }elsif($present == 0 and $absent == 1){
        #zero marks
        $marks = 0;
    }else{
        print "Unknown error in scoring. Check score function!\n";
        exit;
    }

    return $marks;

}

exit;