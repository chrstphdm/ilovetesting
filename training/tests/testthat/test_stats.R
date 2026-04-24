library(testthat)

# Resolve path relative to this test file, regardless of working directory
this_dir <- tryCatch(
  dirname(normalizePath(sys.frame(1)$ofile)),
  error = function(e) getwd()
)
source(file.path(this_dir, "..", "..", "pipelines", "minimal", "scripts", "stats.R"))

make_counts <- function() {
  data.frame(
    s1 = c(10, 0, 5),
    s2 = c(20, 0, 5),
    s3 = c(30, 0, 5),
    row.names = c("geneA", "geneB", "geneC")
  )
}

test_that("résultat est un data.frame avec les bonnes colonnes", {
  result <- compute_stats(make_counts())
  expect_s3_class(result, "data.frame")
  expect_named(result, c("gene", "mean", "sd", "zero_variance"))
  expect_equal(nrow(result), 3)
})

test_that("moyenne calculée correctement", {
  result <- compute_stats(make_counts())
  expect_equal(result$mean[result$gene == "geneA"], 20)
  expect_equal(result$mean[result$gene == "geneC"], 5)
})

test_that("zero_variance détecté sur gènes constants", {
  result <- compute_stats(make_counts())
  expect_true(result$zero_variance[result$gene == "geneC"])
  expect_false(result$zero_variance[result$gene == "geneA"])
})

test_that("geneB (tous zéros) → zero_variance TRUE", {
  result <- compute_stats(make_counts())
  expect_true(result$zero_variance[result$gene == "geneB"])
})

test_that("erreur si df vide", {
  expect_error(compute_stats(data.frame()))
})

test_that("fonctionne sur grande matrice aléatoire", {
  set.seed(42)
  big <- as.data.frame(
    matrix(rpois(80, lambda = 10), nrow = 20,
           dimnames = list(paste0("gene", seq_len(20)), paste0("s", seq_len(4))))
  )
  result <- compute_stats(big)
  expect_equal(nrow(result), 20)
  expect_true(all(result$mean >= 0))
})
