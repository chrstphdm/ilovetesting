#!/usr/bin/env bash
# setup.sh — Installation des outils de formation ilovetesting
# Usage : bash setup.sh [--conda-only] [--no-r]
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✔${NC}  $*"; }
warn() { echo -e "${YELLOW}⚠${NC}  $*"; }
info() { echo -e "   $*"; }

CONDA_ONLY=false
SKIP_R=false
for arg in "$@"; do
  [[ "$arg" == "--conda-only" ]] && CONDA_ONLY=true
  [[ "$arg" == "--no-r" ]]       && SKIP_R=true
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ilovetesting — setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─── 1. Conda / mamba ─────────────────────────────────────────────────────────

if command -v mamba &>/dev/null; then
  CONDA_CMD=mamba
elif command -v conda &>/dev/null; then
  CONDA_CMD=conda
else
  warn "conda/mamba non trouvé."
  info "Installe Miniforge : https://github.com/conda-forge/miniforge"
  CONDA_CMD=""
fi

# ─── 2. Environnement conda ───────────────────────────────────────────────────

if [[ -n "$CONDA_CMD" ]]; then
  ENV_NAME="ilovetesting"
  if $CONDA_CMD env list | grep -q "^${ENV_NAME} "; then
    ok "Environnement conda '${ENV_NAME}' déjà présent"
  else
    info "Création de l'environnement conda '${ENV_NAME}'..."
    $CONDA_CMD env create -f environment.yml
    ok "Environnement conda '${ENV_NAME}' créé"
  fi
  info "Pour l'activer : conda activate ${ENV_NAME}"
fi

if $CONDA_ONLY; then
  echo ""
  echo "Mode --conda-only : arrêt ici."
  exit 0
fi

echo ""
echo "── Vérification des outils ────────────────────────"
echo ""

# ─── 3. Java ──────────────────────────────────────────────────────────────────

if command -v java &>/dev/null; then
  JAVA_VER=$(java -version 2>&1 | awk -F '"' 'NR==1{print $2}')
  ok "Java ${JAVA_VER}"
else
  warn "Java non trouvé — requis pour Nextflow"
  info "Installe Java 17+ : sudo apt install openjdk-17-jre  (ou via conda)"
fi

# ─── 4. Nextflow ──────────────────────────────────────────────────────────────

if command -v nextflow &>/dev/null; then
  NF_VER=$(nextflow -version 2>&1 | grep -oP '\d+\.\d+\.\d+' | head -1)
  ok "Nextflow ${NF_VER}"
else
  info "Installation de Nextflow..."
  if [[ -n "$CONDA_CMD" ]]; then
    info "(via conda — relance après 'conda activate ilovetesting')"
  else
    TARGET="${HOME}/.local/bin"
    mkdir -p "$TARGET"
    curl -s https://get.nextflow.io | bash
    mv nextflow "$TARGET/"
    ok "Nextflow installé dans ${TARGET}/nextflow"
    info "Assure-toi que ${TARGET} est dans ton PATH"
  fi
fi

# ─── 5. nf-test ───────────────────────────────────────────────────────────────

if command -v nf-test &>/dev/null; then
  NFT_VER=$(nf-test version 2>&1 | grep -oP '\d+\.\d+\.\d+' | head -1)
  ok "nf-test ${NFT_VER}"
else
  info "Installation de nf-test..."
  if [[ -n "$CONDA_CMD" ]]; then
    info "(via conda — relance après 'conda activate ilovetesting')"
  else
    TARGET="${HOME}/.local/bin"
    mkdir -p "$TARGET"
    wget -qO- https://code.askimed.com/install/nf-test | bash
    mv nf-test "$TARGET/"
    ok "nf-test installé dans ${TARGET}/nf-test"
  fi
fi

# ─── 6. bats ──────────────────────────────────────────────────────────────────

if command -v bats &>/dev/null; then
  BATS_VER=$(bats --version 2>&1 | awk '{print $NF}')
  ok "bats ${BATS_VER}"
