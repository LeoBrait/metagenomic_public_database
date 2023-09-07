library(vegan)
library(parallel)  # Load the parallel package

rarec <- function(
    data,
    pace = 1,
    sample,
    xlab = "Number of reads",
    ylab = "Phyla",
    label = FALSE,
    cols,
    title_plot,
    ...) {

  sample_size <- nrow(data)
  cols <- rep(cols, length.out = sample_size)
  specimen <- rowSums(data)
  diversity <- specnumber(data)

  # Define the number of CPU cores you want to use for parallel processing
  num_cores <- detectCores()

  # Parallelize the rarefaction calculations using mclapply
  rarified <- mclapply(
    seq_len(sample_size),
    function(i) {
      n <- seq(1, specimen[i], by = pace)
      if (n[length(n)] != specimen[i]){
        n <- c(n, specimen[i])
      }
      print(paste(
        "Computing rarefaction for:",
        rownames(data)[i],
        "sample number of:",
        i,
        "out of:",
        sample_size,
        sep = " "
      ))
      drop(rarefy(data[i, ], n))
    },
    mc.cores = 40
  )

  nmax <- sapply(rarified, function(data) max(attr(data, "Subsample")))
  smax <- sapply(rarified, max)

  plot(
    c(1, max(nmax)),
    c(1, max(smax)),
    xlab = xlab,
    ylab = ylab,
    type = "n",
    main = title_plot,
    bty = "L",
    las = 1,
    font.lab = 2
  )

  for (line in seq_len(length(rarified))) {
    N <- attr(rarified[[line]], "Subsample")
    lines(N, rarified[[line]], col = cols[line], ...)
  }
  if (label) {
    ordilabel(cbind(specimen, diversity), labels = rownames(data), ...)
  }
  invisible(rarified)

}