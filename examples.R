library(devtools)
library(beautier)
library(beastier)
library(tracerer)
library(babette)
library(raket)
library(knitr)
library(ggplot2)
library(testthat)

setwd("C:/Users/joris/Documents/R")

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

file.copy(babette::get_babette_path("anthus_aco.fas"), "test_output_0.fas")
file.copy(babette::get_babette_path("anthus_aco.fas"), "my_fasta.fas")
file.copy(babette::get_babette_path("anthus_aco.fas"), "my_alignment.fas")
file.copy(babette::get_babette_path("anthus_aco.fas"), "anthus_aco.fas")
file.copy(babette::get_babette_path("anthus_nd2.fas"), "anthus_nd2.fas")

mcmc <- create_mcmc(chain_length = 10000, store_every = 1000)

posterior <- run(
  "test_output_0.fas",
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$test_output_0_trees, width = 2)

posterior <- run(
  "my_fasta.fas",
  posterior_crown_age = 15,
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$my_fasta_trees, width = 2)

posterior <- run(
  "my_alignment.fas",
  site_models = create_jc69_site_model(),
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$my_alignment_trees, width = 2)

posterior <- run(
  "my_alignment.fas",
  clock_models = create_rln_clock_model(),
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$my_alignment_trees, width = 2)

posterior <- run(
  "my_alignment.fas",
  tree_priors = create_bd_tree_prior(), 
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = BDBirthRate))
plot_densitree(posterior$my_alignment_trees, width = 2)

posterior <- run(
  "my_alignment.fas",
  tree_priors = create_yule_tree_prior(
    birth_rate_distr = create_normal_distr(
      mean = create_mean_param(value = 1.0),
      sigma = create_sigma_param(value = 0.1)
    )
  ),
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$my_alignment_trees, width = 2)

posterior <- run(
  "my_alignment.fas",
  site_models = create_hky_site_model(
    gamma_site_model = create_gamma_site_model(prop_invariant = 0.5)
  ),
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$my_alignment_trees, width = 2)

posterior <- run(
  "my_alignment.fas",
  clock_models = create_strict_clock_model(
    clock_rate_param = create_clock_rate_param(value = 0.5)
  ), 
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate))
plot_densitree(posterior$my_alignment_trees, width = 2)

posterior <- run(
  c("anthus_aco.fas", "anthus_nd2.fas"),
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate.aco), color = "red") +
  ggplot2::geom_line(ggplot2::aes(y = birthRate.nd2), color = "green")
plot_densitree(posterior$anthus_aco_trees, width = 2)
plot_densitree(posterior$anthus_nd2_trees, width = 2)

posterior <- run(
  c("anthus_aco.fas", "anthus_nd2.fas"),
  site_models = list(
    create_hky_site_model(), 
    create_tn93_site_model()
  ),
  mcmc = mcmc
)

ggplot2::ggplot(
  data = posterior$estimates,
  ggplot2::aes(x = Sample)
) + ggplot2::geom_line(ggplot2::aes(y = birthRate.aco), color = "red") +
  ggplot2::geom_line(ggplot2::aes(y = birthRate.nd2), color = "green")
plot_densitree(posterior$anthus_aco_trees, width = 2)
plot_densitree(posterior$anthus_nd2_trees, width = 2)

file.remove("test_output_0.fas")
file.remove("my_fasta.fas")
file.remove("my_alignment.fas")
file.remove("anthus_aco.fas")
file.remove("anthus_nd2.fas")