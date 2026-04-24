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

## Règles CI

`main` est protégé : tout merge requiert :
- ✅ CI verte (pytest + bats + testthat + nf-test)
- ✅ Au moins 1 review approuvée

Ne jamais pusher directement sur `main`.
