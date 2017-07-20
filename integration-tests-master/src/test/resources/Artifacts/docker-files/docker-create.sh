#!/usr/bin/env bash

set -e

prgdir=$(dirname "$0")
script_path=$(cd "$prgdir"; cd ..; pwd)
echo "script path "$script_path
echo "fetching latest DAS distribution pack and deploying..."

#------## This is to download latest pack from jenkins

#sh $script_path/common-scripts/get-latest-distribution.sh
#sleep 2

#----- Extract the distribution to the temporary location and move it to the distribution directory

mkdir $script_path/docker-files/tmp
cp product-4.0.0-SNAPSHOT.zip $script_path/docker-files/tmp
#unzip -q product-4.0.0-SNAPSHOT.zip -d $script_path/docker-files/tmp/
sleep 5
echo "Distribution pack copied to temporary directory and waiting for image launch..."

#------- to copy downloaded distribution to DAS image
#echo "Copying files from the temp directory to distribution directory"
#cp -r tmp/*/* ${das_home}/distribution/
#sudo docker cp $script_path/tmp/* $containerid:/home/


sudo docker build $script_path/docker-files/ -t dockerhub.private.wso2.com/kavitha-dasc5-inte-new:14.04
echo "Image build is success"
echo "Deleting the temp directory!!"
rm -rf tmp

#----- ## to push updated image to online registry

#sudo docker commit $containerid $new_image:4.0.0
sudo docker push dockerhub.private.wso2.com/kavitha-dasc5-inte-new:14.04


#----- ## To remove container and image from local

#sudo docker stop $containerid
#sudo docker rm $containerid
#sleep 30
#sudo docker rmi -f $image_id