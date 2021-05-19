#!/bin/bash

##########################################################################
# Deploy Elastic Search, Kibana and Filebeat to manage aggregating of logs
##########################################################################

#
# Download the Elastic Stack repos
#
helm repo add elastic https://helm.elastic.co 2>/dev/null
helm repo update

#
# Install Elastic Search
#
helm uninstall elasticsearch 2>/dev/null
helm install elasticsearch elastic/elasticsearch --values=elasticsearchvalues.yaml
if [ $? -ne 0 ];
then
  echo "Problem encountered installing Elastic Search"
  exit 1
fi

#
# TODO: Init container to create schema and ingestion pipeline
#

#
# Install Kibana
#
helm uninstall kibana 2>/dev/null
helm install kibana elastic/kibana
if [ $? -ne 0 ];
then
  echo "Problem encountered installing Kibana"
  exit 1
fi

#
# Expose Kibana so that we can query logs from outside the cluster
#
kubectl apply -f ingress.yaml
if [ $? -ne 0 ];
then
  echo "Problem encountered creating Kibana ingress"
  exit 1
fi
exit

#
# Install filebeat
#
helm install filebeat elastic/filebeat -–values=filebeatvalues.yaml
if [ $? -ne 0 ];
then
  echo "Problem encountered installing Filebeat"
  exit 1
fi