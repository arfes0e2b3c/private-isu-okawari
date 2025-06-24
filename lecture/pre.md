# 初級者用事前準備手順

1. AWS の[Cloud Formation](https://ap-northeast-1.console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/create)にアクセスします
2. 「前提条件 - テンプレートの準備」は「既存のテンプレートを選択」をチェック
3. 「テンプレートの指定」は「テンプレートファイルのアップロード」をチェック
4. 「ファイルの選択」をクリックし、Discord に添付されていたファイルをアップロード
5. 「次へ」を選択
6. 「スタック名」に好きな文字を入れる
7. 「パラメータ」の「KeyName」に自分のキーペアを設定。(キーペア未作成の方は[こちら](https://qiita.com/tumu1632/items/e7b5357f7c36939209d5)などを参考にしてキーペアを作成してください)
8. 「次へ」を選択
9. 全てを無視してページ下の「次へ」を選択
10. 再び全てを無視してページ下の「送信」を選択
11. 作成が完了していることを確認(可能であれば ssh 接続も試してみてください)

```bash
ssh -i ${キーペアのアドレス} ubuntu@${パブリックIPv4アドレス}

# 例
ssh -i ~/.ssh/AWS_key.pem ubuntu@13.158.9.179
```
