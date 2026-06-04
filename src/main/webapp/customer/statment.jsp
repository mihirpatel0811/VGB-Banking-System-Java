<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Financial Statements</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(99, 102, 241, 0.15);
            padding: 30px 20px;
            position: fixed;
            top: 80px;
            bottom: 0;
            left: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 14px 20px;
            color: var(--gray-600);
            font-weight: 500;
            border-radius: var(--radius-md);
            margin-bottom: 8px;
            transition: all var(--transition-normal);
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);
        }
        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: var(--gray-50);
        }
        @media (max-width: 991px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; padding: 120px 20px 20px; }
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 25px;
            box-shadow: var(--shadow-md);
            margin-bottom: 30px;
        }
        .statement-type-btn {
            padding: 12px 25px;
            font-weight: 600;
            border-radius: var(--radius-md);
            cursor: pointer;
            border: 1px solid var(--gray-200);
            background: white;
            color: var(--gray-500);
            transition: all var(--transition-normal);
        }
        .statement-type-btn.active {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            box-shadow: var(--shadow-md);
        }

        /* Print Optimized CSS */
        @media print {
            body {
                background: white;
                color: black;
            }
            .sidebar, .header, .footer, .no-print {
                display: none !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
            }
            .glass-card {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
            }
        }
        .txn-deposit {
            color: var(--accent-emerald) !important;
        }
        .txn-withdrawal {
            color: var(--secondary-500) !important;
        }
    </style>
