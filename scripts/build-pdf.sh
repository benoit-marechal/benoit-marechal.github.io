#!/usr/bin/env bash
#
# build-pdf.sh — Régénère assets/fiche-formateur.pdf depuis la source
# Markdown située dans ../Formateur/Fiche-Formateur.md.
#
# Pipeline : Markdown --[pandoc]--> HTML autonome --[Chrome headless]--> PDF.
# Aucune dépendance LaTeX/typst/weasyprint requise — utilise Chrome déjà
# présent sur le poste de travail.
#
# Usage : ./scripts/build-pdf.sh [--open]
#         --open  ouvre le PDF généré après build
#
# Pré-requis :
#   - pandoc (brew install pandoc)
#   - Google Chrome installé dans /Applications
#   - Source Markdown : ../Formateur/Fiche-Formateur.md
#   - Style print     : ../Formateur/fiche-formateur-print.css

set -euo pipefail

# Résolution chemins (script peut être appelé depuis n'importe où)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$(cd "$REPO_ROOT/../Formateur" && pwd 2>/dev/null || echo "$REPO_ROOT/../Formateur")"
SOURCE_MD="$SOURCE_DIR/Fiche-Formateur.md"
SOURCE_CSS="$SOURCE_DIR/fiche-formateur-print.css"
TARGET_PDF="$REPO_ROOT/assets/fiche-formateur.pdf"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Couleurs pour les messages
red()    { printf '\033[0;31m%s\033[0m\n' "$*" >&2; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }

# Vérifications
[[ -f "$SOURCE_MD" ]]  || { red "❌ Markdown introuvable : $SOURCE_MD"; exit 1; }
[[ -f "$SOURCE_CSS" ]] || { red "❌ CSS print introuvable : $SOURCE_CSS"; exit 1; }
command -v pandoc >/dev/null 2>&1 || { red "❌ pandoc non installé (brew install pandoc)"; exit 1; }
[[ -x "$CHROME" ]]     || { red "❌ Chrome non trouvé : $CHROME"; exit 1; }

# Préparer un dossier temp pour le HTML autonome
TMP_DIR=$(mktemp -d -t fiche-build-XXXXXX)
trap 'rm -rf "$TMP_DIR"' EXIT

yellow "→ Étape 1/2 : Markdown → HTML autonome (pandoc)"
cd "$SOURCE_DIR"
pandoc Fiche-Formateur.md \
  --standalone \
  --embed-resources \
  --css=fiche-formateur-print.css \
  --metadata title="Benoit MARECHAL — Fiche Formateur" \
  --output "$TMP_DIR/fiche.html"

yellow "→ Étape 2/2 : HTML → PDF (Chrome headless)"
mkdir -p "$(dirname "$TARGET_PDF")"

# Chrome headless. --no-pdf-header-footer retire les en-têtes
# automatiques (URL, date). --print-to-pdf-no-header est l'alias récent.
"$CHROME" \
  --headless=new \
  --disable-gpu \
  --hide-scrollbars \
  --no-pdf-header-footer \
  --print-to-pdf="$TARGET_PDF" \
  "file://$TMP_DIR/fiche.html" 2>/dev/null || true

if [[ ! -f "$TARGET_PDF" ]]; then
  red "❌ PDF non généré (Chrome n'a pas écrit le fichier)."
  exit 1
fi

SIZE=$(ls -lh "$TARGET_PDF" | awk '{print $5}')
green "✅ PDF généré : $TARGET_PDF ($SIZE)"

# Option --open : ouvrir le PDF
if [[ "${1:-}" == "--open" ]]; then
  open "$TARGET_PDF"
fi
