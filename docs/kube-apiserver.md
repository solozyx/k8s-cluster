# 在k8s集群主节点 部署 kube-apiserver

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.182.128 | k8s master |   2    | 2G | etcd-cluster-node1 |

## 1. kube-apiserver
kube-apiserver 是 kubernetes 最重要的核心组件之一
- 提供集群管理的 REST API 接口,认证授权,数据校验,集群状态变更
- 是其他模块间数据交互和通信的枢纽,其他模块通过 kube-apiserver 查询或修改数据
- 只有 kube-apiserver 才能直接操作 etcd cluster
> 生产环境为了保证 kube-apiserver 的高可用,一般会部署2个以上节点,在上层做一个LB负载均衡,如haproxy. 单节点和多节点在 kube-apiserver 这一层说来没区别,所以这里只部署1个 kube-apiserver

## 2. 部署 kube-apiserver 系统服务方式
```bash
cp kubernetes-simple/master-node/kube-apiserver.service /lib/systemd/system/
systemctl enable kube-apiserver.service
systemctl start kube-apiserver
journalctl -f -u kube-apiserver
pgrep -l kube-apiserver
```
[kube-apiserver.service][1]

## 3. 重点配置说明

> [Service]
> \# 可执行文件路径
> ExecStart=/root/kubernetes-bins/kube-apiserver \\
> \# 认证授权相关
> --admission-control
> \# 非安全端口(8080)绑定的监听地址 这里表示监听所有地址
> --insecure-bind-address=0.0.0.0 \\
> \# 不使用https
> --kubelet-https=false \\
> \# k8s集群的虚拟ip的地址范围
> \# 指定 kube-apiserver 集群IP范围 16位子网掩码 其中 0.0 这2位是任意的 10.68. 是固定的
> \# 表示使用 kube-proxy 的时候 service IP 地址范围
> --service-cluster-ip-range=10.68.0.0/16 \\
> \# service的node port的端口范围限制 服务发现监听在Node上的端口范围 可以供外面的服务访问
> --service-node-port-range=20000-40000 \\
> \# kube-apiserver 是唯一可以直接操作etcd的模块
> --etcd-servers=http://192.168.182.128:2379,http://192.168.182.130:2379,http://192.168.182.129:2379 \\
> \# 日志级别 2 INFO级 搭建遇到问题调高日志级别看更多的debug日志
> --v=2

[1]: https://github.com/solozyx/k8s-cluster/tree/master/kubernetes-simple/master-node/kube-apiserver.service