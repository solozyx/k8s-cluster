# 在k8s集群所有worker节点 部署 kubelet

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.174.129 | k8s worker |   2    | 2G | node2 |
| centos7 64位 | 192.168.174.128 | k8s worker |   2    | 2G | node3 |

## 1. kubelet
- kubelet 每个 k8s-cluster worker 节点上都运行一个 kubelet 服务进程,默认监听 10250端口
- kubelet 接收 并 执行 k8s-cluster master 节点发来的指令,管理Pod 及 Pod中的容器
- kubelet 进程会在 kube-apiserver 上注册节点自身信息,定期向 k8s-cluster master 节点汇报该 worker 节点的资源使用情况,并通过 cAdvisor 监控节点和容器的资源.

## 2. 部署 kubelet 系统服务方式

### 2.1 在 k8s-cluster worker node2 节点部署 kubelet

```bash
mkdir -p /var/lib/kubelet
mkdir -p /etc/kubernetes
mkdir -p /etc/cni/net.d

cp kubernetes-simple/worker-node/kubelet-node2.service /lib/systemd/system

# kubelet 依赖配置文件
cp kubernetes-simple/worker-node/kubelet.kubeconfig /etc/kubernetes

# kubelet 用到的 cni 插件配置文件
cp kubernetes-simple/worker-node/10-calico.conf /etc/cni/net.d

systemctl enable kubelet-node2.service
systemctl start kubelet-node2.service 
journalctl -f -u kubelet-node2
/root/kubernetes-bins/kubectl get nodes
```

[kubelet-node2.service][1]
[kubelet.kubeconfig][2]
[10-calico.conf][3]

```
[root@CentOS ~]# /root/kubernetes-bins/kubectl get nodes
NAME              STATUS    ROLES     AGE       VERSION
192.168.174.129   Ready     <none>    11m       v1.9.0
[root@CentOS ~]#
```

### 2.2 在 k8s-cluster worker node3 节点部署 kubelet

```bash
mkdir -p /var/lib/kubelet
mkdir -p /etc/kubernetes
mkdir -p /etc/cni/net.d

cp kubernetes-simple/worker-node/kubelet-node3.service /lib/systemd/system

# kubelet 依赖配置文件
cp kubernetes-simple/worker-node/kubelet.kubeconfig /etc/kubernetes

# kubelet 用到的 cni 插件配置文件
cp kubernetes-simple/worker-node/10-calico.conf /etc/cni/net.d

systemctl enable kubelet-node3.service
systemctl start kubelet-node3.service 
journalctl -f -u kubelet-node3
/root/kubernetes-bins/kubectl get nodes
```

[kubelet-node3.service][4]

```
[root@CentOS ~]# /root/kubernetes-bins/kubectl get nodes
NAME              STATUS    ROLES     AGE       VERSION
192.168.174.128   Ready     <none>    20s       v1.9.0
192.168.174.129   Ready     <none>    20m       v1.9.0
[root@CentOS ~]#
```

[1]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/worker-node/kubelet-node2.service
[2]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/worker-node/kubelet.kubeconfig
[3]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/worker-node/10-calico.conf
[4]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/worker-node/kubelet-node3.service