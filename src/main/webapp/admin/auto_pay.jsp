<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Admin Auto Pay Registry</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
    <style>
        .tabs-header {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            border-bottom: 1.5px solid var(--gray-200);
            padding-bottom: 10px;
        }
        .tab-btn {
            padding: 10px 20px;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-500);
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tab-btn:hover {
            color: var(--primary-500);
        }
        .tab-btn.active {
            color: var(--primary-500);
            border-bottom-color: var(--primary-500);
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .stat-card-vertical {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .stat-card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .autopay-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: var(--radius-full);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .autopay-status-badge.active {
            background: #e6f4ea;
            color: #137333;
        }
        .autopay-status-badge.paused {
            background: #fef3c7;
            color: #d97706;
        }
        .autopay-status-badge.disabled {
            background: #fde8e8;
            color: #c81e1e;
        }
        .autopay-status-badge.completed {
            background: #e6f4ea;
            color: #137333;
        }
        .autopay-status-badge.failed {
            background: #fde8e8;
            color: #c81e1e;
        }
        .text-completed {
            color: var(--accent-emerald);
        }
        .text-failed {
            color: var(--gray-500);
        }
        .text-normal-gray {
            color: var(--gray-600);
        }
        .text-error-red {
            color: #b91c1c;
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
    <header class="header scrolled">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Admin Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                    <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">Root Administrator</span>
                    <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Admin Workspace
                    </span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                <i class="bx bx-log-out"></i>
                <span>Logout</span>
            </a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs"><i class="bx bx-receipt"></i> Repayment Logs</a>
            <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard" class="active"><i class="bx bx-sync"></i> Auto Pay Registry</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/cash-counter"><i class="bx bx-wallet"></i> Cash Counter</a>
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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Auto Pay Registry</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer auto-pay configurations, inspect batch execution schedules, and view transaction history logs.</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/auto-pay?action=adminTriggerProcessor" class="btn btn-primary" style="padding: 10px 20px; font-weight: 700; border-radius: var(--radius-md); display: inline-flex; align-items: center; gap: 8px; text-decoration: none; background: var(--gradient-primary); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                        <i class="bx bx-play-circle" style="font-size: 1.2rem;"></i> Run Batch Processor Now
                    </a>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Stat Cards -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 30px;">
                <div class="stat-card-vertical" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-card-icon" style="background: rgba(99, 102, 241, 0.08); color: var(--primary-500);">
                        <i class="bx bx-sync"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.78rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700;">Total Active Instructions</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalIns}</strong>
                    </div>
                </div>
                <div class="stat-card-vertical" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-card-icon" style="background: rgba(16, 185, 129, 0.08); color: var(--accent-emerald);">
                        <i class="bx bx-check-double"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.78rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700;">Total Processed Runs</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalHist}</strong>
                    </div>
                </div>
            </div>

            <!-- Tabs Header -->
            <div class="tabs-header">
                <button type="button" class="tab-btn active" onclick="switchTab(event, 'registered-rules')">Registered Instructions</button>
                <button type="button" class="tab-btn" onclick="switchTab(event, 'execution-logs')">Execution Logs</button>
            </div>

            <!-- TAB 1: REGISTERED INSTRUCTIONS -->
            <div id="registered-rules" class="tab-content active">
                <div class="glass-card" style="background: white; padding: 25px; margin-bottom: 25px;">
                    <!-- Filter bar -->
                    <form action="${pageContext.request.contextPath}/auto-pay" method="GET" style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 15px; margin-bottom: 25px;">
                        <input type="hidden" name="action" value="adminDashboard">
                        <input type="text" name="search" class="filter-input" placeholder="Search customer, card, or account..." value="${search}">
                        <select name="status" class="filter-select">
                            <option value="">All Statuses</option>
                            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                            <option value="paused" ${status == 'paused' ? 'selected' : ''}>Paused</option>
                            <option value="disabled" ${status == 'disabled' ? 'selected' : ''}>Disabled</option>
                        </select>
                        <select name="type" class="filter-select">
                            <option value="">All Targets</option>
                            <option value="credit_card" ${type == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                            <option value="loan" ${type == 'loan' ? 'selected' : ''}>Loans</option>
                        </select>
                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="padding: 10px 20px; font-weight: 600; border-radius: var(--radius-sm);">Apply Filters</button>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=adminReport&type=instructions" class="btn btn-secondary" style="padding: 10px 20px; font-weight: 600; border-radius: var(--radius-sm); text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-download"></i> Export
                            </a>
                        </div>
                    </form>

                    <div style="overflow-x: auto;">
                        <table style="width: 100%; border-collapse: collapse; text-align: left;">
                            <thead>
                                <tr style="border-bottom: 2px solid var(--gray-100);">
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Customer</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Target</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Source Account</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Payment Mode</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Frequency</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Next Run</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Status</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Last Run</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty instructions}">
                                        <c:forEach var="ins" items="${instructions}">
                                            <tr style="border-bottom: 1px solid var(--gray-100);">
                                                <td style="padding: 14px 12px; font-size: 0.85rem; font-weight: 600; color: var(--gray-800);">${ins.customerName} <span style="display: block; font-size: 0.72rem; color: var(--gray-400); font-weight: 500;">ID: #${ins.customerId}</span></td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; font-weight: 600;">
                                                    <c:choose>
                                                        <c:when test="${ins.targetType == 'credit_card'}">
                                                            Credit Card ${ins.maskedCardNumber}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Loan EMI (${ins.loanType})
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; color: var(--gray-600);">${ins.maskedSourceAccountNumber}</td>
                                                <td style="padding: 14px 12px; font-size: 0.82rem; font-weight: 600; text-transform: capitalize; color: var(--gray-600);">${ins.paymentType.replace('_', ' ')}</td>
                                                <td style="padding: 14px 12px; font-size: 0.82rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600;">${ins.paymentFrequency}</td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; font-weight: 600; color: var(--primary-500);">${ins.nextPaymentDate}</td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem;">
                                                    <span class="autopay-status-badge ${ins.status}">${ins.status}</span>
                                                </td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; color: var(--gray-400);">${not empty ins.lastProcessedDate ? ins.lastProcessedDate : 'Never'}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" style="text-align: center; padding: 40px; color: var(--gray-400);">No active registrations match the filters.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Paginator -->
                    <c:if test="${insTotalPages > 1}">
                        <div class="paginator-container">
                            <c:if test="${insPage > 1}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard&insPage=${insPage - 1}&search=${search}&status=${status}&type=${type}" class="paginator-btn"><i class="bx bx-chevron-left"></i> Prev</a>
                            </c:if>
                            <c:forEach var="p" begin="1" end="${insTotalPages}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard&insPage=${p}&search=${search}&status=${status}&type=${type}" class="paginator-btn ${insPage == p ? 'active' : ''}">${p}</a>
                            </c:forEach>
                            <c:if test="${insPage < insTotalPages}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard&insPage=${insPage + 1}&search=${search}&status=${status}&type=${type}" class="paginator-btn">Next <i class="bx bx-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- TAB 2: EXECUTION LOGS -->
            <div id="execution-logs" class="tab-content">
                <div class="glass-card" style="background: white; padding: 25px; margin-bottom: 25px;">
                    <!-- Filter bar -->
                    <form action="${pageContext.request.contextPath}/auto-pay" method="GET" style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 15px; margin-bottom: 25px;">
                        <input type="hidden" name="action" value="adminDashboard">
                        <input type="text" name="search" class="filter-input" placeholder="Search transaction ID, customer name..." value="${search}">
                        <select name="status" class="filter-select">
                            <option value="">All Statuses</option>
                            <option value="completed" ${status == 'completed' ? 'selected' : ''}>Success</option>
                            <option value="failed" ${status == 'failed' ? 'selected' : ''}>Failed</option>
                        </select>
                        <select name="type" class="filter-select">
                            <option value="">All Targets</option>
                            <option value="credit_card" ${type == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                            <option value="loan" ${type == 'loan' ? 'selected' : ''}>Loans</option>
                        </select>
                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="padding: 10px 20px; font-weight: 600; border-radius: var(--radius-sm);">Apply Filters</button>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=adminReport&type=history" class="btn btn-secondary" style="padding: 10px 20px; font-weight: 600; border-radius: var(--radius-sm); text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-download"></i> Export Logs
                            </a>
                        </div>
                    </form>

                    <div style="overflow-x: auto;">
                        <table style="width: 100%; border-collapse: collapse; text-align: left;">
                            <thead>
                                <tr style="border-bottom: 2px solid var(--gray-100);">
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Date &amp; Time</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Customer</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Billing Target</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Source Account</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Amount</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Status</th>
                                    <th style="padding: 12px; font-size: 0.72rem; text-transform: uppercase; color: var(--gray-400);">Txn Reference / Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty historyList}">
                                        <c:forEach var="h" items="${historyList}">
                                            <tr style="border-bottom: 1px solid var(--gray-100);">
                                                <td style="padding: 14px 12px; font-size: 0.85rem; color: var(--gray-700);"><fmt:formatDate value="${h.paymentDate}" pattern="dd MMM yyyy, hh:mm a"/></td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; font-weight: 600; color: var(--gray-800);">${h.customerName}</td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; font-weight: 600;">
                                                    <c:choose>
                                                        <c:when test="${h.targetType == 'credit_card'}">
                                                            Credit Card ${h.maskedCardNumber}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Loan EMI (${h.loanType})
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem; color: var(--gray-600);">${h.maskedSourceAccountNumber}</td>
                                                <td class="${h.status == 'completed' ? 'text-completed' : 'text-failed'}" style="padding: 14px 12px; font-size: 0.85rem; font-weight: 700;">
                                                    <c:choose>
                                                        <c:when test="${h.status == 'completed'}">
                                                            ₹<fmt:formatNumber value="${h.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            --
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 14px 12px; font-size: 0.85rem;">
                                                    <span class="autopay-status-badge ${h.status}">${h.status}</span>
                                                </td>
                                                <td class="${h.status == 'completed' ? 'text-normal-gray' : 'text-error-red'}" style="padding: 14px 12px; font-size: 0.85rem;">
                                                    <c:choose>
                                                        <c:when test="${h.status == 'completed'}">
                                                            <span style="font-family: monospace; font-weight: 600;">${h.transactionReference}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${h.failureReason}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--gray-400);">No execution logs found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Paginator -->
                    <c:if test="${histTotalPages > 1}">
                        <div class="paginator-container">
                            <c:if test="${histPage > 1}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard&histPage=${histPage - 1}&search=${search}&status=${status}&type=${type}" class="paginator-btn"><i class="bx bx-chevron-left"></i> Prev</a>
                            </c:if>
                            <c:forEach var="p" begin="1" end="${histTotalPages}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard&histPage=${p}&search=${search}&status=${status}&type=${type}" class="paginator-btn ${histPage == p ? 'active' : ''}">${p}</a>
                            </c:forEach>
                            <c:if test="${histPage < histTotalPages}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=adminDashboard&histPage=${histPage + 1}&search=${search}&status=${status}&type=${type}" class="paginator-btn">Next <i class="bx bx-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; 2026 Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function switchTab(e, tabId) {
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            e.currentTarget.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        }
    </script>
</body>
</html>
