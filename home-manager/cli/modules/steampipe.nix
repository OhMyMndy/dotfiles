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
    # if [[ -d /run/systemd/system ]]; then
    #  systemctl --user enable --now steampipe
    # fi

    plugins="turbot/ansible turbot/cloudflare turbot/config turbot/csv turbot/docker turbot/exec turbot/gcp turbot/github theapsgroup/gitlab turbot/grafana turbot/jira "
    plugins+="theapsgroup/keycloak turbot/kubernetes turbot/ldap turbot/linkedin turbot/net turbot/openapi turbot/prometheus turbot/steampipe "
    plugins+="turbot/terraform "

    installed=$(steampipe plugin list --output json | jq '.installed[].name, .failed[].name' -r | sort | uniq | sed -E 's#(.*)/(.*)/(.*)@(.*)#\2/\3#g')
    new="$(echo "$plugins" | tr ' ' '\n' | tr '_' ' ')"
    to_install=$(comm -13 <(echo "$installed" | sort) <(echo "$new" | sort))

    # if [[ "$to_install" != "" ]]; then
    #   # TODO: make sure that it waits for the service to be running
    #   ${pkgs.steampipe}/bin/steampipe plugin install $to_install || true
    # fi
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
