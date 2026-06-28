<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.vgb.model.Customer" %>
<%@ page import="com.vgb.service.CustomerService" %>
<%@ page import="com.vgb.model.Account" %>
<%@ page import="com.vgb.service.AccountService" %>
<%@ page import="com.vgb.model.Card" %>
<%@ page import="com.vgb.service.CardService" %>
<%@ page import="com.vgb.model.Loan" %>
<%@ page import="com.vgb.service.LoanService" %>
<%@ page import="com.vgb.model.ChequeBookRequest" %>
<%@ page import="com.vgb.service.ChequeBookRequestService" %>
<%@ page import="com.vgb.constants.AppConstants" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Long customerId = null;
    Object sessionUser = session.getAttribute(AppConstants.USER_SESSION_KEY);
    if (sessionUser != null) {
        customerId = Long.parseLong(sessionUser.toString());
    }
    
    Customer customer = null;
    List<Account> customerAccounts = null;
    List<Card> customerCards = null;
    List<Loan> customerLoans = null;
    List<ChequeBookRequest> customerChequeRequests = null;
    BigDecimal totalBalance = BigDecimal.ZERO;
    
    if (customerId != null) {
        try {
            CustomerService customerService = new CustomerService();
            customer = customerService.getCustomerById(customerId);
            
            AccountService accountService = new AccountService();
            customerAccounts = accountService.getCustomerAccounts(customerId);
            if (customerAccounts != null) {
                for (Account acc : customerAccounts) {
                    if (acc.getBalance() != null) {
                        totalBalance = totalBalance.add(acc.getBalance());
                    }
                }
            }
            
            CardService cardService = new CardService();
            customerCards = cardService.getCustomerCards(customerId);
            
            LoanService loanService = new LoanService();
            customerLoans = loanService.getCustomerLoans(customerId);
            
            ChequeBookRequestService chequeBookService = new ChequeBookRequestService();
            customerChequeRequests = chequeBookService.getCustomerRequests(customerId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    request.setAttribute("customer", customer);
    request.setAttribute("accounts", customerAccounts);
    request.setAttribute("cards", customerCards);
    request.setAttribute("loans", customerLoans);
    request.setAttribute("chequeRequests", customerChequeRequests);
    request.setAttribute("totalBalance", totalBalance);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Profile Settings</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
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
            z-index: 99;
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
            padding: 30px;
            box-shadow: var(--glass-shadow), var(--glass-glow);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
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

        /* Profile banner/cover matching admin style */
        .profile-cover {
            background-image: url('../assest/images/cover-image.png');
            background-size: 100% 100%;
            background-repeat: no-repeat;
            background-position: center;
            height: 120px;
            border-radius: var(--radius-md);
            position: relative;
        }
        .profile-cover::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 50%);
        }
        .avatar-holder {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            background: white;
            margin-top: -50px;
            margin-left: 20px;
            position: relative;
            z-index: 10;
            transition: transform 0.3s ease;
        }
        .avatar-holder:hover {
            transform: scale(1.05);
        }
        .avatar-holder img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Tab buttons layout matching admin style */
        .tab-nav-btn {
            background: transparent;
            border: none;
            outline: none;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--gray-500);
            padding: 10px 18px;
            cursor: pointer;
            position: relative;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .tab-nav-btn.active {
            color: var(--primary-600);
        }
        .tab-nav-btn::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 3px;
            background: transparent;
            transition: all 0.25s ease;
        }
        .tab-nav-btn.active::after {
            background: linear-gradient(90deg, var(--primary-500), var(--secondary-500));
        }

        .control-input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            outline: none;
            font-size: 0.95rem;
            color: var(--gray-800);
            font-family: inherit;
            transition: all 0.3s ease;
        }
        .control-input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }
        .control-input[readonly] {
            background: rgba(99, 102, 241, 0.03);
            color: var(--gray-500);
            cursor: not-allowed;
            border-color: var(--gray-200);
        }

        .sub-card {
            background: rgba(255, 255, 255, 0.45);
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.01);
            transition: all 0.3s ease;
        }
        .sub-card:hover {
            border-color: rgba(99, 102, 241, 0.18);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.02);
            transform: translateY(-2px);
        }

        .password-strength-bar {
            height: 6px;
            border-radius: var(--radius-full);
            background: var(--gray-200);
            margin-top: 10px;
            overflow: hidden;
            position: relative;
        }
        .strength-indicator {
            height: 100%;
            width: 0;
            transition: all 0.4s ease;
        }

        /* Banking detail cards */
        .banking-detail-card {
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            padding: 25px;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
        }
        .banking-detail-card:hover {
            background: rgba(255, 255, 255, 0.85);
            border-color: rgba(99, 102, 241, 0.3);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .card-ambient-badge {
            position: absolute;
            top: 0;
            right: 0;
            background: var(--gradient-primary);
            color: white;
            padding: 6px 15px;
            border-bottom-left-radius: var(--radius-md);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Password input visual tweaks */
        .password-input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;
        }
        .password-eye-icon {
            position: absolute;
            right: 15px;
            cursor: pointer;
            color: var(--gray-400);
            font-size: 1.25rem;
            transition: color 0.2s;
        }
        .password-eye-icon:hover {
            color: var(--primary-500);
        }

        .btn-submit-loading {
            position: relative;
            color: transparent !important;
            pointer-events: none;
        }
        .btn-submit-loading::after {
            content: "";
            position: absolute;
            width: 18px;
            height: 18px;
            top: 50%;
            left: 50%;
            margin-top: -9px;
            margin-left: -9px;
            border: 2px solid white;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spinLoading 0.6s linear infinite;
        }
        @keyframes spinLoading {
            to { transform: rotate(360deg); }
        }

        /* Dark Mode Color Overrides */
        body.dark-mode .sidebar {
            background: rgba(15, 23, 42, 0.45) !important;
        }
        body.dark-mode .sidebar-menu a {
            color: var(--gray-400) !important;
        }
        body.dark-mode .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.03);
            color: var(--white) !important;
        }
        body.dark-mode .sidebar-menu a.active {
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.35);
        }
        body.dark-mode .glass-card {
            background: rgba(30, 41, 59, 0.7) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
        }
        body.dark-mode .avatar-holder {
            border-color: var(--gray-800) !important;
            background: var(--gray-800) !important;
        }
        body.dark-mode .info-tile {
            background: rgba(15, 23, 42, 0.4) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
        }
        body.dark-mode .info-tile span {
            color: var(--gray-400) !important;
        }
        body.dark-mode .info-tile strong {
            color: white !important;
        }
        body.dark-mode .tab-nav-btn {
            color: var(--gray-400) !important;
        }
        body.dark-mode .tab-nav-btn.active {
            color: var(--primary-400) !important;
        }
        body.dark-mode .form-group input {
            background: rgba(15, 23, 42, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
        }
        body.dark-mode .sub-card {
            background: rgba(15, 23, 42, 0.3) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
            box-shadow: none !important;
        }
        body.dark-mode .sub-card:hover {
            border-color: rgba(255, 255, 255, 0.08) !important;
        }
        body.dark-mode .form-group label {
            color: var(--gray-300) !important;
        }
        body.dark-mode .toast-message {
            color: white !important;
        }
        /* Customer Profile Page Specifics */
        body.dark-mode .banking-detail-card {
            background: rgba(15, 23, 42, 0.4) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
        }
        body.dark-mode .banking-detail-card:hover {
            background: rgba(15, 23, 42, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.12) !important;
        }
        body.dark-mode .control-input {
            background: rgba(15, 23, 42, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
        }
        body.dark-mode .control-input[readonly] {
            background: rgba(255, 255, 255, 0.02) !important;
            color: var(--gray-500) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
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
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp" class="active"><i class="bx bx-user"></i> My Profile</a>
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
                <h2 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900);">My Profile &amp; Settings</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Review contact files, verify KYC, or update security credentials.</p>
            </div>

            <!-- Toast alert -->
            <div id="toast" style="position: fixed; top: 100px; right: 40px; z-index: 1000; background: white; padding: 15px 25px; border-radius: var(--radius-md); box-shadow: var(--shadow-xl); border: 1px solid var(--gray-200); display: flex; align-items: center; gap: 10px; transform: translateY(-50px); opacity: 0; transition: all 0.4s ease; border-left: 4px solid var(--primary-500);">
                <div class="toast-icon"></div>
                <div class="toast-message" style="font-weight: 600; color: var(--gray-800);">Action executed successfully.</div>
            </div>

            <!-- Hidden Upload Form -->
            <form id="avatarUploadForm" style="display: none;">
                <input type="file" id="avatarFileInput" name="avatarFile" accept="image/*" onchange="uploadAvatarDynamically();">
            </form>

            <!-- Split Grid Layout matching admin profile structure -->
            <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 30px;" class="mobile-grid-1">
                
                <!-- Left Details Banner Block -->
                <div style="display: flex; flex-direction: column; gap: 30px;">
                    <div class="glass-card" style="padding: 0;">
                        <!-- Cover Banner -->
                        <div class="profile-cover"></div>
                        
                        <!-- Floating Avatar -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding: 0 25px 25px;">
                            <div style="position: relative; display: inline-block;">
                                <c:set var="avatarUrl" value="" />
                                <c:if test="${not empty customer.avatarPath}">
                                    <c:set var="avatarUrl" value="${pageContext.request.contextPath}${customer.avatarPath}" />
                                </c:if>
                                <div class="avatar-holder" id="avatarClickContainer" style="cursor: pointer;" onclick="openLightbox('${avatarUrl}')" title="Click to View Profile Picture">
                                    <c:choose>
                                        <c:when test="${not empty customer.avatarPath}">
                                            <img id="avatarImageRef" src="${avatarUrl}" alt="Profile Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bx bxs-user-circle" style="font-size: 5.5rem; color: var(--gray-300);"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div onclick="document.getElementById('avatarFileInput').click();" style="position: absolute; bottom: 0; right: 0; background: var(--primary-500); color: white; width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1rem; border: 2px solid white; box-shadow: var(--shadow-md); cursor: pointer; z-index: 20;" title="Click to Change Profile Picture">
                                    <i class="bx bx-camera"></i>
                                </div>
                            </div>
                            <div style="background: rgba(16, 185, 129, 0.1); color: var(--accent-green); font-size: 0.72rem; font-weight: 700; padding: 5px 12px; border-radius: var(--radius-full); text-transform: uppercase; letter-spacing: 0.5px; border: 1px solid rgba(16, 185, 129, 0.2);">
                                <i class="bx bxs-circle" style="font-size: 0.55rem; vertical-align: middle; margin-right: 4px;"></i> ${customer.status}
                            </div>
                        </div>

                        <!-- User Profile Overview -->
                        <div style="padding: 0 25px 30px;">
                            <h3 id="bannerFullName" style="font-size: 1.35rem; font-weight: 800; color: var(--gray-900);">${customer.fullName}</h3>
                            <p style="font-size: 0.85rem; color: var(--gray-400); margin-top: 2px;">Customer Account</p>
                            
                            <hr style="border: none; border-top: 1px solid var(--gray-100); margin: 20px 0;">

                            <div style="display: flex; flex-direction: column; gap: 15px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span style="color: var(--gray-400);">Customer ID:</span>
                                    <strong style="color: var(--gray-700); font-family: monospace;">#VGB-CUST-${customer.customerId}</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span style="color: var(--gray-400);">Username:</span>
                                    <strong style="color: var(--gray-700); font-family: monospace;">${customer.username}</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span style="color: var(--gray-400);">Nationality Status:</span>
                                    <strong style="color: var(--primary-500); text-transform: uppercase;"><i class="bx bx-check-shield"></i> Indian</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Net Worth Card matching admin System health layout -->
                    <div class="glass-card" style="background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(168, 85, 247, 0.05) 100%);">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-wallet" style="color: var(--primary-500);"></i> Combined Net Worth
                        </h4>
                        <div style="font-size: 1.8rem; font-weight: 800; color: var(--gray-900); margin-bottom: 8px;">
                            ₹<fmt:formatNumber value="${totalBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                        </div>
                        <div style="font-size: 0.82rem; color: var(--gray-500); line-height: 1.5; margin-bottom: 15px;">
                            Combined balance across all savings, checking, and current accounts linked to your customer ID.
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.85rem; font-weight: 600; color: var(--gray-700); margin-bottom: 8px;">
                            <span>Audit Security Status</span>
                            <span style="color: var(--accent-green);">Secure Access</span>
                        </div>
                        <div class="password-strength-bar" style="margin-top: 0;">
                            <div class="strength-indicator" style="width: 100%; background: var(--accent-green);"></div>
                        </div>
                    </div>
                </div>

                <!-- Right Settings Card -->
                <div class="glass-card">
                    <!-- Tabs Navigation Bar matching admin style -->
                    <div style="display: flex; gap: 15px; border-bottom: 2px solid var(--gray-200); margin-bottom: 30px; flex-wrap: wrap;">
                        <button type="button" class="tab-nav-btn active" id="btn-tab-info" onclick="switchProfileTab('info')">
                            <i class="bx bx-info-circle" style="font-size: 1.15rem;"></i> Profile Specs
                        </button>
                        <button type="button" class="tab-nav-btn" id="btn-tab-credentials" onclick="switchProfileTab('credentials')">
                            <i class="bx bx-shield-quarter" style="font-size: 1.15rem;"></i> Update Credentials
                        </button>
                        <button type="button" class="tab-nav-btn" id="btn-tab-banking" onclick="switchProfileTab('banking')">
                            <i class="bx bx-wallet" style="font-size: 1.15rem;"></i> Banking Ledger
                        </button>
                    </div>

                    <!-- Tab 1: Profile Specifications & Updates -->
                    <div id="tab-content-info">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-card" style="color: var(--primary-500);"></i> Profile Contact Information
                        </h4>
                        
                        <form id="personalUpdateForm" onsubmit="submitContactUpdate(event)">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;" class="mobile-grid-1">
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">First Name</label>
                                    <input type="text" id="firstName" value="${customer.firstName}" required class="control-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Last Name</label>
                                    <input type="text" id="lastName" value="${customer.lastName}" required class="control-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Email Address</label>
                                    <input type="email" id="email" value="${customer.email}" required class="control-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Mobile Number</label>
                                    <input type="text" id="phoneNo" value="${customer.phoneNo}" required class="control-input">
                                </div>
                            </div>
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Home Street Address</label>
                                <input type="text" id="address" value="${customer.address}" required class="control-input">
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 20px;" class="mobile-grid-1">
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">City</label>
                                    <input type="text" id="city" value="${customer.city}" required class="control-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">State</label>
                                    <input type="text" id="state" value="${customer.state}" required class="control-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Zip Code</label>
                                    <input type="text" id="zipCode" value="${customer.zipCode}" required class="control-input">
                                </div>
                            </div>
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px;" class="mobile-grid-1">
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Aadhaar Card Number</label>
                                    <input type="text" value="${customer.aadhaarCard}" readonly class="control-input">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">PAN Card Number</label>
                                    <input type="text" value="${customer.panCard}" readonly class="control-input">
                                </div>
                            </div>
 
                            <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                <span>Save Changes</span>
                                <i class="bx bx-check"></i>
                            </button>
                        </form>
                    </div>

                    <!-- Tab 2: Security & Credentials Forms -->
                    <div id="tab-content-credentials" style="display: none;">
                        <!-- Update Password Card -->
                        <div class="sub-card">
                            <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="bx bx-key" style="color: var(--primary-500); font-size: 1.4rem; background: rgba(99, 102, 241, 0.1); padding: 8px; border-radius: 50%;"></i> Change Account Login Password
                            </h4>
                            <form id="passwordUpdateForm" onsubmit="submitPasswordUpdate(event)" style="display: flex; flex-direction: column; gap: 20px; max-width: 550px;">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Old Password</label>
                                    <div class="password-input-wrapper">
                                        <input type="password" id="oldPasswordInput" required class="control-input">
                                        <i class="bx bx-hide password-eye-icon" onclick="togglePasswordVisibility('oldPasswordInput', this)"></i>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">New Password</label>
                                    <div class="password-input-wrapper">
                                        <input type="password" id="newPasswordInput" required class="control-input" oninput="updatePasswordStrengthMeter(this.value)">
                                        <i class="bx bx-hide password-eye-icon" onclick="togglePasswordVisibility('newPasswordInput', this)"></i>
                                    </div>
                                    
                                    <!-- Dynamic Strength Indicator -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px; font-size: 0.75rem; font-weight: 600;">
                                        <span style="color: var(--gray-400);">Password Strength:</span>
                                        <span id="strengthText" style="color: #ef4444; font-weight: 700;">Too Short</span>
                                    </div>
                                    <div class="password-strength-bar">
                                        <div class="strength-indicator" id="strengthBar" style="background: #ef4444; width: 0%;"></div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="align-self: start; padding: 12px 28px; border-radius: var(--radius-md); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2); display: inline-flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-lock-alt" style="font-size: 1.1rem;"></i> Update Password
                                </button>
                            </form>
                        </div>

                        <!-- Update PIN Card -->
                        <div class="sub-card">
                            <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="bx bx-lock-open" style="color: var(--secondary-500); font-size: 1.4rem; background: rgba(168, 85, 247, 0.1); padding: 8px; border-radius: 50%;"></i> Change Transaction PIN
                            </h4>
                            <form id="pinUpdateForm" onsubmit="submitPinUpdate(event)" style="display: flex; flex-direction: column; gap: 20px; max-width: 550px;">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">New 4-Digit Secure PIN</label>
                                    <div class="password-input-wrapper">
                                        <input type="password" id="newPinInput" maxlength="4" pattern="^[0-9]{4}$" required placeholder="E.g. 0000" class="control-input" style="font-family: monospace; letter-spacing: 4px; font-weight: 700;">
                                        <i class="bx bx-hide password-eye-icon" onclick="togglePasswordVisibility('newPinInput', this)"></i>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="align-self: start; padding: 12px 28px; border-radius: var(--radius-md); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2); display: inline-flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-shield" style="font-size: 1.1rem;"></i> Update PIN
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Tab 3: Banking Signatory & Account details -->
                    <div id="tab-content-banking" style="display: none;">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-wallet" style="color: var(--primary-500);"></i> Mapped Accounts &amp; Signatory Authorities
                        </h4>
                        <p style="color: var(--gray-400); font-size: 0.82rem; margin-bottom: 25px;">Review ledger records, nominees, and joint holdings of your bank profiles.</p>
                        
                        <div style="display: flex; flex-direction: column; gap: 20px;">
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}">
                                        <div class="banking-detail-card">
                                            <div class="card-ambient-badge">
                                                Active ${acc.accountType}
                                            </div>
                                            
                                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px 30px; margin-top: 15px;" class="mobile-grid-1">
                                                <div>
                                                    <span style="display: block; font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Customer ID</span>
                                                    <strong style="font-size: 0.9rem; color: var(--gray-700); display: block; margin-top: 3px;">#VGB-CUST-${acc.customerId > 0 ? acc.customerId : customer.customerId}</strong>
                                                </div>
                                                <div>
                                                    <span style="display: block; font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">IFSC Code</span>
                                                    <strong style="font-size: 0.9rem; color: var(--gray-700); display: block; margin-top: 3px; font-family: monospace;">${acc.ifscCode}</strong>
                                                </div>
                                                <div>
                                                    <span style="display: block; font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Account Number</span>
                                                    <strong style="font-size: 1rem; color: var(--primary-500); display: block; margin-top: 3px; font-family: 'Share Tech Mono', monospace; letter-spacing: 0.5px;">${acc.accountNumber}</strong>
                                                </div>
                                                <div>
                                                    <span style="display: block; font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Nominee Name</span>
                                                    <strong style="font-size: 0.9rem; color: var(--gray-700); display: block; margin-top: 3px;">
                                                        <c:choose>
                                                            <c:when test="${acc.accountType == 'savings' && not empty acc.nomineeName}">
                                                                ${acc.nomineeName}
                                                            </c:when>
                                                            <c:when test="${acc.accountType == 'savings'}">
                                                                No Nominee Assigned
                                                            </c:when>
                                                            <c:otherwise>
                                                                Not Applicable
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </div>
                                                <div style="grid-column: span 2; background: rgba(99, 102, 241, 0.02); padding: 10px; border-radius: var(--radius-sm); border: 1px solid rgba(99, 102, 241, 0.05);">
                                                    <span style="display: block; font-size: 0.7rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 2px;">Signatories</span>
                                                    <strong style="font-size: 0.9rem; color: var(--gray-800); display: flex; align-items: center; gap: 6px;">
                                                        <i class="bx bx-check-double" style="color: var(--accent-green);"></i>
                                                        <span>${acc.customerName} <span style="font-weight: 500; font-size: 0.78rem; color: var(--gray-500);">(${acc.holdingType != null ? acc.holdingType : 'primary'} holding)</span></span>
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; padding: 30px; background: rgba(99, 102, 241, 0.03); border: 1px dashed var(--gray-200); border-radius: var(--radius-md); color: var(--gray-400);">
                                        <p style="font-weight: 500;">No active account signatories found on this profile.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Premium Image Lightbox Modal -->
    <div id="imageLightbox" style="position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(15px); z-index: 2000; display: none; align-items: center; justify-content: center; opacity: 0; transition: opacity 0.3s ease;" onclick="closeLightbox()">
        <!-- Close button -->
        <button onclick="closeLightbox(event)" style="position: absolute; top: 40px; right: 40px; background: rgba(255, 255, 255, 0.1); border: none; color: white; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; cursor: pointer; transition: all 0.3s; outline: none;" onmouseover="this.style.background='rgba(255, 255, 255, 0.25)'; this.style.transform='scale(1.1)'" onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'; this.style.transform='scale(1)'">
            <i class="bx bx-x"></i>
        </button>
        <!-- Image wrapper -->
        <div style="max-width: 90%; max-height: 90%; border-radius: var(--radius-lg); overflow: hidden; border: 4px solid rgba(255, 255, 255, 0.2); box-shadow: var(--shadow-2xl); transform: scale(0.9); transition: transform 0.3s ease;" id="lightboxImageWrapper">
            <img id="lightboxImg" src="" alt="Profile Lightbox" style="max-width: 450px; max-height: 450px; border-radius: 50%; border: 6px solid rgba(255,255,255,0.25); box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); object-fit: cover; display: block;">
        </div>
    </div>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        // Tab switching controller matching admin style
        function switchProfileTab(tabId) {
            document.querySelectorAll('.tab-nav-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.getElementById('tab-content-info').style.display = 'none';
            document.getElementById('tab-content-credentials').style.display = 'none';
            document.getElementById('tab-content-banking').style.display = 'none';

            document.getElementById('btn-tab-' + tabId).classList.add('active');
            document.getElementById('tab-content-' + tabId).style.display = 'block';
        }

        // Live Password Strength Meter Logic
        function updatePasswordStrengthMeter(password) {
            const bar = document.getElementById('strengthBar');
            const text = document.getElementById('strengthText');
            
            if (password.length === 0) {
                bar.style.width = '0%';
                text.innerText = 'Too Short';
                text.style.color = '#ef4444';
                return;
            }

            let score = 0;
            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;

            switch (score) {
                case 0:
                case 1:
                    bar.style.width = '25%';
                    bar.style.background = '#ef4444';
                    text.innerText = 'Weak Password';
                    text.style.color = '#ef4444';
                    break;
                case 2:
                    bar.style.width = '50%';
                    bar.style.background = '#f59e0b';
                    text.innerText = 'Medium Password';
                    text.style.color = '#f59e0b';
                    break;
                case 3:
                    bar.style.width = '75%';
                    bar.style.background = '#3b82f6';
                    text.innerText = 'Good Password';
                    text.style.color = '#3b82f6';
                    break;
                case 4:
                    bar.style.width = '100%';
                    bar.style.background = '#10b981';
                    text.innerText = 'Strong Secure Password';
                    text.style.color = '#10b981';
                    break;
            }
        }

        // Response Toast Alerts Display
        function showResponseToast(message, isSuccess = true) {
            const toast = document.getElementById('toast');
            const toastIcon = toast.querySelector('.toast-icon');
            const toastMessage = toast.querySelector('.toast-message');
            
            if (isSuccess) {
                toastIcon.innerHTML = '<i class="bx bx-check-circle" style="color: #10b981; font-size: 1.5rem;"></i>';
                toast.style.borderColor = 'rgba(16, 185, 129, 0.3)';
                toast.style.borderLeftColor = '#10b981';
                toast.style.background = 'rgba(255, 255, 255, 0.95)';
            } else {
                toastIcon.innerHTML = '<i class="bx bx-error-circle" style="color: #ef4444; font-size: 1.5rem;"></i>';
                toast.style.borderColor = 'rgba(239, 68, 68, 0.3)';
                toast.style.borderLeftColor = '#ef4444';
                toast.style.background = 'rgba(255, 255, 255, 0.95)';
            }
            
            toastMessage.innerText = message;
            toast.style.transform = 'translateY(0)';
            toast.style.opacity = '1';
            
            setTimeout(() => {
                toast.style.transform = 'translateY(-50px)';
                toast.style.opacity = '0';
            }, 4000);
        }

        // Submitting Contact Updates
        function submitContactUpdate(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            if (btn) {
                btn.classList.add('btn-submit-loading');
                btn.disabled = true;
                btn.setAttribute('data-orig-html', btn.innerHTML);
            }
            
            const params = new URLSearchParams();
            params.append('action', 'updateContact');
            params.append('firstName', document.getElementById('firstName').value);
            params.append('lastName', document.getElementById('lastName').value);
            params.append('email', document.getElementById('email').value);
            params.append('phoneNo', document.getElementById('phoneNo').value);
            params.append('address', document.getElementById('address').value);
            params.append('city', document.getElementById('city').value);
            params.append('state', document.getElementById('state').value);
            params.append('zipCode', document.getElementById('zipCode').value);
            
            fetch('${pageContext.request.contextPath}/update-profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || err.message || 'Failed to update contact card'); });
                }
                return response.json();
            })
            .then(data => {
                if (btn) {
                    btn.classList.remove('btn-submit-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(data.message || 'Contact details updated successfully!', true);
                const fullName = document.getElementById('firstName').value + ' ' + document.getElementById('lastName').value;
                const bannerName = document.getElementById('bannerFullName');
                if (bannerName) {
                    bannerName.innerText = fullName;
                }
            })
            .catch(error => {
                if (btn) {
                    btn.classList.remove('btn-submit-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(error.message, false);
            });
        }

        // Submitting Password Update Request (Preserved Backend Integration)
        function submitPasswordUpdate(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            if (btn) {
                btn.classList.add('btn-submit-loading');
                btn.disabled = true;
                btn.setAttribute('data-orig-html', btn.innerHTML);
            }
            
            const oldPassword = document.getElementById('oldPasswordInput').value;
            const newPassword = document.getElementById('newPasswordInput').value;
            
            const params = new URLSearchParams();
            params.append('action', 'updatePassword');
            params.append('oldPassword', oldPassword);
            params.append('newPassword', newPassword);
            
            fetch('${pageContext.request.contextPath}/update-profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || err.message || 'Failed to change password'); });
                }
                return response.json();
            })
            .then(data => {
                if (btn) {
                    btn.classList.remove('btn-submit-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(data.message || 'Password changed successfully!', true);
                document.getElementById('passwordUpdateForm').reset();
                updatePasswordStrengthMeter('');
            })
            .catch(error => {
                if (btn) {
                    btn.classList.remove('btn-submit-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(error.message, false);
            });
        }

        // Submitting PIN Update Request (Preserved Backend Integration)
        function submitPinUpdate(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            if (btn) {
                btn.classList.add('btn-submit-loading');
                btn.disabled = true;
                btn.setAttribute('data-orig-html', btn.innerHTML);
            }
            
            const newPin = document.getElementById('newPinInput').value;
            
            const params = new URLSearchParams();
            params.append('action', 'updatePin');
            params.append('newPin', newPin);
            
            fetch('${pageContext.request.contextPath}/update-profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || err.message || 'Failed to update transaction PIN'); });
                }
                return response.json();
            })
            .then(data => {
                if (btn) {
                    btn.classList.remove('btn-submit-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(data.message || 'Transaction PIN updated successfully!', true);
                document.getElementById('pinUpdateForm').reset();
            })
            .catch(error => {
                if (btn) {
                    btn.classList.remove('btn-submit-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(error.message, false);
            });
        }

        // Input Password Toggle Visibility Handler
        function togglePasswordVisibility(inputId, icon) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bx-hide');
                icon.classList.add('bx-show');
            } else {
                input.type = 'password';
                icon.classList.remove('bx-show');
                icon.classList.add('bx-hide');
            }
        }

        /* --- Full Screen Avatar Lightbox Methods --- */
        function openLightbox(imgSrc) {
            if (!imgSrc) {
                return;
            }
            const lightbox = document.getElementById('imageLightbox');
            const lightboxImg = document.getElementById('lightboxImg');
            const wrapper = document.getElementById('lightboxImageWrapper');
            
            lightboxImg.src = imgSrc;
            lightbox.style.display = 'flex';
            
            setTimeout(() => {
                lightbox.style.opacity = '1';
                wrapper.style.transform = 'scale(1)';
            }, 15);
        }

        function closeLightbox(e) {
            if (e) {
                e.stopPropagation();
            }
            const lightbox = document.getElementById('imageLightbox');
            const wrapper = document.getElementById('lightboxImageWrapper');
            
            lightbox.style.opacity = '0';
            wrapper.style.transform = 'scale(0.9)';
            
            setTimeout(() => {
                lightbox.style.display = 'none';
            }, 300);
        }

        function uploadAvatarDynamically() {
            const fileInput = document.getElementById('avatarFileInput');
            if (fileInput.files.length === 0) {
                return;
            }
            
            const file = fileInput.files[0];
            
            if (!file.type.startsWith('image/')) {
                showResponseToast('Only image files (JPEG, PNG, GIF) are allowed.', false);
                fileInput.value = '';
                return;
            }
            
            showResponseToast('Uploading profile picture...', true);
            
            const formData = new FormData();
            formData.append('avatarFile', file);
            
            fetch('${pageContext.request.contextPath}/upload-profile', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json'
                },
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { 
                        throw new Error(err.error || err.message || 'Failed to upload profile picture.'); 
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const relativePath = data.avatarPath;
                    const absolutePath = '${pageContext.request.contextPath}' + relativePath;
                    
                    const clickContainer = document.getElementById('avatarClickContainer');
                    if (clickContainer) {
                        clickContainer.innerHTML = `<img id="avatarImageRef" src="${absolutePath}" alt="Profile Avatar">`;
                        clickContainer.onclick = function() {
                            openLightbox(absolutePath);
                        };
                    }
                    
                    fileInput.value = '';
                    showResponseToast('Profile picture uploaded successfully!', true);
                } else {
                    showResponseToast('Failed to update profile picture.', false);
                }
            })
            .catch(error => {
                showResponseToast(error.message, false);
                fileInput.value = '';
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
