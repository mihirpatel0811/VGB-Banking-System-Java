# VGB Banking System

A secure digital banking platform built with Java Servlet, JSP, and MySQL for Vertex Galaxy Bank.

## Overview

VGB Banking System provides a web-based banking solution with:
- **Customer Portal**: Account management, fund transfers, statements, loan applications, and service requests
- **Admin Portal**: Customer management, loan approvals, transaction monitoring, and system oversight

## Technology Stack

| Layer | Technology |
|-------|------------|
| Build | Maven 3.x |
| Backend | Java 8, Jakarta Servlet 6.1.0 |
| Frontend | JSP, HTML5, CSS3, JavaScript |
| Database | MySQL 9.0.0 |
| Security | BCrypt (jbcrypt 0.4) |
| Logging | SLF4J 2.0.13 |
| JSON | Gson 2.11.0 |
| Testing | JUnit 5.13.2 |

## Project Structure

```
src/main/
├── java/com/vgb/
│   ├── config/          # Database configuration
│   ├── constants/       # Application constants
│   ├── dao/            # Data Access Objects
│   ├── model/          # Entity models
│   ├── service/        # Business logic layer
│   ├── servlet/        # HTTP request handlers
│   └── util/           # Utility classes
├── webapp/
│   ├── admin/          # Admin JSP pages
│   ├── customer/       # Customer JSP pages
│   ├── assest/         # CSS, JS, images
│   ├── WEB-INF/
│   │   └── web.xml     # Deployment descriptor
│   └── index.jsp       # Landing page
└── resources/
    └── vgb_database.sql # Database schema
```

## Database Schema

The system uses MySQL with the following core tables:

- **admin** - Administrator accounts
- **customer** - Customer profiles with KYC data (PAN, Aadhaar)
- **account** - Bank accounts (savings/current) with service flags
- **account_savings** / **account_current** - Sub-tables for account type details
- **transaction** - Fund transfers, deposits, withdrawals
- **loan** - Loan applications (home, car, personal, education)
- **repayment** - Loan repayment tracking
- **card** - ATM/Debit cards
- **cheque_book_request** - Cheque book service requests
- **beneficiary** - Saved beneficiaries for transfers

## Key Features

### Customer Features
- Login with username/password or PIN
- View account balances and details
- Money transfers between accounts
- Transaction statements
- Loan applications (home, car, personal, education)
- Cheque book requests
- ATM card requests
- Profile management with avatar upload

### Admin Features
- Admin login with role-based access
- View and manage customer accounts
- Approve/reject loan applications
- Monitor all transactions
- Manage ATM card requests
- Review cheque book requests

## Configuration

Database connection settings in `DatabaseConfig.java`:
- URL: `jdbc:mysql://localhost:3306/vgb_database`
- Username: `root`
- Password: `17193` (change for production)

## Build & Deployment

### Prerequisites
- Java 8 or higher
- MySQL 8.0+
- Maven 3.x
- Tomcat 9+ or compatible servlet container

### Build
```bash
mvn clean package
```

### Deploy
Deploy the generated WAR file to your servlet container:
```bash
# Tomcat webapps directory
cp target/VGB-Banking-System-1.0-SNAPSHOT.war $TOMCAT/webapps/
```

### Database Setup
```sql
source src/main/resources/vgb_database.sql
```

## API Endpoints

| Servlet | Path | Method | Description |
|---------|------|--------|-------------|
| LoginServlet | `/login` | GET, POST | User authentication |
| AccountServlet | `/account` | GET, POST | Account operations |
| CustomerDashboardServlet | `/customer-dashboard` | GET | Customer home page |
| AdminDashboardServlet | `/admin-dashboard` | GET | Admin home page |
| LoanServlet | `/loan` | GET, POST | Loan applications |
| ChequeBookServlet | `/chequebook` | GET, POST | Cheque book requests |
| CardServlet | `/card` | GET, POST | Card services |
| LogoutServlet | `/logout` | GET | Session termination |

## Security Features

- Password hashing with BCrypt
- CSRF token protection
- Session timeout (30 minutes)
- Role-based access control
- Input validation utilities

## Default Admin Credentials

```
Username: vgb@admin$17193
Password: admin@17193$
PIN: 1234
```

## License

Internal project for Vertex Galaxy Bank.