# Contributing

## Workflow git

```
main      ← production / formation stable (protégé)
  └── develop ← intégration
        └── feat/xxx   ← développement d'un module
        └── fix/xxx    ← correction
        └── docs/xxx   ← documentation uniquement
```

### Étapes pour contribuer

```bash
# 1. Partir de develop à jour
git checkout develop && git pull

# 2. Créer une branche
git checkout -b feat/module-bash-avance

# 3. Travailler, committer régulièrement
git add <fichiers>
git commit -m "feat(bash): ajouter exercice sur les pipes"

# 4. Pousser et ouvrir une PR vers develop
git push -u origin feat/module-bash-avance
gh pr create --base develop --title "feat: module bash avancé"

# 5. Merge develop → main via PR (après review + CI verte)
```

---

## Conventions de commits (Conventional Commits)

```
<type>(<scope>): <description courte>

[corps optionnel]
[footer optionnel]
```

| Type | Quand |
|------|-------|
| `feat` | Nouveau module, nouvel exercice |
| `fix` | Correction d'un test ou d'un script |
| `docs` | README, CHANGELOG, commentaires |
| `test` | Ajout ou correction de tests |
| `chore` | CI, dépendances, config |
| `refactor` | Réécriture sans changement de comportement |

Exemples :
```
feat(nf-test): ajouter test snapshot pour le workflow QC_TRIM
fix(pytest): corriger le chemin vers bad_counts.tsv
docs(slides): ajouter slide sur les fixtures pytest
chore(ci): ajouter job R testthat dans GitHub Actions
```

---

## Versioning (Semantic Versioning)

```
v<MAJOR>.<MINOR>.<PATCH>

MAJOR : rupture de compatibilité (structure du repo réorganisée)
MINOR : nouveau module ou section ajoutée
PATCH : correction, amélioration mineure
```

Créer une release :
```bash
# Sur main après merge
git tag -a v0.2.0 -m "v0.2.0 — ajout module Bash avancé"
git push origin v0.2.0
gh release create v0.2.0 --generate-notes
```

---

## Pre-commit hooks (optionnel mais recommandé)

```bash
# Installer pre-commit (une fois)
pip install pre-commit   # ou : conda install -c conda-forge pre-commit

# Activer les hooks dans le repo
pre-commit install

# Lancer manuellement sur tous les fichiers
pre-commit run --all-files
```

Les hooks configurés (`.pre-commit-config.yaml`) vérifient :
- espaces en fin de ligne, fin de fichier, encodage YAML
- fins de ligne LF
- `shellcheck` sur les scripts `.sh` et `.bats`

---

## Règles CI

`main` est protégé : tout merge requiert :
- ✅ CI verte (pytest + bats + testthat + nf-test)
- ✅ Au moins 1 review approuvée

Ne jamais pusher directement sur `main`.

---

## Politique containers

### Règles obligatoires

- Chaque process Nextflow déclare son container avec un tag exact (jamais `latest`)
- Chaque container a un test `--version` dans les fichiers `.bats` correspondants
- Chaque process containerisé a un test nf-test pouvant être lancé avec `-profile apptainer`
- Les fichiers `.def` (définitions Apptainer) sont versionnés dans le repo
- Les fichiers `.sif` (images compilées) **ne sont pas** commitées dans git — elles sont archivées sur le stockage HPC ou regénérées

### Sources d'images autorisées

| Source | Usage |
|--------|-------|
| **BioContainers** | Images bioinformatiques standard, tag par version de l'outil |
| **Seqera Containers / Wave** | Build à la volée depuis conda/bioconda |
| **Registry équipe** | Images custom — `.def` versionné obligatoire dans le repo |

### Niveaux de test pour les containers

| Niveau | Outil | Ce qu'on vérifie |
|--------|-------|-----------------|
| **Container seul** | `bats` + `apptainer exec` | Image démarre, outil accessible, bonne version, pas de dépendance à `$HOME` |
| **Process Nextflow containerisé** | `nf-test --profile apptainer` | Nextflow utilise le container, le process termine, les sorties sont correctes |

Les tests container bats (`exercises/06_testing_containers/tests/`) sont **locaux ou HPC** : ils nécessitent Apptainer et le fichier `.sif`. Ils ne s'exécutent pas automatiquement en CI standard — voir le job `test-containers` (déclenchement manuel via `workflow_dispatch`).

### Structure attendue pour un module containerisé

```
modules/
└── mon_outil.nf           # process avec container 'registry/image:tag'

exercises/XX_mon_module/
└── containers/
    ├── mon_outil.def      # définition Apptainer (versionné dans git)
    └── README.md          # instructions pull/build, politique .sif
└── tests/
    ├── container_mon_outil.bats   # tests bats du container seul
    └── mon_outil_container.nf.test  # test nf-test avec profil apptainer
```
