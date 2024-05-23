---
title: "日付操作"
---

## 日付操作は何を使う？

Java での日付操作には、以下の 2 つのパッケージが使用できる。

1. `java.util` : 古い方法
2. `java.time` : Java8 以降

現在では `java.time` を使用するのがメジャー。

## `LocalDate` クラス

日付（年月日）を表すクラス。

### 現在の日付を取得

```java
import java.time.LocalDate;

LocalDate today = LocalDate.now();
System.out.println("Today's date: " + today); // Today's date: 2024-05-22
```

`now()` は、実行環境に設定されたタイムゾーンにおける現在日を取得している。

### 特定の日付を作成

```java
LocalDate specificDate = LocalDate.of(2023, 5, 22);
System.out.println("Specific date: " + specificDate); // Specific date: 2023-05-22
```

### 日付の加算と減算

```java
LocalDate today = LocalDate.now();
LocalDate nextWeek = today.plusWeeks(1);
LocalDate lastMonth = today.minusMonths(1);

System.out.println("Today: " + today); // Today: 2024-05-22
System.out.println("One week later: " + nextWeek); // One week later: 2024-05-29
System.out.println("One month ago: " + lastMonth); // One month ago: 2024-04-22
```

## `LocalTime` クラス

時間（時分秒）を表すクラス。

### 現在の時刻を取得

```java
import java.time.LocalTime;

LocalTime now = LocalTime.now();
System.out.println("Current time: " + now); // Current time: 10:31:30.753651
```

### 特定の時刻を作成

```java
LocalTime specificTime = LocalTime.of(14, 30);
System.out.println("Specific time: " + specificTime); // Specific time: 14:30
```

### 時間の加算と減算

```java
LocalTime now = LocalTime.now();
LocalTime inTwoHours = now.plusHours(2);
LocalTime thirtyMinutesAgo = now.minusMinutes(30);

System.out.println("now: " + now); // now: 10:37:01.180818
System.out.println("In two hours: " + inTwoHours); // In two hours: 12:37:01.180818
System.out.println("Thirty minutes ago: " + thirtyMinutesAgo); // Thirty minutes ago: 10:07:01.180818
```

## `LocalDateTime` クラス

日付と時間を組み合わせたクラス。

### 現在の日付と時刻を取得

```java
import java.time.LocalDateTime;

LocalDateTime now = LocalDateTime.now();
System.out.println("Current date and time: " + now); // Current date and time: 2024-05-22T10:38:54.828522
```

### 特定の日付と時刻を作成

```java
LocalDateTime specificDateTime = LocalDateTime.of(2023, 5, 22, 14, 30);
System.out.println("Specific date and time: " + specificDateTime); // Specific date and time: 2023-05-22T14:30
```

`of()` は様々な引数を取ることができるようにオーバーロードされており、`of(2004, 2, 29, 20, 30, 15, 10000000)` のようにナノ秒まで指定することが可能。

### 日付と時刻の加算と減算

```java
LocalDateTime now = LocalDateTime.now();
LocalDateTime nextMonth = now.plusMonths(1);
LocalDateTime lastYear = now.minusYears(1);

System.out.println("now: " + now); // now: 2024-05-22T10:40:10.709150
System.out.println("One month later: " + nextMonth); // One month later: 2024-06-22T10:40:10.709150
System.out.println("One year ago: " + lastYear); // One year ago: 2023-05-22T10:40:10.709150
```

### メソッド

`LocalDateTime` クラスには、年、月、日、時間、分、秒などのフィールドを直接取得するためのメソッドが用意されている。
これらのメソッドは、特定のフィールドの値を簡単に取得するのに便利。

- `getYear()`: 年を取得する
- `getMonth()`: 月を取得する (`Month` 列挙型を返す)
- `getMonthValue()`: 月の数値（1-12）を取得する
- `getDayOfMonth()`: 月の日を取得する
- `getDayOfYear()`: 年の日を取得する
- `getDayOfWeek()`: 週の日を取得する (`DayOfWeek` 列挙型を返す)
- `getHour()`: 時間を取得する
- `getMinute()`: 分を取得する
- `getSecond()`: 秒を取得する
- `getNano()`: ナノ秒を取得する

