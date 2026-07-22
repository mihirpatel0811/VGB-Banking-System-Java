# 🐳 Docker Setup Guide for VGB Banking System Java

This guide provides instructions for running the **VGB Banking System** using Docker and Docker Compose.

---

## 📋 Prerequisites

Ensure you have installed:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows / Mac) or Docker Engine (Linux).
- [Docker Compose](https://docs.docker.com/compose/) (Included with Docker Desktop).

---

## 🚀 How to Run using Docker Compose (Recommended)

Running with Docker Compose sets up **MySQL 8.0** and **Apache Tomcat 10.1** automatically.

### 1. Open Terminal in Project Directory
```bash
cd "d:\InternShip Project\VGB-Banking-System-Java"
```

### 2. Start Services
Run the following command to build the Java application and launch containers:
```bash
docker compose up --build -d
```

### 3. Check Service Status
```bash
docker compose ps
```

### 4. Access the Application
Once the containers are running, open your web browser:
- **Landing Page**: [http://localhost:8080](http://localhost:8080)
- **Portal Login**: [http://localhost:8080/login.jsp](http://localhost:8080/login.jsp)
- **Customer Dashboard**: [http://localhost:8080/customer-dashboard](http://localhost:8080/customer-dashboard)
- **Admin Dashboard**: [http://localhost:8080/admin-dashboard](http://localhost:8080/admin-dashboard)

---

## 🛑 How to Stop & Clean Up

### Stop Services
```bash
docker compose stop
```

### Stop and Remove Containers & Networks
```bash
docker compose down
```

### Stop and Remove Everything (Including Database Data Volume)
```bash
docker compose down -v
```

---

## 🛠️ Individual Docker Commands (Optional)

### Build Application Image Only
```bash
docker build -t vgb-banking-app:latest .
```

### View Application Container Logs
```bash
docker logs -f vgb-banking-app
```

### View Database Container Logs
```bash
docker logs -f vgb-mysql-db
```
