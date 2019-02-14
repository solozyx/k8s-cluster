# 在k8s集群所有节点 部署 kube-calico-node

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.174.130 | k8s master |   2    | 2G | node1 |
| centos7 64位 | 192.168.174.129 | k8s worker |   2    | 2G | node2 |
| centos7 64位 | 192.168.174.128 | k8s worker |   2    | 2G | node3 |

## 1. calico-node
- calico-node 实现了CNI接口,是 kubernetes 网络方案的一种选择
- calico-node 是一个纯三层的数据中心网络方案(不需要Overlay),并且与 OpenStack / Kubernetes / AWS / GCE 等 IaaS平台都有良好的集成. 
- calico-node 在每一个计算节点利用 Linux Kernel 实现了一个高效的 vRouter 来负责数据转发,而每个 vRouter 通过 BGP协议 负责把自己运行的 workload 的路由信息向整个 calico 网络内传播
- 小规模部署可以直接互联,大规模可通过指定的 BGP route reflector 完成. 这样保证最终所有的 workload 之间的数据流量都是通过 IP路由的 方式完成互联.

## 2. 部署 kube-calico-node 系统服务 + docker 方式

### 2.1 在node1部署kube-calico-node1
```bash
systemctl start docker

cp kubernetes-simple/all-node/kube-calico-node1.service  /lib/systemd/system

mkdir -p /var/run/calico
mkdir -p /run/docker/plugins
mkdir -p /var/log/calico

systemctl enable kube-calico-node1.service
systemctl start kube-calico-node1.service
journalctl -f -u kube-calico-node1
docker ps | grep calico
```
[kube-calico-node1.service][1]

### 2.2 在node2部署kube-calico-node2
```bash
systemctl start docker

cp kubernetes-simple/all-node/kube-calico-node2.service  /lib/systemd/system

mkdir -p /var/run/calico
mkdir -p /run/docker/plugins
mkdir -p /var/log/calico

systemctl enable kube-calico-node2.service
systemctl start kube-calico-node2.service
journalctl -f -u kube-calico-node2
docker ps | grep calico
```
[kube-calico-node2.service][2]

### 2.3 在node2部署kube-calico-node3
```bash
systemctl start docker

cp kubernetes-simple/all-node/kube-calico-node3.service  /lib/systemd/system

mkdir -p /var/run/calico
mkdir -p /run/docker/plugins
mkdir -p /var/log/calico

systemctl enable kube-calico-node3.service
systemctl start kube-calico-node3.service
journalctl -f -u kube-calico-node3
docker ps | grep calico
```
[kube-calico-node3.service][3]

### 2.4 验证kube-calico-node网络
```bash
calicoctl node status

[root@CentOS ~]# /root/kubernetes-bins/calicoctl node status 
Calico process is running.

IPv4 BGP status
+-----------------+-------------------+-------+----------+-------------------------------------------+
|  PEER ADDRESS   |     PEER TYPE     | STATE |  SINCE   |                    INFO                   |
+-----------------+-------------------+-------+----------+-------------------------------------------+
| 192.168.174.129 | node-to-node mesh | start | 09:02:37 | Active Socket: Host is unreachable        |
| 192.168.174.128 | node-to-node mesh | start | 09:10:00 | Active Socket: Host is unreachable        |
+-----------------+-------------------+-------+----------+-------------------------------------------+

IPv6 BGP status
No IPv6 peers found.

[root@CentOS ~]#
```

- 注意 calico-node 这里使用阿里云镜像 创建calico网络失败  
> registry.cn-hangzhou.aliyuncs.com/acs/calico-node:v3.0.3


[1]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/all-node/kube-calico-node1.service
[2]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/all-node/kube-calico-node2.service
[3]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/all-node/kube-calico-node3.service