```java
import java.time.LocalDateTime;

LocalDateTime now = LocalDateTime.now();
int year = now.getYear();
int month = now.getMonthValue();
int day = now.getDayOfMonth();
int hour = now.getHour();
int minute = now.getMinute();
int second = now.getSecond();

System.out.println("Year: " + year); // Year: 2024
System.out.println("Month: " + month); // Month: 5
System.out.println("Day: " + day); // Day: 22
System.out.println("Hour: " + hour); // Hour: 12
System.out.println("Minute: " + minute); // Minute: 20
System.out.println("Second: " + second); // Second: 33
```

## `DateTimeFormatter` クラス

日付と時刻のフォーマットや解析を行うためのクラス。
さまざまなパターンで日付と時刻をフォーマットし、文字列から日付と時刻を解析することもできる。

### 日付と時刻のフォーマット

```java
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

LocalDateTime now = LocalDateTime.now();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
String formattedDateTime = now.format(formatter);

System.out.println("Formatted date and time: " + formattedDateTime); // Formatted date and time: 2024-05-22 10:42:27
```

上記の例では、`DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")` を使用して、`LocalDateTime` オブジェクトを指定したパターンでフォーマットしている。

### フォーマットされた日付と時刻の解析

```java
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

String dateTimeString = "2023-05-22 14:30:00";
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
LocalDateTime parsedDateTime = LocalDateTime.parse(dateTimeString, formatter);

System.out.println("Parsed date and time: " + parsedDateTime); // Parsed date and time: 2023-05-22T14:30
```

この例では、文字列 `"2023-05-22 14:30:00"` を指定したパターンで解析し、`LocalDateTime` オブジェクトを作成している。

### AM/PM が含まれる文字列を日付型に変換する

以下の文字列を `LocalDateTime` に変換する方法について説明する。

```
"2001/02/06 AM 07:12:59"
```

この文字列には `AM` が含まれているため、フォーマットパターンを使って適切に解析する必要がある。`DateTimeFormatter` では、AM/PM 表記のために `"a"` を使う。以下のようにフォーマットパターンを生成する。

```java
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd a hh:mm:ss");
```

しかし、プログラムが実行される環境（国や地域）によっては、このフォーマットパターンだけでは正しく解析できない場合がある。例えば、日本では `AM` や `PM` の代わりに `午前` や `午後` が使われる。こうした違いを正しく処理するために、解析時に「ロケール」を指定すると良い。

ロケールとは、プログラムが動作する国や地域の設定のこと。これを指定することで、AM/PM の表記を正しく認識させることができる。

英語の `AM`/`PM` を使う場合、以下のように `Locale.ENGLISH` を指定する。

```java
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class Main {
    public static void main(String[] args) {
        String dateStr = "2001/02/06 AM 07:12:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd a hh:mm:ss", Locale.ENGLISH);

        LocalDateTime date = LocalDateTime.parse(dateStr, formatter);
        System.out.println("Parsed DateTime: " + date);
    }
}
```

日本語の `午前`/`午後` を使う場合、以下のように `Locale.JAPAN` を指定する。

```java
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class Main {
    public static void main(String[] args) {
        String dateStr = "2001/02/06 午前 07:12:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd a hh:mm:ss", Locale.JAPAN);

        LocalDateTime date = LocalDateTime.parse(dateStr, formatter);
        System.out.println("Parsed DateTime: " + date);
    }
}
```

## `ZonedDateTime` クラス

タイムゾーンを含む日付と時刻を表すクラス。
特定のタイムゾーンに対応した日時を扱うことができる。

### 現在のタイムゾーン付き日付と時刻を取得

```java
import java.time.ZonedDateTime;
import java.time.ZoneId;

ZonedDateTime nowUTC = ZonedDateTime.now(ZoneId.of("UTC"));
ZonedDateTime nowNY = ZonedDateTime.now(ZoneId.of("America/New_York"));

System.out.println("Current date and time in UTC: " + nowUTC); // Current date and time in UTC: 2024-05-22T01:49:53.051588Z[UTC]
System.out.println("Current date and time in New York: " + nowNY); // // Current date and time in New York: 2024-05-21T21:49:53.057609-04:00[America/New_York]
```

上記の例では、`ZonedDateTime.now(ZoneId.of("UTC"))` と `ZonedDateTime.now(ZoneId.of("America/New_York"))` を使用して、UTC とニューヨークの現在の日時を取得している。
`ZoneId.of` に指定する文字列は、IANA (Internet Assigned Numbers Authority) タイムゾーンデータベースに基づいた形式である必要がある。この形式は、通常「地域/都市」の形で指定される。不適切な文字列を指定した場合、コンパイルエラーとなる。

