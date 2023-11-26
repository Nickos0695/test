# test

# Choix techniques
- Docker pour la mise en place de l'environnement de développement ainsi que pour le déploiement
- Go pour le backend - API REST - avec le framework [Gin] qui facilite la création de l'API
- Flutter pour le frontend - Application web

# Sommaire
- [Docker](#docker)
    - [Prérequis](#prérequis)
    - [Installation](#installation)
    - [Utilisation](#utilisation)
- [Backend](#backend)
    - [Prérequis](#prérequis-1)
    - [Installation](#installation-1)
    - [Utilisation](#utilisation-1)
        - [Routes](#routes)
        - [Modèle](#modèle)
        - [Exemple](#exemple)
- [Frontend](#frontend)
    - [Prérequis](#prérequis-2)
    - [Installation](#installation-2)
    - [Utilisation](#utilisation-2)

# Docker
## Prérequis
- [Docker](https://docs.docker.com/install/) version 19.03.5 ou supérieur
- [Docker-compose](https://docs.docker.com/compose/install/) version 1.25.0 ou supérieur

## Installation
- Cloner le projet
- Se placer dans le dossier test
- Lancer la commande `docker-compose up -d`

## Utilisation
- Le serveur est accessible sur le port 3567
- L'app est accessible sur le port 80

# Backend
## Prérequis
- [Go](https://golang.org/dl/) version 1.19 ou supérieur

## Installation
- Cloner le projet dans le dossier test de votre GOPATH
- Se placer dans le dossier backend
- Lancer la commande `go run .`
- Le serveur est accessible sur le port 3567

## Utilisation
### Routes
- GET /api/v1/notes : Récupère toutes les notes
- GET /api/v1/notes/{id} : Récupère une note par son id
- POST /api/v1/notes : Créer une note
- PUT /api/v1/notes/{id} : Modifie une note
- DELETE /api/v1/notes/{id} : Supprime une note

### Modèle
```json
{
    "id": "int",
    "title": "string",
    "text": "string"
}
```

### Exemple
- GET /api/v1/notes
```json
[
    {
        "id": 1,
        "title": "Note 1",
        "text": "Texte de la note 1"
    },
    {
        "id": 2,
        "title": "Note 2",
        "text": "Texte de la note 2"
    }
]
```

# Frontend
## Prérequis
- [Flutter](https://flutter.dev/docs/get-started/install) version 1.12.13 ou supérieur

## Installation
- Cloner le projet dans le dossier test de votre GOPATH
- Se placer dans le dossier frontend
- Lancer la commande `flutter run -d chrome`
- L'app est accessible sur la page chrome qui vient de s'ouvrir

## Utilisation
- Créer une note
- Modifier une note
- Supprimer une note
