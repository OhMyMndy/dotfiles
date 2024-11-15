# see: https://juliu.is/tidying-your-home-with-nix/
{ pkgs, ... }:

# let
#   newTerraform = pkgs.terraform.overrideAttrs (old: {
#     #plugins = [];
#   });
# in
{
  home.packages = with pkgs; [
    awscli2
    azure-cli
    azure-storage-azcopy
    checkov
    google-cloud-sdk
    opentofu
    terraform
    tflint
    tfsec
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
