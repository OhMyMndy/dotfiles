{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    delta
    git
    gitkraken
    gh
    lazygit
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

    # TODO: add two if statements and add how to fix it
    if ${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/emails >/dev/null; then
      user=$(${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user | ${pkgs.jq}/bin/jq -r .name)
      email=$(${pkgs.gh}/bin/gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user/emails | ${pkgs.jq}/bin/jq -r ".[1].email")
      echo "Setting $user <$email> as the default Git user..."

      ${pkgs.git}/bin/git config --global user.name "$user"
      ${pkgs.git}/bin/git config --global user.email "$email" 
    fi
  '';

}
