#!/bin/bash
NODE_PROXY_LOGFILE=node_proxy.log
LOG_DIR=/opt/sasinside/vicpol/logs

echo nodejs proxy logging to: ${LOG_DIR}/${NODE_PROXY_LOGFILE} 

nohup node /opt/sasinside/vicpol/code/redirect_03.js > ${LOG_DIR}/${NODE_PROXY_LOGFILE} 2>&1 &
