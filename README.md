<div align="center">

# 🏦 Vertex Galaxy Bank (VGB)
### Enterprise Digital Banking System & Cloud-Ready Application

*A secure, modern, enterprise-grade digital banking platform built using Java 17, Jakarta Servlets 6.1, JSP, MySQL, Docker, and Maven.*

![Java](https://img.shields.io/badge/Java-SE%2017-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Jakarta Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.1-red?style=for-the-badge)
![JSP](https://img.shields.io/badge/JSP-3.0-blue?style=for-the-badge)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10.1-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2F9.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-3.x-C71A36?style=for-the-badge&logo=apachemaven)

---

### 💳 Secure • Modern • Dark Mode Ready • Dockerized • Enterprise Banking

</div>

---

# 📖 Overview

**Vertex Galaxy Bank (VGB)** is a full-stack enterprise digital banking application designed to simulate modern core banking operations.

The system follows a strict **3-Tier Layered Architecture** (Presentation ➔ Service Logic ➔ Data Access Object) to deliver security, performance, and maintainability.

The application features two complete, role-isolated portals:
- 👤 **Customer Banking Space**: Self-service portal for managing accounts, instant fund transfers, loan applications, credit card repayments, passbooks, and printing multi-page official statements.
- 👑 **Administrator Portal**: Management portal for opening new accounts, KYC verification, document paired inspection, credit card controls, loan approvals, and real-time transaction monitoring.

---

# 🌟 Key Recent Highlights & System Upgrades

- 🐳 **Full Docker Containerization**: Multi-stage build (`Maven 3.9` + `Apache Tomcat 10.1`) paired with `MySQL 8.0` container setup via Docker Compose.
- 🌓 **Instant Manual Theme System**: One-click instant switching between **Light Mode** and **Dark Mode** across all 26 JSP pages with persistence (`localStorage`) and anti-flicker script.
- 📄 **KYC & Document Upload Verification**: Comprehensive registration workflow with paired document upload (Aadhaar, PAN, Passport, Driving License, Voter ID) and paired ID number validation.
- 💳 **Card Controls & Limits Interface**: Viewport-constrained modal overlays (`max-height: 85vh`) with pinned headers/footers and smooth scrollable controls.
- 🖼️ **Profile Avatar Pipeline**: Custom profile image upload, workspace source folder synchronization, and fallback avatar handling.

---

# ✨ Core System Features

## 👤 Customer Banking Portal

### 🔐 Authentication & Security
- BCrypt Password Hashing & Salted Verification
- 4-Digit Security PIN Validation
- Session Handling & Timeout Controls
- CSRF Protection & SQL Injection Prevention via Prepared Statements

### 🏦 Account & Analytics Dashboard
- Live Account Balance & Available Funds Summary
- Total Deposits, Total Withdrawals, and Net Ledger tracking
- Recent Transaction History with Status Indicators
- Quick Action Shortcuts (Transfer, Bill Payment, Card Controls)

### 💸 Fund Transfer Engine
- Internal Account-to-Account Transfers
- Beneficiary Management (Add / Delete / Search)
- Interbank & Wire Transfers
- Instant Transaction Processing & Printable Receipts

### 📄 Professional Statement Generator
- Multi-page printable bank statements with automatic header repetition
- Print-optimized CSS rules (`@media print`) isolating statement layout
- Support for Account Statements, Loan Schedules, and Repayment Receipts

### 💳 Credit Cards & Repayments
- Card Tiers: **Classic**, **Gold**, **Platinum**, and **Royale Metallic**
- Bill Repayments (Full, Minimum Due, Custom Amount)
- Auto-Pay Recurring Instruction Setup & History Log

### 💰 Loan Management
- Product Categories: **Home**, **Personal**, **Vehicle**, **Education**
- Dynamic EMI Calculator & Interest Schedule Visualizer
- Application Submission, Status Tracking, and Repayment Ledger

### 📦 Self-Service Products
- Request Debit / Credit Cards, Cheque Books, and Passbooks
- Live Tracking of Request Approvals

---

## 👑 Administrator Portal

### 📊 Operations Dashboard
- Customer Demographics & Total System Liquidity
- Active Accounts vs. Suspended Accounts
- Pending KYC Approvals & Loan Application Badges

### 👤 Account & KYC Management
- Open New Account Wizard (5-step process)
- Document Upload Verification (Aadhaar, PAN, Passport, DL, Voter ID)
- Customer Profile Edits, Account Activation, and Suspension Controls

### 💳 Card Operations & Limits Control
- Update Daily ATM, POS, and International Usage Limits
- Activate / Freeze Cards & Manage Auto-Pay Rules

### 💰 Loan Desk
- Application Review & Risk Assessment
- Single-Click Loan Approval / Rejection with Remarks
- Interest Rate Adjustments & Repayment Audits

---

# 🏗️ Architecture

```
                                +---------------------------+
                                |   Web Client Browser      |
                                |  (Customer / Admin JSP)   |
                                +-------------+-------------+
                                              | HTTP / HTTPS
                                +-------------v-------------+
                                |  Apache Tomcat 10.1 (WAR) |
                                |  Jakarta Servlet 6.1      |
                                +-------------+-------------+
                                              |
                   +--------------------------+--------------------------+
                   |                          |                          |
        +----------v----------+    +----------v----------+    +----------v----------+
        | Controller Layer    |    |  Business Service   |    |    DAO Layer        |
        | (Servlets & Filters)| ──>|  (Service Classes)  | ──>| (CustomerDAO, etc.) |
        +---------------------+    +---------------------+    +----------+----------+
                                                                         |
                                                              +----------v----------+
                                                              |   MySQL 8.0 / 9.0   |
                                                              | (vgb_database SQL)  |
                                                              +---------------------+
```

---

# 🛠️ Technology Stack

| Component | Technology / Library | Version |
| :--- | :--- | :--- |
| **Language** | Java SE | 17 |
| **Web Runtime** | Apache Tomcat | 10.1 |
| **Servlet Specification** | Jakarta Servlet API | 6.1 |
| **View Template** | JSP / Jakarta JSTL | 3.0 |
| **Database** | MySQL Server | 8.0 / 9.0 |
| **Containerization** | Docker / Docker Compose | Latest |
| **Build Tool** | Apache Maven | 3.9+ |
| **Security & Hashing** | jBCrypt | 0.4 |
| **JSON Parser** | Google Gson | 2.11 |
| **Logging** | SLF4J + SimpleLogger | 2.0 |

---

# 🐳 Running with Docker (Recommended)

Running the project with Docker Compose automatically provisions **MySQL 8.0** and **Apache Tomcat 10.1** with the application pre-deployed as `ROOT.war`.

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.

### Quick Start Commands

```powershell
# 1. Navigate to the project directory
cd "d:\InternShip Project\VGB-Banking-System-Java"

# 2. Build and start containers
docker compose up --build -d
```

### Application URLs
- 🌐 **Landing Page**: [http://localhost:8080](http://localhost:8080)
- 🔑 **Portal Login**: [http://localhost:8080/login.jsp](http://localhost:8080/login.jsp)
- 👤 **Customer Dashboard**: [http://localhost:8080/customer-dashboard](http://localhost:8080/customer-dashboard)
- 👑 **Admin Dashboard**: [http://localhost:8080/admin-dashboard](http://localhost:8080/admin-dashboard)

### Useful Docker Commands
```powershell
# View running services
docker compose ps

# View live Tomcat logs
docker logs -f vgb-banking-app

# Stop containers
docker compose stop

# Stop and remove containers
docker compose down
```

---

# 💻 Manual Local Setup (Without Docker)

### Prerequisites
- Java JDK 17
- Apache Tomcat 10.1+
- MySQL 8.0+
- Apache Maven 3.8+

### 1. Database Setup
Execute the initialization SQL script located at:
```
src/main/resources/vgb_database.sql
```
in your local MySQL server.

### 2. Configure Credentials
Update database connection parameters in `src/main/resources/vgb_database.sql` or set environment variables:
- `DB_URL`: `jdbc:mysql://localhost:3306/vgb_database?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true`
- `DB_USER`: `root`
- `DB_PASSWORD`: `17193`

### 3. Build & Package
```powershell
mvn clean package
```

### 4. Deploy to Tomcat
Copy `target/VGB-Banking-System-1.0.war` into Tomcat's `webapps/` folder as `ROOT.war` and start Tomcat.

---

# 📂 Project Structure

```
VGB-Banking-System-Java
├── Dockerfile                  # Multi-stage Docker build config (Maven + Tomcat)
├── docker-compose.yml          # Container orchestration (Tomcat App + MySQL DB)
├── pom.xml                     # Maven project dependencies & Jakarta EE config
├── README.md                   # Project documentation
├── README_DOCKER.md            # Detailed Docker guide
└── src
    ├── main
    │   ├── java/com/vgb
    │   │   ├── config          # DatabaseConfig & Environment management
    │   │   ├── constants       # System constants & session keys
    │   │   ├── dao             # Data Access Objects (Customer, Account, Card, etc.)
    │   │   ├── model           # Domain POJOs (Customer, Loan, Transaction, etc.)
    │   │   ├── service         # Business logic services
    │   │   ├── servlet         # Servlets handling Web HTTP requests
    │   │   └── util            # Security, Encryption, and Context helpers
    │   ├── resources
    │   │   └── vgb_database.sql # Database Schema & Seed Data
    │   └── webapp
    │       ├── admin           # Admin Portal JSP pages & modals
    │       ├── customer        # Customer Portal JSP pages & forms
    │       ├── errors          # Error handlers (404.jsp, 500.jsp)
    │       ├── assest          # Stylesheets, JS scripts, images, avatars
    │       ├── WEB-INF         # web.xml servlet mappings & taglibs
    │       ├── index.jsp       # Public landing page
    │       ├── login.jsp       # Unified authentication portal
    │       └── forgot-password.jsp # Password recovery portal
```

---

# 🔑 Default Administrator Login

| Credential | Value |
| :--- | :--- |
| **Username** | `vgb@admin$17193` |
| **Password** | `admin@17193$` |
| **Security PIN** | `1234` |

---

# 📄 License

```
© Vertex Galaxy Bank (VGB)
All Rights Reserved.
This software is proprietary and confidential.
Unauthorized distribution or modification is prohibited.
```

---

<div align="center">

Made with ❤️ using Java 17, Jakarta Servlets, JSP, MySQL, and Docker

</div>