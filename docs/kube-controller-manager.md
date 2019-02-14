# 在k8s集群主节点 部署 kube-controller-manager

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.174.130 | k8s master |   2    | 2G | node1 |

## 1. kube-controller-manager
- kube-controller-manager 和 cloud-controller-manager 组成了 kubernetes 的大脑  
- kube-controller-manager 通过 kube-apiserver 监控整个集群的状态,并确保集群处于预期的工作状态  
- kube-controller-manager 由一系列的控制器组成,如 Replication Controller 控制副本, Node Controller 节点控制, Deployment Controller 管理deployment等  
- cloud-controller-manager 在 kubernetes 启用 Cloud Provider 的时候才需要,用来配合云服务提供商的控制
- kube-controller-manager kube-scheduler 和 kube-apiserver 三者的功能紧密相关,一般运行在同一个机器上,可以把它们当做一个整体来看,所以保证了 kube-apiserver 的高可用即是保证了三个模块的高可用
- 可以同时启动多个 kube-controller-manager 进程,但只有1个会被【选举】为leader提供服务

## 2. 部署 kube-controller-manager 系统服务方式
```bash
cp kubernetes-simple/master-node/kube-controller-manager.service /lib/systemd/system/
systemctl enable kube-controller-manager.service
systemctl start kube-controller-manager
journalctl -f -u kube-controller-manager
```
[kube-controller-manager.service][1]

## 3. 重点配置说明

- address=127.0.0.1
对外服务的监听地址,这里表示只有本机的程序可以访问它

- master=http://127.0.0.1:8080    
apiserver的url,kube-controller-manager 与 kube-apiserver 进行通信  

- service-cluster-ip-range=10.68.0.0/16  
服务虚拟ip范围，同 kube-apiserver 配置  

- cluster-cidr=172.20.0.0/16  
Pod的ip地址范围,在集群运行Pod时 虚拟IP范围  
 
- cluster-signing-cert-file=空值   cluster-signing-key-file=空值     
用空值覆盖默认值,表示不使用证书

[1]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/master-node/kube-controller-manager.service