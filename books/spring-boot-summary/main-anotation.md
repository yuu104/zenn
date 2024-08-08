---
title: "主要アノテーション"
---

## @SpringBootApplication

1. **概要**
   Spring Boot アプリケーションのメインクラスに付与する複合アノテーション。
2. **付与位置**
   アプリケーションのメインクラス（通常は、main メソッドを含むクラス）。
3. **使用状況**
   Spring Boot アプリケーションを初期化するときに使用します。このアノテーションは、`@Configuration`、`@EnableAutoConfiguration`、`@ComponentScan` を組み合わせたものです。
4. **目的**
   アプリケーションのエントリーポイントを定義し、自動設定を有効にする。
5. **必要性**
   - 付与した場合: Spring Boot の自動設定が有効になり、最小限の設定でアプリケーションを起動できる
   - 付与しない場合: `@Configuration`, `@EnableAutoConfiguration`, `@ComponentScan` を個別に設定する必要がある
6. **例**
   ```java
   @SpringBootApplication
   public class MyApplication {
       public static void main(String[] args) {
           SpringApplication.run(MyApplication.class, args);
       }
   }
   ```

## @RestController

1. **概要**
   Spring Framework で提供されるアノテーションで、RESTful Web サービスのコントローラーを定義するために使用されます。
2. **付与位置**
   RESTful Web サービスを提供するコントローラークラス。
3. **使用状況**
   HTTP リクエストを処理し、直接データ（通常は JSON 形式）を返すコントローラーを定義するときに使用します。
4. **構成**

   - `@RestController` = `@Controller` + `@ResponseBody`
   - これは複合アノテーションであり、`@Controller`と`@ResponseBody`の機能を組み合わせています

5. **目的**

   - RESTful API エンドポイントの作成を簡素化すること
   - HTTP リクエストを処理し、直接データ（通常は JSON 形式）をレスポンスとして返すこと

6. **動作**

   - このアノテーションが付与されたクラスのすべてのメソッドの戻り値は、自動的にレスポンスボディとして扱われます
   - 戻り値のオブジェクトは、適切な`HttpMessageConverter`を使用して自動的に JSON（または XML）に変換されます

7. **主な特徴**

   - ビューの解決を行わず、データを直接返します
   - 各メソッドに`@ResponseBody`を付ける必要がありません
   - `@RequestBody`アノテーションと組み合わせて使用すると、リクエストボディを自動的に Java オブジェクトにデシリアライズできます

8. **必要性**

   - 付与した場合: メソッドの戻り値が自動的に HTTP レスポンスボディにシリアライズされる
   - 付与しない場合: 各メソッドに@ResponseBody を付与する必要がある

9. **例**

   ```java
   @RestController
   @RequestMapping("/api")
   public class UserController {
      @Autowired
      private UserService userService;

      @GetMapping("/users/{id}")
      public User getUser(@PathVariable Long id) {
          return userService.getUser(id);
      }

      @PostMapping("/users")
      public User createUser(@RequestBody User user) {
          return userService.createUser(user);
      }
   }
   ```

## @Service

1. **概要**
   Spring Framework で提供されるアノテーションで、ビジネスロジックを含むサービス層のクラスを定義するために使用されます。

2. **付与位置**
   ビジネスロジックを含むサービスクラス。

3. **使用状況**
   アプリケーションのビジネスロジックをカプセル化し、Spring 管理の Bean として定義するときに使用します。

4. **構成**

   - `@Service`は`@Component`の specialization です。
   - 内部的には`@Component`と同じ動作をしますが、ビジネスロジック層であることを明示的に示します。

5. **目的**

   - ビジネスサービスファサードを明示的に定義すること。
   - クラスを Spring 管理の Bean として登録し、依存性注入を可能にすること。

6. **動作**

   - このアノテーションが付与されたクラスは、Spring IoC コンテナによって自動的に検出され、Bean として登録されます。
   - コンポーネントスキャンの対象となり、他のクラスに注入可能になります。

7. **主な特徴**

   - ビジネスロジック層であることを明示的に示します。
   - トランザクション管理などの AOP を適用しやすくなります。
   - テスト時にモックやスタブに置き換えやすくなります。

8. **必要性**

   - 付与した場合: Spring IoC コンテナがクラスを自動的に検出し、Bean として管理する。
   - 付与しない場合: XML または@Configuration クラスで明示的に Bean を定義する必要がある。

9. **例**

   ```java
   @Service
   public class UserService {
      @Autowired
      private UserRepository userRepository;

      @Transactional
      public User createUser(User user) {
          // ビジネスロジック（バリデーションなど）
          return userRepository.save(user);
      }

      public User getUser(Long id) {
          return userRepository.findById(id)
              .orElseThrow(() -> new ResourceNotFoundException("User not found"));
      }
   }
   ```

## @Autowired

1. **概要**
   Spring Framework で提供されるアノテーションで、依存性注入（Dependency Injection）を自動的に行うために使用されます。

2. **付与位置**

   - フィールド
   - セッターメソッド
   - コンストラクタ

3. **使用状況**
   Spring 管理の Bean を他の Bean に注入するときに使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - Spring 4.3 以降、クラスに単一のコンストラクタしかない場合は、コンストラクタに@Autowired を付ける必要はありません。

5. **目的**

   - 依存関係の自動解決と注入を行うこと。
   - コードの結合度を下げ、テスタビリティを向上させること。

