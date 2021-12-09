# Dockerized FiveM Server
This repository contains a setup for a dockerized RedM Server that can be fully customized while encuraging git workflow.

# Table of contents
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Starting](#starting)
    - [Service](#service)
  - [Pro tips](#pro-tips)
- [Going deeper](#going-deeper)

# Getting Started
The following chapter will explain how to install, configure and start the dockerized RedM server.

## Installation
In order to install the dockerized RedM server you will need a copy of this repository. Simply use the following git clone command or download a archive of this repository.
```
git clone https://github.com/bumbummen99/RedM.git
```

## Configuration
It is necessary to configure the server before you start the container. To do so you have to copy the .env.example to .env.
```
cp .env.example .env
```
Open the `.env` file with your favourite text editor and follow the instructions in the comments. Do not forget to save this file. Make sure this file does not get leaked as it will contain your private information.

You can put .cfg files into the `cfg` subfolder. These will be apended to the server.cfg template in the `docker` subfolder in ascending order. **Use this to install plugins and configure them.**

## Starting
In order to start the container you will have to use docker-compose. Simply use the following command to start the containers in the current session.
```
docker-compose up
```

You can also append the `-d` flag to start it daemonized and `docker-compose down` to stop it. It is **absolutely required** that you do understand the basics of docker and docker-compose!

### Service
You can also run the setup as a `systemd` service. To do so simply run the provided toolchain script.
```
./toolchain/install-service.sh
```
This will create and enable a .service file for the docker-compose setup. Make sure that restarting is disabled in the compose as that will be handled by systemd. Once the service is installed you can use regular service command provided by distro
```
service redm start
service redm restart
service redm stop
service redm status
watch -n1 service redm status
```

## Pro tips
If the default server.cfg does for some reason not accommodate your needs you can provide your own template. Simply copy the `server.cfg` file from the `docker` subfolder and adjust it to your needs. Once done you can link it in the docker-compose.yml.

# Going deeper
The following chapter will explain the setup in more depth so you can adjust it to your specific needs.

## Installing resources
This chapter will explain how you can install resources in the dockerized RedM server setup.

### Downloading files
In order to install resources you will have to enable and link the `resources` volume in the docker-compose file. Make sure your resources are installed and readable in this directory.

You can install resources by copy and pasting them in yor `resources` volume directory, but since it is better to manage them using a vcs like git it is preferred to install them by cloning them, using a package manager or simply submodules in a resources master repository - it is open to you how you do it.

### SQL files
Sometimes a resource does require a specific database setup. This setup will automatically search all resources **root (where fxmanifest.lua or __resource.lua is)** folder and try to extract your plugins .sql files. These files will then be applied to your MySQL database by using the initdb feature of the entrypoint - this will only work on the first run when there is **no database** in order to initialize it. If you install resources later on you will have to apply database schemes manaually.

**This does only work for static sql**. If your resource does populate or create its database in code you will have to run that routine.

WIP
