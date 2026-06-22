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
                        box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.02), var(--shadow-lg);
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

                    .loan-paper-form h1,
                    .loan-paper-form h2,
                    .loan-paper-form h3,
                    .loan-paper-form h4 {
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

                    .loan-paper-form input[type="text"],
                    .loan-paper-form input[type="date"],
                    .loan-paper-form input[type="number"],
                    .loan-paper-form select,
                    .loan-paper-form textarea {
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
                    .form-control,
                    .control-select,
                    .control-input {
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

                    .form-control:focus,
                    .control-select:focus,
                    .control-input:focus {
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
                        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
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
                        from {
                            transform: scale(0.9) translateY(10px);
                            opacity: 0;
                        }

                        to {
                            transform: scale(1) translateY(0);
                            opacity: 1;
                        }
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

                    /* Loan Card Grid Styling */
                    .loans-category-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
                        gap: 20px;
                        margin-bottom: 30px;
                    }

                    .loan-product-card {
                        background: white;
                        border: 1px solid var(--gray-200);
                        border-radius: var(--radius-lg);
                        padding: 22px 20px;
                        text-align: center;
                        cursor: pointer;
                        transition: all var(--transition-normal);
                        box-shadow: var(--shadow-sm);
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                    }

                    .loan-product-card:hover {
                        transform: translateY(-5px);
                        border-color: var(--primary-500);
                        box-shadow: 0 8px 25px rgba(99, 102, 241, 0.15);
                    }

                    .loan-product-card h4 {
                        font-size: 1rem;
                        font-weight: 700;
                        color: var(--gray-800);
                        margin-bottom: 8px;
                        font-family: 'Poppins', sans-serif;
                    }

                    .loan-product-card p {
                        font-size: 0.75rem;
                        color: var(--gray-400);
                        line-height: 1.5;
                        margin-bottom: 15px;
                        flex-grow: 1;
                    }

                    .loan-product-card .rate-badge {
                        font-size: 1.25rem;
                        font-weight: 800;
                        color: var(--primary-500);
                        margin-bottom: 12px;
                    }

                    .loan-product-card .btn {
                        margin-top: auto;
                    }

                    .loan-paper-form input[type="radio"],
                    .loan-paper-form input[type="checkbox"] {
                        cursor: pointer;
                        margin-right: 5px;
                        width: auto !important;
                    }

                    /* Print layout centering for Admin Apply Modal */
                    @media print {
                        body.print-admin-apply-active * {
                            visibility: hidden !important;
                        }

                        body.print-admin-apply-active #adminApplyModal,
                        body.print-admin-apply-active #adminApplyModal * {
                            visibility: visible !important;
                        }

                        body.print-admin-apply-active #adminApplyModal {
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

                        body.print-admin-apply-active #adminApplyModal .modal-content {
                            box-shadow: none !important;
                            border: none !important;
                            width: 100% !important;
                            max-width: 100% !important;
                            padding: 0 !important;
                            margin: 0 !important;
                            background: white !important;
                        }

                        body.print-admin-apply-active #adminApplyModal .modal-body {
                            overflow: visible !important;
                            max-height: none !important;
                            padding: 0 !important;
                        }

                        body.print-admin-apply-active #adminApplyModal .loan-paper-form {
                            border: none !important;
                            box-shadow: none !important;
                            padding: 0 !important;
                            width: 100% !important;
                            max-width: 100% !important;
                        }
                    }

                    /* Segmented Toggles for Create vs Update Mode */
                    .mode-toggle-btn {
                        color: var(--gray-500);
                    }

                    .mode-toggle-btn.active {
                        color: var(--primary-600) !important;
                    }

                    .mode-toggle-btn::after {
                        content: '';
                        position: absolute;
                        bottom: -17px;
                        left: 0;
                        width: 100%;
                        height: 3px;
                        background: transparent;
                        transition: all 0.3s ease;
                    }

                    .mode-toggle-btn.active::after {
                        background: linear-gradient(90deg, var(--primary-500), var(--secondary-500)) !important;
                    }

                    body.dark-mode .mode-toggle-btn.active {
                        color: var(--primary-400) !important;
                    }

                    body.dark-mode .loan-product-card {
                        background: rgba(30, 41, 59, 0.6) !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                    }

                    body.dark-mode .loan-product-card h4 {
                        color: white !important;
                    }

                    .edit-specs-btn:hover {
                        background: var(--primary-500) !important;
                        color: white !important;
                    }
                </style>
            </head>

            <body class="bank-home-page" data-statement-loan-status="${statementLoan.status}">
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
                        <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation"
                            style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                            <i class="bx bx-menu"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo"
                            style="display: flex; align-items: center; text-decoration: none;">
                            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
                        </a>
                    </div>
                    <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
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
                <aside class="sidebar">
                    <div class="sidebar-menu">
                        <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i>
                            Dashboard</a>
                        <a href="${pageContext.request.contextPath}/account?action=list"><i
                                class="bx bx-user-check"></i> Manage Accounts</a>
                        <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i
                                class="bx bx-transfer-alt"></i> Admin Counter</a>
                        <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i>
                            Manage Cards</a>
                        <a href="${pageContext.request.contextPath}/chequebook?action=list"><i
                                class="bx bx-book-bookmark"></i> Cheque Requests</a>
                        <a href="${pageContext.request.contextPath}/passbook?action=list"><i
                                class="bx bx-book-open"></i> Passbook Requests</a>
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
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;"
                            class="no-print">
                            <div>
                                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">System Loan
                                    Portfolios</h2>
                                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Analyze credit
                                    applications, execute disbursements, or reject failed file ratings.</p>
                            </div>
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
                            style="padding: 15px 25px; margin-bottom: 25px; border-radius: var(--radius-md); display: flex; align-items: center; gap: 15px; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(99, 102, 241, 0.15);">
                            <div style="position: relative; flex: 1;">
                                <input type="text" id="loanSearchInput" onkeyup="filterLoanTables()"
                                    placeholder="Search loans by customer name, account number, phone number, or loan category..."
                                    style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem; background: white; transition: all var(--transition-normal); box-shadow: var(--shadow-sm);">
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
                            <button type="button" class="tab-btn" onclick="switchTab('apply')" id="tab-apply"
                                style="padding: 12px 20px; font-family: var(--font-family); font-size: 0.9rem; font-weight: 600; border-radius: var(--radius-md); display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-plus-circle" style="font-size: 1.1rem;"></i>
                                <span>Apply New Loan</span>
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
                                                    <td style="padding: 15px;"><span
                                                            class="badge-id">#${pendingCount}</span></td>
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
                                                            <button type="button" class="btn btn-secondary"
                                                                onclick="openViewModal('${loan.loanId}', '${customerNames[loan.customerId]}', '${customerPhones[loan.customerId]}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'), '${loan.status}', '${customerAadhaars[loan.customerId]}', '${customerPans[loan.customerId]}')"
                                                                data-form-details="<c:out value="
                                                                ${loan.formDetails}" />" style="padding: 6px 12px;
                                                            font-size: 0.75rem; border-color: var(--primary-500); color:
                                                            var(--primary-500);"><i class="bx bx-show"></i>
                                                            View</button>
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
                                                    <td style="padding: 15px;"><span
                                                            class="badge-id">#${approvedCount}</span></td>
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
                                                            <button type="button" class="btn btn-secondary"
                                                                onclick="openViewModal('${loan.loanId}', '${customerNames[loan.customerId]}', '${customerPhones[loan.customerId]}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'), '${loan.status}', '${customerAadhaars[loan.customerId]}', '${customerPans[loan.customerId]}')"
                                                                data-form-details="<c:out value="
                                                                ${loan.formDetails}" />" style="padding: 6px 12px;
                                                            font-size: 0.75rem; border-color: var(--primary-500); color:
                                                            var(--primary-500);"><i class="bx bx-show"></i>
                                                            View</button>
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
                                                    <td style="padding: 15px;"><span
                                                            class="badge-id">#${closedCount}</span></td>
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
                                                            <button type="button" class="btn btn-secondary"
                                                                onclick="openViewModal('${loan.loanId}', '${customerNames[loan.customerId]}', '${customerPhones[loan.customerId]}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'), '${loan.status}', '${customerAadhaars[loan.customerId]}', '${customerPans[loan.customerId]}')"
                                                                data-form-details="<c:out value="
                                                                ${loan.formDetails}" />" style="padding: 6px 12px;
                                                            font-size: 0.75rem; border-color: var(--primary-500); color:
                                                            var(--primary-500);"><i class="bx bx-show"></i>
                                                            View</button>
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

                        <!-- Tab Content 4: Apply New Loan -->
                        <div class="loan-tab-content no-print" id="content-apply" style="display: none;">

                            <!-- Mode 1: Create New Loan Container -->
                            <div id="apply-new-mode-container">
                                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 25px; margin-bottom: 35px;"
                                    class="mobile-grid-1">
                                    <!-- EMI Calculator -->
                                    <div class="glass-card" style="margin-bottom: 0;">
                                        <h3
                                            style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 10px;">
                                            <i class="bx bx-calculator"></i> VGB Premium EMI Calculator
                                        </h3>

                                        <div class="form-group" style="margin-bottom: 15px;">
                                            <label for="calcAmount"
                                                style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Principal
                                                Amount (₹)</label>
                                            <input type="number" id="calcAmount" value="500000" min="50000"
                                                max="50000000" oninput="calculateEMI()"
                                                style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                        </div>

                                        <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 15px;"
                                            class="mobile-grid-1">
                                            <div class="form-group">
                                                <label for="calcRate"
                                                    style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Annual
                                                    Interest Rate (%)</label>
                                                <select id="calcRate" onchange="calculateEMI()"
                                                    style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
                                                    <option id="opt-calc-home" value="7.50" selected>Home Secure Loan
                                                        (7.50%)</option>
                                                    <option id="opt-calc-vehicle" value="8.50">Vehicle Purchase Loan
                                                        (8.50%)</option>
                                                    <option id="opt-calc-education" value="6.50">Higher Education Loan
                                                        (6.50%)</option>
                                                    <option id="opt-calc-personal" value="12.00">Personal Cash Loan
                                                        (12.00%)</option>
                                                    <option id="opt-calc-business" value="10.50">Business Capital Loan
                                                        (10.50%)</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="displayCalcTermVal"
                                                    style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Tenure
                                                    Duration</label>
                                                <div style="display: flex; gap: 10px;">
                                                    <input type="number" id="displayCalcTermVal" value="10" min="1"
                                                        max="30" required
                                                        style="flex-grow: 1; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;"
                                                        oninput="syncCalcTerm()">
                                                    <select id="calcTermUnit"
                                                        style="width: 100px; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;"
                                                        onchange="syncCalcTerm()">
                                                        <option value="years" selected>Years</option>
                                                        <option value="months">Months</option>
                                                    </select>
                                                </div>
                                                <input type="hidden" id="calcTerm" value="120">
                                            </div>
                                        </div>
                                        <div
                                            style="background: var(--gradient-secondary); padding: 20px; border-radius: var(--radius-md); color: white; text-align: center; margin-top: 25px; box-shadow: var(--shadow-sm);">
                                            <span
                                                style="display: block; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9;">Estimated
                                                Monthly Payment</span>
                                            <strong
                                                style="font-size: 2.2rem; font-weight: 800; display: block; margin-top: 5px;"
                                                id="emiResult">₹ 5,935.09</strong>
                                            <span
                                                style="font-size: 0.75rem; opacity: 0.85; display: block; margin-top: 3px;">Subject
                                                to terms &amp; final physical document verification.</span>
                                        </div>
                                    </div>

                                    <!-- Promotional Info Column -->
                                    <div class="glass-card"
                                        style="display: flex; flex-direction: column; justify-content: space-between; background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(168, 85, 247, 0.05) 100%); margin-bottom: 0;">
                                        <div>
                                            <h3
                                                style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); margin-bottom: 15px;">
                                                <i class="bx bx-star" style="color: #eab308;"></i> Why VGB Premium
                                                Lending?
                                            </h3>
                                            <p
                                                style="font-size: 0.9rem; color: var(--gray-600); line-height: 1.6; margin-bottom: 20px;">
                                                Vertex Galaxy Bank offers custom-tailored credit solutions featuring
                                                highly competitive fixed interest rates, flexible tenure options up to
                                                30 years, and instant digital credit assessment.
                                            </p>
                                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                                <div
                                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                                    <i class="bx bx-check-double"
                                                        style="color: var(--primary-500); font-size: 1.2rem;"></i>
                                                    <span>Zero hidden charges &amp; fully transparent terms</span>
                                                </div>
                                                <div
                                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                                    <i class="bx bx-check-double"
                                                        style="color: var(--primary-500); font-size: 1.2rem;"></i>
                                                    <span>Flexible EMI repayments auto-debited securely</span>
                                                </div>
                                                <div
                                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                                    <i class="bx bx-check-double"
                                                        style="color: var(--primary-500); font-size: 1.2rem;"></i>
                                                    <span>Direct administrative verification with instant updates</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div
                                            style="border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px; margin-top: 20px; font-size: 0.85rem; color: var(--gray-500); font-style: italic;">
                                            Please select one of the loan products below to fill in the formal
                                            application form for the customer.
                                        </div>
                                    </div>
                                </div>

                                <!-- Select Loan Product Grid -->
                                <div style="margin-bottom: 20px;">
                                    <h3
                                        style="font-size: 1.5rem; font-weight: 800; color: var(--gray-900); margin-bottom: 10px; display: flex; align-items: center; gap: 10px;">
                                        <i class="bx bx-gift" style="color: var(--primary-500);"></i>
                                        <span>Select a Premium Loan Solution</span>
                                    </h3>
                                    <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 20px;">Choose a
                                        specialized loan product based on your financial goals. Click **Apply Now** to
                                        open the formal application form.</p>
                                    <div class="loans-category-grid">
                                        <!-- Personal Loan -->
                                        <div class="loan-product-card" id="card-personal"
                                            onclick="showAdminLoanDetails('personal', 12.00, 1500000)">
                                            <div>
                                                <h4>Personal Cash Loan</h4>
                                                <p>Unsecured personal financing for instant cash requirements, medical
                                                    expenses, or emergency funds.</p>
                                            </div>
                                            <div>
                                                <div class="rate-badge" id="badge-rate-personal">12.00% <span
                                                        style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span>
                                                </div>
                                                <div id="badge-max-personal"
                                                    style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">
                                                    Max: ₹ 15,00,000</div>
                                                <div
                                                    style="display: flex; gap: 8px; align-items: center; width: 100%; margin-top: auto;">
                                                    <button type="button" class="btn btn-primary"
                                                        onclick="event.stopPropagation(); openAdminLoanForm('personal', getSpecValue('personal', 'rate'), getSpecValue('personal', 'max'))"
                                                        style="flex-grow: 1; padding: 8px 12px; font-size: 0.75rem; background: linear-gradient(135deg, #a855f7 0%, #ec4899 100%); border: none;">Apply
                                                        Now</button>
                                                    <button type="button" class="edit-specs-btn"
                                                        onclick="event.stopPropagation(); openEditSpecsModal('personal')"
                                                        style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: none; border-radius: var(--radius-md); width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s;"
                                                        title="Edit Interest Rate and Max Limit"><i class="bx bx-cog"
                                                            style="font-size: 1.15rem; vertical-align: middle;"></i></button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Home Loan -->
                                        <div class="loan-product-card" id="card-home"
                                            onclick="showAdminLoanDetails('home', 7.50, 50000000)">
                                            <div>
                                                <h4>Home Secure Loan</h4>
                                                <p>Realize your dream home with low rates, customized repayment
                                                    timelines, and easy paper processing.</p>
                                            </div>
                                            <div>
                                                <div class="rate-badge" id="badge-rate-home">7.50% <span
                                                        style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span>
                                                </div>
                                                <div id="badge-max-home"
                                                    style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">
                                                    Max: ₹ 5,00,00,000</div>
                                                <div
                                                    style="display: flex; gap: 8px; align-items: center; width: 100%; margin-top: auto;">
                                                    <button type="button" class="btn btn-primary"
                                                        onclick="event.stopPropagation(); openAdminLoanForm('home', getSpecValue('home', 'rate'), getSpecValue('home', 'max'))"
                                                        style="flex-grow: 1; padding: 8px 12px; font-size: 0.75rem; background: linear-gradient(135deg, #a855f7 0%, #ec4899 100%); border: none;">Apply
                                                        Now</button>
                                                    <button type="button" class="edit-specs-btn"
                                                        onclick="event.stopPropagation(); openEditSpecsModal('home')"
                                                        style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: none; border-radius: var(--radius-md); width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s;"
                                                        title="Edit Interest Rate and Max Limit"><i class="bx bx-cog"
                                                            style="font-size: 1.15rem; vertical-align: middle;"></i></button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Vehicle Loan -->
                                        <div class="loan-product-card" id="card-vehicle"
                                            onclick="showAdminLoanDetails('vehicle', 8.50, 5000000)">
                                            <div>
                                                <h4>Vehicle Purchase Loan</h4>
                                                <p>Drive your dream car or vehicle home with instant disbursals, high
                                                    limits, and flexible tenure plans.</p>
                                            </div>
                                            <div>
                                                <div class="rate-badge" id="badge-rate-vehicle">8.50% <span
                                                        style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span>
                                                </div>
                                                <div id="badge-max-vehicle"
                                                    style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">
                                                    Max: ₹ 50,00,000</div>
                                                <div
                                                    style="display: flex; gap: 8px; align-items: center; width: 100%; margin-top: auto;">
                                                    <button type="button" class="btn btn-primary"
                                                        onclick="event.stopPropagation(); openAdminLoanForm('vehicle', getSpecValue('vehicle', 'rate'), getSpecValue('vehicle', 'max'))"
                                                        style="flex-grow: 1; padding: 8px 12px; font-size: 0.75rem; background: linear-gradient(135deg, #a855f7 0%, #ec4899 100%); border: none;">Apply
                                                        Now</button>
                                                    <button type="button" class="edit-specs-btn"
                                                        onclick="event.stopPropagation(); openEditSpecsModal('vehicle')"
                                                        style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: none; border-radius: var(--radius-md); width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s;"
                                                        title="Edit Interest Rate and Max Limit"><i class="bx bx-cog"
                                                            style="font-size: 1.15rem; vertical-align: middle;"></i></button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Education Loan -->
                                        <div class="loan-product-card" id="card-education"
                                            onclick="showAdminLoanDetails('education', 6.50, 4000000)">
                                            <div>
                                                <h4>Higher Education Loan</h4>
                                                <p>Fund premium global academic pursuits, covering university fees,
                                                    travel, and accommodation costs.</p>
                                            </div>
                                            <div>
                                                <div class="rate-badge" id="badge-rate-education">6.50% <span
                                                        style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span>
                                                </div>
                                                <div id="badge-max-education"
                                                    style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">
                                                    Max: ₹ 40,00,000</div>
                                                <div
                                                    style="display: flex; gap: 8px; align-items: center; width: 100%; margin-top: auto;">
                                                    <button type="button" class="btn btn-primary"
                                                        onclick="event.stopPropagation(); openAdminLoanForm('education', getSpecValue('education', 'rate'), getSpecValue('education', 'max'))"
                                                        style="flex-grow: 1; padding: 8px 12px; font-size: 0.75rem; background: linear-gradient(135deg, #a855f7 0%, #ec4899 100%); border: none;">Apply
                                                        Now</button>
                                                    <button type="button" class="edit-specs-btn"
                                                        onclick="event.stopPropagation(); openEditSpecsModal('education')"
                                                        style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: none; border-radius: var(--radius-md); width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s;"
                                                        title="Edit Interest Rate and Max Limit"><i class="bx bx-cog"
                                                            style="font-size: 1.15rem; vertical-align: middle;"></i></button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Business Loan -->
                                        <div class="loan-product-card" id="card-business"
                                            onclick="showAdminLoanDetails('business', 10.50, 10000000)">
                                            <div>
                                                <h4>Business Capital Loan</h4>
                                                <p>Power your business venture, purchase heavy equipment, expand
                                                    infrastructure, or boost cashflow.</p>
                                            </div>
                                            <div>
                                                <div class="rate-badge" id="badge-rate-business">10.50% <span
                                                        style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span>
                                                </div>
                                                <div id="badge-max-business"
                                                    style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">
                                                    Max: ₹ 1,00,00,000</div>
                                                <div
                                                    style="display: flex; gap: 8px; align-items: center; width: 100%; margin-top: auto;">
                                                    <button type="button" class="btn btn-primary"
                                                        onclick="event.stopPropagation(); openAdminLoanForm('business', getSpecValue('business', 'rate'), getSpecValue('business', 'max'))"
                                                        style="flex-grow: 1; padding: 8px 12px; font-size: 0.75rem; background: linear-gradient(135deg, #a855f7 0%, #ec4899 100%); border: none;">Apply
                                                        Now</button>
                                                    <button type="button" class="edit-specs-btn"
                                                        onclick="event.stopPropagation(); openEditSpecsModal('business')"
                                                        style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: none; border-radius: var(--radius-md); width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s;"
                                                        title="Edit Interest Rate and Max Limit"><i class="bx bx-cog"
                                                            style="font-size: 1.15rem; vertical-align: middle;"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Mode 2: Update Existing Loan Container -->
                        <div id="update-existing-mode-container" style="display: none;">
                            <div class="glass-card" style="padding: 25px; border-radius: var(--radius-md);">
                                <h3
                                    style="font-size: 1.3rem; font-weight: 700; color: var(--gray-900); margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-list-ul" style="color: var(--primary-500);"></i>
                                    <span>Select a Loan Portfolio to Update</span>
                                </h3>
                                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 20px;">
                                    Choose a customer's active, approved, or pending loan portfolio below to edit
                                    details.
                                </p>
                                <div class="table-responsive" style="overflow-x: auto; width: 100%;">
                                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                                        <thead>
                                            <tr
                                                style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                                <th style="padding: 12px 15px; width: 120px;">Loan ID</th>
                                                <th style="padding: 12px 15px;">Customer Name</th>
                                                <th style="padding: 12px 15px;">Loan Category</th>
                                                <th style="padding: 12px 15px;">Principal</th>
                                                <th style="padding: 12px 15px;">Term Length</th>
                                                <th style="padding: 12px 15px; text-align: center;">Status</th>
                                                <th style="padding: 12px 15px; text-align: center;">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="loan" items="${loans}">
                                                <tr
                                                    style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                                    <td style="padding: 15px;"><span
                                                            class="badge-id">#LN-${loan.loanId}</span></td>
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
                                                    <td style="padding: 15px;">${loan.termMonths} Months</td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <c:choose>
                                                            <c:when test="${loan.status == 'pending_approval'}">
                                                                <span
                                                                    style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Pending</span>
                                                            </c:when>
                                                            <c:when test="${loan.status == 'approved'}">
                                                                <span
                                                                    style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Approved</span>
                                                            </c:when>
                                                            <c:when
                                                                test="${loan.status == 'active' or loan.status == 'disbursed'}">
                                                                <span
                                                                    style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">${loan.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="padding: 15px; text-align: center;">
                                                        <button type="button" class="btn btn-secondary"
                                                            onclick="openAdminLoanUpdateForm('${loan.loanId}', '${loan.customerId}', '${loan.loanType}', '${loan.principalAmount}', '${loan.interestRate}', '${loan.termMonths}', this.getAttribute('data-form-details'))"
                                                            data-form-details="<c:out value=" ${loan.formDetails}" />"
                                                        style="padding: 6px 12px;
                                                        font-size: 0.75rem; border-color: var(--primary-500); color:
                                                        var(--primary-500); display: inline-flex; align-items:
                                                        center; gap: 4px;">
                                                        <i class="bx bx-edit"></i>
                                                        <span>Update Details</span>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty loans}">
                                                <tr>
                                                    <td colspan="7"
                                                        style="text-align: center; padding: 30px; color: var(--gray-400);">
                                                        No loans registered in the system.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
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
                                <i class="bx bx-wallet" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                                Execute Loan Disbursement
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
                                    <select name="accountId" id="disburseAccount" required class="control-select"
                                        style="font-weight: 500;">
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
                                <i class="bx bx-wallet-alt" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                                Execute Loan
                                Repayment
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
                                    <select name="accountId" id="repayAccount" required class="control-select"
                                        style="font-weight: 500;">
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

                    <!-- Edit Loan Specs Modal Overlay (Admin Page Custom Specs Editor) -->
                    <div id="editSpecsModal"
                        style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; padding: 20px;"
                        class="no-print">
                        <div class="modal-card"
                            style="width: 100%; max-width: 450px; position: relative; margin-bottom: 0;">
                            <button type="button" onclick="closeEditSpecsModal()" class="close-btn"
                                style="position: absolute; top: 25px; right: 25px; font-size: 1.5rem; line-height: 1;"><i
                                    class="bx bx-x"></i></button>

                            <h3
                                style="font-size: 1.3rem; font-weight: 700; color: var(--gray-900); margin-bottom: 25px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-cog" style="color: var(--primary-500); font-size: 1.5rem;"></i> Edit
                                Loan Specifications
                            </h3>
                            <form id="editSpecsForm" onsubmit="saveSpecsChanges(event)">
                                <input type="hidden" id="editSpecsType">

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label
                                        style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Loan
                                        Category</label>
                                    <input type="text" id="editSpecsTitle" readonly class="control-input"
                                        style="font-weight: 700; color: var(--gray-900); background: rgba(99, 102, 241, 0.04); border-color: rgba(99, 102, 241, 0.15);">
                                </div>

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label for="editSpecsRate"
                                        style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Interest
                                        Rate (% Fixed P.A.)</label>
                                    <input type="number" step="0.01" min="0.1" max="99.9" id="editSpecsRate" required
                                        class="control-input" style="font-weight: 600;">
                                </div>

                                <div class="form-group" style="margin-bottom: 25px;">
                                    <label for="editSpecsMax"
                                        style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Maximum
                                        Limit Amount (₹)</label>
                                    <input type="number" min="1000" max="999999999" id="editSpecsMax" required
                                        class="control-input" style="font-weight: 600;">
                                </div>

                                <div style="display: flex; gap: 15px; justify-content: flex-end; margin-top: 30px;">
                                    <button type="button" class="btn btn-secondary" onclick="closeEditSpecsModal()"
                                        style="background: transparent !important; border: none !important; color: var(--gray-600) !important; padding: 10px 24px; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; transition: color 0.2s ease;">Cancel</button>
                                    <button type="submit" class="btn btn-primary"
                                        style="background: var(--gradient-primary) !important; border: none !important; color: white !important; padding: 10px 24px; font-weight: 700; border-radius: var(--radius-full); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25); transition: all 0.3s ease;">
                                        <span>Save Changes</span>
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
                                    <div
                                        style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                                        <span
                                            style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official
                                            Loan Amortization &amp; Repayment Statement</span>
                                    </div>

                                    <!-- Details grid (Bank details vs Borrower details) -->
                                    <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);"
                                        class="mobile-grid-1">
                                        <!-- Left: Bank Information -->
                                        <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                                            <span
                                                style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank
                                                Details</span>
                                            <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate
                                                HQ)</strong>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate
                                                Towers, BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra -
                                                400051</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code:
                                                <strong style="font-family: monospace;">VGBK0000001</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free:
                                                1800-VGB-BANK</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal:
                                                www.vertexgalaxybank.com</p>
                                        </div>

                                        <!-- Right: Customer & Loan Details -->
                                        <div>
                                            <span
                                                style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer
                                                &amp; Loan Details</span>
                                            <strong
                                                style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;">${statementCustomer.firstName}
                                                ${statementCustomer.lastName}</strong>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong
                                                    style="font-family: monospace;">#VGB-CUST-${statementCustomer.customerId}</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address:
                                                ${statementCustomer.address}, ${statementCustomer.city},
                                                ${statementCustomer.state} - ${statementCustomer.zipCode}</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Loan Reference:
                                                <strong
                                                    style="font-family: monospace;">#LN-${statementLoan.loanId}</strong>
                                                (${statementLoan.loanType} Loan)
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Principal Amount:
                                                <strong>₹
                                                    <fmt:formatNumber value="${statementLoan.principalAmount}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Interest Rate /
                                                Term: <strong>${statementLoan.interestRate}% P.A. /
                                                    ${statementLoan.termMonths} Mos</strong></p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Accumulated Repaid:
                                                <strong style="color: var(--accent-emerald);">₹
                                                    <fmt:formatNumber value="${totalRepaid}" minFractionDigits="2"
                                                        maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Outstanding Balance:
                                                <strong style="color: var(--secondary-500);">₹
                                                    <fmt:formatNumber value="${statementLoan.remainingBalance}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Repayment Schedule List -->
                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                                        <h4
                                            style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                                            <i class="bx bx-history" style="color: var(--primary-500);"></i>
                                            Repayment Ledger Log
                                        </h4>
                                        <button type="button" onclick="window.print()" class="btn btn-primary no-print"
                                            style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px;">
                                            <span>Print Document</span>
                                            <i class="bx bx-printer"></i>
                                        </button>
                                    </div>
                                    <div
                                        style="overflow-x: auto; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); box-shadow: var(--shadow-sm); margin-bottom: 25px;">
                                        <table
                                            style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem; margin-bottom: 0;">
                                            <thead>
                                                <tr
                                                    style="background: rgba(99, 102, 241, 0.04); color: var(--gray-700); border-bottom: 2px solid var(--gray-200);">
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; width: 80px;">
                                                        Sr. No.</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">
                                                        Payment Date</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">
                                                        Type</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">
                                                        Description</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">
                                                        Status</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">
                                                        Credit Amount</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">
                                                        Debit Amount</th>
                                                    <th
                                                        style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">
                                                        Total Amount</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when
                                                        test="${not empty statementRepayments || not empty statementLoan}">
                                                        <c:set var="repaySr" value="0" />
                                                        <c:set var="runningLoanBal"
                                                            value="${statementLoan.remainingBalance}" />

                                                        <!-- Repayment rows -->
                                                        <c:forEach var="repay" items="${statementRepayments}">
                                                            <c:set var="repaySr" value="${repaySr + 1}" />
                                                            <tr
                                                                style="border-bottom: 1px solid var(--gray-200); color: var(--gray-700); transition: background 0.15s ease;">
                                                                <td
                                                                    style="padding: 14px 16px; font-weight: 600; color: var(--gray-500);">
                                                                    <span class="badge-id">#${repaySr}</span>
                                                                </td>
                                                                <td style="padding: 14px 16px;">
                                                                    ${repay.formattedRepaymentDate}</td>
                                                                <td
                                                                    style="padding: 14px 16px; text-transform: capitalize; font-weight: 600;">
                                                                    <span class="txn-deposit"
                                                                        style="color: var(--accent-emerald) !important;">Repayment</span>
                                                                </td>
                                                                <td style="padding: 14px 16px;">EMI Repayment
                                                                    (Principal: ₹
                                                                    <fmt:formatNumber
                                                                        value="${repay.principalComponent}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />,
                                                                    Interest: ₹
                                                                    <fmt:formatNumber value="${repay.interestComponent}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />)
                                                                </td>
                                                                <td style="padding: 14px 16px;">
                                                                    <span
                                                                        style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">COMPLETED</span>
                                                                </td>
                                                                <td
                                                                    style="padding: 14px 16px; text-align: right; font-weight: 700; color: #10b981;">
                                                                    + ₹
                                                                    <fmt:formatNumber value="${repay.amountPaid}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                                <td
                                                                    style="padding: 14px 16px; text-align: right; font-weight: 700; color: #ef4444;">
                                                                    -</td>
                                                                <td
                                                                    style="padding: 14px 16px; text-align: right; font-weight: 700; color: #1e3a8a; font-family: monospace;">
                                                                    ₹
                                                                    <fmt:formatNumber value="${runningLoanBal}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                            </tr>
                                                            <c:set var="runningLoanBal"
                                                                value="${runningLoanBal + repay.principalComponent}" />
                                                        </c:forEach>

                                                        <!-- Initial Disbursal row -->
                                                        <c:if test="${not empty statementLoan}">
                                                            <c:set var="repaySr" value="${repaySr + 1}" />
                                                            <tr
                                                                style="border-bottom: 1px solid var(--gray-200); color: var(--gray-700); transition: background 0.15s ease;">
                                                                <td
                                                                    style="padding: 14px 16px; font-weight: 600; color: var(--gray-500);">
                                                                    <span class="badge-id">#${repaySr}</span>
                                                                </td>
                                                                <td style="padding: 14px 16px;">
                                                                    ${statementLoan.startDate}</td>
                                                                <td
                                                                    style="padding: 14px 16px; text-transform: capitalize; font-weight: 600;">
                                                                    <span class="txn-withdrawal"
                                                                        style="color: var(--secondary-500) !important;">Disbursal</span>
                                                                </td>
                                                                <td style="padding: 14px 16px;">Initial
                                                                    ${statementLoan.loanType} Loan Disbursal</td>
                                                                <td style="padding: 14px 16px;">
                                                                    <span
                                                                        style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">COMPLETED</span>
                                                                </td>
                                                                <td
                                                                    style="padding: 14px 16px; text-align: right; font-weight: 700; color: #10b981;">
                                                                    -</td>
                                                                <td
                                                                    style="padding: 14px 16px; text-align: right; font-weight: 700; color: #ef4444;">
                                                                    - ₹
                                                                    <fmt:formatNumber
                                                                        value="${statementLoan.principalAmount}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                                <td
                                                                    style="padding: 14px 16px; text-align: right; font-weight: 700; color: #1e3a8a; font-family: monospace;">
                                                                    ₹
                                                                    <fmt:formatNumber
                                                                        value="${statementLoan.principalAmount}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="8"
                                                                style="text-align: center; padding: 35px; color: var(--gray-400); font-style: italic;">
                                                                <i class="bx bx-info-circle"
                                                                    style="font-size: 1.5rem; display: block; margin-bottom: 8px;"></i>
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
                                    <button type="button" class="btn btn-secondary" onclick="closeStatementModal()"
                                        style="border-radius: var(--radius-full); padding: 10px 24px;">Close
                                        View</button>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- High-Fidelity Premium Loan Details Modal (Admin Side) -->
                    <div id="adminLoanDetailsModal"
                        style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); z-index: 1050; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
                        <div class="modal-content"
                            style="width: 100%; max-width: 650px; background: white; border-radius: var(--radius-lg); box-shadow: var(--shadow-2xl); border: 1px solid rgba(99, 102, 241, 0.2); display: flex; flex-direction: column; overflow: hidden;">
                            <!-- Header with premium gradient background -->
                            <div
                                style="padding: 25px 30px; background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%); display: flex; justify-content: space-between; align-items: center; color: white;">
                                <h3 id="adminDetailsModalTitle"
                                    style="font-size: 1.35rem; font-weight: 800; display: flex; align-items: center; gap: 10px; margin: 0; letter-spacing: 0.5px;">
                                    <i class="bx bx-info-circle" style="font-size: 1.6rem;"></i>
                                    <span>Loan Product Specification</span>
                                </h3>
                                <button type="button" onclick="closeAdminDetailsModal()"
                                    style="font-size: 1.6rem; color: rgba(255, 255, 255, 0.8); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;"
                                    onmouseover="this.style.color='#fff'"
                                    onmouseout="this.style.color='rgba(255, 255, 255, 0.8)'"><i
                                        class="bx bx-x"></i></button>
                            </div>

                            <!-- Body with loan type specifications -->
                            <div
                                style="padding: 30px; background: var(--gray-50); flex-grow: 1; max-height: 70vh; overflow-y: auto;">
                                <!-- Overview Section -->
                                <div
                                    style="background: white; padding: 20px; border-radius: var(--radius-md); border: 1px solid var(--gray-200); margin-bottom: 20px;">
                                    <p id="adminDetailsDescription"
                                        style="font-size: 0.95rem; color: var(--gray-700); line-height: 1.6; margin: 0;">
                                    </p>
                                </div>

                                <!-- Rate & Limit badges -->
                                <div
                                    style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px;">
                                    <div
                                        style="background: rgba(99, 102, 241, 0.05); border: 1.5px solid rgba(99, 102, 241, 0.15); padding: 15px; border-radius: var(--radius-md); text-align: center;">
                                        <span
                                            style="font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; display: block;">Fixed
                                            Interest Rate</span>
                                        <strong id="adminDetailsInterestRate"
                                            style="font-size: 1.6rem; color: var(--primary-600); font-weight: 800; display: block; margin-top: 5px;"></strong>
                                    </div>
                                    <div
                                        style="background: rgba(16, 185, 129, 0.05); border: 1.5px solid rgba(16, 185, 129, 0.15); padding: 15px; border-radius: var(--radius-md); text-align: center;">
                                        <span
                                            style="font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; display: block;">Maximum
                                            Credit Limit</span>
                                        <strong id="adminDetailsMaxLimit"
                                            style="font-size: 1.6rem; color: var(--accent-emerald); font-weight: 800; display: block; margin-top: 5px;"></strong>
                                    </div>
                                </div>

                                <!-- Benefits grid -->
                                <div style="margin-bottom: 25px;">
                                    <h4
                                        style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                        <i class="bx bx-check-shield"
                                            style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                        <span>Key Product Benefits</span>
                                    </h4>
                                    <ul id="adminDetailsBenefits"
                                        style="list-style: none; padding: 0; margin: 0; display: grid; grid-template-columns: 1fr; gap: 8px;">
                                    </ul>
                                </div>

                                <!-- Eligibility & Docs columns -->
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;"
                                    class="mobile-grid-1">
                                    <div>
                                        <h4
                                            style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                            <i class="bx bx-user"
                                                style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                            <span>Eligibility Criteria</span>
                                        </h4>
                                        <ul id="adminDetailsEligibility"
                                            style="padding-left: 20px; margin: 0; font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                                        </ul>
                                    </div>
                                    <div>
                                        <h4
                                            style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                            <i class="bx bx-file"
                                                style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                            <span>Required Documentation</span>
                                        </h4>
                                        <ul id="adminDetailsDocuments"
                                            style="padding-left: 20px; margin: 0; font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Footer buttons -->
                             <div
                                 style="padding: 20px 30px; border-top: 1px solid var(--gray-200); display: flex; justify-content: flex-end; gap: 15px; background: white; align-items: center;">
                                 <button type="button" class="btn btn-secondary" onclick="closeAdminDetailsModal()"
                                     style="padding: 10px 22px;">Close</button>
                                 <button type="button" id="adminDetailsEditSpecsBtn" class="edit-specs-btn"
                                     style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: none; border-radius: var(--radius-md); width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s;"
                                     title="Edit Interest Rate and Max Limit">
                                     <i class="bx bx-cog" style="font-size: 1.35rem; vertical-align: middle;"></i>
                                 </button>
                                 <button type="button" id="adminDetailsApplyBtn" class="btn btn-primary"
                                     style="padding: 10px 25px; display: flex; align-items: center; gap: 8px; background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                                     <span>Apply Now</span>
                                     <i class="bx bx-chevron-right"></i>
                                 </button>
                             </div>
                        </div>
                    </div>

                    <!-- Admin Apply Loan Modal -->
                    <div id="adminApplyModal"
                        style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); z-index: 1000; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
                        <div class="modal-content"
                            style="width: 100%; max-width: 850px; background: white; border-radius: var(--radius-lg); box-shadow: var(--shadow-2xl); border: 1px solid rgba(99, 102, 241, 0.2); display: flex; flex-direction: column; max-height: 90vh;">
                            <div class="modal-header no-print"
                                style="padding: 20px 30px; border-bottom: 1px solid var(--gray-200); display: flex; justify-content: space-between; align-items: center; background: var(--gray-50); border-top-left-radius: var(--radius-lg); border-top-right-radius: var(--radius-lg);">
                                <h3
                                    style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 10px; margin: 0;">
                                    <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                                    <span id="adminApplyModalTitle">Official Loan Application Form (Admin
                                        Portal)</span>
                                </h3>
                                <button type="button" onclick="closeAdminApplyModal()"
                                    style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none; outline: none;"><i
                                        class="bx bx-x"></i></button>
                            </div>
                            <div class="modal-body"
                                style="padding: 30px; overflow-y: auto; flex-grow: 1; background: var(--gray-100);">
                                <form id="adminApplyForm" action="${pageContext.request.contextPath}/loan" method="post"
                                    onsubmit="return serializeAdminLoanForm(event)">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                    <input type="hidden" id="submitFormAction" name="action" value="apply">
                                    <input type="hidden" id="submitAdminLoanId" name="loanId" value="">

                                    <!-- Main hidden inputs submitted to server -->
                                    <input type="hidden" id="submitAdminLoanType" name="loanType">
                                    <input type="hidden" id="submitAdminAmount" name="amount">
                                    <input type="hidden" id="submitAdminTermMonths" name="termMonths">
                                    <input type="hidden" id="submitAdminInterestRate" name="interestRate">
                                    <input type="hidden" id="adminSubmitFormDetails" name="formDetails">

                                    <!-- Select Customer Dropdown (outside printable page area but inside form) -->
                                    <div class="no-print"
                                        style="background: white; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); padding: 15px; margin-bottom: 20px; box-shadow: var(--shadow-sm);">
                                        <label
                                            style="display: block; font-size: 0.85rem; font-weight: 700; color: var(--gray-700); margin-bottom: 8px;">Select
                                            Customer Profile to Apply For:</label>
                                        <select id="adminApplyCustomerId" name="customerId" required
                                            onchange="syncAdminCustomerDetails(this)" class="control-select"
                                            style="font-weight: 600;">
                                            <option value="" disabled selected>-- Choose Customer --</option>
                                            <c:forEach var="cust" items="${customers}">
                                                <option value="${cust.customerId}" data-fullname="${cust.fullName}"
                                                    data-phone="${cust.phoneNo}" data-email="${cust.email}"
                                                    data-aadhaar="${cust.aadhaarCard}" data-pan="${cust.panCard}"
                                                    data-address="${cust.address}" data-city="${cust.city}"
                                                    data-state="${cust.state}" data-zipcode="${cust.zipCode}"
                                                    data-dob="${cust.dob}" data-gender="${cust.gender}"
                                                    data-occupation="${cust.occupation}">
                                                    ${cust.fullName} (ID: #${cust.customerId})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="loan-paper-form">
                                        <h1>Loan Application Form</h1>

                                        <!-- 1. Applicant Information -->
                                        <h2>1. Applicant Information</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 30%; font-weight: bold;">Full Name:</td>
                                                <td style="width: 70%;"><input type="text" id="adminFormFullName"
                                                        readonly style="font-weight: 600;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Father's / Husband's Name:</td>
                                                <td><input type="text" id="adminFormRelationName"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Date of Birth:</td>
                                                <td><input type="date" id="adminFormDob" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Gender:</td>
                                                <td>
                                                    <div style="display: flex; gap: 20px;">
                                                        <label><input type="radio" name="adminFormGender" value="Male"
                                                                required> Male</label>
                                                        <label><input type="radio" name="adminFormGender"
                                                                value="Female"> Female</label>
                                                        <label><input type="radio" name="adminFormGender" value="Other">
                                                            Other</label>
                                                    </div>
                                                </td>
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
                                        <h3
                                            style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 10px 0 5px 0;">
                                            Current Address</h3>
                                        <div id="adminFormCurrentAddressDisplay"
                                            style="border-bottom: 1px dotted #475569; padding: 5px 0 10px 0; margin-bottom: 10px; font-weight: 600; min-height: 25px;">
                                        </div>
                                        <input type="hidden" id="adminFormCurrentAddressHidden">

                                        <h3
                                            style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 15px 0 5px 0;">
                                            Permanent Address</h3>
                                        <div style="margin-bottom: 10px;" class="no-print">
                                            <label style="font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                                <input type="checkbox" id="adminFormSameAsCurrent"
                                                    onchange="copyAdminCurrentAddress(this)"> Same as Current
                                                Address
                                            </label>
                                        </div>
                                        <textarea id="adminFormPermanentAddress"
                                            placeholder="______________________________________________________"
                                            required
                                            style="width: 100%; border: none; border-bottom: 1px dotted #475569; font-family: inherit; font-size: inherit; font-weight: 600; outline: none; background: transparent; resize: none; height: 50px;"></textarea>

                                        <!-- 3. Identity Details -->
                                        <h2>3. Identity Details</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Aadhaar Number:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormAadhaar"
                                                        readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">PAN Number:</td>
                                                <td><input type="text" id="adminFormPan" readonly
                                                        style="text-transform: uppercase;"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Voter ID / Driving License No.:</td>
                                                <td><input type="text" id="adminFormVoterDl"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                        </table>

                                        <!-- 4. Employment Information -->
                                        <h2>4. Employment Information</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Occupation:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormOccupation"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Company / Business Name:</td>
                                                <td><input type="text" id="adminFormCompanyName"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Monthly Income:</td>
                                                <td><input type="number" id="adminFormMonthlyIncome"
                                                        placeholder="₹ ______________________" required min="1000">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Work Experience:</td>
                                                <td><input type="text" id="adminFormExperience"
                                                        placeholder="_____________________" required></td>
                                            </tr>
                                        </table>

                                        <!-- 5. Bank Account Details -->
                                        <h2>5. Bank Account Details</h2>
                                        <p style="font-size: 0.85rem; font-style: italic; color: #64748b; margin-bottom: 10px;"
                                            class="no-print">Choose one of the customer's active VGB savings or
                                            checking accounts to link with this loan for disbursal and EMI payments.
                                        </p>
                                        <table>
                                            <tr class="no-print">
                                                <td style="width: 35%; font-weight: bold;">Select Account to Link:
                                                </td>
                                                <td style="width: 65%;">
                                                    <select id="adminFormLinkAccount"
                                                        onchange="syncAdminLinkedAccountDetails(this)"
                                                        style="font-weight: 600; padding: 5px; cursor: pointer;">
                                                        <option value="" disabled selected>-- Select Customer VGB
                                                            Account --</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Account Holder Name:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormAccHolderName"
                                                        readonly></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Account Number:</td>
                                                <td><input type="text" id="adminFormAccNo" readonly
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">IFSC Code:</td>
                                                <td><input type="text" id="adminFormIfsc" readonly
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Branch:</td>
                                                <td><input type="text" id="adminFormBranch" readonly
                                                        value="VGB Main Branch" style="font-weight: 600;"></td>
                                            </tr>
                                        </table>

                                        <!-- 6. Loan Details -->
                                        <h2>6. Loan Details</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Loan Type:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormLoanTypeDisplay"
                                                        readonly style="font-weight: bold; text-transform: uppercase;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Requested Amount (₹):</td>
                                                <td><input type="number" id="adminFormLoanAmount"
                                                        placeholder="______________________" required
                                                        oninput="calculateAdminPaperEMI()"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Tenure Duration:</td>
                                                <td>
                                                    <div style="display: flex; gap: 10px;">
                                                        <input type="number" id="adminFormLoanTermVal"
                                                            placeholder="Tenure" required style="width: 60%;"
                                                            oninput="syncAdminPaperTermMonths()">
                                                        <select id="adminFormLoanTermUnit"
                                                            style="width: 40%; font-weight: 600;"
                                                            onchange="syncAdminPaperTermMonths()">
                                                            <option value="years" selected>Years</option>
                                                            <option value="months">Months</option>
                                                        </select>
                                                    </div>
                                                    <input type="hidden" id="adminFormLoanTermMonths">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Fixed Interest Rate:</td>
                                                <td><input type="text" id="adminFormLoanRate" readonly
                                                        style="font-weight: 600; color: var(--primary-500);"></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Purpose of Loan:</td>
                                                <td><input type="text" id="adminFormLoanPurpose"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Estimated Monthly EMI:</td>
                                                <td style="font-weight: bold; font-size: 1.1rem; color: #0f172a;"
                                                    id="adminFormPaperEmiDisplay">₹ 0.00</td>
                                            </tr>
                                        </table>

                                        <!-- 7. Nominee Information -->
                                        <h2>7. Nominee Information</h2>
                                        <table>
                                            <tr>
                                                <td style="width: 35%; font-weight: bold;">Nominee Name:</td>
                                                <td style="width: 65%;"><input type="text" id="adminFormNomineeName"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Relationship with Applicant:</td>
                                                <td><input type="text" id="adminFormNomineeRelationship"
                                                        placeholder="___________________________" required></td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold;">Nominee Mobile Number:</td>
                                                <td><input type="text" id="adminFormNomineeMobile"
                                                        placeholder="___________________________" required
                                                        pattern="[0-9]{10}"></td>
                                            </tr>
                                        </table>

                                        <!-- 8. Declaration -->
                                        <h2>8. Declaration</h2>
                                        <div
                                            style="margin-bottom: 20px; font-size: 0.9rem; text-align: justify; line-height: 1.5; color: #334155;">
                                            <label
                                                style="cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                                <input type="checkbox" id="adminFormDeclarationCheckbox" required
                                                    style="margin-top: 4px;">
                                                <span>I hereby declare that the details furnished above are true and
                                                    correct to the best of my knowledge and belief and I undertake
                                                    to inform Vertex Galaxy Bank of any changes therein,
                                                    immediately. In case any of the above information is found to be
                                                    false or untrue or misleading, I am aware that I may be held
                                                    liable for it. I authorize the Bank to debit my linked account
                                                    for recovery of EMI.</span>
                                            </label>
                                        </div>

                                        <div
                                            style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; margin-top: 30px;">
                                            <div>
                                                <table style="margin-bottom: 0;">
                                                    <tr>
                                                        <td style="width: 30%; font-weight: bold;">Date:</td>
                                                        <td style="width: 70%;"><input type="text"
                                                                id="adminFormDeclarationDate" readonly></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="font-weight: bold;">Place:</td>
                                                        <td><input type="text" id="adminFormDeclarationPlace"
                                                                placeholder="___________________________" required>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div
                                                style="text-align: center; display: flex; flex-direction: column; justify-content: flex-end; align-items: center;">
                                                <input type="text" id="adminFormSignature" placeholder="Type to sign"
                                                    required
                                                    style="text-align: center; font-family: 'Brush Script MT', cursive, Georgia, serif; font-size: 1.5rem; border-bottom: 1.5px solid #000 !important; width: 85%;">
                                                <span
                                                    style="font-size: 0.75rem; font-weight: bold; color: #475569; text-transform: uppercase; margin-top: 5px; display: block;">Applicant's
                                                    Signature</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Action Buttons (inside form, shown only on screen) -->
                                    <div class="no-print"
                                        style="margin-top: 30px; display: flex; gap: 15px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid var(--gray-200);">
                                        <button type="button" class="btn btn-secondary" onclick="closeAdminApplyModal()"
                                            style="padding: 10px 22px;">Close</button>
                                        <button type="button" class="btn btn-secondary" onclick="printAdminApplyForm()"
                                            style="padding: 10px 22px; display: flex; align-items: center; gap: 8px; border: 1.5px solid var(--gray-300); color: var(--gray-700); background: white;">
                                            <i class="bx bx-printer"></i>
                                            <span>Print Form</span>
                                        </button>
                                        <button type="submit" class="btn btn-primary"
                                            style="padding: 10px 25px; background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%); border: none;">
                                            <span>Submit Application</span>
                                            <i class="bx bx-paper-plane"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Admin View Loan Application Modal -->
                    <div id="adminViewModal"
                        style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); z-index: 1000; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
                        <div class="modal-content"
                            style="width: 100%; max-width: 850px; display: flex; flex-direction: column; max-height: 90vh;">
                            <div class="modal-header no-print">
                                <h3
                                    style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 10px;">
                                    <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                                    <span>Review Loan Application File</span>
                                </h3>
                                <button type="button" onclick="closeAdminViewModal()"
                                    style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;"
                                    onmouseover="this.style.color='var(--gray-900)'"
                                    onmouseout="this.style.color='var(--gray-400)'"><i class="bx bx-x"></i></button>
                            </div>

                            <div class="modal-body"
                                style="padding: 30px; overflow-y: auto; flex-grow: 1; background: var(--gray-100);">
                                <div class="loan-paper-form">
                                    <div
                                        style="text-align: right; font-family: monospace; font-size: 0.8rem; color: var(--gray-500); margin-bottom: 10px;">
                                        LOAN APPLICATION REF: <span id="adminViewLoanId"
                                            style="font-weight: bold;"></span>
                                    </div>
                                    <h1>Loan Application Form</h1>

                                    <!-- 1. Applicant Information -->
                                    <h2>1. Applicant Information</h2>
                                    <table>
                                        <tr>
                                            <td style="width: 30%; font-weight: bold;">Full Name:</td>
                                            <td style="width: 70%;"><input type="text" id="adminViewFormFullName" readonly
                                                    style="font-weight: 600;"></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Father's / Husband's Name:</td>
                                            <td><input type="text" id="adminViewFormRelationName" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Date of Birth:</td>
                                            <td><input type="text" id="adminViewFormDob" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Gender:</td>
                                            <td><input type="text" id="adminViewFormGender" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Mobile Number:</td>
                                            <td><input type="text" id="adminViewFormMobile" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Email Address:</td>
                                            <td><input type="text" id="adminViewFormEmail" readonly></td>
                                        </tr>
                                    </table>

                                    <!-- 2. Address Details -->
                                    <h2>2. Address Details</h2>
                                    <h3
                                        style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 10px 0 5px 0;">
                                        Current Address</h3>
                                    <div id="adminViewFormCurrentAddress"
                                        style="border-bottom: 1px dotted #475569; padding: 5px 0; font-weight: 600;">
                                    </div>

                                    <h3
                                        style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 15px 0 5px 0;">
                                        Permanent Address</h3>
                                    <div id="adminViewFormPermanentAddress"
                                        style="border-bottom: 1px dotted #475569; padding: 5px 0; font-weight: 600; min-height: 25px;">
                                    </div>

                                    <!-- 3. Identity Details -->
                                    <h2>3. Identity Details</h2>
                                    <table>
                                        <tr>
                                            <td style="width: 35%; font-weight: bold;">Aadhaar Number:</td>
                                            <td style="width: 65%;"><input type="text" id="adminViewFormAadhaar" readonly>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">PAN Number:</td>
                                            <td><input type="text" id="adminViewFormPan" readonly
                                                    style="text-transform: uppercase;"></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Voter ID / Driving License No.:</td>
                                            <td><input type="text" id="adminViewFormVoterDl" readonly></td>
                                        </tr>
                                    </table>

                                    <!-- 4. Employment Information -->
                                    <h2>4. Employment Information</h2>
                                    <table>
                                        <tr>
                                            <td style="width: 35%; font-weight: bold;">Occupation:</td>
                                            <td style="width: 65%;"><input type="text" id="adminViewFormOccupation"
                                                    readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Company / Business Name:</td>
                                            <td><input type="text" id="adminViewFormCompanyName" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Monthly Income:</td>
                                            <td><input type="text" id="adminViewFormMonthlyIncome" readonly
                                                    style="font-weight: 600;"></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Work Experience:</td>
                                            <td><input type="text" id="adminViewFormExperience" readonly></td>
                                        </tr>
                                    </table>

                                    <!-- 5. Bank Account Details -->
                                    <h2>5. Bank Account Details</h2>
                                    <table>
                                        <tr>
                                            <td style="width: 35%; font-weight: bold;">Account Holder Name:</td>
                                            <td style="width: 65%;"><input type="text" id="adminViewFormAccHolderName"
                                                    readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Account Number:</td>
                                            <td><input type="text" id="adminViewFormAccNo" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">IFSC Code:</td>
                                            <td><input type="text" id="adminViewFormIfsc" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Branch:</td>
                                            <td><input type="text" id="adminViewFormBranch" readonly></td>
                                        </tr>
                                    </table>

                                    <!-- 6. Loan Details -->
                                    <h2>6. Loan Details</h2>
                                    <table>
                                        <tr>
                                            <td style="width: 35%; font-weight: bold;">Loan Type:</td>
                                            <td style="width: 65%;"><input type="text" id="adminViewFormLoanType" readonly
                                                    style="font-weight: bold; text-transform: uppercase;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Requested Amount (₹):</td>
                                            <td><input type="text" id="adminViewFormLoanAmount" readonly
                                                    style="font-weight: bold;"></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Tenure Duration:</td>
                                            <td><input type="text" id="adminViewFormLoanTenure" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Fixed Interest Rate:</td>
                                            <td><input type="text" id="adminViewFormLoanRate" readonly
                                                    style="font-weight: 600; color: var(--primary-500);"></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Purpose of Loan:</td>
                                            <td><input type="text" id="adminViewFormLoanPurpose" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Estimated Monthly EMI:</td>
                                            <td style="font-weight: bold; font-size: 1.1rem; color: #0f172a;"
                                                id="adminViewFormPaperEmiDisplay">₹ 0.00</td>
                                        </tr>
                                    </table>

                                    <!-- 7. Nominee Information -->
                                    <h2>7. Nominee Information</h2>
                                    <table>
                                        <tr>
                                            <td style="width: 35%; font-weight: bold;">Nominee Name:</td>
                                            <td style="width: 65%;"><input type="text" id="adminViewFormNomineeName"
                                                    readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Relationship with Applicant:</td>
                                            <td><input type="text" id="adminViewFormNomineeRelationship" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Nominee Mobile Number:</td>
                                            <td><input type="text" id="adminViewFormNomineeMobile" readonly></td>
                                        </tr>
                                    </table>

                                    <!-- 8. Declaration -->
                                    <h2>8. Declaration</h2>
                                    <div
                                        style="margin-bottom: 20px; font-size: 0.9rem; text-align: justify; line-height: 1.5; color: #334155;">
                                        <span>I hereby declare that the details furnished above are true and correct
                                            to the best of my knowledge and belief and I undertake to inform Vertex
                                            Galaxy Bank of any changes therein, immediately. In case any of the
                                            above information is found to be false or untrue or misleading, I am
                                            aware that I may be held liable for it. I authorize the Bank to debit my
                                            linked account for recovery of EMI.</span>
                                    </div>

                                    <div
                                        style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; margin-top: 30px;">
                                        <div>
                                            <table style="margin-bottom: 0;">
                                                <tr>
                                                    <td style="width: 30%; font-weight: bold;">Date:</td>
                                                    <td style="width: 70%;"><input type="text"
                                                            id="adminViewFormDeclarationDate" readonly></td>
                                                </tr>
                                                <tr>
                                                    <td style="font-weight: bold;">Place:</td>
                                                    <td><input type="text" id="adminViewFormDeclarationPlace" readonly>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div
                                            style="text-align: center; display: flex; flex-direction: column; justify-content: flex-end; align-items: center;">
                                            <input type="text" id="adminViewFormSignature" readonly
                                                style="text-align: center; font-family: 'Brush Script MT', cursive, Georgia, serif; font-size: 1.5rem; border-bottom: 1.5px solid #000 !important; width: 85%;">
                                            <span
                                                style="font-size: 0.75rem; font-weight: bold; color: #475569; text-transform: uppercase; margin-top: 5px; display: block;">Applicant's
                                                Signature</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons (shown only on screen) -->
                                <div class="no-print"
                                    style="margin-top: 30px; display: flex; gap: 15px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid var(--gray-200);">
                                    <button type="button" class="btn btn-secondary" onclick="closeAdminViewModal()"
                                        style="padding: 10px 22px;">Close</button>
                                    <button type="button" class="btn btn-secondary"
                                        onclick="printAdminApplicationForm()"
                                        style="padding: 10px 22px; display: flex; align-items: center; gap: 8px; border: 1.5px solid var(--gray-300); color: var(--gray-700); background: white;">
                                        <i class="bx bx-printer"></i>
                                        <span>Print Application Form</span>
                                    </button>
                                    <a href="#" id="adminModalApproveBtn" class="btn"
                                        style="padding: 10px 22px; display: none; align-items: center; gap: 8px; background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; font-weight: 600; border-radius: var(--radius-md); box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); transition: all 0.2s; text-decoration: none; justify-content: center;">
                                        <i class="bx bx-check" style="font-size: 1.2rem;"></i>
                                        <span>Approve Application</span>
                                    </a>
                                    <a href="#" id="adminModalRejectBtn" class="btn"
                                        style="padding: 10px 22px; display: none; align-items: center; gap: 8px; background: linear-gradient(135deg, #ef4444, #dc2626); color: white; border: none; font-weight: 600; border-radius: var(--radius-md); box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); transition: all 0.2s; text-decoration: none; justify-content: center;">
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

                    function openViewModal(loanId, customerName, customerPhone, loanType, principal, interestRate, termMonths, formDetailsStr, loanStatus, fallbackAadhaar, fallbackPan) {
                        document.getElementById('adminViewLoanId').textContent = "#LN-" + loanId;

                        // Re-populate basic/fallback details
                        document.getElementById('adminViewFormFullName').value = customerName;
                        document.getElementById('adminViewFormMobile').value = customerPhone;
                        document.getElementById('adminViewFormLoanType').value = loanType;
                        document.getElementById('adminViewFormLoanAmount').value = "₹ " + parseFloat(principal).toLocaleString('en-IN', { minimumFractionDigits: 2 });
                        document.getElementById('adminViewFormLoanRate').value = parseFloat(interestRate).toFixed(2) + "% Fixed P.A.";
                        document.getElementById('adminViewFormLoanTenure').value = termMonths + " Months";
                        document.getElementById('adminViewFormAccHolderName').value = customerName;

                        // Configure Modal Action Buttons dynamically
                        const approveBtn = document.getElementById('adminModalApproveBtn');
                        const rejectBtn = document.getElementById('adminModalRejectBtn');

                        if (loanStatus === 'pending_approval') {
                            approveBtn.style.display = 'inline-flex';
                            rejectBtn.style.display = 'inline-flex';
                            approveBtn.href = '${pageContext.request.contextPath}/loan?action=approve&id=' + loanId;
                            rejectBtn.href = '${pageContext.request.contextPath}/loan?action=reject&id=' + loanId;

                            // Setup confirmations on click
                            approveBtn.onclick = function () {
                                return confirm('Are you sure you want to APPROVE this loan application (Ref: #LN-' + loanId + ')?');
                            };
                            rejectBtn.onclick = function () {
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
                            document.getElementById('adminViewFormRelationName').value = parsed.relationName || '___________________________';
                            document.getElementById('adminViewFormDob').value = parsed.dob || '___________________________';
                            document.getElementById('adminViewFormGender').value = parsed.gender || '___________________________';

                            // Email prefill from basic or parsed
                            document.getElementById('adminViewFormEmail').value = parsed.email || '';

                            document.getElementById('adminViewFormCurrentAddress').textContent = parsed.currentAddress || 'N/A';
                            document.getElementById('adminViewFormPermanentAddress').textContent = parsed.permanentAddress || '______________________________________________________';

                            document.getElementById('adminViewFormAadhaar').value = parsed.aadhaar || fallbackAadhaar || '';
                            document.getElementById('adminViewFormPan').value = parsed.pan || fallbackPan || '';
                            document.getElementById('adminViewFormVoterDl').value = parsed.voterDlNo || '___________________________';

                            document.getElementById('adminViewFormOccupation').value = parsed.occupation || '___________________________';
                            document.getElementById('adminViewFormCompanyName').value = parsed.companyName || '___________________________';
                            document.getElementById('adminViewFormMonthlyIncome').value = parsed.monthlyIncome ? "₹ " + parseFloat(parsed.monthlyIncome).toLocaleString('en-IN') : '₹ ______________________';
                            document.getElementById('adminViewFormExperience').value = parsed.workExperience || '_____________________';

                            document.getElementById('adminViewFormAccNo').value = parsed.linkedAccountNo || '___________________________';
                            document.getElementById('adminViewFormIfsc').value = parsed.linkedIfsc || '___________________________';
                            document.getElementById('adminViewFormBranch').value = parsed.linkedBranch || 'VGB Main Branch';

                            document.getElementById('adminViewFormLoanPurpose').value = parsed.loanPurpose || '___________________________';

                            document.getElementById('adminViewFormNomineeName').value = parsed.nomineeName || '___________________________';
                            document.getElementById('adminViewFormNomineeRelationship').value = parsed.nomineeRelationship || '___________________________';
                            document.getElementById('adminViewFormNomineeMobile').value = parsed.nomineeMobile || '___________________________';

                            document.getElementById('adminViewFormDeclarationDate').value = parsed.declarationDate || '';
                            document.getElementById('adminViewFormDeclarationPlace').value = parsed.declarationPlace || '___________________________';
                            document.getElementById('adminViewFormSignature').value = parsed.signature || '';

                            // Calculate paper EMI
                            const monthlyRate = (parseFloat(interestRate) / 12) / 100;
                            const emi = (parseFloat(principal) * monthlyRate * Math.pow(1 + monthlyRate, parseInt(termMonths))) / (Math.pow(1 + monthlyRate, parseInt(termMonths)) - 1);
                            document.getElementById('adminViewFormPaperEmiDisplay').textContent = "₹ " + emi.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                        } else {
                            // Fall back cleanly to a neat default form compiled from basic database columns
                            document.getElementById('adminViewFormRelationName').value = 'N/A (Legacy Record)';
                            document.getElementById('adminViewFormDob').value = 'N/A';
                            document.getElementById('adminViewFormGender').value = 'N/A';
                            document.getElementById('adminViewFormEmail').value = '';
                            document.getElementById('adminViewFormCurrentAddress').textContent = 'N/A (Legacy Record)';
                            document.getElementById('adminViewFormPermanentAddress').textContent = 'N/A (Legacy Record)';
                            document.getElementById('adminViewFormAadhaar').value = fallbackAadhaar || 'N/A';
                            document.getElementById('adminViewFormPan').value = fallbackPan || 'N/A';
                            document.getElementById('adminViewFormVoterDl').value = 'N/A';

                            document.getElementById('adminViewFormOccupation').value = 'N/A';
                            document.getElementById('adminViewFormCompanyName').value = 'N/A';
                            document.getElementById('adminViewFormMonthlyIncome').value = 'N/A';
                            document.getElementById('adminViewFormExperience').value = 'N/A';

                            document.getElementById('adminViewFormAccNo').value = 'N/A';
                            document.getElementById('adminViewFormIfsc').value = 'N/A';
                            document.getElementById('adminViewFormBranch').value = 'VGB Main Branch';

                            document.getElementById('adminViewFormLoanPurpose').value = 'N/A (Legacy Record)';

                            document.getElementById('adminViewFormNomineeName').value = 'N/A';
                            document.getElementById('adminViewFormNomineeRelationship').value = 'N/A';
                            document.getElementById('adminViewFormNomineeMobile').value = 'N/A';

                            document.getElementById('adminViewFormDeclarationDate').value = 'N/A';
                            document.getElementById('adminViewFormDeclarationPlace').value = 'N/A';
                            document.getElementById('adminViewFormSignature').value = 'N/A';

                            document.getElementById('adminViewFormPaperEmiDisplay').textContent = 'N/A';
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
                        if (badgePending) badgePending.textContent = "${pendingCount}";
                        if (badgeApproved) badgeApproved.textContent = "${approvedCount}";
                        if (badgeClosed) badgeClosed.textContent = "${closedCount}";

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

                        // Load Custom Loan Specifications (Interest Rates & Max Limits)
                        loadLoanSpecs();
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
                        const tableIds = ['content-pending', 'content-approved', 'content-closed'];

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

                    // Premium EMI Calculator & Trigger handlers
                    function calculateEMI() {
                        const amount = parseFloat(document.getElementById('calcAmount').value) || 0;
                        const rate = parseFloat(document.getElementById('calcRate').value) || 0;
                        const term = parseInt(document.getElementById('calcTerm').value) || 0;
                        const emiResult = document.getElementById('emiResult');

                        if (amount <= 0 || rate <= 0 || term <= 0) {
                            emiResult.textContent = "₹ 0.00";
                            return;
                        }

                        const monthlyRate = (rate / 12) / 100;
                        const emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, term)) / (Math.pow(1 + monthlyRate, term) - 1);

                        emiResult.textContent = "₹ " + emi.toLocaleString('en-IN', {
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
                        document.getElementById('calcTerm').value = months;
                        calculateEMI();
                    }

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

                    let adminCurrentMaxLimit = 50000000;

                    function showAdminLoanDetails(type, rate, maxLimit) {
                        const spec = loanSpecs[type];
                        if (!spec) return;

                        document.getElementById('adminDetailsModalTitle').querySelector('span').textContent = spec.title + " Specification";
                        document.getElementById('adminDetailsDescription').textContent = spec.description;
                        document.getElementById('adminDetailsInterestRate').textContent = rate.toFixed(2) + "% Fixed P.A.";
                        document.getElementById('adminDetailsMaxLimit').textContent = "₹ " + maxLimit.toLocaleString('en-IN');

                        // Benefits list
                        const benefitsList = document.getElementById('adminDetailsBenefits');
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

                        // Eligibility list
                        const eligibilityList = document.getElementById('adminDetailsEligibility');
                        eligibilityList.innerHTML = '';
                        spec.eligibility.forEach(el => {
                            const li = document.createElement('li');
                            li.textContent = el;
                            eligibilityList.appendChild(li);
                        });

                        // Documents list
                        const documentsList = document.getElementById('adminDetailsDocuments');
                        documentsList.innerHTML = '';
                        spec.documents.forEach(doc => {
                            const li = document.createElement('li');
                            li.textContent = doc;
                            documentsList.appendChild(li);
                        });

                        // Bind the Apply Button action
                        const applyBtn = document.getElementById('adminDetailsApplyBtn');
                        applyBtn.onclick = function () {
                            closeAdminDetailsModal();
                            openAdminLoanForm(type, rate, maxLimit);
                        };

                        // Bind the Edit Specs Button action
                        const editSpecsBtn = document.getElementById('adminDetailsEditSpecsBtn');
                        if (editSpecsBtn) {
                            editSpecsBtn.onclick = function () {
                                closeAdminDetailsModal();
                                openEditSpecsModal(type);
                            };
                        }

                        document.getElementById('adminLoanDetailsModal').style.display = 'flex';
                    }

                    function closeAdminDetailsModal() {
                        document.getElementById('adminLoanDetailsModal').style.display = 'none';
                    }

                    function setApplyMode(mode) {
                        const btnCreate = document.getElementById('btn-mode-create');
                        const btnUpdate = document.getElementById('btn-mode-update');
                        const containerCreate = document.getElementById('apply-new-mode-container');
                        const containerUpdate = document.getElementById('update-existing-mode-container');

                        if (mode === 'create') {
                            if (btnCreate) btnCreate.classList.add('active');
                            if (btnUpdate) btnUpdate.classList.remove('active');
                            if (containerCreate) containerCreate.style.display = 'block';
                            if (containerUpdate) containerUpdate.style.display = 'none';
                        } else {
                            if (btnUpdate) btnUpdate.classList.add('active');
                            if (btnCreate) btnCreate.classList.remove('active');
                            if (containerCreate) containerCreate.style.display = 'none';
                            if (containerUpdate) containerUpdate.style.display = 'block';
                        }
                    }

                    function openAdminLoanUpdateForm(loanId, customerId, loanType, principal, interestRate, termMonths, formDetailsStr) {
                        // Reset form fields
                        document.getElementById('adminApplyForm').reset();

                        // Configure Mode Parameters
                        document.getElementById('submitFormAction').value = 'update';
                        document.getElementById('submitAdminLoanId').value = loanId;
                        document.getElementById('adminApplyModalTitle').textContent = 'Modify Loan Details (Ref: #LN-' + loanId + ')';

                        const submitBtn = document.getElementById('adminApplyForm').querySelector('button[type="submit"] span');
                        if (submitBtn) {
                            submitBtn.textContent = 'Save Changes';
                        }

                        // Populate & Disable Customer Selector
                        const custSelect = document.getElementById('adminApplyCustomerId');
                        custSelect.value = customerId;
                        custSelect.disabled = true;
                        custSelect.required = false;

                        // Sync profile data fields
                        syncAdminCustomerDetails(custSelect);

                        // Map core fields
                        document.getElementById('adminFormLoanTypeDisplay').value = loanType;
                        document.getElementById('submitAdminLoanType').value = loanType;
                        document.getElementById('adminFormLoanRate').value = parseFloat(interestRate).toFixed(2) + "% Fixed P.A.";
                        document.getElementById('submitAdminInterestRate').value = interestRate;

                        document.getElementById('adminFormLoanAmount').value = principal;
                        document.getElementById('submitAdminAmount').value = principal;

                        if (parseInt(termMonths) % 12 === 0) {
                            document.getElementById('adminFormLoanTermVal').value = parseInt(termMonths) / 12;
                            document.getElementById('adminFormLoanTermUnit').value = 'years';
                        } else {
                            document.getElementById('adminFormLoanTermVal').value = termMonths;
                            document.getElementById('adminFormLoanTermUnit').value = 'months';
                        }
                        document.getElementById('adminFormLoanTermMonths').value = termMonths;
                        document.getElementById('submitAdminTermMonths').value = termMonths;

                        // Parse JSON details
                        let parsed = null;
                        if (formDetailsStr && formDetailsStr.trim() !== '') {
                            try {
                                parsed = JSON.parse(formDetailsStr);
                            } catch (e) {
                                console.error("Failed to parse formDetails JSON string", e);
                            }
                        }

                        if (parsed) {
                            document.getElementById('adminFormRelationName').value = parsed.relationName || '';
                            document.getElementById('adminFormDob').value = parsed.dob || '';

                            if (parsed.gender) {
                                const radio = document.querySelector('input[name="adminFormGender"][value="' + parsed.gender + '"]');
                                if (radio) radio.checked = true;
                            }

                            document.getElementById('adminFormPermanentAddress').value = parsed.permanentAddress || '';
                            document.getElementById('adminFormVoterDl').value = parsed.voterDlNo || '';
                            document.getElementById('adminFormOccupation').value = parsed.occupation || '';
                            document.getElementById('adminFormCompanyName').value = parsed.companyName || '';
                            document.getElementById('adminFormMonthlyIncome').value = parsed.monthlyIncome || '';
                            document.getElementById('adminFormExperience').value = parsed.workExperience || '';

                            // Select linked account after dropdown population delay
                            setTimeout(() => {
                                const accSelect = document.getElementById('adminFormLinkAccount');
                                if (parsed.linkedAccountId) {
                                    accSelect.value = parsed.linkedAccountId;
                                    syncAdminLinkedAccountDetails(accSelect);
                                }
                            }, 100);

                            document.getElementById('adminFormLoanPurpose').value = parsed.loanPurpose || '';
                            document.getElementById('adminFormNomineeName').value = parsed.nomineeName || '';
                            document.getElementById('adminFormNomineeRelationship').value = parsed.nomineeRelationship || '';
                            document.getElementById('adminFormNomineeMobile').value = parsed.nomineeMobile || '';
                            document.getElementById('adminFormDeclarationPlace').value = parsed.declarationPlace || '';
                            document.getElementById('adminFormDeclarationDate').value = parsed.declarationDate || '';
                            document.getElementById('adminFormSignature').value = parsed.signature || '';
                            document.getElementById('adminFormDeclarationCheckbox').checked = true;
                        }

                        // Recalculate EMI and limits
                        adminCurrentMaxLimit = 999999999; // bypass limit validation on updates
                        calculateAdminPaperEMI();

                        document.getElementById('adminApplyModal').style.display = 'flex';
                    }

                    function openAdminLoanForm(type, rate, maxLimit) {
                        // Configure Mode Parameters
                        document.getElementById('submitFormAction').value = 'apply';
                        document.getElementById('submitAdminLoanId').value = '';
                        document.getElementById('adminApplyModalTitle').textContent = 'Official Loan Application Form (Admin Portal)';

                        const submitBtn = document.getElementById('adminApplyForm').querySelector('button[type="submit"] span');
                        if (submitBtn) {
                            submitBtn.textContent = 'Submit Application';
                        }

                        // Enable Customer Selector
                        const custSelect = document.getElementById('adminApplyCustomerId');
                        custSelect.disabled = false;
                        custSelect.required = true;

                        adminCurrentMaxLimit = maxLimit;
                        document.getElementById('adminFormLoanTypeDisplay').value = type;
                        document.getElementById('submitAdminLoanType').value = type;

                        document.getElementById('adminFormLoanRate').value = rate.toFixed(2) + "% Fixed P.A.";
                        document.getElementById('submitAdminInterestRate').value = rate;

                        const amountInput = document.getElementById('adminFormLoanAmount');
                        amountInput.max = maxLimit;
                        amountInput.placeholder = "Max limit: ₹ " + maxLimit.toLocaleString('en-IN');
                        amountInput.value = "";

                        // Pre-fill today's date
                        const today = new Date();
                        const yyyy = today.getFullYear();
                        let mm = today.getMonth() + 1;
                        let dd = today.getDate();
                        if (dd < 10) dd = '0' + dd;
                        if (mm < 10) mm = '0' + mm;
                        document.getElementById('adminFormDeclarationDate').value = dd + '/' + mm + '/' + yyyy;

                        // Reset form fields
                        document.getElementById('adminApplyForm').reset();

                        // Re-fill values set above
                        document.getElementById('adminFormLoanTypeDisplay').value = type;
                        document.getElementById('submitAdminLoanType').value = type;
                        document.getElementById('adminFormLoanRate').value = rate.toFixed(2) + "% Fixed P.A.";
                        document.getElementById('submitAdminInterestRate').value = rate;
                        document.getElementById('adminFormDeclarationDate').value = dd + '/' + mm + '/' + yyyy;
                        document.getElementById('adminFormBranch').value = "VGB Main Branch";

                        // Clear customer selector & related details
                        document.getElementById('adminApplyCustomerId').value = "";
                        syncAdminCustomerDetails(document.getElementById('adminApplyCustomerId'));

                        // Trigger term syncing to initial value
                        document.getElementById('adminFormLoanTermVal').value = 10;
                        document.getElementById('adminFormLoanTermUnit').value = "years";
                        syncAdminPaperTermMonths();

                        document.getElementById('adminApplyModal').style.display = 'flex';
                    }

                    function closeAdminApplyModal() {
                        document.getElementById('adminApplyModal').style.display = 'none';
                    }

                    function syncAdminCustomerDetails(select) {
                        if (!select.value) {
                            // Clear fields
                            document.getElementById('adminFormFullName').value = "";
                            document.getElementById('adminFormMobile').value = "";
                            document.getElementById('adminFormEmail').value = "";
                            document.getElementById('adminFormAadhaar').value = "";
                            document.getElementById('adminFormPan').value = "";
                            document.getElementById('adminFormCurrentAddressDisplay').textContent = "";
                            document.getElementById('adminFormCurrentAddressHidden').value = "";

                            // Reset permanent address checkbox & field
                            document.getElementById('adminFormSameAsCurrent').checked = false;
                            document.getElementById('adminFormPermanentAddress').value = "";

                            // Reset other customer-specific fields
                            document.getElementById('adminFormDob').value = "";
                            document.querySelectorAll('input[name="adminFormGender"]').forEach(r => r.checked = false);
                            document.getElementById('adminFormOccupation').value = "";
                            document.getElementById('adminFormAccHolderName').value = "";

                            // Reset Linked Account select
                            document.getElementById('adminFormLinkAccount').innerHTML = '<option value="" disabled selected>-- Select Customer VGB Account --</option>';
                            document.getElementById('adminFormAccNo').value = "";
                            document.getElementById('adminFormIfsc').value = "";
                            return;
                        }

                        const selectedOpt = select.options[select.selectedIndex];
                        const fullname = selectedOpt.getAttribute('data-fullname') || '';
                        const phone = selectedOpt.getAttribute('data-phone') || '';
                        const email = selectedOpt.getAttribute('data-email') || '';
                        const aadhaar = selectedOpt.getAttribute('data-aadhaar') || '';
                        const pan = selectedOpt.getAttribute('data-pan') || '';
                        const address = selectedOpt.getAttribute('data-address') || '';
                        const city = selectedOpt.getAttribute('data-city') || '';
                        const state = selectedOpt.getAttribute('data-state') || '';
                        const zipcode = selectedOpt.getAttribute('data-zipcode') || '';

                        const dob = selectedOpt.getAttribute('data-dob') || '';
                        const gender = selectedOpt.getAttribute('data-gender') || '';
                        const occupation = selectedOpt.getAttribute('data-occupation') || '';

                        // Populate
                        document.getElementById('adminFormFullName').value = fullname;
                        document.getElementById('adminFormMobile').value = phone;
                        document.getElementById('adminFormEmail').value = email;
                        document.getElementById('adminFormAadhaar').value = aadhaar;
                        document.getElementById('adminFormPan').value = pan;

                        const fullAddr = address + (city ? ", " + city : "") + (state ? ", " + state : "") + (zipcode ? " - " + zipcode : "");
                        document.getElementById('adminFormCurrentAddressDisplay').textContent = fullAddr;
                        document.getElementById('adminFormCurrentAddressHidden').value = fullAddr;

                        document.getElementById('adminFormAccHolderName').value = fullname;

                        // Set DOB if it matches yyyy-MM-dd format
                        if (dob && dob !== 'null') {
                            document.getElementById('adminFormDob').value = dob;
                        } else {
                            document.getElementById('adminFormDob').value = "";
                        }

                        // Set Gender
                        if (gender) {
                            const genUpper = gender.toUpperCase();
                            let radioVal = "";
                            if (genUpper.startsWith("M")) radioVal = "Male";
                            else if (genUpper.startsWith("F")) radioVal = "Female";
                            else radioVal = "Other";

                            const radio = document.querySelector('input[name="adminFormGender"][value="' + radioVal + '"]');
                            if (radio) radio.checked = true;
                        } else {
                            document.querySelectorAll('input[name="adminFormGender"]').forEach(r => r.checked = false);
                        }

                        // Set Occupation
                        if (occupation && occupation !== 'null') {
                            document.getElementById('adminFormOccupation').value = occupation;
                        } else {
                            document.getElementById('adminFormOccupation').value = "";
                        }

                        // Populate Linked Accounts list dynamically
                        const customerId = parseInt(select.value);
                        const linkSelect = document.getElementById('adminFormLinkAccount');
                        linkSelect.innerHTML = '<option value="" disabled selected>-- Select Customer VGB Account --</option>';
                        document.getElementById('adminFormAccNo').value = "";
                        document.getElementById('adminFormIfsc').value = "";

                        const customerAccounts = allAccounts.filter(acc => parseInt(acc.customerId) === customerId && acc.status.toLowerCase() === 'active');
                        if (customerAccounts.length === 0) {
                            const opt = document.createElement('option');
                            opt.value = "";
                            opt.textContent = "No active VGB account found for this customer";
                            opt.disabled = true;
                            linkSelect.appendChild(opt);
                        } else {
                            customerAccounts.forEach(acc => {
                                const opt = document.createElement('option');
                                opt.value = acc.accountId;
                                opt.textContent = "Account #" + acc.accountNumber + " (" + acc.accountType.toUpperCase() + ")";
                                opt.setAttribute('data-acc-no', acc.accountNumber);
                                opt.setAttribute('data-ifsc', 'VGBK0000001'); // Default branch IFSC
                                opt.setAttribute('data-type', acc.accountType);
                                linkSelect.appendChild(opt);
                            });
                        }
                    }

                    function copyAdminCurrentAddress(checkbox) {
                        const currentAddr = document.getElementById('adminFormCurrentAddressHidden').value;
                        const permAddrField = document.getElementById('adminFormPermanentAddress');
                        if (checkbox.checked) {
                            permAddrField.value = currentAddr;
                        } else {
                            permAddrField.value = "";
                        }
                    }

                    function syncAdminLinkedAccountDetails(select) {
                        if (!select.value) return;
                        const selectedOpt = select.options[select.selectedIndex];
                        const accNo = selectedOpt.getAttribute('data-acc-no');
                        const ifsc = selectedOpt.getAttribute('data-ifsc');

                        document.getElementById('adminFormAccNo').value = accNo;
                        document.getElementById('adminFormIfsc').value = ifsc;
                    }

                    function syncAdminPaperTermMonths() {
                        const valInput = document.getElementById('adminFormLoanTermVal');
                        const unit = document.getElementById('adminFormLoanTermUnit').value;

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
                        document.getElementById('adminFormLoanTermMonths').value = months;
                        document.getElementById('submitAdminTermMonths').value = months;
                        calculateAdminPaperEMI();
                    }

                    function calculateAdminPaperEMI() {
                        const amount = parseFloat(document.getElementById('adminFormLoanAmount').value) || 0;
                        const rateStr = document.getElementById('submitAdminInterestRate').value;
                        const rate = parseFloat(rateStr) || 0;
                        const term = parseInt(document.getElementById('adminFormLoanTermMonths').value) || 0;

                        const emiDisplay = document.getElementById('adminFormPaperEmiDisplay');

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

                    function serializeAdminLoanForm(event) {
                        const amount = parseFloat(document.getElementById('adminFormLoanAmount').value) || 0;
                        if (amount <= 0) {
                            alert("Please enter a valid loan amount.");
                            event.preventDefault();
                            return false;
                        }
                        if (amount > adminCurrentMaxLimit) {
                            alert("The requested amount exceeds the maximum limit of ₹ " + adminCurrentMaxLimit.toLocaleString('en-IN') + " for this loan category.");
                            event.preventDefault();
                            return false;
                        }

                        const linkAccSelect = document.getElementById('adminFormLinkAccount');
                        const linkAcc = linkAccSelect.value;
                        if (!linkAcc) {
                            alert("Please select a bank account to link to this loan.");
                            event.preventDefault();
                            return false;
                        }

                        // Gather all details for JSON serialization matching customer style
                        const details = {
                            relationName: document.getElementById('adminFormRelationName').value,
                            dob: document.getElementById('adminFormDob').value,
                            gender: document.querySelector('input[name="adminFormGender"]:checked')?.value || '',
                            permanentAddress: document.getElementById('adminFormPermanentAddress').value,
                            aadhaar: document.getElementById('adminFormAadhaar').value,
                            pan: document.getElementById('adminFormPan').value,
                            voterDlNo: document.getElementById('adminFormVoterDl').value,
                            occupation: document.getElementById('adminFormOccupation').value,
                            companyName: document.getElementById('adminFormCompanyName').value,
                            monthlyIncome: document.getElementById('adminFormMonthlyIncome').value,
                            workExperience: document.getElementById('adminFormExperience').value,
                            linkedAccountId: linkAcc,
                            linkedAccountNo: document.getElementById('adminFormAccNo').value,
                            linkedIfsc: document.getElementById('adminFormIfsc').value,
                            linkedBranch: document.getElementById('adminFormBranch').value,
                            loanPurpose: document.getElementById('adminFormLoanPurpose').value,
                            nomineeName: document.getElementById('adminFormNomineeName').value,
                            nomineeRelationship: document.getElementById('adminFormNomineeRelationship').value,
                            nomineeMobile: document.getElementById('adminFormNomineeMobile').value,
                            declarationPlace: document.getElementById('adminFormDeclarationPlace').value,
                            declarationDate: document.getElementById('adminFormDeclarationDate').value,
                            signature: document.getElementById('adminFormSignature').value
                        };

                        document.getElementById('adminSubmitFormDetails').value = JSON.stringify(details);
                        document.getElementById('submitAdminAmount').value = amount;
                        document.getElementById('submitAdminTermMonths').value = document.getElementById('adminFormLoanTermMonths').value;

                        // Enable customer selector right before submit so it gets sent in POST
                        document.getElementById('adminApplyCustomerId').disabled = false;

                        return true;
                    }

                    const defaultSpecs = {
                        personal: { rate: 12.00, max: 1500000, title: 'Personal Cash Loan' },
                        home: { rate: 7.50, max: 50000000, title: 'Home Secure Loan' },
                        vehicle: { rate: 8.50, max: 5000000, title: 'Vehicle Purchase Loan' },
                        education: { rate: 6.50, max: 4000000, title: 'Higher Education Loan' },
                        business: { rate: 10.50, max: 10000000, title: 'Business Capital Loan' }
                    };

                    function getSpecValue(type, property) {
                        const localVal = localStorage.getItem('vgb_loan_' + property + '_' + type);
                        if (localVal) {
                            return parseFloat(localVal);
                        }
                        return defaultSpecs[type][property];
                    }

                    function loadLoanSpecs() {
                        const types = ['personal', 'home', 'vehicle', 'education', 'business'];
                        types.forEach(type => {
                            const rate = getSpecValue(type, 'rate');
                            const max = getSpecValue(type, 'max');

                            // Update card badges/texts
                            const rateEl = document.getElementById('badge-rate-' + type);
                            if (rateEl) {
                                rateEl.innerHTML = rate.toFixed(2) + '% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span>';
                            }
                            const maxEl = document.getElementById('badge-max-' + type);
                            if (maxEl) {
                                maxEl.textContent = 'Max: ₹ ' + max.toLocaleString('en-IN');
                            }

                            // Update the card's onclick attribute dynamically
                            const card = document.getElementById('card-' + type);
                            if (card) {
                                card.onclick = function () {
                                    showAdminLoanDetails(type, rate, max);
                                };
                            }

                            // Update EMI calculator options
                            const optEl = document.getElementById('opt-calc-' + type);
                            if (optEl) {
                                optEl.value = rate.toFixed(2);
                                const title = defaultSpecs[type].title;
                                optEl.textContent = title + ' (' + rate.toFixed(2) + '%)';
                            }
                        });
                        // Recalculate EMI if calculator is visible
                        if (typeof calculateEMI === 'function') {
                            calculateEMI();
                        }
                    }

                    function openEditSpecsModal(type) {
                        const spec = defaultSpecs[type];
                        if (!spec) return;

                        const currentRate = getSpecValue(type, 'rate');
                        const currentMax = getSpecValue(type, 'max');

                        document.getElementById('editSpecsType').value = type;
                        document.getElementById('editSpecsTitle').value = spec.title;
                        document.getElementById('editSpecsRate').value = currentRate.toFixed(2);
                        document.getElementById('editSpecsMax').value = currentMax;

                        document.getElementById('editSpecsModal').style.display = 'flex';
                    }

                    function closeEditSpecsModal() {
                        document.getElementById('editSpecsModal').style.display = 'none';
                    }

                    function saveSpecsChanges(event) {
                        event.preventDefault();
                        const type = document.getElementById('editSpecsType').value;
                        const rate = parseFloat(document.getElementById('editSpecsRate').value) || 0;
                        const max = parseFloat(document.getElementById('editSpecsMax').value) || 0;

                        if (rate <= 0 || max <= 0) {
                            alert("Please enter valid positive values.");
                            return;
                        }

                        localStorage.setItem('vgb_loan_rate_' + type, rate);
                        localStorage.setItem('vgb_loan_max_' + type, max);

                        loadLoanSpecs();
                        closeEditSpecsModal();
                    }

                    function printAdminApplyForm() {
                        document.body.classList.add('print-admin-apply-active');
                        window.print();
                        setTimeout(() => {
                            document.body.classList.remove('print-admin-apply-active');
                        }, 1000);
                    }
                </script>
            </body>

            </html>