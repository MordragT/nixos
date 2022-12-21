{ lib
, jre
, python3
, fetchFromGitHub
, fetchpatch
, enableGoogle ? false
, enableAWS ? false
, enableAzure ? false
, enableSSH ? false
}:
let
  hydra-core =
    python3.pkgs.buildPythonPackage rec {
      pname = "hydra-core";
      version = "1.3.0";
      src = python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "TlRCDDMExvkcabPdmgSsGNfhNEZFV8yriEdLQGSjCfM=";
      };

      propagatedBuildInputs = with python3.pkgs; [
        packaging
        omegaconf
      ];

      nativeBuildInputs = [
        jre
      ];

      doCheck = false;
    };

  iterative-telemetry =
    python3.pkgs.buildPythonPackage rec {
      pname = "iterative-telemetry";
      version = "0.0.6";
      format = "pyproject";

      src = python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "chvAv6li602Ah31aTgTHWIgep+fnUpo/Dpv9foKTZeI=";
      };

      SETUPTOOLS_SCM_PRETEND_VERSION = version;

      nativeBuildInputs = with python3.pkgs; [
        setuptools
      ];

      propagatedBuildInputs = with python3.pkgs; [
        requests
        appdirs
        filelock
        distro
      ];
    };

  dvc-objects =
    python3.pkgs.buildPythonPackage rec {
      pname = "dvc-objects";
      version = "0.14.0";
      format = "pyproject";

      src = fetchFromGitHub {
        owner = "iterative";
        repo = pname;
        rev = "refs/tags/${version}";
        sha256 = "Refpekyr114mIGvbaAynxldA+s83EtALeLoTQO73b/M=";
      };

      SETUPTOOLS_SCM_PRETEND_VERSION = version;

      nativeBuildInputs = with python3.pkgs; [
        setuptools-scm
      ];

      propagatedBuildInputs = with python3.pkgs; [
        flatten-dict
        fsspec
        funcy
        pygtrie
        shortuuid
        tqdm
        typing-extensions
      ];
    };

  dvc-http =
    python3.pkgs.buildPythonPackage rec {
      pname = "dvc-http";
      version = "2.27.2";
      format = "pyproject";

      src = fetchFromGitHub {
        owner = "iterative";
        repo = pname;
        rev = version;
        sha256 = "5dlATvnTAz7NcpSNNGN9YKaB5oEvhyMykKr4hKxTmaI=";
      };

      postPatch = ''
        substituteInPlace setup.cfg \
          --replace "    dvc" "    dvc-objects"
      '';

      SETUPTOOLS_SCM_PRETEND_VERSION = version;

      nativeBuildInputs = with python3.pkgs; [
        setuptools-scm
      ];

      propagatedBuildInputs = with python3.pkgs; [
        aiohttp-retry
        fsspec
        dvc-objects
      ];

      # Circular dependency with dvc
      doCheck = false;
    };

  dvc-data =
    python3.pkgs.buildPythonPackage rec {
      pname = "dvc-data";
      version = "0.28.4";
      format = "pyproject";

      src = fetchFromGitHub {
        owner = "iterative";
        repo = pname;
        rev = version;
        sha256 = "ocwOIhguH460+HJ0sE5Wj+KOiyG4NprJ+QaO+YtfTGU=";
      };

      SETUPTOOLS_SCM_PRETEND_VERSION = version;

      nativeBuildInputs = with python3.pkgs; [
        setuptools-scm
      ];

      propagatedBuildInputs = with python3.pkgs; [
        dictdiffer
        diskcache
        dvc-objects
        funcy
        nanotime
        pygtrie
        shortuuid
      ];
    };

  dvc-task =
    python3.pkgs.buildPythonPackage
      rec {
        pname = "dvc-task";
        version = "0.1.6";
        format = "pyproject";

        src = fetchFromGitHub {
          owner = "iterative";
          repo = pname;
          rev = version;
          sha256 = "Ets1Mg296i5Q9NXSoCnl63XWWa5AFM6SdL++ceJu4fk=";
        };

        SETUPTOOLS_SCM_PRETEND_VERSION = version;

        nativeBuildInputs = with python3.pkgs; [
          setuptools-scm
        ];

        propagatedBuildInputs = with python3.pkgs; [
          kombu
          shortuuid
          celery
          funcy
        ];
      };

  dvc-render =
    python3.pkgs.buildPythonPackage rec {
      pname = "dvc-render";
      version = "0.0.16";
      format = "pyproject";

      src = fetchFromGitHub {
        owner = "iterative";
        repo = pname;
        rev = "refs/tags/${version}";
        sha256 = "QHCrY221SHlj+hcQUI3ysoCnC0ItgX7LT6+PsVofVCc=";
      };

      SETUPTOOLS_SCM_PRETEND_VERSION = version;

      nativeBuildInputs = with python3.pkgs; [
        setuptools-scm
      ];
    };

  dvclive = python3.pkgs.buildPythonPackage rec {
    pname = "dvclive";
    version = "1.2.2";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "iterative";
      repo = pname;
      rev = "refs/tags/${version}";
      sha256 = "thrBPrWwLYhQPTmCxQdZTy6licML2tZjkzAaHZNQBWI=";
    };

    nativeBuildInputs = with python3.pkgs; [
      setuptools
    ];

    propagatedBuildInputs = with python3.pkgs; [
      dvc-render
      tabulate # will be available as dvc-render.optional-dependencies.table
      ruamel-yaml
    ];

    # Circular dependency with dvc
    doCheck = false;
  };
