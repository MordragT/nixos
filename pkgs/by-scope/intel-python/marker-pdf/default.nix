{
  lib,
  python,
  fetchPypi,
  fetchurl,
  buildPythonPackage,
  poetry-core,
  pdftext,
  surya-ocr,
  anthropic,
  click,
  filetype,
  ftfy,
  google-genai,
  markdown2,
  markdownify,
  openai,
  pillow,
  pydantic,
  pydantic-settings,
  python-dotenv,
  rapidfuzz,
  regex,
  scikit-learn,
  torch,
  tqdm,
  transformers,
  ebooklib,
  mammoth,
  openpyxl,
  python-pptx,
  weasyprint,
}: let
  fontFileName = "GoNotoCurrent-Regular.ttf";

  fetchFont = fetchurl {
    url = "https://models.datalab.to/artifacts/${fontFileName}";
    hash = "sha256-iCr7q5ZWCMLSvGJ/2AFrliqlpr4tNY+d4kp7WWfFYy4=";
  };
in
  buildPythonPackage rec {
    pname = "marker-pdf";
    version = "1.10.1";
    pyproject = true;

    src = fetchPypi {
      pname = "marker_pdf";
      inherit version;
      hash = "sha256-gWS8wEo7WNa+USzENXGAKgDa/D95mykgfsnx7fYJLPk=";
    };

    patches = [
      ./skip-font-download.patch
      ./fix-output-dir.patch
    ];

    pythonRelaxDeps = [
      "anthropic"
      "click"
      "markdownify"
      "openai"
      "pillow"
      "regex"
    ];

    pythonRemoveDeps = [
      "pre-commit"
    ];

    postInstall = ''
      FONT_DEST_DIR="$out/lib/${python.libPrefix}/site-packages/static/fonts"
      mkdir -p $FONT_DEST_DIR
      cp ${fetchFont} "$FONT_DEST_DIR/${fontFileName}"
      echo "Installed font to $FONT_DEST_DIR/${fontFileName}"
    '';

    build-system = [
      poetry-core
    ];

    dependencies = [
      pdftext
      surya-ocr
      anthropic
      click
      filetype
      ftfy
      google-genai
      markdown2
      markdownify
      openai
      pillow
      pydantic
      pydantic-settings
      python-dotenv
      rapidfuzz
      regex
      scikit-learn
      torch
      tqdm
      transformers
    ];

    optional-dependencies = {
      full = [
        ebooklib
        mammoth
        openpyxl
        python-pptx
        weasyprint
      ];
    };

    pythonImportsCheck = [
      "marker"
    ];

    meta = {
      description = "Convert documents to markdown with high speed and accuracy";
      homepage = "https://pypi.org/project/marker-pdf/";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [mordrag];
    };
  }
