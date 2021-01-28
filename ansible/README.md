


```
sudo apt-get update -qq && sudo apt-get install python3-venv askpass -y -qq
pip3 instal pipx
pipx install ansible --include-deps
```

```
ansible-playbook -i localhost, sysctl.yml -K -k
```
