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

La source de vérité de la fiche est `../Formateur/Fiche-Formateur.md` (hors repo).
À chaque modification de la fiche, lancer :

```bash
./scripts/build-pdf.sh           # régénère assets/fiche-formateur.pdf
./scripts/build-pdf.sh --open    # idem + ouvre le PDF dans Preview
```

Pipeline : `Markdown` → `HTML autonome` (pandoc) → `PDF` (Chrome headless).

**Pré-requis** : `pandoc` (`brew install pandoc`) et Google Chrome installé dans `/Applications`.

⚠️ **Avant chaque commit qui touche le contenu**, penser à régénérer le PDF si la fiche source a changé.

## Documentation projet

- Spec design : [`docs/superpowers/specs/2026-05-07-site-formateur-design.md`](docs/superpowers/specs/2026-05-07-site-formateur-design.md)
- Plan d'implémentation : [`docs/superpowers/plans/2026-05-07-site-formateur.md`](docs/superpowers/plans/2026-05-07-site-formateur.md)

## Contact

LinkedIn : <https://www.linkedin.com/in/benoit-marechal-lyon>
