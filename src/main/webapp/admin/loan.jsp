<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>VGB | Admin Loan Review</title>
                <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
                <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
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
                        transition: background-color 0.3s ease, color 0.3s ease;
                    }
                    
                    body.dark-mode {
                        --glass-bg: rgba(30, 41, 59, 0.45);
                        --glass-border: rgba(255, 255, 255, 0.08);
                        --card-glow: rgba(99, 102, 241, 0.1);
                        --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
                        background-color: #0f172a !important;
                    }

                    /* Preloader override */
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
                        align-items: center;
                        justify-content: center;
                        width: 40px;
                        height: 40px;
                        font-size: 1.5rem;
                        color: var(--gray-700);
                        border-radius: var(--radius-sm);
                        background: rgba(99, 102, 241, 0.05);
                        border: 1px solid rgba(99, 102, 241, 0.1);
                        transition: all 0.3s ease;
                    }
                    
                    body.dark-mode .mobile-nav-toggle {
                        color: var(--gray-300) !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                        background: rgba(255, 255, 255, 0.02);
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

                    /* Print Optimized CSS */
                    @media print {
                        body {
                            background: white !important;
                            color: black !important;
                        }

                        .sidebar,
                        .header,
                        .footer,
                        .no-print,
                        aside {
                            display: none !important;
                        }

                        .main-content {
                            margin-left: 0 !important;
                            padding: 0 !important;
                            width: 100% !important;
                            max-width: 100% !important;
                        }

                        #statementModal {
                            position: relative !important;
                            background: transparent !important;
                            background-color: transparent !important;
                            backdrop-filter: none !important;
                            display: block !important;
                            padding: 0 !important;
                            z-index: auto !important;
                            overflow: visible !important;
                            width: 100% !important;
                            max-width: 100% !important;
                            margin: 0 !important;
                        }

                        #statementModal .modal-card {
                            max-width: 100% !important;
                            max-height: none !important;
                            overflow: visible !important;
                            box-shadow: none !important;
                            border: none !important;
                            padding: 0 !important;
                            margin: 0 !important;
                            background: transparent !important;
                            background-color: transparent !important;
                        }

                        .statement-print-area {
                            width: 100% !important;
                            padding: 0 !important;
                            margin: 0 !important;
                        }

                        /* Collapse grid columns to full-width stacked blocks in print */
                        .mobile-grid-1 {
                            display: block !important;
                        }

                        .mobile-grid-1>div {
                            width: 100% !important;
                            margin-bottom: 20px !important;
                        }

                        /* Enforce visible overflows to avoid horizontal table truncation */
                        div {
                            overflow: visible !important;
                        }

                        /* Table layout fixes to prevent squishing of column headers */
                        table {
                            width: 100% !important;
                            table-layout: auto !important;
                            border-collapse: collapse !important;
                        }

                        th,
                        td {
                            word-wrap: break-word !important;
                            white-space: normal !important;
                        }

                        .print-only {
                            display: flex !important;
                        }
                    }

                    .print-only {
                        display: none;
                    }

                    /* --- TAB BUTTONS --- */
                    .tab-btn {
                        background: var(--glass-bg) !important;
                        color: var(--gray-600) !important;
                        border: 1px solid rgba(99, 102, 241, 0.15) !important;
                        box-shadow: var(--shadow-sm);
                        cursor: pointer;
                        transition: all var(--transition-normal);
                        backdrop-filter: blur(20px);
                        -webkit-backdrop-filter: blur(20px);
                    }

                    body.dark-mode .tab-btn {
                        color: var(--gray-400) !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                        background: rgba(30, 41, 59, 0.45) !important;
                    }

                    .tab-btn:hover {
                        background: rgba(99, 102, 241, 0.05) !important;
                        color: var(--primary-500) !important;
                        transform: translateY(-2px);
                    }

                    body.dark-mode .tab-btn:hover {
                        background: rgba(255, 255, 255, 0.02) !important;
                        color: white !important;
                    }

                    .tab-btn.active {
                        background: var(--gradient-primary) !important;
                        color: white !important;
                        border-color: transparent !important;
                        box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25) !important;
                    }

                    /* Printable paper layout inside Admin View Modal */
                    .loan-paper-form {
                        background: #fff;
                        border: 1.5px solid var(--gray-200);
                        padding: 40px;
                        border-radius: var(--radius-sm);
                        color: #1e293b;
                        font-family: 'Times New Roman', Times, serif;
                        font-size: 0.95rem;
                        line-height: 1.6;
                        box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-lg);
                        position: relative;
                        max-width: 800px;
                        margin: 0 auto;
                        transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;
                    }

                    body.dark-mode .loan-paper-form {
                        background: #1e293b;
                        border-color: rgba(255, 255, 255, 0.08);
                        color: #cbd5e1;
                        box-shadow: var(--shadow-xl);
                    }

                    .loan-paper-form h1, .loan-paper-form h2, .loan-paper-form h3, .loan-paper-form h4 {
                        font-family: 'Poppins', sans-serif;
                        color: #0f172a;
                    }

                    body.dark-mode .loan-paper-form h1,
                    body.dark-mode .loan-paper-form h2,
                    body.dark-mode .loan-paper-form h3,
                    body.dark-mode .loan-paper-form h4 {
                        color: #f1f5f9;
                    }

                    .loan-paper-form h1 {
                        font-size: 1.5rem;
                        font-weight: 800;
                        text-align: center;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        border-bottom: 2px double #475569;
                        padding-bottom: 12px;
                        margin-bottom: 20px;
                    }

                    body.dark-mode .loan-paper-form h1 {
                        border-bottom-color: #64748b;
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

                    body.dark-mode .loan-paper-form h2 {
                        border-bottom-color: #475569;
                        color: #cbd5e1;
                    }

                    .loan-paper-form table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 15px;
                    }

                    .loan-paper-form td {
                        padding: 6px 0;
                        vertical-align: middle;
                    }

                    .loan-paper-form input[type="text"], .loan-paper-form input[type="date"], .loan-paper-form input[type="number"], .loan-paper-form select, .loan-paper-form textarea {
                        border: none;
                        border-bottom: 1px dotted #475569 !important;
                        background: transparent;
                        font-weight: 600;
                        font-family: inherit;
                        font-size: inherit;
                        outline: none;
                        color: #0f172a;
                        width: 100%;
                        padding: 2px 5px;
                    }

                    body.dark-mode .loan-paper-form input[type="text"],
                    body.dark-mode .loan-paper-form input[type="date"],
                    body.dark-mode .loan-paper-form input[type="number"],
                    body.dark-mode .loan-paper-form select,
                    body.dark-mode .loan-paper-form textarea {
                        border-bottom-color: #64748b !important;
                        color: #f1f5f9;
                    }

                    /* --- INPUTS AND SELECTS --- */
                    .form-control, .control-select, .control-input {
                        width: 100%;
                        padding: 12px 15px;
                        border: 1.5px solid var(--gray-200);
                        border-radius: var(--radius-md);
                        background: white;
                        outline: none;
                        font-family: var(--font-family);
                        transition: all 0.3s ease;
                    }

                    body.dark-mode .form-control,
                    body.dark-mode .control-select,
                    body.dark-mode .control-input {
                        background: #0f172a !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                        color: white !important;
                    }

                    .form-control:focus, .control-select:focus, .control-input:focus {
                        border-color: var(--primary-500);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
                    }

                    /* Badge Monospace styling */
                    .badge-pending {
                        background: rgba(245, 158, 11, 0.12);
                        color: var(--accent-amber);
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                    }
                    .badge-approved {
                        background: rgba(16, 185, 129, 0.12);
                        color: var(--accent-emerald);
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                    }
                    .badge-rejected {
                        background: rgba(239, 68, 68, 0.12);
                        color: #ef4444;
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                    }
                    .badge-id {
                        font-family: monospace;
                        font-weight: 600;
                        letter-spacing: 0.5px;
                        background: rgba(99, 102, 241, 0.08);
                        color: var(--primary-600);
                        padding: 4px 8px;
                        border-radius: var(--radius-sm);
                        font-size: 0.8rem;
                    }
                    body.dark-mode .badge-id {
                        background: rgba(99, 102, 241, 0.15);
                        color: var(--primary-400);
                    }

                    /* --- PREMIUM MODERN TABLES --- */
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
                        border-bottom-color: rgba(255, 255, 255, 0.1);
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

                    /* --- RESPONSIVE WORKOUTS --- */
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

                    /* Glassmorphic Modal */
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
                        border-radius: var(--radius-lg);
                        box-shadow: 0 20px 50px rgba(0,0,0,0.3);
                        animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                        overflow: hidden;
                        max-height: 90vh;
                        display: flex;
                        flex-direction: column;
                    }
                    
                    body.dark-mode .modal-content {
                        background: rgba(15, 23, 42, 0.85) !important;
                        border: 1px solid rgba(255, 255, 255, 0.08) !important;
                    }

                    .modal-card {
                        background: rgba(255, 255, 255, 0.95) !important;
                        backdrop-filter: blur(25px) saturate(180%);
                        -webkit-backdrop-filter: blur(25px) saturate(180%);
                        border: 1px solid rgba(255, 255, 255, 0.5) !important;
                        box-shadow: var(--panel-shadow), var(--shadow-2xl) !important;
                        border-radius: var(--radius-lg);
                        padding: 35px;
                    }
                    body.dark-mode .modal-card {
                        background: rgba(15, 23, 42, 0.92) !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                    }

                    @keyframes modalScaleUp {
                        from { transform: scale(0.9) translateY(10px); opacity: 0; }
                        to { transform: scale(1) translateY(0); opacity: 1; }
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
                        color: var(--gray-900);
                    }
                    body.dark-mode .close-btn:hover {
                        color: white;
                    }

                    /* Admin View Modal specific print isolates */
                    @media print {
                        body.print-admin-active * {
                            visibility: hidden !important;
                        }
                        body.print-admin-active #adminViewModal,
                        body.print-admin-active #adminViewModal * {
                            visibility: visible !important;
                        }
                        body.print-admin-active #adminViewModal {
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
                        body.print-admin-active #adminViewModal .modal-content {
                            box-shadow: none !important;
                            border: none !important;
                            width: 100% !important;
                            max-width: 100% !important;
                            padding: 0 !important;
                            margin: 0 !important;
                            background: white !important;
                        }
                        body.print-admin-active #adminViewModal .modal-body {
                            overflow: visible !important;
                            max-height: none !important;
                            padding: 0 !important;
                        }
                        body.print-admin-active #adminViewModal .loan-paper-form {
                            border: none !important;
                            box-shadow: none !important;
                            padding: 0 !important;
                            width: 100% !important;
                            max-width: 100% !important;
                        }
                    }

                    .txn-deposit {
                        color: var(--accent-emerald) !important;
                    }
                    .txn-withdrawal {
                        color: var(--secondary-500) !important;
                    }
                </style>
            </head>

            <body class="bank-home-page" data-statement-loan-status="${statementLoan.status}">
                <div class="preloader">
                    <div class="loader">
                        <div class="loader-ring"></div>
                        <span>VGB</span>
                    </div>
                </div>

                <div class="cursor-glow"></div>

                <!-- Header -->
                <header class="header scrolled">
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                            <i class="bx bx-menu"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center;">
                            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
                        </a>
                    </div>
                    <div class="nav-actions">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <img src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary-500);">
                            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
                        </div>
                        <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary"
                            style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
                    </div>
                </header>

                <!-- Sidebar Navigation -->
                <aside class="sidebar">
                    <div class="sidebar-menu">
                        <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i>
                            Dashboard</a>
                        <a href="${pageContext.request.contextPath}/account?action=list"><i
                                class="bx bx-user-check"></i> Manage Accounts</a>
                        <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i
                                class="bx bx-transfer-alt"></i> Admin Counter</a>
                        <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
                        <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
                        <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
                        <a href="${pageContext.request.contextPath}/loan?action=list" class="active"><i
                                class="bx bx-building-house"></i> Review Loans</a>
                        <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My
                            Profile</a>

                    </div>
                    <div
                        style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
                        <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
                        <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">
                            INTERNAL USE ONLY</p>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <div class="container" style="max-width: 1200px; padding: 0;">
                        <div style="margin-bottom: 40px;" class="no-print">
                            <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">System Loan
                                Portfolios</h2>
                            <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Analyze credit
                                applications, execute disbursements, or reject failed file ratings.</p>
                        </div>

                        <!-- Alerts -->
                        <c:if test="${not empty error or not empty sessionScope.error}">
                            <div class="no-print"
                                style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                                <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                                <span>${not empty error ? error : sessionScope.error}</span>
                            </div>
                            <c:remove var="error" scope="session" />
                        </c:if>
                        <c:if test="${not empty success or not empty sessionScope.success}">
                            <div class="no-print"
                                style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                                <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                                <span>${not empty success ? success : sessionScope.success}</span>
                            </div>
                            <c:remove var="success" scope="session" />
                        </c:if>

                        <!-- Loan & Customer Search Filter -->
                        <div class="glass-card no-print"
                            style="padding: 15px 25px; margin-bottom: 25px; display: flex; align-items: center; gap: 15px;">
                            <div style="position: relative; flex: 1;">
                                <input type="text" id="loanSearchInput" onkeyup="filterLoanTables()"
                                    class="control-input"
                                    placeholder="Search loans by customer name, account number, phone number, or loan category..."
                                    style="padding-left: 45px; font-size: 0.9rem;">
                                <i class="bx bx-search"
                                    style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.35rem;"></i>
                            </div>
                        </div>

                        <!-- Interactive Tab buttons (no-print) -->
                        <div style="display: flex; gap: 15px; margin-bottom: 25px; flex-wrap: wrap;" class="no-print">
                            <button type="button" class="tab-btn active" onclick="switchTab('pending')" id="tab-pending"
                                style="padding: 12px 20px; font-family: var(--font-family); font-size: 0.9rem; font-weight: 600; border-radius: var(--radius-md); display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-time-five" style="font-size: 1.1rem;"></i>
                                <span>Pending Applications</span>
                                <span id="badge-pending"
                                    style="background: var(--primary-500); color: white; border-radius: var(--radius-full); padding: 2px 8px; font-size: 0.75rem; font-weight: 700;">0</span>
                            </button>
                            <button type="button" class="tab-btn" onclick="switchTab('approved')" id="tab-approved"
                                style="padding: 12px 20px; font-family: var(--font-family); font-size: 0.9rem; font-weight: 600; border-radius: var(--radius-md); display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-check-double" style="font-size: 1.1rem;"></i>
                                <span>Approved &amp; Active</span>
                                <span id="badge-approved"
                                    style="background: var(--accent-emerald); color: white; border-radius: var(--radius-full); padding: 2px 8px; font-size: 0.75rem; font-weight: 700;">0</span>
                            </button>
                            <button type="button" class="tab-btn" onclick="switchTab('closed')" id="tab-closed"
                                style="padding: 12px 20px; font-family: var(--font-family); font-size: 0.9rem; font-weight: 600; border-radius: var(--radius-md); display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-archive" style="font-size: 1.1rem;"></i>
                                <span>Closed &amp; History</span>
                                <span id="badge-closed"
                                    style="background: var(--gray-500); color: white; border-radius: var(--radius-full); padding: 2px 8px; font-size: 0.75rem; font-weight: 700;">0</span>
                            </button>
                            <button type="button" class="tab-btn" onclick="switchTab('payments')" id="tab-payments"
                                style="padding: 12px 20px; font-family: var(--font-family); font-size: 0.9rem; font-weight: 600; border-radius: var(--radius-md); display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-credit-card" style="font-size: 1.1rem;"></i>
                                <span>Repayment Logs</span>
                                <span id="badge-payments"
                                    style="background: var(--secondary-500); color: white; border-radius: var(--radius-full); padding: 2px 8px; font-size: 0.75rem; font-weight: 700;">0</span>
                            </button>
                        </div>

                        <!-- Tab Content 1: Pending Applications -->
                        <div class="glass-card loan-tab-content no-print" id="content-pending">
                            <h3
                                style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                                <i class="bx bx-time-five"></i> Pending Loan Applications
                            </h3>
                            <div class="table-responsive" style="overflow-x: auto; width: 100%;">
                                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr
                                            style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                            <th style="padding: 12px 15px; width: 80px;">Sr. No.</th>
                                            <th style="padding: 12px 15px;">Customer Name</th>
                                            <th style="padding: 12px 15px;">Category</th>
                                            <th style="padding: 12px 15px;">Principal</th>
                                            <th style="padding: 12px 15px;">Interest Rate</th>
                                            <th style="padding: 12px 15px;">Term Length</th>
                                            <th style="padding: 12px 15px; text-align: center;">Status</th>
                                            <th style="padding: 12px 15px; text-align: center;">Ledger</th>
                                            <th style="padding: 12px 15px; text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="pendingCount" value="0" />
                                        <c:forEach var="loan" items="${loans}">
                                            <c:if test="${loan.status == 'pending_approval'}">
                                                <c:set var="pendingCount" value="${pendingCount + 1}" />
                                                <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);"
                                                    data-customer-id="${loan.customerId}"
                                                    data-loan-category="${loan.loanType}"
                                                    data-customer-name="${customerNames[loan.customerId]}"
                                                    data-customer-phone="${customerPhones[loan.customerId]}">
                                                    <td
                                                        style="padding: 15px;"><span class="badge-id">#${pendingCount}</span></td>
                                                    <td
                                                        style="padding: 15px; font-weight: 600; color: var(--gray-900);">
                                                        ${customerNames[loan.customerId]}</td>
                                                    <td
                                                        style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                                        ${loan.loanType}</td>
                                                    <td style="padding: 15px; font-weight: 600;">₹
                                                        <fmt:formatNumber value="${loan.principalAmount}"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 15px;">${loan.interestRate}% P.A.</td>
                                                    <td style="padding: 15px;">${loan.termMonths} Months</td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <span
                                                            style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Pending</span>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <a href="${pageContext.request.contextPath}/loan?action=statement&id=${loan.loanId}"
                                                            class="btn btn-secondary"
                                                            style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-cyan); color: var(--accent-cyan);"><i
                                                                class="bx bx-file"></i> Statement</a>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <div style="display: flex; gap: 8px; justify-content: center;">
                                                            <button type="button" class="btn btn-secondary" onclick="openViewModal('${loan.loanId}', '${customerNames[loan.customerId]}', '${customerPhones[loan.customerId]}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'), '${loan.status}')" data-form-details="<c:out value="${loan.formDetails}" />" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500);"><i class="bx bx-show"></i> View</button>
                                                            <a href="${pageContext.request.contextPath}/loan?action=approve&id=${loan.loanId}"
                                                                class="btn btn-secondary"
                                                                style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-emerald); color: var(--accent-emerald);"><i
                                                                    class="bx bx-check"></i> Approve</a>
                                                            <a href="${pageContext.request.contextPath}/loan?action=reject&id=${loan.loanId}"
                                                                class="btn btn-secondary"
                                                                style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444;"><i
                                                                    class="bx bx-x"></i> Reject</a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${pendingCount == 0}">
                                            <tr>
                                                <td colspan="9"
                                                    style="text-align: center; padding: 30px; color: var(--gray-400);">
                                                    No pending loan applications registered.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Tab Content 2: Approved & Active -->
                        <div class="glass-card loan-tab-content no-print" id="content-approved" style="display: none;">
                            <h3
                                style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                                <i class="bx bx-check-double"></i> Approved and Active Loans
                            </h3>
                            <div class="table-responsive" style="overflow-x: auto; width: 100%;">
                                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr
                                            style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                            <th style="padding: 12px 15px; width: 80px;">Sr. No.</th>
                                            <th style="padding: 12px 15px;">Customer Name</th>
                                            <th style="padding: 12px 15px;">Category</th>
                                            <th style="padding: 12px 15px;">Principal</th>
                                            <th style="padding: 12px 15px;">Remaining Balance</th>
                                            <th style="padding: 12px 15px; text-align: right;">Monthly EMI</th>
                                            <th style="padding: 12px 15px;">Maturity Date</th>
                                            <th style="padding: 12px 15px;">Term Length</th>
                                            <th style="padding: 12px 15px; text-align: center;">Status</th>
                                            <th style="padding: 12px 15px; text-align: center;">Ledger</th>
                                            <th style="padding: 12px 15px; text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="approvedCount" value="0" />
                                        <c:forEach var="loan" items="${loans}">
                                            <c:if
                                                test="${loan.status == 'approved' or loan.status == 'disbursed' or loan.status == 'active'}">
                                                <c:set var="approvedCount" value="${approvedCount + 1}" />
                                                <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);"
                                                    data-customer-id="${loan.customerId}"
                                                    data-loan-category="${loan.loanType}"
                                                    data-customer-name="${customerNames[loan.customerId]}"
                                                    data-customer-phone="${customerPhones[loan.customerId]}">
                                                    <td
                                                        style="padding: 15px;"><span class="badge-id">#${approvedCount}</span></td>
                                                    <td
                                                        style="padding: 15px; font-weight: 600; color: var(--gray-900);">
                                                        ${customerNames[loan.customerId]}</td>
                                                    <td
                                                        style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                                        ${loan.loanType}</td>
                                                    <td style="padding: 15px; font-weight: 600;">₹
                                                        <fmt:formatNumber value="${loan.principalAmount}"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 15px; font-weight: 600; color: #ef4444;">₹
                                                        <fmt:formatNumber value="${loan.remainingBalance}"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 15px; font-weight: 600; text-align: right;">₹
                                                        <fmt:formatNumber value="${loan.monthlyEMI}"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 15px;">
                                                        <c:choose>
                                                            <c:when test="${not empty loan.endDate}">
                                                                ${loan.endDate}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    style="color: var(--gray-400); font-style: italic;">Pending
                                                                    Approval</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding: 15px;">${loan.termMonths} Months</td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <c:choose>
                                                            <c:when test="${loan.status == 'approved'}">
                                                                <span
                                                                    style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Approved</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Active</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <a href="${pageContext.request.contextPath}/loan?action=statement&id=${loan.loanId}"
                                                            class="btn btn-secondary"
                                                            style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-cyan); color: var(--accent-cyan);"><i
                                                                class="bx bx-file"></i> Statement</a>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <div style="display: flex; gap: 8px; justify-content: center;">
                                                            <c:if test="${loan.status == 'approved'}">
                                                                <button type="button" class="btn btn-secondary"
                                                                    onclick="openDisburseModal('${loan.loanId}', '${loan.customerId}', '${loan.principalAmount}')"
                                                                    style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500);"><i
                                                                        class="bx bx-wallet"></i> Disburse</button>
                                                            </c:if>
                                                            <c:if
                                                                test="${loan.status == 'active' or loan.status == 'disbursed'}">
                                                                <button type="button" class="btn btn-secondary"
                                                                    onclick="openRepayModal('${loan.loanId}', '${loan.customerId}', '${loan.remainingBalance}')"
                                                                    style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-amber); color: var(--accent-amber);"><i
                                                                        class="bx bx-wallet-alt"></i> Repay</button>
                                                            </c:if>
                                                            <button type="button" class="btn btn-secondary" onclick="openViewModal('${loan.loanId}', '${customerNames[loan.customerId]}', '${customerPhones[loan.customerId]}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'), '${loan.status}')" data-form-details="<c:out value="${loan.formDetails}" />" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500);"><i class="bx bx-show"></i> View</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${approvedCount == 0}">
                                            <tr>
                                                <td colspan="11"
                                                    style="text-align: center; padding: 30px; color: var(--gray-400);">
                                                    No approved or active loans found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Tab Content 3: Closed & History -->
                        <div class="glass-card loan-tab-content no-print" id="content-closed" style="display: none;">
                            <h3
                                style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                                <i class="bx bx-archive"></i> Closed &amp; Archived Loans
                            </h3>
                            <div class="table-responsive" style="overflow-x: auto; width: 100%;">
                                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr
                                            style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                            <th style="padding: 12px 15px; width: 80px;">Sr. No.</th>
                                            <th style="padding: 12px 15px;">Customer Name</th>
                                            <th style="padding: 12px 15px;">Category</th>
                                            <th style="padding: 12px 15px;">Principal Amount</th>
                                            <th style="padding: 12px 15px;">Remaining Balance</th>
                                            <th style="padding: 12px 15px;">Term Length</th>
                                            <th style="padding: 12px 15px; text-align: center;">Status</th>
                                            <th style="padding: 12px 15px; text-align: center;">Ledger</th>
                                            <th style="padding: 12px 15px; text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="closedCount" value="0" />
                                        <c:forEach var="loan" items="${loans}">
                                            <c:if
                                                test="${loan.status == 'closed' or loan.status == 'rejected' or loan.status == 'defaulted'}">
                                                <c:set var="closedCount" value="${closedCount + 1}" />
                                                <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);"
                                                    data-customer-id="${loan.customerId}"
                                                    data-loan-category="${loan.loanType}"
                                                    data-customer-name="${customerNames[loan.customerId]}"
                                                    data-customer-phone="${customerPhones[loan.customerId]}">
                                                    <td
                                                        style="padding: 15px;"><span class="badge-id">#${closedCount}</span></td>
                                                    <td
                                                        style="padding: 15px; font-weight: 600; color: var(--gray-900);">
                                                        ${customerNames[loan.customerId]}</td>
                                                    <td
                                                        style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                                        ${loan.loanType}</td>
                                                    <td style="padding: 15px; font-weight: 600;">₹
                                                        <fmt:formatNumber value="${loan.principalAmount}"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 15px; font-weight: 600;">₹
                                                        <fmt:formatNumber value="${loan.remainingBalance}"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </td>
                                                    <td style="padding: 15px;">${loan.termMonths} Months</td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <c:choose>
                                                            <c:when test="${loan.status == 'closed'}">
                                                                <span
                                                                    style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Closed</span>
                                                            </c:when>
                                                            <c:when test="${loan.status == 'rejected'}">
                                                                <span
                                                                    style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Rejected</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    style="background: rgba(239, 68, 68, 0.2); color: #b91c1c; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">${loan.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <a href="${pageContext.request.contextPath}/loan?action=statement&id=${loan.loanId}"
                                                            class="btn btn-secondary"
                                                            style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-cyan); color: var(--accent-cyan);"><i
                                                                class="bx bx-file"></i> Statement</a>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <div style="display: flex; gap: 8px; justify-content: center;">
                                                            <button type="button" class="btn btn-secondary" onclick="openViewModal('${loan.loanId}', '${customerNames[loan.customerId]}', '${customerPhones[loan.customerId]}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'), '${loan.status}')" data-form-details="<c:out value="${loan.formDetails}" />" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500);"><i class="bx bx-show"></i> View</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${closedCount == 0}">
                                            <tr>
                                                <td colspan="9"
                                                    style="text-align: center; padding: 30px; color: var(--gray-400);">
                                                    No closed or archived loans found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Tab Content 4: Repayment Logs -->
                        <div class="glass-card loan-tab-content no-print" id="content-payments" style="display: none;">
                            <h3
                                style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                                <i class="bx bx-credit-card"></i> Loan Repayment Ledger
                            </h3>
                            <div class="table-responsive" style="overflow-x: auto; width: 100%;">
                                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr
                                            style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                            <th style="padding: 12px 15px; width: 80px;">Sr. No.</th>
                                            <th style="padding: 12px 15px;">Customer Name</th>
                                            <th style="padding: 12px 15px;">Amount Paid</th>
                                            <th style="padding: 12px 15px;">Principal Component</th>
                                            <th style="padding: 12px 15px;">Interest Component</th>
                                            <th style="padding: 12px 15px;">Date Paid</th>
                                            <th style="padding: 12px 15px; text-align: center;">Ledger</th>
                                            <th style="padding: 12px 15px; text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="paymentsCount" value="0" />
                                        <c:forEach var="pay" items="${repayments}">
                                            <c:set var="paymentsCount" value="${paymentsCount + 1}" />
                                            <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);"
                                                data-customer-id="${pay.customerId}"
                                                data-customer-name="${customerNames[pay.customerId]}"
                                                data-customer-phone="${customerPhones[pay.customerId]}"
                                                data-loan-id="${pay.loanId}">
                                                <td style="padding: 15px;"><span class="badge-id">#${paymentsCount}</span></td>
                                                <td style="padding: 15px; font-weight: 600; color: var(--gray-900);">
                                                    ${customerNames[pay.customerId]}</td>
                                                <td
                                                    style="padding: 15px; font-weight: 600; color: var(--accent-emerald);">
                                                    ₹
                                                    <fmt:formatNumber value="${pay.amountPaid}" minFractionDigits="2"
                                                        maxFractionDigits="2" />
                                                </td>
                                                <td style="padding: 15px; color: var(--gray-600);">₹
                                                    <fmt:formatNumber value="${pay.principalComponent}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </td>
                                                <td style="padding: 15px; color: var(--gray-500);">₹
                                                    <fmt:formatNumber value="${pay.interestComponent}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </td>
                                                <td style="padding: 15px;">${pay.formattedRepaymentDate}</td>
                                                <td style="padding: 15px; text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/loan?action=statement&id=${pay.loanId}"
                                                        class="btn btn-secondary"
                                                        style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-cyan); color: var(--accent-cyan);"><i
                                                            class="bx bx-file"></i> Statement</a>
                                                </td>
                                                <td style="padding: 15px; text-align: center;">
                                                    <div style="display: flex; gap: 8px; justify-content: center;">
                                                        <a href="${pageContext.request.contextPath}/loan?action=statement&id=${pay.loanId}"
                                                            class="btn btn-secondary"
                                                            style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500);"><i
                                                                class="bx bx-show"></i> View</a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${paymentsCount == 0}">
                                            <tr>
                                                <td colspan="8"
                                                    style="text-align: center; padding: 30px; color: var(--gray-400);">
                                                    No repayments recorded.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Disburse Loan Modal Overlay -->
                        <div id="disburseModal"
                            style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; padding: 20px;"
                            class="no-print">
                            <div class="modal-card"
                                style="width: 100%; max-width: 500px; position: relative; margin-bottom: 0;">
                                <button type="button" onclick="closeDisburseModal()" class="close-btn"
                                    style="position: absolute; top: 25px; right: 25px; font-size: 1.5rem; line-height: 1;"><i
                                        class="bx bx-x"></i></button>

                                <h3
                                    style="font-size: 1.3rem; font-weight: 700; color: var(--gray-900); margin-bottom: 25px; display: flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-wallet" style="color: var(--primary-500); font-size: 1.5rem;"></i> Execute Loan Disbursement
                                </h3>
                                <form action="${pageContext.request.contextPath}/loan?action=disburse" method="post"
                                    id="disburseForm">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                    <input type="hidden" name="id" id="disburseLoanId">

                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="disburseAmount"
                                            style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Disbursement
                                            Amount (₹)</label>
                                        <input type="text" id="disburseAmount" readonly class="control-input"
                                            style="font-weight: 700; color: var(--gray-900); background: rgba(99, 102, 241, 0.04); border-color: rgba(99, 102, 241, 0.15);">
                                    </div>

                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="disburseAccount"
                                            style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Select
                                            Target Customer Account</label>
                                        <select name="accountId" id="disburseAccount" required class="control-select" style="font-weight: 500;">
                                            <option value="">-- Select Active Account --</option>
                                        </select>
                                        <span
                                            style="font-size: 0.75rem; color: var(--gray-400); display: block; margin-top: 6px; line-height: 1.4;">Only
                                            active checking or savings accounts owned by this customer will be
                                            listed.</span>
                                    </div>

                                    <div style="display: flex; gap: 15px; justify-content: flex-end; margin-top: 30px;">
                                        <button type="button" class="btn btn-secondary" onclick="closeDisburseModal()"
                                            style="background: transparent !important; border: none !important; color: var(--gray-600) !important; padding: 10px 24px; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; transition: color 0.2s ease;">Cancel</button>
                                        <button type="submit" class="btn btn-primary"
                                            style="background: var(--gradient-primary) !important; border: none !important; color: white !important; padding: 10px 24px; font-weight: 700; border-radius: var(--radius-full); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25); transition: all 0.3s ease;">
                                            <span>Transfer Funds</span>
                                            <i class="bx bx-check-double" style="font-size: 1.1rem;"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Repay Loan Modal Overlay -->
                        <div id="repayModal"
                            style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; padding: 20px;"
                            class="no-print">
                            <div class="modal-card"
                                style="width: 100%; max-width: 500px; position: relative; margin-bottom: 0;">
                                <button type="button" onclick="closeRepayModal()" class="close-btn"
                                    style="position: absolute; top: 25px; right: 25px; font-size: 1.5rem; line-height: 1;"><i
                                        class="bx bx-x"></i></button>

                                <h3
                                    style="font-size: 1.3rem; font-weight: 700; color: var(--gray-900); margin-bottom: 25px; display: flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-wallet-alt" style="color: var(--primary-500); font-size: 1.5rem;"></i> Execute Loan Repayment
                                </h3>
                                <form action="${pageContext.request.contextPath}/loan?action=repayment" method="post"
                                    id="repayForm">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                    <input type="hidden" name="loanId" id="repayLoanId">
                                    <input type="hidden" name="customerId" id="repayCustomerId">

                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="repayRemaining"
                                            style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Remaining
                                            Balance (₹)</label>
                                        <input type="text" id="repayRemaining" readonly class="control-input"
                                            style="font-weight: 700; color: var(--gray-900); background: rgba(99, 102, 241, 0.04); border-color: rgba(99, 102, 241, 0.15);">
                                    </div>

                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label for="repayAccount"
                                            style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Select
                                            Customer Account to Debit</label>
                                        <select name="accountId" id="repayAccount" required class="control-select" style="font-weight: 500;">
                                            <option value="">-- Select Active Account --</option>
                                        </select>
                                    </div>

                                    <div class="form-group" style="margin-bottom: 25px;">
                                        <label for="repayAmount"
                                            style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Repayment
                                            Amount (₹)</label>
                                        <input type="number" step="0.01" min="1" name="amount" id="repayAmount" required
                                            placeholder="E.g., 5000" class="control-input" style="font-weight: 600;">
                                    </div>

                                    <div style="display: flex; gap: 15px; justify-content: flex-end; margin-top: 30px;">
                                        <button type="button" class="btn btn-secondary" onclick="closeRepayModal()"
                                            style="background: transparent !important; border: none !important; color: var(--gray-600) !important; padding: 10px 24px; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; transition: color 0.2s ease;">Cancel</button>
                                        <button type="submit" class="btn btn-primary"
                                            style="background: var(--gradient-primary) !important; border: none !important; color: white !important; padding: 10px 24px; font-weight: 700; border-radius: var(--radius-full); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25); transition: all 0.3s ease;">
                                            <span>Process Repayment</span>
                                            <i class="bx bx-check-double" style="font-size: 1.1rem;"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Loan Statement Modal Overlay -->
                        <c:if test="${not empty statementLoan}">
                            <c:set var="totalRepaid" value="0.0" />
                            <c:if test="${not empty statementRepayments}">
                                <c:forEach var="rpy" items="${statementRepayments}">
                                    <c:set var="totalRepaid" value="${totalRepaid + rpy.amountPaid}" />
                                </c:forEach>
                            </c:if>
                            <div id="statementModal"
                                style="display: flex; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; padding: 20px;">
                                <div class="modal-card"
                                    style="width: 100%; max-width: 900px; max-height: 90vh; overflow-y: auto; position: relative; margin-bottom: 0;">
                                    <!-- Close button in modal (hidden in print) -->
                                    <button type="button" onclick="closeStatementModal()" class="close-btn"
                                        style="position: absolute; top: 25px; right: 25px; font-size: 1.5rem; line-height: 1;"><i
                                            class="bx bx-x"></i></button>

                                    <!-- Header (Print/Download Option, hidden in print) -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;"
                                        class="no-print">
                                        <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--gray-900);"><i
                                                class="bx bx-file"></i> Vertex Galaxy Bank Loan Statement</h3>
                                    </div>

                                    <!-- Statement Document Body -->
                                    <div class="statement-print-area">
                                        <!-- Official Bank Logo & Name -->
                                        <div
                                            style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 15px; margin-bottom: 25px;">
                                            <div>
                                                <h1
                                                    style="font-size: 1.8rem; font-weight: 800; color: var(--primary-500); letter-spacing: 1px; line-height: 1;">
                                                    VERTEX GALAXY BANK</h1>
                                                <p
                                                    style="font-size: 0.8rem; color: var(--gray-500); margin-top: 5px; font-weight: 500;">
                                                    Secure Credit &amp; Lending Divisions</p>
                                            </div>
                                            <div style="text-align: right;">
                                                <span
                                                    style="font-family: monospace; font-size: 0.85rem; color: var(--gray-500); font-weight: 700;">LN-REF:
                                                    #LN-${statementLoan.loanId}</span>
                                                <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 3px;">
                                                    Date Generated: <span id="currentDate"></span></p>
                                            </div>
                                        </div>

                                        <!-- Official Header Subtitle (shown in both screen and print) -->
                                        <div style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                                            <span style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official Loan Amortization &amp; Repayment Statement</span>
                                        </div>

                                        <!-- Details grid (Bank details vs Borrower details) -->
                                        <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);" class="mobile-grid-1">
                                            <!-- Left: Bank Information -->
                                            <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                                                <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank Details</span>
                                                <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate HQ)</strong>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers, BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code: <strong style="font-family: monospace;">VGBK0000001</strong></p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free: 1800-VGB-BANK</p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal: www.vertexgalaxybank.com</p>
                                            </div>
                                            
                                            <!-- Right: Customer & Loan Details -->
                                            <div>
                                                <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer &amp; Loan Details</span>
                                                <strong style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;">${statementCustomer.firstName} ${statementCustomer.lastName}</strong>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong style="font-family: monospace;">#VGB-CUST-${statementCustomer.customerId}</strong></p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address: ${statementCustomer.address}, ${statementCustomer.city}, ${statementCustomer.state} - ${statementCustomer.zipCode}</p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Loan Reference: <strong style="font-family: monospace;">#LN-${statementLoan.loanId}</strong> (${statementLoan.loanType} Loan)</p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Principal Amount: <strong>₹<fmt:formatNumber value="${statementLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Interest Rate / Term: <strong>${statementLoan.interestRate}% P.A. / ${statementLoan.termMonths} Mos</strong></p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Accumulated Repaid: <strong style="color: var(--accent-emerald);">₹<fmt:formatNumber value="${totalRepaid}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                                                <p style="margin: 4px 0 0; color: var(--gray-600);">Outstanding Balance: <strong style="color: var(--secondary-500);">₹<fmt:formatNumber value="${statementLoan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></strong></p>
                                            </div>
                                        </div>

                                        <!-- Repayment Schedule List -->
                                        <div
                                            style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                                            <h4
                                                style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                                                <i class="bx bx-history" style="color: var(--primary-500);"></i> Repayment Ledger Log
                                            </h4>
                                            <button type="button" onclick="window.print()" class="btn btn-primary no-print"
                                                style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px;">
                                                <span>Print Document</span>
                                                <i class="bx bx-printer"></i>
                                            </button>
                                        </div>
                                        <div style="overflow-x: auto; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); box-shadow: var(--shadow-sm); margin-bottom: 25px;">
                                            <table
                                                style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem; margin-bottom: 0;">
                                                <thead>
                                                    <tr
                                                        style="background: rgba(99, 102, 241, 0.04); color: var(--gray-700); border-bottom: 2px solid var(--gray-200);">
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; width: 80px;">Sr. No.</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Payment Date</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Type</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Description</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Status</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Credit Amount</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Debit Amount</th>
                                                        <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Total Amount</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty statementRepayments || not empty statementLoan}">
                                                            <c:set var="repaySr" value="0" />
                                                            <c:set var="runningLoanBal" value="${statementLoan.remainingBalance}" />
                                                            
                                                            <!-- Repayment rows -->
                                                            <c:forEach var="repay" items="${statementRepayments}">
                                                                <c:set var="repaySr" value="${repaySr + 1}" />
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--gray-200); color: var(--gray-700); transition: background 0.15s ease;">
                                                                    <td
                                                                        style="padding: 14px 16px; font-weight: 600; color: var(--gray-500);"><span class="badge-id">#${repaySr}</span></td>
                                                                    <td style="padding: 14px 16px;">${repay.formattedRepaymentDate}</td>
                                                                    <td style="padding: 14px 16px; text-transform: capitalize; font-weight: 600;">
                                                                        <span class="txn-deposit" style="color: var(--accent-emerald) !important;">Repayment</span>
                                                                    </td>
                                                                    <td style="padding: 14px 16px;">EMI Repayment (Principal: ₹<fmt:formatNumber value="${repay.principalComponent}" minFractionDigits="2" maxFractionDigits="2"/>, Interest: ₹<fmt:formatNumber value="${repay.interestComponent}" minFractionDigits="2" maxFractionDigits="2"/>)</td>
                                                                    <td style="padding: 14px 16px;">
                                                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">COMPLETED</span>
                                                                    </td>
                                                                    <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #10b981;">
                                                                        + ₹<fmt:formatNumber value="${repay.amountPaid}" minFractionDigits="2" maxFractionDigits="2"/>
                                                                    </td>
                                                                    <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #ef4444;">-</td>
                                                                    <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #1e3a8a; font-family: monospace;">
                                                                        ₹<fmt:formatNumber value="${runningLoanBal}" minFractionDigits="2" maxFractionDigits="2"/>
                                                                    </td>
                                                                </tr>
                                                                <c:set var="runningLoanBal" value="${runningLoanBal + repay.principalComponent}" />
                                                            </c:forEach>
                                                            
                                                            <!-- Initial Disbursal row -->
                                                            <c:if test="${not empty statementLoan}">
                                                                <c:set var="repaySr" value="${repaySr + 1}" />
                                                                <tr
                                                                    style="border-bottom: 1px solid var(--gray-200); color: var(--gray-700); transition: background 0.15s ease;">
                                                                    <td style="padding: 14px 16px; font-weight: 600; color: var(--gray-500);"><span class="badge-id">#${repaySr}</span></td>
                                                                    <td style="padding: 14px 16px;">${statementLoan.startDate}</td>
                                                                    <td style="padding: 14px 16px; text-transform: capitalize; font-weight: 600;">
                                                                        <span class="txn-withdrawal" style="color: var(--secondary-500) !important;">Disbursal</span>
                                                                    </td>
                                                                    <td style="padding: 14px 16px;">Initial ${statementLoan.loanType} Loan Disbursal</td>
                                                                    <td style="padding: 14px 16px;">
                                                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">COMPLETED</span>
                                                                    </td>
                                                                    <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #10b981;">-</td>
                                                                    <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #ef4444;">
                                                                        - ₹<fmt:formatNumber value="${statementLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                                    </td>
                                                                    <td style="padding: 14px 16px; text-align: right; font-weight: 700; color: #1e3a8a; font-family: monospace;">
                                                                        ₹<fmt:formatNumber value="${statementLoan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td colspan="8"
                                                                    style="text-align: center; padding: 35px; color: var(--gray-400); font-style: italic;">
                                                                    <i class="bx bx-info-circle" style="font-size: 1.5rem; display: block; margin-bottom: 8px;"></i>
                                                                    No repayments recorded on this loan account ledger.
                                                                </td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Footer Signatures (print only) -->
                                        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px;"
                                            class="print-only">
                                            <div style="text-align: center; width: 200px;">
                                                <div
                                                    style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;">
                                                </div>
                                                <span
                                                    style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Authorized
                                                    Signatory</span>
                                            </div>
                                            <div style="text-align: center; width: 200px;">
                                                <div
                                                    style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;">
                                                </div>
                                                <span
                                                    style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">System
                                                    Generated Seals</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Modal Controls (hidden in print) -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px;"
                                        class="no-print">
                                        <button type="button" class="btn btn-secondary"
                                            onclick="closeStatementModal()" style="border-radius: var(--radius-full); padding: 10px 24px;">Close View</button>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Admin View Loan Application Modal -->
                        <div id="adminViewModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); z-index: 1000; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
                            <div class="modal-content" style="width: 100%; max-width: 850px; display: flex; flex-direction: column; max-height: 90vh;">
                                <div class="modal-header no-print">
                                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 10px;">
                                        <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                                        <span>Review Loan Application File</span>
                                    </h3>
                                    <button type="button" onclick="closeAdminViewModal()" style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-900)'" onmouseout="this.style.color='var(--gray-400)'"><i class="bx bx-x"></i></button>
                                </div>
                                
                                <div class="modal-body" style="padding: 30px; overflow-y: auto; flex-grow: 1; background: var(--gray-100);">
                                    <div class="loan-paper-form">
                                        <div style="text-align: right; font-family: monospace; font-size: 0.8rem; color: var(--gray-500); margin-bottom: 10px;">
                                            LOAN APPLICATION REF: <span id="adminViewLoanId" style="font-weight: bold;"></span>
                                        </div>
                                        <h1>Loan Application Form</h1>
                                        
                                        <!-- 1. Applicant Information -->
                                        <h2>1. Applicant Information</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 30%; font-weight: bold;">Full Name:</td>
                                                <td style="width: 70%;"><input type="text" id="adminFormFullName" readonly style="font-weight: 600;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Father's / Husband's Name:</td>
                                                <td><input type="text" id="adminFormRelationName" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Date of Birth:</td>
                                                <td><input type="text" id="adminFormDob" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Gender:</td>
                                                <td><input type="text" id="adminFormGender" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Mobile Number:</td>
                                                <td><input type="text" id="adminFormMobile" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Email Address:</td>
                                                <td><input type="text" id="adminFormEmail" readonly></td>
                                            </tr>
                                        </table>

                                        <!-- 2. Address Details -->
                                        <h2>2. Address Details</h2>
                                        <h3 style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 10px 0 5px 0;">Current Address</h3>
                                        <div id="adminFormCurrentAddress" style="border-bottom: 1px dotted #475569; padding: 5px 0; font-weight: 600;"></div>

                                        <h3 style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 15px 0 5px 0;">Permanent Address</h3>
                                        <div id="adminFormPermanentAddress" style="border-bottom: 1px dotted #475569; padding: 5px 0; font-weight: 600; min-height: 25px;"></div>

                                        <!-- 3. Identity Details -->
                                        <h2>3. Identity Details</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Aadhaar Number:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormAadhaar" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">PAN Number:</td>
                                                <td><input type="text" id="adminFormPan" readonly style="text-transform: uppercase;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Voter ID / Driving License No.:</td>
                                                <td><input type="text" id="adminFormVoterDl" readonly></td>
                                            </tr>
                                        </table>

                                        <!-- 4. Employment Information -->
                                        <h2>4. Employment Information</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Occupation:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormOccupation" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Company / Business Name:</td>
                                                <td><input type="text" id="adminFormCompanyName" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Monthly Income:</td>
                                                <td><input type="text" id="adminFormMonthlyIncome" readonly style="font-weight: 600;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Work Experience:</td>
                                                <td><input type="text" id="adminFormExperience" readonly></td>
                                            </tr>
                                        </table>

                                        <!-- 5. Bank Account Details -->
                                        <h2>5. Bank Account Details</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Account Holder Name:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormAccHolderName" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Account Number:</td>
                                                <td><input type="text" id="adminFormAccNo" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">IFSC Code:</td>
                                                <td><input type="text" id="adminFormIfsc" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Branch:</td>
                                                <td><input type="text" id="adminFormBranch" readonly></td>
                                            </tr>
                                        </table>

                                        <!-- 6. Loan Details -->
                                        <h2>6. Loan Details</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Loan Type:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormLoanType" readonly style="font-weight: bold; text-transform: uppercase;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Requested Amount (₹):</td>
                                                <td><input type="text" id="adminFormLoanAmount" readonly style="font-weight: bold;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Tenure Duration:</td>
                                                <td><input type="text" id="adminFormLoanTenure" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Fixed Interest Rate:</td>
                                                <td><input type="text" id="adminFormLoanRate" readonly style="font-weight: 600; color: var(--primary-500);"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Purpose of Loan:</td>
                                                <td><input type="text" id="adminFormLoanPurpose" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Estimated Monthly EMI:</td>
                                                <td style="font-weight: bold; font-size: 1.1rem; color: #0f172a;" id="adminFormPaperEmiDisplay">₹ 0.00</td>
                                            </tr>
                                        </table>

                                        <!-- 7. Nominee Information -->
                                        <h2>7. Nominee Information</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Nominee Name:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormNomineeName" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Relationship with Applicant:</td>
                                                <td><input type="text" id="adminFormNomineeRelationship" readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Nominee Mobile Number:</td>
                                                <td><input type="text" id="adminFormNomineeMobile" readonly></td>
                                            </tr>
                                        </table>

                                        <!-- 8. Declaration -->
                                        <h2>8. Declaration</h2>
                                        <div style="margin-bottom: 20px; font-size: 0.9rem; text-align: justify; line-height: 1.5; color: #334155;">
                                            <span>I hereby declare that the details furnished above are true and correct to the best of my knowledge and belief and I undertake to inform Vertex Galaxy Bank of any changes therein, immediately. In case any of the above information is found to be false or untrue or misleading, I am aware that I may be held liable for it. I authorize the Bank to debit my linked account for recovery of EMI.</span>
                                        </div>

                                        <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; margin-top: 30px;">
                                            <div>
                                                <table style="margin-bottom: 0;">
                                                    <tr>
                                                        <td style="width: 30%; font-weight: bold;">Date:</td>
                                                        <td style="width: 70%;"><input type="text" id="adminFormDeclarationDate" readonly></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="font-weight: bold;">Place:</td>
                                                        <td><input type="text" id="adminFormDeclarationPlace" readonly></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div style="text-align: center; display: flex; flex-direction: column; justify-content: flex-end; align-items: center;">
                                                <input type="text" id="adminFormSignature" readonly style="text-align: center; font-family: 'Brush Script MT', cursive, Georgia, serif; font-size: 1.5rem; border-bottom: 1.5px solid #000 !important; width: 85%;">
                                                <span style="font-size: 0.75rem; font-weight: bold; color: #475569; text-transform: uppercase; margin-top: 5px; display: block;">Applicant's Signature</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Action Buttons (shown only on screen) -->
                                    <div class="no-print" style="margin-top: 30px; display: flex; gap: 15px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid var(--gray-200);">
                                        <button type="button" class="btn btn-secondary" onclick="closeAdminViewModal()" style="padding: 10px 22px;">Close</button>
                                        <button type="button" class="btn btn-secondary" onclick="printAdminApplicationForm()" style="padding: 10px 22px; display: flex; align-items: center; gap: 8px; border: 1.5px solid var(--gray-300); color: var(--gray-700); background: white;">
                                            <i class="bx bx-printer"></i>
                                            <span>Print Application Form</span>
                                        </button>
                                        <a href="#" id="adminModalApproveBtn" class="btn" style="padding: 10px 22px; display: none; align-items: center; gap: 8px; background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; font-weight: 600; border-radius: var(--radius-md); box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); transition: all 0.2s; text-decoration: none; justify-content: center;">
                                            <i class="bx bx-check" style="font-size: 1.2rem;"></i>
                                            <span>Approve Application</span>
                                        </a>
                                        <a href="#" id="adminModalRejectBtn" class="btn" style="padding: 10px 22px; display: none; align-items: center; gap: 8px; background: linear-gradient(135deg, #ef4444, #dc2626); color: white; border: none; font-weight: 600; border-radius: var(--radius-md); box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); transition: all 0.2s; text-decoration: none; justify-content: center;">
                                            <i class="bx bx-x" style="font-size: 1.2rem;"></i>
                                            <span>Reject Application</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <footer class="footer no-print"
                    style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
                    <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
                        <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span
                                data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
                    </div>
                </footer>

                <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
                <!-- Hidden JSON data block for JS to read (avoids IDE JavaScript parser warnings/errors) -->
                <script id="accounts-data" type="application/json">
                    [
                        <c:forEach var="acc" items="${accounts}" varStatus="loop">
                            {
                                "accountId": "${acc.accountId}",
                                "customerId": "${acc.customerId}",
                                "accountNumber": "${acc.accountNumber}",
                                "accountType": "${acc.accountType}",
                                "balance": "${acc.balance}",
                                "status": "${acc.status}"
                            }${loop.last ? '' : ','}
                        </c:forEach>
                    ]
                </script>
                <script>
                    // Store all system accounts locally in JS for interactive client-side filtering
                    const allAccounts = JSON.parse(document.getElementById('accounts-data').textContent);

                    function openViewModal(loanId, customerName, customerPhone, loanType, principal, interestRate, termMonths, formDetailsStr, loanStatus) {
                        document.getElementById('adminViewLoanId').textContent = "#LN-" + loanId;
                        
                        // Re-populate basic/fallback details
                        document.getElementById('adminFormFullName').value = customerName;
                        document.getElementById('adminFormMobile').value = customerPhone;
                        document.getElementById('adminFormLoanType').value = loanType;
                        document.getElementById('adminFormLoanAmount').value = "₹ " + parseFloat(principal).toLocaleString('en-IN', { minimumFractionDigits: 2 });
                        document.getElementById('adminFormLoanRate').value = parseFloat(interestRate).toFixed(2) + "% Fixed P.A.";
                        document.getElementById('adminFormLoanTenure').value = termMonths + " Months";
                        document.getElementById('adminFormAccHolderName').value = customerName;

                        // Configure Modal Action Buttons dynamically
                        const approveBtn = document.getElementById('adminModalApproveBtn');
                        const rejectBtn = document.getElementById('adminModalRejectBtn');
                        
                        if (loanStatus === 'pending_approval') {
                            approveBtn.style.display = 'inline-flex';
                            rejectBtn.style.display = 'inline-flex';
                            approveBtn.href = '${pageContext.request.contextPath}/loan?action=approve&id=' + loanId;
                            rejectBtn.href = '${pageContext.request.contextPath}/loan?action=reject&id=' + loanId;
                            
                            // Setup confirmations on click
                            approveBtn.onclick = function() {
                                return confirm('Are you sure you want to APPROVE this loan application (Ref: #LN-' + loanId + ')?');
                            };
                            rejectBtn.onclick = function() {
                                return confirm('Are you sure you want to REJECT this loan application (Ref: #LN-' + loanId + ')?');
                            };
                        } else {
                            approveBtn.style.display = 'none';
                            rejectBtn.style.display = 'none';
                        }

                        let parsed = null;
                        if (formDetailsStr && formDetailsStr.trim() !== '') {
                            try {
                                parsed = JSON.parse(formDetailsStr);
                            } catch (e) {
                                console.error("Failed to parse formDetails JSON string", e);
                            }
                        }

                        if (parsed) {
                            // Populate detailed form from JSON block
                            document.getElementById('adminFormRelationName').value = parsed.relationName || '___________________________';
                            document.getElementById('adminFormDob').value = parsed.dob || '___________________________';
                            document.getElementById('adminFormGender').value = parsed.gender || '___________________________';
                            
                            // Email prefill from basic or parsed
                            document.getElementById('adminFormEmail').value = parsed.email || '';
                            
                            document.getElementById('adminFormCurrentAddress').textContent = parsed.currentAddress || 'N/A';
                            document.getElementById('adminFormPermanentAddress').textContent = parsed.permanentAddress || '______________________________________________________';
                            
                            document.getElementById('adminFormAadhaar').value = parsed.aadhaar || '';
                            document.getElementById('adminFormPan').value = parsed.pan || '';
                            document.getElementById('adminFormVoterDl').value = parsed.voterDlNo || '___________________________';
                            
                            document.getElementById('adminFormOccupation').value = parsed.occupation || '___________________________';
                            document.getElementById('adminFormCompanyName').value = parsed.companyName || '___________________________';
                            document.getElementById('adminFormMonthlyIncome').value = parsed.monthlyIncome ? "₹ " + parseFloat(parsed.monthlyIncome).toLocaleString('en-IN') : '₹ ______________________';
                            document.getElementById('adminFormExperience').value = parsed.workExperience || '_____________________';
                            
                            document.getElementById('adminFormAccNo').value = parsed.linkedAccountNo || '___________________________';
                            document.getElementById('adminFormIfsc').value = parsed.linkedIfsc || '___________________________';
                            document.getElementById('adminFormBranch').value = parsed.linkedBranch || 'VGB Main Branch';
                            
                            document.getElementById('adminFormLoanPurpose').value = parsed.loanPurpose || '___________________________';
                            
                            document.getElementById('adminFormNomineeName').value = parsed.nomineeName || '___________________________';
                            document.getElementById('adminFormNomineeRelationship').value = parsed.nomineeRelationship || '___________________________';
                            document.getElementById('adminFormNomineeMobile').value = parsed.nomineeMobile || '___________________________';
                            
                            document.getElementById('adminFormDeclarationDate').value = parsed.declarationDate || '';
                            document.getElementById('adminFormDeclarationPlace').value = parsed.declarationPlace || '___________________________';
                            document.getElementById('adminFormSignature').value = parsed.signature || '';
                            
                            // Calculate paper EMI
                            const monthlyRate = (parseFloat(interestRate) / 12) / 100;
                            const emi = (parseFloat(principal) * monthlyRate * Math.pow(1 + monthlyRate, parseInt(termMonths))) / (Math.pow(1 + monthlyRate, parseInt(termMonths)) - 1);
                            document.getElementById('adminFormPaperEmiDisplay').textContent = "₹ " + emi.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                        } else {
                            // Fall back cleanly to a neat default form compiled from basic database columns
                            document.getElementById('adminFormRelationName').value = 'N/A (Legacy Record)';
                            document.getElementById('adminFormDob').value = 'N/A';
                            document.getElementById('adminFormGender').value = 'N/A';
                            document.getElementById('adminFormEmail').value = '';
                            document.getElementById('adminFormCurrentAddress').textContent = 'N/A (Legacy Record)';
                            document.getElementById('adminFormPermanentAddress').textContent = 'N/A (Legacy Record)';
                            document.getElementById('adminFormAadhaar').value = 'N/A';
                            document.getElementById('adminFormPan').value = 'N/A';
                            document.getElementById('adminFormVoterDl').value = 'N/A';
                            
                            document.getElementById('adminFormOccupation').value = 'N/A';
                            document.getElementById('adminFormCompanyName').value = 'N/A';
                            document.getElementById('adminFormMonthlyIncome').value = 'N/A';
                            document.getElementById('adminFormExperience').value = 'N/A';
                            
                            document.getElementById('adminFormAccNo').value = 'N/A';
                            document.getElementById('adminFormIfsc').value = 'N/A';
                            document.getElementById('adminFormBranch').value = 'VGB Main Branch';
                            
                            document.getElementById('adminFormLoanPurpose').value = 'N/A (Legacy Record)';
                            
                            document.getElementById('adminFormNomineeName').value = 'N/A';
                            document.getElementById('adminFormNomineeRelationship').value = 'N/A';
                            document.getElementById('adminFormNomineeMobile').value = 'N/A';
                            
                            document.getElementById('adminFormDeclarationDate').value = 'N/A';
                            document.getElementById('adminFormDeclarationPlace').value = 'N/A';
                            document.getElementById('adminFormSignature').value = 'N/A';
                            
                            document.getElementById('adminFormPaperEmiDisplay').textContent = 'N/A';
                        }

                        document.getElementById('adminViewModal').style.display = 'flex';
                    }

                    function closeAdminViewModal() {
                        document.getElementById('adminViewModal').style.display = 'none';
                    }

                    function printAdminApplicationForm() {
                        document.body.classList.add('print-admin-active');
                        window.print();
                        setTimeout(() => {
                            document.body.classList.remove('print-admin-active');
                        }, 1000);
                    }

                    function switchTab(tabId) {
                        document.querySelectorAll('.tab-btn').forEach(btn => {
                            btn.classList.remove('active');
                        });

                        const activeBtn = document.getElementById('tab-' + tabId);
                        if (activeBtn) {
                            activeBtn.classList.add('active');
                        }

                        document.querySelectorAll('.loan-tab-content').forEach(card => {
                            card.style.display = 'none';
                        });

                        const activeCard = document.getElementById('content-' + tabId);
                        if (activeCard) {
                            activeCard.style.display = 'block';
                        }
                    }

                    function openDisburseModal(loanId, customerId, amount) {
                        document.getElementById('disburseLoanId').value = loanId;
                        document.getElementById('disburseAmount').value = "₹ " + parseFloat(amount).toLocaleString('en-IN', { minimumFractionDigits: 2 });

                        const select = document.getElementById('disburseAccount');
                        select.innerHTML = '<option value="">-- Select Active Account --</option>';

                        // Filter only active accounts belonging to the specific borrower
                        const customerAccounts = allAccounts.filter(acc => acc.customerId === customerId && acc.status.toLowerCase() === 'active');

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

                        document.getElementById('disburseModal').style.display = 'flex';
                    }

                    function closeDisburseModal() {
                        document.getElementById('disburseModal').style.display = 'none';
                    }

                    function openRepayModal(loanId, customerId, remaining) {
                        document.getElementById('repayLoanId').value = loanId;
                        document.getElementById('repayCustomerId').value = customerId;
                        document.getElementById('repayRemaining').value = "₹ " + parseFloat(remaining).toLocaleString('en-IN', { minimumFractionDigits: 2 });

                        const select = document.getElementById('repayAccount');
                        select.innerHTML = '<option value="">-- Select Active Account --</option>';

                        // Filter only active accounts belonging to the specific borrower
                        const customerAccounts = allAccounts.filter(acc => acc.customerId === customerId && acc.status.toLowerCase() === 'active');

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

                        document.getElementById('repayModal').style.display = 'flex';
                    }

                    function closeRepayModal() {
                        document.getElementById('repayModal').style.display = 'none';
                    }

                    function closeStatementModal() {
                        const statementModal = document.getElementById('statementModal');
                        if (statementModal) {
                            statementModal.style.display = 'none';
                        }
                    }

                    // Initialize state, badges, and default tabs on page load
                    document.addEventListener("DOMContentLoaded", function () {
                        // Populate dynamic counter badges
                        const badgePending = document.getElementById('badge-pending');
                        const badgeApproved = document.getElementById('badge-approved');
                        const badgeClosed = document.getElementById('badge-closed');
                        const badgePayments = document.getElementById('badge-payments');
                        if (badgePending) badgePending.textContent = "${pendingCount}";
                        if (badgeApproved) badgeApproved.textContent = "${approvedCount}";
                        if (badgeClosed) badgeClosed.textContent = "${closedCount}";
                        if (badgePayments) badgePayments.textContent = "${paymentsCount}";

                        // Auto switch to appropriate active tab or default to pending
                        const loanStatus = document.body.getAttribute('data-statement-loan-status');
                        if (loanStatus && loanStatus.trim() !== '') {
                            if (loanStatus === 'pending_approval') {
                                switchTab('pending');
                            } else if (loanStatus === 'approved' || loanStatus === 'disbursed' || loanStatus === 'active') {
                                switchTab('approved');
                            } else {
                                switchTab('closed');
                            }
                        } else {
                            switchTab('pending');
                        }

                        // Generate full localized date inside statement
                        let d = new Date();
                        let options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
                        let dateEl = document.getElementById('currentDate');
                        if (dateEl) {
                            dateEl.textContent = d.toLocaleDateString('en-US', options);
                        }

                        // Theme switch toggle logic with localStorage sync
                        const themeBtn = document.getElementById('themeToggle');
                        if (themeBtn) {
                            themeBtn.style.setProperty('display', 'flex', 'important');
                            themeBtn.onclick = function () {
                                document.body.classList.toggle('dark-mode');
                                const isDark = document.body.classList.contains('dark-mode');
                                const icon = themeBtn.querySelector('i');
                                if (icon) {
                                    icon.className = isDark ? 'bx bx-sun' : 'bx bx-moon';
                                }
                                localStorage.setItem('admin-theme', isDark ? 'dark' : 'light');
                            };

                            // Sync with stored theme preference on load
                            const savedTheme = localStorage.getItem('admin-theme');
                            if (savedTheme === 'dark') {
                                document.body.classList.add('dark-mode');
                                const icon = themeBtn.querySelector('i');
                                if (icon) icon.className = 'bx bx-sun';
                            } else {
                                document.body.classList.remove('dark-mode');
                                const icon = themeBtn.querySelector('i');
                                if (icon) icon.className = 'bx bx-moon';
                            }
                        }

                        // Mobile menu drawer toggle handler with outside click collapse
                        const mobileToggle = document.getElementById('mobileNavToggle');
                        const sidebar = document.querySelector('.sidebar');
                        if (mobileToggle && sidebar) {
                            mobileToggle.addEventListener('click', (e) => {
                                e.stopPropagation();
                                sidebar.classList.toggle('active');
                                const icon = mobileToggle.querySelector('i');
                                if (icon) {
                                    if (sidebar.classList.contains('active')) {
                                        icon.className = 'bx bx-x';
                                    } else {
                                        icon.className = 'bx bx-menu';
                                    }
                                }
                            });

                            document.addEventListener('click', (e) => {
                                if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                                    sidebar.classList.remove('active');
                                    const icon = mobileToggle.querySelector('i');
                                    if (icon) icon.className = 'bx bx-menu';
                                }
                            });
                        }

                        // Custom mouse follower cursor glow movement binding
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

                    // Global accounts map to associate customer IDs with account numbers in search
                    const customerAccountsMap = {};
                    <c:if test="${not empty accounts}">
                        <c:forEach var="acc" items="${accounts}">
                            customerAccountsMap["${acc.customerId}"] = "${acc.accountNumber}";
                        </c:forEach>
                    </c:if>

                    // Live Client-side Loan Tables Filter
                    function filterLoanTables() {
                        const query = document.getElementById('loanSearchInput').value.toLowerCase().trim();
                        const tableIds = ['content-pending', 'content-approved', 'content-closed', 'content-payments'];

                        tableIds.forEach(id => {
                            const tbody = document.querySelector('#' + id + ' tbody');
                            if (!tbody) return;

                            const rows = tbody.querySelectorAll('tr[data-customer-id]');
                            if (rows.length === 0) return;

                            let fallbackRow = tbody.querySelector('tr.empty-row');
                            if (!fallbackRow) {
                                fallbackRow = document.createElement('tr');
                                fallbackRow.className = 'empty-row';
                                const headerCols = tbody.closest('table').querySelectorAll('thead th').length;
                                fallbackRow.innerHTML = `<td colspan="${headerCols}" style="text-align: center; padding: 40px; color: var(--gray-400);"><i class="bx bx-info-circle" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i> No records match your search query.</td>`;
                                tbody.appendChild(fallbackRow);
                            }

                            let visibleCount = 0;
                            rows.forEach(row => {
                                const custId = row.getAttribute('data-customer-id') || '';
                                const name = (row.getAttribute('data-customer-name') || '').toLowerCase();
                                const phone = (row.getAttribute('data-customer-phone') || '').toLowerCase();
                                const loanCat = (row.getAttribute('data-loan-category') || '').toLowerCase();
                                const accNo = custId ? (customerAccountsMap[custId] || '').toLowerCase() : '';

                                const textMatch = name.includes(query) ||
                                    phone.includes(query) ||
                                    loanCat.includes(query) ||
                                    accNo.includes(query);

                                if (textMatch) {
                                    row.style.display = '';
                                    visibleCount++;
                                } else {
                                    row.style.display = 'none';
                                }
                            });

                            if (visibleCount === 0) {
                                fallbackRow.style.display = '';
                            } else {
                                fallbackRow.style.display = 'none';
                            }
                        });
                    }
                </script>
            </body>

            </html>