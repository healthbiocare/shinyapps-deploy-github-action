# start from shiny-verse to include both the shiny and tidyverse packages,
# saving us time assuming that the app to be deployed doesn't have dependencies
# locked to different versions.
# HBC NOTE: We set a specific R version for this docker image, because sometimes the 
# "latest" version was not supported by the Linux version used in the GH Actions process.
FROM rocker/shiny-verse:4.4.1

# install rsconnect and renv packages, as well as prerequisite libraries
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev
RUN install2.r rsconnect renv DT RecordLinkage plotly shinydashboard shinyjs 

# copy deploy script to root of the workspace
COPY deploy.R /deploy.R

# run deploy script, ignoring any .Rprofile files to avoid issues with conflicting
# library paths.
# TODO: this may cause issues if the .Rprofile does any setup required for the app to run
CMD ["Rscript", "--no-init-file", "/deploy.R"]
