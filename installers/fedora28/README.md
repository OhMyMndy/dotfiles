# Install Fedora 28

```
curl https://raw.githubusercontent.com/Mandy91/dotfiles/master/installers/fedora28/fedora28.ks > /tmp/kickstart.ks

sudo anaconda --kickstart /tmp/kickstart.ks

```

## Show post log
```
sudo chroot /mnt/sysimage bash -c "which tail 2>/dev/null >/dev/null && touch /home/mandy/post.log && tail -f /home/mandy/post.log"
```


## Show all relevant logs

```
xfce4-terminal \
  -T Anaconda -H \
  -e 'bash -c "curl https://raw.githubusercontent.com/Mandy91/dotfiles/master/installers/fedora28/fedora28.ks > /tmp/kickstart.ks && sudo anaconda --kickstart /tmp/kickstart.ks"' \
  \
  --tab -T 'Anaconda log' -H \
  -e 'bash -c "while true; do tail -f /tmp/anaconda.log; sleep 10; done"' \
  \
  --tab -T 'Post log' -H \
  -e 'bash -c "while true; do sudo chroot /mnt/sysimage bash -c \"which tail 2>/dev/null >/dev/null && touch /home/mandy/post.log && tail -f /home/mandy/post.log\"; sleep 10;done"'
```


## Show all post installation

```
xfce4-terminal \
  -T ' Anaconda post installation logs' -H \
  -e 'bash -c "while true; do sudo chroot /mnt/sysimage bash -c \"which tail 2>/dev/null >/dev/null && touch /home/mandy/post.log && tail -f /home/mandy/post.log\"; sleep 10;done"'
```