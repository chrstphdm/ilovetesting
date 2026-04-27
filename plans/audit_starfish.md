# Audit — Références Starfish-spécifiques

Date : 2026-04-27
Branche : develop

---

## Résultat principal

**Aucune référence directe à Starfish, KEYBIOME, MAG, scoring propriétaire,
campagnes internes, restauration des sols, ou données internes n'a été trouvée
dans le repo.**

Les termes recherchés (`starfish`, `keybiome`, `MAG`, `campaign`, `scoring`,
`restauration`, `soil`, `catalogue`, `binning`, `assembly`, `metagenom`, `16S`,
`amplicon`, `OTU`, `ASV`, `taxonomy`, `kraken`, `metaphlan`) sont absents.

---

## Ce qui existe : exemples bioinformatiques génériques

Les exemples actuels sont bioinformatiques mais **non propriétaires** :

| Élément | Type | Verdict |
|---------|------|---------|
| `validate_fastq.sh` | Script de validation FASTQ | ✅ Neutre — générique |
| `parse_counts.py` | Parseur de table de comptage | ✅ Neutre — générique |
| `stats.R` | Calcul de statistiques sur table | ✅ Neutre — générique |
| `sample.fastq` | Mini FASTQ synthétique, 100 reads | ✅ Neutre — générique |
| `counts.tsv` | Table de comptage (20 gènes × 4 échantillons) | ✅ Neutre — générique |
| `reference.fasta` | Séquences de référence synthétiques | ✅ Neutre — générique |
| `bad.fastq`, `empty.fastq` | Cas limites FASTQ | ✅ Neutre — générique |
| `sample_shuffled.fastq`, `sample_doubled.fastq` | Tests metamorphic | ✅ Neutre — générique |
| Process FASTQC/TRIM simulés | Pipeline pédagogique Nextflow | ✅ Neutre — simulations bash |

---

## Éléments à charge cognitive élevée (sans être Starfish-spécifiques)

Ce sont des éléments qui ne sont pas propriétaires mais qui introduisent
une charge cognitive liée au domaine bioinformatique **avant** que le mécanisme
de test soit compris.

| Élément | Pourquoi charge cognitive | Recommandation |
|---------|--------------------------|----------------|
| Format FASTQ (@header / seq / + / qual) | Inconnu des non-bioinformaticiens, 4 lignes par read | Remplacer dans modules 01/02/03 |
| `counts.tsv` (20 gènes × 4 échantillons) | Implique une connaissance RNA-seq | Remplacer dans modules 01/02/03 |
| `reference.fasta` | Non utilisé dans les exercices actuels | Peut être conservé ou retiré |
| `total_reads`, `file` dans snapshots nf-test | Métadonnées FASTQC-spécifiques | Remplacer avec pipeline neutre |
| Noms FASTQC / TRIM dans le pipeline | Outils réels connus, mais simulation invisible | Renommer en COUNT_LINES / SUMMARISE |

---

## Ce qui est légitime de garder en FASTQ/bioinfo

Ces éléments ont une justification pédagogique propre à leur module :

| Élément | Module | Justification |
|---------|--------|---------------|
| `sample.fastq`, `sample_shuffled.fastq`, `sample_doubled.fastq` | 06 — Metamorphic testing | Le module est explicitement bioinformatique (oracle problem, BWA/Bowtie) |
| `fastqc_0.12.1.sif` | 05 — Container testing | FastQC est un outil public standard, non propriétaire |
| `container 'biocontainers/fastqc:0.12.1'` | 05 — Container testing | BioContainers est la référence communautaire |
| Exemple BWA/Bowtie dans slide 06 | 06 — Bioinformatics testing | Référence à PMC5425734 — cas réel documenté dans la littérature |

---

## Fichiers à modifier par phase (synthèse)

### Phase 1 — Slides conceptuels (aucune dépendance code)

| Fichier | Changement |
|---------|------------|
| `slides/01_intro.qmd` | Remplacer scénario d'intro par jointure de table silencieuse (neutre) |
| `slides/02_testing_concepts.qmd` | Remplacer `validate_fastq.sh` dans les exemples bats par `validate_records.sh` |
| `slides/07_small_team_strategy.qmd` | Vérifier l'absence de référence Starfish (déjà neutre) |

