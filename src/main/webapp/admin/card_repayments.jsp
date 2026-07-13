<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<% 
    if (session.getAttribute(com.vgb.constants.AppConstants.ADMIN_SESSION_KEY) == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB Admin | Card Repayment Logs</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
    <style>
        :root {
            --primary-grad: linear-gradient(135deg, #4f46e5 0%, #3730a3 100%);
            --emerald-grad: linear-gradient(135deg, #10b981 0%, #047857 100%);
            --rose-grad: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%);
            --amber-grad: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            --card-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.08);
            --transition-smooth: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.9) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
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
            transition: var(--transition-smooth);
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
            text-decoration: none;
            transition: var(--transition-smooth);
        }

        .sidebar-menu a:hover {
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500) !important;
            transform: translateX(4px);
        }

        .sidebar-menu a.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
        }

        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: #f8fafc;
            transition: var(--transition-smooth);
        }

        .footer {
            margin-left: 280px;
            background: white;
            border-top: 1px solid rgba(99, 102, 241, 0.15);
            padding: 20px 0;
            transition: var(--transition-smooth);
        }

        @media (max-width: 991px) {
            .sidebar { left: -280px !important; }
            .sidebar.active { left: 0 !important; }
            .main-content { margin-left: 0 !important; padding: 120px 20px 40px !important; }
            .footer { margin-left: 0 !important; }
        }

        /* Glassmorphism Cards */
        .glass-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--card-shadow);
            margin-bottom: 30px;
            transition: var(--transition-smooth);
        }

        .glass-card:hover {
            box-shadow: 0 15px 35px -10px rgba(99, 102, 241, 0.12);
        }

        /* Metrics Widget Styles */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        @media (max-width: 1024px) {
            .metrics-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .metrics-grid {
                grid-template-columns: 1fr;
            }
        }

        .metric-card {
            background: white;
            border-radius: var(--radius-md);
            padding: 24px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(226, 232, 240, 0.6);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: var(--transition-smooth);
            position: relative;
            overflow: hidden;
        }

        .metric-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary-500);
        }

        .metric-card.amount::before { background: #4f46e5; }
        .metric-card.completed::before { background: #10b981; }
        .metric-card.failed::before { background: #ef4444; }
        .metric-card.total::before { background: #f59e0b; }

        .metric-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .metric-icon-wrapper {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
        }

        .metric-card.amount .metric-icon-wrapper { background: rgba(79, 70, 229, 0.08); color: #4f46e5; }
        .metric-card.completed .metric-icon-wrapper { background: rgba(16, 185, 129, 0.08); color: #10b981; }
        .metric-card.failed .metric-icon-wrapper { background: rgba(239, 68, 68, 0.08); color: #ef4444; }
        .metric-card.total .metric-icon-wrapper { background: rgba(245, 158, 11, 0.08); color: #f59e0b; }

        .metric-details h4 {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--gray-400);
            font-weight: 600;
            margin-bottom: 4px;
        }

        .metric-details .metric-value {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--gray-800);
            line-height: 1.2;
        }

        /* Modern Table styling */
        .vgb-table-container {
            border-radius: var(--radius-lg);
            border: 1px solid rgba(226, 232, 240, 0.8);
            background: white;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }

        .vgb-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .vgb-table th {
            background: #f8fafc;
            padding: 18px 24px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--gray-500);
            border-bottom: 1.5px solid var(--gray-100);
            letter-spacing: 0.75px;
        }

        .vgb-table tr {
            transition: var(--transition-smooth);
        }

        .vgb-table tr:hover td {
            background: rgba(99, 102, 241, 0.015);
        }

        .vgb-table td {
            padding: 18px 24px;
            font-size: 0.88rem;
            border-bottom: 1px solid var(--gray-50);
            color: var(--gray-700);
            vertical-align: middle;
        }

        .vgb-table tr:last-child td {
            border-bottom: none;
        }

        /* Status Badge Styling */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-badge.completed {
            background: rgba(16, 185, 129, 0.08);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.15);
        }

        .status-badge.failed {
            background: rgba(239, 68, 68, 0.08);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.15);
        }

        /* Filter Form Layout */
        .filter-form-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
            gap: 15px;
            align-items: flex-end;
        }

        @media (max-width: 991px) {
            .filter-form-grid {
                grid-template-columns: 1fr 1fr;
            }
            .filter-form-grid .form-actions {
                grid-column: span 2;
                justify-content: flex-end;
            }
        }
        @media (max-width: 576px) {
            .filter-form-grid {
                grid-template-columns: 1fr;
            }
            .filter-form-grid .form-actions {
                grid-column: span 1;
            }
        }

        .form-control {
            height: 48px;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--gray-200);
            background: white;
            font-family: inherit;
            padding: 10px 16px;
            font-size: 0.9rem;
            width: 100%;
            transition: var(--transition-smooth);
            color: var(--gray-800);
        }

        .form-control:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            outline: none;
        }

        .btn {
            height: 48px;
            padding: 12px 24px;
            border-radius: var(--radius-md);
            font-weight: 700;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: var(--transition-smooth);
            border: 1.5px solid transparent;
            text-decoration: none;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);
        }
        .btn-primary:hover {
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.35);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            border-color: var(--gray-200);
            color: var(--gray-700);
        }
        .btn-secondary:hover {
            background: var(--gray-50);
            border-color: var(--gray-300);
        }

        .btn-icon-only {
            width: 48px;
            height: 48px;
            padding: 0;
        }

        .text-mono {
            font-family: 'Share Tech Mono', monospace;
            letter-spacing: 0.5px;
            font-size: 0.95rem;
        }
    </style>
