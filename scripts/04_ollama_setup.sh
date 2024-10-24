
#/sata/docker_data/models存放各个本地推理平台下载的大模型文件，每一个子目录对应一个平台
docker run -d --gpus=all -v /sata/docker_data/models/ollama:/root/.ollama -p 11434:11434 --restart always --name ollama ollama/ollama:0.3.13

#大模型下载
docker exec -it ollama ollama pull qwen2.5:14b