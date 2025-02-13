#!/bin/bash

# 显示帮助信息
show_usage() {
    echo "Usage: $0 [-h]"
    echo "  -h, --help               Display this help message"
}

# 解析命令行参数
parse_params() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                echo "Error: Invalid argument '$1'"
                show_usage
                exit 1
                ;;
        esac
    done
}

# 检查X11Forwarding配置
check_x11_forwarding() {
    local config_file="/etc/ssh/sshd_config"
    local x11_forwarding

    # 读取配置文件中的X11Forwarding设置
    x11_forwarding=$(grep -i "^\s*X11Forwarding" "$config_file" | awk '{print $2}')

    if [[ "$x11_forwarding" != "no" ]]; then
        echo "检测失败: X11Forwarding 未禁用，当前配置为：$x11_forwarding"
        return 1
    else
        echo "检测通过: X11Forwarding 已正确禁用。"
        return 0
    fi
}

# 主执行流程
main() {
    parse_params "$@"
    check_x11_forwarding
}

main "$@"

