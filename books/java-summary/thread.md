---
title: "スレッド"
---

## スレッドとは

スレッドは、プログラムの中で独立して実行される一連の命令のことを指す。マルチスレッドプログラミングでは、一つのプログラムを複数のスレッドで並行して実行することができ、これによりプログラムの実行効率を高める。

### 例: シングルスレッド vs マルチスレッド

**シングルスレッドの例**

```java
public class SingleThreadExample {
    public static void main(String[] args) {
        System.out.println("Task 1");
        System.out.println("Task 2");
        System.out.println("Task 3");
    }
}
```

この例では、タスク 1、タスク 2、タスク 3 が順番に実行される。

**マルチスレッドの例**

```java
public class MultiThreadExample {
    public static void main(String[] args) {
        Thread thread1 = new Thread(() -> System.out.println("Task 1"));
        Thread thread2 = new Thread(() -> System.out.println("Task 2"));
        Thread thread3 = new Thread(() -> System.out.println("Task 3"));

        thread1.start();
        thread2.start();
        thread3.start();
    }
}
```

マルチスレッドプログラムでは、タスク 1、タスク 2、タスク 3 が並行して実行される。

## スレッドセーフとは

スレッドセーフとは、複数のスレッドが同時に実行されても、プログラムが正しく動作する特性を指す。特に、共有データへのアクセスが競合しないようにすることが重要である。

### 例: スレッドセーフでない場合

```java
public class Counter {
    private int count = 0;

    public void increment() {
        count++;
    }

    public int getCount() {
        return count;
    }

    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();

        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) {
                counter.increment();
            }
        };

        Thread thread1 = new Thread(task);
        Thread thread2 = new Thread(task);

        thread1.start();
        thread2.start();

        thread1.join();
        thread2.join();

        System.out.println(counter.getCount()); // 予期しない結果になることがある
    }
}
```

この例では、`counter`オブジェクトが複数のスレッドから同時にアクセスされ、正しくカウントされない可能性がある。

### スレッドセーフにする方法

スレッドセーフにするための一般的な方法は、同期化である。Java では、`synchronized`キーワードを使用してメソッドやブロックを同期化できる。

**同期化された例**

```java
public class Counter {
    private int count = 0;

    public synchronized void increment() {
        count++;
    }

    public synchronized int getCount() {
        return count;
    }

    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();

        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) {
                counter.increment();
            }
        };

        Thread thread1 = new Thread(task);
        Thread thread2 = new Thread(task);

        thread1.start();
        thread2.start();

        thread1.join();
        thread2.join();

        System.out.println(counter.getCount()); // 正しい結果が得られる
    }
}
```

この例では、`increment`メソッドと`getCount`メソッドが同期化されているため、複数のスレッドから同時にアクセスされても正しくカウントされる。

:::details 処理の流れ

1. **Counter クラスの定義**

   - `count`フィールドを保持し、`increment`メソッドと`getCount`メソッドを提供。
   - `increment`メソッドと`getCount`メソッドは`synchronized`キーワードで修飾されており、スレッドセーフな操作が保証される。

2. **main メソッドの開始**

   - `Counter`オブジェクトが生成され、`counter`変数に格納される。

3. **Runnable タスクの定義**

   - `Runnable`インターフェースを使用して、1000 回`increment`メソッドを呼び出すタスクを定義。

4. **スレッドの生成**

   - `task`を実行する 2 つのスレッド、`thread1`と`thread2`を生成。

5. **スレッドの開始**

   - `thread1.start()`と`thread2.start()`を呼び出し、それぞれのスレッドを開始。
   - 各スレッドは独立して`task`を実行し始める。

6. **スレッドの終了を待つ**

   - `thread1.join()`と`thread2.join()`を呼び出し、`main`スレッドが`thread1`と`thread2`の終了を待つ。

7. **カウントの取得と表示**
   - 両方のスレッドが終了した後、`counter.getCount()`を呼び出して最終的なカウント値を取得し、表示。

:::

## 実際のユースケース

:::details 大規模な計算処理

膨大な計算量を持つ処理を複数のスレッドで並列に実行することで、計算時間を短縮できる。

