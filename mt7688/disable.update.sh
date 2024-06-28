# ====================== hc-module ======================
HC_MODULE_OTA_CHECKSUM=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/hc-module/checksum`
HC_MODULE_CURRENT_CHECKSUM=`sha256sum /hc-module/hc-module | awk '{print $1}'`

if [ "$HC_MODULE_OTA_CHECKSUM" != "$HC_MODULE_CURRENT_CHECKSUM" ]; then
        echo "Update"
        wget https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/master/mt7688/hc-module/hc-module -O /tmp/hc-module-update
        chmod +x /hc-module/hc-module
fi

HC_MODULE_CONF_CHEKCSUM=