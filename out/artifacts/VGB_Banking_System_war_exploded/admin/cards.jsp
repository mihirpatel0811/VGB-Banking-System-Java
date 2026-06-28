<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage ATM Cards</title>
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
        .card-dues-warning {
            color: #ef4444;
        }
        .card-dues-normal {
            color: var(--gray-800);
        }

        /* PREMIUM VGB 3D GLOWING CARDS FOR VISUALIZER */
        .vgb-atm-card {
            border-radius: 20px;
            padding: 25px;
            color: white;
            position: relative;
            overflow: hidden;
            min-height: 220px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            perspective: 1000px;
            border: 1.5px solid rgba(255, 255, 255, 0.2);
            cursor: pointer;
        }

        .vgb-atm-card.debit {
            background: radial-gradient(circle at 80% 80%, #3a007c 0%, #080321 60%, #01000b 100%) !important;
            box-shadow: 0 12px 25px rgba(58, 0, 124, 0.25) !important;
        }

        .vgb-atm-card.credit {
            background: 
                radial-gradient(circle at 75% 35%, rgba(212, 175, 55, 0.25) 0%, transparent 55%),
                linear-gradient(to right, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                linear-gradient(to bottom, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                linear-gradient(135deg, #121316 0%, #08090a 100%) !important;
            background-size: cover, 16px 16px, 16px 16px, cover;
            box-shadow: 0 12px 25px rgba(124, 45, 18, 0.25) !important;
        }

        .vgb-atm-card.inactive-card {
            background: repeating-linear-gradient(45deg, rgba(0,0,0,0.15) 0px, rgba(0,0,0,0.15) 2px, transparent 2px, transparent 10px), 
                        linear-gradient(135deg, #2e3035 0%, #151618 100%) !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
            opacity: 0.8;
        }

        .vgb-atm-card:hover:not(.interactive) {
            transform: translateY(-8px) rotateX(6deg) rotateY(-6deg);
            box-shadow: 0 22px 40px rgba(0, 0, 0, 0.25);
        }

        .vgb-atm-card.debit:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(59, 130, 246, 0.4), 0 0 15px rgba(6, 182, 212, 0.3);
        }

        .vgb-atm-card.credit:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(139, 92, 246, 0.4), 0 0 15px rgba(236, 72, 153, 0.3);
        }

        .vgb-atm-card::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 20%, rgba(255, 255, 255, 0.08) 40%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.08) 60%, transparent 80%);
            transform: rotate(-45deg);
            transition: all 0.8s ease;
            pointer-events: none;
            opacity: 0.6;
        }

        .vgb-atm-card:hover::after {
            left: 100%;
        }

        .vgb-atm-card.flipped {
            transform: rotateY(180deg);
        }
        
        .vgb-atm-card.flipped:hover:not(.interactive) {
            transform: rotateY(180deg) translateY(-8px) rotateX(-6deg) rotateY(6deg);
        }

        /* PREMIUM DYNAMIC INTERACTIVE CARD CLASSES */
        .vgb-atm-card.interactive {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }

        .vgb-atm-card.interactive:hover {
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.25);
        }

        /* Glassmorphic Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1000;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(8px);
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        /* PREMIUM ATM CARD CUSTOMIZER & SIMULATOR */
        .card-customizer-grid {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            gap: 40px;
            align-items: center;
        }
        @media (max-width: 991px) {
            .card-customizer-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }
        .simulator-display {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.04) 0%, rgba(6, 182, 212, 0.04) 100%);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 40px 30px;
            position: relative;
            min-height: 330px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.05);
        }
        .simulator-controls {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .control-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .control-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.75px;
        }
        .control-input, .control-select {
            width: 100%;
            padding: 11px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            background: white;
            font-size: 0.9rem;
            color: var(--gray-800);
            font-family: inherit;
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
        }
        .control-input:focus, .control-select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
        }
        .control-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .card-3d-scene {
            perspective: 1200px;
            transform-style: preserve-3d;
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
        <a href="#" class="logo">
            <span class="logo-text">V</span>
            <span class="logo-text">G</span>
            <span class="logo-text">B</span>
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/admin/notification.jsp"><i class="bx bx-bell"></i> Audit Logs</a>
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
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Atm Cards Control Center</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer debit/credit card applications, audit system card limits, and process card approvals.</p>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error or not empty sessionScope.error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                    <span>${not empty error ? error : sessionScope.error}</span>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>
            <c:if test="${not empty success or not empty sessionScope.success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                    <span>${not empty success ? success : sessionScope.success}</span>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <!-- Stats Rows (Dynamic Card Metrics) -->
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <c:set var="pendingCount" value="0" />
                <c:set var="activeCount" value="0" />
                <c:set var="feeRevenue" value="0" />
                
                <c:forEach var="card" items="${cards}">
                    <c:choose>
                        <c:when test="${card.status eq 'pending'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                        </c:when>
                        <c:when test="${card.status eq 'active'}">
                            <c:set var="activeCount" value="${activeCount + 1}" />
                        </c:when>
                    </c:choose>
                    <c:if test="${card.feePaid}">
                        <c:set var="feeRevenue" value="${feeRevenue + card.cardFee}" />
                    </c:if>
                </c:forEach>

                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-credit-card"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Active Cards Issued</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${activeCount}</strong>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-time-five"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Pending Approvals</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${pendingCount}</strong>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-wallet"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Card Service Revenue</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">₹ <fmt:formatNumber value="${feeRevenue}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                    </div>
                </div>
            </div>



            <!-- Table 1: Pending Card Approvals -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-time"></i> Pending Card Applications Awaiting Review
                </h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Card Type</th>
                                <th style="padding: 12px 15px;">Provider</th>
                                <th style="padding: 12px 15px;">Holder Name</th>
                                <th style="padding: 12px 15px;">Linked Account</th>
                                <th style="padding: 12px 15px;">Fee Paid</th>
                                <th style="padding: 12px 15px;">Applied Date</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasPending" value="false" />
                            <c:forEach var="card" items="${cards}">
                                <c:if test="${card.status eq 'pending'}">
                                    <c:set var="hasPending" value="true" />
                                    <fmt:formatDate var="formattedAppliedDate" value="${card.createdAt}" pattern="MM/yy" />
                                    <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                        <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 3px 8px; border-radius: var(--radius-sm); font-size: 0.75rem;">${card.cardType}</span>
                                        </td>
                                        <td style="padding: 15px; text-transform: uppercase; font-weight: 500;">${card.cardProvider}</td>
                                        <td style="padding: 15px; font-weight: 500;">${card.cardHolderName}</td>
                                        <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${card.accountNumber}</td>
                                        <td style="padding: 15px; font-weight: 600; color: var(--accent-emerald);">₹ ${card.cardFee}</td>
                                        <td style="padding: 15px;"><fmt:formatDate value="${card.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td style="padding: 15px; text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; white-space: nowrap;">
                                            <a href="${pageContext.request.contextPath}/card?action=approve&id=${card.cardId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-emerald); color: var(--accent-emerald); margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-check"></i> Approve</a>
                                            <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn btn-secondary" onclick="return confirm('Reject and permanently close this card application?');" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444; margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-x"></i> Reject</a>
                                        </td>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasPending}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 30px; color: var(--gray-400);">No pending ATM card applications at this time.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Table 2: All System Cards (Debit & Credit) -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-credit-card-front"></i> All System Issued Cards Directory
                </h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Sr No.</th>
                                <th style="padding: 12px 15px;">Card Number</th>
                                <th style="padding: 12px 15px;">Holder Name</th>
                                <th style="padding: 12px 15px;">Card Type</th>
                                <th style="padding: 12px 15px;">Provider</th>
                                <th style="padding: 12px 15px;">Expiry Date</th>
                                <th style="padding: 12px 15px;">Dues (Credit)</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty cards}">
                                    <c:forEach var="card" items="${cards}" varStatus="status">
                                        <fmt:formatDate var="formattedExpiryDate" value="${card.expiryDate}" pattern="MM/yy" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-600);">${status.count}</td>
                                            <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${card.cardNumber}</td>
                                            <td style="padding: 15px; font-weight: 500;">${card.cardHolderName}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">${card.cardType}</td>
                                            <td style="padding: 15px; text-transform: uppercase;">${card.cardProvider}</td>
                                            <td style="padding: 15px;"><fmt:formatDate value="${card.expiryDate}" pattern="yyyy-MM-dd" /></td>
                                            <td style="padding: 15px; font-weight: 700;" class="${card.outstandingBalance gt 0 ? 'card-dues-warning' : 'card-dues-normal'}">
                                                ₹ <fmt:formatNumber value="${card.outstandingBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${card.status eq 'active'}">
                                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Active</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Pending</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'expired'}">
                                                        <span style="background: rgba(239, 68, 68, 0.1); color: #b91c1c; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Expired</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(156, 163, 175, 0.1); color: var(--gray-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Closed</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; white-space: nowrap;">
                                                <c:if test="${card.status eq 'active'}">
                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn btn-secondary" onclick="return confirm('Are you sure you want to permanently close card #${card.cardId}?');" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444; margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-power-off"></i> Close</a>
                                                </c:if>
                                            </td>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 30px; color: var(--gray-400);">No ATM cards registered in database directory.</td>
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
    </div>

    <script>

    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
