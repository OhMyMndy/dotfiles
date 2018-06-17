Name:           libui-php
Version:        2.0.0
Release:        Release
Summary:        Libui

License:        MIT
URL:            https://github.com/krakjoe/ui
%undefine _disable_source_fetch
Source:        https://github.com/krakjoe/ui/archive/v%{version}.tar.gz

BuildRequires:  libui, cmake
Requires:	php

%description
Libui


%prep -n ui-%{version}
%setup -q -n ui-%{version}


%build
cd ui
phpize
make
make install



%changelog
* Tue Jun  5 2018 Mandy
- Initial Spec
