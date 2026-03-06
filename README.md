# tbls-mysql-sample

[tbls](https://github.com/k1LoW/tbls) + [dbmate](https://github.com/amacneil/dbmate) + GitHub Actions のサンプルリポジトリです。
マイグレーション管理とスキーマドキュメント自動生成・CI lint の運用例。

## 構成

```
db/migrations/           # dbmate マイグレーションファイル
docs/schema/             # tbls が生成するドキュメント (Git 管理)
.tbls.yml                # tbls 設定
.mise.toml               # dbmate / tbls のバージョン固定
.github/workflows/tbls.yml  # CI (migrate + lint + doc diff check)
docker-compose.yml       # ローカル MySQL
Makefile                 # コマンドショートカット
```

## セットアップ

### 前提

- Docker
- [mise](https://mise.jdx.dev/)

```bash
# dbmate / tbls をインストール
mise install
```

### ローカル実行

```bash
# MySQL 起動
make up

# マイグレーション実行
make migrate

# ドキュメント生成
make doc

# lint 実行
make lint

# DB とドキュメントの差分チェック
make diff

# マイグレーションをロールバック
make rollback

# MySQL 停止
make down
```

## CI の仕組み

GitHub Actions で `db/migrations/` や `.tbls.yml` が変更されたときに自動実行されます。

1. **dbmate up** — マイグレーションを適用して最新スキーマを構築
2. **tbls lint** — テーブル / カラムコメントの有無、外部キーインデックスなどをチェック
3. **tbls doc** — ドキュメントを再生成
4. **diff check** — `docs/schema/` に差分があれば CI を失敗させる

## 開発フロー

### スキーマ変更時

1. マイグレーションファイルを作成
   ```bash
   DATABASE_URL="mysql://root:password@127.0.0.1:3306/sample" dbmate new add_status_to_posts
   ```
2. 作成されたファイルに `-- migrate:up` / `-- migrate:down` を記述
3. マイグレーション適用 & ドキュメント再生成
   ```bash
   make migrate
   make doc
   ```
4. 変更をコミット & プッシュ（マイグレーション + docs/schema/ の差分）

### lint ルール変更

`.tbls.yml` の `lint` セクションを編集してください。利用可能なルールは [tbls の公式ドキュメント](https://github.com/k1LoW/tbls#lint) を参照してください。

### コメント補強

`.tbls.yml` の `comments` セクションで、DDL の `COMMENT` に加えて補足説明を追記できます。

## License

MIT
