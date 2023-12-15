# Objectives
* Implement semantic versioning for images using git tag metadata in Actions
* Use webhooks to keep production up to date
![diagram](placeholder)
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
## restart script
![image of pulling script](https://github.com/WSU-kduncan/f23cicd-mkieselhorst/blob/main/imagepuller.png)
1. the script uses the first line of `#!bin/sudo bash`
  1. this is because it runs the following commands as sudo
2. it then runs`docker stop ceg3120`
  1. this is to ensure the container with the name of "ceg3120" is stopped before continuing
3. then it uses `docker rm ceg3120`
  1. this is to remove the old container image, and to just free up space if they are just being replaced
4. then runs `docker image pull kxwell/ceg3120:latest`
  1. to pull the newest image of the repo using the tag `:latest`
5. runs `docker run -d -p 8080:80 --name ceg3120 kxwell/ceg3120:latest`
  1. to run the container on port 8080, using the name "ceg3120" to identify it for the next time the script is run, and then defines the image
## webhook
### installation
* `sudo apt-get install webhook`
* in `/etc/webhook.conf` i entered this as my code as my definition file:
  ![webhook definition file](placeholder)
* it defines the command to execute, working dir, repsoinse message, then looks for matching payloads sent to the working webhook. If there is one, and it supplies the necessary secret, then it runs the script defined earlier
* created a new dir in home called hooks, then another called ceg3120 inside of that
* the file should be located in `/etc/`
* then inside ceg3120/ i moved the `imagepuller` script
* created another dir but this time in `/var/` called `ceg3120` which is designated as the working dir in the webhook.conf file
* to run it, i used `/usr/bin/webhook -nopanic -hooks /etc/webhook.conf`
* after that, it was setup on my instance ip, and port 9000
### configuration in github
* in github repo, go to settings, webhooks, and create new webhook
* here, enter in the address, and name it, then supply the secret
* then select the settings to apply it ( just set to deploy on run)
### Proof
* recorded video of proof submitted on pilot.
