#!/bin/bash

# 初始化例外组ID数组
EXCEPTION_GROUP_IDS=()

# 解析命令行参数
while getopts 'e:' OPTION; do
  case "$OPTION" in
    e)
      IFS=',' read -r -a EXCEPTION_GROUP_IDS <<< "$OPTARG"
      ;;
    *)
      echo "Usage: $0 [-e exception_group_ids]"
      echo "Example: $0 -e 100,101"
      exit 1
      ;;
  esac
done

# 检查/etc/passwd中的组是否都存在于/etc/group中
check_group_existence() {
    # 提取/etc/passwd中的所有组ID
    group_ids_in_passwd=$(awk -F ':' '{print $4}' /etc/passwd | sort -u)

    # 提取/etc/group中的所有组ID
    group_ids_in_group=$(awk -F ':' '{print $3}' /etc/group | sort -u)

    for gid in $group_ids_in_passwd; do
        if [[ " ${EXCEPTION_GROUP_IDS[*]} " =~ " ${gid} " ]]; then
            echo "跳过例外组ID: $gid"
            continue
        fi

        if ! grep -q -w "^$gid$" <<< "$group_ids_in_group"; then
            echo "检测失败: /etc/passwd中的组ID $gid 在/etc/group中不存在。"
            return 1
        fi
    done

    echo "检测成功: /etc/passwd中的所有组都在/etc/group中存在。"
    return 0
}

# 执行检查函数
if check_group_existence; then
    exit 0
else
    exit 1
fi


