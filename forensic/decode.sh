#!/bin/bash
# Script created by Alex_Cat ᓚᘏᗢ
 
if [ $# -eq 0 ]; then
	echo "Use: ./decode.sh <decoded_file>" 
	exit 1
fi

function check_command {
	if [ -z $(which $1) ]; then
		printf "Install $1"
		sudo apt install $1
	fi
}

function decode_file {
	if   [ $(echo "$(file $1)" | grep -c uuencoded)   -eq 1 ]; then 
		check_command "uuencode"
		uudecode -o "$FILENAME.out" "$FILENAME"
		mv "$FILENAME.out" "$FILENAME"
		TYPE="uuencoded" 
	elif [ $(echo "$(file $1)" | grep -c gzip )  -eq 1 ]; then 
		check_command "gzip"
		mv "$FILENAME" "$FILENAME.gz"
		gzip -d "$FILENAME.gz"
		rm "$FILENAME.gz"
		TYPE="qzip"
	elif [ $(echo "$(file $1)" | grep -c bzip2 ) -eq 1 ]; then
		check_command "bzip2"
		mv "$FILENAME" "$FILENAME.bz"
		bzip2 -d "$FILENAME.bz"
		rm "$FILENAME.bz"
		TYPE="bzip2"
	elif [ $(echo "$(file --mime-type $1)" | grep -c ar )    -eq 1 ]; then
		check_command "ar"
		mv "$FILENAME" "$FILENAME.deb"
		ar x "$FILENAME.deb"
		rm "$FILENAME.deb"
		TYPE="ar"
	elif [ $(echo "$(file $1)" | grep -c lzip )  -eq 1 ]; then
		check_command "lzip"
		mv "$FILENAME" "$FILENAME.lz"
		lzip -d "$FILENAME.lz"
		rm "$FILENAME.lz"
		TYPE="lzip"
	elif [ $(echo "$(file $1)" | grep -c cpio )  -eq 1 ]; then
		check_command "cpio"
		mv "$FILENAME" "$FILENAME.out"
		cpio -i -F "$FILENAME.out"
		rm "$FILENAME.out"
		TYPE="cpio"
	elif [ $(echo "$(file $1)" | grep -c LZ4 )  -eq 1 ]; then
		check_command "lz4"
		mv "$FILENAME" "$FILENAME.lz4"
		lz4 -d "$FILENAME.lz4"
		rm "$FILENAME.lz4"
		TYPE="lz4"
	elif [ $(echo "$(file $1)" | grep -c LZMA )  -eq 1 ]; then
		check_command "lzma"
		mv "$FILENAME" "$FILENAME.lzma"
		lzma -d "$FILENAME.lzma"
		rm "$FILENAME.lzma" 
		TYPE="lzma"
	elif [ $(echo "$(file $1)" | grep -c lzop )  -eq 1 ]; then 
		check_command "lzop"
		mv "$FILENAME" "$FILENAME.lzop"
		lzop -d "$FILENAME.lzop"
		rm "$FILENAME.lzop"
		TYPE="lzop"
	elif [ $(echo "$(file $1)" | grep -c XZ )  -eq 1 ]; then
		check_command "xz"
		mv "$FILENAME" "$FILENAME.xz"
		xz -d "$FILENAME.xz"
		rm "$FILENAME.xz"
		TYPE="xz"
	elif [ $(echo "$(file $1)" | grep -c text)   -eq 1 ]; then 
		TYPE="text"
	else
		TYPE="error"
	fi
}

FILENAME=$(basename $1)
TYPE="begin_value" 

while [ $TYPE != "text" ] && [ $TYPE != "error" ]; do
	decode_file $FILENAME
	echo "$FILENAME - $TYPE"
done 

exit 0
