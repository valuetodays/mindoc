#!/bin/bash
set -eux

# 默认资源
if [ ! -d "/mindoc/conf" ]; then mkdir -p "/mindoc/conf" ; fi
if [[ -z "$(ls -A -- "/mindoc/conf")" ]] ; then cp -r "/mindoc/__default_assets__/conf" "/mindoc/" ; fi

if [ ! -d "/mindoc/static" ]; then mkdir -p "/mindoc/static" ; fi
if [[ -z "$(ls -A -- "/mindoc/static")" ]] ; then cp -r "/mindoc/__default_assets__/static" "/mindoc/" ; fi

if [ ! -d "/mindoc/views" ]; then mkdir -p "/mindoc/views" ; fi
if [[ -z "$(ls -A -- "/mindoc/views")" ]] ; then cp -r "/mindoc/__default_assets__/views" "/mindoc/" ; fi

refresh_view_if_missing_marker() {
    local file="$1"
    local marker="$2"
    local target="/mindoc/views/$file"
    local source="/mindoc/__default_assets__/views/$file"

    if [ -f "$source" ] && { [ ! -f "$target" ] || ! grep -q "$marker" "$target" ; }; then
        if [ -f "$target" ]; then
            cp "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
        fi
        mkdir -p "$(dirname "$target")"
        cp "$source" "$target"
    fi
}

refresh_view_if_missing_marker "manager/setting.tpl" "watermark_variable_label"
refresh_view_if_missing_marker "widgets/footer.tpl" "mindoc-watermark"
refresh_view_if_missing_marker "document/default_read.tpl" "mindoc-watermark"
refresh_view_if_missing_marker "document/cherry_read.tpl" "mindoc-watermark"

refresh_lang_if_missing_marker() {
    local file="$1"
    local marker="$2"
    local target="/mindoc/conf/lang/$file"
    local source="/mindoc/__default_assets__/conf/lang/$file"

    if [ -f "$source" ] && { [ ! -f "$target" ] || ! grep -q "$marker" "$target" ; }; then
        if [ -f "$target" ]; then
            cp "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
        fi
        mkdir -p "$(dirname "$target")"
        cp "$source" "$target"
    fi
}

refresh_lang_if_missing_marker "zh-cn.ini" "watermark_variable_tips"
refresh_lang_if_missing_marker "en-us.ini" "watermark_variable_tips"
refresh_lang_if_missing_marker "ru-ru.ini" "watermark_variable_tips"

if [ ! -d "/mindoc/uploads" ]; then mkdir -p "/mindoc/uploads" ; fi
if [[ -z "$(ls -A -- "/mindoc/uploads")" ]] ; then cp -r "/mindoc/__default_assets__/uploads" "/mindoc/" ; fi

# 如果配置文件不存在就复制
cp --no-clobber /mindoc/conf/app.conf.example /mindoc/conf/app.conf

# 数据库等初始化
/mindoc/mindoc_linux_amd64 install

# 运行
/mindoc/mindoc_linux_amd64

# # Debug Dockerfile
# while [ 1 ]
# do
#     echo "log ..."
#     sleep 5s
# done
