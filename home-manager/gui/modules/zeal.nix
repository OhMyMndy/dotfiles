{ config, lib, ... }:
{
  # Install zeal flatpak
  home.activation.setupZeal = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # add path here so flatpak can access other binaries
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin"
    PATH+=":$HOME/.local/bin:$PATH"


    if command -v /usr/bin/flatpak &>/dev/null; then
      /usr/bin/flatpak --user --noninteractive install flathub org.zealdocs.Zeal -y >/dev/null
    fi
    mkdir -p ~/.var/app/org.zealdocs.Zeal/config/Zeal
    mkdir -p ~/.var/app/org.zealdocs.Zeal/data/Zeal
    rm -rf ~/.config/Zeal ~/.local/share/Zeal
    ln -sf ~/.var/app/org.zealdocs.Zeal/config/Zeal ~/.config/Zeal
    ln -sf ~/.var/app/org.zealdocs.Zeal/data/Zeal ~/.local/share/Zeal

    if [[ ! -f ~/.config/Zeal/Zeal.conf ]]; then
      mkdir -p ~/.config/Zeal
      cp .config/Zeal/Zeal.conf ~/.config/Zeal
    fi
    pipx install -q zeal-feeds >/dev/null

    python_version="$(asdf list all python | grep '^3.10' | tail -1)"
    asdf install python "$python_version" >/dev/null

    pipx install -q --python="$(asdf where python $python_version)/bin/python" git+https://github.com/Morpheus636/zeal-cli@main >/dev/null

    feeds="Alpinejs Beautiful_Soup Clang Cython glibc HAProxy jq Kubernetes "
    feeds="Linux_Man_Pages llm LLVM "
    feeds+="mypy json-schema Neovim Terraform Packer pytest QEMU Scrapy"

    installed="$(zeal-cli list)"

    new="$(echo "$feeds")"

    to_install=$(comm -13 <(echo "$installed" | sort) <(echo "$new" | sort))
    if [[ "$to_install" != "" ]]; then
      zeal-feeds install $to_install
    fi


    docsets="Bash CSS Dart Django Docker ElasticSearch Flask GLib Go "
    docsets+="Handlebars HTML Java JavaScript Jekyll Jinja jQuery Laravel Less Lua_5.4 "
    docsets+="Markdown MongoDB MySQL Nginx NumPy Pandas Perl PHP PHPUnit Polymer.dart "
    docsets+="PostgreSQL Puppet Python_3 Qt Qt_6 React Ruby Ruby_3 Rust "
    docsets+="SQLAlchemy SQLite Swift Symfony TypeScript Vagrant"

    new="$(echo "$docsets" | tr ' ' '\n')"
    installed="$(zeal-cli list)"


    to_install=$(comm -13 <(echo "$installed" | sort) <(echo "$new" | sort))
    printf "$to_install" | tr '\n' '\0' | tr ' ' '_' | xargs -0 -I{} bash -c "zeal-cli install {}"

  '';
}
