---
title: "「npx create-xxx」で始めるnpmパッケージを自作したい"
---

## はじめに

`create-next-app` や `npm init playwright` のような便利なセットアップコマンドを利用した経験はありませんか？
これらのコマンドは、たった数秒でプロジェクトをセットアップし、開発の第一歩を大きく加速させてくれます。
ただ、その裏側を「どうやって作られているのだろう？」と考えたことがある方もいるのではないでしょうか。

本記事では、そんな「`npx create-xxx` で始める npm パッケージの自作方法」について、シンプルなパッケージの自作をしながら解説します。

1. `npx create-xxx` によるセットアップコマンドを作成する方法
2. モジュール関数を提供する方法
3. プロジェクト内で利用できる CLI ツールを提供する方法
4. 作成したパッケージを公開する方法

## 今回自作する npm パッケージについて

文字列をリバースするシンプルな npm パッケージ「rext」を作成します。
このパッケージは、以下の特徴を備えています。

- **`npx create-xxx` によるセットアップ**
  プロジェクトを簡単にセットアップできるコマンドを提供します。
  必要なフォルダやファイルを自動生成し、すぐにモジュール関数や CLI ツールを利用可能です。
- **モジュールとしての利用**
  関数をインポートし、プログラム内で利用可能です。
- **CLI ツールとしての利用**
  プロジェクト内で実行できるコマンドを提供します。
- **TypeScript に対応**
  型定義を提供します。

### 提供する機能

1. **セットアップコマンド: `npx create-rext [プロジェクト名]`**
   このコマンドを実行することで、以下のフォルダ構造を持つプロジェクトが自動生成されます。

   ```text
   <プロジェクト>
   ├── node_modules/
   ├── reverse-output/           # リバース結果を保存するフォルダ
   │   └── .gitkeep              # 空フォルダをGitで管理
   ├── texts/                    # 入力データ用フォルダ
   │   └── sample.json           # サンプルデータ
   ├── .gitignore
   └── package.json
   ```

   ```json: texts/sample.json
   {
     "texts": ["hello", "world"]
   }
   ```

   セットアップ後、すぐに CLI を使った操作やモジュールの利用を開始できます。

2. **モジュール関数**
   `reverseText` 関数をモジュールとして提供します。
   TypeScript の型定義も含まれています。

   ```ts: index.d.ts
   /**
    * 指定された文字列をリバースします。
    *
    * @param {string} text - リバースする文字列。
    * @returns {string} リバースされた文字列。
    */
   export declare function reverseText(text: string): string;
   //# sourceMappingURL=index.d.ts.map
   ```

   ```ts
   import { reverseText } from "rext";

   const original = "typescript";
   const reversed = reverseText(original);
   console.log(reversed); // => "tpircsepyt"
   ```

3. **CLI ツール**
   プロジェクト内で動作する CLI ツールとして、以下の機能を提供します。

   - **`rext reverse-console` :**
     指定した JSON ファイルに記載された文字列をリバースし、その結果を標準出力に表示します。
     - 実行例:
       ```shell
       npx rext reverse-console texts/sample.json
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
       npx rext reverse-text texts/sample.json sample
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
       npx rext reverse-json texts/sample.json sample
       ```
     - 実行結果:
       ```json: reverse-output/sample.json
       {
         "hello": "olleh",
         "world": "dlrow",
         "typescript": "tpircsepyt"
       }
       ```

### パッケージを分割して提供する

今回作成する「rext」ですが、下記 2 つのパッケージに分割して提供します。

1. **`rext`**
   コア機能である「モジュール関数」及び「CLI ツール」を提供します。
2. **`create-rext`**
   `rext` プロジェクトのセットアップ専用パッケージです。

このように複数のパッケージに分割した提供方針は Next.js や Playwright などでも採用されています。

:::details Next.js

https://www.npmjs.com/package/nextjs

https://www.npmjs.com/package/create-next-app

:::

:::details Playwright

https://www.npmjs.com/package/playwright
https://www.npmjs.com/package/create-playwright

:::

:::message

**🤔 なぜパッケージを分割するのか？**

1. **`npx` を使って `create-rext` を実現するため**
   `npx` はコマンド名（`create-rext`）とパッケージ名（`create-rext`）が一致している場合にのみ、そのパッケージを検索して実行します。
   もし `create-rext` コマンドを `rext` パッケージ内に含めてしまうと、`npx create-rext` は動作しません。（`npm install -g rext` した後、`npx create-rext` する必要がある）

2. **依存関係の最適化**
   セットアップツール（`create-rext`）は開発環境でしか使いません。
   これをコア機能（`rext`）に統合してしまうと、本番環境に不要な依存関係が含まれる可能性があります。
   本番環境に不要な依存関係を含めないことで、以下の利点が生まれます。

   - ビルド内容の軽量化
   - セキュリティリスクの軽減

   例として、`create-rext` ではテンプレートファイルの生成に `fs-extra` という外部パッケージを利用しますが、これはセットアップ時にしか必要ありません。

3. **メンテナンス性の向上**
   メンテナンス性において、特に恩恵を受けるのが**バージョニング**です。
   npm では、パッケージ更新時に必ずバージョンアップが必要です。
   同一パッケージにまとめた場合、セットアップ機能に関する小さな変更だけでコア機能に変更がなくても、バージョンアップを余儀なくされます。
   パッケージ単位の更新頻度が多くなると、利用者側のメンテナンス性も低下させてしまいます。

:::

## 新規パッケージ用プロジェクト作成

