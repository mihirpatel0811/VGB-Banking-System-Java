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
    <title>
        <c:choose>
            <c:when test="${subView == 'receipt'}">VGB | Repayment Receipt</c:when>
            <c:when test="${subView == 'history'}">VGB | Repayment History</c:when>
            <c:otherwise>VGB | Credit Card Repayment</c:otherwise>
        </c:choose>
    </title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
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
            transition: all 0.3s ease;
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
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .sidebar-menu a:hover {
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500) !important;
            transform: translateX(4px);
        }
        .sidebar-menu a.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
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
        @media (max-width: 991px) {
            .sidebar { left: -280px !important; }
            .sidebar.active { left: 0 !important; }
            .main-content { margin-left: 0 !important; padding: 120px 20px 40px !important; }
            .footer { margin-left: 0 !important; }
        }

        /* Redesigned Glass Cards */
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
        }

        /* 3D Glassmorphic Card Mockup */
        .card-mockup {
            border-radius: var(--radius-lg);
            padding: 28px;
            color: white;
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 45px rgba(15, 23, 42, 0.15), inset 0 1px 0 rgba(255, 255, 255, 0.2);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.4s ease;
            height: 220px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .card-mockup:hover {
            transform: translateY(-8px) rotateX(4deg) rotateY(-4deg);
            box-shadow: 0 30px 60px rgba(99, 102, 241, 0.25), inset 0 1px 0 rgba(255, 255, 255, 0.3);
        }
        .card-mockup::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.15) 0%, transparent 60%);
            z-index: 1;
            pointer-events: none;
        }
        
        /* Metallic Tiers */
        .tier-classic {
            background: linear-gradient(135deg, #4b5563 0%, #1f2937 100%);
            border: 1px solid rgba(156, 163, 175, 0.25);
        }
        .tier-classic::after {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.05) 0%, transparent 60%);
            pointer-events: none;
        }
        
        .tier-gold {
            background: linear-gradient(135deg, #ca8a04 0%, #78350f 50%, #451a03 100%);
            border: 1px solid rgba(251, 191, 36, 0.3);
        }
        .tier-gold::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(75deg, transparent 40%, rgba(251, 191, 36, 0.15) 50%, transparent 60%);
            animation: gold-shine 6s infinite linear;
            pointer-events: none;
        }
        
        .tier-platinum {
            background: linear-gradient(135deg, #475569 0%, #1e293b 100%);
            border: 1px solid rgba(148, 163, 184, 0.3);
        }
        .tier-platinum::after {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.08) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.05) 0%, transparent 50%);
            pointer-events: none;
        }
        
        .tier-royale {
            background: linear-gradient(135deg, #1e1b4b 0%, #4c1d95 50%, #030712 100%);
            border: 1px solid rgba(139, 92, 246, 0.4);
            box-shadow: 0 0 25px rgba(139, 92, 246, 0.25), inset 0 1px 1px rgba(255, 255, 255, 0.2);
        }
        .tier-royale::after {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 50% 50%, rgba(236, 72, 153, 0.1) 0%, transparent 80%);
            pointer-events: none;
        }

        @keyframes gold-shine {
            0% { transform: translateX(-150%) skewX(-30deg); }
            50%, 100% { transform: translateX(150%) skewX(-30deg); }
        }

        .card-chip {
            width: 45px;
            height: 32px;
            background: linear-gradient(135deg, #fbbf24 0%, #d97706 100%);
            border-radius: 6px;
            position: relative;
            box-shadow: inset 0 1px 1px rgba(255,255,255,0.4), 0 2px 4px rgba(0,0,0,0.15);
        }
        .card-chip::after {
            content: '';
            position: absolute;
            top: 6px; left: 6px; right: 6px; bottom: 6px;
            border: 1px solid rgba(0,0,0,0.12);
            border-radius: 4px;
        }

        /* Segmented Button Selection */
        .segmented-control {
            display: flex;
            background: rgba(99, 102, 241, 0.03);
            border: 1px solid rgba(99, 102, 241, 0.08);
            padding: 8px;
            border-radius: var(--radius-lg);
            gap: 8px;
            margin-bottom: 25px;
        }
        .segmented-option {
            flex: 1;
            text-align: center;
            padding: 16px 12px;
            border-radius: var(--radius-md);
            cursor: pointer;
            background: transparent;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid transparent;
            user-select: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 4px;
        }
        .segmented-option .opt-title {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray-400);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .segmented-option .opt-value {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--gray-700);
            margin: 2px 0;
        }
        .segmented-option .opt-desc {
            font-size: 0.65rem;
            color: var(--gray-400);
            font-weight: 500;
        }
        .segmented-option.active {
            background: var(--white);
            color: var(--primary-500);
            box-shadow: var(--shadow-lg);
            border-color: rgba(99, 102, 241, 0.12);
            transform: translateY(-2px);
        }
        .segmented-option.active .opt-title {
            color: var(--primary-500);
        }
        .segmented-option.active .opt-value {
            color: var(--primary-600);
        }
        .segmented-option.active .opt-desc {
            color: var(--primary-400);
        }
        .segmented-option:hover:not(.active) {
            background: rgba(99, 102, 241, 0.04);
            transform: translateY(-1px);
        }

        /* Confirmation Dialog Styles with Backdrop Blur */
        .overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .overlay.show {
            opacity: 1;
        }
        .confirm-dialog {
            width: 100%;
            max-width: 500px;
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.12);
            padding: 35px;
            transform: scale(0.9);
            transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .overlay.show .confirm-dialog {
            transform: scale(1);
        }
        
        .confirm-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--gray-100);
            font-size: 0.95rem;
        }
        .confirm-row:last-child {
            border-bottom: none;
        }
        .confirm-label {
            color: var(--gray-500);
            font-weight: 500;
        }
        .confirm-value {
            color: var(--gray-800);
            font-weight: 700;
        }
        .confirm-value.highlight {
            color: var(--primary-500);
        }

        /* Status Badge Pill */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 6px 12px;
            border-radius: var(--radius-full);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status-pill.completed {
            background: rgba(16, 185, 129, 0.08);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.15);
        }
        .pulse-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: currentColor;
            display: inline-block;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(0.9); opacity: 0.6; }
            50% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(0.9); opacity: 0.6; }
        }

        /* Custom Table Styling */
        .vgb-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .vgb-table th {
            padding: 18px 24px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--gray-400);
            border-bottom: 1px solid var(--gray-100);
            letter-spacing: 0.75px;
        }
        .vgb-table td {
            padding: 20px 24px;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--gray-50);
            color: var(--gray-700);
            transition: background-color 0.2s ease;
            white-space: nowrap;
            vertical-align: middle;
        }
        .vgb-table tr:hover td {
            background-color: rgba(99, 102, 241, 0.015);
        }
        .vgb-table tr:last-child td {
            border-bottom: none;
        }

        .btn-outline-sm {
            border: 1px solid var(--gray-200);
            background: var(--white);
            color: var(--primary-500);
            padding: 6px 14px;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s ease;
        }
        .btn-outline-sm:hover {
            border-color: var(--primary-400);
            background: rgba(99, 102, 241, 0.03);
            color: var(--primary-600);
        }

        /* Premium Security Certificate Invoice Receipt */
        .receipt-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            border: 1px solid var(--gray-200);
            padding: 40px;
            box-shadow: var(--shadow-xl);
            max-width: 600px;
            margin: 0 auto 30px;
            position: relative;
            overflow: hidden;
        }
        .receipt-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 6px;
            background: var(--gradient-primary);
        }
        .receipt-header {
            text-align: center;
            border-bottom: 2px dashed var(--gray-200);
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        .receipt-logo {
            width: 65px;
            height: 65px;
            object-fit: contain;
            margin-bottom: 12px;
        }
        .receipt-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(16, 185, 129, 0.08);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #10b981;
            padding: 8px 18px;
            border-radius: var(--radius-full);
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 15px;
            box-shadow: 0 4px 10px rgba(16, 185, 129, 0.05);
        }
        .receipt-row {
            display: flex;
            justify-content: space-between;
            padding: 14px 0;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--gray-100);
        }
        .receipt-row:last-of-type {
            border-bottom: none;
        }
        .receipt-label {
            color: var(--gray-400);
            font-weight: 500;
        }
        .receipt-value {
            color: var(--gray-800);
            font-weight: 600;
            text-align: right;
        }
        .receipt-total {
            background: rgba(99, 102, 241, 0.03);
            border: 1px solid rgba(99, 102, 241, 0.06);
            border-radius: var(--radius-md);
            padding: 18px 24px;
            margin: 25px 0 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .tear-off-divider {
            height: 2px;
            border-bottom: 2px dashed var(--gray-200);
            margin: 20px 0;
            position: relative;
        }
        .tear-off-divider::before, .tear-off-divider::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            background: var(--gray-50);
            border-radius: 50%;
            top: -9px;
            box-shadow: inset 0 0 2px rgba(0,0,0,0.1);
        }
        .tear-off-divider::before {
            left: -48px;
        }
        .tear-off-divider::after {
            right: -48px;
        }

        /* Animated checkmark styles */
        .success-animation { margin: 25px auto 10px; }
        .checkmark {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: block;
            stroke-width: 2;
            stroke: #fff;
            stroke-miterlimit: 10;
            box-shadow: inset 0px 0px 0px #10b981;
            animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s forwards;
            margin: 0 auto;
        }
        .checkmark__circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 2;
            stroke-miterlimit: 10;
            stroke: #10b981;
            fill: none;
            animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }
        .checkmark__check {
            transform-origin: 50% 50%;
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.8s forwards;
        }
        @keyframes stroke {
            100% { stroke-dashoffset: 0; }
        }
        @keyframes scale {
            0%, 100% { transform: none; }
            50% { transform: scale3d(1.1, 1.1, 1); }
        }
        @keyframes fill {
            100% { box-shadow: inset 0px 0px 0px 30px #10b981; }
        }

        /* Form Control Improvements */
        .form-control {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            font-size: 0.95rem;
            color: var(--gray-800);
            width: 100%;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
            outline: none;
        }

        /* Paginator */
        .paginator-container {
            display: flex;
            justify-content: center;
            gap: 8px;
            padding: 25px;
            border-top: 1px solid var(--gray-100);
        }
        .paginator-btn {
            padding: 8px 16px;
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-600);
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            transition: all 0.2s ease;
        }
        .paginator-btn:hover {
            background: var(--gray-100);
            color: var(--primary-500);
            border-color: var(--gray-300);
        }
        .paginator-btn.active {
            background: var(--gradient-primary);
            color: var(--white);
            border-color: transparent;
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.2);
        }

        /* Empty State */
        .empty-state-container {
            text-align: center;
            padding: 60px 40px;
        }
        .empty-state-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(99, 102, 241, 0.04);
            color: var(--primary-500);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 20px;
            border: 1px solid rgba(99, 102, 241, 0.08);
        }
        .empty-state-container h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-800);
            margin: 0 0 8px;
        }
        .empty-state-container p {
            color: var(--gray-400);
            font-size: 0.9rem;
            max-width: 420px;
            margin: 0 auto 24px;
            line-height: 1.6;
        }

        /* Toast Styles */
        .toast-container {
            position: fixed;
            top: 24px;
            right: 24px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 12px;
            max-width: 380px;
            width: 100%;
        }
        .toast-card {
            background: var(--white);
            border-left: 4px solid var(--primary-500);
            box-shadow: var(--shadow-xl);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            transform: translateX(120%);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.3s ease;
            opacity: 0;
        }
        .toast-card.show {
            transform: translateX(0);
            opacity: 1;
        }
        .toast-card.error {
            border-left-color: #ef4444;
        }
        .toast-icon {
            font-size: 1.4rem;
            color: var(--primary-500);
        }
        .toast-card.error .toast-icon {
            color: #ef4444;
        }
        .toast-card span {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-700);
        }

        /* Print background */
        .print-bg-container {
            display: none;
        }

        /* Print Media Styles */
        @media print {
            @page {
                size: A4 portrait;
                margin: 0;
            }
            body {
                background: white !important;
                color: black !important;
                margin: 0 !important;
                padding: 0 !important;
            }
            .header, .sidebar, .footer, .btn-print-actions, .mobile-nav-toggle, .no-print {
                display: none !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
                min-height: auto !important;
            }
            .receipt-card {
                position: static !important;
                border: none !important;
                box-shadow: none !important;
                padding: 160px 60px 100px 60px !important;
                margin: 0 !important;
                width: 100% !important;
                box-sizing: border-box !important;
                background: transparent !important;
            }
            .print-bg-container {
                display: block !important;
                position: fixed !important;
                left: 0 !important;
                top: 0 !important;
                width: 210mm !important;
                height: 297mm !important;
                z-index: -10 !important;
                pointer-events: none !important;
            }
            .print-bg-img {
                width: 100% !important;
                height: 100% !important;
                object-fit: fill !important;
            }
        }
    </style>
