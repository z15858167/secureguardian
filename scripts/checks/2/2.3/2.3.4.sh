#!/bin/bash

# 默认Banner路径
expected_banner_path=${1:-"/etc/issue.net"}

# SSH配置文件路径
ssh_config_file="/etc/ssh/sshd_config"

# 检查Banner配置
check_banner_configuration() {
    # 检查文件是否存在
    if [ ! -f "$ssh_config_file" ]; then
        echo "错误：SSH配置文件$ssh_config_file不存在。"
        return 1
    fi

    # 检查Banner路径配置
    if grep -qiP "^\s*Banner\s+$expected_banner_path" "$ssh_config_file"; then
        echo "检测通过：Banner正确配置为$expected_banner_path。"
        return 0
    else
        echo "检测未通过：Banner未配置为$expected_banner_path。"
        return 1
    fi
}

# 调用函数并处理返回值
if check_banner_configuration; then
    exit 0  # 检查通过，脚本成功退出
else
    exit 1  # 检查未通过
fi

