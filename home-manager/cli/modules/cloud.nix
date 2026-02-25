# see: https://juliu.is/tidying-your-home-with-nix/
{ pkgs, ... }:
# let
#   newTerraform = pkgs.terraform.overrideAttrs (old: {
#     #plugins = [];
#   });
# in
{
  home.packages = with pkgs; [
    #    awscli2
    #    azure-cli
    #    azure-storage-azcopy
    checkov
    google-cloud-sdk
    # SEE: https://search.nixos.org/packages?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=google-cloud
    # (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.google-cloud-workstations])
    # TODO: alias terraform to tofu
    #    opentofu
    pulumictl
    # SEE: https://github.com/pulumi/pulumi/issues/17003
    # SEE: https://github.com/NixOS/nixpkgs/issues/351955
    #    previous.pulumi
    # TODO: why is Terraform being built all the time?
    tenv # OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go
    #    unstable.terraform
    #    terragrunt
    tflint
    tfsec
  ];
  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "gcloud"
        "terraform"
      ];
    };
  };
}