</head>
<body class="bank-home-page">
    <div class="toast-container" id="toastContainer"></div>

    <!-- Header -->
    <header class="header scrolled">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" style="background: none; border: none; font-size: 1.8rem; cursor: pointer; color: var(--gray-700);">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty customer && not empty customer.avatarPath}">
                        <img src="${pageContext.request.contextPath}${customer.avatarPath}" alt="Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                            ${not empty customer.firstName ? customer.firstName.substring(0, 1) : "C"}
                        </div>
                    </c:otherwise>
                </c:choose>
                <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                    <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">
                        ${customer.firstName} ${customer.lastName}
                    </span>
                    <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Customer Space
                    </span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout" style="text-decoration: none;">
                <i class="bx bx-log-out"></i>
                <span>Logout</span>
            </a>
        </div>
    </header>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list" class="${subView == 'repay' ? 'active' : ''}"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=history" class="${subView != 'repay' ? 'active' : ''}"><i class="bx bx-receipt"></i> Card Repayments</a>
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
        <div class="container" style="max-width: 1000px; padding: 0;">

            <!-- ================= REPAY FORM VIEW ================= -->
            <c:if test="${subView == 'repay'}">
                <div class="no-print" style="margin-bottom: 30px;">
                    <a href="${pageContext.request.contextPath}/card?action=list" style="text-decoration: none; color: var(--primary-500); font-weight: 600; display: inline-flex; align-items: center; gap: 5px; margin-bottom: 15px;">
                        <i class="bx bx-left-arrow-alt" style="font-size: 1.2rem;"></i> Back to My Cards
                    </a>
                    <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900); margin: 0;">Credit Card Bill Repayment</h1>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Clear your card dues instantly and securely using your active savings or current account.</p>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: start;" class="mobile-grid-1">
                    
                    <!-- Left: Bill Summary Panel -->
                    <div>
                        <div class="glass-card" style="margin-bottom: 0;">
                            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin: 0 0 20px;">
                                <i class="bx bx-file-find" style="color: var(--primary-500); margin-right: 5px;"></i> Bill Statement Summary
                            </h3>

                            <!-- Dynamic Tier Class Definition -->
                            <c:set var="tierClass" value="tier-platinum" />
                            <c:if test="${card.cardTier == 'classic'}"><c:set var="tierClass" value="tier-classic" /></c:if>
                            <c:if test="${card.cardTier == 'gold'}"><c:set var="tierClass" value="tier-gold" /></c:if>
                            <c:if test="${card.cardTier == 'platinum'}"><c:set var="tierClass" value="tier-platinum" /></c:if>
                            <c:if test="${card.cardTier == 'royale'}"><c:set var="tierClass" value="tier-royale" /></c:if>

                            <!-- Glassmorphic Card Mockup -->
                            <div class="card-mockup ${tierClass}">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; z-index: 2;">
                                    <div>
                                        <p style="font-size: 0.65rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.7; font-weight: 600; margin: 0;">VGB Credit Card</p>
                                        <p style="font-size: 0.95rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin: 2px 0 0;">${card.cardTier} Tier</p>
                                    </div>
                                    <span style="font-size: 1.6rem; font-weight: 800; font-family: 'Poppins'; text-transform: uppercase; font-style: italic; color: #fbbf24;">VGB</span>
                                </div>
                                <div style="display: flex; align-items: center; justify-content: space-between; z-index: 2;">
                                    <p style="font-family: 'Share Tech Mono', monospace; font-size: 1.45rem; letter-spacing: 2px; margin: 0;">${card.getMaskedCardNumber()}</p>
                                    <div class="card-chip"></div>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: flex-end; z-index: 2;">
                                    <div>
                                        <p style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.6; margin: 0;">Card Holder</p>
                                        <p style="font-size: 0.85rem; font-weight: 600; margin: 2px 0 0;">${card.cardHolderName}</p>
                                    </div>
                                    <div>
                                        <p style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.6; text-align: right; margin: 0;">Expiry</p>
                                        <p style="font-size: 0.85rem; font-weight: 600; margin: 2px 0 0; text-align: right;"><fmt:formatDate value="${card.expiryDate}" pattern="MM/yy" /></p>
                                    </div>
                                </div>
                            </div>

                            <!-- Dynamic limit utilization percentage -->
                            <c:set var="utilPercent" value="${card.onlineLimit > 0 ? (card.outstandingBalance * 100 / card.onlineLimit) : 0}" />

                            <!-- Limit Utilization Visualizer -->
                            <div style="margin-bottom: 25px; background: rgba(99, 102, 241, 0.02); border: 1px solid rgba(99, 102, 241, 0.05); padding: 18px; border-radius: var(--radius-md);">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                    <span style="font-size: 0.8rem; font-weight: 600; color: var(--gray-500);">Credit Limit Utilization</span>
                                    <span style="font-size: 0.8rem; font-weight: 700; color: var(--primary-500);"><fmt:formatNumber value="${utilPercent}" pattern="0.0" />%</span>
                                </div>
                                <div style="height: 8px; width: 100%; background: var(--gray-200); border-radius: var(--radius-full); overflow: hidden; position: relative;">
                                    <div style="height: 100%; width: ${utilPercent}%; background: var(--gradient-primary); border-radius: var(--radius-full); transition: width 1s ease;"></div>
                                </div>
                                <div style="display: flex; justify-content: space-between; margin-top: 8px; font-size: 0.75rem; font-weight: 500; color: var(--gray-400);">
                                    <span>Used: ₹<fmt:formatNumber value="${card.outstandingBalance}" pattern="#,##,##0.00" /></span>
                                    <span>Limit: ₹<fmt:formatNumber value="${card.onlineLimit}" pattern="#,##,##0.00" /></span>
                                </div>
                            </div>

                            <!-- Statement Metrics Grid -->
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Billing Cycle</span>
                                    <p style="font-size: 0.9rem; font-weight: 700; color: var(--gray-700); margin: 4px 0 0;">${billingCycle}</p>
                                </div>
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Statement Date</span>
                                    <p style="font-size: 0.9rem; font-weight: 700; color: var(--gray-700); margin: 4px 0 0;">${statementDate}</p>
                                </div>
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Payment Due Date</span>
                                    <p style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); margin: 4px 0 0;">${dueDate}</p>
                                </div>
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Payment Status</span>
                                    <c:choose>
                                        <c:when test="${card.outstandingBalance > 0}">
                                            <p style="font-size: 0.9rem; font-weight: 700; color: #ef4444; margin: 4px 0 0; display: flex; align-items: center; gap: 4px;">
                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: #ef4444; display: inline-block;"></span> Dues Outstanding
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="font-size: 0.9rem; font-weight: 700; color: #10b981; margin: 4px 0 0; display: flex; align-items: center; gap: 4px;">
                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: #10b981; display: inline-block;"></span> All Dues Paid
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Card Limits Detail -->
                            <div style="border-top: 1px solid var(--gray-100); margin-top: 25px; padding-top: 20px; display: flex; justify-content: space-between;">
                                <div>
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Total Credit Limit</span>
                                    <p style="font-size: 1.15rem; font-weight: 800; color: var(--gray-800); margin: 2px 0 0;">₹<fmt:formatNumber value="${card.onlineLimit}" pattern="#,##,##0.00" /></p>
                                </div>
                                <div style="text-align: right;">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Available Credit</span>
                                    <p style="font-size: 1.15rem; font-weight: 800; color: #10b981; margin: 2px 0 0;">₹<fmt:formatNumber value="${availableLimit}" pattern="#,##,##0.00" /></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Payment Execution Panel -->
                    <div>
                        <div class="glass-card" style="margin-bottom: 0;">
                            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin: 0 0 20px;">
                                <i class="bx bx-credit-card-front" style="color: var(--primary-500); margin-right: 5px;"></i> Repayment Workspace
                            </h3>

                            <form id="repayForm" method="post" action="${pageContext.request.contextPath}/card-repayment">
                                <input type="hidden" name="action" value="repay">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="cardId" value="${card.cardId}">

                                <!-- Source Account Selection -->
                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label style="display: block; font-weight: 600; font-size: 0.85rem; color: var(--gray-700); margin-bottom: 8px;">Select Source Bank Account</label>
                                    <div style="position: relative;">
                                        <select class="form-control" name="accountId" id="accountId" style="padding-left: 45px; font-weight: 600; appearance: none; -webkit-appearance: none;" required>
                                            <option value="" disabled selected>-- Select savings or current account --</option>
                                            <c:forEach var="acc" items="${accounts}">
                                                <option value="${acc.accountId}" data-balance="${acc.balance}" data-number="${acc.accountNumber}">
                                                    VGB ${acc.accountType.toUpperCase()} - •••• ${acc.accountNumber.substring(acc.accountNumber.length() - 4)} (Bal: ₹<fmt:formatNumber value="${acc.balance}" pattern="#,##,##0.00" />)
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <i class="bx bx-wallet" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); font-size: 1.2rem; color: var(--gray-400); pointer-events: none;"></i>
                                        <i class="bx bx-chevron-down" style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); font-size: 1.2rem; color: var(--gray-400); pointer-events: none;"></i>
                                    </div>
                                    
                                    <!-- Dynamic Account details display -->
                                    <div id="selectedAccountCard" style="display: none; margin-top: 15px; padding: 15px 20px; border-radius: var(--radius-md); border: 1px dashed rgba(99, 102, 241, 0.2); background: rgba(99, 102, 241, 0.02); justify-content: space-between; align-items: center; transition: all 0.3s ease;">
                                        <div>
                                            <span style="font-size: 0.7rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Debiting Bank Balance</span>
                                            <h4 style="font-size: 1.15rem; font-weight: 800; color: var(--accent-emerald); margin: 2px 0 0;" id="selectedAccBalance">₹ 0.00</h4>
                                        </div>
                                        <div style="text-align: right;">
                                            <span style="font-size: 0.75rem; font-weight: 700; color: var(--gray-700); display: block;" id="selectedAccType">Savings Account</span>
                                            <span style="font-size: 0.75rem; font-family: 'Share Tech Mono', monospace; color: var(--gray-400);" id="selectedAccNo">•••• 0000</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Payment Option (Segmented Controls) -->
                                <label style="display: block; font-weight: 600; font-size: 0.85rem; color: var(--gray-700); margin-bottom: 8px;">Payment Option</label>
                                <div class="segmented-control" id="optionControl">
                                    <input type="hidden" name="paymentOption" id="paymentOption" value="full">
                                    <div class="segmented-option" data-value="minimum" id="optMin">
                                        <div class="opt-title">Min Due</div>
                                        <div class="opt-value">₹<fmt:formatNumber value="${minimumDue}" pattern="#,##,##0.00" /></div>
                                        <div class="opt-desc">Keep account active</div>
                                    </div>
                                    <div class="segmented-option active" data-value="full" id="optFull">
                                        <div class="opt-title">Outstanding</div>
                                        <div class="opt-value">₹<fmt:formatNumber value="${card.outstandingBalance}" pattern="#,##,##0.00" /></div>
                                        <div class="opt-desc">Avoid interest charges</div>
                                    </div>
                                    <div class="segmented-option" data-value="custom" id="optCustom">
                                        <div class="opt-title">Custom</div>
                                        <div class="opt-value"><i class="bx bx-edit-alt"></i> Enter</div>
                                        <div class="opt-desc">Clear partial dues</div>
                                    </div>
                                </div>

                                <!-- Amount Details -->
                                <div class="form-group" style="margin-bottom: 25px;" id="customAmountGroup">
                                    <label style="display: block; font-weight: 600; font-size: 0.85rem; color: var(--gray-700); margin-bottom: 8px;">Repayment Amount</label>
                                    <div style="position: relative;">
                                        <input type="number" class="form-control" name="amount" id="amount" step="0.01" style="padding-left: 50px; font-weight: 800; font-size: 1.25rem; height: 52px;" placeholder="0.00" value="${card.outstandingBalance}">
                                        <span style="position: absolute; left: 18px; top: 50%; transform: translateY(-50%); font-size: 1.4rem; font-weight: 700; color: var(--gray-400);">₹</span>
                                    </div>
                                    <small id="amountHelp" style="color: var(--gray-400); font-weight: 500; margin-top: 10px; display: block; line-height: 1.5; font-size: 0.8rem; padding-left: 4px;"></small>
                                </div>

                                <button type="button" class="btn btn-primary w-100" id="btnSubmitPayment" style="padding: 14px 20px; font-weight: 700; border-radius: var(--radius-md); box-shadow: var(--shadow-glow);" ${card.outstandingBalance <= 0 ? 'disabled' : ''}>
                                    <i class="bx bx-check-shield" style="font-size: 1.15rem; margin-right: 5px;"></i> Proceed to Payment
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Overlay Confirmation Dialog -->
                <div class="overlay" id="confirmOverlay">
                    <div class="confirm-dialog">
                        <div style="text-align: center; margin-bottom: 20px;">
                            <div style="width: 56px; height: 56px; border-radius: 50%; background: rgba(99, 102, 241, 0.08); color: var(--primary-500); display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 12px; border: 1px solid rgba(99, 102, 241, 0.15);">
                                <i class="bx bx-lock-alt"></i>
                            </div>
                            <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--gray-900); margin: 0 0 5px;">Confirm Payment</h3>
                            <p style="color: var(--gray-400); font-size: 0.85rem; margin: 0;">Please review the card repayment details before completing the secure transaction.</p>
                        </div>

                        <div style="background: var(--gray-50); border: 1px solid var(--gray-100); border-radius: var(--radius-md); padding: 10px 20px; margin-bottom: 25px;">
                            <div class="confirm-row">
                                <span class="confirm-label">Credit Card</span>
                                <span class="confirm-value" id="lblCard">${card.getMaskedCardNumber()}</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Debiting Account</span>
                                <span class="confirm-value" id="lblAccount">--</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Repayment Amount</span>
                                <span class="confirm-value highlight" id="lblAmount">₹0.00</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Projected Card Dues</span>
                                <span class="confirm-value" id="lblRemainingDues">₹0.00</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Remaining Bank Balance</span>
                                <span class="confirm-value" id="lblRemainingAccountBalance">₹0.00</span>
                            </div>
                        </div>

                        <div style="display: flex; gap: 15px;">
                            <button type="button" class="btn btn-secondary" id="btnCancelPayment" style="flex: 1; padding: 12px 20px; font-weight: 600; border-radius: var(--radius-md);">Cancel</button>
                            <button type="button" class="btn btn-primary" id="btnConfirmPayment" style="flex: 1; padding: 12px 20px; font-weight: 700; background: var(--accent-emerald); border-color: var(--accent-emerald); border-radius: var(--radius-md);">Confirm & Pay</button>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- ================= REPAYMENT RECEIPT VIEW ================= -->
            <c:if test="${subView == 'receipt'}">
                <!-- Print Background Image (Always visible in print layout) -->
                <div class="print-bg-container">
                    <img src="${pageContext.request.contextPath}/assest/images/All Forms/Letter Pad.png" class="print-bg-img" alt="VGB Letterhead">
                </div>
                <!-- Receipt Card -->
                <div class="receipt-card">
                    <div class="receipt-header">
                        <img class="receipt-logo" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo">
                        <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--gray-800); margin: 5px 0 0;">VERTEX GALAXY BANK</h2>
                        <p style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; margin-top: 3px; letter-spacing: 1px;">SECURE CARD PAYMENT RECEIPT</p>
                        
                        <!-- Animated Success Tick -->
                        <div class="success-animation">
                            <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
                                <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>
                                <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
                            </svg>
                        </div>
                        
                        <div class="receipt-status">
                            <i class="bx bx-shield-check" style="font-size: 1.1rem;"></i> Payment Success
                        </div>
                    </div>

                    <div class="receipt-details">
                        <div class="receipt-row">
                            <span class="receipt-label">Transaction Reference ID</span>
                            <span class="receipt-value" style="font-family: 'Share Tech Mono', monospace; font-size: 1.05rem; color: var(--primary-500); font-weight: 700;">${repayment.transactionReference}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Payment Date & Time</span>
                            <span class="receipt-value"><fmt:formatDate value="${repayment.repaymentDate}" pattern="dd MMM yyyy, hh:mm:ss a" /></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Card Holder Name</span>
                            <span class="receipt-value" style="text-transform: uppercase;">${repayment.cardHolderName}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Credit Card Number</span>
                            <span class="receipt-value" style="font-family: 'Share Tech Mono', monospace; font-size: 0.95rem; letter-spacing: 0.5px;">${repayment.getMaskedCardNumber()}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Debited Bank Account</span>
                            <span class="receipt-value" style="font-family: 'Share Tech Mono', monospace; font-size: 0.95rem;">${repayment.getSourceAccountNumber()}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Remaining Card Dues</span>
                            <span class="receipt-value" style="color: var(--gray-700); font-weight: 700;">₹<fmt:formatNumber value="${card.outstandingBalance}" pattern="#,##,##0.00" /></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Available Credit Limit</span>
                            <span class="receipt-value" style="color: var(--accent-emerald); font-weight: 700;">₹<fmt:formatNumber value="${card.onlineLimit - card.outstandingBalance}" pattern="#,##,##0.00" /></span>
                        </div>

                        <!-- Tear-off Separator -->
                        <div class="tear-off-divider"></div>

                        <div class="receipt-total">
                            <span style="font-weight: 600; color: var(--gray-500); font-size: 0.95rem;">Repayment Amount</span>
                            <span style="font-size: 1.6rem; font-weight: 800; color: var(--primary-500);">₹<fmt:formatNumber value="${repayment.amountPaid}" pattern="#,##,##0.00" /></span>
                        </div>

                        <div style="text-align: center; color: var(--gray-400); font-size: 0.75rem; margin-top: 20px; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 4px;">
                            <i class="bx bx-lock-alt" style="font-size: 0.9rem;"></i> This is a secure computer-generated receipt.
                        </div>
                    </div>
                </div>

                <!-- Print Actions -->
                <div class="btn-print-actions" style="max-width: 600px; margin: 0 auto; display: flex; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/card?action=list" class="btn btn-secondary" style="flex: 1; padding: 14px 20px; font-weight: 600; text-align: center; text-decoration: none; border-radius: var(--radius-md);">
                        Go to Cards
                    </a>
                    <button type="button" class="btn btn-primary" onclick="window.print();" style="flex: 1; padding: 14px 20px; font-weight: 700; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-radius: var(--radius-md);">
                        <i class="bx bx-printer" style="font-size: 1.2rem;"></i> Print Receipt / PDF
                    </button>
                    <a href="${pageContext.request.contextPath}/card-repayment?action=history" class="btn btn-secondary" style="flex: 1; padding: 14px 20px; font-weight: 600; text-align: center; text-decoration: none; color: var(--primary-500) !important; border-radius: var(--radius-md);">
                        View History
                    </a>
                </div>
            </c:if>

            <!-- ================= REPAYMENT HISTORY VIEW ================= -->
            <c:if test="${subView == 'history'}">
                <div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;" class="mobile-grid-1">
                    <div>
                        <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900); margin: 0;">Repayment History</h1>
                        <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Track your past credit card repayments, download transaction vouchers, and audit statement logs.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/card?action=list" class="btn btn-secondary" style="text-decoration: none; padding: 12px 20px; display: inline-flex; align-items: center; gap: 6px; font-weight: 600; border-radius: var(--radius-md);">
                        <i class="bx bx-credit-card"></i> Card Console
                    </a>
                </div>

                <!-- List Card -->
                <div class="glass-card" style="padding: 0; overflow: hidden; border-radius: var(--radius-lg);">
                    <c:choose>
                        <c:when test="${not empty repayments}">
                            <div style="overflow-x: auto;">
                                <table class="vgb-table">
                                    <thead>
                                        <tr>
                                            <th>Date & Time</th>
                                            <th>Card Number</th>
                                            <th>Source A/C</th>
                                            <th>Method</th>
                                            <th>Reference ID</th>
                                            <th>Status</th>
                                            <th style="text-align: right;">Amount Paid</th>
                                            <th style="text-align: center;">Voucher</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${repayments}">
                                            <tr>
                                                <td style="font-weight: 500;"><fmt:formatDate value="${r.repaymentDate}" pattern="dd MMM yyyy, hh:mm a" /></td>
                                                <td style="font-family: 'Share Tech Mono', monospace; font-size: 0.95rem; letter-spacing: 0.5px;">${r.getMaskedCardNumber()}</td>
                                                <td style="font-weight: 500;">${r.getSourceAccountNumber()}</td>
                                                <td style="text-transform: capitalize; font-weight: 600; font-size: 0.8rem; color: var(--gray-500);">${r.paymentOption}</td>
                                                <td style="font-family: 'Share Tech Mono', monospace; font-size: 0.95rem; color: var(--primary-500);">${r.transactionReference}</td>
                                                <td>
                                                    <span class="status-pill completed">
                                                        <span class="pulse-dot"></span>
                                                        ${r.status}
                                                    </span>
                                                </td>
                                                <td style="text-align: right; font-weight: 700; color: var(--gray-800);">
                                                    ₹<fmt:formatNumber value="${r.amountPaid}" pattern="#,##,##0.00" />
                                                </td>
                                                <td style="text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/card-repayment?action=receipt&reference=${r.transactionReference}" class="btn btn-outline-sm" style="text-decoration: none;">
                                                        <i class="bx bx-receipt"></i> View
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination Links -->
                            <c:if test="${totalPages > 1}">
                                <div class="no-print paginator-container">
                                    <c:if test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/card-repayment?action=history&page=${currentPage - 1}" class="paginator-btn">&laquo; Prev</a>
                                    </c:if>
                                    
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="${pageContext.request.contextPath}/card-repayment?action=history&page=${i}" class="paginator-btn ${i == currentPage ? 'active' : ''}">
                                            ${i}
                                        </a>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/card-repayment?action=history&page=${currentPage + 1}" class="paginator-btn">Next &raquo;</a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state-container">
                                <div class="empty-state-icon">
                                    <i class="bx bx-receipt"></i>
                                </div>
                                <h3>No Repayment Logs</h3>
                                <p>You haven't made any credit card repayments yet. Dues will show up here as soon as payments are processed.</p>
                                <a href="${pageContext.request.contextPath}/card?action=list" class="btn btn-primary" style="text-decoration: none; padding: 12px 24px; font-weight: 600; display: inline-block; border-radius: var(--radius-md);">Pay Credit Card Bill</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div style="max-width: 1000px; margin: 0 auto; text-align: center;">
            <p style="font-size: 0.85rem; color: var(--gray-400); font-weight: 500; margin: 0;">&copy; 2026 Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Mobile Nav toggle (Universal)
        const sidebar = document.querySelector('.sidebar');
        const mobileToggle = document.getElementById('mobileNavToggle');
        if (mobileToggle && sidebar) {
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
            });
        }
    </script>

    <!-- ================= SCRIPTS FOR REPAY FORM ================= -->
    <c:if test="${subView == 'repay'}">
        <script>
            const cardOutstanding = parseFloat("${card.outstandingBalance}");
            const cardMinimum = parseFloat("${minimumDue}");

            // Segmented Control click handlers
            const options = document.querySelectorAll('.segmented-option');
            const hiddenOptionInput = document.getElementById('paymentOption');
            const amountInput = document.getElementById('amount');
            const customAmountGroup = document.getElementById('customAmountGroup');
            const amountHelp = document.getElementById('amountHelp');
            const accountSelect = document.getElementById('accountId');

            // Initial setup
            setPaymentSelection('full');

            options.forEach(opt => {
                opt.addEventListener('click', function() {
                    options.forEach(o => o.classList.remove('active'));
                    this.classList.add('active');
                    const val = this.getAttribute('data-value');
                    setPaymentSelection(val);
                });
            });

            function setPaymentSelection(val) {
                hiddenOptionInput.value = val;
                if (val === 'minimum') {
                    amountInput.value = cardMinimum.toFixed(2);
                    amountInput.readOnly = true;
                    customAmountGroup.style.display = 'block';
                    amountHelp.innerText = "Paying the Minimum Amount Due keeps your account active but interest is charged on the unpaid balance.";
                } else if (val === 'full') {
                    amountInput.value = cardOutstanding.toFixed(2);
                    amountInput.readOnly = true;
                    customAmountGroup.style.display = 'block';
                    amountHelp.innerText = "Paying the outstanding balance in full avoids interest charges on your billing cycle statement.";
                } else {
                    amountInput.value = "";
                    amountInput.readOnly = false;
                    customAmountGroup.style.display = 'block';
                    amountHelp.innerText = "Enter any custom payment amount between ₹1.00 and ₹" + cardOutstanding.toFixed(2);
                }
            }

            // Interactive Bank Account Info Box Handler
            if (accountSelect) {
                accountSelect.addEventListener('change', function() {
                    const selectedOpt = this.options[this.selectedIndex];
                    if (this.value !== "") {
                        const bal = parseFloat(selectedOpt.getAttribute('data-balance'));
                        const num = selectedOpt.getAttribute('data-number');
                        const text = selectedOpt.text;
                        
                        let type = "Savings Account";
                        if (text.toLowerCase().includes("current")) {
                            type = "Current Account";
                        }
                        
                        document.getElementById('selectedAccBalance').innerText = "₹" + bal.toLocaleString('en-IN', {minimumFractionDigits: 2});
                        document.getElementById('selectedAccType').innerText = type;
                        document.getElementById('selectedAccNo').innerText = "•••• " + num.slice(-4);
                        
                        const accountCard = document.getElementById('selectedAccountCard');
                        accountCard.style.display = 'flex';
                        accountCard.style.opacity = '0';
                        setTimeout(() => {
                            accountCard.style.opacity = '1';
                        }, 50);
                    } else {
                        document.getElementById('selectedAccountCard').style.display = 'none';
                    }
                });
            }

            // Form Validation & Confirmation triggers
            const btnSubmit = document.getElementById('btnSubmitPayment');
            const confirmOverlay = document.getElementById('confirmOverlay');
            const btnCancel = document.getElementById('btnCancelPayment');
            const btnConfirm = document.getElementById('btnConfirmPayment');
            const repayForm = document.getElementById('repayForm');

            btnSubmit.addEventListener('click', function() {
                // Client-side validations
                const selectedOpt = accountSelect.options[accountSelect.selectedIndex];
                if (accountSelect.value === "") {
                    showToast("Please select a source bank account to debit.", "error");
                    return;
                }

                const paymentAmount = parseFloat(amountInput.value);
                if (isNaN(paymentAmount) || paymentAmount <= 0) {
                    showToast("Please enter a valid repayment amount greater than zero.", "error");
                    return;
                }

                if (paymentAmount > cardOutstanding) {
                    showToast("Payment amount cannot exceed the card outstanding dues of ₹" + cardOutstanding.toFixed(2), "error");
                    return;
                }

                const accountBalance = parseFloat(selectedOpt.getAttribute('data-balance'));
                if (accountBalance < paymentAmount) {
                    showToast("Insufficient balance in the selected account to clear this amount.", "error");
                    return;
                }

                // Populate overlay values
                document.getElementById('lblAccount').innerText = "VGB •••• " + selectedOpt.getAttribute('data-number').slice(-4);
                document.getElementById('lblAmount').innerText = "₹" + paymentAmount.toLocaleString('en-IN', {minimumFractionDigits: 2});
                document.getElementById('lblRemainingDues').innerText = "₹" + (cardOutstanding - paymentAmount).toLocaleString('en-IN', {minimumFractionDigits: 2});
                document.getElementById('lblRemainingAccountBalance').innerText = "₹" + (accountBalance - paymentAmount).toLocaleString('en-IN', {minimumFractionDigits: 2});

                // Open overlay with animation transition
                confirmOverlay.style.display = 'flex';
                setTimeout(() => {
                    confirmOverlay.classList.add('show');
                }, 10);
            });

            btnCancel.addEventListener('click', function() {
                confirmOverlay.classList.remove('show');
                setTimeout(() => {
                    confirmOverlay.style.display = 'none';
                }, 300);
            });

            btnConfirm.addEventListener('click', function() {
                // Disable buttons to prevent duplicate submission
                btnConfirm.disabled = true;
                btnCancel.disabled = true;
                btnConfirm.innerHTML = '<i class="bx bx-loader-alt bx-spin" style="margin-right: 5px;"></i> Processing...';
                
                // Submit form
                repayForm.submit();
            });

            // Toast Helper
            function showToast(message, type = "success") {
                const container = document.getElementById('toastContainer');
                const card = document.createElement('div');
                card.className = "toast-card show " + (type === 'error' ? 'error' : '');
                
                const icon = document.createElement('i');
                icon.className = "bx " + (type === 'error' ? 'bx-error-circle' : 'bx-badge-check') + " toast-icon";
                
                const textSpan = document.createElement('span');
                textSpan.innerText = message;
                
                card.appendChild(icon);
                card.appendChild(textSpan);
                container.appendChild(card);
                
                setTimeout(() => {
                    card.classList.remove('show');
                    setTimeout(() => card.remove(), 400);
                }, 3500);
            }
        </script>
    </c:if>
</body>
</html>