else
  info "Installation de bats..."
  BATS_TMP=$(mktemp -d)
  git clone --depth 1 https://github.com/bats-core/bats-core.git "$BATS_TMP" 2>/dev/null
  TARGET="${HOME}/.local"
  mkdir -p "$TARGET"
  bash "$BATS_TMP/install.sh" "$TARGET"
  rm -rf "$BATS_TMP"
  ok "bats installé dans ${TARGET}/bin/bats"
  info "Assure-toi que ${HOME}/.local/bin est dans ton PATH"
fi

# ─── 7. Python + dépendances ──────────────────────────────────────────────────

if command -v python3 &>/dev/null; then
  PY_VER=$(python3 --version 2>&1 | awk '{print $2}')
  ok "Python ${PY_VER}"
  if python3 -c "import pandas, pytest" 2>/dev/null; then
    ok "pandas + pytest déjà installés"
  else
    info "Installation de pandas et pytest..."
    python3 -m pip install --quiet -r requirements.txt
    ok "pandas + pytest installés"
  fi
else
  warn "Python 3 non trouvé"
fi

# ─── 8. R + testthat ──────────────────────────────────────────────────────────

if $SKIP_R; then
  info "R ignoré (--no-r)"
elif command -v Rscript &>/dev/null; then
  R_VER=$(Rscript -e "cat(R.version\$major, R.version\$minor, sep='.')" 2>/dev/null)
  ok "R ${R_VER}"
  if Rscript -e "library(testthat)" 2>/dev/null; then
    ok "testthat déjà installé"
  else
    info "Installation de testthat..."
    Rscript -e "install.packages('testthat', repos='https://cloud.r-project.org', quiet=TRUE)"
    ok "testthat installé"
  fi
else
  warn "R non trouvé — module 03 non disponible"
fi

# ─── 9. Quarto ────────────────────────────────────────────────────────────────

if command -v quarto &>/dev/null; then
  QMD_VER=$(quarto --version 2>&1)
  ok "Quarto ${QMD_VER}"
else
  info "Installation de Quarto..."
  if [[ -n "$CONDA_CMD" ]]; then
    info "(via conda — relance après 'conda activate ilovetesting')"
  else
    OS=$(uname -s)
    ARCH=$(uname -m)
    QUARTO_VERSION="1.6.42"
    if [[ "$OS" == "Linux" && "$ARCH" == "x86_64" ]]; then
      DEB="quarto-${QUARTO_VERSION}-linux-amd64.deb"
      wget -q "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/${DEB}" -O "/tmp/${DEB}"
      sudo dpkg -i "/tmp/${DEB}" && rm "/tmp/${DEB}"
      ok "Quarto ${QUARTO_VERSION} installé"
    elif [[ "$OS" == "Darwin" ]]; then
      if command -v brew &>/dev/null; then
        brew install --cask quarto
        ok "Quarto installé via brew"
      else
        warn "brew non trouvé — télécharge Quarto manuellement : https://quarto.org/docs/get-started/"
      fi
    else
      warn "OS/arch non supporté automatiquement — télécharge Quarto : https://quarto.org/docs/get-started/"
    fi
  fi
fi

# ─── Résumé ───────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Vérification finale"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ALL_OK=true
for cmd in nextflow nf-test bats python3 Rscript quarto; do
  if command -v "$cmd" &>/dev/null; then
    ok "$cmd"
  else
    warn "$cmd manquant"
    ALL_OK=false
  fi
done

echo ""
if $ALL_OK; then
  echo -e "${GREEN}Tout est prêt.${NC} Lance les tests :"
  echo ""
  echo "  pytest                              # tests Python"
  echo "  bats training/tests/bats/           # tests Bash"
  echo "  Rscript -e \"testthat::test_dir('training/tests/testthat/')\"  # tests R"
  echo "  cd training/tests/nf-test && nf-test test  # tests Nextflow"
else
  echo -e "${YELLOW}Certains outils manquent.${NC}"
  echo "Active l'environnement conda puis relance :"
  echo "  conda activate ilovetesting && bash setup.sh"
fi
echo ""
