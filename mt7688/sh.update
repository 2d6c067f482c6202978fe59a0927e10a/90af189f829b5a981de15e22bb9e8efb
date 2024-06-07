if [ "$SERVER" == "Production" ]; then
    FW_URL="https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/master/mt7688/Production/firmware.tar.gz"
    VERSION=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/Production/version`
    CHECK_SUM=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/Production/checksum | awk '{print $1}'`
elif [ "$SERVER" = "Staging" ]; then
    FW_URL="https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/master/mt7688/Staging/firmware.tar.gz"
    VERSION=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/Staging/version`
    CHECK_SUM=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/Staging/checksum | awk '{print $1}'`
else
    echo "$SERVER"
    echo "SERVER not found"
    exit 1
fi

echo "Check Version"
VERSION_VALIDATOR=`cat /etc/config/hc-config.json | grep build_date | awk -F \" '{print $4}'`
echo "VERSION=$VERSION | VERSION_VALIDATOR=$VERSION_VALIDATOR"
if [ "$VERSION" == "$VERSION_VALIDATOR" ]; then
        echo "Firmware already update"
        exit 1
else
        echo "Difference version"
fi

echo "Remove old firmware"
rm -rf /tmp/firmware/tar.gz /tmp/database/update

echo "Download firmware"
wget $FW_URL -O /tmp/firmware.tar.gz

echo "Check sum firmware"
VALIDATOR=`sha256sum /tmp/firmware.tar.gz | awk '{print $1}'`
echo "VALIDATOR=$VALIDATOR | SHA256=$CHECK_SUM"
if [ "$VALIDATOR" != "$CHECK_SUM" ]; then
        echo "Check sum not match"
        exit -1
else
        echo "Check sum success"
fi

echo "Update firmware"
tar -xvzf /tmp/firmware.tar.gz -C /tmp/database
sh /tmp/database/update/script_update.sh

echo "Update version and restart service"
reboot