<p align="center">
  <strong>rtk-windows — Windows向け高性能CLIプロキシ（LLMトークン消費 60-90% 削減）</strong>
</p>

<p align="center">
  <a href="https://github.com/luysantanadev/rtk-windows.git/actions"><img src="https://img.shields.io/github/actions/workflow/status/luysantanadev/rtk-windows/ci.yml" alt="CI"></a>
  <a href="https://github.com/luysantanadev/rtk-windows.git/releases"><img src="https://img.shields.io/github/v/release/luysantanadev/rtk-windows" alt="Release"></a>
  <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License: Apache-2.0"></a>
</p>

<p align="center">
  <a href="#インストール">インストール</a> &bull;
  <a href="#インストール">インストール</a> &bull;
  <a href="docs/TROUBLESHOOTING.md">トラブルシューティング</a> &bull;
  <a href="docs/contributing/ARCHITECTURE.md">アーキテクチャ</a>
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

**rtk-windows** は Windows 専用フォークで、コマンド出力を LLM コンテキストに到達する前にフィルタリング・圧縮します。単一の Rust バイナリ、依存関係ゼロ、オーバーヘッド 10ms 未満。

> **Windows のみ:** このプロジェクトは Windows 10/11 と PowerShell Core または Command Prompt に限定されています。
>
> **独立フォーク:** これは Windows 重視の独立実装です。いかなるアップストリームプロジェクトとも提携していません。

## トークン節約（30分の Claude Code セッション）

| 操作 | 頻度 | 標準 | rtk-windows | 節約 |
|------|------|------|-----|------|
| `ls` / `tree` | 10x | 2,000 | 400 | -80% |
| `cat` / `read` | 20x | 40,000 | 12,000 | -70% |
| `grep` / `rg` | 8x | 16,000 | 3,200 | -80% |
| `git status` | 10x | 3,000 | 600 | -80% |
| `cargo test` / `npm test` | 5x | 25,000 | 2,500 | -90% |
| **合計** | | **~118,000** | **~23,900** | **-80%** |

## インストール

### Windows binary (recommended)

```powershell
# Download rtk-windows-x86_64-pc-windows-msvc.zip from Releases
# Extract rtk-windows.exe and add it to PATH
``` 

### Cargo

```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

### 確認

```powershell
rtk-windows --version   # "rtk-windows 0.27.x" と表示されるはず
rtk-windows gain        # トークン節約統計が表示されるはず
```

## クイックスタート

```powershell
# 1. Claude Code 用フックをインストール（推奨）
rtk-windows init --global

# 2. Claude Code を再起動してテスト
git status  # 自動的に rtk-windows git status に書き換え
```

## 仕組み

```
  rtk-windows なし：                                       rtk-windows あり：

  Claude  --git status-->  shell  -->  git          Claude  --git status-->  rtk-windows  -->  git
    ^                                   |             ^                      |          |
    |        ~2,000 tokens（生出力）     |             |   ~200 tokens        | フィルタ |
    +-----------------------------------+             +------- （圧縮済）----+----------+
```

4つの戦略：

1. **スマートフィルタリング** - ノイズを除去（コメント、空白、ボイラープレート）
2. **グルーピング** - 類似項目を集約（ディレクトリ別ファイル、タイプ別エラー）
3. **トランケーション** - 関連コンテキストを保持、冗長性をカット
4. **重複排除** - 繰り返しログ行をカウント付きで統合

## コマンド

### ファイル
```powershell
rtk-windows ls .                        # 最適化されたディレクトリツリー
rtk-windows read file.rs                # スマートファイル読み取り
rtk-windows find "*.rs" .               # コンパクトな検索結果
rtk-windows grep "pattern" .            # ファイル別グループ化検索
```

### Git
```powershell
rtk-windows git status                  # コンパクトなステータス
rtk-windows git log -n 10               # 1行コミット
rtk-windows git diff                    # 圧縮された diff
rtk-windows git push                    # -> "ok main"
```

### テスト
```powershell
rtk-windows jest                        # Jest コンパクト
rtk-windows vitest                      # Vitest コンパクト
rtk-windows pytest                      # Python テスト（-90%）
rtk-windows go test                     # Go テスト（-90%）
rtk-windows test <cmd>                  # 失敗のみ表示（-90%）
```

### ビルド & リント
```powershell
rtk-windows lint                        # ESLint ルール別グループ化
rtk-windows tsc                         # TypeScript エラーグループ化
rtk-windows cargo build                 # Cargo ビルド（-80%）
rtk-windows ruff check                  # Python リント（-80%）
```

### 分析
```powershell
rtk-windows gain                        # 節約統計
rtk-windows gain --graph                # ASCII グラフ（30日間）
rtk-windows discover                    # 見逃した節約機会を発見
```

## ドキュメント

- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - よくある問題の解決
- **[INSTALL.md](INSTALL.md)** - 詳細インストールガイド
- **[ARCHITECTURE.md](docs/contributing/ARCHITECTURE.md)** - 技術アーキテクチャ

## コミュニティ

これらは Windows 中心の独立フォークです。エンタープライズまたはカスタムデプロイメントについては [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

## ライセンス

Apache 2.0 ライセンス - 詳しいことは [LICENSE](LICENSE) を参照。

## 免責事項

詳細は [DISCLAIMER.md](DISCLAIMER.md) を参照。



