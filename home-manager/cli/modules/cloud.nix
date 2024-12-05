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
    # SEE: https://search.nixos.org/packages?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=google-cloud
    # (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.google-cloud-workstations])
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
      ];
    };
  };
}
