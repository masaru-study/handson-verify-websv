#!/bin/bash
DEPLOY_DIR='/etc/nginx/conf.d/handson-test-html'
CONF_NAME='handson-test.conf'

apt update && apt install -y nginx
systemctl stop nginx

[ ! -d ${DEPLOY_DIR} ] && rm -rf ${DEPLOY_DIR}
mkdir -p ${DEPLOY_DIR}



cat << "EOF" > ${DEPLOY_DIR}/${CONF_NAME}
server {
    listen 80;
    server_name _;

    root /etc/nginx/conf.d/handson-test-html;
    index index.html;
    
    location / {
        # HTML内の各プレースホルダーを動的な値に置換
        sub_filter 'CL-ADDRESS' '$remote_addr';
        sub_filter 'SV-HOSTNAME' '$hostname';
        sub_filter 'SV-ADDRESS' '$server_addr';
        # 複数のsub_filterを有効にするためoffに設定
        sub_filter_once off;
    }

    # 400エラーテスト用のロケーション
    location = /test400 {
        return 400;
    }

    # 401エラーテスト用のロケーション
    location = /test401 {
        return 401;
    }

    # 403エラーテスト用のロケーション
    location = /test403 {
        return 403;
    }
    
    # 404エラーテスト用のロケーション
    location = /test404 {
        return 404;
    }

    # 500エラーテスト用のロケーション
    location = /test500 {
        return 500;
    }

    # 502エラーテスト用のロケーション
    location = /test502 {
        return 502;
    }

    # 503エラーテスト用のロケーション
    location = /test503 {
        return 503;
    }
    
    # 504エラーテスト用のロケーション
    location = /test504 {
        return 504;
    }

    # エラーページ設定
    error_page 400 401 403 404 /error_handler;
    error_page 500 502 503 504 /error_handler;

    # エラーハンドリング用の内部ロケーション
    location = /error_handler {
        internal;
        rewrite ^ /error.html?status=$status break;
    }
}
EOF

cat << "EOF" > ${DEPLOY_DIR}/index.html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>👍アクセス成功🎊</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; }
        .container { border: 1px solid #ccc; padding: 20px 40px; display: inline-block; border-radius: 8px; background-color: #f9f9f9;}
        h1 { color: #333; }
        .server-info { text-align: left; margin-top: 20px; }
        .server-info strong { color: #007bff; }
    </style>
</head>
<body>
    <div class="container">
        <h1>ハンズオンサーバー</h1>
        <hr>
        <div class="server-info">
            <p><strong>アクセス元クライアントIP:</strong> CL-ADDRESS</p>
            <p><strong>応答サーバーホスト名:</strong> SV-HOSTNAME</p>
            <p><strong>応答サーバーIPアドレス:</strong> SV-ADDRESS</p>
        </div>
    </div>
</body>
</html>
EOF

cat << "EOF" > ${DEPLOY_DIR}/error.html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>👎アクセス失敗⛔</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; color: #555; }
        .container { border: 1px solid #e74c3c; padding: 20px; display: inline-block; border-radius: 8px; background-color: #fbecec; }
        h1 { color: #c0392b; }
        #status-code { font-weight: bold; font-size: 1.2em; }
        #error-cause { margin-top: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>エラーが発生しました</h1>
        <p>ステータスコード: <span id="status-code"></span></p>
        <p id="error-cause"></p>
    </div>

    <script>
        // URLのクエリパラメータからステータスコードを取得
        const params = new URLSearchParams(window.location.search);
        const statusCode = params.get('status');
        
        const statusCodeElement = document.getElementById('status-code');
        const errorCauseElement = document.getElementById('error-cause');

        if (statusCode) {
            statusCodeElement.textContent = statusCode;
            const code = parseInt(statusCode, 10);

            // ステータスコードに応じて原因を自然言語で表示
            if (code >= 400 && code < 500) {
                errorCauseElement.textContent = 'お客様のリクエストに問題があるようです（クライアントエラー）。URLをご確認の上、再度お試しください。';
            } else if (code >= 500 && code < 600) {
                errorCauseElement.textContent = 'サーバー側で一時的な問題が発生しました（サーバーエラー）。時間をおいてから再度お試しください。';
            } else {
                errorCauseElement.textContent = '不明なエラーです。';
            }
        } else {
            statusCodeElement.textContent = 'N/A';
            errorCauseElement.textContent = 'ステータスコードが取得できませんでした。';
        }
    </script>
</body>
</html>
EOF



ln -s ${DEPLOY_DIR}/${CONF_NAME} /etc/nginx/conf.d/${CONF_NAME}
unlink /etc/nginx/sites-enabled/default
systemctl enable --now nginx
