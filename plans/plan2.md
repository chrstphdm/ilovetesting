# Plan 2 — Neutralisation pédagogique du repo ilovetesting

## Contexte

Le repo GitHub public `chrstphdm/ilovetesting` existe déjà.
Il contient : slides revealjs, exercices guidés, corrections, tests Bash/bats, Python/pytest,
R/testthat, Nextflow/nf-test, containers Apptainer/Singularity, pipeline Nextflow minimal, CI GitHub Actions, site Quarto.

---

## Décision pédagogique

Réorienter la formation vers des exemples communautaires neutres.

**Objectif :** les collaborateurs apprennent d'abord la mécanique des tests sur des cas neutres,
puis adaptent eux-mêmes les patterns à leurs propres pipelines.

**Pourquoi :** réduire la charge cognitive, éviter les débats métier pendant la formation,
apprendre les frameworks proprement, permettre l'adaptation à des pipelines hétérogènes.

**Éviter :**
- exemples Starfish, KEYBIOME, MAG catalogues internes
- scoring propriétaire, campagnes internes, base de données interne
- données internes, logique métier propriétaire

**Accepter :**
- petits fichiers texte, CSV/TSV simples
- mini FASTQ uniquement si générique
- petits scripts de transformation
- petits workflows Nextflow neutres
- exemples inspirés de tutoriels Nextflow, nf-test, bats, pytest, testthat, Carpentries

---

## Contraintes d'exécution

```
Branche : develop
Ne pas merger vers main
Ne pas régénérer tout le repo
Ne pas transformer en template nf-core

Les tests CHANGERONT de contenu — c'est attendu et voulu.
La structure CI (jobs pytest / bats / testthat / nf-test) reste intacte.
Les commandes dans CLAUDE.md restent valides.
Quarto doit rester rendable après chaque phase.
```

---

## Progression pédagogique cible

```
Étape 1 — Exemple neutre communautaire
  → comprendre la mécanique du framework de test

Étape 2 — Généralisation du pattern
  → comprendre ce qu'on vient réellement de tester
  → questions : entrée ? sortie ? assertion ? cas d'erreur ? risque couvert ?

Étape 3 — Adaptation libre
  → chaque collaborateur transpose le pattern à son propre pipeline
  → exercice final : choisir un script/process réel et ajouter un test minimal
  → ne pas intégrer ce cas réel dans le repo public
```

---

## Dataset neutre de référence

Un seul dataset traverse toute la formation (slides 02, 03, exercices 01/02/03).

```
training/data/
├── records.tsv            # id, group, value — 20 lignes
├── invalid_records.tsv    # valeurs manquantes, type incorrect
├── empty.tsv              # fichier vide
├── duplicated_records.tsv # id dupliqué
└── sample.fastq           # gardé pour modules 05/06 (bioinformatique)
```

Le fichier `records.tsv` est le fil conducteur : Bash vérifie le format,
Python parse et valide, R calcule des statistiques.
`sample.fastq` reste pour les modules containers et metamorphic testing
(qui ont une coloration bioinformatique légitime).

---

## Pipeline Nextflow neutre

Remplacer le pipeline pédagogique FASTQC/TRIM par un pipeline COUNT_LINES/SUMMARISE.

```
modules/
├── count_lines.nf     # compte les lignes d'un TSV, écrit un entier dans un fichier
└── summarise.nf       # lit le résultat de count_lines, écrit un résumé TSV
workflows/
└── process_table.nf   # enchaîne count_lines → summarise
main.nf                # point d'entrée
```

