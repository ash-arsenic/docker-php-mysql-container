all: up

prepare: 
	@echo "************************Checking For Dependecies***************************"
	
#	@sudo apt-get update
#	@sudo apt install -y docker.io
#	@sudo apt install -y docker-compose
#	@sudo systemctl enable --now docker
	
	@sudo pacman -Syu
	@sudo pacman -Syu docker
	@sudo pacman -Syu docker-compose
	@sudo systemctl enable --now docker


up: prepare
	@echo "******************************Containers Starting**************************"
	@if [ ! -d docker ]; then\
		mkdir docker;\
		if [ ! -d www ]; then\
			cd docker ;\
			mkdir www && cd ../../ ;\
		fi;\
	fi;

	@sudo cp ./index.php ./docker/www/;
	@sudo docker-compose up -d --build
	@echo "****************************Wait for 120 sec*******************************"
	@sleep 120
	@echo "****************************Write make teardown to remove the containers**************************"

teardown: down
	@echo "****************************Removing Containers*************************"
	@sudo docker-compose down
	@sudo rm -rf ./docker

down:
	@echo "****************************Stopping Containers**************************"
	@sudo docker stop apache database
