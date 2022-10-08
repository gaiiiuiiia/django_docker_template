## Template for dockerized django application

#### how to use:
pull this repo to your machine

copy the docker/.env.dist file to the docker/.env file. this file contains a lot of project settings. 


for the first time, when you up containers, 
you should comment docker-volumes directives in docker/docker-compose.yaml file 
for static and media in app and webserver services.
It is important because if you are not comment volumes, they will be created by root user.
After first container start you can uncomment volumes.

run "docker-compose -f ./docker/docker-compose.yaml build"
or simply "make dc_build"

after that up containers.

run "make dc_up"

at first time when containers were being created, the ${APP_FOLDER} directory was created. (see the docker/.env file)

go to the ${APP_FOLDER}/app/settings and copy the secrets_template.py to secrets.py at the same directory.
fill secrets with your secret datas and restart containers running "make dc_down && make dc_up"
