#!/bin/bash

# 定义要检查的协议
PROTOCOLS="tcp,udp,icmp"

# 检查 nftables 配置
check_nftables_config() {
    local ruleset=$(nft list ruleset)
    local failed=0

    IFS=',' read -ra PROTOCOL_ARRAY <<< "$PROTOCOLS"
    for protocol in "${PROTOCOL_ARRAY[@]}"; do
        # 检查input链
        local input_match=$(echo "$ruleset" | awk -v proto="$protocol" '
            /chain input/ {recording=1}
            recording && /}/ {recording=0}
            recording && $0 ~ "ip protocol " proto " ct state +.*established.*accept" {found=1; exit}
            END {if (found) print "yes"; else print "no"}')

        # 检查output链
        local output_match=$(echo "$ruleset" | awk -v proto="$protocol" '
            /chain output/ {recording=1}
            recording && /}/ {recording=0}
            recording && $0 ~ "ip protocol " proto " ct state +.*(established|related|new).*accept" {found=1; exit}
            END {if (found) print "yes"; else print "no"}')

        if [ "$input_match" == "yes" ] && [ "$output_match" == "yes" ]; then
            echo "协议 $protocol 的input和output链已正确配置关联状态策略。"
        else
            echo "检测失败: 协议 $protocol 的input或output链未正确配置关联状态策略。"
            failed=1
        fi
    done

    return $failed
}

# 执行检查
if check_nftables_config; then
    echo "检测成功:所有指定协议的链关联状态策略检查通过。"
    exit 0
else
    echo "检测失败:至少一个指定协议的链关联状态策略检查未通过。"
    exit 1
fi

