# benoit-marechal.github.io

Mon site personnel. Formateur Cloud AWS et IA générative · 18 ans d'expérience IT · Lyon. Deux piliers : Cloud IaaS/AWS et usages de l'IA générative, avec un socle Docker et Linux/RHEL. Amazon Bedrock est présenté comme un axe de spécialisation en préparation.

🌐 <https://benoit-marechal.github.io>

## Stack

HTML + CSS, hébergé sur GitHub Pages.

La fiche publique est maintenue dans `assets/fiche-formateur.md`, avec son style d'impression `assets/fiche-formateur-print.css`. Le PDF téléchargeable (`assets/fiche-formateur.pdf`) est généré par `scripts/build-pdf.sh` (pandoc → HTML → Chrome headless → PDF). Le hook `.githooks/pre-commit` vérifie sa mise à jour avant commit.

Le positionnement s'appuie sur le CV une page du projet `mes-formations`. Les sources publiques du PDF sont conservées ici pour que sa génération ne dépende pas d'un dossier personnel externe.

## Setup d'une nouvelle machine

Google Chrome doit être installé dans `/Applications`. Poppler fournit `pdfinfo`, utilisé pour vérifier que la fiche tient sur une page avant de remplacer le PDF.

```bash
brew install pandoc poppler
git config core.hooksPath .githooks
./scripts/build-pdf.sh
```
