以下は、Makefile に準拠した形式に置き換えた **Markdown ファイル**です。ファイル名例：`02_application_tuning.md` にするとよいでしょう。

---

````md
# アプリケーションのパフォーマンスをチューニングしよう（Makefile 対応版）

## 準備

アクセスログをローテートして、nginx をリロードします：

```bash
# 今までのアクセスログを移動
make rotate-nginx-log
```

## アプリケーションのログを集計してみる

まずベンチマーカーを実行：

```bash
make benchmark
```

```bash
#次に、nginx アクセスログを alp で集計
make analyze-nginx
```

## 静的ファイルを nginx 経由で返却する

まず設定ファイルを開きます：

```bash
sudo vi /etc/nginx/sites-available/isucon.conf
```

- `:%d` と入力して enter を押し、現在の内容をすべて削除
- [isucon.conf の設定ファイル](/lecture/part2/isucon1.conf) を貼り付け
- `:wq` で保存して閉じる

その後、nginx をリロードします：

```bash
make reload-nginx
```

# 結果の確認

「準備、アプリケーションのログを集計してみる」でやったことをもう一度行って、スコアが上がっていること、css や js の返却時間が 0 になっていることを確認する

```bash
# 今までのアクセスログを移動
make rotate-nginx-log
# nginxのreload
make reload-nginx
# ベンチマーカーの実行
make benchmark
# nginx アクセスログを alp で集計
make analyze-nginx
```

> `css` や `js` の返却時間が `0` に近くなっていれば成功です。
````
