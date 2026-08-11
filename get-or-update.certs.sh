#!/bin/bash

# Webroot directory for Certbot challenges
WEBROOT="/var/www/certbot"

# Create webroot directory if it doesn't exist
sudo mkdir -p "$WEBROOT"
sudo chown -R www-data:www-data $WEBROOT  # Adjust user/group as needed
sudo chmod -R 755 $WEBROOT

# Extract domains from NGINX configs
DOMAINS=$(grep -h "server_name" /etc/nginx/sites-enabled/*.conf | grep -v "\.conf~" | awk '{print $2}' | tr ';' ' ' | xargs -n1 | sort -u | grep -v "_")

# Request certificates for all domains
for domain in $DOMAINS; do
    if [[ "$domain" == *"example.com"* ]]; then
        # echo "⏭️ Skipping $domain (contains 'example.com')"
        continue
    fi
    echo $domain
    sudo certbot certonly --webroot -w $WEBROOT -d $domain --non-interactive --agree-tos -m demidoff@1vp.ru
done

# Reload NGINX
# sudo nginx -t && sudo systemctl reload nginx
