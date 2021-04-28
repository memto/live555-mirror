#!/bin/sh

# lib_dirs="BasicUsageEnvironment"
lib_dirs="liveMedia BasicUsageEnvironment UsageEnvironment groupsock"
app_dirs="mediaServer proxyServer"
# app_dirs="testProgs mediaServer proxyServer hlsProxy"


inc_path=""
inc_pri=""
for lib_dir in $lib_dirs
do
	lib_pri="$lib_dir.pri"

	inc_path="${inc_path}\$\$PWD/live/$lib_dir/include \\\\\n"
	inc_pri="${inc_pri}include(\$\$PWD/live/$lib_dir/$lib_pri) \\n"

	save_dir=`pwd`
	cd $lib_dir

	echo "SOURCES += \\" > $lib_pri
	src_str=""
	for src_file in *.c*; do
		src_str="${src_str}\$\$PWD/$src_file \\\\\n"
	done
	src_str=${src_str%"\\\\\n"}
	echo $src_str >> $lib_pri
	
	echo "" >> $lib_pri

	echo "HEADERS += \\" >> $lib_pri
	hd_file=""
	for src_file in include/*.h*; do
		hd_file="${hd_file}\$\$PWD/$src_file \\\\\n"
	done
	hd_file=${hd_file%"\\\\\n"}
	echo $hd_file >> $lib_pri
	
	cd $save_dir
done

live555_pri="../live555.pri"

echo "QMAKE_CXXFLAGS += -O2 -DSOCKLEN_T=socklen_t -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64 -Wall -DBSD=1" > $live555_pri
echo "QMAKE_CFLAGS += -O2 -DSOCKLEN_T=socklen_t -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64 -Wall -DBSD=1" >> $live555_pri

echo "" >> $live555_pri
echo "LIBS += -lssl -lcrypto" >> $live555_pri

echo "" >> $live555_pri
inc_path=${inc_path%"\\\\\n"}
echo "INCLUDEPATH += $inc_path" >> $live555_pri

echo "" >> $live555_pri
echo $inc_pri >> $live555_pri

