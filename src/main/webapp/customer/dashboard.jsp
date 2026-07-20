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
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
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
        
        /* 6-slot Actions Horizontal Line Grid */
        .actions-line-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 15px;
        }
        @media (max-width: 1024px) {
            .actions-line-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        @media (max-width: 768px) {
            .actions-line-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 480px) {
            .actions-line-grid {
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

        /* VGB Luxury Card Design System */
        :root {
            --primary-luxury: #041C54;
            --secondary-luxury: #0A2D7A;
            --gold-luxury: #F4B400;
            --white-luxury: #FFFFFF;
            --bg-light-luxury: #F5F7FA;
            --text-dark-luxury: #0E214A;
        }

        .vgb-luxury-card-container {
            perspective: 2000px;
            width: 100%;
            position: relative;
            transform-style: preserve-3d;
        }

        .vgb-luxury-card {
            background: linear-gradient(135deg, var(--primary-luxury) 0%, var(--secondary-luxury) 100%);
            border-radius: 32px;
            border: 1.5px solid rgba(244, 180, 0, 0.25);
            box-shadow: 0 30px 60px rgba(4, 28, 84, 0.35),
                        0 0 40px rgba(244, 180, 0, 0.05),
                        inset 0 1px 2px rgba(255, 255, 255, 0.15);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.15s ease-out, box-shadow 0.3s ease;
            transform-style: preserve-3d;
        }

        .vgb-luxury-card.animate-float {
            animation: floatingCard 6s ease-in-out infinite;
        }

        @keyframes floatingCard {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-8px); }
            100% { transform: translateY(0px); }
        }

        .vgb-luxury-card-top {
            display: flex;
            position: relative;
            z-index: 2;
            transform-style: preserve-3d;
        }

        .vgb-luxury-card-left {
            flex: 0.65;
            padding: 35px;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 280px;
            transform: translateZ(30px);
        }

        .vgb-luxury-card-right {
            flex: 0.35;
            padding: 35px;
            background: var(--white-luxury);
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            gap: 15px;
            transform: translateZ(50px);
            border-left: 1px solid rgba(244, 180, 0, 0.15);
        }

        /* Responsive stack for tablet/mobile */
        @media (max-width: 991px) {
            .vgb-luxury-card-top {
                flex-direction: column;
            }
            .vgb-luxury-card-left, .vgb-luxury-card-right {
                flex: 1;
                min-height: auto;
            }
            .vgb-luxury-card-right {
                border-left: none;
                border-top: 1px solid rgba(244, 180, 0, 0.15);
                padding: 30px;
            }
        }

        /* Glass Glare & Reflections */
        .vgb-luxury-glare {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at var(--x, 50%) var(--y, 50%), rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0) 65%);
            mix-blend-mode: overlay;
            pointer-events: none;
            z-index: 10;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .vgb-luxury-card:hover .vgb-luxury-glare {
            opacity: 1;
        }

        /* Header elements */
        .vgb-luxury-logo-area {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .vgb-luxury-logo {
            width: 32px;
            height: 34px;
            object-fit: contain;
            filter: drop-shadow(0 0 10px rgba(244, 180, 0, 0.4));
        }
        .vgb-luxury-brand {
            display: flex;
            flex-direction: column;
        }
        .vgb-luxury-bank-name {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--white-luxury);
            letter-spacing: 0.5px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        .vgb-luxury-tagline {
            font-size: 0.55rem;
            color: var(--gold-luxury);
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-top: 2px;
        }

        /* Separator lines */
        .vgb-luxury-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(244, 180, 0, 0.3), transparent);
            margin: 20px 0;
            width: 100%;
        }

        /* Balance & account labels */
        .vgb-luxury-label {
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
        }
        .vgb-luxury-balance-wrapper {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .vgb-luxury-balance {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--white-luxury);
            text-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
        }
        .vgb-luxury-account-wrapper {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 15px;
        }
        .vgb-luxury-account-number {
            font-family: 'Courier New', monospace;
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--white-luxury);
            letter-spacing: 3px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
        }

        /* Toggle eye buttons */
        .vgb-luxury-toggle-btn {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: rgba(255, 255, 255, 0.9);
            cursor: pointer;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            transform: translateZ(20px);
            border-radius: 50%;
        }
        .vgb-luxury-toggle-btn:hover {
            background: rgba(244, 180, 0, 0.15);
            border-color: var(--gold-luxury);
            color: var(--gold-luxury);
            box-shadow: 0 0 10px rgba(244, 180, 0, 0.3);
            transform: translateZ(25px) scale(1.1);
        }

        /* Profile details on right */
        .vgb-luxury-profile-wrapper {
            position: relative;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            padding: 4px;
            background: linear-gradient(45deg, #ffd700, #ff8f00, #ffd700);
            background-size: 200% auto;
            animation: goldBorderShine 4s linear infinite;
            box-shadow: 0 10px 25px rgba(244, 180, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .vgb-luxury-profile-wrapper:hover {
            transform: scale(1.08) rotate(5deg);
        }
        @keyframes goldBorderShine {
            0% { background-position: 0% center; }
            50% { background-position: 100% center; }
            100% { background-position: 0% center; }
        }
        .vgb-luxury-profile-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            background: white;
            border: 2px solid white;
        }
        .vgb-luxury-customer-name {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--text-dark-luxury);
            letter-spacing: 0.5px;
            margin-top: 5px;
        }
        .vgb-luxury-holder-title {
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--gold-luxury);
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        /* Bottom Info Bar */
        .vgb-luxury-card-bottom {
            background: rgba(4, 28, 84, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-top: 1.5px solid rgba(244, 180, 0, 0.25);
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            padding: 25px 35px;
            position: relative;
            z-index: 2;
            transform: translateZ(40px);
        }

        @media (max-width: 991px) {
            .vgb-luxury-card-bottom {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .vgb-luxury-card-bottom {
                grid-template-columns: 1fr;
            }
        }

        .vgb-luxury-info-item {
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            position: relative;
        }

        .vgb-luxury-info-item i {
            font-size: 1.25rem;
            color: var(--gold-luxury);
            background: rgba(244, 180, 0, 0.1);
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(244, 180, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .vgb-luxury-info-item:hover i {
            transform: scale(1.15) rotate(10deg);
        }
        .vgb-luxury-info-text {
            display: flex;
            flex-direction: column;
        }
        .vgb-luxury-info-title {
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 500;
        }
        .vgb-luxury-info-value {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--white-luxury);
            margin-top: 1px;
        }

        /* Dividers for grid items */
        @media (min-width: 992px) {
            .vgb-luxury-info-item:not(:nth-child(4n))::after {
                content: '';
                position: absolute;
                right: -10px;
                top: 15%;
                bottom: 15%;
                width: 1px;
                background: linear-gradient(to bottom, transparent, var(--gold-luxury), transparent);
                opacity: 0.4;
            }
        }
        @media (min-width: 577px) and (max-width: 991px) {
            .vgb-luxury-info-item:not(:nth-child(2n))::after {
                content: '';
                position: absolute;
                right: -10px;
                top: 15%;
                bottom: 15%;
                width: 1px;
                background: linear-gradient(to bottom, transparent, var(--gold-luxury), transparent);
                opacity: 0.4;
            }
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
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
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
            <a href="${pageContext.request.contextPath}/card-repayment?action=history"><i class="bx bx-receipt"></i> Card Repayments</a>
            <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard"><i class="bx bx-sync"></i> Auto Pay</a>
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

            <!-- Top Row: Full Width Luxury Card -->
            <div style="margin-bottom: 30px;">
                <div class="vgb-luxury-card-container">
                    <div class="vgb-luxury-card animate-float">
                        <!-- Glare Layer -->
                        <div class="vgb-luxury-glare"></div>

                        <!-- Top Section -->
                        <div class="vgb-luxury-card-top">
                            <!-- Left Section (65%) -->
                            <div class="vgb-luxury-card-left">
                                <!-- Connection Constellation SVG Background -->
                                <svg class="world-map-svg" viewBox="0 0 400 250" style="position: absolute; right: 0; top: 0; width: 100%; height: 100%; opacity: 0.12; pointer-events: none; z-index: 1;">
                                    <!-- Connection lines -->
                                    <path d="M 30,150 Q 130,50 230,180 T 360,60" fill="none" stroke="#F4B400" stroke-width="1.2" stroke-dasharray="4,4" />
                                    <path d="M 60,80 Q 180,200 300,90" fill="none" stroke="#FFFFFF" stroke-width="0.8" stroke-dasharray="3,3" />
                                    <!-- Nodes -->
                                    <circle cx="30" cy="150" r="3.5" fill="#F4B400" />
                                    <circle cx="130" cy="98" r="2.5" fill="#FFFFFF" />
                                    <circle cx="230" cy="180" r="4.5" fill="#F4B400" />
                                    <circle cx="300" cy="90" r="3.5" fill="#FFFFFF" />
                                    <circle cx="360" cy="60" r="2.5" fill="#F4B400" />
                                </svg>

                                <!-- Header Area -->
                                <div class="vgb-luxury-logo-area">
                                    <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" class="vgb-luxury-logo">
                                    <div class="vgb-luxury-brand">
                                        <span class="vgb-luxury-bank-name">Vertex Galaxy Bank</span>
                                        <span class="vgb-luxury-tagline">Trust &bull; Innovate &bull; Prosper</span>
                                    </div>
                                </div>

                                <div class="vgb-luxury-divider"></div>

                                <!-- Balance Details -->
                                <div>
                                    <span class="vgb-luxury-label">Available Balance</span>
                                    <div class="vgb-luxury-balance-wrapper">
                                        <span class="vgb-luxury-balance" id="cardBalanceDisplay" 
                                              data-full="₹ <fmt:formatNumber value='${activeBalance}' minFractionDigits='2' maxFractionDigits='2'/>" 
                                              data-masked="₹ &bull;&bull;&bull;&bull;&bull;">
                                            ₹ <fmt:formatNumber value="${activeBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                        <button type="button" onclick="toggleBalanceVisibility()" class="vgb-luxury-toggle-btn" id="eyeBalanceBtn" title="Show/Hide Balance">
                                            <i class="bx bx-show" id="eyeBalanceIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Account Number Details -->
                                <div>
                                    <span class="vgb-luxury-label">Account Number</span>
                                    <div class="vgb-luxury-account-wrapper">
                                        <span class="vgb-luxury-account-number" id="cardNumberDisplay" 
                                              data-full="${not empty activeAccount ? activeAccount.accountNumber : '000000000000'}" 
                                              data-masked="${not empty activeAccount ? '••••  ••••  ••••  '.concat(activeAccount.accountNumber.substring(activeAccount.accountNumber.length() - 4)) : '••••  ••••  ••••  0000'}">
                                            ${not empty activeAccount ? activeAccount.accountNumber : '000000000000'}
                                        </span>
                                        <button type="button" onclick="toggleCardNumberVisibility()" class="vgb-luxury-toggle-btn" id="eyeIconBtn" title="Show/Hide Account Number">
                                            <i class="bx bx-show" id="eyeIcon"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Section (35%) -->
                            <div class="vgb-luxury-card-right">
                                <!-- Subtle Shield Icon Overlay -->
                                <i class="bx bxs-shield-alt-2" style="position: absolute; top: 20px; right: 20px; font-size: 1.8rem; color: rgba(244, 180, 0, 0.15);"></i>
                                
                                <!-- Profile Wrapper with gold shining border -->
                                <div class="vgb-luxury-profile-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty customer && not empty customer.avatarPath}">
                                            <img src="${pageContext.request.contextPath}${customer.avatarPath}" alt="Customer Profile Avatar" class="vgb-luxury-profile-img">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="width: 100%; height: 100%; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 2rem; border: 2px solid white; text-transform: uppercase;">
                                                ${not empty customer ? customer.fullName.substring(0, 1) : 'V'}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="margin-top: 15px; text-align: center;">
                                    <h4 class="vgb-luxury-customer-name" style="margin: 0; margin-bottom: 4px;">${not empty customer ? customer.fullName : 'VGB CUSTOMER'}</h4>
                                    <span class="vgb-luxury-holder-title">Premium Member</span>
                                </div>
                            </div>
                        </div>

                        <!-- Bottom Information Bar -->
                        <div class="vgb-luxury-card-bottom">
                            <!-- 1. DOB -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-calendar"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">Date of Birth</span>
                                    <span class="vgb-luxury-info-value">${not empty birthDate ? birthDate : '08/08/2002'}</span>
                                </div>
                            </div>
                            <!-- 2. Account Type -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-wallet"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">Account Type</span>
                                    <span class="vgb-luxury-info-value" style="text-transform: capitalize;">${not empty activeAccount ? activeAccount.accountType : 'Savings'}</span>
                                </div>
                            </div>
                            <!-- 3. Branch Name -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-map-pin"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">Branch Name</span>
                                    <span class="vgb-luxury-info-value">Mumbai Main Branch</span>
                                </div>
                            </div>
                            <!-- 4. Customer Since -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-time-five"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">Customer Since</span>
                                    <span class="vgb-luxury-info-value">
                                        <c:choose>
                                            <c:when test="${not empty customer && not empty customer.createdAt}">
                                                2026
                                            </c:when>
                                            <c:otherwise>
                                                2026
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <!-- 5. Customer ID -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-user-badge"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">Customer ID</span>
                                    <span class="vgb-luxury-info-value">${not empty customer ? customer.customerId : '000000'}</span>
                                </div>
                            </div>
                            <!-- 6. IFSC Code -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-building"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">IFSC Code</span>
                                    <span class="vgb-luxury-info-value">${not empty activeAccount ? activeAccount.ifscCode : 'VGBK0000101'}</span>
                                </div>
                            </div>
                            <!-- 7. Account Status -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-check-shield"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">Account Status</span>
                                    <span class="vgb-luxury-info-value" style="text-transform: capitalize;">${not empty activeAccount ? activeAccount.status : 'Active'}</span>
                                </div>
                            </div>
                            <!-- 8. KYC Status -->
                            <div class="vgb-luxury-info-item">
                                <i class="bx bx-shield-quarter"></i>
                                <div class="vgb-luxury-info-text">
                                    <span class="vgb-luxury-info-title">KYC Status</span>
                                    <span class="vgb-luxury-info-value" style="text-transform: capitalize;">
                                        <c:choose>
                                            <c:when test="${not empty customer.status && customer.status == 'active'}">
                                                Verified
                                            </c:when>
                                            <c:otherwise>
                                                Verified
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Fast Actions Panel (Full Width Horizontal) -->
            <div class="glass-actions-panel" style="margin-bottom: 40px; width: 100%;">
                <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-bolt-circle" style="color: var(--primary-500); font-size: 1.3rem;"></i>
                    <span>Quick Portal Actions</span>
                </h4>
                <div class="actions-line-grid">
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
                                <th style="text-align: center;">Action</th>
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
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${acc.accountId == activeAccount.accountId}">
                                                        <span class="badge-status badge-active" style="background: rgba(16, 185, 129, 0.15); color: #10b981; padding: 4px 8px; border-radius: 4px;"><i class="bx bx-radio-circle-marked"></i> Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/account?action=switch&accountId=${acc.accountId}" class="btn btn-primary" style="padding: 4px 10px; font-size: 0.75rem; border-radius: 4px; display: inline-flex; align-items: center; gap: 4px; text-decoration: none;"><i class="bx bx-sync"></i> Switch</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="padding: 0;">
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
                // Format full number with credit card spacing
                const formattedFull = fullNumber.replace(/(\d{4})(?=\d)/g, '$1  ');
                displayEl.setAttribute('data-full', formattedFull);
                displayEl.textContent = formattedFull;
            }

            // Interactive 3D Luxury Card Tilt & Glare script
            const cardContainer = document.querySelector('.vgb-luxury-card-container');
            const card = document.querySelector('.vgb-luxury-card');
            if (cardContainer && card) {
                cardContainer.addEventListener('mousemove', (e) => {
                    // Temporarily remove float animation to avoid fighting transforms
                    card.classList.remove('animate-float');
                    
                    const rect = cardContainer.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;

                    const centerX = rect.width / 2;
                    const centerY = rect.height / 2;

                    // Calculate rotation angles (max 10 degrees)
                    const rotX = -((y - centerY) / centerY) * 10;
                    const rotY = ((x - centerX) / centerX) * 10;

                    card.style.transform = `rotateX(${rotX}deg) rotateY(${rotY}deg) translateY(-5px) scale(1.02)`;

                    // Set custom property positions for glare positioning
                    card.style.setProperty('--x', `${(x / rect.width) * 100}%`);
                    card.style.setProperty('--y', `${(y / rect.height) * 100}%`);
                });

                cardContainer.addEventListener('mouseleave', () => {
                    // Smooth transition back to neutral state
                    card.style.transform = 'rotateX(0deg) rotateY(0deg) translateY(0) scale(1)';
                    card.style.setProperty('--x', '50%');
                    card.style.setProperty('--y', '50%');
                    
                    // Re-enable float animation after transition
                    setTimeout(() => {
                        card.classList.add('animate-float');
                    }, 150);
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
                    iconEl.className = 'bx bx-show';
                } else {
                    displayEl.textContent = maskedNumber;
                    iconEl.className = 'bx bx-hide';
                }
            }
        }

        function toggleBalanceVisibility() {
            const displayEl = document.getElementById('cardBalanceDisplay');
            const iconEl = document.getElementById('eyeBalanceIcon');
            if (displayEl && iconEl) {
                const fullVal = displayEl.getAttribute('data-full');
                const maskedVal = displayEl.getAttribute('data-masked');
                
                const currentText = displayEl.textContent.trim();
                const isMasked = (currentText === maskedVal.trim());
                
                if (isMasked) {
                    displayEl.textContent = fullVal;
                    iconEl.className = 'bx bx-show';
                } else {
                    displayEl.textContent = maskedVal;
                    iconEl.className = 'bx bx-hide';
                }
            }
        }
    </script>
</body>
</html>
