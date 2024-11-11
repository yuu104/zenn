---
title: "Maven"
---

## Maven とは

- Java ベースのプロジェクト管理およびビルドツール
- Maven を使うことで依存関係の管理やプロジェクトのビルド、テスト、デプロイなどを自動化できる
- Node.js における npm や yarn に近い

## 依存関係の管理

### POM (Project Object Model)ファイル

- Maven プロジェクトの中心には、`pom.xml`（Project Object Model）が存在する
- `pom.xml` ファイルがプロジェクトのルートに存在し、プロジェクトの設定や依存関係を記述する
- Node.js における `packege.json`
- `<dependencies>` セクションで、プロジェクトが必要とするライブラリを指定する
- Maven は指定された依存関係をダウンロードし、プロジェクトに追加する

```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.3.8</version>
        </dependency>
    </dependencies>
</project>
```

### `pom.xml`の主要な項目

| 項目             | 説明                                                                                                                 | 例                           |
| ---------------- | -------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `<groupId>`      | プロジェクトの一意な識別子。通常、逆ドメイン形式を使用します。                                                       | `com.example`                |
| `<artifactId>`   | プロジェクトの名前。Maven リポジトリ内で一意なパッケージ名を設定します。                                             | `my-app`                     |
| `<version>`      | プロジェクトのバージョン番号です。バージョン管理に役立ちます。                                                       | `1.0.0`                      |
| `<packaging>`    | 成果物の形式を指定します。`jar`、`war`、`pom`などが使用されます。                                                    | `jar`                        |
| `<dependencies>` | プロジェクトが依存する外部ライブラリやモジュールを管理します。Maven は指定された依存関係を自動でダウンロードします。 | `spring-core`（例）          |
| `<build>`        | ビルドプロセスのカスタマイズを行います。主にコンパイルやパッケージの設定を定義します。                               | なし（カスタム設定）         |
| `<plugins>`      | ビルドやテストなど、Maven の特定のフェーズで実行されるプラグインを設定します。                                       | `maven-compiler-plugin`      |
| `<parent>`       | 親プロジェクトを指定し、設定を継承します。マルチモジュールプロジェクトにおいて特に有効です。                         | `parent-project`             |
| `<modules>`      | マルチモジュールプロジェクトの子モジュールを定義します。親プロジェクトの`pom.xml`で使用します。                      | `module-a`, `module-b`       |
| `<properties>`   | プロジェクト内で共通のプロパティを定義し、バージョンや設定値を一元管理します。                                       | `maven.compiler.source: 1.8` |

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

## Maven の標準ディレクトリ構成とクラスパス、パッケージの関連性

Maven には標準的なディレクトリ構成があり、これに従うことでプロジェクトの管理が大幅に簡単になります。
特に、クラスパスやパッケージの関連性について理解することは、効率的な開発環境の構築に不可欠です。

### 標準ディレクトリ構成

Maven プロジェクトは通常、以下のディレクトリ構造を持ちます。

```
プロジェクトルート
    |--- LICENSE.txt    # プロジェクトのライセンス情報を記述するファイル
    |--- README.txt     # プロジェクト情報を記述するファイル
    |--- NOTICE.txt     # プロジェクトの帰属通知を記述するファイル
    |--- pom.xml        # mavenのライフサイクル規定を記述する設定ファイル
    |
    |--- src
    |    |--- main      # 実装するJavaやWebアプリのパッケージを格納するディレクトリ
    |    |     |--- java    # Javaのソースファイルを格納するディレクトリ
    |    |     |              # このディレクトリはアプリケーションの主要なソースコードを保持します。
    |    |     |              # 例えば、`com.example.myapp`というパッケージのクラスは、
    |    |     |              # `src/main/java/com/example/myapp`ディレクトリに格納されます。
    |    |     |              # これにより、Mavenはビルド時に正しいクラスパスを設定し、Javaのクラスローディングメカニズムが
    |    |     |              # クラスパスから適切にクラスを見つけることができます。
    |    |     |
    |    |     |--- resources   # 実行時に利用する設定情報（リソース）ファイルを格納するディレクトリ
    |    |     |              # アプリケーションで使用する設定ファイルやプロパティファイルがここに含まれます。
    |    |     |              # これらのファイルは、ビルド時に`target/classes`にコピーされ、実行時にクラスパスに含まれます。
    |    |     |
    |    |     |--- webapp  # Webアプリに関係するHTMLやCSS、JSPなどを格納するディレクトリ
    |    |     |              # Webアプリケーションの静的ファイルやテンプレートファイルを配置します。
    |    |     |
    |    |     |--- filters # ターゲットとしてフィルタリングするリソースファイルを格納するディレクトリ
    |    |                   # フィルタリングにより環境ごとの設定変更を簡単に行うことができます。
    |
    |    |--- test  # JUnitテストで利用するJavaや設定情報を格納するディレクトリ
    |    |     |--- java    # テストコード（ファイル名はTest**.java、**Test.java、**TestCase.javaのいずれか）
    |    |     |              # `src/test/java`にはユニットテストコードが格納されます。
    |    |     |              # テストコードは、アプリケーションのロジックを確認するために使用され、
    |    |     |              # Mavenは`mvn test`コマンドを実行する際にこのディレクトリをクラスパスに追加します。
    |    |     |
    |    |     |--- resources # テスト実行時に利用する設定情報（リソース）ファイルを格納するディレクトリ
    |    |     |              # テスト用の設定情報やモックデータをここに配置します。
    |    |     |
    |    |     |--- filters # テスト環境ごとにフィルタリングするリソースファイルを格納するディレクトリ
    |    |                   # テスト環境に応じた設定変更を行うことができます。
    |
    |    |--- config    # Mavenプロジェクトの設定ファイルを格納するディレクトリ
    |    |                   # プロジェクト全体の設定情報や外部ツール用の設定ファイルが含まれます。
    |
    |    |--- site      # Webサイトの情報を格納するディレクトリ
    |                    # プロジェクトのドキュメントやサイトの生成に使用されます。
    |
    |--- target
    　      |--- classes # mvn compileでコンパイルされたクラスファイルを格納するディレクトリ
                      # `src/main/java`のソースコードをコンパイルした成果物がここに配置され、実行時に使用されます。
```

