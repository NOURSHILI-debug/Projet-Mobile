# Projet-Mobile

GymFlow is a mobile application designed to help users manage their fitness routines and track progress.  

This project is built with **Flutter** for the frontend and **Django REST Framework** for the backend, running together using **Docker Compose**.

--- 
# Project Structure
```bash
Projet-Mobile/
│
├── backend/ # Django REST API backend
│
├── gymflow/ # Flutter mobile frontend
│
├── docker-compose.yml # Docker Compose configuration
│
└── README.md 
```

# Getting Started

## 1. clone the repo

```bash
git clone https://github.com/NOURSHILI-debug/Projet-Mobile.git

cd Projet-Mobile
```

## 2. Run backend With Docker 
```bash
docker compose build
docker compose up 
```

## 3. Debug your app in gymflow directory
```bash 
cd gymflow
code .
```
## 4. Configure your backend 
```bash
cd backend
code .
```
# Run the project 

## Run the backend
```bash
cd backend
docker compose up -d
```
### Add a superuser
now check the container id to make a superuser (admin account)
```bash
docker ps 
docker exec -it <id> /bin/bash
```
(replace <id> with the id you get from docker ps)
```bash
python manage.py createsuperuser
```
then follow the instructions

## Run the frontend
### Add .env file
```bash
cd gymflow
```
if you're using emulator
```bash
echo "BACKEND_URL=http://10.0.2.2:8000" > .env
```
if you're using chrome or any brower
```bash
echo "BACKEND_URL=http://127.0.0.1:8000" > .env
```
if you're using the phone put the pc's private ip 
```bash
echo "BACKEND_URL=http://<ip>:8000" > .env
```
now run the app using the "start debugging app" at the top right of vscode

# Usage
use the admin account you created (python manage.py createsuperuser) to login
from there you can make other accounts



