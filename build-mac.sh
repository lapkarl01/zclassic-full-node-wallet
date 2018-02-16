#!/bin/bash

############################################
#    Created by @Pega88 && @Jon_S_Layton   #
#         v1.0.0 16 Feb 2018		   	   #
############################################

#fetch + install jar2app
if [ -e /usr/local/bin/jar2app ]
then
    echo "jar2app already installed - OK"
else
	git clone https://github.com/Jorl17/jar2app
	cd jar2app
	chmod +x install.sh uninstall.sh
	sudo ./install.sh /usr/local/bin
  cd ..
  rm -rf jar2app
fi

#fetch + install dylibbundler 
if [ -e /usr/local/bin/dylibbundler ]
then
    echo "dylibbundler already installed - OK"
else
	git clone https://github.com/auriamg/macdylibbundler
	cd macdylibbundler 
	sudo make install
  cd ..
  rm -rf macdylibbundler 
fi


#build the jar from source
ant jar -f src/build/build.xml

#package jar to app
jar2app build/jars/ZclassicSwingWallet.jar  -i ./src/resources/images/zclassic-logo.icns


#add zcld and zcl-cli into the required Contents folder of the App
cp ./zcld ./ZclassicSwingWallet.app/Contents/zcld
cp ./zcl-cli ./ZclassicSwingWallet.app/Contents/zcl-cli


chmod +x ./ZclassicSwingWallet.app/Contents/zcld
chmod +x ./ZclassicSwingWallet.app/Contents/zcl-cli


#statically build required libraries
dylibbundler -od -b -x ./ZclassicSwingWallet.app/Contents/zcld \
                    -x ./ZclassicSwingWallet.app/Contents/zcl-cli \
                    -d ./ZclassicSwingWallet.app/Contents/libs \
                    -p @executable_path/libs