### Phase 2 — Nouvelles données et scripts

| À créer | Remplace |
|---------|---------|
| `data/records.tsv` (id, group, value — 20 lignes) | `data/counts.tsv` dans les modules 01/02/03 |
| `data/invalid_records.tsv` | `data/bad_counts.tsv` |
| `data/empty.tsv` | `data/empty.fastq` dans les modules 01/02/03 |
| `data/duplicated_records.tsv` | — (nouveau cas) |
| `scripts/validate_records.sh` | `scripts/validate_fastq.sh` dans les modules 01/03 |
| `scripts/parse_records.py` | `scripts/parse_counts.py` dans les modules 02/03 |
| `scripts/stats_records.R` | `scripts/stats.R` dans les modules 03 |

`validate_fastq.sh`, `parse_counts.py`, `stats.R` et les données FASTQ **conservés**
pour les modules 05/06 (containers, metamorphic testing).

### Phase 3 — Exercices et tests 01/02/03

| Fichier | Changement |
|---------|------------|
| `exercises/01_bash/README.qmd` + `solution.qmd` | Passer à `validate_records.sh` + `records.tsv` |
| `exercises/02_python/README.qmd` + `solution.qmd` | Passer à `parse_records.py` + `records.tsv` |
| `exercises/03_r/README.qmd` + `solution.qmd` | Passer à `stats_records.R` + `records.tsv` |
| `slides/03_bash_python_r.qmd` | Exemples `records.tsv` dans les trois langages |
| `tests/bats/test_validate_fastq.bats` | Réécrire → `test_validate_records.bats` |
| `tests/pytest/test_parse_counts.py` | Réécrire → `test_parse_records.py` |
| `tests/testthat/test_stats.R` | Réécrire → `test_stats_records.R` |

### Phase 4 — Pipeline Nextflow et slides 04/05/06

| Fichier | Changement |
|---------|------------|
| `pipelines/minimal/modules/fastqc.nf` | Renommer → `count_lines.nf` |
| `pipelines/minimal/modules/trim.nf` | Renommer → `summarise.nf` |
| `pipelines/minimal/workflows/qc_trim.nf` | Renommer → `process_table.nf` |
| `pipelines/minimal/main.nf` | Mettre à jour les imports |
| `tests/nf-test/fastqc.nf.test` | Réécrire → `count_lines.nf.test` |
| `tests/nf-test/qc_trim.nf.test` | Réécrire → `process_table.nf.test` |
| `tests/nf-test/pipeline.nf.test` | Mettre à jour les assertions |
| Snapshots nf-test | Régénérer avec `--update-snapshot` |
| `slides/04_nf_test.qmd` | Exemples COUNT_LINES / SUMMARISE |
| `exercises/04_nextflow/README.qmd` + `solution.qmd` | Mettre à jour |

---

## Ce qui ne change PAS

| Fichier/Dossier | Raison |
|----------------|--------|
| `exercises/05_testing_containers/` | FastQC est l'outil de démonstration public, non propriétaire |
| `exercises/06_metamorphic/` | FASTQ générique, référence PMC légitime |
| `slides/05_container_testing.qmd` | Contenu Apptainer/HPC déjà neutre |
| `slides/06_bioinformatics_testing.qmd` | Oracle problem et metamorphic testing restent bioinfo |
| Structure CI (jobs pytest/bats/testthat/nf-test) | Inchangée |
| `testing-methodology.qmd`, `testing-matrix.qmd` | Déjà neutres |
| `snapshot-policy.qmd`, `container-policy.qmd` | Déjà neutres |
| `faq.qmd` | Exemples à mettre à jour en phase 3 (validate_fastq → validate_records) |

---

## Décision sur `faq.qmd`

La FAQ référence `validate_fastq.sh` dans un exemple de test de non-régression.
À mettre à jour en phase 3 avec `validate_records.sh`.

---

## Conclusion

Le repo ne contient pas de contenu propriétaire Starfish.
Le problème est uniquement pédagogique : les exemples FASTQ/counts
introduisent une charge cognitive bioinformatique dans les modules qui
devraient enseigner la mécanique des tests (01/02/03).

Le plan de neutralisation s'applique donc aux modules 01–04 uniquement.
Les modules 05–06 gardent leur coloration bioinformatique (légitime et documentée).
