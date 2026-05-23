brew install qemu cdrtools

curl -LO https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img



mkisofs -output seed.iso -volid cidata -joliet -rock \
  user-data.yml meta-data.yml



qemu-system-aarch64 \
  -machine virt,accel=hvf \
  -cpu host \
  -smp 4 \
  -m 8G \
  -bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd \
  -drive if=virtio,file=sbox-dev.qcow2,format=qcow2 \
  -drive if=virtio,file=seed.iso,format=raw \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -nographic

TODO

To get faster internet speeds in the VM, replace `netdev` with `-netdev vmnet-shared,id=net0 \` however this requires QEMU to run as root.