### タイムゾーン付き日付と時刻の変換

```java
ZonedDateTime now = ZonedDateTime.now();
ZonedDateTime tokyoTime = now.withZoneSameInstant(ZoneId.of("UTC"));

System.out.println("Current date and time: " + now); // Current date and time: 2024-05-22T10:53:13.771750+09:00[Asia/Tokyo]
System.out.println("Current date and time in UTC: " + tokyoTime); // Current date and time in Tokyo: 2024-05-22T01:53:13.771750Z[UTC]
```

この例では、現在の `ZonedDateTime` オブジェクトを UTC のタイムゾーンに変換している。`withZoneSameInstant(ZoneId.of("UTC"))` を使用すると、同じ瞬間の異なるタイムゾーンでの日時を取得することができる。

### タイムゾーンのリストを取得

利用可能なタイムゾーンの ID を取得するには、`ZoneId.getAvailableZoneIds()` メソッドを使用することができる。これにより、すべてのタイムゾーン ID のセットが返される。

```java
import java.time.ZoneId;
import java.util.Set;

Set<String> allZoneIds = ZoneId.getAvailableZoneIds();
allZoneIds.forEach(System.out::println);
```

## `ZoneId` 抽象クラス

- タイムゾーンを表現するために使用される
- 特定のタイムゾーンに基づいた日時操作を実現するための基盤となる

### 概要

- **抽象クラス**
  `ZoneId` は抽象クラスであり、直接インスタンス化できない。具体的な実装は `ZoneRegion` や `ZoneOffset` などのサブクラスによって提供される。
- **タイムゾーンの表現**
  地域ベースのタイムゾーン（例: "Asia/Tokyo"）や固定オフセット（例: "+09:00"）を表現。

### `of` メソッド

`of` メソッドは、指定されたタイムゾーン ID に基づいて適切な `ZoneId` のサブクラス（`ZoneRegion` または `ZoneOffset`）のインスタンスを生成するファクトリーメソッド。

```java
ZoneId tokyoZoneId = ZoneId.of("Asia/Tokyo"); // ZoneRegion のインスタンスが生成される
ZoneId utcPlus9 = ZoneId.of("+09:00"); // ZoneOffset のインスタンスが生成される
```

`of` メソッドは、指定されたタイムゾーン ID を基に内部的に `ZoneRegion` または `ZoneOffset` のインスタンスを生成する。

### `systemDefault` メソッド

`systemDefault` メソッドは、システムのデフォルトタイムゾーンを取得する。

```java
ZoneId defaultZoneId = ZoneId.systemDefault();
```

### `getAvailableZoneIds` メソッド

`getAvailableZoneIds` メソッドは、利用可能なすべてのタイムゾーン ID のセットを取得する。

```java
Set<String> allZoneIds = ZoneId.getAvailableZoneIds();
```

### `getId` メソッド

`getId` メソッドは、タイムゾーン ID を文字列として取得する。

```java
String zoneIdString = tokyoZoneId.getId();
```

### `getRules` メソッド

`getRules` メソッドは、タイムゾーンのルール（夏時間やオフセットの変更など）を取得する。

```java
ZoneRules tokyoRules = tokyoZoneId.getRules();
```

### `ZoneRegion` クラス

`ZoneRegion` クラスは、地域ベースのタイムゾーンを表現する具体的な実装。`ZoneId` を継承し、地域ベースのタイムゾーン ID（例: "Asia/Tokyo"）に対応する。

```java
ZoneId tokyoZoneId = ZoneId.of("Asia/Tokyo"); // 実際には ZoneRegion のインスタンス
ZoneRules tokyoRules = tokyoZoneId.getRules();

System.out.println("Tokyo Zone ID: " + tokyoZoneId);
System.out.println("Tokyo Zone Rules: " + tokyoRules);
```

### 使用例

:::details 現在の日時を特定のタイムゾーンで取得

```java
ZoneId tokyoZoneId = ZoneId.of("Asia/Tokyo");
ZonedDateTime tokyoDateTime = ZonedDateTime.now(tokyoZoneId);

System.out.println("Current date and time in Tokyo: " + tokyoDateTime);
```

:::

:::details 異なるタイムゾーン間の日時変換

