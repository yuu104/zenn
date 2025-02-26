---
title: "ES ModulesとCommon JS。そしてTypeScript"
---

## 1. はじめに：モジュールシステムの混沌

JavaScript のモジュールシステムは長年にわたり進化してきました。特に「CommonJS」と「ES Modules」という 2 つの主要なモジュールシステムの共存状態は、多くの開発者に混乱をもたらしています。さらに TypeScript が加わると、その複雑さは増します。この記事では、これらの関係性を整理し、実務での判断基準を明確にします。

## 2. モジュールシステムの基本

### 2.1 CommonJS (CJS)

Node.js の伝統的なモジュールシステムです。

```javascript
// インポート
const module = require("./module");

// エクスポート
module.exports = { function1, function2 };
```

**特徴：**

- 動的読み込みが可能（条件分岐内での require）
- Node.js 環境で長く使われてきた標準
- ファイル拡張子の省略が可能

### 2.2 ES Modules (ESM)

ECMAScript 標準のモジュールシステムです。

```javascript
// インポート
import module from './module.js';

// エクスポート
export const function1 = () => {};
export default function2() {};
```

**特徴：**

- 静的解析が可能（トップレベルでの import）
- ブラウザでネイティブサポート
- 非同期インポートをサポート（dynamic import）
- ESM では拡張子が必須

## 3. 歴史的背景と現状

```
【モジュールシステムの進化】
2009: CommonJS策定（Node.js向け）
2015: ES Modules仕様策定（ES2015/ES6）
2018: Node.jsがES Modulesの実験的サポート開始
2020: Node.jsがES Modulesを正式サポート
現在: 移行期（両方のシステムが共存）
```

現在の JavaScript エコシステムは「移行期」にあります。ESM は将来の標準ですが、膨大な数のライブラリとプロジェクトが CommonJS で書かれている状況です。

## 4. Node.js におけるモジュールシステム設定

Node.js では`package.json`の`type`フィールドでプロジェクト全体のデフォルトモジュールシステムを指定します。

```json
{
  "type": "module" // .jsファイルをESMとして扱う
}
```

`type`フィールドが未指定の場合は、歴史的経緯により`"commonjs"`がデフォルト値となります。

### 4.1 ファイル拡張子によるオーバーライド

| 拡張子 | モジュールタイプ                | 備考                                     |
| ------ | ------------------------------- | ---------------------------------------- |
| `.mjs` | **常に ESM**                    | package.json の設定に関わらず            |
| `.cjs` | **常に CommonJS**               | package.json の設定に関わらず            |
| `.js`  | **package.json の`type`に依存** | `type: "module"`なら ESM、それ以外は CJS |

### 4.2 ESM におけるインポートパスの注意点

ESM は拡張子を省略できない仕様です：

```javascript
// ✅ 正しい
import { something } from "./module.js";

// ❌ 誤り（拡張子の省略）
import { something } from "./module";
```

これは Node.js の CommonJS との大きな違いの一つです。

## 5. TypeScript におけるモジュールシステム設定

TypeScript はトランスパイル時のモジュールシステムを`tsconfig.json`で詳細に制御できます。

### 5.1 主要な設定項目

```json
{
  "compilerOptions": {
    "target": "ES2020", // 出力JSのバージョン
    "module": "NodeNext", // 出力モジュール形式
    "moduleResolution": "NodeNext", // モジュール解決方法
    "esModuleInterop": true // モジュール間互換性
    // その他の設定...
  }
}
```

### 5.2 `module` - 出力モジュール形式

| 設定値       | 出力形式                    | 特徴                               |
| ------------ | --------------------------- | ---------------------------------- |
| `"CommonJS"` | `require()/module.exports`  | Node.js 互換、最も安定             |
| `"AMD"`      | AMD 形式                    | ブラウザ用（レガシー）             |
| `"UMD"`      | Universal Module Definition | CJS/AMD の両対応（レガシー）       |
| `"ES2015"`   | ES Modules（ES2015）        | 基本的な ESM 機能                  |
| `"ES2020"`   | ES Modules（ES2020）        | dynamic import など追加機能        |
| `"ESNext"`   | 最新の ESM 仕様             | 最新機能を含む                     |
| `"Node16"`   | Node.js v16 互換            | `package.json`の`type`に依存       |
| `"NodeNext"` | 最新 Node.js 互換           | `package.json`の`type`に依存、推奨 |

