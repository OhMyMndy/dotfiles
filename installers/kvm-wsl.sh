
##Fully based on https://boxofcables.dev/accelerated-kvm-guests-on-wsl-2/
if [ -z "$1" ]
  then
    echo "Must supply your Windows 10 username"
    exit
fi
WIN_USERNAME=$1

#package updates and installations

sudo apt update && sudo apt -y upgrade
sudo apt -y install build-essential libncurses-dev bison flex libssl-dev libelf-dev cpu-checker qemu-kvm aria2 jq bc binutils dwarves

#download WSL2 Kernel and backup config file
cd ~
tag="$(curl https://api.github.com/repos/microsoft/WSL2-Linux-Kernel/releases/latest | jq '.tag_name' -r)"

if [[ ! -d WSL2-Linux-Kernel-$tag ]]; then
  curl -SsL https://github.com/microsoft/WSL2-Linux-Kernel/archive/$tag.tar.gz -o wsl2-kernel.tar.gz
  tar -xf wsl2-kernel.tar.gz
fi

cd ./WSL2-Linux-Kernel-$tag
cp -f ./Microsoft/config-wsl .config

#add properties to avoid using make menuconfig command (CONFIG_VHOST_NET and CONFIG_VHOST are already in the file)
#echo 'KVM_GUEST=y
#CONFIG_KVM=y
#CONFIG_KVM_INTEL=m' >> .config
sed -i 's/# CONFIG_KVM_GUEST is not set/CONFIG_KVM_GUEST=y/g' .config

sed -i 's/# CONFIG_ARCH_CPUIDLE_HALTPOLL is not set/CONFIG_ARCH_CPUIDLE_HALTPOLL=y/g' .config

sed -i 's/# CONFIG_HYPERV_IOMMU is not set/CONFIG_HYPERV_IOMMU=y/g' .config

sed -i '/^# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set/a CONFIG_PARAVIRT_CLOCK=y' .config

sed -i '/^# CONFIG_CPU_IDLE_GOV_TEO is not set/a CONFIG_CPU_IDLE_GOV_HALTPOLL=y' .config

sed -i '/^CONFIG_CPU_IDLE_GOV_HALTPOLL=y/a CONFIG_HALTPOLL_CPUIDLE=y' .config

sed -i 's/CONFIG_HAVE_ARCH_KCSAN=y/CONFIG_HAVE_ARCH_KCSAN=n/g' .config

sed -i '/^CONFIG_HAVE_ARCH_KCSAN=n/a CONFIG_KCSAN=n' .config
#build the kernel
make -j 8

#install kernel modules
sudo make modules_install

#install the new wsl2 kernel
cp -f arch/x86/boot/bzImage /mnt/c/Users/$WIN_USERNAME/bzImage
echo '[wsl2]
nestedVirtualization=true
kernel=C:\\Users\\'$WIN_USERNAME'\\bzImage' > /mnt/c/Users/$WIN_USERNAME/.wslconfig

#create kvm-nested.conf file and moves to /etc/modprobe.d/ folder
echo 'options kvm-intel nested=1
options kvm-intel enable_shadow_vmcs=1
options kvm-intel enable_apicv=1
options kvm-intel ept=1' > kvm-nested.conf
sudo mv kvm-nested.conf /etc/modprobe.d/
exit
