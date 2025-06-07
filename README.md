# handson-verify-websv
ネットワーク系ハンズオンした時の動作確認用Webサーバー

- manual-setup.sh
  - srcの中身を参照して設定が入る。(git cloneして使う想定)

- fullauto-setup.sh
  - このスクリプトだけですべての設定が入る。(スクリプトだけコピペして使う想定)
  - srcの中身を関係なく実行。
　- ＊＊＊不具合あり。まだ使わないで。＊＊＊

- auto-script-generator.sh
  - fullauto-setup.shを作るスクリプト。
  - メンテナンス用。（実動作には影響しない）

```
.
├── manual-setup.sh
├── fullauto-setup.sh
└── src/
    ├── websv.conf
    ├── index.html
    ├── error.html
    └── auto-script-generator.sh
```

# TODO: 不具合修正
- fullauto-setup.sh
  - CR(^M)が入る。要修正
- websv.conf
  - エラーページにステータスコードが渡せず想定した表記にならない。