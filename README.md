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

