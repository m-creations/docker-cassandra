Cassandra 2.1.2 as a Docker container. For development use only.  

## Quickstart

### Single Node

Pull the image and launch it.  
  
```
docker pull m-creations/docker-cassandra:1.0
docker run -d --name cass1 -v /data/cass1:/data -e MAX_HEAP_SIZE=600m -e HEAP_NEWSIZE=100m -e CLUSTER_NAME=testcluster -e OPS_IP=192.168.1.1  mcreations/openwrt-cassandra:1.0
```

Grab the seed node's IP using:  
  
```
SEED_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cass1)
```
  
Connect to it using CQLSH:  
  
```
cqlsh $SEED_IP  
```
 
### Multiple Nodes
  
Follow the single node setup to get the first node running and keep track of its IP. Run the following to launch the other nodes in the cluster:  

```
SEED_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cass1)
```  
 
```
for name in cass{2..5}; do
  echo "Starting node $name"
  docker run -d --name $name -v /data/$name:/data -e MAX_HEAP_SIZE=600m -e HEAP_NEWSIZE=100m -e CLUSTER_NAME=testcluster -e OPS_IP=192.168.1.1 -e SEED=$SEED_IP mcreations/openwrt-cassandra:1.0
  sleep 30
done
```
  
Once all the nodes are up, check cluster status using:  
  
```
nodetool --host $SEED_IP status
```
