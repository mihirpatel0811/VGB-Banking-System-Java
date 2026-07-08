<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.vgb.service.AccountService" %>
<%@ page import="com.vgb.service.LoanService" %>
<%@ page import="com.vgb.service.CustomerService" %>
<%@ page import="com.vgb.model.Account" %>
<%@ page import="com.vgb.model.Loan" %>
<%@ page import="com.vgb.model.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    AccountService accountService = new AccountService();
    List<Account> allAccounts = accountService.getAllAccounts();
    request.setAttribute("allAccounts", allAccounts);

    LoanService loanService = new LoanService();
    List<Loan> allLoans = loanService.getAllLoans();
    request.setAttribute("allLoans", allLoans);

    CustomerService customerService = new CustomerService();
    List<Customer> allCustomers = customerService.getAllCustomers();
    Map<Long, String> customerNames = new HashMap<>();
    for (Customer c : allCustomers) {
        customerNames.put(c.getCustomerId(), c.getFullName());
    }
    request.setAttribute("customerNames", customerNames);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Admin Teller Counter</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        @media print {
            body {
                background: white !important;
                color: black !important;
            }
            .sidebar, .navbar, .counter-tabs, .print-hidden, .footer, #btnTabHistory {
                display: none !important;
            }
            main, .content, .container {
                margin: 0 !important;
                padding: 0 !important;
                left: 0 !important;
                width: 100% !important;
                max-width: 100% !important;
            }
            body.print-receipt-active * {
                visibility: hidden;
            }
            body.print-receipt-active #receiptPrintArea, 
            body.print-receipt-active #receiptPrintArea * {
                visibility: visible;
            }
            body.print-receipt-active #receiptPrintArea {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                border: none !important;
                box-shadow: none !important;
            }
        }

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

        /* Teller Tab styling */
        .counter-tabs {
            display: flex;
            gap: 15px;
            border-bottom: 1.5px solid rgba(99, 102, 241, 0.1);
            padding-bottom: 20px;
            margin-bottom: 35px;
            flex-wrap: wrap;
        }
        .counter-tab-btn {
            padding: 12px 24px;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-600) !important;
            background: rgba(255, 255, 255, 0.45);
            border: 1.5px solid var(--glass-border);
            border-radius: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        body.dark-mode .counter-tab-btn {
            color: var(--gray-400) !important;
            background: rgba(30, 41, 59, 0.2);
        }
        .counter-tab-btn:hover {
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500) !important;
            border-color: rgba(99, 102, 241, 0.2);
            transform: translateY(-1px);
        }
        .counter-tab-btn.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            border-color: transparent;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.25);
        }
        body.dark-mode .counter-tab-btn.active {
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.35);
        }

        .counter-pane {
            display: none;
        }
        .counter-pane.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }

        /* Two-Column Layout */
        .counter-grid {
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 40px;
        }
        @media (max-width: 991px) {
            .counter-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }

        /* Live ticking clock style */
        .counter-clock-card {
            background: rgba(99, 102, 241, 0.03);
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: var(--radius-md);
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }
        body.dark-mode .counter-clock-card {
            background: rgba(255, 255, 255, 0.01);
            border-color: rgba(255, 255, 255, 0.05);
        }
        .clock-icon-wrapper {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: rgba(99, 102, 241, 0.08);
            color: var(--primary-500);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }
        body.dark-mode .clock-icon-wrapper {
            background: rgba(255, 255, 255, 0.05);
            color: var(--primary-300);
        }
        .clock-label {
            display: block;
            font-size: 0.72rem;
            color: var(--gray-400);
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .clock-display {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gray-700);
            font-family: monospace;
            margin-top: 2px;
        }
        body.dark-mode .clock-display {
            color: var(--gray-300);
        }
        .clock-pulse {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10b981;
            position: absolute;
            top: 18px;
            right: 18px;
            box-shadow: 0 0 8px #10b981;
            animation: clockPulse 1.5s infinite;
        }
        @keyframes clockPulse {
            0% { transform: scale(0.9); opacity: 0.6; }
            50% { transform: scale(1.2); opacity: 1; box-shadow: 0 0 12px #10b981; }
            100% { transform: scale(0.9); opacity: 0.6; }
        }

        /* Search Autocomplete selects */
        .search-select-wrapper {
            position: relative;
            margin-bottom: 20px;
        }
        .search-select-input {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            font-weight: 500;
            background: var(--white);
            color: var(--gray-800);
            font-size: 0.9rem;
            transition: all var(--transition-normal);
        }
        body.dark-mode .search-select-input {
            border-color: rgba(255, 255, 255, 0.1);
        }
        .search-select-input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3.5px rgba(99, 102, 241, 0.08);
        }
        .search-select-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.15rem;
        }
        .search-select-arrow {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.15rem;
            pointer-events: none;
            transition: transform 0.3s ease;
        }
        .search-select-wrapper.active .search-select-arrow {
            transform: translateY(-50%) rotate(180deg);
        }
        .search-select-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: var(--white);
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            z-index: 1000;
            max-height: 230px;
            overflow-y: auto;
            margin-top: 6px;
            display: none;
            animation: paneFadeIn 0.22s cubic-bezier(0.4, 0, 0.2, 1);
        }
        body.dark-mode .search-select-results {
            background: #1e293b;
            border-color: rgba(255, 255, 255, 0.1);
        }
        .search-select-item {
            padding: 12px 15px;
            cursor: pointer;
            border-bottom: 1px solid var(--gray-100);
            display: flex;
            flex-direction: column;
            gap: 4px;
            transition: background 0.2s ease;
        }
        body.dark-mode .search-select-item {
            border-bottom-color: rgba(255, 255, 255, 0.05);
        }
        .search-select-item:hover {
            background: rgba(99, 102, 241, 0.05);
        }
        .search-select-item-title {
            font-weight: 600;
            color: var(--gray-800);
            font-size: 0.85rem;
        }
        body.dark-mode .search-select-item-title {
            color: var(--gray-200);
        }
        .search-select-item-subtitle {
            font-size: 0.75rem;
            color: var(--gray-400);
            font-family: monospace;
        }
        .search-select-empty {
            padding: 18px;
            color: var(--gray-400);
            text-align: center;
            font-size: 0.85rem;
        }

        /* Verified Details Card visuals */
        .verified-preview-card {
            background: var(--glass-bg);
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1.5px solid rgba(255, 255, 255, 0.5);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        body.dark-mode .verified-preview-card {
            border-color: rgba(255, 255, 255, 0.06);
            box-shadow: var(--panel-shadow);
        }
        .verified-preview-card.selected {
            border-color: rgba(16, 185, 129, 0.3) !important;
            background: rgba(16, 185, 129, 0.02) !important;
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.05);
        }
        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.7rem;
            font-weight: 700;
            background: rgba(16, 185, 129, 0.08);
            color: var(--accent-emerald);
            padding: 4px 8px;
            border-radius: 4px;
            text-transform: uppercase;
            margin-bottom: 15px;
        }
        .wire-transfer-arrow {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 15px 0;
            color: var(--primary-500);
            font-size: 2rem;
            animation: bounceArrow 1.5s infinite;
        }
        @keyframes bounceArrow {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(6px); }
        }

        /* Real-Time alerts styling inside verified columns */
        .counter-alert-warning {
            background: rgba(245, 158, 11, 0.08);
            border-left: 4px solid #f59e0b;
            color: #b45309;
            padding: 12px 15px;
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            font-weight: 500;
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideIn 0.3s ease;
        }
        .counter-alert-danger {
            background: rgba(239, 68, 68, 0.08);
            border-left: 4px solid #ef4444;
            color: #b91c1c;
            padding: 12px 15px;
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            font-weight: 500;
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideIn 0.3s ease;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-5px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Form elements overrides */
        .form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--gray-500);
            margin-bottom: 8px;
        }
        body.dark-mode .form-group label {
            color: var(--gray-400);
        }

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

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
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
    <script>
        // Fail-safe preloader removal
        (function() {
            var hide = function() {
                var p = document.querySelector('.preloader');
                if (p) {
                    p.classList.add('hidden');
                    document.body.style.overflow = 'auto';
                }
            };
            if (document.readyState === 'complete') {
                hide();
            } else {
                window.addEventListener('load', hide);
                // Hard timeout safety: remove preloader after 1.5 seconds under all conditions
                setTimeout(hide, 1500);
            }
        })();
    </script>

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
    <aside class="sidebar no-print">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp" class="active"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
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
            <div style="margin-bottom: 35px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Administrative Teller Desk</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Post physical counter deposits, withdrawals, or system wire routing tasks directly.</p>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty sessionScope.error or not empty error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 15px; border-radius: var(--radius-md); margin-bottom: 25px; font-size: 0.9rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-error-circle" style="font-size: 1.3rem;"></i>
                    <span>${not empty error ? error : sessionScope.error}</span>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.success or not empty success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 15px; border-radius: var(--radius-md); margin-bottom: 25px; font-size: 0.9rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-check-circle" style="font-size: 1.3rem;"></i>
                    <span>${not empty success ? success : sessionScope.success}</span>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <!-- Counter Tabs Switchers -->
            <div class="counter-tabs">
                <button type="button" class="counter-tab-btn active" id="btnTabDeposit" onclick="switchCounterPane('deposit')">
                    <i class="bx bx-down-arrow-alt"></i> <span>Cash Deposit</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabWithdraw" onclick="switchCounterPane('withdraw')">
                    <i class="bx bx-up-arrow-alt"></i> <span>Cash Withdrawal</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabTransfer" onclick="switchCounterPane('transfer')">
                    <i class="bx bx-transfer"></i> <span>Internal Transfer</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabExternalTransfer" onclick="switchCounterPane('external_transfer')">
                    <i class="bx bx-transfer-alt"></i> <span>External Transfer</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabLoanRepay" onclick="switchCounterPane('loanrepay')">
                    <i class="bx bx-credit-card"></i> <span>Loan Repayment</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabHistory" onclick="switchCounterPane('history')">
                    <i class="bx bx-history"></i> <span>Transaction History</span>
                </button>
            </div>

            <!-- PANE 1: Cash Deposit -->
            <div class="counter-pane active" id="paneDeposit">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-down-arrow-alt"></i> Counter Cash Deposit
                        </h3>
                        
                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=deposit" method="post" id="formDeposit" onsubmit="return validateDepositForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="accountId" id="hidDepositAccId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Target Account</label>
                                <div class="search-select-wrapper" id="selectDepositAccWrapper">
                                    <input type="text" class="search-select-input" id="txtDepositAcc" placeholder="Type customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownDepositAcc"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Deposit Amount (INR)</label>
                                <input type="number" step="0.01" min="500" name="amount" id="numDepositAmt" required placeholder="Min. ₹500" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcDepositPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" name="description" id="txtDepositDesc" value="Teller counter cash load" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" style="width: 100%;">Post Deposit Amount</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Target Profile</h4>
                        
                        <div class="verified-preview-card" id="cardDepositPreview">
                            <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Awaiting Account Selection</div>
                            <p style="color: var(--gray-400); font-size: 0.85rem; text-align: center; padding: 30px 0;">Please search and choose a target account in the left panel to verify details.</p>
                        </div>
                        
                        <div id="depositAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 2: Cash Withdrawal -->
            <div class="counter-pane" id="paneWithdraw">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-up-arrow-alt"></i> Counter Cash Withdrawal
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=withdraw" method="post" id="formWithdraw" onsubmit="return validateWithdrawForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="accountId" id="hidWithdrawAccId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account</label>
                                <div class="search-select-wrapper" id="selectWithdrawAccWrapper">
                                    <input type="text" class="search-select-input" id="txtWithdrawAcc" placeholder="Type customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownWithdrawAcc"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Payment Mode</label>
                                <div style="display: flex; gap: 20px; align-items: center; margin-top: 5px;">
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; color: var(--gray-800);">
                                        <input type="radio" name="paymentMode" value="cash" checked onchange="togglePaymentMode('withdraw', this.value)" style="accent-color: var(--primary-500);"> Cash Withdrawal
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; color: var(--gray-800);">
                                        <input type="radio" name="paymentMode" value="cheque" onchange="togglePaymentMode('withdraw', this.value)" style="accent-color: var(--primary-500);"> Checkbook Withdrawal
                                    </label>
                                </div>
                            </div>

                            <div class="form-group cheque-only-withdraw" style="margin-bottom: 20px; display: none;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Cheque Book Number</label>
                                <select name="chequeBookNumber" id="selWithdrawChequeBook" class="search-select-input" style="width: 100%; height: auto;" onchange="loadCheques('withdraw', this.value)">
                                    <option value="">-- Select Active Cheque Book --</option>
                                </select>
                            </div>

                            <div class="form-group cheque-only-withdraw" style="margin-bottom: 20px; display: none;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Cheque Number</label>
                                <select name="chequeNumber" id="selWithdrawChequeNo" class="search-select-input" style="width: 100%; height: auto;" onchange="recalcWithdrawPayout()">
                                    <option value="">-- Select Unused Cheque Number --</option>
                                </select>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Withdrawal Amount (INR)</label>
                                <input type="number" step="0.01" min="100" name="amount" id="numWithdrawAmt" required placeholder="Max. ₹3,00,000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcWithdrawPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" name="description" id="txtWithdrawDesc" value="Teller counter cash payout" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" id="btnSubmitWithdraw" style="width: 100%;">Post Withdrawal Amount</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Source Profile</h4>

                        <div class="verified-preview-card" id="cardWithdrawPreview">
                            <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Awaiting Account Selection</div>
                            <p style="color: var(--gray-400); font-size: 0.85rem; text-align: center; padding: 30px 0;">Please search and choose a source account in the left panel to verify details.</p>
                        </div>

                        <div id="withdrawAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 3: Funds Transfer -->
            <div class="counter-pane" id="paneTransfer">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-transfer"></i> Counter Funds Transfer
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=transfer" method="post" id="formTransfer" onsubmit="return validateTransferForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="transferType" value="internal">
                            <input type="hidden" name="fromAccountId" id="hidTransferFromId">
                            <input type="hidden" name="toAccountId" id="hidTransferToId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account (From)</label>
                                <div class="search-select-wrapper" id="selectTransferFromWrapper">
                                    <input type="text" class="search-select-input" id="txtTransferFrom" placeholder="Type source customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownTransferFrom"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Payment Mode</label>
                                <div style="display: flex; gap: 20px; align-items: center; margin-top: 5px;">
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; color: var(--gray-800);">
                                        <input type="radio" name="paymentMode" value="cash" checked onchange="togglePaymentMode('transfer', this.value)" style="accent-color: var(--primary-500);"> Cash Transfer
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; color: var(--gray-800);">
                                        <input type="radio" name="paymentMode" value="cheque" onchange="togglePaymentMode('transfer', this.value)" style="accent-color: var(--primary-500);"> Checkbook Transfer
                                    </label>
                                </div>
                            </div>

                            <div class="form-group cheque-only-transfer" style="margin-bottom: 20px; display: none;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Cheque Book Number</label>
                                <select name="chequeBookNumber" id="selTransferChequeBook" class="search-select-input" style="width: 100%; height: auto;" onchange="loadCheques('transfer', this.value)">
                                    <option value="">-- Select Active Cheque Book --</option>
                                </select>
                            </div>

                            <div class="form-group cheque-only-transfer" style="margin-bottom: 20px; display: none;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Cheque Number</label>
                                <select name="chequeNumber" id="selTransferChequeNo" class="search-select-input" style="width: 100%; height: auto;" onchange="recalcTransferPayout()">
                                    <option value="">-- Select Unused Cheque Number --</option>
                                </select>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Target Account (To)</label>
                                <div class="search-select-wrapper" id="selectTransferToWrapper">
                                    <input type="text" class="search-select-input" id="txtTransferTo" placeholder="Type target customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownTransferTo"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transfer Amount (INR)</label>
                                <input type="number" step="0.01" min="1" name="amount" id="numTransferAmt" required placeholder="Max. ₹3,50,000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" name="description" id="txtTransferDesc" value="Teller counter bank transfer" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" id="btnSubmitTransfer" style="width: 100%;">Post Funds Transfer</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Wire Route</h4>

                        <!-- Stacked panels representing wire flow -->
                        <div id="transferRouteContainer">
                            <div class="verified-preview-card" id="cardTransferSourcePreview" style="margin-bottom: 10px;">
                                <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Source Awaiting</div>
                                <p style="color: var(--gray-400); font-size: 0.82rem; text-align: center; padding: 10px 0;">Select source account.</p>
                            </div>

                            <div class="wire-transfer-arrow" id="transferVisualArrow" style="display: none;">
                                <i class="bx bx-down-arrow-alt"></i>
                            </div>

                            <div class="verified-preview-card" id="cardTransferTargetPreview">
                                <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Target Awaiting</div>
                                <p style="color: var(--gray-400); font-size: 0.82rem; text-align: center; padding: 10px 0;">Select target account.</p>
                            </div>
                        </div>

                        <div id="transferAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 3b: External Funds Transfer -->
            <div class="counter-pane" id="paneExternalTransfer">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-transfer-alt"></i> External Funds Transfer (Other Bank)
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=transfer" method="post" id="formExternalTransfer" onsubmit="return validateExternalTransferForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="transferType" value="external">
                            <input type="hidden" name="fromAccountId" id="hidExtTransferFromId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account (From)</label>
                                <div class="search-select-wrapper" id="selectExtTransferFromWrapper">
                                    <input type="text" class="search-select-input" id="txtExtTransferFrom" placeholder="Type source customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownExtTransferFrom"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Payment Mode</label>
                                <div style="display: flex; gap: 20px; align-items: center; margin-top: 5px;">
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; color: var(--gray-800);">
                                        <input type="radio" name="paymentMode" value="cash" checked onchange="togglePaymentMode('ext_transfer', this.value)" style="accent-color: var(--primary-500);"> Cash Wire
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; color: var(--gray-800);">
                                        <input type="radio" name="paymentMode" value="cheque" onchange="togglePaymentMode('ext_transfer', this.value)" style="accent-color: var(--primary-500);"> Checkbook Wire
                                    </label>
                                </div>
                            </div>

                            <div class="form-group cheque-only-ext_transfer" style="margin-bottom: 20px; display: none;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Cheque Book Number</label>
                                <select name="chequeBookNumber" id="selExtTransferChequeBook" class="search-select-input" style="width: 100%; height: auto;" onchange="loadCheques('ext_transfer', this.value)">
                                    <option value="">-- Select Active Cheque Book --</option>
                                </select>
                            </div>

                            <div class="form-group cheque-only-ext_transfer" style="margin-bottom: 20px; display: none;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Cheque Number</label>
                                <select name="chequeNumber" id="selExtTransferChequeNo" class="search-select-input" style="width: 100%; height: auto;" onchange="recalcExternalTransferPayout()">
                                    <option value="">-- Select Unused Cheque Number --</option>
                                </select>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Beneficiary Name</label>
                                <input type="text" name="beneficiaryName" id="txtExtBeneficiaryName" required placeholder="Enter holder's name" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcExternalTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Beneficiary Account Number</label>
                                <input type="text" name="beneficiaryAccountNumber" id="txtExtBeneficiaryAcc" required placeholder="Enter account number" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcExternalTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">IFSC Code</label>
                                <input type="text" name="ifscCode" id="txtExtBeneficiaryIfsc" required placeholder="E.g., SBIN0001234" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcExternalTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Bank Name</label>
                                <input type="text" name="bankName" id="txtExtBeneficiaryBank" required placeholder="E.g., State Bank of India" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcExternalTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Branch Name (Optional)</label>
                                <input type="text" name="branchName" id="txtExtBeneficiaryBranch" placeholder="E.g., Connaught Place" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcExternalTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transfer Amount (INR)</label>
                                <input type="number" step="0.01" min="1" name="amount" id="numExtTransferAmt" required placeholder="Max. ₹3,50,000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcExternalTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" name="description" id="txtExtTransferDesc" value="Teller counter external bank transfer" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" id="btnSubmitExtTransfer" style="width: 100%;">Post External Transfer</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Wire Route</h4>

                        <!-- Stacked panels representing wire flow -->
                        <div id="extTransferRouteContainer">
                            <div class="verified-preview-card" id="cardExtTransferSourcePreview" style="margin-bottom: 10px;">
                                <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Source Awaiting</div>
                                <p style="color: var(--gray-400); font-size: 0.82rem; text-align: center; padding: 10px 0;">Select source account.</p>
                            </div>

                            <div class="wire-transfer-arrow" id="extTransferVisualArrow" style="display: none;">
                                <i class="bx bx-down-arrow-alt"></i>
                            </div>

                            <div class="verified-preview-card" id="cardExtTransferTargetPreview">
                                <div class="verified-badge" style="background: rgba(245, 158, 11, 0.08); color: #d97706;"><i class="bx bx-shield-quarter"></i> Target Beneficiary Details</div>
                                <p style="color: var(--gray-400); font-size: 0.82rem; text-align: center; padding: 10px 0;">Enter beneficiary details left.</p>
                            </div>
                        </div>

                        <div id="extTransferAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 4: Loan Repayment -->
            <div class="counter-pane" id="paneLoanRepay">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-credit-card"></i> Counter Loan Repayment
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/loan?action=repayment" method="post" id="formLoanRepay" onsubmit="return validateLoanRepayForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="loanId" id="hidRepayLoanId">
                            <input type="hidden" name="customerId" id="hidRepayCustomerId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Active Loan Profile</label>
                                <div class="search-select-wrapper" id="selectRepayLoanWrapper">
                                    <input type="text" class="search-select-input" id="txtRepayLoan" placeholder="Type customer name, loan ID or type..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownRepayLoan"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Customer Account to Debit</label>
                                <select name="accountId" id="repayAccount" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none; font-size: 0.9rem;" onchange="recalcLoanRepayPayout()">
                                    <option value="">-- Select Active Account --</option>
                                </select>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Repayment Amount (INR)</label>
                                <input type="number" step="0.01" min="1" name="amount" id="numRepayAmt" required placeholder="E.g., 5000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcLoanRepayPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" name="description" id="txtRepayDesc" value="Teller counter loan repayment" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" style="width: 100%;">Post Loan Repayment</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Loan Ledger</h4>

                        <div class="verified-preview-card" id="cardLoanRepayPreview">
                            <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Awaiting Loan Selection</div>
                            <p style="color: var(--gray-400); font-size: 0.85rem; text-align: center; padding: 30px 0;">Please search and select a loan portfolio in the left panel to verify details.</p>
                        </div>

                        <div id="loanRepayAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 5: Transaction History Ledger -->
            <div class="counter-pane" id="paneHistory">
                <div class="glass-card" style="margin-bottom: 25px; padding: 25px;">
                    <div class="print-hidden" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; margin-bottom: 20px;">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin: 0; display: flex; align-items: center; gap: 10px;">
                            <i class="bx bx-history" style="color: var(--primary-500);"></i> Core Transaction Ledger Log
                        </h3>
                        <div style="display: flex; gap: 10px;">
                            <button type="button" class="btn btn-secondary" onclick="exportToCSV()" style="display: flex; align-items: center; gap: 6px; padding: 8px 15px; font-size: 0.85rem; border: 1.5px solid var(--gray-300); background: white; color: var(--gray-700); cursor: pointer; border-radius: var(--radius-md);">
                                <i class="bx bx-file" style="font-size: 1.1rem;"></i> Export Excel (CSV)
                            </button>
                            <button type="button" class="btn btn-primary" onclick="window.print()" style="display: flex; align-items: center; gap: 6px; padding: 8px 15px; font-size: 0.85rem; background: var(--primary-500); color: white; cursor: pointer; border: none; border-radius: var(--radius-md);">
                                <i class="bx bx-printer" style="font-size: 1.1rem;"></i> Print Ledger
                            </button>
                        </div>
                    </div>

                    <!-- Dynamic Filtering Options -->
                    <div class="print-hidden" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 15px; margin-bottom: 20px; background: #f8fafc; padding: 15px; border-radius: var(--radius-md); border: 1px solid var(--gray-200);">
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">Customer Name</label>
                            <input type="text" id="filterCustName" placeholder="Search name..." oninput="triggerHistoryLoad()" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">Account Number</label>
                            <input type="text" id="filterAccNum" placeholder="Search account..." oninput="triggerHistoryLoad()" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">Type</label>
                            <select id="filterType" onchange="triggerHistoryLoad()" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                                <option value="all">All Types</option>
                                <option value="deposit">Deposit</option>
                                <option value="withdrawal">Withdrawal</option>
                                <option value="transfer">Transfer</option>
                                <option value="fee">Fee</option>
                                <option value="interest">Interest</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">Status</label>
                            <select id="filterStatus" onchange="triggerHistoryLoad()" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                                <option value="all">All Statuses</option>
                                <option value="completed">Completed</option>
                                <option value="pending">Pending</option>
                                <option value="failed">Failed</option>
                                <option value="reversed">Reversed</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">Date Filter</label>
                            <select id="filterDate" onchange="toggleCustomDateFields(this.value); triggerHistoryLoad();" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                                <option value="all">All Dates</option>
                                <option value="today">Today</option>
                                <option value="month">This Month</option>
                                <option value="year">This Year</option>
                                <option value="custom">Custom Date Range</option>
                            </select>
                        </div>
                    </div>

                    <!-- Custom Date Fields -->
                    <div id="customDateContainer" class="print-hidden" style="display: none; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px; background: #f1f5f9; padding: 12px; border-radius: var(--radius-md); border: 1px solid var(--gray-200);">
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">Start Date</label>
                            <input type="date" id="filterStartDate" onchange="triggerHistoryLoad()" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label style="display: block; font-size: 0.78rem; font-weight: 600; color: var(--gray-600); margin-bottom: 6px;">End Date</label>
                            <input type="date" id="filterEndDate" onchange="triggerHistoryLoad()" style="width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-sm); outline: none; font-size: 0.85rem; background: white;">
                        </div>
                    </div>

                    <!-- Transaction ID Search Box -->
                    <div class="form-group print-hidden" style="margin-bottom: 20px;">
                        <div style="position: relative;">
                            <input type="text" id="filterQueryText" placeholder="Search by Transaction ID or Reference Number (e.g., TXN...)" oninput="triggerHistoryLoad()" style="width: 100%; padding: 12px 15px 12px 40px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem; background: white; box-shadow: var(--shadow-sm);">
                            <i class="bx bx-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); font-size: 1.2rem; color: var(--gray-400);"></i>
                        </div>
                    </div>

                    <!-- Ledger Table -->
                    <div style="overflow-x: auto; border: 1px solid var(--gray-200); border-radius: var(--radius-md);">
                        <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem;" id="tblHistoryLedger">
                            <thead>
                                <tr style="background: var(--gray-50); border-bottom: 1.5px solid var(--gray-200); color: var(--gray-600); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px;">
                                    <th style="padding: 12px 15px;">Txn ID / Ref</th>
                                    <th style="padding: 12px 15px;">Date &amp; Time</th>
                                    <th style="padding: 12px 15px;">Type</th>
                                    <th style="padding: 12px 15px;">Sender Account</th>
                                    <th style="padding: 12px 15px;">Receiver / Target</th>
                                    <th style="padding: 12px 15px; text-align: right;">Amount (INR)</th>
                                    <th style="padding: 12px 15px;">Mode</th>
                                    <th style="padding: 12px 15px; text-align: center;">Status</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyHistoryLedger">
                                <tr>
                                    <td colspan="8" style="padding: 40px; text-align: center; color: var(--gray-400);">
                                        <i class="bx bx-loader-alt bx-spin" style="font-size: 2rem; margin-bottom: 10px; color: var(--primary-500);"></i>
                                        <div>Loading transaction database ledger logs...</div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <!-- Account Database JSON Serialization (safely decoupled to avoid syntax parse warnings) -->
    <script id="accounts-data" type="application/json">
        [
            <c:forEach var="acc" items="${allAccounts}" varStatus="status">
                {
                    "accountId": "${acc.accountId}",
                    "customerId": "${acc.customerId}",
                    "accountNumber": "${acc.accountNumber}",
                    "accountType": "${acc.accountType}",
                    "balance": "${acc.balance != null ? acc.balance : 0.0}",
                    "status": "${acc.status}",
                    "customerName": "<c:out value="${acc.customerName}" />",
                    "businessName": "<c:out value="${acc.businessName}" />",
                    "ifscCode": "${acc.ifscCode != null ? acc.ifscCode : 'VGBK0000001'}"
                }${status.last ? '' : ','}
            </c:forEach>
        ]
    </script>
    
    <!-- Loans Database JSON Serialization (safely decoupled to avoid syntax parse warnings) -->
    <script id="loans-data" type="application/json">
        [
            <c:set var="firstLoan" value="true" />
            <c:forEach var="loan" items="${allLoans}">
                <c:if test="${loan.status == 'active' or loan.status == 'disbursed'}">
                    <c:if test="${not firstLoan}">,</c:if>
                    {
                        "loanId": "${loan.loanId}",
                        "customerId": "${loan.customerId}",
                        "customerName": "<c:out value="${customerNames[loan.customerId]}" />",
                        "loanType": "${loan.loanType}",
                        "principalAmount": "${loan.principalAmount}",
                        "remainingBalance": "${loan.remainingBalance}",
                        "status": "${loan.status}"
                    }
                    <c:set var="firstLoan" value="false" />
                </c:if>
            </c:forEach>
        ]
    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        const allAccounts = JSON.parse(document.getElementById('accounts-data').textContent);
        allAccounts.forEach(acc => {
            acc.balance = parseFloat(acc.balance) || 0.0;
        });
        const allLoans = JSON.parse(document.getElementById('loans-data').textContent);
        allLoans.forEach(loan => {
            loan.remainingBalance = parseFloat(loan.remainingBalance) || 0.0;
            loan.principalAmount = parseFloat(loan.principalAmount) || 0.0;
        });

        // Checkbook UI visibility toggle
        function togglePaymentMode(formType, val) {
            const chequeGroups = document.querySelectorAll('.cheque-only-' + formType);
            if (val === 'cheque') {
                chequeGroups.forEach(el => el.style.display = 'block');
                
                // Get selected account ID to load active checkbooks
                let accountId = 0;
                if (formType === 'withdraw' && selectedWithdrawAcc) {
                    accountId = selectedWithdrawAcc.accountId;
                } else if (formType === 'transfer' && selectedTransferFrom) {
                    accountId = selectedTransferFrom.accountId;
                } else if (formType === 'ext_transfer' && selectedExtTransferFrom) {
                    accountId = selectedExtTransferFrom.accountId;
                }
                
                if (accountId > 0) {
                    loadChequeBooks(formType, accountId);
                } else {
                    const cbSelect = document.getElementById('sel' + capitalize(formType) + 'ChequeBook');
                    if (cbSelect) {
                        cbSelect.innerHTML = '<option value="">-- First Select an Account --</option>';
                    }
                }
            } else {
                chequeGroups.forEach(el => el.style.display = 'none');
            }
        }

        function capitalize(str) {
            if (str === 'ext_transfer') return 'ExtTransfer';
            return str.charAt(0).toUpperCase() + str.slice(1);
        }

        // Cache for loaded checkbooks and checks to prevent duplicate fetches
        const chequeBooksCache = {};
        const chequesCache = {};

        function loadChequeBooks(formType, accountId) {
            const cbSelect = document.getElementById('sel' + capitalize(formType) + 'ChequeBook');
            const chkSelect = document.getElementById('sel' + capitalize(formType) + 'ChequeNo');
            if (!cbSelect) return;
            
            cbSelect.innerHTML = '<option value="">-- Loading Cheque Books... --</option>';
            if (chkSelect) chkSelect.innerHTML = '<option value="">-- Select Unused Cheque Number --</option>';

            const cacheKey = accountId;
            if (chequeBooksCache[cacheKey]) {
                renderChequeBooks(cbSelect, chequeBooksCache[cacheKey]);
                return;
            }

            fetch('${pageContext.request.contextPath}/account?action=getChequeBooksJson&accountId=' + accountId)
                .then(res => res.json())
                .then(data => {
                    chequeBooksCache[cacheKey] = data;
                    renderChequeBooks(cbSelect, data);
                })
                .catch(err => {
                    console.error('Failed to load checkbooks', err);
                    cbSelect.innerHTML = '<option value="">-- Failed to Load Checkbooks --</option>';
                });
        }

        function renderChequeBooks(selectEl, books) {
            if (!books || books.length === 0) {
                selectEl.innerHTML = '<option value="">-- No Active Cheque Books Found --</option>';
                return;
            }
            let html = '<option value="">-- Select Active Cheque Book --</option>';
            books.forEach(b => {
                html += '<option value="' + b.chequebookNumber + '" data-id="' + b.chequebookId + '">' + b.chequebookNumber + ' (Chq #' + b.startChequeNo + '-' + b.endChequeNo + ')</option>';
            });
            selectEl.innerHTML = html;
        }

        function loadCheques(formType, chequeBookNumber) {
            const cbSelect = document.getElementById('sel' + capitalize(formType) + 'ChequeBook');
            const chkSelect = document.getElementById('sel' + capitalize(formType) + 'ChequeNo');
            if (!chkSelect || !cbSelect) return;

            const selectedOption = cbSelect.options[cbSelect.selectedIndex];
            const chequeBookId = selectedOption ? selectedOption.getAttribute('data-id') : null;

            if (!chequeBookId) {
                chkSelect.innerHTML = '<option value="">-- Select Unused Cheque Number --</option>';
                return;
            }

            chkSelect.innerHTML = '<option value="">-- Loading Cheques... --</option>';

            const cacheKey = chequeBookId;
            if (chequesCache[cacheKey]) {
                renderCheques(chkSelect, chequesCache[cacheKey]);
                return;
            }

            fetch('${pageContext.request.contextPath}/account?action=getUnusedChequesJson&chequeBookId=' + chequeBookId)
                .then(res => res.json())
                .then(data => {
                    chequesCache[cacheKey] = data;
                    renderCheques(chkSelect, data);
                })
                .catch(err => {
                    console.error('Failed to load cheque leaves', err);
                    chkSelect.innerHTML = '<option value="">-- Failed to Load Cheques --</option>';
                });
        }

        function renderCheques(selectEl, leaves) {
            if (!leaves || leaves.length === 0) {
                selectEl.innerHTML = '<option value="">-- No Unused Cheques Remaining --</option>';
                return;
            }
            let html = '<option value="">-- Select Unused Cheque Number --</option>';
            leaves.forEach(l => {
                html += '<option value="' + l.chequeNumber + '">' + l.chequeNumber + '</option>';
            });
            selectEl.innerHTML = html;
        }

        // Ledger History Loading
        let historyData = [];
        let historyLoadTimeout = null;

        function triggerHistoryLoad() {
            clearTimeout(historyLoadTimeout);
            historyLoadTimeout = setTimeout(loadHistoryLedger, 300);
        }

        function toggleCustomDateFields(val) {
            const container = document.getElementById('customDateContainer');
            if (container) {
                if (val === 'custom') {
                    container.style.display = 'grid';
                } else {
                    container.style.display = 'none';
                }
            }
        }

        function loadHistoryLedger() {
            const tbody = document.getElementById('tbodyHistoryLedger');
            if (!tbody) return;

            const custName = document.getElementById('filterCustName').value;
            const accNum = document.getElementById('filterAccNum').value;
            const type = document.getElementById('filterType').value;
            const status = document.getElementById('filterStatus').value;
            const dateFilter = document.getElementById('filterDate').value;
            const startDate = document.getElementById('filterStartDate').value;
            const endDate = document.getElementById('filterEndDate').value;
            const queryText = document.getElementById('filterQueryText').value;

            tbody.innerHTML = `<tr>
                <td colspan="8" style="padding: 40px; text-align: center; color: var(--gray-400);">
                    <i class="bx bx-loader-alt bx-spin" style="font-size: 2rem; margin-bottom: 10px; color: var(--primary-500);"></i>
                    <div>Querying system ledger database...</div>
                </td>
            </tr>`;

            const params = new URLSearchParams({
                action: 'getFilteredTransactionsJson',
                customerName: custName,
                accountNumber: accNum,
                transactionType: type,
                status: status,
                dateFilter: dateFilter,
                startDate: startDate,
                endDate: endDate,
                queryText: queryText
            });

            fetch('${pageContext.request.contextPath}/account?' + params.toString())
                .then(res => res.json())
                .then(data => {
                    historyData = data;
                    renderHistoryLedger(data);
                })
                .catch(err => {
                    console.error('Failed to load transaction history', err);
                    tbody.innerHTML = `<tr>
                        <td colspan="8" style="padding: 20px; text-align: center; color: var(--danger-500); font-weight: 500;">
                            Failed to load transaction ledger. Please check admin connection.
                        </td>
                    </tr>`;
                });
        }

        function renderHistoryLedger(txns) {
            const tbody = document.getElementById('tbodyHistoryLedger');
            if (!tbody) return;

            if (!txns || txns.length === 0) {
                tbody.innerHTML = `<tr>
                    <td colspan="8" style="padding: 40px; text-align: center; color: var(--gray-400);">
                        No transaction records match the specified filters.
                    </td>
                </tr>`;
                return;
            }

            let html = '';
            txns.forEach(t => {
                const dateStr = t.transactionDate ? t.transactionDate.replace('T', ' ') : '-';
                
                // Color badges based on status and type
                let typeColor = 'var(--gray-600)';
                if (t.transactionType === 'deposit') typeColor = '#10b981';
                else if (t.transactionType === 'withdrawal') typeColor = '#ef4444';
                else if (t.transactionType === 'transfer') typeColor = '#3b82f6';
                else if (t.transactionType === 'fee') typeColor = '#f59e0b';
                
                let statusBg = 'rgba(16, 185, 129, 0.08)';
                let statusColor = '#10b981';
                if (t.status === 'pending') {
                    statusBg = 'rgba(245, 158, 11, 0.08)';
                    statusColor = '#d97706';
                } else if (t.status === 'failed') {
                    statusBg = 'rgba(239, 68, 68, 0.08)';
                    statusColor = '#ef4444';
                } else if (t.status === 'reversed') {
                    statusBg = 'rgba(107, 114, 128, 0.08)';
                    statusColor = '#6b7280';
                }

                const senderAcc = t.senderAccountNumber || '-';
                let receiverAcc = t.receiverAccountNumber || '-';
                if (t.beneficiaryName) {
                    receiverAcc = t.beneficiaryName + ' (Ext A/C: ' + t.receiverAccountNumber + ')';
                }

                html += `<tr onclick="showReceipt(${t.transactionId})" style="border-bottom: 1px solid var(--gray-100); hover: background-color: var(--gray-50); cursor: pointer; transition: all 0.2s;">
                    <td style="padding: 12px 15px; font-weight: 700; color: var(--gray-800);">
                        <div>#${t.transactionId}</div>
                        <div style="font-size: 0.72rem; color: var(--gray-400); font-family: monospace;">${t.referenceNumber}</div>
                    </td>
                    <td style="padding: 12px 15px; color: var(--gray-600); font-size: 0.8rem;">${dateStr}</td>
                    <td style="padding: 12px 15px; text-transform: uppercase; font-weight: 700; color: ${typeColor}; font-size: 0.75rem;">${t.transactionType}</td>
                    <td style="padding: 12px 15px; color: var(--gray-700); font-weight: 500;">${senderAcc}</td>
                    <td style="padding: 12px 15px; color: var(--gray-700); font-weight: 500;">${receiverAcc}</td>
                    <td style="padding: 12px 15px; text-align: right; font-weight: 700; color: var(--gray-800); font-size: 0.9rem;">₹${parseFloat(t.amount).toFixed(2)}</td>
                    <td style="padding: 12px 15px; text-transform: uppercase; font-weight: 600; color: var(--gray-500); font-size: 0.75rem;">${t.transferMode || 'Cash'}</td>
                    <td style="padding: 12px 15px; text-align: center;">
                        <span style="display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 0.72rem; font-weight: 700; background: ${statusBg}; color: ${statusColor}; text-transform: uppercase;">
                            ${t.status}
                        </span>
                    </td>
                </tr>`;
            });
            tbody.innerHTML = html;
        }

        // Receipt Modal operations
        function showReceipt(txnId) {
            const t = historyData.find(x => x.transactionId === txnId);
            if (!t) return;

            document.getElementById('recTxnId').textContent = '#' + t.transactionId;
            document.getElementById('recRefNum').textContent = t.referenceNumber;
            document.getElementById('recDateTime').textContent = t.transactionDate ? t.transactionDate.replace('T', ' ') : '-';
            document.getElementById('recType').textContent = t.transactionType.toUpperCase();
            document.getElementById('recMode').textContent = t.transferMode || 'Cash';
            document.getElementById('recSender').textContent = t.senderAccountNumber || 'Counter Vault';
            document.getElementById('recReceiver').textContent = t.receiverAccountNumber || 'Counter Cashier';
            document.getElementById('recStatus').textContent = t.status.toUpperCase();
            document.getElementById('recAmount').textContent = '₹' + parseFloat(t.amount).toFixed(2);
            document.getElementById('recPerfBy').textContent = t.performedById ? 'Admin (ID: ' + t.performedById + ')' : 'System / Auto';

            if (t.beneficiaryName) {
                document.getElementById('rowRecBeneficiary').style.display = 'table-row';
                document.getElementById('recBeneficiaryVal').innerHTML = 
                    'Name: ' + t.beneficiaryName + '<br>' +
                    'Bank: ' + (t.beneficiaryBank || 'Other Bank') + '<br>' +
                    'Branch: ' + (t.beneficiaryBranch || '-') + '<br>' +
                    'IFSC: ' + (t.beneficiaryIfsc || '-');
            } else {
                document.getElementById('rowRecBeneficiary').style.display = 'none';
            }

            // Style status
            const statusEl = document.getElementById('recStatus');
            if (t.status === 'completed') statusEl.style.color = '#10b981';
            else if (t.status === 'pending') statusEl.style.color = '#f59e0b';
            else statusEl.style.color = '#ef4444';

            document.getElementById('receiptModal').style.display = 'flex';
        }

        function closeReceiptModal() {
            document.getElementById('receiptModal').style.display = 'none';
        }

        function printReceipt() {
            document.body.classList.add('print-receipt-active');
            window.print();
            document.body.classList.remove('print-receipt-active');
        }

        // Export to Excel (CSV format)
        function exportToCSV() {
            if (!historyData || historyData.length === 0) {
                alert('No transaction records available to export.');
                return;
            }

            let csvContent = '\uFEFF'; // Excel UTF-8 BOM
            csvContent += 'Transaction ID,Reference Number,Date & Time,Type,Sender Account,Receiver/Target Account,Beneficiary Name,Beneficiary IFSC,Beneficiary Bank,Beneficiary Branch,Amount,Mode,Performed By ID,Status\n';

            historyData.forEach(t => {
                const row = [
                    t.transactionId,
                    t.referenceNumber,
                    t.transactionDate ? t.transactionDate.replace('T', ' ') : '',
                    t.transactionType,
                    t.senderAccountNumber || '',
                    t.receiverAccountNumber || '',
                    t.beneficiaryName || '',
                    t.beneficiaryIfsc || '',
                    t.beneficiaryBank || '',
                    t.beneficiaryBranch || '',
                    t.amount,
                    t.transferMode || 'Cash',
                    t.performedById || '',
                    t.status
                ].map(val => {
                    const text = String(val).replace(/"/g, '""');
                    return text.includes(',') || text.includes('\n') || text.includes('"') ? '"' + text + '"' : text;
                }).join(',');
                csvContent += row + '\n';
            });

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', 'VGB_Transaction_Ledger_' + new Date().toISOString().substring(0,10) + '.csv');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        // Active State Selected Trackers
        let selectedDepositAcc = null;
        let selectedWithdrawAcc = null;
        let selectedTransferFrom = null;
        let selectedTransferTo = null;
        let selectedExtTransferFrom = null;
        let selectedRepayLoan = null;

        // Switched tab controls
        function switchCounterPane(paneType) {
            document.querySelectorAll('.counter-pane').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.counter-tab-btn').forEach(el => el.classList.remove('active'));

            if (paneType === 'deposit') {
                document.getElementById('paneDeposit').classList.add('active');
                document.getElementById('btnTabDeposit').classList.add('active');
            } else if (paneType === 'withdraw') {
                document.getElementById('paneWithdraw').classList.add('active');
                document.getElementById('btnTabWithdraw').classList.add('active');
            } else if (paneType === 'transfer') {
                document.getElementById('paneTransfer').classList.add('active');
                document.getElementById('btnTabTransfer').classList.add('active');
            } else if (paneType === 'external_transfer') {
                document.getElementById('paneExternalTransfer').classList.add('active');
                document.getElementById('btnTabExternalTransfer').classList.add('active');
            } else if (paneType === 'loanrepay') {
                document.getElementById('paneLoanRepay').classList.add('active');
                document.getElementById('btnTabLoanRepay').classList.add('active');
            } else if (paneType === 'history') {
                document.getElementById('paneHistory').classList.add('active');
                document.getElementById('btnTabHistory').classList.add('active');
                loadHistoryLedger();
            }
        }

        // Dropdown autocompletes builder
        function setupAutocomplete(inputId, dropdownId, hiddenInputId, wrapperId, onSelectCallback) {
            const input = document.getElementById(inputId);
            const dropdown = document.getElementById(dropdownId);
            const hidden = document.getElementById(hiddenInputId);
            const wrapper = document.getElementById(wrapperId);

            if (!input || !dropdown || !hidden || !wrapper) return;

            input.addEventListener('focus', () => {
                wrapper.classList.add('active');
                renderResults(input.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            input.addEventListener('input', (e) => {
                renderResults(e.target.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            document.addEventListener('click', (e) => {
                if (!wrapper.contains(e.target)) {
                    wrapper.classList.remove('active');
                    dropdown.style.display = 'none';
                }
            });
        }

        function renderResults(query, dropdown, input, hidden, wrapper, onSelectCallback) {
            const q = query.toLowerCase().trim();
            dropdown.innerHTML = '';

            const filtered = allAccounts.filter(acc => {
                if (acc.status !== 'active') return false;
                const numMatch = acc.accountNumber.toLowerCase().includes(q);
                const custMatch = acc.customerName.toLowerCase().includes(q);
                const busMatch = acc.businessName.toLowerCase().includes(q);
                return numMatch || custMatch || busMatch;
            });

            if (filtered.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'search-select-empty';
                empty.innerText = 'No matching active accounts found';
                dropdown.appendChild(empty);
            } else {
                filtered.forEach(acc => {
                    const item = document.createElement('div');
                    item.className = 'search-select-item';

                    const title = document.createElement('span');
                    title.className = 'search-select-item-title';
                    const ownerName = acc.businessName ? acc.businessName + ' (Business)' : acc.customerName;
                    title.innerText = ownerName + ' | ' + acc.accountType.toUpperCase();

                    const subtitle = document.createElement('span');
                    subtitle.className = 'search-select-item-subtitle';
                    subtitle.innerText = 'Acc: ' + acc.accountNumber + ' | Bal: ₹' + acc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 });

                    item.appendChild(title);
                    item.appendChild(subtitle);

                    item.addEventListener('click', () => {
                        input.value = ownerName + ' (' + acc.accountNumber + ')';
                        hidden.value = acc.accountId;
                        dropdown.style.display = 'none';
                        wrapper.classList.remove('active');
                        if (onSelectCallback) onSelectCallback(acc);
                    });

                    dropdown.appendChild(item);
                });
            }

            dropdown.style.display = 'block';
        }

        // Live Clock Initializer
        function initLiveClocks() {
            const displays = document.querySelectorAll('.clock-display');
            function tick() {
                const now = new Date();
                const optDate = { day: '2-digit', month: 'short', year: 'numeric' };
                const dateStr = now.toLocaleDateString('en-IN', optDate).replace(/ /g, '-');
                const timeStr = now.toLocaleTimeString('en-IN', { hour12: false });
                displays.forEach(el => {
                    el.innerText = dateStr + ' ' + timeStr;
                });
            }
            setInterval(tick, 1000);
            tick();
        }

        // 1. Recalculate Payouts
        function recalcDepositPayout() {
            const amtVal = parseFloat(document.getElementById('numDepositAmt').value) || 0;
            const container = document.getElementById('depositAlertContainer');
            container.innerHTML = '';

            if (!selectedDepositAcc) return;

            const card = document.getElementById('cardDepositPreview');
            const ownerName = selectedDepositAcc.businessName ? selectedDepositAcc.businessName + ' (Business)' : selectedDepositAcc.customerName;
            const newBal = selectedDepositAcc.balance + amtVal;

            card.innerHTML = 
                '<div class="verified-badge"><i class="bx bx-shield-quarter"></i> Verified Target Account</div>' +
                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Owner Name</span>' +
                        '<strong style="color: var(--gray-800); font-size: 0.9rem;">' + ownerName + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Number</span>' +
                        '<strong style="color: var(--gray-800); font-family: monospace; font-size: 0.9rem;">' + selectedDepositAcc.accountNumber + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Type</span>' +
                        '<strong style="color: var(--gray-700); font-size: 0.85rem; text-transform: capitalize;">' + selectedDepositAcc.accountType + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">IFSC Code</span>' +
                        '<strong style="color: var(--gray-700); font-family: monospace; font-size: 0.85rem;">' + selectedDepositAcc.ifscCode + '</strong>' +
                    '</div>' +
                    '<div style="grid-column: span 2; border-top: 1px solid var(--gray-100); padding-top: 12px; margin-top: 5px; display: flex; justify-content: space-between; align-items: center;">' +
                        '<div>' +
                            '<span style="display: block; font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Balance</span>' +
                            '<span style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">₹ ' + selectedDepositAcc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</span>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<span style="display: block; font-size: 0.72rem; color: var(--primary-400); text-transform: uppercase; font-weight: 600;">Balance Post-Deposit</span>' +
                            '<strong style="color: var(--accent-emerald); font-size: 1.15rem;">₹ ' + newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            card.classList.add('selected');
        }

        function recalcWithdrawPayout() {
            const amtVal = parseFloat(document.getElementById('numWithdrawAmt').value) || 0;
            const alertContainer = document.getElementById('withdrawAlertContainer');
            alertContainer.innerHTML = '';

            if (!selectedWithdrawAcc) return;

            const card = document.getElementById('cardWithdrawPreview');
            const ownerName = selectedWithdrawAcc.businessName ? selectedWithdrawAcc.businessName + ' (Business)' : selectedWithdrawAcc.customerName;
            const newBal = selectedWithdrawAcc.balance - amtVal;

            card.innerHTML = 
                '<div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Verified Source Account</div>' +
                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Owner Name</span>' +
                        '<strong style="color: var(--gray-800); font-size: 0.9rem;">' + ownerName + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Number</span>' +
                        '<strong style="color: var(--gray-800); font-family: monospace; font-size: 0.9rem;">' + selectedWithdrawAcc.accountNumber + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Type</span>' +
                        '<strong style="color: var(--gray-700); font-size: 0.85rem; text-transform: capitalize;">' + selectedWithdrawAcc.accountType + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">IFSC Code</span>' +
                        '<strong style="color: var(--gray-700); font-family: monospace; font-size: 0.85rem;">' + selectedWithdrawAcc.ifscCode + '</strong>' +
                    '</div>' +
                    '<div style="grid-column: span 2; border-top: 1px solid var(--gray-100); padding-top: 12px; margin-top: 5px; display: flex; justify-content: space-between; align-items: center;">' +
                        '<div>' +
                            '<span style="display: block; font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Balance</span>' +
                            '<span style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">₹ ' + selectedWithdrawAcc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</span>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<span style="display: block; font-size: 0.72rem; color: var(--primary-400); text-transform: uppercase; font-weight: 600;">Remaining Balance</span>' +
                            '<strong style="color: ' + (newBal < 0 ? '#ef4444' : 'var(--gray-800)') + '; font-size: 1.1rem;">₹ ' + newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            card.classList.add('selected');

            // Limit warning checks
            if (amtVal > 300000) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Withdrawal limit exceeded (Max ₹3,00,000 per cash transaction).</span>
                    </div>
                `;
            } else if (amtVal > selectedWithdrawAcc.balance) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-danger">
                        <i class="bx bx-error-circle"></i>
                        <span>Insufficient funds (Amount exceeds available counter balance).</span>
                    </div>
                `;
            }
        }

        function recalcTransferPayout() {
            const amtVal = parseFloat(document.getElementById('numTransferAmt').value) || 0;
            const alertContainer = document.getElementById('transferAlertContainer');
            alertContainer.innerHTML = '';

            const sourceCard = document.getElementById('cardTransferSourcePreview');
            const targetCard = document.getElementById('cardTransferTargetPreview');
            const arrow = document.getElementById('transferVisualArrow');

            if (selectedTransferFrom) {
                const ownerName = selectedTransferFrom.businessName ? selectedTransferFrom.businessName + ' (Business)' : selectedTransferFrom.customerName;
                const newBal = selectedTransferFrom.balance - amtVal;
                
                sourceCard.innerHTML = 
                    '<div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-log-out"></i> Verified Source Account (Debit)</div>' +
                    '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">' +
                        '<div style="grid-column: span 2;">' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Owner / Number</span>' +
                            '<strong style="font-size: 0.85rem; color: var(--gray-800);">' + ownerName + ' (' + selectedTransferFrom.accountNumber + ')</strong>' +
                        '</div>' +
                        '<div>' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Balance</span>' +
                            '<strong style="font-size: 0.85rem; color: var(--gray-700);">₹ ' + selectedTransferFrom.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--primary-400); text-transform: uppercase;">Remaining</span>' +
                            '<strong style="font-size: 0.88rem; color: ' + (newBal < 0 ? '#ef4444' : 'var(--gray-800)') + ';">₹ ' + newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                    '</div>';
                sourceCard.classList.add('selected');
            }

            if (selectedTransferTo) {
                const ownerName = selectedTransferTo.businessName ? selectedTransferTo.businessName + ' (Business)' : selectedTransferTo.customerName;
                const newBal = selectedTransferTo.balance + amtVal;

                targetCard.innerHTML = 
                    '<div class="verified-badge" style="background: rgba(16,185,129,0.08); color: var(--accent-emerald);"><i class="bx bx-log-in"></i> Verified Target Account (Credit)</div>' +
                    '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">' +
                        '<div style="grid-column: span 2;">' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Owner / Number</span>' +
                            '<strong style="font-size: 0.85rem; color: var(--gray-800);">' + ownerName + ' (' + selectedTransferTo.accountNumber + ')</strong>' +
                        '</div>' +
                        '<div>' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Balance</span>' +
                            '<strong style="font-size: 0.85rem; color: var(--gray-700);">₹ ' + selectedTransferTo.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--primary-400); text-transform: uppercase;">Post-Credit</span>' +
                            '<strong style="font-size: 0.88rem; color: var(--accent-emerald);">₹ ' + newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                    '</div>';
                targetCard.classList.add('selected');
            }

            if (selectedTransferFrom && selectedTransferTo) {
                arrow.style.display = 'flex';
                
                if (selectedTransferFrom.accountId === selectedTransferTo.accountId) {
                    alertContainer.innerHTML = `
                        <div class="counter-alert-danger">
                            <i class="bx bx-error-circle"></i>
                            <span>Source and target accounts must be different.</span>
                        </div>
                    `;
                    return;
                }
            }

            // Transfer Limits check
            if (amtVal > 350000) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Transfer limit exceeded (Max ₹3,50,000 per routing wire transaction).</span>
                    </div>
                `;
            } else if (selectedTransferFrom && amtVal > selectedTransferFrom.balance) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-danger">
                        <i class="bx bx-error-circle"></i>
                        <span>Insufficient funds in source account.</span>
                    </div>
                `;
            }
        }

        // Form Submit Validators
        function validateDepositForm() {
            if (!selectedDepositAcc) {
                shakePane('paneDeposit');
                alert("Please select a target active account profile.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numDepositAmt').value) || 0;
            if (amtVal <= 0) {
                shakePane('paneDeposit');
                alert("Deposit amount must be greater than zero.");
                return false;
            }
            const ownerName = selectedDepositAcc.businessName ? selectedDepositAcc.businessName : selectedDepositAcc.customerName;
            return confirm(`Are you sure you want to deposit ₹${amtVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })} into Account #${selectedDepositAcc.accountNumber} (${ownerName})?`);
        }

        function validateWithdrawForm() {
            if (!selectedWithdrawAcc) {
                shakePane('paneWithdraw');
                alert("Please select a source active account profile.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numWithdrawAmt').value) || 0;
            if (amtVal <= 0) {
                shakePane('paneWithdraw');
                alert("Withdrawal amount must be greater than zero.");
                return false;
            }
            if (amtVal > 300000) {
                shakePane('paneWithdraw');
                alert("Withdrawal amount cannot exceed ₹3,00,000.");
                return false;
            }
            if (amtVal > selectedWithdrawAcc.balance) {
                shakePane('paneWithdraw');
                alert("Insufficient available balance for this payout.");
                return false;
            }

            const mode = document.querySelector('input[name="paymentMode"]:checked').value;
            if (mode === 'cheque') {
                const cb = document.getElementById('selWithdrawChequeBook').value;
                const chq = document.getElementById('selWithdrawChequeNo').value;
                if (!cb || !chq) {
                    shakePane('paneWithdraw');
                    alert("Please select a valid Cheque Book and Cheque Leaf Number.");
                    return false;
                }
            }

            const ownerName = selectedWithdrawAcc.businessName ? selectedWithdrawAcc.businessName : selectedWithdrawAcc.customerName;
            return confirm(`Are you sure you want to withdraw ₹${amtVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })} from Account #${selectedWithdrawAcc.accountNumber} (${ownerName})?`);
        }

        function validateTransferForm() {
            if (!selectedTransferFrom || !selectedTransferTo) {
                shakePane('paneTransfer');
                alert("Please choose both source and target active accounts.");
                return false;
            }
            if (selectedTransferFrom.accountId === selectedTransferTo.accountId) {
                shakePane('paneTransfer');
                alert("Source and target accounts must be different.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numTransferAmt').value) || 0;
            if (amtVal <= 0) {
                shakePane('paneTransfer');
                alert("Transfer amount must be greater than zero.");
                return false;
            }
            if (amtVal > 350000) {
                shakePane('paneTransfer');
                alert("Transfer amount cannot exceed ₹3,50,000.");
                return false;
            }
            if (amtVal > selectedTransferFrom.balance) {
                shakePane('paneTransfer');
                alert("Insufficient funds in the source account for transfer.");
                return false;
            }

            const mode = document.querySelector('input[name="paymentMode"]:checked').value;
            if (mode === 'cheque') {
                const cb = document.getElementById('selTransferChequeBook').value;
                const chq = document.getElementById('selTransferChequeNo').value;
                if (!cb || !chq) {
                    shakePane('paneTransfer');
                    alert("Please select a valid Cheque Book and Cheque Leaf Number.");
                    return false;
                }
            }

            const fromName = selectedTransferFrom.businessName ? selectedTransferFrom.businessName : selectedTransferFrom.customerName;
            const toName = selectedTransferTo.businessName ? selectedTransferTo.businessName : selectedTransferTo.customerName;
            return confirm(`Are you sure you want to transfer ₹${amtVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })} from Account #${selectedTransferFrom.accountNumber} (${fromName}) to Account #${selectedTransferTo.accountNumber} (${toName})?`);
        }

        function recalcExternalTransferPayout() {
            const amtVal = parseFloat(document.getElementById('numExtTransferAmt').value) || 0;
            const beneName = document.getElementById('txtExtBeneficiaryName').value.trim() || 'N/A';
            const beneAcc = document.getElementById('txtExtBeneficiaryAcc').value.trim() || 'N/A';
            const beneIfsc = document.getElementById('txtExtBeneficiaryIfsc').value.trim().toUpperCase() || 'N/A';
            const beneBank = document.getElementById('txtExtBeneficiaryBank').value.trim() || 'N/A';
            const beneBranch = document.getElementById('txtExtBeneficiaryBranch').value.trim() || '';

            const alertContainer = document.getElementById('extTransferAlertContainer');
            alertContainer.innerHTML = '';

            const sourceCard = document.getElementById('cardExtTransferSourcePreview');
            const targetCard = document.getElementById('cardExtTransferTargetPreview');
            const arrow = document.getElementById('extTransferVisualArrow');

            if (selectedExtTransferFrom) {
                const ownerName = selectedExtTransferFrom.businessName ? selectedExtTransferFrom.businessName + ' (Business)' : selectedExtTransferFrom.customerName;
                const newBal = selectedExtTransferFrom.balance - amtVal;
                
                sourceCard.innerHTML = 
                    '<div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-log-out"></i> Verified Source Account (Debit)</div>' +
                    '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">' +
                        '<div style="grid-column: span 2;">' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Owner / Number</span>' +
                            '<strong style="font-size: 0.85rem; color: var(--gray-800);">' + ownerName + ' (' + selectedExtTransferFrom.accountNumber + ')</strong>' +
                        '</div>' +
                        '<div>' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Balance</span>' +
                            '<strong style="font-size: 0.85rem; color: var(--gray-700);">₹ ' + selectedExtTransferFrom.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<span style="display: block; font-size: 0.7rem; color: var(--primary-400); text-transform: uppercase;">Remaining</span>' +
                            '<strong style="font-size: 0.88rem; color: ' + (newBal < 0 ? '#ef4444' : 'var(--gray-800)') + ';">₹ ' + newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                    '</div>';
                sourceCard.classList.add('selected');
            }

            targetCard.innerHTML = 
                '<div class="verified-badge" style="background: rgba(245, 158, 11, 0.08); color: #d97706;"><i class="bx bx-user-voice"></i> External Recipient Details</div>' +
                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">' +
                    '<div style="grid-column: span 2;">' +
                        '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Beneficiary / A/C</span>' +
                        '<strong style="font-size: 0.85rem; color: var(--gray-800);">' + beneName + ' (' + beneAcc + ')</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Bank / IFSC</span>' +
                        '<strong style="font-size: 0.8rem; color: var(--gray-700);">' + beneBank + ' | ' + beneIfsc + '</strong>' +
                    '</div>' +
                    '<div style="text-align: right;">' +
                        '<span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Branch / Amount</span>' +
                        '<strong style="font-size: 0.8rem; color: var(--gray-700);">' + (beneBranch ? beneBranch : 'N/A') + ' | ₹' + amtVal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                    '</div>' +
                '</div>';
            targetCard.classList.add('selected');

            if (selectedExtTransferFrom) {
                arrow.style.display = 'flex';
            }

            if (amtVal > 350000) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Transfer limit exceeded (Max ₹3,50,000 per routing wire transaction).</span>
                    </div>
                `;
            } else if (selectedExtTransferFrom && amtVal > selectedExtTransferFrom.balance) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-danger">
                        <i class="bx bx-error-circle"></i>
                        <span>Insufficient funds in source account.</span>
                    </div>
                `;
            }
        }

        function validateExternalTransferForm() {
            if (!selectedExtTransferFrom) {
                shakePane('paneExternalTransfer');
                alert("Please select a source active account profile.");
                return false;
            }
            const beneName = document.getElementById('txtExtBeneficiaryName').value.trim();
            const beneAcc = document.getElementById('txtExtBeneficiaryAcc').value.trim();
            const beneIfsc = document.getElementById('txtExtBeneficiaryIfsc').value.trim();
            const beneBank = document.getElementById('txtExtBeneficiaryBank').value.trim();

            if (!beneName || !beneAcc || !beneIfsc || !beneBank) {
                shakePane('paneExternalTransfer');
                alert("Please fill in all required beneficiary details.");
                return false;
            }

            const amtVal = parseFloat(document.getElementById('numExtTransferAmt').value) || 0;
            if (amtVal <= 0) {
                shakePane('paneExternalTransfer');
                alert("Transfer amount must be greater than zero.");
                return false;
            }
            if (amtVal > 350000) {
                shakePane('paneExternalTransfer');
                alert("Transfer amount cannot exceed ₹3,50,000.");
                return false;
            }
            if (amtVal > selectedExtTransferFrom.balance) {
                shakePane('paneExternalTransfer');
                alert("Insufficient funds in the source account.");
                return false;
            }

            const mode = document.querySelector('input[name="paymentMode"]:checked').value;
            if (mode === 'cheque') {
                const cb = document.getElementById('selExtTransferChequeBook').value;
                const chq = document.getElementById('selExtTransferChequeNo').value;
                if (!cb || !chq) {
                    shakePane('paneExternalTransfer');
                    alert("Please select a valid Cheque Book and Cheque Leaf Number.");
                    return false;
                }
            }

            return confirm(`Are you sure you want to process an external transfer of ₹${amtVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })} from Account #${selectedExtTransferFrom.accountNumber} to ${beneName} (${beneBank})?`);
        }

        function shakePane(id) {
            const pane = document.getElementById(id);
            if (pane) {
                pane.classList.add('shake-input');
                setTimeout(() => {
                    pane.classList.remove('shake-input');
                }, 500);
            }
        }

        // ===== LOAN REPAYMENT TELLER METHODS =====
        function populateRepayAccounts(customerId) {
            const select = document.getElementById('repayAccount');
            select.innerHTML = '<option value="">-- Select Active Account --</option>';

            const customerAccounts = allAccounts.filter(acc => acc.customerId.toString() === customerId.toString() && acc.status.toLowerCase() === 'active');

            if (customerAccounts.length === 0) {
                const opt = document.createElement('option');
                opt.value = "";
                opt.textContent = "No active accounts found for this customer";
                select.appendChild(opt);
            } else {
                customerAccounts.forEach(acc => {
                    const opt = document.createElement('option');
                    opt.value = acc.accountId;
                    opt.textContent = "Account #" + acc.accountNumber + " (" + acc.accountType.toUpperCase() + ") - Bal: ₹" + parseFloat(acc.balance).toLocaleString('en-IN', { minimumFractionDigits: 2 });
                    select.appendChild(opt);
                });
            }
        }

        function recalcLoanRepayPayout() {
            const amtVal = parseFloat(document.getElementById('numRepayAmt').value) || 0;
            const alertContainer = document.getElementById('loanRepayAlertContainer');
            alertContainer.innerHTML = '';

            const select = document.getElementById('repayAccount');
            const selectedAccId = select.value;
            const selectedAcc = allAccounts.find(acc => acc.accountId.toString() === selectedAccId.toString());

            if (!selectedRepayLoan) return;

            const card = document.getElementById('cardLoanRepayPreview');
            const remBal = parseFloat(selectedRepayLoan.remainingBalance);
            const postRepayBal = remBal - amtVal;

            let accountDetailsHTML = '';
            if (selectedAcc) {
                const accBal = parseFloat(selectedAcc.balance);
                const postAccBal = accBal - amtVal;
                accountDetailsHTML = 
                    '<div style="grid-column: span 2; border-top: 1px dashed var(--gray-200); padding-top: 10px; margin-top: 5px;">' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Selected Source Account Details</span>' +
                        '<div style="display: flex; justify-content: space-between; align-items: center; margin-top: 5px;">' +
                            '<span style="font-size: 0.85rem; color: var(--gray-600); font-family: monospace;">Acc #' + selectedAcc.accountNumber + '</span>' +
                            '<span style="font-size: 0.85rem; color: ' + (postAccBal < 0 ? '#ef4444' : 'var(--gray-800)') + '; font-weight: 600;">' +
                                '₹ ' + accBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + ' ➡️ ₹ ' + postAccBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) +
                            '</span>' +
                        '</div>' +
                    '</div>';

                if (amtVal > accBal) {
                    alertContainer.innerHTML = `
                        <div class="counter-alert-danger">
                            <i class="bx bx-error-circle"></i>
                            <span>Insufficient funds (Amount exceeds source account balance).</span>
                        </div>
                    `;
                }
            }

            card.innerHTML = 
                '<div class="verified-badge" style="background: rgba(16, 185, 129, 0.08); color: var(--accent-emerald);"><i class="bx bx-shield-quarter"></i> Verified Loan Profile</div>' +
                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Borrower Name</span>' +
                        '<strong style="color: var(--gray-800); font-size: 0.9rem;">' + selectedRepayLoan.customerName + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Loan Account ID</span>' +
                        '<strong style="color: var(--gray-800); font-family: monospace; font-size: 0.9rem;">#LN-' + selectedRepayLoan.loanId + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Loan Category</span>' +
                        '<strong style="color: var(--gray-700); font-size: 0.85rem; text-transform: capitalize;">' + selectedRepayLoan.loanType + '</strong>' +
                    '</div>' +
                    '<div>' +
                        '<span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Status</span>' +
                        '<strong style="color: var(--primary-500); font-size: 0.85rem; text-transform: uppercase;">' + selectedRepayLoan.status + '</strong>' +
                    '</div>' +
                    '<div style="grid-column: span 2; border-top: 1px solid var(--gray-100); padding-top: 12px; margin-top: 5px; display: flex; justify-content: space-between; align-items: center;">' +
                        '<div>' +
                            '<span style="display: block; font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Remaining Balance</span>' +
                            '<span style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">₹ ' + remBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</span>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<span style="display: block; font-size: 0.72rem; color: var(--primary-400); text-transform: uppercase; font-weight: 600;">Balance Post-Repayment</span>' +
                            '<strong style="color: ' + (postRepayBal < 0 ? '#ef4444' : 'var(--gray-800)') + '; font-size: 1.15rem;">₹ ' + postRepayBal.toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</strong>' +
                        '</div>' +
                    '</div>' +
                    accountDetailsHTML +
                '</div>';
            card.classList.add('selected');

            if (amtVal > remBal) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Amount exceeds remaining loan balance (₹${remBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}). Extra payment is not allowed.</span>
                    </div>
                `;
            }
        }

        function validateLoanRepayForm() {
            if (!selectedRepayLoan) {
                shakePane('paneLoanRepay');
                alert("Please select an active loan profile.");
                return false;
            }
            const select = document.getElementById('repayAccount');
            if (!select.value) {
                shakePane('paneLoanRepay');
                alert("Please select a customer source checking/savings account to debit.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numRepayAmt').value) || 0;
            if (amtVal <= 0) {
                shakePane('paneLoanRepay');
                alert("Please enter a valid repayment amount.");
                return false;
            }
            const remBal = parseFloat(selectedRepayLoan.remainingBalance);
            if (amtVal > remBal) {
                shakePane('paneLoanRepay');
                alert("Repayment amount cannot exceed the remaining loan balance.");
                return false;
            }
            const selectedAcc = allAccounts.find(acc => acc.accountId.toString() === select.value.toString());
            if (selectedAcc && amtVal > parseFloat(selectedAcc.balance)) {
                shakePane('paneLoanRepay');
                alert("Insufficient funds in the selected customer source account.");
                return false;
            }
            return confirm(`Are you sure you want to pay ₹${amtVal.toLocaleString('en-IN', { minimumFractionDigits: 2 })} for Loan #LN-${selectedRepayLoan.loanId} from Account #${selectedAcc.accountNumber}?`);
        }

        function renderLoanResults(query, dropdown, input, hidden, wrapper, onSelectCallback) {
            const q = query.toLowerCase().trim();
            dropdown.innerHTML = '';

            const filtered = allLoans.filter(loan => {
                const idMatch = loan.loanId.toLowerCase().includes(q);
                const nameMatch = loan.customerName.toLowerCase().includes(q);
                const typeMatch = loan.loanType.toLowerCase().includes(q);
                return idMatch || nameMatch || typeMatch;
            });

            if (filtered.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'search-select-empty';
                empty.innerText = 'No matching active/disbursed loans found';
                dropdown.appendChild(empty);
            } else {
                filtered.forEach(loan => {
                    const item = document.createElement('div');
                    item.className = 'search-select-item';

                    const title = document.createElement('span');
                    title.className = 'search-select-item-title';
                    title.innerText = loan.customerName + ' | ' + loan.loanType.toUpperCase() + ' LOAN';

                    const subtitle = document.createElement('span');
                    subtitle.className = 'search-select-item-subtitle';
                    subtitle.innerText = 'Loan ID: #LN-' + loan.loanId + ' | Bal: ₹' + parseFloat(loan.remainingBalance).toLocaleString('en-IN', { minimumFractionDigits: 2 });

                    item.appendChild(title);
                    item.appendChild(subtitle);

                    item.addEventListener('click', () => {
                        input.value = loan.customerName + ' (LN-' + loan.loanId + ')';
                        hidden.value = loan.loanId;
                        document.getElementById('hidRepayCustomerId').value = loan.customerId;
                        dropdown.style.display = 'none';
                        wrapper.classList.remove('active');
                        if (onSelectCallback) onSelectCallback(loan);
                    });

                    dropdown.appendChild(item);
                });
            }

            dropdown.style.display = 'block';
        }

        function setupLoanAutocomplete(inputId, dropdownId, hiddenInputId, wrapperId, onSelectCallback) {
            const input = document.getElementById(inputId);
            const dropdown = document.getElementById(dropdownId);
            const hidden = document.getElementById(hiddenInputId);
            const wrapper = document.getElementById(wrapperId);

            if (!input || !dropdown || !hidden || !wrapper) return;

            input.addEventListener('focus', () => {
                wrapper.classList.add('active');
                renderLoanResults(input.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            input.addEventListener('input', (e) => {
                renderLoanResults(e.target.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            document.addEventListener('click', (e) => {
                if (!wrapper.contains(e.target)) {
                    wrapper.classList.remove('active');
                    dropdown.style.display = 'none';
                }
            });
        }

        // Document Ready Bindings
        document.addEventListener('DOMContentLoaded', () => {
            initLiveClocks();

            // Set up Autocomplete dropdowns
            setupAutocomplete(
                'txtDepositAcc', 
                'dropdownDepositAcc', 
                'hidDepositAccId', 
                'selectDepositAccWrapper', 
                (acc) => {
                    selectedDepositAcc = acc;
                    recalcDepositPayout();
                }
            );

            setupAutocomplete(
                'txtWithdrawAcc', 
                'dropdownWithdrawAcc', 
                'hidWithdrawAccId', 
                'selectWithdrawAccWrapper', 
                (acc) => {
                    selectedWithdrawAcc = acc;
                    recalcWithdrawPayout();
                    const mode = document.querySelector('input[name="paymentMode"]:checked');
                    if (mode && mode.value === 'cheque') {
                        loadChequeBooks('withdraw', acc.accountId);
                    }
                }
            );

            setupAutocomplete(
                'txtTransferFrom', 
                'dropdownTransferFrom', 
                'hidTransferFromId', 
                'selectTransferFromWrapper', 
                (acc) => {
                    selectedTransferFrom = acc;
                    recalcTransferPayout();
                    const mode = document.querySelector('input[name="paymentMode"]:checked');
                    if (mode && mode.value === 'cheque') {
                        loadChequeBooks('transfer', acc.accountId);
                    }
                }
            );

            setupAutocomplete(
                'txtTransferTo', 
                'dropdownTransferTo', 
                'hidTransferToId', 
                'selectTransferToWrapper', 
                (acc) => {
                    selectedTransferTo = acc;
                    recalcTransferPayout();
                }
            );

            setupAutocomplete(
                'txtExtTransferFrom', 
                'dropdownExtTransferFrom', 
                'hidExtTransferFromId', 
                'selectExtTransferFromWrapper', 
                (acc) => {
                    selectedExtTransferFrom = acc;
                    recalcExternalTransferPayout();
                    const mode = document.querySelector('input[name="paymentMode"]:checked');
                    if (mode && mode.value === 'cheque') {
                        loadChequeBooks('ext_transfer', acc.accountId);
                    }
                }
            );

            setupLoanAutocomplete(
                'txtRepayLoan',
                'dropdownRepayLoan',
                'hidRepayLoanId',
                'selectRepayLoanWrapper',
                (loan) => {
                    selectedRepayLoan = loan;
                    populateRepayAccounts(loan.customerId);
                    recalcLoanRepayPayout();
                }
            );

            // Double Submission Lock & Loading State Interceptor
            document.querySelectorAll('form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    const btn = form.querySelector('button[type="submit"]');
                    if (btn) {
                        // Check if already processing
                        if (btn.disabled) return;
                        btn.disabled = true;
                        btn.innerHTML = '<i class="bx bx-loader-alt bx-spin"></i> Processing Transaction...';
                    }
                });
            });



            // Mobile menu toggle handler
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

            // Cursor glow follower
            const glow = document.querySelector('.cursor-glow');
            if (glow) {
                window.addEventListener('mousemove', (e) => {
                    const { clientX, clientY } = e;
                    requestAnimationFrame(() => {
                        glow.style.left = clientX + 'px';
                        glow.style.top = clientY + 'px';
                    });
                });
            }
        });
    </script>
    <!-- Transaction Receipt Modal (Print-friendly layout) -->
    <div id="receiptModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 10000; align-items: center; justify-content: center; padding: 20px;" class="print-hidden">
        <div style="background: white; width: 100%; max-width: 500px; border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); overflow: hidden; display: flex; flex-direction: column;">
            <!-- Header -->
            <div style="background: var(--primary-500); color: white; padding: 20px; display: flex; justify-content: space-between; align-items: center;">
                <h4 style="margin: 0; font-size: 1.1rem; font-weight: 600;">Transaction Receipt</h4>
                <button onclick="closeReceiptModal()" style="background: none; border: none; color: white; font-size: 1.5rem; cursor: pointer; display: flex; align-items: center;"><i class="bx bx-x"></i></button>
            </div>
            
            <!-- Receipt Printable Content -->
            <div id="receiptPrintArea" style="padding: 25px; overflow-y: auto; flex-grow: 1; font-family: 'Outfit', sans-serif;">
                <div style="text-align: center; margin-bottom: 20px; border-bottom: 2px dashed var(--gray-200); padding-bottom: 15px;">
                    <h3 style="margin: 0 0 5px 0; font-size: 1.5rem; font-weight: 800; color: var(--primary-600); letter-spacing: 0.5px;">VERTEX GALAXY BANK</h3>
                    <p style="margin: 0; font-size: 0.8rem; color: var(--gray-500); text-transform: uppercase;">Counter Service Branch</p>
                </div>
                
                <table style="width: 100%; font-size: 0.88rem; border-collapse: collapse; color: var(--gray-800);">
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500); width: 40%;">Transaction ID</td>
                        <td style="padding: 10px 0; text-align: right; font-weight: 700;" id="recTxnId">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Reference Number</td>
                        <td style="padding: 10px 0; text-align: right; font-weight: 700; font-family: monospace;" id="recRefNum">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Date &amp; Time</td>
                        <td style="padding: 10px 0; text-align: right;" id="recDateTime">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Transaction Type</td>
                        <td style="padding: 10px 0; text-align: right; text-transform: capitalize; font-weight: 600;" id="recType">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Payment Mode</td>
                        <td style="padding: 10px 0; text-align: right; text-transform: capitalize;" id="recMode">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Sender Account</td>
                        <td style="padding: 10px 0; text-align: right; font-weight: 600;" id="recSender">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Receiver Account</td>
                        <td style="padding: 10px 0; text-align: right; font-weight: 600;" id="recReceiver">-</td>
                    </tr>
                    <!-- External Beneficiary Row Group -->
                    <tr id="rowRecBeneficiary" style="border-bottom: 1px solid var(--gray-100); display: none;">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Beneficiary Details</td>
                        <td style="padding: 10px 0; text-align: right; font-size: 0.8rem; line-height: 1.4;" id="recBeneficiaryVal">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Performed By (ID)</td>
                        <td style="padding: 10px 0; text-align: right;" id="recPerfBy">-</td>
                    </tr>
                    <tr style="border-bottom: 1px solid var(--gray-100);">
                        <td style="padding: 10px 0; font-weight: 600; color: var(--gray-500);">Status</td>
                        <td style="padding: 10px 0; text-align: right; font-weight: 700;" id="recStatus">-</td>
                    </tr>
                    <tr>
                        <td style="padding: 15px 0 10px 0; font-weight: 700; font-size: 1.1rem; color: var(--gray-800);">Amount Paid</td>
                        <td style="padding: 15px 0 10px 0; text-align: right; font-weight: 800; font-size: 1.3rem; color: var(--primary-600);" id="recAmount">-</td>
                    </tr>
                </table>
                
                <div style="margin-top: 25px; text-align: center; font-size: 0.75rem; color: var(--gray-400); border-top: 1px dashed var(--gray-200); padding-top: 15px;">
                    Thank you for banking with Vertex Galaxy Bank. This is a computer-generated transaction receipt.
                </div>
            </div>
            
            <!-- Footer Actions -->
            <div style="background: var(--gray-50); padding: 15px; display: flex; gap: 10px; justify-content: flex-end; border-top: 1px solid var(--gray-200);">
                <button type="button" onclick="closeReceiptModal()" style="border: 1.5px solid var(--gray-300); background: white; color: var(--gray-700); padding: 8px 16px; border-radius: var(--radius-md); font-size: 0.85rem; font-weight: 500; cursor: pointer;">Close</button>
                <button type="button" onclick="printReceipt()" style="background: var(--primary-500); border: none; color: white; padding: 8px 16px; border-radius: var(--radius-md); font-size: 0.85rem; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 6px;">
                    <i class="bx bx-printer"></i> Print Receipt
                </button>
            </div>
        </div>
    </div>
</body>
</html>
