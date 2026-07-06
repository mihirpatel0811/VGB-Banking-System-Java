<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (request.getAttribute("customer") == null) {
        Long customerId = null;
        Object sessionUser = session.getAttribute(com.vgb.constants.AppConstants.USER_SESSION_KEY);
        if (sessionUser != null) {
            customerId = Long.parseLong(sessionUser.toString());
        }
        if (customerId != null) {
            try {
                com.vgb.model.Customer sessionCustomer = new com.vgb.service.CustomerService().getCustomerById(customerId);
                request.setAttribute("customer", sessionCustomer);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Financial Statements</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-bg-hover: rgba(255, 255, 255, 0.65);
            --glass-border: rgba(255, 255, 255, 0.4);
            --glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.06);
            --glass-glow: inset 0 0 20px rgba(255, 255, 255, 0.2);
            --accent-green: #10b981;
            --accent-red: #ef4444;
            --accent-blue: #3b82f6;
        }

        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.9) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border-right: 1px solid rgba(99, 102, 241, 0.15) !important;
            padding: 30px 20px;
            position: fixed;
            top: 80px;
            bottom: 0;
            left: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 18px;
            color: var(--gray-600) !important;
            font-weight: 500;
            border-radius: var(--radius-md);
            margin-bottom: 8px;
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
            border: 1px solid transparent;
        }
        .sidebar-menu a i {
            font-size: 1.25rem;
            transition: transform var(--transition-fast);
        }
        .sidebar-menu a:hover {
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500) !important;
            border-color: rgba(99, 102, 241, 0.1);
            transform: translateX(4px);
        }
        .sidebar-menu a:hover i {
            transform: scale(1.1);
        }
        .sidebar-menu a.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
            border-color: transparent;
        }
        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: var(--gray-50);
            transition: all 0.3s ease;
        }
        .footer {
            margin-left: 280px;
            background: white;
            border-top: 1px solid rgba(99, 102, 241, 0.15);
            padding: 20px 0;
            transition: all 0.3s ease;
        }
        .mobile-nav-toggle {
            display: none !important;
        }
        @media (max-width: 991px) {
            .mobile-nav-toggle {
                display: flex !important;
            }
            .sidebar {
                left: -280px !important;
                top: 80px;
                height: calc(100vh - 80px);
                z-index: 1000;
            }
            .sidebar.active {
                left: 0 !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 120px 20px 40px !important;
            }
            .footer {
                margin-left: 0 !important;
            }
        }

        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--glass-shadow), var(--glass-glow);
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
            margin-bottom: 30px;
        }
        .glass-card:hover {
            background: var(--glass-bg-hover);
            border-color: rgba(99, 102, 241, 0.25);
        }
        .btn-logout {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: var(--radius-full);
            border: 1.5px solid rgba(99, 102, 241, 0.2) !important;
            background: transparent;
            color: var(--gray-700) !important;
            transition: all var(--transition-normal);
            cursor: pointer;
            text-decoration: none;
        }
        .btn-logout:hover {
            border-color: transparent !important;
            background: var(--gradient-primary);
            color: white !important;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
            transform: translateY(-1px);
        }
        .btn-logout i {
            font-size: 1.05rem;
            transition: transform var(--transition-fast);
        }
        .btn-logout:hover i {
            transform: translateX(3px);
        }
        @media (max-width: 480px) {
            .mobile-hide {
                display: none !important;
            }
        }
        .statement-type-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            font-weight: 600;
            border-radius: var(--radius-md);
            cursor: pointer;
            border: 1px solid var(--gray-200);
            background: white;
            color: var(--gray-600);
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
        }
        .statement-type-btn i {
            font-size: 1.2rem;
        }
        .statement-type-btn.active {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
        }
        .statement-type-btn:active {
            transform: scale(0.96) !important;
        }

        .filter-select, .filter-input {
            width: 100%;
            padding: 10px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            outline: none;
            font-weight: 500;
            color: var(--gray-700);
            transition: border-color 0.2s;
        }
        .filter-select:focus, .filter-input:focus {
            border-color: var(--primary-400);
        }

        /* Ledger Table Styles */
        .ledger-table-container {
            overflow-x: auto;
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            margin-bottom: 25px;
            background: rgba(255, 255, 255, 0.6);
        }
        .ledger-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.85rem;
            margin-bottom: 0;
        }
        .ledger-table th {
            background: rgba(99, 102, 241, 0.05);
            color: var(--gray-800);
            padding: 14px 16px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
        }
        .ledger-table td {
            padding: 15px 16px;
            border-bottom: 1px solid var(--gray-100);
            color: var(--gray-700);
        }
        .ledger-table tbody tr {
            transition: background-color 0.2s;
        }
        .ledger-table tbody tr:hover {
            background-color: rgba(99, 102, 241, 0.02);
        }
        
        .txn-deposit-val {
            color: var(--accent-green) !important;
            font-weight: 700;
        }
        .txn-withdrawal-val {
            color: var(--accent-red) !important;
            font-weight: 700;
        }
        .txn-balance-val {
            font-family: 'Share Tech Mono', monospace;
            font-weight: 700;
            color: var(--gray-900);
        }
        .badge-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-status-completed {
            background: rgba(16, 185, 129, 0.1);
            color: var(--accent-green);
        }
        .badge-status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: #d97706;
        }
        .badge-status-failed {
            background: rgba(239, 68, 68, 0.1);
            color: var(--accent-red);
        }
        .badge-type {
            font-weight: 600;
            text-transform: capitalize;
        }
        .badge-type.deposit {
            color: var(--accent-green);
        }
        .badge-type.withdrawal {
            color: var(--accent-red);
        }
        .badge-type.transfer {
            color: var(--accent-blue);
        }

        .print-only {
            display: none !important;
        }

        /* Print Optimized CSS */
        @media print {
            body {
                background: white !important;
                color: black !important;
            }
            .sidebar, .header, .footer, .no-print {
                display: none !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
                width: 100% !important;
            }
            .glass-card {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                background: transparent !important;
            }
            .print-header {
                display: block !important;
            }
            .print-only {
                display: flex !important;
            }
            
            #txnTable, #regularStatement table, #loanStatement table {
                table-layout: fixed !important;
                width: 100% !important;
                border-collapse: collapse !important;
            }
            #txnTable th, #txnTable td, 
            #regularStatement table th, #regularStatement table td,
            #loanStatement table th, #loanStatement table td {
                padding: 6px 4px !important;
                font-size: 10px !important;
                white-space: normal !important;
                word-wrap: break-word !important;
                word-break: break-word !important;
            }
            
            #txnTable th:nth-child(1), #txnTable td:nth-child(1),
            #loanStatement table th:nth-child(1), #loanStatement table td:nth-child(1) { width: 5% !important; }
            #txnTable th:nth-child(2), #txnTable td:nth-child(2),
            #loanStatement table th:nth-child(2), #loanStatement table td:nth-child(2) { width: 16% !important; }
            #txnTable th:nth-child(3), #txnTable td:nth-child(3),
            #loanStatement table th:nth-child(3), #loanStatement table td:nth-child(3) { width: 8% !important; }
            #txnTable th:nth-child(4), #txnTable td:nth-child(4),
            #loanStatement table th:nth-child(4), #loanStatement table td:nth-child(4) { width: 27% !important; }
            #txnTable th:nth-child(5), #txnTable td:nth-child(5),
            #loanStatement table th:nth-child(5), #loanStatement table td:nth-child(5) { width: 8% !important; }
            #txnTable th:nth-child(6), #txnTable td:nth-child(6),
            #loanStatement table th:nth-child(6), #loanStatement table td:nth-child(6) { width: 12% !important; }
            #txnTable th:nth-child(7), #txnTable td:nth-child(7),
            #loanStatement table th:nth-child(7), #loanStatement table td:nth-child(7) { width: 12% !important; }
            #txnTable th:nth-child(8), #txnTable td:nth-child(8),
            #loanStatement table th:nth-child(8), #loanStatement table td:nth-child(8) { width: 12% !important; }

            .badge-status, .txn-deposit-val, .txn-withdrawal-val, span[style*="background"] {
                background: transparent !important;
                padding: 0 !important;
            }
        }
    </style>
