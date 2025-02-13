#!/bin/bash

# 检查是否安装了openldap-clients软件
check_openldap_clients_installed() {
    if rpm -qa | grep -q "openldap-clients"; then
        echo "LDAP客户端软件openldap-clients已安装，不符合安全规范。"
        return 1 # 表示检测不通过
    else
        echo "LDAP客户端软件openldap-clients未安装，符合安全规范。"
        return 0 # 表示检测通过
    fi
}

# 执行检查
check_openldap_clients_installed

# 捕获函数返回值
retval=$?

# 以此值退出脚本
exit $retval

