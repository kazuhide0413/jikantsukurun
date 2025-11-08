## サービス名（仮）

時間作るん

## サービス概要

時間作るんは、誰もが**毎日必ずする習慣**を手助けするサービスです。
**毎日必ずする習慣**（自炊、洗濯、風呂、歯磨き等）が出来たら記録をつけていき、その結果を可視化します。
小さな達成を積み重ねて、習慣を自然に身につけていき、日々使える時間を増やすことができます。

## このサービスへの思い・作りたい理由

現在、働きながらプログラミングを学んでいます。
仕事が終わった後に勉強するというのはなかなかハードルが高く、辛いものだと日々感じてます。
私はその辛さの大きな原因として、時間が無いことだと考えてます。
なんとかして自分の使える時間を生み出せないかと悩んでた際、日常生活での無駄を減らせばよいと考えました。
無駄な時間をなくすことができたという達成感を毎日感じることによって、辛さも減っていくと考えています。

### このサービスにおける無駄な時間の定義（例）

1. 風呂に入ろうと決心する（22時）
2. 面倒くさいと思う
3. スマホさわったりテレビみたりしてだらだらする（30分くらい）
4. そろそろ風呂に入ろうと思い、入る（22時30分）
5. 1.〜4.で発生した30分間は無駄な時間！

## ユーザー層について

- 社会人、主婦、学生など該当は幅広く想定しています。  
私自身と照らし合わせ、特に働いた後の社会人に使っていただきたいです。
- やるべきことがあるのに、気づいたら時間が経っていると日々後悔している方が対象です。
- やるべきことの有無に関わらず、時間を効率よく使いたい方が対象です。

## サービス利用のイメージ（例：帰宅後のサラリーマン）

1. 初期設定で**毎日必ずする習慣**（自炊、洗濯、風呂、歯磨き等）を登録します。
2. 働いて家に帰宅したら、サービスを開いて「帰宅ボタン」を押します。
3. サービスを開いて、習慣をやり終える度に「登録した習慣ボタン」を押します。
4. 登録したすべての習慣が終わります。
5. 就寝するときに、「就寝ボタン」を押します。
6. 5.で押された時刻と4.で押された時刻の差分は有効に使える時間だと考えてます。
7. **無駄な時間を減らせたことにより生まれた有効に使える時間を、カレンダーで見れるようにします。**

## ユーザーの獲得について

- インターネットやXを利用した拡散  
ちょっとした無駄な時間を減らせたと拡散されれば利用したいと考える人も増えていく想定です。

## サービスの差別化ポイント・推しポイント

1. 差別化ポイント  
習慣化サービスが多くありますが、本サービスでは**毎日必ずする習慣**（自炊、洗濯、風呂、歯磨き等）に重きをおいて習慣化します。

| 特徴 | 時間作るん（本サービス） | 競合Aサービス | 競合Bサービス |
| - | - | - | - |
| 想定している習慣 | 自炊、洗濯、風呂、歯磨き | 読書、筋トレ、散歩 | 読書、筋トレ、散歩 |
| 想定しているユーザー層 | ◎<br>意識の低い層<br>特に忙しい社会人・主婦・学生 | △<br>意識の高い層 | △<br>意識の高い層 | 
| 実施のハードル | ◎<br>日々必須でやるべきこと | ⚪︎<br>わざわざ時間を作る必要がある<br>（習慣はあえて1つだけ設定） | △<br>わざわざ時間を作る必要がある<br>（習慣を複数設定） |
| 習慣達成の実感 | ◎<br>無駄な時間を減らせた達成感がある | △<br>項目を1つに絞っており<br>人によっては感じづらい | △<br>達成後に満足して<br>時間を無駄にしてしまう可能性がある |

2. 推しポイント  
本サービスを利用することで、気づかないうちに無駄になっている時間を取り戻すことができます。

3. 継続利用のために  
本サービスはデフォルトの習慣（洗濯、風呂、歯磨き）を設定して、わざわざ習慣を登録しなくてもよいようにします。<br>
ログイン完了後すぐに項目を表示し、ボタンワンクリックで習慣を入力し終わります。

## 機能候補

### 【MVPリリースまでに作っていたい機能】

- ユーザー登録機能（メールアドレス）
- ログイン機能（メールアドレス）
- 日々の習慣作成機能
- 日々の習慣登録機能
- 日々の習慣削除機能
- 日々の習慣編集機能
- カレンダーに有効に使えた時間を表示する機能

### 【本リリースまでに作っていたい機能】

- ユーザー登録機能（LINEアカウント）
- ログイン機能（LINEアカウント）
- PWA対応（まるでスマートフォンのアプリのように使えるようにする技術）
- 前日に達成した習慣を指定した時間に、通知させる機能（LINE）
#### 検討中
- サービスの背景（色あい）が日によって変わる機能（7色を想定）
- ユーザー登録機能（Googleアカウント、Appleアカウント）
- ログイン機能（Googleアカウント、Appleアカウント）
- カレンダーに日々達成した習慣を表示する機能（googleカレンダー）
- カレンダーに日々達成した習慣を表示する機能（Appleカレンダー）
- パスワードリセット機能

## 機能の実装方針

| 機能 / カテゴリ | 技術 |
| - | - |
| バックエンド | Ruby on Rails 7.2.2.1 / Ruby 3.2.3 |
| フロントエンド | JavaScript / Stimulus |
| CSS フレームワーク | Tailwind CSS / daisyUI |
| 環境構築 | Docker |
| インフラ | Render |
| データベース | PostgreSQL |
| 認証機能 | Devise / omniauth-line / omniauth-google-oauth2 / omniauth-apple |

## 画面遷移図

https://www.figma.com/design/AB77xgxg39nGXgD8SHgSEi/%E6%99%82%E9%96%93%E4%BD%9C%E3%82%8B%E3%82%93?node-id=20-2&p=f&t=4CYouGWBatNeBuBA-0

## ER図

```mermaid
erDiagram
    direction TB

    USERS {
        int id PK "(NOTNULL)"
        string name "ユーザー名(NOTNULL)"
        string email "メールアドレス(NOTNULL)"
        string encrypted_password "暗号化済みパスワード(NOTNULL)"
        string reset_password_token
        datetime reset_password_sent_at
        datetime remember_created_at
        datetime created_at
        datetime updated_at
    }

    HABITS {
        int id PK "(NOTNULL)"
        int user_id FK
        string title "習慣名(NOTNULL)"
        datetime created_at
        datetime updated_at
    }

    DAILY_HABIT_RECORDS {
        int id PK "(NOTNULL)"
        int user_id FK "(NOTNULL)"
        int habit_id FK "(NOTNULL)"
        date record_date "記録日(NOTNULL)"
        boolean is_completed "完了したか"
        datetime completed_at "完了時刻"
        datetime created_at
        datetime updated_at
    }

    DAILY_SESSIONS {
        int id PK "(NOTNULL)"
        int user_id FK "(NOTNULL)"
        date session_date "セッション日付(NOTNULL)"
        datetime return_home_at "帰宅時刻"
        datetime bedtime_at "就寝時刻"
        int effective_duration "有効時間(分単位)"
        datetime created_at
        datetime updated_at
    }

    DEFAULT_HABITS {
        int id PK "(NOTNULL)"
        string title "共通デフォルト習慣名(NOTNULL)"
        datetime created_at
        datetime updated_at
    }

    USERS ||--o{ HABITS : ""
    USERS ||--o{ DAILY_HABIT_RECORDS : ""
    USERS ||--o{ DAILY_SESSIONS : ""
    HABITS ||--o{ DAILY_HABIT_RECORDS : ""
```