6. **動作**

   - Spring IoC コンテナが、適切な型の Bean を自動的に探し出し、注入します。
   - 型による自動ワイヤリングを行いますが、必要に応じて@Qualifier を使用して特定の Bean を指定することもできます。

7. **主な特徴**

   - コンストラクタ、セッター、フィールドの注入をサポートします。
   - デフォルトでは、注入される Bean が見つからない場合、例外をスローします。
   - `required=false`オプションを使用することで、Bean が見つからない場合でも例外をスローしないようにできます。

8. **必要性**

   - 付与した場合: Spring IoC コンテナが適切な Bean を自動的に注入する。
   - 付与しない場合: 手動でオブジェクトを生成し、依存関係を設定する必要がある。

9. **例**

   ```java
   @Service
   public class EmailService {
      private final JavaMailSender mailSender;
      private final UserRepository userRepository;

      @Autowired // コンストラクタが1つの場合、Spring 4.3以降では省略可能
      public EmailService(JavaMailSender mailSender, UserRepository userRepository) {
          this.mailSender = mailSender;
          this.userRepository = userRepository;
      }

      // フィールド注入の例（推奨されません）
      @Autowired
      private ConfigService configService;

      // セッター注入の例
      private TemplateEngine templateEngine;

      @Autowired
      public void setTemplateEngine(TemplateEngine templateEngine) {
          this.templateEngine = templateEngine;
      }

      // メソッド
   }
   ```

## @Repository

1. **概要**
   Spring Framework で提供されるアノテーションで、データアクセス層のクラスを定義するために使用されます。

2. **付与位置**
   データアクセス層のクラス（DAO クラスやリポジトリクラス）。

3. **使用状況**
   データベースとのやり取りを行うクラスや、データの永続化を担当するクラスを定義するときに使用します。

4. **構成**

   - `@Repository`は`@Component`の specialization です。
   - 内部的には`@Component`と同じ動作をしますが、データアクセス層であることを明示的に示します。

5. **目的**

   - データアクセス層のクラスを明示的に定義すること。
   - データアクセス例外を Spring のデータアクセス例外階層にマッピングすること。

6. **動作**

   - このアノテーションが付与されたクラスは、Spring IoC コンテナによって自動的に検出され、Bean として登録されます。
   - データアクセス例外を Spring の一般的なデータアクセス例外に変換します。

7. **主な特徴**

   - データアクセス層であることを明示的に示します。
   - Spring Data JPA と組み合わせて使用すると、カスタムリポジトリの実装に使用できます。
   - AOP を使用したトランザクション管理との統合が容易になります。

8. **必要性**

   - 付与した場合: データアクセス例外が Spring の DataAccessException に自動的に変換される。
   - 付与しない場合: データベース固有の例外がそのまま伝播する可能性がある。

9. **例**

   ```java
   @Repository
   public class UserRepository {
       @Autowired
       private JdbcTemplate jdbcTemplate;

       public User findById(Long id) {
           return jdbcTemplate.queryForObject(
               "SELECT * FROM users WHERE id = ?",
               new Object[]{id},
               (rs, rowNum) ->
                   new User(
                       rs.getLong("id"),
                       rs.getString("username"),
                       rs.getString("email")
                   )
           );
       }
   }
   ```

## @Controller

1. **概要**
   Spring MVC フレームワークで提供されるアノテーションで、Web リクエストを処理するコントローラークラスを定義するために使用されます。

2. **付与位置**
   Spring MVC のコントローラークラス。

3. **使用状況**
   HTTP リクエストを処理し、適切なビュー（テンプレート）を返すコントローラーを定義するときに使用します。

4. **構成**

   - `@Controller`は`@Component`の specialization です。
   - Spring MVC の`DispatcherServlet`と連携して動作します。

5. **目的**

   - Web リクエストを処理するクラスを明示的に定義すること。
   - リクエストマッピングとビュー解決を容易にすること。

6. **動作**

   - このアノテーションが付与されたクラスは、Spring IoC コンテナによって自動的に検出され、Bean として登録されます。
   - `DispatcherServlet`がリクエストを適切なコントローラーメソッドにルーティングします。

7. **主な特徴**

   - `@RequestMapping`アノテーションと組み合わせて使用し、HTTP リクエストをメソッドにマッピングします。
   - デフォルトでは、メソッドの戻り値はビュー名として解釈されます。
   - `@ResponseBody`アノテーションを使用することで、レスポンスボディを直接返すこともできます。

8. **必要性**

   - 付与した場合: クラスが Spring MVC のコントローラーとして認識され、Web リクエストを処理できる。
   - 付与しない場合: クラスが通常の Spring Bean として扱われ、Web リクエストを処理できない。

9. **例**

   ```java
   @Controller
   @RequestMapping("/users")
   public class UserController {
       @Autowired
       private UserService userService;

       @GetMapping("/{id}")
       public String getUser(@PathVariable Long id, Model model) {
           User user = userService.getUser(id);
           model.addAttribute("user", user);
           return "user-details";  // ビュー名を返す
       }

       @PostMapping
       public String createUser(@ModelAttribute User user) {
           userService.createUser(user);
           return "redirect:/users";  // リダイレクト
       }
   }
   ```

## @RequestMapping

1. **概要**
   Spring MVC フレームワークで提供されるアノテーションで、Web リクエストをハンドラーメソッドにマッピングするために使用されます。

