# tbls-mysql-sample

[tbls](https://github.com/k1LoW/tbls) を使った MySQL スキーマドキュメント自動生成・CI lint の運用サンプルです。

## 構成

```
schema/init.sql          # DDL (テーブル定義)
docs/schema/             # tbls が生成するドキュメント (Git 管理)
.tbls.yml                # tbls 設定
.github/workflows/tbls.yml  # CI (lint + doc diff check)
docker-compose.yml       # ローカル MySQL
Makefile                 # コマンドショートカット
```

## セットアップ

### 前提

- Docker
- [tbls](https://github.com/k1LoW/tbls#install)

### ローカル実行

```bash
# MySQL 起動
make up

# ドキュメント生成
make doc

# lint 実行
make lint

# DB とドキュメントの差分チェック
make diff

# MySQL 停止
make down
```

## CI の仕組み

GitHub Actions で `schema/` または `.tbls.yml` が変更されたときに自動実行されます。

1. **tbls lint** — テーブル / カラムコメントの有無、外部キーインデックスなどをチェック
2. **tbls doc** — ドキュメントを再生成
3. **diff check** — `docs/schema/` に差分があれば CI を失敗させる → ローカルで `make doc` してコミットする運用

## カスタマイズ

### テーブル追加時

1. `schema/init.sql` に DDL を追加（全テーブル・全カラムに `COMMENT` を付ける）
2. `make up && make doc` でドキュメント再生成
3. 変更をコミット & プッシュ

### lint ルール変更

`.tbls.yml` の `lint` セクションを編集してください。利用可能なルールは [tbls の公式ドキュメント](https://github.com/k1LoW/tbls#lint) を参照してください。

### コメント補強

`.tbls.yml` の `comments` セクションで、DDL の `COMMENT` に加えて補足説明を追記できます。

## License

MIT
