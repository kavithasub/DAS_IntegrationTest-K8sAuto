#!/bin/bash

# Docker init script, this is the Entry Point of the Docker image
# ----- These variables are parsed as Environment variables through Kubernetes controller

echo "das_home is : " ${das_home}
#echo "das_test_repo is : " ${das_test_repo}
#echo "das_test_repo_name is : " ${das_test_repo_name}
echo "Deployment Pattern is : " ${pattern}

#echo "Creating the DAS Home"
#mkdir -p ${das_home}

cd ${das_home}
#mkdir distribution
#cp ${das_home}/wso2das-4.0.0-SNAPSHOT /home/distribution

cd wso2das-4.0.0-SNAPSHOT/bin
sh worker.sh