</head>
<body class="bank-home-page">
    <div class="preloader">
        <div class="loader">
            <div class="loader-ring"></div>
            <div class="loader-ring-outer"></div>
            <span class="loader-watermark">VGB</span>
        </div>
    </div>

    <div class="cursor-glow"></div>

    <!-- Header -->
    <header class="header scrolled no-print">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty customer}">
                        <c:choose>
                            <c:when test="${not empty customer.avatarPath}">
                                <img src="${pageContext.request.contextPath}${customer.avatarPath}" alt="Customer Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                                    ${customer.fullName.substring(0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                            <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                            <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-green); display: inline-block;"></span>
                                Customer Space
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gray-100); color: var(--gray-500); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1.5px solid var(--gray-200);">
                            <i class="bx bx-user"></i>
                        </div>
                        <span style="font-weight: 600; color: var(--gray-700); font-size: 0.85rem;" class="mobile-hide">Customer Space</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                <i class="bx bx-log-out"></i>
                <span>Logout</span>
            </a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar no-print">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement" class="active"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Support Hotline</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">1800-VGB-BANK</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Page Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="no-print">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Transaction Ledger Statements</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Filter by date, category type, or print official bank transcripts.</p>
                </div>
                <button type="button" onclick="window.print()" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                    <span>Export Statement</span>
                    <i class="bx bx-printer"></i>
                </button>
            </div>

            <!-- Tabs Section -->
            <div style="display: flex; gap: 15px; margin-bottom: 35px;" class="no-print">
                <button class="statement-type-btn active" id="btnRegular" onclick="switchStmt('regular')"><i class="bx bx-receipt"></i> Regular Ledger Statement</button>
                <button class="statement-type-btn" id="btnLoan" onclick="switchStmt('loan')"><i class="bx bx-building-house"></i> Loan Statement</button>
            </div>

            <!-- Regular Search Filters -->
            <div class="glass-card no-print" id="regularFilters">
                <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px;"><i class="bx bx-slider"></i> Filters &amp; Query Range</h4>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;" class="mobile-grid-1">
                    <div class="form-group">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Date Range</label>
                        <select id="dateFilter" onchange="runFilter()" class="filter-select">
                            <option value="all">Full Statement</option>
                            <option value="today">Today Only</option>
                            <option value="month">Current Month</option>
                            <option value="year">Current Year</option>
                            <option value="custom">Custom Date Range</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Transaction Type</label>
                        <select id="typeFilter" onchange="runFilter()" class="filter-select">
                            <option value="all">All Types</option>
                            <option value="deposit">Deposits</option>
                            <option value="withdrawal">Withdrawals</option>
                            <option value="transfer">Transfers</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Select Account</label>
                        <select id="accountFilter" onchange="switchAccount(this.value)" class="filter-select" style="font-weight: 600; cursor: pointer;">
                            <c:forEach items="${accounts}" var="acc">
                                <option value="${acc.accountId}" ${acc.accountId == selectedAccountId ? 'selected' : ''}>
                                    ${acc.accountNumber} - ${acc.accountType} (₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group" id="customDateRangeGroup" style="display: none; grid-column: span 3; background: rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md); border: 1px dashed rgba(99, 102, 241, 0.2);">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div>
                                <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Start Date</label>
                                <input type="date" id="startDate" onchange="runFilter()" class="filter-input">
                            </div>
                            <div>
                                <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">End Date</label>
                                <input type="date" id="endDate" onchange="runFilter()" class="filter-input">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Loan Search Filters -->
            <div class="glass-card no-print" id="loanFilters" style="display: none;">
                <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px;"><i class="bx bx-slider"></i> Loan Statement Filters</h4>
                <div style="display: grid; grid-template-columns: 1fr; gap: 20px;">
                    <div class="form-group">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Select Active Loan</label>
                        <select id="loanSelectFilter" onchange="switchLoan(this.value)" class="filter-select" style="font-weight: 600; cursor: pointer;">
                            <c:choose>
                                <c:when test="${not empty customerLoans}">
                                    <c:forEach items="${customerLoans}" var="ln">
                                        <option value="${ln.loanId}" ${ln.loanId == selectedLoanId ? 'selected' : ''}>
                                            Loan ID: ${ln.loanId} - ${ln.loanType} Loan (Principal: ₹<fmt:formatNumber value="${ln.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>) - Status: ${ln.status}
                                        </option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="0">No active loans found</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Regular Transactions Ledger Table -->
            <div class="glass-card" id="regularStatement">
                <!-- Official Bank Logo & Name -->
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 15px; margin-bottom: 25px;">
                    <div>
                        <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-500); letter-spacing: 1px; line-height: 1; margin: 0;">VERTEX GALAXY BANK</h1>
                        <p style="font-size: 0.8rem; color: var(--gray-500); margin-top: 5px; font-weight: 500; margin-bottom: 0;">Always Beyond Boundaries</p>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-family: monospace; font-size: 0.85rem; color: var(--gray-500); font-weight: 700;">ACC-REF: #ACC-${selectedAccount.accountNumber}</span>
                        <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 3px; margin-bottom: 0;">Date Generated: <span id="currentDateRegular"></span></p>
                    </div>
                </div>

                <!-- Official Header Subtitle -->
                <div style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                    <span style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official Account Transaction Ledger Statement</span>
                </div>

                <!-- Details grid (Bank details vs Customer details) -->
                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);" class="mobile-grid-1">
                    <!-- Left: Bank Information -->
                    <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                        <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank Details</span>
                        <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate HQ)</strong>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers, BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code: <strong style="font-family: monospace;">VGBK0000001</strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free: 1800-VGB-BANK</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal: www.vertexgalaxybank.com</p>
                    </div>
                    
                    <!-- Right: Customer & Account Details -->
                    <div>
                        <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer &amp; Account Details</span>
                        <strong style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;">${customer.fullName}</strong>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong style="font-family: monospace;">#VGB-CUST-${customer.customerId}</strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address: ${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Account Number: <strong style="font-family: monospace;">${selectedAccount.accountNumber}</strong> (${selectedAccount.accountType} Account)</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Account Balance: <strong>₹<fmt:formatNumber value="${selectedAccount.balance}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                    <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                        <i class="bx bx-history" style="color: var(--primary-500);"></i> Transaction Ledger Log
                    </h4>
                    <button type="button" onclick="window.print()" class="btn btn-primary no-print" style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px; background: var(--gradient-primary); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                        <span>Print Document</span>
                        <i class="bx bx-printer"></i>
                    </button>
                </div>
                
                <div class="ledger-table-container">
                    <table class="ledger-table" id="txnTable">
                        <thead>
                            <tr>
                                <th style="width: 80px;">Sr. No.</th>
                                <th>Transaction Date</th>
                                <th>Type</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th style="text-align: right;">Credit Amount</th>
                                <th style="text-align: right;">Debit Amount</th>
                                <th style="text-align: right;">Running Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty transactions}">
                                    <c:set var="txnSr" value="0" />
                                    <c:forEach var="txn" items="${transactions}">
                                        <c:set var="txnSr" value="${txnSr + 1}" />
                                        <tr class="txn-row" data-type="${txn.transactionType}">
                                            <td style="font-weight: 600; color: var(--gray-500);">${txnSr}</td>
                                            <td class="txn-date">${txn.transactionDate}</td>
                                            <td>
                                                <span class="badge-type ${txn.transactionType}">${txn.transactionType}</span>
                                            </td>
                                            <td>${txn.description}</td>
                                            <td>
                                                <span class="badge-status badge-status-${txn.status.toLowerCase()}">${txn.status}</span>
                                            </td>
                                            <td style="text-align: right;">
                                                <c:choose>
                                                    <c:when test="${txn.transactionType == 'deposit' || txn.transactionType == 'interest' || (txn.transactionType == 'transfer' && txn.toAccountId == selectedAccountId)}">
                                                        <span class="txn-deposit-val">+ ₹<fmt:formatNumber value="${txn.amount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;">
                                                <c:choose>
                                                    <c:when test="${txn.transactionType == 'withdrawal' || txn.transactionType == 'fee' || (txn.transactionType == 'transfer' && txn.fromAccountId == selectedAccountId)}">
                                                        <span class="txn-withdrawal-val">- ₹<fmt:formatNumber value="${txn.amount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;" class="txn-balance-val">
                                                ₹<fmt:formatNumber value="${txn.runningBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr class="txn-row">
                                        <td colspan="8" style="text-align: center; padding: 35px; color: var(--gray-400);">No transactions retrieved for this account.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Footer Signatures (print only) -->
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px;" class="print-only">
                    <div style="text-align: center; width: 200px;">
                        <div style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;"></div>
                        <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Authorized Signatory</span>
                    </div>
                    <div style="text-align: center; width: 200px;">
                        <div style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;"></div>
                        <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">System Generated Seals</span>
                    </div>
                </div>
            </div>

            <!-- Loan Repayment Ledger Table -->
            <div class="glass-card" id="loanStatement" style="display: none;">
                <!-- Official Bank Logo & Name -->
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 15px; margin-bottom: 25px;">
                    <div>
                        <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-500); letter-spacing: 1px; line-height: 1; margin: 0;">VERTEX GALAXY BANK</h1>
                        <p style="font-size: 0.8rem; color: var(--gray-500); margin-top: 5px; font-weight: 500; margin-bottom: 0;">Always Beyond Boundaries</p>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-family: monospace; font-size: 0.85rem; color: var(--gray-500); font-weight: 700;">LN-REF: #LN-${selectedLoan.loanId}</span>
                        <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 3px; margin-bottom: 0;">Date Generated: <span id="currentDateLoan"></span></p>
                    </div>
                </div>

                <!-- Official Header Subtitle -->
                <div style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                    <span style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official Loan Amortization &amp; Repayment Statement</span>
                </div>

                <c:set var="totalRepaid" value="0.0" />
                <c:if test="${not empty repayments}">
                    <c:forEach var="rpy" items="${repayments}">
                        <c:set var="totalRepaid" value="${totalRepaid + rpy.amountPaid}" />
                    </c:forEach>
                </c:if>

                <!-- Details grid (Bank details vs Customer details) -->
                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);" class="mobile-grid-1">
                    <!-- Left: Bank Information -->
                    <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                        <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank Details</span>
                        <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate HQ)</strong>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers, BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code: <strong style="font-family: monospace;">VGBK0000001</strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free: 1800-VGB-BANK</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal: www.vertexgalaxybank.com</p>
                    </div>
                    
                    <!-- Right: Customer & Loan Details -->
                    <div>
                        <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer &amp; Loan Details</span>
                        <strong style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;">${customer.fullName}</strong>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong style="font-family: monospace;">#VGB-CUST-${customer.customerId}</strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address: ${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Loan Reference: <strong style="font-family: monospace;">#LN-${selectedLoan.loanId}</strong> (${selectedLoan.loanType} Loan)</p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Principal Amount: <strong>₹<fmt:formatNumber value="${selectedLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Interest Rate / Term: <strong>${selectedLoan.interestRate}% P.A. / ${selectedLoan.termMonths} Mos</strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Accumulated Repaid: <strong style="color: var(--accent-green);">₹<fmt:formatNumber value="${totalRepaid}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                        <p style="margin: 4px 0 0; color: var(--gray-600);">Outstanding Balance: <strong style="color: var(--accent-red);">₹<fmt:formatNumber value="${selectedLoan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                    <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                        <i class="bx bx-history" style="color: var(--primary-500);"></i> Repayment Ledger Log
                    </h4>
                    <button type="button" onclick="window.print()" class="btn btn-primary no-print" style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px; background: var(--gradient-primary); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                        <span>Print Document</span>
                        <i class="bx bx-printer"></i>
                    </button>
                </div>
                
                <div class="ledger-table-container">
                    <table class="ledger-table">
                        <thead>
                            <tr>
                                <th style="width: 80px;">Sr. No.</th>
                                <th>Payment Date</th>
                                <th>Type</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th style="text-align: right;">Credit Amount</th>
                                <th style="text-align: right;">Debit Amount</th>
                                <th style="text-align: right;">Outstanding Principal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty repayments || not empty selectedLoan}">
                                    <c:set var="repaySr" value="0" />
                                    <c:set var="runningLoanBal" value="${selectedLoan.remainingBalance}" />
                                    
                                    <!-- Repayment rows -->
                                    <c:forEach var="repay" items="${repayments}">
                                        <c:set var="repaySr" value="${repaySr + 1}" />
                                        <tr>
                                            <td style="font-weight: 600; color: var(--gray-500);"><span class="badge-id">#${repaySr}</span></td>
                                            <td class="txn-date">${repay.repaymentDate}</td>
                                            <td>
                                                <span class="badge-type deposit">Repayment</span>
                                            </td>
                                            <td>EMI Repayment (Principal: ₹<fmt:formatNumber value="${repay.principalComponent}" minFractionDigits="2" maxFractionDigits="2"/>, Interest: ₹<fmt:formatNumber value="${repay.interestComponent}" minFractionDigits="2" maxFractionDigits="2"/>)</td>
                                            <td>
                                                <span class="badge-status badge-status-completed">COMPLETED</span>
                                            </td>
                                            <td style="text-align: right;" class="txn-deposit-val">
                                                + ₹<fmt:formatNumber value="${repay.amountPaid}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="text-align: right;">-</td>
                                            <td style="text-align: right;" class="txn-balance-val">
                                                ₹<fmt:formatNumber value="${runningLoanBal}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                        <c:set var="runningLoanBal" value="${runningLoanBal + repay.principalComponent}" />
                                    </c:forEach>
                                    
                                    <!-- Initial Disbursal row -->
                                    <c:if test="${not empty selectedLoan}">
                                        <c:set var="repaySr" value="${repaySr + 1}" />
                                        <tr>
                                            <td style="font-weight: 600; color: var(--gray-500);"><span class="badge-id">#${repaySr}</span></td>
                                            <td class="txn-date">${selectedLoan.startDate}</td>
                                            <td>
                                                <span class="badge-type withdrawal">Disbursal</span>
                                            </td>
                                            <td>Initial ${selectedLoan.loanType} Loan Disbursal</td>
                                            <td>
                                                <span class="badge-status badge-status-completed">COMPLETED</span>
                                            </td>
                                            <td style="text-align: right;">-</td>
                                            <td style="text-align: right;" class="txn-withdrawal-val">
                                                - ₹<fmt:formatNumber value="${selectedLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="text-align: right;" class="txn-balance-val">
                                                ₹<fmt:formatNumber value="${selectedLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <tr style="text-align: center;">
                                        <td colspan="8" style="padding: 35px; color: var(--gray-400);">No loan statement entries found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Footer Signatures (print only) -->
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px;" class="print-only">
                    <div style="text-align: center; width: 200px;">
                        <div style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;"></div>
                        <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Authorized Signatory</span>
                    </div>
                    <div style="text-align: center; width: 200px;">
                        <div style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;"></div>
                        <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">System Generated Seals</span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer no-print">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        window.onload = function() {
            // Populate generated dates dynamically
            const currentDateStr = new Date().toLocaleDateString('en-IN', {
                day: '2-digit',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
            const rDateSpan = document.getElementById('currentDateRegular');
            if (rDateSpan) rDateSpan.innerText = currentDateStr;
            const lDateSpan = document.getElementById('currentDateLoan');
            if (lDateSpan) lDateSpan.innerText = currentDateStr;

            // Format dates inside lists beautifully
            document.querySelectorAll('.txn-date').forEach(el => {
                const rawVal = el.innerText.trim();
                if (rawVal) {
                    const normalizedStr = rawVal.replace('T', ' ');
                    const dateObj = new Date(normalizedStr);
                    if (!isNaN(dateObj.getTime())) {
                        el.innerText = dateObj.toLocaleDateString('en-IN', {
                            day: '2-digit',
                            month: 'short',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit',
                            hour12: true
                        });
                    }
                }
            });

            // Initialize active tab from query params
            const urlParams = new URLSearchParams(window.location.search);
            const tab = urlParams.get('tab');
            if (tab === 'loan') {
                switchStmt('loan');
            } else {
                switchStmt('regular');
            }
        };

        function switchStmt(type) {
            document.getElementById('btnRegular').classList.remove('active');
            document.getElementById('btnLoan').classList.remove('active');

            document.getElementById('regularStatement').style.display = 'none';
            document.getElementById('loanStatement').style.display = 'none';
            document.getElementById('regularFilters').style.display = 'none';
            document.getElementById('loanFilters').style.display = 'none';

            if (type === 'regular') {
                document.getElementById('btnRegular').classList.add('active');
                document.getElementById('regularStatement').style.display = 'block';
                document.getElementById('regularFilters').style.display = 'block';
            } else {
                document.getElementById('btnLoan').classList.add('active');
                document.getElementById('loanStatement').style.display = 'block';
                document.getElementById('loanFilters').style.display = 'block';
            }
        }

        function switchAccount(accountId) {
            window.location.href = '${pageContext.request.contextPath}/account?action=statement&accountId=' + accountId + '&tab=regular';
        }

        function switchLoan(loanId) {
            window.location.href = '${pageContext.request.contextPath}/account?action=statement&loanId=' + loanId + '&tab=loan';
        }

        function runFilter() {
            const dateVal = document.getElementById('dateFilter').value;
            const customGroup = document.getElementById('customDateRangeGroup');
            if (customGroup) {
                if (dateVal === 'custom') {
                    customGroup.style.display = 'block';
                } else {
                    customGroup.style.display = 'none';
                }
            }
            
            const type = document.getElementById('typeFilter').value;
            const rows = document.querySelectorAll('.txn-row');
            
            const now = new Date();
            const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
            const startOfYear = new Date(now.getFullYear(), 0, 1);
            
            let customStart = null;
            let customEnd = null;
            if (dateVal === 'custom') {
                const sVal = document.getElementById('startDate').value;
                const eVal = document.getElementById('endDate').value;
                if (sVal) {
                    customStart = new Date(sVal);
                    customStart.setHours(0, 0, 0, 0);
                }
                if (eVal) {
                    customEnd = new Date(eVal);
                    customEnd.setHours(23, 59, 59, 999);
                }
            }
            
            rows.forEach(row => {
                // Skips empty state row
                if (row.cells.length < 8) return;
                const rowType = row.getAttribute('data-type') || '';
                
                // Type check
                const typeMatch = (type === 'all' || rowType === type);
                
                // Date check
                let dateMatch = true;
                const dateCellText = row.cells[1].innerText.trim();
                if (dateCellText) {
                    const normalizedDateStr = dateCellText.replace('T', ' ');
                    const txnDate = new Date(normalizedDateStr);
                    
                    if (!isNaN(txnDate.getTime())) {
                        if (dateVal === 'today') {
                            dateMatch = (txnDate >= startOfToday);
                        } else if (dateVal === 'month') {
                            dateMatch = (txnDate >= startOfMonth);
                        } else if (dateVal === 'year') {
                            dateMatch = (txnDate >= startOfYear);
                        } else if (dateVal === 'custom') {
                            if (customStart && txnDate < customStart) {
                                dateMatch = false;
                            }
                            if (customEnd && txnDate > customEnd) {
                                dateMatch = false;
                            }
                        }
                    }
                }
                
                if (typeMatch && dateMatch) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            // Mobile sidebar toggle handler
            const mobileToggle = document.getElementById('mobileNavToggle');
            const sidebar = document.querySelector('.sidebar');
            if (mobileToggle && sidebar) {
                mobileToggle.addEventListener('click', (e) => {
                    e.stopPropagation();
                    sidebar.classList.toggle('active');
                    const icon = mobileToggle.querySelector('i');
                    if (sidebar.classList.contains('active')) {
                        icon.className = 'bx bx-x';
                    } else {
                        icon.className = 'bx bx-menu';
                    }
                });
                
                // Close sidebar if clicking outside
                document.addEventListener('click', (e) => {
                    if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                        sidebar.classList.remove('active');
                        mobileToggle.querySelector('i').className = 'bx bx-menu';
                    }
                });
            }
        });
    </script>
</body>
</html>
