# user inputs
AppName=$AppName
#AppExeName=$AppExeName # executable name. The file path should be dist/AppName/AppExeName
IconFile=$IconFile # path to icon file
Version=$Version # version i.e. 0.2.1
Description=$Description # app description
AppPublisher=$AppPublisher # maintainer or company
AppPublisherEmail=$AppPublisherEmail # email of maintainer or company
AppUrl=$AppUrl # Homepage url

echo Build parameters:
echo "    AppName=$AppName"
#echo "    AppExeName=$AppExeName"
echo "    IconFile=$IconFile"
echo "    Version=$Version"
echo "    Description=$Description"
echo "    AppPublisher=$AppPublisher"
echo "    AppPublisherEmail=$AppPublisherEmail"
echo "    AppUrl=$AppUrl"

# derived parameters
AppExeName=$AppName
SOURCE=dist/$AppName
ARCH=$(dpkg --print-architecture)
WORKDIR=dist_wizard

# tmp directory
ROOTDIR=$WORKDIR/$AppName
DEBIAN=$ROOTDIR/DEBIAN

BIN=/usr/bin/$AppExeName
LIB=/usr/lib/$AppName
DESKTOP=/usr/share/applications/$AppExeName.desktop

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
echo Write desktop file
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
echo Copy source files
if [[ -d "$SRC_LIB" ]]; then
    rm -rf $SRC_LIB
fi
cp -r $SOURCE $SRC_LIB

# create relative soft link to /usr/bin/
echo Create relative soft link to executable file
if [[ -f "$SRC_BIN" ]]; then
    rm -f $SRC_BIN
fi
ln -r -s $SRC_LIB/$AppExeName $SRC_BIN

# copy icon file
echo Copy icon file
if [[ -n "$IconFile" && -f "$IconFile" ]]; then
    ICON_FNAME=$(echo $IconFile | rev | cut -d "/" -f 1 | rev)
    ICON=/usr/share/icons/hicolor/scalable/apps/$AppExeName-$ICON_FNAME
    SRC_ICON=$ROOTDIR$ICON
    cp -f $IconFile $SRC_ICON
fi

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
