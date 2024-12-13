{
  pkgs,
  lib,
  home,
  ...
}: {
  home.packages = with pkgs; [
    steampipe
  ];

  home.activation.setupSteampipe = lib.hm.dag.entryAfter ["installPackages"] ''
    plugins="cloudflare config csv docker exec gcp github theapsgroup/gitlab grafana jira "
    plugins+="theapsgroup/keycloak kubernetes ldap linkedin net openapi prometheus steampipe "
    plugins+="tailscale terraform "
    ${pkgs.steampipe}/bin/steampipe plugin install $plugins
  '';
}