2. **付与位置**

   - クラスレベル
   - メソッドレベル

3. **使用状況**
   HTTP リクエストを特定のコントローラーメソッドにマッピングするときに使用します。

4. **構成**

   - URL、HTTP メソッド、リクエストパラメータ、ヘッダー、メディアタイプなどの属性を指定できます。

5. **目的**

   - Web リクエストと処理メソッドを関連付けること。
   - RESTful API のエンドポイントを定義すること。

6. **動作**

   - DispatcherServlet がリクエストを受け取ると、@RequestMapping の情報に基づいて適切なハンドラーメソッドにルーティングします。

7. **主な特徴**

   - クラスレベルとメソッドレベルの両方で使用でき、階層的な URL マッピングが可能。
   - 複数の URL パターンを一つのメソッドにマッピングできる。
   - 正規表現を使用した高度な URL マッピングが可能。

8. **必要性**

   - 付与した場合: 特定の URL パターンと HTTP メソッドに対するハンドラーメソッドが明確に定義される。
   - 付与しない場合: Spring MVC がリクエストを適切なメソッドにルーティングできない。

9. **例**

   ```java
   @Controller
   @RequestMapping("/api/users")  // クラスレベルのマッピング
   public class UserController {
       @RequestMapping(method = RequestMethod.GET)  // メソッドレベルのマッピング
       public List<User> getAllUsers() {
           // すべてのユーザーを取得するロジック
       }

       @RequestMapping(value = "/{id}", method = RequestMethod.GET)
       public User getUser(@PathVariable Long id) {
           // 特定のユーザーを取得するロジック
       }

       @RequestMapping(method = RequestMethod.POST, consumes = "application/json")
       public User createUser(@RequestBody User user) {
           // ユーザーを作成するロジック
       }
   }
   ```

## @GetMapping, @PostMapping, @PutMapping, @DeleteMapping, @PatchMapping

1. **概要**
   Spring Framework 4.3 で導入された、HTTP メソッド固有のリクエストマッピングアノテーションです。

2. **付与位置**
   コントローラークラスのメソッド

3. **使用状況**
   特定の HTTP メソッド（GET, POST, PUT, DELETE, PATCH）に対応するリクエストハンドラーを定義するときに使用します。

4. **構成**

   - これらは@RequestMapping のコンポジションアノテーションです。
   - 各アノテーションは特定の HTTP メソッドに対応しています。

5. **目的**

   - 特定の HTTP メソッドに対するリクエストマッピングを簡潔に定義すること。
   - コードの可読性を向上させること。

6. **動作**

   - これらのアノテーションが付与されたメソッドは、指定された HTTP メソッドと URL パターンに一致するリクエストを処理します。

7. **主な特徴**

   - @RequestMapping よりも簡潔で明示的な記述が可能。
   - RESTful API の設計原則に沿った実装を促進。
   - URL パターン、パラメータ、ヘッダーなどの追加の制約を指定可能。

8. **必要性**

   - 付与した場合: 特定の HTTP メソッドに対するハンドラーメソッドが明確に定義される。
   - 付与しない場合: @RequestMapping を使用して明示的に HTTP メソッドを指定する必要がある。

9. **例**

   ```java
   @RestController
   @RequestMapping("/api/users")
   public class UserController {
       @GetMapping  // GET /api/users
       public List<User> getAllUsers() {
           // すべてのユーザーを取得するロジック
       }

       @GetMapping("/{id}")  // GET /api/users/{id}
       public User getUser(@PathVariable Long id) {
           // 特定のユーザーを取得するロジック
       }

       @PostMapping  // POST /api/users
       public User createUser(@RequestBody User user) {
           // ユーザーを作成するロジック
       }

       @PutMapping("/{id}")  // PUT /api/users/{id}
       public User updateUser(@PathVariable Long id, @RequestBody User user) {
           // ユーザーを更新するロジック
       }

       @DeleteMapping("/{id}")  // DELETE /api/users/{id}
       public void deleteUser(@PathVariable Long id) {
           // ユーザーを削除するロジック
       }

       @PatchMapping("/{id}")  // PATCH /api/users/{id}
       public User partialUpdateUser(@PathVariable Long id, @RequestBody Map<String, Object> updates) {
           // ユーザーを部分的に更新するロジック
       }
   }
   ```

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

## @Configuration

1. **概要**
   Spring Framework で提供されるアノテーションで、Java ベースの設定クラスを定義するために使用されます。

2. **付与位置**
   設定クラス（通常は、@Bean メソッドを含むクラス）

3. **使用状況**
   XML 設定の代わりに、Java コードでアプリケーションの設定を行うときに使用します。

4. **構成**

   - `@Configuration`は`@Component`の specialization です。
   - 通常、@Bean アノテーションが付与されたメソッドを 1 つ以上含みます。

5. **目的**

   - Spring IoC コンテナに対して、Bean の定義ソースであることを示すこと。
   - アプリケーションのコンポーネントを設定し、それらの依存関係を定義すること。

6. **動作**

   - このアノテーションが付与されたクラスは、Spring IoC コンテナによって処理され、Bean の定義ソースとして扱われます。
   - クラス内の@Bean アノテーションが付与されたメソッドは、Bean の定義を提供します。

