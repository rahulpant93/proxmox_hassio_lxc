#!/usr/bin/env bash/

# Setup script environment
set -o errexit  #Exit immediately if a pipeline returns a non-zero status
set -o errtrace #Trap ERR from shell functions, command substitutions, and commands from subshell
set -o nounset  #Treat unset variables as an error
set -o pipefail #Pipe will exit with last non-zero status if applicable
shopt -s expand_aliases
alias die='EXIT=$? LINE=$LINENO error_exit'
trap die ERR
trap cleanup EXIT

function error_exit() {
  trap - ERR
  local DEFAULT='Unknown failure occured.'
  local REASON="\e[97m${1:-$DEFAULT}\e[39m"
  local FLAG="\e[91m[ERROR] \e[93m$EXIT@$LINE"
  msg "$FLAG $REASON"
  [ ! -z ${CTID-} ] && cleanup_ctid
  exit $EXIT
}
function warn() {
  local REASON="\e[97m$1\e[39m"
  local FLAG="\e[93m[WARNING]\e[39m"
  msg "$FLAG $REASON"
}
function info() {
  local REASON="$1"
  local FLAG="\e[36m[INFO]\e[39m"
  msg "$FLAG $REASON"
}
function msg() {
  local TEXT="$1"
  echo -e "$TEXT"
}
function cleanup_ctid() {
  if $(pct status $CTID &>/dev/null); then
    if [ "$(pct status $CTID | awk '{print $2}')" == "running" ]; then
      pct stop $CTID
    fi
    pct destroy $CTID
  elif [ "$(pvesm list $STORAGE --vmid $CTID)" != "" ]; then
    pvesm free $ROOTFS
  fi
}
function cleanup() {
  popd >/dev/null
  rm -rf $TEMP_DIR
}
TEMP_DIR=$(mktemp -d)
pushd $TEMP_DIR >/dev/null

# Create LXC
export CTID=$(pvesh get /cluster/nextid)
export PCT_OSTYPE=debian
export PCT_OSVERSION=12
#export PCT_OSTYPE=ubuntu
#export PCT_OSVERSION=23.04
export PCT_DISK_SIZE=64
export PCT_OPTIONS="
  -cmode shell
  -features nesting=1
  -hostname homeassistant
  -net0 name=eth0,bridge=vmbr0,hwaddr=BC:24:11:AB:B0:47,firewall=0,ip=dhcp,type=veth
  -nameserver 192.168.29.1
  -searchdomain home.arpa
  -onboot 1
  -tags homeassistant
"
bash -c "$(wget -qLO - https://github.com/rahulpant93/proxmox_lxc_create/raw/main/lxc_create.sh)" || exit

# Detect storage pool type
STORAGE_TYPE=$(pvesm status -storage $(pct config $CTID | grep rootfs | awk -F ":" '{print $2}') | awk 'NR>1 {print $2}')
if [ "$STORAGE_TYPE" == "zfspool" ]; then
  warn "Some addons may not work due to ZFS not supporting 'fallocate'."
fi

# Download setup script
REPO="https://github.com/rahulpant93/proxmox_hassio_lxc"
wget -qO - ${REPO}/tarball/master | tar -xz --strip-components=1

# Modify LXC permissions to support Docker
LXC_CONFIG=/etc/pve/lxc/${CTID}.conf
cat <<EOF >> $LXC_CONFIG
lxc.cgroup.devices.allow: a
lxc.cgroup2.devices.allow: a
lxc.cap.drop:
EOF

# Load modules for Docker before starting LXC
cat << 'EOF' >> $LXC_CONFIG
lxc.hook.pre-start: sh -ec 'for module in overlay; do modinfo $module; $(lsmod | grep -Fq $module) || modprobe $module; done;'
EOF

# Set autodev hook to enable access to devices in container
bash ./set_autodev_hook.sh $CTID

# Set container timezone to match host
cat << 'EOF' >> $LXC_CONFIG
lxc.hook.mount: sh -c 'ln -fs $(readlink /etc/localtime) ${LXC_ROOTFS_MOUNT}/etc/localtime'
EOF

# Setup container for Home Assistant
msg "Starting LXC container..."
pct start $CTID

### Begin LXC commands ###
alias lxc-cmd="lxc-attach -n $CTID --"
# Prepare container OS
msg "Setting up container OS..."
lxc-cmd dhclient -4
lxc-cmd sed -i "/$LANG/ s/\(^# \)//" /etc/locale.gen
lxc-cmd locale-gen >/dev/null
lxc-cmd apt-get -y purge openssh-{client,server} >/dev/null

