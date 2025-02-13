#!/bin/bash

# 功能说明：
# 此脚本用于检查系统是否已配置为忽略所有ICMP请求。这有助于提高系统的安全性，防止通过ICMP请求探测系统。

check_icmp_requests_ignoring() {
    # 检查ICMP请求忽略的配置
    local ignore_all=$(sysctl -n net.ipv4.icmp_echo_ignore_all)

    # 确认配置是否为1，即忽略所有ICMP请求
    if [ "$ignore_all" -eq 1 ]; then
        echo "检测成功: 系统已配置为忽略所有ICMP请求。"
        return 0
    else
        echo "检测失败: 系统未配置为忽略所有ICMP请求。"
        return 1
    fi
}

# 调用函数并处理返回值
if check_icmp_requests_ignoring; then
    exit 0  # 检查通过，脚本成功退出
else
    exit 1  # 检查未通过，脚本以失败退出
fi

