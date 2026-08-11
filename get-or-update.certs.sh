#!/bin/bash

# Webroot directory for Certbot challenges
WEBROOT="/var/www/certbot"

# Create webroot directory if it doesn't exist
sudo mkdir -p "$WEBROOT"
sudo chown -R www-data:www-data "$WEBROOT"  # Adjust user/group as needed for your system
sudo chmod -R 755 "$WEBROOT"

# Get all NGINX config files
CONFIG_FILES=$(find /etc/nginx/sites-available/ -name "*.odoo.conf" | grep -v "\.conf~")

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Iterate over each config file
for config_file in $CONFIG_FILES; do
    # Parse server_names from config file
    DOMAINS=$("$SCRIPT_DIR/parse_config.sh" "$config_file" | sort -u | grep -v "example.com")

    # Request certificates for all domains in the config file
    for domain in $DOMAINS; do
        # Check if a certificate already exists for the domain
        if sudo certbot certificates | grep -q "$domain"; then
            echo "Certificate already exists for $domain"
        else
            echo "Requesting certificate for $domain"
            if sudo certbot certonly --webroot -w "$WEBROOT" -d "$domain" --non-interactive --agree-tos -m demidoff@1vp.ru; then
                # Certificate request successful, create symlink
                echo "Certificate request successful for $domain"
                sudo ln -sf "$config_file" "/etc/nginx/sites-enabled/$(basename "$config_file")"
            else
                # Certificate request failed, remove symlink if it exists
                echo "Certificate request failed for $domain"
                if [ -L "/etc/nginx/sites-enabled/$(basename "$config_file")" ]; then
                    sudo rm "/etc/nginx/sites-enabled/$(basename "$config_file")"
                fi
            fi
        fi
    done
done

# Reload NGINX
echo "Reloading NGINX"
if sudo nginx -t && sudo systemctl reload nginx; then
    echo "NGINX reloaded successfully"
else
    echo "NGINX reload failed"
    exit 1
fi

exit 0
