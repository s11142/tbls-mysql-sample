# tbls-mysql-sample

[tbls](https://github.com/k1LoW/tbls) + [dbmate](https://github.com/amacneil/dbmate) + GitHub Actions のサンプルリポジトリです。
マイグレーション管理とスキーマドキュメント自動生成・CI lint の運用例。

## 構成

```
db/migrations/           # dbmate マイグレーションファイル
docs/schema/             # tbls が生成するドキュメント (Git 管理)
.tbls.yml                # tbls 設定
.mise.toml               # dbmate / tbls のバージョン固定 + タスク定義
.github/workflows/tbls.yml  # CI (migrate + lint + doc diff check)
```

## セットアップ

### 前提

- [mise](https://mise.jdx.dev/)
- Webアプリ側の MySQL が起動していること

```bash
# dbmate / tbls をインストール
mise install
```

> **NOTE:** `DATABASE_URL` / `TBLS_DSN` のデフォルトは `.mise.toml` の `[env]` に定義されています。
> Webアプリ側の MySQL が異なる接続先の場合は、環境変数で上書きしてください。

### ローカル実行

```bash
# マイグレーション実行
mise run migrate

# ドキュメント生成
mise run doc

# lint 実行
mise run lint

# DB とドキュメントの差分チェック
mise run diff

# マイグレーションをロールバック
mise run rollback
```

## CI の仕組み

GitHub Actions で `db/migrations/` や `.tbls.yml` が変更されたときに自動実行されます。

1. **dbmate up** — マイグレーションを適用して最新スキーマを構築
2. **tbls lint** — テーブル / カラムコメントの有無、外部キーインデックスなどをチェック
3. **tbls doc** — ドキュメントを再生成
4. **diff check** — `docs/schema/` に差分があれば CI を失敗させる

## 開発フロー

本リポジトリはマイグレーション・スキーマドキュメントの管理専用です。
MySQL はWebアプリ側のリポジトリで起動し、本リポジトリからは同じ DB に接続して操作します。

### スキーマ変更の全体像

```
Webアプリ側リポジトリ          本リポジトリ (tbls-mysql-sample)
──────────────────          ─────────────────────────────
1. MySQL を起動
   docker compose up -d
                             2. マイグレーション作成
                                dbmate new <name>
                             3. SQL を記述
                             4. マイグレーション適用 & ドキュメント生成
                                mise run migrate
                                mise run doc
                                mise run lint
                             5. コミット & プッシュ
                             6. CI が検証 (migrate → lint → doc → diff check)

7. スキーマ変更に合わせて
   アプリコードを修正・テスト
```

### 手順の詳細

1. **Webアプリ側で MySQL を起動する**

2. **マイグレーションファイルを作成する**
   ```bash
   dbmate new add_status_to_posts
   ```
   `db/migrations/` にファイルが生成されるので、`-- migrate:up` / `-- migrate:down` を記述する。

3. **マイグレーション適用 & ドキュメント再生成**
   ```bash
   mise run migrate
   mise run doc
   mise run lint
   ```

4. **コミット & プッシュ**
   マイグレーションファイルと `docs/schema/` の差分をまとめてコミットする。
   CI が自動で lint と doc の差分チェックを実行する。

5. **Webアプリ側でコード修正**
   スキーマの変更に合わせて、Webアプリ側のリポジトリでアプリコードを修正・テストする。

### lint ルール変更

`.tbls.yml` の `lint` セクションを編集してください。利用可能なルールは [tbls の公式ドキュメント](https://github.com/k1LoW/tbls#lint) を参照してください。

### コメント補強

`.tbls.yml` の `comments` セクションで、DDL の `COMMENT` に加えて補足説明を追記できます。

## License

MIT
