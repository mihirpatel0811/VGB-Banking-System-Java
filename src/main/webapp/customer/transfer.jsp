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
    <title>VGB | Transfer Funds</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
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
            z-index: 100;
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
        /* Premium Logout Button */
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
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 30px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
        }
        .portal-tab-btn {
            padding: 12px 24px !important;
            font-weight: 600 !important;
            font-size: 0.88rem !important;
            border-radius: var(--radius-md) !important;
            cursor: pointer !important;
            border: 1.5px solid rgba(99, 102, 241, 0.15) !important;
            background: rgba(255, 255, 255, 0.7) !important;
            color: var(--gray-600) !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
            backdrop-filter: blur(10px) !important;
            box-shadow: var(--shadow-sm) !important;
            outline: none;
        }
        
        body.dark-mode .portal-tab-btn {
            background: rgba(30, 41, 59, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            color: var(--gray-300) !important;
        }

        .portal-tab-btn:hover {
            border-color: var(--primary-400) !important;
            color: var(--primary-500) !important;
            transform: translateY(-3px) scale(1.02) !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.15) !important;
            background: rgba(99, 102, 241, 0.05) !important;
        }
        
        body.dark-mode .portal-tab-btn:hover {
            background: rgba(99, 102, 241, 0.1) !important;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3) !important;
        }

        .portal-tab-btn.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            border-color: transparent !important;
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.25), 0 0 15px rgba(236, 72, 153, 0.15) !important;
            transform: translateY(-2px) !important;
        }
        
        body.dark-mode .portal-tab-btn.active {
            box-shadow: 0 10px 25px rgba(99, 102, 241, 0.35), 0 0 15px rgba(236, 72, 153, 0.25) !important;
        }
        .portal-form-section {
            display: none;
        }
        .portal-form-section.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Unified Form Controls styling */
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 8px;
            transition: color 0.3s ease;
        }
        .form-control-modern {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            background: rgba(255, 255, 255, 0.85);
            color: var(--gray-800);
            font-family: inherit;
            font-size: 0.9rem;
            outline: none;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .form-control-modern:focus {
            border-color: var(--primary-400);
            background: white;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15), 0 4px 12px rgba(99, 102, 241, 0.05);
        }
        
        /* Checkbox & radio custom styling */
        .custom-option-card {
            background: rgba(99, 102, 241, 0.02);
            border: 1.5px dashed rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            padding: 16px;
            margin-bottom: 24px;
            transition: all 0.3s ease;
        }
        .custom-option-card:hover {
            background: rgba(99, 102, 241, 0.04);
            border-color: rgba(99, 102, 241, 0.3);
        }
        
        /* Premium Submit Buttons */
        .btn-submit-premium {
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px 28px;
            font-weight: 700;
            font-size: 0.9rem;
            border-radius: var(--radius-md);
            border: none;
            background: var(--gradient-primary);
            color: white !important;
            cursor: pointer;
            box-shadow: 0 8px 22px rgba(99, 102, 241, 0.2);
            transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn-submit-premium:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(99, 102, 241, 0.3);
        }
        .btn-submit-premium:active {
            transform: translateY(0);
        }
        .btn-submit-premium i {
            font-size: 1.2rem;
            transition: transform 0.3s ease;
        }
        .btn-submit-premium:hover i {
            transform: scale(1.1) rotate(5deg);
        }
        
        /* Glass Alert Elements */
        .glass-alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            border-radius: var(--radius-md);
            margin-bottom: 25px;
            font-size: 0.85rem;
            font-weight: 500;
            border: 1px solid transparent;
            backdrop-filter: blur(10px);
            animation: fadeIn 0.4s ease;
        }
        .glass-alert-danger {
            background: rgba(239, 68, 68, 0.08);
            border-color: rgba(239, 68, 68, 0.2);
            color: #b91c1c;
        }
        .glass-alert-success {
            background: rgba(16, 185, 129, 0.08);
            border-color: rgba(16, 185, 129, 0.2);
            color: #047857;
        }
        
        /* Receipt-style Ticket */
        .verification-receipt-card {
            background: rgba(255, 255, 255, 0.85);
            border: 1.5px solid rgba(16, 185, 129, 0.25);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-top: 30px;
            position: relative;
            box-shadow: 0 10px 30px rgba(16, 185, 129, 0.05);
            animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .verification-receipt-card::before, .verification-receipt-card::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            background: var(--gray-50);
            border-radius: 50%;
            top: 50%;
            transform: translateY(-50%);
        }
        .verification-receipt-card::before {
            left: -9px;
            border-right: 1.5px solid rgba(16, 185, 129, 0.25);
        }
        .verification-receipt-card::after {
            right: -9px;
            border-left: 1.5px solid rgba(16, 185, 129, 0.25);
        }
        .receipt-dashed-line {
            border-top: 1.5px dashed rgba(16, 185, 129, 0.25);
            margin: 20px 0;
            position: relative;
        }
        .receipt-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px 20px;
        }
        @media (max-width: 480px) {
            .receipt-grid {
                grid-template-columns: 1fr;
            }
        }
        .receipt-item span {
            font-size: 0.72rem;
            text-transform: uppercase;
            color: var(--gray-400);
            font-weight: 700;
            letter-spacing: 0.5px;
            display: block;
        }
        .receipt-item strong {
            display: block;
            font-size: 0.95rem;
            color: var(--gray-800);
            margin-top: 4px;
        }
        
        /* Secondary Button (Verify) */
        .btn-verify-modern {
            padding: 12px 24px;
            font-weight: 700;
            font-size: 0.85rem;
            border-radius: var(--radius-md);
            border: 1.5px solid rgba(99, 102, 241, 0.2);
            background: transparent;
            color: var(--primary-600) !important;
            cursor: pointer;
            transition: all var(--transition-normal);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            outline: none;
        }
        .btn-verify-modern:hover {
            background: rgba(99, 102, 241, 0.05);
            border-color: var(--primary-400);
            transform: translateY(-1px);
        }

        /* Visual Selector Cards CSS */
        .account-selector-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
            margin-top: 5px;
        }
        .account-select-card {
            background: rgba(255, 255, 255, 0.45);
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            padding: 16px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            user-select: none;
        }
        .account-select-card:hover {
            border-color: var(--primary-300);
            background: rgba(99, 102, 241, 0.03);
            transform: translateY(-2px);
        }
        .account-select-card.active {
            border-color: var(--primary-500);
            background: rgba(99, 102, 241, 0.06);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.1);
        }
        .account-select-card.active::after {
            content: '✓';
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary-500);
            color: white;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .acc-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .acc-card-type {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--gray-500);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .account-select-card.active .acc-card-type {
            color: var(--primary-600);
        }
        .acc-card-badge {
            font-size: 0.65rem;
            font-weight: 600;
            background: rgba(99, 102, 241, 0.08);
            color: var(--primary-600);
            padding: 2px 6px;
            border-radius: var(--radius-sm);
        }
        .acc-card-num {
            display: block;
            font-family: monospace;
            font-size: 0.85rem;
            color: var(--gray-600);
            font-weight: 600;
        }
        .acc-card-bal {
            display: block;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--gray-800);
            margin-top: 4px;
        }
        
        .card-selector-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 10px;
            margin-bottom: 10px;
        }
        .card-select-card {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border: 1.5px solid transparent;
            border-radius: var(--radius-md);
            padding: 16px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            box-shadow: var(--shadow-sm);
            user-select: none;
        }
        .card-select-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .card-select-card.active {
            border-color: var(--primary-400);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.25);
        }
        .card-select-card.active::after {
            content: '✓';
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary-500);
            color: white;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .mini-card-brand {
            font-size: 0.65rem;
            font-weight: 800;
            letter-spacing: 0.5px;
            opacity: 0.8;
        }
        .mini-card-type {
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.6;
            margin-top: 2px;
        }
        .mini-card-number {
            font-family: monospace;
            font-size: 0.85rem;
            margin-top: 15px;
            font-weight: 600;
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
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
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
            <a href="${pageContext.request.contextPath}/account?action=transferPage" class="active"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
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
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Digital Operations Portal</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Transfer funds or request cash counter withdrawals through our secure digital gateway.</p>
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

            <!-- Portal Tab Navigation Bar -->
            <div style="display: flex; gap: 15px; margin-bottom: 30px; flex-wrap: wrap;">
                <button type="button" id="tabBtnTransfer" onclick="showPortalTab('transfer')" class="portal-tab-btn active">
                    <i class="bx bx-send"></i> Fund Transfer
                </button>
                <button type="button" id="tabBtnWithdraw" onclick="showPortalTab('withdraw')" class="portal-tab-btn">
                    <i class="bx bx-down-arrow-circle"></i> Cash Withdrawal
                </button>
                <button type="button" id="tabBtnCardDeposit" onclick="showPortalTab('cardDeposit')" class="portal-tab-btn">
                    <i class="bx bx-credit-card-front"></i> Card Deposit
                </button>
                <button type="button" id="tabBtnAddBeneficiary" onclick="showPortalTab('addBeneficiary')" class="portal-tab-btn">
                    <i class="bx bx-user-plus"></i> Add Beneficiary
                </button>
            </div>

            <div class="portal-workspace-grid">
                <!-- Portal Workspace -->
                <div class="glass-card">
                    
                    <!-- SECTION 1: FUND TRANSFER -->
                    <div id="secTransfer" class="portal-form-section active">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-send"></i> New Transfer Request
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=transfer" method="post" onsubmit="return validateTransferForm(event)">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Source Account Select Dropdown -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label>Select Source Account</label>
                                <select id="transferSourceAccount" name="fromAccountId" required style="display: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="account-selector-grid" id="gridTransferSource">
                                    <c:forEach items="${accounts}" var="acc" varStatus="vs">
                                        <div class="account-select-card ${vs.first ? 'active' : ''}" data-value="${acc.accountId}">
                                            <div class="acc-card-header">
                                                <span class="acc-card-type"><i class="bx bx-wallet"></i> ${acc.accountType}</span>
                                                <span class="acc-card-badge">Primary</span>
                                            </div>
                                            <div class="acc-card-body">
                                                <span class="acc-card-num">${acc.accountNumber}</span>
                                                <span class="acc-card-bal">₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ATM Card payment checkbox -->
                            <div class="custom-option-card">
                                <label style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primary-500); cursor: pointer; margin-bottom: 0;">
                                    <input type="checkbox" id="transferUseCard" name="useCard" value="true" onchange="toggleTransferCardFields()" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                    <span>Pay using active VGB ATM Card (Debit/Credit)</span>
                                </label>
                                
                                <div id="transferCardFields" style="display: none; margin-top: 15px; border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px;">
                                    <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 15px; margin-bottom: 10px;" class="mobile-grid-1">
                                        <div>
                                            <label>Select ATM Card</label>
                                            <select id="transferCardId" name="cardId" style="display: none;">
                                                <c:forEach items="${cards}" var="card">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <option value="${card.cardId}">
                                                            ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                            <div class="card-selector-grid" id="gridTransferCard">
                                                <c:forEach items="${cards}" var="card" varStatus="vs">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <div class="card-select-card ${vs.first ? 'active' : ''}" data-value="${card.cardId}">
                                                            <div class="mini-card-brand">${card.cardProvider.toUpperCase()}</div>
                                                            <div class="mini-card-type">${card.cardType.toUpperCase()}</div>
                                                            <div class="mini-card-number">${card.getMaskedCardNumber()}</div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div>
                                            <label for="transferCardCvv" style="display: block; font-size: 0.8rem; font-weight: 500; color: var(--gray-700); margin-bottom: 5px;">Enter 3-Digit CVV</label>
                                            <input type="password" maxlength="3" id="transferCardCvv" name="cvv" placeholder="•••" class="form-control-modern" style="font-family: monospace;">
                                        </div>
                                    </div>
                                    <span style="font-size: 0.75rem; color: var(--gray-400);"><i class="bx bx-info-circle"></i> Selecting a card overrides the source account selection. Standard card limits will apply.</span>
                                </div>
                            </div>

                            <!-- Destination Type Selector -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label>Transfer Destination Type</label>
                                <div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; color: var(--gray-600); cursor: pointer;">
                                        <input type="radio" name="destType" value="own" checked onclick="toggleDestType('own')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Another Account of Yours (Internal)</span>
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; color: var(--gray-600); cursor: pointer;">
                                        <input type="radio" name="destType" value="p2p" onclick="toggleDestType('p2p')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Other Customer's Account (P2P)</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Target Own Account Dropdown (Active by default) -->
                            <div class="form-group" id="containerInternalTarget" style="margin-bottom: 20px;">
                                <label>Select Destination Account</label>
                                <select id="toAccountIdInternal" name="toAccountId" required style="display: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="account-selector-grid" id="gridTransferDest">
                                    <c:forEach items="${accounts}" var="acc" varStatus="vs">
                                        <div class="account-select-card ${vs.first ? 'active' : ''}" data-value="${acc.accountId}">
                                            <div class="acc-card-header">
                                                <span class="acc-card-type"><i class="bx bx-wallet"></i> ${acc.accountType}</span>
                                                <span class="acc-card-badge">Secondary</span>
                                            </div>
                                            <div class="acc-card-body">
                                                <span class="acc-card-num">${acc.accountNumber}</span>
                                                <span class="acc-card-bal">₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Target Other Customer Beneficiary Dropdown (Disabled/Hidden by default) -->
                            <div class="form-group" id="containerExternalTarget" style="margin-bottom: 20px; display: none;">
                                <label>Select Saved Customer Beneficiary</label>
                                <select id="toAccountIdExternal" class="form-control-modern" style="display: none;">
                                    <c:forEach items="${beneficiaries}" var="ben">
                                        <option value="${ben.nomineeName}">
                                            ${ben.customerName} - ${ben.accountNumber} (${ben.accountType}) [IFSC: ${ben.ifscCode}]
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="account-selector-grid" id="gridTransferDestExternal">
                                    <c:choose>
                                        <c:when test="${not empty beneficiaries}">
                                            <c:forEach items="${beneficiaries}" var="ben" varStatus="vs">
                                                <div class="account-select-card ${vs.first ? 'active' : ''}" data-value="${ben.nomineeName}">
                                                    <div class="acc-card-header">
                                                        <span class="acc-card-type"><i class="bx bx-user"></i> ${ben.customerName}</span>
                                                        <span class="acc-card-badge" style="background: rgba(16, 185, 129, 0.08); color: #10b981;">Beneficiary</span>
                                                    </div>
                                                    <div class="acc-card-body">
                                                        <span class="acc-card-num">${ben.accountNumber}</span>
                                                        <span class="acc-card-bal" style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; margin-top: 5px;">IFSC: ${ben.ifscCode}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="grid-column: 1 / -1; padding: 20px; text-align: center; background: rgba(99, 102, 241, 0.03); border: 1.5px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-md); color: var(--gray-500); font-size: 0.88rem;">
                                                <i class="bx bx-info-circle" style="font-size: 1.5rem; display: block; margin-bottom: 8px; color: var(--primary-400);"></i>
                                                No saved beneficiaries. Register one under the <strong>Add Beneficiary</strong> tab to enable transfers.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Transfer Amount -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="amount">Amount to Transfer (INR)</label>
                                <input type="number" step="0.01" min="100" id="amount" name="amount" required placeholder="Min. ₹100" class="form-control-modern">
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="description">Transaction Description</label>
                                <input type="text" id="description" name="description" placeholder="E.g., Rent, Family Support" class="form-control-modern">
                            </div>

                            <button type="submit" class="btn-submit-premium">
                                <span>Authenticate Transfer</span>
                                <i class="bx bx-shield-quarter"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 2: CASH WITHDRAWAL -->
                    <div id="secWithdraw" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-down-arrow-circle"></i> Counter Cash Withdrawal
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=withdraw" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Source Account Select Dropdown -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label>Select Source Account</label>
                                <select id="withdrawSourceAccount" name="accountId" required style="display: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="account-selector-grid" id="gridWithdrawSource">
                                    <c:forEach items="${accounts}" var="acc" varStatus="vs">
                                        <div class="account-select-card ${vs.first ? 'active' : ''}" data-value="${acc.accountId}">
                                            <div class="acc-card-header">
                                                <span class="acc-card-type"><i class="bx bx-wallet"></i> ${acc.accountType}</span>
                                                <span class="acc-card-badge">Primary</span>
                                            </div>
                                            <div class="acc-card-body">
                                                <span class="acc-card-num">${acc.accountNumber}</span>
                                                <span class="acc-card-bal">₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ATM Card withdraw checkbox -->
                            <div class="custom-option-card">
                                <label style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primary-500); cursor: pointer; margin-bottom: 0;">
                                    <input type="checkbox" id="withdrawUseCard" name="useCard" value="true" onchange="toggleWithdrawCardFields()" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                    <span>Withdraw using active VGB ATM Card (Debit/Credit)</span>
                                </label>
                                
                                <div id="withdrawCardFields" style="display: none; margin-top: 15px; border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px;">
                                    <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 15px; margin-bottom: 10px;" class="mobile-grid-1">
                                        <div>
                                            <label>Select ATM Card</label>
                                            <select id="withdrawCardId" name="cardId" style="display: none;">
                                                <c:forEach items="${cards}" var="card">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <option value="${card.cardId}">
                                                            ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                            <div class="card-selector-grid" id="gridWithdrawCard">
                                                <c:forEach items="${cards}" var="card" varStatus="vs">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <div class="card-select-card ${vs.first ? 'active' : ''}" data-value="${card.cardId}">
                                                            <div class="mini-card-brand">${card.cardProvider.toUpperCase()}</div>
                                                            <div class="mini-card-type">${card.cardType.toUpperCase()}</div>
                                                            <div class="mini-card-number">${card.getMaskedCardNumber()}</div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div>
                                            <label for="withdrawCardCvv" style="display: block; font-size: 0.8rem; font-weight: 500; color: var(--gray-700); margin-bottom: 5px;">Enter 3-Digit CVV</label>
                                            <input type="password" maxlength="3" id="withdrawCardCvv" name="cvv" placeholder="•••" class="form-control-modern" style="font-family: monospace;">
                                        </div>
                                    </div>
                                    <span style="font-size: 0.75rem; color: var(--gray-400);"><i class="bx bx-info-circle"></i> Selecting a card overrides the source account selection. Standard card limits will apply.</span>
                                </div>
                            </div>

                            <!-- Withdrawal Amount -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="withdrawAmount">Amount to Withdraw (INR)</label>
                                <input type="number" step="0.01" min="100" id="withdrawAmount" name="amount" required placeholder="Min. ₹100" class="form-control-modern">
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="withdrawDescription">Transaction Description</label>
                                <input type="text" id="withdrawDescription" name="description" placeholder="E.g., Self counter cash withdrawal" class="form-control-modern">
                            </div>

                            <button type="submit" class="btn-submit-premium">
                                <span>Process Cash Withdrawal</span>
                                <i class="bx bx-check-shield"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 2A: CARD DEPOSIT -->
                    <div id="secCardDeposit" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-credit-card-front"></i> VGB ATM Card Deposit
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=deposit" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="useCard" value="true">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Target/Link select card -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label>Select Card to Charge</label>
                                <select id="depositCardId" name="cardId" required style="display: none;">
                                    <c:forEach items="${cards}" var="card">
                                        <c:if test="${card.status eq 'active'}">
                                            <option value="${card.cardId}">
                                                ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                                <div class="card-selector-grid" id="gridDepositCard">
                                    <c:forEach items="${cards}" var="card" varStatus="vs">
                                        <c:if test="${card.status eq 'active'}">
                                            <div class="card-select-card ${vs.first ? 'active' : ''}" data-value="${card.cardId}">
                                                <div class="mini-card-brand">${card.cardProvider.toUpperCase()}</div>
                                                <div class="mini-card-type">${card.cardType.toUpperCase()}</div>
                                                <div class="mini-card-number">${card.getMaskedCardNumber()}</div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- CVV -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="depositCardCvv">Card Security Code (3-Digit CVV)</label>
                                <input type="password" maxlength="3" id="depositCardCvv" name="cvv" required placeholder="•••" class="form-control-modern" style="font-family: monospace;">
                            </div>

                            <!-- Deposit Amount -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="depositAmount">Amount to Deposit (INR)</label>
                                <input type="number" step="0.01" min="100" id="depositAmount" name="amount" required placeholder="Min. ₹100" class="form-control-modern">
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="depositDescription">Transaction Description</label>
                                <input type="text" id="depositDescription" name="description" placeholder="E.g., Self card deposit" class="form-control-modern">
                            </div>

                            <button type="submit" class="btn-submit-premium">
                                <span>Process Card Deposit</span>
                                <i class="bx bx-check-double"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 3: ADD BENEFICIARY -->
                    <div id="secAddBeneficiary" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-user-plus"></i> Register New Beneficiary
                        </h3>
                        
                        <div id="beneficiaryAlertContainer" class="glass-alert" style="display: none;">
                            <i class="bx" id="beneficiaryAlertIcon" style="font-size: 1.2rem;"></i>
                            <span id="beneficiaryAlertMessage"></span>
                        </div>

                        <form id="addBeneficiaryForm" onsubmit="event.preventDefault(); return performBeneficiaryValidation();">
                            <!-- Beneficiary Bank Type Selection -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label>Beneficiary Bank Type</label>
                                <div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--primary-500); cursor: pointer;">
                                        <input type="radio" name="benBankType" value="vgb" checked onclick="toggleBenBankType('vgb')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Vertex Galaxy Bank (VGB) Customer</span>
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--primary-500); cursor: pointer;">
                                        <input type="radio" name="benBankType" value="other" onclick="toggleBenBankType('other')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Other Bank Customer</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Account Holder Name (Only shown for Other Bank) -->
                            <div class="form-group" id="containerBenHolderName" style="margin-bottom: 20px; display: none;">
                                <label for="benHolderName">Account Holder Name (Required)</label>
                                <input type="text" id="benHolderName" placeholder="Enter recipient's full name" class="form-control-modern">
                            </div>

                            <!-- Beneficiary Account Number -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="benAccountNumber">Beneficiary Account Number</label>
                                <input type="text" id="benAccountNumber" required placeholder="Enter account number (e.g. 100087654321)" class="form-control-modern">
                            </div>

                            <!-- Beneficiary IFSC -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="benIfscCode">Branch IFSC Code</label>
                                <input type="text" id="benIfscCode" required placeholder="Enter 11-digit IFSC code (e.g. VGBK0000001)" class="form-control-modern" style="font-family: monospace;">
                            </div>

                            <!-- Nickname Reference -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="benNickName">Account Holder Name / Nickname Reference (Optional)</label>
                                <input type="text" id="benNickName" placeholder="E.g. Business Account, John Doe" class="form-control-modern">
                            </div>

                            <button type="submit" id="btnValidateBeneficiary" class="btn-verify-modern">
                                <span>Verify Account Details</span>
                                <i class="bx bx-check-double"></i>
                            </button>
                        </form>

                        <!-- Dynamically Injected Verification Result Preview Card -->
                        <div id="containerVerificationPreview" class="verification-receipt-card" style="display: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
                                <h4 style="font-size: 1.05rem; font-weight: 700; color: #047857;"><i class="bx bx-badge-check"></i> Verified Receipt</h4>
                                <i class="bx bxs-check-circle" style="color: #10b981; font-size: 1.8rem;"></i>
                            </div>
                            
                            <div class="receipt-dashed-line"></div>
                            
                            <div class="receipt-grid">
                                <div class="receipt-item">
                                    <span>Verified Account Holder</span>
                                    <strong id="previewHolderName"></strong>
                                </div>
                                <div class="receipt-item">
                                    <span>Branch Routing IFSC</span>
                                    <strong id="previewIfscCode" style="font-family: monospace;"></strong>
                                </div>
                                <div class="receipt-item">
                                    <span>Account Number</span>
                                    <strong id="previewAccountNumber" style="font-family: monospace;"></strong>
                                </div>
                                <div class="receipt-item">
                                    <span>System Account Type</span>
                                    <strong id="previewAccountType" style="text-transform: uppercase;"></strong>
                                </div>
                            </div>
                            
                            <div class="receipt-dashed-line"></div>

                            <button type="button" id="btnSaveBeneficiary" onclick="performBeneficiarySave()" class="btn-submit-premium">
                                <span>Save Beneficiary to Directory</span>
                                <i class="bx bx-save"></i>
                            </button>
                        </div>
                    </div>

                </div>

                <!-- Guidelines Card -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <div class="glass-card" style="background: rgba(99, 102, 241, 0.04); border-color: rgba(99, 102, 241, 0.15);">
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--primary-600); margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-info-circle" style="font-size: 1.25rem;"></i>
                            <span>Service Routing Limits</span>
                        </h4>
                        <ul style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.7; padding-left: 0; list-style: none; margin: 0;">
                            <li style="margin-bottom: 12px; display: flex; align-items: flex-start; gap: 8px;">
                                <i class="bx bx-subdirectory-right" style="color: var(--primary-500); font-size: 1.1rem; margin-top: 2px; flex-shrink: 0;"></i>
                                <span>Minimum counter withdrawal or transfer amount is <strong>₹100</strong>.</span>
                            </li>
                            <li style="margin-bottom: 12px; display: flex; align-items: flex-start; gap: 8px;">
                                <i class="bx bx-subdirectory-right" style="color: var(--primary-500); font-size: 1.1rem; margin-top: 2px; flex-shrink: 0;"></i>
                                <span>Saved Beneficiary routing maps accounts securely with real-time verification checks.</span>
                            </li>
                            <li style="display: flex; align-items: flex-start; gap: 8px;">
                                <i class="bx bx-subdirectory-right" style="color: var(--primary-500); font-size: 1.1rem; margin-top: 2px; flex-shrink: 0;"></i>
                                <span>Ensure beneficiary account numbers match exactly to lock dynamic ledger clearances.</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function showPortalTab(tab) {
            const tabTransfer = document.getElementById('tabBtnTransfer');
            const tabWithdraw = document.getElementById('tabBtnWithdraw');
            const tabCardDeposit = document.getElementById('tabBtnCardDeposit');
            const tabAddBeneficiary = document.getElementById('tabBtnAddBeneficiary');
            const secTransfer = document.getElementById('secTransfer');
            const secWithdraw = document.getElementById('secWithdraw');
            const secCardDeposit = document.getElementById('secCardDeposit');
            const secAddBeneficiary = document.getElementById('secAddBeneficiary');

            // Reset active classes
            tabTransfer.classList.remove('active');
            tabWithdraw.classList.remove('active');
            if (tabCardDeposit) tabCardDeposit.classList.remove('active');
            tabAddBeneficiary.classList.remove('active');
            secTransfer.classList.remove('active');
            secWithdraw.classList.remove('active');
            if (secCardDeposit) secCardDeposit.classList.remove('active');
            secAddBeneficiary.classList.remove('active');

            if (tab === 'transfer') {
                tabTransfer.classList.add('active');
                secTransfer.classList.add('active');
            } else if (tab === 'withdraw') {
                tabWithdraw.classList.add('active');
                secWithdraw.classList.add('active');
            } else if (tab === 'cardDeposit') {
                if (tabCardDeposit) tabCardDeposit.classList.add('active');
                if (secCardDeposit) secCardDeposit.classList.add('active');
            } else {
                tabAddBeneficiary.classList.add('active');
                secAddBeneficiary.classList.add('active');
            }
        }

        function toggleTransferCardFields() {
            const useCard = document.getElementById('transferUseCard').checked;
            const fieldsDiv = document.getElementById('transferCardFields');
            const cardIdSelect = document.getElementById('transferCardId');
            const cvvInput = document.getElementById('transferCardCvv');
            if (useCard) {
                fieldsDiv.style.display = 'block';
                cardIdSelect.required = true;
                cvvInput.required = true;
            } else {
                fieldsDiv.style.display = 'none';
                cardIdSelect.required = false;
                cvvInput.required = false;
            }
        }

        function toggleWithdrawCardFields() {
            const useCard = document.getElementById('withdrawUseCard').checked;
            const fieldsDiv = document.getElementById('withdrawCardFields');
            const cardIdSelect = document.getElementById('withdrawCardId');
            const cvvInput = document.getElementById('withdrawCardCvv');
            if (useCard) {
                fieldsDiv.style.display = 'block';
                cardIdSelect.required = true;
                cvvInput.required = true;
            } else {
                fieldsDiv.style.display = 'none';
                cardIdSelect.required = false;
                cvvInput.required = false;
            }
        }

        function toggleDestType(type) {
            const internalSelect = document.getElementById('toAccountIdInternal');
            const externalSelect = document.getElementById('toAccountIdExternal');
            const internalContainer = document.getElementById('containerInternalTarget');
            const externalContainer = document.getElementById('containerExternalTarget');

            if (type === 'own') {
                internalContainer.style.display = 'block';
                internalSelect.name = 'toAccountId';
                internalSelect.disabled = false;
                internalSelect.required = true;

                externalContainer.style.display = 'none';
                externalSelect.removeAttribute('name');
                externalSelect.disabled = true;
                externalSelect.required = false;
            } else {
                externalContainer.style.display = 'block';
                externalSelect.name = 'toAccountId';
                externalSelect.disabled = false;
                externalSelect.required = true;

                internalContainer.style.display = 'none';
                internalSelect.removeAttribute('name');
                internalSelect.disabled = true;
                internalSelect.required = false;
            }
        }

        function validateTransferForm(event) {
            const fromAcc = document.getElementById('transferSourceAccount').value;
            const destType = document.querySelector('input[name="destType"]:checked').value;
            
            if (destType === 'own') {
                const toAcc = document.getElementById('toAccountIdInternal').value;
                if (fromAcc === toAcc) {
                    event.preventDefault();
                    alert("Self-transfer Error: Source account and destination account cannot be the same. Please select a different destination account.");
                    return false;
                }
            }
            return true;
        }

        // Beneficiary AJAX Operations
        let verifiedAccountId = 0;

        function showBeneficiaryAlert(message, type) {
            const container = document.getElementById('beneficiaryAlertContainer');
            const icon = document.getElementById('beneficiaryAlertIcon');
            const msgSpan = document.getElementById('beneficiaryAlertMessage');

            container.style.display = 'flex';
            msgSpan.textContent = message;

            if (type === 'success') {
                container.style.background = 'rgba(16, 185, 129, 0.1)';
                container.style.borderLeft = '4px solid #10b981';
                container.style.color = '#047857';
                icon.className = 'bx bx-check-circle';
            } else {
                container.style.background = 'rgba(239, 68, 68, 0.1)';
                container.style.borderLeft = '4px solid #ef4444';
                container.style.color = '#b91c1c';
                icon.className = 'bx bx-error-circle';
            }
        }

        function hideBeneficiaryAlert() {
            document.getElementById('beneficiaryAlertContainer').style.display = 'none';
        }

        function toggleBenBankType(type) {
            const holderNameContainer = document.getElementById('containerBenHolderName');
            const holderNameInput = document.getElementById('benHolderName');
            
            if (type === 'other') {
                holderNameContainer.style.display = 'block';
                holderNameInput.required = true;
            } else {
                holderNameContainer.style.display = 'none';
                holderNameInput.required = false;
            }
        }

        function performBeneficiaryValidation() {
            const accNum = document.getElementById('benAccountNumber').value.trim();
            const ifsc = document.getElementById('benIfscCode').value.trim();
            const previewContainer = document.getElementById('containerVerificationPreview');
            const benType = document.querySelector('input[name="benBankType"]:checked').value;
            const holderName = document.getElementById('benHolderName').value.trim();

            hideBeneficiaryAlert();
            previewContainer.style.display = 'none';
            verifiedAccountId = 0;

            const btn = document.getElementById('btnValidateBeneficiary');
            btn.disabled = true;
            btn.classList.add('btn-loading');
            btn.querySelector('span').textContent = 'Validating Ledger Record...';

            let url = '${pageContext.request.contextPath}/account?action=verifyBeneficiary' + 
                      '&beneficiaryType=' + encodeURIComponent(benType) + 
                      '&accountNumber=' + encodeURIComponent(accNum) + 
                      '&ifscCode=' + encodeURIComponent(ifsc);
            
            if (benType === 'other') {
                url += '&holderName=' + encodeURIComponent(holderName);
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Verify Account Details';

                    if (data.valid) {
                        verifiedAccountId = data.accountId;
                        
                        document.getElementById('previewHolderName').textContent = data.customerName;
                        document.getElementById('previewIfscCode').textContent = data.ifscCode;
                        document.getElementById('previewAccountNumber').textContent = data.accountNumber;
                        document.getElementById('previewAccountType').textContent = data.accountType;

                        previewContainer.style.display = 'block';
                    } else {
                        showBeneficiaryAlert(data.message || 'Validation failed. No matching ledger accounts found.', 'error');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Verify Account Details';
                    showBeneficiaryAlert('Network connection error during verification: ' + error, 'error');
                });

            return false;
        }

        function performBeneficiarySave() {
            const benType = document.querySelector('input[name="benBankType"]:checked').value;
            if (benType === 'vgb' && verifiedAccountId === 0) return;

            const btn = document.getElementById('btnSaveBeneficiary');
            btn.disabled = true;
            btn.classList.add('btn-loading');
            btn.querySelector('span').textContent = 'Registering with core routing...';

            const csrfToken = '${sessionScope.csrfToken}';
            const accNum = document.getElementById('previewAccountNumber').textContent;
            const ifsc = document.getElementById('previewIfscCode').textContent;
            const holderName = document.getElementById('previewHolderName').textContent;
            const nickname = document.getElementById('benNickName').value.trim();

            let bodyParams = 'csrfToken=' + encodeURIComponent(csrfToken) + 
                             '&beneficiaryType=' + encodeURIComponent(benType) + 
                             '&beneficiaryAccountId=' + encodeURIComponent(verifiedAccountId) + 
                             '&accountNumber=' + encodeURIComponent(accNum) + 
                             '&ifscCode=' + encodeURIComponent(ifsc) + 
                             '&holderName=' + encodeURIComponent(holderName) + 
                             '&nickname=' + encodeURIComponent(nickname);

            fetch('${pageContext.request.contextPath}/account?action=saveBeneficiary', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: bodyParams
            })
                .then(response => response.json())
                .then(data => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Save Beneficiary to Directory';

                    if (data.success) {
                        showBeneficiaryAlert(data.message || 'Beneficiary saved and locked successfully.', 'success');
                        document.getElementById('containerVerificationPreview').style.display = 'none';
                        document.getElementById('addBeneficiaryForm').reset();
                        document.getElementById('containerBenHolderName').style.display = 'none';
                        verifiedAccountId = 0;
                        
                        // Dynamically refresh select box options in the background
                        refreshBeneficiaryList();
                    } else {
                        showBeneficiaryAlert(data.message || 'Failed to save beneficiary.', 'error');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Save Beneficiary to Directory';
                    showBeneficiaryAlert('Network save error: ' + error, 'error');
                });
        }

        // Visual Card Selectors Sync Logic (Global Scope)
        function setupGridSelector(gridId, selectId) {
            const grid = document.getElementById(gridId);
            const select = document.getElementById(selectId);
            if (grid && select) {
                const cards = grid.querySelectorAll('.account-select-card, .card-select-card');
                
                // Initialize hidden select with the active card's value on load
                const activeCard = grid.querySelector('.active');
                if (activeCard) {
                    select.value = activeCard.getAttribute('data-value');
                }

                cards.forEach(card => {
                    card.addEventListener('click', () => {
                        cards.forEach(c => c.classList.remove('active'));
                        card.classList.add('active');
                        select.value = card.getAttribute('data-value');
                        // Trigger change event if form controls require it
                        select.dispatchEvent(new Event('change'));
                    });
                });
            }
        }

        function refreshBeneficiaryList() {
            fetch('${pageContext.request.contextPath}/account?action=transferPage')
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    
                    const newSelect = doc.getElementById('toAccountIdExternal');
                    if (newSelect) {
                        const targetSelect = document.getElementById('toAccountIdExternal');
                        targetSelect.innerHTML = newSelect.innerHTML;
                    }
                    
                    const newGrid = doc.getElementById('gridTransferDestExternal');
                    if (newGrid) {
                        const targetGrid = document.getElementById('gridTransferDestExternal');
                        targetGrid.innerHTML = newGrid.innerHTML;
                        // Re-bind click events for the new cards
                        setupGridSelector('gridTransferDestExternal', 'toAccountIdExternal');
                    }
                })
                .catch(err => console.error('Error refreshing beneficiaries directory:', err));
        }

        document.addEventListener('DOMContentLoaded', () => {
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

            // Initialize Grid Selectors
            setupGridSelector('gridTransferSource', 'transferSourceAccount');
            setupGridSelector('gridTransferCard', 'transferCardId');
            setupGridSelector('gridTransferDest', 'toAccountIdInternal');
            setupGridSelector('gridTransferDestExternal', 'toAccountIdExternal');
            setupGridSelector('gridWithdrawSource', 'withdrawSourceAccount');
            setupGridSelector('gridWithdrawCard', 'withdrawCardId');
            setupGridSelector('gridDepositCard', 'depositCardId');
        });
    </script>
</body>
</html>
