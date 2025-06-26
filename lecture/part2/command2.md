# 画像を静的ファイルとしてキャッシュしよう（Makefile 対応版）

## 問題となるエンドポイントの特定

```bash
# 集計用のコマンド
make analyze-nginx
```

## 画像を静的ファイルから返す設定

```bash
# nginxの設定ファイルを開く
sudo vi /etc/nginx/sites-available/isucon.conf
```

- `:%d` と入力して Enter で内容を全削除
- [isucon.conf の設定ファイル](/lecture/part2/isucon2.conf) を貼り付け
- `:wq` で保存して終了

その後、nginx をリロードします：

```bash
make reload-nginx
```

## 結果の確認

```bash
# 今までのアクセスログを移動
make rotate-access-log
# ベンチマーカーを走らせるための、スコア計測用コマンド
make benchmark
# 集計用のコマンド
make analyze-nginx
```

> 画像系のエンドポイント（`/image/...`）のレスポンス時間が **ほぼ 0 秒** になっていれば成功です！

```

```
