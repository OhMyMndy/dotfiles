
if [ -d ~/.shellrc.d ]; then
  for rc in ~/.shellrc.d/*; do
    if [ -f "$rc" ]; then
        # shellcheck disable=SC1090
        . "$rc"
    fi
  done
fi



if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			# shellcheck disable=SC1090
			. "$rc"
		fi
  done
fi