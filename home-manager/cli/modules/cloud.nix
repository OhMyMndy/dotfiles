# see: https://juliu.is/tidying-your-home-with-nix/
{ pkgs, ... }:

# let
#   newTerraform = pkgs.terraform.overrideAttrs (old: {
#     #plugins = [];
#   });
# in
{
  home.packages = with pkgs; [
    google-cloud-sdk
    terraform
    opentofu
  ];
  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "gcloud"
        "terraform"
        # "opentofu"
      ];
    };
  };
}