</head>
<body class="bank-home-page">
    <div class="toast-container" id="toastContainer"></div>

    <!-- Header -->
    <header class="header scrolled">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" style="background: none; border: none; font-size: 1.8rem; cursor: pointer; color: var(--gray-700);">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Admin" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500);">
                <script>
                    (function () {
                        const avatar = localStorage.getItem('admin_avatar');
                        if (avatar) {
                            document.getElementById('adminHeaderAvatar').src = avatar;
                        }
                    })();
                </script>
                <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                    <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">Root Administrator</span>
                    <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Admin Desk
                    </span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout" style="text-decoration: none;">
                <i class="bx bx-log-out"></i>
                <span>Logout</span>
            </a>
        </div>
    </header>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs" class="active"><i class="bx bx-receipt"></i> Repayment Logs</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/cash-counter"><i class="bx bx-wallet"></i> Cash Counter</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">DATABASE ACTIVE</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900);">Credit Card Repayment Audits</h1>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor and filter security logs for credit card bill payments processed system-wide.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/card-repayment?action=adminExport&search=${search}&status=${status}&startDate=${startDate}&endDate=${endDate}" class="btn btn-secondary">
                        <i class="bx bx-export" style="font-size: 1.25rem;"></i> Export Report (CSV)
                    </a>
                </div>
            </div>

            <!-- Metrics Grid -->
            <div class="metrics-grid">
                <div class="metric-card amount">
                    <div class="metric-icon-wrapper">
                        <i class="bx bx-rupee"></i>
                    </div>
                    <div class="metric-details">
                        <h4>Total Amount Repaid</h4>
                        <div class="metric-value">₹<fmt:formatNumber value="${stats.totalAmount}" pattern="#,##,##0.00" /></div>
                    </div>
                </div>
                <div class="metric-card completed">
                    <div class="metric-icon-wrapper">
                        <i class="bx bx-badge-check"></i>
                    </div>
                    <div class="metric-details">
                        <h4>Completed Payments</h4>
                        <div class="metric-value">${stats.completedCount}</div>
                    </div>
                </div>
                <div class="metric-card failed">
                    <div class="metric-icon-wrapper">
                        <i class="bx bx-error-circle"></i>
                    </div>
                    <div class="metric-details">
                        <h4>Failed Payments</h4>
                        <div class="metric-value">${stats.failedCount}</div>
                    </div>
                </div>
                <div class="metric-card total">
                    <div class="metric-icon-wrapper">
                        <i class="bx bx-history"></i>
                    </div>
                    <div class="metric-details">
                        <h4>Total Audit Entries</h4>
                        <div class="metric-value">${stats.totalCount}</div>
                    </div>
                </div>
            </div>

            <!-- Search and Filter Panel -->
            <div class="glass-card">
                <form method="get" action="${pageContext.request.contextPath}/card-repayment">
                    <input type="hidden" name="action" value="adminLogs">
                    <div class="filter-form-grid">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 0.8rem; font-weight: 600; color: var(--gray-400); display: block; margin-bottom: 6px; text-transform: uppercase;">Search logs</label>
                            <div style="position: relative;">
                                <input type="text" name="search" class="form-control" placeholder="Search customer ID, card, txn..." value="${search}" style="padding-left: 42px;">
                                <i class="bx bx-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.15rem;"></i>
                            </div>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 0.8rem; font-weight: 600; color: var(--gray-400); display: block; margin-bottom: 6px; text-transform: uppercase;">Payment Status</label>
                            <select name="status" class="form-control" style="font-weight: 600;">
                                <option value="all" ${status == 'all' ? 'selected' : ''}>All Logs</option>
                                <option value="completed" ${status == 'completed' ? 'selected' : ''}>Completed</option>
                                <option value="failed" ${status == 'failed' ? 'selected' : ''}>Failed</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 0.8rem; font-weight: 600; color: var(--gray-400); display: block; margin-bottom: 6px; text-transform: uppercase;">From Date</label>
                            <input type="date" name="startDate" class="form-control" value="${startDate}">
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 0.8rem; font-weight: 600; color: var(--gray-400); display: block; margin-bottom: 6px; text-transform: uppercase;">To Date</label>
                            <input type="date" name="endDate" class="form-control" value="${endDate}">
                        </div>

                        <div class="form-actions" style="display: flex; gap: 8px;">
                            <button type="submit" class="btn btn-primary">
                                <i class="bx bx-slider"></i> Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs" class="btn btn-secondary btn-icon-only" title="Reset Filters">
                                <i class="bx bx-refresh" style="font-size: 1.4rem;"></i>
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Table of Results -->
            <div class="vgb-table-container">
                <c:choose>
                    <c:when test="${not empty repayments}">
                        <div style="overflow-x: auto;">
                            <table class="vgb-table">
                                <thead>
                                    <tr>
                                        <th>Audit ID</th>
                                        <th>Cust ID</th>
                                        <th>Card Holder Name</th>
                                        <th>Credit Card Number</th>
                                        <th>Source Bank Account</th>
                                        <th>Reference ID</th>
                                        <th>Repayment Date</th>
                                        <th>Status</th>
                                        <th style="text-align: right;">Amount Paid</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${repayments}">
                                        <tr>
                                            <td style="font-weight: 700; color: var(--primary-600);">#${r.repaymentId}</td>
                                            <td style="font-weight: 600; color: var(--gray-500);">USR-${r.customerId}</td>
                                            <td style="text-transform: uppercase; font-weight: 600; font-size: 0.8rem; letter-spacing: 0.5px;">${r.cardHolderName}</td>
                                            <td class="text-mono">${r.getMaskedCardNumber()}</td>
                                            <td style="font-weight: 500; color: var(--gray-500);">${r.getSourceAccountNumber()}</td>
                                            <td class="text-mono" style="color: var(--primary-500); font-weight: 500;">${r.transactionReference}</td>
                                            <td style="font-weight: 500;"><fmt:formatDate value="${r.repaymentDate}" pattern="dd MMM yyyy, hh:mm a" /></td>
                                            <td>
                                                <span class="status-badge ${r.status}">
                                                    <span style="width: 5px; height: 5px; border-radius: 50%; background: currentColor; display: inline-block;"></span>
                                                    ${r.status}
                                                </span>
                                            </td>
                                            <td style="text-align: right; font-weight: 800; color: var(--gray-800); font-size: 0.95rem;">
                                                ₹ <fmt:formatNumber value="${r.amountPaid}" pattern="#,##,##0.00" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination Navigation -->
                        <c:if test="${totalPages > 1}">
                            <div style="display: flex; justify-content: center; gap: 8px; padding: 25px; border-top: 1px solid var(--gray-100); background: #f8fafc;">
                                <c:if test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs&page=${currentPage - 1}&search=${search}&status=${status}&startDate=${startDate}&endDate=${endDate}" class="btn btn-secondary" style="height: 38px; padding: 0 16px; font-size: 0.8rem;">&laquo; Prev</a>
                                </c:if>
                                
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs&page=${i}&search=${search}&status=${status}&startDate=${startDate}&endDate=${endDate}" class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}" style="height: 38px; width: 38px; padding: 0; font-size: 0.8rem; font-weight: 600;">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs&page=${currentPage + 1}&search=${search}&status=${status}&startDate=${startDate}&endDate=${endDate}" class="btn btn-secondary" style="height: 38px; padding: 0 16px; font-size: 0.8rem;">Next &raquo;</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 80px 40px; background: white;">
                            <div style="width: 80px; height: 80px; border-radius: 50%; background: rgba(99, 102, 241, 0.04); color: var(--primary-500); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 20px;">
                                <i class="bx bx-receipt"></i>
                            </div>
                            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-700);">No Repayment Logs Found</h3>
                            <p style="color: var(--gray-400); font-size: 0.9rem; margin-top: 5px; max-width: 400px; margin-left: auto; margin-right: auto;">No transaction records matched the selected filters. Double check the search input or date range.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div style="max-width: 1200px; margin: 0 auto; text-align: center;">
            <p style="font-size: 0.85rem; color: var(--gray-400); font-weight: 500;">&copy; 2026 Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Mobile Navigation Toggle
        const sidebar = document.querySelector('.sidebar');
        const mobileToggle = document.getElementById('mobileNavToggle');
        if (mobileToggle && sidebar) {
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
            });
        }

        // Show session error message if present in the page context via session transfer
        window.addEventListener('DOMContentLoaded', () => {
            const successMsg = "${success}";
            const errorMsg = "${error}";
            if (successMsg && successMsg.trim() !== "") {
                showToast(successMsg, "success");
            }
            if (errorMsg && errorMsg.trim() !== "") {
                showToast(errorMsg, "error");
            }
        });

        // Toast Helper
        function showToast(message, type = "success") {
            const container = document.getElementById('toastContainer');
            if (!container) {
                // Create container if not exists
                const cont = document.createElement('div');
                cont.className = 'toast-container';
                cont.id = 'toastContainer';
                document.body.appendChild(cont);
            }
            
            const card = document.createElement('div');
            card.className = "toast-card show " + (type === 'error' ? 'error' : '');
            
            const icon = document.createElement('i');
            icon.className = "bx " + (type === 'error' ? 'bx-error-circle' : 'bx-badge-check') + " toast-icon";
            
            const textSpan = document.createElement('span');
            textSpan.innerText = message;
            
            card.appendChild(icon);
            card.appendChild(textSpan);
            document.getElementById('toastContainer').appendChild(card);
            
            setTimeout(() => {
                card.classList.remove('show');
                setTimeout(() => card.remove(), 400);
            }, 3500);
        }
    </script>
</body>
</html>
