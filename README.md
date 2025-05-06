# Hygen + Next.js テンプレート

このリポジトリは、[Hygen](https://www.hygen.io/) コード生成ツールを使用して Next.js プロジェクトを効率的に構築するためのテンプレート集です。

## 概要

このテンプレートを使用すると、モダンな Next.js ウェブアプリケーションの基本構造を素早く生成することができます。Material UI、フォーム処理、認証機能などが含まれており、新しいプロジェクトを迅速に開始することができます。

## テンプレート構成

リポジトリには以下の主要なディレクトリが含まれています：

- `init/`: 新規プロジェクト初期化用テンプレート

  - `components/`: React コンポーネントテンプレート（フォーム、モーダル、共通コンポーネントなど）
  - `pages/`: Next.js ページテンプレート（\_app.tsx, \_document.tsx, index.tsx, login.tsx など）
  - `styles/`: スタイル関連ファイル
  - `lib/`: ユーティリティ関数とロジック
  - `public/`: 静的ファイル
  - `root/`: プロジェクトルートのファイル（package.json, tsconfig.json, README.md など）

- `list-pu-struct/`: リスト表示とページコンポーネント構造テンプレート

  - `components/`: リスト表示用コンポーネント
  - `initials/`: 初期値設定

- `list-pu-entry/`: エントリーポイントテンプレート
  - `pages/`: エントリーページ
  - `components/`: エントリー関連コンポーネント
  - `initials/`: 初期値設定

## テンプレートの特徴

- **型安全**: TypeScript を完全サポート
- **モダン UI**: Material UI を使用したコンポーネント
- **フォーム管理**: React Hook Form との統合
- **認証機能**: 必要に応じて認証機能を追加可能（Firebase 認証対応）
- **スタイリング**: Emotion を使用した CSS-in-JS
- **状態管理**: Jotai による効率的な状態管理
- **API 連携**: OpenAPI Generator 対応

## 技術スタック

- [Next.js](https://nextjs.org/) - React フレームワーク
- [TypeScript](https://www.typescriptlang.org/) - 型安全な JavaScript
- [Material UI](https://mui.com/) - コンポーネントライブラリ
- [React Hook Form](https://react-hook-form.com/) - フォーム管理
- [Emotion](https://emotion.sh/) - CSS-in-JS ソリューション
- [Jotai](https://jotai.org/) - 状態管理
- [Axios](https://axios-http.com/) - HTTP クライアント

## Hygen の使い方

### インストール

まず、Hygen をグローバルにインストールします：

```bash
npm install -g hygen
```

または、プロジェクトローカルにインストールする場合：

```bash
npm install --save-dev hygen
```

### プロジェクト生成

新しい Next.js プロジェクトを生成するには：

```bash
# 基本的な初期化
hygen init new --name プロジェクト名

# オプションを指定して初期化
hygen init new --name プロジェクト名 --root ./my-app
```

### コンポーネント生成

プロジェクト生成後、追加のコンポーネントやページを生成できます：

```bash
# リスト表示コンポーネント生成
hygen list-pu-struct new --name 商品リスト

# エントリーページ生成
hygen list-pu-entry new --name 商品登録
```

## テンプレートのカスタマイズ

テンプレートは `.ejs.t` 形式で記述されており、必要に応じてカスタマイズすることができます。各テンプレートのフロントマターで出力先や条件付きレンダリングなどを制御できます。

例：

```
---
to: <%= rootDirectory %>/components/form/InitForm.tsx
force: true
---
// テンプレートの内容
```

- `to`: 出力先ファイルパス
- `force`: 既存ファイルを上書きするか
- 他にも `unless_exists`, `sh` などの制御が可能

## 独自テンプレートの追加方法

1. 適切なディレクトリに新しい `.ejs.t` ファイルを作成
2. フロントマターで出力先を設定
3. テンプレート内容を記述（EJS テンプレート構文を使用可能）

## ライセンス

[MIT](LICENSE)
