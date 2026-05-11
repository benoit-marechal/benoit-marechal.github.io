# Site formateur — Benoit MARECHAL

Site personnel professionnel hébergé sur GitHub Pages.

🌐 **URL** : <https://benoit-marechal.github.io>

## Stack

HTML5 + CSS3 purs. Aucun framework, aucun JS, aucun build. Hébergement statique GitHub Pages.

## Structure

```
.
├── index.html              # one-pager complet
├── style.css               # styles
├── 404.html                # page d'erreur
├── robots.txt
├── favicon.ico
├── scripts/
│   └── build-pdf.sh        # régénère assets/fiche-formateur.pdf
└── assets/
    ├── benoit-marechal.jpg
    └── fiche-formateur.pdf # généré (cf. ci-dessous)
```

## Développement local

```bash
python3 -m http.server 8000
# Puis ouvrir http://localhost:8000
```

## Régénérer la Fiche Formateur PDF

La source de la fiche est `../Formateur/Fiche-Formateur.md`.

```bash
./scripts/build-pdf.sh           # régénère assets/fiche-formateur.pdf
./scripts/build-pdf.sh --open    # idem + ouvre le PDF dans Preview
```

Pipeline : `Markdown` → `HTML autonome` (pandoc) → `PDF` (Chrome headless).
Pré-requis : `pandoc` (`brew install pandoc`) et Google Chrome.

## Contact

LinkedIn : <https://www.linkedin.com/in/benoit-marechal-lyon>
