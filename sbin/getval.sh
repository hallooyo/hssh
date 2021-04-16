configfile=$1
key=$2
sed "/^$key=/"'!d; s/.*=//' $configfile
