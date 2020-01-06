#!/usr/bin/env python3

# See https://developer.gnome.org/pango/stable/PangoMarkupFormat.html for pango format
# See https://goodies.xfce.org/projects/panel-plugins/xfce4-genmon-plugin how to use xfce4-genmon-plugin

import sys
import json
import subprocess


def main():
    chosen_workspace = None

    if len(sys.argv) > 1:
        chosen_workspace = sys.argv[1]

    if chosen_workspace is None:
        return

    chosen_workspace_name = ""
    i3_result = subprocess.check_output("i3-msg -t get_workspaces", shell=True).decode('UTF-8').rstrip()
    i3_result = json.loads(i3_result)
    i3_result.sort(key=lambda x: x['num'], reverse=False)


    result_to_print = "<txt> <span font='Iosevka Nerd Font Mono 10'>"

    for workspace in i3_result:
        if (chosen_workspace in (workspace['num'], 'all')):
            name = workspace['name']
            urgent = workspace['urgent']
            focused = workspace['focused']
            visible = workspace['visible']
            chosen_workspace_name = name
        
            if urgent:
                result_to_print += "<span weight='Bold' fgcolor='#FB0120' bgcolor='black'> {} </span>".format(name)
            elif focused:
                result_to_print +="<span weight='Bold' fgcolor='#55EB3E' bgcolor='black'> {} </span>".format(name)
            elif visible:
                result_to_print +="<span weight='Bold' fgcolor='#24c5e8' bgcolor='black'> {} </span>".format(name)
            else:
                result_to_print += "<span fgcolor='#eaeaea' bgcolor='black'> {} </span>".format(name)

    if not chosen_workspace_name:
        print()
        return

    result_to_print = result_to_print.rstrip()
    result_to_print += "</span></txt>"
    if chosen_workspace != 'all':
        result_to_print += "<txtclick>i3-msg workspace {}</txtclick>".format(chosen_workspace_name)

    print(result_to_print)

if __name__== "__main__":
    main()