</head>
<body class="bank-home-page">
    <div class="preloader">
        <div class="loader">
            <div class="loader-ring"></div>
            <span>VGB</span>
        </div>
    </div>

    <div class="cursor-glow"></div>

    <!-- Header -->
    <header class="header scrolled no-print">
        <a href="#" class="logo">
            <span class="logo-text">V</span>
            <span class="logo-text">G</span>
            <span class="logo-text">B</span>
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-user-circle"></i> Customer Space</span>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
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
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement" class="active"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/customer/notification.jsp"><i class="bx bx-bell"></i> Alerts</a>
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
                <button type="button" onclick="window.print()" class="btn btn-primary">
                    <span>Export Statement</span>
                    <i class="bx bx-printer"></i>
                </button>
            </div>

            <!-- Header block for Print layout -->
            <div style="display: none; border-bottom: 3px double var(--gray-300); padding-bottom: 20px; margin-bottom: 30px;" class="print-header">
                <h1 style="font-size: 2.2rem; font-weight: 800; color: #4f46e5;">VERTEX GALAXY BANK</h1>
                <p style="font-size: 0.9rem; color: #475569; margin-top: 5px;">Official Customer Transaction Statement</p>
                <div style="display: flex; justify-content: space-between; margin-top: 15px; font-size: 0.85rem; color: #64748b;">
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <span>Date Compiled: <fmt:formatDate value="${now}" pattern="dd-MM-yyyy HH:mm"/></span>
                    <span>Account Number: ${selectedAccount.accountNumber} - ${selectedAccount.accountType}</span>
                </div>
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
                        <select id="dateFilter" onchange="runFilter()" style="width: 100%; padding: 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
                            <option value="all">Full Statement</option>
                            <option value="today">Today Only</option>
                            <option value="month">Current Month</option>
                            <option value="year">Current Year</option>
                            <option value="custom">Custom Date Range</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Transaction Type</label>
                        <select id="typeFilter" onchange="runFilter()" style="width: 100%; padding: 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
                            <option value="all">All Types</option>
                            <option value="deposit">Deposits</option>
                            <option value="withdrawal">Withdrawals</option>
                            <option value="transfer">Transfers</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">Select Account</label>
                        <select id="accountFilter" onchange="switchAccount(this.value)" style="width: 100%; padding: 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none; font-weight: 600; cursor: pointer;">
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
                                <input type="date" id="startDate" onchange="runFilter()" style="width: 100%; padding: 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
                            </div>
                            <div>
                                <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 8px;">End Date</label>
                                <input type="date" id="endDate" onchange="runFilter()" style="width: 100%; padding: 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
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
                        <select id="loanSelectFilter" onchange="switchLoan(this.value)" style="width: 100%; padding: 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none; font-weight: 600; cursor: pointer;">
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
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-receipt"></i> Regular Ledger Log</h3>
                
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;" id="txnTable">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px; width: 80px;">Sr. No.</th>
                                <th style="padding: 12px 15px;">Transaction Date</th>
                                <th style="padding: 12px 15px;">Type</th>
                                <th style="padding: 12px 15px;">Description</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: right;">Credit Amount</th>
                                <th style="padding: 12px 15px; text-align: right;">Debit Amount</th>
                                <th style="padding: 12px 15px; text-align: right;">Total Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty transactions}">
                                    <c:set var="txnSr" value="0" />
                                    <c:forEach var="txn" items="${transactions}">
                                        <c:set var="txnSr" value="${txnSr + 1}" />
                                        <tr class="txn-row" data-type="${txn.transactionType}" style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-500);">${txnSr}</td>
                                            <td style="padding: 15px;">${txn.transactionDate}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                                <span class="${(txn.transactionType == 'deposit' || txn.transactionType == 'interest' || (txn.transactionType == 'transfer' && txn.toAccountId == selectedAccountId)) ? 'txn-deposit' : 'txn-withdrawal'}">${txn.transactionType}</span>
                                            </td>
                                            <td style="padding: 15px;">${txn.description}</td>
                                            <td style="padding: 15px;">
                                                <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">${txn.status}</span>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #10b981;">
                                                <c:choose>
                                                    <c:when test="${txn.transactionType == 'deposit' || txn.transactionType == 'interest' || (txn.transactionType == 'transfer' && txn.toAccountId == selectedAccountId)}">
                                                        + ₹<fmt:formatNumber value="${txn.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #ef4444;">
                                                <c:choose>
                                                    <c:when test="${txn.transactionType == 'withdrawal' || txn.transactionType == 'fee' || (txn.transactionType == 'transfer' && txn.fromAccountId == selectedAccountId)}">
                                                        - ₹<fmt:formatNumber value="${txn.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #1e3a8a;">
                                                ₹<fmt:formatNumber value="${txn.runningBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr class="txn-row">
                                        <td colspan="8" style="text-align: center; padding: 30px; color: var(--gray-400);">No transactions retrieved for this account.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Loan Repayment Ledger Table -->
            <div class="glass-card" id="loanStatement" style="display: none;">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-building-house"></i> Loan Amortization &amp; EMI Payments</h3>
                
                <c:if test="${not empty selectedLoan}">
                    <div style="background: rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md); margin-bottom: 20px; display: flex; justify-content: space-between; gap: 15px; font-size: 0.85rem;" class="loan-summary-box mobile-grid-1">
                        <div>
                            <span style="font-weight: 600; color: var(--gray-700);">Loan Type:</span> <span style="text-transform: capitalize; font-weight: 600; color: var(--primary-500);">${selectedLoan.loanType} Loan</span>
                            <span style="margin-left: 20px; font-weight: 600; color: var(--gray-700);">Total Principal:</span> <span style="font-weight: 600; color: var(--gray-900);">₹<fmt:formatNumber value="${selectedLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>
                        <div>
                            <span style="font-weight: 600; color: var(--gray-700);">Interest Rate:</span> <span style="font-weight: 600; color: var(--gray-900);">${selectedLoan.interestRate}% p.a.</span>
                            <span style="margin-left: 20px; font-weight: 600; color: var(--gray-700);">Remaining Balance:</span> <span style="font-weight: 600; color: var(--secondary-500);">₹<fmt:formatNumber value="${selectedLoan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>
                    </div>
                </c:if>

                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px; width: 80px;">Sr. No.</th>
                                <th style="padding: 12px 15px;">Payment Date</th>
                                <th style="padding: 12px 15px;">Type</th>
                                <th style="padding: 12px 15px;">Description</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: right;">Credit Amount</th>
                                <th style="padding: 12px 15px; text-align: right;">Debit Amount</th>
                                <th style="padding: 12px 15px; text-align: right;">Total Amount</th>
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
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-500);">${repaySr}</td>
                                            <td style="padding: 15px;">${repay.repaymentDate}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                                <span class="txn-deposit">Repayment</span>
                                            </td>
                                            <td style="padding: 15px;">EMI Repayment (Principal: ₹<fmt:formatNumber value="${repay.principalComponent}" minFractionDigits="2" maxFractionDigits="2"/>, Interest: ₹<fmt:formatNumber value="${repay.interestComponent}" minFractionDigits="2" maxFractionDigits="2"/>)</td>
                                            <td style="padding: 15px;">
                                                <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">COMPLETED</span>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #10b981;">
                                                + ₹<fmt:formatNumber value="${repay.amountPaid}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #ef4444;">-</td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #1e3a8a;">
                                                ₹<fmt:formatNumber value="${runningLoanBal}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                        <c:set var="runningLoanBal" value="${runningLoanBal + repay.principalComponent}" />
                                    </c:forEach>
                                    
                                    <!-- Initial Disbursal row -->
                                    <c:if test="${not empty selectedLoan}">
                                        <c:set var="repaySr" value="${repaySr + 1}" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-500);">${repaySr}</td>
                                            <td style="padding: 15px;">${selectedLoan.startDate}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                                <span class="txn-withdrawal">Disbursal</span>
                                            </td>
                                            <td style="padding: 15px;">Initial ${selectedLoan.loanType} Loan Disbursal</td>
                                            <td style="padding: 15px;">
                                                <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">COMPLETED</span>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #10b981;">-</td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #ef4444;">
                                                - ₹<fmt:formatNumber value="${selectedLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: #1e3a8a;">
                                                ₹<fmt:formatNumber value="${selectedLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-400); text-align: center;">
                                        <td colspan="8" style="padding: 30px;">No loan statement entries found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Bottom Controls (Print, hidden in print view) -->
            <div style="margin-top: 20px; display: flex; justify-content: flex-start;" class="no-print">
                <button type="button" onclick="window.print()" class="btn btn-primary">
                    <span>Export Statement</span>
                    <i class="bx bx-printer"></i>
                </button>
            </div>
        </div>
    </main>

    <footer class="footer no-print" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        window.onload = function() {
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
                if (row.cells.length < 8) return;
                const rowType = row.getAttribute('data-type') || '';
                
                // Type check
                let typeMatch = (type === 'all' || rowType === type);
                
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
    </script>
</body>
</html>