1. **`src/main/java`**
   アプリケーションのソースコードがここに格納されます。
   このディレクトリがクラスパスの起点となり、パッケージ名（例：`com.example.myapp`）に対応したディレクトリ構造を持ちます。
   この構造に従うことで、Java コンパイラや Maven がコードを適切に認識し、ビルドや実行が可能になります。
   また、ビルド時にはこのコードが`target/classes`にコンパイルされ、クラスローダがクラスを見つけるために使用されます。

2. **`src/main/resources`**
   アプリケーションで使用するリソースファイルを置く場所です。
   例えば、設定情報やメッセージプロパティファイルなどをここに格納します。
   これらのリソースはビルド時に`target/classes`にコピーされ、アプリケーションの実行中にクラスパスからアクセスできます。

3. **`src/test/java`**
   テストコードが格納されます。
   JUnit などのテストフレームワークを使ったテストクラスをここに配置します。
   `src/main/java`内のクラスをテストする目的で使用され、`mvn test`コマンドによって自動的に実行されます。
   テストクラスは通常、ビジネスロジックの検証やユニットテストのために作成されます。

### クラスパスとパッケージの関連性

Maven では、`src/main/java`以下のディレクトリがクラスパスの起点として扱われます。
例えば、`com.example.myapp`というパッケージは`src/main/java/com/example/myapp`に対応する必要があります。
この構造に従うことで、Java コンパイラや Maven がコードを適切に認識し、ビルドや実行が可能になります。

この標準構造に従うことで、Maven は自動的にクラスパスを設定し、開発者がクラスパスの手動設定を行う手間を省くことができます。
これにより、プロジェクトの保守性と一貫性が向上します。

## マルチモジュールによるモノレポ構成

Maven を使用すると、1 つのリポジトリで複数のモジュールを管理する「モノレポ」構成を簡単に実現できます。
_これにより_、複数の関連プロジェクトを統一して管理し、一括でビルドすることが可能です。

### モノレポ構成の基本

Maven のモノレポ構成では、**親プロジェクト**（ルートプロジェクト）と**子モジュール**（サブプロジェクト）を使います。
親プロジェクトの`pom.xml`が全体の設定を管理し、子モジュールごとの`pom.xml`でモジュール固有の設定を行います。

```
project-root/
├── pom.xml                 # 親プロジェクト（ルート）のPOMファイル
├── module-a/
│   └── pom.xml             # モジュールAのPOMファイル
├── module-b/
│   └── pom.xml             # モジュールBのPOMファイル
└── module-c/
    └── pom.xml             # モジュールCのPOMファイル
```

### 親プロジェクトの設定

親プロジェクトの`pom.xml`では、`<modules>`セクションで各子モジュールを指定します。
この`<module>`タグには、各子モジュールの相対パスを指定します。例えば、`<module>module-a</module>`と記述することで、親プロジェクトから見た`module-a`ディレクトリにあるモジュールをビルド対象とします。

この設定により、Maven は親プロジェクトから子モジュールを一括でビルドすることが可能になります。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>parent-project</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>

    <modules>
        <module>module-a</module>
        <module>module-b</module>
        <module>module-c</module>
    </modules>
</project>
```

### 子モジュールの設定

各子モジュールの`pom.xml`には、親プロジェクトを指定する`<parent>`セクションがあります。
これにより、親プロジェクトの設定を継承しつつ、個別の依存関係や設定を追加できます。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.example</groupId>
        <artifactId>parent-project</artifactId>
        <version>1.0.0</version>
    </parent>

    <artifactId>module-a</artifactId>
</project>
```

### 子モジュール間の依存関係の設定

Maven のマルチモジュールプロジェクトでは、子モジュール同士で相互に利用することが可能です。
例えば、`module-a`から`module-b`の機能を利用したい場合、`module-a`の`pom.xml`に`module-b`を依存関係として追加することで、他のモジュールのクラスやメソッドを使用することができます。

以下の例では、`module-a`が`module-b`に依存していることを示します。

```xml
<dependencies>
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>module-b</artifactId>
        <version>1.0.0</version>
    </dependency>
</dependencies>
```

この設定を行うことで、`module-a`は`module-b`の全てのパブリッククラスおよびメソッドにアクセスできるようになります。
モジュール間の依存を明示的にすることで、コードの再利用が可能になり、また各モジュールの役割を分けて管理することができます。

また、親プロジェクトの`pom.xml`においても全体の依存関係を一元的に管理できるため、各モジュールがどのように連携しているのかがわかりやすくなります。

### モノレポ構成の利点

- **依存関係の管理が一元化**され、複数のモジュール間の依存関係が明確になる。
- **再利用性**が向上し、共通コードを一か所で管理することができる。
- **一括ビルド**が容易で、関連するモジュールをまとめて管理できるため、リリース作業が効率化される。

### 注意点

プロジェクトが大規模になると、全体のビルド時間が長くなることがあり、モジュールごとに個別のビルドを行いたくなる場合があります。
その場合は、特定のモジュールのみをビルドするよう Maven コマンドを調整することができます。

```bash
# 特定のモジュールのみビルド
mvn clean install -pl module-a
```

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
