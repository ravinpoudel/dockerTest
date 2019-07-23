# Docker

Docker is one of the containerization system that allows multiple isolated operating systems to run inside a larger, host system. 

# Advantages

Bundled Dependencies 

Cross-platform Installation

Easy Distribution via images, which can be pushed to the docker hub


## 1. Running RStudio Server with Docker

Download an image from Docker hub. [Rocker](https://hub.docker.com/u/rocker/) contains Dockerfiles relevant to R and R-users. 

```


docker pull rocker/tidyverse


```

Now we need to run the downloaded image file in the with docker container. Before we run the image file we need think
about some of the flag that will be to pass to docker container.

```

docker run \
-d \
--name rstudio \
-v $(pwd):/home/rstudio \
-e PASSWORD=test \
-p 8787:8787 \
rocker/tidyverse

#############################################################################################
    -d                       ## Run in detached mode instead of -it mode (interactive mode)
    --name rstudio           ## Assign a name to the container
    -v $(pwd):/home/rstudio  ## mount pwd [path_to_shared_local_directory] to access from container at /home/rstudio 	HOST_DIR:CONTAINER_DIR
    -e PASSWORD=test         ## Password
    -p 8787:8787             ## Make a port available to services outside of Docker
    rocker/tidyverse         ## Docker image file 
#############################################################################################


```

Now,
open:
http://localhost:8787


```
username: rstudio (default username)
password: test

```

To check the list of container, and if your container is running:

```

docker ps


```

To stop the container:

```

docker container stop rstudio

```

To restart the container:

```

docker restart rstudio

```

To remove the container, first stop it then remove:

```
docker container stop rstudio
docker container rm rstudio

```

Alternatively, one can use GUI tools such as [kitematic](https://kitematic.com/) for managing Docker environments. 



## 2. Dockerfile
Dockerfile defines environment and resources need to run docker container. Basically, Dockerfile contains a list of commands that client calls while creating an image.

Lets create a folder for a project[barseq], where we want to run R. For better organization, lets create three folder:

```

data -- for input data
code -- for R code and dependencies files
output -- for storing output files

```


Note, we replicate the local folder structure, so we can specify the directories we want in the Dockerfile. After that we copy the files which we want our image to have access through these local directories – this is how you get your R script into the Docker image

```
	mkdir barseq
	cd barseq
	mkdir data
	mkdir code
	mkdir output

```

Copy your code and data into the respective folders. For instance, in this example - I have created two code files:

	barseq.R -- contains R code to process data
	
	install_packages.R  -- contains list of packages that need to be installed

```
### barseq.R ####

library("dplyr")
library("ggplot2")


## input file

data <- read.csv("data/df_merge.csv", header=T, row.names = 1, stringsAsFactors = FALSE)

data['rb_size'] <- nchar(data$cutseq)


index_seq_count <- data %>%
  select(cutseq, F_Index, R_Index, ClusterID, rb_size) %>%
  group_by(F_Index,R_Index,cutseq,rb_size) %>%
  count()
  
write.csv(index_seq_count,"output/index_seq_count.csv")


index_seq_count50 <- data %>%
  select(cutseq, F_Index, R_Index, ClusterID, rb_size) %>%
  group_by(F_Index,R_Index,cutseq,rb_size) %>%
  count() %>%
  filter(n>=50)

write.csv(index_seq_count50,"output/index_seq_count50.csv")

```

Information included in `install_packages.R`

```

# list of packages
install.packages("dplyr")
install.packages("ggplot2")

```

Now lets create a Dockerfile, and save the file at `barseq` folder.


```
######### Dockerfile #########

# Base image https://hub.docker.com/u/rocker/
FROM rocker/tidyverse

# Create directories
RUN mkdir -p /data
RUN mkdir -p /code
RUN mkdir -p /output

# Copy files
COPY /code/install_packages.R /code/install_packages.R
COPY /code/barseq.R /code/barseq.R

$ Install R-packages
RUN Rscript /code/install_packages.R

# Run the script
CMD Rscript /code/barseq.R

```

Now we have defined the Dockerfile, next step is to build a docker image file:

```
docker build -t barseq .

```

You can check the newly created image by running

```
docker image ls

```

Now, the final step is to run the docker image file with the docker container. 

```
docker run -it --rm -v $(pwd)/data:/data -v $(pwd)/output:/output barseq

	-it 	## interactive mode
	-v 	## mount inside_directory:outside_directory

```
Now navigate to your local directory `/barseq/output/` where (if every things, defined above are working properly) then you should have two files ` index_seq_count.csv ` and `index_seq_count50.csv`. 




## 3. Running Docker on AWS

```

```



## 9. Commonly use tools for Docker

```

docker ps    			## shows you all containers that are currently running
docker pull [image]     	## pull command fetches image from the Docker registry and saves it to our system
docker build [Dockerfile] 	## docker build command creates a Docker image from a Dockerfile
docker run [imagefile]
docker image ls
docker image rm [imagefile]
docker image rm -f [imagefile]
docker container stop [containername]
docker container rm [containername]
docker container rm -f [containername]
docker restart [containername]
docker container prune 		## remove all stopped containers

```

## 10. Resources

[Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1006144

