{
  config,
  lib,
  ...
}:
{
  # Install zeal flatpak
  home.activation.setupZeal = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # add path here so flatpak can access other binaries
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin"
    PATH+=":$HOME/.local/bin:$PATH"
    . "$HOME/.asdf/asdf.sh"

    if command -v /usr/bin/flatpak &>/dev/null; then
      /usr/bin/flatpak --user install flathub org.zealdocs.Zeal -y
    fi
    mkdir -p ~/.var/app/org.zealdocs.Zeal/config/Zeal
    mkdir -p ~/.var/app/org.zealdocs.Zeal/data/Zeal
    rm -rf ~/.config/Zeal ~/.local/share/Zeal
    ln -sf ~/.var/app/org.zealdocs.Zeal/config/Zeal ~/.config/Zeal
    ln -sf ~/.var/app/org.zealdocs.Zeal/data/Zeal ~/.local/share/Zeal

    pipx install zeal-feeds
    feeds="Alpinejs Beautiful_Soup Clang Cython glibc HAProxy jq Kubernetes "
    feeds="Linux_Man_Pages llm LLVM "
    feeds+="mypy json-schema Neovim Terraform Packer pytest QEMU Scrapy"

    zeal-feeds install $feeds

    python_version="$(asdf list all python | grep '^3.10' | tail -1)"
    asdf install python "$python_version"

    pipx install --python="$(asdf where python $python_version)/bin/python" git+https://github.com/Morpheus636/zeal-cli@main

    docsets="Bash CSS Dart Django Docker ElasticSearch Flask GLib Go "
    docsets+="Handlebars HTML Java JavaScript Jekyll Jinja jQuery Laravel Less Lua_5.4 "
    docsets+="Markdown MongoDB MySQL Nginx NumPy Pandas Perl PHP PHPUnit Polymer.dart "
    docsets+="PostgreSQL Puppet Python_3 Qt_5 Qt_6 React Ruby Ruby_2 Ruby_3 Rust "
    docsets+="SQLAlchemy SQLite Swift Symfony TypeScript Vagrant"

    # printf $docsets | tr ' ' '\0' | xargs -0 -I{} bash -c "zeal-cli install {}"
    new="$(echo "$docsets" | tr ' ' '\n' | tr '_' ' ')"
    installed="$(zeal-cli list | tr '_' ' ')"

    # TODO why does Qt 5 still show up?
    to_install=$(comm -13 <(echo "$installed" | sort) <(echo "$new" | sort))
    printf "$to_install" | tr '\n' '\0' | tr ' ' '_' | xargs -0 -I{} bash -c "zeal-cli install {}"
  '';
}
