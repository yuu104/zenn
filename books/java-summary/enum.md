---
title: "enum"
---

## enum とは？

- 複数の定数を一つのクラスとしてまとめておくことができる型
- enum で定義する定数を**列挙子**と呼ぶ
- enum はクラスとして定義される
- フィールドやメソッドも定義できる

### 基本構文

```java
public enum Day {
  SUNDAY,
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY
}
```

- `Day` という `enum` 型を定義している
- 週の各曜日を定数として列挙している

### 利用例

```java
public class EnumExample {
  public static void main(String[] args) {
    Day today = Day.MONDAY;

    switch (today) {
      case MONDAY:
        System.out.println("Start of the work week");
        break;
      case FRIDAY:
        System.out.println("End of the work week");
        break;
      case SATURDAY:
      case SUNDAY:
        System.out.println("Weekend");
        break;
      default:
        System.out.println("Midweek");
        break;
    }
  }
}
```

## 目的

- 定数のグループを型安全に扱うこと
- これにより、マジックナンバーや文字列の使用を避け、エラーを減少させることができる

## 解決したい技術的課題

**問題点:**

- マジックナンバーや文字列リテラルの多用により、コードの可読性が低下し、エラーが発生しやすくなる
- 定数グループの管理が困難になる

**解決策:**

- `enum` を使用して定数グループを定義することで、コードの可読性を向上させ、型安全性を確保する

## 定数（列挙子）の正体はインスタンス

- `enum` で定義された列挙子は、enum クラスのインスタンス
- enum はクラスであり、列挙子は**クラス唯一のインスタンス**

```java
public enum Day {
    SUNDAY,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
}
```

上記 enum では、`SUNDAY`、`MONDAY` などはすべて `Day` クラスのインスタンス。

enum の内部を擬似的に再現すると、以下のような感じ。

```java
public final class Day extends Enum<Day> {
  // 定数
  public static final Day SUNDAY = new Day("SUNDAY", 0);
  public static final Day MONDAY = new Day("MONDAY", 1);
  public static final Day TUESDAY = new Day("TUESDAY", 2);
  public static final Day WEDNESDAY = new Day("WEDNESDAY", 3);
  public static final Day THURSDAY = new Day("THURSDAY", 4);
  public static final Day FRIDAY = new Day("FRIDAY", 5);
  public static final Day SATURDAY = new Day("SATURDAY", 6);

  private static final Day[] VALUES = {SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY};

  // フィールド
  private final String name;
  private final int ordinal;

  // コンストラクタ
  private Day(String name, int ordinal) {
    this.name = name;
    this.ordinal = ordinal;
  }

　// メソッド
  public String name() {
    return name;
  }

  public int ordinal() {
    return ordinal;
  }

  public static Day[] values() {
    return VALUES.clone();
  }

  public static Day valueOf(String name) {
    for (Day day : VALUES) {
      if (day.name.equals(name)) {
        return day;
      }
    }
    throw new IllegalArgumentException("No enum constant " + name);
  }
}
```

`Day` はクラスなので、フィールドやコンストラクタ、メソッドを定義できる。
フィールドやコンストラクタを定義した場合、インスタンス化（列挙子の定義）時に初期化する必要がある。

```java
public enum Day {
  SUNDAY("日曜日"),
  MONDAY("月曜日"),
  TUESDAY("火曜日"),
  WEDNESDAY("水曜日"),
  THURSDAY("木曜日"),
  FRIDAY("金曜日"),
  SATURDAY("土曜日");

  private String japaneseName;

  private Day(String japaneseName) {
    this.japaneseName = japaneseName;
  }

  public String getJapaneseName() {
    return japaneseName;
  }
}
```

## クラスとしての特徴

- フィールド・メソッドは普通のクラスと同様に定義できる
- コンストラクタは `private` にしかできない＝外部からのインスタンス生成は不可能
  - アクセス修飾子が無い場合は `private` と解釈される
  - `public`・ `protected` を付けるとコンパイルエラー
- クラス直下に定数を宣言する
  - これらの定数は自クラスのインスタンス
  - 自クラスの `public static final` なフィールドとなる

## enum 標準メソッド

`enum` 型は、自動的にいくつかの便利なメソッドを提供している。これらのメソッドは、`enum` 型を操作するために非常に役立つ。

### 1. `values()` メソッド

- `values()`メソッドは、`enum`のすべての定数を含む配列を返す
- これにより、`enum`定数をループ処理したり、すべての定数を一度に取得したりすることができる

```java
public enum Day {
    SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
}

public class EnumTest {
    public static void main(String[] args) {
        for (Day day : Day.values()) {
            System.out.println(day);
        }
    }
}
```

このコードは、すべての曜日を出力する。

### 2. `valueOf(String name)` メソッド

- 指定された名前に対応する `enum` 定数を返す
- 名前が一致しない場合は、`IllegalArgumentException` がスローされる

```java
public class EnumTest {
    public static void main(String[] args) {
        Day day = Day.valueOf("MONDAY");
        System.out.println(day);  // 出力: MONDAY
    }
}
```

### 3. `name()` メソッド

- `enum`定数の名前を文字列として返す
- これは、定数が定義されたときの名前

```java
Day day = Day.MONDAY;
System.out.println(day.name());  // 出力: MONDAY
```

### 4. `ordinal()` メソッド

- `enum` 定数が定義された順序を示す整数を返す
- 最初の定数は `0`、次は `1` というように 0 から始まるインデックスを持つ

```java
Day day = Day.MONDAY;
System.out.println(day.ordinal());  // 出力: 1
```

### 5. `compareTo(E o)` メソッド

- `enum`定数の定義順序に基づいて他の定数と比較する
- 定数の定義順序に基づいて負の整数、0、正の整数を返す

```java
Day day1 = Day.MONDAY;
Day day2 = Day.FRIDAY;
System.out.println(day1.compareTo(day2));  // 出力: -4
```

### 6. `toString()` メソッド

- `name()`メソッドと同様に`enum`定数の名前を文字列として返す
- ただし、`toString()`メソッドはオーバーライドしてカスタマイズすることが可能

```java
public enum Day {
    SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY;

    @Override
    public String toString() {
        return name().charAt(0) + name().substring(1).toLowerCase();
    }
}

public class EnumTest {
    public static void main(String[] args) {
        Day day = Day.MONDAY;
        System.out.println(day);  // 出力: Monday
    }
}
```

### 7. `getDeclaringClass()` メソッド

定数が属する `enum` 型を返す。

```java
Day day = Day.MONDAY;
System.out.println(day.getDeclaringClass());  // 出力: class Day
```
