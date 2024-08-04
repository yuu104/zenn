---
title: "Hello, World"
---

## Spring Initializer

Spring Initializr は、Spring Boot プロジェクトの初期セットアップを自動化するツールです。
以下に、Spring Initializr が提供する主な機能と利点を詳しく説明します。

1. **プロジェクト構造の生成**

   - 標準的な Maven/Gradle プロジェクト構造を自動生成します
   - `src/main/java` や `src/test/java` などのディレクトリ構造を作成します

2. **`pom.xml`（または `build.gradle`）ファイルの生成**

   - プロジェクトの基本情報（`groupId`, `artifactId`, `version`）を設定します
   - Spring Boot Starter Parent（または依存関係管理）を設定します
   - 選択された依存関係を適切なバージョンで追加します

3. **アプリケーションのエントリーポイントの生成**

   - メインクラス（`@SpringBootApplication` アノテーション付き）を作成します
   - これにより、アプリケーションの起動が容易になります

4. **設定ファイルの生成**

   - `application.properties` または `application.yml` ファイルを生成します
   - 必要に応じて、基本的な設定を含めます

5. **依存関係の選択と追加**

   - Web、データベース、セキュリティなど、様々な Spring Boot Starter を選択できます
   - 選択した依存関係に基づいて、必要なライブラリを自動的に `pom.xml` に追加します

6. **Spring Boot バージョンの選択**

   - 使用する Spring Boot のバージョンを選択できます
   - 選択されたバージョンに互換性のある依存関係を自動的に設定します

7. **ビルドツールの選択**

   - Maven または Gradle を選択できます
   - 選択したビルドツールに応じた設定ファイルを生成します

8. **プログラミング言語の選択**

   - Java、Kotlin、Groovy から選択できます
   - 選択した言語に適したソースファイルと設定を生成します

9. **メタデータの設定**

   - プロジェクト名、説明、パッケージ名などを設定できます

10. **Gitignore ファイルの生成**

    - プロジェクトに適した Gitignore ファイルを生成します

11. **テスト環境のセットアップ**

    - JUnit などのテストフレームワークの設定を含めます
    - 基本的なテストクラスを生成します

12. **カスタマイズオプション**

    - Java/Kotlin/Groovy のバージョン選択
    - パッケージング（JAR/WAR）の選択
    - Java 互換性レベルの設定

13. **依存関係の互換性保証**

    - 選択された全ての依存関係が互いに互換性があることを確認します

Spring Initializr は、これらの機能を通じて、開発者がプロジェクトの基本セットアップに時間を費やすことなく、迅速にアプリケーション開発を開始できるようにします。

https://qiita.com/smats-rd/items/ec2dc566bfb4b92f04d5

今回は以下のように設定します。

1. **ビルドツール**
   Maven
2. **Spring Boot のバージョン**
   3.0.2
3. **使用言語**
   Java
4. **Group Id**
   `com.example`
5. **Artifacr Id**
   `demo`
6. **パッケージタイプ**
   Jar
7. **Java のバージョン**
   17
8. **依存ライブラリ**
   | ライブラリ | 説明 |
   | ---- | ---- |
   | Spring Boot DevTools | 開発効率を上げるための補助ツールで、Web アプリケーションのホットリロードを可能にしてくれます。 |
   | Lambok | Lambok が使えるようになる |
   | H2 | H2 データベースを使えるようになる |
   | Spring Web | |

すると、以下のようなディレクトリ構成が自動生成されます。

```
demo/
├── .mvn/
├── .vscode/
├── src/
│   ├── main/
│   └── test/
├── target/
├── .gitignore
├── HELP.md
├── mvnw
├── mvnw.cmd
└── pom.xml
```

今回は Docker を使用したコンテナ開発なので、Maven Wrapper は必要ありません。
よって、`.mvn`, `mvnw`, `mvnw.cmd` は削除します。

```
demo/
├── .vscode/
├── src/
│   ├── main/
│   └── test/
├── target/
├── .gitignore
├── HELP.md
└── pom.xml
```

## Docker

### `Dockerfile`

```Dockerfile
FROM maven:3.9.5-eclipse-temurin-17
WORKDIR /usr/app
```

Maven と Java17 がインストールされているベースイメージを採用します。
これにより、ホストマシンには Java 環境を用意する必要がありません。

## `.dockerignore`

```.dockerignore: .dockerignore
# すべてを無視する
**

# ただし、以下は許可する
!src/**
!pom.xml
```

