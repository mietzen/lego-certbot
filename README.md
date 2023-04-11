# Lego-Certbot

# Certbot alternative based on the amazing [LEGO](https://github.com/go-acme/lego).

## Usage

Cloudflare example: 

```yaml
version: "3"
services:
  cloudflare-lego-certbot:
    image: mietzen/lego-certbot:v4.10
    restart: always
    environment:
      - CLOUDFLARE_DNS_API_TOKEN=YOUR_TOKEN
      - EMAIL='your@mail.com'
      - DNS_PROVIDER=cloudflare
      - DOMAINS='your.domain.com,your2nd.domain.com'
    # dns=1.1.1.1 # Optional 
    volumes:
      - certs:/data

  nginx:
    image: nginx:1-slim
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl.conf:/etc/nginx/ssl.conf:ro
      - ./nginx/proxy.conf:/etc/nginx/proxy.conf:ro
      - ./nginx/dhparams.pem:/etc/nginx/dhparams.pem:ro
      - certs:/etc/ssl
    command: "/bin/sh -c 'while :; do sleep 12h & wait $${!}; nginx -s reload; echo 'reloading config'; done & nginx -g \"daemon off;\"'"
    restart: unless-stopped
    networks:
      - nginx

networks:
  nginx:
    external: true

volumes:
  certs:
```

For other DNS Providers see: [LEGO DNS PROVIDERS](https://go-acme.github.io/lego/dns/)
And set the needed environment variables.

