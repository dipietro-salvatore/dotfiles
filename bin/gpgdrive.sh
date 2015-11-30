#!/bin/bash

MOUNT="/media/ram"
TMP="$MOUNT/gpg"

GPGFILEPATH=$1
GPGFILENAME="$(basename $GPGFILEPATH)"
TMPTARFOLDER="$TMP/$(echo $GPGFILENAME | cut -d '.' -f1-2)"
TMPFOLDER="$(echo $GPGFILENAME | cut -d '.' -f1)"
PASSWD=""





gpgmount()
{
	#create folder in ram
	if [ ! -d "$TMP"  ]; then
		echo "Create $TMP"
		mkdir -p $TMP
	else
		echo "Folder $TMP alredy monted"
	fi
	
	mount | grep $TMP > /dev/null
	if [ $? -eq 1 ]; then
		echo "Mount space in RAM"
		mount -t tmpfs tmpfs $TMP && mount | grep $TMP
	else
		echo "Space in RAM alredy mounted"
	fi
	
	mount | grep $TMP > /dev/null
	if [ $? -eq 1 ]; then
		echo "Difficulties to mount a space in RAM. Program TERMINATE."
		exit 1
	fi
	
	#open gpg file
	echo "Open GPG file"
	
	echo "Provide the password to decrypt the file"
	read -s PASSWD
	#echo "gpg -d -o $TMPTARFOLDER $GPGFILENAME"
	gpg -d --passphrase $PASSWD -o $TMPTARFOLDER $GPGFILEPATH
	if [ ! -f $TMPTARFOLDER ]; then
	        echo "Difficulties to decrypt the file. Are you sure that the password is correct? Program TERMINATE."
	        exit 1
	fi
	
	
	
	#untar the file
	echo "tar -C $TMP -xf $TMPTARFOLDER $TMPFOLDER "
	tar -C $TMP -xf $TMPTARFOLDER $TMPFOLDER 

  #give permissions to the user
  chown -R $USER:$USER $TMPTARFOLDER $TMPFOLDER
}

gpgsave()
{
	echo "Create new .tar file"
	#recreate tar file
	#echo "tar -C $TMP -cf $TMPTARFOLDER $TMPFOLDER "
	tar -C $TMP -cf $TMPTARFOLDER $TMPFOLDER 
	
	echo "Encrypt the file"
	#re-encrypt file
	gpg -c --passphrase $PASSWD -o $GPGFILEPATH $TMPTARFOLDER

}


gpgcreate()
{
	echo "Creation new GPG drive"
	#set folders
	TMP="$(dirname $GPGFILEPATH)"
	TMPTARFOLDER="$(echo $GPGFILENAME | cut -d '.' -f1-2)"
	TMPFOLDER="$(echo $GPGFILENAME | cut -d '.' -f1)"
	mkdir $TMP/$TMPFOLDER

	#ask password
        echo "Provide the password to encrypt/decrypt the file"
        read -s PASSWD
	
	gpgsave
	
	#remove the folder
	rmdir $TMP/$TMPFOLDER
}


terminate() 
{
	echo "Terminate the program"
	
	#remove folder (FEATURE remove secure srm??)
	rm -rf $TMPFOLDER 
	rm -rf $TMPTARFOLDER

	#umount $TMP
	umount $TMP
}



if [  "$#" -lt 1 ]; then
	echo "No file to use. Run $0 pgpfilename.tar.gpg [create]"
	exit 1
fi



#CREATE option
if [  "$#" -eq 2 ]; then
	if [ "$2" == "create" ]; then
		gpgcreate
		exit 0
	else
	        echo "No file to use. Run $0 pgpfilename.tar.gpg [create]"
	        exit 1
	fi
fi

#check to be root
if [[ $(id -u) != 0 ]]; then
  echo "Error: Sadly you need to run me as root. Please run me sudo $0 pgpfilename.tar.gpg"
  exit 1
fi



#######START########


gpgmount


#open nautilus
echo "Do you want to open this in nautilus [Y/n]"
#read -p RESPONSE
if [ "$(read)" != "n"  ]; then
	#echo "Nautilus is opening. When you finish to edit the content, press CTRL+C to continue the execution."
	gnome-open $TMP/$TMPFOLDER > /dev/null
fi

#wait a return
#read 

echo "Press Y if you have finished to use this file and  want to save it in a new file GPG file. [Y/n]."
#read -p RESPONSE
if [ "$(read )" == "n"  ]; then
        terminate
	exit 0
else
	gpgsave
	terminate
	exit 0
fi

exit 0
