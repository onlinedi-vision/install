#!/bin/bash
set -e

echo "  * Fetching AppImage.tar.gz (/tmp/division-client-install-tmp.tar.gz)"

curl -s https://api.github.com/repos/onlinedi-vision/od-client/releases/latest \
	| grep "browser_download_url" \
	| awk -F ' ' '{ print $2 }' \
	| tr -d \" \
	| wget -O /tmp/division-client-install-tmp.tar.gz -qi - --show-progress 


echo "\n\n\n  * Creating /opt/division-online directory (if not existant)"
if [ ! -d /opt/division-online ]; then
	sudo mkdir /opt/division-online
fi

echo "  * Untaring appimage (into /opt/division-online)"
sudo tar -zvxf /tmp/division-client-install-tmp.tar.gz -C /opt/division-online
sudo chmod 0777 /opt/division-online/division.client.AppDir/

# Added full permissions to 'other' so echo commands can execute successfully; could revise
echo "  * Creating /usr/bin/division-online-client script"
sudo touch /usr/bin/division-online-client
sudo chmod o+wx /usr/bin/division-online-client
sudo echo "#!/usr/bin/env bash" > /usr/bin/division-online-client
sudo echo "/opt/division-online/division.client.AppDir/AppRun" >> /usr/bin/division-online-client

if [ ! -d $HOME/.division-online ]; then
	echo "  * Creating \$HOME/.division-online (at $HOME/.division-online) cache directory"
	set -x
	mkdir $HOME/.division-online
	touch $HOME/.division-online/server_secrets.json
	touch $HOME/.division-online/dm_secrets.json
	touch $HOME/.division-online/credentials.json
	set +x
fi

echo "  * Finished installing! You should be able to run division-online-client to open the client app!"
echo "  * For troubleshooting please check out the github page of the project (https://github.com/onlinedi-vision/od-client)!"
echo "  * Have fun!"