```java
ZoneId tokyoZoneId = ZoneId.of("Asia/Tokyo");
ZonedDateTime tokyoDateTime = ZonedDateTime.now(tokyoZoneId);

ZoneId newYorkZoneId = ZoneId.of("America/New_York");
ZonedDateTime newYorkDateTime = tokyoDateTime.withZoneSameInstant(newYorkZoneId);

System.out.println("Current date and time in Tokyo: " + tokyoDateTime);
System.out.println("Current date and time in New York: " + newYorkDateTime);
```

:::

## `ZoneOffset` クラス

- `ZoneId` を継承したクラス
- UTC からの固定オフセットを表現する
- タイムゾーンのオフセットを時間単位、分単位、秒単位で指定できる

```java
ZoneId utcPlus9 = ZoneId.of("+09:00"); // 実際には ZoneOffset のインスタンス
ZoneRules offsetRules = utcPlus9.getRules();

System.out.println("Zone Offset ID: " + utcPlus9); // Zone Offset ID: +09:00
System.out.println("Zone Offset Rules: " + offsetRules); // Zone Offset Rules: ZoneRules[currentStandardOffset=+09:00]
```

:::details 主要メソッド

1. **`of` メソッド**

   - 指定したオフセットを持つ `ZoneOffset` オブジェクトを生成する
   - オフセットを `+HH:mm`、`-HH:mm` の形式で指定する

   ```java
   ZoneOffset offset = ZoneOffset.of("+09:00");
   System.out.println(offset);  // +09:00
   ```

2. **`ofHours` メソッド**

   - 指定した時間のオフセットを持つ `ZoneOffset` オブジェクトを生成する
   - 時間単位でオフセットを指定する。

   ```java
   ZoneOffset offset = ZoneOffset.ofHours(9);
   System.out.println(offset);  // +09:00
   ```

3. **`ofHoursMinutes` メソッド**

   - 指定した時間と分のオフセットを持つ `ZoneOffset` オブジェクトを生成する

   ```java
   ZoneOffset offset = ZoneOffset.ofHoursMinutes(5, 30);
   System.out.println(offset);  // +05:30
   ```

4. **`ofTotalSeconds` メソッド**

   - 指定した秒数のオフセットを持つ `ZoneOffset` オブジェクトを生成する

   ```java
   ZoneOffset offset = ZoneOffset.ofTotalSeconds(32400); // 9時間 × 3600秒
   System.out.println(offset);  // +09:00
   ```

5. **`getTotalSeconds` メソッド**

   - `ZoneOffset` オブジェクトのオフセットを秒単位で取得する

   ```java
   ZoneOffset offset = ZoneOffset.of("+09:00");
   int totalSeconds = offset.getTotalSeconds();
   System.out.println(totalSeconds);  // Output: 32400
   ```

:::

:::details 使用例

1. **`ZoneOffset` を使用した日時操作**

   `OffsetDateTime` と組み合わせて、特定のオフセットを持つ日時を表現する。

   ```java
   import java.time.OffsetDateTime;
   import java.time.ZoneOffset;
   import java.time.format.DateTimeFormatter;

   public class Main {
       public static void main(String[] args) {
           // 現在の日時を +09:00 のオフセットで取得
           ZoneOffset offset = ZoneOffset.of("+09:00");
           OffsetDateTime dateTime = OffsetDateTime.now(offset);
           System.out.println(dateTime); // 2024-05-22T21:16:22.192004+09:00

           // 固定オフセットを持つ日時の指定
           OffsetDateTime specificDateTime = OffsetDateTime.of(2023, 5, 22, 10, 15, 30, 0, offset);
           System.out.println(specificDateTime); // 2023-05-22T10:15:30+09:00

           // DateTimeFormatter を使用してフォーマット
           DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ssXXX");
           String formattedDateTime = specificDateTime.format(formatter);
           System.out.println(formattedDateTime); // 2023-05-22 10:15:30+09:00
       }
   }
   ```

