# Part 1
1. created new github repo with link in pilot
2. create a folder named website and added files for website in it
3. install docker
    *  used this website as a guide [avenueCode](https://blog.avenuecode.com/running-docker-engine-on-wsl-2)
 	  *  ran the following to install dependencies `sudo apt update && sudo apt upgrade -y
sudo apt remove docker docker-engine docker.io containerd runc
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y`
    *  added the docker repository to the source list using `sudo mkdir -p /etc/apt/keyrings` and then `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`
    *  set up the repository using `echo \ deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`
    *  installed the docker engine with `sudo apt-get update	sudo apt-get install docker-ce docker-ce-cli containerd.io -y`
    *  set the permissions to ruin docker with `sudo usermod -aG docker $USER`
    *  installed docker compose with `sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose sudo chmod +x /usr/local/bin/docker-compose sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`
    *  run docker engine with `sudo service docker start`
4.  create dockerfile in the website folder
    *  creadted Dockerfile with `vim Dockerfile`
    *  pulled nginx image with `sudo docker pull httpd`
    *  inside of the dockerfile, i used
        *  `FROM nginx:latest
            COPY ./index.html /usr/share/nginx/html/index.html`
    * built the docker image with `sudo docker build -t 3120nginx .`
    * ran image in container with `docker run -it --rm -d -p 8080:80 --name web 3120nginx`
