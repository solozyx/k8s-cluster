/root/kubernetes-bins/etcd --name node2 \
          --initial-advertise-peer-urls http://192.168.182.130:2380 \
          --listen-peer-urls http://192.168.182.130:2380 \
          --listen-client-urls http://192.168.182.130:2379,http://127.0.0.1:2379 \
          --advertise-client-urls http://192.168.182.130:2379 \
          --initial-cluster-token etcd-cluster \
          --initial-cluster node1=http://192.168.182.128:2380,node2=http://192.168.182.130:2380,node3=http://192.168.182.129:2380 \
          --initial-cluster-state new \
          --data-dir=/var/lib/etcd >> ./etcd-node2.log 2>&1 &