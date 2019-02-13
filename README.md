# k8s-cluster

准备3台centos虚拟机，每台2核cpu和2G内存，配置好root账户，并安装好docker，后续的所有操作都是使用root账户。虚拟机具体信息如下表：

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.182.128 | k8s master |   2    | 2G | node1 |
| centos7 64位 | 192.168.182.130 | k8s worker |   2    | 2G | node2 |
| centos7 64位 | 192.168.182.129 | k8s worker |   2    | 2G | node3 |

```/etc/hosts
192.168.182.128 node1
192.168.182.130 node2
192.168.182.129 node3
```

```bash
# 放开 etcd 提供服务的 2379 和 2380 端口
firewall-cmd --zone=public --add-port=2379/tcp --permanent
firewall-cmd --zone=public --add-port=2380/tcp --permanent

# 放开 kube-apiserver 提供服务的 6443 和 8080 端口
#firewall-cmd --zone=public --add-port=6443/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent

systemctl stop firewalld.service
systemctl start firewalld.service
```

## [1 搭建3节点etcd-cluster][1]
## [2 在k8s集群主节点 部署 kube-apiserver][2]
## [3 在k8s集群主节点 部署 kube-controller-manager][3]





[1]: https://github.com/solozyx/k8s-cluster/tree/master/docs/etcd-cluster.md
[2]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kube-apiserver.md
[3]: https://github.com/solozyx/k8s-cluster/tree/master/docs/kube-controller-manager.md
