#!/bin/bash

ACCOUNT=`whoami`

echo "service account is $ACCOUNT, Start settins!"

echo "Stop1. Set wca, wva configuration"
{
	tar -zxf ./wca-libs.tar.gz && \
	sudo mkdir -p /opt/penta/keys && \
	sudo cp -rf ./wca-libs /opt/penta/ 
} || \
{
	echo "Failed wca, wva configuration"
	exit 1
}


echo "Step2. Set tomcat configuration"
{
	tar -zxf apache-tomcat-8.5.63.tar.gz && \
	cp context.xml server.xml ./apache-tomcat-8.5.63/conf/ && \
	cp catalina.sh ./apache-tomcat-8.5.63/bin/ 
} || \
{
	echo "Failed tomcat configuration"
	exit 1
}

echo "Step3. Move tomcat to /opt"
{
	sudo cp -rf apache-tomcat-8.5.63 /opt/tomcat-wca && \
	sudo cp -rf apache-tomcat-8.5.63 /opt/tomcat-wva && \
	sudo chown $ACCOUNT:$ACCOUNT -R /opt/tomcat*
	sudo chown $ACCOUNT:$ACCOUNT -R /opt/penta
} || \
{
	echo "Failed tomcat to /opt"
	exit 1
}


echo "Step4. Apply service"
{
	sed -i "s/autocrypt/$ACCOUNT/g" ./wca.service > /dev/null 2>&1 && \
	sed -i "s/autocrypt/$ACCOUNT/g" ./wva.service > /dev/null 2>&1 && \
	sudo cp ./wca.service /etc/systemd/system/ && \
	sudo cp ./wva.service /etc/systemd/system/ && \
	sudo systemctl enable wca && \
	sudo systemctl enable wva
} || \
{
	echo "Failed to apply service"
	exit 1
}

echo "Finished Settings!"

