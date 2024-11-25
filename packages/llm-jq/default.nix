{ lib
, python3
, fetchFromGitHub
,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "llm-jq";
  version = "0.1.1";
  pyproject = true;
  dontCheckRuntimeDeps = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-jq";
    rev = version;
    hash = "sha256-Mf/tbB9+UdmSRpulqv5Wagr8wjDcRrNs2741DNQZhO4=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    test = [
      pytest
    ];
  };

  meta = with lib; {
    description = "Write and execute jq programs with the help of LLM";
    homepage = "https://github.com/simonw/llm-jq";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
