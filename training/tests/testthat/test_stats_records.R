library(testthat)

this_dir <- tryCatch(
  dirname(normalizePath(sys.frame(1)$ofile)),
  error = function(e) getwd()
)
source(file.path(this_dir, "..", "..", "pipelines", "minimal", "scripts", "stats_records.R"))

make_records <- function() {
  data.frame(
    id    = c("S01", "S02", "S03", "S04", "S05", "S06"),
    group = c("A", "B", "A", "B", "A", "B"),
    value = c(10, 20, 30, 40, 50, 60),
    stringsAsFactors = FALSE
  )
}

test_that("résultat est un data.frame avec les bonnes colonnes", {
  result <- compute_stats(make_records())
  expect_s3_class(result, "data.frame")
  expect_named(result, c("group", "mean", "sd"))
  expect_equal(nrow(result), 2)
})

test_that("moyenne par groupe calculée correctement", {
  result <- compute_stats(make_records())
  expect_equal(result$mean[result$group == "A"], 30)
  expect_equal(result$mean[result$group == "B"], 40)
})

test_that("toutes les moyennes sont non négatives", {
  result <- compute_stats(make_records())
  expect_true(all(result$mean >= 0))
})

test_that("erreur si colonne manquante", {
  bad_df <- data.frame(id = "S01", group = "A", stringsAsFactors = FALSE)
  expect_error(compute_stats(bad_df), "Missing columns")
})

test_that("erreur si data.frame vide", {
  expect_error(compute_stats(data.frame()), "Missing columns")
})
