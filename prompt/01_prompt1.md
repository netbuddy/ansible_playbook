你将创建一个ansible的role，名称为semaphore，目的是将定制后的semaphore软件部署到docker容器中，提供的输入文件为docker_compose.yml和.env.example，其内容分别在三个引号中。关键要点包括：
1. .env.example中的每一个配置项通过交互方式让用户输入值，文件中配置项的值作为默认值，用户回车即可确认，配置项全部设置完成后生成.env文件
2. 将.env和docker_compose.yml上传到目标主机的~/docker_compose_yml/semaphore/目录，如果该目录不存在则创建
3. playbook文件中的hosts设置为servers，模块的名称采用FQCN方式
4. docker容器以守护进程方式运行
5. 如果只通过playbook的内嵌模块实现起来有技术难度，可考虑结合shell脚本实现

docker_compose.yml文件：
"""
version: '3'
services:
  semaphore:
    ports:
      - "${LOCAL_PORT}:3000"
    image: semaphoreui/semaphore:latest
    hostname: semaphore
    restart: always
    user: "${UID}:${GID}"
    environment:
      SEMAPHORE_DB_DIALECT: bolt
      SEMAPHORE_ADMIN_PASSWORD: "${ADMIN_PASSWORD}"
      SEMAPHORE_ADMIN_NAME: "${ADMIN_NAME}"
      SEMAPHORE_ADMIN_EMAIL: admin@localhost
      SEMAPHORE_ADMIN: admin
      TZ: Asia/Shanghai
    volumes:
      - semaphore_config:/etc/semaphore
      - semaphore_db:/var/lib/semaphore
      - "${PLAYBOOK_PATH}:/playbook"
      - "${SSH_PATH}:~/.ssh"

volumes:
  semaphore_config:
  semaphore_db:
"""

.env.example文件：
"""
LOCAL_PORT=17900
ADMIN_NAME=admin
ADMIN_PASSWORD=87ed96ba-1e96-4c88-8145-77c8feb803f6
PLAYBOOK_PATH=~/docker_data/semaphore/playbook
SSH_PATH=~/docker_data/semaphore/.ssh
"""