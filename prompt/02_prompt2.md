你将创建一个ansible的role，名称为semaphore，目的是对安装完成后的semaphore软件进行配置，关键要点包括： 
1. semaphore是一个执行ansible的平台，可通过openapi接口对其进行操作，api接口文档参见：https://github.com/semaphoreui/semaphore/blob/develop/api-docs.yml
2. semaphore的api地址为http://192.168.213.11:17900/api
3. 通过/auth/login的post接口登录semaphore平台，输入json对象的auth和password字段通过交互式方式获得，返回代码为204则表示登录成功
4. 通过/projects的post接口在semaphore平台中创将新的项目，输入json对象的值为：{"name": "oslab",  "alert": true,  "alert_chat": "oslab",  "max_parallel_tasks": 0}，，返回代码为201则表示创建成功
5. playbook文件中模块的名称采用FQCN方式，yes和no分别用true和false表示