#!/bin/bash

# 函数：检查DNS服务（named）是否已启用
check_dns_service_enabled() {
    # 检查DNS服务（named）是否已启用
    if systemctl is-enabled named &>/dev/null; then
        echo "DNS服务（named）已启用。如果不需要作为DNS服务器，请考虑禁用它。"
        return 1 # 如果服务已启用，则返回1
    else
        echo "DNS服务（named）已禁用或未安装。"
        return 0 # 如果服务已禁用或未安装，则返回0
    fi
}

# 调用函数
check_dns_service_enabled

# 捕获函数返回值
retval=$?

exit $retval
