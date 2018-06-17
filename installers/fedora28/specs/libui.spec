Name:           libui
Version:        3.5
Release:        alpha
Summary:        Libui

License:        MIT
URL:            https://github.com/andlabs/libui
%undefine _disable_source_fetch
Source:        https://github.com/andlabs/libui/archive/%{release}%{version}.tar.gz

BuildRequires:  cmake, gcc-c++, gtk3-devel
Requires:	gtk3

%description
Libui


%prep -n %{name}-alpha%{version}
%setup -q -n %{name}-alpha%{version}


%build
mkdir build
cd build
cmake ..
make



%install
install -d "${RPM_BUILD_ROOT}/usr/"{include,lib}
install -Dm644 ui.h "${RPM_BUILD_ROOT}/usr/include"
install -Dm644 ui_unix.h "${RPM_BUILD_ROOT}/usr/include"
install -Dm755 build/out/libui.so.0 "${RPM_BUILD_ROOT}/usr/lib"
install -Dm755 build/out/libui.so "${RPM_BUILD_ROOT}/usr/lib"


%files
/usr/include/ui_unix.h
/usr/include/ui.h
/usr/lib/libui.so.0
/usr/lib/libui.so

%changelog
* Tue Jun  5 2018 Mandy
- Initial Spec
