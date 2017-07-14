#! /bin/bash

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

das_port=32013
server_response="Problem accessing: /worker. Reason: Not Found"

prgdir=$(dirname "$0")
script_path=$(cd "$prgdir"; cd ..; pwd)

# ----  This is to initiate infrastucture deployment

#/bin.bash $script_path/infrastructure-automation/invoke.sh
#sleep 10


#------- This is to invoke for docker image creation and DAS configuration
#/bin/bash $script_path/docker-files/das-service/docker1.sh


# ----- K8s master url needs to be export from /k8s.properties

K8s_master=$(echo $(cat $script_path/infrastructure-automation/k8s.properties))
export $K8s_master
echo "Kubernetes Master URL is Set to : "$K8s_master
echo "Current location : "$script_path

echo "Creating the K8S Pods!!!!"

kubectl create -f $script_path/das_standalone/das_test_service.yaml
kubectl create -f $script_path/das_standalone/das_test_rc.yaml

sleep 10
sudo docker build $script_path/docker-files/das-service
sleep 10

function getKubeNodeIP() {
    IFS=$','
    node_ip=$(kubectl get node $1 -o template --template='{{range.status.addresses}}{{if eq .type "ExternalIP"}}{{.address}}{{end}}{{end}}')
    if [ -z $node_ip ]; then
      echo $(kubectl get node $1 -o template --template='{{range.status.addresses}}{{if eq .type "InternalIP"}}{{.address}}{{end}}{{end}}')
    else
      echo $node_ip
    fi
}

kube_nodes=($(kubectl get nodes | awk '{if (NR!=1) print $1}'))
host=$(getKubeNodeIP "${kube_nodes[1]}")
echo $host
echo "Waiting DAS to launch on http://${host}:${das_port}"
sleep 10

# The loop is used as a global timer. Current loop timer is 3*100 Sec.
for number in {1..10}
do
echo $(date)" Waiting for server startup!"
if [ "$server_response" == "$(curl --silent --get --connect-timeout 5 --max-time 10 http://${host}:${das_port})/worker" ]
#if [$(ps -ef | grep -v grep | grep $service | wc -l) > 0  ]
then
  break
fi
sleep 3
done

trap : 0

echo >&2 '
************
*** DONE ***
************
'

echo 'Generating The deployment.json!'
pods=$(kubectl get pods --output=jsonpath={.items..metadata.name})
json='['
for pod in $pods; do
         hostip=$(kubectl get pods "$pod" --output=jsonpath={.status.hostIP})
         lable=$(kubectl get pods "$pod" --output=jsonpath={.metadata.labels.name})
         servicedata=$(kubectl describe svc "$lable")
         json+='{"hostIP" :"'$hostip'", "lable" :"'$lable'", "ports" :['
         declare -a dataarray=($servicedata)
         let count=0
         for data in ${dataarray[@]}  ; do
            if [ "$data" = "NodePort:" ]; then
            IFS='/' read -a myarray <<< "${dataarray[$count+2]}"
            json+='{'
            json+='"protocol" :"'${dataarray[$count+1]}'",  "port" :"'${myarray[0]}'"'
            json+="},"
            fi

         ((count+=1))
         done
         i=$((${#json}-1))
         lastChr=${json:$i:1}

         if [ "$lastChr" = "," ]; then
         json=${json:0:${#json}-1}
         fi

         json+="]},"
done

json=${json:0:${#json}-1}
json+="]"

echo $json;

cat > deployment.json << EOF1
$json
EOF1