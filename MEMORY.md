# Memory

## 身份
- GitHub: TurinFohlen
- Token: （已通过 mcporter 配置 GitHub MCP）

## 平台限制
- ⚠️ 容器会话太长会崩（上下文限制），大操作后记得备份
- 备份：zip 打包 + GitHub push 双重保险

## 架构
- 出口：Termux (Android) + TunnelProxy (Elixir) + frp → frp.freefrp.net
- FreeFRP: 11095(HTTP文件/上传/代理) / 11096(PTY Shell)
- GitHub API ✅ / raw.githubusercontent.com ❌ / PyPI ❌ / npm ❌

## 工具链（2026-04-19 恢复）
- Go 1.26.2 ✅ / Java 21 ✅ / Maven 3.9.6 ✅
- Erlang OTP 28 ✅ / Elixir 1.19.x ✅ / Ruby 3.2.0 ✅ / Lua 5.4.4 ✅
- Node.js v22.17 ✅ / Python 3.11.2 ✅ / GCC 12.2.0 ✅
- Rust 1.95.0 ✅
- 环境变量：. /workspace/.toolchain_env

## 核心项目

### TunnelProxy（用户 Termux 端）
- GitHub: https://github.com/TurinFohlen/tunnel_proxy
- 功能：HTTP文件服务 + PTY Shell + 文件上传
- 启动：`cd /sdcard/Download/tunnel_proxy && mix run --no-halt`
- frpc 映射：8080→11095(HTTP) / 27417→11096(PTY)

### tunnel-proxy Skill（沙盒端）
- GitHub: https://github.com/TurinFohlen/tunnel-proxy
- Skill 路径：/userspace/skills/tunnel-proxy/
- 脚本：tunnel_exec.py / tunnel_upload.py / tunnel_download.py / tunnel_proxy.py

### openclaw-toolchain
- GitHub: https://github.com/TurinFohlen/openclaw-toolchain
- toolchain_v2.tar.gz：完整工具链备份

### base65536-skill
- GitHub: https://github.com/TurinFohlen/base65536-skill

## 安全注意
- MEMORY.md 不写任何 Token / API Key / 代理地址
- Token 统一放 ~/.openclaw/ 或 mcporter 配置，不进 Git
