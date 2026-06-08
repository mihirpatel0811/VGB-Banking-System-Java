<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Admin Dashboard</title>
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
        .stat-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-sm);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
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
    <header class="header scrolled">
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center;">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
        </a>
        <div class="nav-actions">
            <div style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary-500);">
                <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
            </div>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="active"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="mobile-grid-1">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Admin Dashboard</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor and approve customer registrations, manage account activations, and process credit approvals.</p>
                </div>
            </div>

            <!-- Stats Rows (Action Alerts) -->
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-group"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Total Active Profiles</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${totalActiveCustomers}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-building-house"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Pending Loan Reviews</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${totalPendingLoans}</strong>
                    </div>
                </div>
                <div class="stat-card" style="background: var(--gradient-primary); color: white;">
                    <div class="stat-icon" style="background: rgba(255, 255, 255, 0.2); color: white;">
                        <i class="bx bx-shield-quarter"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; opacity: 0.85; text-transform: uppercase; font-weight: 600;">Secure System Mode</span>
                        <strong style="font-size: 1.4rem; font-weight: 700; display: block; margin-top: 5px;">AES-256 ACTIVE</strong>
                    </div>
                </div>
            </div>

            <!-- Financial Summary Header -->
            <div style="margin-bottom: 25px;">
                <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-bar-chart-square" style="color: var(--primary-500);"></i> System Summary & Financial Health
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-top: 3px;">System-wide real-time ledger metrics, asset-to-liability status, and operational summaries.</p>
            </div>

            <!-- Financial Summary Grid -->
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <!-- Total System Deposits -->
                <div class="stat-card" style="position: relative; overflow: hidden; background: white;">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-wallet"></i>
                    </div>
                    <div style="width: 100%;">
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Total System Deposits</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800); display: block; margin: 4px 0;">
                            ₹ <fmt:formatNumber value="${totalSystemDeposits}" minFractionDigits="2" maxFractionDigits="2"/>
                        </strong>
                        <div style="display: flex; gap: 10px; font-size: 0.75rem; color: var(--gray-500); border-top: 1px solid var(--gray-100); padding-top: 8px; margin-top: 8px;">
                            <span>Active Accounts: <strong>${totalAccounts}</strong></span>
                        </div>
                    </div>
                </div>

                <!-- Total System Credit -->
                <div class="stat-card" style="position: relative; overflow: hidden; background: white;">
                    <div class="stat-icon" style="background: rgba(6, 182, 212, 0.1); color: var(--accent-cyan);">
                        <i class="bx bx-credit-card"></i>
                    </div>
                    <div style="width: 100%;">
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Active Credit Issued</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800); display: block; margin: 4px 0;">
                            ₹ <fmt:formatNumber value="${totalSystemCredit}" minFractionDigits="2" maxFractionDigits="2"/>
                        </strong>
                        <div style="display: flex; gap: 10px; font-size: 0.75rem; color: var(--gray-500); border-top: 1px solid var(--gray-100); padding-top: 8px; margin-top: 8px;">
                            <span>Active Loans: <strong>${totalActiveLoans}</strong> of <strong>${totalLoans}</strong></span>
                        </div>
                    </div>
                </div>

                <!-- Total Transaction Volume -->
                <div class="stat-card" style="position: relative; overflow: hidden; background: white;">
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber);">
                        <i class="bx bx-transfer"></i>
                    </div>
                    <div style="width: 100%;">
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Ledger Transaction Volume</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800); display: block; margin: 4px 0;">
                            ₹ <fmt:formatNumber value="${totalTransactionVolume}" minFractionDigits="2" maxFractionDigits="2"/>
                        </strong>
                        <div style="display: flex; gap: 10px; font-size: 0.75rem; color: var(--gray-500); border-top: 1px solid var(--gray-100); padding-top: 8px; margin-top: 8px;">
                            <span>Total Ledger Count: <strong>${totalTransactions}</strong></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detailed Breakdowns -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <!-- User base Breakdown -->
                <div class="glass-card" style="margin-bottom: 0;">
                    <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                        <span><i class="bx bx-group" style="color: var(--primary-500);"></i> Customers & Users</span>
                        <span style="font-size: 0.8rem; background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 10px; border-radius: var(--radius-sm);">Total: ${totalCustomers}</span>
                    </h4>
                    
                    <div style="display: flex; flex-direction: column; gap: 15px;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-size: 0.9rem; color: var(--gray-600);"><i class="bx bx-badge-check" style="color: var(--accent-emerald); margin-right: 5px;"></i> Active Customer Profiles</span>
                            <span style="font-weight: 600; color: var(--gray-800);">${totalActiveCustomers}</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-size: 0.9rem; color: var(--gray-600);"><i class="bx bx-user-minus" style="color: #ef4444; margin-right: 5px;"></i> Suspended / Closed Profiles</span>
                            <span style="font-weight: 600; color: var(--gray-800);">${totalSuspendedCustomers}</span>
                        </div>
                    </div>
                </div>

                <!-- Account Type Breakdown -->
                <div class="glass-card" style="margin-bottom: 0;">
                    <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                        <span><i class="bx bx-home-alt" style="color: var(--secondary-500);"></i> Accounts Distribution</span>
                        <span style="font-size: 0.8rem; background: rgba(236, 72, 153, 0.1); color: var(--secondary-500); padding: 4px 10px; border-radius: var(--radius-sm);">Total: ${totalAccounts}</span>
                    </h4>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div style="background: var(--gray-50); padding: 12px; border-radius: var(--radius-md); border: 1px solid var(--gray-100); text-align: center;">
                            <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">Savings</span>
                            <strong style="font-size: 1.25rem; color: var(--gray-700);">${totalSavingsAccounts}</strong>
                        </div>
                        <div style="background: var(--gray-50); padding: 12px; border-radius: var(--radius-md); border: 1px solid var(--gray-100); text-align: center;">
                            <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">Current</span>
                            <strong style="font-size: 1.25rem; color: var(--gray-700);">${totalCurrentAccounts}</strong>
                        </div>
                    </div>
                </div>
            </div>



            <!-- Pending Loans Table -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-building-house"></i> Pending Loan Requests Awaiting Review</h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Loan ID</th>
                                <th style="padding: 12px 15px;">Customer ID</th>
                                <th style="padding: 12px 15px;">Loan Category</th>
                                <th style="padding: 12px 15px;">Principal Requested</th>
                                <th style="padding: 12px 15px;">Interest Rate</th>
                                <th style="padding: 12px 15px;">Term Length</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty pendingLoans}">
                                    <c:forEach var="loan" items="${pendingLoans}">
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-family: monospace;">#LN-${loan.loanId}</td>
                                            <td style="padding: 15px; font-family: monospace;">#CUST-${loan.customerId}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">${loan.loanType}</td>
                                            <td style="padding: 15px; font-weight: 600; color: var(--primary-500);">₹ <fmt:formatNumber value="${loan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="padding: 15px;">${loan.interestRate}% P.A.</td>
                                            <td style="padding: 15px;">${loan.termMonths} Months</td>
                                            <td style="padding: 15px; text-align: center; display: flex; gap: 10px; justify-content: center;">
                                                <a href="${pageContext.request.contextPath}/loan?action=approve&id=${loan.loanId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-emerald); color: var(--accent-emerald);"><i class="bx bx-check"></i> Approve</a>
                                                <a href="${pageContext.request.contextPath}/loan?action=reject&id=${loan.loanId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444;"><i class="bx bx-x"></i> Reject</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 30px; color: var(--gray-400);">No pending loan applications awaiting review.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
