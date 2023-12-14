# Objectives
* Implement semantic versioning for images using git tag metadata in Actions
* Use webhooks to keep production up to date
# Part 1 - Semantic Versioning
## Tag Generation
In order to generate a tag, use `git tag` followed by the tag you wish to use, or you can go into your github repository, then releases, then "draft a new release", then select "create new tag on publish" and enter tag you wish to use.
* behavior of workflow

- ![docker image file1](https://github.com/WSU-kduncan/f23cicd-mkieselhorst/blob/main/docker1.png)
- ![docker image file2](https://github.com/WSU-kduncan/f23cicd-mkieselhorst/blob/main/docker2.png)
- ![docker image file3](https://github.com/WSU-kduncan/f23cicd-mkieselhorst/blob/main/docker3.png)
* In this workflow,
  1. It is set to run on push that is tagged with anything
  2. when it is ran
    1. it builds from the dockerfile, running on ubuntu-latest
    2. runs the checkout action to grab the data from the repository
    3. runs the docker/metadata-action with id `meta`
       1. grabs the image from the environment variables stored in github
       2. sets the `latest tag` for the master branch
       3. then adds the tags of the version, and branch
    4. runs the docker/login-action
       1. uses docker username and paassword secrets that are stored
    5. runs docker buildx-action to build from the repo
    6. runs docker/build-push-actions
       1. from the dockerfile
       2. will push
       3. with the tags `kxwell/ceg3120:latest` & `kxwell/ceg3120:${{ steps.meta.outputs.version }}` from the meta id output
       4. then uses the labels from the meta id output as well
* [Dockerhub Repo](https://hub.docker.com/r/kxwell/ceg3120/tags)

# part 2 - Deployment
### docker installation
*  ran the following to install dependencies
      *  `sudo apt update && sudo apt upgrade -y
sudo apt remove docker docker-engine docker.io containerd runc
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y`
*  added the docker repository to the source list using
      *  `sudo mkdir -p /etc/apt/keyrings` and then `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`
*  set up the repository using
      *  `echo \ deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`
*  installed the docker engine with
      *  `sudo apt-get update	sudo apt-get install docker-ce docker-ce-cli containerd.io -y`
*  set the permissions to ruin docker with
      *  `sudo usermod -aG docker $USER`
*  installed docker compose with
      *  `sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose sudo chmod +x /usr/local/bin/docker-compose sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`
*  run docker engine with
      *  `sudo service docker start`
