
DIR_BIN=`dirname $(readlink -f $0)`
cd $DIR_BIN

sh ./add_plant.sh 1 /dev/ttyACM0 50 1