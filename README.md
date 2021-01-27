![](https://img.shields.io/badge/Stability-Experimental-red.svg)

# Cluster API Provider Tink

This repository is
[Experimental](https://github.com/packethost/standards/blob/master/experimental-statement.md)
meaning that it's based on untested ideas or techniques and not yet established
or finalized or involves a radically new and innovative style! This means that
support is best effort (at best!) and we strongly encourage you to NOT use this
in production.

---

Cluster API Provider Tinkerbell (CAPT) is the implementation of Cluster API
Provider for Tinkerbell.

## Goal

* It acts as a bridge between Cluster API (a Kubernetes sig-lifecycle project)
  and Tinkerbell
* It simplifies Kubernetes cluster management using Tinkerbell as underline
  infrastructure provider
* Create, update, delete Kubernetes project in a declarative fashion.

## Current state

7th December 2020 marks the first commit for this project, it starts as a
porting from CAPP (cluster api provider packet).

As it is now it does not do anything useful. It starts the infrastructure
manager. Just a go binary with all the boilerplate code and controllers
bootstrapped.

## Technical preview

This project is under active development and you should expect issues, pull
requests and conversation ongoing in the [bi-weekly community
meeting]()https://github.com/tinkerbell/.github/blob/master/COMMUNICATION.md#contributors-mailing-list.
Feel free to join if you are curious or if you have any question.

There is a milestone called `v0.1.0 tech preview`. Have a look at issues
assigned to that label to know more about what it will contain.

## Testing

### Start the sandbox

```sh
git clone https://github.com/tinkerbell/sandbox.git
cd sandbox/deploy/vagrant

# TODO: document how to fix the certificate
# TODO: document hacking in a second worker

vagrant up provisioner
vagrant ssh provisioner
cd /vagrant && source .env && cd deploy
docker-compose up -d
docker pull detiber/ubuntu-install
docker tag detiber/ubuntu-install 192.168.1.1/ubuntu-install
docker push 192.168.1.1/ubuntu-install
cat > hardware-data.json <<EOF
{
  "id": "ce2e62ed-826f-4485-a39f-a82bb74338e2",
  "metadata": {
    "facility": {
      "facility_code": "onprem"
    },
    "instance": {},
    "state": ""
  },
  "network": {
    "interfaces": [
      {
        "dhcp": {
          "arch": "x86_64",
          "ip": {
            "address": "192.168.1.5",
            "gateway": "192.168.1.1",
            "netmask": "255.255.255.0"
          },
          "mac": "08:00:27:00:00:01",
          "uefi": false
        },
        "netboot": {
          "allow_pxe": true,
          "allow_workflow": true
        }
      }
    ]
  }
}
EOF
cat > hardware2-data.json <<EOF
{
  "id": "fe2e62ed-826f-4485-a39f-a82bb74338e3",
  "metadata": {
    "facility": {
      "facility_code": "onprem"
    },
    "instance": {},
    "state": ""
  },
  "network": {
    "interfaces": [
      {
        "dhcp": {
          "arch": "x86_64",
          "ip": {
            "address": "192.168.1.6",
            "gateway": "192.168.1.1",
            "netmask": "255.255.255.0"
          },
          "mac": "08:00:27:00:00:02",
          "uefi": false
        },
        "netboot": {
          "allow_pxe": true,
          "allow_workflow": true
        }
      }
    ]
  }
}
EOF

docker exec -i deploy_tink-cli_1 tink hardware push < ./hardware-data.json
docker exec -i deploy_tink-cli_1 tink hardware push < ./hardware2-data.json
PGPASSWORD=tinkerbell docker-compose exec db psql -U tinkerbell -c 'drop trigger events_channel ON events;'
```

### Bring up the tilt environment

```sh
git clone https://github.com/kubernetes-sigs/cluster-api.git
cd cluster-api
git checkout release-0.3
cat > tilt-settings.json <<EOF
{
    "default_registry": "gcr.io/detiber",
    "provider_repos": ["../../tinkerbell/cluster-api-provider-tink"],
    "enable_providers": ["tinkerbell", "kubeadm-bootstrap", "kubeadm-control-plane"],
}
EOF
tilt up
```

### Do the thing

```sh
# create the hardware resources
kubectl create -f testhardware.yaml

# TODO: how to generate the cluster

# TODO: add user definition and ssh authorized keys

# create the cluster
kubectl create -f testCluster.yaml

# TODO: boot the vagrant worker vm

clusterctl get kubeconfig test > test.kubeconfig

kubectl --kubeconfig=./test.kubeconfig \
  apply -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml

kubectl --kubeconfig test.kubeconfig get nodes

kubectl scale md test-worker-a --replicas=1

# TODO: boot the vagrant worker vm
```