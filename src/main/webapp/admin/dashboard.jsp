<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Admin Dashboard</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(99, 102, 241, 0.08);
            --card-glow: rgba(99, 102, 241, 0.04);
            --panel-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
        }

        body {
            background-color: #f6f8fc !important;
            color: var(--gray-700) !important;
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
        }
        
        body.dark-mode {
            --glass-bg: rgba(30, 41, 59, 0.45);
            --glass-border: rgba(255, 255, 255, 0.08);
            --card-glow: rgba(99, 102, 241, 0.1);
            --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            background-color: #0f172a !important;
        }

        /* Preloader styling fixes to match dashboard design */
        .preloader {
            background: #f6f8fc;
            z-index: 9999;
        }
        body.dark-mode .preloader {
            background: #0f172a;
        }

        /* Background blur animation cursor glow */
        .cursor-glow {
            position: fixed;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.08) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            z-index: 1;
            transition: left 0.1s ease-out, top 0.1s ease-out;
        }
        body.dark-mode .cursor-glow {
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
        }

        /* --- STICKY GLASSMORPHIC HEADER --- */
        .header {
            background: rgba(255, 255, 255, 0.6) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border-bottom: 1px solid var(--glass-border) !important;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.02);
            padding: 20px 40px;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            z-index: 1000;
        }
        
        body.dark-mode .header {
            background: rgba(15, 23, 42, 0.6) !important;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
        }

        .header.scrolled {
            background: rgba(255, 255, 255, 0.8) !important;
            padding: 14px 40px;
            border-bottom-color: rgba(99, 102, 241, 0.15) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
        }
        
        body.dark-mode .header.scrolled {
            background: rgba(15, 23, 42, 0.8) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .mobile-nav-toggle {
            display: none !important;
        }
        body.dark-mode .mobile-nav-toggle {
            color: var(--gray-300) !important;
        }

        /* --- STYLISH SIDEBAR --- */
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.45) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border-right: 1px solid var(--glass-border) !important;
            padding: 30px 20px;
            position: fixed;
            top: 80px;
            bottom: 0;
            left: 0;
            z-index: 99;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--panel-shadow);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        body.dark-mode .sidebar {
            background: rgba(15, 23, 42, 0.45) !important;
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

        body.dark-mode .sidebar-menu a {
            color: var(--gray-400) !important;
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
        
        body.dark-mode .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.03);
            color: var(--white) !important;
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

        body.dark-mode .sidebar-menu a.active {
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.35);
        }

        /* --- MAIN CONTENT AREA --- */
        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: transparent;
            z-index: 10;
            position: relative;
        }

        /* --- PREMIUM GLASS CARDS --- */
        .glass-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }
        
        body.dark-mode .glass-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
            box-shadow: var(--panel-shadow);
        }

        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2) !important;
        }

        /* --- KPI STAT CARDS --- */
        .stat-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-lg);
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
        }

        body.dark-mode .stat-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: rgba(99, 102, 241, 0.25) !important;
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.1);
        }

        .stat-icon {
            width: 54px;
            height: 54px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            flex-shrink: 0;
            transition: transform 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.1) rotate(5deg);
        }

        /* Special dynamic pulses on glow items */
        .secure-glow {
            position: absolute;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            top: -50px;
            right: -50px;
            pointer-events: none;
        }

        .pulse-dot {
            width: 8px;
            height: 8px;
            background: #10b981;
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7);
            animation: pulse 1.6s infinite;
        }
        @keyframes pulse {
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

        /* Sparkline accent line */
        .sparkline-decor {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
        }

        /* Progress bars styling */
        .progress-bar-container {
            width: 100%;
            height: 6px;
            background: rgba(99, 102, 241, 0.08);
            border-radius: var(--radius-full);
            overflow: hidden;
            margin-top: 10px;
        }
        
        body.dark-mode .progress-bar-container {
            background: rgba(255, 255, 255, 0.08);
        }

        .progress-bar-fill {
            height: 100%;
            border-radius: var(--radius-full);
            transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* --- TABLE STYLING --- */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            padding: 16px 20px;
            color: var(--gray-500);
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
            white-space: nowrap;
        }

        body.dark-mode th {
            color: var(--gray-400);
        }

        td {
            padding: 18px 20px;
            font-size: 0.875rem;
            color: var(--gray-700);
            border-bottom: 1px solid rgba(99, 102, 241, 0.05);
            vertical-align: middle;
            white-space: nowrap;
        }

        body.dark-mode td {
            color: var(--gray-300);
            border-bottom-color: rgba(255, 255, 255, 0.04);
        }

        tr {
            transition: background 0.2s ease;
        }

        tr:hover td {
            background: rgba(99, 102, 241, 0.02);
        }
        
        body.dark-mode tr:hover td {
            background: rgba(255, 255, 255, 0.01);
        }

        /* --- MONOSPACE ID BADGE --- */
        .badge-id {
            font-family: 'Courier New', Courier, monospace;
            font-weight: 700;
            font-size: 0.8rem;
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500);
            padding: 5px 10px;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(99, 102, 241, 0.08);
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        body.dark-mode .badge-id {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-300);
        }

        /* --- CUSTOM ACTION BUTTONS --- */
        .btn-action-approve {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(16, 185, 129, 0.3);
            background: rgba(16, 185, 129, 0.05);
            color: var(--accent-emerald) !important;
            cursor: pointer;
            transition: all var(--transition-fast);
            text-decoration: none;
        }

        .btn-action-approve:hover {
            background: var(--accent-emerald);
            color: white !important;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);
            transform: translateY(-1px);
        }

        .btn-action-reject {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(239, 68, 68, 0.3);
            background: rgba(239, 68, 68, 0.05);
            color: #ef4444 !important;
            cursor: pointer;
            transition: all var(--transition-fast);
            text-decoration: none;
        }

        .btn-action-reject:hover {
            background: #ef4444;
            color: white !important;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
            transform: translateY(-1px);
        }

        /* Footer margin fix */
        .footer {
            margin-left: 280px;
            background: var(--white) !important;
            border-top: 1px solid var(--glass-border) !important;
            padding: 24px 0;
            transition: all 0.3s ease;
        }
        
        body.dark-mode .footer {
            background: rgba(15, 23, 42, 0.8) !important;
        }

        /* --- RESPONSIVE WORKOUTS --- */
        @media (max-width: 991px) {
            .mobile-nav-toggle {
                display: flex !important;
            }
            .admin-label {
                display: none !important;
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
                <script>
                    (function() {
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
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="active"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs"><i class="bx bx-receipt"></i> Repayment Logs</a>
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
                <div class="stat-card secure-card" style="background: var(--gradient-primary) !important; color: white; border: none; overflow: hidden; position: relative;">
                    <div class="secure-glow"></div>
                    <div class="stat-icon" style="background: rgba(255, 255, 255, 0.25); color: white; z-index: 1;">
                        <i class="bx bx-shield-quarter bx-tada" style="animation-duration: 2s;"></i>
                    </div>
                    <div style="z-index: 1;">
                        <span style="display: block; font-size: 0.8rem; opacity: 0.9; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;">Secure System Mode</span>
                        <div style="display: flex; align-items: center; gap: 8px; margin-top: 5px;">
                            <strong style="font-size: 1.35rem; font-weight: 800;">AES-256 ACTIVE</strong>
                            <span class="pulse-dot"></span>
                        </div>
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
                <div class="stat-card" style="position: relative; overflow: hidden;">
                    <div class="sparkline-decor" style="background: var(--accent-emerald);"></div>
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
                <div class="stat-card" style="position: relative; overflow: hidden;">
                    <div class="sparkline-decor" style="background: var(--accent-cyan);"></div>
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
                <div class="stat-card" style="position: relative; overflow: hidden;">
                    <div class="sparkline-decor" style="background: var(--accent-amber);"></div>
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
                        <span style="font-size: 0.8rem; background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 10px; border-radius: var(--radius-sm); font-weight: 600;">Total: ${totalCustomers}</span>
                    </h4>
                    
                    <c:set var="activePercentage" value="${totalCustomers gt 0 ? (totalActiveCustomers div totalCustomers) * 100 : 0}" />
                    <div style="display: flex; flex-direction: column; gap: 15px;">
                        <div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 0.9rem; color: var(--gray-600);"><i class="bx bx-badge-check" style="color: var(--accent-emerald); margin-right: 5px;"></i> Active Customer Profiles</span>
                                <span style="font-weight: 600; color: var(--gray-800);">${totalActiveCustomers}</span>
                            </div>
                            <div class="progress-bar-container">
                                <div class="progress-bar-fill" style="--active-width: ${activePercentage}%; width: var(--active-width); background: var(--gradient-primary);"></div>
                            </div>
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
                        <span style="font-size: 0.8rem; background: rgba(236, 72, 153, 0.1); color: var(--secondary-500); padding: 4px 10px; border-radius: var(--radius-sm); font-weight: 600;">Total: ${totalAccounts}</span>
                    </h4>
                    
                    <c:set var="savingsPercentage" value="${totalAccounts gt 0 ? (totalSavingsAccounts div totalAccounts) * 100 : 0}" />
                    <c:set var="currentPercentage" value="${totalAccounts gt 0 ? (totalCurrentAccounts div totalAccounts) * 100 : 0}" />
                    
                    <div style="display: flex; flex-direction: column; gap: 15px;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div style="background: rgba(99, 102, 241, 0.03); padding: 12px; border-radius: var(--radius-md); border: 1px solid var(--glass-border); text-align: center;">
                                <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings</span>
                                <strong style="font-size: 1.25rem; color: var(--gray-700);">${totalSavingsAccounts}</strong>
                                <div class="progress-bar-container" style="height: 4px; margin-top: 6px;">
                                    <div class="progress-bar-fill" style="--savings-width: ${savingsPercentage}%; width: var(--savings-width); background: var(--accent-emerald);"></div>
                                </div>
                            </div>
                            <div style="background: rgba(99, 102, 241, 0.03); padding: 12px; border-radius: var(--radius-md); border: 1px solid var(--glass-border); text-align: center;">
                                <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current</span>
                                <strong style="font-size: 1.25rem; color: var(--gray-700);">${totalCurrentAccounts}</strong>
                                <div class="progress-bar-container" style="height: 4px; margin-top: 6px;">
                                    <div class="progress-bar-fill" style="--current-width: ${currentPercentage}%; width: var(--current-width); background: var(--secondary-500);"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Loans Table -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-building-house" style="color: var(--primary-500);"></i> Pending Loan Requests Awaiting Review
                </h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Loan ID</th>
                                <th>Customer ID</th>
                                <th>Loan Category</th>
                                <th>Principal Requested</th>
                                <th>Interest Rate</th>
                                <th>Term Length</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty pendingLoans}">
                                    <c:forEach var="loan" items="${pendingLoans}">
                                        <tr>
                                            <td><span class="badge-id">#LN-${loan.loanId}</span></td>
                                            <td><span class="badge-id">#CUST-${loan.customerId}</span></td>
                                            <td style="text-transform: capitalize; font-weight: 600;">${loan.loanType}</td>
                                            <td style="font-weight: 700; color: var(--primary-500);">₹ <fmt:formatNumber value="${loan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="font-weight: 500;">${loan.interestRate}% P.A.</td>
                                            <td style="font-weight: 500; color: var(--gray-500);">${loan.termMonths} Months</td>
                                            <td style="text-align: center;">
                                                <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                    <a href="${pageContext.request.contextPath}/loan?action=approve&id=${loan.loanId}&csrfToken=${sessionScope.csrfToken}" class="btn-action-approve"><i class="bx bx-check"></i> Approve</a>
                                                    <a href="${pageContext.request.contextPath}/loan?action=reject&id=${loan.loanId}&csrfToken=${sessionScope.csrfToken}" class="btn-action-reject"><i class="bx bx-x"></i> Reject</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 40px; color: var(--gray-400); font-weight: 500;">
                                            <div style="display: flex; flex-direction: column; align-items: center; gap: 10px;">
                                                <i class="bx bx-check-shield" style="font-size: 2.5rem; color: var(--accent-emerald);"></i>
                                                <span>No pending loan applications awaiting review.</span>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        // Cursor glow follow
        const glow = document.querySelector('.cursor-glow');
        if (glow) {
            document.addEventListener('mousemove', (e) => {
                glow.style.left = e.clientX + 'px';
                glow.style.top = e.clientY + 'px';
            });
        }

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
    </script>
</body>
</html>
