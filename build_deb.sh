# user inputs
AppName=mycalc
AppExeName=MyCalc
IconFile="icon.svg"
Version=0.0.1
Description="this is description"
AppPublisher="muenai Co.,Ltd."
AppPublisherEmail="service@muenai.com"
AppUrl="https://www.muenai.com"

# derived parameters
SOURCE=dist/$AppName
ARCH=$(dpkg --print-architecture)
WORKDIR=dist_wizard
# tmp directory
ROOTDIR=$WORKDIR/$AppName
DEBIAN=$ROOTDIR/DEBIAN
ICON_FNAME=$(echo $IconFile | rev | cut -d "/" -f 1 | rev)

BIN=/usr/bin/$AppExeName
LIB=/usr/lib/$AppName
ICON=/usr/share/icons/hicolor/scalable/apps/$AppExeName-$ICON_FNAME
DESKTOP=/usr/share/applications/$AppExeName.desktop

SRC_ICON=$ROOTDIR$ICON
SRC_BIN=$ROOTDIR$BIN
SRC_LIB=$ROOTDIR$LIB
SRC_DESKTOP=$ROOTDIR$DESKTOP

# create folders
mkdir -p $ROOTDIR
mkdir -p $ROOTDIR/usr/bin
mkdir -p $ROOTDIR/usr/lib
mkdir -p $ROOTDIR/usr/share/applications
mkdir -p $ROOTDIR/usr/share/icons/hicolor/scalable/apps
mkdir -p $DEBIAN

# write desktop file
echo "[Desktop Entry]
Version=$Version
Name=$AppName
Comment=$Description
Exec=$BIN
Path=$LIB
Icon=$ICON
Terminal=true
Type=Application
" > $SRC_DESKTOP

# copy source files
if [[ -d "$SRC_LIB" ]]; then
    rm -rf $SRC_LIB
fi
cp -r $SOURCE $SRC_LIB

# create relative soft link to /usr/bin/
if [[ -f "$SRC_BIN" ]]; then
    rm -f $SRC_BIN
fi
ln -r -s $SRC_LIB/$AppExeName $SRC_BIN

# copy icon file
cp -f $IconFile $SRC_ICON

# write control file
echo "Source: $AppName
Package: $AppName
Version: $Version
Maintainer: $AppPublisher, <$AppPublisherEmail>
Homepage: $AppUrl
Architecture: $ARCH
Description: $Description
" > $DEBIAN/control

# build
dpkg -b $ROOTDIR $WORKDIR

# remove tmp directory
rm -rf $ROOTDIR
