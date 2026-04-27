# Containers

Images de containers utilisées dans les exercices de formation.

## fastqc_0.12.1.sif

| Attribut | Valeur |
|----------|--------|
| Outil | FastQC |
| Version | 0.12.1 |
| Source | BioContainers |
| URI Docker | `docker://biocontainers/fastqc:0.12.1--hdfd78af_0` |

### Obtenir l'image

**Option 1 — pull direct (recommandé, plus rapide) :**
```bash
apptainer pull fastqc_0.12.1.sif docker://biocontainers/fastqc:0.12.1--hdfd78af_0
```

**Option 2 — build depuis le fichier de définition :**
```bash
apptainer build fastqc_0.12.1.sif fastqc.def
```

### Vérifier l'image

```bash
apptainer exec fastqc_0.12.1.sif fastqc --version
# → FastQC v0.12.1
```

### Politique d'équipe

- Le fichier `.def` est versionné dans le repo.
- Les fichiers `.sif` **ne sont pas** versionnés (trop volumineux — ajouter `*.sif` au `.gitignore`).
- En production, les `.sif` sont archivés sur le stockage HPC de l'équipe.
- La version est toujours pinned : pas de tag `latest`.
