
plot_dens <- function(
  x, dots = list(), 
  cols = c("#CCCCCC33"),
  main = NULL, bounds = NULL) {
  
  if(length(cols) == 1) {cols <- rep(cols, length(dots) + 1)}
  xlim <- c(min(vapply(dots, min, double(1)), x),
            max(vapply(dots, max, double(1)), x))
  ylim <- c(0, max(vapply(lapply(dots, function(x) density(x)[["y"]]),
                          max, double(1)), density(x)[["y"]]))
  plot(density(x), xlim = xlim, ylim = ylim, main = main)
  polygon(density(x), col = cols[1], border = NA)
  for(i in seq_along(dots)) {
    dens <- density(dots[[i]])
    polygon(dens, col = cols[i + 1], border = NA)
    lines(dens)
  }
  lines(density(x))
  abline(v = bounds, lty = "dashed", col = "darkgray")
}

counter <- 1


# Table -------------------------------------------------------------------

table <- do.call(cbind, 
                 lapply(1:8, function(i, run, W) {
                   table_ise(run[[i]], W[[i]])
                 },
                 run = list(sdm_qu[[counter]], sdm_k5[[counter]], sdm_k7[[counter]],
                            sar_qu[[counter]], sar_k5[[counter]], sar_k7[[counter]],
                            sem_qu[[counter]], clm[[counter]]),
                 W = list(W_qu, W_k5n, W_k7n, W_qu, W_k5n, W_k7n, W_qu, W_qu)))
table <- table[, c(1, which(!names(table) == "variables"))]
names(table)[-1] <- paste0(gsub("(.*)[.][0-9]", "\\1", names(table)[-1]), "-",
                           c(rep(c("sdm_qu", "sdm_k5", "sdm_k7",
                                   "sar_qu", "sar_k5", "sar_k7"), each = 4),
                             rep(c("sem_qu", "clm"), each = 2)))
write.csv(table, file = paste0("txt/fit_bayesian_", effect, "_", 
                               names(variables)[counter], ".csv"))


# Plots -------------------------------------------------------------------

png("plots/bayes/dens_full_dir.png", width = 1200, height = 750)
op <- par(mfrow = c(ceiling(sqrt(length(variables[[counter]]))),
                    floor(sqrt(length(variables[[counter]])))), 
          mar =  c(2, 2, 2, 0.5))
