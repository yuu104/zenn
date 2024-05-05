---
title: "java.lang.Object クラス"
---

## 概要

- 全てのクラスのスーパークラス
- `Object` クラスが提供する基本的なメソッドを、どのクラスでも使用可能

### `toString()` メソッド

インスタンスを文字列として表現した結果を返す。

- **デフォルト実装:**

  - クラス名にインスタンス（オブジェクト）のハッシュコードを連結した文字列を返す

  ```java
  public String toString() {
    return getClass().getName() + "@" + Integer.toHexString(hashCode());
  }
  ```

- **オーバーライドの重要性:**

  - デフォルトの実装では有用な情報を返さず、意味がない
  - オーバーライドすることで、意味ある情報を返すようにする

  ```java
  class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
      this.name = name;
      this.age = age;
    }

    @Override
    public String toString() {
      return "Person{name='" + name + "', age=" + age + "}";
    }
  }
  ```

- **`toString()` メソッドの存在意義**

  `System.out.println()` は、オブジェクトを引数として受け取るときに、`toString()` を自動的に呼び出す。

  ```java
  Person person = new Person("John Doe", 30);
  System.out.println(person);  // Person{name='John Doe', age=30}
  ```

  これにより、以下の目的に利用できる。

  - **デバック:** オブジェクトの状態を簡単に出力して確認できる
  - **ログ記録:** システムのログにオブジェクトの具体的な情報を提供できる
