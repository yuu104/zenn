---
title: "Scannerクラス"
---

## 目的

`Scanner`クラスは、Java でテキストデータを簡単に読み取るためのユーティリティクラスです。標準入力（コンソール）、ファイル、文字列、ネットワークなどの多様なソースからデータを読み取り、数値や文字列として解析するために使用されます。

## コンストラクタのシグネチャ

`Scanner`クラスには複数のコンストラクタがあります。以下に主なコンストラクタを列挙します。

1. **標準入力から読み取るコンストラクタ**:

   ```java
   public Scanner(InputStream source)
   ```

   - 例: `Scanner scanner = new Scanner(System.in);`

2. **ファイルから読み取るコンストラクタ**:

   ```java
   public Scanner(File source) throws FileNotFoundException
   ```

   - 例: `Scanner scanner = new Scanner(new File("input.txt"));`

3. **文字列から読み取るコンストラクタ**:

   ```java
   public Scanner(String source)
   ```

   - 例: `Scanner scanner = new Scanner("text to be scanned");`

4. **パスから読み取るコンストラクタ**:

   ```java
   public Scanner(Path source) throws IOException
   ```

   - 例: `Scanner scanner = new Scanner(Files.newInputStream(Paths.get("input.txt")));`

5. **他のソースから読み取るコンストラクタ**:
   ```java
   public Scanner(Readable source)
   public Scanner(ReadableByteChannel source)
   ```

## 主なメソッド

`Scanner`クラスには、データを読み取るための多くのメソッドが用意されています。主なメソッドを以下に示します。

:::details hasNext ~ 次のトークンが存在するか確認する

- **シグネチャ**:
  ```java
  boolean hasNext()
  ```
- **詳細な説明**:
  次のトークンが存在するかどうかを確認します。存在する場合は`true`を返し、存在しない場合は`false`を返します。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("Hello World");
  while (scanner.hasNext()) {
      String word = scanner.next();
      System.out.println(word);
  }
  // 出力: Hello, World
  scanner.close();
  ```

:::

:::details next ~ 次のトークンを文字列として取得する

- **シグネチャ**:
  ```java
  String next()
  ```
- **詳細な説明**:
  次のトークンを文字列として返します。次のトークンが存在しない場合は、`NoSuchElementException`をスローします。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("Hello World");
  String firstWord = scanner.next();
  System.out.println(firstWord); // 出力: Hello
  scanner.close();
  ```

:::

:::details close ~ Scanner を閉じて、リソースを解放する

- **シグネチャ**:
  ```java
  void close()
  ```
- **詳細な説明**:
  `Scanner`を閉じて、リソースを解放します。`Scanner`が使用しているストリームがある場合、それも閉じられます。
- **具体例**:
  ```java
  Scanner scanner = new Scanner(System.in);
  scanner.close();
  ```

:::

:::details hasNextLine ~ 次の行が存在するか確認する

- **シグネチャ**:
  ```java
  boolean hasNextLine()
  ```
- **詳細な説明**:
  次の行が存在するかどうかを確認します。存在する場合は`true`を返し、存在しない場合は`false`を返します。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("Hello\nWorld");
  while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      System.out.println(line);
  }
  // 出力: Hello, World
  scanner.close();
  ```

:::

:::details nextLine ~ 次の行を文字列として取得する

- **シグネチャ**:
  ```java
  String nextLine()
  ```
- **詳細な説明**:
  次の行を文字列として返します。行の終わりまで読み取り、改行文字を除去します。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("Hello\nWorld");
  String firstLine = scanner.nextLine();
  System.out.println(firstLine); // 出力: Hello
  scanner.close();
  ```

:::

:::details hasNextInt ~ 次のトークンが整数として存在するか確認する

- **シグネチャ**:
  ```java
  boolean hasNextInt()
  ```
- **詳細な説明**:
  次のトークンが整数として存在するかどうかを確認します。存在する場合は`true`を返し、存在しない場合は`false`を返します。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("123 abc");
  if (scanner.hasNextInt()) {
      int number = scanner.nextInt();
      System.out.println(number); // 出力: 123
  }
  scanner.close();
  ```

:::

:::details nextInt ~ 次のトークンを整数として取得する

- **シグネチャ**:
  ```java
  int nextInt()
  ```
- **詳細な説明**:
  次のトークンを整数として返します。次のトークンが整数として存在しない場合は、`InputMismatchException`をスローします。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("123 abc");
  int number = scanner.nextInt();
  System.out.println(number); // 出力: 123
  scanner.close();
  ```

