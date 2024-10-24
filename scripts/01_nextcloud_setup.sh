#!/bin/bash

# 创建项目目录
mkdir -p nextcloud && cd nextcloud

# 创建 docker-compose.yml 文件
cat << EOF > docker-compose.yml
services:
  db:
    image: mariadb:10.11
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=nextcloud
      - MYSQL_PASSWORD=nextcloud
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  redis:
    image: redis:alpine
    restart: always

  app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    depends_on:
      - redis
      - db
    volumes:
      - /sata/docker_data/netcloud_dev:/var/www/html
      - /sata/docker_data/file_repo:/var/www/html/data
    environment:
      - MYSQL_PASSWORD=nextcloud
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
    extra_hosts:
      host.docker.internal: host-gateway

volumes:
  nextcloud:
  db:
EOF

# 启动 Docker 容器
docker-compose up -d