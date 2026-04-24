compute_stats <- function(counts_df) {
  stopifnot(is.data.frame(counts_df))
  stopifnot(nrow(counts_df) > 0)

  result <- data.frame(
    gene  = rownames(counts_df),
    mean  = rowMeans(counts_df),
    sd    = apply(counts_df, 1, sd),
    row.names = NULL
  )
  result$zero_variance <- result$sd == 0
  result
}