7. **主な特徴**

   - Java コードでのフルコントロールによる柔軟な設定が可能。
   - プログラマティックな Bean 定義が可能。
   - タイプセーフな設定が可能。
   - IDE のサポートが受けやすい。

8. **必要性**

   - 付与した場合: クラスが Spring の設定クラスとして認識され、@Bean メソッドからの Bean 定義が処理される。
   - 付与しない場合: クラスが通常の Spring Bean として扱われ、@Bean メソッドが無視される可能性がある。

9. **例**

   ```java
   @Configuration
   public class AppConfig {
       @Bean
       public DataSource dataSource() {
           DriverManagerDataSource dataSource = new DriverManagerDataSource();
           dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
           dataSource.setUrl("jdbc:mysql://localhost:3306/mydb");
           dataSource.setUsername("user");
           dataSource.setPassword("password");
           return dataSource;
       }

       @Bean
       public JdbcTemplate jdbcTemplate(DataSource dataSource) {
           return new JdbcTemplate(dataSource);
       }
   }
   ```

## @ConfigurationProperties

1. **概要**
   Spring Boot で提供されるアノテーションで、外部設定プロパティを型安全な方法で Java オブジェクトにバインドするために使用されます。

2. **付与位置**

   - クラス
   - @Bean メソッド

3. **使用状況**
   アプリケーションの設定プロパティ（application.properties, application.yml, 環境変数など）を扱う際に使用します。

4. **構成**

   - prefix を指定して、特定のプロパティグループをバインドします。
   - 通常、@Component や@Configuration と併用されます。

5. **目的**

   - 外部設定を型安全な方法で Java オブジェクトにマッピングすること。
   - 設定の一元管理と再利用性を向上させること。

6. **動作**

   - 指定された prefix に基づいて、外部設定プロパティを Java オブジェクトのフィールドにバインドします。
   - リフレクションを使用して、プロパティ名とフィールド名をマッチングさせます。

7. **主な特徴**

   - 階層的な設定プロパティのサポート。
   - リストや配列などの複雑な型のバインディングが可能。
   - バリデーションと組み合わせて使用可能（@Validated アノテーションを併用）。
   - relaxed binding をサポート（例：database-url, database_url, DATABASE_URL などが同じプロパティにバインド）。

8. **必要性**

   - 付与した場合: 外部設定プロパティが自動的に Java オブジェクトにマッピングされる。
   - 付与しない場合: @Value アノテーションを使用して個別にプロパティを注入する必要がある。

9. **例**

   ```java
   @Configuration
   @ConfigurationProperties(prefix = "app.datasource")
   public class DataSourceProperties {
       private String url;
       private String username;
       private String password;

       // getters and setters

       @Bean
       public DataSource dataSource() {
           DriverManagerDataSource dataSource = new DriverManagerDataSource();
           dataSource.setUrl(this.url);
           dataSource.setUsername(this.username);
           dataSource.setPassword(this.password);
           return dataSource;
       }
   }

   // application.properties
   // app.datasource.url=jdbc:mysql://localhost:3306/mydb
   // app.datasource.username=user
   // app.datasource.password=password
   ```

## @PathVariable

1. **概要**
   Spring MVC で提供されるアノテーションで、URL パスの変数部分をメソッドの引数にバインドするために使用されます。

2. **付与位置**
   コントローラーメソッドの引数

3. **使用状況**
   RESTful API で動的な URL パスを扱う際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - オプションで、URL テンプレート内の変数名を指定できます。

5. **目的**

   - URL パスの一部を動的に取得し、メソッドパラメータとして使用すること。
   - RESTful API のパス設計を容易にすること。

6. **動作**

   - URL パス内の中括弧{}で囲まれた部分を、アノテーションが付与された引数にバインドします。
   - 必要に応じて、自動的に型変換を行います（例：文字列から数値へ）。

7. **主な特徴**

   - 複数のパス変数を同時に扱うことができます。
   - 正規表現を使用して、パス変数の形式を制限できます。
   - 必須でないパス変数を定義できます（required = false）。

8. **必要性**

   - 付与した場合: URL パスの変数部分が自動的にメソッドパラメータにマッピングされる。
   - 付与しない場合: URL パスの変数を手動で解析する必要がある。

9. **例**

   ```java
   @RestController
   @RequestMapping("/api/users")
   public class UserController {
       @GetMapping("/{id}")
       public User getUser(@PathVariable Long id) {
           // idを使用してユーザーを取得するロジック
           return userService.getUser(id);
       }

       @GetMapping("/{userId}/orders/{orderId}")
       public Order getUserOrder(
           @PathVariable Long userId,
           @PathVariable("orderId") Long orderIdentifier
       ) {
           // userIdとorderIdentifierを使用して注文を取得するロジック
           return orderService.getUserOrder(userId, orderIdentifier);
       }

       @GetMapping("/{id:\\d+}")
       public User getUserWithRegex(@PathVariable Long id) {
           // 数字のみを受け付けるパス変数
           return userService.getUser(id);
       }
   }
   ```

## @RequestParam

1. **概要**
   Spring MVC で提供されるアノテーションで、HTTP リクエストパラメータをメソッドの引数にバインドするために使用されます。

2. **付与位置**
   コントローラーメソッドの引数

3. **使用状況**
   クエリパラメータ、フォームデータ、マルチパートリクエストのパラメータを取得する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - オプションで、パラメータ名、デフォルト値、必須フラグなどを指定できます。

