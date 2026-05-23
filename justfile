vm_name    := "sbox-dev"
base_img   := "noble-server-cloudimg-arm64.img"
disk       := vm_name + ".qcow2"
disk_size  := "10G"
cpus       := "4"
mem        := "8G"
ssh_port   := "2222"
bios       := "/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
image_url  := "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img"

# list available commands
default:
    @just --list

# download the base cloud image
fetch:
    #!/usr/bin/env bash
    if [ ! -f {{ base_img }} ]; then
        curl -LO {{ image_url }}
    else
        echo "Base image already exists, skipping download"
    fi

# build the seed ISO from cloud-init configs
seed:
    mkisofs -output seed.iso -volid cidata -joliet -rock user-data meta-data

# create a fresh working disk + seed ISO
create: fetch seed
    cp {{ base_img }} {{ disk }}
    qemu-img resize {{ disk }} {{ disk_size }}

# boot the VM (blocks this terminal)
boot:
    qemu-system-aarch64 \
      -machine virt,accel=hvf \
      -cpu host -smp {{ cpus }} -m {{ mem }} \
      -bios {{ bios }} \
      -drive if=virtio,file={{ disk }},format=qcow2 \
      -drive if=virtio,file=seed.iso,format=raw \
      -device virtio-net-pci,netdev=net0 \
      -netdev user,id=net0,hostfwd=tcp::{{ ssh_port }}-:22 \
      -nographic

# SSH into the running VM
ssh:
    ssh -p {{ ssh_port }} suraj@localhost

# delete working disk and seed ISO
destroy:
    rm -f {{ disk }} seed.iso

# nuke and rebuild from scratch
rebuild: destroy create
