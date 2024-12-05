{lib, ...}: {
  home.activation.recollConfig = lib.hm.dag.entryAfter ["installPackages"] ''
    if [[ ! -f ~/.recoll/recoll.conf ]]; then
      mkdir -p ~/.recoll
      cat <<EOF | tee ~/.recoll/recoll.conf
    skippedPaths = /media/ /tmp $HOME/.firefox-history/hts-cache $HOME/.nodenv $HOME/.rbenv $HOME/.pub-cache $HOME/.dartServer $HOME/.npm $HOME/.asdf $HOME/.cache $HOME/.local/share/containers
    aspellLanguage = en
    skippedNames = #* *~ caughtspam tmp loop.ps \
        Cache cache* .cache .ccls-cache .thumbnails \
        .beagle CVS .svn .git .hg .bzr .xsession-errors \
        *.pyc __pycache__ .pytest_cache .tox .direnv \
        .recoll* xapiandb recollrc recoll.conf recoll.ini *.rclwe
    noContentSuffixes = .md5 .map \
        .o .lib .dll .a .sys .exe .com \
        .mpp .mpt .vsd .sqlite \
        .img .img.gz .img.bz2 .img.xz .image .image.gz .image.bz2 .image.xz .ttf \
        .dat .bak .rdf .log.gz .log .db .msf .pid \
        ,v ~ #

    compressedfilemaxkbs = 100000
    EOF
    fi
  '';
}
