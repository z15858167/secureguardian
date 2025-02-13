#!/bin/bash

# 功能说明：
# 本函数用于检查系统是否禁止响应ICMP广播报文。
# ICMP广播报文可能导致网络攻击，如反射式拒绝服务攻击。
# 通过检查系统内核参数net.ipv4.icmp_echo_ignore_broadcasts，确认其值为1，确保系统安全。

check_icmp_broadcasts() {
    # 读取内核参数
    local ignore_broadcasts=$(sysctl -n net.ipv4.icmp_echo_ignore_broadcasts)
    
    # 检查参数值是否为1
    if [[ "$ignore_broadcasts" == "1" ]]; then
        echo "检测成功: 系统已禁止响应ICMP广播报文。"
        return 0
    else
        echo "检测失败: 系统未正确配置以禁止响应ICMP广播报文。"
        return 1
    fi
}

# 调用检查函数并处理返回值
if check_icmp_broadcasts; then
    exit 0  # 检查通过，脚本成功退出
else
    exit 1  # 检查未通过，脚本以失败退出
fi

