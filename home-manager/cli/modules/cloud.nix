# see: https://juliu.is/tidying-your-home-with-nix/
{pkgs, ...}:
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
    # TODO: alias terraform to tofu
    opentofu
    # TODO: why is Terraform being built all the time?
    # terraform
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
