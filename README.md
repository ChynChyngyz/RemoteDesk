# 🖥️ Client Nexus (Remote Desktop Application)

![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Django](https://img.shields.io/badge/Backend-Django_REST-092E20?style=flat&logo=django&logoColor=white)
![WebRTC](https://img.shields.io/badge/Protocol-WebRTC-333333?style=flat&logo=webrtc&logoColor=white)
![Docker](https://img.shields.io/badge/Infrastructure-Docker-2496ED?style=flat&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)

*A secure, high-performance, cross-platform remote desktop control application inspired by AnyDesk.*


# 📌 Project Description

# Client Nexus - Remote Desktop Platform

Client Nexus is a professional, production-ready remote desktop solution inspired by AnyDesk. It provides high-performance screen streaming and remote control capabilities using a modern stack based on Flutter and Django.

## 🧱 Tech Stack

- **Backend:** Django 6.x, Django REST Framework, Django Channels (Daphne).
- **Database:** PostgreSQL 15.
- **Real-time:** WebSockets (via Redis channel layers).
- **Communication:** WebRTC with Coturn (STUN/TURN).
- **Reverse Proxy:** Nginx with WebSocket support.
- **Containerization:** Docker & Docker Compose.
- **Frontend:** Flutter (Cross-platform).

---

## 📁 Project Structure

- `back/`: Django backend project.
  - `back/`: Core settings and routing.
  - `authUser/`: Custom user model and JWT authentication.
  - `orgs/`: Organization and multi-tenancy management.
  - `agent/`: Device registration and heartbeat management.
  - `tickets/`: Support ticket system.
  - `remote/`: Remote session signaling logic.
- `front/`: Flutter client application.
- `docker-compose.yml`: Root orchestration file.
- `turnserver.conf`: TURN server configuration.
- `.env.example`: Template for environment variables.

---

## ⚙️ Environment Variables

The project uses a `.env` file for configuration. Copy `.env.example` to `.env` and fill in the values.

| Variable | Description | Example |
| :--- | :--- | :--- |
| `SECRET_KEY` | Django unique secret key | `p@ssw0rd123...` |
| `DEBUG` | Enable/Disable debug mode | `False` |
| `ALLOWED_HOSTS` | Allowed host headers | `localhost,nexus.com` |
| `DB_NAME` | PostgreSQL database name | `nexus_db` |
| `DB_USER` | Database user | `admin` |
| `DB_PASSWORD` | Database password | `********` |
| `REDIS_URL` | Redis connection URL | `redis://redis:6379/1` |
| `COTURN_SECRET` | Secret for TURN server auth | `SUPER_SECRET` |
| `DOMAIN_NAME` | Primary server domain | `nexus.example.com` |

---

## 🚀 Getting Started

### Local Development (Backend)

1. **Install dependencies:**
   ```bash
   cd back
   pip install -r requirements.txt
   ```
2. **Setup environment:**
   Create a `.env` file in the project root based on `.env.example`.
3. **Run migrations:**
   ```bash
   python manage.py migrate
   ```
4. **Start the server:**
   ```bash
   daphne -b 0.0.0.0 -p 8000 back.asgi:application
   ```

### Docker Deployment

To launch the entire stack (Database, Redis, Backend, Nginx, Coturn):

```bash
docker-compose up -d --build
```

---

## 🌐 API Endpoints

### 🔐 Authentication (`/api/v1/auth/`)
- `POST /login/`: User authentication (Phone/Password).
- `POST /token/refresh/`: Refresh JWT access token.
- `GET /me/`: Retrieve current authenticated user profile.

### 🏢 Organization & Management (`/api/v1/orgs/`)
- `GET/POST /organizations/`: Manage organizations.
- `GET/POST /users/`: Manage organization users.
- `GET/POST /devices/`: Manage registered devices.
- `GET/POST /tickets/`: Support ticketing system.

### 🤖 Agent / Device (`/api/v1/agent/`)
- `POST /register/`: Automated device registration.
- `POST /login_agent/`: Device-specific authentication.
- `POST /heartbeat/`: Regular status reporting.

---

## 🌍 Networking & Security

- **Nginx:** Acts as a reverse proxy, handling SSL termination (if configured) and upgrading HTTP connections to WebSockets for live sessions.
- **Coturn:** Essential for WebRTC communication through NAT and Firewalls.
- **JWT Auth:** Stateless authentication using `SimpleJWT`. Tokens are passed in the `Authorization: Bearer <token>` header.

## 🐳 Production Notes

1. **DEBUG:** Always set `DEBUG=False` in `.env` for production.
2. **Secrets:** Change the `SECRET_KEY` and `DB_PASSWORD` immediately.
3. **Static Files:** Run `python manage.py collectstatic` to gather assets for Nginx.
4. **SSL:** Update `nginx.conf` and `docker-compose.yml` to include certbot/Let's Encrypt for HTTPS.