# Update container OS
msg "Updating container OS..."
lxc-cmd apt-get update --allow-releaseinfo-change >/dev/null
lxc-cmd apt-get -qqy upgrade &>/dev/null

# Install prerequisites
msg "Installing prerequisites..."
lxc-cmd apt-get -qqy install \
    avahi-daemon curl jq network-manager xterm &>/dev/null

# Install Docker
msg "Installing Docker..."
lxc-cmd sh <(curl -sSL https://get.docker.com) &>/dev/null

# Configure Docker configuration
msg "Configuring Docker..."
DOCKER_CONFIG_PATH='/etc/docker/daemon.json'
HA_URL_BASE=https://raw.githubusercontent.com/home-assistant/supervised-installer/main/homeassistant-supervised
lxc-cmd mkdir -p $(dirname $DOCKER_CONFIG_PATH)
lxc-cmd wget -qLO $DOCKER_CONFIG_PATH ${HA_URL_BASE}/etc/docker/daemon.json
lxc-cmd systemctl restart docker

# Configure NetworkManager
msg "Configuring NetworkManager..."

NETWORKMANAGER_CONFIG_PATH='/etc/NetworkManager/NetworkManager.conf'
lxc-cmd wget -qLO $NETWORKMANAGER_CONFIG_PATH ${HA_URL_BASE}/etc/NetworkManager/NetworkManager.conf
msg "Configuring NetworkManager... 2"

lxc-cmd sed -i 's/type\:veth/interface-name\:veth\*/' $NETWORKMANAGER_CONFIG_PATH
msg "Configuring NetworkManager... 3"
#### read

NETWORKMANAGER_PROFILE_PATH='/etc/NetworkManager/system-connections/default'
lxc-cmd wget -qLO $NETWORKMANAGER_PROFILE_PATH https://github.com/rahulpant93/proxmox_hassio_lxc/raw/master/system-connection-default
msg "Configuring NetworkManager... 5"
#### read

lxc-cmd chmod 600 $NETWORKMANAGER_PROFILE_PATH
msg "Configuring NetworkManager... 6 $NETWORKMANAGER_PROFILE_PATH"
#### read

#NETWORKMANAGER_CONNECTION=$(lxc-cmd nmcli connection | grep eth0 | awk -F "  " '{print $1}')
#msg "Configuring NetworkManager... 7 $NETWORKMANAGER_CONNECTION"
#lxc-cmd nmcli connection down "$NETWORKMANAGER_CONNECTION" > /dev/null
#msg "Configuring NetworkManager... 8"
#lxc-cmd nmcli connection delete "$NETWORKMANAGER_CONNECTION" > /dev/null
#msg "Configuring NetworkManager... 9"

#lxc-cmd dhclient -r &> /dev/null
#msg "Configuring NetworkManager... 10"

lxc-cmd systemctl restart NetworkManager
msg "Configuring NetworkManager... 11"
#lxc-cmd nm-online -q
#### read
lxc-cmd nm-online
msg "Configuring NetworkManager... 12"

# Create Home Assistant config
msg "Creating Home Assistant config..."
HASSIO_CONFIG_PATH=/etc/hassio.json
HASSIO_DOCKER=ghcr.io/home-assistant/amd64-hassio-supervisor
HASSIO_MACHINE=qemux86-64
HASSIO_DATA_PATH=/usr/share/hassio
lxc-cmd bash -c "cat > $HASSIO_CONFIG_PATH <<- EOF
{
    \"supervisor\": \"${HASSIO_DOCKER}\",
    \"machine\": \"${HASSIO_MACHINE}\",
    \"data\": \"${HASSIO_DATA_PATH}\"
}
EOF
"

# Pull Home Assistant Supervisor image
msg "Downloading Home Assistant Supervisor container..."
HASSIO_VERSION=$(lxc-cmd bash -c "curl -s https://version.home-assistant.io/stable.json | jq -r '.supervisor' || echo 'latest'")
lxc-cmd docker pull "$HASSIO_DOCKER:$HASSIO_VERSION" > /dev/null
lxc-cmd docker tag "$HASSIO_DOCKER:$HASSIO_VERSION" "$HASSIO_DOCKER:latest" > /dev/null

# Install Home Assistant Supervisor
msg "Installing Home Assistant Supervisor..."
HASSIO_SUPERVISOR_PATH=/usr/sbin/hassio-supervisor
HASSIO_SUPERVISOR_SERVICE=/etc/systemd/system/hassio-supervisor.service
echo lxc-cmd wget -qLO $HASSIO_SUPERVISOR_PATH ${HA_URL_BASE}/usr/sbin/hassio-supervisor
echo lxc-cmd chmod a+x $HASSIO_SUPERVISOR_PATH
echo lxc-cmd wget -qLO $HASSIO_SUPERVISOR_SERVICE ${HA_URL_BASE}/etc/systemd/system/hassio-supervisor.service
msg "Installing Home Assistant Supervisor... 1"

lxc-cmd wget -qLO $HASSIO_SUPERVISOR_PATH ${HA_URL_BASE}/usr/sbin/hassio-supervisor
msg "Installing Home Assistant Supervisor... 2"

lxc-cmd chmod a+x $HASSIO_SUPERVISOR_PATH
msg "Installing Home Assistant Supervisor... 3"

lxc-cmd wget -qLO $HASSIO_SUPERVISOR_SERVICE ${HA_URL_BASE}/etc/systemd/system/hassio-supervisor.service
msg "Installing Home Assistant Supervisor... 4"

lxc-cmd sed -i "s,%%HASSIO_CONFIG%%,${HASSIO_CONFIG_PATH},g" $HASSIO_SUPERVISOR_PATH
lxc-cmd sed -i -e "s,%%BINARY_DOCKER%%,/usr/bin/docker,g" \
  -e "s,%%SERVICE_DOCKER%%,docker.service,g" \
  -e "s,%%BINARY_HASSIO%%,${HASSIO_SUPERVISOR_PATH},g" \
  $HASSIO_SUPERVISOR_SERVICE
msg "Installing Home Assistant Supervisor... 5"

lxc-cmd systemctl enable hassio-supervisor.service > /dev/null 2>&1
msg "Installing Home Assistant Supervisor... 6"

# Create service to fix Home Assistant boot time check
msg "Creating service to fix boot time check..."
pct push $CTID hassio-fix-btime.service /etc/systemd/system/hassio-fix-btime.service
lxc-cmd mkdir -p ${HASSIO_SUPERVISOR_SERVICE}.wants
lxc-cmd ln -s /etc/systemd/system/{hassio-fix-btime.service,hassio-supervisor.service.wants/}

# Start Home Assistant Supervisor
msg "Starting Home Assistant..."
lxc-cmd systemctl start hassio-supervisor.service

# Install 'ha' cli
msg "Installing the 'ha' cli..."
echo lxc-cmd wget -qLO /usr/bin/ha ${HA_URL_BASE}/usr/bin/ha
echo lxc-cmd chmod a+x /usr/bin/ha
lxc-cmd wget -qLO /usr/bin/ha ${HA_URL_BASE}/usr/bin/ha
lxc-cmd chmod a+x /usr/bin/ha

# Setup 'ha' cli prompt
msg "Configuring 'ha' cli prompt..."
HA_CLI_PATH=/usr/sbin/hassio-cli
lxc-cmd wget -qLO $HA_CLI_PATH https://github.com/home-assistant/operating-system/raw/dev/buildroot-external/rootfs-overlay/usr/sbin/hassos-cli
lxc-cmd sed -i 's,/bin/ash,/bin/bash,g' $HA_CLI_PATH
lxc-cmd sed -i '/# Run CLI container/,/^fi/d' $HA_CLI_PATH
lxc-cmd sed -i 's,^\(mesg n.*\)$,# \1,' /root/.profile
lxc-cmd chmod a+x $HA_CLI_PATH
lxc-cmd usermod --shell $HA_CLI_PATH root
lxc-cmd bash -c "echo -e '\ncd $HASSIO_DATA_PATH' >> /root/.bashrc"
lxc-cmd bash -c "mkdir -p /usr/share/hassio"
lxc-cmd bash -c "touch /usr/share/hassio/supervisor-version"

# Cleanup container
msg "Cleanup..."
lxc-cmd apt-get autoremove >/dev/null
lxc-cmd apt-get autoclean >/dev/null
lxc-cmd rm -rf /var/{cache,log}/* /var/lib/apt/lists/*
### Finish LXC commands ###

# Get network details and show completion message
IP=$(pct exec $CTID ip a s dev eth0 | sed -n '/inet / s/\// /p' | awk '{print $2}')

# Show completion message
info "Successfully created Home Assistant LXC to $CTID."
msg "

Home Assistant is reachable by going to the following URLs.

      http://${IP}:8123
      http://${HOSTNAME}.local:8123

"