5. **目的**

   - HTTP リクエストパラメータを簡単に取得し、メソッドパラメータとして使用すること。
   - パラメータの型変換や必須チェックを自動化すること。

6. **動作**

   - リクエストパラメータの名前と一致する引数に値をバインドします。
   - 必要に応じて、自動的に型変換を行います（例：文字列から数値へ）。

7. **主な特徴**

   - 必須でないパラメータを定義できます（required = false）。
   - デフォルト値を指定できます。
   - 複数の値を持つパラメータを配列やリストとして受け取ることができます。
   - バインディングエラーが発生した場合、自動的にエラーハンドリングされます。

8. **必要性**

   - 付与した場合: リクエストパラメータが自動的にメソッドパラメータにマッピングされる。
   - 付与しない場合: HttpServletRequest を使用して手動でパラメータを取得する必要がある。

9. **例**

   ```java
   @RestController
   @RequestMapping("/api/users")
   public class UserController {
       @GetMapping("/search")
       public List<User> searchUsers(
           @RequestParam(name = "name", required = false) String name,
           @RequestParam(defaultValue = "1") int page,
           @RequestParam(name = "size", defaultValue = "10") int pageSize
       ) {
           // nameでユーザーを検索し、ページネーションを適用するロジック
           return userService.searchUsers(name, page, pageSize);
       }

       @GetMapping("/filter")
       public List<User> filterUsers(@RequestParam Map<String, String> params) {
           // すべてのクエリパラメータをMapとして受け取る
           return userService.filterUsers(params);
       }

       @GetMapping("/roles")
       public List<User> getUsersByRoles(@RequestParam List<String> roles) {
           // 複数の役割を指定してユーザーを取得するロジック
           return userService.getUsersByRoles(roles);
       }
   }
   ```

## @RequestBody

1. **概要**
   Spring MVC で提供されるアノテーションで、HTTP リクエストボディをメソッドの引数にバインドするために使用されます。

2. **付与位置**
   コントローラーメソッドの引数

3. **使用状況**
   JSON、XML、その他のメディアタイプで送信されるリクエストボディを受け取る際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - 通常、POST、PUT、PATCH リクエストで使用されます。

5. **目的**

   - HTTP リクエストボディを自動的に Java オブジェクトにデシリアライズすること。
   - RESTful API でのデータの送受信を簡素化すること。

6. **動作**

   - リクエストボディの内容を、指定された型の Java オブジェクトに変換します。
   - 変換には、設定された HttpMessageConverter が使用されます。

7. **主な特徴**

   - コンテンツタイプに基づいて適切な HttpMessageConverter が選択されます。
   - バリデーションアノテーション（@Valid）と組み合わせて使用できます。
   - 一つのメソッドに一つの@RequestBody のみ使用可能です。
   - リクエストボディが存在しない場合、400 Bad Request エラーが返されます。

8. **必要性**

   - 付与した場合: リクエストボディが自動的に Java オブジェクトにデシリアライズされる。
   - 付与しない場合: リクエストボディを手動で解析して Java オブジェクトに変換する必要がある。

9. **例**

   ```java
   @RestController
   @RequestMapping("/api/users")
   public class UserController {
       @PostMapping
       public User createUser(@RequestBody @Valid User user) {
           // ユーザーを作成するロジック
           return userService.createUser(user);
       }

       @PutMapping("/{id}")
       public User updateUser(@PathVariable Long id, @RequestBody User user) {
           // ユーザーを更新するロジック
           return userService.updateUser(id, user);
       }

       @PatchMapping("/{id}")
       public User partialUpdateUser(@PathVariable Long id, @RequestBody Map<String, Object> updates) {
           // ユーザーを部分的に更新するロジック
           return userService.partialUpdateUser(id, updates);
       }
   }
   ```

## @ControllerAdvice

1. **概要**
   Spring MVC で提供されるアノテーションで、複数のコントローラーに対してグローバルな機能を提供するために使用されます。

2. **付与位置**
   クラス

3. **使用状況**
   複数のコントローラーに共通する例外処理、モデル属性のバインディング、データバインディングの初期化などを一元管理する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - オプションで適用範囲（特定のコントローラークラス、パッケージなど）を指定できます。

5. **目的**

   - グローバルな例外処理を提供すること。
   - 複数のコントローラーに共通するロジックを集中化すること。
   - コードの重複を減らし、保守性を向上させること。

6. **動作**

   - このアノテーションが付与されたクラスは、指定された（または全ての）コントローラーに対して、アドバイス（横断的な機能）を提供します。
   - Spring MVC がリクエストを処理する際に、@ControllerAdvice クラスのメソッドが適用されます。

7. **主な特徴**

   - @ExceptionHandler メソッドを使用して、グローバルな例外処理を定義できます。
   - @InitBinder メソッドを使用して、データバインディングの初期化をグローバルに行えます。
   - @ModelAttribute メソッドを使用して、全てのコントローラーに共通のモデル属性を追加できます。
   - 特定のコントローラーやパッケージに対象を限定することができます。

8. **必要性**

   - 付与した場合: 複数のコントローラーに対して共通の機能を一元的に提供できる。
   - 付与しない場合: 各コントローラーで個別に例外処理やデータバインディングの設定を行う必要がある。