```java
public class ParallelSum {
    private static final int SIZE = 1000000;
    private static final int THREADS = 4;
    private static int[] array = new int[SIZE];

    static {
        for (int i = 0; i < SIZE; i++) {
            array[i] = i;
        }
    }

    public static void main(String[] args) throws InterruptedException {
        int chunkSize = SIZE / THREADS;
        Thread[] threads = new Thread[THREADS];
        SumTask[] tasks = new SumTask[THREADS];

        for (int i = 0; i < THREADS; i++) {
            tasks[i] = new SumTask(array, i * chunkSize, (i + 1) * chunkSize);
            threads[i] = new Thread(tasks[i]);
            threads[i].start();
        }

        int totalSum = 0;
        for (int i = 0; i < THREADS; i++) {
            threads[i].join();
            totalSum += tasks[i].getSum();
        }

        System.out.println("Total sum: " + totalSum);
    }
}

class SumTask implements Runnable {
    private int[] array;
    private int start;
    private int end;
    private int sum;

    public SumTask(int[] array, int start, int end) {
        this.array = array;
        this.start = start;
        this.end = end;
    }

    public int getSum() {
        return sum;
    }

    @Override
    public void run() {
        sum = 0;
        for (int i = start; i < end; i++) {
            sum += array[i];
        }
    }
}
```

この例では、配列の合計を 4 つのスレッドで並列に計算することで、処理時間を短縮している。
:::

:::details I/O 処理の並列化

複数のファイルからデータを読み込む際に、各ファイルの読み込みを別々のスレッドで実行することで、I/O 待ち時間を短縮できる。

```java
public class FileReadTask implements Runnable {
    private String fileName;

    public FileReadTask(String fileName) {
        this.fileName = fileName;
    }

    @Override
    public void run() {
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(fileName + ": " + line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws InterruptedException {
        String[] files = {"file1.txt", "file2.txt", "file3.txt"};
        Thread[] threads = new Thread[files.length];

        for (int i = 0; i < files.length; i++) {
            threads[i] = new Thread(new FileReadTask(files[i]));
            threads[i].start();
        }

        for (Thread thread : threads) {
            thread.join();
        }
    }
}
```

この例では、3 つのファイルをそれぞれ別のスレッドで読み込み、I/O 操作を並列に実行することで待ち時間を短縮している。
:::

## コレクションのスレッドセーフ化

コレクションは複数のスレッドから同時にアクセスされることが多

いため、スレッドセーフにすることが重要です。Java の`Collections`クラスには、コレクションをスレッドセーフにするためのメソッドがいくつか用意されています。

#### 1. `synchronizedList`

`List`をスレッドセーフにする。

```java
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
syncList.add("apple");
syncList.add("banana");

synchronized (syncList) {
    for (String item : syncList) {
        System.out.println(item);
    }
}
```

この例では、`Collections.synchronizedList`を使用して、リスト`syncList`をスレッドセーフにしています。

#### 2. `synchronizedSet`

`Set`をスレッドセーフにする。

```java
Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
syncSet.add("apple");
syncSet.add("banana");

synchronized (syncSet) {
    for (String item : syncSet) {
        System.out.println(item);
    }
}
```

この例では、`Collections.synchronizedSet`を使用して、セット`syncSet`をスレッドセーフにしています。

#### 3. `synchronizedMap`

`Map`をスレッドセーフにする。

```java
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());
syncMap.put("apple", "fruit");
syncMap.put("carrot", "vegetable");

synchronized (syncMap) {
    for (Map.Entry<String, String> entry : syncMap.entrySet()) {
        System.out.println(entry.getKey() + ": " + entry.getValue());
    }
}
```

この例では、`Collections.synchronizedMap`を使用して、マップ`syncMap`をスレッドセーフにしています。

### まとめ

- **スレッド**: プログラム内で独立して実行される一連の命令。マルチスレッドプログラミングにより、複数のスレッドが並行して実行され、実行効率が向上する。
- **スレッドセーフ**: 複数のスレッドが同時に実行されてもプログラムが正しく動作する特性。共有データへのアクセスが競合しないようにすることが重要。
- **同期化**: `synchronized`キーワードを使用してメソッドやブロックを同期化し、スレッドセーフを保証する方法。
- **ユースケース**:
  - 大規模な計算処理の並列化により、計算時間を短縮。
  - I/O 処理の並列化により、I/O 待ち時間を短縮。
- **コレクションのスレッドセーフ化**:
  - `Collections.synchronizedList`、`Collections.synchronizedSet`、`Collections.synchronizedMap`を使用して、コレクションをスレッドセーフにする。

スレッドとスレッドセーフの概念を理解することで、より効率的で信頼性の高いプログラムを設計・実装できるようになる。また、コレクションをスレッドセーフにすることで、複数のスレッドから安全にアクセスできるようになる。
