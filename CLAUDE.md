# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

MiriaはFlutterで開発されたMisskeyクライアントアプリです。iOS、Android、デスクトップ（Windows、macOS、Linux）をサポートしています。

## 開発コマンド

### 基本的な開発コマンド
```bash
# 依存関係の取得
fvm flutter pub get

# 開発モードで実行
fvm flutter run

# コード生成
fvm flutter pub run build_runner build

# テスト実行（カバレッジ付き）
fvm flutter test --coverage --coverage-path=~/coverage/lcov.info

# コードフォーマット
fvm dart format --output=none --set-exit-if-changed .
```

### ビルドコマンド
```bash
# iOS (リリース)
fvm flutter build ipa --no-tree-shake-icons --release --no-codesign

# Android APK
fvm flutter build apk --no-tree-shake-icons --release

# Android AAB
fvm flutter build appbundle --no-tree-shake-icons --release

# Windows
fvm flutter build windows --release

# Linux
fvm flutter build linux
```

### その他のコマンド
```bash
# アイコン生成
fvm flutter pub run flutter_launcher_icons:main

# バージョンアップ
fvm flutter pub run cider bump build --bump-build

# バージョン確認
fvm flutter pub run cider version
```

## アーキテクチャ

### 状態管理
- **Riverpod 3.0 (dev版)** を使用
- `@Riverpod`アノテーションによるcode generation
- `providers.dart`で中央集権的な依存性注入管理
- マルチアカウント対応のため`AccountContext`パターンを使用

### データレイヤー
- **Repository パターン**: `lib/repository/`配下でAPI呼び出しとローカル状態を管理
- **Freezed + json_annotation**: 全データモデルでimmutableクラスとJSON serialization
- **misskey_dart**: Misskey APIクライアント

### UIレイヤー
- **auto_route**: ルーティング管理（`app_router.dart`）
- **flutter_hooks**: React Hooksライクなウィジェット
- カスタムタイムラインUI（双方向無限スクロール対応）

### 主要な設計パターン
- **AccountContext**: 読み取り用・投稿用アカウントの分離
- **TimelineRepository**: 各種タイムライン（Home、Local、Global等）の基底クラス
- **MFMサポート**: Misskeyの独自マークアップ言語の完全サポート

## 重要な開発規則

### コード生成
新しいデータモデルやプロバイダーを追加した場合は、必ず以下を実行：
```bash
fvm flutter pub run build_runner build
```

### ルーティング
新しい画面を追加する場合：
1. `app_router.dart`にルートを追加
2. 適切なルートタイプを選択（AutoRoute、AutoDialogRoute、AutoModalRouteSheet）
3. コード生成を実行

### 状態管理
- 新機能は`@riverpod`アノテーションを使用
- 既存のChangeNotifierProviderは段階的に移行中
- マルチアカウント対応のため、必ずAccountContextを考慮

### データモデル
- 新しいモデルは必ずFreezedを使用
- JSON serialization/deserializationを考慮
- immutableな設計を維持

## プロジェクト固有事項

- **FVM使用**: Flutter 3.24.5で固定（`.fvmrc`）
- **国際化対応**: `l10n.yaml`設定、現在は日本語（規定は関西弁、ja_OJはお嬢様口調）・中国語をサポート
- **マルチプラットフォーム**: モバイル・デスクトップの両方をサポート
- **Misskeyバージョン**: v13以降のMisskey及びforkをサポート

### 最後に必ずやること

- `fvm dart analyze | grep 'error'`で致命的なエラーが出ていないかを確認する
- `fvm dart format .`でフォーマッタを適用する
- `fvm dart fix --apply`で機械的に修正可能なフォーマットを修正する
- `fvm flutter test`でテストが動作することを確認する　（やや長い時間がかかります）

<!-- code-review-graph MCP tools -->
## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes` or `query_graph` instead of Grep
- **Understanding impact**: `get_impact_radius` instead of manually tracing imports
- **Code review**: `detect_changes` + `get_review_context` instead of reading entire files
- **Finding relationships**: `query_graph` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview` + `list_communities`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool | Use when |
| ------ | ---------- |
| `detect_changes` | Reviewing code changes — gives risk-scored analysis |
| `get_review_context` | Need source snippets for review — token-efficient |
| `get_impact_radius` | Understanding blast radius of a change |
| `get_affected_flows` | Finding which execution paths are impacted |
| `query_graph` | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes` | Finding functions/classes by name or keyword |
| `get_architecture_overview` | Understanding high-level codebase structure |
| `refactor_tool` | Planning renames, finding dead code |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes` for code review.
3. Use `get_affected_flows` to understand impact.
4. Use `query_graph` pattern="tests_for" to check coverage.
