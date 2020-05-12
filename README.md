# Fabric deployed with Kubernetes

Tested with:
minikube
kubeadmn
azure aks

docker-compose


## Deploy in Azure etcd, 2orgs, 4 peer, 3 orderer
```bash
#CoreDNS
cd ./network/azure-2org-3ord-4peer/k8s/coreDNS
./configCoreDns.sh
```

```bash
cd ./network/azure-2org-3ord-4peer
./up-ca.sh

#Add ips of cas
vim ./network/azure-ca-2org/docker-compose/cli-build-ca.yaml

./buid-ca-msp.sh
./build.sh

./up.sh

#Add ips of orderer and peers
vim ./network/azure-2org-3ord-4peer/docker-compose/cli.yaml

./createChannel.sh
./deployCC.sh
./runCC.sh

```

### Deploy api-server.

In another terminal
```bash
cd ./apps/
./build.sh
./docker-build.sh
docker push le999/org1-api1:1.0
docker push le999/org2-api1:1.0
cd -

cd ./network/azure-2org-3ord-4peer
#Run
./up-api.sh

#Test
vim ./test-network.sh #Set ips
./test-network.sh
```


### Test Locally.

In another terminal
```bash
#Add ips of peer and orderer:
vim ./apps/docker-compose-api-server.yaml

cd ./apps/
./build.sh

#Run
./up.sh

./up-api.sh
```

In browser open
http://localhost:3000/api-docs



#References
https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/
https://stackoverflow.com/questions/53498438/how-do-i-force-kubernetes-coredns-to-reload-its-config-map-after-a-change
