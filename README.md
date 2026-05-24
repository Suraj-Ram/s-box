# s-box

A development sandbox that runs Ubuntu Server Noble VM on Apple Silicon using QEMU with a declarative cloud-init bootstrap script.

### Usage
1. Install `qemu`, `cdrtools` and `just` if you don't have them already. 
```
brew install qemu cdrtools just
```
2. Create the cloud-init seed ISO.
```
just create
```
3. Run the VM.
```
just boot
```
4. Wait for cloud-init to finish and then SSH into the VM
```
just ssh
``` 


TODO

- [ ] To get faster internet speeds in the VM, replace `netdev` with `-netdev vmnet-shared,id=net0 \` however this requires QEMU to run as root
- [ ] Parameterize the SSH key and username in `user-data`