9. **例**

   ```java
   @ControllerAdvice
   public class GlobalExceptionHandler {
       @ExceptionHandler(ResourceNotFoundException.class)
       public ResponseEntity<ErrorResponse> handleResourceNotFoundException(ResourceNotFoundException ex) {
           ErrorResponse error = new ErrorResponse("Resource Not Found", ex.getMessage());
           return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
       }

       @ExceptionHandler(Exception.class)
       public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
           ErrorResponse error = new ErrorResponse("Internal Server Error", ex.getMessage());
           return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
       }

       @InitBinder
       public void initBinder(WebDataBinder binder) {
           SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
           binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
       }

       @ModelAttribute
       public void addAttributes(Model model) {
           model.addAttribute("globalAttribute", "Value available to all controllers");
       }
   }

   // 特定のパッケージに限定したControllerAdvice
   @ControllerAdvice("com.example.controllers")
   public class SpecificPackageAdvice {
       // このパッケージ内のコントローラーにのみ適用されるアドバイス
   }

   // 特定のコントローラータイプに限定したControllerAdvice
   @ControllerAdvice(annotations = RestController.class)
   public class RestControllerAdvice {
       // @RestControllerアノテーションが付いたコントローラーにのみ適用されるアドバイス
   }
   ```

@ControllerAdvice を使用することで、Spring Boot アプリケーションの横断的な関心事を効果的に管理できます。例外処理の一元化、共通のデータバインディング設定、グローバルなモデル属性の提供などが可能になり、コードの重複を減らし、アプリケーションの保守性を向上させることができます。

特に、RESTful API の開発において、@ControllerAdvice は一貫したエラーレスポンスの生成や、アプリケーション全体でのバリデーションロジックの適用などに非常に有用です。また、特定のコントローラーやパッケージに適用範囲を限定することで、より細かい制御も可能になります。

## @ExceptionHandler

1. **概要**
   Spring MVC で提供されるアノテーションで、特定の例外をハンドリングするメソッドを定義するために使用されます。

2. **付与位置**
   コントローラークラスのメソッド、または `@ControllerAdvice` クラスのメソッド

3. **使用状況**
   アプリケーション固有の例外処理ロジックを実装する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - ハンドリングする例外のクラスを指定します。

5. **目的**

   - 特定の例外に対するカスタムエラーレスポンスを定義すること。
   - グローバルな例外処理を一元管理すること。

6. **動作**

   - 指定された例外（またはそのサブクラス）が発生した場合、そのメソッドが呼び出されます。
   - メソッドの戻り値がクライアントに返されます。

7. **主な特徴**

   - 複数の例外クラスを一つのハンドラーで処理できます。
   - `@ResponseStatus` と組み合わせて、HTTP ステータスコードを指定できます。
   - `@ControllerAdvice` と併用することで、アプリケーション全体の例外処理を集中管理できます。
   - 例外オブジェクトを引数として受け取り、エラーメッセージなどの詳細情報にアクセスできます。

8. **必要性**

   - 付与した場合: 特定の例外に対してカスタマイズされたエラーレスポンスを返すことができる。
   - 付与しない場合: デフォルトの例外処理メカニズムが使用され、詳細なエラー情報がクライアントに露出する可能性がある。

9. **例**

   ```java
   @RestControllerAdvice
   public class GlobalExceptionHandler {
       @ExceptionHandler(ResourceNotFoundException.class)
       @ResponseStatus(HttpStatus.NOT_FOUND)
       public ErrorResponse handleResourceNotFoundException(ResourceNotFoundException ex) {
           return new ErrorResponse("Resource not found", ex.getMessage());
       }

       @ExceptionHandler(ValidationException.class)
       @ResponseStatus(HttpStatus.BAD_REQUEST)
       public ErrorResponse handleValidationException(ValidationException ex) {
           return new ErrorResponse("Validation error", ex.getMessage());
       }

       @ExceptionHandler(Exception.class)
       @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
       public ErrorResponse handleGenericException(Exception ex) {
           return new ErrorResponse("Internal server error", "An unexpected error occurred");
       }
   }

   @RestController
   @RequestMapping("/api/users")
   public class UserController {
       @ExceptionHandler(UserNotFoundException.class)
       @ResponseStatus(HttpStatus.NOT_FOUND)
       public ErrorResponse handleUserNotFoundException(UserNotFoundException ex) {
           return new ErrorResponse("User not found", ex.getMessage());
       }

       @GetMapping("/{id}")
       public User getUser(@PathVariable Long id) {
           // ユーザーを取得するロジック
           // UserNotFoundExceptionがスローされる可能性がある
       }
   }
   ```

## @Value

1. **概要**
   Spring Framework で提供されるアノテーションで、プロパティ値を直接フィールドやメソッド/コンストラクタのパラメータに注入するために使用されます。

2. **付与位置**

   - フィールド
   - メソッドパラメータ
   - コンストラクタパラメータ

3. **使用状況**
   設定ファイル、環境変数、システムプロパティなどから値を取得して注入する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - プロパティのキーやデフォルト値を指定できます。

5. **目的**

   - 外部設定値を簡単に注入すること。
   - プロパティ値の動的な解決を可能にすること。

6. **動作**

   - 指定されたキーに基づいて、プロパティソースから値を取得し、フィールドやパラメータに注入します。
   - Spring 式言語（SpEL）を使用して、複雑な値の解決も可能です。

