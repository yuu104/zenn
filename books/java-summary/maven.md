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
- これにより、ローカルにインストールしたパッケージを別ブロジェクトでも使用したい場合、再度リモートからインストールすることなく、`~/md/repository` にあるキャッシュを使用できる

## ビルドと `target` フォルダ

- Java プロジェクトを実行するにはコンパイルが必要
- Maven では、ビルドツールでもある
- ソースコードと `~/.m2/repository` を基にビルドを行い、その結果はプロジェクト直下の `target` フォルダに格納される
