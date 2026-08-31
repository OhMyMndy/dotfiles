{
  pkgs,
  lib,
  config,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    delta
    git
    glab
    gh
    ghq
    lazygit
    mergiraf
    tea
    tig
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Mandy Schoep";
      };
    };
    #    userEmail = "2277717+OhMyMndy@users.noreply.github.com";
  };

  home.file.".config/lazygit".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/lazygit";

  home.file.".config/git/gitconfig-delta".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/git/gitconfig-delta";

  home.file.".config/git/gitattributes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/git/gitattributes";

  home.file.".config/git/gitignore".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/git/gitignore";

  home.activation.setupGit = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="$PATH:${config.home.path}/bin" #${pkgs.git}/bin:${pkgs.gh}/bin:${pkgs.jq}/bin"
    touch "$HOME/.gitconfig"
    git config --global ghq.root ~/src
    git config --global include.path "~/.config/git/gitconfig-delta"
    git config --global init.defaultBranch main
    git config --global core.excludesFile "~/.config/git/gitignore"
    git config --global core.attributesfile "~/.config/git/gitattributes"

    if gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user &>/dev/null; then
      user=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user | jq -r .name)
      # echo "Setting $user as the default Git user..."

      git config --global user.name "$user"

      # extensions can only be installed when we are logged in with gh
      gh extension list | grep nektos/gh-act >/dev/null || gh extension install nektos/gh-act
    fi

    if gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/emails &>/dev/null; then
      email=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/emails | jq -r ".[1].email")
      # echo "Setting <$email> as the default Git user..."

      git config --global user.email "$email"
    else
      echo "No email found for the default Git user."
      echo "run: 'gh auth refresh -h github.com -s user' to refresh the token"
    fi

  '';
}