特に重要なのは`"NodeNext"`（または`"Node16"`）設定です。これは`package.json`の`type`フィールドに基づいて適切なモジュール形式を選択します：

```
NodeNext + type:"module"    ⟹ ESM出力
NodeNext + type未指定      ⟹ CommonJS出力
```

### 5.3 `moduleResolution` - モジュール解決アルゴリズム

| 設定値       | 解決アルゴリズム                      | 推奨用途                 |
| ------------ | ------------------------------------- | ------------------------ |
| `"Classic"`  | TypeScript 1.6 以前の方式（レガシー） | 非推奨                   |
| `"Node"`     | Node.js CommonJS スタイル             | CommonJS プロジェクト    |
| `"Node16"`   | Node.js ESM 対応スタイル              | Node.js ESM プロジェクト |
| `"NodeNext"` | 最新 Node.js 形式                     | 最新プロジェクト（推奨） |
| `"Bundler"`  | (TS5.0+) モダンバンドラー向け         | Webpack/Vite 等と併用    |

**`moduleResolution`の挙動の違い：**

```typescript
import { something } from "./module";

// "Node" - 以下の順序で解決
// 1. ./module.ts
// 2. ./module.tsx
// 3. ./module.d.ts
// 4. ./module/index.ts
// (拡張子省略OK)

// "NodeNext" & ESM - 拡張子必須
// import { something } from './module'; // エラー
// import { something } from './module.js'; // 正しい
// (実際のファイルは module.ts だが .js と記述)
```

### 5.4 `target` - 出力 JavaScript のバージョン

この設定は、TypeScript が出力する JavaScript の ECMAScript バージョンを制御します：

```json
"target": "ES2020"
```

#### 利用可能な値と特徴

| 設定値               | 対応する JS バージョン | 主な機能                               |
| -------------------- | ---------------------- | -------------------------------------- |
| `"ES3"`              | ECMAScript 3 (1999)    | 最も古い、IE6 互換                     |
| `"ES5"`              | ECMAScript 5 (2009)    | IE11 互換、`forEach`など               |
| `"ES2015"` / `"ES6"` | ECMAScript 2015        | クラス、アロー関数、`let`/`const`      |
| `"ES2017"`           | ECMAScript 2017        | `async`/`await`                        |
| `"ES2020"`           | ECMAScript 2020        | オプショナルチェーン、Nullish 結合     |
| `"ES2022"`           | ECMAScript 2022        | クラスフィールド、プライベートメンバー |
| `"ESNext"`           | 最新の機能             | 今後の標準機能（不安定な場合あり）     |

#### コード変換例

```typescript
// TypeScriptソースコード
const value = obj?.prop?.method?.();

// ES2020以上の出力
const value = obj?.prop?.method?.();

// ES2019以下への出力
const value =
  obj === null || obj === void 0
    ? void 0
    : obj.prop === null || obj.prop === void 0
    ? void 0
    : (_a = obj.prop.method) === null || _a === void 0
    ? void 0
    : _a.call(obj.prop);
```

#### 環境ごとの推奨設定

| 対象環境        | 推奨 target | メリット                       |
| --------------- | ----------- | ------------------------------ |
| Node.js 18+     | `"ES2022"`  | 最新機能、コード量削減         |
| Node.js 16+     | `"ES2021"`  | 高い互換性とパフォーマンス     |
| モダンブラウザ  | `"ES2020"`  | 良好な互換性とコンパクトな出力 |
| IE11 を含む環境 | `"ES5"`     | 広範なブラウザ互換性           |

