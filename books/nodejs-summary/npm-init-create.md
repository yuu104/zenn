---
title: "「npx create-xxx」で始めるnpmパッケージを自作したい"
---

## はじめに

`create-next-app` や `npm init playwright` のような便利なツールを使ったことはありませんか？
これらのコマンドは、たった数秒でプロジェクトをセットアップし、開発の第一歩を大きく加速させてくれます。
そして、その裏側を「どうやって作られているのだろう？」と考えたことがある方もいるのではないでしょうか。

本記事では、そんな「`npx create-xxx` で始めるnpmパッケージの自作方法」について私が学んだ内容を言語化したものです。
以下の内容について、具体例となるシンプルなパッケージを自作を通して解説します。

1. `npx create-xxx` 形式の初期化コマンドを作成する方法
2. プロジェクト内で利用できるCLIツールの設計と実装
3. インポートして利用する関数を提供する方法
4. 作成したnpmパッケージを公開する方法


## 今回自作するnpmパッケージについて

文字列をリバースするシンプルなnpmパッケージ「`rext`」を作成します。
このパッケージは、以下の特徴を備えています。
- **`npx create-xxx` による初期化コマンド**
  プロジェクトを簡単にセットアップできるコマンドを提供します。
  必要なフォルダやファイルを自動生成し、初期化後すぐにCLIツールやライブラリ機能を利用可能です。
- **CLIツールとしての利用**
  プロジェクト内で実行できるコマンドを提供します。
- **ライブラリとしての利用**
  関数をインポートしてプログラム内で利用可能です。
- **TypeScriptに対応**
  型定義を提供し、開発者体験を向上させます。


### 提供する機能
1. **初期化コマンド: `npx create-rext [プロジェクト名]`**
   このコマンドを実行することで、以下のフォルダ構造を持つプロジェクトを自動生成されます。
   ```text
   <プロジェクト>
   ├── package.json              # プロジェクトの設定ファイル
   ├── texts/                    # 入力データ用フォルダ
   │   └── sample.json           # サンプルデータ
   ├── reverse-output/           # リバース結果を保存するフォルダ
   │   └── .gitkeep              # 空フォルダをGitで管理
   ├── tsconfig.json             # TypeScriptの設定ファイル
   └── node_modules/             # npm依存関係
   ```
   ```json: sample.json
   {
     "texts": ["hello", "world", "typescript"]
   }
   ```
   初期化後、すぐに CLI を使った操作やライブラリの利用を始められます。

2. **CLI ツール**
   プロジェクト内で動作する CLI ツールとして、以下の機能を提供します。
   - **`rext reverse-console` :**
     指定した JSON ファイルに記載された文字列をリバースし、その結果を標準出力に表示します。
     - 実行例:
       ```shell
       rext reverse-console texts/sample.json
       ```
     - 実行結果:
       ```shell
       hello -> olleh
       world -> dlrow
       typescript -> tpircsepyt
       ```
   - **`rext reverse-text` :**
     リバース結果をテキストファイルとして保存します。
     - 実行例:
       ```shell
       rext reverse-text texts/sample.json sample
       ```
     - 実行結果:
       ```text: reverse-output/sample.text
       hello -> olleh
       world -> dlrow
       typescript -> tpircsepyt
       ```
   - **`rext reverse-json` :**
     リバース結果を JSON ファイルとして保存します。
     - 実行例:
       ```shell
       rext reverse-json texts/sample.json sample
       ```
     - 実行結果:
       ```json: reverse-output/sample.json
       {
         "hello": "olleh",
         "world": "dlrow",
         "typescript": "tpircsepyt"
       }
       ```

3. **ライブラリ機能**
   このパッケージでは、`reverseText` 関数をライブラリとして提供します。
   TypeScript の型定義も含まれており、安全に利用できます。

   ```ts
   export declare function reverseText(text: string): string;
   ```

   ```ts
   import { reverseText } from 'rext';

   const original = "typescript";
   const reversed = reverseText(original);
   console.log(reversed); // => "tpircsepyt"
   ```

## 初期化コマンド `npx create-xxx` の実装




## `npx` のおさらい

## `npx create-xxx` って何？

## 参考リンク

https://www.freecodecamp.org/news/how-to-create-and-publish-your-first-npm-package/

https://docs.npmjs.com/creating-node-js-modules

https://zenn.dev/k0kishima/articles/d75f4dc5bd1a26

https://zenn.dev/taroshun32/articles/npm-package-original

https://dev.to/mikhaelesa/create-your-own-npm-create-cli-like-create-vite-3ig7

https://docs.npmjs.com/cli/v8/commands/npm-init