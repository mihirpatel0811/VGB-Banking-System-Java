<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>VGB | Manage Accounts</title>
                <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
                <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.7" rel="stylesheet">
                <style>
                    :root {
                        --glass-bg: rgba(255, 255, 255, 0.45);
                        --glass-border: rgba(99, 102, 241, 0.08);
                        --card-glow: rgba(99, 102, 241, 0.04);
                        --panel-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
                    }

                    /* A4 Portrait Form Styling & Layout */
                    .a4-container {
                        font-family: 'Poppins', 'Inter', sans-serif;
                        background: #ffffff;
                        color: #1e293b;
                        padding: 30px;
                        border-radius: var(--radius-lg);
                        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                        max-width: 900px;
                        margin: 0 auto;
                        position: relative;
                        box-sizing: border-box;
                    }

                    .a4-section-card {
                        background: #ffffff;
                        border: 1px solid #e2e8f0;
                        border-radius: var(--radius-md);
                        padding: 20px 25px;
                        margin-bottom: 25px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .a4-section-card:hover {
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                    }

                    .a4-section-title {
                        font-size: 0.95rem;
                        font-weight: 800;
                        color: var(--primary-600);
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        margin-bottom: 18px;
                        border-bottom: 2px solid var(--primary-100);
                        padding-bottom: 6px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    /* Office Use Only Table Styling */
                    .office-use-box {
                        border: 2px dashed #94a3b8;
                        border-radius: var(--radius-md);
                        padding: 15px;
                        background: #f8fafc;
                        margin-bottom: 25px;
                    }

                    .office-use-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
                        gap: 12px;
                    }

                    .office-use-item {
                        border: 1px solid #cbd5e1;
                        background: #ffffff;
                        padding: 6px 10px;
                        border-radius: var(--radius-sm);
                        text-align: center;
                    }

                    .office-use-item label {
                        display: block;
                        font-size: 0.62rem;
                        font-weight: 700;
                        color: #64748b;
                        text-transform: uppercase;
                        margin-bottom: 4px;
                    }

                    .office-use-item span {
                        font-size: 0.78rem;
                        font-weight: 700;
                        color: #334155;
                        font-family: monospace;
                    }

                    /* Form Controls Styling */
                    .a4-form-row {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 15px;
                        margin-bottom: 15px;
                    }

                    .a4-form-group {
                        display: flex;
                        flex-direction: column;
                        gap: 6px;
                    }

                    .a4-form-group label {
                        font-size: 0.78rem;
                        font-weight: 700;
                        color: #475569;
                    }

                    .a4-form-group input,
                    .a4-form-group select,
                    .a4-form-group textarea {
                        padding: 10px 12px;
                        border: 1.5px solid #cbd5e1;
                        border-radius: var(--radius-sm);
                        font-size: 0.85rem;
                        color: #1e293b;
                        background: #ffffff;
                        outline: none;
                        transition: border-color 0.2s, box-shadow 0.2s;
                    }

                    .a4-form-group input:focus,
                    .a4-form-group select:focus,
                    .a4-form-group textarea:focus {
                        border-color: var(--primary-500);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
                    }

                    /* Radio & Checkbox Groups */
                    .a4-radio-group {
                        display: flex;
                        gap: 15px;
                        align-items: center;
                        height: 38px;
                    }

                    .a4-radio-label {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        font-size: 0.82rem;
                        font-weight: 600;
                        color: #334155;
                        cursor: pointer;
                    }

                    /* Photo/KYC Upload Styling */
                    .a4-photo-upload {
                        width: 120px;
                        height: 140px;
                        border: 2px dashed #cbd5e1;
                        border-radius: var(--radius-sm);
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        position: relative;
                        background: #f8fafc;
                        overflow: hidden;
                        transition: border-color 0.2s;
                    }

                    .a4-photo-upload:hover {
                        border-color: var(--primary-500);
                    }

                    .a4-photo-upload i {
                        font-size: 2rem;
                        color: #94a3b8;
                        margin-bottom: 6px;
                    }

                    .a4-photo-upload span {
                        font-size: 0.65rem;
                        font-weight: 600;
                        color: #64748b;
                        text-align: center;
                        padding: 0 8px;
                    }

                    .a4-photo-upload input[type="file"] {
                        position: absolute;
                        inset: 0;
                        opacity: 0;
                        cursor: pointer;
                    }

                    .print-bg-container {
                         display: none;
                     }

                    /* Print Media Overrides */
                    @media print {
                        @page {
                            size: A4 portrait;
                            margin: 0;
                        }
                        body {
                            background-color: white !important;
                            margin: 0 !important;
                            padding: 0 !important;
                            color: #1a1a1a !important;
                        }
                        .sidebar,
                        .header,
                        .footer,
                        .no-print,
                        .modal-header,
                        .modal-footer,
                        .print-hide-header {
                            display: none !important;
                        }

                        .main-content {
                            margin-left: 0 !important;
                            padding: 0 !important;
                        }

                        .modal {
                            position: absolute !important;
                            left: 0 !important;
                            top: 0 !important;
                            width: 100% !important;
                            height: auto !important;
                            background: none !important;
                            backdrop-filter: none !important;
                            padding: 0 !important;
                            display: block !important;
                            z-index: 99999 !important;
                            overflow: visible !important;
                        }

                        .modal-content {
                            max-width: 100% !important;
                            max-height: none !important;
                            border: none !important;
                            box-shadow: none !important;
                            padding: 0 !important;
                            background: transparent !important;
                        }

                        .modal-body {
                            padding: 0 !important;
                            background: transparent !important;
                        }

                        .statement-print-area {
                            position: relative !important;
                            z-index: 1 !important;
                            margin: 0 !important;
                            padding: 160px 60px 100px 60px !important;
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

                        #statementTxnTable {
                            table-layout: fixed !important;
                            width: 100% !important;
                            border-collapse: collapse !important;
                            background: transparent !important;
                        }
                        #statementTxnTable th, #statementTxnTable td {
                            padding: 8px 6px !important;
                            font-size: 11px !important;
                            white-space: normal !important;
                            word-wrap: break-word !important;
                            word-break: break-word !important;
                            border-bottom: 1px solid #ddd !important;
                        }
                        #statementTxnTable th {
                            background: rgba(0, 0, 0, 0.04) !important;
                            color: #000 !important;
                            font-weight: 700 !important;
                        }

                        .a4-container {
                            box-shadow: none !important;
                            padding: 0 !important;
                            border: none !important;
                            margin: 0 !important;
                            width: 100% !important;
                        }

                        .a4-section-card {
                            box-shadow: none !important;
                            border: 1px solid #94a3b8 !important;
                            page-break-inside: avoid !important;
                        }

                        select {
                            appearance: none !important;
                            background: transparent !important;
                            border: 1px solid #94a3b8 !important;
                        }
                    }


                    body {
                        background-color: #f6f8fc !important;
                        color: var(--gray-700) !important;
                        overflow-x: hidden;
                        font-family: 'Poppins', sans-serif;
                    }

                    body.dark-mode {
                        --glass-bg: rgba(30, 41, 59, 0.45);
                        --glass-border: rgba(255, 255, 255, 0.08);
                        --card-glow: rgba(99, 102, 241, 0.1);
                        --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
                        background-color: #0f172a !important;
                    }

                    /* Preloader styling fixes to match dashboard design */
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

                    /* --- KPI STAT CARDS --- */
                    .stat-card {
                        background: var(--glass-bg) !important;
                        backdrop-filter: blur(25px) saturate(180%);
                        -webkit-backdrop-filter: blur(25px) saturate(180%);
                        border: 1px solid rgba(255, 255, 255, 0.5) !important;
                        border-radius: var(--radius-lg);
                        padding: 24px;
                        display: flex;
                        align-items: center;
                        gap: 20px;
                        box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
                        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
                        position: relative;
                        overflow: hidden;
                    }

                    body.dark-mode .stat-card {
                        border: 1px solid rgba(255, 255, 255, 0.06) !important;
                    }

                    .stat-card:hover {
                        transform: translateY(-5px);
                        border-color: rgba(99, 102, 241, 0.25) !important;
                        box-shadow: 0 15px 35px rgba(99, 102, 241, 0.1);
                    }

                    .stat-icon {
                        width: 54px;
                        height: 54px;
                        border-radius: var(--radius-md);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.6rem;
                        flex-shrink: 0;
                        transition: transform 0.3s ease;
                    }

                    .stat-card:hover .stat-icon {
                        transform: scale(1.1) rotate(5deg);
                    }

                    /* Search & toolbar items */
                    .search-container {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                        margin-bottom: 25px;
                        flex-wrap: wrap;
                    }

                    .search-box {
                        position: relative;
                        flex-grow: 1;
                        min-width: 280px;
                    }

                    .search-box i {
                        position: absolute;
                        left: 15px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--gray-400);
                        font-size: 1.2rem;
                    }

                    .search-box input {
                        width: 100%;
                        padding: 12px 15px 12px 45px;
                        border: 1.5px solid var(--gray-200);
                        border-radius: var(--radius-md);
                        outline: none;
                        background: var(--white);
                        color: var(--gray-800);
                        transition: all var(--transition-normal);
                    }

                    body.dark-mode .search-box input {
                        border-color: rgba(255, 255, 255, 0.1);
                    }

                    .search-box input:focus {
                        border-color: var(--primary-500);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                    }

                    /* --- TABLE STYLING --- */
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

                    /* --- MONOSPACE ID BADGE --- */
                    .badge-id {
                        font-family: 'Courier New', Courier, monospace;
                        font-weight: 700;
                        font-size: 0.8rem;
                        background: rgba(99, 102, 241, 0.06);
                        color: var(--primary-500);
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        border: 1px solid rgba(99, 102, 241, 0.08);
                        letter-spacing: 0.5px;
                        white-space: nowrap;
                    }

                    body.dark-mode .badge-id {
                        background: rgba(99, 102, 241, 0.12);
                        color: var(--primary-300);
                    }

                    /* Custom circle table actions */
                    .btn-action-circle {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        width: 32px;
                        height: 32px;
                        border-radius: 50%;
                        border: 1px solid var(--gray-200);
                        background: var(--white);
                        color: var(--gray-600);
                        cursor: pointer;
                        transition: all var(--transition-fast);
                        font-size: 1rem;
                        text-decoration: none;
                    }

                    body.dark-mode .btn-action-circle {
                        border-color: rgba(255, 255, 255, 0.08);
                        background: rgba(30, 41, 59, 0.5);
                        color: var(--gray-300);
                    }

                    .btn-action-circle:hover {
                        transform: scale(1.1);
                        color: white !important;
                    }

                    .btn-action-circle:active {
                        transform: scale(0.95) !important;
                    }

                    .btn-action-view:hover {
                        border-color: var(--primary-500);
                        background: var(--primary-500);
                        box-shadow: 0 4px 10px rgba(99, 102, 241, 0.3);
                    }

                    .btn-action-edit:hover {
                        border-color: var(--accent-cyan);
                        background: var(--accent-cyan);
                        box-shadow: 0 4px 10px rgba(6, 182, 212, 0.3);
                    }

                    .btn-action-block:hover {
                        border-color: var(--accent-amber);
                        background: var(--accent-amber);
                        box-shadow: 0 4px 10px rgba(245, 158, 11, 0.3);
                    }

                    .btn-action-delete:hover {
                        border-color: #ef4444;
                        background: #ef4444;
                        box-shadow: 0 4px 10px rgba(239, 68, 68, 0.3);
                    }

                    /* Statuses */
                    .status-pill-active {
                        background: rgba(16, 185, 129, 0.12);
                        color: var(--accent-emerald);
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 700;
                        text-transform: uppercase;
                    }

                    .status-pill-closed {
                        background: rgba(239, 68, 68, 0.12);
                        color: #ef4444;
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 700;
                        text-transform: uppercase;
                    }

                    /* Account Type Badges */
                    .badge-type-savings {
                        background: rgba(99, 102, 241, 0.12);
                        color: var(--primary-500);
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    .badge-type-current {
                        background: rgba(16, 185, 129, 0.12);
                        color: var(--accent-emerald);
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    .badge-type-salary {
                        background: rgba(236, 72, 153, 0.12);
                        color: var(--secondary-500);
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    .badge-type-student {
                        background: rgba(6, 182, 212, 0.12);
                        color: var(--accent-cyan);
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    .badge-type-fd {
                        background: rgba(168, 85, 247, 0.12);
                        color: #a855f7;
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    .badge-type-rd {
                        background: rgba(245, 158, 11, 0.12);
                        color: var(--accent-amber);
                        padding: 5px 10px;
                        border-radius: var(--radius-sm);
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    /* Modals and Overlays */
                    .modal {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        z-index: 1000;
                        background: rgba(15, 23, 42, 0.45);
                        backdrop-filter: blur(12px);
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                        overflow-y: auto;
                    }

                    .modal-content {
                        background: var(--white);
                        color: var(--gray-800);
                        border-radius: var(--radius-lg);
                        width: 100%;
                        max-width: 900px;
                        max-height: 90vh;
                        overflow-y: auto;
                        border: 1px solid var(--glass-border);
                        box-shadow: var(--shadow-2xl);
                        position: relative;
                        animation: modalFadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
                    }

                    body.dark-mode .modal-content {
                        background: rgba(30, 41, 59, 0.95) !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                    }

                    .modal-large {
                        max-width: 1100px;
                    }

                    .modal-header {
                        padding: 20px 30px;
                        border-bottom: 1px solid var(--gray-100);
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        position: sticky;
                        top: 0;
                        background: var(--white);
                        z-index: 10;
                    }

                    body.dark-mode .modal-header {
                        background: rgba(30, 41, 59, 0.98) !important;
                        border-bottom-color: rgba(255, 255, 255, 0.08) !important;
                    }

                    .modal-body {
                        padding: 30px;
                    }

                    .modal-footer {
                        padding: 20px 30px;
                        border-top: 1px solid var(--gray-100);
                        display: flex;
                        justify-content: flex-end;
                        gap: 15px;
                        position: sticky;
                        bottom: 0;
                        background: var(--white);
                        z-index: 10;
                    }

                    body.dark-mode .modal-footer {
                        background: rgba(30, 41, 59, 0.98) !important;
                        border-top-color: rgba(255, 255, 255, 0.08) !important;
                    }

                    @keyframes modalFadeIn {
                        from {
                            opacity: 0;
                            transform: scale(0.95) translateY(10px);
                        }

                        to {
                            opacity: 1;
                            transform: scale(1) translateY(0);
                        }
                    }

                    .close-modal-btn {
                        font-size: 1.5rem;
                        color: var(--gray-400);
                        background: none;
                        border: none;
                        cursor: pointer;
                        transition: color var(--transition-normal);
                    }

                    .close-modal-btn:hover {
                        color: #ef4444;
                    }

                    /* Forms inside modals styling */
                    .form-row {
                        display: grid;
                        grid-template-columns: 1fr;
                        gap: 20px;
                        margin-bottom: 20px;
                    }

                    @media (min-width: 768px) {
                        .form-row.row-2 {
                            grid-template-columns: 1fr 1fr;
                        }

                        .form-row.row-3 {
                            grid-template-columns: 1fr 1fr 1fr;
                        }
                    }

                    .form-group label {
                        display: block;
                        font-size: 0.8rem;
                        font-weight: 600;
                        color: var(--gray-500);
                        margin-bottom: 8px;
                    }

                    .form-group input,
                    .form-group select,
                    .form-group textarea {
                        width: 100%;
                        padding: 11px 15px;
                        border: 1.5px solid var(--gray-200);
                        background: var(--white);
                        color: var(--gray-800);
                        border-radius: var(--radius-md);
                        outline: none;
                        transition: border-color 0.2s, box-shadow 0.2s;
                    }

                    body.dark-mode .form-group input,
                    body.dark-mode .form-group select,
                    body.dark-mode .form-group textarea {
                        border-color: rgba(255, 255, 255, 0.1);
                    }

                    .form-group input:focus,
                    .form-group select:focus,
                    .form-group textarea:focus {
                        border-color: var(--primary-500);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
                    }

                    /* Signatories partners details box */
                    .partner-card {
                        background: rgba(99, 102, 241, 0.02);
                        border: 1.5px solid var(--glass-border);
                        border-radius: var(--radius-md);
                        padding: 24px;
                        margin-bottom: 20px;
                        position: relative;
                    }

                    body.dark-mode .partner-card {
                        background: rgba(255, 255, 255, 0.01);
                    }

                    .remove-partner-btn {
                        position: absolute;
                        right: 20px;
                        top: 20px;
                        color: #ef4444;
                        font-size: 1.35rem;
                        cursor: pointer;
                        transition: transform 0.2s;
                    }

                    .remove-partner-btn:hover {
                        transform: scale(1.1);
                    }

                    /* Wizard Node Progress */
                    .step-progress-bar {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 55px;
                        position: relative;
                        counter-reset: step;
                    }

                    .step-progress-line-wrapper {
                        position: absolute;
                        top: 20px;
                        left: 22px;
                        right: 22px;
                        height: 4px;
                        z-index: 1;
                    }

                    .step-progress-line-bg {
                        position: absolute;
                        inset: 0;
                        background: var(--gray-200);
                        border-radius: 2px;
                    }

                    body.dark-mode .step-progress-line-bg {
                        background: rgba(255, 255, 255, 0.1);
                    }

                    .step-indicator-line {
                        position: absolute;
                        left: 0;
                        top: 0;
                        height: 100%;
                        background: var(--gradient-primary);
                        z-index: 2;
                        width: 0%;
                        transition: width 0.4s ease;
                        border-radius: 2px;
                    }

                    .step-node {
                        width: 44px;
                        height: 44px;
                        border-radius: 50%;
                        background: var(--white);
                        border: 3.5px solid var(--gray-200);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        color: var(--gray-400);
                        position: relative;
                        z-index: 3;
                        transition: all 0.4s ease;
                        counter-increment: step;
                    }

                    body.dark-mode .step-node {
                        background: #1e293b;
                        border-color: rgba(255, 255, 255, 0.1);
                    }

                    .step-node::before {
                        content: counter(step);
                    }

                    .step-node.active {
                        border-color: var(--primary-500);
                        color: var(--primary-500);
                        box-shadow: 0 0 15px rgba(99, 102, 241, 0.3);
                    }

                    .step-node.completed {
                        border-color: var(--accent-emerald);
                        background: var(--accent-emerald);
                        color: white;
                    }

                    .step-node.completed::before {
                        content: '✓';
                        font-size: 1.1rem;
                    }

                    .step-node-label {
                        position: absolute;
                        top: 50px;
                        left: 50%;
                        transform: translateX(-50%);
                        font-size: 0.72rem;
                        font-weight: 600;
                        white-space: nowrap;
                        color: var(--gray-400);
                        text-transform: uppercase;
                    }

                    .step-node.active .step-node-label {
                        color: var(--primary-500);
                    }

                    .step-node.completed .step-node-label {
                        color: var(--accent-emerald);
                    }

                    .wizard-step {
                        display: none;
                    }

                    .wizard-step.active {
                        display: block;
                    }

                    /* 3D Visualizers Grid */
                    .visualizer-preview-grid {
                        display: grid;
                        grid-template-columns: 1fr;
                        gap: 30px;
                        margin-top: 20px;
                    }

                    @media (min-width: 768px) {
                        .visualizer-preview-grid {
                            grid-template-columns: 1fr 1fr;
                        }
                    }

                    .visualizer-container {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        background: rgba(99, 102, 241, 0.02);
                        border: 1.5px solid var(--glass-border);
                        border-radius: var(--radius-lg);
                        padding: 35px 20px;
                        min-height: 250px;
                        position: relative;
                        perspective: 1200px;
                    }

                    /* ATM Cards 3D visualizers */
                    .vgb-atm-card {
                        width: 320px;
                        height: 200px;
                        position: relative;
                        transform-style: preserve-3d;
                        transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
                        border-radius: 16px;
                        cursor: pointer;
                    }

                    .vgb-atm-card.flipped {
                        transform: rotateY(180deg);
                    }

                    .vgb-atm-card .card-face {
                        position: absolute;
                        inset: 0;
                        padding: 20px;
                        backface-visibility: hidden;
                        border-radius: inherit;
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                        border: 1px solid rgba(255, 255, 255, 0.15);
                        box-sizing: border-box;
                    }

                    .vgb-atm-card .card-front {
                        z-index: 2;
                    }

                    .vgb-atm-card .card-back {
                        transform: rotateY(180deg);
                        z-index: 1;
                        background: #080b11;
                        padding: 20px;
                        color: #ffffff;
                    }

                    .vgb-atm-card.visa {
                        background: repeating-linear-gradient(45deg, rgba(255, 255, 255, 0.015) 0px, rgba(255, 255, 255, 0.015) 1px, transparent 1px, transparent 8px),
                            linear-gradient(135deg, #1b1c21 0%, #0d0e11 100%) !important;
                        box-shadow: 0 12px 25px rgba(15, 23, 42, 0.3) !important;
                        border: 1.5px solid rgba(255, 255, 255, 0.3) !important;
                    }

                    .vgb-atm-card.visa .card-front::after {
                        content: '';
                        position: absolute;
                        width: 320px;
                        height: 180px;
                        bottom: -50px;
                        left: -50px;
                        border-top: 4px solid #a855f7;
                        border-right: 2px solid transparent;
                        border-radius: 50%;
                        transform: rotate(-12deg);
                        box-shadow: 0 -3px 12px rgba(168, 85, 247, 0.6);
                        filter: drop-shadow(0 0 6px #a855f7);
                        pointer-events: none;
                        z-index: 1;
                    }

                    .vgb-atm-card.mastercard {
                        background:
                            radial-gradient(circle at 75% 35%, rgba(212, 175, 55, 0.25) 0%, transparent 55%),
                            linear-gradient(to right, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                            linear-gradient(to bottom, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                            linear-gradient(135deg, #121316 0%, #08090a 100%) !important;
                        background-size: cover, 16px 16px, 16px 16px, cover;
                        box-shadow: 0 12px 25px rgba(212, 175, 55, 0.2) !important;
                        border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
                    }

                    .vgb-atm-card.mastercard .card-front::after {
                        content: '';
                        position: absolute;
                        width: 180px;
                        height: 180px;
                        top: 20px;
                        right: 20px;
                        border: 2px double #d4af37;
                        border-radius: 50%;
                        transform: rotateX(75deg) rotateY(-20deg);
                        box-shadow: 0 0 25px rgba(212, 175, 55, 0.6), inset 0 0 25px rgba(212, 175, 55, 0.3);
                        filter: drop-shadow(0 0 4px rgba(212, 175, 55, 0.5));
                        pointer-events: none;
                        z-index: 1;
                    }

                    /* Gold styled text for Mastercard (Royale design) in preview */
                    .vgb-atm-card.mastercard .card-number-display,
                    .vgb-atm-card.mastercard .holder-name,
                    .vgb-atm-card.mastercard .expiry-value,
                    .vgb-atm-card.mastercard .expiry-label {
                        color: #d4af37 !important;
                        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8) !important;
                    }

                    .vgb-atm-card.rupay {
                        background: radial-gradient(circle at 80% 80%, #3a007c 0%, #080321 60%, #01000b 100%) !important;
                        box-shadow: 0 12px 25px rgba(99, 102, 241, 0.25) !important;
                        border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
                    }

                    .vgb-atm-card.rupay .card-front::after {
                        content: '';
                        position: absolute;
                        width: 250px;
                        height: 250px;
                        bottom: -90px;
                        right: -70px;
                        background: radial-gradient(circle, rgba(162, 23, 221, 0.45) 0%, rgba(93, 23, 221, 0.2) 45%, rgba(20, 10, 80, 0.05) 70%, transparent 80%);
                        border-radius: 50%;
                        transform: rotateX(65deg) rotateY(-15deg);
                        box-shadow: inset 0 0 50px rgba(162, 23, 221, 0.3), 0 0 60px rgba(162, 23, 221, 0.25);
                        pointer-events: none;
                        z-index: 1;
                    }

                    .card-bank-header {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        background: transparent;
                        z-index: 5;
                    }

                    .card-bank-name-stack {
                        display: flex;
                        flex-direction: column;
                        line-height: 1.1;
                    }

                    .card-bank-name-stack .bank-title {
                        font-size: 0.8rem;
                        font-weight: 800;
                        letter-spacing: 1.5px;
                        color: #ffffff;
                    }

                    .card-bank-name-stack .bank-subtitle {
                        font-size: 0.45rem;
                        font-weight: 600;
                        letter-spacing: 1px;
                        color: rgba(255, 255, 255, 0.7);
                    }

                    .card-middle-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-top: 15px;
                        z-index: 5;
                        background: transparent;
                    }

                    .contactless-icon {
                        font-size: 1.5rem;
                        transform: rotate(90deg);
                        opacity: 0.8;
                        color: #ffffff;
                    }

                    .card-number-display {
                        font-family: monospace;
                        font-size: 1.2rem;
                        letter-spacing: 2px;
                        font-weight: 600;
                        margin: 20px 0 10px;
                        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
                        color: #ffffff;
                        z-index: 5;
                    }

                    .card-bottom-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-end;
                        z-index: 5;
                        background: transparent;
                    }

                    .card-holder-info {
                        display: flex;
                        flex-direction: column;
                        gap: 2px;
                    }

                    .expiry-info {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .expiry-label {
                        font-size: 0.45rem;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        opacity: 0.7;
                        color: #ffffff;
                    }

                    .expiry-value {
                        font-size: 0.72rem;
                        font-weight: 700;
                        color: #ffffff;
                    }

                    .holder-name {
                        font-size: 0.85rem;
                        font-weight: 700;
                        letter-spacing: 0.5px;
                        text-transform: uppercase;
                        color: #ffffff;
                        font-family: monospace;
                    }

                    .brand-visa {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                        line-height: 1;
                    }

                    .brand-visa .visa-text {
                        font-size: 1.35rem;
                        font-weight: 800;
                        font-style: italic;
                        color: #ffffff;
                        letter-spacing: 0.5px;
                    }

                    .brand-visa .visa-sub {
                        font-size: 0.45rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        color: rgba(255, 255, 255, 0.8);
                        letter-spacing: 0.5px;
                        margin-top: -2px;
                    }

                    .brand-mastercard {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        line-height: 1;
                        gap: 2px;
                    }

                    .mc-circles {
                        display: flex;
                        align-items: center;
                        width: 28px;
                        height: 18px;
                        position: relative;
                    }

                    .mc-circles .circle {
                        width: 16px;
                        height: 16px;
                        border-radius: 50%;
                        position: absolute;
                    }

                    .mc-circles .circle.red {
                        background: #eb001b;
                        left: 0;
                    }

                    .mc-circles .circle.orange {
                        background: #ff5f00;
                        right: 0;
                        opacity: 0.9;
                    }

                    .mc-text {
                        font-size: 0.42rem;
                        font-weight: 700;
                        color: #ffffff;
                        text-transform: lowercase;
                        letter-spacing: 0.5px;
                    }

                    .brand-rupay {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                        line-height: 1;
                    }

                    .brand-rupay .rupay-text {
                        font-size: 1.1rem;
                        font-weight: 800;
                        font-style: italic;
                        color: #ffffff;
                        letter-spacing: 0.5px;
                    }

                    .brand-rupay .rupay-sub {
                        font-size: 0.45rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        color: rgba(255, 255, 255, 0.8);
                        letter-spacing: 0.5px;
                        margin-top: -1px;
                    }

                    .metallic-chip {
                        width: 42px;
                        height: 32px;
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #b45309 100%);
                        border-radius: 6px;
                        border: 1px solid rgba(255, 255, 255, 0.25);
                        box-shadow: inset 0 1px 3px rgba(255, 255, 255, 0.4);
                        position: relative;
                    }

                    .metallic-chip::after {
                        content: '';
                        position: absolute;
                        inset: 5px;
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        border-radius: 2px;
                    }

                    .card-back-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        font-size: 0.45rem;
                        color: rgba(255, 255, 255, 0.6);
                        margin-bottom: 2px;
                        z-index: 5;
                        background: transparent;
                    }

                    .card-back-magnetic-strip {
                        height: 35px;
                        background: #000000;
                        margin: 0 -20px;
                        z-index: 5;
                    }

                    .card-back-signature-container {
                        margin-top: 10px;
                        display: grid;
                        grid-template-columns: 1fr auto;
                        gap: 15px;
                        align-items: center;
                        z-index: 5;
                        background: transparent;
                    }

                    .signature-strip-text {
                        background: repeating-linear-gradient(45deg, #e2e8f0, #e2e8f0 4px, #cbd5e1 4px, #cbd5e1 8px);
                        height: 32px;
                        border-radius: 4px;
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                        padding-left: 12px;
                        line-height: 1.2;
                    }

                    .signature-strip-text span {
                        font-size: 0.45rem;
                        font-weight: 700;
                        color: #475569;
                        letter-spacing: 0.5px;
                    }

                    .signature-strip-cvv {
                        background: #ffffff;
                        height: 32px;
                        width: 45px;
                        border-radius: 4px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border: 1px solid #cbd5e1;
                    }

                    .signature-strip-cvv .cvv-val {
                        font-family: monospace;
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: #334155;
                        letter-spacing: 1px;
                    }

                    .card-back-bottom {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-top: 8px;
                        z-index: 5;
                        background: transparent;
                    }

                    .mc-hologram {
                        width: 30px;
                        height: 20px;
                        background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
                        border-radius: 3px;
                        opacity: 0.8;
                        box-shadow: 0 0 4px rgba(255, 255, 255, 0.1);
                    }

                    .back-logo-v {
                        display: flex;
                        align-items: center;
                        gap: 4px;
                    }

                    .logo-text-stacked {
                        display: flex;
                        flex-direction: column;
                        line-height: 1;
                    }

                    .logo-text-stacked .text-top {
                        font-size: 0.52rem;
                        font-weight: 800;
                        letter-spacing: 1px;
                        color: #ffffff;
                    }

                    .logo-text-stacked .text-bottom {
                        font-size: 0.35rem;
                        font-weight: 600;
                        letter-spacing: 0.5px;
                        color: rgba(255, 255, 255, 0.7);
                    }

                    .back-property-text {
                        font-size: 0.45rem;
                        opacity: 0.45;
                        text-align: center;
                        line-height: 1.3;
                        margin-top: 4px;
                        color: #ffffff;
                        border-top: 1px solid rgba(255, 255, 255, 0.08);
                        padding-top: 4px;
                        z-index: 5;
                    }

                    /* 3D Cheque */
                    .vgb-cheque-3d {
                        width: 330px;
                        aspect-ratio: 2.38 / 1;
                        background: linear-gradient(to right, #bae6fd, #e0f2fe);
                        border: 1px solid #93c5fd;
                        border-radius: 8px;
                        padding: 10px 14px;
                        color: #334155;
                        font-size: 0.55rem;
                        box-shadow: 0 10px 25px rgba(15, 23, 42, 0.1);
                        position: relative;
                        overflow: hidden;
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                        transition: transform 0.5s ease;
                        transform-style: preserve-3d;
                        cursor: pointer;
                    }

                    .vgb-cheque-3d:hover {
                        transform: translateY(-3px) rotateX(4deg);
                    }

                    .vgb-cheque-3d .cheque-hologram {
                        position: absolute;
                        left: 12px;
                        top: 0;
                        bottom: 0;
                        width: 14px;
                        background: linear-gradient(90deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
                        border-left: 1px solid rgba(255, 255, 255, 0.2);
                        border-right: 1px solid rgba(255, 255, 255, 0.2);
                        opacity: 0.85;
                        box-shadow: 0 0 5px rgba(0, 0, 0, 0.05);
                        z-index: 2;
                    }

                    .vgb-cheque-3d .cheque-hologram::after {
                        content: '';
                        position: absolute;
                        inset: 0;
                        background: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(255, 255, 255, 0.15) 5px, rgba(255, 255, 255, 0.15) 10px);
                    }

                    .vgb-cheque-3d .cheque-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                        z-index: 3;
                        margin-left: 14px;
                    }

                    .vgb-cheque-3d .cheque-bank-info {
                        display: flex;
                        flex-direction: column;
                    }

                    .vgb-cheque-3d .cheque-bank-name {
                        font-weight: 800;
                        font-size: 0.8rem;
                        letter-spacing: 0.5px;
                        color: #1e3a8a;
                        display: flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .vgb-cheque-3d .cheque-branch-details {
                        font-size: 0.45rem;
                        color: #475569;
                        line-height: 1.3;
                        margin-top: 2px;
                    }

                    .vgb-cheque-3d .cheque-date-box {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                    }

                    .vgb-cheque-3d .date-squares {
                        display: flex;
                        gap: 1.5px;
                        margin-bottom: 2px;
                    }

                    .vgb-cheque-3d .date-squares span {
                        width: 12px;
                        height: 14px;
                        border: 1px solid #1e3a8a;
                        background: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.5rem;
                        font-weight: 600;
                        color: #1e3a8a;
                        border-radius: 1px;
                    }

                    .vgb-cheque-3d .cheque-row {
                        display: flex;
                        align-items: flex-end;
                        margin: 4px 0;
                        z-index: 3;
                        margin-left: 14px;
                    }

                    .vgb-cheque-3d .cheque-label {
                        font-weight: bold;
                        font-size: 0.62rem;
                        color: #1e3a8a;
                        white-space: nowrap;
                        display: flex;
                        align-items: baseline;
                        gap: 3px;
                    }

                    .vgb-cheque-3d .hindi-text {
                        font-size: 0.55rem;
                        font-weight: normal;
                        color: #64748b;
                    }

                    .vgb-cheque-3d .cheque-line-fill {
                        flex: 1;
                        border-bottom: 1.5px dotted #64748b;
                        margin: 0 8px;
                        font-family: 'Times New Roman', Times, serif;
                        font-size: 0.8rem;
                        font-style: italic;
                        font-weight: 700;
                        color: #0f172a;
                        padding-bottom: 1px;
                        padding-left: 5px;
                        letter-spacing: 0.5px;
                    }

                    .vgb-cheque-3d .bearer-text {
                        font-size: 0.52rem !important;
                    }

                    .vgb-cheque-3d .cheque-amount-box {
                        width: 100px;
                        height: 24px;
                        border: 1.5px solid #1e3a8a;
                        background: white;
                        border-radius: 4px;
                        display: flex;
                        align-items: center;
                        padding: 0 6px;
                        position: relative;
                        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
                    }

                    .vgb-cheque-3d .rupee-symbol {
                        font-size: 0.8rem;
                        font-weight: 800;
                        color: #1e3a8a;
                        border-right: 1.5px solid #1e3a8a;
                        padding-right: 4px;
                        height: 100%;
                        display: flex;
                        align-items: center;
                    }

                    .vgb-cheque-3d .amount-val {
                        flex: 1;
                        font-family: monospace;
                        font-size: 0.8rem;
                        font-weight: 700;
                        text-align: right;
                        letter-spacing: 0.5px;
                        color: #0f172a;
                    }

                    .vgb-cheque-3d .cheque-details-row {
                        display: grid;
                        grid-template-columns: 1.4fr 0.6fr 1.2fr 1.2fr;
                        gap: 8px;
                        align-items: flex-end;
                        margin-top: 6px;
                        z-index: 3;
                        margin-left: 14px;
                    }

                    .vgb-cheque-3d .cheque-acc-box {
                        border: 1.5px solid #1e3a8a;
                        background: white;
                        border-radius: 4px;
                        display: flex;
                        align-items: center;
                        padding: 2px 6px;
                        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
                    }

                    .vgb-cheque-3d .acc-label {
                        font-size: 0.45rem;
                        font-weight: bold;
                        color: #1e3a8a;
                        border-right: 1px solid #cbd5e1;
                        padding-right: 4px;
                        margin-right: 4px;
                        line-height: 1.2;
                        white-space: nowrap;
                    }

                    .vgb-cheque-3d .acc-val {
                        font-family: monospace;
                        font-size: 0.72rem;
                        font-weight: 700;
                        letter-spacing: 0.5px;
                        color: #0f172a;
                    }

                    .vgb-cheque-3d .cheque-branch-codes {
                        font-size: 0.45rem;
                        color: #475569;
                        font-family: monospace;
                        line-height: 1.2;
                        font-weight: 600;
                    }

                    .vgb-cheque-3d .cheque-payable-text {
                        font-size: 0.4rem;
                        color: #64748b;
                        line-height: 1.2;
                        border-left: 1px solid #cbd5e1;
                        padding-left: 6px;
                    }

                    .vgb-cheque-3d .cheque-sign-area {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                        text-align: right;
                        padding-bottom: 2px;
                    }

                    .vgb-cheque-3d .cheque-sign-name {
                        font-family: 'Brush Script MT', cursive, sans-serif;
                        font-size: 1.1rem;
                        font-style: italic;
                        color: #2563eb;
                        margin-bottom: 2px;
                        font-weight: 500;
                        letter-spacing: 0.5px;
                        max-width: 100px;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .vgb-cheque-3d .cheque-sign-label {
                        font-size: 0.45rem;
                        color: #475569;
                        font-weight: bold;
                    }

                    .vgb-cheque-3d .cheque-micr-band {
                        text-align: center;
                        font-family: 'Courier New', Courier, monospace;
                        font-size: 0.7rem;
                        font-weight: 700;
                        letter-spacing: 2px;
                        color: #0f172a;
                        margin-top: 10px;
                        margin-bottom: 2px;
                        border-top: 1px dashed rgba(99, 102, 241, 0.1);
                        padding-top: 6px;
                        z-index: 3;
                        margin-left: 14px;
                    }

                    /* 3D Passbook Booklet */
                    .passbook-wrapper {
                        width: 280px;
                        height: 180px;
                        position: relative;
                        transform-style: preserve-3d;
                        cursor: pointer;
                        perspective: 800px;
                    }

                    .passbook-book {
                        width: 100%;
                        height: 100%;
                        position: relative;
                        transform-style: preserve-3d;
                        transform: rotateX(12deg) rotateY(-18deg);
                        transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
                    }

                    .passbook-book::before {
                        content: '';
                        position: absolute;
                        left: 0;
                        top: 0;
                        bottom: 0;
                        width: 10px;
                        background: linear-gradient(90deg, rgba(0, 0, 0, 0.5) 0%, rgba(255, 255, 255, 0.15) 30%, rgba(0, 0, 0, 0.2) 100%);
                        z-index: 50;
                        border-radius: 8px 0 0 8px;
                    }

                    .passbook-cover-wrapper {
                        position: absolute;
                        inset: 0;
                        transform-origin: left center;
                        transform-style: preserve-3d;
                        transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
                        z-index: 30;
                    }

                    .passbook-book.open .passbook-cover-wrapper {
                        transform: rotateY(-155deg);
                    }

                    .passbook-cover-front {
                        position: absolute;
                        inset: 0;
                        backface-visibility: hidden;
                        background: radial-gradient(circle at 30% 30%, #1e1b4b 0%, #0c0a21 65%, #02000a 100%);
                        border-radius: 8px;
                        padding: 15px;
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                        z-index: 2;
                        border: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .passbook-cover-inside {
                        position: absolute;
                        inset: 0;
                        backface-visibility: hidden;
                        transform: rotateY(180deg);
                        background: linear-gradient(135deg, #0f0b29 0%, #03010f 100%);
                        border-radius: 8px;
                        padding: 15px;
                        color: #e2e8f0;
                        z-index: 1;
                        font-size: 0.5rem;
                    }

                    .passbook-page {
                        position: absolute;
                        width: 98%;
                        height: 96%;
                        top: 2%;
                        left: 1%;
                        background: #faf8f5;
                        border-radius: 4px 8px 8px 4px;
                        padding: 15px;
                        color: #334155;
                        z-index: 20;
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                        box-shadow: inset 3px 0 10px rgba(0, 0, 0, 0.15);
                    }

                    /* Statement Meta Grid */
                    .statement-meta-grid {
                        display: grid;
                        grid-template-columns: 1fr;
                        gap: 20px;
                        margin-bottom: 25px;
                    }

                    @media (min-width: 768px) {
                        .statement-meta-grid {
                            grid-template-columns: 1fr 1fr;
                        }
                    }

                    .statement-ledger-section {
                        margin-top: 15px;
                    }

                    .txn-deposit {
                        color: var(--accent-emerald) !important;
                    }

                    .txn-withdrawal {
                        color: var(--secondary-500) !important;
                    }

                    .txn-fee {
                        color: var(--accent-amber) !important;
                    }

                    .print-only {
                        display: none !important;
                    }

                    /* Print styling */
                    @media print {
                        body {
                            background: white !important;
                            color: black !important;
                        }

                        /* Hide everything that is NOT the statement modal */
                        body>*:not(#statementModal) {
                            display: none !important;
                        }

                        #statementModal {
                            display: block !important;
                            position: relative !important;
                            background: white !important;
                            margin: 0 !important;
                            padding: 0 !important;
                            width: 100% !important;
                            box-shadow: none !important;
                            overflow: visible !important;
                        }

                        #statementModal .modal-content {
                            display: block !important;
                            box-shadow: none !important;
                            border: none !important;
                            width: 100% !important;
                            max-width: 100% !important;
                            margin: 0 !important;
                            padding: 0 !important;
                            overflow: visible !important;
                        }

                        #statementModal .modal-body {
                            padding: 0 !important;
                        }

                        #statementModal .no-print {
                            display: none !important;
                        }

                        .statement-meta-grid {
                            grid-template-columns: 1fr 1fr !important;
                            display: grid !important;
                            margin-bottom: 25px !important;
                        }

                        /* Table formatting to fit portrait page */
                        #statementTxnTable {
                            table-layout: fixed !important;
                            width: 100% !important;
                            border-collapse: collapse !important;
                        }

                        #statementTxnTable th,
                        #statementTxnTable td {
                            padding: 6px 4px !important;
                            font-size: 10px !important;
                            white-space: normal !important;
                            word-wrap: break-word !important;
                            word-break: break-word !important;
                        }

                        /* Column widths for standard portrait layout */
                        #statementTxnTable th:nth-child(1),
                        #statementTxnTable td:nth-child(1) {
                            width: 5% !important;
                        }

                        #statementTxnTable th:nth-child(2),
                        #statementTxnTable td:nth-child(2) {
                            width: 16% !important;
                        }

                        #statementTxnTable th:nth-child(3),
                        #statementTxnTable td:nth-child(3) {
                            width: 8% !important;
                        }

                        #statementTxnTable th:nth-child(4),
                        #statementTxnTable td:nth-child(4) {
                            width: 27% !important;
                        }

                        #statementTxnTable th:nth-child(5),
                        #statementTxnTable td:nth-child(5) {
                            width: 8% !important;
                        }

                        #statementTxnTable th:nth-child(6),
                        #statementTxnTable td:nth-child(6) {
                            width: 12% !important;
                        }

                        #statementTxnTable th:nth-child(7),
                        #statementTxnTable td:nth-child(7) {
                            width: 12% !important;
                        }

                        #statementTxnTable th:nth-child(8),
                        #statementTxnTable td:nth-child(8) {
                            width: 12% !important;
                        }

                        .print-only {
                            display: flex !important;
                        }

                        .badge-id,
                        .txn-deposit,
                        .txn-withdrawal,
                        span[style*="background"] {
                            background: transparent !important;
                            padding: 0 !important;
                        }
                    }

                    /* Footer margin fix */
                    .footer {
                        margin-left: 280px;
                        background: var(--white) !important;
                        border-top: 1px solid var(--glass-border) !important;
                        padding: 24px 0;
                        transition: all 0.3s ease;
                    }

                    body.dark-mode .footer {
                        background: rgba(15, 23, 42, 0.8) !important;
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
                <header class="header scrolled no-print">
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation"
                            style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                            <i class="bx bx-menu"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo"
                            style="display: flex; align-items: center; text-decoration: none;">
                            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo"
                                style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
                        </a>
                    </div>
                    <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/logo.png"
                                alt="Admin Profile Avatar"
                                style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                            <script>
                                (function () {
                                    const avatar = localStorage.getItem('admin_avatar');
                                    if (avatar) {
                                        document.getElementById('adminHeaderAvatar').src = avatar;
                                    }
                                })();
                            </script>
                            <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                                <span
                                    style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">Root
                                    Administrator</span>
                                <span
                                    style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                    <span
                                        style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
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
                <aside class="sidebar no-print">
                    <div class="sidebar-menu">
                        <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i>
                            Dashboard</a>
                        <a href="${pageContext.request.contextPath}/account?action=list" class="active"><i
                                class="bx bx-user-check"></i> Manage Accounts</a>
                        <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i>
                            Manage Cards</a>
                        <a href="${pageContext.request.contextPath}/chequebook?action=list"><i
                                class="bx bx-book-bookmark"></i> Cheque Requests</a>
                        <a href="${pageContext.request.contextPath}/passbook?action=list"><i
                                class="bx bx-book-open"></i> Passbook Requests</a>
                        <a href="${pageContext.request.contextPath}/loan?action=list"><i
                                class="bx bx-building-house"></i> Review Loans</a>
                        <a href="${pageContext.request.contextPath}/cash-counter"><i class="bx bx-wallet"></i> Cash Counter</a>
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

                        <!-- Welcome Header -->
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;"
                            class="no-print">
                            <div>
                                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Manage Accounts
                                </h2>
                                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer
                                    records, issue and update corporate assets, and review statements.</p>
                            </div>
                        </div>

                        <!-- Alerts -->
                        <c:if test="${not empty error}">
                            <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;"
                                class="no-print">
                                <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                                <span>${error}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;"
                                class="no-print">
                                <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                                <span>${success}</span>
                            </div>
                        </c:if>

                        <!-- Statistics Cards -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px;"
                            class="no-print">
                            <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                                <div class="stat-icon"
                                    style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                                    <i class="bx bx-group"></i>
                                </div>
                                <div>
                                    <span
                                        style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Total
                                        Customers</span>
                                    <strong
                                        style="font-size: 1.6rem; color: var(--gray-800);">${totalCustomers}</strong>
                                </div>
                            </div>
                            <div class="stat-card" style="border-left: 5px solid var(--accent-cyan);">
                                <div class="stat-icon"
                                    style="background: rgba(6, 182, 212, 0.1); color: var(--accent-cyan);">
                                    <i class="bx bx-user"></i>
                                </div>
                                <div>
                                    <span
                                        style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings
                                        (Single)</span>
                                    <strong
                                        style="font-size: 1.6rem; color: var(--gray-800);">${totalSavingsSingle}</strong>
                                </div>
                            </div>
                            <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                                <div class="stat-icon"
                                    style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                                    <i class="bx bx-group-work"></i>
                                </div>
                                <div>
                                    <span
                                        style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings
                                        (Joint)</span>
                                    <strong
                                        style="font-size: 1.6rem; color: var(--gray-800);">${totalSavingsJoint}</strong>
                                </div>
                            </div>
                            <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                                <div class="stat-icon"
                                    style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                                    <i class="bx bx-briefcase"></i>
                                </div>
                                <div>
                                    <span
                                        style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current
                                        Accounts</span>
                                    <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalCurrent}</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Collapsible Required Documents Guide -->
                    <div class="glass-card no-print" style="margin-bottom: 30px; padding: 20px 25px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; cursor: pointer;"
                            onclick="toggleDocsGuide()">
                            <h4
                                style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin: 0;">
                                <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                KYC & Required Documents Guide for Account Opening
                            </h4>
                            <i class="bx bx-chevron-down" id="docsGuideArrow"
                                style="font-size: 1.5rem; color: var(--gray-500); transition: transform 0.3s ease;"></i>
                        </div>

                        <div id="docsGuideContent"
                            style="max-height: 0px; overflow: hidden; transition: max-height 0.3s cubic-bezier(0, 1, 0, 1);">
                            <hr style="border: none; border-top: 1px solid var(--gray-100); margin: 15px 0;">
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px;"
                                class="mobile-grid-1">
                                <!-- Savings Accounts -->
                                <div
                                    style="background: rgba(99, 102, 241, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border);">
                                    <h5
                                        style="font-size: 0.9rem; font-weight: 700; color: var(--primary-600); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                        <i class="bx bx-user" style="font-size: 1.1rem;"></i> Savings Account (Single &
                                        Joint)
                                    </h5>
                                    <ul
                                        style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                        <li><strong>ID Proof (POI):</strong> Aadhaar Card, PAN Card, Voter ID, or
                                            Passport.</li>
                                        <li><strong>Address Proof (POA):</strong> Aadhaar, Utility Bill, or Rental
                                            Agreement.</li>
                                        <li><strong>Photographs:</strong> 1 passport-size photo (uploaded dynamically).
                                        </li>
                                        <li><strong>Nominee Details:</strong> ID details and nominee relationship
                                            declaration.</li>
                                        <li><strong>Joint Holder Info:</strong> Full KYC documents for all signatory
                                            owners.</li>
                                    </ul>
                                </div>

                                <!-- Current Accounts -->
                                <div
                                    style="background: rgba(16, 185, 129, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid rgba(16, 185, 129, 0.1);">
                                    <h5
                                        style="font-size: 0.9rem; font-weight: 700; color: var(--accent-emerald); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                        <i class="bx bx-briefcase" style="font-size: 1.1rem;"></i> Commercial Current
                                        Account
                                    </h5>
                                    <ul
                                        style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                        <li><strong>Business Registration:</strong> Certificate of Incorporation or
                                            Partnership Deed.</li>
                                        <li><strong>Tax details:</strong> GSTIN Certificate and Entity Permanent Account
                                            (PAN Card).</li>
                                        <li><strong>KYC of Partners:</strong> Aadhaar Card, PAN Card, and photos of all
                                            signing authorities.</li>
                                        <li><strong>Board Resolution:</strong> Authorization letter for corporate bank
                                            transactions.</li>
                                    </ul>
                                </div>

                                <!-- Student Accounts -->
                                <div
                                    style="background: rgba(6, 182, 212, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid rgba(6, 182, 212, 0.1);">
                                    <h5
                                        style="font-size: 0.9rem; font-weight: 700; color: var(--accent-cyan); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                        <i class="bx bx-book-bookmark" style="font-size: 1.1rem;"></i> Student Account
                                        Requirements
                                    </h5>
                                    <ul
                                        style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                        <li><strong>Educational ID:</strong> Original School / College ID Card copy.
                                        </li>
                                        <li><strong>Study Proof:</strong> Bonafide Certificate issued by the academic
                                            registrar.</li>
                                        <li><strong>Age verification:</strong> Birth certificate (for minor student
                                            accounts).</li>
                                        <li><strong>Guardian Consent:</strong> KYC & signature of guardian if applicant
                                            age < 18.</li>
                                    </ul>
                                </div>

                                <!-- Salary Accounts -->
                                <div
                                    style="background: rgba(236, 72, 153, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid rgba(236, 72, 153, 0.1);">
                                    <h5
                                        style="font-size: 0.9rem; font-weight: 700; color: var(--secondary-500); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                        <i class="bx bx-money" style="font-size: 1.1rem;"></i> Salary Account
                                        Requirements
                                    </h5>
                                    <ul
                                        style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                        <li><strong>Employment ID:</strong> Corporate Employee Identification Card.</li>
                                        <li><strong>Income Proof:</strong> Company employment letter or salary credit
                                            mandate.</li>
                                        <li><strong>Employer Verification:</strong> Official corporate email/phone
                                            configuration.</li>
                                        <li><strong>Standard KYC:</strong> Primary applicant POI and POA (Aadhaar &
                                            PAN).</li>
                                    </ul>
                                </div>

                                <!-- Term Deposit (FD / RD) -->
                                <div
                                    style="background: rgba(245, 158, 11, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid rgba(245, 158, 11, 0.1);">
                                    <h5
                                        style="font-size: 0.9rem; font-weight: 700; color: var(--accent-amber); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                        <i class="bx bx-time-five" style="font-size: 1.1rem;"></i> Term Deposits (Fixed
                                        & Recurring)
                                    </h5>
                                    <ul
                                        style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                        <li><strong>VGB Customer Base:</strong> Linked active saving account (or
                                            standard KYC).</li>
                                        <li><strong>RD Auto-debit:</strong> Signed standing instruction form for monthly
                                            credits.</li>
                                        <li><strong>FD Funding:</strong> Cleared check, demand draft, or bank account
                                            transfer.</li>
                                        <li><strong>Maturity payout:</strong> Linked savings account payout details
                                            registry.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Customer List Table Card -->
                    <div class="glass-card">
                        <div class="search-container no-print"
                            style="display: flex; gap: 15px; align-items: center; margin-bottom: 25px; flex-wrap: wrap;">
                            <div class="search-box" style="flex: 2; min-width: 280px; position: relative;">
                                <i class="bx bx-search"
                                    style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.2rem;"></i>
                                <input type="text" id="accountSearchInput"
                                    placeholder="Search customer ID, account number, or name..."
                                    onkeyup="filterAccountsTable()"
                                    style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: var(--white); color: var(--gray-800); transition: all var(--transition-normal);">
                            </div>
                            <div style="flex: 1; min-width: 160px;">
                                <select id="accountTypeFilter" onchange="filterAccountsTable()" class="form-group"
                                    style="padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); color: var(--gray-700); width: 100%; outline: none; transition: border-color 0.2s; font-size: 0.85rem; font-weight: 500; height: 48px;">
                                    <option value="">All Account Types</option>
                                    <option value="savings">Savings Account</option>
                                    <option value="current">Current Account</option>
                                    <option value="salary">Salary Account</option>
                                    <option value="student">Student Account</option>
                                    <option value="fd">Fixed Deposit (FD)</option>
                                    <option value="rd">Recurring Deposit (RD)</option>
                                </select>
                            </div>
                            <div style="flex: 1; min-width: 160px;">
                                <select id="accountStatusFilter" onchange="filterAccountsTable()" class="form-group"
                                    style="padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); color: var(--gray-700); width: 100%; outline: none; transition: border-color 0.2s; font-size: 0.85rem; font-weight: 500; height: 48px;">
                                    <option value="">All Statuses</option>
                                    <option value="active">Active</option>
                                    <option value="closed">Closed</option>
                                </select>
                            </div>
                            <button class="btn btn-primary" onclick="openWizardModal()"
                                style="display: inline-flex; align-items: center; gap: 8px; height: 48px; border-radius: var(--radius-md); padding: 0 20px;">
                                <i class="bx bx-plus-circle" style="font-size: 1.15rem;"></i>
                                <span style="font-weight: 600;">Create New Account</span>
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table id="accountsTable">
                                <thead>
                                    <tr>
                                        <th>Sr No.</th>
                                        <th>Customer ID</th>
                                        <th>Customer Name</th>
                                        <th>Account Number</th>
                                        <th>Account Type</th>
                                        <th style="text-align: right;">Total Balance</th>
                                        <th style="text-align: center;">Status</th>
                                        <th style="text-align: center;">Statement</th>
                                        <th style="text-align: center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty accounts}">
                                            <c:forEach var="acc" items="${accounts}" varStatus="status">
                                                <tr class="account-row-data" data-account-type="${acc.accountType}"
                                                    data-account-status="${acc.status}">
                                                    <td style="font-weight: 600; color: var(--gray-500);">${status.index
                                                        + 1}</td>
                                                    <td><span class="badge-id td-cust-id">#CUST-${acc.customerId}</span>
                                                    </td>
                                                    <td style="font-weight: 600; color: var(--gray-800);"
                                                        class="td-cust-name">${acc.customerName}</td>
                                                    <td><span class="badge-id td-acc-num">${acc.accountNumber}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${acc.accountType eq 'savings'}">
                                                                <span class="badge-type-savings">Savings</span>
                                                            </c:when>
                                                            <c:when test="${acc.accountType eq 'current'}">
                                                                <span class="badge-type-current">Current</span>
                                                            </c:when>
                                                            <c:when test="${acc.accountType eq 'salary'}">
                                                                <span class="badge-type-salary">Salary</span>
                                                            </c:when>
                                                            <c:when test="${acc.accountType eq 'student'}">
                                                                <span class="badge-type-student">Student</span>
                                                            </c:when>
                                                            <c:when test="${acc.accountType eq 'fd'}">
                                                                <span class="badge-type-fd">FD Deposit</span>
                                                            </c:when>
                                                            <c:when test="${acc.accountType eq 'rd'}">
                                                                <span class="badge-type-rd">RD Deposit</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge-type-savings">${acc.accountType}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td
                                                        style="text-align: right; font-weight: 700; color: var(--gray-800);">
                                                        ₹
                                                        <fmt:formatNumber value="${acc.balance}" minFractionDigits="2"
                                                            maxFractionDigits="2" />
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <c:choose>
                                                            <c:when test="${acc.status eq 'active'}">
                                                                <span class="status-pill-active">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill-closed">${acc.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <button type="button" class="btn btn-primary"
                                                            style="padding: 8px 14px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; display: inline-flex; align-items: center; gap: 4px; border: none;"
                                                            onclick="openStatementModal(Number('${acc.accountId}'), '${acc.customerName}', '${acc.accountNumber}', '${acc.accountType}', Number('${acc.balance}'), '${acc.status}')">
                                                            <i class="bx bx-receipt"></i> View Statement
                                                        </button>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <div
                                                            style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                            <button type="button"
                                                                class="btn-action-circle btn-action-view"
                                                                title="View Details"
                                                                onclick="openViewModal(Number('${status.index}'))">
                                                                <i class="bx bx-show"></i>
                                                            </button>
                                                            <button type="button"
                                                                class="btn-action-circle btn-action-edit"
                                                                title="Edit Account"
                                                                onclick="openEditModal(Number('${status.index}'))">
                                                                <i class="bx bx-edit"></i>
                                                            </button>
                                                            <c:if test="${acc.status ne 'closed'}">
                                                                <button type="button"
                                                                    class="btn-action-circle btn-action-block"
                                                                    title="Close Account"
                                                                    onclick="openCloseModal(Number('${status.index}'))">
                                                                    <i class="bx bx-block"></i>
                                                                </button>
                                                            </c:if>
                                                            <a href="${pageContext.request.contextPath}/account?action=delete&id=${acc.accountId}"
                                                                class="btn-action-circle btn-action-delete"
                                                                title="Delete Profile"
                                                                onclick="return confirm('WARNING: Are you sure you want to delete account ${acc.accountNumber} and all associated signatories permanently?');">
                                                                <i class="bx bx-trash"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="9"
                                                    style="text-align: center; padding: 40px; color: var(--gray-400); font-style: italic;">
                                                    <i class="bx bx-info-circle"
                                                        style="font-size: 2.5rem; display: block; margin-bottom: 15px;"></i>
                                                    No bank accounts registered in the database ledger.
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

                <!-- ==========================================
         NEW ACCOUNT SUMMARY MODAL
         ========================================== -->
                <c:if test="${not empty newAccountSummary}">
                    <div class="modal" id="newAccountSummaryModal" style="display: flex;">
                        <div class="modal-content" style="max-width: 650px;">
                            <div class="modal-header"
                                style="background: rgba(16, 185, 129, 0.05); border-bottom: 1px solid var(--gray-100);">
                                <h3
                                    style="font-weight: 700; color: #047857; display: flex; align-items: center; gap: 8px; margin: 0;">
                                    <i class="bx bx-check-circle" style="color: #10b981; font-size: 1.6rem;"></i> Bank
                                    Account Opened Successfully
                                </h3>
                                <button type="button" class="close-modal-btn"
                                    onclick="closeModal('newAccountSummaryModal')"><i class="bx bx-x"></i></button>
                            </div>
                            <div class="modal-body" style="padding: 25px;">
                                <div style="background: rgba(16, 185, 129, 0.05); border: 1px solid rgba(16, 185, 129, 0.2); border-radius: var(--radius-md); padding: 15px; margin-bottom: 20px; text-align: center;"
                                    class="no-print">
                                    <span style="font-size: 0.85rem; color: #047857; font-weight: 600;">
                                        The bank account has been successfully registered in the ledger. Please note
                                        down or print the customer credentials below.
                                    </span>
                                </div>

                                <div class="statement-print-area">
                                    <!-- Header for print -->
                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 10px; margin-bottom: 20px;">
                                        <div>
                                            <h2
                                                style="font-size: 1.4rem; font-weight: 800; color: var(--primary-500); letter-spacing: 0.5px; margin: 0; line-height: 1;">
                                                VERTEX GALAXY BANK</h2>
                                            <p
                                                style="font-size: 0.75rem; color: var(--gray-500); margin: 3px 0 0; font-weight: 500;">
                                                Account Opening Credentials Summary</p>
                                        </div>
                                        <div style="text-align: right;">
                                            <span
                                                style="font-family: monospace; font-size: 0.8rem; color: var(--gray-500); font-weight: 700;">BRANCH:
                                                RAJKOT</span>
                                        </div>
                                    </div>

                                    <!-- Summary Content -->
                                    <h4
                                        style="font-weight: 700; color: var(--gray-800); border-bottom: 1.5px solid var(--gray-100); padding-bottom: 5px; margin-bottom: 12px; font-size: 0.95rem;">
                                        <i class="bx bx-wallet" style="color: var(--primary-500);"></i> Core Account
                                        Information
                                    </h4>
                                    <table
                                        style="width: 100%; font-size: 0.85rem; line-height: 1.8; margin-bottom: 20px;">
                                        <tr>
                                            <td style="color: var(--gray-500); width: 35%;">Customer ID:</td>
                                            <td style="font-weight: 700; color: var(--gray-800);">
                                                ${newAccountSummary.customerId}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">CIF Number:</td>
                                            <td
                                                style="font-weight: 700; color: var(--gray-800); font-family: monospace;">
                                                ${newAccountSummary.cifNumber}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Account Number:</td>
                                            <td
                                                style="font-weight: 800; font-family: monospace; color: var(--gray-800); font-size: 0.95rem;">
                                                ${newAccountSummary.accountNumber}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Application Ref Number:</td>
                                            <td
                                                style="font-weight: 700; font-family: monospace; color: var(--gray-800);">
                                                ${newAccountSummary.applicationRefNo}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Passbook Number:</td>
                                            <td
                                                style="font-weight: 700; font-family: monospace; color: var(--gray-800);">
                                                ${newAccountSummary.passbookNumber}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">ATM Card Number:</td>
                                            <td
                                                style="font-weight: 700; font-family: monospace; color: var(--gray-800);">
                                                ${newAccountSummary.atmCardNumber}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">IFSC Code:</td>
                                            <td style="font-weight: 700; font-family: monospace;">
                                                ${newAccountSummary.ifscCode}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Account Type:</td>
                                            <td style="font-weight: 700; text-transform: uppercase;">
                                                ${newAccountSummary.accountType} (${newAccountSummary.holdingType})</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Initial Deposit:</td>
                                            <td style="font-weight: 800; color: var(--accent-emerald);">₹
                                                <fmt:formatNumber value="${newAccountSummary.initialAmount}"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Account Status:</td>
                                            <td style="font-weight: 700; color: #10b981; text-transform: uppercase;">
                                                ${newAccountSummary.accountStatus}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">KYC Status:</td>
                                            <td style="font-weight: 700; color: #3b82f6; text-transform: uppercase;">
                                                ${newAccountSummary.kycStatus}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Account Opening Date:</td>
                                            <td style="font-weight: 700; color: var(--gray-800);">
                                                ${newAccountSummary.accountOpeningDate}</td>
                                        </tr>
                                        <tr
                                            style="border-top: 1px dashed var(--gray-200); padding-top: 5px; margin-top: 5px;">
                                            <td style="color: var(--primary-500); font-weight: 700;">Secure ATM/Counter
                                                PIN:</td>
                                            <td
                                                style="font-weight: 800; color: var(--primary-700); font-size: 1.1rem; letter-spacing: 2px; font-family: monospace;">
                                                ${newAccountSummary.pin}</td>
                                        </tr>
                                    </table>

                                    <h4
                                        style="font-weight: 700; color: var(--gray-800); border-bottom: 1.5px solid var(--gray-100); padding-bottom: 5px; margin-bottom: 12px; font-size: 0.95rem;">
                                        <i class="bx bx-key" style="color: var(--primary-500);"></i> Access Credentials
                                    </h4>

                                    <c:choose>
                                        <c:when test="${newAccountSummary.accountType eq 'savings'}">
                                            <!-- Savings Account Credentials -->
                                            <table
                                                style="width: 100%; font-size: 0.85rem; line-height: 1.8; margin-bottom: 20px;">
                                                <tr>
                                                    <td style="color: var(--gray-500); width: 35%;">Primary Holder Name:
                                                    </td>
                                                    <td style="font-weight: 700; color: var(--gray-800);">
                                                        ${newAccountSummary.primaryName}</td>
                                                </tr>
                                                <tr>
                                                    <td style="color: var(--gray-500);">Login Username:</td>
                                                    <td
                                                        style="font-weight: 700; font-family: monospace; color: var(--primary-600);">
                                                        ${newAccountSummary.primaryUsername}</td>
                                                </tr>
                                                <tr>
                                                    <td style="color: var(--gray-500);">Login Password:</td>
                                                    <td style="font-weight: 700; font-family: monospace;">
                                                        ${newAccountSummary.primaryPassword}</td>
                                                </tr>

                                                <c:if test="${newAccountSummary.holdingType eq 'joint'}">
                                                    <tr
                                                        style="border-top: 1px dashed var(--gray-100); padding-top: 10px; margin-top: 10px;">
                                                        <td style="color: var(--gray-500);">Joint Holder Name:</td>
                                                        <td style="font-weight: 700; color: var(--gray-800);">
                                                            ${newAccountSummary.jointName}</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="color: var(--gray-500);">Login Username:</td>
                                                        <td
                                                            style="font-weight: 700; font-family: monospace; color: var(--primary-600);">
                                                            ${newAccountSummary.jointUsername}</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="color: var(--gray-500);">Login Password:</td>
                                                        <td style="font-weight: 700; font-family: monospace;">
                                                            ${newAccountSummary.jointPassword}</td>
                                                    </tr>
                                                </c:if>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Current Corporate Credentials -->
                                            <table
                                                style="width: 100%; font-size: 0.85rem; line-height: 1.8; margin-bottom: 20px;">
                                                <tr>
                                                    <td style="color: var(--gray-500); width: 35%;">Business Name:</td>
                                                    <td style="font-weight: 700; color: var(--gray-800);">
                                                        ${newAccountSummary.businessName}</td>
                                                </tr>
                                                <tr>
                                                    <td style="color: var(--gray-500);">GSTIN:</td>
                                                    <td style="font-weight: 700; font-family: monospace;">
                                                        ${newAccountSummary.gstin}</td>
                                                </tr>
                                            </table>

                                            <div style="margin-top: 10px; margin-bottom: 20px;">
                                                <span
                                                    style="font-weight: 700; font-size: 0.8rem; color: var(--gray-600); display: block; margin-bottom: 8px;">Signatory
                                                    / Partner Credentials:</span>
                                                <c:forEach var="partner" items="${newAccountSummary.partners}">
                                                    <div
                                                        style="margin-bottom: 10px; background: rgba(99, 102, 241, 0.02); border: 1.5px solid var(--gray-200); padding: 12px; border-radius: var(--radius-sm);">
                                                        <div
                                                            style="font-weight: 700; font-size: 0.8rem; color: var(--gray-800); margin-bottom: 4px;">
                                                            ${partner.name} (${partner.role})</div>
                                                        <div style="display: flex; gap: 20px; font-size: 0.8rem;">
                                                            <span><strong>Username:</strong> <code
                                                                    style="font-weight:700; color:var(--primary-600);">${partner.username}</code></span>
                                                            <span><strong>Password:</strong> <code
                                                                    style="font-weight:700;">${partner.password}</code></span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <h4
                                        style="font-weight: 700; color: var(--gray-800); border-bottom: 1.5px solid var(--gray-100); padding-bottom: 5px; margin-bottom: 12px; font-size: 0.95rem;">
                                        <i class="bx bx-chip" style="color: var(--primary-500);"></i> Requested
                                        Instruments
                                    </h4>
                                    <table style="width: 100%; font-size: 0.85rem; line-height: 1.8;">
                                        <tr>
                                            <td style="color: var(--gray-500); width: 35%;">ATM Debit Card:</td>
                                            <td style="font-weight: 700;">${newAccountSummary.atmCard}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Cheque Book (50 leaves):</td>
                                            <td style="font-weight: 700;">${newAccountSummary.chequeBook}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Passbook Booklet:</td>
                                            <td style="font-weight: 700;">${newAccountSummary.passbook}</td>
                                        </tr>
                                    </table>

                                    <div style="margin-top: 30px; text-align: center; font-size: 0.75rem; color: var(--gray-400); border-top: 1px dashed var(--gray-300); padding-top: 15px;"
                                        class="print-only">
                                        This is a system generated secure credentials sheet. Please change your password
                                        and PIN upon first login.
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer no-print">
                                <button type="button" class="btn btn-primary" onclick="window.print()"
                                    style="display: inline-flex; align-items: center; gap: 6px;">
                                    <i class="bx bx-printer"></i> Print Summary
                                </button>
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeModal('newAccountSummaryModal')">Close</button>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- ==========================================
         VIEW ACCOUNT MODAL
         ========================================== -->
                <div class="modal" id="viewAccountModal">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3
                                style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-user" style="color: var(--primary-500);"></i> Account Details Summary
                            </h3>
                            <button type="button" class="close-modal-btn" onclick="closeModal('viewAccountModal')"><i
                                    class="bx bx-x"></i></button>
                        </div>
                        <div class="modal-body" id="viewModalBody">
                            <!-- Dynamically populated via JS -->
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                onclick="closeModal('viewAccountModal')">Close</button>
                        </div>
                    </div>
                </div>

                <!-- ==========================================
         EDIT ACCOUNT MODAL
         ========================================== -->
                <div class="modal" id="editAccountModal">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/account?action=edit" method="POST">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="accountId" id="editAccountId">

                            <div class="modal-header">
                                <h3
                                    style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-edit" style="color: var(--accent-cyan);"></i> Edit Account
                                    Parameters
                                </h3>
                                <button type="button" class="close-modal-btn"
                                    onclick="closeModal('editAccountModal')"><i class="bx bx-x"></i></button>
                            </div>
                            <div class="modal-body">
                                <div class="form-row row-2">
                                    <div class="form-group">
                                        <label>IFSC Code</label>
                                        <input type="text" name="ifscCode" id="editIfsc" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Ledger Status</label>
                                        <select name="status" id="editStatus">
                                            <option value="active">Active</option>
                                            <option value="frozen">Frozen</option>
                                            <option value="dormant">Dormant</option>
                                            <option value="closed">Closed</option>
                                        </select>
                                    </div>
                                </div>

                                <div
                                    style="margin: 25px 0; background: rgba(99, 102, 241, 0.02); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border);">
                                    <h4
                                        style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px;">
                                        <i class="bx bx-chip"></i> Enabled Services Options
                                    </h4>
                                    <div style="display:flex; gap:30px; flex-wrap:wrap;">
                                        <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                            <input type="checkbox" name="atmCard" id="editAtmCard" value="on"> ATM Debit
                                            Card
                                        </label>
                                        <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                            <input type="checkbox" name="chequeBook" id="editChequeBook" value="on">
                                            Cheque Book Request
                                        </label>
                                        <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                            <input type="checkbox" name="passbook" id="editPassbook" value="on"> Offline
                                            Passbook
                                        </label>
                                    </div>
                                </div>

                                <!-- Savings Specific Edit Controls -->
                                <div id="savingsEditFields" style="display:none;">
                                    <h4
                                        style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                        Savings Terms
                                    </h4>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Nominee Name</label>
                                            <input type="text" name="nomineeName" id="editNominee">
                                        </div>
                                        <div class="form-group">
                                            <label>Holding Mode</label>
                                            <select name="holdingType" id="editHoldingType"
                                                onchange="toggleEditHoldingType()">
                                                <option value="single">Single Owner</option>
                                                <option value="joint">Joint Account</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Daily Cash Limit (₹)</label>
                                            <input type="number" step="0.01" name="dailyWithdrawalLimit"
                                                id="editDailyLimit">
                                        </div>
                                    </div>

                                    <h4
                                        style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-top:20px; margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                        Primary Holder Personal Details
                                    </h4>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>First Name *</label>
                                            <input type="text" name="firstName" id="editFirstName">
                                        </div>
                                        <div class="form-group">
                                            <label>Middle Name</label>
                                            <input type="text" name="middleName" id="editMiddleName">
                                        </div>
                                        <div class="form-group">
                                            <label>Last Name *</label>
                                            <input type="text" name="lastName" id="editLastName">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Date of Birth *</label>
                                            <input type="date" name="dob" id="editDob">
                                        </div>
                                        <div class="form-group">
                                            <label>Gender *</label>
                                            <select name="gender" id="editGender">
                                                <option value="male">Male</option>
                                                <option value="female">Female</option>
                                                <option value="other">Other</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Marital Status</label>
                                            <select name="maritalStatus" id="editMarital">
                                                <option value="single">Single</option>
                                                <option value="married">Married</option>
                                                <option value="divorced">Divorced</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Email *</label>
                                            <input type="email" name="email" id="editEmail">
                                        </div>
                                        <div class="form-group">
                                            <label>Phone *</label>
                                            <input type="text" name="phone" id="editPhone">
                                        </div>
                                        <div class="form-group">
                                            <label>Annual Income (₹)</label>
                                            <input type="number" name="income" id="editIncome">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Occupation</label>
                                            <input type="text" name="occupation" id="editOcc">
                                        </div>
                                        <div class="form-group">
                                            <label>PAN Number *</label>
                                            <input type="text" name="pan" id="editPan">
                                        </div>
                                        <div class="form-group">
                                            <label>Aadhaar Card *</label>
                                            <input type="text" name="aadhaar" id="editAadhaar">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Father's Name *</label>
                                            <input type="text" name="fatherName" id="editFatherName">
                                        </div>
                                        <div class="form-group">
                                            <label>Mother's Name *</label>
                                            <input type="text" name="motherName" id="editMotherName">
                                        </div>
                                        <div class="form-group">
                                            <label>Nationality *</label>
                                            <input type="text" name="nationality" id="editNationality">
                                        </div>
                                    </div>
                                    <div class="form-row row-2">
                                        <div class="form-group">
                                            <label>Alternate Phone</label>
                                            <input type="text" name="altPhone" id="editAltPhone">
                                        </div>
                                        <div class="form-group">
                                            <label>Relationship Manager</label>
                                            <input type="text" name="relationshipManager" id="editRelationshipManager">
                                        </div>
                                    </div>
                                    <div class="form-row row-2">
                                        <div class="form-group">
                                            <label>Permanent Address *</label>
                                            <input type="text" name="permAddress" id="editPermAddress">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Address *</label>
                                            <input type="text" name="address" id="editAddress">
                                        </div>
                                        <div class="form-group">
                                            <label>City *</label>
                                            <input type="text" name="city" id="editCity">
                                        </div>
                                        <div class="form-group">
                                            <label>State *</label>
                                            <input type="text" name="state" id="editState">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Zip Code *</label>
                                            <input type="text" name="zip" id="editZip">
                                        </div>
                                    </div>

                                    <!-- Guardian Edit Fields -->
                                    <div id="guardianEditFields" style="display:none; margin-top:20px;">
                                        <h4
                                            style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(239, 68, 68, 0.08); padding-bottom:8px;">
                                            Registered Legal Guardian Details (Minor Applicants)
                                        </h4>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Guardian Name *</label>
                                                <input type="text" name="guardianName" id="editGuardianName">
                                            </div>
                                            <div class="form-group">
                                                <label>Relationship *</label>
                                                <select name="guardianRelationship" id="editGuardianRelationship">
                                                    <option value="father">Father</option>
                                                    <option value="mother">Mother</option>
                                                    <option value="legal_guardian">Legal Guardian</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Contact Phone *</label>
                                                <input type="text" name="guardianPhone" id="editGuardianPhone">
                                            </div>
                                        </div>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Guardian Aadhaar Card *</label>
                                                <input type="text" name="guardianAadhaar" id="editGuardianAadhaar">
                                            </div>
                                            <div class="form-group">
                                                <label>Guardian PAN Card *</label>
                                                <input type="text" name="guardianPan" id="editGuardianPan">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Student Edit Fields -->
                                    <div id="studentEditFields" style="display:none; margin-top:20px;">
                                        <h4
                                            style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                            Student Academic Profile
                                        </h4>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>School / College Name *</label>
                                                <input type="text" name="schoolCollegeName" id="editSchoolCollege">
                                            </div>
                                            <div class="form-group">
                                                <label>Student ID Number *</label>
                                                <input type="text" name="studentId" id="editStudentId">
                                            </div>
                                        </div>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Course / Specialization *</label>
                                                <input type="text" name="course" id="editCourse">
                                            </div>
                                            <div class="form-group">
                                                <label>Admission Roll Number</label>
                                                <input type="text" name="admissionNumber" id="editAdmissionNumber">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Salary Edit Fields -->
                                    <div id="salaryEditFields" style="display:none; margin-top:20px;">
                                        <h4
                                            style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                            Corporate Employment Profile
                                        </h4>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Employer Company *</label>
                                                <input type="text" name="companyName" id="editCompanyName">
                                            </div>
                                            <div class="form-group">
                                                <label>Employer Designation / HR *</label>
                                                <input type="text" name="employerName" id="editEmployerName">
                                            </div>
                                        </div>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Employee ID Code *</label>
                                                <input type="text" name="employeeId" id="editEmployeeId">
                                            </div>
                                            <div class="form-group">
                                                <label>Salary Credit Frequency *</label>
                                                <select name="salaryFrequency" id="editSalaryFrequency">
                                                    <option value="monthly">Monthly Salary Credit</option>
                                                    <option value="weekly">Weekly Payments</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Deposit Edit Fields -->
                                    <div id="depositEditFields" style="display:none; margin-top:20px;">
                                        <h4
                                            style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                            Term Deposit Investment Specifics
                                        </h4>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Tenure (Months) *</label>
                                                <input type="number" name="fdRdTenure" id="editFdRdTenure">
                                            </div>
                                            <div class="form-group">
                                                <label>Interest Rate (% p.a.) *</label>
                                                <input type="number" step="0.01" name="fdRdInterestRate"
                                                    id="editFdRdInterestRate">
                                            </div>
                                        </div>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Maturity Amount (₹) *</label>
                                                <input type="number" step="0.01" name="fdRdMaturityAmount"
                                                    id="editFdRdMaturityAmount">
                                            </div>
                                            <div class="form-group">
                                                <label>Maturity Date *</label>
                                                <input type="date" name="fdRdMaturityDate" id="editFdRdMaturityDate">
                                            </div>
                                        </div>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Interest Payout Option *</label>
                                                <select name="fdRdPayoutOption" id="editFdRdPayoutOption">
                                                    <option value="cumulative">Cumulative (Interest at Maturity)
                                                    </option>
                                                    <option value="monthly">Monthly Payout</option>
                                                    <option value="quarterly">Quarterly Payout</option>
                                                </select>
                                            </div>
                                            <div class="form-group" style="display:flex; align-items:center; gap:8px;">
                                                <label
                                                    style="cursor:pointer; display:flex; align-items:center; gap:6px; font-weight:700; color:var(--primary-600);">
                                                    <input type="checkbox" name="isPension" id="editIsPension"
                                                        value="on"> Pension Account status
                                                </label>
                                            </div>
                                        </div>
                                        <div style="display:flex; gap:30px; margin-top:15px; flex-wrap:wrap;">
                                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                                <input type="checkbox" name="fdAutoRenewal" id="editFdAutoRenewal"
                                                    value="on"> Auto-Renewal status
                                            </label>
                                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                                <input type="checkbox" name="rdAutoDebit" id="editRdAutoDebit"
                                                    value="on"> Auto-Debit status
                                            </label>
                                        </div>
                                    </div>

                                    <!-- Joint Holder Edit Fields -->
                                    <div id="jointCustomerEditFields" style="display:none; margin-top:20px;">
                                        <h4
                                            style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                            Joint Holder Personal Details
                                        </h4>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>First Name *</label>
                                                <input type="text" name="joint_firstName" id="editJointFirstName">
                                            </div>
                                            <div class="form-group">
                                                <label>Middle Name</label>
                                                <input type="text" name="joint_middleName" id="editJointMiddleName">
                                            </div>
                                            <div class="form-group">
                                                <label>Last Name *</label>
                                                <input type="text" name="joint_lastName" id="editJointLastName">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Date of Birth *</label>
                                                <input type="date" name="joint_dob" id="editJointDob">
                                            </div>
                                            <div class="form-group">
                                                <label>Gender *</label>
                                                <select name="joint_gender" id="editJointGender">
                                                    <option value="male">Male</option>
                                                    <option value="female">Female</option>
                                                    <option value="other">Other</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Marital Status</label>
                                                <select name="joint_maritalStatus" id="editJointMarital">
                                                    <option value="single">Single</option>
                                                    <option value="married">Married</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Email *</label>
                                                <input type="email" name="joint_email" id="editJointEmail">
                                            </div>
                                            <div class="form-group">
                                                <label>Phone *</label>
                                                <input type="text" name="joint_phone" id="editJointPhone">
                                            </div>
                                            <div class="form-group">
                                                <label>Annual Income (₹)</label>
                                                <input type="number" name="joint_income" id="editJointIncome">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Occupation</label>
                                                <input type="text" name="joint_occupation" id="editJointOcc">
                                            </div>
                                            <div class="form-group">
                                                <label>PAN Number *</label>
                                                <input type="text" name="joint_pan" id="editJointPan">
                                            </div>
                                            <div class="form-group">
                                                <label>Aadhaar Card *</label>
                                                <input type="text" name="joint_aadhaar" id="editJointAadhaar">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Father's Name *</label>
                                                <input type="text" name="joint_fatherName" id="editJointFatherName">
                                            </div>
                                            <div class="form-group">
                                                <label>Mother's Name *</label>
                                                <input type="text" name="joint_motherName" id="editJointMotherName">
                                            </div>
                                            <div class="form-group">
                                                <label>Nationality *</label>
                                                <input type="text" name="joint_nationality" id="editJointNationality">
                                            </div>
                                        </div>
                                        <div class="form-row row-2">
                                            <div class="form-group">
                                                <label>Alternate Phone</label>
                                                <input type="text" name="joint_altPhone" id="editJointAltPhone">
                                            </div>
                                            <div class="form-group">
                                                <label>Permanent Address *</label>
                                                <input type="text" name="joint_permAddress" id="editJointPermAddress">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Address *</label>
                                                <input type="text" name="joint_address" id="editJointAddress">
                                            </div>
                                            <div class="form-group">
                                                <label>City *</label>
                                                <input type="text" name="joint_city" id="editJointCity">
                                            </div>
                                            <div class="form-group">
                                                <label>State *</label>
                                                <input type="text" name="joint_state" id="editJointState">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Zip Code *</label>
                                                <input type="text" name="joint_zip" id="editJointZip">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Current Specific Edit Controls -->
                                <div id="currentEditFields" style="display:none;">
                                    <h4
                                        style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                        Corporate Registry Settings
                                    </h4>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Registered Trade Name</label>
                                            <input type="text" name="businessName" id="editBusinessName">
                                        </div>
                                        <div class="form-group">
                                            <label>GSTIN Identification</label>
                                            <input type="text" name="gstin" id="editGstin">
                                        </div>
                                        <div class="form-group">
                                            <label>Overdraft Line (₹)</label>
                                            <input type="number" step="0.01" name="overdraftLimit" id="editOverdraft">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Company Category</label>
                                            <input type="text" name="companyCategory" id="editCompanyCategory">
                                        </div>
                                        <div class="form-group">
                                            <label>Company PAN</label>
                                            <input type="text" name="companyPan" id="editCompanyPan">
                                        </div>
                                        <div class="form-group">
                                            <label>Company Aadhaar</label>
                                            <input type="text" name="companyAadhaar" id="editCompanyAadhaar">
                                        </div>
                                    </div>
                                    <div class="form-row row-3">
                                        <div class="form-group">
                                            <label>Company Phone</label>
                                            <input type="text" name="companyPhone" id="editCompanyPhone">
                                        </div>
                                        <div class="form-group">
                                            <label>Company Email</label>
                                            <input type="email" name="companyEmail" id="editCompanyEmail">
                                        </div>
                                        <div class="form-group">
                                            <label>Corporate Address</label>
                                            <input type="text" name="companyAddress" id="editCompanyAddress">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeModal('editAccountModal')">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ==========================================
         CLOSE ACCOUNT MODAL
         ========================================== -->
                <div class="modal" id="closeAccountModal">
                    <div class="modal-content" style="max-width: 600px;">
                        <div class="modal-header">
                            <h3 style="font-weight: 700; color: #b91c1c; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-error-alt" style="color: #ef4444;"></i> Close Account Confirmation
                            </h3>
                            <button type="button" class="close-modal-btn" onclick="closeModal('closeAccountModal')">
                                <i class="bx bx-x"></i>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div
                                style="background: rgba(239, 68, 68, 0.08); border-left: 4px solid #ef4444; color: #b91c1c; padding: 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.9rem;">
                                <h4 style="font-weight:700; margin-bottom:5px;"><i class="bx bx-error-circle"></i>
                                    Warning</h4>
                                <span>Are you sure you want to close this account? This will mark the ledger status as
                                    closed and restrict future operations. This action cannot be undone.</span>
                            </div>

                            <table style="width:100%; font-size:0.9rem; line-height:2.0; border-collapse:collapse;">
                                <tr>
                                    <td style="color:var(--gray-500); width:40%; padding: 8px 0;">Account Number:</td>
                                    <td style="font-weight:700; font-family:monospace; color:var(--gray-800);"
                                        id="closeAccNum">-</td>
                                </tr>
                                <tr>
                                    <td style="color:var(--gray-500); padding: 8px 0;">Account Type:</td>
                                    <td style="font-weight:700; text-transform:uppercase;" id="closeAccType">-</td>
                                </tr>
                                <tr>
                                    <td style="color:var(--gray-500); padding: 8px 0;">Primary Holder Name:</td>
                                    <td style="font-weight:700; color:var(--gray-800);" id="closeHolderName">-</td>
                                </tr>
                                <tr>
                                    <td style="color:var(--gray-500); padding: 8px 0;">Current Ledger Balance:</td>
                                    <td style="font-weight:800; color:#ef4444; font-size:1.1rem;" id="closeBalance">-
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color:var(--gray-500); padding: 8px 0;">Current Ledger Status:</td>
                                    <td style="font-weight:700; text-transform:uppercase;" id="closeStatus">-</td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                onclick="closeModal('closeAccountModal')">Cancel</button>
                            <button type="button" class="btn btn-danger" onclick="confirmCloseAccount()">Confirm Close
                                Account</button>
                        </div>
                    </div>
                </div>

                <!-- ==========================================
         CREATE NEW ACCOUNT WIZARD MODAL
         ========================================== -->
                <div class="modal" id="createAccountModal">
                    <div class="modal-content wizard-modal-content">
                        <style>
                            /* Premium Glassmorphic Wizard Styling */
                            .wizard-modal-content {
                                max-width: 950px !important;
                                background: #ffffff !important;
                                border-radius: 16px !important;
                                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04) !important;
                                overflow: hidden;
                            }

                            .wizard-header {
                                padding: 20px 30px;
                                background: linear-gradient(135deg, var(--primary-600), #4f46e5);
                                color: white;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            .wizard-body {
                                padding: 30px;
                                max-height: 70vh;
                                overflow-y: auto;
                            }

                            .wizard-footer {
                                padding: 20px 30px;
                                background: var(--gray-50);
                                border-top: 1px solid var(--gray-100);
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            /* Stepper Styling */
                            .stepper-wrapper {
                                display: flex;
                                justify-content: space-between;
                                margin-bottom: 30px;
                                position: relative;
                                padding-bottom: 10px;
                            }

                            .stepper-line-back {
                                position: absolute;
                                top: 20px;
                                left: 40px;
                                right: 40px;
                                height: 4px;
                                background: var(--gray-200);
                                z-index: 1;
                            }

                            .stepper-line-front {
                                position: absolute;
                                top: 20px;
                                left: 40px;
                                height: 4px;
                                background: var(--primary-500);
                                z-index: 2;
                                width: 0%;
                                transition: width 0.3s ease;
                            }

                            .step-item {
                                position: relative;
                                z-index: 3;
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                flex: 1;
                            }

                            .step-number {
                                width: 40px;
                                height: 40px;
                                border-radius: 50%;
                                background: white;
                                border: 3px solid var(--gray-300);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: 700;
                                color: var(--gray-500);
                                transition: all 0.3s ease;
                                font-size: 0.9rem;
                            }

                            .step-item.active .step-number {
                                border-color: var(--primary-500);
                                background: var(--primary-500);
                                color: white;
                                box-shadow: 0 0 10px rgba(99, 102, 241, 0.3);
                            }

                            .step-item.completed .step-number {
                                border-color: #10b981;
                                background: #10b981;
                                color: white;
                            }

                            .step-title {
                                font-size: 0.65rem;
                                font-weight: 700;
                                color: var(--gray-500);
                                margin-top: 8px;
                                text-transform: uppercase;
                                letter-spacing: 0.5px;
                            }

                            .step-item.active .step-title {
                                color: var(--primary-600);
                            }

                            .step-item.completed .step-title {
                                color: #10b981;
                            }

                            .wizard-step-pane {
                                display: block;
                                margin-bottom: 20px;
                            }

                            .card-badge {
                                display: inline-block;
                                padding: 4px 10px;
                                border-radius: 20px;
                                font-size: 0.72rem;
                                font-weight: 700;
                                text-transform: uppercase;
                                margin-left: 10px;
                            }

                            .badge-minor {
                                background: #fee2e2;
                                color: #b91c1c;
                            }

                            .badge-adult {
                                background: #d1fae5;
                                color: #065f46;
                            }

                            .badge-senior {
                                background: #fef3c7;
                                color: #b45309;
                            }

                            .preview-box {
                                width: 100px;
                                height: 100px;
                                border: 2px dashed var(--gray-300);
                                border-radius: 8px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                overflow: hidden;
                                margin-top: 8px;
                                background: var(--gray-50);
                                position: relative;
                            }

                            .preview-box img {
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                            }

                            .preview-box span {
                                font-size: 0.65rem;
                                color: var(--gray-400);
                                text-align: center;
                                padding: 5px;
                            }

                            .validation-msg {
                                font-size: 0.72rem;
                                color: #ef4444;
                                margin-top: 4px;
                                font-weight: 600;
                                display: none;
                            }
                        </style>

                        <form
                            action="${pageContext.request.contextPath}/account?action=create&csrfToken=${sessionScope.csrfToken}"
                            method="POST" id="createAccountForm" enctype="multipart/form-data"
                            onsubmit="return validateA4FormSubmit()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                            <!-- Header -->
                            <div class="wizard-header">
                                <h3
                                    style="margin:0; font-weight:800; font-size:1.25rem; display:flex; align-items:center; gap:10px;">
                                    <i class="bx bx-plus-circle"></i> Open New Ledger Account
                                </h3>
                                <button type="button" onclick="closeModal('createAccountModal')"
                                    style="background:none; border:none; color:white; font-size:1.5rem; cursor:pointer;"><i
                                        class="bx bx-x"></i></button>
                            </div>

                            <!-- Wizard Body Content -->
                            <div class="wizard-body" style="padding: 20px 30px;">

                                <!-- STEP 1: ACCOUNT TYPE SELECTION -->
                                <div class="wizard-step-pane" id="wizardStepPane1">
                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-cog"></i> Section A – Account
                                            Setup & Type</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Account Type *</label>
                                                <select name="accountType" id="a4AccountType"
                                                    onchange="handleAccountTypeChange()" required>
                                                    <option value="savings">Savings Account (4.00% p.a.)</option>
                                                    <option value="current">Current Account (0.00% p.a.)</option>
                                                    <option value="salary">Salary Account (3.50% p.a.)</option>
                                                    <option value="student">Student Account (3.50% p.a.)</option>
                                                    <option value="fd">Fixed Deposit (FD)</option>
                                                    <option value="rd">Recurring Deposit (RD)</option>
                                                </select>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Holding / Ownership Type *</label>
                                                <select name="holdingType" id="a4HoldingType"
                                                    onchange="handleHoldingTypeChange()" required>
                                                    <option value="single">Individual (Single)</option>
                                                    <option value="joint">Joint Account Holder</option>
                                                </select>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Initial Opening Deposit Amount (₹) *</label>
                                                <input type="number" step="0.01" name="initialAmount"
                                                    id="a4InitialAmount" value="1000.00" onkeyup="calculateMaturity();">
                                                <small style="color: var(--primary-500); font-weight:700;"
                                                    id="a4MinDepositNote"></small>
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Home Branch</label>
                                                <input type="text" name="branch" value="Rajkot Corporate Branch"
                                                    readonly style="background:#f1f5f9;">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Branch IFSC</label>
                                                <input type="text" name="ifscCode" value="VGB0000171" readonly
                                                    style="background:#f1f5f9;">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Ledger Currency</label>
                                                <input type="text" name="currency" value="INR (₹)" readonly
                                                    style="background:#f1f5f9;">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- STEP 2: PERSONAL DETAILS -->
                                <div class="wizard-step-pane" id="wizardStepPane2">
                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-user"></i> Section B – Applicant
                                            Personal Profile</div>
                                        <div style="display:flex; gap:20px; align-items:flex-start;"
                                            class="mobile-grid-1">
                                            <div style="flex-grow:1;">
                                                <div class="a4-form-row">
                                                    <div class="a4-form-group">
                                                        <label>First Name *</label>
                                                        <input type="text" name="firstName" id="a4First" required>
                                                    </div>
                                                    <div class="a4-form-group">
                                                        <label>Middle Name</label>
                                                        <input type="text" name="middleName" id="a4Middle">
                                                    </div>
                                                    <div class="a4-form-group">
                                                        <label>Last Name *</label>
                                                        <input type="text" name="lastName" id="a4Last" required>
                                                    </div>
                                                </div>
                                                <div class="a4-form-row">
                                                    <div class="a4-form-group">
                                                        <label>Father's Name *</label>
                                                        <input type="text" name="fatherName" id="a4Father" required>
                                                    </div>
                                                    <div class="a4-form-group">
                                                        <label>Mother's Name *</label>
                                                        <input type="text" name="motherName" id="a4Mother" required>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="avatar-preview-container no-print"
                                                style="position: relative; width: 120px; height: 120px; flex-shrink: 0; margin-top: 10px;">
                                                <div class="preview-box" id="avatarPreviewBox"
                                                    style="width: 100%; height: 100%; border-radius: 50%; border: 4px solid var(--white); box-shadow: 0 4px 15px rgba(0,0,0,0.12); display: flex; align-items: center; justify-content: center; overflow: hidden; background: #e2e8f0; color: #64748b; transition: all 0.3s ease;">
                                                    <i class="bx bx-user"
                                                        style="font-size: 3.5rem; color: #94a3b8;"></i>
                                                </div>
                                                <label
                                                    style="position: absolute; bottom: 0; right: 0; width: 38px; height: 38px; background: #6366f1; color: var(--white); border-radius: 50%; border: 3px solid var(--white); display: flex; align-items: center; justify-content: center; cursor: pointer; box-shadow: 0 3px 8px rgba(99,102,241,0.4); transition: transform 0.2s;"
                                                    onmouseover="this.style.transform='scale(1.1)'"
                                                    onmouseout="this.style.transform='scale(1)'"
                                                    title="Click to upload photo">
                                                    <i class="bx bx-camera" style="font-size: 1.15rem;"></i>
                                                    <input type="file" name="primaryAvatar" id="primaryAvatarFile"
                                                        accept="image/*" style="display:none;"
                                                        onchange="previewPhoto(this, 'avatarPreviewBox')">
                                                </label>
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Date of Birth * <span id="ageClassificationBadge"></span></label>
                                                <input type="date" name="dob" id="a4Dob" required
                                                    onchange="handleDobChange(); calculateMaturity();">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Gender *</label>
                                                <select name="gender" id="a4Gender" required>
                                                    <option value="male">Male</option>
                                                    <option value="female">Female</option>
                                                    <option value="other">Other</option>
                                                </select>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Marital Status</label>
                                                <select name="maritalStatus" id="a4Marital">
                                                    <option value="single">Single</option>
                                                    <option value="married">Married</option>
                                                    <option value="divorced">Divorced</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Nationality *</label>
                                                <input type="text" name="nationality" id="a4Nationality" value="Indian"
                                                    required>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Occupation *</label>
                                                <input type="text" name="occupation" id="a4Occupation"
                                                    placeholder="e.g. Student, Self-Employed" required>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Annual Income (₹) *</label>
                                                <input type="number" name="income" id="a4Income" value="300000"
                                                    required>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- STEP 3: CONTACTS & ADDRESSES -->
                                <div class="wizard-step-pane" id="wizardStepPane3">
                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-map-pin"></i> Section C – Address
                                            & Contact Profile</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Mobile Number * (10 digits)</label>
                                                <input type="tel" name="phone" id="a4Phone" required
                                                    onkeyup="validateMobile(this)">
                                                <div class="validation-msg" id="phoneError">Mobile number must be
                                                    exactly 10 digits.</div>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Alternate Phone</label>
                                                <input type="tel" name="altPhone" id="a4AltPhone">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Email Address *</label>
                                                <input type="email" name="email" id="a4Email" required
                                                    onkeyup="validateEmail(this)">
                                                <div class="validation-msg" id="emailError">Please enter a valid email.
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Current Address -->
                                        <div
                                            style="background:#f8fafc; padding:15px; border-radius:8px; border:1px solid #e2e8f0; margin-bottom:20px;">
                                            <h5
                                                style="font-size:0.85rem; font-weight:700; color:#334155; margin-bottom:12px;">
                                                Current Residential Address</h5>
                                            <div class="a4-form-row">
                                                <div class="a4-form-group" style="grid-column:span 2;">
                                                    <label>Address *</label>
                                                    <input type="text" name="address" id="a4Address" required>
                                                </div>
                                                <div class="a4-form-group">
                                                    <label>City *</label>
                                                    <input type="text" name="city" id="a4City" required>
                                                </div>
                                            </div>
                                            <div class="a4-form-row">
                                                <div class="a4-form-group">
                                                    <label>State *</label>
                                                    <input type="text" name="state" id="a4State" required>
                                                </div>
                                                <div class="a4-form-group">
                                                    <label>PIN Code *</label>
                                                    <input type="text" name="zip" id="a4Zip" required>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Permanent Address checkbox -->
                                        <div style="margin-bottom:15px;">
                                            <label
                                                style="display:flex; align-items:center; gap:8px; font-weight:600; cursor:pointer;">
                                                <input type="checkbox" id="syncAddressCheck"
                                                    onchange="syncPermanentAddress(this.checked)"> Permanent Address
                                                same as Current Address
                                            </label>
                                        </div>
                                    </div>
                                    <!-- STEP 4: WORKFLOW DETAILS (DYNAMIC CONTEXT) -->
                                    <!-- MINOR ACCOUNT WORKFLOW -->
                                    <div class="a4-section-card" id="minorWorkflowSection" style="display:none;">
                                        <div class="a4-section-title"><i class="bx bx-shield-quarter"></i> Section D1 –
                                            Parent / Guardian Details (Minor Account)</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Guardian Name *</label>
                                                <input type="text" name="guardianName" id="a4GuardianName">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Relationship *</label>
                                                <select name="guardianRelationship" id="a4GuardianRelationship">
                                                    <option value="father">Father</option>
                                                    <option value="mother">Mother</option>
                                                    <option value="legal_guardian">Legal Guardian</option>
                                                </select>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Guardian Mobile Number *</label>
                                                <input type="tel" name="guardianPhone" id="a4GuardianPhone">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Guardian Aadhaar Card (12 digits) *</label>
                                                <input type="text" name="guardianAadhaar" id="a4GuardianAadhaar">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Guardian PAN Card *</label>
                                                <input type="text" name="guardianPan" id="a4GuardianPan">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Guardian Signature Copy *</label>
                                                <input type="file" name="guardianSignatureCopy"
                                                    accept="image/*,application/pdf">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Minor Birth Certificate *</label>
                                                <input type="file" name="birthCertificateCopy"
                                                    accept="image/*,application/pdf">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- STUDENT ACCOUNT FIELDS -->
                                    <div class="a4-section-card" id="studentWorkflowSection" style="display:none;">
                                        <div class="a4-section-title"><i class="bx bx-book-open"></i> Section D2 –
                                            Educational Information (Student Account)</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>School / College Name *</label>
                                                <input type="text" name="schoolCollegeName" id="a4SchoolCollege">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Student ID Number *</label>
                                                <input type="text" name="studentId" id="a4StudentId">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Course / Stream *</label>
                                                <input type="text" name="course" id="a4Course"
                                                    placeholder="e.g. B.Tech, Class XII">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Admission / Roll Number</label>
                                                <input type="text" name="admissionNumber" id="a4AdmissionNumber">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Student Identity Card Upload *</label>
                                                <input type="file" name="studentIdCopy"
                                                    accept="image/*,application/pdf">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>School/College Bonafide Certificate *</label>
                                                <input type="file" name="bonafideCopy" accept="image/*,application/pdf">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- CORPORATE CURRENT ACCOUNT FIELDS -->
                                    <div class="a4-section-card" id="corporateWorkflowSection" style="display:none;">
                                        <div class="a4-section-title"><i class="bx bx-briefcase"></i> Section D3 –
                                            Corporate Registry Settings</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Registered Trade Name *</label>
                                                <input type="text" name="businessName" id="a4BusName">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>GSTIN ID Number *</label>
                                                <input type="text" name="gstin" id="a4BusGst">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Business Category *</label>
                                                <select name="companyCategory" id="a4BusCategory">
                                                    <option value="sole_proprietor">Sole Proprietor</option>
                                                    <option value="partnership">Partnership Firm</option>
                                                    <option value="private_limited">Private Limited</option>
                                                    <option value="public_limited">Public Limited</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Business Phone *</label>
                                                <input type="tel" name="companyPhone" id="a4BusPhone">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Business Email *</label>
                                                <input type="email" name="companyEmail" id="a4BusEmail">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Business Registration / PAN *</label>
                                                <input type="text" name="companyPan" id="a4BusRegNo">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group" style="grid-column: span 2;">
                                                <label>Business Head Office Address *</label>
                                                <input type="text" name="companyAddress" id="a4BusAddress">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Company Aadhaar ID</label>
                                                <input type="text" name="companyAadhaar" id="a4BusAadhaar">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>GST Registration Certificate *</label>
                                                <input type="file" name="gstCertCopy" accept="image/*,application/pdf">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Business Registration Document *</label>
                                                <input type="file" name="businessRegCopy"
                                                    accept="image/*,application/pdf">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Business Address/Establishment Proof *</label>
                                                <input type="file" name="businessProofCopy"
                                                    accept="image/*,application/pdf">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- SALARY ACCOUNT FIELDS -->
                                    <div class="a4-section-card" id="salaryWorkflowSection" style="display:none;">
                                        <div class="a4-section-title"><i class="bx bx-wallet-alt"></i> Section D4 –
                                            Employer & Corporate Salary Agreement</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Company / Organization Name *</label>
                                                <input type="text" name="companyName" id="a4SalaryCompany">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Employer Name / HR Manager *</label>
                                                <input type="text" name="employerName" id="a4SalaryEmployer">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Employee ID Number *</label>
                                                <input type="text" name="employeeId" id="a4SalaryEmpId">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Salary Credit Frequency *</label>
                                                <select name="salaryFrequency" id="a4SalaryFreq">
                                                    <option value="monthly">Monthly Salary Credit</option>
                                                    <option value="weekly">Weekly Payments</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- FIXED DEPOSIT & RECURRING DEPOSIT CALCULATOR -->
                                    <div class="a4-section-card" id="termDepositWorkflowSection" style="display:none;">
                                        <div class="a4-section-title"><i class="bx bx-calculator"></i> Section D5 – Term
                                            Deposit Plan & Live Calculator</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Investment Tenure (Months) *</label>
                                                <select id="termTenureSelect" onchange="calculateMaturity()">
                                                    <option value="12">12 Months (1 Year)</option>
                                                    <option value="24">24 Months (2 Years)</option>
                                                    <option value="36">36 Months (3 Years)</option>
                                                    <option value="60">60 Months (5 Years)</option>
                                                    <option value="120">120 Months (10 Years)</option>
                                                </select>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Interest Rate (% p.a.)</label>
                                                <input type="text" id="termInterestRate" readonly
                                                    style="background:#f1f5f9; font-weight:700; color:var(--primary-700);">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Maturity Date</label>
                                                <input type="text" id="termMaturityDate" readonly
                                                    style="background:#f1f5f9; font-weight:700;">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Estimated Maturity Amount (₹)</label>
                                                <input type="text" id="termMaturityAmount" readonly
                                                    style="background:#f1f5f9; font-weight:800; color:#10b981; font-size:1.05rem;">
                                            </div>
                                            <div class="a4-form-group" id="fdPayoutField">
                                                <label>Interest Payout Option *</label>
                                                <select name="fdPayoutOption" id="a4FdPayoutOption">
                                                    <option value="cumulative">Cumulative (Interest at Maturity)
                                                    </option>
                                                    <option value="monthly">Monthly Payout</option>
                                                    <option value="quarterly">Quarterly Payout</option>
                                                </select>
                                            </div>
                                            <div class="a4-form-group" id="fdRenewalCheckbox"
                                                style="display:flex; align-items:center; gap:8px;">
                                                <label
                                                    style="cursor:pointer; display:flex; align-items:center; gap:6px;">
                                                    <input type="checkbox" name="fdAutoRenewal"> Auto-Renewal on
                                                    Maturity
                                                </label>
                                            </div>
                                            <div class="a4-form-group" id="rdDebitCheckbox"
                                                style="display:flex; align-items:center; gap:8px;">
                                                <label
                                                    style="cursor:pointer; display:flex; align-items:center; gap:6px;">
                                                    <input type="checkbox" name="rdAutoDebit" checked> Enable Auto-Debit
                                                    from Primary Savings
                                                </label>
                                            </div>
                                        </div>

                                        <!-- Hidden inputs to submit compiled variables -->
                                        <input type="hidden" name="fdRdTenureMonths" id="hiddenFdRdTenureMonths">
                                        <input type="hidden" name="fdRdInterestRate" id="hiddenFdRdInterestRate">
                                        <input type="hidden" name="fdRdMaturityAmount" id="hiddenFdRdMaturityAmount">
                                        <input type="hidden" name="fdRdMaturityDate" id="hiddenFdRdMaturityDate">
                                    </div>

                                    <!-- SENIOR CITIZEN BENEFITS -->
                                    <div class="a4-section-card" id="seniorWorkflowSection" style="display:none;">
                                        <div class="a4-section-title"><i class="bx bx-shield-plus"></i> Section D6 –
                                            Senior Citizen Perks & Ledger</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Dedicated Relationship Manager</label>
                                                <input type="text" name="relationshipManager" id="a4RelationshipManager"
                                                    value="Rajesh Mehta - Senior RM" readonly
                                                    style="background:#f1f5f9;">
                                            </div>
                                            <div class="a4-form-group"
                                                style="display:flex; align-items:center; gap:8px;">
                                                <label
                                                    style="cursor:pointer; display:flex; align-items:center; gap:6px; font-weight:700; color:var(--primary-600);">
                                                    <input type="checkbox" name="isPension" value="true"> Pension
                                                    Account Ledger Option
                                                </label>
                                            </div>
                                        </div>
                                        <div
                                            style="background:#fffbeb; border:1px solid #fef3c7; padding:12px; border-radius:6px; color:#b45309; font-size:0.75rem;">
                                            <strong>Senior Citizen Perks Enabled:</strong> Higher interest rates on
                                            Savings (+0.50% p.a.) and Term Deposits (+0.75% p.a.), priority teller
                                            lines, and zero locker fee for the first year.
                                        </div>
                                    </div>

                                    <!-- STANDARD NOMINEE DETAILS -->
                                    <div class="a4-section-card" id="a4NomineeSection">
                                        <div class="a4-section-title"><i class="bx bx-heart"></i> Section D7 – Nominee
                                            Details</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Nominee Name *</label>
                                                <input type="text" name="nomineeName" id="a4NomineeName"
                                                    value="No Nominee" required>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Relationship *</label>
                                                <input type="text" name="nomineeRel" id="a4NomineeRel" value="Spouse">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Nominee DOB *</label>
                                                <input type="date" name="nomineeDob" id="a4NomineeDob"
                                                    value="2000-01-01">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Nominee Mobile *</label>
                                                <input type="tel" name="nomineePhone" id="a4NomineePhone"
                                                    value="0000000000">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Nominee Aadhaar</label>
                                                <input type="text" name="nomineeAadh" id="a4NomineeAadh"
                                                    value="000000000000">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Nominee Address *</label>
                                                <input type="text" name="nomineeAddr" id="a4NomineeAddr"
                                                    value="Same as customer address">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- STEP 5: INSTRUMENTS & KYC UPLOADS -->
                                <div class="wizard-step-pane" id="wizardStepPane5">
                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-chip"></i> Section E1 – Requested
                                            Services & Card Type</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group"
                                                style="display:flex; flex-direction:column; gap:8px;">
                                                <label style="cursor:pointer; font-weight:700;"><input type="checkbox"
                                                        name="atmCard" id="a4AtmCheck"
                                                        onchange="toggleAtmCardSelection(this.checked)"> ATM / Debit
                                                    Card Requested</label>
                                                <div id="cardProviderSelection"
                                                    style="display:none; margin-left:20px; margin-top:5px;">
                                                    <label>Select Card Network: </label>
                                                    <select name="cardProvider" id="a4CardProvider">
                                                        <option value="visa">Visa Debit Card</option>
                                                        <option value="mastercard">Mastercard Debit Card</option>
                                                        <option value="rupay">RuPay Domestic Card</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="a4-form-group" style="display:flex; align-items:center;">
                                                <label style="cursor:pointer; font-weight:700;"><input type="checkbox"
                                                        name="chequeBook" id="a4ChequeCheck"> Cheque Book
                                                    Requested</label>
                                            </div>
                                            <div class="a4-form-group" style="display:flex; align-items:center;">
                                                <label style="cursor:pointer; font-weight:700;"><input type="checkbox"
                                                        name="passbook" id="a4PassbookCheck" checked> Passbook Booklet
                                                    Requested</label>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-cloud-upload"></i> Section E2 –
                                            KYC Documentation Proofs Upload</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Aadhaar Card Copy (Front & Back) *</label>
                                                <input type="file" name="aadhaarCopy" id="aadhaarCopyInput"
                                                    accept="image/*,application/pdf" required>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>PAN Card Copy *</label>
                                                <input type="file" name="panCopy" id="panCopyInput"
                                                    accept="image/*,application/pdf" required>
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Passport Copy (Optional)</label>
                                                <input type="file" name="passportCopy" accept="image/*,application/pdf">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Driving License Copy (Optional)</label>
                                                <input type="file" name="dlCopy" accept="image/*,application/pdf">
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Voter ID Copy (Optional)</label>
                                                <input type="file" name="voterIdCopy" accept="image/*,application/pdf">
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Applicant Signature Copy *</label>
                                                <input type="file" name="signatureCopy" id="signatureCopyInput"
                                                    accept="image/*">
                                                <div class="validation-msg" id="signatureError"
                                                    style="display:none; color: #ef4444; font-size: 0.75rem; margin-top: 4px;">
                                                    Please upload a signature copy before submitting.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- STEP 6: LOGIN CREDENTIALS SETUP -->
                                <div class="wizard-step-pane" id="wizardStepPane6">
                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-key"></i> Section F – Access
                                            Credentials Configuration</div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Portal Login Username * (Min 4 chars)</label>
                                                <input type="text" name="username" id="a4Username" required>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Transaction Secure PIN * (Exactly 4 digits)</label>
                                                <div style="position: relative;">
                                                    <input type="password" name="pin" id="a4Pin" maxlength="4"
                                                        placeholder="e.g. 1729" required
                                                        onkeyup="validatePinStrength(this)"
                                                        style="padding-right: 40px; width: 100%;">
                                                    <i class="bx bx-show toggle-eye"
                                                        onclick="togglePassword('a4Pin', this)"
                                                        style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.2s;"></i>
                                                </div>
                                                <div class="validation-msg" id="pinError">PIN must be exactly 4 digits.
                                                </div>
                                            </div>
                                        </div>
                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Portal Access Password * (Min 8 chars, 1 Upper, 1 Lower, 1 Num, 1
                                                    Spec)</label>
                                                <div style="position: relative;">
                                                    <input type="password" name="password" id="a4Password" required
                                                        onkeyup="validatePasswordStrength(this)"
                                                        style="padding-right: 40px; width: 100%;">
                                                    <i class="bx bx-show toggle-eye"
                                                        onclick="togglePassword('a4Password', this)"
                                                        style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.2s;"></i>
                                                </div>
                                                <div class="validation-msg" id="passwordError">Password is weak. Make
                                                    sure it meets all criteria.</div>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Confirm Portal Password *</label>
                                                <div style="position: relative;">
                                                    <input type="password" name="confirmPassword" id="a4ConfirmPassword"
                                                        required style="padding-right: 40px; width: 100%;">
                                                    <i class="bx bx-show toggle-eye"
                                                        onclick="togglePassword('a4ConfirmPassword', this)"
                                                        style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.2s;"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- SECTION G: DECLARATION & SUBMISSION -->
                                <div class="wizard-step-pane" id="wizardStepPane7">
                                    <div class="a4-section-card">
                                        <div class="a4-section-title"><i class="bx bx-badge-check"></i> Section G –
                                            Submission Declaration</div>

                                        <p
                                            style="font-size:0.75rem; color:var(--gray-500); text-align:justify; margin-bottom:20px;">
                                            I/We hereby declare that all details, certificates, and address validations
                                            provided above are true, complete, and correct to the best of my/our
                                            knowledge. I/We understand and agree that any false, misleading, or
                                            incorrect statement will result in the immediate closure of this bank ledger
                                            account. I/We declare that I/we have read, understood, and agreed to be
                                            bound by the Terms and Conditions of Vertex Galaxy Bank.
                                        </p>

                                        <div class="a4-form-row">
                                            <div class="a4-form-group">
                                                <label>Application Declaration Place *</label>
                                                <input type="text" name="place" id="a4Place" value="Rajkot" required>
                                            </div>
                                            <div class="a4-form-group">
                                                <label>Declaration / Submission Date *</label>
                                                <input type="date" name="applicationDate" id="a4AppDate" required
                                                    readonly style="background:#f1f5f9;">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!-- Wizard Navigation Footer -->
                            <div class="wizard-footer">
                                <div>
                                    <button type="button" class="btn btn-secondary no-print"
                                        onclick="saveA4FormDraft()"><i class="bx bx-save"></i> Save Draft</button>
                                    <button type="button" class="btn btn-warning no-print" onclick="resetA4Form()"><i
                                            class="bx bx-refresh"></i> Reset</button>
                                </div>
                                <div style="display:flex; gap:10px;">
                                    <button type="submit" class="btn btn-success no-print" id="btnSubmitForm"
                                        style="background:#10b981; border:none; color:white; display:inline-block;"><i
                                            class="bx bx-check-circle"></i> Submit Application</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ==========================================
         ACCOUNT STATEMENT LEDGER MODAL
         ========================================== -->
                <div class="modal" id="statementModal">
                    <div class="modal-content modal-large">
                        <div class="modal-header no-print"
                            style="padding: 20px 30px; border-bottom: 1px solid var(--gray-100);">
                            <h3
                                style="font-size: 1.4rem; font-weight: 800; color: var(--gray-900); display: flex; align-items: center; gap: 10px; margin: 0;">
                                <i class="bx bx-file" style="color: var(--primary-500);"></i> Vertex Galaxy Bank Account
                                Statement
                            </h3>
                            <button type="button" class="close-modal-btn" onclick="closeModal('statementModal')"
                                style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none;"><i
                                    class="bx bx-x"></i></button>
                        </div>
                        <div class="modal-body" style="padding: 30px;">
                            <!-- FILTERS BLOCK -->
                            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom:25px;"
                                class="no-print">
                                <div>
                                    <label
                                        style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Date
                                        Filter Range</label>
                                    <select id="stmtDateFilter" onchange="runStatementFilter()"
                                        style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                                        <option value="all">All Available ledger</option>
                                        <option value="current_month">Current Month</option>
                                        <option value="last_month">Last Month</option>
                                        <option value="year">Current Financial Year</option>
                                        <option value="custom">Custom Date Range...</option>
                                    </select>
                                </div>
                                <div>
                                    <label
                                        style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Transaction
                                        Type</label>
                                    <select id="stmtTypeFilter" onchange="runStatementFilter()"
                                        style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                                        <option value="all">All Transactions</option>
                                        <option value="received">Received / Credits</option>
                                        <option value="paid">Paid / Debits</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Custom Dates group -->
                            <div id="stmtCustomDateGroup"
                                style="display:none; border-top:1px dashed var(--gray-200); padding-top:15px;"
                                class="no-print">
                                <div
                                    style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:20px;">
                                    <div>
                                        <label
                                            style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Start
                                            Date</label>
                                        <input type="date" id="stmtStartDate" onchange="runStatementFilter()"
                                            style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                                    </div>
                                    <div>
                                        <label
                                            style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">End
                                            Date</label>
                                        <input type="date" id="stmtEndDate" onchange="runStatementFilter()"
                                            style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                                    </div>
                                </div>
                            </div>

                            <div class="statement-print-area">
                                <!-- Print Background Image (Always visible in print layout) -->
                                <div class="print-bg-container">
                                    <img src="${pageContext.request.contextPath}/assest/images/All Forms/Letter Pad.png" class="print-bg-img" alt="VGB Letterhead">
                                </div>
                                <!-- Official Bank Logo & Name -->
                                <div
                                    style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 15px; margin-bottom: 25px;">
                                    <div class="print-hide-header">
                                        <h1
                                            style="font-size: 1.8rem; font-weight: 800; color: var(--primary-500); letter-spacing: 1px; line-height: 1;">
                                            VERTEX GALAXY BANK</h1>
                                        <p
                                            style="font-size: 0.8rem; color: var(--gray-500); margin-top: 5px; font-weight: 500;">
                                            Secure Credit &amp; Lending Divisions</p>
                                    </div>
                                    <div style="text-align: right;">
                                        <span
                                            style="font-family: monospace; font-size: 0.85rem; color: var(--gray-500); font-weight: 700;"
                                            id="lblStmtRef">ACC-REF: -</span>
                                        <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 3px;">Date
                                            Generated: <span id="lblStmtDateGenerated">-</span></p>
                                    </div>
                                </div>

                                <!-- Official Header Subtitle (shown in both screen and print) -->
                                <div
                                    style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                                    <span
                                        style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official
                                        Account Transaction Ledger Statement</span>
                                </div>

                                <!-- Details Grid -->
                                <div class="statement-meta-grid"
                                    style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);">
                                    <!-- Left: Bank Information -->
                                    <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                                        <span
                                            style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank
                                            Details</span>
                                        <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate
                                            HQ)</strong>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers, BKC
                                            Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code: <strong
                                                style="font-family: monospace;">VGBK0000001</strong></p>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free:
                                            1800-VGB-BANK</p>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal:
                                            www.vertexgalaxybank.com</p>
                                    </div>

                                    <!-- Right: Customer & Account Details -->
                                    <div>
                                        <span
                                            style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer
                                            &amp; Account Details</span>
                                        <strong
                                            style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;"
                                            id="lblStmtName">-</strong>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong
                                                style="font-family: monospace;" id="lblStmtCustId">-</strong></p>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address: <strong
                                                style="color: var(--gray-800); font-weight: 600;"
                                                id="lblStmtAddress">-</strong></p>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">Account Reference: <strong
                                                style="font-family: monospace;" id="lblStmtAccNum">-</strong> (<span
                                                id="lblStmtAccType"
                                                style="text-transform: uppercase; font-weight: 600;">-</span> Account)
                                        </p>
                                        <p style="margin: 4px 0 0; color: var(--gray-600);">Total Balance: <strong
                                                style="color: var(--primary-500); font-size: 1.05rem;"
                                                id="lblStmtBalance">-</strong></p>
                                    </div>
                                </div>

                                <!-- Ledger Section Header -->
                                <div
                                    style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                                    <h4
                                        style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                                        <i class="bx bx-history" style="color: var(--primary-500);"></i> Transaction
                                        Ledger Log
                                    </h4>
                                    <button type="button" onclick="window.print()" class="btn btn-primary no-print"
                                        style="display: inline-flex; align-items: center; gap: 6px;">
                                        <span>Print Document</span>
                                        <i class="bx bx-printer"></i>
                                    </button>
                                </div>

                                <!-- Table Responsive Wrapper -->
                                <div
                                    style="overflow-x: auto; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); box-shadow: var(--shadow-sm); margin-bottom: 25px;">
                                    <table id="statementTxnTable"
                                        style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem; margin-bottom: 0;">
                                        <thead>
                                            <tr
                                                style="background: rgba(99, 102, 241, 0.04); color: var(--gray-700); border-bottom: 2px solid var(--gray-200);">
                                                <th
                                                    style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; width: 80px;">
                                                    Sr. No.</th>
                                                <th
                                                    style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">
                                                    Transaction Date</th>
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
                                        <tbody id="statementTxnTbody">
                                            <!-- Populated dynamically via AJAX -->
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Footer Signatures -->
                                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px; margin-bottom: 25px;"
                                    class="print-only">
                                    <div style="text-align: center; width: 200px;">
                                        <div
                                            style="border-bottom: 1.5px solid var(--gray-400); height: 40px; margin-bottom: 8px;">
                                        </div>
                                        <span
                                            style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; text-transform: capitalize;">Authorized
                                            Signatory</span>
                                    </div>
                                    <div style="text-align: center; width: 200px;">
                                        <div
                                            style="border-bottom: 1.5px solid var(--gray-400); height: 40px; margin-bottom: 8px;">
                                        </div>
                                        <span
                                            style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; text-transform: capitalize;">System
                                            Generated Seals</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Modal Controls (hidden in print) -->
                            <div style="display: flex; justify-content: center; align-items: center; margin-top: 35px; border-top: 1px solid var(--gray-100); padding-top: 25px;"
                                class="no-print">
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeModal('statementModal')">Close View</button>
                            </div>
                        </div>
                    </div>
                </div>

                <footer class="footer no-print">
                    <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
                        <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy;
                            <span>2026</span> Vertex Galaxy Bank. Internal administrative access.
                        </p>
                    </div>
                </footer>

                <script>
                    var accountsData = [];
                    // <c:forEach var="acc" items="${accounts}">
                    accountsData.push({
                        accountId: Number("${acc.accountId}"),
                        customerId: Number("${acc.customerId}"),
                        customerName: "${acc.customerName}",
                        accountNumber: "${acc.accountNumber}",
                        accountType: "${acc.accountType}",
                        balance: Number("${acc.balance}"),
                        status: "${acc.status}",
                        ifscCode: "${acc.ifscCode}",
                        hasAtmCard: "${acc.hasAtmCard}" === "true",
                        hasChequeBook: "${acc.hasChequeBook}" === "true",
                        hasPassbook: "${acc.hasPassbook}" === "true",

                        // Savings fields
                        nomineeName: "${acc.nomineeName}",
                        holdingType: "${acc.holdingType}",
                        dailyWithdrawalLimit: "${acc.dailyWithdrawalLimit}",

                        // Current fields
                        businessName: "${acc.businessName}",
                        gstin: "${acc.gstin}",
                        overdraftLimit: "${acc.overdraftLimit}",
                        companyCategory: "${acc.companyCategory}",
                        companyPhone: "${acc.companyPhone}",
                        companyEmail: "${acc.companyEmail}",
                        companyAddress: "${acc.companyAddress}",
                        companyPan: "${acc.companyPan}",
                        companyAadhaar: "${acc.companyAadhaar}",

                        // Primary Customer fields
                        primaryFirstName: "${acc.primaryFirstName}",
                        primaryMiddleName: "${acc.primaryMiddleName}",
                        primaryLastName: "${acc.primaryLastName}",
                        primaryFatherName: "${acc.primaryFatherName}",
                        primaryMotherName: "${acc.primaryMotherName}",
                        primaryNationality: "${acc.primaryNationality}",
                        primaryEmail: "${acc.primaryEmail}",
                        primaryPhone: "${acc.primaryPhone}",
                        primaryAltPhone: "${acc.primaryAltPhone}",
                        primaryAddress: "${acc.primaryAddress}",
                        primaryPermAddress: "${acc.primaryPermAddress}",
                        primaryCity: "${acc.primaryCity}",
                        primaryState: "${acc.primaryState}",
                        primaryZip: "${acc.primaryZip}",
                        primaryPan: "${acc.primaryPan}",
                        primaryAadhaar: "${acc.primaryAadhaar}",
                        primaryGender: "${acc.primaryGender}",
                        primarySignaturePath: "${acc.primarySignaturePath}",
                        primaryMaritalStatus: "${acc.primaryMaritalStatus}",
                        primaryOccupation: "${acc.primaryOccupation}",
                        primaryIncome: "${acc.primaryIncome}",

                        // Joint Customer fields
                        jointCustomerId: Number("${acc.jointCustomerId}"),
                        jointFirstName: "${acc.jointFirstName}",
                        jointMiddleName: "${acc.jointMiddleName}",
                        jointLastName: "${acc.jointLastName}",
                        jointFatherName: "${acc.jointFatherName}",
                        jointMotherName: "${acc.jointMotherName}",
                        jointNationality: "${acc.jointNationality}",
                        jointEmail: "${acc.jointEmail}",
                        jointPhone: "${acc.jointPhone}",
                        jointAltPhone: "${acc.jointAltPhone}",
                        jointDob: "${acc.jointDob}",
                        jointGender: "${acc.jointGender}",
                        jointMaritalStatus: "${acc.jointMaritalStatus}",
                        jointPan: "${acc.jointPan}",
                        jointAadhaar: "${acc.jointAadhaar}",
                        jointAddress: "${acc.jointAddress}",
                        jointPermAddress: "${acc.jointPermAddress}",
                        jointCity: "${acc.jointCity}",
                        jointState: "${acc.jointState}",
                        jointZip: "${acc.jointZip}",
                        jointOccupation: "${acc.jointOccupation}",
                        jointIncome: "${acc.jointIncome}",

                        // DOB
                        customerDob: "${acc.customerDob}",
                        phoneNo: "${acc.companyPhone}",

                        // Guardian details
                        guardianName: "${acc.primaryGuardianName}",
                        guardianRelationship: "${acc.primaryGuardianRelationship}",
                        guardianPhone: "${acc.primaryGuardianPhone}",
                        guardianAadhaar: "${acc.primaryGuardianAadhaar}",
                        guardianPan: "${acc.primaryGuardianPan}",

                        // Student details
                        schoolCollegeName: "${acc.primarySchoolCollegeName}",
                        studentId: "${acc.primaryStudentId}",
                        course: "${acc.primaryCourse}",
                        admissionNumber: "${acc.primaryAdmissionNumber}",

                        // Salary details
                        companyName: "${acc.primaryCompanyName}",
                        employerName: "${acc.primaryEmployerName}",
                        employeeId: "${acc.primaryEmployeeId}",
                        salaryFrequency: "${acc.primarySalaryFrequency}",

                        // Senior RM
                        relationshipManager: "${acc.primaryRelationshipManager}",

                        // Term Deposit variables
                        fdRdTenure: "${acc.fdRdTenureMonths}",
                        fdRdInterestRate: "${acc.fdRdInterestRate}",
                        fdRdMaturityAmount: "${acc.fdRdMaturityAmount}",
                        fdRdMaturityDate: "${acc.fdRdMaturityDate}",
                        fdRdPayoutOption: "${acc.fdRdPayoutOption}",
                        fdRdAutoRenewal: "${acc.fdRdAutoRenewal}" === "true",
                        fdRdAutoDebit: "${acc.fdRdAutoDebit}" === "true",

                        // CBS generated fields
                        applicationRefNo: "${acc.applicationRefNo}",
                        passbookNumber: "${acc.passbookNumber}",
                        atmCardNumber: "${acc.atmCardNumber}",
                        isPensionAccount: "${acc.pensionAccount}" === "true"
                    });
                    // </c:forEach>
                </script>

                <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
                <script>
                    var contextPath = "${pageContext.request.contextPath}";
                    var currentWizardStep = 1;

                    window.onload = function () {
                        // Remove preloader
                        const loader = document.querySelector('.preloader');
                        if (loader) {
                            loader.classList.add('hidden');
                        }
                    };



                    // Live table search filtering
                    function filterAccountsTable() {
                        var searchInput = document.getElementById('accountSearchInput');
                        var searchVal = searchInput.value.toLowerCase().trim();

                        var typeSelect = document.getElementById('accountTypeFilter');
                        var typeVal = typeSelect ? typeSelect.value.toLowerCase() : "";

                        var statusSelect = document.getElementById('accountStatusFilter');
                        var statusVal = statusSelect ? statusSelect.value.toLowerCase() : "";

                        var rows = document.querySelectorAll('.account-row-data');

                        rows.forEach(function (row) {
                            var custId = row.querySelector('.td-cust-id').textContent.toLowerCase();
                            var custName = row.querySelector('.td-cust-name').textContent.toLowerCase();
                            var accNum = row.querySelector('.td-acc-num').textContent.toLowerCase();

                            var rowType = row.getAttribute('data-account-type') ? row.getAttribute('data-account-type').toLowerCase() : "";
                            var rowStatus = row.getAttribute('data-account-status') ? row.getAttribute('data-account-status').toLowerCase() : "";

                            var matchesSearch = custId.includes(searchVal) || custName.includes(searchVal) || accNum.includes(searchVal);
                            var matchesType = typeVal === "" || rowType === typeVal;
                            var matchesStatus = statusVal === "" || rowStatus === statusVal;

                            if (matchesSearch && matchesType && matchesStatus) {
                                row.style.display = '';
                            } else {
                                row.style.display = 'none';
                            }
                        });
                    }

                    // Modal triggers
                    function openModal(id) {
                        document.getElementById(id).style.display = 'flex';
                        var footer = document.querySelector('.footer');
                        if (footer) footer.style.setProperty('display', 'none', 'important');
                    }
                    function closeModal(id) {
                        document.getElementById(id).style.display = 'none';
                        var anyModalOpen = Array.from(document.querySelectorAll('.modal')).some(function (m) {
                            return m.style.display === 'flex';
                        });
                        if (!anyModalOpen) {
                            var footer = document.querySelector('.footer');
                            if (footer) footer.style.display = '';
                        }
                    }

                    // View details modal population
                    function openViewModal(index) {
                        var acc = accountsData[index];
                        var body = document.getElementById('viewModalBody');

                        var detailsHtml = `
                <!-- Core Banking generated numbers -->
                <h4 style="font-weight:700; color:var(--primary-600); border-bottom:1.5px solid var(--primary-100); padding-bottom:5px; margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <i class="bx bx-lock-alt"></i> Core Banking Credentials
                </h4>
                <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:12px; margin-bottom:25px;">
                    <div style="background:#f8fafc; border:1px solid #cbd5e1; padding:12px; border-radius:var(--radius-sm); text-align:center;">
                        <span style="display:block; font-size:0.65rem; color:#64748b; font-weight:700; text-transform:uppercase; margin-bottom:4px;">Account Number</span>
                        <strong style="font-family:monospace; font-size:1.05rem; color:#1e293b; cursor:pointer;" onclick="navigator.clipboard.writeText('\${acc.accountNumber}'); alert('Copied Account Number: \${acc.accountNumber}')" title="Click to copy">\${acc.accountNumber} <i class="bx bx-copy" style="font-size:0.85rem; color:var(--primary-500);"></i></strong>
                    </div>
                    <div style="background:#f8fafc; border:1px solid #cbd5e1; padding:12px; border-radius:var(--radius-sm); text-align:center;">
                        <span style="display:block; font-size:0.65rem; color:#64748b; font-weight:700; text-transform:uppercase; margin-bottom:4px;">CIF Number</span>
                        <strong style="font-family:monospace; font-size:1.05rem; color:#1e293b; cursor:pointer;" onclick="navigator.clipboard.writeText('\${acc.cifNumber || 'N/A'}'); alert('Copied CIF Number: \${acc.cifNumber || 'N/A'}')" title="Click to copy">\${acc.cifNumber || 'N/A'} <i class="bx bx-copy" style="font-size:0.85rem; color:var(--primary-500);"></i></strong>
                    </div>
                    <div style="background:#f8fafc; border:1px solid #cbd5e1; padding:12px; border-radius:var(--radius-sm); text-align:center;">
                        <span style="display:block; font-size:0.65rem; color:#64748b; font-weight:700; text-transform:uppercase; margin-bottom:4px;">Application Ref No</span>
                        <strong style="font-family:monospace; font-size:0.95rem; color:#1e293b; cursor:pointer;" onclick="navigator.clipboard.writeText('\${acc.applicationRefNo || 'N/A'}'); alert('Copied Application Ref: \${acc.applicationRefNo || 'N/A'}')" title="Click to copy">\${acc.applicationRefNo || 'N/A'} <i class="bx bx-copy" style="font-size:0.85rem; color:var(--primary-500);"></i></strong>
                    </div>
                    <div style="background:#f8fafc; border:1px solid #cbd5e1; padding:12px; border-radius:var(--radius-sm); text-align:center;">
                        <span style="display:block; font-size:0.65rem; color:#64748b; font-weight:700; text-transform:uppercase; margin-bottom:4px;">Passbook booklet</span>
                        <strong style="font-family:monospace; font-size:0.95rem; color:#1e293b; cursor:pointer;" onclick="navigator.clipboard.writeText('\${acc.passbookNumber || 'N/A'}'); alert('Copied Passbook No: \${acc.passbookNumber || 'N/A'}')" title="Click to copy">\${acc.passbookNumber || 'N/A'} <i class="bx bx-copy" style="font-size:0.85rem; color:var(--primary-500);"></i></strong>
                    </div>
                    <div style="background:#f8fafc; border:1px solid #cbd5e1; padding:12px; border-radius:var(--radius-sm); text-align:center;">
                        <span style="display:block; font-size:0.65rem; color:#64748b; font-weight:700; text-transform:uppercase; margin-bottom:4px;">ATM Card Number</span>
                        <strong style="font-family:monospace; font-size:0.95rem; color:#1e293b; cursor:pointer;" onclick="navigator.clipboard.writeText('\${acc.atmCardNumber || 'N/A'}'); alert('Copied ATM Card No: \${acc.atmCardNumber || 'N/A'}')" title="Click to copy">\${acc.atmCardNumber || 'N/A'} <i class="bx bx-copy" style="font-size:0.85rem; color:var(--primary-500);"></i></strong>
                    </div>
                    <div style="background:#f8fafc; border:1px solid #cbd5e1; padding:12px; border-radius:var(--radius-sm); text-align:center;">
                        <span style="display:block; font-size:0.65rem; color:#64748b; font-weight:700; text-transform:uppercase; margin-bottom:4px;">IFSC Code</span>
                        <strong style="font-family:monospace; font-size:0.95rem; color:#1e293b; cursor:pointer;" onclick="navigator.clipboard.writeText('\${acc.ifscCode}'); alert('Copied IFSC: \${acc.ifscCode}')" title="Click to copy">\${acc.ifscCode} <i class="bx bx-copy" style="font-size:0.85rem; color:var(--primary-500);"></i></strong>
                    </div>
                </div>

                <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
                    <div>
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Account Specifications</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Account Type:</td><td style="font-weight:700; text-transform:uppercase; color:var(--primary-600);">\${acc.accountType}</td></tr>
                            <tr><td style="color:var(--gray-500);">Ledger Balance:</td><td style="font-weight:800; color:var(--accent-emerald); font-size:1.05rem;">₹ \${acc.balance.toLocaleString('en-IN', {minimumFractionDigits:2, maximumFractionDigits:2})}</td></tr>
                            <tr><td style="color:var(--gray-500);">Account Status:</td><td style="font-weight:700; text-transform:uppercase; color:\${acc.status === 'active' ? 'var(--accent-emerald)' : 'red'}">\${acc.status}</td></tr>
                        </table>
                    </div>
                    <div>
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Enabled Services</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:50%;">ATM Debit Card:</td><td style="font-weight:700;">\${acc.hasAtmCard ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Cheque Book:</td><td style="font-weight:700;">\${acc.hasChequeBook ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Offline Passbook:</td><td style="font-weight:700;">\${acc.hasPassbook ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                        </table>
                    </div>
                </div>
            `;

                        // Append specialized profile blocks
                        if (acc.accountType === 'savings') {
                            detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Savings Ledger Specifics</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Registered Nominee:</td><td style="font-weight:700;">\${acc.nomineeName || 'No Nominee'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Holding Mode:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.holdingType || 'single'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Daily Cash Limit:</td><td style="font-weight:700;">₹ \${parseFloat(acc.dailyWithdrawalLimit || 50000).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td></tr>
                        </table>
                    </div>
                `;
                        } else if (acc.accountType === 'current') {
                            detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Corporate Registry</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Business Trade Name:</td><td style="font-weight:700;">\${acc.businessName || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">GSTIN Identification:</td><td style="font-weight:700; font-family:monospace;">\${acc.gstin || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Overdraft Limit line:</td><td style="font-weight:700; color:var(--primary-600);">₹ \${parseFloat(acc.overdraftLimit || 100000).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Category:</td><td style="font-weight:700;">\${acc.companyCategory || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company PAN / Aadhaar:</td><td style="font-weight:700; font-family:monospace;">\${acc.companyPan || 'N/A'} / \dots \${acc.companyAadhaar || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Corporate Contact:</td><td style="font-weight:700;">\${acc.companyPhone || 'N/A'} / \${acc.companyEmail || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Registered Address:</td><td style="font-weight:700;">\${acc.companyAddress || 'N/A'}</td></tr>
                        </table>
                    </div>
                `;
                        } else if (acc.accountType === 'student') {
                            detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Student Academic Profile</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">School / College Name:</td><td style="font-weight:700;">\${acc.schoolCollegeName || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Course / Specialization:</td><td style="font-weight:700;">\${acc.course || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Student ID Number:</td><td style="font-weight:700; font-family:monospace;">\${acc.studentId || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Admission Roll Number:</td><td style="font-weight:700; font-family:monospace;">\${acc.admissionNumber || 'N/A'}</td></tr>
                        </table>
                    </div>
                `;
                        } else if (acc.accountType === 'salary') {
                            detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Corporate Employment Profile</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Employer Company:</td><td style="font-weight:700;">\${acc.companyName || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Designation / Category:</td><td style="font-weight:700;">\${acc.employerName || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Employee ID Code:</td><td style="font-weight:700; font-family:monospace;">\${acc.employeeId || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Salary Credit Frequency:</td><td style="font-weight:700;">\${acc.salaryFrequency || 'Monthly'}</td></tr>
                        </table>
                    </div>
                `;
                        } else if (acc.accountType === 'fd' || acc.accountType === 'rd') {
                            detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">\${acc.accountType.toUpperCase()} Investment Terms</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Investment Tenure:</td><td style="font-weight:700;">\${acc.fdRdTenure || '0'} Months</td></tr>
                            <tr><td style="color:var(--gray-500);">Interest Rate:</td><td style="font-weight:700; color:var(--primary-600);">\${acc.fdRdInterestRate || '0.0'}% p.a.</td></tr>
                            <tr><td style="color:var(--gray-500);">Maturity Date:</td><td style="font-weight:700; font-family:monospace;">\${acc.fdRdMaturityDate || 'N/A'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Expected Maturity Amount:</td><td style="font-weight:800; color:var(--accent-emerald);">₹ \${parseFloat(acc.fdRdMaturityAmount || 0).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td></tr>
                            <tr><td style="color:var(--gray-500);">Interest Payout Option:</td><td style="font-weight:700;">\${acc.fdRdPayoutOption || 'On Maturity'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Auto-Renewal:</td><td style="font-weight:700;">\${acc.fdRdAutoRenewal ? '✓ ACTIVE' : '✗ INACTIVE'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Auto-Debit linked account:</td><td style="font-weight:700;">\${acc.fdRdAutoDebit ? '✓ ACTIVE' : '✗ INACTIVE'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Pension Account:</td><td style="font-weight:700;">\${acc.isPensionAccount ? '✓ ACTIVE' : '✗ INACTIVE'}</td></tr>
                        </table>
                    </div>
                `;
                        }

                        // Add Primary Customer details section
                        if (acc.primaryFirstName) {
                            var isMinor = false;
                            if (acc.customerDob) {
                                var dobYr = new Date(acc.customerDob).getFullYear();
                                var currYr = new Date().getFullYear();
                                if (currYr - dobYr < 18) {
                                    isMinor = true;
                                }
                            }

                            detailsHtml += `
                    <div style="margin-top:25px; background: rgba(99, 102, 241, 0.03); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.1);">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px; display:flex; justify-content:space-between; align-items:center;">
                            <span><i class="bx bx-user" style="color:var(--primary-500);"></i> Primary Holder Profile</span>
                            \${isMinor ? '<span style="background:rgba(239, 68, 68, 0.12); color:#ef4444; font-size:0.65rem; font-weight:700; padding:2px 8px; border-radius:10px;">MINOR APPLICANT</span>' : ''}
                        </h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr>
                                <td style="color:var(--gray-500); width:35%;">Full Name:</td>
                                <td style="font-weight:700;">\${acc.primaryFirstName} \${acc.primaryMiddleName ? acc.primaryMiddleName + ' ' : ''}\${acc.primaryLastName}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Date of Birth / Gender:</td>
                                <td style="font-weight:700;">\${acc.customerDob || 'N/A'} / \${acc.primaryGender.toUpperCase()}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Marital Status / Occupation:</td>
                                <td style="font-weight:700;">\${acc.primaryMaritalStatus.toUpperCase()} / \${acc.primaryOccupation || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Email / Phone:</td>
                                <td style="font-weight:700;">\${acc.primaryEmail || 'N/A'} / \${acc.primaryPhone || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">PAN Card / Aadhaar:</td>
                                <td style="font-weight:700; font-family:monospace;">\${acc.primaryPan || 'N/A'} / \${acc.primaryAadhaar || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Annual Income:</td>
                                <td style="font-weight:700; color: var(--accent-emerald);">₹ \${parseFloat(acc.primaryIncome || 0).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Father / Mother Name:</td>
                                <td style="font-weight:700;">\${acc.primaryFatherName || 'N/A'} / \${acc.primaryMotherName || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Address:</td>
                                <td style="font-weight:700;">\${acc.primaryAddress ? acc.primaryAddress + ', ' + acc.primaryCity + ', ' + acc.primaryState + ' - ' + acc.primaryZip : 'N/A'}</td>
                            </tr>
                            \${acc.primarySignaturePath ? '<tr><td style="color:var(--gray-500);">Applicant Signature:</td><td><img src="' + contextPath + acc.primarySignaturePath + '" alt="Signature" style="max-height: 50px; border: 1.5px solid var(--gray-200); border-radius: 4px; padding: 2px; background: white;"></td></tr>' : ''}
                        </table>
                    </div>
                `;

                            if (isMinor && acc.guardianName) {
                                detailsHtml += `
                        <div style="margin-top:20px; background: rgba(239, 68, 68, 0.02); padding: 15px; border-radius: var(--radius-md); border: 1.5px solid rgba(239, 68, 68, 0.1);">
                            <h5 style="font-size:0.85rem; font-weight:700; color:#ef4444; margin-bottom:10px; display:flex; align-items:center; gap:6px;">
                                <i class="bx bx-shield-quarter"></i> Registered Legal Guardian Details
                            </h5>
                            <table style="width:100%; font-size:0.8rem; line-height:1.7;">
                                <tr><td style="color:var(--gray-500); width:35%;">Guardian Name:</td><td style="font-weight:700;">\${acc.guardianName} (\${acc.guardianRelationship})</td></tr>
                                <tr><td style="color:var(--gray-500);">Contact Phone:</td><td style="font-weight:700;">\${acc.guardianPhone || 'N/A'}</td></tr>
                                <tr><td style="color:var(--gray-500);">Aadhaar / PAN Details:</td><td style="font-weight:700; font-family:monospace;">\${acc.guardianAadhaar || 'N/A'} / \${acc.guardianPan || 'N/A'}</td></tr>
                            </table>
                        </div>
                    `;
                            }

                            if (acc.relationshipManager) {
                                detailsHtml += `
                        <div style="margin-top:20px; background: rgba(245, 158, 11, 0.02); padding: 15px; border-radius: var(--radius-md); border: 1.5px solid rgba(245, 158, 11, 0.1);">
                            <h5 style="font-size:0.85rem; font-weight:700; color:var(--accent-amber); margin-bottom:10px; display:flex; align-items:center; gap:6px;">
                                <i class="bx bx-badge-check"></i> VGB Senior Priority RM Assigned
                            </h5>
                            <table style="width:100%; font-size:0.8rem; line-height:1.7;">
                                <tr><td style="color:var(--gray-500); width:35%;">Relationship Manager:</td><td style="font-weight:700;">\${acc.relationshipManager}</td></tr>
                            </table>
                        </div>
                    `;
                            }
                        }

                        // Add Joint Customer details section if joint holding
                        if (acc.holdingType === 'joint' && acc.jointCustomerId > 0) {
                            detailsHtml += `
                    <div style="margin-top:25px; background: rgba(236, 72, 153, 0.03); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid rgba(236, 72, 153, 0.1);">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">
                            <i class="bx bx-group" style="color:var(--secondary-500);"></i> Joint Holder Details
                        </h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr>
                                <td style="color:var(--gray-500); width:35%;">Full Name:</td>
                                <td style="font-weight:700;">\${acc.jointFirstName} \${acc.jointMiddleName ? acc.jointMiddleName + ' ' : ''}\${acc.jointLastName}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Date of Birth / Gender:</td>
                                <td style="font-weight:700;">\${acc.jointDob || 'N/A'} / \${acc.jointGender.toUpperCase()}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Marital Status / Occupation:</td>
                                <td style="font-weight:700;">\${acc.jointMaritalStatus.toUpperCase()} / \${acc.jointOccupation || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Email / Phone:</td>
                                <td style="font-weight:700;">\${acc.jointEmail || 'N/A'} / \${acc.jointPhone || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">PAN Card / Aadhaar:</td>
                                <td style="font-weight:700; font-family:monospace;">\${acc.jointPan || 'N/A'} / \${acc.jointAadhaar || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Annual Income:</td>
                                <td style="font-weight:700; color: var(--accent-emerald);">₹ \${parseFloat(acc.jointIncome || 0).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Father / Mother Name:</td>
                                <td style="font-weight:700;">\${acc.jointFatherName || 'N/A'} / \${acc.jointMotherName || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Address:</td>
                                <td style="font-weight:700;">\${acc.jointAddress ? acc.jointAddress + ', ' + acc.jointCity + ', ' + acc.jointState + ' - ' + acc.jointZip : 'N/A'}</td>
                            </tr>
                        </table>
                    </div>
                `;
                        }

                        body.innerHTML = detailsHtml;
                        openModal('viewAccountModal');
                    }

                    // Edit details modal population
                    function openEditModal(index) {
                        var acc = accountsData[index];
                        document.getElementById('editAccountId').value = acc.accountId;
                        document.getElementById('editIfsc').value = acc.ifscCode;
                        document.getElementById('editStatus').value = acc.status;

                        document.getElementById('editAtmCard').checked = acc.hasAtmCard;
                        document.getElementById('editChequeBook').checked = acc.hasChequeBook;
                        document.getElementById('editPassbook').checked = acc.hasPassbook;

                        // Hide all sub-type blocks first
                        document.getElementById('savingsEditFields').style.display = 'none';
                        document.getElementById('currentEditFields').style.display = 'none';
                        document.getElementById('studentEditFields').style.display = 'none';
                        document.getElementById('salaryEditFields').style.display = 'none';
                        document.getElementById('depositEditFields').style.display = 'none';
                        document.getElementById('guardianEditFields').style.display = 'none';
                        document.getElementById('jointCustomerEditFields').style.display = 'none';

                        if (acc.accountType === 'current') {
                            document.getElementById('currentEditFields').style.display = 'block';
                            document.getElementById('editBusinessName').value = acc.businessName || '';
                            document.getElementById('editGstin').value = acc.gstin || '';
                            document.getElementById('editOverdraft').value = acc.overdraftLimit || '';
                            document.getElementById('editCompanyCategory').value = acc.companyCategory || '';
                            document.getElementById('editCompanyPan').value = acc.companyPan || '';
                            document.getElementById('editCompanyAadhaar').value = acc.companyAadhaar || '';
                            document.getElementById('editCompanyPhone').value = acc.companyPhone || '';
                            document.getElementById('editCompanyEmail').value = acc.companyEmail || '';
                            document.getElementById('editCompanyAddress').value = acc.companyAddress || '';

                            updateEditRequiredFields('current', 'single');
                        } else {
                            // Non-current accounts (savings, student, salary, fd, rd)
                            document.getElementById('savingsEditFields').style.display = 'block';
                            document.getElementById('editNominee').value = acc.nomineeName || '';
                            document.getElementById('editHoldingType').value = acc.holdingType || 'single';
                            document.getElementById('editDailyLimit').value = acc.dailyWithdrawalLimit || '';

                            // Populate primary customer details
                            document.getElementById('editFirstName').value = acc.primaryFirstName || '';
                            document.getElementById('editMiddleName').value = acc.primaryMiddleName || '';
                            document.getElementById('editLastName').value = acc.primaryLastName || '';
                            document.getElementById('editDob').value = acc.customerDob || '';
                            document.getElementById('editGender').value = acc.primaryGender || 'male';
                            document.getElementById('editMarital').value = acc.primaryMaritalStatus || 'single';
                            document.getElementById('editEmail').value = acc.primaryEmail || '';
                            document.getElementById('editPhone').value = acc.primaryPhone || '';
                            document.getElementById('editIncome').value = acc.primaryIncome || '';
                            document.getElementById('editOcc').value = acc.primaryOccupation || '';
                            document.getElementById('editPan').value = acc.primaryPan || '';
                            document.getElementById('editAadhaar').value = acc.primaryAadhaar || '';
                            document.getElementById('editAddress').value = acc.primaryAddress || '';
                            document.getElementById('editPermAddress').value = acc.primaryPermAddress || '';
                            document.getElementById('editFatherName').value = acc.primaryFatherName || '';
                            document.getElementById('editMotherName').value = acc.primaryMotherName || '';
                            document.getElementById('editNationality').value = acc.primaryNationality || 'Indian';
                            document.getElementById('editAltPhone').value = acc.primaryAltPhone || '';
                            document.getElementById('editCity').value = acc.primaryCity || '';
                            document.getElementById('editState').value = acc.primaryState || '';
                            document.getElementById('editZip').value = acc.primaryZip || '';
                            document.getElementById('editRelationshipManager').value = acc.relationshipManager || '';

                            // Check Minor guardian details
                            var isMinor = false;
                            if (acc.customerDob) {
                                var dobYr = new Date(acc.customerDob).getFullYear();
                                var currYr = new Date().getFullYear();
                                if (currYr - dobYr < 18) {
                                    isMinor = true;
                                }
                            }

                            if (isMinor) {
                                document.getElementById('guardianEditFields').style.display = 'block';
                                document.getElementById('editGuardianName').value = acc.guardianName || '';
                                document.getElementById('editGuardianRelationship').value = acc.guardianRelationship || 'father';
                                document.getElementById('editGuardianPhone').value = acc.guardianPhone || '';
                                document.getElementById('editGuardianAadhaar').value = acc.guardianAadhaar || '';
                                document.getElementById('editGuardianPan').value = acc.guardianPan || '';
                            }

                            // Show specialized fields based on type
                            if (acc.accountType === 'student') {
                                document.getElementById('studentEditFields').style.display = 'block';
                                document.getElementById('editSchoolCollege').value = acc.schoolCollegeName || '';
                                document.getElementById('editStudentId').value = acc.studentId || '';
                                document.getElementById('editCourse').value = acc.course || '';
                                document.getElementById('editAdmissionNumber').value = acc.admissionNumber || '';
                            } else if (acc.accountType === 'salary') {
                                document.getElementById('salaryEditFields').style.display = 'block';
                                document.getElementById('editCompanyName').value = acc.companyName || '';
                                document.getElementById('editEmployerName').value = acc.employerName || '';
                                document.getElementById('editEmployeeId').value = acc.employeeId || '';
                                document.getElementById('editSalaryFrequency').value = acc.salaryFrequency || 'monthly';
                            } else if (acc.accountType === 'fd' || acc.accountType === 'rd') {
                                document.getElementById('depositEditFields').style.display = 'block';
                                document.getElementById('editFdRdTenure').value = acc.fdRdTenure || '12';
                                document.getElementById('editFdRdInterestRate').value = acc.fdRdInterestRate || '';
                                document.getElementById('editFdRdMaturityAmount').value = acc.fdRdMaturityAmount || '';
                                document.getElementById('editFdRdMaturityDate').value = acc.fdRdMaturityDate || '';
                                document.getElementById('editFdRdPayoutOption').value = acc.fdRdPayoutOption || 'cumulative';
                                document.getElementById('editFdAutoRenewal').checked = acc.fdRdAutoRenewal;
                                document.getElementById('editRdAutoDebit').checked = acc.fdRdAutoDebit;
                                document.getElementById('editIsPension').checked = acc.isPensionAccount;
                            }

                            // Populate joint customer details if joint savings
                            var jointFields = document.getElementById('jointCustomerEditFields');
                            if (acc.holdingType === 'joint') {
                                jointFields.style.display = 'block';
                                document.getElementById('editJointFirstName').value = acc.jointFirstName || '';
                                document.getElementById('editJointMiddleName').value = acc.jointMiddleName || '';
                                document.getElementById('editJointLastName').value = acc.jointLastName || '';
                                document.getElementById('editJointDob').value = acc.jointDob || '';
                                document.getElementById('editJointGender').value = acc.jointGender || 'male';
                                document.getElementById('editJointMarital').value = acc.jointMaritalStatus || 'single';
                                document.getElementById('editJointEmail').value = acc.jointEmail || '';
                                document.getElementById('editJointPhone').value = acc.jointPhone || '';
                                document.getElementById('editJointIncome').value = acc.jointIncome || '';
                                document.getElementById('editJointOcc').value = acc.jointOccupation || '';
                                document.getElementById('editJointPan').value = acc.jointPan || '';
                                document.getElementById('editJointAadhaar').value = acc.jointAadhaar || '';
                                document.getElementById('editJointAddress').value = acc.jointAddress || '';
                                document.getElementById('editJointPermAddress').value = acc.jointPermAddress || '';
                                document.getElementById('editJointFatherName').value = acc.jointFatherName || '';
                                document.getElementById('editJointMotherName').value = acc.jointMotherName || '';
                                document.getElementById('editJointNationality').value = acc.jointNationality || 'Indian';
                                document.getElementById('editJointAltPhone').value = acc.jointAltPhone || '';
                                document.getElementById('editJointCity').value = acc.jointCity || '';
                                document.getElementById('editJointState').value = acc.jointState || '';
                                document.getElementById('editJointZip').value = acc.jointZip || '';
                            }

                            updateEditRequiredFields('savings', acc.holdingType);
                        }

                        openModal('editAccountModal');
                    }

                    function toggleEditHoldingType() {
                        var holdingType = document.getElementById('editHoldingType').value;
                        var jointFields = document.getElementById('jointCustomerEditFields');
                        if (holdingType === 'joint') {
                            jointFields.style.display = 'block';
                        } else {
                            jointFields.style.display = 'none';
                        }
                        updateEditRequiredFields('savings', holdingType);
                    }

                    function updateEditRequiredFields(accountType, holdingType) {
                        var primaryInputs = [
                            'editFirstName', 'editLastName', 'editDob', 'editGender',
                            'editEmail', 'editPhone', 'editPan', 'editAadhaar',
                            'editAddress', 'editCity', 'editState', 'editZip',
                            'editPermAddress', 'editFatherName', 'editMotherName', 'editNationality'
                        ];
                        var jointInputs = [
                            'editJointFirstName', 'editJointLastName', 'editJointDob', 'editJointGender',
                            'editJointEmail', 'editJointPhone', 'editJointPan', 'editJointAadhaar',
                            'editJointAddress', 'editJointCity', 'editJointState', 'editJointZip',
                            'editJointPermAddress', 'editJointFatherName', 'editJointMotherName', 'editJointNationality'
                        ];

                        if (accountType !== 'current') {
                            primaryInputs.forEach(function (id) {
                                var elem = document.getElementById(id);
                                if (elem) elem.setAttribute('required', 'required');
                            });

                            if (holdingType === 'joint') {
                                jointInputs.forEach(function (id) {
                                    var elem = document.getElementById(id);
                                    if (elem) elem.setAttribute('required', 'required');
                                });
                            } else {
                                jointInputs.forEach(function (id) {
                                    var elem = document.getElementById(id);
                                    if (elem) elem.removeAttribute('required');
                                });
                            }
                        } else {
                            primaryInputs.forEach(function (id) {
                                var elem = document.getElementById(id);
                                if (elem) elem.removeAttribute('required');
                            });
                            jointInputs.forEach(function (id) {
                                var elem = document.getElementById(id);
                                if (elem) elem.removeAttribute('required');
                            });
                        }
                    }

                    var closingAccountId = 0;
                    function openCloseModal(index) {
                        var acc = accountsData[index];
                        closingAccountId = acc.accountId;

                        document.getElementById('closeAccNum').textContent = acc.accountNumber;
                        document.getElementById('closeAccType').textContent = acc.accountType;
                        document.getElementById('closeHolderName').textContent = acc.customerName;
                        document.getElementById('closeBalance').textContent = "₹ " + acc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                        document.getElementById('closeStatus').textContent = acc.status;

                        openModal('closeAccountModal');
                    }

                    function confirmCloseAccount() {
                        if (closingAccountId > 0) {
                            window.location.href = "${pageContext.request.contextPath}/account?action=close&id=" + closingAccountId;
                        }
                    }

                    // ==========================================
                    // PREMIUM A4 OPEN ACCOUNT APPLICATION HANDLERS
                    // ==========================================
                    function openWizardModal() {
                        try {
                            // Set Date
                            var today = new Date().toISOString().split('T')[0];
                            var a4AppDates = document.querySelectorAll('[name="applicationDate"]');
                            a4AppDates.forEach(function (el) { el.value = today; });

                            var systemCreatedDate = document.getElementById('systemCreatedDate');
                            if (systemCreatedDate) systemCreatedDate.textContent = today;

                            // Generate secure random PIN
                            var randPin = Math.floor(1000 + Math.random() * 9000);
                            var a4Pin = document.getElementById('a4Pin');
                            if (a4Pin) a4Pin.value = randPin;

                            // Generate random username
                            var randNum = Math.floor(100 + Math.random() * 900);
                            var a4Username = document.getElementById('a4Username');
                            if (a4Username) a4Username.value = "vgbUser" + randNum;

                            var a4Password = document.getElementById('a4Password');
                            if (a4Password) a4Password.value = "VgbPass" + randPin;

                            var a4ConfirmPassword = document.getElementById('a4ConfirmPassword');
                            if (a4ConfirmPassword) a4ConfirmPassword.value = "VgbPass" + randPin;

                            handleAccountTypeChange();
                            handleHoldingTypeChange();

                            // Try loading draft
                            loadA4FormDraft();

                            openModal('createAccountModal');

                        } catch (err) {
                            console.error("Error in openWizardModal:", err);
                            alert("Error initializing Create Account modal: " + err.message);
                        }
                    }

                    function validateA4FormSubmit() {
                        // Validate Section A: Initial opening deposit
                        var amtInput = document.getElementById('a4InitialAmount');
                        var type = document.getElementById('a4AccountType').value;
                        var initialAmt = parseFloat(amtInput.value);
                        var minAmt = 1000;
                        if (type === 'current') minAmt = 5000;
                        else if (type === 'student') minAmt = 500;
                        else if (type === 'salary') minAmt = 0;
                        else if (type === 'fd') minAmt = 10000;
                        else if (type === 'rd') minAmt = 1000;

                        if (isNaN(initialAmt) || initialAmt < minAmt) {
                            alert("Initial deposit must be at least ₹" + minAmt.toLocaleString('en-IN', { minimumFractionDigits: 2 }));
                            amtInput.focus();
                            return false;
                        }

                        // Validate Section B: Personal Profile
                        var requiredIds = ['a4First', 'a4Last', 'a4Father', 'a4Mother', 'a4Dob', 'a4Nationality', 'a4Occupation', 'a4Income'];
                        for (var i = 0; i < requiredIds.length; i++) {
                            var input = document.getElementById(requiredIds[i]);
                            if (input && !input.value.trim()) {
                                alert("Please fill in the required field: " + input.previousElementSibling.textContent.replace('*', '').trim());
                                input.focus();
                                return false;
                            }
                        }

                        // Validate Section C: Contact & Address
                        var phone = document.getElementById('a4Phone');
                        if (phone && (phone.value.length !== 10 || isNaN(phone.value))) {
                            alert("Mobile number must be exactly 10 digits.");
                            phone.focus();
                            return false;
                        }

                        var email = document.getElementById('a4Email');
                        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (email && !emailRegex.test(email.value)) {
                            alert("Please enter a valid email address.");
                            email.focus();
                            return false;
                        }

                        var addrRequired = ['a4Address', 'a4City', 'a4State', 'a4Zip'];
                        for (var j = 0; j < addrRequired.length; j++) {
                            var el = document.getElementById(addrRequired[j]);
                            if (el && !el.value.trim()) {
                                alert("Please fill in current address field: " + el.previousElementSibling.textContent.replace('*', '').trim());
                                el.focus();
                                return false;
                            }
                        }

                        var syncCheck = document.getElementById('syncAddressCheck');
                        if (syncCheck && !syncCheck.checked) {
                            var permRequired = ['a4PermAddress', 'a4PermCity', 'a4PermState', 'a4PermZip'];
                            for (var k = 0; k < permRequired.length; k++) {
                                var pEl = document.getElementById(permRequired[k]);
                                if (pEl && !pEl.value.trim()) {
                                    alert("Please fill in permanent address field: " + pEl.previousElementSibling.textContent.replace('*', '').trim());
                                    pEl.focus();
                                    return false;
                                }
                            }
                        }

                        // Validate Section D: Workflows
                        var dobVal = document.getElementById('a4Dob').value;
                        var age = 0;
                        if (dobVal) {
                            var dob = new Date(dobVal);
                            age = (new Date() - dob) / (365.25 * 24 * 60 * 60 * 1000);
                        }

                        if (age < 18) {
                            var guardName = document.getElementById('a4GuardianName');
                            var guardPhone = document.getElementById('a4GuardianPhone');
                            var guardAadhaar = document.getElementById('a4GuardianAadhaar');
                            var guardPan = document.getElementById('a4GuardianPan');

                            if (!guardName || !guardName.value.trim()) {
                                alert("Guardian Name is required for Minor accounts.");
                                guardName.focus();
                                return false;
                            }
                            if (!guardPhone || guardPhone.value.length !== 10) {
                                alert("Guardian Mobile Number must be 10 digits.");
                                guardPhone.focus();
                                return false;
                            }
                            if (!guardAadhaar || guardAadhaar.value.length !== 12) {
                                alert("Guardian Aadhaar must be 12 digits.");
                                guardAadhaar.focus();
                                return false;
                            }
                            if (!guardPan || guardPan.value.length !== 10) {
                                alert("Guardian PAN must be 10 characters.");
                                guardPan.focus();
                                return false;
                            }
                        }

                        if (type === 'student') {
                            var school = document.getElementById('a4SchoolCollege');
                            var sid = document.getElementById('a4StudentId');
                            var course = document.getElementById('a4Course');

                            if (!school || !school.value.trim()) {
                                alert("School / College Name is required for Student accounts.");
                                school.focus();
                                return false;
                            }
                            if (!sid || !sid.value.trim()) {
                                alert("Student ID Number is required.");
                                sid.focus();
                                return false;
                            }
                            if (!course || !course.value.trim()) {
                                alert("Course stream is required.");
                                course.focus();
                                return false;
                            }
                        }

                        if (type === 'current') {
                            var bName = document.getElementById('a4BusName');
                            var bGst = document.getElementById('a4BusGst');
                            var bPhone = document.getElementById('a4BusPhone');
                            var bReg = document.getElementById('a4BusRegNo');
                            var bAddr = document.getElementById('a4BusAddress');

                            if (!bName || !bName.value.trim()) {
                                alert("Registered Trade Name is required.");
                                bName.focus();
                                return false;
                            }
                            if (!bGst || bGst.value.length !== 15) {
                                alert("GSTIN ID must be exactly 15 characters.");
                                bGst.focus();
                                return false;
                            }
                            if (!bPhone || bPhone.value.length !== 10) {
                                alert("Business Phone must be 10 digits.");
                                bPhone.focus();
                                return false;
                            }
                            if (!bReg || !bReg.value.trim()) {
                                alert("Business Registration/PAN is required.");
                                bReg.focus();
                                return false;
                            }
                            if (!bAddr || !bAddr.value.trim()) {
                                alert("Business Address is required.");
                                bAddr.focus();
                                return false;
                            }
                        }

                        if (type === 'salary') {
                            var company = document.getElementById('a4SalaryCompany');
                            var HR = document.getElementById('a4SalaryEmployer');
                            var empId = document.getElementById('a4SalaryEmpId');

                            if (!company || !company.value.trim()) {
                                alert("Company / Organization Name is required.");
                                company.focus();
                                return false;
                            }
                            if (!HR || !HR.value.trim()) {
                                alert("Employer/HR Name is required.");
                                HR.focus();
                                return false;
                            }
                            if (!empId || !empId.value.trim()) {
                                alert("Employee ID is required.");
                                empId.focus();
                                return false;
                            }
                        }

                        if (type !== 'current') {
                            var nominee = document.getElementById('a4NomineeName');
                            if (!nominee || !nominee.value.trim()) {
                                alert("Nominee Name is required.");
                                nominee.focus();
                                return false;
                            }
                        }

                        // Validate Section E: KYC Uploads
                        var aadhaarCopy = document.getElementById('aadhaarCopyInput');
                        var panCopy = document.getElementById('panCopyInput');
                        var signatureCopy = document.getElementById('signatureCopyInput');

                        if (aadhaarCopy && !aadhaarCopy.value && !aadhaarCopy.hasAttribute('disabled')) {
                            alert("Aadhaar Card Copy is required for KYC verification.");
                            return false;
                        }
                        if (panCopy && !panCopy.value && !panCopy.hasAttribute('disabled')) {
                            alert("PAN Card Copy is required for KYC verification.");
                            return false;
                        }
                        if (signatureCopy && !signatureCopy.value && !signatureCopy.hasAttribute('disabled')) {
                            alert("Applicant Signature Copy is required for KYC verification.");
                            return false;
                        }

                        // Validate Section F: Access credentials
                        var username = document.getElementById('a4Username').value;
                        var pin = document.getElementById('a4Pin').value;
                        var pass = document.getElementById('a4Password').value;
                        var confirmPass = document.getElementById('a4ConfirmPassword').value;

                        if (username.length < 4) {
                            alert("Username must be at least 4 characters.");
                            return false;
                        }

                        if (pin.length !== 4 || isNaN(pin)) {
                            alert("PIN must be exactly 4 digits.");
                            return false;
                        }

                        var pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                        if (!pwRegex.test(pass)) {
                            alert("Password must contain at least 8 characters, including 1 uppercase, 1 lowercase, 1 digit, and 1 special symbol.");
                            return false;
                        }

                        if (pass !== confirmPass) {
                            alert("Passwords do not match!");
                            return false;
                        }

                        // Disable empty file inputs to avoid Tomcat's FileCountLimitExceededException (max 10 parts)
                        var fileInputs = document.querySelectorAll('#createAccountForm input[type="file"]');
                        fileInputs.forEach(function (input) {
                            if (!input.value) {
                                input.disabled = true;
                            }
                        });

                        return true;
                    }

                    // Live calculation for FD / RD
                    function calculateMaturity() {
                        try {
                            var type = document.getElementById('a4AccountType').value;
                            var amount = parseFloat(document.getElementById('a4InitialAmount').value) || 0;

                            var dobVal = document.getElementById('a4Dob').value;
                            var isSenior = false;
                            if (dobVal) {
                                var dob = new Date(dobVal);
                                var age = (new Date() - dob) / (365.25 * 24 * 60 * 60 * 1000);
                                isSenior = age >= 60;
                            }

                            var tenureSelect = document.getElementById('termTenureSelect');
                            var tenure = parseInt(tenureSelect.value) || 12;

                            if (type === 'fd') {
                                var rate = 6.00;
                                if (tenure <= 12) rate = isSenior ? 6.75 : 6.00;
                                else if (tenure <= 36) rate = isSenior ? 7.25 : 6.50;
                                else rate = isSenior ? 7.75 : 7.00;

                                // Quarterly Compounding: A = P * (1 + r/4)^(4 * t/12)
                                var p = amount;
                                var r = rate / 100.0;
                                var n = 4;
                                var t = tenure / 12.0;
                                var a = p * Math.pow((1 + r / n), (n * t));

                                var termRateInput = document.getElementById('termInterestRate');
                                var termMatAmtInput = document.getElementById('termMaturityAmount');
                                var termMatDateInput = document.getElementById('termMaturityDate');

                                if (termRateInput) termRateInput.value = rate.toFixed(2) + "% p.a.";
                                if (termMatAmtInput) termMatAmtInput.value = a.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

                                var matDate = new Date();
                                matDate.setMonth(matDate.getMonth() + tenure);
                                if (termMatDateInput) termMatDateInput.value = matDate.toISOString().split('T')[0];

                                document.getElementById('hiddenFdRdTenureMonths').value = tenure;
                                document.getElementById('hiddenFdRdInterestRate').value = rate.toFixed(2);
                                document.getElementById('hiddenFdRdMaturityAmount').value = a.toFixed(2);
                                document.getElementById('hiddenFdRdMaturityDate').value = matDate.toISOString().split('T')[0];
                            }
                            else if (type === 'rd') {
                                var rate = 5.50;
                                if (tenure <= 12) rate = isSenior ? 6.00 : 5.50;
                                else if (tenure <= 36) rate = isSenior ? 6.50 : 6.00;
                                else rate = isSenior ? 7.00 : 6.50;

                                // RD Maturity Amount: M = P * ((1 + i)^n - 1) / i * (1 + i) where i = r/12
                                var p = amount; // monthly installment
                                var r = rate / 100.0;
                                var i = r / 12.0;
                                var n = tenure;
                                var a = p * ((Math.pow(1 + i, n) - 1) / i) * (1 + i);

                                var termRateInput = document.getElementById('termInterestRate');
                                var termMatAmtInput = document.getElementById('termMaturityAmount');
                                var termMatDateInput = document.getElementById('termMaturityDate');

                                if (termRateInput) termRateInput.value = rate.toFixed(2) + "% p.a.";
                                if (termMatAmtInput) termMatAmtInput.value = a.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

                                var matDate = new Date();
                                matDate.setMonth(matDate.getMonth() + tenure);
                                if (termMatDateInput) termMatDateInput.value = matDate.toISOString().split('T')[0];

                                document.getElementById('hiddenFdRdTenureMonths').value = tenure;
                                document.getElementById('hiddenFdRdInterestRate').value = rate.toFixed(2);
                                document.getElementById('hiddenFdRdMaturityAmount').value = a.toFixed(2);
                                document.getElementById('hiddenFdRdMaturityDate').value = matDate.toISOString().split('T')[0];
                            }
                        } catch (err) {
                            console.error("Error in calculateMaturity:", err);
                        }
                    }

                    // Utility to enable/disable and strip required attributes from hidden sections
                    function toggleSectionInputs(sectionId, enable) {
                        var section = document.getElementById(sectionId);
                        if (!section) return;
                        var inputs = section.querySelectorAll('input, select, textarea');
                        inputs.forEach(function (input) {
                            if (enable) {
                                input.removeAttribute('disabled');
                            } else {
                                input.setAttribute('disabled', 'disabled');
                                input.removeAttribute('required');
                            }
                        });
                    }

                    // DOB Age Calculation Workflows
                    function handleDobChange() {
                        try {
                            var dobVal = document.getElementById('a4Dob').value;
                            if (!dobVal) return;

                            var dob = new Date(dobVal);
                            var today = new Date();
                            var age = (today - dob) / (365.25 * 24 * 60 * 60 * 1000);

                            var classification = "";
                            var badgeClass = "";

                            var minorSection = document.getElementById('minorWorkflowSection');
                            var seniorSection = document.getElementById('seniorWorkflowSection');
                            var badgeEl = document.getElementById('ageClassificationBadge');

                            if (age < 18) {
                                classification = "Minor";
                                badgeClass = "card-badge badge-minor";

                                if (minorSection) minorSection.style.display = 'block';
                                if (seniorSection) seniorSection.style.display = 'none';

                                toggleSectionInputs('minorWorkflowSection', true);
                                setRequired('a4GuardianName', true);
                                setRequired('a4GuardianPhone', true);
                                setRequired('a4GuardianAadhaar', true);
                                setRequired('a4GuardianPan', true);
                            }
                            else if (age >= 60) {
                                classification = "Senior Citizen";
                                badgeClass = "card-badge badge-senior";

                                if (minorSection) minorSection.style.display = 'none';
                                if (seniorSection) seniorSection.style.display = 'block';

                                toggleSectionInputs('minorWorkflowSection', false);
                                setRequired('a4GuardianName', false);
                                setRequired('a4GuardianPhone', false);
                                setRequired('a4GuardianAadhaar', false);
                                setRequired('a4GuardianPan', false);
                            }
                            else {
                                classification = "Adult";
                                badgeClass = "card-badge badge-adult";

                                if (minorSection) minorSection.style.display = 'none';
                                if (seniorSection) seniorSection.style.display = 'none';

                                toggleSectionInputs('minorWorkflowSection', false);
                                setRequired('a4GuardianName', false);
                                setRequired('a4GuardianPhone', false);
                                setRequired('a4GuardianAadhaar', false);
                                setRequired('a4GuardianPan', false);
                            }

                            if (badgeEl) {
                                badgeEl.className = badgeClass;
                                badgeEl.textContent = classification;
                            }
                        } catch (err) {
                            console.error("Error in handleDobChange:", err);
                        }
                    }

                    // Account Type change layout update
                    function handleAccountTypeChange() {
                        try {
                            var typeElem = document.getElementById('a4AccountType');
                            if (!typeElem) return;
                            var type = typeElem.value;
                            var minAmt = 1000;
                            var noteText = "Minimum initial amount required is ₹1,000.00.";

                            var studentSection = document.getElementById('studentWorkflowSection');
                            var corporateSection = document.getElementById('corporateWorkflowSection');
                            var salarySection = document.getElementById('salaryWorkflowSection');
                            var termSection = document.getElementById('termDepositWorkflowSection');
                            var nomineeSection = document.getElementById('a4NomineeSection');

                            // Hide all by default
                            if (studentSection) studentSection.style.display = 'none';
                            if (corporateSection) corporateSection.style.display = 'none';
                            if (salarySection) salarySection.style.display = 'none';
                            if (termSection) termSection.style.display = 'none';
                            if (nomineeSection) nomineeSection.style.display = 'block';

                            // Disable all dynamic sections by default to bypass HTML5 validation
                            toggleSectionInputs('studentWorkflowSection', false);
                            toggleSectionInputs('corporateWorkflowSection', false);
                            toggleSectionInputs('salaryWorkflowSection', false);
                            toggleSectionInputs('termDepositWorkflowSection', false); // termDeposit
                            toggleSectionInputs('a4NomineeSection', true);

                            // Reset standard nominee required attributes
                            setRequired('a4NomineeName', true);
                            setRequired('a4NomineeRel', true);
                            setRequired('a4NomineeDob', true);
                            setRequired('a4NomineePhone', true);

                            // Disable transaction services for FD/RD
                            var atmCheck = document.getElementById('a4AtmCheck');
                            var chequeCheck = document.getElementById('a4ChequeCheck');
                            var passbookCheck = document.getElementById('a4PassbookCheck');

                            if (type === 'fd' || type === 'rd') {
                                if (atmCheck) { atmCheck.checked = false; atmCheck.disabled = true; }
                                if (chequeCheck) { chequeCheck.checked = false; chequeCheck.disabled = true; }
                                if (passbookCheck) { passbookCheck.checked = false; passbookCheck.disabled = true; }
                            } else {
                                if (atmCheck) atmCheck.disabled = false;
                                if (chequeCheck) chequeCheck.disabled = false;
                                if (passbookCheck) passbookCheck.disabled = false;
                            }

                            if (type === 'student') {
                                minAmt = 500;
                                noteText = "Minimum initial amount required is ₹500.00.";
                                if (studentSection) studentSection.style.display = 'block';
                                toggleSectionInputs('studentWorkflowSection', true);
                                setRequired('a4SchoolCollege', true);
                                setRequired('a4StudentId', true);
                                setRequired('a4Course', true);
                            }
                            else if (type === 'salary') {
                                minAmt = 0;
                                noteText = "Initial deposit is ₹0.00 (Zero Balance Salary Account).";
                                if (salarySection) salarySection.style.display = 'block';
                                toggleSectionInputs('salaryWorkflowSection', true);
                                setRequired('a4SalaryCompany', true);
                                setRequired('a4SalaryEmployer', true);
                                setRequired('a4SalaryEmpId', true);
                            }
                            else if (type === 'current') {
                                minAmt = 5000;
                                noteText = "Minimum initial amount required is ₹5,000.00.";
                                if (corporateSection) corporateSection.style.display = 'block';
                                if (nomineeSection) nomineeSection.style.display = 'none';

                                toggleSectionInputs('corporateWorkflowSection', true);
                                toggleSectionInputs('a4NomineeSection', false);

                                setRequired('a4NomineeName', false);
                                setRequired('a4NomineeRel', false);
                                setRequired('a4NomineeDob', false);
                                setRequired('a4NomineePhone', false);

                                setRequired('a4BusName', true);
                                setRequired('a4BusGst', true);
                                setRequired('a4BusPhone', true);
                                setRequired('a4BusRegNo', true);
                                setRequired('a4BusAddress', true);
                            }
                            else if (type === 'fd') {
                                minAmt = 10000;
                                noteText = "Minimum Fixed Deposit amount is ₹10,000.00.";
                                if (termSection) {
                                    termSection.style.display = 'block';
                                    toggleSectionInputs('termDepositWorkflowSection', true);
                                    document.getElementById('fdPayoutField').style.display = 'block';
                                    document.getElementById('fdRenewalCheckbox').style.display = 'flex';
                                    document.getElementById('rdDebitCheckbox').style.display = 'none';
                                }
                            }
                            else if (type === 'rd') {
                                minAmt = 1000;
                                noteText = "Minimum monthly installment is ₹1,000.00.";
                                if (termSection) {
                                    termSection.style.display = 'block';
                                    toggleSectionInputs('termDepositWorkflowSection', true);
                                    document.getElementById('fdPayoutField').style.display = 'none';
                                    document.getElementById('fdRenewalCheckbox').style.display = 'none';
                                    document.getElementById('rdDebitCheckbox').style.display = 'flex';
                                }
                            }

                            var initAmtInput = document.getElementById('a4InitialAmount');
                            if (initAmtInput) initAmtInput.value = minAmt.toFixed(2);
                            var minDepNote = document.getElementById('a4MinDepositNote');
                            if (minDepNote) minDepNote.textContent = noteText;

                            calculateMaturity();
                        } catch (err) {
                            console.error("Error in handleAccountTypeChange:", err);
                        }
                    }

                    // Stepper required attribute toggle helper
                    function setRequired(id, isReq) {
                        var elem = document.getElementById(id);
                        if (elem) {
                            if (isReq) {
                                elem.setAttribute('required', 'required');
                            } else {
                                elem.removeAttribute('required');
                            }
                        }
                    }

                    // Handle Holding Type Change
                    function handleHoldingTypeChange() {
                        try {
                            var holdTypeElem = document.getElementById('a4HoldingType');
                            if (!holdTypeElem) return;
                            var holdType = holdTypeElem.value;
                            var jointSec = document.getElementById('a4JointHolderSection');

                            if (holdType === 'joint') {
                                if (jointSec) jointSec.style.display = 'block';
                                toggleSectionInputs('a4JointHolderSection', true);
                                setRequired('a4JointName', true);
                                setRequired('a4JointRel', true);
                                setRequired('a4JointPhone', true);
                                setRequired('a4JointEmail', true);
                                setRequired('a4JointAadh', true);
                                setRequired('a4JointPan', true);
                            } else {
                                if (jointSec) jointSec.style.display = 'none';
                                toggleSectionInputs('a4JointHolderSection', false);
                                setRequired('a4JointName', false);
                                setRequired('a4JointRel', false);
                                setRequired('a4JointPhone', false);
                                setRequired('a4JointEmail', false);
                                setRequired('a4JointAadh', false);
                                setRequired('a4JointPan', false);
                            }
                        } catch (err) {
                            console.error("Error in handleHoldingTypeChange:", err);
                        }
                    }

                    // ATM Provider selection visual toggle
                    function toggleAtmCardSelection(checked) {
                        var el = document.getElementById('cardProviderSelection');
                        if (el) el.style.display = checked ? 'block' : 'none';
                    }

                    // Permanent Address same as Current Residential Address
                    function syncPermanentAddress(checked) {
                        var currentAddr = document.getElementById('a4Address');
                        var currentCity = document.getElementById('a4City');
                        var currentState = document.getElementById('a4State');
                        var currentZip = document.getElementById('a4Zip');

                        var permAddr = document.getElementById('a4PermAddress');
                        var permCity = document.getElementById('a4PermCity');
                        var permState = document.getElementById('a4PermState');
                        var permZip = document.getElementById('a4PermZip');

                        if (checked) {
                            if (permAddr && currentAddr) { permAddr.value = currentAddr.value; permAddr.readOnly = true; }
                            if (permCity && currentCity) { permCity.value = currentCity.value; permCity.readOnly = true; }
                            if (permState && currentState) { permState.value = currentState.value; permState.readOnly = true; }
                            if (permZip && currentZip) { permZip.value = currentZip.value; permZip.readOnly = true; }
                        } else {
                            if (permAddr) { permAddr.value = ""; permAddr.readOnly = false; }
                            if (permCity) { permCity.value = ""; permCity.readOnly = false; }
                            if (permState) { permState.value = ""; permState.readOnly = false; }
                            if (permZip) { permZip.value = ""; permZip.readOnly = false; }
                        }
                    }

                    // Real-time Upload Image Preview
                    function previewPhoto(input, previewBoxId) {
                        var box = document.getElementById(previewBoxId);
                        if (!box) return;

                        if (input.files && input.files[0]) {
                            var reader = new FileReader();
                            reader.onload = function (e) {
                                box.innerHTML = '<img src="' + e.target.result + '" alt="Avatar Preview" style="width: 100%; height: 100%; object-fit: cover;">';
                            };
                            reader.readAsDataURL(input.files[0]);
                        } else {
                            box.innerHTML = '<i class="bx bx-user" style="font-size: 3.5rem; color: #94a3b8;"></i>';
                        }
                    }

                    // Real-time Field Validators
                    function validateMobile(input) {
                        var err = document.getElementById('phoneError');
                        if (input.value.length !== 10 || isNaN(input.value)) {
                            if (err) err.style.display = 'block';
                        } else {
                            if (err) err.style.display = 'none';
                        }
                    }

                    function validateEmail(input) {
                        var err = document.getElementById('emailError');
                        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(input.value)) {
                            if (err) err.style.display = 'block';
                        } else {
                            if (err) err.style.display = 'none';
                        }
                    }

                    function validatePinStrength(input) {
                        var err = document.getElementById('pinError');
                        if (input.value.length !== 4 || isNaN(input.value)) {
                            if (err) err.style.display = 'block';
                        } else {
                            if (err) err.style.display = 'none';
                        }
                    }

                    function validatePasswordStrength(input) {
                        var err = document.getElementById('passwordError');
                        var pwRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                        if (!pwRegex.test(input.value)) {
                            if (err) err.style.display = 'block';
                        } else {
                            if (err) err.style.display = 'none';
                        }
                    }

                    // Auto-Save Form Draft to LocalStorage
                    function saveA4FormDraft() {
                        try {
                            var form = document.getElementById('createAccountForm');
                            if (!form) return;
                            var formData = {};
                            var inputs = form.querySelectorAll('input:not([type="file"]), select, textarea');
                            inputs.forEach(function (inp) {
                                if (inp.name) {
                                    formData[inp.name] = inp.value;
                                }
                            });
                            localStorage.setItem('vgb_a4_form_draft', JSON.stringify(formData));
                            alert("Application draft saved successfully in local storage.");
                        } catch (err) {
                            console.error("Error saving draft:", err);
                        }
                    }

                    // Load Form Draft from LocalStorage
                    function loadA4FormDraft() {
                        try {
                            var draft = localStorage.getItem('vgb_a4_form_draft');
                            if (draft) {
                                var formData = JSON.parse(draft);
                                var form = document.getElementById('createAccountForm');
                                if (!form) return;
                                for (var key in formData) {
                                    try {
                                        var inp = form.querySelector('[name="' + key + '"]');
                                        if (inp) {
                                            inp.value = formData[key];
                                        }
                                    } catch (selectorErr) {
                                        // Safe lookup
                                    }
                                }
                                // Trigger manual change to refresh view
                                handleAccountTypeChange();
                                handleDobChange();
                                handleHoldingTypeChange();
                            }
                        } catch (e) {
                            console.error("Error loading draft", e);
                        }
                    }

                    // Reset A4 Form
                    function resetA4Form() {
                        try {
                            var form = document.getElementById('createAccountForm');
                            if (form) form.reset();
                            localStorage.removeItem('vgb_a4_form_draft');

                            // Clear photo preview
                            var previewBox = document.getElementById('avatarPreviewBox');
                            if (previewBox) previewBox.innerHTML = '<i class="bx bx-user" style="font-size: 3.5rem; color: #94a3b8;"></i>';

                            openWizardModal();
                        } catch (err) {
                            console.error("Error resetting form:", err);
                        }
                    }



                    // ==========================================
                    // AJAX-BASED STATEMENT VIEW OVERLAY
                    // ==========================================
                    var statementTransactionsList = [];
                    var statementAccountId = 0;
                    var statementAccountBalance = 0;

                    function openStatementModal(accountId, customerName, accountNumber, accountType, totalBalance, status) {
                        statementAccountId = accountId;
                        statementAccountBalance = totalBalance;

                        var acc = accountsData.find(a => a.accountId === accountId);

                        // Set customer detail labels in statement layout
                        document.getElementById('lblStmtName').textContent = customerName.toUpperCase();
                        document.getElementById('lblStmtCustId').textContent = "#VGB-CUST-" + acc.customerId;
                        document.getElementById('lblStmtAccNum').textContent = "#" + accountNumber;
                        document.getElementById('lblStmtAccType').textContent = accountType;

                        var address = "";
                        if (acc.accountType === 'savings') {
                            address = (acc.primaryAddress || "") + ", " + (acc.primaryCity || "") + ", " + (acc.primaryState || "") + " - " + (acc.primaryZip || "");
                        } else {
                            address = acc.companyAddress || "";
                        }
                        document.getElementById('lblStmtAddress').textContent = address;
                        document.getElementById('lblStmtBalance').textContent = "₹ " + totalBalance.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

                        // Set print and screen labels
                        document.getElementById('lblStmtRef').textContent = "ACC-REF: #ACC-" + accountId;
                        var compiledDate = new Date();
                        var options = { month: 'long', day: 'numeric', year: 'numeric' };
                        var datePart = compiledDate.toLocaleDateString('en-US', options);
                        var timePart = compiledDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
                        document.getElementById('lblStmtDateGenerated').textContent = datePart + " at " + timePart;

                        // Reset filters
                        document.getElementById('stmtDateFilter').value = 'all';
                        document.getElementById('stmtTypeFilter').value = 'all';
                        document.getElementById('stmtCustomDateGroup').style.display = 'none';

                        // Show preloader
                        document.getElementById('statementTxnTbody').innerHTML = '<tr><td colspan="8" style="text-align:center; padding:30px; color:var(--gray-400);"><i class="bx bx-loader-alt bx-spin" style="font-size:2rem; display:block; margin-bottom:10px;"></i> Fetching ledger entries...</td></tr>';

                        openModal('statementModal');

                        // Fetch transaction logs via AJAX
                        var xhr = new XMLHttpRequest();
                        xhr.open('GET', '${pageContext.request.contextPath}/account?action=getTransactionsJson&accountId=' + accountId, true);
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState === 4) {
                                if (xhr.status === 200) {
                                    try {
                                        statementTransactionsList = JSON.parse(xhr.responseText);
                                        runStatementFilter();
                                    } catch (e) {
                                        console.error("Failed to parse JSON transaction log.", e);
                                        document.getElementById('statementTxnTbody').innerHTML = '<tr><td colspan="8" style="text-align:center; color:#ef4444; padding:30px;">Error parsing transactions list.</td></tr>';
                                    }
                                } else {
                                    document.getElementById('statementTxnTbody').innerHTML = '<tr><td colspan="8" style="text-align:center; color:#ef4444; padding:30px;">Failed to fetch transactions from server.</td></tr>';
                                }
                            }
                        };
                        xhr.send();
                    }

                    function runStatementFilter() {
                        var dateVal = document.getElementById('stmtDateFilter').value;
                        var typeVal = document.getElementById('stmtTypeFilter').value;

                        var customGroup = document.getElementById('stmtCustomDateGroup');
                        if (dateVal === 'custom') {
                            customGroup.style.display = 'block';
                        } else {
                            customGroup.style.display = 'none';
                        }

                        var tbody = document.getElementById('statementTxnTbody');
                        tbody.innerHTML = '';

                        var now = new Date();
                        var startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());

                        var startOfCurrentMonth = new Date(now.getFullYear(), now.getMonth(), 1);

                        // Last month boundaries
                        var startOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
                        var endOfLastMonth = new Date(now.getFullYear(), now.getMonth(), 0, 23, 59, 59, 999);

                        var startOfCurrentYear = new Date(now.getFullYear(), 0, 1);

                        let customStart = null;
                        let customEnd = null;
                        if (dateVal === 'custom') {
                            var sVal = document.getElementById('stmtStartDate').value;
                            var eVal = document.getElementById('stmtEndDate').value;
                            if (sVal) {
                                customStart = new Date(sVal);
                                customStart.setHours(0, 0, 0, 0);
                            }
                            if (eVal) {
                                customEnd = new Date(eVal);
                                customEnd.setHours(23, 59, 59, 999);
                            }
                        }

                        var filteredCount = 0;

                        for (var i = 0; i < statementTransactionsList.length; i++) {
                            var t = statementTransactionsList[i];

                            // Parse date & time
                            var dateStr = t.transactionDate.replace('T', ' ');
                            var txnDate = new Date(dateStr);

                            // 1. Filter Type check
                            var isCredit = t.transactionType === 'deposit' || t.transactionType === 'interest' || (t.transactionType === 'transfer' && t.toAccountId === statementAccountId);
                            var isDebit = t.transactionType === 'withdrawal' || t.transactionType === 'fee' || (t.transactionType === 'transfer' && t.fromAccountId === statementAccountId);

                            var typeMatches = true;
                            if (typeVal === 'received') {
                                typeMatches = isCredit;
                            } else if (typeVal === 'paid') {
                                typeMatches = isDebit;
                            }

                            // 2. Filter Date check
                            var dateMatches = true;
                            if (!isNaN(txnDate.getTime())) {
                                if (dateVal === 'current_month') {
                                    dateMatches = (txnDate >= startOfCurrentMonth);
                                } else if (dateVal === 'last_month') {
                                    dateMatches = (txnDate >= startOfLastMonth && txnDate <= endOfLastMonth);
                                } else if (dateVal === 'year') {
                                    dateMatches = (txnDate >= startOfCurrentYear);
                                } else if (dateVal === 'custom') {
                                    if (customStart && txnDate < customStart) dateMatches = false;
                                    if (customEnd && txnDate > customEnd) dateMatches = false;
                                }
                            }

                            if (typeMatches && dateMatches) {
                                filteredCount++;

                                var dateFormatted = txnDate.toLocaleDateString('en-GB');
                                var timeFormatted = txnDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' });

                                var amountClass = isCredit ? 'txn-deposit' : 'txn-withdrawal';

                                var detailsString = t.description;
                                if (t.referenceNumber) {
                                    detailsString += ' <small style="display:block; color:var(--gray-400); font-family:monospace;">Ref: ' + t.referenceNumber + '</small>';
                                }

                                var statusPill = '<span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">' + (t.status || 'COMPLETED').toUpperCase() + '</span>';

                                var creditVal = isCredit ? '+ ₹ ' + t.amount.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-';
                                var debitVal = isDebit ? '- ₹ ' + t.amount.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-';
                                var runningBalFormatted = t.runningBalance.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

                                var rowHtml = `
                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.85rem; color: var(--gray-700);">
                            <td style="padding: 14px 16px; font-weight:600; color:var(--gray-400);"><span class="badge-id">#\${filteredCount}</span></td>
                            <td style="padding: 14px 16px;">\${dateFormatted} \${timeFormatted}</td>
                            <td style="padding: 14px 16px; text-transform: capitalize; font-weight: 600;"><span class="\${amountClass}">\${t.transactionType}</span></td>
                            <td style="padding: 14px 16px;">\${detailsString}</td>
                            <td style="padding: 14px 16px;">\${statusPill}</td>
                            <td style="padding: 14px 16px; text-align:right; font-weight:700; color: #10b981;">\${creditVal}</td>
                            <td style="padding: 14px 16px; text-align:right; font-weight:700; color: #ef4444;">\${debitVal}</td>
                            <td style="padding: 14px 16px; text-align:right; font-weight:700; color: #1e3a8a; font-family: monospace;">₹ \${runningBalFormatted}</td>
                        </tr>
                    `;
                                tbody.insertAdjacentHTML('beforeend', rowHtml);
                            }
                        }

                        if (filteredCount === 0) {
                            tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:30px; color:var(--gray-400);">No transactions match selected filter queries.</td></tr>';
                        }
                    }

                    // Numbers to Words converter for Cheque
                    function numberToWords(num) {
                        var a = ['', 'One ', 'Two ', 'Three ', 'Four ', 'Five ', 'Six ', 'Seven ', 'Eight ', 'Nine ', 'Ten ', 'Eleven ', 'Twelve ', 'Thirteen ', 'Fourteen ', 'Fifteen ', 'Sixteen ', 'Seventeen ', 'Eighteen ', 'Nineteen '];
                        var b = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

                        if ((num = num.toString()).length > 9) return 'overflow';
                        var n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
                        if (!n) return '';
                        var str = '';
                        str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'Crore ' : '';
                        str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'Lakh ' : '';
                        str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'Thousand ' : '';
                        str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'Hundred ' : '';
                        str += (n[5] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) : '';
                        return str.trim();
                    }

                    // Toggle required documents guide panel
                    function toggleDocsGuide() {
                        var content = document.getElementById('docsGuideContent');
                        var arrow = document.getElementById('docsGuideArrow');
                        if (content.style.maxHeight === '0px' || !content.style.maxHeight) {
                            content.style.maxHeight = '1000px';
                            arrow.style.transform = 'rotate(180deg)';
                        } else {
                            content.style.maxHeight = '0px';
                            arrow.style.transform = 'rotate(0deg)';
                        }
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

                    // Toggle password and PIN visibility helper
                    function togglePassword(inputId, icon) {
                        var input = document.getElementById(inputId);
                        if (!input) return;
                        if (input.type === 'password') {
                            input.type = 'text';
                            icon.classList.remove('bx-show');
                            icon.classList.add('bx-hide');
                            icon.style.color = 'var(--primary-500)';
                        } else {
                            input.type = 'password';
                            icon.classList.remove('bx-hide');
                            icon.classList.add('bx-show');
                            icon.style.color = 'var(--gray-400)';
                        }
                    }
                </script>
            </body>

            </html>