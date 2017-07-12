#!/bin/bash

#set -e

prgdir=$(dirname "$0")
script_path=$(cd "$prgdir"; cd ..; pwd)
echo "Current location : " $script_path

#----to login to docker
sudo docker login dockerhub.private.wso2.com

#echo "Please enter your docker Password: "
#read -sr PASSWORD_INPUT
#export PASSWORD=$PASSWORD_INPUT

#-----to pull the docker base image

#init_image=dockerhub.private.wso2.com/ubuntu:14.04  #for fisrt time pull using base image
init_image=dockerhub.private.wso2.com/kavitha-dasc5-integration:4.0.0  # already pushed a DAS base image
sudo docker pull $init_image
sleep 60
echo "The base image you pulled is "$init_image


#---- this is to tag and add new image----to tag an image by giving imageid  ===> will clone your image and create tag for new image

declare -a imag_array=($(sudo docker images $init_image | awk 'NR==2'))
image_id=$(echo ${imag_array[@]} | awk '{print $3}' )
echo "image id is "$image_id

name_space=dockerhub.private.wso2.com/kavitha
new_image=$name_space-dasc5-integration
#sudo docker tag $image_id $new_image:4.0.0
#tag_image=($(sudo docker tag $image_id $new_image:m1))
#echo "tagged image is "$tag_image


#----to run above image (don't run as interactive mode bcz to get container id in same)
echo "running on... "
#sh das-service/docker2.sh $new_image:m5
sudo docker run -it -d $new_image:4.0.0
#echo "image started running in background"
sleep 3


#----to get container id of running image
#con_details=($(sudo docker ps | awk '{if (NR!=1) print $1}'))

declare -a con_array=($(sudo docker ps | awk 'NR==2'))
containerid=$(echo ${con_array[@]} | awk '{print $1}')
#containerid=($(sudo docker ps | awk -F':' '{ print $1 }' | sort ))
echo "container id is "$containerid

# ========== need to checkout from jenkins ===========before commit

echo "fetching latest DAS distribution pack and deploying..."
sh $script_path/common-scripts/get-latest-distribution.sh
sleep 2
#Extract the distribution to the temporary location and move it to the distribution directory
mkdir tmp
unzip -q product-4.0.0-SNAPSHOT.zip -d tmp/

#------- to copy downloaded distribution to DAS image
echo "Copying files from the temp directory to distribution directory"
#cp -r tmp/*/* ${das_home}/distribution/
sudo docker cp $script_path/tmp/* $containerid:/home/
sleep 120

echo "Deleting the temp directory!!"
rm -rf tmp

sudo docker commit $containerid $new_image:4.0.0
sudo docker push $new_image:4.0.0
sleep 60

#------- to remove container and image from local
sudo docker stop $containerid
sudo docker rm $containerid
sleep 30
sudo docker rmi Image -f $image_id

# to remove older containers
#sudo docker rm `docker ps --no-trunc -a -q`

#==================

#----to create an image by giving container id ===> will create a new image on respective name
#---- update imageid each time

#image_name=($(sudo docker images $init_image | awk '{print $1}' | sort ))
#image_name=$pull_image
#echo "image name is "$image_name


#if [ -z "$image_name" ]
#then
#  echo "\$image_name is null."
#  image_name=dockerhub.private.wso2.com/ubuntu-image1
#else
#  echo "\$String is NOT null."
#fi     # $String is null.

#num=1
#for i in $(sudo docker images $new_image);
#  do
#     echo item: $i
#
#     image_name="$i-image-$num"
#     num=$num+1
#     echo $image_name
#
trap : 0

echo >&2 '
************
*** DONE ***
************
'



