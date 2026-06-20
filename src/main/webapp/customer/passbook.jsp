<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Passbook Services</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
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

        .services-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 35px;
        }

        .service-feature-card {
            border-radius: 16px;
            padding: 24px;
            color: white;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 160px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .service-feature-card.primary {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
        }
        .service-feature-card.secondary {
            background: linear-gradient(135deg, #0d9488 0%, #14b8a6 100%);
        }

        .service-feature-card .icon-bg {
            position: absolute;
            right: -20px;
            bottom: -20px;
            font-size: 8rem;
            color: rgba(255, 255, 255, 0.08);
            pointer-events: none;
        }

        /* Modal styling */
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

        .modal-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(99, 102, 241, 0.2);
            width: 100%;
            max-width: 600px;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        @keyframes modalScaleUp {
            from { transform: scale(0.9) translateY(10px); opacity: 0; }
            to { transform: scale(1) translateY(0); opacity: 1; }
        }

        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(99, 102, 241, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-body {
            padding: 25px;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--gray-400);
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .close-btn:hover {
            color: #ef4444;
        }

        /* Paper style request form */
        .paper-form {
            background: #fff;
            border: 1.5px solid var(--gray-200);
            padding: 30px;
            border-radius: var(--radius-sm);
            color: #1e293b;
            font-family: 'Times New Roman', Times, serif;
            font-size: 1rem;
            line-height: 1.6;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.01), var(--shadow-sm);
            position: relative;
            overflow: hidden;
        }

        .paper-header {
            text-align: center;
            border-bottom: 2px double #475569;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }

        .paper-header h2 {
            font-size: 1.35rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #0f172a;
            margin: 0;
            font-family: 'Poppins', sans-serif;
        }

        .paper-header h3 {
            font-size: 0.95rem;
            font-weight: 700;
            color: #475569;
            margin: 4px 0 0;
            text-transform: uppercase;
            font-family: 'Poppins', sans-serif;
            letter-spacing: 0.5px;
        }

        .fee-badge {
            position: absolute;
            right: 20px;
            top: 20px;
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-600);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-family: 'Poppins', sans-serif;
        }

        .paper-select, .paper-input {
            border: none;
            border-bottom: 1px dotted #475569;
            padding: 2px 5px;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
            cursor: pointer;
        }

        .signature-font {
            display: block;
            font-size: 1.4rem;
            font-style: italic;
            color: #3b82f6;
            font-family: 'Brush Script MT', cursive, sans-serif;
            padding-bottom: 5px;
        }

        /* ===== 3D BOOKLET PASSBOOK STYLING ===== */
        .passbook-top-layout {
            display: grid;
            grid-template-columns: 1.1fr 1.3fr;
            gap: 35px;
            margin-bottom: 35px;
            align-items: stretch;
        }

        @media (max-width: 991px) {
            .passbook-top-layout {
                grid-template-columns: 1fr !important;
            }
        }

        .passbook-visualizer-container {
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(30, 27, 75, 0.02) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 40px 20px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.02);
            height: 100%;
            perspective: 1200px;
            position: relative;
            overflow: hidden;
        }

        .passbook-wrapper {
            width: 380px;
            height: 250px;
            position: relative;
            transform-style: preserve-3d;
            cursor: pointer;
        }

        .passbook-book {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateX(12deg) rotateY(-18deg);
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
        }

        /* Spin line / binding edge decoration */
        .passbook-book::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 15px;
            background: linear-gradient(90deg, rgba(0,0,0,0.5) 0%, rgba(255,255,255,0.15) 30%, rgba(0,0,0,0.2) 100%);
            z-index: 50;
            border-radius: 12px 0 0 12px;
            pointer-events: none;
            opacity: 0.8;
        }

        /* 3D cover swing wrapper */
        .passbook-cover-wrapper {
            position: absolute;
            inset: 0;
            transform-origin: left center;
            transform-style: preserve-3d;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 30;
        }

        /* Book states */
        .passbook-book.open .passbook-cover-wrapper {
            transform: rotateY(-155deg);
        }

        .passbook-book.open {
            transform: rotateX(15deg) rotateY(10deg);
        }

        /* Front side of the cover */
        .passbook-cover-front {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            background: radial-gradient(circle at 30% 30%, #1e1b4b 0%, #0c0a21 65%, #02000a 100%);
            border-radius: 12px;
            box-shadow: 10px 15px 35px rgba(0, 0, 0, 0.4), inset -1px 0 2px rgba(255, 255, 255, 0.1);
            padding: 24px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 2;
        }

        /* Star & Nebula effects on cover */
        .passbook-cover-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: 
                radial-gradient(circle at 80% 20%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 10% 80%, rgba(236, 72, 153, 0.1) 0%, transparent 40%);
            pointer-events: none;
        }

        /* Inside side of the cover (visible when open) */
        .passbook-cover-inside {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            transform: rotateY(180deg);
            background: linear-gradient(135deg, #0f0b29 0%, #03010f 100%);
            border-radius: 12px;
            padding: 24px;
            color: #e2e8f0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-right: 1.5px solid rgba(255, 255, 255, 0.05);
            z-index: 1;
        }

        /* Inside Page (bottom page/content page) */
        .passbook-page {
            position: absolute;
            width: 98%;
            height: 96%;
            top: 2%;
            left: 1%;
            background: #faf8f5;
            border-radius: 4px 10px 10px 4px;
            box-shadow: inset 5px 0 15px rgba(0, 0, 0, 0.15), 5px 10px 20px rgba(0,0,0,0.15);
            padding: 20px 24px;
            color: #334155;
            font-family: 'Poppins', sans-serif;
            z-index: 20;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow: hidden;
        }

        /* Back Cover */
        .passbook-back {
            position: absolute;
            inset: 0;
            background: #080517;
            border-radius: 12px;
            box-shadow: 3px 5px 15px rgba(0,0,0,0.5);
            z-index: 10;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 24px;
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.65rem;
            border-left: 2px solid rgba(255,255,255,0.05);
        }

        /* Cover Details */
        .cover-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .bank-abbrev {
            font-weight: 800;
            font-size: 1.2rem;
            letter-spacing: 1.5px;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .chip-icon {
            font-size: 1.6rem;
            color: #d4af37;
            opacity: 0.85;
        }

        .cover-logo {
            align-self: center;
            width: 70px;
            height: 70px;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.4));
        }

        .v-logo-svg {
            width: 100%;
            height: 100%;
        }

        .cover-title {
            text-align: center;
        }

        .cover-title h2 {
            font-size: 1.6rem;
            font-weight: 700;
            letter-spacing: 5px;
            margin: 0;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 25%, #b38728 50%, #fbf5b7 75%, #aa771c 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .cover-title p {
            font-size: 0.6rem;
            letter-spacing: 2.5px;
            color: #d4af37;
            text-transform: uppercase;
            margin-top: 4px;
            font-weight: 600;
            opacity: 0.8;
        }

        .cover-footer {
            text-align: center;
            border-top: 1px solid rgba(212, 175, 55, 0.15);
            padding-top: 10px;
        }

        .bank-tagline {
            font-size: 0.55rem;
            letter-spacing: 1px;
            color: #a5b4fc;
            text-transform: uppercase;
            opacity: 0.7;
        }

        /* Inside Cover details */
        .cover-inside-header {
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 8px;
            font-size: 0.75rem;
            font-weight: 600;
            color: #f8fafc;
            letter-spacing: 0.5px;
        }

        .cover-inside-body {
            font-size: 0.62rem;
            line-height: 1.5;
            color: #94a3b8;
        }

        .cover-inside-footer {
            font-size: 0.55rem;
            color: rgba(255, 255, 255, 0.3);
            text-align: center;
        }

        /* Page details style */
        .page-header {
            border-bottom: 2px solid #cbd5e1;
            padding-bottom: 6px;
            margin-bottom: 12px;
            text-align: center;
        }

        .page-header h4 {
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.75px;
            color: #1e293b;
            margin: 0;
            text-transform: uppercase;
        }

        .passbook-info-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.68rem;
            line-height: 1.4;
        }

        .passbook-info-table td {
            padding: 5px 0;
            border-bottom: 1px dashed #e2e8f0;
        }

        .passbook-info-table td:first-child {
            color: #64748b;
            width: 35%;
        }

        .passbook-info-table td:last-child {
            color: #0f172a;
        }

        .info-bold {
            font-weight: 700;
        }

        .text-ellipsis {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 180px;
            display: inline-block;
            vertical-align: bottom;
        }

        .passbook-status-watermark {
            position: absolute;
            top: 55%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-20deg);
            font-size: 2.2rem;
            font-weight: 900;
            color: rgba(245, 158, 11, 0.12); /* Default pending */
            border: 4px solid currentColor;
            padding: 4px 16px;
            border-radius: 6px;
            pointer-events: none;
            letter-spacing: 2px;
            text-transform: uppercase;
            user-select: none;
        }

        .passbook-status-watermark.approved {
            color: rgba(16, 185, 129, 0.15);
        }

        .passbook-status-watermark.rejected {
            color: rgba(239, 68, 68, 0.15);
        }

        /* Back cover art */
        .back-cover-header {
            border-bottom: 1px solid rgba(255,255,255,0.05);
            padding-bottom: 8px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* Interactive hint animation */
        .click-hint {
            position: absolute;
            bottom: 12px;
            right: 15px;
            font-size: 0.65rem;
            color: var(--primary-400);
            display: flex;
            align-items: center;
            gap: 4px;
            font-weight: 500;
            animation: pulseHint 2s infinite;
            pointer-events: none;
        }

        @keyframes pulseHint {
            0%, 100% { opacity: 0.5; transform: translateX(0); }
            50% { opacity: 1; transform: translateX(3px); }
        }

        /* Styling for list and options */
        .badge-new {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-600);
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .badge-renew {
            background: rgba(236, 72, 153, 0.12);
            color: var(--secondary-600);
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
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
        <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
            <span style="font-weight: 800; font-size: 1.25rem; background: linear-gradient(135deg, var(--primary-500) 0%, var(--secondary-500) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 0.5px;">Vertex Galaxy Bank</span>
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-user-circle"></i> Customer Space</span>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
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
            <a href="${pageContext.request.contextPath}/passbook?action=list" class="active"><i class="bx bx-book-open"></i> Passbook Requests</a>
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
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Passbook Services</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Submit application requests for physical booklet passbooks, review statuses, and preview your premium design.</p>
                </div>
                <div>
                    <button onclick="openRequestModal('apply')" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <i class="bx bx-plus-circle"></i> Request New Passbook
                    </button>
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

            <!-- 3D Passbook Section -->
            <div class="passbook-top-layout">
                <!-- Left: Premium interactive 3D Visualizer -->
                <div class="passbook-visualizer-container">
                    <div class="passbook-wrapper" onclick="toggleBookOpen()">
                        <div class="passbook-book" id="3dPassbook">
                            <!-- Back Cover -->
                            <div class="passbook-back">
                                <div class="back-cover-header">VERTEX GALAXY BANK</div>
                                <div>
                                    <p style="margin: 0; font-weight: bold; color: rgba(255,255,255,0.6);">General Information</p>
                                    <p style="margin: 4px 0 0;">This passbook remains the property of Vertex Galaxy Bank. If found, please return to any branch office.</p>
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                    <div>
                                        <p style="margin: 0;">Support Hotline: 1800-VGB-BANK</p>
                                        <p style="margin: 2px 0 0;">Web: www.vertexgalaxybank.com</p>
                                    </div>
                                    <div style="font-family: monospace; font-size: 0.9rem; letter-spacing: 1.5px; opacity: 0.7;">*VGB-PB*</div>
                                </div>
                            </div>
                            
                            <!-- Inside Ledger Info Page -->
                            <div class="passbook-page">
                                <div class="page-header">
                                    <h4>ACCOUNT CREDENTIALS CARD</h4>
                                </div>
                                <table class="passbook-info-table">
                                    <tr>
                                        <td>Holder Name:</td>
                                        <td class="info-bold uppercase text-ellipsis" id="pbCustName">
                                            <c:out value="${customer.firstName} ${customer.lastName}" default="CUSTOMER NAME"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Account No:</td>
                                        <td class="info-bold monospace" id="pbAccNum">
                                            <c:choose>
                                                <c:when test="${not empty accounts}">
                                                    ${accounts[0].accountNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    SELECT ACCOUNT
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Account Type:</td>
                                        <td class="info-bold uppercase" id="pbAccType">
                                            <c:choose>
                                                <c:when test="${not empty accounts}">
                                                    ${accounts[0].accountType}
                                                </c:when>
                                                <c:otherwise>
                                                    SAVINGS
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>IFS Code:</td>
                                        <td class="info-bold monospace">VGB0000171</td>
                                    </tr>
                                    <tr>
                                        <td>Branch:</td>
                                        <td class="info-bold">BHAKTINAGAR, RAJKOT</td>
                                    </tr>
                                </table>
                                <div class="passbook-status-watermark" id="pbWatermark">PREVIEW</div>
                            </div>
                            
                            <!-- Folding Front Cover -->
                            <div class="passbook-cover-wrapper">
                                <!-- Front Cover Outer -->
                                <div class="passbook-cover-front">
                                    <div class="cover-header">
                                        <span class="bank-abbrev">VGB</span>
                                        <span class="chip-icon"><i class="bx bx-chip"></i></span>
                                    </div>
                                    <div class="cover-logo">
                                        <svg viewBox="0 0 100 100" class="v-logo-svg">
                                            <defs>
                                                <linearGradient id="goldGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                                    <stop offset="0%" stop-color="#bf953f" />
                                                    <stop offset="25%" stop-color="#fcf6ba" />
                                                    <stop offset="50%" stop-color="#b38728" />
                                                    <stop offset="75%" stop-color="#fbf5b7" />
                                                    <stop offset="100%" stop-color="#aa771c" />
                                                </linearGradient>
                                            </defs>
                                            <!-- High-quality Stylized V logo -->
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGrad)" />
                                            <!-- Sparkle star inside V -->
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGrad)" />
                                        </svg>
                                    </div>
                                    <div class="cover-title">
                                        <h2>PASSBOOK</h2>
                                        <p>VERTEX GALAXY BANK</p>
                                    </div>
                                    <div class="cover-footer">
                                        <span class="bank-tagline">Always Beyond Boundaries</span>
                                    </div>
                                </div>
                                <!-- Front Cover Inner -->
                                <div class="passbook-cover-inside">
                                    <div class="cover-inside-header">VERTEX GALAXY PASSBOOK</div>
                                    <div class="cover-inside-body">
                                        <p style="margin: 0; font-weight: bold; color: white;">Notice to Customer:</p>
                                        <p style="margin: 6px 0 0;">Please keep this passbook in a safe place. Please update your passbook at any VGB kiosk terminal regularly to log transaction ledgers offline.</p>
                                        <p style="margin: 8px 0 0;">Report any discrepancy to the branch manager immediately.</p>
                                    </div>
                                    <div class="cover-inside-footer">
                                        VGB Secure Booklet | Version 3D
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="click-hint" id="pbHint"><i class="bx bx-pointer"></i> Click to Open</div>
                </div>

                <!-- Right: Information & Request form summary -->
                <div class="glass-card" style="display: flex; flex-direction: column; justify-content: space-between; margin-bottom: 0;">
                    <div>
                        <h3 style="font-size: 1.4rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-shield-quarter" style="color: var(--primary-500);"></i> Premium Galaxy Passbook
                        </h3>
                        <p style="color: var(--gray-500); font-size: 0.9rem; line-height: 1.6;">
                            Our galaxy-class physical passbook comes standard with:
                        </p>
                        <ul style="color: var(--gray-600); font-size: 0.85rem; padding-left: 20px; line-height: 1.8; margin: 15px 0;">
                            <li>Galaxy navy-blue textured covers with dual metallic gold foil accents</li>
                            <li>Inline smart EMV-style chip simulator representing next-gen security</li>
                            <li>Quick-scan machine-readable ledger columns</li>
                            <li>Flat processing fee of <strong>₹100.00</strong> (fully refunded if request is rejected by Admin)</li>
                        </ul>
                    </div>
                    <div style="background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-md); padding: 18px; margin-top: 15px;">
                        <span style="font-size: 0.75rem; font-weight: 700; color: var(--primary-600); text-transform: uppercase; letter-spacing: 0.5px; display: block; margin-bottom: 6px;">Important Policy</span>
                        <p style="font-size: 0.8rem; color: var(--gray-500); margin: 0; line-height: 1.5;">
                            Applying for a Passbook will automatically deduct ₹100.00 from your account balance. Upon approval, your account parameters will be updated to enable passbook transactions.
                        </p>
                    </div>
                </div>
            </div>

            <!-- List of previous requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-list-ol"></i> Application History</h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Request ID</th>
                                <th style="padding: 12px 15px;">Account Number</th>
                                <th style="padding: 12px 15px;">Type</th>
                                <th style="padding: 12px 15px;">Fee Status</th>
                                <th style="padding: 12px 15px;">Requested Date</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="req" items="${requests}">
                                        <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; vertical-align: middle;">
                                            <td style="padding: 15px; font-weight: 700; color: var(--gray-700);">#${req.requestId}</td>
                                            <td style="padding: 15px; font-family: monospace; font-weight: 600;">${req.accountNumber}</td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${req.requestType eq 'new'}">
                                                        <span class="badge-new">New Cover</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-renew">Renewal</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px;">
                                                <span style="font-weight: 600; color: var(--gray-700);">₹<fmt:formatNumber value="${req.charges}" minFractionDigits="2"/></span>
                                                <c:choose>
                                                    <c:when test="${req.chargesPaid}">
                                                        <span style="background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;"><i class="bx bx-check"></i> Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.12); color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;"><i class="bx bx-x"></i> Refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; color: var(--gray-500);">
                                                <fmt:formatDate value="${req.requestedAt}" pattern="dd-MMM-yyyy hh:mm a" />
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${req.status eq 'approved' or req.status eq 'delivered'}">
                                                        <span style="background: rgba(16, 185, 129, 0.2); color: #10b981; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Approved</span>
                                                    </c:when>
                                                    <c:when test="${req.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.2); color: #fbbf24; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.2); color: #ef4444; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Rejected</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: right;">
                                                <div style="display: flex; gap: 8px; justify-content: flex-end; align-items: center;">
                                                    <button type="button" class="btn" 
                                                            data-id="${req.requestId}" 
                                                            data-name="${req.customerName}" 
                                                            data-account="${req.accountNumber}" 
                                                            data-type="${req.requestType}" 
                                                            data-acctype="${req.accountType}"
                                                            data-status="${req.status}"
                                                            style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #6366f1; color: white; border: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"
                                                            onclick="inspectRequest(this)">
                                                        <i class="bx bx-show"></i> Inspect
                                                    </button>
                                                    <c:if test="${req.status eq 'approved'}">
                                                        <button onclick="openRequestModal('renew', '${req.accountId}')" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600;">Renew</button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 30px; color: var(--gray-400);">No passbook request applications found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Interactive Request Form Modal -->
    <div id="requestModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="margin: 0; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-file"></i> <span id="modalTitle">Apply for Passbook</span>
                </h3>
                <button class="close-btn" onclick="closeRequestModal()"><i class="bx bx-x"></i></button>
            </div>
            <div class="modal-body">
                <form id="passbookRequestForm" action="${pageContext.request.contextPath}/passbook" method="POST">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" id="formAction" value="apply">
                    
                    <div class="paper-form">
                        <div class="fee-badge">Fee: ₹100.00</div>
                        <div class="paper-header">
                            <h2>VERTEX GALAXY BANK</h2>
                            <h3>PASSBOOK APPLICATION FORM</h3>
                        </div>
                        
                        <div style="margin-bottom: 20px;">
                            <label style="font-weight: bold; font-size: 0.85rem; color: #475569; display: block; margin-bottom: 5px;">SELECT LINKED ACCOUNT</label>
                            <select name="accountId" id="modalAccountId" class="paper-select" style="width: 100%; padding: 6px 0;" onchange="updateModalPreview()" required>
                                <c:forEach var="acc" items="${accounts}">
                                    <option value="${acc.accountId}" data-accnum="${acc.accountNumber}" data-acctype="${acc.accountType}">
                                        ${acc.accountNumber} (${acc.accountType}) - Bal: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div style="margin-bottom: 25px;">
                            <label style="font-weight: bold; font-size: 0.85rem; color: #475569; display: block; margin-bottom: 5px;">APPLICATION CATEGORY</label>
                            <select name="requestTypeSelect" id="modalRequestType" class="paper-select" style="width: 100%; padding: 6px 0;" onchange="updateFormAction()" disabled>
                                <option value="new">New Passbook Issuance (Standard)</option>
                                <option value="renew">Renew Passbook (Pages Exhausted/Lost)</option>
                            </select>
                        </div>

                        <div style="border-top: 1px dashed #cbd5e1; padding-top: 15px; display: flex; justify-content: space-between; align-items: flex-end;">
                            <div style="font-size: 0.8rem; color: #64748b;">
                                <p style="margin: 0;">Debit balance checks enabled.</p>
                                <p style="margin: 2px 0 0;">Transaction description will log: <strong>PASSBOOK FEE</strong></p>
                            </div>
                            <div style="text-align: right; width: 150px;">
                                <span class="signature-font">
                                    <c:out value="${customer.firstName} ${customer.lastName}" default="Holder Signature"/>
                                </span>
                                <div style="border-top: 1px solid #475569; font-size: 0.7rem; color: #475569; padding-top: 2px; text-transform: uppercase;">Applicant Signature</div>
                            </div>
                        </div>
                    </div>
                    
                    <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 15px;">
                        <button type="button" class="btn btn-secondary" style="padding: 10px 20px;" onclick="closeRequestModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary" style="padding: 10px 20px; font-weight: 600;">Confirm & Debit ₹100.00</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        const book = document.getElementById('3dPassbook');
        const container = document.querySelector('.passbook-visualizer-container');
        const hint = document.getElementById('pbHint');

        // Interactive 3D mouse move effect
        container.addEventListener('mousemove', (e) => {
            if (book.classList.contains('open')) return;

            const rect = container.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;

            const centerX = rect.width / 2;
            const centerY = rect.height / 2;

            const maxRotX = 15;
            const maxRotY = 22;

            const rotX = -((y - centerY) / centerY) * maxRotX;
            const rotY = ((x - centerX) / centerX) * maxRotY;

            book.style.transform = `rotateX(${12 + rotX}deg) rotateY(${-18 + rotY}deg)`;
        });

        container.addEventListener('mouseleave', () => {
            if (book.classList.contains('open')) return;
            book.style.transform = `rotateX(12deg) rotateY(-18deg)`;
        });

        function toggleBookOpen() {
            book.classList.toggle('open');
            if (book.classList.contains('open')) {
                hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Close';
                book.style.transform = 'rotateX(15deg) rotateY(10deg)';
            } else {
                hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Open';
                book.style.transform = 'rotateX(12deg) rotateY(-18deg)';
            }
        }

        // Modal triggers
        function openRequestModal(action, accountIdVal) {
            const modal = document.getElementById('requestModal');
            const formAction = document.getElementById('formAction');
            const modalTitle = document.getElementById('modalTitle');
            const selectType = document.getElementById('modalRequestType');
            const selectAcc = document.getElementById('modalAccountId');

            formAction.value = action;
            if (action === 'renew') {
                modalTitle.innerText = "Renew Passbook";
                selectType.value = 'renew';
                if (accountIdVal) {
                    selectAcc.value = accountIdVal;
                }
            } else {
                modalTitle.innerText = "Apply for Passbook";
                selectType.value = 'new';
            }

            modal.style.display = 'flex';
            updateModalPreview();
        }

        function closeRequestModal() {
            document.getElementById('requestModal').style.display = 'none';
        }

        function updateFormAction() {
            const selectType = document.getElementById('modalRequestType');
            const formAction = document.getElementById('formAction');
            formAction.value = selectType.value;
        }

        function updateModalPreview() {
            const selectAcc = document.getElementById('modalAccountId');
            const selectedOpt = selectAcc.options[selectAcc.selectedIndex];
            if (!selectedOpt) return;

            const accNum = selectedOpt.getAttribute('data-accnum');
            const accType = selectedOpt.getAttribute('data-acctype');

            // Sync with 3D Page Preview
            document.getElementById('pbAccNum').innerText = accNum;
            document.getElementById('pbAccType').innerText = accType;
            
            // Set Watermark text
            const wm = document.getElementById('pbWatermark');
            wm.innerText = "PREVIEW";
            wm.className = "passbook-status-watermark";
        }

        // View dynamic preview for a previous request
        function inspectRequest(btn) {
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            const acc = btn.getAttribute('data-account');
            const type = btn.getAttribute('data-type');
            const acctype = btn.getAttribute('data-acctype');
            const status = btn.getAttribute('data-status');

            document.getElementById('pbCustName').innerText = name;
            document.getElementById('pbAccNum').innerText = acc;
            document.getElementById('pbAccType').innerText = acctype;

            const wm = document.getElementById('pbWatermark');
            wm.innerText = status;
            wm.className = "passbook-status-watermark " + status.toLowerCase();

            // Open book cover automatically to show info
            if (!book.classList.contains('open')) {
                toggleBookOpen();
            }

            // Scroll visualizer into view on mobile
            container.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    </script>
</body>
</html>