7. **主な特徴**

   - プレースホルダー構文（${...}）を使用してプロパティ値を参照できます。
   - デフォルト値を指定できます。
   - タイプ変換が自動的に行われます。
   - SpEL を使用して、複雑な式や条件付きの値を定義できます。

8. **必要性**

   - 付与した場合: プロパティ値が自動的にフィールドやパラメータに注入される。
   - 付与しない場合: プログラムコード内で明示的にプロパティ値を取得・設定する必要がある。

9. **例**

   ```java
   @Component
   public class MyComponent {
       @Value("${app.name}")
       private String appName;

       @Value("${app.description:Default description}")
       private String appDescription;

       @Value("#{systemProperties['user.country']}")
       private String userCountry;

       @Value("#{T(java.lang.Math).random() * 100.0}")
       private double randomNumber;

       @Value("#{new java.text.SimpleDateFormat('yyyy-MM-dd').parse('2023-01-01')}")
       private Date startDate;

       // コンストラクタ、メソッドなど
   }
   ```

## @Transactional

1. **概要**
   Spring Framework で提供されるアノテーションで、メソッドやクラスにトランザクション境界を定義するために使用されます。

2. **付与位置**

   - クラス
   - メソッド

3. **使用状況**
   データベース操作を含むビジネスロジックにトランザクション管理を適用する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - トランザクションの属性（分離レベル、伝播動作など）を指定できます。

5. **目的**

   - メソッドの実行をトランザクション境界で囲むこと。
   - データの整合性を保証すること。
   - 複数のデータベース操作を原子的に実行すること。

6. **動作**

   - メソッド開始時にトランザクションを開始し、正常終了時にコミット、例外発生時にロールバックします。
   - クラスレベルで定義された場合、そのクラスのすべての公開メソッドにトランザクションが適用されます。

7. **主な特徴**

   - 宣言的トランザクション管理を提供します。
   - トランザクションの分離レベルを指定できます。
   - トランザクションの伝播動作を制御できます。
   - ロールバックのルールをカスタマイズできます。
   - 読み取り専用トランザクションを定義できます。

8. **必要性**

   - 付与した場合: メソッドの実行が自動的にトランザクション境界で囲まれる。
   - 付与しない場合: プログラムコード内で明示的にトランザクション管理を行う必要がある。

9. **例**

   ```java
   @Service
   public class UserService {
       @Autowired
       private UserRepository userRepository;

       @Transactional
       public void createUser(User user) {
           userRepository.save(user);
           // 他のデータベース操作
       }

       @Transactional(readOnly = true)
       public User getUser(Long id) {
           return userRepository.findById(id)
               .orElseThrow(() -> new UserNotFoundException(id));
       }

       @Transactional(propagation = Propagation.REQUIRES_NEW, isolation = Isolation.SERIALIZABLE)
       public void transferMoney(Long fromId, Long toId, BigDecimal amount) {
           // 送金ロジック
       }
   }
   ```

## @Scheduled

1. **概要**
   Spring Framework で提供されるアノテーションで、メソッドを定期的に実行するスケジュールタスクを定義するために使用されます。

2. **付与位置**
   メソッド

3. **使用状況**
   定期的なバッチ処理、データ更新、クリーンアップタスクなどを実装する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - 実行のタイミングやインターバルを指定するための属性を持ちます。

5. **目的**

   - メソッドを指定された間隔や時間に自動的に実行すること。
   - 定期的なタスクの管理を簡素化すること。

6. **動作**

   - アプリケーション起動時にスケジューラーが初期化され、指定されたタイミングでメソッドが呼び出されます。
   - デフォルトでは単一スレッドで実行されますが、並列実行も設定可能です。

7. **主な特徴**

   - cron 式を使用して複雑なスケジュールを定義できます。
   - 固定レート（fixedRate）または固定遅延（fixedDelay）での実行が可能です。
   - 初期遅延（initialDelay）を設定できます。
   - プロパティからスケジュール設定を動的に読み込むことができます。

8. **必要性**

   - 付与した場合: メソッドが自動的にスケジュールされ、定期的に実行される。
   - 付与しない場合: タスクのスケジューリングを手動で管理する必要がある。

9. **例**

   ```java
   @Component
   public class ScheduledTasks {
       private static final Logger log = LoggerFactory.getLogger(ScheduledTasks.class);

       @Scheduled(fixedRate = 5000) // 5秒ごとに実行
       public void reportCurrentTime() {
           log.info("The time is now {}", new Date());
       }

       @Scheduled(cron = "0 0 1 * * ?") // 毎日午前1時に実行
       public void performDailyCleanup() {
           // 日次クリーンアップ処理
       }

       @Scheduled(fixedDelay = 1000, initialDelay = 5000) // 5秒後に開始し、その後1秒間隔で実行
       public void doSomething() {
           // 何らかの処理
       }

       @Scheduled(fixedRateString = "${my.fixedRate}")
       public void scheduleTaskUsingProperty() {
           // プロパティから設定を読み込んで実行
       }
   }
   ```

## @Profile

1. **概要**
   Spring Framework で提供されるアノテーションで、特定の環境プロファイルでのみコンポーネントを有効にするために使用されます。

2. **付与位置**

   - クラス
   - メソッド（@Bean メソッドを含む）

3. **使用状況**
   異なる環境（開発、テスト、本番など）に応じて異なる設定やビーンを使用する際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - 一つまたは複数のプロファイル名を指定します。

