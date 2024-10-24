编写一个ansible的role（内容格式符合ansible-lint规范），用于docker镜像下载，其主要流程如下：
1. 确保目录/etc/systemd/system/docker.service.d存在
2. 如果设置为代理方式，则从步骤3顺序执行，否则跳转到步骤5执行
3. 创建/etc/systemd/system/docker.service.d/http-proxy.conf文件，文件的内容在三个双引号中间：
"""
[Service]
Environment="HTTP_PROXY=http://proxy_server:proxy_port"
Environment="HTTPS_PROXY=https://proxy_server:proxy_port"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
"""
将proxy_server和proxy_port分别替换为操作系统的环境变量，由用户指定
4. 创建一个handler，在创建http-proxy.conf文件的任务完成后触发，执行systemd_service模块，并重启docker服务
5. 创建docker pull任务，采用docker_image_pull模块下载镜像
6. 创建文件删除任务，如果/etc/systemd/system/docker.service.d/http-proxy.conf文件存在，就删除并触发步骤4中的handler
7. 创建调试任务，执行“systemctl show --property=Environment docker”命令，打印输出信息用户查看代理信息