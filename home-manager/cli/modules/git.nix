{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    delta
    git
    gh
    lazygit
    tea
    tig
  ];

  programs.git = {
    enable = true;
    userName  = "Mandy Schoep";
#    userEmail = "2277717+OhMyMndy@users.noreply.github.com";
  };

  home.file.".config/lazygit" = {
    source = ./../../../.config/lazygit;
  };

  home.file.".gitconfig-delta" = {
    source = ./../../../.gitconfig-delta;
  };

  home.activation.setupGit = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="$PATH:${config.home.path}/bin" #${pkgs.git}/bin:${pkgs.gh}/bin:${pkgs.jq}/bin"

    touch "$HOME/.gitconfig"
    git config --global include.path ".gitconfig-delta"
    git config --global init.defaultBranch main

    if gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user &>/dev/null; then
      user=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user | jq -r .name)
      # echo "Setting $user as the default Git user..."

      git config --global user.name "$user"

      # extensions can only be installed when we are logged in with gh
      gh extension install nektos/gh-act
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
