#!/bin/bash
# Script created by Alex_Cat ᓚᘏᗢ
 
if [ -z $1 ]; then
	echo "Use: ./decode.sh <decoded_file>" 
	exit 1
fi

function get_type {
	if   [ $(echo "$(file $1)" | grep -c uuencoded)   -eq 1 ]; then 
		echo "uuencoded" 
	elif [ $(echo "$(file --mime-type $1)" | grep -c gzip )  -eq 1 ]; then 
		echo "qzip"
	elif [ $(echo "$(file --mime-type $1)" | grep -c bzip2 ) -eq 1 ]; then 
		echo "bzip2"
	elif [ $(echo "$(file --mime-type $1)" | grep -c ar )    -eq 1 ]; then 
		echo "ar"
	elif [ $(echo "$(file --mime-type $1)" | grep -c lzip )  -eq 1 ]; then 
		echo "lzip"
	elif [ $(echo "$(file --mime-type $1)" | grep -c cpio )  -eq 1 ]; then 
		echo "cpio"
	elif [ $(echo "$(file --mime-type $1)" | grep -c lz4 )  -eq 1 ]; then 
		echo "lz4"
	elif [ $(echo "$(file $1)" | grep -c LZMA )  -eq 1 ]; then 
		echo "lzma"
	elif [ $(echo "$(file $1)" | grep -c lzop )  -eq 1 ]; then 
		echo "lzop"
	elif [ $(echo "$(file $1)" | grep -c XZ )  -eq 1 ]; then 
		echo "xz"
	elif [ $(echo "$(file $1)" | grep -c text)   -eq 1 ]; then 
		echo "text" 
	else
		echo "error"
	fi
}

FILENAME=$(basename $1)
TYPE=$(get_type $1) 

while [ $TYPE != "text" ] && [ $TYPE != "error" ]; do
	case $TYPE in
		"text")
			echo "$FILENAME is text"
			exit 0
		;;
		
		"qzip")
			echo "$FILENAME is gzip"
			mv "$FILENAME" "$FILENAME.gz"
			gzip -d "$FILENAME.gz"
			rm "$FILENAME.gz"
		;;
		
		"bzip2")
			echo "$FILENAME is bzip2"
			mv "$FILENAME" "$FILENAME.bz"
			bzip2 -d "$FILENAME.bz"
			rm "$FILENAME.bz"
		;;
		
		"ar")
			echo "$FILENAME is ar"
			mv "$FILENAME" "$FILENAME.deb"
			ar x "$FILENAME.deb"
			rm "$FILENAME.deb"
		;;
		
		"lzip")
			echo "$FILENAME is lzip"
			mv "$FILENAME" "$FILENAME.lz"
			lzip -d "$FILENAME.lz"
			rm "$FILENAME.lz"
		;;
		
		"cpio")
			echo "$FILENAME is cpio"
			mv "$FILENAME" "$FILENAME.out"
			cpio -i -F "$FILENAME.out"
			rm "$FILENAME.out"
		;;
		
		"lz4")
			echo "$FILENAME is lz4"
			mv "$FILENAME" "$FILENAME.lz4"
			lz4 -d "$FILENAME.lz4"
			rm "$FILENAME.lz4"
		;;
		
		"lzma")
			echo "$FILENAME is lzma"
			mv "$FILENAME" "$FILENAME.lzma"
			lzma -d "$FILENAME.lzma"
			rm "$FILENAME.lzma"
		;;
		
		"lzop")
			echo "$FILENAME is lzop"
			mv "$FILENAME" "$FILENAME.lzop"
			lzop -d "$FILENAME.lzop"
			rm "$FILENAME.lzop"
		;;
		
		"xz")
			echo "$FILENAME is xz"
			mv "$FILENAME" "$FILENAME.xz"
			xz -d "$FILENAME.xz"
			rm "$FILENAME.xz"
		;;
		
		"uuencoded")
			echo "$FILENAME is uuencoded text"
			uudecode -o "$FILENAME.out" "$FILENAME"
			mv "$FILENAME.out" "$FILENAME"
			rm "$FILENAME.out"
		;;
		
		"error")
			echo "$FILENAME is error"
			exit 2
		;;
	esac
	
	FILENAME=${FILENAME}
	TYPE=$(get_type $FILENAME)
	echo "$FILENAME - $TYPE"
done 

exit 0
