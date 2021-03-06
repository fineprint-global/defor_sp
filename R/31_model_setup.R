
# Dependencies ------------------------------------------------------------

stopifnot(
  exists("get_W"), # etc., 30
  file.exists("data/data.rds"),
  require("dplyr"),
  require("sf")
)

data <- readRDS("data/data.rds")


# Prep data ---------------------------------------------------------------

# Apply regional subsets
municipio_subset <- c()
# municipio_subset <- read.table("txt/municipios.txt")[[1]]

data <- data %>% filter(!code %in% municipio_subset)

# Time period
dates <- seq(2006, 2016)
dates_len <- length(dates)


# Prep models -------------------------------------------------------------

# Models
variables <- list(
  base = c("forest_ch_km2",
           "forest_px_km2_lag", "pasture_px_km2_lag", "crop_px_km2_lag",
           "pop_km2_lag", "gdp_cap_lag", "cattle_dens_lag", "soy_filled_lag",
           "spei_wet_lag", "spei_dry_lag"),
  base_vlim1 = c("forest_ch_km2",
                 "forest_px_km2_lag", "pasture_px_km2_lag", "crop_px_km2_lag",
                 "pop_km2_lag", "spei_wet_lag"),
  base_vlim2 = c("forest_ch_km2",
                 "forest_px_km2_lag", "pasture_px_km2_lag", "crop_px_km2_lag",
                 "cattle_dens_lag", "soy_filled_lag")
)

# Weights
Ws <- list(
  queen = get_W(data, type = "queen"),
  k5 = get_W(data, type = "knear", k = 5),
  k7 = get_W(data, type = "knear", k = 7)
)

W_qu <- Ws[[1]]
W_k5n <- Ws[[2]]
W_k7n <- Ws[[3]]

# Fixed effects (TFE, CFE)
fixed_effects <- list(
  # c(TRUE, TRUE),
  c(TRUE, FALSE),
  # c(FALSE, FALSE)
)

# MCMC options
n_iter <- 25000
n_save <- 10000
n_griddy <- 2000
rho_a <- 1.01
sigma_a <- 10
sigma_b <- 1
beta_mean <- 0
beta_var <- 10 ^ 8
