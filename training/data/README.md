# Mini datasets de test

Données synthétiques minimalistes — usage exclusivement pédagogique.

| Fichier | Description | Taille |
|---------|-------------|--------|
| `sample.fastq` | 100 reads FASTQ valides, 80 bp | ~24 KB |
| `empty.fastq` | Fichier vide | 0 B |
| `bad.fastq` | Format invalide (pas de `@`) | ~200 B |
| `counts.tsv` | 20 gènes × 4 échantillons, valeurs positives | ~1 KB |
| `bad_counts.tsv` | 20 gènes × 3 échantillons, valeurs négatives | ~800 B |
| `reference.fasta` | 3 séquences synthétiques, ~200 bp chacune | ~700 B |

Générés avec `random.seed(42)` pour reproductibilité.