plot_dens(sdm_qu[[counter]]$rho_post,
          list(sar_qu[[counter]]$rho_post,
               sem_qu[[counter]]$rho_post),
          main = paste0("Rho", " - ", 
                        "SDM (gray), SAR (yellow), SEM (red)"), 
          cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33"))
for(i in seq(1, -1 + length(variables[[counter]]))) {
  plot_dens(sdm_qu[[counter]]$direct_post[i + 1, ], 
            list(sar_qu[[counter]]$direct_post[i + 1, ], 
                 sem_qu[[counter]]$beta_post[i + 1, ],
                 clm[[counter]]$beta_post[i + 1, ]), 
            main = paste0(variables[[counter]][-1][i], " - ", 
                          "SDM_d (gray), SAR_d (yellow), SEM (red) & CLM (green)"), 
            cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33", "#00CCFF33"))
}
par(op); dev.off()

png("plots/bayes/dens_full_indir.png", width = 1200, height = 750)
op <- par(mfrow = c(ceiling(sqrt(length(variables[[counter]]) - 1)),
                    floor(sqrt(length(variables[[counter]]) - 1))), 
          mar =  c(2, 2, 2, 0.5))
for(i in seq(1, -1 + length(variables[[counter]]))) {
  plot_dens(sdm_qu[[counter]]$indirect_post[i + 1, ], 
            list(sar_qu[[counter]]$indirect_post[i + 1, ]), 
            main = paste0(variables[[counter]][-1][i], " - ", 
                          "SDM_i (gray), SAR_i (yellow)"), 
            cols = c("#CCCCCC33", "#FFFF0033"))
}
par(op); dev.off()

png("plots/bayes/dens_sdm_dir.png", width = 1200, height = 750)
op <- par(mfrow = c(ceiling(sqrt(length(variables[[counter]]))),
                    floor(sqrt(length(variables[[counter]])))), 
          mar =  c(2, 2, 2, 0.5))
plot_dens(sdm_qu[[counter]]$rho_post,
          list(sdm_k5[[counter]]$rho_post,
               sdm_k7[[counter]]$rho_post),
          main = paste0("Rho", " - ", 
                        "SDM_qu (gray), SDM_k5 (yellow), SDM_k7 (red)"), 
          cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33"))

for(i in seq(1, -1 + length(variables[[counter]]))) {
  plot_dens(sdm_qu[[counter]]$direct_post[i + 1, ], 
            list(sdm_k5[[counter]]$direct_post[i + 1, ], 
                 sdm_k7[[counter]]$direct_post[i + 1, ]), 
            main = paste0(variables[[counter]][-1][i], " - ", 
                          "SDM_qu (gray), SDM_k5 (yellow), SDM_k7 (red)"), 
            cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33"))
}
par(op); dev.off()

png("plots/bayes/dens_sar_dir.png", width = 1200, height = 750)
op <- par(mfrow = c(ceiling(sqrt(length(variables[[counter]]))),
                    floor(sqrt(length(variables[[counter]])))), 
          mar =  c(2, 2, 2, 0.5))
plot_dens(sar_qu[[counter]]$rho_post,
          list(sar_k5[[counter]]$rho_post,
               sar_k7[[counter]]$rho_post),
          main = paste0("Rho", " - ", 
                        "SAR_qu (gray), SAR_k5 (yellow), SAR_k7 (red)"), 
          cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33"))

for(i in seq(1, -1 + length(variables[[counter]]))) {
  plot_dens(sar_qu[[counter]]$direct_post[i + 1, ], 
            list(sar_k5[[counter]]$direct_post[i + 1, ], 
                 sar_k7[[counter]]$direct_post[i + 1, ]), 
            main = paste0(variables[[counter]][-1][i], " - ", 
                          "SAR_qu (gray), SAR_k5 (yellow), SAR_k7 (red)"), 
            cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33"))
}
par(op); dev.off()

png("plots/bayes/dens_sar_ind.png", width = 1200, height = 750)
op <- par(mfrow = c(ceiling(sqrt(length(variables[[counter]]) - 1)),
                    floor(sqrt(length(variables[[counter]]) - 1))), 
          mar =  c(2, 2, 2, 0.5))
for(i in seq(1, -1 + length(variables[[counter]]))) {
  plot_dens(sar_qu[[counter]]$indirect_post[i + 1, ], 
            list(sar_k5[[counter]]$indirect_post[i + 1, ], 
                 sar_k7[[counter]]$indirect_post[i + 1, ]), 
            main = paste0(variables[[counter]][-1][i], " - ", 
                          "SAR_qu (gray), SAR_k5 (yellow), SAR_k7 (red)"), 
            cols = c("#CCCCCC33", "#FFFF0033", "#FF00CC33"))
}
par(op); dev.off()


# Get HPDIs ---------------------------------------------------------------

ci_sdm_qu <- lapply(get_hpdis(sdm_qu[[1]], c(0.99, 0.95)), t)
write.csv(cbind(rbind(ci_sdm_qu[[1]], ci_sdm_qu[[3]]), rbind(ci_sdm_qu[[2]], NA)), "txt/ci/sdm_qu.csv")
ci_sdm_k7 <- lapply(get_hpdis(sdm_k7[[1]], c(0.99, 0.95)), t)
write.csv(cbind(rbind(ci_sdm_k7[[1]], ci_sdm_k7[[3]]), rbind(ci_sdm_k7[[2]], NA)), "txt/ci/sdm_k7.csv")
ci_sar_qu <- lapply(get_hpdis(sar_qu[[1]], c(0.99, 0.95)), t)
write.csv(cbind(rbind(ci_sar_qu[[1]], ci_sar_qu[[3]]), rbind(ci_sar_qu[[2]], NA)), "txt/ci/sar_qu.csv")
write.csv(do.call(rbind, lapply(get_hpdis(sem_qu[[1]], c(0.99, 0.95)), t)), "txt/ci/sem_qu.csv")
write.csv(lapply(get_hpdis(clm[[1]], c(0.99, 0.95)), t), "txt/ci/clm.csv")
