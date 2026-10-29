#!/usr/bin/env bash
# Génère la fiche publique depuis assets/fiche-formateur.md et son CSS local.
# Prérequis macOS : pandoc, Poppler (pdfinfo) et Google Chrome.
# Usage : ./scripts/build-pdf.sh [--open]

set -euo pipefail

if [[ $# -gt 1 || ( $# -eq 1 && "${1}" != "--open" ) ]]; then
  printf 'Usage : %s [--open]\n' "${0}" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_MD="${REPO_ROOT}/assets/fiche-formateur.md"
SOURCE_CSS="${REPO_ROOT}/assets/fiche-formateur-print.css"
TARGET_PDF="${REPO_ROOT}/assets/fiche-formateur.pdf"
CHROME="${CHROME_BIN:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"

for source in "${SOURCE_MD}" "${SOURCE_CSS}"; do
  [[ -f "${source}" ]] || { printf 'Source introuvable : %s\n' "${source}" >&2; exit 1; }
done
for dependency in pandoc pdfinfo; do
  command -v "${dependency}" >/dev/null 2>&1 || { printf 'Commande requise : %s\n' "${dependency}" >&2; exit 1; }
done
[[ -x "${CHROME}" ]] || { printf 'Chrome introuvable : %s\n' "${CHROME}" >&2; exit 1; }

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/fiche-build.XXXXXX")"
cleanup() {
  if command -v trash >/dev/null 2>&1; then
    trash "${TMP_DIR}" >/dev/null 2>&1 || printf 'Dossier temporaire conservé : %s\n' "${TMP_DIR}" >&2
  else
    printf 'Dossier temporaire conservé : %s\n' "${TMP_DIR}" >&2
  fi
}
trap cleanup EXIT

printf 'Génération de la fiche publique…\n'
pandoc "${SOURCE_MD}" \
  --standalone \
  --embed-resources \
  --css="${SOURCE_CSS}" \
  --metadata pagetitle="Benoit Maréchal - Formateur Cloud AWS & IA générative" \
  --output "${TMP_DIR}/fiche.html"

# Un profil temporaire évite de transmettre la commande à une session Chrome ouverte.
if ! "${CHROME}" \
  --headless=new \
  --disable-gpu \
  --hide-scrollbars \
  --no-pdf-header-footer \
  --user-data-dir="${TMP_DIR}/chrome-profile" \
  --print-to-pdf="${TMP_DIR}/fiche.pdf" \
  "file://${TMP_DIR}/fiche.html" >"${TMP_DIR}/chrome.log" 2>&1; then
  cat "${TMP_DIR}/chrome.log" >&2
  printf 'Échec de Chrome ; le PDF précédent est conservé.\n' >&2
  exit 1
fi

[[ -s "${TMP_DIR}/fiche.pdf" ]] || { printf 'Chrome n’a pas généré de PDF ; le précédent est conservé.\n' >&2; exit 1; }
if ! LC_ALL=C pdfinfo "${TMP_DIR}/fiche.pdf" >"${TMP_DIR}/pdfinfo.txt"; then
  printf 'PDF invalide ; le précédent est conservé.\n' >&2
  exit 1
fi
PAGES="$(awk '/^Pages:/ {print $2}' "${TMP_DIR}/pdfinfo.txt")"
[[ "${PAGES}" == "1" ]] || { printf 'La fiche doit tenir sur une page (résultat : %s). PDF précédent conservé.\n' "${PAGES}" >&2; exit 1; }

# La cible n’est remplacée qu’après validation du fichier temporaire.
mv "${TMP_DIR}/fiche.pdf" "${TARGET_PDF}"
printf 'PDF vérifié : %s (1 page)\n' "${TARGET_PDF}"

if [[ "${1:-}" == "--open" ]]; then
  open "${TARGET_PDF}"
fi
