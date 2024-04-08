# HowTo

Ini adalah panduan untuk membuat job probe ke blackbox-exporter. Pertama-tama masukan beberapa target ke file `template.conf`, secara default file tersebut berisi seperti berikut
```
    targets:
    ##################################################################################################
    # HERE ARE DEFINED ALL TARGETS THAT SHOULD BE MONITORED BY THE BLACKBOX EXPORTERS                #
    # THE STRUCTURE OF THIS TEMPLATE IS DESCRIBED IN THE LINE BELOW                                  #
    # <BLACKBOX_EXPORTER_IP_PORT>:_:<MODULE>:_:<JOB>:_:<SRC_NODE>:_:<TARGET_URL>:_:<DST_NAME>        #
    ##################################################################################################
    - SOURCE_NODE_IP:19115:_:YOUR_MODULE_NAME:_:YOUR_JOB_NAME:_:SOURCE_NODE_NAME:_:YOUR_TARGET_ENDPOINT:_:YOUR_TARGET_NAME
    - SOURCE_NODE_IP:19115:_:YOUR_MODULE_NAME:_:YOUR_JOB_NAME:_:SOURCE_NODE_NAME:_:YOUR_TARGET_ENDPOINT:_:YOUR_TARGET_NAME
    - SOURCE_NODE_IP:19115:_:YOUR_MODULE_NAME:_:YOUR_JOB_NAME:_:SOURCE_NODE_NAME:_:YOUR_TARGET_ENDPOINT:_:YOUR_TARGET_NAME
```

Perhatikan apa saja yang perlu direplace:
- `YOUR_MODULE_NAME`: replace dengan nama module blackbox seperti `http_2xx`, `tcp_connect` atau `https_kubeapi` sesuai konfigurasi `configmap.yaml`
- `YOUR_JOB_NAME`: replace dengan sebuah nama contohnya `blackbox-kube-apiserver` yang nantinya akan menjadi nama job
- `YOUR_TARGET_ENDPOINT`: Replace dengan URL seperti `https://10.21.0.11:6443/healthz` atau IP dan port `10.21.0.11:6443` jika menggunakan module `tcp_connect`
- `YOUR_TARGET_NAME`: replace dengan nama dari sebuah target misal nama node seperti `jh-k8s-master001`

```
    targets:
    ##################################################################################################
    # HERE ARE DEFINED ALL TARGETS THAT SHOULD BE MONITORED BY THE BLACKBOX EXPORTERS                #
    # THE STRUCTURE OF THIS TEMPLATE IS DESCRIBED IN THE LINE BELOW                                  #
    # <BLACKBOX_EXPORTER_IP_PORT>:_:<MODULE>:_:<JOB>:_:<SRC_NODE>:_:<TARGET_URL>:_:<DST_NAME>        #
    ##################################################################################################
    - SOURCE_NODE_IP:19115:_:https_kubeapi:_:blackbox-kube-apiserver:_:SOURCE_NODE_NAME:_:https://10.21.0.11:6443/healthz:_:jh-k8s-master001
    - SOURCE_NODE_IP:19115:_:https_kubeapi:_:blackbox-kube-apiserver:_:SOURCE_NODE_NAME:_:https://10.21.0.12:6443/healthz:_:jh-k8s-master002
    - SOURCE_NODE_IP:19115:_:https_kubeapi:_:blackbox-kube-apiserver:_:SOURCE_NODE_NAME:_:https://10.21.0.13:6443/healthz:_:jh-k8s-master003
```

Setelah selesai menambahkan target selanjutnya adalah menjalankan script dari file `script.sh` yang nantinya akan membuat file-file manifest dengan nama node seperti berikut
```
~/victoria-metrics-operator/blackbox-exporter/probe# bash script.sh
~/victoria-metrics-operator/blackbox-exporter/probe# ls -l
total 44
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-master001.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-master002.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-master003.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-worker001.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-worker002.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-worker003.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-worker004.yaml
-rw-r--r-- 1 root root 2819 Jul 24 03:35 jh-k8s-worker005.yaml
-rw-r--r-- 1 root root  224 Jul 24 03:35 list.txt
-rw-r--r-- 1 root root 1037 Jul 24 03:35 script.sh
-rw-r--r-- 1 root root 2831 Jul 24 03:13 template.conf
```

`SOURCE_NODE_IP` dan `SOURCE_NODE_NAME` akan disesuaikan oleh script tersebut jadi setelah itu silahkan review filenya kemudian apply
```
kubectl apply -f blackbox-exporter/probe/
```

Verifikasi
```
# kubectl -n monitoring-system get VMStaticScrape
NAME                        AGE
blackbox-jh-k8s-master001   22m
blackbox-jh-k8s-master002   22m
blackbox-jh-k8s-master003   22m
blackbox-jh-k8s-worker001   22m
blackbox-jh-k8s-worker002   22m
blackbox-jh-k8s-worker003   22m
blackbox-jh-k8s-worker004   22m
blackbox-jh-k8s-worker005   22m
```
