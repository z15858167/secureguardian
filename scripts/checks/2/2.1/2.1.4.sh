#!/bin/bash

# 默认例外用户列表
EXCEPTIONS=("root")

# 解析命令行参数，允许用户通过 -e 参数添加额外的例外账号
while getopts ":e:" opt; do
  case ${opt} in
    e )
      IFS=',' read -ra ADDR <<< "${OPTARG}"
      for i in "${ADDR[@]}"; do
          EXCEPTIONS+=("$i")
      done
      ;;
    h )
      echo "使用方法: $0 [-e 账号列表]"
      exit 1
      ;;
  esac
done

check_uid_zero_accounts() {
  # 检测非root且UID为0的账号
  local uid_zero_accounts=$(awk -F':' '{if ($3 == 0) print $1}' /etc/passwd)

  for account in $uid_zero_accounts; do
    # 检查账号是否在例外列表中
    if [[ ! " ${EXCEPTIONS[@]} " =~ " ${account} " ]]; then
      echo "检测不成功: 账号 ${account} 的UID为0，不应存在非root的UID为0账号。"
      return 1
    fi
  done

  echo "检测成功: 除例外账号外，没有发现非root的UID为0的账号。"
  return 0
}

# 调用函数并处理返回值
if check_uid_zero_accounts; then
  exit 0
else
  exit 1
fi

