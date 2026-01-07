# Projet-Mobile

GymFlow is a mobile application designed to help users manage their fitness routines and track progress.  

This project is built with **Flutter** for the frontend and **Django REST Framework** for the backend, running together using **Docker Compose**.

--- 
# Project Structure
```bash
Projet-Mobile/
│
├── backend/                      # Django backend (API + WebSocket)
│   ├── backend/                  # Django project config
│   │   ├── settings.py           # Global Django settings
│   │   ├── urls.py               # Root URL routing
│   │   ├── asgi.py               # ASGI entry (WebSockets / Channels)
│   │   └── wsgi.py               # WSGI entry (HTTP)
│   │
│   ├── users/                    # Users & authentication domain
│   │   ├── models.py             # Custom User model
│   │   ├── serializers.py        # DRF serializers
│   │   ├── views.py              # API views (login, profile, roles)
│   │   ├── permissions.py        # Custom permission classes
│   │   └── urls.py               # User-related endpoints
│   │
│   ├── chat/                     # Real-time chat feature
│   │   ├── models.py             # Message model
│   │   ├── consumers.py          # WebSocket consumers (Django Channels)
│   │   ├── routing.py            # WebSocket routes
│   │   ├── views.py              # REST endpoints (history, rooms)
│   │   └── urls.py               # Chat API routes
│   │
│   ├── media/                    # Uploaded files (profile images)
│   │   └── profiles/
│   │
│   ├── db.sqlite3                # Development database
│   ├── manage.py                 # Django CLI entry
│   ├── requirements.txt          # Python dependencies
│   └── Dockerfile                # Backend container definition
│
├── gymflow/                      # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart              # App entry point
│   │
│   │   ├── screens/               # UI screens (pages)
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── root_shell.dart    # Bottom navigation shell
│   │   │   └── dashboard/
│   │   │       ├── home_screen.dart
│   │   │       ├── profile_screen.dart
│   │   │       ├── progress_screen.dart
│   │   │       ├── schedule_screen.dart
│   │   │       ├── Chat/
│   │   │       │   ├── chat_screen.dart
│   │   │       │   └── chat_room_screen.dart
│   │   │       └── Manage_Members/
│   │   │           ├── add_member_screen.dart
│   │   │           └── manage_users_screen.dart
│   │
│   │   ├── services/              # Business logic & API calls
│   │   │   ├── auth_service.dart  # Auth + token handling
│   │   │   └── chat_service.dart  # REST + WebSocket chat logic
│   │
│   │   ├── widgets/               # Reusable UI components
│   │   │   ├── custom_navbar.dart
│   │   │   ├── text_field.dart
│   │   │   ├── button.dart
│   │   │   └── logout_alert.dart
│   │
│   │   └── utils/                 # Helpers & utilities
│   │       ├── token_storage.dart # Secure token persistence
│   │       └── user_utils.dart    # User-related helpers
│   │
│   └── pubspec.yaml               # Flutter dependencies & assets
│
├── docker-compose.yml             # Orchestrates backend services
│
└── README.md                      # Project documentation

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



