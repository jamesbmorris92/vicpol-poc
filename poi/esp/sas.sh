# SAS Server setup, should be saved in /etc/profile.d/sas.ssh
#SAS Environment variables
export LD_LIBRARY_PATH=/opt/sas/viya/home/lib64:${LD_LIBRARY_PATH}

#ESP Environment variables
export DFESP_HOME=/opt/sas/viya/home/SASEventStreamProcessingEngine/5.2
export LD_LIBRARY_PATH=$DFESP_HOME/lib:/opt/sas/viya/home/SASFoundation/sasexe:$LD_LIBRARY_PATH
export DFESP_SSLPATH=$DFESP_HOME/ssl/lib
export DFESP_JAVA_TRUSTSTORE=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.jks
export SSLCALISTLOC=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem
export PATH=$PATH:$DFESP_HOME/bin


#psql Environment Variables
export PATH=${PATH}:/opt/sas/viya/home/bin

#rabbitmqctl command
export PATH=${PATH}:/opt/sas/viya/home/lib/rabbitmq-server-3.7.3/sbin

#odbc
export LD_LIBRARY_PATH=/opt/odbc/unixODBC-2.3.7/lib:${LD_LIBRARY_PATH}
export PATH=/opt/odbc/unixODBC-2.3.7/bin:${PATH}