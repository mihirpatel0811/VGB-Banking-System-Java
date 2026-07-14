<div align="center">

# 🏦 Vertex Galaxy Bank (VGB)
### Enterprise Digital Banking System

*A secure, modern, enterprise-grade digital banking platform built using Java Servlets, JSP, MySQL, and Maven.*

![Java](https://img.shields.io/badge/Java-SE%208+-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-3.0+-blue?style=for-the-badge)
![Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.1-red?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-9.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-3.x-C71A36?style=for-the-badge&logo=apachemaven)
![License](https://img.shields.io/badge/License-Proprietary-darkgreen?style=for-the-badge)

---

### 💳 Secure • Modern • Scalable • Enterprise Banking Platform

</div>

---

# 📖 Overview

**Vertex Galaxy Bank (VGB)** is a full-stack enterprise digital banking application that simulates a modern online banking platform.

The application follows a **3-Tier Layered Architecture**, separating the presentation layer, business logic layer, and persistence layer to improve scalability, maintainability, and security.

The system contains two dedicated workspaces:

- 👤 Customer Banking Portal
- 👑 Administrator Portal

Customers can manage bank accounts, transfer funds, apply for loans, repay credit cards, print official statements, and request banking products.

Administrators manage customer KYC, approve loans, monitor transaction activities, manage cards, cheque books, and oversee the entire banking ecosystem.

---

# ✨ Core Features

## 👤 Customer Portal

### 🔐 Authentication

- Secure Login
- BCrypt Password Encryption
- Secure PIN Authentication
- Forgot Password
- Session Timeout
- CSRF Protection

---

### 🏦 Banking Dashboard

- Customer Overview
- Account Balance
- Available Balance
- Total Deposits
- Total Withdrawals
- Recent Transactions
- Account Analytics

---

### 💸 Fund Transfer

- Transfer Between Accounts
- Add Beneficiary
- Bank-to-Bank Transfer
- Instant Transaction Processing
- Transaction Receipt
- Transfer History

---

### 📄 Transaction Statements

Professional printable statements featuring:

- Multi-page Printing
- Automatic Letterhead
- Page Header Repeating
- Print Optimized Layout
- PDF Friendly Design
- Loan Statement Printing

---

### 💳 Credit Card Services

Supports multiple card categories:

- Classic Card
- Gold Card
- Platinum Card
- Royale Metallic Card

Functions:

- Bill Payment
- Auto Bill Payment
- Payment History
- Printable Receipts
- Due Tracking

---

### 💰 Loan Center

Available Loans

- Home Loan
- Personal Loan
- Car Loan
- Education Loan

Features

- Apply Loan
- EMI Calculator
- Interest Schedule
- Repayment History
- Loan Statement
- Outstanding Balance

---

### 📦 Banking Services

Request:

- Debit Card
- Credit Card
- Cheque Book
- Passbook

Track request status in real time.

---

### 👤 Profile Management

- Edit Profile
- Upload Avatar
- Change Password
- Update Contact Details
- Security PIN Management

---

# 👑 Admin Portal

## Dashboard

- Customer Statistics
- Banking Analytics
- Loan Statistics
- Transaction Summary
- Pending Requests
- Active Accounts

---

## Customer Management

- View Customers
- Search Customers
- Update Customer
- Activate / Suspend Account
- Delete Customer

---

## KYC Management

- Verify Documents
- Approve KYC
- Reject KYC
- View Uploaded Documents

---

## Loan Management

- Review Applications
- Approve Loan
- Reject Loan
- Interest Assignment
- Repayment Monitoring

---

## Transaction Monitoring

Live monitoring of

- Deposits
- Withdrawals
- Transfers
- Loan Payments
- Credit Card Payments

---

## Banking Operations

Manage

- Debit Cards
- Credit Cards
- Cheque Books
- Passbooks

---

# 🏗️ System Architecture

```
                    +----------------------+
                    |    Customer Portal   |
                    +----------+-----------+
                               |
                    +----------v-----------+
                    |   Java Servlets      |
                    |  Controller Layer    |
                    +----------+-----------+
                               |
                    +----------v-----------+
                    |   Service Layer      |
                    | Business Logic       |
                    +----------+-----------+
                               |
                    +----------v-----------+
                    |     DAO Layer        |
                    | Data Access Objects  |
                    +----------+-----------+
                               |
                    +----------v-----------+
                    |      MySQL DB        |
                    +----------------------+
```

---

# 🛠 Technology Stack

| Layer | Technology |
|----------|----------------|
| Language | Java SE 8+ |
| Frontend | HTML5, CSS3, JavaScript |
| View Engine | JSP |
| Controller | Jakarta Servlet 6.1 |
| Backend | Java |
| Database | MySQL |
| Build Tool | Maven |
| JSON | Gson |
| Logging | SLF4J |
| Encryption | BCrypt |
| Testing | JUnit |

---

# 📂 Project Structure

```
VGB-Banking-System-Java
│
├── src
│
├── main
│   ├── java
│   │
│   └── com.vgb
│       ├── config
│       ├── constants
│       ├── dao
│       ├── model
│       ├── service
│       ├── servlet
│       └── util
│
├── resources
│   └── vgb_database.sql
│
├── webapp
│   ├── admin
│   ├── customer
│   ├── assets
│   ├── WEB-INF
│   └── index.jsp
│
└── pom.xml
```

---

# 🗄 Database Configuration

Database

```
vgb_database
```

Connection

```java
jdbc:mysql://localhost:3306/vgb_database
```

Username

```
root
```

Password

```
17193
```

---

# ⚙ Installation

## Clone Repository

```bash
git clone https://github.com/yourusername/VGB-Banking-System-Java.git
```

---

## Build

```bash
mvn clean package
```

---

## Deploy

Copy the generated WAR file

```
target/VGB-Banking-System.war
```

into

```
Tomcat/webapps/
```

Start Tomcat

```
http://localhost:8080/VGB-Banking-System
```

---

# 🛡 Security Features

- BCrypt Password Encryption
- Secure PIN Authentication
- CSRF Protection
- SQL Injection Prevention
- Prepared Statements
- Session Timeout
- Role-Based Access Control
- Authentication Filter
- Authorization Filter
- Input Validation
- Secure File Upload
- Audit Logs
- Print Isolation Styles

# 🚀 Future Enhancements

- Mobile Banking App
- UPI Integration
- QR Payments
- Internet Banking
- Face Recognition Login
- Fingerprint Authentication
- Email Notifications
- SMS OTP
- Investment Dashboard
- Fixed Deposit Module
- Recurring Deposit
- AI Chat Assistant
- Banking Analytics
- Multi-language Support
- Dark / Light Theme

---

# 📊 Project Highlights

✅ Enterprise Architecture

✅ 3-Tier Layer Design

✅ Responsive UI

✅ Secure Authentication

✅ Role-Based Access

✅ Loan Management

✅ Credit Card Management

✅ Transaction Monitoring

✅ Printable Statements

✅ Banking Product Requests

✅ Modern Banking Workflow

---

# 👨‍💻 Default Administrator Login

| Field | Value |
|----------|----------------|
| Username | `vgb@admin$17193` |
| Password | `admin@17193$` |
| Secure PIN | `1234` |

---

# 🤝 Contributing

This repository is intended for internal development.

If contributions are allowed in the future:

```bash
Fork Repository

Create Branch

Commit Changes

Push Changes

Create Pull Request
```

---

# 📄 License

```
© Vertex Galaxy Bank

All Rights Reserved.

This software is proprietary and confidential.
Unauthorized distribution or modification is prohibited.
```

---

<div align="center">

## ⭐ If you like this project, consider giving it a Star!

Made with ❤️ using Java, JSP, Servlets & MySQL

</div>