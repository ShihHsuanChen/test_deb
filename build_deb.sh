# user inputs
AppName=$AppName # dist/<AppName>
PackageName=$PackageName # should be all lower case or '-+.' characters
AppExeName=$AppExeName # executable name. The file path should be dist/<AppName>/<AppExeName>
IconFile=$IconFile # path to icon file
Version=$Version # version i.e. 0.2.1
Description=$Description # app description
AppPublisher=$AppPublisher # maintainer or company
AppPublisherEmail=$AppPublisherEmail # email of maintainer or company
AppUrl=$AppUrl # Homepage url

# check dpkg version
if [[ -z "$(command -V dpkg)" ]]; then
    echo 'command "dpkg" not found'
    echo Exit
    exit
else
    dpkg --version
    echo ""
fi

if [[ -z "$Version" ]]; then
    echo Version is not given. Use default value 0.0.0
    Version="0.0.0"
fi

if [[ -z "$AppExeName" ]]; then
    echo AppExeName is not given. Use AppName by default
    AppExeName=$AppName
fi

echo Build parameters:
echo "    AppName=$AppName"
echo "    AppExeName=$AppExeName"
echo "    PackageName=$PackageName"
echo "    Version=$Version"
echo "    Description=$Description"
echo "    IconFile=$IconFile"
echo "    AppPublisher=$AppPublisher"
echo "    AppPublisherEmail=$AppPublisherEmail"
echo "    AppUrl=$AppUrl"

# derived parameters
SOURCE=dist/$AppName
ARCH=$(dpkg --print-architecture)
WORKDIR=dist_wizard

# tmp directory
ROOTDIR=$WORKDIR/$AppName
TMPDIR=$ROOTDIR/tmp
DEBIAN=$ROOTDIR/DEBIAN

BIN=/usr/bin/$AppExeName
LIB=/usr/lib/$AppName
DESKTOP=/usr/share/applications/$AppExeName.desktop

SRC_BIN=$ROOTDIR$BIN
SRC_LIB=$ROOTDIR$LIB
SRC_DESKTOP=$ROOTDIR$DESKTOP

if ! [[ -d "$SOURCE" ]]; then
    echo Source directory $SOURCE does not exist
    echo Exit
    exit
fi

if ! [[ -f "$SOURCE/$AppExeName" ]]; then
    echo Source executable file $SOURCE/$AppExeName does not exist
    echo Exit
    exit
fi

# create folders
mkdir -p $ROOTDIR
mkdir -p $ROOTDIR/tmp
mkdir -p $ROOTDIR/usr/bin
mkdir -p $ROOTDIR/usr/lib
mkdir -p $ROOTDIR/usr/share/applications
mkdir -p $DEBIAN


# handle icon file
if [[ -n "$IconFile" && -f "$IconFile" ]]; then
    ICON_FNAME=$(echo $IconFile | rev | cut -d "/" -f 1 | rev)
    ICON_EXT=$(echo $ICON_FNAME | rev | cut -d "." -f 1 | rev)

    if [[ "$ICON_EXT" == "svg" ]]; then
        ICON_DIR=/usr/share/icons/hicolor/scalable/apps
    else
        ICON_SIZE=$(identify -ping -format '%wx%h ' $IconFile | rev | cut -d " " -f 2 | rev) # largest size

        if ! [[ -d "/usr/share/icons/hicolor/$ICON_SIZE" && ($ICON_EXT = "png" || $ICON_EXT = "PNG") ]]; then
            # size not acceptable or file is not png -> convert icon file
            # change size
            if ! [[ -d "/usr/share/icons/hicolor/$ICON_SIZE" ]]; then
                echo Icon size is not acceptable. Fallback to 64x64
                ICON_SIZE="64x64" # Fixed size TODO
            fi
            # change file ext
            ICON_EXT="png"
            OFNAME=$(echo $ICON_FNAME | rev | cut -d "." -f 2- | rev).$ICON_EXT
            # convert
            echo Convert icon file to $OFNAME '('$ICON_SIZE')'
            convert "$IconFile" -thumbnail $ICON_SIZE -alpha on -background none -flatten $TMPDIR/$OFNAME
            IconFile=$TMPDIR/$OFNAME
        fi
        ICON_DIR=/usr/share/icons/hicolor/$ICON_SIZE/apps
    fi

    mkdir -p $ROOTDIR$ICONDIR
    ICON=$ICON_DIR/$AppName.$ICON_EXT # /usr/share/icons/.../<ICON_FNAME>
    SRC_ICON=$ROOTDIR$ICON # dist_wizard/<AppName>/usr/share/icons/.../<ICON_FNAME>

    echo Copy icon file to $ROOTDIR$ICON_DIR
    mkdir -p $ROOTDIR$ICON_DIR
    cp -f $IconFile $SRC_ICON
fi

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


# write control file
echo "Source: $AppName
Package: $PackageName
Version: $Version
Maintainer: $AppPublisher, <$AppPublisherEmail>
Homepage: $AppUrl
Architecture: $ARCH
Description: $Description
" > $DEBIAN/control

# build
dpkg -b $ROOTDIR $WORKDIR

# remove tmp directory
rm -rf $TMPDIR
rm -rf $ROOTDIR # debug
