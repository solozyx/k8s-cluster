# 在k8s集群任意节点部署 kubectl 工具 这里在 k8s-cluster master 主节点部署 kubectl

| 系统类型 | IP地址 | 节点角色 | CPU | Memory | Hostname |
| :------: | :--------: | :-------: | :-----: | :---------: | :-----: |
| centos7 64位 | 192.168.182.128 | k8s master |   2    | 2G | node1 |

## 1. kubectl
- kubectl 是 kubernetes 的命令行工具,提供了大量的命令,方便管理 kubernetes 集群中的各种功能.


## 2. 部署 kubectl
使用 kubectl 的第一步是配置 kubernetes 集群和认证方式:
- cluster信息 : kube-apiserver 地址
- 用户信息 : 用户名 密码 密钥
- context : cluster + 用户信息 + Namespace 的组合

> 这里先不设置认证授权安全相关的内容,只需要设置 kube-apiserver 和 context 

```bash
# 指定 kube-apiserver 地址
kubectl config set-cluster kubernetes  --server=http://192.168.174.130:8080

# 设置context,指定cluster
kubectl config set-context kubernetes --cluster=kubernetes

# 选择默认context
kubectl config use-context kubernetes

cat ~/.kube/config 

kubectl get pods
```

通过这些设置最终目的是生成了一个配置文件: ` ~/.kube/config ` 可以手写 或 复制一个文件就不需要上面的命令

```
[root@CentOS ~]# cd kubernetes-bins/
[root@CentOS kubernetes-bins]# ls
calico  calicoctl  calico-ipam  etcd  etcdctl  kube-apiserver  kube-controller-manager  kubectl  
kubelet  kube-proxy  kube-scheduler  loopback  nohup.out  VERSION.md

[root@CentOS kubernetes-bins]# ./kubectl config set-cluster kubernetes  --server=http://192.168.174.130:8080 
Cluster "kubernetes" set.

[root@CentOS kubernetes-bins]# ./kubectl config set-context kubernetes --cluster=kubernetes
Context "kubernetes" created.

[root@CentOS kubernetes-bins]# ./kubectl config use-context kubernetes
Switched to context "kubernetes".

[root@CentOS kubernetes-bins]# cat ~/.kube/config 
apiVersion: v1
clusters:
- cluster:
    server: http://192.168.174.130:8080
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: ""
  name: kubernetes
current-context: kubernetes
kind: Config
preferences: {}
users: []

[root@CentOS kubernetes-bins]# ./kubectl get pods
No resources found.
[root@CentOS kubernetes-bins]# 
```