:::

:::details hasNextDouble ~ 次のトークンが double として存在するか確認する

- **シグネチャ**:
  ```java
  boolean hasNextDouble()
  ```
- **詳細な説明**:
  次のトークンが`double`として存在するかどうかを確認します。存在する場合は`true`を返し、存在しない場合は`false`を返します。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("3.14 abc");
  if (scanner.hasNextDouble()) {
      double number = scanner.nextDouble();
      System.out.println(number); // 出力: 3.14
  }
  scanner.close();
  ```

:::

:::details nextDouble ~ 次のトークンを double として取得する

- **シグネチャ**:
  ```java
  double nextDouble()
  ```
- **詳細な説明**:
  次のトークンを`double`として返します。次のトークンが`double`として存在しない場合は、`InputMismatchException`をスローします。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("3.14 abc");
  double number = scanner.nextDouble();
  System.out.println(number); // 出力: 3.14
  scanner.close();
  ```

:::

:::details useDelimiter ~ トークンの区切りを設定する

- **シグネチャ**:
  ```java
  Scanner useDelimiter(Pattern pattern)
  Scanner useDelimiter(String pattern)
  ```
- **詳細な説明**:
  トークンを区切るためのパターンを設定します。デフォルトの区切りパターンは空白文字です。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("apple,banana,cherry");
  scanner.useDelimiter(",");
  while (scanner.hasNext()) {
      String fruit = scanner.next();
      System.out.println(fruit);
  }
  // 出力: apple, banana, cherry
  scanner.close();
  ```

:::

:::details skip ~ 次のトークンをスキップする

- **シグネチャ**:
  ```java
  void skip(Pattern pattern)
  void skip(String pattern)
  ```
- **詳細な説明**:
  次のトークンをスキップします。トークンがパターンに一致しない場合、`NoSuchElementException`をスローします。
- **具体例**:
  ```java
  Scanner scanner = new Scanner("Hello, World!");
  scanner.skip("Hello, ");
  String remaining = scanner.nextLine();
  System.out.println(remaining); // 出力: World!
  scanner.close();
  ```

:::

## 具体例

### 1. 標準入力からの読み取り

```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter your name:");
        String name = scanner.nextLine();

        System.out.println("Enter your age:");
        int age = scanner.nextInt();

        System.out.println("Hello, " + name + ". You are " + age + " years old.");

        scanner.close();
    }
}
```

### 2. ファイルからの読み取り

```java
import

 java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        try {
            File file = new File("input.txt");
            Scanner scanner = new Scanner(file);

            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                System.out.println(line);
            }

            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

### 3. 文字列からの読み取り

```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        String input = "1 2 3 four five six";
        Scanner scanner = new Scanner(input);

        while (scanner.hasNext()) {
            if (scanner.hasNextInt()) {
                int number = scanner.nextInt();
                System.out.println("Integer: " + number);
            } else {
                String word = scanner.next();
                System.out.println("Word: " + word);
            }
        }

        scanner.close();
    }
}
```

### 4. `Path`と`Scanner`の組み合わせ

```java
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.io.IOException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Path filePath = Paths.get("input.txt");

        try (Scanner scanner = new Scanner(Files.newInputStream(filePath))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### 5. 正規表現を使用したデータの解析

```java
import java.util.Scanner;
import java.util.regex.Pattern;

public class Main {
    public static void main(String[] args) {
        String input = "apple, banana, cherry, date";
        Scanner scanner = new Scanner(input);
        scanner.useDelimiter(Pattern.compile(", "));

        while (scanner.hasNext()) {
            String fruit = scanner.next();
            System.out.println(fruit);
        }

        scanner.close();
    }
}
```

## まとめ

`Scanner`クラスは、Java でのテキストデータの読み取りと解析を簡素化するための強力なツールです。標準入力、ファイル、文字列など多様なソースからデータを読み取り、数値や文字列に変換するための便利なメソッドを提供します。具体例を参考に、`Scanner`クラスの使用方法とその利便性を理解してください。
