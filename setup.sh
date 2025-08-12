#!/bin/bash

# 函数：克隆或更新仓库
# 参数1: 仓库URL
# 参数2: 目标路径
function clone_or_update_repository() {
    local repository_url=$1
    local target_path=$2

    if [ -d "$target_path" ]; then
        echo "更新 $target_path..."
        cd "$target_path" || exit
        git pull
    else
        echo "克隆 $repository_url 到 $target_path..."
        # --depth 1 表示只克隆最新的一次提交，加快克隆速度
#        git clone --depth 1 "$repository_url" "$target_path"
        until git clone --depth 1 "$repository_url" "$target_path"; do
            echo "Clone failed, retrying in 3 seconds..."
            sleep 3
        done
    fi
}

# 主要目录
FOLDER="./uiotos/"
INSTALL_FOLDER="${FOLDER}uiotos-v1/"

# 创建安装目录如果不存在
if [ ! -d "$FOLDER" ]; then
    echo "初次启动大概需要花15分钟，请耐心等等..."
    mkdir -p "$FOLDER"
fi

# 设置 git 缓冲区大小
git config --global http.postBuffer 524288000
# 设置 git 压缩等级
git config --global core.compression 0
# 设置 git 速度限制
git config --global http.lowSpeedLimit 0
# 设置 git 速度限制时间
git config --global http.lowSpeedTime 999999

# 克隆或更新主项目
clone_or_update_repository "https://gitee.com/page-nesting/uiotos-v1.git" "$INSTALL_FOLDER"
rm -rf "$INSTALL_FOLDER/.git"

# 克隆或更新 tools 项目
clone_or_update_repository "https://gitee.com/page-nesting/tools.git" "${FOLDER}tools/"
rm -rf "${FOLDER}tools/.git"

# 克隆或更新 storage 项目
clone_or_update_repository "https://gitee.com/page-nesting/storage.git" "${INSTALL_FOLDER}uiotos/space/storage"
rm -rf "${INSTALL_FOLDER}uiotos/space/storage/.git"

# 克隆或更新 assets 项目
clone_or_update_repository "https://gitee.com/page-nesting/assets.git" "${INSTALL_FOLDER}uiotos/space/storage/assets"
rm -rf "${INSTALL_FOLDER}uiotos/space/storage/assets/.git"

# 克隆或更新 assets-part2 项目
clone_or_update_repository "https://gitee.com/page-nesting/assets-part2.git" "${INSTALL_FOLDER}uiotos/space/storage/assets-part2"
rm -rf "${INSTALL_FOLDER}uiotos/space/storage/assets-part2/.git"

sed -i 's/hostname =.*/hostname = "m1.apifoxmock.com\/m1\/6932753-6648964-default";/' "${INSTALL_FOLDER}uiotos/space/custom/libs/iotosconfig.js"

sed -i 's/iotos_host =.*/iotos_host = "https:\/\/" + hostname;/' "${INSTALL_FOLDER}uiotos/space/custom/libs/iotosconfig.js"