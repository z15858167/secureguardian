#!/bin/bash

# 功能说明：
# 本函数用于检查和确保内核SMEP（Supervisor Mode Execution Prevention）特性已启用。
# SMEP特性可以防止内核执行用户空间代码，从而增强系统安全性。
# 函数检查CPU标志以确定是否支持SMEP，并检查系统启动参数确认SMEP是否已启用。

check_smep() {
    # 检查CPU是否支持SMEP
    if grep -qw smep /proc/cpuinfo; then
        echo "检测到CPU支持SMEP。"
        # 检查是否存在禁用SMEP的启动参数
        if grep -qi "nosmep" /proc/cmdline; then
            echo "检测失败: SMEP已在系统启动参数中被禁用。"
            return 1
        else
            echo "检测成功: SMEP已启用且正在运行。"
            return 0
        fi
    else
        echo "检测忽略: 当前CPU不支持SMEP。"
        return 0
    fi
}

# 调用检查函数并处理返回值
if check_smep; then
    exit 0  # SMEP检查通过，脚本成功退出
else
    exit 1  # SMEP检查未通过，脚本以失败退出
fi

