## EVAL: run-dgx-spark
Created: 2026-02-11

### Overview
DGX-Spark サーバー上で DevContainer が正常に動作し，開発環境として使用可能であることを検証する．

### Capability Evals

#### CE-1: sync-devcontainer.sh の動作
- [ ] `./scripts/sync-devcontainer.sh` がエラーなく完了する
- [ ] `.devcontainer/.gitconfig` が正しく生成される
- [ ] `./scripts/sync-devcontainer.sh <dgx-spark-host>` で認証ファイルがサーバーに同期される
- [ ] サーバー側の `~/.claude/`，`~/.claude.json`，`~/.gemini/` が正しく配置される

#### CE-2: Claude Code の動作（認証不要）
- [ ] DevContainer 起動後，`claude` コマンドが利用可能である
- [ ] Mac ローカルの `~/.claude/` 設定が DevContainer 内に反映されている
- [ ] Mac ローカルの `~/.claude.json` が DevContainer 内に反映されている
- [ ] 再認証なしで Claude Code セッションを開始できる

#### CE-3: Gemini CLI の動作（認証不要）
- [ ] DevContainer 起動後，`gemini` コマンドが利用可能である
- [ ] Mac ローカルの `~/.gemini/` 設定が DevContainer 内に反映されている
- [ ] 再認証なしで Gemini セッションを開始できる

#### CE-4: Python (uv) 環境
- [ ] `uv` コマンドが利用可能である
- [ ] `uv python list` で Python バージョンが確認できる
- [ ] `uv init` でプロジェクトを初期化できる
- [ ] `uv add <package>` でパッケージをインストールできる
- [ ] `uv run python -c "print('hello')"` が正常に実行される

#### CE-5: Node.js (JavaScript) 環境
- [ ] `node --version` で Node.js バージョンが表示される
- [ ] `npm --version` で npm が利用可能である
- [ ] `node -e "console.log('hello')"` が正常に実行される
- [ ] npm パッケージのインストールが正常に動作する

### Regression Evals

#### RE-1: 既存 DevContainer 設定の互換性
- [ ] `devcontainer.json` の構文が有効である
- [ ] `Dockerfile` が正常にビルドできる
- [ ] VS Code 拡張機能が自動インストールされる

#### RE-2: シェル環境
- [ ] Zsh がデフォルトシェルとして動作する
- [ ] Oh My Zsh のプラグインが読み込まれる
- [ ] Git Delta が正常に動作する
- [ ] fzf が利用可能である

#### RE-3: Git 設定
- [ ] `.gitconfig` が正しくマウントされている
- [ ] `git` コマンドが正常に動作する
- [ ] GitHub CLI (`gh`) が利用可能である

### Success Criteria
- pass@3 > 90% for capability evals (CE-1 ~ CE-5)
- pass^3 = 100% for regression evals (RE-1 ~ RE-3)

### Test Environment
- Target Server: dgx-spark
- Base Image: Ubuntu Noble (24.04 LTS)
- Connection: VS Code Remote SSH + DevContainer

### Notes
- CE-2，CE-3 の認証テストは `sync-devcontainer.sh` によるファイル同期が前提
- DGX-Spark 固有のドライバやGPU設定はこのevalのスコープ外
