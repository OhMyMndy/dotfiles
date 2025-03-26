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
    if [[ -d /run/systemd/system ]]; then
      systemctl --user enable --now steampipe
    fi

    plugins="ansible cloudflare config csv docker exec gcp github theapsgroup/gitlab grafana jira "
    plugins+="theapsgroup/keycloak kubernetes ldap linkedin net openapi prometheus steampipe "
    plugins+="tailscale terraform "

    installed=$(steampipe plugin list | tail -n +4 | sed 's#hub.steampipe.io/plugins/turbot/##' |  sed 's#hub.steampipe.io/plugins/##' |  sed 's/@latest//' | awk '{print $2}')
    new="$(echo "$plugins" | tr ' ' '\n' | tr '_' ' ')"
    to_install=$(comm -13 <(echo "$installed" | sort) <(echo "$new" | sort))

    if [[ "$to_install" != "" ]]; then
      # TODO: make sure that it waits for the service to be running
      ${pkgs.steampipe}/bin/steampipe plugin install $to_install || true
    fi
    # ${pkgs.steampipe}/bin/steampipe plugin update --all
  '';

  systemd.user.services."steampipe" = {
    Unit = {
      Description = "Steampipe Service";
    };
    Service = {
      ExecStart = "${pkgs.steampipe}/bin/steampipe service start --foreground";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
