_px() {
  local -a profiles
  local f
  for f in ~/.config/proxies/*.env(N); do
    # name:description — only the first colon splits, so URLs are safe
    profiles+=( "${f:t:r}:$(sed -n 's|^export http_proxy=||p' $f)" )
  done
  profiles+=( 'off:unset all proxy vars' )
  _describe 'proxy profile' profiles
}
compdef _px px
