---
title: "Maven"
---

## Maven とは

- Java ベースのプロジェクト管理およびビルドツール
- Maven を使うことで依存関係の管理やプロジェクトのビルド、テスト、デプロイなどを自動化できる
- Node.js における npm や yarn に近い

## 依存関係の管理

### POM (Project Object Model)ファイル

- `pom.xml` ファイルがプロジェクトのルートに存在し、プロジェクトの設定や依存関係を記述する
- Node.js における `packege.json`
- `<dependencies>` セクションで、プロジェクトが必要とするライブラリを指定する
- Maven は指定された依存関係をダウンロードし、プロジェクトに追加する

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
</project>
```

### 依存関係の保存先

- Maven によりインストールされたパッケージは `~/.m2/repository` に保管される
- つまり、ユーザー単位でグローバルに保管される
- これにより、ローカルにインストールしたパッケージを別ブロジェクトでも使用したい場合、再度リモートからインストールすることなく、`~/m2/repository` にあるキャッシュを使用できる

## ビルドと `target` フォルダ

- Java プロジェクトを実行するにはコンパイルが必要
- Maven では、ビルドツールでもある
- ソースコードと `~/.m2/repository` を基にビルドを行い、その結果はプロジェクト直下の `target` フォルダに格納される

## Maven コマンド（npm とのた対応あり）

| **npm コマンド**       | **Maven コマンド**                        | **説明**                                                                                                                                                   |
| ---------------------- | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `npm install`          | `mvn install`                             | 依存関係をインストールし、プロジェクトをビルドします。Maven の場合、`mvn install`はローカルリポジトリにパッケージをインストールする意味も含みます。        |
| `npm start`            | `mvn spring-boot:run`                     | アプリケーションを実行します。Spring Boot アプリケーションを直接実行するために使用します。                                                                 |
| `npm run <script>`     | `mvn <goal>`                              | 任意のスクリプト（ゴール）を実行します。Maven のゴール（フェーズ）を指定して実行します。                                                                   |
| `npm test`             | `mvn test`                                | プロジェクトのテストを実行します。Maven は JUnit などのテストフレームワークを使用してテストを実行します。                                                  |
| `npm run build`        | `mvn package`                             | プロジェクトをビルドしてパッケージ化します。Maven ではプロジェクトをパッケージ（jar または war ファイル）としてビルドします。                              |
| `npm run clean`        | `mvn clean`                               | ビルド生成物をクリーン（削除）します。ターゲットディレクトリをクリーンアップします。                                                                       |
| `npm outdated`         | `mvn versions:display-dependency-updates` | 依存関係の更新状況を表示します。                                                                                                                           |
| `npm update`           | `mvn versions:use-latest-versions`        | 依存関係を最新バージョンに更新します。                                                                                                                     |
| `npx create-react-app` | `mvn archetype:generate`                  | 新しいプロジェクトを生成します。Maven ではアーキタイプを使用してプロジェクトのスケルトンを生成します。                                                     |
| `npm init`             | N/A                                       | npm プロジェクトを初期化します。Maven には直接対応するコマンドはありませんが、プロジェクトの初期化は`pom.xml`の手動作成や IDE のテンプレートを使用します。 |

### `npm install` vs `mvn install`

- **npm**: `package.json`に定義された依存関係をインストールする
- **Maven**: `pom.xml`に定義された依存関係をインストールし、プロジェクトをビルドし、ローカルリポジトリにパッケージをインストールする

### `npm start` vs `mvn spring-boot:run`

- **npm**: `package.json`の`scripts`セクションで定義された`start`スクリプトを実行する
- **Maven**: Spring Boot アプリケーションを実行する

### `npm run <script>` vs `mvn <goal>`

- **npm**: `package.json`の`scripts`セクションで定義された任意のスクリプトを実行する
- **Maven**: 任意の Maven ゴール（フェーズ）を実行します。例えば、`mvn compile`でコンパイルを行う

### `npm test` vs `mvn test`

- **npm**: テストスクリプトを実行する（通常、Jest や Mocha などを使用）
- **Maven**: `src/test/java`ディレクトリ内の JUnit テストを実行する

### `npm run build` vs `mvn package`

- **npm**: プロジェクトをビルドする（通常、Web アプリケーションの場合はバンドルを作成）
- **Maven**: プロジェクトをビルドし、jar または war ファイルとしてパッケージ化する

### `npm run clean` vs `mvn clean`

- **npm**: 通常、カスタムスクリプトとして定義されるビルド生成物を削除する
- **Maven**: `target`ディレクトリをクリーンアップする

### `npm outdated` vs `mvn versions:display-dependency-updates`

- **npm**: 依存関係のバージョンの更新状況を表示する
- **Maven**: 依存関係の最新バージョンを表示する

### `npm update` vs `mvn versions:use-latest-versions`

- **npm**: 依存関係を最新バージョンに更新する
- **Maven**: 依存関係を最新バージョンに更新する

### `npx create-react-app` vs `mvn archetype:generate`

- **npm**: React アプリケーションのスケルトンを生成する
- **Maven**: プロジェクトのアーキタイプを使用して、新しいプロジェクトのスケルトンを生成する

### `npm init` vs プロジェクトの初期化

- **npm**: 新しい`package.json`ファイルを生成し、プロジェクトを初期化する
- **Maven**: 新しいプロジェクトを初期化するために、`pom.xml`ファイルを作成するか、IDE のテンプレート機能を使用する

## Maven Wrapper

Maven Wrapper は、プロジェクト内で特定のバージョンの Maven を使用するためのツールです。これにより、以下のメリットが得られます：

- 開発者がローカルに Maven をインストールする必要がなくなる
- プロジェクト全体で一貫した Maven のバージョンを使用できる
- CI/CD 環境での設定が簡単になる

### Maven Wrapper の主要コンポーネント

Maven Wrapper は主に以下の 3 つのコンポーネントで構成されています：

1. `.mvn` ディレクトリ
2. `mvnw` スクリプト（Unix 系システム用）
3. `mvnw.cmd` スクリプト（Windows 用）

それぞれの詳細は以下の通りです：

1. **`.mvn` ディレクトリ**

   - **目的**: Maven Wrapper の設定と必要なファイルを格納
   - **主な内容**:
     - `wrapper/maven-wrapper.jar`: Wrapper の実行に必要な JAR ファイル
     - `wrapper/maven-wrapper.properties`: Wrapper の設定ファイル（使用する Maven のバージョンなど）
   - **役割**:
     - プロジェクト固有の Maven 設定を保持
     - Wrapper の動作に必要なファイルを提供

2. **`mvnw` スクリプト（Unix 系システム用）**

   - **目的**: Unix 系システム（Linux, macOS）で Maven Wrapper を起動するためのシェルスクリプト
   - **使用方法**: `./mvnw [Maven コマンド]`
     例: `./mvnw clean install`
   - **役割**:
     - システムにインストールされた Maven の代わりに Wrapper 版の Maven を使用
     - 必要に応じて指定されたバージョンの Maven をダウンロード
     - Maven コマンドを実行

3. **`mvnw.cmd` スクリプト（Windows 用）**

   - **目的**: Windows システムで Maven Wrapper を起動するためのバッチスクリプト
   - **使用方法**: `mvnw.cmd [Maven コマンド]`
     例: `mvnw.cmd clean install`
   - **役割**:
     - `mvnw` と同様の機能を Windows 環境で提供

### Maven Wrapper の利点

1. **環境の一貫性**: 全開発者が同じバージョンの Maven を使用
2. **簡単なセットアップ**: Maven のインストールが不要
3. **CI/CD との統合**: ビルドサーバーでの Maven インストールが不要
4. **バージョン管理**: プロジェクトごとに異なる Maven バージョンの使用が可能

### 使用例

```bash
# Unix系システムの場合
./mvnw clean install

# Windowsの場合
mvnw.cmd clean install
```

これらのコンポーネントにより、Maven がインストールされていない環境でもプロジェクトのビルドやテストが可能になり、開発プロセスの一貫性と効率性が向上します。
