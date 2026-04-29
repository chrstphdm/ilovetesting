# ilovetesting

[![Tests](https://github.com/chrstphdm/ilovetesting/actions/workflows/test.yml/badge.svg)](https://github.com/chrstphdm/ilovetesting/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/github/v/tag/chrstphdm/ilovetesting?label=version)](https://github.com/chrstphdm/ilovetesting/releases)
[![nf-test](https://img.shields.io/badge/tested_with-nf--test-337ab7)](https://www.nf-test.com)

Formation interne à l'écriture de tests dans les pipelines bioinformatiques.

**Site de formation → [chrstphdm.github.io/ilovetesting](https://chrstphdm.github.io/ilovetesting/)**

Couvre : **Nextflow + nf-test · Bash + bats · Python + pytest · R + testthat**

---

## Pourquoi tester ?

| Sans tests | Avec tests |
|---|---|
| Bug découvert en production | Bug détecté avant merge |
| "Ça marchait hier" | Preuve documentée que ça marche |
| Refactoring risqué | Refactoring en confiance |
| CI impossible | CI automatisée |

**Règle d'équipe :**
- Pas de merge sans test
- Chaque bug trouvé → un test qui le détecte
- Chaque module Nextflow → un test nf-test

---

## Structure

```
training/
├── slides/          # Présentations Quarto (revealjs)
├── exercises/       # Exercices guidés par module
├── pipelines/       # Pipeline Nextflow exemple (2 étapes)
├── tests/           # Tests nf-test / pytest / bats / testthat
├── data/            # Mini datasets bioinfo
├── templates/       # Templates copiables
└── .github/         # CI GitHub Actions
```

---

## Parcours de formation

| # | Module | Outil | Durée estimée |
|---|--------|-------|---------------|
| 1 | Concepts généraux | — | 30 min |
| 2 | Tests Bash | bats | 45 min |
| 3 | Tests Python | pytest | 45 min |
| 4 | Tests R | testthat | 45 min |
| 5 | Tests Nextflow | nf-test | 90 min |
| 6 | Bonnes pratiques d'industrialisation | nf-test | 30 min |
| 7 | Intégration CI | GitHub Actions | 30 min |

---

## Démarrage rapide

```bash
# Cloner le repo
git clone https://github.com/starfishbio/ilovetesting
cd ilovetesting

# Lancer tous les tests
cd training

# Tests Python
pytest tests/pytest/ -v

# Tests Bash
bats tests/bats/

# Tests R
Rscript -e "testthat::test_dir('tests/testthat/')"

# Tests Nextflow
cd pipelines/minimal
nf-test test
```

---

## Checklist PR

Avant chaque merge :

- [ ] Tests existants passent en CI
- [ ] Nouveau code couvert par au moins un test
- [ ] Si bug corrigé : test qui aurait détecté le bug ajouté
- [ ] `nf-test test` passe localement pour les modules Nextflow modifiés

---

## Positionnement

Ce repo ne cherche pas à implémenter un pipeline nf-core ni à adopter toute sa structure.
nf-core est utilisé comme **source d'inspiration sélective** pour certaines pratiques d'industrialisation :
tests automatisés, profils dédiés, mini datasets, CI sur PR, reproductibilité.
La structure reste légère et adaptée à une petite équipe avec des pipelines internes.

## Sources

- [training.nextflow.io](https://training.nextflow.io/) — concepts Nextflow + nf-test
- [nf-test.com/docs](https://www.nf-test.com/docs/) — syntaxe et patterns nf-test
- [nf-co.re/docs/developing/testing](https://nf-co.re/docs/developing/testing/overview) — bonnes pratiques de test (référence, pas obligation)
- [github.com/askimed/nf-test-examples](https://github.com/askimed/nf-test-examples) — exemples réels
- [PMC5425734](https://pmc.ncbi.nlm.nih.gov/articles/PMC5425734/) — metamorphic testing en bioinfo
