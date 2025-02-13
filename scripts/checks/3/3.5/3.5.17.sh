#!/bin/bash

# 功能说明：
# 此脚本用于检查系统的tcp_fin_timeout设置，以确保TIME_WAIT的持续时间不会导致资源耗尽。

check_tcp_fin_timeout() {
    # 检查tcp_fin_timeout的设置
    local fin_timeout=$(sysctl -n net.ipv4.tcp_fin_timeout)

    # 判断tcp_fin_timeout是否设置为推荐值60秒或更少
    if [[ "$fin_timeout" -le 60 ]]; then
        echo "检测成功: tcp_fin_timeout设置正确，当前值为：$fin_timeout。"
        return 0
    else
        echo "检测失败: tcp_fin_timeout设置过高，当前值为：$fin_timeout。建议设置不大于60秒。"
        return 1
    fi
}

# 调用函数并处理返回值
if check_tcp_fin_timeout; then
    exit 0  # 检查通过，脚本成功退出
else
    exit 1  # 检查未通过，脚本以失败退出
fi

