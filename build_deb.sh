SOURCE=./dist/MyCalc/
AppName=mycalc
AppExeName=MyCalc
AppDistribution=stable
IconFile="icon.svg"
Version=0.0.1
Description="this is description"
AppPublisher="muenai Co.,Ltd."
AppPublisherEmail="service@muenai.com"
AppUrl="https://www.muenai.com"

ARCH=$(dpkg --print-architecture)
WORKDIR=./dist_wizard
mkdir -p $WORKDIR
ROOTDIR=$WORKDIR/$AppName
DEBIAN=$ROOTDIR/DEBIAN
BIN=$ROOTDIR/usr/bin/$AppExeName
LIB=$ROOTDIR/usr/lib/$AppName
DESKTOP=$ROOTDIR/usr/share/applications/$AppExeName.desktop

mkdir -p $ROOTDIR
mkdir -p $ROOTDIR/usr/bin
mkdir -p $ROOTDIR/usr/lib
mkdir -p $ROOTDIR/usr/share/applications
mkdir -p $DEBIAN


echo "[Desktop Entry]
Version=$Version
Name=$AppName
Comment=$Description
Exec=$BIN -ui
Path=$LIB
Icon=$IconFile
Terminal=true
Type=Application
" > $DESKTOP
#Categories=Utility;Development;

# copy source files
if [[ -d "$LIB" ]]; then
    rm -rf $LIB
fi

cp -r $SOURCE/ $LIB
if [[ -f "$BIN" ]]; then
    rm -f $BIN
fi
ln -r -s $LIB/$AppExeName $BIN

# write control file
echo "Source: $AppName
Package: $AppName
Version: $Version
Maintainer: $AppPublisher, <$AppPublisherEmail>
Homepage: $AppUrl
Architecture: $ARCH
Description: $Description
" > $DEBIAN/control

dpkg -b $ROOTDIR $WORKDIR
#rm -rf $ROOTDIR
