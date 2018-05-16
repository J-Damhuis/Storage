# e_stem <- Ng0 * e((sirg - erg) * age) * (p_age_t / (1 - (1 - p_0_t) ^ Ng0))
# e_crown <- 2 * e((sirg - erg) * age) * (p_age_t / p_0_t)
# p_t1_t2 <- (1 - (erg / sirg)) / (1 - ((erg / sirg) * e(-1 * (sirg - erg) * (t2 - t1))))

pbd_get_exp_n_lineages_pb <- function(
  sirg,
  erg,
  Ng,
  stem_age = NULL,
  crown_age = NULL
) {
  if (sirg <= 0.0) {
    stop("'sirg' must be non-zero and positive")
  }
  if (erg < 0.0) {
    stop("'erg' must be zero or positive")
  }
  if (Ng <= 0.0) {
    stop("'Ng' must be non-zero and positive")
  }
  if (is.null(crown_age)) {
    if (is.null(stem_age)) {
      stop(
        "At least one of 'crown_age' or 'stem_age' ",
        "must be non-zero and positive"
      )
    } else if (stem_age <= 0.0) {
      stop("'stem_age' must be non-zero and positive")
    }
  } else if (crown_age <= 0.0) {
    stop("'crown_age' must be non-zero and positive")
  } else if (crown_age > 0.0) {
    if (!is.null(stem_age)) {
      stop("Must set either 'crown_age' or 'stem_age'")
    }
  }
  
  age <- stem_age
  if (is.null(age)) age <- crown_age
  
  prob <- (1-(erg/sirg))/(1-(erg/sirg)*exp(-(sirg-erg)*age))
  
  if (is.null(stem_age)) exp_n <- 2*exp((sirg-erg)*age)*
}