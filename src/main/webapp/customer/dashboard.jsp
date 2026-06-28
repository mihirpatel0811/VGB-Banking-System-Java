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
    <title>VGB | Customer Dashboard</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
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
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
        }
        .stat-card-gradient {
            background: var(--gradient-secondary);
            color: white;
            border-radius: var(--radius-lg);
            padding: 25px;
            box-shadow: var(--shadow-lg);
        }

        /* Glass Actions Panel styling */
        .glass-actions-panel {
            background: rgba(255, 255, 255, 0.45) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border: 1px solid rgba(255, 255, 255, 0.65) !important;
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.8) !important;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s ease;
        }

        .glass-actions-panel:hover {
            border-color: rgba(99, 102, 241, 0.25) !important;
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.05), inset 0 0 2px 1px rgba(255, 255, 255, 0.8) !important;
        }

        /* 6-slot Actions Grid */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }
        @media (max-width: 768px) {
            .actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 480px) {
            .actions-grid {
                grid-template-columns: 1fr;
            }
        }
        .action-tile {
            background: rgba(255, 255, 255, 0.45) !important;
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-md) !important;
            padding: 20px 10px !important;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.01) !important;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
            text-decoration: none;
            height: 100%;
        }
        .action-tile:hover {
            transform: translateY(-5px) scale(1.02);
            background: white !important;
            border-color: rgba(99, 102, 241, 0.3) !important;
            box-shadow: 0 12px 25px rgba(99, 102, 241, 0.08) !important;
        }
        .action-tile i {
            font-size: 1.8rem;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            box-shadow: inset 0 2px 4px rgba(255, 255, 255, 0.2);
        }
        .action-tile:hover i {
            transform: scale(1.1) rotate(8deg);
        }
        .tile-purple i { background: rgba(99, 102, 241, 0.08) !important; color: var(--primary-500); }
        .tile-pink i { background: rgba(236, 72, 153, 0.08) !important; color: var(--secondary-500); }
        .tile-cyan i { background: rgba(6, 182, 212, 0.08) !important; color: var(--accent-cyan); }
        .tile-teal i { background: rgba(20, 184, 166, 0.08) !important; color: var(--accent-teal); }
        .tile-emerald i { background: rgba(16, 185, 129, 0.08) !important; color: var(--accent-emerald); }
        .tile-amber i { background: rgba(245, 158, 11, 0.08) !important; color: var(--accent-amber); }

        .action-title {
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        .action-desc {
            font-size: 0.72rem;
            color: var(--gray-400);
            line-height: 1.3;
        }

        /* ATM Card styling modifications */
        .vgb-premium-atm-card-container {
            perspective: 1500px;
            width: 100%;
            height: 100%;
        }
        .vgb-premium-atm-card {
            background: linear-gradient(135deg, #09061c 0%, #030209 100%) !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            border-radius: 24px !important;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5), 
                        0 0 35px rgba(99, 102, 241, 0.15),
                        inset 0 1px 1px rgba(255, 255, 255, 0.15) !important;
            padding: 32px !important;
            color: white !important;
            position: relative !important;
            overflow: hidden !important;
            height: 100% !important;
            display: flex !important;
            flex-direction: column !important;
            justify-content: space-between !important;
            transition: transform 0.15s ease-out, box-shadow 0.3s ease, border-color 0.3s ease !important;
            transform-style: preserve-3d !important;
        }
        .vgb-premium-atm-card::after {
            content: '';
            position: absolute;
            top: -150%;
            left: -150%;
            width: 300%;
            height: 300%;
            background: linear-gradient(
                45deg,
                transparent 45%,
                rgba(255, 255, 255, 0.05) 48%,
                rgba(255, 255, 255, 0.12) 50%,
                rgba(255, 255, 255, 0.05) 52%,
                transparent 55%
            );
            transform: rotate(-15deg);
            transition: transform 0.6s ease;
            z-index: 5;
            pointer-events: none;
        }
        .vgb-premium-atm-card:hover::after {
            transform: rotate(-15deg) translate(30%, 30%);
        }
        .vgb-premium-atm-card:hover {
            box-shadow: 0 35px 70px rgba(0, 0, 0, 0.6), 
                        0 0 50px rgba(168, 85, 247, 0.3),
                        inset 0 1px 1px rgba(255, 255, 255, 0.25) !important;
            border-color: rgba(168, 85, 247, 0.35) !important;
        }
        .vgb-premium-atm-card > *:not(.card-bg-waves) {
            transform: translateZ(40px);
            transform-style: preserve-3d;
            position: relative;
            z-index: 2;
        }
        .vgb-premium-atm-card .card-bg-waves {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
            transform: translateZ(0px);
        }
        .vgb-premium-atm-card .card-glare {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at var(--x, 50%) var(--y, 50%), rgba(255, 255, 255, 0.25) 0%, rgba(255, 255, 255, 0) 65%);
            mix-blend-mode: overlay;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 10;
            transform: translateZ(0px);
        }
        .vgb-premium-atm-card:hover .card-glare {
            opacity: 1;
        }
        .vgb-premium-atm-card .card-divider {
            margin: 15px 0;
            border-top: 1px solid rgba(139, 92, 246, 0.2);
            box-shadow: 0 1px 8px rgba(139, 92, 246, 0.25);
            opacity: 0.7;
            transform: translateZ(20px);
        }
        @keyframes goldShimmer {
            0% { background-position: -200% center; }
            100% { background-position: 200% center; }
        }
        .premium-shimmer {
            font-size: 1.15rem;
            font-weight: 900;
            font-family: 'Poppins', sans-serif;
            font-style: italic;
            letter-spacing: 0.5px;
            background: linear-gradient(90deg, #ffd700 0%, #ffe082 25%, #ffb300 50%, #ffe082 75%, #ffd700 100%);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: goldShimmer 4s linear infinite;
            text-shadow: 0 2px 10px rgba(255, 215, 0, 0.15);
        }

        /* Modern Tables & Badges */
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
            padding: 14px 18px;
            color: var(--gray-500);
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.75px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
            white-space: nowrap;
        }
        td {
            padding: 16px 18px;
            font-size: 0.875rem;
            color: var(--gray-700);
            border-bottom: 1px solid rgba(99, 102, 241, 0.05);
            vertical-align: middle;
            white-space: nowrap;
        }
        tr {
            transition: background 0.2s ease;
        }
        tr:hover td {
            background: rgba(99, 102, 241, 0.01);
        }
        .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--accent-emerald);
        }
        .badge-pending {
            background: rgba(245, 158, 11, 0.1);
            color: var(--accent-amber);
        }
        .badge-loan-active {
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary-500);
        }
        .badge-id {
            font-family: monospace;
            font-weight: 600;
            background: rgba(99, 102, 241, 0.05);
            color: var(--primary-600);
            padding: 3px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: var(--gray-400);
        }
        .empty-state svg {
            width: 60px;
            height: 60px;
            margin-bottom: 15px;
            color: var(--gray-300);
        }
        .empty-state p {
            font-size: 0.88rem;
            font-weight: 500;
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
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="active"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
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
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Digital Banking Dashboard</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Manage your premium VGB assets, transfer funds instantly, and review open loan lines.</p>
                </div>
                <div style="background: white; padding: 10px 20px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); display: flex; align-items: center; gap: 10px; box-shadow: var(--shadow-sm);">
                    <i class="bx bx-calendar-check" style="font-size: 1.5rem; color: var(--primary-500);"></i>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">System Time</span>
                        <strong style="font-size: 0.9rem; color: var(--gray-700);" id="liveSystemTime">May 23, 2026</strong>
                    </div>
                </div>
            </div>

            <!-- Dynamic PIN Welcome Alert Banner -->
            <c:if test="${not empty customer}">
            <div class="glass-card" style="margin-bottom: 40px; border-left: 4px solid var(--primary-500); background: rgba(99, 102, 241, 0.03); display: flex; align-items: center; gap: 20px; padding: 20px;">
                <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(99, 102, 241, 0.1); color: var(--primary-500); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0;">
                    <i class="bx bx-shield-quarter"></i>
                </div>
                <div>
                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 4px;">Welcome to Vertex Galaxy Bank! Secure PIN Active</h4>
                    <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.5;">Your administrative account approval is complete. Your secure 4-digit Banking PIN is <strong style="color: var(--primary-600); font-family: monospace; font-size: 1rem; letter-spacing: 0.5px;">${customer.pin}</strong>. You can use this PIN for quick authentication and authorization.</p>
                </div>
            </div>
            </c:if>

            <!-- Top Row Stat Cards -->
            <div style="display: grid; grid-template-columns: 1.6fr 1.4fr; gap: 30px; margin-bottom: 40px; align-items: stretch;" class="mobile-grid-1">
                <!-- VGB Credit Card Rendering + Total Balance -->
                <div class="vgb-premium-atm-card-container">
                    <div class="vgb-premium-atm-card">
                        <!-- Glare Layer -->
                        <div class="card-glare"></div>

                        <!-- 3D Vector Wave and Dot Grid Background -->
                        <svg class="card-bg-waves" viewBox="0 0 400 250" preserveAspectRatio="none">
                            <defs>
                                <radialGradient id="bgGrad" cx="20%" cy="20%" r="90%">
                                    <stop offset="0%" stop-color="#140f35"/>
                                    <stop offset="60%" stop-color="#070417"/>
                                    <stop offset="100%" stop-color="#020106"/>
                                </radialGradient>
                                
                                <linearGradient id="wavePurple" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" stop-color="#a855f7" stop-opacity="0.6"/>
                                    <stop offset="50%" stop-color="#6366f1" stop-opacity="0.3"/>
                                    <stop offset="100%" stop-color="#ec4899" stop-opacity="0"/>
                                </linearGradient>

                                <linearGradient id="waveMagenta" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" stop-color="#db2777" stop-opacity="0.5"/>
                                    <stop offset="70%" stop-color="#7c3aed" stop-opacity="0.15"/>
                                    <stop offset="100%" stop-color="#000000" stop-opacity="0"/>
                                </linearGradient>

                                <pattern id="dotGrid" x="0" y="0" width="12" height="12" patternUnits="userSpaceOnUse">
                                    <circle cx="2" cy="2" r="0.75" fill="#a855f7" fill-opacity="0.25"/>
                                </pattern>
                            </defs>
                            
                            <rect width="100%" height="100%" fill="url(#bgGrad)"/>
                            <rect width="100%" height="100%" fill="url(#dotGrid)"/>

                            <path d="M-50,260 C80,260 180,180 260,110 C340,40 380,0 450,-50 L450,260 Z" fill="url(#wavePurple)"/>
                            <path d="M-50,260 C120,240 220,130 310,70 C370,30 400,-10 450,-50" fill="none" stroke="url(#waveMagenta)" stroke-width="2.5" opacity="0.65"/>
                            <path d="M-20,270 C100,270 200,210 280,150 C360,90 410,30 450,-20" fill="none" stroke="#db2777" stroke-width="1.5" opacity="0.4"/>
                            <path d="M50,280 C180,250 250,180 340,110 C400,60 430,20 470,-10" fill="none" stroke="#a855f7" stroke-width="1.2" opacity="0.3"/>
                        </svg>
                        
                        <!-- Card Header -->
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 24px; height: 26px; object-fit: contain; filter: drop-shadow(0 0 8px rgba(168,85,247,0.5));">
                                <span style="font-weight: 700; letter-spacing: 0.5px; font-size: 0.95rem; color: white; text-shadow: 0 1px 4px rgba(0,0,0,0.4);">Vertex Galaxy Bank</span>
                            </div>
                            
                            <!-- Detailed Golden EMV Chip -->
                            <svg width="48" height="38" viewBox="0 0 48 38" style="border-radius: 8px; box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.35), 0 4px 12px rgba(0, 0, 0, 0.45); border: 1px solid rgba(255, 255, 255, 0.15); flex-shrink: 0;">
                                <defs>
                                    <linearGradient id="chipBg" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#fff4cc" />
                                        <stop offset="25%" stop-color="#ffd54f" />
                                        <stop offset="50%" stop-color="#ffb300" />
                                        <stop offset="85%" stop-color="#ff8f00" />
                                        <stop offset="100%" stop-color="#b36200" />
                                    </linearGradient>
                                </defs>
                                <rect width="100%" height="100%" fill="url(#chipBg)" />
                                <rect x="4" y="4" width="40" height="30" rx="4" fill="none" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <line x1="16" y1="4" x2="16" y2="34" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <line x1="32" y1="4" x2="32" y2="34" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <line x1="4" y1="14" x2="44" y2="14" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <line x1="4" y1="24" x2="44" y2="24" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <circle cx="24" cy="19" r="5" fill="none" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <path d="M 20 19 L 4 19" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                                <path d="M 28 19 L 44 19" stroke="rgba(0, 0, 0, 0.25)" stroke-width="0.75" />
                            </svg>
                        </div>

                        <!-- Balance & Card Number -->
                        <div style="margin-top: 15px;">
                            <span style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 1.5px; opacity: 0.75; color: rgba(165, 180, 252, 0.75); font-weight: 600;">Total Net Balance</span>
                            <h3 style="font-size: 2.6rem; font-weight: 800; color: white; margin-top: 2px; text-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);">₹ <fmt:formatNumber value="${totalBalance}" minFractionDigits="2" maxFractionDigits="2"/></h3>
                            
                            <!-- Masked/Full Account Number -->
                            <div style="display: flex; align-items: center; gap: 12px; margin-top: 20px;">
                                <span id="cardNumberDisplay" data-full="${not empty accounts ? accounts[0].accountNumber : '000000000000'}" style="font-family: 'Courier New', monospace; font-size: 1.45rem; letter-spacing: 3px; font-weight: 700; color: white; text-shadow: 0 2px 5px rgba(0,0,0,0.4); opacity: 0.95;">
                                    ••••  ••••  ••••  0000
                                </span>
                                <button type="button" onclick="toggleCardNumberVisibility()" style="background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.15); color: rgba(255, 255, 255, 0.9); cursor: pointer; border-radius: 50%; width: 34px; height: 34px; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1rem; transition: all 0.3s ease; z-index: 999; transform: translateZ(50px);" id="eyeIconBtn" title="Show/Hide Account Number">
                                    <i class="bx bx-show" id="eyeIcon"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Glowing Separator Line -->
                        <div class="card-divider"></div>

                        <!-- Card Footer -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                            <div style="display: flex; gap: 40px;">
                                <div>
                                    <span style="display: block; font-size: 0.6rem; color: rgba(160, 174, 192, 0.7); text-transform: uppercase; letter-spacing: 1px; font-weight: 500; margin-bottom: 2px;">Card Holder</span>
                                    <span style="font-size: 0.9rem; font-weight: 700; text-transform: uppercase; color: white; letter-spacing: 1px; text-shadow: 0 1px 3px rgba(0,0,0,0.3);">${not empty customer ? customer.fullName : 'VGB CUSTOMER'}</span>
                                </div>
                                <div>
                                    <span style="display: block; font-size: 0.6rem; color: rgba(160, 174, 192, 0.7); text-transform: uppercase; letter-spacing: 1px; font-weight: 500; margin-bottom: 2px;">Birth Date</span>
                                    <span style="font-size: 0.95rem; font-weight: 700; color: white; letter-spacing: 0.5px; text-shadow: 0 1px 3px rgba(0,0,0,0.3);">${not empty birthDate ? birthDate : '08/08/2002'}</span>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <span class="premium-shimmer">PREMIUM</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Fast Actions Panel -->
                <div class="glass-actions-panel">
                    <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                        <i class="bx bx-bolt-circle" style="color: var(--primary-500); font-size: 1.3rem;"></i>
                        <span>Quick Portal Actions</span>
                    </h4>
                    <div class="actions-grid">
                        <a href="${pageContext.request.contextPath}/account?action=transferPage" class="action-tile tile-purple">
                            <i class="bx bx-send"></i>
                            <span class="action-title">Send Money</span>
                            <span class="action-desc">Instant IMPS/NEFT</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/loan?action=list" class="action-tile tile-pink">
                            <i class="bx bx-building-house"></i>
                            <span class="action-title">Apply Loan</span>
                            <span class="action-desc">Low interest limits</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/card?action=list" class="action-tile tile-cyan">
                            <i class="bx bx-credit-card"></i>
                            <span class="action-title">My Cards</span>
                            <span class="action-desc">Limits &amp; status</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/chequebook?action=list" class="action-tile tile-teal">
                            <i class="bx bx-book-bookmark"></i>
                            <span class="action-title">Cheque Books</span>
                            <span class="action-desc">Request &amp; tracking</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/passbook?action=list" class="action-tile tile-emerald">
                            <i class="bx bx-book-open"></i>
                            <span class="action-title">Passbook</span>
                            <span class="action-desc">Update logs</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/account?action=statement" class="action-tile tile-amber">
                            <i class="bx bx-file"></i>
                            <span class="action-title">Statements</span>
                            <span class="action-desc">Download statements</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- List of Customer Accounts -->
            <div class="glass-card" style="margin-bottom: 40px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; flex-wrap: wrap; gap: 10px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-wallet"></i> Linked Financial Accounts</h3>
                    <a href="${pageContext.request.contextPath}/account?action=list" class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.8rem;"><i class="bx bx-receipt"></i> View Detailed Ledger</a>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Account Type</th>
                                <th>Account Number</th>
                                <th>IFSC Code</th>
                                <th>Status</th>
                                <th style="text-align: right;">Current Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}">
                                        <tr>
                                            <td style="font-weight: 600; text-transform: capitalize;">
                                                <i class="bx bx-circle" style="color: var(--primary-500); margin-right: 5px;"></i> ${acc.accountType}
                                            </td>
                                            <td><span class="badge-id">${acc.accountNumber}</span></td>
                                            <td style="font-family: monospace; font-weight: 500;">${acc.ifscCode}</td>
                                            <td>
                                                <span class="badge-status badge-active"><i class="bx bx-check-shield"></i> ${acc.status}</span>
                                            </td>
                                            <td style="text-align: right; font-weight: 700; color: var(--gray-900); font-size: 0.95rem;">₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="padding: 0;">
                                            <div class="empty-state">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                                    <rect x="2" y="5" width="20" height="14" rx="2" />
                                                    <line x1="2" y1="10" x2="22" y2="10" />
                                                </svg>
                                                <p>No active bank accounts linked yet.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Active Loans Panel -->
            <div class="glass-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; flex-wrap: wrap; gap: 10px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-building-house"></i> Active Loans Overview</h3>
                    <a href="${pageContext.request.contextPath}/loan?action=list" class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.8rem;"><i class="bx bx-credit-card-front"></i> Repay / View All</a>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Loan ID</th>
                                <th>Loan Type</th>
                                <th>Principal Amount</th>
                                <th>Remaining Balance</th>
                                <th>Interest Rate</th>
                                <th style="text-align: right;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty activeLoans}">
                                    <c:forEach var="loan" items="${activeLoans}">
                                        <tr>
                                            <td><span class="badge-id">#LN-${loan.loanId}</span></td>
                                            <td style="text-transform: capitalize; font-weight: 600;">${loan.loanType} Loan</td>
                                            <td style="font-weight: 600; color: var(--gray-800);">₹ <fmt:formatNumber value="${loan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="font-weight: 700; color: #ef4444;">₹ <fmt:formatNumber value="${loan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="font-weight: 500; color: var(--gray-500);">${loan.interestRate}% P.A.</td>
                                            <td style="text-align: right;">
                                                <span class="badge-status badge-loan-active"><i class="bx bx-time-five"></i> ${loan.status}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="padding: 0;">
                                            <div class="empty-state">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                                    <path d="M3 21h18M3 10h18M5 6h14M4 10v11M20 10v11M8 14v3M12 14v3M16 14v3" />
                                                </svg>
                                                <p>No active loans registered in database.</p>
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
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved. Secured by RBI.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const displayEl = document.getElementById('cardNumberDisplay');
            if (displayEl) {
                const fullNumber = displayEl.getAttribute('data-full');
                const last4 = fullNumber.slice(-4);
                displayEl.setAttribute('data-masked', `••••  ••••  ••••  ${last4}`);
                displayEl.textContent = `••••  ••••  ••••  ${last4}`;
            }

            // Interactive 3D ATM Card Tilt & Glare script
            const cardContainer = document.querySelector('.vgb-premium-atm-card-container');
            const card = document.querySelector('.vgb-premium-atm-card');
            if (cardContainer && card) {
                cardContainer.addEventListener('mousemove', (e) => {
                    const rect = cardContainer.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;

                    const centerX = rect.width / 2;
                    const centerY = rect.height / 2;

                    // Calculate rotation angles (max 15 degrees)
                    const rotX = -((y - centerY) / centerY) * 15;
                    const rotY = ((x - centerX) / centerX) * 15;

                    card.style.transform = `rotateX(${rotX}deg) rotateY(${rotY}deg) translateY(-8px) scale(1.02)`;

                    // Set custom property positions for glare positioning
                    card.style.setProperty('--x', `${(x / rect.width) * 100}%`);
                    card.style.setProperty('--y', `${(y / rect.height) * 100}%`);
                });

                cardContainer.addEventListener('mouseleave', () => {
                    // Smooth transition back to neutral state
                    card.style.transform = 'rotateX(0deg) rotateY(0deg) translateY(0) scale(1)';
                    card.style.setProperty('--x', '50%');
                    card.style.setProperty('--y', '50%');
                });
            }

            // Dynamic live time update
            function updateLiveTime() {
                const timeEl = document.getElementById('liveSystemTime');
                if (timeEl) {
                    const now = new Date();
                    const options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
                    timeEl.textContent = now.toLocaleDateString('en-US', options);
                }
            }
            setInterval(updateLiveTime, 1000);
            updateLiveTime();

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
        });

        function toggleCardNumberVisibility() {
            const displayEl = document.getElementById('cardNumberDisplay');
            const iconEl = document.getElementById('eyeIcon');
            if (displayEl && iconEl) {
                const fullNumber = displayEl.getAttribute('data-full');
                const maskedNumber = displayEl.getAttribute('data-masked');
                
                const currentText = displayEl.textContent.trim();
                const isMasked = (currentText === maskedNumber.trim());
                
                if (isMasked) {
                    displayEl.textContent = fullNumber;
                    iconEl.className = 'bx bx-hide';
                } else {
                    displayEl.textContent = maskedNumber;
                    iconEl.className = 'bx bx-show';
                }
            }
        }
    </script>
</body>
</html>
