# k8s-cluster

准备3台centos虚拟机，每台2核cpu和2G内存，配置好root账户，并安装好docker，后续的所有操作都是使用root账户。虚拟机具体信息如下表：

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.174.130 | k8s master |   2    | 2G | node1 |
| centos7 64位 | 192.168.174.129 | k8s worker |   2    | 2G | node2 |
| centos7 64位 | 192.168.174.128 | k8s worker |   2    | 2G | node3 |

```/etc/hosts
192.168.174.130 node1
192.168.174.129 node2
192.168.174.128 node3
```

```bash
# 在3个节点 放开 etcd 提供服务的 2379 和 2380 端口
firewall-cmd --zone=public --add-port=2379/tcp --permanent
firewall-cmd --zone=public --add-port=2380/tcp --permanent

# 在k8s master节点 放开 kube-apiserver 提供服务的 6443 和 8080 端口
#firewall-cmd --zone=public --add-port=6443/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent

systemctl stop firewalld.service
systemctl start firewalld.service
```

## 一. etcd集群
### [1. 搭建3节点etcd-cluster][1]

## 二. 剥离了认证授权功能的k8s集群部署
### [1. 在k8s集群主节点 部署 kube-apiserver][2]
### [2. 在k8s集群主节点 部署 kube-controller-manager][3]
### [3. 在k8s集群主节点 部署 kube-scheduler][4]
### [4. 在k8s集群所有节点 部署 kube-calico-node][5]
### [5. 在k8s集群任意节点部署kubectl工具 这里在 k8s-cluster master 主节点部署 kubectl][6]
### [6. 在k8s集群所有worker节点 部署 kubelet][7]




[1]: https://github.com/solozyx/k8s-cluster/tree/master/docs/etcd-cluster.md
[2]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kube-apiserver.md
[3]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kube-controller-manager.md
[4]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kube-scheduler.md
[5]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kube-calico-node.md
[6]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kubectl.md
[7]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kubelet.md