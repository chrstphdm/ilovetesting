load_records <- function(path) {
    if (!file.exists(path)) stop(paste("File not found:", path))
    df <- read.table(path, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
    if (nrow(df) == 0) stop("File has no data rows")
    df
}

compute_stats <- function(df) {
    stopifnot(is.data.frame(df))
    required <- c("id", "group", "value")
    missing <- setdiff(required, names(df))
    if (length(missing) > 0) stop(paste("Missing columns:", paste(missing, collapse = ", ")))

    groups <- unique(df$group)
    result <- data.frame(
        group = groups,
        mean  = sapply(groups, function(g) mean(df$value[df$group == g])),
        sd    = sapply(groups, function(g) sd(df$value[df$group == g])),
        row.names = NULL
    )
    result
}
