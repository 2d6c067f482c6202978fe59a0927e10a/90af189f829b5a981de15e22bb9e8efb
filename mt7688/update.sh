#!/bin/sh

/etc/init.d/health-check stop
/etc/init.d/health-check disable
/etc/init.d/hc-module stop
/etc/init.d/hc-module disable