npm パッケージを自作する第一歩として、`rext` パッケージ用の新規プロジェクトを作成します。
以下の手順を実施します。

1. パッケージ名を決める
2. パッケージ開発用の新規プロジェクトを作成する
3. `package.json` を作成する
4. TypeScript のセットアップ

### ① パッケージ名を決める

パッケージの名前は、npm レジストリ上でユニークである必要があります。
名前にはスペースを入れず、小文字にする必要があります。（`-`, `.`, `_` は OK）

使用したいパッケージ名が既に npm レジストリに存在する場合、以下 2 つの選択肢があります。

1. 他のユニークな名前を使用する
2. **スコープをつける**

「スコープ」とは、名前にプレフィックスを追加することでパッケージをグループ化する方法です。

```
@[スコープ名]/[パッケージ名]
```

スコープは主に次の目的で使用されます。

1. **パッケージ名の競合を回避**
   スコープ名は一意である必要があるため、パッケージ名は必然的にユニークとなります。
2. **パッケージの整理**
   スコープを使用することで、特定の組織やプロジェクトに関連するパッケージを簡単に識別できます。
3. **プライベートパッケージ**
   スコープを使用することで、npm レジストリ上でプライベートパッケージを管理できます。
   これにより、組織内のメンバーのみがアクセスできるパッケージを作成することが可能です。

スコープ付きパッケージを依存関係に含めた場合、`node_modules` ディレクトリには次のように反映されます。

```
node_modules/
└── @スコープ名/
    └── パッケージ名/
```

:::message
**パッケージ名のガイドライン**

npm でパッケージ名を選ぶ際には、以下の点を考慮してください。

1. **ユニーク性**
   他のパッケージ名と重複しないものを選ぶ。
2. **記述性**
   パッケージの内容を適切に表す名前を選ぶ。
