#!/usr/bin/perl -w
#===============================================================================
#
#        Li Xue (), me.lixue@gmail.com
#        07/19/2016 07:30:56 PM
#
#  DESCRIPTION: Replace the pdb files in the haddock parameter file with the new pdb file
#               User needs specify which pdb file to be replaced.
#
#        USAGE: ./replacePDBfl.pl haddock_parameterFL new_pdb_file pdbFL_number (e.g., 1)
#
#===============================================================================

use strict;
use warnings;
use utf8;
use File::Copy;

my $haddockparamFL = shift @ARGV;
my $pdbFL = shift @ARGV;
my $pdbFL_num = shift @ARGV;


if (!defined $pdbFL_num){
    die("\nUSAGE: ./replacePDBfl.pl haddock_parameterFL new_pdb_file pdbFL_number (e.g., 1)\n\n");
}

#-- read the new pdb file
open( INPUT, "<$pdbFL" ) or die("Cannot open $pdbFL:$!");
my @a = <INPUT>;
map {s/[\n\r]//g} @a;
close INPUT;

if ( !@a ) {
    die("Nothing read from $pdbFL:$!");
}
my $newPDB = join( '\n', @a );



#-- replace the pdb file
copy( $haddockparamFL, "$haddockparamFL.ori" )
  or die("Cannot copy $haddockparamFL to $haddockparamFL.ori:$!");
my $haddockparamFL_tmp = "$haddockparamFL.tmp";
unlink $haddockparamFL_tmp if ( -e $haddockparamFL_tmp );

open( OUTPUT, ">>$haddockparamFL_tmp" )
  or die("Cannot open $haddockparamFL_tmp:$!");

open(INPUT, "<$haddockparamFL")or die ("Cannot open $haddockparamFL:$!");

my $flag =0;
my $num =0;
while(<INPUT>){
    s/[\n\r]//mg;

    if (/^(\s*\"raw_pdb\":\s*[\'\"]{1})(.+)([\'\"]{1},\s*)$/){
    #"raw_pdb": "ATOM      1  N   ... \nATOM     2..."
     $num ++;

     if ($num != $pdbFL_num){
         print OUTPUT "$_\n";
         next;
     }
     $flag =1;


     my $newLine = "$1$newPDB$3";
     print OUTPUT "$newLine\n";
     next;

    }
    print OUTPUT "$_\n";
}
close INPUT;
close OUTPUT;

if ( $flag == 0 ) {
    print "\nWARNING: nothing changed!!!\n";
    unlink $haddockparamFL_tmp;
    unlink "$haddockparamFL.ori";
}
else {

    move( $haddockparamFL_tmp, $haddockparamFL )
      or die("Cannot rename $haddockparamFL_tmp as $haddockparamFL:$!");
    print "The pdb file (# $pdbFL_num) updated in $haddockparamFL.\n";
}

