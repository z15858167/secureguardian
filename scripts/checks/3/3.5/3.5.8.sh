#!/bin/bash

# 功能说明：
# 此脚本用于检查系统是否禁止转发ICMP重定向报文。这有助于防止潜在的网络攻击，提高系统的安全性。

check_icmp_redirects_forwarding() {
    # 检查系统内核参数
    local all_send_redirects=$(sysctl -n net.ipv4.conf.all.send_redirects)
    local default_send_redirects=$(sysctl -n net.ipv4.conf.default.send_redirects)

    # 检查是否都设置为0，禁止转发ICMP重定向
    if [[ "$all_send_redirects" == "0" && "$default_send_redirects" == "0" ]]; then
        echo "检测成功: 系统已正确配置为不转发ICMP重定向报文。"
        return 0
    else
        echo "检测失败: 系统的ICMP重定向转发设置未正确配置。"
        return 1
    fi
}

# 调用检查函数并处理返回值
if check_icmp_redirects_forwarding; then
    exit 0  # 检查通过，脚本成功退出
else
    exit 1  # 检查未通过，脚本以失败退出
fi