3. **npm のポリシーに適合していること**
   - 不快な名前を避ける
   - 他人の商標を使用しない
   - [npm の商標ポリシー](https://docs.npmjs.com/policies/disputes#trademarks)に違反しない

\
さらに、スコープなしのパッケージ名を選ぶ場合は、次の点も確認してください。

- 他のパッケージ名と紛らわしくない名前を選ぶ
- 著者について混乱を招かない名前を選ぶ

:::

### ② パッケージ開発用の新規プロジェクトを作成する

次に、パッケージ用の新しいフォルダーを作成し、Git リポジトリを初期化します。

1. **新規フォルダーの作成**
   ```shell
   mkdir rext
   cd rext
   ```
2. **Git リポジトリを初期化する**
   ```shell
   git init
   ```
3. **`.gitignore` を設定する**
   ```.gitignore: .gitignore
   node_modules/
   ```

### ③ package.json を作成する

パッケージのメタデータを管理するための `package.json` を作成します。

:::message
そもそも「パッケージ」とは、`package.json` を含むファイルやディレクトリのことです。
そのため、npm レジストリに公開するパッケージには、`package.json` が含める必要があります。
:::

`npm init` を実行すると、以下のプロンプトが表示されます。
プロンプトに回答することで、`package.json` の主要フィールドが指定されます。

:::details package-name（必須）

`name` フィールドに該当します。
\
パッケージ名です。

:::

:::details version（必須）

`version` フィールドに該当します。
\
パッケージのバージョン番号です。
npm では、**セマンティックバージョニング（Semantic Versioning, SemVer）** に基づいたバージョン番号を使用します。
セマンティックバージョニングでは、次の形式のバージョン番号を使用します。

```
MAJOR.MINOR.PATCH
```

例：`1.2.3`

1. **MAJOR（重大な変更）**

- 後方互換性を破る変更が加えられた場合にインクリメントします
- 例：`1.0.0` → `2.0.0`
- 変更例：
  - モジュール関数の引数が変更された
  - 削除された機能がある

2. **MINOR（新機能）**
   - 後方互換性を保ったまま新しい機能が追加された場合にインクリメントします
   - 例：`1.2.0` → `1.3.0`
   - 変更例：
     - 新規オプションやメソッドを追加
     - 既存の機能には影響しない改善
3. **PATCH（バグ修正）**
   - 後方互換性を保ちながらバグ修正が行われた場合にインクリメントします
   - 例：`1.2.3` → `1.2.4`
   - 変更例：
     - バグの修正
     - パフォーマンスの最適化

\
`MAJOR` が `0` の間は、`MAJOR` の更新なしに破壊的変更を行うことが許容されています。
そのため、開発初期段階では `0.x.x` にするケースが多いです。
そして、正式リリースのタイミングで `1.x.x` にします。

:::

:::details description
`description` フィールドに該当します。
\
パッケージの説明を記述できます。
このパッケージが何を提供するものなのか？どのように使用するのか？を記述します。

:::

:::details entry point

`main` フィールドに該当します。
\
パッケージが他のアプリケーションやモジュールから `import` または `require` された際に参照されるエントリーポイントを指定します。
デフォルトは `index.js` です。

\
`main` フィールドが以下のように設定されている場合、

```json
{
  "main": "index.js"
}
```

他のプロジェクトでこのパッケージをインポートすると、`/index.js` が読み込まれます。

```ts
const rext = require("rext");
```

:::

:::details test command

`scripts.test` フィールドに該当します。
\
このフィールドでは、テストスクリプトを指定します。
`npm test` コマンドを実行することで、このスクリプトが実行されます。

デフォルトでは、次のようなプレースホルダーが自動生成されます。

```json
{
  "scripts": {
    "test": "mocha"
  }
}
```

:::

:::details git repository

`repository` フィールドに該当します。
\
パッケージのソースコードがホストされているリポジトリを指定します。
通常、Git リポジトリの URL を記載します。

```json
{
  "repository": {
    "type": "git",
    "url": "git+https://github.com/yuu104/rext.git"
  }
}
```

OSS として公開する際に特に重要です。

:::

:::details keywords

`keywords` フィールドに該当します。
\
このフィールドでは、パッケージに関連するキーワードを配列形式で指定します。
npm 検索でパッケージが見つかりやすくなります。

```json
{
  "keywords": ["reverse", "text"]
}
```

:::

:::details author

`author` フィールドに該当します。
\
パッケージの作成者の名前や連絡先を指定します。
単純な文字列またはオブジェクト形式で記載できます。

```json
{
  "author": "Your Name"
}
```

```json
{
  "author": {
    "name": "Your Name",
    "email": "youremail@example.com",
    "url": "https://yourwebsite.com"
  }
}
```

:::

:::details license

`license` フィールドに該当します。
\
パッケージのライセンスを指定します。
このフィールドは、パッケージを使用する人がどのような条件で使用できるかを明示します。

デフォルトは、`ISC (Internet Systems Consortium)` です。

:::

```json: package.json
{
  "name": "@yuu104/rext",
  "version": "0.1.0",
  "description": "Simple text reverse library",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/yuu104/rext.git"
  },
  "keywords": ["reverse", "text"],
  "author": "yuu104",
  "license": "ISC"
}
```

### ④ TypeScript のセットアップ

1. **必要なパッケージのインストール**
   以下のコマンドを実行して、TypeScript と Node.js の型定義を開発依存としてインストールします。
   ```shell
   npm install --save-dev typescript @types/node
   ```
2. **`tsconfig.json` の作成**
   プロジェクトルートに TypeScript の設定ファイル `tsconfig.json` を作成します。
   今回は[TSConfig bases](https://github.com/tsconfig/bases) を利用してサクッと設定します。

   ```shell
   npm install --save-dev @tsconfig/node22
   ```

   ```json: tsconfig.json
   {
     "extends": "@tsconfig/node22/tsconfig.json",
     "compilerOptions": {
       "outDir": "./dist",
       "rootDir": "./src",
       "declaration": true,
       "declarationMap": true
     },
     "include": ["src/**/*.ts"]
   }
   ```

3. **ビルドの設定**
   JS にコンパイルする必要があるので、`package.json` と `.gitignore` を修正します。

   ```diff json: package.json
     {
       "name": "@yuu104/rext",
       "version": "0.1.0",
       "description": "Simple text reverse library",
   -   "main": "index.js",
   +   "main": "./dist/index.js",
       "scripts": {
   -     "test": "echo \"Error: no test specified\" && exit 1"
   +     "build": "tsc",
   +     "prepare": "npm run build",
       },
       "keywords": ["reverse", "text", "cli"],
       "author": "yuu104",
       "license": "ISC"
       ....
     }
   ```

   ```diff .gitignore: .gitignore
    node_modules/
   + dist/
   ```

\
ここまでのデレクトリ構成は以下になります。

```
.
├── node_modules/
├── .gitignore
├── package-lock.json
├── package.json
└── tsconfig.json
```

## モジュール関数の実装

引数に指定した文字列をリバースして返却する関数 `reverseText()` を実装します。

以下のように、`reverseText` をパッケージ名である `rext` からインポートして利用できるようにします。

```ts
import { reverseText } from "rext";

const original = "typescript";
const reversed = reverseText(original);
console.log(reversed); // => "tpircsepyt"
```

`import` 文の `rext` が指し示すのは、`package.json` の `main` フィールドに指定した `./dist/index.js` です。この場所がエントリーポイントとなります。

そのため、`src/index.ts` に `reverseText` を実装します。

```diff
  .
  ├── node_modules/
+ ├── src
+ |   └── index.ts
  ├── .gitignore
  ├── package-lock.json
  ├── package.json
  └── tsconfig.json
```

```ts: src/index.ts
/**
 * 指定された文字列をリバースします。
 *
 * @param {string} text - リバースする文字列
 * @returns {string} リバースされた文字列
 */
export function reverseText(text: string): string {
  return text.split("").reverse().join("");
}
```

\
ビルド（`npm run build`）すると、`dist/index.js` が生成されます。

```diff
  .
  ├── node_modules/
+ └── dist
+ |   ├── index.d.ts
+ |   ├── index.d.ts.map
+ |   └── index.js
  ├── src
  |   └── index.ts
  ├── .gitignore
  ├── package-lock.json
  ├── package.json
  └── tsconfig.json
```

## CLI ツールの実装

続いて、`rext` コマンドによる以下の CLI ツールを実装します。

1. **`rext reverse-console` :**
   指定した JSON ファイルに記載された文字列をリバースし、その結果を標準出力する。
2. **`rext reverse-text` :**
   指定した JSON ファイルに記載された文字列をリバースし、その結果をテキストファイルとして保存する。
3. **`rext reverse-json` :**
   指定した JSON ファイルに記載された文字列をリバースし、その結果を JSON ファイルとして保存する。

### ① bin の設定

npm パッケージで CLI を提供する場合、`package.json` の `bin` フィールドを設定する必要があります。
この設定により、npm CLI や npx を使用たコマンドの実行が可能になります。

`rext` コマンドを追加するために以下の設定を行います。

```diff json: package.json
  {
    "name": "@yuu104/rext",
    "version": "0.1.0",
    "description": "Simple text reverse library",
    "main": "./dist/index.js",
    "scripts": {
      "build": "tsc",
      "prepare": "npm run build"
    },
+   "bin": {
+     "rext": "./dist/bin/index.js"
+   },
    ....
  }
```

- **キー（`rext`）**
  コマンド名を指定します。
- **値（`./dist/bin/index.js`）**
  実行されるスクリプトファイルのパスを指定します。

この設定により、`rext` コマンドに対し `./dist/bin/index.js` がマッピングされます。

:::message

**bin の仕組み**
\
bin の設定があるパッケージを依存関係に含めると、`node_modules/.bin/` にシンボリックリンクが作成されます。

```
node_modules/
├── .bin/
|   └──rext → ../@yuu104/rext/dist/bin/index.js
│
└── @yuu104/
    └── rext/
        └── dist/
            └── bin/
                └── index.js
```

\
「シンボリックリンク」とは、ファイルやディレクトリへのショートカットや参照のようなものです。
ローカルモードの場合、`npm run` や `npx` を実行すると `node_modules/.bin/` が優先的に参照され、該当するスクリプトファイルを実行してくれます。

\
よって、流れとしては以下になります。
`npx rext`
　 ↓
`node_modules/.bin/rext`
　 ↓
`node_modules/@yuu104/rext/dist/bin/index.js`

:::

### ② スクリプトの実装

`rext` パッケージのプロジェクトに以下を追加します。

```diff
  .
  ├── node_modules/
  ├── src
+ |   ├── bin
+ |   |   └── index.ts
  |   └── index.ts
  ├── .gitignore
  ├── package-lock.json
  ├── package.json
  └── tsconfig.json
```

:::details src/bin/index.ts

```ts: src/bin/index.ts
#!/usr/bin/env node

import * as fs from "fs";
import * as path from "path";
import { reverseText } from "../index";

function main() {
  // `process.argv`は Node.js プロセスが実行されたときに渡されたコマンドライン引数を含む配列
  // `process.argv[0]` : Node.jsの実行ファイル(node)の絶対パス
  // `process.argv[1]` : 実行中スクリプトファイルのパス
  // `process.argv[2]以降 : ユーザーがスクリプト実行時に渡した引数
  const [, , subCommand, ...args] = process.argv;

  switch (subCommand) {
    case "reverse-console":
      reverseConsole(args);
      break;
    case "reverse-text":
      reverseTextFile(args);
      break;
    case "reverse-json":
      reverseJsonFile(args);
      break;
    default:
      console.error(
        "Unknown command. Use one of: reverse-console, reverse-text, reverse-json"
      );
      process.exit(1);
  }
}

/**
 * 指定した JSON ファイルに記載された文字列をリバースし、その結果を標準出力する。
 * @param args - コマンドライン引数。 args[0]: JSON ファイルのパス
 */
function reverseConsole(args: string[]): void {
  if (args.length < 1) {
    console.error("Usage: rext reverse-console <jsonFilePath>");
    process.exit(1);
  }

  const jsonFilePath = args[0];
  const jsonData = loadJsonFile(jsonFilePath);
  jsonData.texts.forEach((txt: string) => {
    console.log(`${txt} -> ${reverseText(txt)}`);
  });
}

/**
 * 指定した JSON ファイルに記載された文字列をリバースし、その結果をテキストファイルとして保存する。
 * @param args - コマンドライン引数。 args[0]: JSON ファイルのパス, args[1]: 出力ファイル名
 */
function reverseTextFile(args: string[]) {
  if (args.length < 2) {
    console.error("Usage: rext reverse-text <jsonFilePath> <outputFileName>");
    process.exit(1);
  }

  const jsonFilePath = args[0];
  const outputFileName = args[1];
  const jsonData = loadJsonFile(jsonFilePath);

  let output = "";
  jsonData.texts.forEach((txt: string) => {
    output += `${txt} -> ${reverseText(txt)}\n`;
  });

  const outputPath = path.join("reverse-output", `${outputFileName}.text`);
  fs.writeFileSync(outputPath, output);
  console.log(`Saved reversed text to ${outputPath}`);
}

/**
 * 指定した JSON ファイルに記載された文字列をリバースし、その結果を JSON ファイルとして保存する。
 * @param args - コマンドライン引数。 args[0]: JSON ファイルのパス, args[1]: 出力ファイル名
 */
function reverseJsonFile(args: string[]) {
  if (args.length < 2) {
    console.error("Usage: rext reverse-json <jsonFilePath> <outputFileName>");
    process.exit(1);
  }

  const jsonFilePath = args[0];
  const outputFileName = args[1];
  const jsonData = loadJsonFile(jsonFilePath);

  const reversedObject: Record<string, string> = {};
  jsonData.texts.forEach((txt: string) => {
    reversedObject[txt] = reverseText(txt);
  });

  const outputPath = path.join("reverse-output", `${outputFileName}.json`);
  fs.writeFileSync(outputPath, JSON.stringify(reversedObject, null, 2));
  console.log(`Saved reversed JSON to ${outputPath}`);
}

/**
 * 指定したパスの JSON ファイルを読み込み、オブジェクトを返す。
 * @param filePath　- JSON ファイルのパス
 * @returns　JSONオブジェクト
 */
function loadJsonFile(filePath: string): Record<string, string[]> {
  const content = fs.readFileSync(filePath, "utf-8");
  return JSON.parse(content);
}

main();
```

:::

\
以上で、`rext` パッケージのロジック実装は完了です ✨

## `npx create-xxx` 用のパッケージを作成する

次は、セットアップツールである `create-rext` パッケージを作成します。

`create-xxx` のようなセットアップコマンドは、開発者が以下のような手順を短縮し、すぐに開発できる状態を提供するために用意されます。

- 必要なディレクトリやファイルを作成
- デフォルトの設定ファイル（`package.json`、`tsconfig.json` など）を用意

### ① パッケージ用のプロジェクトを新規作成

`rext` パッケージと同様に用意します。

1. **新規フォルダーの作成**

   ```shell
   mkdir create-rext
   cd create-rext
   ```

2. **Git の設定**

   ```shell
   git init
   ```

   ```.gitignore: .gitignore
   node_module/
   ```

3. **`package.json` の作成**

   ```json: package.json
   {
      "name": "@yuu104/create-rext",
      "version": "0.1.0",
      "description": "Create rext project with one command",
      "main": "index.js",
      "scripts": {
       "test": "echo \"Error: no test specified\" && exit 1"
      },
      "repository": {
       "type": "git",
       "url": "git+https://github.com/yuu104/create-rext.git"
      },
      "keywords": [
       "rext",
       "reverse",
       "text",
       "cli"
      ],
      "author": "yuu",
      "license": "ISC",
   }
   ```

4. **TypeScript のセットアップ**

   ```shell
   npm install --save-dev typescript @types/node @tsconfig/node22
   ```

   ```json: tsconfig.json
   {
      "extends": "@tsconfig/node22/tsconfig.json",
      "compilerOptions": {
       "outDir": "./dist",
       "rootDir": "./src",
       "declaration": true,
       "declarationMap": true
      },
      "include": ["src/**/*.ts"]
   }
   ```

   ```diff json: package.json
      {
        "name": "@yuu104/create-rext",
        "version": "0.1.0",
        "description": "Create rext project with one command",
   -    "main": "index.js",
   +    "main": "./dist/index.js",
        "scripts": {
   -      "test": "echo \"Error: no test specified\" && exit 1"
   +      "build": "tsc",
   +      "prepare": "npm run build"
        },
        ...
      }
   ```

   ```diff .gitignore: .gitignore
     node_module/
   + dist/
   ```

ここまでのディレクトリ構成は以下になります。

```
.
├── node_modules/
├── .gitignore
├── package-lock.json
├── package.json
└── tsconfig.json
```

### ② テンプレートファイルの準備

`npx create-rext` によるプロジェクト生成時に用意されるディレクトリ構成を `template/` フォルダーに作成します。
`npx create-rext [プロジェクト名]` コマンドを実行した際、`template/` 配下のファイル群が `[プロジェクト名]/` にコピーされます。

以下を `template/` に配置します。

```diff
  .
  ├── node_modules/
  ├── src
  |   ├── bin
  |   |   └── rext.ts
  |   └── index.ts
+ ├── template
+ │   ├── package.json
+ │   ├── reverse-output
+ |   |   └── .gitkeep
+ │   └── texts
+ │       └── sample.json
  ├── .gitignore
  ├── package-lock.json
  ├── package.json
  └── tsconfig.json
```

:::details package.json

```json: package.json
{
  "name": "placeholder", // `create-rext`コマンド実行時に、動的に[プロジェクト名]へ変更します
  "version": "1.0.0",
  "dependencies": {
    "@yuu104/rext": "^0.1.0" // モジュール関数を利用するため、依存関係に含めます
  },
  "license": "UNLICENSED"
}
```

:::

:::details reverse-output

空フォルダーなので、`.gitkeep` を入れます。

:::

:::details texts/sample.json

リバース処理の対象となる文字列データを格納するサンプルファイルです。

```json: texts/sample.json
{
  "texts": [ "hello", "world" ]
}
```

:::

### ③ bin の設定

`rext` パッケージと同様に設定します。

```diff json: package.json
  {
    "name": "@yuu104/create-rext",
    "version": "0.1.0",
    "description": "Create rext project with one command",
    "main": "./dist/index.js",
    "scripts": {
      "build": "tsc",
      "prepare": "npm run build"
    },
+   "bin": {
+     "create-rext": "./dist/bin/index.js"
+   },
    ...
  }
```

### ④ セットアップコマンドのスクリプト実装

```diff
  .
  ├── node_modules/
+ ├── src
+ |   └── bin
+ |       └── index.ts
  ├── template
  │   ├── package.json
  │   ├── reverse-output
  |   |   └── .gitkeep
  │   └── texts
  │       └── sample.json
  ├── .gitignore
  ├── package-lock.json
  ├── package.json
  └── tsconfig.json
```

\
ファイル操作を便利にしてくれるライブラリ `fs-extra` をインストールします。

```shell
npm install fs-extra
npm install --save-dev @types/fs-extra
```

\
`src/bin/create-rext.ts` を作成し、以下のロジックを実装します。

1. コマンド入力のバリデーション
2. `template/` をコピーしてプロジェクトフォルダーに配置
3. `package.json` の `name` フィールドを変更
4. `npm install` 実行

:::details src/bin/create-rext.ts

````ts: src/bin/create-rext.ts
#!/usr/bin/env node

import * as path from "path";
import * as fs from "fs";
import * as fse from "fs-extra";
import { execSync } from "child_process";

/**
 * `create-rext` コマンドのエントリーポイント
 */
function main() {
  // ユーザが指定したプロジェクト名を取得
  const args = process.argv.slice(2);
  if (args.length < 1) {
    console.error("Usage: npx create-rext <project-name>");
    process.exit(1);
  }

  const projectName = args[0]; // プロジェクト名
  const projectPath = path.resolve(process.cwd(), projectName); // 作成先ディレクトリの絶対パス

  // プロジェクト用フォルダが既に存在していればエラーにする
  if (fs.existsSync(projectPath)) {
    console.error(`Directory "${projectName}" already exists.`);
    process.exit(1);
  }

  // テンプレートのパスを取得 (自身のプロジェクト内 template/ を想定)
  const templatePath = path.resolve(__dirname, "../../", "template");

  // テンプレート一式をコピー
  fse.copySync(templatePath, projectPath);

  // プロジェクト名を package.json の name フィールドに反映
  updatePackageJson(projectPath, projectName);

  // npm install を実行して依存関係をインストール
  try {
    console.log("Installing dependencies. This may take a while...");
    execSync("npm install", { cwd: projectPath, stdio: "inherit" });
    console.log("Dependencies installed successfully.");
  } catch (err) {
    console.error("Failed to install dependencies:", err);
    process.exit(1);
  }

  // 完了メッセージを表示
  console.log(`\nProject "${projectName}" has been created successfully!`);
  console.log(`Navigate to the project directory with:\n  cd ${projectName}`);
  console.log(`Then start using the rext CLI tool.`);
}

/**
 * 指定されたプロジェクトディレクトリ内の `package.json` を更新し、
 * プロジェクト名を設定します。
 *
 * この関数は、テンプレートからコピーされた `package.json` を
 * ユーザ指定のプロジェクト名にカスタマイズします。
 *
 * @param projectPath - `package.json` が存在するプロジェクトディレクトリの絶対パス
 * @param projectName - `package.json` に設定するプロジェクト名
 *
 * @throws `package.json` が指定されたディレクトリに存在しない場合、エラーをスローします。
 *
 * @example
 * ```ts
 * updatePackageJson('/path/to/project', 'my-new-project')
 * ```
 */
function updatePackageJson(projectPath: string, projectName: string): void {
  const packageJsonPath = path.join(projectPath, "package.json");
  // package.json が存在するか確認
  if (!fs.existsSync(packageJsonPath)) {
    console.error("package.json not found in template. Exiting...");
    process.exit(1);
  }

  // package.json を読み込み、JSON オブジェクトとして解析
  const raw = fs.readFileSync(packageJsonPath, "utf-8");
  const obj = JSON.parse(raw);

  // プロジェクト名を上書き
  obj.name = projectName;

  // 更新された JSON オブジェクトをファイルに上書き保存
  const updated = JSON.stringify(obj, null, 2);
  fs.writeFileSync(packageJsonPath, updated);
}

main();
````

:::

\
\
以上で `create-rext` のロジック実装は完了です ✨

:::message

**🤔 npx create-xxx と npm init xxx の関連性**

パッケージによって、セットアップコマンドが `npx create-xxx` と `npm init xxx` だったりします。
例えば、

- Next.js では [`npx create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app)
- Playwright では [`npm init playwright`](https://playwright.dev/docs/intro#installing-playwright)

でセットアップを行うようにと記載されています。

\
違いは何でしょうか？
↓↓↓
**両者に違いはなく、同じです。**

\
実は、`npm init xxx` は内部的に `npx create-xxx` へ変換しています。

- `npm init foo` -> `npx create-foo`
- `npm init @usr/foo` -> `npx @usr/create-foo`
- `npm init @usr` -> `npx @usr/create`
- `npm init @usr@2.0.0` -> `npx @usr/create@2.0.0`
- `npm init @usr/foo@2.0.0` -> `npx @usr/create-foo@2.0.0`

\
また、npm v7 以降では、`npx` は内部的に `npm exec` を実行するようになりました。
そのため、以下のような関係となります。

- `npm init foo` -> `npx create-foo` -> `npm exec create-foo`
- `npm init @usr/foo` -> `npx @usr/create-foo` -> `npm exec @usr/create-foo`
- `npm init @usr` -> `npx @usr/create` -> `npm exec @usr/create`
- `npm init @usr@2.0.0` -> `npx @usr/create@2.0.0` -> `npm exec @usr/create@2.0.0`
- `npm init @usr/foo@2.0.0` -> `npx @usr/create-foo@2.0.0` -> `npm exec @usr/create-foo@2.0.0`

\
つまり、**内部的にはどちらも `npm exec` を実行するため、違いはない**ということです。

:::

## README を作成する

続いて、README を作成します。
README はユーザーがパッケージを理解するために触れる最初の情報です。

以下の内容等を記述します。

- インストール方法
- 設定方法
- 使用方法
- その他、ユーザーに役立つ情報

GitHub リポジトリと同様、README は npm レジストリのページ上に表示されます。

:::message
**npm パッケージの `README.md` ファイルは、パッケージのルートディレクトリに配置する必要があります。**
:::

:::message
**README の更新を npm レジストリのページに反映するためには、パッケージのバージョン更新が必要です。**
:::

## パッケージに含めるファイルを指定する

パッケージを公開する際に、不要なファイルやディレクトリが含まれないようにするため、公開対象のファイルを明示的に指定します。
これによりパッケージのサイズが最適化され、不要なファイルの公開を防ぐことができます。

設定方法としては 2 通り存在します。

### ① `.npmignore` を使用する

`.gitignore` と同じ形式で、**除外したいファイルやディレクトリ**を指定します。

```.npmignore: .npmignore
src/
tsconfig.json
```

:::message
**`.npmignore` が存在しない場合、`.gitignore` の内容が適用されます。**
`.npmignore` が存在する場合、`.gitignore` は無視されます。
:::

### ② `package.json` の `files` フィールドを指定する

`.npmignore` とは逆で、**パッケージに含めたいファイルやディレクトリ**を指定します。

:::details rext パッケージ

```diff json: rext/package.json
  {
    "name": "@yuu104/rext",
    "version": "0.1.0",
    "description": "Simple text reverse library",
    "main": "./dist/index.js",
    "scripts": {
      "build": "tsc",
      "prepare": "npm run build"
    },
    "bin": {
      "create-rext": "./dist/bin/create-rext.js",
      "rext": "./dist/bin/rext.js",
    },
+   "files": [
+     "dist",
+   ],
    ....
  }
```

:::

:::details create-rext パッケージ

```diff json: create-rext/package.json
  {
    "name": "@yuu104/rext",
    "version": "0.1.0",
    "description": "Simple text reverse library",
    "main": "./dist/index.js",
    "scripts": {
      "build": "tsc",
      "prepare": "npm run build"
    },
    "bin": {
      "create-rext": "./dist/bin/create-rext.js",
      "rext": "./dist/bin/rext.js",
    },
+   "files": [
+     "dist",
+     "template",
+   ],
    ....
  }
```

:::

:::message

**省略した場合**

`["*"]` として解釈され、すべてのファイルが対象となります。
よって、省略する場合は `.npmignore` で指定する必要があります。

:::

:::message

**`.npmignore` と併用した場合**

- ルートディレクトリの場合 → `files` フィールドが優先されます
- サブディレクトリの場合 → `.npmignore` が優先されます

:::

### 絶対に含まれるファイル・含まれないファイル

`.npmignore` や `files` フィールドの設定に関わらず、必ずパッケージに含まれるファイル・含まれないファイルが存在します。
下記ファイルの設定はしてもしなくても構いません。

:::details 絶対に含まれるファイル

- `package.json`
- `README`
- `LICENSE` / `LICENCE`
- `CHANGELOG`
- `package.json` の `main` フィールドに指定したファイル

:::

:::details 絶対に含まれないファイル

- `.DS_Store`
- `.git`
- `.gitignore`
- `node_modules/`
- `.npmignore`
- `.npmrc`
- `package-lock.json`（公開したい場合は、`.npm-shrinkwrap.json` を使用する）
- `.hg`
- `.lock-wscript`
- `.svn`
- `.wafpickle-*`
- `CVS`
- `config.gypi`
- `npm-debug.log`
- `.*.swp`
- `._*`
- `*.orig`

:::

## 作成したパッケージをローカルで動作検証する

作成したパッケージを検証します。
「rext」 はまだ npm レジストリへ公開されていません。どのようにパッケージをインストールするのでしょうか？

### `npm link` でシンボリックリンクを作成する

`npm link` を利用します。
`npm link` とは、**ローカル開発中のパッケージを他のプロジェクトで簡単に利用できるようにするコマンド**です。

`rext` パッケージのプロジェクトルート直下（`package.json` と同階層）で以下のコマンドを実行します。

```shell
cd ~/workspace/rext
npm link
```

すると、グローバルの `node_modules` に対し、`npm link` したパッケージへのシンボリックリンクが作成されます。

```shell
# 例
/usr/local/lib/node_modules/@yuu104/create-rext → ~/workspace/rext
```

また、bin においても同様、グローバル環境にリンクされます。

```shell
# 例
/usr/local/bin/rext → /usr/local/lib/node_modules/@yuu104/rext/bin/index.js
```

### `npm link {パッケージ名}` でパッケージを擬似インストールする

適当なディレクトリを作成して動作検証を行います。

```shell
mkdir test-rext
cd test-rext
```

`npm link` を実行します。

```shell
npm link @yuu104/rext
```

すると、`node_modules` にシンボリックリンクが作成されます。

```shell
# 例
/test-rext/node_modules/@yuu104/rext → /usr/local/bin/node_modules/@yuu104/rext
```

これで、`rext` の動作検証が可能になります。

しかし、本当は `create-rext` コマンドでプロジェクトを作成したいです...

### `create-rext` コマンドを検証する

`create-rext` パッケージにおいても、`npm link` 利用して検証を行います。
しかし、現状ではコマンドの実行中にエラーとなり、プロジェクトの立ち上げに失敗します。

何故でしょうか？
`create-rext` コマンドの実行スクリプトである `create-rext.ts` を確認してみます。

```ts: create-rext.ts
function main() {
  // ...

  // テンプレートのパスを取得 (自身のプロジェクト内 template/ を想定)
  const templatePath = path.resolve(__dirname, "../../", "template");

  // テンプレート一式をコピー
  fse.copySync(templatePath, projectPath);

  // プロジェクト名を package.json の name フィールドに反映
  updatePackageJson(projectPath, projectName);

  // npm install を実行して依存関係をインストール
  try {
    console.log("Installing dependencies. This may take a while...");
    execSync("npm install", { cwd: projectPath, stdio: "inherit" });
    console.log("Dependencies installed successfully.");
  } catch (err) {
    console.error("Failed to install dependencies:", err);
    process.exit(1);
  }

  // ...
}
```

最後に `npm install` していますね。
`template/package.json` の `dependencies` には、`@yuu104/rext` が含まれています。
これが原因です。
`@yuu104/rext` は npm レジストリには存在しないため、`npm install` しても失敗するのです...

ではどうすれば良いのでしょうか？
[Local Paths](https://docs.npmjs.com/cli/v11/configuring-npm/package-json#local-paths) を使用します。

Local Paths は、`package.json` の `dependencies` を指定する際に、ローカルのディレクトリを直接参照する方法です。
`file:` の後に続けて、パッケージへの相対パスを指定します。

```diff json: template/package.json
 {
   "dependencies": {
-     "rext": "^0.1.0"
+     "rext": "file:../rext"
   }
 }
```

この状態で `npm install` すると、`node_modules/@yuu104/rext` にシンボリックリンクが作成されます。

```shell
# 例
/test-rext/node_modules/@yuu104/rext → ~/workspace/rext
```

:::message

npm link を使用した場合、参照元の変更が即座に反映されます。

しかし、Local Paths を使用した場合は異なります。
変更を反映させるには `npm install` を再実行する必要があります。

npm link と Local Paths の違いについては、下記リンクが参考になります。
https://zenn.dev/ttskch/articles/0fa9bb8934f1ef

:::

これでローカルでの検証環境が整いました 👍
`create-rext` コマンドでプロジェクトを作成してみましょう！

### 後片付けをする

検証が完了したので、次は公開です！
...とその前に、npm link や Local Paths で設定した内容を元に戻しておきます。

1. **`npm unlink` でシンボリックリンクを削除する**
   ```shell
   # `npm link` で作成したシンボリックリンクを削除する
   npm unlink
   ```
2. **Local Paths の設定を解除**

   ```diff json: ~/workspace/create-rext/template/package.json
    {
      "dependencies": {
   -     "rext": "file:../workspace"
   +     "rext": "^0.1.0"
      }
    }
   ```

## npm レジストリへ公開する

さあ、いよいよ公開です 🔥🔥

### LICENSE ファイルを作成する

公開する npm パッケージのライセンスについて明記したファイルを作成します。
今回は ISC ライセンスなので、[ISC LICENSE](https://choosealicense.com/licenses/isc/)から記載内容をコピーし、ルートディレクトリ直下に `LICENSE` ファイルを作成します。

`Copyright (c) [year] [fullname]` の `[year]` と `fullname` だけ書き換えます。

```LICENSE: LICENSE
ISC License

Copyright (c) 2025 yuu104

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
```

### npm アカウントの作成

npm レジストリにパッケージを公開するには、アカウントが必要です。
アカウントを持っていない場合は作成します。

https://www.npmjs.com/signup

### 公開されるファイル群を確認する

最終確認として、公開されるファイルを確認します。

```shell
npm pack
```

上記コマンドを実行すると、`<name>-<version>.tgz` ファイルが生成されます。
こちらを展開し、以下のファイルのみが入っていることをチェックします。

- `package.json` の `files` に指定したファイル
- `README.md` や `LICENSE` 等、絶対に含まれるファイル

### npm コマンドで公開

作成したアカウントで npm レジストリへログインします。

```shell
npm login
```

`publish` コマンドで公開します。

```shell
npm publish --access public
```

スコープ付きパッケージの場合、デフォルトだとプライベート公開（有料）になってしまします。
そのため、`--access public` でパブリック公開を指定します。

\
以上で公開が完了しました 🎉🎉
`npx @yuu104/create-rext [プロジェクト名]` でプロジェクトを開始できます！

https://www.npmjs.com/package/@yuu104/rext
https://www.npmjs.com/package/@yuu104/create-rext

## GitHub Packages へ公開する

npm レジストリでプライベートパッケージを公開する場合、[Pro プランへの加入](https://www.npmjs.com/products?utm_source=chatgpt.com)が必要になり料金が発生します...

そんな時に便利なのが GitHub Packages です。
https://github.co.jp/features/packages

GitHub Packages とは、ソフトウェアパッケージをパブリックまたはプライベートにホストして利用することができるホスティングサービスです。
特定の org 内でのみ利用可能なパッケージをホストすることができます。

npm、RubyGems、Apache Maven、Gradle、Docker、NuGet といった、広く使われているパッケージマネージャーに対する様々なパッケージレジストリを提供しています。

GitHub Packages を使えば、GitHub リポジトリと統合された形で[プライベートパッケージをある程度無料で](https://docs.github.com/ja/enterprise-cloud@latest/packages/learn-github-packages/introduction-to-github-packages#github-packages-%E3%81%AE%E8%AB%8B%E6%B1%82%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)ホスティングできます。

\
公開手順 & 配布方法は下記リンクが分かりやすいので参考にしてください。

https://zenn.dev/moneyforward/articles/20230620-github-packages
_↑ とりあえずこれ読めば基本的な使い方を把握できる_

https://qiita.com/marumaru0113/items/21b600c21caf5d9b9775
_↑ プライベートパッケージのインストールには Access Token が必要で、それを良い感じに取り扱って運用する Tips が解説されている_

https://docs.github.com/ja/packages
_↑ 公式 Doc はこれ_

## 参考リンク

https://www.freecodecamp.org/news/how-to-create-and-publish-your-first-npm-package/

https://dev.to/mikhaelesa/create-your-own-npm-create-cli-like-create-vite-3ig7

https://docs.npmjs.com/creating-node-js-modules

https://docs.npmjs.com/cli/v8/commands/npm-init

https://docs.npmjs.com/about-package-readme-files

https://docs.npmjs.com/cli/v11/using-npm/developers

https://docs.npmjs.com/cli/v7/configuring-npm/package-json#files

https://docs.npmjs.com/cli/v7/commands/npm-link

https://qiita.com/hoshimado/items/c6f1484297d974f44f19

https://qiita.com/masato_makino/items/656f4fbb1595cbcdc23d

https://zenn.dev/k0kishima/articles/d75f4dc5bd1a26

https://zenn.dev/taroshun32/articles/npm-package-original

https://dev.classmethod.jp/articles/github-packages-private/
