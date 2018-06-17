Name:           polybar
Version:        3.1.0
Release:        Stable
Summary:        Polybar

License:        MIT

%undefine _disable_source_fetch
Source:         https://github.com/jaagr/polybar/archive/%{version}.tar.gz
# Patch0:         https://file.io/vawBMZ

BuildRequires: git cmake gcc-c++ clang i3-ipc jsoncpp-devel pulseaudio-libs-devel alsa-lib-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel xcb-util-xrm-devel xcb-util-cursor-devel

Requires(post): info
Requires(preun): info

BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
A fast and easy-to-use tool for creating status bars.

Polybar aims to help users build beautiful and highly customizable status bars for their desktop environment, without the need of having a black belt in shell scripting. Here are a few screenshots showing you what it can look like:


%prep
git submodule update --recursive --remote
%setup -q


%build
cmake  -DCMAKE_C_COMPILER="clang" -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_INSTALL_PREFIX=%{_prefix} .

%install
%make_install

%files
%defattr(-,root,root)
%dir %{_datadir}/bash-completion/
%dir %{_datadir}/bash-completion/completions
%dir %{_datadir}/doc/%{name}
%dir %{_datadir}/zsh/
%dir %{_datadir}/zsh/site-functions
%{_bindir}/%{name}
%{_bindir}/%{name}-msg
%{_datadir}/doc/%{name}/config
%{_mandir}/man1/%{name}.1.gz
%{_datadir}/bash-completion/completions/%{name}
%{_datadir}/zsh/site-functions/_%{name}
%{_datadir}/zsh/site-functions/_%{name}_msg



%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT