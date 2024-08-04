---
title: "H2データベース"
---

## H2 データベースとは

インメモリ型のデータベースです。インメモリ型データベースは、全てのデータをメモリ上に持ちます。
そのため、Spring Boot の起動中しかデータベースを使えません。Spring Boot を再起動すると、テーブルもデータも消えてしまいます。
その仕組みを利用して、テストや学習などに H2 データベースが利用されます。

## 依存関係のインストール

```xml: pom.xml
<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <scope>runtime</scope>
</dependency>
```

## `application.properties` の設定

はい、最新の Spring Boot（3.x 系）に対応した設定に修正し、説明します：

```properties
# データソースの設定
spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# SQLスクリプトの設定
spring.sql.init.encoding=UTF-8
spring.sql.init.mode=always
spring.sql.init.schema-locations=classpath:schema.sql
spring.sql.init.data-locations=classpath:data.sql

# H2コンソールの設定
spring.h2.console.enabled=true
```

1. `spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE`

   - インメモリ H2 データベースを使用し、名前を"testdb"とします
   - `DB_CLOSE_DELAY=-1`: 最後の接続が閉じられた後もデータベースを開いたままにします
   - `DB_CLOSE_ON_EXIT=FALSE`: JVM 終了時にデータベースを閉じないようにします

2. `spring.datasource.driver-class-name=org.h2.Driver`

   - H2 データベースの JDBC ドライバクラスを指定します

3. `spring.datasource.username=sa`

   - データベース接続のユーザー名を設定します（"sa"は System Administrator の略）

4. `spring.datasource.password=`

   - データベース接続のパスワードを空に設定します

5. `spring.sql.init.encoding=UTF-8`

   - SQL スクリプトのエンコーディングを UTF-8 に設定します

6. `spring.sql.init.mode=always`

   - アプリケーション起動時に常に SQL スクリプトを実行します
   - `always`: 毎回実行
   - `embedded`: 組み込みデータベースの場合のみ実行
   - `never`: 実行しない

7. `spring.sql.init.schema-locations=classpath:schema.sql`

   - スキーマ定義用 SQL ファイルの場所を指定します
   - `classpath:` は `src/main/resources` のことです

8. `spring.sql.init.data-locations=classpath:data.sql`

   - 初期データ挿入用 SQL ファイルの場所を指定します
   - `classpath:` は `src/main/resources` のことです

9. `spring.h2.console.enabled=true`
   - H2 データベースの Web コンソールを有効にします

これらの設定により：

- インメモリの H2 データベースが設定されます
- アプリケーション起動時に`schema.sql`でスキーマが作成され、`data.sql`で初期データが挿入されます
- H2 コンソールが有効になり、ブラウザから直接データベースの内容を確認・操作できます

## 初期 SQL を用意する

```sql: src/main/resources/schema.sql
CREATE TABLE IF NOT EXISTS employee (
  id VARCHAR(50)
  PRIMARY KEY,
  name VARCHAR(50),
  age INT
);
```

```sql: src/main/resources/data.sql
INSERT INTO employee (id, name, age) VALUES('1', 'Tom', 30);
```
