{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "llm-openrouter";
  version = "0.2";
  pyproject = true;
  dontCheckRuntimeDeps = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openrouter";
    rev = version;
    hash = "sha256-tEYzTykNG5USY5LXNnPxtjCr0GLnQ3zqILS07leLHyg=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [ python3.pkgs.httpx ];

  passthru.optional-dependencies = with python3.pkgs; {
    test = [
      pytest
      pytest-httpx
    ];
  };

  meta = with lib; {
    description = "LLM plugin for models hosted by OpenRouter";
    homepage = "https://github.com/simonw/llm-openrouter";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