#### `target`と`module`の関係

1. **機能制約**：一部のモジュール機能には最低限の`target`が必要

   - `module: "ES2020"`には`target: "ES2020"`以上が推奨（dynamic import などの機能のため）

2. **自動調整**：一部の設定では自動調整が行われる
   - `target`が`"ES3"`または`"ES5"`の場合、`module: "ES6"`以上を指定しても一部の構文は下位互換コードに変換される

### 5.5 モジュール間の互換性設定

```json
"esModuleInterop": true
```

この設定を有効にすると：

1. CommonJS モジュールを ESM 方式でインポート可能になる
2. `import * as x from 'y'`と`import x from 'y'`の区別が明確になる

```typescript
// esModuleInterop: false の場合
import * as React from "react"; // 正しい
import React from "react"; // エラー

// esModuleInterop: true の場合
import React from "react"; // 正しい（推奨）
```

### 5.6 その他の関連設定

```json
"allowSyntheticDefaultImports": true, // デフォルトエクスポートがないモジュールでもデフォルトインポート構文を許可
"resolveJsonModule": true,           // JSONファイルを直接インポート可能に
"isolatedModules": true,             // ファイルごとの単独トランスパイルでも安全なコードを強制
"baseUrl": "./",                     // 非相対インポートのベースディレクトリ
"paths": {                           // インポートパスのエイリアス
  "@/*": ["src/*"]                  // import x from '@/utils' → src/utils
}
```

## 6. TypeScript + ESM での特殊な注意点

TypeScript で ESM 開発をする場合、以下の特殊な規則があります：

### 6.1 インポートパスの拡張子

ESM プロジェクトでは、インポートパスに`.js`拡張子を使用します（実際のファイルは`.ts`）：

```typescript
// ✅ 正しい（.ts ファイル内）
import { something } from "./module.js";

// ❌ 誤り - 拡張子がない
import { something } from "./module";

// ❌ 誤り - .ts 拡張子を使用
import { something } from "./module.ts";
```

このルールは一見混乱しますが、**コンパイル後のファイル名と一致させるため**の仕様です。

## 7. 実践的な TypeScript 設定パターン

### 7.1 Node.js + ESM プロジェクト

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "outDir": "dist"
  }
}

// package.json
{
  "type": "module",
  "main": "dist/index.js"
}
```

### 7.2 Node.js + CommonJS プロジェクト

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "CommonJS",    // または NodeNext + package.jsonで type 未指定
    "moduleResolution": "Node",
    "esModuleInterop": true,
    "outDir": "dist"
  }
}

// package.json
{
  // type未指定 = "commonjs"がデフォルト
  "main": "dist/index.js"
}
```

### 7.3 デュアルパッケージ（ESM + CommonJS の両対応）

```json
// package.json
{
  "name": "my-package",
  "type": "module",
  "main": "./dist/cjs/index.js", // CommonJS用エントリーポイント
  "module": "./dist/esm/index.js", // ESM用エントリーポイント（旧形式）
  "exports": {
    ".": {
      "import": "./dist/esm/index.js", // ESM環境向け
      "require": "./dist/cjs/index.js", // CommonJS環境向け
      "types": "./dist/types/index.d.ts" // TypeScript型定義
    }
  }
}
```

ビルドスクリプト例：

```json
"scripts": {
  "build:esm": "tsc --module ESNext --outDir dist/esm",
  "build:cjs": "tsc --module CommonJS --outDir dist/cjs",
  "build": "npm run build:esm && npm run build:cjs"
}
```

または複数の設定ファイルを使用：

```json
// tsconfig.base.json - 共通設定
{
  "compilerOptions": {
    "target": "ES2020",
    "esModuleInterop": true,
    "declaration": true,
    "strict": true
  }
}

// tsconfig.esm.json - ESM用
{
  "extends": "./tsconfig.base.json",
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "NodeNext",
    "outDir": "dist/esm"
  }
}

// tsconfig.cjs.json - CommonJS用
{
  "extends": "./tsconfig.base.json",
  "compilerOptions": {
    "module": "CommonJS",
    "moduleResolution": "Node",
    "outDir": "dist/cjs"
  }
}
```

