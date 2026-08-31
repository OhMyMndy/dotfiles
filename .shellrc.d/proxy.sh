px() {
  [[ $1 == off ]] && {
    unset {http,https,no}_proxy {HTTP,HTTPS,NO}_PROXY
    return
  }
  source ~/".config/proxies/$1.env"
  export HTTP_PROXY="$http_proxy" HTTPS_PROXY="$https_proxy" NO_PROXY="$no_proxy"
  export PROXY="$1"
}
