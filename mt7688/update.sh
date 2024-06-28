# ====================== hc-module ======================
HC_MODULE_OTA_CHECKSUM=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/hc-module/checksum`
HC_MODULE_CURRENT_CHECKSUM=`sha256sum /hc-module/hc-module | awk '{print $1}'`

if [ "$HC_MODULE_OTA_CHECKSUM" != "$HC_MODULE_CURRENT_CHECKSUM" ]; then
        wget https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/master/mt7688/hc-module/hc-module -O /tmp/hc-module-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/hc-module-update | awk '{print $1}'`
        if [ "$HC_MODULE_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/hc-module-update /hc-module/hc-module
                chmod +x /hc-module/hc-module
                /etc/init.d/hc-module restart
        fi
fi

#====================== hc module config ==================
HC_MODULE_CONF_OTA_CHEKCSUM=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/hc-module-conf/checksum`
HC_MODULE_CONF_CURRENT_CHECKSUM=`sha256sum /hc-module/hc-module.conf | awk '{print $1}'`

if [ "$HC_MODULE_CONF_OTA_CHEKCSUM" != "$HC_MODULE_CONF_CURRENT_CHECKSUM" ]; then
        wget https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/hc-module-conf/hc-module.conf -O /tmp/hc-module-conf-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/hc-module-conf-update | awk '{print $1}'`
        if [ "$HC_MODULE_CONF_OTA_CHEKCSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/hc-module-conf-update /hc-module/hc-module.conf
                /etc/init.d/hc-module restart
        fi
fi