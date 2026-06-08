<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Accounts Directory</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
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
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-sm);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        /* PREMIUM VGB 3D CARDS */
        .vgb-atm-card {
            width: 320px;
            height: 200px;
            border-radius: 16px;
            padding: 20px;
            color: white;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            perspective: 1000px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            cursor: pointer;
        }
        .vgb-atm-card.debit {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #06b6d4 100%);
            box-shadow: 0 10px 20px rgba(59, 130, 246, 0.25);
        }
        .vgb-atm-card.credit {
            background: linear-gradient(135deg, #4c1d95 0%, #8b5cf6 50%, #ec4899 100%);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.25);
        }
        .vgb-atm-card.inactive-card {
            background: linear-gradient(135deg, #374151 0%, #4b5563 100%) !important;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1) !important;
            opacity: 0.6;
        }
        .vgb-atm-card.flipped {
            transform: rotateY(180deg);
        }
        .vgb-atm-card.interactive {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }
        .vgb-atm-card .card-face {
            position: absolute;
            inset: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backface-visibility: hidden;
            border-radius: inherit;
        }
        .vgb-atm-card .card-front {
            background: inherit;
        }
        .vgb-atm-card .card-back {
            background: inherit;
            transform: rotateY(180deg);
        }
        .vgb-atm-card::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 20%, rgba(255, 255, 255, 0.08) 40%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.08) 60%, transparent 80%);
            transform: rotate(-45deg);
            transition: all 0.8s ease;
            pointer-events: none;
            opacity: 0.5;
        }
        .vgb-atm-card:hover::after {
            left: 100%;
        }

        /* 3D Cheque Layout styling */
        .vgb-cheque-3d {
            width: 320px;
            height: 200px;
            background-color: #e0f2fe;
            background-image: 
                radial-gradient(circle at 10% 90%, rgba(99, 102, 241, 0.04) 0%, transparent 60%),
                radial-gradient(circle at 90% 10%, rgba(6, 182, 212, 0.03) 0%, transparent 50%),
                linear-gradient(to right, #bae6fd, #e0f2fe);
            border: 1px solid #93c5fd;
            border-radius: 8px;
            padding: 12px 15px;
            color: #334155;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 0.55rem;
            line-height: 1.3;
            box-shadow: 0 10px 20px rgba(15, 23, 42, 0.08);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1), box-shadow 0.3s ease;
            transform-style: preserve-3d;
            perspective: 1000px;
            cursor: pointer;
            border: 1.5px solid rgba(255, 255, 255, 0.1);
        }
        .vgb-cheque-3d.inactive-card {
            filter: grayscale(0.8) opacity(0.5);
        }
        .vgb-cheque-3d .cheque-hologram {
            position: absolute;
            left: 8px;
            top: 0;
            bottom: 0;
            width: 10px;
            background: linear-gradient(90deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
            opacity: 0.85;
            z-index: 2;
        }
        .vgb-cheque-3d .cheque-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            z-index: 3;
            margin-left: 10px;
        }
        .vgb-cheque-3d .cheque-bank-name {
            font-weight: 800;
            font-size: 0.65rem;
            color: #1e3a8a;
        }
        .vgb-cheque-3d .cheque-branch-details {
            font-size: 0.45rem;
            color: #475569;
        }
        .vgb-cheque-3d .cheque-date-box {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        .vgb-cheque-3d .date-squares {
            display: flex;
            gap: 1.5px;
        }
        .vgb-cheque-3d .date-squares span {
            width: 8px;
            height: 10px;
            border: 0.5px solid #1e3a8a;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.45rem;
            font-weight: 600;
            color: #1e3a8a;
        }
        .vgb-cheque-3d .cheque-row {
            display: flex;
            align-items: flex-end;
            margin: 2px 0;
            z-index: 3;
            margin-left: 10px;
        }
        .vgb-cheque-3d .cheque-label {
            font-weight: bold;
            font-size: 0.55rem;
            color: #1e3a8a;
            white-space: nowrap;
        }
        .vgb-cheque-3d .cheque-line-fill {
            flex: 1;
            border-bottom: 1px dotted #64748b;
            margin: 0 4px;
            font-size: 0.55rem;
            font-style: italic;
            color: #0f172a;
        }
        .vgb-cheque-3d .cheque-amount-box {
            width: 70px;
            height: 18px;
            border: 1px solid #1e3a8a;
            background: white;
            display: flex;
            align-items: center;
            padding: 0 4px;
        }
        .vgb-cheque-3d .cheque-details-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 4px;
            z-index: 3;
            margin-left: 10px;
        }
        .vgb-cheque-3d .cheque-acc-box {
            border: 1px solid #1e3a8a;
            background: white;
            padding: 2px 4px;
            font-size: 0.55rem;
        }
        .vgb-cheque-3d .cheque-sign-area {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        .vgb-cheque-3d .cheque-sign-name {
            font-family: 'Brush Script MT', cursive, sans-serif;
            font-size: 0.85rem;
            font-style: italic;
            color: #2563eb;
        }
        .vgb-cheque-3d .cheque-micr-band {
            text-align: center;
            font-family: monospace;
            font-size: 0.55rem;
            letter-spacing: 2px;
            color: #0f172a;
            margin-top: 5px;
            z-index: 3;
            margin-left: 10px;
        }

        /* 3D Passbook Cover & Inner Layout styling */
        .vgb-passbook-3d {
            width: 320px;
            height: 200px;
            border-radius: 12px;
            color: white;
            position: relative;
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            perspective: 1000px;
            cursor: pointer;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }
        .vgb-passbook-3d.inactive-card {
            filter: grayscale(0.8) opacity(0.5);
        }
        .vgb-passbook-3d .card-face {
            position: absolute;
            inset: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            backface-visibility: hidden;
            border-radius: inherit;
        }
        .vgb-passbook-3d .card-front {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            border: 2px solid #d97706; /* Gold border */
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .vgb-passbook-3d .card-back {
            background: #f8fafc;
            color: #334155;
            transform: rotateY(180deg);
            border: 1px solid #cbd5e1;
        }

        /* Modals and Tabs Layout */
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
            max-width: 800px;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            margin-bottom: 0;
        }
        @keyframes modalScaleUp {
            from { transform: scale(0.95) translateY(10px); opacity: 0; }
            to { transform: scale(1) translateY(0); opacity: 1; }
        }
        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(99, 102, 241, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }
        .modal-body {
            padding: 25px;
            overflow-y: auto;
            max-height: calc(90vh - 160px);
        }
        .modal-footer {
            padding: 15px 25px;
            border-top: 1px solid rgba(99, 102, 241, 0.1);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            flex-shrink: 0;
            background: rgba(99, 102, 241, 0.02);
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

        .wizard-step-pane {
            display: none;
            flex-direction: column;
            gap: 20px;
        }
        .wizard-step-pane.active {
            display: flex;
        }

        /* Directional Staggered Slide Animations for Active Pane Children */
        .wizard-step-pane.active > * {
            opacity: 0;
        }

        #createAccountForm.slide-next .wizard-step-pane.active > *,
        .wizard-step-pane.active > * {
            animation: slideNextIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        #createAccountForm.slide-back .wizard-step-pane.active > * {
            animation: slideBackIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .wizard-step-pane.active > *:nth-child(1) { animation-delay: 0.03s; }
        .wizard-step-pane.active > *:nth-child(2) { animation-delay: 0.06s; }
        .wizard-step-pane.active > *:nth-child(3) { animation-delay: 0.09s; }
        .wizard-step-pane.active > *:nth-child(4) { animation-delay: 0.12s; }
        .wizard-step-pane.active > *:nth-child(5) { animation-delay: 0.15s; }
        .wizard-step-pane.active > *:nth-child(6) { animation-delay: 0.18s; }
        .wizard-step-pane.active > *:nth-child(7) { animation-delay: 0.21s; }
        .wizard-step-pane.active > *:nth-child(8) { animation-delay: 0.24s; }

        @keyframes slideNextIn {
            from {
                opacity: 0;
                transform: translateX(24px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideBackIn {
            from {
                opacity: 0;
                transform: translateX(-24px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* High-fidelity Form Controls styling for Wizard */
        #createAccountModal .form-control {
            padding: 11px 15px;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            font-family: inherit;
            font-size: 0.88rem;
            color: #334155;
            background: #f8fafc;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
            width: 100%;
            box-sizing: border-box;
        }
        #createAccountModal .form-control::placeholder {
            color: #94a3b8;
        }
        #createAccountModal .form-control:hover {
            border-color: #cbd5e1;
            background: #f1f5f9;
        }
        #createAccountModal .form-control:focus {
            border-color: var(--primary-500);
            background: white;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12);
        }
        #createAccountModal select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748b' stroke-width='2.5'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2.5' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            background-size: 14px;
            padding-right: 40px;
        }
        #createAccountModal .form-group {
            margin-bottom: 5px;
        }
        #createAccountModal .form-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        #createAccountModal .wizard-step-pane div[style*="grid-template-columns"] {
            gap: 16px 20px !important;
        }


        /* Active step indicator animation */
        .step-indicator-item {
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
        }
        .step-indicator-item.active {
            transform: scale(1.08);
        }
        .step-indicator-item.active span:first-child {
            animation: pulseActiveIndicator 2s infinite;
        }
        @keyframes pulseActiveIndicator {
            0% {
                box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.6);
            }
            70% {
                box-shadow: 0 0 0 6px rgba(99, 102, 241, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(99, 102, 241, 0);
            }
        }
        .step-indicator-item.completed span:first-child {
            animation: pulseCompletedIndicator 0.4s ease-out;
        }
        @keyframes pulseCompletedIndicator {
            0% { transform: scale(0.8); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        /* Button premium micro-interactions */
        #createAccountModal .btn {
            position: relative;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }
        #createAccountModal .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.3);
        }
        #createAccountModal .btn:active {
            transform: translateY(0);
        }

        .tabs-header {
            display: flex;
            border-bottom: 1px solid var(--gray-200);
            margin-bottom: 25px;
            gap: 5px;
        }
        .tab-link {
            padding: 12px 20px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--gray-500);
            border: none;
            background: none;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .tab-link:hover {
            color: var(--primary-500);
        }
        .tab-link.active {
            color: var(--primary-500);
            border-bottom-color: var(--primary-500);
        }
        .tab-pane {
            display: none;
        }
        .tab-pane.active {
            display: block;
            animation: tabFadeIn 0.3s ease-out;
        }
        @keyframes tabFadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .partner-card {
            background: rgba(99, 102, 241, 0.01);
            border: 1px dashed rgba(99, 102, 241, 0.2);
            border-radius: var(--radius-md);
            padding: 20px;
            margin-bottom: 15px;
            position: relative;
            transition: all 0.3s;
        }
        .partner-card:hover {
            background: rgba(99, 102, 241, 0.03);
            border-color: var(--primary-500);
        }

        .summary-card {
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md);
            padding: 15px 20px;
            margin-bottom: 15px;
        }
        .summary-card h5 {
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--gray-700);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
            border-bottom: 1px solid var(--gray-200);
            padding-bottom: 6px;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
        }
        .summary-field {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }
        .summary-field span {
            font-size: 0.72rem;
            color: var(--gray-400);
            text-transform: uppercase;
            font-weight: 500;
        }
        .summary-field strong {
            font-size: 0.88rem;
            color: var(--gray-700);
            font-weight: 600;
        }

        .showcase-grid-3d {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            justify-content: center;
            align-items: center;
        }
        .showcase-item-3d {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 15px;
            box-shadow: var(--shadow-sm);
            text-align: center;
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
        <a href="#" class="logo">
            <span class="logo-text">V</span>
            <span class="logo-text">G</span>
            <span class="logo-text">B</span>
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list" class="active"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/admin/notification.jsp"><i class="bx bx-bell"></i> Audit Logs</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Page Header -->
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Manage Accounts Directory</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor active accounts database, register new customers, and update signatories configurations.</p>
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

            <!-- Metrics Statistics Grid -->
            <div class="stat-grid">
                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-group"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Total Customers</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${totalCustomers}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-user-check"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings (Single User)</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${savingsSingleCustomers}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-user-voice"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings (Joining User)</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${savingsJointCustomers}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-amber);">
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber);">
                        <i class="bx bx-briefcase"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Accounts</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${currentCustomers}</strong>
                    </div>
                </div>
            </div>

            <!-- Search Panel and Action triggers -->
            <div class="glass-card" style="display: flex; gap: 20px; align-items: center; justify-content: space-between; flex-wrap: wrap;">
                <div style="display: flex; gap: 15px; align-items: center; flex: 1; min-width: 300px;">
                    <div style="position: relative; flex: 1;">
                        <input type="text" id="searchInput" oninput="filterAccountsTable()" placeholder="Search by Customer ID, Name, Account Number..." style="width: 100%; padding: 12px 40px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                        <i class="bx bx-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.25rem;"></i>
                    </div>
                    <select id="typeFilter" onchange="filterAccountsTable()" style="padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-weight: 500; cursor: pointer;">
                        <option value="all">All Account Types</option>
                        <option value="savings">Savings</option>
                        <option value="current">Current</option>
                    </select>
                    <select id="statusFilter" onchange="filterAccountsTable()" style="padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-weight: 500; cursor: pointer;">
                        <option value="all">All Statuses</option>
                        <option value="active">Active</option>
                        <option value="closed">Closed</option>
                    </select>
                </div>
                <button type="button" class="btn btn-primary" onclick="openCreateAccountModal()" style="display: flex; align-items: center; gap: 8px; font-weight: 600; padding: 12px 24px; margin-top: 0; box-shadow: var(--shadow-md);">
                    <i class="bx bx-user-plus" style="font-size: 1.25rem;"></i> Open New Account
                </button>
            </div>

            <!-- Signatories ledger table directory -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-folder-open"></i> Accounts Directory
                </h3>
                <div style="overflow-x: auto;">
                    <table class="table" id="accountsTable" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); padding-bottom: 10px; color: var(--gray-500); font-weight: 600; font-size: 0.85rem;">
                                <th style="padding: 12px;">Sr No.</th>
                                <th style="padding: 12px;">Customer ID</th>
                                <th style="padding: 12px;">Customer Name</th>
                                <th style="padding: 12px;">Account Number</th>
                                <th style="padding: 12px;">Account Type</th>
                                <th style="padding: 12px;">Total Balance</th>
                                <th style="padding: 12px;">Status</th>
                                <th style="padding: 12px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}" varStatus="status">
                                        <tr data-cust-id="CUST-${acc.customerId}" data-cust-name="${acc.customerName}" data-acc-number="${acc.accountNumber}" data-acc-type="${acc.accountType}" data-acc-status="${acc.status}" style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-500);">${status.count}</td>
                                            <td style="padding: 15px; font-family: monospace; font-weight: 500;">CUST-${acc.customerId}</td>
                                            <td style="padding: 15px; font-weight: 500;">
                                                <c:out value="${acc.customerName}" default="No Owner" />
                                            </td>
                                            <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${acc.accountNumber}</td>
                                            <td style="padding: 15px; text-transform: capitalize;">
                                                <c:choose>
                                                    <c:when test="${acc.accountType eq 'savings'}">
                                                        Savings (<c:out value="${acc.holdingType}" default="Single" />)
                                                        <c:if test="${not empty acc.ageCategory}">
                                                            <span style="font-size: 0.75rem; color: var(--primary-500); display: block; margin-top: 2px; font-weight: 500;">
                                                                <c:out value="${acc.ageCategory}" />
                                                            </span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Current Account
                                                        <c:if test="${not empty acc.ageCategory}">
                                                            <span style="font-size: 0.75rem; color: var(--primary-500); display: block; margin-top: 2px; font-weight: 500;">
                                                                <c:out value="${acc.ageCategory}" />
                                                            </span>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; font-weight: 700; color: var(--primary-500);">
                                                ₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2" />
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${acc.status eq 'active'}">
                                                        <span style="background: rgba(16, 185, 129, 0.15); color: #10b981; padding: 4px 10px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; text-transform: uppercase;">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.15); color: #ef4444; padding: 4px 10px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; text-transform: uppercase;">Closed</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: center; white-space: nowrap;">
                                                <button type="button" class="btn btn-secondary" onclick="openEditAccountModal('${acc.customerId}', '${acc.accountId}')" style="padding: 6px 10px; font-size: 0.8rem; border-color: var(--accent-amber); color: var(--accent-amber); background: transparent; display: inline-flex; align-items: center; gap: 4px; margin-top:0;" title="Edit Profile & Services"><i class="bx bx-edit"></i> Edit</button>
                                                
                                                <a href="${pageContext.request.contextPath}/account?action=statement&accountId=${acc.accountId}" class="btn btn-secondary" style="padding: 6px 10px; font-size: 0.8rem; border-color: var(--primary-500); color: var(--primary-500); background: transparent; display: inline-flex; align-items: center; gap: 4px; margin-top: 0; margin-left: 5px;" title="View Statement Ledger"><i class="bx bx-show"></i> View</a>
                                                
                                                <c:if test="${acc.status ne 'closed'}">
                                                    <button type="button" class="btn btn-secondary" onclick="triggerSoftCloseAccount('${acc.accountId}', '${acc.accountNumber}')" style="padding: 6px 10px; font-size: 0.8rem; border-color: #ef4444; color: #ef4444; background: transparent; display: inline-flex; align-items: center; gap: 4px; margin-top:0; margin-left: 5px;" title="Close Account"><i class="bx bx-x-circle"></i> Close</button>
                                                </c:if>
                                                
                                                <button type="button" class="btn btn-secondary" onclick="triggerHardDeleteAccount('${acc.accountId}', '${acc.accountNumber}')" style="padding: 6px 10px; font-size: 0.8rem; border-color: #991b1b; color: #ef4444; background: rgba(239, 68, 68, 0.05); display: inline-flex; align-items: center; gap: 4px; margin-top:0; margin-left: 5px;" title="Hard Delete Signatory"><i class="bx bx-trash"></i> Delete</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="text-align: center; padding: 30px; color: var(--gray-400);">No customer signatories found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Hidden Forms for Submit Actions -->
    <form id="closeAccountForm" action="${pageContext.request.contextPath}/account?action=close" method="post" style="display: none;">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" id="closeFormAccountId" name="accountId">
    </form>
    <form id="deleteAccountForm" action="${pageContext.request.contextPath}/account?action=delete" method="post" style="display: none;">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" id="deleteFormAccountId" name="accountId">
    </form>

    <!-- View Statement Modal -->
    <div id="statementModal" class="modal" <c:if test="${not empty statementAccount}">style="display: flex;"</c:if>>
        <div class="modal-content" style="max-width: 900px;">
            <div class="modal-header">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-receipt" style="color: var(--primary-500);"></i> Transaction Ledger & Statement
                </h3>
                <button type="button" class="close-btn" onclick="closeStatementModal()">&times;</button>
            </div>
            <div class="modal-body">
                <c:if test="${not empty statementAccount}">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px;">
                        <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.1); border-radius: var(--radius-md); padding: 15px;">
                            <h4 style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 10px;">Primary Signatory</h4>
                            <p style="font-size: 1rem; font-weight: 600; color: var(--gray-800);">${statementCustomer.firstName} ${statementCustomer.lastName}</p>
                            <p style="font-size: 0.85rem; color: var(--gray-500); margin-top: 4px;">Email: ${statementCustomer.email} | Phone: ${statementCustomer.phoneNo}</p>
                            <p style="font-size: 0.85rem; color: var(--gray-500);">Address: ${statementCustomer.address}, ${statementCustomer.city}, ${statementCustomer.state}</p>
                        </div>
                        <div style="background: rgba(16, 185, 129, 0.03); border: 1px solid rgba(16, 185, 129, 0.1); border-radius: var(--radius-md); padding: 15px;">
                            <h4 style="font-size: 0.85rem; font-weight: 700; color: var(--accent-emerald); text-transform: uppercase; margin-bottom: 10px;">Ledger Details</h4>
                            <p style="font-size: 1rem; font-weight: 600; color: var(--gray-800);">A/C No: ${statementAccount.accountNumber}</p>
                            <p style="font-size: 0.85rem; color: var(--gray-500); margin-top: 4px;">IFSC Branch: ${statementAccount.ifscCode} | Type: <span style="text-transform: capitalize;">${statementAccount.accountType}</span></p>
                            <p style="font-size: 1.1rem; font-weight: 700; color: var(--accent-emerald); margin-top: 6px;">Available Balance: ₹ <fmt:formatNumber value="${statementAccount.balance}" minFractionDigits="2" maxFractionDigits="2" /></p>
                        </div>
                    </div>

                    <div style="overflow-x: auto;">
                        <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem;">
                            <thead>
                                <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-weight: 600;">
                                    <th style="padding: 10px;">Date/Time</th>
                                    <th style="padding: 10px;">Reference ID</th>
                                    <th style="padding: 10px;">Description</th>
                                    <th style="padding: 10px;">Type</th>
                                    <th style="padding: 10px; text-align: right;">Amount</th>
                                    <th style="padding: 10px; text-align: right;">Running Balance</th>
                                    <th style="padding: 10px; text-align: center;">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty transactions}">
                                        <c:forEach var="txn" items="${transactions}">
                                            <tr style="border-bottom: 1px solid var(--gray-100); color: var(--gray-700);">
                                                <td style="padding: 12px 10px;"><fmt:formatDate value="${txn.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                <td style="padding: 12px 10px; font-family: monospace;">${txn.referenceNumber}</td>
                                                <td style="padding: 12px 10px; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${txn.description}">${txn.description}</td>
                                                <td style="padding: 12px 10px; text-transform: uppercase; font-weight: 600;">
                                                    <c:choose>
                                                        <c:when test="${txn.transactionType eq 'deposit' or txn.transactionType eq 'interest'}">
                                                            <span style="color: #10b981;">Credit</span>
                                                        </c:when>
                                                        <c:when test="${txn.transactionType eq 'transfer' and txn.toAccountId eq statementAccount.accountId}">
                                                            <span style="color: #10b981;">Credit</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #ef4444;">Debit</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 12px 10px; text-align: right; font-weight: 600;">
                                                    ₹ <fmt:formatNumber value="${txn.amount}" minFractionDigits="2" maxFractionDigits="2" />
                                                </td>
                                                <td style="padding: 12px 10px; text-align: right; font-weight: 600; color: var(--gray-600);">
                                                    ₹ <fmt:formatNumber value="${txn.runningBalance}" minFractionDigits="2" maxFractionDigits="2" />
                                                </td>
                                                <td style="padding: 12px 10px; text-align: center;">
                                                    <span style="font-size: 0.7rem; font-weight: 700; text-transform: uppercase; color: #10b981; background: rgba(16, 185, 129, 0.1); padding: 2px 6px; border-radius: var(--radius-sm);">${txn.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 25px; color: var(--gray-400);">No transaction history logs recorded for this ledger.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeStatementModal()" style="margin-top:0;">Close Statement</button>
            </div>
        </div>
    </div>

    <!-- Edit Account Modal -->
    <div id="editAccountModal" class="modal">
        <div class="modal-content" style="max-width: 750px;">
            <div class="modal-header">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-edit-alt" style="color: var(--primary-500);"></i> Edit Customer Signatories Ledger
                </h3>
                <button type="button" class="close-btn" onclick="closeEditAccountModal()">&times;</button>
            </div>
            
            <form id="editAccountForm" action="${pageContext.request.contextPath}/account?action=update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" id="editCustomerId" name="customerId">
                <input type="hidden" id="editAccountId" name="accountId">
                <input type="hidden" id="editJointCustomerId" name="jointCustomerId">

                <div class="modal-body">
                    <!-- Tabs Headers -->
                    <div class="tabs-header">
                        <button type="button" class="tab-link active" onclick="switchModalTab(event, 'tabPrimary')"><i class="bx bx-user"></i> Primary Profile</button>
                        <button type="button" id="tabJointLink" class="tab-link" onclick="switchModalTab(event, 'tabJoint')" style="display: none;"><i class="bx bx-group"></i> Joint Profile</button>
                        <button type="button" class="tab-link" onclick="switchModalTab(event, 'tabBanking')"><i class="bx bx-slider"></i> Banking Services</button>
                        <button type="button" class="tab-link" onclick="switchModalTab(event, 'tabSecurity')"><i class="bx bx-lock"></i> Security/Access</button>
                    </div>

                    <!-- Tab 1: Primary Profile -->
                    <div id="tabPrimary" class="tab-pane active">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">First Name *</label>
                                <input type="text" id="editFirstName" name="firstName" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name *</label>
                                <input type="text" id="editLastName" name="lastName" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Signature *</label>
                                <input type="email" id="editEmail" name="email" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Signature *</label>
                                <input type="text" id="editPhoneNo" name="phoneNo" class="form-control" maxlength="10" required>
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">Address Description *</label>
                                <input type="text" id="editAddress" name="address" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">City *</label>
                                <input type="text" id="editCity" name="city" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">State *</label>
                                <input type="text" id="editState" name="state" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Zip Code *</label>
                                <input type="text" id="editZipCode" name="zipCode" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">PAN Number</label>
                                <input type="text" id="editPanCard" name="panCard" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Aadhaar Card (12 digits)</label>
                                <input type="text" id="editAadhaarCard" name="aadhaarCard" class="form-control" maxlength="12">
                            </div>
                        </div>
                    </div>

                    <!-- Tab 2: Joint Profile -->
                    <div id="tabJoint" class="tab-pane">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">First Name *</label>
                                <input type="text" id="editJointFirstName" name="jointFirstName" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name *</label>
                                <input type="text" id="editJointLastName" name="jointLastName" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Signature *</label>
                                <input type="email" id="editJointEmail" name="jointEmail" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Signature *</label>
                                <input type="text" id="editJointPhoneNo" name="jointPhoneNo" class="form-control" maxlength="10">
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">Address Description *</label>
                                <input type="text" id="editJointAddress" name="jointAddress" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">City *</label>
                                <input type="text" id="editJointCity" name="jointCity" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">State *</label>
                                <input type="text" id="editJointState" name="jointState" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Zip Code *</label>
                                <input type="text" id="editJointZipCode" name="jointZipCode" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">PAN Number</label>
                                <input type="text" id="editJointPanCard" name="jointPanCard" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Aadhaar Card</label>
                                <input type="text" id="editJointAadhaarCard" name="jointAadhaarCard" class="form-control" maxlength="12">
                            </div>
                        </div>
                    </div>

                    <!-- Tab 3: Banking Preferences -->
                    <div id="tabBanking" class="tab-pane">
                        <div style="display: flex; gap: 20px; margin-bottom: 25px;">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 500;">
                                <input type="checkbox" id="editHasAtmCard" name="hasAtmCard" value="1" style="width: 18px; height: 18px;"> Opt ATM Debit Card
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 500;">
                                <input type="checkbox" id="editHasChequeBook" name="hasChequeBook" value="1" style="width: 18px; height: 18px;"> Opt Cheque Book
                            </label>
                        </div>

                        <!-- Savings specific subclass fields -->
                        <div id="subclassSavingsFields" style="display: none; border-top: 1px solid var(--gray-200); padding-top: 20px;">
                            <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); margin-bottom: 15px; text-transform: uppercase;">Savings Configuration</h4>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label class="form-label">Nominee Person Name</label>
                                    <input type="text" id="editNomineeName" name="nomineeName" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Holding Structure</label>
                                    <select id="editHoldingType" name="holdingType" class="form-control" onchange="toggleJointTabOnHoldingChange()">
                                        <option value="single">Single Holder</option>
                                        <option value="joint">Joint Holder</option>
                                    </select>
                                </div>
                                <div class="form-group" style="grid-column: span 2;">
                                    <label class="form-label">Daily ATM Withdrawal Limit (₹)</label>
                                    <input type="number" id="editDailyWithdrawalLimit" name="dailyWithdrawalLimit" class="form-control" step="0.01">
                                </div>
                            </div>
                        </div>

                        <!-- Current specific subclass fields -->
                        <div id="subclassCurrentFields" style="display: none; border-top: 1px solid var(--gray-200); padding-top: 20px;">
                            <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); margin-bottom: 15px; text-transform: uppercase;">Corporate Configuration</h4>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label class="form-label">Business Name *</label>
                                    <input type="text" id="editBusinessName" name="businessName" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">GSTIN ID *</label>
                                    <input type="text" id="editGstin" name="gstin" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Overdraft Credit Limit (₹)</label>
                                    <input type="number" id="editOverdraftLimit" name="overdraftLimit" class="form-control" step="0.01">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Category</label>
                                    <input type="text" id="editCompanyCategory" name="companyCategory" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Phone Signature</label>
                                    <input type="text" id="editCompanyPhone" name="companyPhone" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Email</label>
                                    <input type="email" id="editCompanyEmail" name="companyEmail" class="form-control">
                                </div>
                                <div class="form-group" style="grid-column: span 2;">
                                    <label class="form-label">Company Registered Address</label>
                                    <input type="text" id="editCompanyAddress" name="companyAddress" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company PAN</label>
                                    <input type="text" id="editCompanyPan" name="companyPan" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Corporate Aadhaar</label>
                                    <input type="text" id="editCompanyAadhaar" name="companyAadhaar" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tab 4: Security -->
                    <div id="tabSecurity" class="tab-pane">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">Secure Login Username *</label>
                                <input type="text" id="editUsername" name="username" class="form-control" required readonly style="background: var(--gray-100); cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Reset Secure PIN (4 digits)</label>
                                <input type="password" id="editPin" name="pin" class="form-control" maxlength="4" placeholder="Leave blank to keep unchanged">
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">Reset Master Login Password</label>
                                <input type="password" id="editPassword" name="password" class="form-control" placeholder="Leave blank to keep unchanged">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditAccountModal()" style="margin-top:0;">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="margin-top:0;">Save Ledger Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Create Account Wizard Modal -->
    <div id="createAccountModal" class="modal">
        <div class="modal-content" style="max-width: 850px;">
            <div class="modal-header">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-plus-circle" style="color: var(--primary-500);"></i> 
                    <span id="wizHeaderTitle">Onboard New Customer Ledger</span>
                </h3>
                <button type="button" class="close-btn" onclick="closeCreateAccountModal()">&times;</button>
            </div>
            
            <form id="createAccountForm" action="${pageContext.request.contextPath}/account?action=createProcess" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                
                <div class="modal-body">
                    <!-- Dynamic Step Indicators -->
                    <div id="wizardStepsIndicator" style="display: flex; flex-wrap: wrap; justify-content: space-between; gap: 10px; margin-bottom: 30px; border-bottom: 1px solid var(--gray-100); padding-bottom: 15px;">
                        <!-- Rendered by JS -->
                    </div>

                    <!-- STEP 1: Account Classification -->
                    <div id="wizardStepClassification" class="wizard-step-pane active">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Select Account Classification</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Define the core ledger structure and ownership type for the signatory profile.</p>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label class="form-label">Account Classification *</label>
                                <select id="wizAccountType" name="accountType" class="form-control" onchange="toggleClassificationFlowSelection()" required>
                                    <option value="savings" selected>Savings Account</option>
                                    <option value="current">Current Corporate Account</option>
                                </select>
                            </div>
                            <div class="form-group" id="wizHoldingTypeWrapper">
                                <label class="form-label">Holding Structure *</label>
                                <select id="wizHoldingType" name="holdingType" class="form-control" onchange="toggleClassificationFlowSelection()" required>
                                    <option value="single" selected>Single User Account</option>
                                    <option value="joint">Joining User Account (Max 2)</option>
                                </select>
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">IFSC Branch Routing *</label>
                                <input type="text" id="wizIfscCode" name="ifscCode" class="form-control" value="VGBK0000001" required>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 2: Primary Holder Demographic Details -->
                    <div id="wizardStepPrimaryHolder" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Primary Customer Demographics</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Enter the personal profiling information for the primary signatory.</p>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">First Name *</label>
                                <input type="text" id="wizFirstName" name="firstName" class="form-control" placeholder="First Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Middle Name</label>
                                <input type="text" id="wizMiddleName" name="middleName" class="form-control" placeholder="Middle Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name *</label>
                                <input type="text" id="wizLastName" name="lastName" class="form-control" placeholder="Last Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Gender Signature</label>
                                <select id="wizGender" name="gender" class="form-control">
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Date of Birth *</label>
                                <input type="date" id="wizDob" name="dob" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Marital Status</label>
                                <select id="wizMaritalStatus" name="maritalStatus" class="form-control">
                                    <option value="">Select Status</option>
                                    <option value="Single">Single</option>
                                    <option value="Married">Married</option>
                                    <option value="Divorced">Divorced</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Father's Name</label>
                                <input type="text" id="wizFatherName" name="fatherName" class="form-control" placeholder="Father's Full Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Mother's Name</label>
                                <input type="text" id="wizMotherName" name="motherName" class="form-control" placeholder="Mother's Full Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Signature *</label>
                                <input type="email" id="wizEmail" name="email" class="form-control" placeholder="name@domain.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Signature * (10 Digits)</label>
                                <input type="text" id="wizPhoneNo" name="phoneNo" class="form-control" placeholder="10 numeric digits" maxlength="10">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Alternate Phone Number</label>
                                <input type="text" id="wizAltPhoneNo" name="altPhoneNo" class="form-control" placeholder="Alternate Phone">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nationality</label>
                                <input type="text" id="wizNationality" name="nationality" class="form-control" value="Indian">
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">Residential Address *</label>
                                <input type="text" id="wizAddress" name="address" class="form-control" placeholder="House/Flat No, Street, Area">
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">Permanent Address (Leave empty if same as residential)</label>
                                <input type="text" id="wizPermAddress" name="permAddress" class="form-control" placeholder="Permanent Address">
                            </div>
                            <div class="form-group">
                                <label class="form-label">City *</label>
                                <input type="text" id="wizCity" name="city" class="form-control" placeholder="City">
                            </div>
                            <div class="form-group">
                                <label class="form-label">State *</label>
                                <input type="text" id="wizState" name="state" class="form-control" placeholder="State">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Zip Code *</label>
                                <input type="text" id="wizZipCode" name="zipCode" class="form-control" placeholder="6 Digits" maxlength="6">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Occupation</label>
                                <input type="text" id="wizOccupation" name="occupation" class="form-control" placeholder="Business, Salaried, Student">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Annual Income (₹)</label>
                                <input type="number" id="wizAnnualIncome" name="annualIncome" class="form-control" value="0.00" step="0.01">
                            </div>
                            <div class="form-group">
                                <label class="form-label">PAN Card *</label>
                                <input type="text" id="wizPanCard" name="panCard" class="form-control" placeholder="ABCDE1234F">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Aadhaar Card * (12 Digits)</label>
                                <input type="text" id="wizAadhaarCard" name="aadhaarCard" class="form-control" placeholder="12 numeric digits" maxlength="12">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Customer Avatar Photo</label>
                                <input type="file" id="wizPrimaryAvatarFile" name="primaryAvatarFile" class="form-control" accept="image/*">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 3 (Option A): Joint Holder Signatory Details (Savings Joint Only) -->
                    <div id="wizardStepJointHolder" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Joint Holder Signatory Details</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Register a new joint customer or select an existing customer signatory.</p>
                        
                        <div class="form-group" style="margin-bottom: 20px; max-width: 300px;">
                            <label class="form-label">Joint signatory Mode *</label>
                            <select id="wizJointCustomerMode" name="jointCustomerMode" class="form-control" onchange="toggleJointModeFields()">
                                <option value="existing" selected>Link Existing Customer</option>
                                <option value="new">Register New Customer Profile</option>
                            </select>
                        </div>

                        <!-- Existing selector -->
                        <div id="wizJointExistingSelector" style="background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md);">
                            <div class="form-group">
                                <label class="form-label">Select Registered Customer Signatory *</label>
                                <select id="wizJointCustomerId" name="jointCustomerId" class="form-control" style="cursor: pointer;">
                                    <option value="">-- Choose Customer --</option>
                                    <c:forEach var="cust" items="${customers}">
                                        <option value="${cust.customerId}">ID: ${cust.customerId} - ${cust.firstName} ${cust.lastName} (PAN: ${cust.panCard})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Brand new profile -->
                        <div id="wizJointNewFields" style="display: none; flex-direction: column; gap: 15px;">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label class="form-label">First Name *</label>
                                    <input type="text" id="wizJointFirstName" name="jointFirstName" class="form-control" placeholder="First Name">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Last Name *</label>
                                    <input type="text" id="wizJointLastName" name="jointLastName" class="form-control" placeholder="Last Name">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Email Signature *</label>
                                    <input type="email" id="wizJointEmail" name="jointEmail" class="form-control" placeholder="joint@domain.com">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Phone Signature *</label>
                                    <input type="text" id="wizJointPhone" name="jointPhone" class="form-control" placeholder="10 Digits" maxlength="10">
                                </div>
                                <div class="form-group" style="grid-column: span 2;">
                                    <label class="form-label">Address *</label>
                                    <input type="text" id="wizJointAddress" name="jointAddress" class="form-control" placeholder="Address">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">City *</label>
                                    <input type="text" id="wizJointCity" name="jointCity" class="form-control" placeholder="City">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">State *</label>
                                    <input type="text" id="wizJointState" name="jointState" class="form-control" placeholder="State">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Zip Code *</label>
                                    <input type="text" id="wizJointZipCode" name="jointZipCode" class="form-control" placeholder="Zip Code" maxlength="6">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">PAN Card *</label>
                                    <input type="text" id="wizJointPan" name="jointPan" class="form-control" placeholder="ABCDE1234F">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Aadhaar Card (12 Digits) *</label>
                                    <input type="text" id="wizJointAadhaar" name="jointAadhaar" class="form-control" placeholder="Aadhaar Number" maxlength="12">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Joint Signatory Avatar Photo</label>
                                    <input type="file" id="wizJointAvatarFile" name="jointAvatarFile" class="form-control" accept="image/*">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 3 (Option B): Corporate Company Profile (Current Account Only) -->
                    <div id="wizardStepCompanyDetails" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Corporate Company Profile</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Enter the legal corporate parameters for company profile registration.</p>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label class="form-label">Company Registered Name *</label>
                                <input type="text" id="wizBusinessName" name="businessName" class="form-control" placeholder="Company Legal Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">GSTIN Identification Code *</label>
                                <input type="text" id="wizGstin" name="gstin" class="form-control" placeholder="22AAAAA0000A1Z5">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Overdraft Credit Limit (₹) *</label>
                                <input type="number" id="wizOverdraftLimit" name="overdraftLimit" class="form-control" value="100000.00" step="0.01">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Company Category *</label>
                                <select id="wizCompanyCategory" name="companyCategory" class="form-control">
                                    <option value="Proprietorship">Proprietorship</option>
                                    <option value="Partnership">Partnership Firm</option>
                                    <option value="LLP">Limited Liability Partnership</option>
                                    <option value="PvtLtd" selected>Private Limited Company</option>
                                    <option value="PublicLtd">Public Limited Company</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Email Address *</label>
                                <input type="email" id="wizCompanyEmail" name="companyEmail" class="form-control" placeholder="info@company.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Phone *</label>
                                <input type="text" id="wizCompanyPhone" name="companyPhone" class="form-control" placeholder="Corporate Contact No">
                            </div>
                            <div class="form-group" style="grid-column: span 2;">
                                <label class="form-label">Registered Corporate Address *</label>
                                <input type="text" id="wizCompanyAddress" name="companyAddress" class="form-control" placeholder="HQ Address">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Company PAN Card Code *</label>
                                <input type="text" id="wizCompanyPan" name="companyPan" class="form-control" placeholder="ABCDE1234F">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Signatory Aadhaar *</label>
                                <input type="text" id="wizCompanyAadhaar" name="companyAadhaar" class="form-control" placeholder="Aadhaar ID" maxlength="12">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 4 (Option B): Partner Signatories Configuration (Current Account Only) -->
                    <div id="wizardStepPartnerDetails" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Partner Signatories Configuration</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Register other partner signatories allowed to operate this ledger counter.</p>
                        
                        <div id="partnerListContainer" style="margin-bottom: 20px;">
                            <!-- Appended dynamically by JS addPartnerCard() -->
                        </div>
                        
                        <button type="button" class="btn btn-secondary" onclick="addPartnerCard()" style="border-style: dashed; width: 100%; padding: 12px; display: inline-flex; justify-content: center; align-items: center; gap: 8px; color: var(--primary-500); border-color: var(--primary-500); background: transparent; font-weight: 600;">
                            <i class="bx bx-plus"></i> Add Partner Signatory Profile
                        </button>
                    </div>

                    <!-- STEP 5: Nominee Configuration (Savings Only) -->
                    <div id="wizardStepNominee" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Nominee Configuration</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Declare nominee properties and set daily ATM limit configuration.</p>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label class="form-label">Nominee Person Name (Optional)</label>
                                <input type="text" id="wizNomineeName" name="nomineeName" class="form-control" placeholder="Nominee Full Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Daily ATM Withdrawal Limit (₹)</label>
                                <input type="number" id="wizDailyWithdrawalLimit" name="dailyWithdrawalLimit" class="form-control" value="50000.00" step="0.01">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 6: Premium 3D Service Preferences & ATM Card Customizer -->
                    <div id="wizardStepPreferences" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Premium Banking Services Preference</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Configure ATM debit/credit cards, cheque books, and cover booklets. Click visual elements to customize.</p>
                        
                        <!-- Checkbox switches -->
                        <div style="display: flex; gap: 30px; margin-bottom: 30px;" class="mobile-grid-1">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 600;">
                                <input type="checkbox" id="wizHasAtmCard" name="hasAtmCard" value="1" onchange="toggleCardOptionWiz()" style="width: 20px; height: 20px; cursor: pointer;"> Apply ATM Card
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 600;">
                                <input type="checkbox" id="wizHasChequeBook" name="hasChequeBook" value="1" onchange="toggleChequeOptionWiz()" style="width: 20px; height: 20px; cursor: pointer;"> Apply Cheque Book
                            </label>
                            <div id="wizPassbookCheckboxWrapper">
                                <label style="display: flex; align-items: center; gap: 8px; cursor: not-allowed; font-weight: 600;">
                                    <input type="checkbox" id="wizHasPassbook" name="hasPassbook" value="1" checked disabled style="width: 20px; height: 20px;"> Passbook Booklet (Default selected)
                                </label>
                            </div>
                        </div>

                        <!-- ATM options dropdowns -->
                        <div id="wizAtmCardDetails" style="display: none; gap: 20px; margin-bottom: 25px;">
                            <div class="form-group" style="flex: 1;">
                                <label class="form-label">ATM Card Class</label>
                                <select id="wizCardType" name="wizardCardType" class="form-control" onchange="syncWizAtmCardPreview()" style="cursor: pointer;">
                                    <option value="debit" selected>Sapphire Debit</option>
                                    <option value="credit">Royale Credit</option>
                                </select>
                            </div>
                            <div class="form-group" style="flex: 1;">
                                <label class="form-label">Payment Network Provider</label>
                                <select id="wizCardProvider" name="wizardCardProvider" class="form-control" onchange="syncWizAtmCardPreview()" style="cursor: pointer;">
                                    <option value="visa" selected>Visa Secure</option>
                                    <option value="mastercard">Mastercard ID</option>
                                    <option value="rupay">RuPay Global</option>
                                </select>
                            </div>
                        </div>

                        <!-- Dynamic 3D Selector Showcase Grid -->
                        <div class="showcase-grid-3d">
                            <!-- 3D Card Showcase -->
                            <div class="showcase-item-3d">
                                <span style="font-weight: 700; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; margin-bottom: 12px; display: block;">3D ATM Card Model</span>
                                <div id="wizAtmTiltWrapper" class="card-3d-scene" onclick="toggleWizAtmSelection()" style="width: 320px; height: 200px;">
                                    <div id="wizAtmPreviewCard" class="vgb-atm-card debit inactive-card interactive" onclick="event.stopPropagation(); flipWizAtmCard()">
                                        <!-- Front -->
                                        <div class="card-face card-front">
                                            <div style="display: flex; justify-content: space-between; align-items: center; background: transparent;">
                                                <span id="wizProviderLabel" style="font-size: 1.25rem; font-weight: 800; letter-spacing: 0.5px; font-style: italic;">VISA</span>
                                                <div style="width: 38px; height: 28px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); border-radius: 4px;"></div>
                                            </div>
                                            <div id="wizNumberLabel" style="font-family: monospace; font-size: 1.15rem; letter-spacing: 1.5px; font-weight: 600; margin: 15px 0 5px;">4589  7321  6048  2190</div>
                                            <div style="display: flex; justify-content: space-between; align-items: flex-end; background: transparent;">
                                                <div>
                                                    <span style="font-size: 0.5rem; opacity: 0.7; display: block;">Card Holder</span>
                                                    <span id="wizHolderLabel" style="font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">NEW HOLDER</span>
                                                </div>
                                                <span style="font-size: 0.85rem; font-weight: 800; font-style: italic;">VGB</span>
                                            </div>
                                        </div>
                                        <!-- Back -->
                                        <div class="card-face card-back">
                                            <div style="height: 35px; background: #000; margin: 0 -20px;"></div>
                                            <div style="background: rgba(255, 255, 255, 0.9); height: 30px; border-radius: 4px; display: flex; align-items: center; justify-content: flex-end; padding-right: 10px;">
                                                <span id="wizCvv" style="font-family: monospace; font-size: 0.85rem; font-weight: 700; color: #334155;" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV">•••</span>
                                            </div>
                                            <div style="font-size: 0.45rem; opacity: 0.6; text-align: center;">VGB Bank Customer Support support@vgb.com</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3D Cheque Showcase -->
                            <div class="showcase-item-3d">
                                <span style="font-weight: 700; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; margin-bottom: 12px; display: block;">3D Cheque Model</span>
                                <div onclick="toggleWizChequeSelection()">
                                    <div id="wizChequePreviewCard" class="vgb-cheque-3d inactive-card" onclick="event.stopPropagation(); flipWizServiceCard('wizChequePreviewCard')">
                                        <div class="cheque-hologram"></div>
                                        <div class="cheque-header">
                                            <span class="cheque-bank-name"><i class="bx bx-shield-quarter"></i> VERTEX GALAXY BANK</span>
                                            <div class="cheque-date-box">
                                                <div class="date-squares">
                                                    <span>0</span><span>5</span><span>0</span><span>6</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="cheque-row" style="margin-top: 10px;">
                                            <span class="cheque-label">Pay</span>
                                            <span class="cheque-line-fill">SELF OR BEARER</span>
                                        </div>
                                        <div class="cheque-row">
                                            <span class="cheque-label">Rupees</span>
                                            <span class="cheque-line-fill">INITIAL FUNDING DEPOSIT</span>
                                            <div class="cheque-amount-box">
                                                <span style="font-weight: 800; border-right: 1px solid #1e3a8a; padding-right: 3px; margin-right: 3px;">₹</span>
                                                <span style="font-family: monospace; font-weight: 700; margin-left: auto;">1,000.00</span>
                                            </div>
                                        </div>
                                        <div class="cheque-details-row">
                                            <div class="cheque-acc-box">A/C No: 100098481827</div>
                                            <div class="cheque-sign-area">
                                                <span class="cheque-sign-name">Authorized</span>
                                            </div>
                                        </div>
                                        <div class="cheque-micr-band">⑈000076⑈ 360240005⑆</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 3D Passbook Showcase -->
                            <div class="showcase-item-3d" id="wizPassbookPreviewContainer">
                                <span style="font-weight: 700; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; margin-bottom: 12px; display: block;">3D Passbook Model</span>
                                <div id="wizPassbookPreviewCard" class="vgb-passbook-3d" onclick="flipWizServiceCard('wizPassbookPreviewCard')">
                                    <!-- Front cover page -->
                                    <div class="card-face card-front">
                                        <h4 style="font-size: 1.15rem; font-weight: 800; letter-spacing: 1px; color: #fbbf24;"><i class="bx bx-shield-quarter"></i> VGB</h4>
                                        <p style="font-size: 0.65rem; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px; margin-top: 4px;">Savings Account Passbook</p>
                                        <div style="width: 35px; height: 35px; border: 1.5px solid #fbbf24; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-top: 15px; color: #fbbf24; font-size: 1.15rem;">
                                            <i class="bx bx-star"></i>
                                        </div>
                                    </div>
                                    <!-- Back info page -->
                                    <div class="card-face card-back">
                                        <h5 style="font-size: 0.75rem; font-weight: 700; border-bottom: 1px solid #cbd5e1; padding-bottom: 4px; margin-bottom: 8px;">Signatory Info</h5>
                                        <p style="font-size: 0.6rem; color: #64748b; line-height: 1.4;">
                                            This Passbook contains physical transaction ledgers. Please present it at the counter for printing updates.
                                        </p>
                                        <p style="font-size: 0.6rem; color: #64748b; margin-top: 8px;">
                                            <strong>Customer Care:</strong> 1800-VGB-BANK<br>
                                            <strong>Branch code:</strong> RAJKOT MAIN (0171)
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 7: Security Credentials & Login Setup -->
                    <div id="wizardStepCredentials" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Security Credentials Configuration</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Create login credentials. The secure security PIN is auto-generated.</p>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label class="form-label">Login Username *</label>
                                <input type="text" id="wizUsername" name="username" class="form-control" placeholder="Choose unique username">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Master Password *</label>
                                <input type="password" id="wizPassword" name="password" class="form-control" placeholder="At least 8 characters">
                            </div>
                            <div class="form-group" style="grid-column: span 2; display: flex; align-items: center; gap: 15px; background: rgba(16, 185, 129, 0.03); border: 1px solid rgba(16, 185, 129, 0.1); border-radius: var(--radius-md); padding: 15px;">
                                <div style="width: 45px; height: 45px; border-radius: 50%; background: rgba(16, 185, 129, 0.1); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; color: #10b981;">
                                    <i class="bx bx-key"></i>
                                </div>
                                <div>
                                    <span style="font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 500; display: block;">Programmatic Auto-Generated Secure PIN</span>
                                    <strong id="wizAutoPinLabel" style="font-size: 1.25rem; color: #10b981; font-family: monospace; letter-spacing: 2px;">9021</strong>
                                    <!-- Hidden input to submit with form -->
                                    <input type="hidden" id="wizPin" name="pin">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 8: Initial Ledger Funding Deposit -->
                    <div id="wizardStepFunding" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Initial Ledger Funding Deposit</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Deposit initial funding to activate the account. Pay more but not less than target amount.</p>
                        
                        <div class="form-group" style="max-width: 350px;">
                            <label class="form-label">Initial Deposit Amount (₹) *</label>
                            <input type="number" id="wizInitialDeposit" name="initialDeposit" class="form-control" style="font-size: 1.15rem; font-weight: 700; color: var(--primary-500);" step="0.01">
                            <span id="wizMinDepositLabel" style="font-size: 0.72rem; color: var(--gray-400); font-weight: 500; margin-top: 5px; display: block;">₹1,000.00 Minimum Fixed Amount</span>
                        </div>
                    </div>

                    <!-- STEP 9: Summary & Final Review -->
                    <div id="wizardStepSummary" class="wizard-step-pane">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Onboarding summary & Review</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 15px;">Please verify all primary demographic and preferences data before confirming.</p>
                        
                        <div id="wizardSummaryContainer" style="display: flex; flex-direction: column; gap: 15px;">
                            <!-- Populated dynamically by JS renderWizardSummary() -->
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" id="wizBackBtn" class="btn btn-secondary" onclick="navigateWizardStep(-1)" style="margin-top:0;">Back</button>
                    <button type="button" id="wizNextBtn" class="btn btn-primary" onclick="navigateWizardStep(1)" style="margin-top:0;">Next Step</button>
                    <button type="submit" id="wizSubmitBtn" class="btn btn-primary" style="margin-top:0; display: none; background: #10b981; border-color: #10b981;">Finish & Create Account</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Inject context path for JS -->
    <script>
        window.VGB_CONTEXT_PATH = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/assest/js/script.js?v=2.6"></script>
</body>
</html>
