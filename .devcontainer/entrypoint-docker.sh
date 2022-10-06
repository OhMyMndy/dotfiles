#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# @see https://github.com/microsoft/vscode-dev-containers/blob/main/containers/docker-in-docker/.devcontainer/library-scripts/docker-in-docker-debian.sh for the original source

sudo pkill dockerd
set -e

dockerd_start="$(cat << 'INNEREOF'
    # explicitly remove dockerd and containerd PID file to ensure that it can start properly if it was stopped uncleanly
    # ie: docker kill <ID>
    find /run /var/run -iname 'docker*.pid' -delete || :
    find /run /var/run -iname 'container*.pid' -delete || :
    ## Dind wrapper script from docker team, adapted to a function
    # Maintained: https://github.com/moby/moby/blob/master/hack/dind
    export container=docker
    if [ -d /sys/kernel/security ] && ! mountpoint -q /sys/kernel/security; then
        mount -t securityfs none /sys/kernel/security || {
            echo >&2 'Could not mount /sys/kernel/security.'
            echo >&2 'AppArmor detection and --privileged mode might break.'
        }
    fi
    # Mount /tmp (conditionally)
    if ! mountpoint -q /tmp; then
        mount -t tmpfs none /tmp
    fi
    # cgroup v2: enable nesting
    if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
        # move the processes from the root group to the /init group,
        # otherwise writing subtree_control fails with EBUSY.
        # An error during moving non-existent process (i.e., "cat") is ignored.
        mkdir -p /sys/fs/cgroup/init
        xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs || :
        # enable controllers
        sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
            > /sys/fs/cgroup/cgroup.subtree_control
    fi
    ## Dind wrapper over.
    # Handle DNS
    CUSTOMDNS=""
    set -e
    # Start docker/moby engine
    ( dockerd $CUSTOMDNS > /tmp/dockerd.log 2>&1 ) &
INNEREOF
)"
# Start using sudo if not invoked as root
if [ "$(id -u)" -ne 0 ]; then
    sudo /bin/sh -c "${dockerd_start}"
else
    eval "${dockerd_start}"
fi
set +e
# Execute whatever commands were passed in (if any). This allows us
# to set this script to ENTRYPOINT while still executing the default CMD.
exec "$@"