# Base image https://hub.docker.com/u/rocker/
FROM rocker/tidyverse

## create directories
RUN mkdir -p /data
RUN mkdir -p /code
RUN mkdir -p /output

## copy files
COPY /code/install_packages.R /code/install_packages.R
COPY /code/barseq.R /code/barseq.R

## install R-packages
RUN Rscript /code/install_packages.R


## run the script
CMD Rscript /code/barseq.R