2. **`ZoneOffset` を使用した `ZonedDateTime` の変換**

   `ZoneOffset` を使用して、`ZonedDateTime` を異なるオフセットに変換する。

   ```java
   import java.time.ZonedDateTime;
   import java.time.ZoneOffset;
   import java.time.ZoneId;

   public class Main {
       public static void main(String[] args) {
           // 現在の東京の日時を取得
           ZonedDateTime tokyoDateTime = ZonedDateTime.now(ZoneId.of("Asia/Tokyo"));
           System.out.println("Current date and time in Tokyo: " + tokyoDateTime);

           // 東京の日時を +09:00 のオフセットに変換
           ZoneOffset offset = ZoneOffset.of("+09:00");
           ZonedDateTime offsetDateTime = tokyoDateTime.withZoneSameInstant(offset);
           System.out.println("Tokyo date and time with +09:00 offset: " + offsetDateTime);
       }
   }
   ```

:::

## `java.time.temporal.ChronoField`

`ChronoField` は、年、月、日、時間、分、秒などの特定のフィールドを表す列挙型。
`LocalDateTime` クラスを含む多くの日時クラスに対して、一貫した方法でフィールド操作を提供する。

### 主なフィールド

- `YEAR`: 年
- `MONTH_OF_YEAR`: 月（1-12）
- `DAY_OF_MONTH`: 月の日（1-31）
- `DAY_OF_YEAR`: 年の日（1-365/366）
- `DAY_OF_WEEK`: 週の日（1-7）
- `HOUR_OF_DAY`: 時（0-23）
- `MINUTE_OF_HOUR`: 分（0-59）
- `SECOND_OF_MINUTE`: 秒（0-59）
- `NANO_OF_SECOND`: ナノ秒（0-999,999,999）
- `EPOCH_DAY`: エポックからの日数
- `INSTANT_SECONDS`: エポックからの秒数
- `AMPM_OF_DAY`: AM の場合は `0`、PM の場合は `1`

### 使用例

```java
import java.time.LocalDateTime;
import java.time.temporal.ChronoField;

LocalDateTime now = LocalDateTime.now();
int year = now.get(ChronoField.YEAR);
int month = now.get(ChronoField.MONTH_OF_YEAR);
int day = now.get(ChronoField.DAY_OF_MONTH);
int hour = now.get(ChronoField.HOUR_OF_DAY);
int minute = now.get(ChronoField.MINUTE_OF_HOUR);
int second = now.get(ChronoField.SECOND_OF_MINUTE);

System.out.println("Year: " + year); // Year: 2024
System.out.println("Month: " + month); // Month: 5
System.out.println("Day: " + day); // Day: 22
System.out.println("Hour: " + hour); // Hour: 12
System.out.println("Minute: " + minute); // Minute: 26
System.out.println("Second: " + second); // Second: 1
```

### 日時クラスのメソッド vs `ChronoField` の利点

#### `LocalDateTime` メソッドの利点

- **シンプルで直感的**: 日付や時刻の情報を簡単に取得できる。
- **読みやすさ**: コードが簡潔で読みやすい。

#### `ChronoField` の利点

- **一貫性と汎用性**: 異なる日時クラスに対して同じ方法でアクセス可能。
- **詳細なフィールド操作**: エポック秒やナノ秒などの詳細なフィールドにも対応。
- **カスタム暦システム**: 標準の ISO 暦以外の暦システムにも対応。
- **柔軟性**: フィールドの存在確認や特定のフィールドの加算・減算が容易。

## `with` メソッド 〜 日時を変更して新たなオブジェクトを生成する

日時オブジェクトを変更するためのメソッドで、既存のオブジェクトを基にして特定のフィールドの値を変更した新しいオブジェクトを返す。
`LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime` など、`java.time` パッケージの多くのクラスに存在する。

### 年を変更する

```java
import java.time.LocalDateTime;

LocalDateTime now = LocalDateTime.now();
LocalDateTime newDateTime = now.withYear(2025);

System.out.println("Current date and time: " + now);
System.out.println("New date and time: " + newDateTime);
```

このコードでは、現在の日時オブジェクトから年を 2025 年に変更した新しい日時オブジェクトを作成している。

### 月を変更する

```java
LocalDateTime now = LocalDateTime.now();
LocalDateTime newDateTime = now.withMonth(12);

System.out.println("Current date and time: " + now);
System.out.println("New date and time: " + newDateTime);
```

### 日を変更する

```java
LocalDateTime now = LocalDateTime.now();
LocalDateTime newDateTime = now.withDayOfMonth(25);

System.out.println("Current date and time: " + now);
System.out.println("New date and time: " + newDateTime);
```

### `with` メソッドと `ChronoField` の併用

`ChronoField` と併用することで、より柔軟にフィールドを変更することができる。

#### `ChronoField` を使用して年を変更する