## 8. よくある問題と解決策

### 8.1 「拡張子が見つからない」エラー

```
Error: Cannot find module './module' or its corresponding type declarations.
```

**解決策：**

- ESM プロジェクト（`type: "module"`）: インポートに`.js`拡張子を追加
- `moduleResolution: "NodeNext"`での共通問題

### 8.2 「デフォルトエクスポートが見つからない」エラー

```
Module '"xxx"' has no default export.
```

**解決策：**

- `esModuleInterop: true`を設定
- 名前付きインポートを使用: `import { something } from 'xxx'`

### 8.3 混沌の原因と実務上の混乱ポイント

多くのプロジェクトでは表面上 ESM 構文を使いながらも、実際には CJS として動作しています：

```typescript
// ESM風の構文を使用
import { something } from "./module";

// しかし拡張子を省略（CJSの慣習）
// TypeScriptやWebpackが内部で解決
```

この状況が続く理由：

1. バンドラー（Webpack/Rollup など）が拡張子の省略をサポート
2. TypeScript コンパイラが内部で適切な変換を実行
3. トランスパイラが ESM 構文 →CJS 出力に変換

## 9. 高度な設定オプション

### 9.1 条件付きエクスポート（package.json）

```json
"exports": {
  ".": {
    "types": "./dist/index.d.ts",
    "node": {
      "import": "./dist/node/esm/index.js",
      "require": "./dist/node/cjs/index.js"
    },
    "browser": {
      "import": "./dist/browser/esm/index.js",
      "require": "./dist/browser/cjs/index.js"
    },
    "default": "./dist/index.js"
  }
}
```

これにより、環境とモジュールシステムに応じて適切なファイルが使用されます。

### 9.2 TypeScript のパスマッピング

```json
"baseUrl": "./",
"paths": {
  "#internal/*": ["./src/internal/*"],
  "#config": ["./config/index.ts"]
}
```

## 10. 将来展望とベストプラクティス

### 10.1 モジュールシステムの将来

モジュールシステムの状況は徐々に収束に向かっています：

1. **短期的見通し（1-2 年）**: デュアルパッケージが主流
2. **中期的見通し（3-5 年）**: ESM が主流、CJS は互換性のために存続
3. **長期的見通し（5 年以上）**: ESM が標準、CJS は特殊なケースのみ

### 10.2 現時点でのベストプラクティス

1. **新規プロジェクト**:

   - フロントエンド専用: ESM 推奨
   - Node.js 専用: 両方サポートを検討（移行期のため）
   - ライブラリ開発: デュアルパッケージが最適解

2. **TypeScript 設定**:

   ```json
   // モダンなアプローチ
   {
     "compilerOptions": {
       "target": "ES2020",
       "module": "NodeNext",
       "moduleResolution": "NodeNext",
       "esModuleInterop": true
     }
   }
   ```

3. **インポート文**:

   ```typescript
   // ESMプロジェクトでの推奨（拡張子必須）
   import { something } from "./module.js";

   // CJSプロジェクトでの一般的な書き方（拡張子省略可）
   import { something } from "./module";
   ```

## 11. 結論

JavaScript モジュールシステムの現状は確かに混沌としています。しかし、この混乱は標準化に向けた過渡期の表れでもあります。Node.js と TypeScript のエコシステムにおけるモジュールシステムの選択は複雑ですが、適切な設定を理解することで一貫性のある開発環境を構築できます。

未来に向けた準備としては、ESM の採用を視野に入れつつ、現実的な互換性のためのステップを踏むことが賢明なアプローチと言えるでしょう。両方のモジュールシステムの特性と制約を理解することで、この移行期をより効果的に乗り切ることができます。

## 参考リンク

https://zenn.dev/yodaka/articles/596f441acf1cf3
