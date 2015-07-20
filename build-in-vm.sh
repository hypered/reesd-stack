#! /bin/bash

# Build the Docker images using kvm (with the https://github.com/noteed/vm
# image). This could also use docker-in-docker. This operates the VM using ssh.

set -e

function log {
  echo "$(date --iso-8601=seconds --utc) $1"
}

log "Preparing fresh virtual machine..."
VM_ID="1"
TAP="tap${VM_ID}"
MAC="DE:AD:BE:EF:9E:2${VM_ID}"

sudo tunctl -u `whoami` -t ${TAP}
sudo ip link set ${TAP} up
sleep 0.5s
sudo brctl addif br0 ${TAP}

SSH="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -A horde@vm-1"

sleep 1

kvm \
  -daemonize -vnc :02 -snapshot -no-reboot \
  -m 2048 \
  -device e1000,netdev=net0,mac=${MAC} \
  -netdev tap,id=net0,ifname=${TAP},script=no \
  -boot d ../../projects/vm/ubuntu-14.04.2-server-amd64.img

while [[ $(${SSH} true ; echo $?) -ne 0 ]] ; do
  sleep 1
done

log "Adding known GitHub hosts..."
cat <<END | ${SSH} dd of=/home/horde/.ssh/known_hosts
|1|p6Kww5VDPj72Kq+qQE0ACkpMRlk=|jSfUYXMqixyYjLpZmtkjrNGI5JQ= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|ovxQ7VpZPVjd7kA5AgJxHkUQt48=|CU8waeBCiuGmvTGTUTLaf57Xl/o= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|JHZ9H958i5Wn0Hb+2k3vL2jxmzg=|JG7y47WhwWlNO56j7SxPQcctY1g= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
END

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null build-images-helper.sh horde@vm-1:
${SSH} ./build-images-helper.sh

log "Copying images locally..."
mkdir -p new-images
${SSH} docker save images.reesd.com/reesd/stack:latest > reesd-stack-docker-image.tar

log "Stopping virtual machine..."
${SSH} sudo reboot

log "Compressing tarballs..."
xz reesd-stack-docker-image.tar

sudo brctl delif br0 ${TAP}
sudo tunctl -d ${TAP}
log "Done."
