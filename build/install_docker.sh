#!/bin/bash -x

if [[ "$EUID" -ne 0 ]]; then
	echo "Must run with sudo"
	exit
fi

main(){

	if [[ $1 = "--version" ]]; then
		show_versions
		exit 0
	fi

	apt-get update

	install_docker
  #install_docker_compose

	echo "logout and login"
}


install_docker(){
	# Docker
	# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce

	apt-get install \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    gnupg-agent \
	    software-properties-common -y

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

	apt-key fingerprint 0EBFCD88

	add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"


	apt-get update

	apt-get install docker-ce docker-ce-cli containerd.io -y

	# https://docs.docker.com/install/linux/linux-postinstall/
	groupadd docker
	usermod -aG docker $SUDO_USER

	# newgrp docker
	sudo -u $SUDO_USER docker run hello-world

	docker --version
}

install_docker_compose(){

	# https://docs.docker.com/compose/install/

	curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

	chmod +x /usr/local/bin/docker-compose

	# https://docs.docker.com/compose/completion/
	curl -L https://raw.githubusercontent.com/docker/compose/1.25.3/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

	docker-compose --version
}


show_versions(){
	echo "-----------------------------"
	docker --version
	docker-compose --version
}

main "$@"