```java
import java.time.LocalDateTime;
import java.time.temporal.ChronoField;

LocalDateTime now = LocalDateTime.now();
LocalDateTime newDateTime = now.with(ChronoField.YEAR, 2025);

System.out.println("Current date and time: " + now);
System.out.println("New date and time: " + newDateTime);
```

#### `ChronoField` を使用して AM/PM を変更する

```java
LocalDateTime now = LocalDateTime.now();
LocalDateTime newDateTime = now.with(ChronoField.AMPM_OF_DAY, 1); // PM に変更

System.out.println("Current date and time: " + now);
System.out.println("New date and time (PM): " + newDateTime);
```

## `ChronoUnit` クラス

日付や時刻の特定の単位（年、月、日、時間、分、秒など）を表す列挙型。これを使用することで、期間の計算や日付・時刻の加算・減算を簡単に行うことができる。

- `YEARS`: 年
- `MONTHS`: 月
- `WEEKS`: 週
- `DAYS`: 日
- `HOURS`: 時間
- `MINUTES`: 分
- `SECONDS`: 秒
- `MILLIS`: ミリ秒
- `MICROS`: マイクロ秒
- `NANOS`: ナノ秒

### 日付の加算と減算

`ChronoUnit` を使用して、日付や時刻に特定の単位を加算または減算する。

##### 日を加算

```java
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

LocalDate today = LocalDate.now();
LocalDate nextWeek = today.plus(1, ChronoUnit.WEEKS);

System.out.println("Today: " + today);
System.out.println("One week later: " + nextWeek);
```

##### 月を減算

```java
import java.time.LocalDate;

LocalDate today = LocalDate.now();
LocalDate lastMonth = today.minus(1, ChronoUnit.MONTHS);

System.out.println("Today: " + today);
System.out.println("One month ago: " + lastMonth);
```

### 期間の計算

2 つの日付や時刻の間の期間を計算することもできる。

#### 日数の計算

```java
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

LocalDate startDate = LocalDate.of(2023, 1, 1);
LocalDate endDate = LocalDate.of(2023, 12, 31);
long daysBetween = ChronoUnit.DAYS.between(startDate, endDate);

System.out.println("Days between: " + daysBetween);
```

#### 月数の計算

```java
import java.time.LocalDate;

LocalDate startDate = LocalDate.of(2023, 1, 1);
LocalDate endDate = LocalDate.of(2023, 12, 31);
long monthsBetween = ChronoUnit.MONTHS.between(startDate, endDate);

System.out.println("Months between: " + monthsBetween);
```

## 日付の比較

Java では、日付と時刻を比較するためのさまざまな方法が提供されている。
`java.time` パッケージのクラス (`LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime` など) には、日付や時刻を比較するためのメソッドが含まれている。

### 主な比較メソッド

- `isAfter()`: 指定された日時より後かどうかを判定
- `isBefore()`: 指定された日時より前かどうかを判定
- `isEqual()`: 指定された日時と等しいかどうかを判定
- `compareTo()`: 2 つの日時を比較

### `isAfter()` メソッド

```java
import java.time.LocalDate;

LocalDate date1 = LocalDate.of(2023, 1, 1);
LocalDate date2 = LocalDate.of(2023, 12, 31);

boolean isAfter = date2.isAfter(date1);
System.out.println("Is date2 after date1? " + isAfter);  // true
```

### `isBefore()` メソッド

```java
import java.time.LocalDate;

LocalDate date1 = LocalDate.of(2023, 1, 1);
LocalDate date2 = LocalDate.of(2023, 12, 31);

boolean isBefore = date1.isBefore(date2);
System.out.println("Is date1 before date2? " + isBefore);  // true
```

### `isEqual()` メソッド

```java
import java.time.LocalDate;

LocalDate date1 = LocalDate.of(2023, 1, 1);
LocalDate date2 = LocalDate.of(2023, 1, 1);

boolean isEqual = date1.isEqual(date2);
System.out.println("Is date1 equal to date2? " + isEqual);  // true
```

### `compareTo()` メソッド

```java
import java.time.LocalDate;

LocalDate date1 = LocalDate.of(2023, 1, 1);
LocalDate date2 = LocalDate.of(2023, 12, 31);

int comparison = date1.compareTo(date2);
if (comparison < 0) {
    System.out.println("date1 is before date2");
} else if (comparison > 0) {
    System.out.println("date1 is after date2");
} else {
    System.out.println("date1 is equal to date2");
}
```

