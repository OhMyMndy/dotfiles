Name:           Polybar
Version:        3.10
Release:        3.10%{?dist}
Summary:        Polybar

License:        MIT


BuildRequires: git cmake gcc-c++ i3-ipc jsoncpp-devel pulseaudio-libs-devel alsa-lib-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel pulseaudio-libs-devel xcb-util-xrm-devel
BuildRoot:      %{_tmppath}/%{name}-root

Requires(post): info
Requires(preun): info

%description
A fast and easy-to-use tool for creating status bars.

Polybar aims to help users build beautiful and highly customizable status bars for their desktop environment, without the need of having a black belt in shell scripting. Here are a few screenshots showing you what it can look like:

%prep
rm -rf /tmp/polybar
git clone --recursive https://github.com/jaagr/polybar /tmp/polybar

%build
cd /tmp/polybar
mkdir build

%install
cd /tmp/polybar/build
cmake ..
make install



%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT