# Wovn::ReverseProxy

Translation proxy by wovnrb.

## Installation

    $ gem install wovn-reverse_proxy
    $ wovnrp

## Usage

### Apache HTTP server

```
ProxyPass         / http://localhost:4567/
ProxyPassReverse  / http://localhost:4567/
ProxyPreserveHost on

RequestHeader set X_WOVN_HOST       http://localhost:3000
RequestHeader set X_WOVN_USER_TOKEN IRb6-
RequestHeader set X_WOVN_SECRET_KEY secret
```

### nginx

```
proxy_pass       http://localhost:4567;
proxy_set_header X-Forwarded-Host $host;

proxy_set_header X-Wovn-Host       http://localhost:3000;
proxy_set_header X-Wovn-User-Token IRb6-;
proxy_set_header X-Wovn-Secret-Key secret;
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/wovn-reverse_proxy.