in

python3.pkgs.buildPythonApplication rec {
  pname = "dvc";
  version = "2.37.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hiroto7";
    repo = pname;
    rev = "18eab2ef9a6e5fa1d9d7e93ea96710ad3949ccec";
    sha256 = "sbfbXyyLhVC1iDGlYr3cXjArRUUlUKd5RsjjvZDbJro=";
  };

  # postPatch = ''
  #   substituteInPlace setup.cfg \
  #     --replace "grandalf==0.6" "grandalf" \
  #     --replace "scmrepo==0.0.25" "scmrepo" \
  #     --replace "pathspec>=0.9.0,<0.10.0" "pathspec"
  #   substituteInPlace dvc/daemon.py \
  #     --subst-var-by dvc "$out/bin/dcv"
  # '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "dvc-render==0.0.15" "dvc-render" \
      --replace "dvc-task==0.1.6" "dvc-task" \
      --replace "dvclive>=1.0" "dvclive" \
      --replace "dvc-data==0.28.4" "dvc-data" \
      --replace "dvc-http==2.27.2" "dvc-http" \
      --replace "iterative-telemetry==0.0.6" "iterative-telemetry" \
      --replace "pathspec>=0.9.0,<0.10.0" "pathspec" \
      --replace "grandalf==0.6" "grandalf" \
      --replace "scmrepo==0.1.4" "scmrepo"
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp-retry
    appdirs
    colorama
    configobj
    dictdiffer
    diskcache
    distro
    dpath
    dvclive
    dvc-data
    dvc-render
    dvc-task
    dvc-http
    flatten-dict
    flufl_lock
    funcy
    grandalf
    nanotime
    networkx
    packaging
    pathspec
    ply
    psutil
    pydot
    pygtrie
    pyparsing
    python-benedict
    requests
    rich
    ruamel-yaml
    scmrepo
    shortuuid
    shtab
    tabulate
    tomlkit
    tqdm
    typing-extensions
    voluptuous
    zc_lockfile
    hydra-core
    iterative-telemetry
  ] ++ lib.optionals enableGoogle [
    gcsfs
    google-cloud-storage
  ] ++ lib.optionals enableAWS [
    aiobotocore
    boto3
    s3fs
  ] ++ lib.optionals enableAzure [
    azure-identity
    knack
  ] ++ lib.optionals enableSSH [
    bcrypt
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  # Tests require access to real cloud services
  doCheck = false;

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab anthonyroussel ];
  };
}
