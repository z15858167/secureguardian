#!/bin/bash

# 初始化例外用户组名数组
exceptions=()

# 解析命令行参数
while getopts "e:" opt; do
  case ${opt} in
    e )
      IFS=',' read -r -a exceptions <<< "${OPTARG}"
      ;;
    \? )
      echo "使用方法: $0 [-e 组名1,组名2,...]"
      exit 1
      ;;
  esac
done

# 检查用户组名唯一性的函数
check_groupname_uniqueness() {
  # 检索 /etc/group 中的组名并检查是否唯一
  local duplicate_groupnames=$(awk -F':' '{print $1}' /etc/group | sort | uniq -d)

  for groupname in $duplicate_groupnames; do
    # 检查组名是否在例外列表中
    if printf '%s\n' "${exceptions[@]}" | grep -q "^$groupname$"; then
      # 如果组名在例外列表中，忽略这个组名
      echo "例外用户组名 $groupname 被忽略。"
    else
      # 如果组名不在例外列表中，报告重复组名
      echo "检测失败: 用户组名 $groupname 不唯一。"
      return 1
    fi
  done

  echo "检测成功: 所有用户组名唯一。"
  return 0
}

# 调用检查函数
if check_groupname_uniqueness; then
  exit 0
else
  exit 1
fi

