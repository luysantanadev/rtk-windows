<p align="center">
  <img src="https://avatars.githubusercontent.com/u/258253854?v=4" alt="rtk-windows - Rust Token Killer" width="500">
</p>

<p align="center">
  <strong>高性能 CLI 代理，将 LLM token 消耗降低 60-90%</strong>
</p>

<p align="center">
  <a href="https://github.com/luysantanadev/rtk-windows.git/actions"><img src="https://github.com/luysantanadev/rtk-windows.git/workflows/Security%20Check/badge.svg" alt="CI"></a>
  <a href="https://github.com/luysantanadev/rtk-windows.git/releases"><img src="https://img.shields.io/github/v/release/luysantanadev/rtk-windows" alt="Release"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="https://www.rtk-ai.app">官网</a> &bull;
  <a href="#安装">安装</a> &bull;
  <a href="docs/TROUBLESHOOTING.md">故障排除</a> &bull;
  <a href="docs/contributing/ARCHITECTURE.md">架构</a>
</p>

<p align="center">
  <a href="README.md">English</a> &bull;
  <a href="README_fr.md">Francais</a> &bull;
  <a href="README_zh.md">中文</a> &bull;
  <a href="README_ja.md">日本語</a> &bull;
  <a href="README_ko.md">한국어</a> &bull;
  <a href="README_es.md">Espanol</a>
</p>

---

rtk-windows 在命令输出到达 LLM 上下文之前进行过滤和压缩。单一 Rust 二进制文件，零依赖，<10ms 开销。

## Token 节省（30 分钟 Claude Code 会话）

| 操作 | 频率 | 标准 | rtk-windows | 节省 |
|------|------|------|-----|------|
| `ls` / `tree` | 10x | 2,000 | 400 | -80% |
| `cat` / `read` | 20x | 40,000 | 12,000 | -70% |
| `grep` / `rg` | 8x | 16,000 | 3,200 | -80% |
| `git status` | 10x | 3,000 | 600 | -80% |
| `git diff` | 5x | 10,000 | 2,500 | -75% |
| `cargo test` / `npm test` | 5x | 25,000 | 2,500 | -90% |
| **总计** | | **~118,000** | **~23,900** | **-80%** |

## 安装

### Windows binary (recommended)

```powershell
# Download rtk-windows-x86_64-pc-windows-msvc.zip from Releases
# Extract rtk-windows.exe and add it to PATH
``` 

### Cargo

```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

### 验证

```powershell
rtk-windows --version   # 应显示 "rtk-windows 0.27.x"
rtk-windows gain        # 应显示 token 节省统计
```

## 快速开始

```powershell
# 1. 为 Claude Code 安装 hook（推荐）
rtk-windows init --global

# 2. 重启 Claude Code，然后测试
git status  # 自动重写为 rtk-windows git status
```

## 工作原理

```
  没有 rtk：                                      使用 rtk：

  Claude  --git status-->  shell  -->  git         Claude  --git status-->  rtk-windows  -->  git
    ^                                   |            ^                      |          |
    |        ~2,000 tokens（原始）       |            |   ~200 tokens        | 过滤     |
    +-----------------------------------+            +------- （已过滤）-----+----------+
```

四种策略：

1. **智能过滤** - 去除噪音（注释、空白、样板代码）
2. **分组** - 聚合相似项（按目录分文件，按类型分错误）
3. **截断** - 保留相关上下文，删除冗余
4. **去重** - 合并重复日志行并计数

## 命令

### 文件
```powershell
rtk-windows ls .                        # 优化的目录树
rtk-windows read file.rs                # 智能文件读取
rtk-windows find "*.rs" .               # 紧凑的查找结果
rtk-windows grep "pattern" .            # 按文件分组的搜索结果
```

### Git
```powershell
rtk-windows git status                  # 紧凑状态
rtk-windows git log -n 10               # 单行提交
rtk-windows git diff                    # 精简 diff
rtk-windows git push                    # -> "ok main"
```

### 测试
```powershell
rtk-windows jest                        # Jest 紧凑输出
rtk-windows vitest                      # Vitest 紧凑输出
rtk-windows pytest                      # Python 测试（-90%）
rtk-windows go test                     # Go 测试（-90%）
rtk-windows test <cmd>                  # 仅显示失败（-90%）
```

### 构建 & 检查
```powershell
rtk-windows lint                        # ESLint 按规则分组
rtk-windows tsc                         # TypeScript 错误分组
rtk-windows cargo build                 # Cargo 构建（-80%）
rtk-windows ruff check                  # Python lint（-80%）
```

### 容器
```powershell
rtk-windows docker ps                   # 紧凑容器列表
rtk-windows docker logs <container>     # 去重日志
rtk-windows kubectl pods                # 紧凑 Pod 列表
```

### 分析
```powershell
rtk-windows gain                        # 节省统计
rtk-windows gain --graph                # ASCII 图表（30 天）
rtk-windows discover                    # 发现遗漏的节省机会
```

## 文档

- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - 解决常见问题
- **[INSTALL.md](INSTALL.md)** - 详细安装指南
- **[ARCHITECTURE.md](docs/contributing/ARCHITECTURE.md)** - 技术架构

## 贡献

欢迎贡献！请在 [GitHub](https://github.com/luysantanadev/rtk-windows.git) 上提交 issue 或 PR。

加入 [Discord]() 社区。

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)。

## 免责声明

详见 [DISCLAIMER.md](DISCLAIMER.md)。



