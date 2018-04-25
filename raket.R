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

set.seed(42)
folder_name <- tempdir()
all_input_filenames <- raket::create_input_files_general(
  mcmc = beautier::create_mcmc(chain_length = 10000, store_every = 1000),
  sequence_length = 150,
  folder_name = folder_name
)
input_filename <- sample(all_input_filenames, size = 1)
dummy <- file.remove(all_input_filenames[ all_input_filenames != input_filename] )
testit::assert(file.exists(input_filename))

print(readRDS(input_filename))

output_filename <- tempfile("out.RDa")
raket::create_output_file(
  input_filename = input_filename,
  output_filename = output_filename
)

print(readRDS(output_filename))


nltts_filename <- tempfile("nltt.RDa")
raket::create_nltt_file(
  input_filename = output_filename,
  output_filename = nltts_filename,
  burn_in_fraction = 0.1
)

print(names(readRDS(nltts_filename)))

ggplot(
  data = data.frame(nltts = readRDS(nltts_filename)$nltts),
  aes(x = nltts)
) + geom_histogram(binwidth = 0.01) + geom_density()

csv_filename <- tempfile("nltts.csv")
raket::nltt_files_to_csv(
  nltt_filenames = nltts_filename, 
  csv_filename = csv_filename
)

knitr::kable(read.csv(file = csv_filename))

df <- raket::to_long(df = read.csv(csv_filename))

knitr::kable(df)

raket::plot(df_long = df)