5. **目的**

   - 環境固有の設定やビーンを定義すること。
   - アプリケーションの柔軟性と再利用性を高めること。

6. **動作**

   - 指定されたプロファイルがアクティブな場合にのみ、アノテーションが付与されたコンポーネントが有効になります。
   - プロファイルは、アプリケーション起動時や実行時に設定できます。

7. **主な特徴**

   - 複数のプロファイルを指定できます。
   - NOT 演算子（!）を使用して、特定のプロファイルが非アクティブな場合にコンポーネントを有効にできます。
   - SpEL（Spring Expression Language）を使用して、より複雑な条件を指定できます。

8. **必要性**

   - 付与した場合: コンポーネントが特定の環境でのみ有効になる。
   - 付与しない場合: コンポーネントがすべての環境で常に有効になる。

9. **例**

   ```java
   @Configuration
   public class AppConfig {
       @Bean
       @Profile("dev")
       public DataSource devDataSource() {
           // 開発環境用のデータソース設定
       }

       @Bean
       @Profile("prod")
       public DataSource prodDataSource() {
           // 本番環境用のデータソース設定
       }
   }

   @Service
   @Profile("!prod")
   public class DevOnlyService {
       // 本番環境以外でのみ有効なサービス
   }

   @RestController
   @Profile({"dev", "test"})
   public class TestController {
       // 開発環境とテスト環境でのみ有効なコントローラー
   }
   ```

## @Async

1. **概要**
   Spring Framework で提供されるアノテーションで、メソッドを非同期的に実行するために使用されます。

2. **付与位置**

   - メソッド
   - クラス

3. **使用状況**
   時間のかかる処理を非同期で実行し、アプリケーションの応答性を向上させる際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - オプションでカスタム Executor の名前を指定できます。

5. **目的**

   - メソッドを非同期的に実行し、呼び出し元のスレッドをブロックしないこと。
   - 並列処理によってアプリケーションのパフォーマンスを向上させること。

6. **動作**

   - アノテーションが付与されたメソッドは、別のスレッドで実行されます。
   - デフォルトでは、SimpleAsyncTaskExecutor が使用されますが、カスタム Executor を設定することも可能です。

7. **主な特徴**

   - メソッドの戻り値として Future や CompletableFuture を使用できます。
   - クラスレベルで適用すると、そのクラスのすべての公開メソッドが非同期になります。
   - 例外処理には注意が必要で、AsyncUncaughtExceptionHandler を使用できます。

8. **必要性**

   - 付与した場合: メソッドが非同期的に実行され、呼び出し元のスレッドがブロックされない。
   - 付与しない場合: メソッドが同期的に実行され、処理が完了するまで呼び出し元のスレッドがブロックされる。

9. **例**

   ```java
   @Service
   public class AsyncService {
       @Async
       public void asyncMethod() {
           // 時間のかかる処理
       }

       @Async
       public CompletableFuture<String> asyncMethodWithResult() {
           // 非同期処理
           return CompletableFuture.completedFuture("結果");
       }
   }

   @Configuration
   @EnableAsync
   public class AsyncConfig implements AsyncConfigurer {
       @Override
       public Executor getAsyncExecutor() {
           ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
           executor.setCorePoolSize(5);
           executor.setMaxPoolSize(10);
           executor.setQueueCapacity(25);
           executor.initialize();
           return executor;
       }
   }
   ```

## @Valid

1. **概要**
   Java Bean Validation で提供されるアノテーションで、Spring MVC と統合されており、オブジェクトのバリデーションを行うために使用されます。

2. **付与位置**

   - メソッドパラメータ
   - フィールド（ネストされたバリデーションの場合）

3. **使用状況**
   リクエストボディ、フォームデータ、パスパラメータなどの入力データのバリデーションを行う際に使用します。

4. **構成**

   - 単独で使用されるアノテーションです。
   - 通常、他のバリデーションアノテーション（@NotNull, @Size, @Email など）と併用されます。

5. **目的**

   - 入力データの整合性を確保すること。
   - バリデーションロジックをビジネスロジックから分離すること。

6. **動作**

   - Spring MVC がリクエストを処理する際に、@Valid が付与されたパラメータに対してバリデーションを実行します。
   - バリデーションエラーが発生した場合、BindingResult オブジェクトにエラー情報が格納されます。

7. **主な特徴**

   - グループバリデーションをサポートしています。
   - カスタムバリデーションアノテーションを作成して使用できます。
   - ネストされたオブジェクトのバリデーションが可能です。
   - @Validated アノテーションと組み合わせて使用することで、より詳細な制御が可能です。

8. **必要性**

   - 付与した場合: オブジェクトのフィールドに対して自動的にバリデーションが実行される。
   - 付与しない場合: バリデーションを手動で実行するか、バリデーションが行われない。

9. **例**

   ```java
   @RestController
   @RequestMapping("/api/users")
   public class UserController {
       @PostMapping
       public ResponseEntity<User> createUser(@Valid @RequestBody User user, BindingResult result) {
           if (result.hasErrors()) {
               // バリデーションエラーの処理
               return ResponseEntity.badRequest().body(null);
           }
           // ユーザー作成ロジック
           return ResponseEntity.ok(user);
       }
   }

   public class User {
       @NotNull
       @Size(min = 2, max = 30)
       private String name;

       @Email
       private String email;

       @NotNull
       @Min(18)
       private Integer age;

       // getters and setters
   }
   ```
