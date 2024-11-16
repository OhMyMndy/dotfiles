{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    delta
    git
    gitkraken
    gh
    lazygit
    tea
    tig
  ];

  programs.git = {
    enable = true;
  };

  home.file.".config/lazygit" = {
    source = ./../../../.config/lazygit;
  };

  home.file.".gitconfig-delta" = {
    source = ./../../../.gitconfig-delta;
  };

  home.activation.setupGit = lib.hm.dag.entryAfter [ "installPackages" ] ''
    (cd "$HOME"
    touch ".gitconfig"
    ${pkgs.git}/bin/git config --global include.path ".gitconfig-delta")
    ${pkgs.git}/bin/git config --global init.defaultBranch main

    if ${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user >/dev/null; then
      user=$(${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user | ${pkgs.jq}/bin/jq -r .name)
      echo "Setting $user as the default Git user..."

      ${pkgs.git}/bin/git config --global user.name "$user"
    fi
    if ${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/emails >/dev/null; then
      email=$(${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/emails | ${pkgs.jq}/bin/jq -r ".[1].email")
      echo "Setting <$email> as the default Git user..."

      ${pkgs.git}/bin/git config --global user.email "$email" 
    else
      echo "No email found for the default Git user."
      echo "run: 'gh auth refresh -h github.com -s user' to refresh the token" 
    fi
  '';

}
