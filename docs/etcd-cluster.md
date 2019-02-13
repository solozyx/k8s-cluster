# 搭建3节点etcd-cluster
## 1. 准备服务器
准备3台centos虚拟机，每台2核cpu和2G内存，配置好root账户，并安装好docker，后续的所有操作都是使用root账户。虚拟机具体信息如下表：

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.182.128 | k8s master |   2    | 2G | etcd-cluster-node1 |
| centos7 64位 | 192.168.182.130 | k8s worker |   2    | 2G | etcd-cluster-node2 |
| centos7 64位 | 192.168.182.129 | k8s worker |   2    | 2G | etcd-cluster-node3 |

```/etc/hosts
192.168.182.128 etcd-cluster-node1
192.168.182.130 etcd-cluster-node2
192.168.182.129 etcd-cluster-node3
```

放开etcd提供服务的 2379 和 2380 端口
```bash
firewall-cmd --zone=public --add-port=2379/tcp --permanent
firewall-cmd --zone=public --add-port=2380/tcp --permanent
systemctl stop firewalld.service
systemctl start firewalld.service
```

> 使用ubuntu的同学也可以参考此文档，需要注意替换系统命令

## 2. 在所有节点安装etcd
### 2.1 在node1安装etcd
```bash
cp etcd-cluster/etcd-node1.service  /lib/systemd/system
mkdir -p /var/lib/etcd
systemctl enable etcd-node1.service
systemctl start etcd-node1 
journalctl -f -u etcd-node1.service
netstat -ntlp
```
[etcd-node1.service][1]

### 2.2 在node2安装etcd
```bash
cp etcd-cluster/etcd-node2.service  /lib/systemd/system
mkdir -p /var/lib/etcd
systemctl enable etcd-node2.service 
systemctl start etcd-node2
journalctl -f -u etcd-node2.service
netstat -ntlp
```
[etcd-node2.service][2]

### 2.3 在node3安装etcd
```bash
cp etcd-cluster/etcd-node3.service  /lib/systemd/system
mkdir -p /var/lib/etcd
systemctl enable etcd-node3.service 
systemctl start etcd-node3
journalctl -f -u etcd-node3.service
netstat -ntlp
```
[etcd-node3.service][3]

### 2.4 查看etcd cluster 集群状态
```bash
etcdctl member list

[root@CentOS kubernetes-bins]# ./etcdctl member list 
65c6bdcc0c215bc4: name=node1 peerURLs=http://192.168.182.128:2380 clientURLs=http://192.168.182.128:2379 isLeader=true
8cc3ba684014c64f: name=node3 peerURLs=http://192.168.182.129:2380 clientURLs=http://192.168.182.129:2379 isLeader=false
9829c5eda31aac68: name=node2 peerURLs=http://192.168.182.130:2380 clientURLs=http://192.168.182.130:2379 isLeader=false
[root@CentOS kubernetes-bins]# 
```

[1]: https://github.com/solozyx/k8s-cluster/tree/master/etcd-cluster/etcd-node1.service
[2]: https://github.com/solozyx/k8s-cluster/tree/master/etcd-cluster/etcd-node2.service
[3]: https://github.com/solozyx/k8s-cluster/tree/master/etcd-cluster/etcd-node3.service
