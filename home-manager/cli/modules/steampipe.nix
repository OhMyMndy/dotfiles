{
  pkgs,
  lib,
  home,
  ...
}:
{
  home.packages = with pkgs; [ steampipe ];

  #TODO:check manually for installation of plugins, the steampipe plugins install is slow
  # when the plugins are installed
  home.activation.setupSteampipe = lib.hm.dag.entryAfter [ "installPackages" ] ''
    plugins="cloudflare config csv docker exec gcp github theapsgroup/gitlab grafana jira "
    plugins+="theapsgroup/keycloak kubernetes ldap linkedin net openapi prometheus steampipe "
    plugins+="tailscale terraform "
    ${pkgs.steampipe}/bin/steampipe plugin install $plugins
    # ${pkgs.steampipe}/bin/steampipe plugin update --all
  '';
}