### `equals()` メソッド

`equals()` メソッドを使用して、2 つの日付や時刻が等しいかどうかを比較することもできる。

```java
import java.time.LocalDate;

LocalDate date1 = LocalDate.of(2023, 1, 1);
LocalDate date2 = LocalDate.of(2023, 1, 1);

boolean isEqual = date1.equals(date2);
System.out.println("Dates are equal: " + isEqual);  // true
```

### `==` 演算子の使用を避ける理由

- **参照の比較**: `==` 演算子は、2 つのオブジェクトが同じメモリ位置を参照しているかどうかをチェックするため、オブジェクトの内容が同じでも異なるインスタンスであれば `false` になる。
- **内容の比較ではない**: オブジェクトの内容を比較する場合は、`equals()` メソッドや比較メソッドを使用する。

## `truncate()` ~ 日時の切り捨て

`truncate` メソッドは、日時オブジェクトの特定の単位以下の部分を切り捨てて、新しい日時オブジェクトを生成するために使用される。このメソッドは、`java.time` パッケージの多くのクラスに存在し、特定の単位までの正確な日時を取得するのに役立つ。

### 時間単位で切り捨て

```java
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

LocalDateTime dateTime = LocalDateTime.of(2023, 5, 22, 14, 35, 50, 123456789);
LocalDateTime truncatedToHours = dateTime.truncatedTo(ChronoUnit.HOURS);

System.out.println("Original date and time: " + dateTime);
System.out.println("Truncated to hours: " + truncatedToHours);
```

この例では、14 時 35 分 50 秒が 14 時に切り捨てられる。

### 分単位で切り捨て

```java
import java.time.LocalDateTime;

LocalDateTime dateTime = LocalDateTime.of(2023, 5, 22, 14, 35, 50, 123456789);
LocalDateTime truncatedToMinutes = dateTime.truncatedTo(ChronoUnit.MINUTES);

System.out.println("Original date and time: " + dateTime);
System.out.println("Truncated to minutes: " + truncatedToMinutes);
```

この例では、14 時 35 分 50 秒が 14 時 35 分に切り捨てられる。

### 秒単位で切り捨て

```java
import java.time.LocalDateTime;

LocalDateTime dateTime = LocalDateTime.of(2023, 5, 22, 14, 35, 50, 123456789);
LocalDateTime truncatedToSeconds = dateTime.truncatedTo(ChronoUnit.SECONDS);

System.out.println("Original date and time: " + dateTime);
System.out.println("Truncated to seconds: " + truncatedToSeconds);
```

この例では、14 時 35 分 50 秒 123456789 ナノ秒が 14 時 35 分 50 秒に切り捨てられる。

## 日付同士の差分を取得したい場合

https://qiita.com/tora_kouno/items/d230f904a2b768ccb319

## `TemporalAdjusters` クラス

「次の月曜日」や「今月の最終日」などの日時操作を簡単に行うことができる。

:::details 使い方

```java
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.time.DayOfWeek;

public class Main {
    public static void main(String[] args) {
        // 現在の日付を取得
        LocalDate today = LocalDate.now();

        // 次の月曜日に調整
        LocalDate nextMonday = today.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        System.out.println("Next Monday: " + nextMonday);

        // 今月の最終日に調整
        LocalDate lastDayOfMonth = today.with(TemporalAdjusters.lastDayOfMonth());
        System.out.println("Last day of this month: " + lastDayOfMonth);

        // 次の特定の日（例えば次の金曜日）
        LocalDate nextFriday = today.with(TemporalAdjusters.next(DayOfWeek.FRIDAY));
        System.out.println("Next Friday: " + nextFriday);
    }
}
```

:::

:::details よく使われる `TemporalAdjusters` のメソッド

- `firstDayOfMonth()`: 月の最初の日
- `lastDayOfMonth()`: 月の最後の日
- `firstDayOfNextMonth()`: 次の月の最初の日
- `firstDayOfYear()`: 年の最初の日
- `lastDayOfYear()`: 年の最後の日
- `firstInMonth(DayOfWeek dayOfWeek)`: 月の最初の特定の曜日
- `next(DayOfWeek dayOfWeek)`: 次の特定の曜日
- `previous(DayOfWeek dayOfWeek)`: 前の特定の曜日

:::
