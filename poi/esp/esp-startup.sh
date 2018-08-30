#!/bin/bash
ESP_PROJECT=PERSONS_OF_INTEREST
ESP_LOGFILE=${ESP_PROJECT}.log
LOG_DIR=/opt/sasinside/vicpol/logs

echo ESP logging to: ${LOG_DIR}/${ESP_LOGFILE}

#Use this command to start up the ESP server without a model during development
#nohup $DFESP_HOME/bin/dfesp_xml_server -http 9080s -pubsub 9180 > ${LOG_DIR}/${ESP_LOGFILE} 2>&1 &

#Uncomment the below once the model is stable
nohup $DFESP_HOME/bin/dfesp_xml_server -http 9080s -pubsub 9180 -model file:///opt/sasinside/vicpol/code/${ESP_PROJECT}.xml> ${LOG_DIR}/${ESP_LOGFILE} 2>&1 &