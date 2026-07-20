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
        /* Modern Tabs Header */
        .tabs-header {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            border-bottom: 1px solid var(--gray-200);
            padding-bottom: 2px;
            flex-wrap: wrap;
        }
        .tab-btn {
            padding: 12px 24px;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-500);
            background: none;
            border: none;
            position: relative;
            cursor: pointer;
            transition: all var(--transition-fast) ease;
            border-radius: var(--radius-md) var(--radius-md) 0 0;
        }
        .tab-btn:hover {
            color: var(--primary-500);
            background: rgba(99, 102, 241, 0.04);
        }
        .tab-btn.active {
            color: var(--primary-500);
            font-weight: 700;
        }
        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-primary);
            border-radius: var(--radius-full);
            animation: lineExpand 0.3s ease forwards;
        }
        @keyframes lineExpand {
            from { left: 50%; right: 50%; }
            to { left: 0; right: 0; }
        }

        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
            animation: slideUpFade 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        @keyframes slideUpFade {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Stat Cards Dashboard styling */
        .stat-card-vertical {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 22px 26px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: transform 0.3s cubic-bezier(0.25, 0.8, 0.25, 1), box-shadow 0.3s ease;
        }
        .stat-card-vertical:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg), 0 0 15px rgba(99, 102, 241, 0.05);
        }
        .stat-card-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            transition: transform 0.3s ease;
        }
        .stat-card-vertical:hover .stat-card-icon {
            transform: scale(1.08) rotate(3deg);
        }

        /* Status Badges with Pulse indicator */
        .autopay-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px 4px 10px;
            border-radius: var(--radius-full);
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
        }
        .autopay-status-badge::before {
            content: '';
            width: 6px;
            height: 6px;
            border-radius: 50%;
            display: inline-block;
        }
        
        .autopay-status-badge.active, .autopay-status-badge.completed {
            background: rgba(16, 185, 129, 0.08);
            color: #047857;
        }
        .autopay-status-badge.active::before, .autopay-status-badge.completed::before {
            background: var(--accent-emerald);
            box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
            animation: activePulse 1.5s infinite;
        }
        @keyframes activePulse {
            0% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
            }
            70% {
                transform: scale(1);
                box-shadow: 0 0 0 6px rgba(16, 185, 129, 0);
            }
            100% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(16, 185, 129, 0);
            }
        }
        
        .autopay-status-badge.paused {
            background: rgba(245, 158, 11, 0.08);
            color: #b45309;
        }
        .autopay-status-badge.paused::before {
            background: var(--accent-amber);
        }
        
        .autopay-status-badge.disabled, .autopay-status-badge.failed {
            background: rgba(239, 68, 68, 0.08);
            color: #b91c1c;
        }
        .autopay-status-badge.disabled::before, .autopay-status-badge.failed::before {
            background: var(--accent-red);
        }
        
        .text-completed {
            color: var(--accent-emerald);
        }
        .text-failed {
            color: var(--accent-red);
        }
        .text-normal-gray {
            color: var(--gray-600);
        }
        .text-error-red {
            color: #b91c1c;
        }

        /* --- DIRECTORY TABLE REDESIGN --- */
        .directory-table-container {
            border-radius: var(--radius-xl);
            border: 1px solid rgba(99, 102, 241, 0.12);
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            box-shadow: var(--panel-shadow);
            overflow: hidden;
            margin-top: 15px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        body.dark-mode .directory-table-container {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.08);
        }

        .directory-table-responsive {
            overflow-x: auto;
            width: 100%;
            -webkit-overflow-scrolling: touch;
        }

        /* Custom Scrollbar */
        .directory-table-responsive::-webkit-scrollbar {
            height: 8px;
            width: 8px;
        }
        .directory-table-responsive::-webkit-scrollbar-track {
            background: rgba(99, 102, 241, 0.02);
            border-radius: 10px;
        }
        .directory-table-responsive::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.15);
            border-radius: 10px;
        }
        .directory-table-responsive::-webkit-scrollbar-thumb:hover {
            background: rgba(99, 102, 241, 0.3);
        }

        body.dark-mode .directory-table-responsive::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.12);
        }
        body.dark-mode .directory-table-responsive::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.25);
        }

        .directory-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            text-align: left;
        }

        .directory-table th {
            background: rgba(99, 102, 241, 0.04);
            color: var(--gray-700);
            font-size: 0.78rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            padding: 18px 20px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.12);
            white-space: nowrap;
        }

        body.dark-mode .directory-table th {
            background: rgba(30, 41, 59, 0.5);
            color: var(--gray-300);
            border-bottom-color: rgba(255, 255, 255, 0.1);
        }

        .directory-table td {
            padding: 16px 20px;
            font-size: 0.88rem;
            color: var(--gray-600);
            border-bottom: 1px solid rgba(99, 102, 241, 0.06);
            white-space: nowrap;
            vertical-align: middle;
            transition: all 0.25s ease;
        }

        body.dark-mode .directory-table td {
            color: var(--gray-400);
            border-bottom-color: rgba(255, 255, 255, 0.05);
        }

        .directory-table tr {
            transition: all 0.25s ease;
        }

        .directory-table tbody tr:hover td {
            background: rgba(99, 102, 241, 0.03) !important;
            color: var(--gray-900);
        }

        body.dark-mode .directory-table tbody tr:hover td {
            background: rgba(255, 255, 255, 0.02) !important;
            color: #ffffff;
        }

        /* Rounded outer corners for table header and footer */
        .directory-table tr:first-child th:first-child {
            border-top-left-radius: var(--radius-xl);
        }
        .directory-table tr:first-child th:last-child {
            border-top-right-radius: var(--radius-xl);
        }
        .directory-table tr:last-child td:first-child {
            border-bottom-left-radius: var(--radius-xl);
        }
        .directory-table tr:last-child td:last-child {
            border-bottom-right-radius: var(--radius-xl);
        }

        .print-only {
            display: none !important;
        }

        /* Print formatting */
        @media print {
            body {
                background: white !important;
                color: black !important;
            }
            .sidebar, .header, .footer, .no-print, form, .paginator-container, .tabs-header {
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
            /* Make sure the active tab-content is shown and takes full width */
            .tab-content.active {
                display: block !important;
            }
            .print-only {
                display: block !important;
            }
            .directory-table-container {
                border: none !important;
                box-shadow: none !important;
                background: transparent !important;
                padding: 0 !important;
                margin: 0 !important;
                overflow: visible !important;
            }
            .directory-table {
                width: 100% !important;
                border-collapse: collapse !important;
                table-layout: auto !important;
                page-break-inside: auto !important;
            }
            .directory-table thead {
                display: table-header-group !important;
            }
            .directory-table tr {
                page-break-inside: avoid !important;
                page-break-after: auto !important;
            }
            .directory-table th, .directory-table td {
                padding: 8px 10px !important;
                font-size: 9.5pt !important;
                line-height: 1.4 !important;
                white-space: normal !important;
                word-wrap: break-word !important;
                border-bottom: 1px solid #cbd5e0 !important;
                page-break-inside: avoid !important;
            }
            .directory-table th {
                background-color: #f7fafc !important;
                color: #2d3748 !important;
                font-weight: 700 !important;
                border-bottom: 2px solid #cbd5e0 !important;
            }
        }

        /* Modern Filter Bar Redesign */
        .filter-bar-premium {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 15px;
            margin-bottom: 25px;
            align-items: center;
        }
        @media (max-width: 992px) {
            .filter-bar-premium {
                grid-template-columns: 1fr 1fr;
            }
            .filter-actions-group {
                grid-column: span 2;
                justify-content: flex-end;
            }
        }
        @media (max-width: 576px) {
            .filter-bar-premium {
                grid-template-columns: 1fr;
            }
            .filter-actions-group {
                grid-column: span 1;
                flex-direction: column;
                align-items: stretch;
            }
        }

        .filter-input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        .filter-input-group i {
            position: absolute;
            left: 15px;
            color: var(--gray-400);
            font-size: 1.15rem;
            pointer-events: none;
            transition: color 0.2s ease;
            z-index: 5;
        }
        .filter-input-premium {
            width: 100%;
            padding: 12px 16px 12px 42px;
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.9);
            outline: none;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-700);
            transition: all 0.2s ease;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.02);
        }
        body.dark-mode .filter-input-premium {
            background: rgba(15, 23, 42, 0.6);
            border-color: rgba(255, 255, 255, 0.08);
            color: var(--gray-300);
        }
        .filter-input-premium:focus {
            border-color: var(--primary-400);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
            background: white;
        }
        body.dark-mode .filter-input-premium:focus {
            background: rgba(15, 23, 42, 0.8);
            border-color: var(--primary-500);
        }
        .filter-input-group:focus-within i {
            color: var(--primary-500);
        }

        .filter-select-premium {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.9);
            outline: none;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-700);
            transition: all 0.2s ease;
            cursor: pointer;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.02);
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%236366f1' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 15px;
            padding-right: 40px;
        }
        body.dark-mode .filter-select-premium {
            background-color: rgba(15, 23, 42, 0.6);
            border-color: rgba(255, 255, 255, 0.08);
            color: var(--gray-300);
        }
        .filter-select-premium:focus {
            border-color: var(--primary-400);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
            background-color: white;
        }
        body.dark-mode .filter-select-premium:focus {
            background-color: rgba(15, 23, 42, 0.8);
            border-color: var(--primary-500);
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
    <aside class="sidebar no-print">
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
        <!-- Print Header (Vertex Galaxy Bank Corporate Letterhead format matching statement) -->
        <div class="print-only" style="width: 100%; margin-bottom: 30px;">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2.5px solid #6366f1; padding-bottom: 8px;">
                <div style="display: flex; align-items: center; gap: 12px; text-align: left;">
                    <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 45px; height: 45px; object-fit: contain;">
                    <div style="text-align: left;">
                        <h1 style="font-size: 1.45rem; font-weight: 800; color: #6366f1; letter-spacing: 0.5px; margin: 0; font-family: 'Poppins', sans-serif;">VERTEX GALAXY BANK</h1>
                        <p style="font-size: 0.75rem; color: #718096; margin: 2px 0 0; font-weight: 600; font-family: 'Poppins', sans-serif;">Always Beyond Boundaries</p>
                    </div>
                </div>
                <div style="text-align: right; line-height: 1.3; font-family: 'Poppins', sans-serif;">
                    <p style="margin: 0; font-size: 7.5pt; color: #4a5568; font-weight: 600;">Corporate HQ: VGB Corporate Towers, BKC Road,</p>
                    <p style="margin: 0; font-size: 7.5pt; color: #4a5568; font-weight: 600;">Bandra Kurla Complex, Mumbai, MH - 400051</p>
                    <p style="margin: 0; font-size: 7.5pt; color: #718096; font-weight: 500;">Toll Free: 1800-VGB-BANK | www.vertexgalaxybank.com</p>
                </div>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 6px; font-size: 8pt; color: #4a5568; font-weight: 600; font-family: 'Poppins', sans-serif;">
                <div style="font-weight: 700; text-transform: uppercase;" id="printReportTitle">AUTO PAY REGISTRY REPORT</div>
                <div style="display: flex; gap: 15px;">
                    <span>Date: <span class="printCurrentDate">-</span></span>
                </div>
            </div>
        </div>

        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;" class="no-print">
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
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 30px;" class="no-print">
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
                <div class="glass-card" style="padding: 25px; margin-bottom: 25px;">
                    <!-- Redesigned Premium Filter bar -->
                    <form action="${pageContext.request.contextPath}/auto-pay" method="GET" class="filter-bar-premium">
                        <input type="hidden" name="action" value="adminDashboard">
                        <div class="filter-input-group">
                            <i class="bx bx-search-alt"></i>
                            <input type="text" name="search" class="filter-input-premium" placeholder="Search customer, card, or account..." value="${search}">
                        </div>
                        <div style="position: relative;">
                            <select name="status" class="filter-select-premium">
                                <option value="">All Statuses</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="paused" ${status == 'paused' ? 'selected' : ''}>Paused</option>
                                <option value="disabled" ${status == 'disabled' ? 'selected' : ''}>Disabled</option>
                            </select>
                        </div>
                        <div style="position: relative;">
                            <select name="type" class="filter-select-premium">
                                <option value="">All Targets</option>
                                <option value="credit_card" ${type == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                                <option value="loan" ${type == 'loan' ? 'selected' : ''}>Loans</option>
                            </select>
                        </div>
                        <div style="display: flex; gap: 10px; align-items: center;" class="no-print filter-actions-group">
                            <button type="submit" class="btn btn-primary" style="padding: 12px 24px; font-weight: 700; border-radius: 10px; border: none; background: var(--gradient-primary); box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15); display: inline-flex; align-items: center; gap: 6px;">
                                <i class="bx bx-filter-alt"></i> Apply Filters
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="printReport('AUTO PAY REGISTERED INSTRUCTIONS')" style="padding: 12px 18px; font-weight: 600; border-radius: 10px; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-printer"></i> PDF
                            </button>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=adminReport&type=instructions&format=excel" class="btn btn-secondary" style="padding: 12px 18px; font-weight: 600; border-radius: 10px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-spreadsheet"></i> Excel
                            </a>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=adminReport&type=instructions&format=csv" class="btn btn-secondary" style="padding: 12px 18px; font-weight: 600; border-radius: 10px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-download"></i> CSV
                            </a>
                        </div>
                    </form>

                    <div class="directory-table-container">
                        <div class="directory-table-responsive">
                            <table class="directory-table">
                                <thead>
                                    <tr>
                                        <th>Customer</th>
                                        <th>Target</th>
                                        <th>Source Account</th>
                                        <th>Payment Mode</th>
                                        <th>Frequency</th>
                                        <th>Next Run</th>
                                        <th>Status</th>
                                        <th>Last Run</th>
                                        <th class="no-print" style="text-align: center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty instructions}">
                                            <c:forEach var="ins" items="${instructions}">
                                                <tr>
                                                    <td style="font-weight: 600; color: var(--gray-800);">${ins.customerName} <span style="display: block; font-size: 0.72rem; color: var(--gray-400); font-weight: 500;">ID: #${ins.customerId}</span></td>
                                                    <td style="font-weight: 600;">
                                                        <c:choose>
                                                            <c:when test="${ins.targetType == 'credit_card'}">
                                                                Credit Card ${ins.maskedCardNumber}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Loan EMI (${ins.loanType})
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="font-family: monospace; font-weight: 600;">${ins.maskedSourceAccountNumber}</td>
                                                    <td style="font-weight: 600; text-transform: capitalize;">${ins.paymentType.replace('_', ' ')}</td>
                                                    <td style="text-transform: uppercase; color: var(--gray-500); font-weight: 600;">${ins.paymentFrequency}</td>
                                                    <td style="font-weight: 600; color: var(--primary-500);">${ins.nextPaymentDate}</td>
                                                    <td>
                                                        <span class="autopay-status-badge ${ins.status}">${ins.status}</span>
                                                    </td>
                                                    <td style="color: var(--gray-400);">${not empty ins.lastProcessedDate ? ins.lastProcessedDate : 'Never'}</td>
                                                    <td class="no-print" style="text-align: center;">
                                                        <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                            <c:choose>
                                                                <c:when test="${ins.status == 'active'}">
                                                                    <a href="${pageContext.request.contextPath}/auto-pay?action=adminPause&id=${ins.autoPayId}&search=${search}&status=${status}&type=${type}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; font-weight: 700; border-radius: var(--radius-sm); text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: rgba(245, 158, 11, 0.1); color: #d97706; border: 1.5px solid rgba(245, 158, 11, 0.2);">
                                                                        <i class="bx bx-pause" style="font-size: 0.95rem;"></i> Pause
                                                                    </a>
                                                                </c:when>
                                                                <c:when test="${ins.status == 'paused' || ins.status == 'disabled'}">
                                                                    <a href="${pageContext.request.contextPath}/auto-pay?action=adminResume&id=${ins.autoPayId}&search=${search}&status=${status}&type=${type}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.75rem; font-weight: 700; border-radius: var(--radius-sm); text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: rgba(16, 185, 129, 0.1); color: #059669; border: 1.5px solid rgba(16, 185, 129, 0.2);">
                                                                        <i class="bx bx-play" style="font-size: 0.95rem;"></i> Activate
                                                                    </a>
                                                                </c:when>
                                                            </c:choose>
                                                            <a href="javascript:void(0)" onclick="confirmAdminCancel('${ins.autoPayId}')" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.75rem; font-weight: 700; border-radius: var(--radius-sm); text-decoration: none; display: inline-flex; align-items: center; gap: 4px; background: rgba(239, 68, 68, 0.1); color: #dc2626; border: 1.5px solid rgba(239, 68, 68, 0.2);">
                                                                <i class="bx bx-x" style="font-size: 0.95rem;"></i> Close
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="9" style="text-align: center; padding: 40px; color: var(--gray-400);">No active registrations match the filters.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
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
                <div class="glass-card" style="padding: 25px; margin-bottom: 25px;">
                    <!-- Redesigned Premium Filter bar -->
                    <form action="${pageContext.request.contextPath}/auto-pay" method="GET" class="filter-bar-premium">
                        <input type="hidden" name="action" value="adminDashboard">
                        <div class="filter-input-group">
                            <i class="bx bx-search-alt"></i>
                            <input type="text" name="search" class="filter-input-premium" placeholder="Search transaction ID, customer name..." value="${search}">
                        </div>
                        <div style="position: relative;">
                            <select name="status" class="filter-select-premium">
                                <option value="">All Statuses</option>
                                <option value="completed" ${status == 'completed' ? 'selected' : ''}>Success</option>
                                <option value="failed" ${status == 'failed' ? 'selected' : ''}>Failed</option>
                            </select>
                        </div>
                        <div style="position: relative;">
                            <select name="type" class="filter-select-premium">
                                <option value="">All Targets</option>
                                <option value="credit_card" ${type == 'credit_card' ? 'selected' : ''}>Credit Card</option>
                                <option value="loan" ${type == 'loan' ? 'selected' : ''}>Loans</option>
                            </select>
                        </div>
                        <div style="display: flex; gap: 10px; align-items: center;" class="no-print filter-actions-group">
                            <button type="submit" class="btn btn-primary" style="padding: 12px 24px; font-weight: 700; border-radius: 10px; border: none; background: var(--gradient-primary); box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15); display: inline-flex; align-items: center; gap: 6px;">
                                <i class="bx bx-filter-alt"></i> Apply Filters
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="printReport('AUTO PAY EXECUTION LOGS')" style="padding: 12px 18px; font-weight: 600; border-radius: 10px; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-printer"></i> PDF
                            </button>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=adminReport&type=history&format=excel" class="btn btn-secondary" style="padding: 12px 18px; font-weight: 600; border-radius: 10px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-spreadsheet"></i> Excel
                            </a>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=adminReport&type=history&format=csv" class="btn btn-secondary" style="padding: 12px 18px; font-weight: 600; border-radius: 10px; text-decoration: none; display: inline-flex; align-items: center; gap: 5px;">
                                <i class="bx bx-download"></i> CSV
                            </a>
                        </div>
                    </form>

                    <div class="directory-table-container">
                        <div class="directory-table-responsive">
                            <table class="directory-table">
                                <thead>
                                    <tr>
                                        <th>Date &amp; Time</th>
                                        <th>Customer</th>
                                        <th>Billing Target</th>
                                        <th>Source Account</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Txn Reference / Reason</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty historyList}">
                                            <c:forEach var="h" items="${historyList}">
                                                <tr>
                                                    <td><fmt:formatDate value="${h.paymentDate}" pattern="dd MMM yyyy, hh:mm a"/></td>
                                                    <td style="font-weight: 600; color: var(--gray-800);">${h.customerName}</td>
                                                    <td style="font-weight: 600;">
                                                        <c:choose>
                                                            <c:when test="${h.targetType == 'credit_card'}">
                                                                Credit Card ${h.maskedCardNumber}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Loan EMI (${h.loanType})
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="font-family: monospace; font-weight: 600;">${h.maskedSourceAccountNumber}</td>
                                                    <td class="${h.status == 'completed' ? 'text-completed' : 'text-failed'}" style="font-weight: 700;">
                                                        <c:choose>
                                                            <c:when test="${h.status == 'completed'}">
                                                                ₹<fmt:formatNumber value="${h.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                --
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="autopay-status-badge ${h.status}">${h.status}</span>
                                                    </td>
                                                    <td class="${h.status == 'completed' ? 'text-normal-gray' : 'text-error-red'}">
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
    <footer class="footer no-print">
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

        function printReport(title) {
            document.querySelectorAll('.printCurrentDate').forEach(el => {
                el.innerText = new Date().toLocaleDateString('en-US', { day: '2-digit', month: 'short', year: 'numeric' });
            });
            document.getElementById('printReportTitle').innerText = title;
            window.print();
        }

        function confirmAdminCancel(id) {
            if (confirm("Are you sure you want to permanently cancel/close this auto-pay instruction?")) {
                window.location.href = "${pageContext.request.contextPath}/auto-pay?action=adminCancel&id=" + id + "&search=" + encodeURIComponent('${search}') + "&status=" + encodeURIComponent('${status}') + "&type=" + encodeURIComponent('${type}');
            }
        }
    </script>
</body>
</html>
