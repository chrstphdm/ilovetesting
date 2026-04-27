# Changelog

Toutes les modifications notables de ce projet sont documentées ici.

Format basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/).
Versioning selon [Semantic Versioning](https://semver.org/lang/fr/).

## [Unreleased]

## [0.2.0] - 2026-04-27

### Added
- Test `nextflow_pipeline` end-to-end (niveau 3 nf-test) avec assertions métier
- Assertions métier dans les tests nf-test existants (count de reads, format FASTQ, valeurs TSV)
- Module pédagogique 05 : metamorphic testing (exercice + correction + slide Quarto)
- Données de test pour le metamorphic testing : `sample_doubled.fastq`, `sample_shuffled.fastq`
- Tests bats metamorphic : MR1 (permutation), MR2 (duplication), MR3 (validation croisée)
- GitHub Pages : workflow `quarto-publish.yml` pour publier le site Quarto sur `gh-pages`
- Pre-commit hooks : `.pre-commit-config.yaml` (trailing whitespace, yaml check, shellcheck)
- Documentation pre-commit dans CONTRIBUTING.md

### Changed
- Reformulation des références nf-core : source d'inspiration sélective, pas standard obligatoire
- Section "Positionnement" ajoutée dans README pour clarifier l'approche pragmatique

## [0.1.0] - 2026-04-24

### Added
- Structure complète du repo de formation
- Slides Quarto revealjs (intro, concepts, nf-test)
- Exercices guidés + corrections (Bash, Python, R, Nextflow)
- Pipeline Nextflow minimal (FASTQC + TRIM) comme support pédagogique
- Tests prêts à l'emploi : pytest · bats · testthat · nf-test
- Mini datasets synthétiques (FASTQ, FASTA, TSV)
- Templates réutilisables pour chaque framework
- CI GitHub Actions (4 jobs : pytest / bats / testthat / nf-test)
- Script d'installation `setup.sh` + `environment.yml` conda
