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
    <title>VGB | Apply and Manage Loans</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(99, 102, 241, 0.08);
            --card-glow: rgba(99, 102, 241, 0.04);
            --panel-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --secondary-gradient: linear-gradient(135deg, #a855f7 0%, #7c3aed 100%);
            --emerald-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }

        body {
            background-color: #f6f8fc !important;
            color: var(--gray-700) !important;
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        body.dark-mode {
            --glass-bg: rgba(30, 41, 59, 0.45);
            --glass-border: rgba(255, 255, 255, 0.08);
            --card-glow: rgba(99, 102, 241, 0.1);
            --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            background-color: #0f172a !important;
        }

        /* Preloader */
        .preloader {
            background: #f6f8fc;
            z-index: 9999;
        }
        body.dark-mode .preloader {
            background: #0f172a;
        }

        /* Cursor follower */
        .cursor-glow {
            position: fixed;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.06) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            z-index: 1;
            transition: left 0.1s ease-out, top 0.1s ease-out;
        }
        body.dark-mode .cursor-glow {
            background: radial-gradient(circle, rgba(99, 102, 241, 0.12) 0%, transparent 70%);
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

        /* --- EMI CALCULATOR LAYOUT --- */
        .calculator-result-box {
            background: var(--secondary-gradient);
            padding: 24px;
            border-radius: var(--radius-md);
            color: white;
            text-align: center;
            margin-top: 25px;
            box-shadow: 0 10px 25px rgba(168, 85, 247, 0.25);
            position: relative;
            overflow: hidden;
        }

        .calculator-result-box::before {
            content: '';
            position: absolute;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 75%);
            border-radius: 50%;
            top: -60px;
            right: -60px;
            pointer-events: none;
        }

        .calculator-input-field {
            width: 100%;
            padding: 12px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            font-size: 0.9rem;
            color: var(--gray-800);
            background: white;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        body.dark-mode .calculator-input-field {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }
        .calculator-input-field:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }

        /* --- LOAN PRODUCT CARDS GRID --- */
        .loans-category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .loan-product-card {
            background: white;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 24px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        body.dark-mode .loan-product-card {
            background: rgba(30, 41, 59, 0.4);
            border-color: rgba(255, 255, 255, 0.08);
        }

        .loan-product-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-500);
            box-shadow: 0 12px 30px rgba(99, 102, 241, 0.15);
        }

        .loan-product-card h4 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 8px;
        }
        body.dark-mode .loan-product-card h4 {
            color: var(--white);
        }

        .loan-product-card p {
            font-size: 0.76rem;
            color: var(--gray-400);
            line-height: 1.6;
            margin-bottom: 15px;
            flex-grow: 1;
        }

        .loan-product-card .rate-badge {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--primary-500);
            margin-bottom: 8px;
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* --- ACTIVE LOANS TABLE SYSTEM --- */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
            border: 1px solid var(--glass-border);
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
            background: rgba(99, 102, 241, 0.02);
        }
        body.dark-mode th {
            color: var(--gray-400);
            background: rgba(15, 23, 42, 0.15);
        }

        td {
            padding: 16px 20px;
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

        .badge-id {
            font-family: 'Share Tech Mono', monospace;
            font-weight: 700;
            font-size: 0.85rem;
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500);
            padding: 5px 12px;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(99, 102, 241, 0.08);
            letter-spacing: 0.5px;
            white-space: nowrap;
        }
        body.dark-mode .badge-id {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-300);
        }

        .badge-status {
            padding: 4px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        /* --- PRINTABLE PAPER Application FORM --- */
        .loan-paper-form {
            background: #fff;
            border: 1.5px solid var(--gray-300);
            padding: 25px 20px;
            border-radius: 4px;
            color: #1e293b;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.95rem;
            line-height: 1.6;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-lg);
            position: relative;
            max-width: 800px;
            width: calc(100% - 40px);
            margin: 20px auto 0;
            box-sizing: border-box;
        }
        .loan-paper-form h1, .loan-paper-form h2, .loan-paper-form h3 {
            font-family: 'Poppins', sans-serif;
            color: #0f172a;
        }
        .loan-paper-form h1 {
            font-size: 1.5rem;
            font-weight: 800;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            border-bottom: 2px double #475569;
            padding-bottom: 12px;
            margin-bottom: 22px;
        }
        .loan-paper-form h2 {
            font-size: 1.05rem;
            font-weight: 700;
            border-bottom: 1px solid #94a3b8;
            padding-bottom: 4px;
            margin-top: 25px;
            margin-bottom: 15px;
            text-transform: uppercase;
            color: #475569;
            letter-spacing: 0.5px;
        }
        .loan-paper-form h3 {
            font-size: 0.9rem;
            font-weight: 700;
            color: #475569;
            margin: 15px 0 5px 0;
            text-transform: capitalize;
        }
        .loan-paper-form table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        .loan-paper-form td {
            padding: 8px 0;
            vertical-align: middle;
        }
        .loan-paper-form input[type="text"], .loan-paper-form input[type="date"], .loan-paper-form input[type="number"], .loan-paper-form select {
            border: none !important;
            border-bottom: 1.5px dotted #475569 !important;
            background: transparent !important;
            font-weight: 600 !important;
            font-family: inherit !important;
            font-size: inherit !important;
            outline: none !important;
            color: #0f172a !important;
            width: 100% !important;
            padding: 3px 5px !important;
            border-radius: 0 !important;
            box-shadow: none !important;
        }

        .loan-paper-form input[type="radio"], .loan-paper-form input[type="checkbox"] {
            cursor: pointer;
            margin-right: 5px;
        }

        /* --- GLASSMORPHIC OVERLAY MODAL --- */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(10px);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-y: auto;
        }

        .modal-dialog-content {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid rgba(99, 102, 241, 0.2);
            box-shadow: var(--shadow-2xl);
            width: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            animation: modalFadeIn 0.3s ease-out;
        }
        body.dark-mode .modal-dialog-content {
            background: #1e293b;
            border-color: rgba(255, 255, 255, 0.08);
        }

        /* Print formatting */
        @media print {
            body * {
                visibility: hidden !important;
            }
            #loanApplicationModal, #loanApplicationModal * {
                visibility: visible !important;
            }
            #loanApplicationModal {
                position: absolute !important;
                left: 0 !important;
                top: 0 !important;
                width: 100% !important;
                height: auto !important;
                overflow: visible !important;
                background: white !important;
                padding: 0 !important;
                display: flex !important;
            }
            .modal-dialog-content {
                box-shadow: none !important;
                border: none !important;
                width: 100% !important;
                max-width: 100% !important;
                padding: 0 !important;
                margin: 0 !important;
                background: white !important;
            }
            .loan-paper-form {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                width: 100% !important;
                max-width: 100% !important;
            }
            .no-print {
                display: none !important;
            }
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
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
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
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
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
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list" class="active"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i class="bx bx-file"></i> Statements</a>
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
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Secure Lending Solutions</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Simulate monthly EMI payments, submit digital application requests, and pay active balances.</p>
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

            <div style="display: grid; grid-template-columns: 1.15fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <!-- EMI Calculator -->
                <div class="glass-card">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 12px;"><i class="bx bx-calculator" style="color: var(--primary-500);"></i> VGB Premium EMI Calculator</h3>
                    
                    <div class="form-group" style="margin-bottom: 16px;">
                        <label for="calcAmount" style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray-500); margin-bottom: 6px; text-transform: uppercase;">Principal Amount (₹)</label>
                        <input type="number" id="calcAmount" class="calculator-input-field" value="500000" min="50000" max="50000000" oninput="calculateEMI()">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;" class="mobile-grid-1">
                        <div class="form-group">
                            <label for="calcRate" style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray-500); margin-bottom: 6px; text-transform: uppercase;">Annual Interest Rate (%)</label>
                            <select id="calcRate" onchange="calculateEMI()" class="calculator-input-field" style="cursor: pointer;">
                                <option value="7.50" selected>Home Secure Loan (7.50%)</option>
                                <option value="8.50">Vehicle Purchase Loan (8.50%)</option>
                                <option value="6.50">Higher Education Loan (6.50%)</option>
                                <option value="12.00">Personal Cash Loan (12.00%)</option>
                                <option value="10.50">Business Capital Loan (10.50%)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="displayCalcTermVal" style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray-500); margin-bottom: 6px; text-transform: uppercase;">Tenure Duration</label>
                            <div style="display: flex; gap: 10px;">
                                <input type="number" id="displayCalcTermVal" class="calculator-input-field" value="10" min="1" max="30" required oninput="syncCalcTerm()">
                                <select id="calcTermUnit" class="calculator-input-field" style="width: 120px; cursor: pointer;" onchange="syncCalcTerm()">
                                    <option value="years" selected>Years</option>
                                    <option value="months">Months</option>
                                </select>
                            </div>
                            <input type="hidden" id="calcTerm" value="120">
                        </div>
                    </div>
                    
                    <div class="calculator-result-box">
                        <span style="display: block; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1.5px; opacity: 0.95; font-weight: 600;">Estimated Monthly Payment</span>
                        <strong style="font-size: 2.3rem; font-weight: 800; display: block; margin-top: 5px; font-family: 'Share Tech Mono', monospace;" id="emiResult">₹ 0.00</strong>
                        <span style="font-size: 0.75rem; opacity: 0.85; display: block; margin-top: 5px;">Subject to terms &amp; final paper document verification.</span>
                    </div>
                </div>

                <!-- Promotional Info Column -->
                <div class="glass-card" style="display: flex; flex-direction: column; justify-content: space-between; background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(168, 85, 247, 0.05) 100%) !important; border-color: rgba(99, 102, 241, 0.2);">
                    <div>
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 12px;"><i class="bx bx-shield-quarter" style="color: var(--primary-500);"></i> Why VGB Premium Lending?</h3>
                        <p style="font-size: 0.9rem; color: var(--gray-600); line-height: 1.6; margin-bottom: 20px;">
                            Vertex Galaxy Bank offers custom-tailored credit solutions featuring highly competitive fixed interest rates, flexible tenure options up to 30 years, and instant digital credit assessment. 
                        </p>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                <i class="bx bx-check-shield" style="color: var(--accent-emerald); font-size: 1.25rem;"></i>
                                <span style="font-weight: 500;">Zero hidden charges &amp; fully transparent terms</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                <i class="bx bx-credit-card-front" style="color: var(--accent-emerald); font-size: 1.25rem;"></i>
                                <span style="font-weight: 500;">Flexible EMI repayments auto-debited securely</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                <i class="bx bx-badge-check" style="color: var(--accent-emerald); font-size: 1.25rem;"></i>
                                <span style="font-weight: 500;">Direct administrative verification with instant updates</span>
                            </div>
                        </div>
                    </div>
                    <div style="border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px; margin-top: 20px; font-size: 0.8rem; color: var(--gray-500); font-style: italic; font-weight: 500;">
                        Select one of the loan products below to inspect details or open the formal application.
                    </div>
                </div>
            </div>

            <!-- Premium Loan Products Section -->
            <div style="margin-bottom: 40px;">
                <h3 style="font-size: 1.5rem; font-weight: 800; color: var(--gray-900); margin-bottom: 10px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-gift" style="color: var(--primary-500);"></i>
                    <span>Select a Premium Loan Solution</span>
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 20px;">Choose a specialized loan product based on your financial goals. Click **Apply Now** to open the formal application form.</p>
                
                <div class="loans-category-grid">
                    <!-- Personal Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('personal', 12.00, 1500000)">
                        <div>
                            <h4>Personal Cash Loan</h4>
                            <p>Unsecured personal financing for instant cash requirements, medical expenses, or emergency funds.</p>
                        </div>
                        <div>
                            <div class="rate-badge">12.00% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 15px; font-weight: 600;">Max: ₹ 15,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 0.78rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Home Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('home', 7.50, 50000000)">
                        <div>
                            <h4>Home Secure Loan</h4>
                            <p>Realize your dream home with low rates, customized repayment timelines, and easy paper processing.</p>
                        </div>
                        <div>
                            <div class="rate-badge">7.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 15px; font-weight: 600;">Max: ₹ 5,00,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 0.78rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Vehicle Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('vehicle', 8.50, 5000000)">
                        <div>
                            <h4>Vehicle Purchase Loan</h4>
                            <p>Drive your dream car or vehicle home with instant disbursals, high limits, and flexible tenure plans.</p>
                        </div>
                        <div>
                            <div class="rate-badge">8.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 15px; font-weight: 600;">Max: ₹ 50,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 0.78rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Education Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('education', 6.50, 4000000)">
                        <div>
                            <h4>Higher Education Loan</h4>
                            <p>Fund premium global academic pursuits, covering university fees, travel, and accommodation costs.</p>
                        </div>
                        <div>
                            <div class="rate-badge">6.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 15px; font-weight: 600;">Max: ₹ 40,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 0.78rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Business Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('business', 10.50, 10000000)">
                        <div>
                            <h4>Business Capital Loan</h4>
                            <p>Power your business venture, purchase heavy machinery, expand infrastructure, or boost working capital.</p>
                        </div>
                        <div>
                            <div class="rate-badge">10.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 15px; font-weight: 600;">Max: ₹ 1,00,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 0.78rem;">Apply Now</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Existing Loans Ledger -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-receipt" style="color: var(--primary-500);"></i> Active Loan Portfolio Ledger</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Loan ID</th>
                                <th>Loan Type</th>
                                <th>Interest Rate</th>
                                <th>Principal</th>
                                <th>Remaining Balance</th>
                                <th style="text-align: right;">Monthly EMI</th>
                                <th>Maturity Date</th>
                                <th>Status</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty loans}">
                                    <c:forEach var="loan" items="${loans}">
                                        <tr>
                                            <td><span class="badge-id">#LN-${loan.loanId}</span></td>
                                            <td style="text-transform: capitalize; font-weight: 600;">${loan.loanType}</td>
                                            <td style="font-weight: 500;">${loan.interestRate}% P.A.</td>
                                            <td style="font-weight: 700; color: var(--gray-800);">₹ <fmt:formatNumber value="${loan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="font-weight: 700; color: #ef4444;">₹ <fmt:formatNumber value="${loan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="text-align: right; font-weight: 700; color: var(--primary-500); font-family: 'Share Tech Mono', monospace;">₹ <fmt:formatNumber value="${loan.monthlyEMI}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty loan.endDate}">
                                                        ${loan.endDate}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-400); font-style: italic; font-weight: 500;">Awaiting Approval</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${loan.status == 'active' or loan.status == 'approved' or loan.status == 'disbursed'}">
                                                        <span class="badge-status" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">Active</span>
                                                    </c:when>
                                                    <c:when test="${loan.status == 'pending_approval' or loan.status == 'pending'}">
                                                        <span class="badge-status" style="background: rgba(245, 158, 11, 0.1); color: #fbbf24;">Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status" style="background: rgba(156, 163, 175, 0.1); color: var(--gray-500);">${loan.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center;">
                                                <c:if test="${loan.status == 'active' or loan.status == 'approved' or loan.status == 'disbursed'}">
                                                    <button type="button" class="btn btn-secondary" onclick="openRepayModal('${loan.loanId}', '${loan.remainingBalance}')" style="padding: 6px 14px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500); background: transparent; display: inline-flex; align-items: center; gap: 4px;">
                                                        <i class="bx bx-wallet-alt"></i> Repay EMI
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 40px; color: var(--gray-400); font-weight: 500;">No active or pending loans found for this profile.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Repay EMI Modal Overlay -->
        <div id="repayModal" class="modal-overlay">
            <div class="modal-dialog-content" style="max-width: 500px; padding: 30px; position: relative;">
                <button type="button" onclick="closeRepayModal()" style="position: absolute; top: 20px; right: 20px; font-size: 1.6rem; color: var(--gray-400); cursor: pointer; border: none; background: transparent;"><i class="bx bx-x"></i></button>
                
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 12px;"><i class="bx bx-wallet-alt" style="color: var(--primary-500);"></i> Process Loan EMI Auto-Debit</h3>
                <form action="${pageContext.request.contextPath}/loan?action=repayment" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="loanId" id="modalLoanId">

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="modalRemaining" style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray-500); margin-bottom: 6px; text-transform: uppercase;">Remaining Balance (₹)</label>
                        <input type="text" id="modalRemaining" readonly class="calculator-input-field" style="background: var(--gray-100);">
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="modalAccount" style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray-500); margin-bottom: 6px; text-transform: uppercase;">Select Account to Debit</label>
                        <select id="modalAccount" name="accountId" required class="calculator-input-field" style="cursor: pointer;">
                            <c:forEach var="acc" items="${accounts}">
                                <option value="${acc.accountId}">Account #${acc.accountId} (${acc.accountType}) - Bal: ₹ ${acc.balance}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 25px;">
                        <label for="modalAmount" style="display: block; font-size: 0.8rem; font-weight: 700; color: var(--gray-500); margin-bottom: 6px; text-transform: uppercase;">Payment Amount (₹)</label>
                        <input type="number" step="0.01" min="100" id="modalAmount" name="amount" required placeholder="E.g., 5000" class="calculator-input-field">
                    </div>

                    <div style="display: flex; gap: 15px; justify-content: flex-end;">
                        <button type="button" class="btn btn-secondary" onclick="closeRepayModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <span>Execute Debit</span>
                            <i class="bx bx-check-double"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Loan Specification Details Modal -->
        <div id="loanDetailsModal" class="modal-overlay" style="z-index: 1050;">
            <div class="modal-dialog-content" style="max-width: 650px;">
                <!-- Header with premium gradient background -->
                <div style="padding: 25px 30px; background: var(--primary-gradient); display: flex; justify-content: space-between; align-items: center; color: white;">
                    <h3 id="detailsModalTitle" style="font-size: 1.35rem; font-weight: 800; display: flex; align-items: center; gap: 10px; margin: 0; letter-spacing: 0.5px; color: white;">
                        <i class="bx bx-info-circle" style="font-size: 1.6rem;"></i>
                        <span>Loan Product Specification</span>
                    </h3>
                    <button type="button" onclick="closeDetailsModal()" style="font-size: 1.6rem; color: rgba(255, 255, 255, 0.8); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='rgba(255, 255, 255, 0.8)'"><i class="bx bx-x"></i></button>
                </div>
                
                <!-- Body with specifications -->
                <div style="padding: 30px; background: var(--gray-50); max-height: 70vh; overflow-y: auto;">
                    <div style="background: white; padding: 20px; border-radius: var(--radius-md); border: 1px solid var(--gray-200); margin-bottom: 20px;">
                        <p id="detailsDescription" style="font-size: 0.9rem; color: var(--gray-600); line-height: 1.6; margin: 0;"></p>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px;">
                        <div style="background: rgba(99, 102, 241, 0.04); border: 1.5px solid rgba(99, 102, 241, 0.12); padding: 15px; border-radius: var(--radius-md); text-align: center;">
                            <span style="font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; display: block;">Fixed Interest Rate</span>
                            <strong id="detailsInterestRate" style="font-size: 1.6rem; color: var(--primary-600); font-weight: 800; display: block; margin-top: 5px;"></strong>
                        </div>
                        <div style="background: rgba(16, 185, 129, 0.04); border: 1.5px solid rgba(16, 185, 129, 0.12); padding: 15px; border-radius: var(--radius-md); text-align: center;">
                            <span style="font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; display: block;">Maximum Credit Limit</span>
                            <strong id="detailsMaxLimit" style="font-size: 1.6rem; color: var(--accent-emerald); font-weight: 800; display: block; margin-top: 5px;"></strong>
                        </div>
                    </div>
                    
                    <div style="margin-bottom: 25px;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-check-shield" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                            <span>Key Product Benefits</span>
                        </h4>
                        <ul id="detailsBenefits" style="list-style: none; padding: 0; margin: 0; display: grid; grid-template-columns: 1fr; gap: 8px;">
                        </ul>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;" class="mobile-grid-1">
                        <div>
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-user" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                <span>Eligibility Criteria</span>
                            </h4>
                            <ul id="detailsEligibility" style="padding-left: 20px; margin: 0; font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            </ul>
                        </div>
                        <div>
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                <span>Required Documents</span>
                            </h4>
                            <ul id="detailsDocuments" style="padding-left: 20px; margin: 0; font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Footer buttons -->
                <div style="padding: 20px 30px; border-top: 1px solid var(--gray-200); display: flex; justify-content: flex-end; gap: 15px; background: white;">
                    <button type="button" class="btn btn-secondary" onclick="closeDetailsModal()" style="padding: 10px 22px;">Close</button>
                    <button type="button" id="detailsApplyBtn" class="btn btn-primary" style="padding: 10px 25px; display: flex; align-items: center; gap: 8px; border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                        <span>Apply Now</span>
                        <i class="bx bx-chevron-right"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Printable formal Loan Application Form Modal -->
        <div id="loanApplicationModal" class="modal-overlay">
            <div class="modal-dialog-content" style="max-width: 850px; max-height: 90vh;">
                <div class="modal-header no-print" style="padding: 20px 30px; border-bottom: 1px solid var(--gray-200); display: flex; justify-content: space-between; align-items: center; background: var(--gray-50); border-top-left-radius: var(--radius-lg); border-top-right-radius: var(--radius-lg);">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 10px;">
                        <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                        <span>Official Loan Application Form</span>
                    </h3>
                    <button type="button" onclick="closeLoanModal()" style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-900)'" onmouseout="this.style.color='var(--gray-400)'"><i class="bx bx-x"></i></button>
                </div>
                
                <div class="modal-body" style="padding: 30px; overflow-y: auto; flex-grow: 1; background: var(--gray-100);">
                    <form id="actualLoanForm" action="${pageContext.request.contextPath}/loan?action=apply" method="post" onsubmit="serializeLoanForm(event)">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        
                        <!-- Hidden parameters submitted to servlet -->
                        <input type="hidden" id="submitLoanType" name="loanType">
                        <input type="hidden" id="submitAmount" name="amount">
                        <input type="hidden" id="submitTermMonths" name="termMonths">
                        <input type="hidden" id="submitInterestRate" name="interestRate">
                        <input type="hidden" id="submitFormDetails" name="formDetails">

                        <div class="loan-paper-form">
                            <h1>Loan Application Form</h1>
                            
                            <!-- 1. Applicant Information -->
                            <h2>1. Applicant Information</h2>
                            <table>
                                <tr>
                                    <td style="width: 30%; font-weight: bold;">Full Name:</td>
                                    <td style="width: 70%;"><input type="text" id="formFullName" value="${customer.fullName}" readonly style="font-weight: 600;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Father's / Husband's Name:</td>
                                    <td><input type="text" id="formRelationName" placeholder="Type relation full name" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Date of Birth:</td>
                                    <td><input type="date" id="formDob" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Gender:</td>
                                    <td>
                                        <div style="display: flex; gap: 20px;">
                                            <label><input type="radio" name="formGender" value="Male" required> Male</label>
                                            <label><input type="radio" name="formGender" value="Female"> Female</label>
                                            <label><input type="radio" name="formGender" value="Other"> Other</label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Mobile Number:</td>
                                    <td><input type="text" id="formMobile" value="${customer.phoneNo}" readonly></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Email Address:</td>
                                    <td><input type="text" id="formEmail" value="${customer.email}" readonly></td>
                                </tr>
                            </table>

                            <!-- 2. Address Details -->
                            <h2>2. Address Details</h2>
                            <h3 style="margin: 10px 0 5px 0;">Current Address</h3>
                            <div style="border-bottom: 1.5px dotted #475569; padding: 5px 0 10px 0; margin-bottom: 10px; font-weight: 600;">
                                ${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}
                                <input type="hidden" id="formCurrentAddress" value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                            </div>

                            <h3 style="margin: 15px 0 5px 0;">Permanent Address</h3>
                            <div style="margin-bottom: 10px;" class="no-print">
                                <label style="font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                    <input type="checkbox" id="sameAsCurrent" onchange="copyCurrentAddress(this)"> Same as Current Address
                                </label>
                            </div>
                            <textarea id="formPermanentAddress" placeholder="Enter permanent address details..." required style="width: 100%; border: none; border-bottom: 1.5px dotted #475569; font-family: inherit; font-size: inherit; font-weight: 600; outline: none; background: transparent; resize: none; height: 50px;"></textarea>

                            <!-- 3. Identity Details -->
                            <h2>3. Identity Details</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Aadhaar Number:</td>
                                    <td style="width: 65%;"><input type="text" id="formAadhaar" value="${customer.aadhaarCard}" readonly></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">PAN Number:</td>
                                    <td><input type="text" id="formPan" value="${customer.panCard}" readonly style="text-transform: uppercase;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Voter ID / DL Number:</td>
                                    <td><input type="text" id="formVoterDl" placeholder="Enter identification document number" required></td>
                                </tr>
                            </table>

                            <!-- 4. Employment Information -->
                            <h2>4. Employment Information</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Occupation:</td>
                                    <td style="width: 65%;"><input type="text" id="formOccupation" placeholder="E.g., Software Engineer, Merchant" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Company / Business Name:</td>
                                    <td><input type="text" id="formCompanyName" placeholder="Company or Organization Name" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Monthly Net Income:</td>
                                    <td><input type="number" id="formMonthlyIncome" placeholder="₹ Value" required min="1000"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Total Work Experience:</td>
                                    <td><input type="text" id="formExperience" placeholder="E.g., 5 Years" required></td>
                                </tr>
                            </table>

                            <!-- 5. Bank Account Details -->
                            <h2>5. Bank Account Details</h2>
                            <p style="font-size: 0.85rem; font-style: italic; color: #64748b; margin-bottom: 10px;" class="no-print">Link one of your active accounts for disbursement and auto-recovery.</p>
                            <table>
                                <tr class="no-print">
                                    <td style="width: 35%; font-weight: bold;">Select Account to Link:</td>
                                    <td style="width: 65%;">
                                        <select id="formLinkAccount" onchange="syncLinkedAccountDetails(this)" style="font-weight: 600; padding: 5px; cursor: pointer;">
                                            <option value="" disabled selected>-- Select Your VGB Account --</option>
                                            <c:forEach var="acc" items="${accounts}">
                                                <option value="${acc.accountId}" data-acc-no="${acc.accountNumber}" data-ifsc="${acc.ifscCode}" data-type="${acc.accountType}">
                                                    Account #${acc.accountId} (${acc.accountType})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Account Holder Name:</td>
                                    <td style="width: 65%;"><input type="text" id="formAccHolderName" value="${customer.fullName}" readonly></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Account Number:</td>
                                    <td><input type="text" id="formAccNo" readonly placeholder="Select account above to populate" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">IFSC Code:</td>
                                    <td><input type="text" id="formIfsc" readonly placeholder="Select account above to populate" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">IFSC Branch:</td>
                                    <td><input type="text" id="formBranch" readonly value="VGB Main Branch" style="font-weight: 600;"></td>
                                </tr>
                            </table>

                            <!-- 6. Loan Details -->
                            <h2>6. Loan Details</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Loan Product:</td>
                                    <td style="width: 65%;"><input type="text" id="formLoanTypeDisplay" readonly style="font-weight: bold; text-transform: uppercase;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Requested Amount (₹):</td>
                                    <td><input type="number" id="formLoanAmount" placeholder="Enter amount" required oninput="calculatePaperEMI()"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Repayment Tenure:</td>
                                    <td>
                                        <div style="display: flex; gap: 10px;">
                                            <input type="number" id="formLoanTermVal" placeholder="Tenure" required style="width: 60%;" oninput="syncPaperTermMonths()">
                                            <select id="formLoanTermUnit" style="width: 40%; font-weight: 600;" onchange="syncPaperTermMonths()">
                                                <option value="years" selected>Years</option>
                                                <option value="months">Months</option>
                                            </select>
                                        </div>
                                        <input type="hidden" id="formLoanTermMonths">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Interest rate profile:</td>
                                    <td><input type="text" id="formLoanRate" readonly style="font-weight: 600; color: var(--primary-500);"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Detailed Purpose:</td>
                                    <td><input type="text" id="formLoanPurpose" placeholder="E.g., Medical expenses, vehicle purchase" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Estimated Monthly EMI:</td>
                                    <td style="font-weight: bold; font-size: 1.15rem; color: #0f172a; font-family: 'Share Tech Mono', monospace;" id="formPaperEmiDisplay">₹ 0.00</td>
                                </tr>
                            </table>

                            <!-- 7. Nominee Information -->
                            <h2>7. Nominee Information</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Nominee Name:</td>
                                    <td style="width: 65%;"><input type="text" id="formNomineeName" placeholder="Full name of nominee" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Relationship:</td>
                                    <td><input type="text" id="formNomineeRelationship" placeholder="E.g., Spouse, Child, Parent" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Mobile Number:</td>
                                    <td><input type="text" id="formNomineeMobile" placeholder="10-Digit Mobile No." required pattern="[0-9]{10}"></td>
                                </tr>
                            </table>

                            <!-- 8. Declaration -->
                            <h2>8. Declaration</h2>
                            <div style="margin-bottom: 20px; font-size: 0.88rem; text-align: justify; line-height: 1.6; color: #334155;">
                                <label style="cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                    <input type="checkbox" id="formDeclarationCheckbox" required style="margin-top: 4px;">
                                    <span>I hereby declare that the details furnished above are true and correct to the best of my knowledge and belief. I authorize Vertex Galaxy Bank to execute monthly auto-debits on my linked account to clear EMI repayments.</span>
                                </label>
                            </div>

                            <div style="display: grid; grid-template-columns: 1.4fr 1fr; gap: 30px; margin-top: 30px;">
                                <div>
                                    <table style="margin-bottom: 0;">
                                        <tr>
                                            <td style="width: 30%; font-weight: bold;">Date:</td>
                                            <td style="width: 70%;"><input type="text" id="formDeclarationDate" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Place:</td>
                                            <td><input type="text" id="formDeclarationPlace" placeholder="E.g., Mumbai, Delhi" required></td>
                                        </tr>
                                    </table>
                                </div>
                                <div style="text-align: center; display: flex; flex-direction: column; justify-content: flex-end; align-items: center;">
                                    <input type="text" id="formSignature" placeholder="Type name to sign" required style="text-align: center; font-family: 'Brush Script MT', cursive, Georgia, serif; font-size: 1.65rem; border-bottom: 1.5px solid #000 !important; width: 85%;">
                                    <span style="font-size: 0.75rem; font-weight: bold; color: #475569; text-transform: uppercase; margin-top: 5px; display: block;">Applicant's Signature</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="no-print" style="margin-top: 30px; display: flex; gap: 15px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid var(--gray-200);">
                            <button type="button" class="btn btn-secondary" onclick="closeLoanModal()" style="padding: 10px 22px;">Close</button>
                            <button type="button" class="btn btn-secondary" onclick="printApplicationForm()" style="padding: 10px 22px; display: flex; align-items: center; gap: 8px; border: 1.5px solid var(--gray-300); color: var(--gray-700); background: white;">
                                <i class="bx bx-printer"></i>
                                <span>Print Form</span>
                            </button>
                            <button type="submit" class="btn btn-primary" style="padding: 10px 25px;">
                                <span>Submit Application</span>
                                <i class="bx bx-paper-plane"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        let currentMaxLimit = 50000000;

        const loanSpecs = {
            'personal': {
                title: 'Personal Cash Loan',
                description: 'Unsecured personal financing tailored for instant cash requirements, medical expenses, vacation planning, or emergency funds. No collateral required, with direct instant disbursal to your active savings or checking account.',
                benefits: [
                    'Zero collateral or security requirements',
                    'Flexible repayment tenure ranges from 12 to 60 months',
                    'Direct bank transfer with minimal digital paperwork',
                    'Fully transparent pricing - zero hidden charges'
                ],
                eligibility: [
                    'Age: 21 to 60 years old',
                    'Salaried or self-employed with stable income stream',
                    'Minimum monthly net income: ₹ 25,000'
                ],
                documents: [
                    'Valid PAN Card & Aadhaar Card',
                    'Last 3 months salary slips or income proofs',
                    '6 months active bank account statements'
                ]
            },
            'home': {
                title: 'Home Secure Loan',
                description: 'Realize your dream home with Vertex Galaxy Bank\'s purchase, construction, or renovation lending solution. Featuring our lowest rates, high tenure lengths up to 30 years, and tax exemption benefits.',
                benefits: [
                    'Extremely low fixed interest rates at 7.50% P.A.',
                    'Repayment tenure flexibility up to 360 months (30 years)',
                    'Income tax deduction benefits on principal and interest',
                    'Property evaluation and legal consulting services included'
                ],
                eligibility: [
                    'Age: 21 to 65 years old',
                    'Consistent salaried/business income profiles',
                    'Minimum monthly net income: ₹ 40,000',
                    'Clear, marketable legal title of the property'
                ],
                documents: [
                    'Valid PAN Card & Aadhaar Card',
                    'Property sale agreement & builder NOC',
                    '3 years filed income tax returns (ITR)',
                    'Last 6 months active bank statements'
                ]
            },
            'vehicle': {
                title: 'Vehicle Purchase Loan',
                description: 'Drive your dream car or commercial vehicle home with high credit limits, up to 90% funding of the on-road price, and flexible repayment structures tailored to your monthly cashflow.',
                benefits: [
                    'Up to 90% financing on the vehicle\'s on-road price',
                    'Instant digital credit validation and quick disbursals',
                    'Flexible tenure periods up to 84 months (7 years)',
                    'Attractive dealership tie-ups for added savings'
                ],
                eligibility: [
                    'Age: 18 to 65 years old',
                    'Stable source of salaried or self-employed income',
                    'Minimum monthly net income: ₹ 30,000'
                ],
                documents: [
                    'Valid PAN Card & Aadhaar Card',
                    'Proforma invoice of the selected vehicle',
                    '3 months salary slips or business income proofs',
                    '6 months active bank statements'
                ]
            },
            'education': {
                title: 'Higher Education Loan',
                description: 'Fund global academic pursuits at premium national and international universities. Vertex Galaxy Bank covers all your academic fees, boarding, travel, and laptop requirements, with a moratorium period during course completion.',
                benefits: [
                    'Attractive low rate of 6.50% P.A. for meritorious students',
                    'Covers 100% of college fee, hostel, travel, and study tools',
                    'Moratorium period: Repayments start 1 year after course completion',
                    'Section 80E income tax interest deduction benefits'
                ],
                eligibility: [
                    'Confirmed admission in recognized global/national institution',
                    'Co-applicant (parent/spouse/guardian) with active income',
                    'Acceptable academic credentials (10th, 12th, or graduation)'
                ],
                documents: [
                    'Admission letter from university with fee structure',
                    'Applicant\'s academic marks sheets (10th/12th/Graduation)',
                    'KYC of both student applicant and co-borrower',
                    'Income proof and bank statements of co-borrower'
                ]
            },
            'business': {
                title: 'Business Capital Loan',
                description: 'Power your business operations, upgrade machinery, expand operations, or bolster working capital with our premium, high-limit Business Capital Loan offering quick processing and customized corporate repayment schedules.',
                benefits: [
                    'High credit funding limits up to ₹ 1,00,00,000',
                    'Flexible repayment structures based on business cashflow cycles',
                    'Quick credit scoring and streamlined administrative approvals',
                    'Helps scale operations, inventory stock, or raw material procurement'
                ],
                eligibility: [
                    'Minimum 2 years of active business vintage',
                    'Satisfactory business credit score (CIBIL/CRF)',
                    'Profitable operations for the last two financial years'
                ],
                documents: [
                    'Entity business PAN Card, GST registration certificates',
                    '2 years audited business financial statement papers',
                    '1 year business primary checking statements',
                    'KYC of all directors/promoters/partners'
                ]
            }
        };

        function showLoanDetails(type, rate, maxLimit) {
            const spec = loanSpecs[type];
            if (!spec) return;
            
            document.getElementById('detailsModalTitle').querySelector('span').textContent = spec.title + " Specification";
            document.getElementById('detailsDescription').textContent = spec.description;
            document.getElementById('detailsInterestRate').textContent = rate.toFixed(2) + "% Fixed P.A.";
            document.getElementById('detailsMaxLimit').textContent = "₹ " + maxLimit.toLocaleString('en-IN');
            
            const benefitsList = document.getElementById('detailsBenefits');
            benefitsList.innerHTML = '';
            spec.benefits.forEach(benefit => {
                const li = document.createElement('li');
                li.style.display = 'flex';
                li.style.alignItems = 'flex-start';
                li.style.gap = '10px';
                li.style.fontSize = '0.88rem';
                li.style.color = 'var(--gray-700)';
                li.style.lineHeight = '1.5';
                li.innerHTML = '<i class="bx bx-check" style="color: var(--accent-emerald); font-size: 1.25rem; margin-top: 2px;"></i><span>' + benefit + '</span>';
                benefitsList.appendChild(li);
            });
            
            const eligibilityList = document.getElementById('detailsEligibility');
            eligibilityList.innerHTML = '';
            spec.eligibility.forEach(el => {
                const li = document.createElement('li');
                li.textContent = el;
                eligibilityList.appendChild(li);
            });
            
            const documentsList = document.getElementById('detailsDocuments');
            documentsList.innerHTML = '';
            spec.documents.forEach(doc => {
                const li = document.createElement('li');
                li.textContent = doc;
                documentsList.appendChild(li);
            });
            
            const applyBtn = document.getElementById('detailsApplyBtn');
            applyBtn.onclick = function() {
                closeDetailsModal();
                openLoanForm(type, rate, maxLimit);
            };
            
            document.getElementById('loanDetailsModal').style.display = 'flex';
        }
        
        function closeDetailsModal() {
            document.getElementById('loanDetailsModal').style.display = 'none';
        }

        function openLoanForm(type, rate, maxLimit) {
            currentMaxLimit = maxLimit;
            document.getElementById('formLoanTypeDisplay').value = type;
            document.getElementById('submitLoanType').value = type;
            
            document.getElementById('formLoanRate').value = rate.toFixed(2) + "% Fixed P.A.";
            document.getElementById('submitInterestRate').value = rate;

            const amountInput = document.getElementById('formLoanAmount');
            amountInput.max = maxLimit;
            amountInput.placeholder = "Max: ₹ " + maxLimit.toLocaleString('en-IN');
            amountInput.value = "";

            const today = new Date();
            const yyyy = today.getFullYear();
            let mm = today.getMonth() + 1;
            let dd = today.getDate();
            if (dd < 10) dd = '0' + dd;
            if (mm < 10) mm = '0' + mm;
            document.getElementById('formDeclarationDate').value = dd + '/' + mm + '/' + yyyy;

            document.getElementById('actualLoanForm').reset();
            
            // Re-populate readonly fields
            document.getElementById('formFullName').value = "${customer.fullName}";
            document.getElementById('formMobile').value = "${customer.phoneNo}";
            document.getElementById('formEmail').value = "${customer.email}";
            document.getElementById('formAadhaar').value = "${customer.aadhaarCard}";
            document.getElementById('formPan').value = "${customer.panCard}";
            document.getElementById('formLoanTypeDisplay').value = type;
            document.getElementById('formLoanRate').value = rate.toFixed(2) + "% Fixed P.A.";
            document.getElementById('formDeclarationDate').value = dd + '/' + mm + '/' + yyyy;
            document.getElementById('formBranch').value = "VGB Main Branch";
            document.getElementById('formAccHolderName').value = "${customer.fullName}";

            document.getElementById('formLoanTermVal').value = 10;
            document.getElementById('formLoanTermUnit').value = "years";
            syncPaperTermMonths();

            document.getElementById('loanApplicationModal').style.display = 'flex';
        }

        function closeLoanModal() {
            document.getElementById('loanApplicationModal').style.display = 'none';
        }

        function copyCurrentAddress(checkbox) {
            const currentAddr = document.getElementById('formCurrentAddress').value;
            const permAddrField = document.getElementById('formPermanentAddress');
            if (checkbox.checked) {
                permAddrField.value = currentAddr;
            } else {
                permAddrField.value = "";
            }
        }

        function syncLinkedAccountDetails(select) {
            if (!select.value) return;
            const selectedOpt = select.options[select.selectedIndex];
            const accNo = selectedOpt.getAttribute('data-acc-no');
            const ifsc = selectedOpt.getAttribute('data-ifsc');
            
            document.getElementById('formAccNo').value = accNo;
            document.getElementById('formIfsc').value = ifsc;
        }

        function syncPaperTermMonths() {
            const valInput = document.getElementById('formLoanTermVal');
            const unit = document.getElementById('formLoanTermUnit').value;
            
            if (unit === 'years') {
                valInput.min = "1";
                valInput.max = "30";
                if (parseFloat(valInput.value) > 30) valInput.value = "30";
            } else {
                valInput.min = "12";
                valInput.max = "360";
                if (parseFloat(valInput.value) > 360) valInput.value = "360";
            }
            
            const val = parseInt(valInput.value) || 0;
            let months = val;
            if (unit === 'years') {
                months = val * 12;
            }
            document.getElementById('formLoanTermMonths').value = months;
            document.getElementById('submitTermMonths').value = months;
            calculatePaperEMI();
        }

        function calculatePaperEMI() {
            const amount = parseFloat(document.getElementById('formLoanAmount').value) || 0;
            const rateStr = document.getElementById('submitInterestRate').value;
            const rate = parseFloat(rateStr) || 0;
            const term = parseInt(document.getElementById('formLoanTermMonths').value) || 0;
            
            const emiDisplay = document.getElementById('formPaperEmiDisplay');
            
            if (amount <= 0 || rate <= 0 || term <= 0) {
                emiDisplay.textContent = "₹ 0.00";
                return;
            }

            const monthlyRate = (rate / 12) / 100;
            const emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, term)) / (Math.pow(1 + monthlyRate, term) - 1);
            
            emiDisplay.textContent = "₹ " + emi.toLocaleString('en-IN', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
        }

        function serializeLoanForm(event) {
            const amount = parseFloat(document.getElementById('formLoanAmount').value) || 0;
            if (amount > currentMaxLimit) {
                alert("The requested amount exceeds the maximum limit of ₹ " + currentMaxLimit.toLocaleString('en-IN') + " for this loan category.");
                event.preventDefault();
                return false;
            }

            const linkAcc = document.getElementById('formLinkAccount').value;
            if (!linkAcc) {
                alert("Please select a bank account to link to this loan.");
                event.preventDefault();
                return false;
            }

            const details = {
                relationName: document.getElementById('formRelationName').value,
                dob: document.getElementById('formDob').value,
                gender: document.querySelector('input[name="formGender"]:checked')?.value || '',
                permanentAddress: document.getElementById('formPermanentAddress').value,
                aadhaar: document.getElementById('formAadhaar').value,
                pan: document.getElementById('formPan').value,
                voterDlNo: document.getElementById('formVoterDl').value,
                occupation: document.getElementById('formOccupation').value,
                companyName: document.getElementById('formCompanyName').value,
                monthlyIncome: document.getElementById('formMonthlyIncome').value,
                workExperience: document.getElementById('formExperience').value,
                linkedAccountId: document.getElementById('formLinkAccount').value,
                linkedAccountNo: document.getElementById('formAccNo').value,
                linkedIfsc: document.getElementById('formIfsc').value,
                linkedBranch: document.getElementById('formBranch').value,
                loanPurpose: document.getElementById('formLoanPurpose').value,
                nomineeName: document.getElementById('formNomineeName').value,
                nomineeRelationship: document.getElementById('formNomineeRelationship').value,
                nomineeMobile: document.getElementById('formNomineeMobile').value,
                declarationPlace: document.getElementById('formDeclarationPlace').value,
                declarationDate: document.getElementById('formDeclarationDate').value,
                signature: document.getElementById('formSignature').value
            };

            document.getElementById('submitFormDetails').value = JSON.stringify(details);
            document.getElementById('submitAmount').value = amount;
            document.getElementById('submitTermMonths').value = document.getElementById('formLoanTermMonths').value;
            
            return true;
        }

        function printApplicationForm() {
            window.print();
        }

        function calculateEMI() {
            const amount = parseFloat(document.getElementById('calcAmount').value) || 0;
            const rate = parseFloat(document.getElementById('calcRate').value) || 0;
            const term = parseInt(document.getElementById('calcTerm').value) || 0;
            
            if (amount <= 0 || rate <= 0 || term <= 0) {
                document.getElementById('emiResult').textContent = "₹ 0.00";
                return;
            }

            const monthlyRate = (rate / 12) / 100;
            const emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, term)) / (Math.pow(1 + monthlyRate, term) - 1);
            
            document.getElementById('emiResult').textContent = "₹ " + emi.toLocaleString('en-IN', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
        }

        function syncCalcTerm() {
            const valInput = document.getElementById('displayCalcTermVal');
            const unit = document.getElementById('calcTermUnit').value;
            
            if (unit === 'years') {
                valInput.min = "1";
                valInput.max = "30";
                if (parseFloat(valInput.value) > 30) {
                    valInput.value = "30";
                }
            } else {
                valInput.min = "12";
                valInput.max = "360";
                if (parseFloat(valInput.value) > 360) {
                    valInput.value = "360";
                }
            }
            
            const val = parseInt(valInput.value) || 0;
            let months = val;
            if (unit === 'years') {
                months = val * 12;
            }
            document.getElementById('calcTerm').value = months;
            calculateEMI();
        }

        document.addEventListener('DOMContentLoaded', () => {
            syncCalcTerm();
            calculateEMI();

            // Mobile sidebar toggle
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
                
                document.addEventListener('click', (e) => {
                    if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                        sidebar.classList.remove('active');
                        mobileToggle.querySelector('i').className = 'bx bx-menu';
                    }
                });
            }

            // Glow follower
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

        function openRepayModal(loanId, remaining) {
            document.getElementById('modalLoanId').value = loanId;
            document.getElementById('modalRemaining').value = "₹ " + parseFloat(remaining).toLocaleString('en-IN', { minimumFractionDigits: 2 });
            document.getElementById('repayModal').style.display = 'flex';
        }

        function closeRepayModal() {
            document.getElementById('repayModal').style.display = 'none';
        }
    </script>
</body>
</html>