Ces process sont des simulations bash (comme les actuels), mais sur un cas neutre.
Les snapshots nf-test seront régénérés après le changement (c'est attendu).
Les scripts bash simulant FASTQC/TRIM sont remplacés par des scripts COUNT_LINES/SUMMARISE.

---

## Phases d'exécution

### Phase 0 — Audit (préalable à tout)

Objectif : inventorier ce qui est Starfish-spécifique avant de toucher quoi que ce soit.

Actions :
- Grep dans tous les fichiers `.qmd`, `.bats`, `.py`, `.R`, `.nf`, `.nf.test`
  pour : `Starfish`, `KEYBIOME`, `MAG`, `coverage`, `campaign`, `scoring`, `soil`
- Lister les résultats dans un fichier `plans/audit_starfish.md`
- Classer : "à retirer", "à généraliser", "neutre déjà"

Critère de sortie : `plans/audit_starfish.md` exhaustif.

---

### Phase 1 — Slides conceptuels (sans dépendance code)

Slides : `01_intro.qmd`, `02_testing_concepts.qmd`, `07_small_team_strategy.qmd`

Ces slides ne dépendent pas de code ou de données — ils peuvent être modifiés
sans risque de casse.

**01_intro.qmd :**
- Scénario de bug silencieux neutre (jointure de table, 3 lignes disparues)
- Conserver : "ce qu'un test apporte", "la règle d'équipe", "les outils", "ce que les tests ne garantissent pas"
- Retirer : toute référence Starfish ou cas métier propriétaire
- Conserver le slide "Organisation de la formation" (mapping modules/exercices)

**02_testing_concepts.qmd :**
- Exemples neutres : `records.tsv`, comptage de lignes, validation de colonnes
- Ajouter explicitement : "Un snapshot ne dit pas que la sortie est correcte. Il dit seulement qu'elle n'a pas changé."
- Garder la distinction oracle exact / oracle faible
- Le slide GIVEN/WHEN/THEN = AAA reste tel quel (déjà neutre)

**07_small_team_strategy.qmd :**
- Retirer toute référence Starfish dans les décisions d'équipe
- Conserver et compléter la matrice de décision neutre :

  | Si... | Alors tester... |
  |-------|----------------|
  | ça transforme une donnée critique | test unitaire + assertion comportementale |
  | ça enchaîne deux étapes | test workflow |
  | ça produit un livrable | test pipeline |
  | ça a déjà cassé | test de non-régression |
  | ça dépend d'un outil externe | test container/version |
  | ça coûte cher | test minimal en PR + test long nightly ou manuel |

- Ajouter slide "minimum viable test" :
  un input minimal, une sortie attendue, une assertion comportementale, un cas d'erreur, une commande documentée
- Ajouter slide "quand ne pas tester" :
  code exploratoire jetable, visualisation temporaire, wrapper trivial déjà couvert, sortie énorme non utilisée, cas non critique très coûteux — mais documenter pourquoi
- Conserver le maturity model niveaux 0–5

Validation phase 1 : `cd training && quarto render slides/`

---

### Phase 2 — Données et scripts

Objectif : créer le dataset neutre et les scripts associés.

**Données :**
- Créer `training/data/records.tsv` (colonnes : id, group, value — 20 lignes)
- Créer `training/data/invalid_records.tsv` (valeurs manquantes, type incorrect)
- Créer `training/data/empty.tsv` (fichier vide, en-tête seul)
- Créer `training/data/duplicated_records.tsv` (id dupliqué)
- Conserver `training/data/sample.fastq` (et variants shuffled/doubled pour module 06)

**Scripts :**
- Créer `training/pipelines/minimal/scripts/validate_records.sh`
  → vérifie que le TSV a 3 colonnes, que value est numérique, exit 1 si invalide
- Créer `training/pipelines/minimal/scripts/parse_records.py`
  → charge records.tsv, valide types, détecte doublons, retourne un DataFrame
- Créer `training/pipelines/minimal/scripts/stats_records.R`
  → charge records.tsv, calcule mean/sd par groupe, retourne un data.frame

Les scripts `validate_fastq.sh`, `parse_counts.py`, `stats.R` sont conservés
en parallèle (ils sont référencés dans les tests existants pendant la transition).
Ils seront retirés en phase 3 après remplacement complet.

Validation phase 2 :
```bash
bash training/pipelines/minimal/scripts/validate_records.sh training/data/records.tsv
python -c "import sys; sys.path.insert(0,'training'); from pipelines.minimal.scripts.parse_records import load_records; print(load_records('training/data/records.tsv').shape)"
Rscript -e "source('training/pipelines/minimal/scripts/stats_records.R'); print(compute_stats(load_records('training/data/records.tsv')))"
```

---

### Phase 3 — Slides et exercices 01/02/03

Dépend de la phase 2 (scripts et données doivent exister).

**Slide 03_bash_python_r.qmd :**
- Utiliser `records.tsv` comme exemple commun aux trois langages
- Bash/bats : vérifier que le fichier existe, que le header est correct, qu'un fichier vide déclenche exit 1
- Python/pytest : parser records.tsv, vérifier que value est numérique, vérifier l'absence de doublon
- R/testthat : charger records.tsv, vérifier les colonnes, calculer moyenne par groupe, vérifier la structure
- Ne pas ré-expliquer AAA (slide 02 le fait) — directement la syntaxe
- Ajouter la règle : "Tout script appelé par un workflow doit pouvoir être testé hors du workflow."

**Exercice 01_bash :**
- Remplacer `validate_fastq.sh` par `validate_records.sh`
- Tests bats : happy path, fichier vide, fichier absent, header incorrect
- Données : records.tsv, empty.tsv, invalid_records.tsv

**Exercice 02_python :**
- Remplacer `parse_counts.py` par `parse_records.py`
- Tests pytest : chargement valide, valeurs négatives, doublons
- Données : records.tsv, invalid_records.tsv, duplicated_records.tsv

**Exercice 03_r :**
- Remplacer `stats.R` par `stats_records.R`
- Tests testthat : colonnes, types, calcul de moyenne, data.frame vide
- Données : records.tsv, empty.tsv

**Tests :**
- Réécrire `training/tests/bats/` pour utiliser les nouveaux scripts et données
- Réécrire `training/tests/pytest/` pour utiliser parse_records.py
- Réécrire `training/tests/testthat/` pour utiliser stats_records.R
- Retirer les anciens scripts validate_fastq.sh, parse_counts.py, stats.R (ou les garder sans tests)

Validation phase 3 :
```bash
pytest -v --tb=short
bats training/tests/bats/
Rscript -e "testthat::test_dir('training/tests/testthat/')"
cd training && quarto render slides/03_bash_python_r.qmd
```

---

### Phase 4 — Pipeline Nextflow et slides 04/05/06

Dépend de la phase 3. Phase la plus risquée — à faire en dernier.

**Pipeline :**
- Remplacer modules FASTQC/TRIM par COUNT_LINES/SUMMARISE
- Maintenir la même structure DSL2 (modules, workflows, main.nf)
- Les scripts bash simulés restent des simulations (bash + awk)
- Régénérer les snapshots nf-test : `nf-test test --update-snapshot`

**Slide 04_nf_test.qmd :**
- Utiliser COUNT_LINES et SUMMARISE_TABLE comme exemples
- Conserver : test de process, test de workflow, test de pipeline, snapshot, assertion explicite
- Remplacer par "framework de référence" (pas "framework officiel")
- Ajouter slide : "nf-test ne remplace pas les tests Bash/Python/R, ni la validation scientifique"
- Installation : préférer conda ou méthode documentée dans le repo (pas `wget | bash`)

**Slide 05_container_testing.qmd :**
- Garder le contenu Apptainer/Singularity (critique pour HPC)
- Exemples neutres : fastqc, seqkit, samtools ou outil simple public
- Ajouter la règle : "Un container custom critique doit avoir un .def versionné,
  un test de version, une commande de reconstruction documentée, et au moins un test d'exécution minimale."

**Slide 06_bioinformatics_testing.qmd :**
- Garder la coloration bioinformatique (oracle problem, metamorphic testing)
- Remplacer exemples Starfish par exemples bioinfo génériques :
  mini FASTQ, table de métriques QC, fichier d'abondance simple, samplesheet générique
- Exemples metamorphic neutres :
  réordonner les reads ne change pas le count, dupliquer un fichier double le count,
  fichier vide → échec explicite, proportion dans [0,1], reads en sortie ≤ reads en entrée

**Exercice 04_nextflow :**
- Mettre à jour les tests nf-test pour COUNT_LINES et SUMMARISE
- Conserver la structure (process / workflow / pipeline)
- Régénérer les snapshots

**Exercice 06_metamorphic :**
- Garder les données sample.fastq / shuffled / doubled (générique)
- Retirer toute référence à un cas métier Starfish

Validation phase 4 :
```bash
cd training/tests/nf-test && nf-test test --verbose
cd training && quarto render
```

---

## Site Quarto

### index.qmd

Ajouter une section "Pourquoi des exemples neutres ?" :
- moins de bruit métier
- apprentissage plus rapide
- exemples réutilisables
- adaptation plus facile aux pipelines de chacun
- formation utilisable par une équipe hétérogène

Ajouter une section "Comment adapter à votre pipeline ?" :
1. choisir une étape critique
2. construire un input minimal
3. définir une sortie attendue
4. écrire une assertion comportementale
5. ajouter un cas d'erreur
6. documenter la commande
7. ajouter le test à la CI si le coût est acceptable

Ajouter la mention : "Les exemples du repo sont volontairement simples.
Ils ne remplacent pas l'analyse des risques de chaque pipeline réel."

### Nouvelle page : from-examples-to-your-pipeline.qmd

Fichier : `training/from-examples-to-your-pipeline.qmd`

Contenu :
- identifier le comportement à protéger
- réduire le problème à un input minimal
- choisir le bon niveau de test
- écrire une assertion utile
- ajouter un test négatif
- décider si le test va en CI, nightly ou manuel
- documenter la limite du test

Table d'adaptation :

| Exemple neutre | Adaptation possible |
|---------------|---------------------|
| records.tsv | metadata, métriques, samplesheet |
| count lines | compter reads, lignes, features, records |
| validate header | valider colonnes obligatoires |
| duplicate id | détecter sample_id dupliqué |
| tool --version | tester container bioinfo |
| mini workflow | tester sous-workflow réel |

Ne pas mentionner de données internes.

### Nouvelle page : references.qmd

Fichier : `training/references.qmd`

Sources communautaires utilisées comme inspiration :
- Nextflow training : https://training.nextflow.io/
- nf-test docs + side quest : https://www.nf-test.com/docs/
- askimed/nf-test-examples : https://github.com/askimed/nf-test-examples
- bats-core tutorial : https://bats-core.readthedocs.io/en/stable/tutorial.html
- pytest docs : https://docs.pytest.org/
- Carpentries Python Testing : https://carpentries-incubator.github.io/python-testing/
- testthat docs : https://testthat.r-lib.org/
- R Packages testing basics : https://r-pkgs.org/testing-basics.html
- RSE good practices : https://github.com/esciencecenter-digital-skills/good-practices-in-research-software-development
- arxiv 2310.00960 : https://arxiv.org/pdf/2310.00960

Présenter comme inspirations pédagogiques, pas comme contenu copié.

### Navigation _quarto.yml

Ajouter dans Référence :
- "Adapter à votre pipeline" → from-examples-to-your-pipeline.qmd
- "Références" → references.qmd

---

## Contraintes de style

- Documentation en français
- Code, variables, commentaires en anglais
- Ton professionnel, sobre, direct
- Pas de sur-spécialisation Starfish
- Pas de données internes ni logique propriétaire
- Pas de longs paragraphes dans les slides
- Une idée par slide
- Exemples simples mais utiles (pas foo/bar ni addition de deux nombres)
- Pas de blocs Markdown mal fermés
- Vérifier les fences si du code est modifié

---

## Validation par phase

| Phase | Commandes de validation |
|-------|------------------------|
| 0 | lecture de `plans/audit_starfish.md` |
| 1 | `cd training && quarto render slides/01_intro.qmd slides/02_testing_concepts.qmd slides/07_small_team_strategy.qmd` |
| 2 | exécution manuelle des trois scripts (bash, python, R) |
| 3 | `pytest -v --tb=short && bats training/tests/bats/ && Rscript -e "testthat::test_dir('training/tests/testthat/')"` |
| 4 | `cd training/tests/nf-test && nf-test test --verbose && cd training && quarto render` |
| finale | `cd training && quarto render` (site complet) |

Ne pas prétendre avoir exécuté une commande si elle n'a pas été exécutée.

---

## Commits conventionnels attendus

```
chore(audit): inventaire des références Starfish-spécifiques
feat(slides): neutraliser 01_intro, 02_testing_concepts, 07_strategy
feat(data): ajouter records.tsv et variantes, scripts validate/parse/stats
feat(exercises): réécrire exercices 01/02/03 sur records.tsv
feat(tests): réécrire tests bats/pytest/testthat sur scripts neutres
feat(pipeline): remplacer FASTQC/TRIM par COUNT_LINES/SUMMARISE
feat(slides): neutraliser 03_bash_python_r, 04_nf_test, 05_containers, 06_bioinfo
feat(site): ajouter from-examples-to-your-pipeline.qmd et references.qmd
```

---

## Sortie attendue par phase

Pour chaque phase, fournir :
- Liste des fichiers modifiés
- Liste des références Starfish retirées ou généralisées
- Liste des exemples neutres ajoutés
- Résultat des commandes de validation
- Limites restantes
- Proposition de commit conventionnel
