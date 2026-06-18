# VT 定制说明

## 改动目录

- Docker 发布：增加 Docker Hub 上传流程，并将构建基础环境切换到 Ubuntu 24.04。
- 用户头像：支持用户头像使用完整的 `http` 或 `https` 绝对地址。
  + `UPDATE "public"."md_members" SET "avatar" = 'https://example.com/abc.jpg' WHERE "member_id" = ?`
- 首页布局：优化首页 hero、卡片和知识目录区域的展示宽度与紧凑度。
- 首页推荐区：通过 Book 的 `home_pin` 字段控制公开知识库是否显示在首页推荐区。
- 私有知识库标识：首页“知识库目录”中私有项目会在名称旁显示小锁图标。
- 页面水印：增加可配置的页面水印能力。
- 自定义脚本：增加站点访问统计或埋点脚本配置。
- 文章页快捷键：站内搜索不再拦截 `Ctrl+F` / `Cmd+F`，保留浏览器原生页面查找。
- Release 流程：增加 GitHub Actions release 工作流。

## 站内中转路径

以 `/s/` 开头的路径约定为站内中转路径，用于在页面上暴露稳定、可读的站内地址，再由服务端根据配置解析到实际目标内容。

### 关于入口

`/s/about` 是顶部导航“关于”的中转路径。

- 当系统配置 `site_about_url` 为空时，顶部导航不显示“关于”，直接访问 `/s/about` 返回 404。
- 当系统配置 `site_about_url` 不为空时，顶部导航显示“关于”，页面链接为 `/s/about`。
- 当 `site_about_url` 指向站内文章路径时，访问 `/s/about` 会直接渲染对应文章且地址栏保持 `/s/about`。
- `site_about_url` 示例：`/blog-3.html`。

## 首页推荐区

首页推荐区由 Book 的 `home_pin` 字段控制，仅展示公开项目且 `home_pin = 't'` 的 Book，最多展示 4 个。

- 项目设置页提供“首页推荐”开关，保存值为 `t/f`。
- 推荐卡片标题使用 `book_name`，展示时自动去掉 `数字 + -` 前缀，例如 `03-开发技术` 显示为 `开发技术`。
- 推荐卡片描述继续使用项目描述字段。
- 下方“知识库目录”仍显示原始 `book_name`，不做标题处理。

## 文章页快捷键

文章阅读页不拦截带 `Ctrl` 或 `Cmd` 修饰键的键盘事件，避免覆盖浏览器自带的页面查找。

- `Ctrl+F` / `Cmd+F`：使用浏览器原生查找。
- `F`：打开项目内搜索面板并聚焦搜索框。
- `Esc`：关闭项目内搜索面板，回到阅读视图。

## 部署排查

### Docker 挂载目录

生产环境尽量不要挂载整个 `/mindoc/conf`、`/mindoc/static`、`/mindoc/views` 或 `/mindoc/database`。

- `/mindoc/static` 和 `/mindoc/views` 属于镜像发布内容，挂载宿主机目录会导致升级镜像后仍使用旧静态资源或旧模板。
- `/mindoc/conf` 包含语言包等镜像发布内容，挂载宿主机目录会覆盖镜像内的新文件。发布新版本后如果宿主机旧语言包缺少新增字段，可能出现同一页面大部分菜单是中文、单个菜单回退为英文的情况。
- 使用 PostgreSQL 等外部数据库时，不需要挂载 `/mindoc/database`。
- 一般只保留业务数据目录，例如 `/mindoc/uploads`；如需持久化日志或运行态文件，可保留 `/mindoc/runtime`。

推荐挂载示例：

```yaml
volumes:
  - /opt/docker_data/minDoc/uploads:/mindoc/uploads
  - /opt/docker_data/minDoc/runtime:/mindoc/runtime
```

当前 Dockerfile 不声明 `VOLUME`，需要持久化的目录统一由 `docker run -v` 或 `docker-compose.yml` 显式指定，避免镜像自动创建匿名 volume。

如果从旧镜像升级，历史容器可能已经存在 `/mindoc/conf` 匿名 volume。发布新版本时可刷新匿名 volume，确保 `/mindoc/conf/lang` 使用新镜像内的语言包：

```bash
docker compose up -d --force-recreate --renew-anon-volumes
```

如果不是使用 compose，而是手动 `docker run`，更新容器时删除旧容器及匿名 volume：

```bash
docker rm -f -v mindoc
```

语言包异常时可先检查运行容器内的实际文件：

```bash
docker exec mindoc grep -n '^about[[:space:]]*=' /mindoc/conf/lang/zh-cn.ini
docker exec mindoc grep -n '^about[[:space:]]*=' /mindoc/__default_assets__/conf/lang/zh-cn.ini
```
