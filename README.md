# Certificate Management Scripts

This repository contains scripts for managing SSL certificates using Certbot and NGINX.

## Scripts

### parse_config.sh

This script extracts server names from NGINX configuration files. It is designed to work with HTTPS server blocks and can be used to identify all domains that need SSL certificates.

### get-or-update.certs.sh

This script automates the process of requesting and updating SSL certificates for all domains listed in NGINX configuration files. It uses the `parse_config.sh` script to extract domains and Certbot to request certificates.

## Usage

1. **parse_config.sh**: Run the script with one or more NGINX configuration files as arguments to extract server names.

    ```bash
    ./parse_config.sh /etc/nginx/sites-available/example.conf
    ```

2. **get-or-update.certs.sh**: Run the script to request and update SSL certificates for all domains listed in NGINX configuration files.

    ```bash
    ./get-or-update.certs.sh
    ```

## Requirements

- Certbot
- NGINX
- Bash

## License

This project is licensed under the MIT License - see the LICENSE file for details.
