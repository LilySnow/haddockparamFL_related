# Li Xue (L.Xue@uu.nl)
# Sep. 16th, 2015
#
# extract tbl files from a haddockparam.web

haddockparamFL=$1


#--check input

if [ -z $haddockparamFL ];then
    printf "\nUsage: extractTBLfl_fromHaddockparam.sh haddock_parameter_file\n\n"
    exit 1
fi


#--start
num=`egrep 'tblfile' $haddockparamFL |wc -l `

echo "There are $num tbl files in the haddock parameter file"

egrep '^\s+\"unambigtblfile' $haddockparamFL > tmp
if [[ $? == 0 ]]; then
    egrep 'unambigtblfile' $haddockparamFL  |perl -ple 's/^\s+\"unambigtblfile\"\s*:\s*//g; s/\\n/\n/g; s/"//g ' |perl -ple "s/[,']//g" > unambig.tbl
    echo "unambig.tbl generated"
fi


egrep '^\s+\"tblfile\"' $haddockparamFL > tmp
if [[ $? == 0 ]]; then
   egrep '^\s+\"tblfile' $haddockparamFL|  perl -ple 's/^\s+\"tblfile\":\s*//g; s/\\n/\n/g; s/"//g ' |perl -ple "s/[',]//g" > ambig.tbl
   echo "ambig.tbl generated"
fi

unlink tmp
