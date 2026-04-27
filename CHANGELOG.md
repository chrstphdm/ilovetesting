# Changelog

Toutes les modifications notables de ce projet sont documentées ici.

Format basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/).
Versioning selon [Semantic Versioning](https://semver.org/lang/fr/).

## [Unreleased]

## [0.3.0] - 2026-04-27

### Added
- Module pédagogique 06 : tester les containers Apptainer/Singularity
- Slide `06_testing_containers.qmd` : deux niveaux de test, risques classiques, politique d'équipe
- Exercice `06_testing_containers/` : README.qmd + solution.qmd
- Tests bats `container_fastqc.bats` : 6 tests avec pattern `skip` si le `.sif` est absent
- Test nf-test `fastqc_container.nf.test` : process FASTQC dans son container, profil apptainer
- Fichier de définition `fastqc.def` versionné dans le repo
- Navigation Quarto mise à jour : slides 05 et 06, exercices 05 et 06
- Politique containers documentée dans CONTRIBUTING.md
- Job CI `test-containers` déclenché manuellement (`workflow_dispatch`) pour runner self-hosted avec Apptainer
- `*.sif` ajouté dans `.gitignore`

### Changed
- `fastqc.nf` : directive `container 'biocontainers/fastqc:0.12.1--hdfd78af_0'` ajoutée
- `trim.nf` : directive `container 'biocontainers/cutadapt:4.4--py310h1425a21_0'` ajoutée
- `nextflow.config` : profils `apptainer` et `singularity` ajoutés

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
