# README

Project URL: [course-graphql-api](https://course-graphql-api.herokuapp.com/graphiql)

## System Require

* Ruby version
  * 2.7.6

* System dependencies
  * Database
    * Postgresql 14
  * API
    * graphql: Graphql API library
  * Development
    * graphiql-rails: that provides GraphQL client interface for reaction with GraphQL API.
    * dotenv-rails: that can setup environment variables.
    * annotate: display table information on model.
    * rubocop: coding style checking.
    * brakeman: security scanning.
    * lefthook: pre-commit hook before doing git commit.
  * Test
    * factory_bot_rails: easy generate test data on spec.
    * database_cleaner: clean database on test environment.
    * shoulda-matchers: that provides one-lines syntax on spec.

* Development configuration:
  * install ruby 2.7.6 via rvm/rbenv
  * bundle install
  * Create `master.key`

    ```shell
      rails credentials:edit
    ```

* Database creation
  * run `cp .env.example .env` and setup settings as below.

    ```shell
    DATABASE_NAME=course_api_development
    DATABASE_USER=postgre
    DATABASE_PASSWORD=postgre
    DATABASE_HOST=127.0.0.1
    DATABASE_DB=postgre
    DATABASE_PORT=5432
    ```

  * then run below cmd to create database and setup table

    ```shell
      rails db:create && db:migration
    ```

  * setup seed data

    ```shell
      rails db:seed
    ```

* How to run the test suite

  ```shell
  bundle exec rspec
  ```

## 開發規劃與問題解決

* 專案設計
  * 採用 Graphql API 當作本次 API 的開發設計規劃，主要是透過這次的專案開發來理解 GraphQL 的知識以及應用方式
  * 小專案的關係，先暫時不用 `bullet` gem 來做 N+1 query 的檢查
* 註解
  * 使用 `TODO` `OPTIMIZE` 當註的說明，若有較複雜的邏輯時，則會額外補充說明。
* 遇到的問題
  * 未曾撰寫過 GraphQL 的 query/mutation spec code, 所以先研究網路的寫法, 再依照需求做 spec test code 的撰寫
  * 『章節』『單元』有指定『順序』是唯一值，所以使用 unique index key 的方式，避免『順序』重複資料出現。
  * 在建立『課程』『章節』『單元』時，必須先建資料才會觸發重複資料的驗證，所以用 Transaction 將建立資料流程包覆起來，並透過 `Create!` 方式來建立，只要建立失敗就全部資料 rollback 。
* 待處理問題
  * N+1 issue: 透過 GraphQL 查詢 courses/course 時，遇到 N+1 的問題，並不能單純使用 `include` 來做排除，這部分後續會再繼續深入研究如何處理。
  * Pagination: 查詢 courses 時，當資料量過多時，應該要使用 Pagination 來做資料分頁。
  * bulk insert 的用法，建立 course 時，可以透過 `insert_all!` 來做優化，透過此方式來 bulk insert 提升建立資料的效能
  * update course 的優化方式: 需要另外花時間研究是否有更好的方式來處理。例如使用 `accepts_nested_attributes_for`
  * dockerize: 專案可以透過 docker & docker-compose 來啟動。
