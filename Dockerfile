# 使用官方的Node.js基础镜像
FROM docker.xuanyuan.me/library/node:16.20.2-bookworm

# 安装必要的工具
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制本地克隆好的项目文件到工作目录
COPY ./uiotos/uiotos-v1/uiotos /uiotos

# 设置工作目录到服务器目录
WORKDIR /uiotos/server/

# 暴露端口
EXPOSE 8999

# 启动 Node.js 服务器
CMD ["node", "server.js"]

