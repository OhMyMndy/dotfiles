Name:           peco
Version:        0.5.3
Release:        stable
Summary:        Peco
BuildArch:		x86_64

License:        MIT
URL:            https://github.com/peco/peco
%undefine _disable_source_fetch
Source:         https://github.com/peco/peco/releases/download/v%{version}/%{name}_linux_amd64.tar.gz


%description
Simplistic interactive filtering tool

%prep -n peco_linux_amd64
%setup -n peco_linux_amd64

%install
install -d "${RPM_BUILD_ROOT}%{_bindir}"
install %{_builddir}/peco_linux_amd64/peco "${RPM_BUILD_ROOT}%{_bindir}"

%files
%{_bindir}/peco

%clean

%changelog
* Tue Jun  5 2018 Mandy
- Initial Spec
