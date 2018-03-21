## Install Fedora 27

```
curl https://raw.githubusercontent.com/Mandy91/dotfiles/master/installers/kickstart/fedora27.ks > /tmp/kickstart.ks

sudo anaconda --kickstart /tmp/kickstart.ks

```

### Show post log
```
sudo chroot /mnt/sysimage bash -c "which tail 2>/dev/null >/dev/null && touch /home/mandy/post.log && tail -f /home/mandy/post.log"
```
