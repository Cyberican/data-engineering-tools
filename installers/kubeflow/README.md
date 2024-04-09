# Setup a local kubeflow instance

### Prerequisites
* Juju
* lxd - container manager


``` sh
# Install the lxd  
sudo snap install lxd
```

``` sh
# Setup Juju controller "CONTROLLER" on localhost/localhost 
juju bootstrap
```
