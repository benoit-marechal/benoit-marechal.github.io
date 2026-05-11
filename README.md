# benoit-marechal.github.io

Mon site personnel. Formateur · 20 ans d'IT · Lyon.

🌐 <https://benoit-marechal.github.io>

## Stack

HTML + CSS, hébergé sur GitHub Pages.

La Fiche Formateur PDF (`assets/fiche-formateur.pdf`) est régénérée
automatiquement à chaque commit par le hook `.githooks/pre-commit`,
qui passe la source `../Formateur/Fiche-Formateur.md` dans
`scripts/build-pdf.sh` (pandoc → HTML → Chrome headless → PDF).

## Setup d'une nouvelle machine

```bash
brew install pandoc
git config core.hooksPath .githooks
```
