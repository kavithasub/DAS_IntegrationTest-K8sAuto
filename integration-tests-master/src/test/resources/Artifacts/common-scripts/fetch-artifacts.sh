#!/bin/bash
# Copyright (c) 2017, WSO2 Inc. (http://wso2.com) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
# This file is triggered from docker.sh

echo "das_home is : " ${das_home}
echo "das_test_repo is : " ${das_test_repo}
echo "das_test_repo_name is : " ${das_test_repo_name}
echo "Deployment Pattern is : " ${pattern}
#das_home=$(mkdir /home/DAS_HOME)

#------- to download the latest dirtribution
#sh get-latest-distribution.sh

#Extract the distribution to the temporary location and move it to the distribution directory
mkdir tmp
unzip -q product-4.0.0-SNAPSHOT.zip -d tmp/

#------- to copy downloaded distribution to DAS image
echo "Copying files from the temp directory to distribution directory"
#cp -r tmp/*/* ${das_home}/distribution/
sudo docker cp tmp/*/* |-

echo "Deleting the temp directory!!"
rm -rf tmp

#echo "Copying the dependency Jars"
echo "skipping copy dependencies"
#Copy the dependency Jars to the server
# me comment -----cp -r ${ballerina_home}/${ballerina_test_repo_name}/src/test/resources/Artifacts/${pattern}/resources/bre/lib/* ${ballerina_home}/distribution/bre/lib

#cd into the services package structure root
#cd ${ballerina_home}/${ballerina_test_repo_name}/src/test/resources/Artifacts/${pattern}
#chmod +x ${das_home}/distribution/bin/ballerina

#Source the Environment file
echo "Starting the DAS Server!!!"

#Start the Server
sh ${das_home}/bin/editor.sh
