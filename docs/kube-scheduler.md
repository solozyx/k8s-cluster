# 在k8s集群主节点 部署 kube-scheduler

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.182.128 | k8s master |   2    | 2G | node1 |

## 1. kube-scheduler
- kube-scheduler 负责分配调度 Pod 到集群内的节点上,它监听 kube-apiserver ,查询还未分配 Node 的 Pod ,然后根据调度策略为这些 Pod 分配节点. kubernetes的各种调度策略就是通过它实现的.

## 2. 部署 kube-controller-manager 系统服务方式
```bash
cp kubernetes-simple/master-node/kube-scheduler.service /lib/systemd/system/
systemctl enable kube-scheduler.service
systemctl start kube-scheduler
journalctl -f -u kube-scheduler
```
[kube-scheduler.service][1]


## 3. 重点配置说明

- address=127.0.0.1   
对外服务的监听地址,这里表示只有本机的程序可以访问它  
  
- master=http://127.0.0.1:8080 
apiserver的url,kube-scheduler 与 kube-apiserver 进行通信  

[1]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/master-node/kube-scheduler.service