### `compose.yaml`

```yaml: compose.yaml
services:
  app:
    build: .
    volumes:
      - type: bind
        source: .
        target: /usr/app
    ports:
      - "8080:8080"
    entrypoint: ["mvn", "spring-boot:run", "-e"]
```

全てのファイルをバインドマウントしています。
Maven のローカルリポジトリもコンテナ内で生成します。

## Makefile

```Makefile: Makefile
clean:
	docker compose down --rmi all

dev:
	docker compose up app --build

down:
	docker compose down

bash-app:
	docker compose exec app /bin/bash
```

## エントリーポイント

Spring Boot プロジェクトを作成すると、`/src/main/java/[Group Id]/[Artifact Id]/[Artifact Id]+[Application].java` が生成されていると思います。
このファイルは、Spring Boot アプリケーションのメインクラスであり、エントリーポイントとなります。

```java: DemoApplication.java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
```

### `@SpringBootApplication` アノテーション

- `@Configuration`, `@EnableAutoConfiguration`, `@ComponentScan` を組み合わせたアノテーション
- アプリケーションのコンフィギュレーション、自動設定、コンポーネントスキャンを有効にする

## GET API を作成する

以下のファイルを作成します。

```java: /src/main/java/com/example/demo/controller/HelloController.java
package com.example.demo.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class HelloController {
  @GetMapping("/hello")
  public String getHello() {
      return new String("sample");
  }
}
```

### `@RestController` アノテーション

1. **定義**
   `@RestController`は、Spring Framework で提供されるアノテーションで、RESTful Web サービスのコントローラーを定義するために使用されます。

2. **構成**

   - `@RestController` = `@Controller` + `@ResponseBody`
   - これは複合アノテーションであり、`@Controller`と`@ResponseBody`の機能を組み合わせています

3. **主な目的**

   - RESTful API エンドポイントの作成を簡素化すること
   - HTTP リクエストを処理し、直接データ（通常は JSON 形式）をレスポンスとして返すこと

4. **動作**

   - このアノテーションが付与されたクラスのすべてのメソッドの戻り値は、自動的にレスポンスボディとして扱われます
   - 戻り値のオブジェクトは、適切な`HttpMessageConverter`を使用して自動的に JSON（または XML）に変換されます

5. **主な特徴**
   - ビューの解決を行わず、データを直接返します
   - 各メソッドに`@ResponseBody`を付ける必要がありません
   - `@RequestBody`アノテーションと組み合わせて使用すると、リクエストボディを自動的に Java オブジェクトにデシリアライズできます

### `@GetMapping` アノテーション

1. **定義**
   `@GetMapping` は Spring Framework のアノテーションで、HTTP GET リクエストを特定のハンドラメソッドにマッピングするために使用されます。

2. **目的**

   - HTTP GET メソッドを使用してリソースを取得するエンドポイントを定義します
   - URL パターンとメソッドを関連付けます

3. **属性**

   - `value` または `path`: URL パターンを指定します
   - `produces`: 生成するコンテンツタイプを指定します
   - `consumes`: 受け入れるコンテンツタイプを指定します
   - `headers`: 特定のヘッダーが存在する場合のみマッピングします
   - `params`: 特定のリクエストパラメータが存在する場合のみマッピングします

4. **URL パターンの例**

   ```java
   @GetMapping("/users/{id}")
   public User getUser(@PathVariable Long id) {
       // 特定のユーザーを返すロジック
   }
   ```

5. **複数のパスの指定**

   ```java
   @GetMapping({"/users", "/members"})
   public List<User> getUsers() {
       // 複数のパスでアクセス可能
   }
   ```

6. **コンテンツタイプの指定**

   ```java
   @GetMapping(value = "/users", produces = "application/json")
   public List<User> getUsersJson() {
       // JSONを返す
   }
   ```

7. **カスタムヘッダーの要求**

   ```java
   @GetMapping(value = "/users", headers = "X-API-VERSION=1")
   public List<User> getUsersV1() {
       // 特定のヘッダーが存在する場合のみ実行
   }
   ```

8. **正規表現を用いたパスマッピング**

   ```java
   @GetMapping("/users/{id:[0-9]+}")
   public User getUserById(@PathVariable Long id) {
       // IDが数字の場合のみマッチ
   }
   ```

9. **`@RequestMapping` との関係**

   - `@GetMapping` は `@RequestMapping(method = RequestMethod.GET)` の省略形です
   - 他の HTTP メソッド用に `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping` も存在します
