---
title: "GET Request"
---

## 基本的構成

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

## `@RestController` アノテーション

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

## `@GetMapping` アノテーション

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
