#!/bin/bash

sudo apt update && sudo apt install -y nginx

mkdir -p ~/www/webpage/
cat > ~/www/webpage/index.html << EOF
<html lang="">
  <!-- Text between angle brackets is an HTML tag and is not displayed.
        Most tags, such as the HTML and /HTML tags that surround the contents of
        a page, come in pairs; some tags, like HR, for a horizontal rule, stand
        alone. Comments, such as the text you're reading, are not displayed when
        the Web page is shown. The information between the HEAD and /HEAD tags is
        not displayed. The information between the BODY and /BODY tags is displayed.-->
  <head>
    <title>Enter a title, displayed at the top of the window.</title>
  </head>
  <!-- The information between the BODY and /BODY tags is displayed.-->
  <body>
    <h1>Enter the main heading, usually the same as the title.</h1>
    <p>Be <b>bold</b> in stating your key points. Put them in a list:</p>
    <ul>
      <li>The first item in your list</li>
      <li>The second item; <i>italicize</i> key words</li>
    </ul>
    <p>Improve your image by including an image.</p>
    <p>
      <img src="https://i.imgur.com/SEBww.jpg" alt="A Great HTML Resource" />
    </p>
    <p>
      Add a link to your favorite
      <a href="https://www.dummies.com/">Web site</a>. Break up your page
      with a horizontal rule or two.
    </p>
    <hr />
    <p>
      Finally, link to <a href="page2.html">another page</a> in your own Web
      site.
    </p>
    <!-- And add a copyright notice.-->
    <p>&#169; Wiley Publishing, 2011</p>
  </body>
</html>
EOF

chmod -R a+r .
sudo nano /etc/nginx/nginx.conf
sudo nano /etc/nginx/sites-enabled/default
        # server {
        #         listen 80;
        #         server_name oslab.fun;
        #         root /home/public/www/webpage;
        #         index index.html;
        # }
sudo systemctl reload nginx

wget -O -  https://get.acme.sh | sh
. .bashrc
acme.sh --upgrade --auto-upgrade
acme.sh --set-default-ca --server letsencrypt
acme.sh --issue -d oslab.fun -w /home/public/www/webpage --keylength ec-256 --force

wget https://github.com/XTLS/Xray-install/raw/main/install-release.sh
sudo bash install-release.sh
rm ~/install-release.sh

mkdir ~/xray_cert
acme.sh --install-cert -d oslab.fun --ecc \
            --fullchain-file ~/xray_cert/xray.crt \
            --key-file ~/xray_cert/xray.key
chmod +r ~/xray_cert/xray.key

cat > ~/xray_cert/xray-cert-renew.sh << EOF
#!/bin/bash

/home/public/.acme.sh/acme.sh --install-cert -d oslab.fun --ecc --fullchain-file /home/public/xray_cert/xray.crt --key-file /home/public/xray_cert/xray.key
echo "Xray Certificates Renewed"

chmod +r /home/public/xray_cert/xray.key
echo "Read Permission Granted for Private Key"

sudo systemctl restart xray
echo "Xray Restarted"
EOF
chmod +x ~/xray_cert/xray-cert-renew.sh
crontab -l > conf && echo "0 1 1 * *   bash /home/public/xray_cert/xray-cert-renew.sh" >> conf && crontab conf && rm -f conf

xray uuid
mkdir ~/xray_log
touch ~/xray_log/access.log && touch ~/xray_log/error.log
chmod a+w ~/xray_log/*.log
sudo nano /etc/systemd/system/xray.service
sudo nano /usr/local/etc/xray/config.json
sudo systemctl start xray
sudo systemctl status xray