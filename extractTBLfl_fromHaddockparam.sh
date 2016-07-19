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
num=`egrep 'tbl' $haddockparamFL |wc -l `

echo "There are $num tbl files in the haddock parameter file"

egrep '^\s+unambigtbldata' $haddockparamFL > tmp
if [[ $? == 0 ]]; then
    egrep 'unambigtbldata' $haddockparamFL  |perl -ple 's/^\s+unambigtbldata\s+=\s*//g; s/\\n/\n/g; s/"//g ' |perl -ple "s/[,']//g" > unambig.tbl
    echo "unambig.tbl generated"
fi


egrep '^\s+ambigtbldata' $haddockparamFL > tmp
if [[ $? == 0 ]]; then
   egrep '^\s+ambigtbldata' $haddockparamFL|  perl -ple 's/^\s+ambigtbldata\s+=\s*//g; s/\\n/\n/g; s/"//g ' |perl -ple "s/[',]//g" > ambig.tbl
   echo "ambig.tbl generated"
fi

egrep '^\s+tbldata' $haddockparamFL > tmp
if [[ $? == 0 ]]; then
   egrep '^\s+tbldata' $haddockparamFL|  perl -ple 's/^\s+tbldata\s+=\s*//g; s/\\n/\n/g; s/"//g ' |perl -ple "s/[',]//g" > other.tbl
   echo "other.tbl (the tbldata field in the parameter file) generated"
fi



unlink tmp
