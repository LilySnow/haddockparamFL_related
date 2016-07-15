#!/usr/bin/perl -w
#===============================================================================
#
#        Li Xue (), me.lixue@gmail.com
#        07/14/2016 09:54:00 PM
#
#  DESCRIPTION: Extract pdb files from a haddock parameter file
#
#        USAGE: ./extractPDBfl_fromHaddockparam.pl haddock_parameter_file
#
#===============================================================================

use strict;
use warnings;
use utf8;

my $haddockparamFL=shift @ARGV;

if ( -z $haddockparamFL ){
    print "\n\nUsage: extractPDBfl_fromHaddockparam.pl haddockparameter_file\n\n";
    exit;
}

#-- start
my $randnum = rand(100);
my $tmpFL = "/tmp/$haddockparamFL.$randnum.tmp";
system("egrep 'pdbdata' $haddockparamFL > $tmpFL") == 0 or die ("Failed:$!");

open(INPUT, "<$haddockparamFL")or die ("Cannot open $haddockparamFL:$!");

my $num =0;
while(<INPUT>){
    s/[\n\r]//mg;

    if (/pdbdata\s*=\s*[\'\"]{1}(.+)[\'\"]{1},/){
    # pdbdata = "ATOM      1  CB .... \n",
     $num ++;

     my @content = split(/\\n/,$1);

     #-- write to file
     my $pdbFL = "pdbFL$num.pdb";
     unlink $pdbFL if (-e $pdbFL);

     open(OUTPUT, ">>$pdbFL") or die ("Cannot open $pdbFL:$!");
     my $content_tmp = join("\n", @content);
     $content_tmp =~s/\\//g; # H4\'  => H4'

     print OUTPUT $content_tmp ;
     close OUTPUT;

     print "$pdbFL generated\n";

    }
}
close INPUT;

