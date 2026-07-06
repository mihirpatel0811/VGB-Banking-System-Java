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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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

        /* Print Media Overrides */
        @media print {
            body {
                background: white !important;
                color: black !important;
            }
            .sidebar, .header, .footer, .no-print, .modal-header, .modal-footer {
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
            }
            .modal-content {
                max-width: 100% !important;
                max-height: none !important;
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                background: white !important;
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
            background: repeating-linear-gradient(45deg, rgba(255,255,255,0.015) 0px, rgba(255,255,255,0.015) 1px, transparent 1px, transparent 8px), 
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
            body > *:not(#statementModal) {
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
            #statementTxnTable th, #statementTxnTable td {
                padding: 6px 4px !important;
                font-size: 10px !important;
                white-space: normal !important;
                word-wrap: break-word !important;
                word-break: break-word !important;
            }
            
            /* Column widths for standard portrait layout */
            #statementTxnTable th:nth-child(1), #statementTxnTable td:nth-child(1) { width: 5% !important; }
            #statementTxnTable th:nth-child(2), #statementTxnTable td:nth-child(2) { width: 16% !important; }
            #statementTxnTable th:nth-child(3), #statementTxnTable td:nth-child(3) { width: 8% !important; }
            #statementTxnTable th:nth-child(4), #statementTxnTable td:nth-child(4) { width: 27% !important; }
            #statementTxnTable th:nth-child(5), #statementTxnTable td:nth-child(5) { width: 8% !important; }
            #statementTxnTable th:nth-child(6), #statementTxnTable td:nth-child(6) { width: 12% !important; }
            #statementTxnTable th:nth-child(7), #statementTxnTable td:nth-child(7) { width: 12% !important; }
            #statementTxnTable th:nth-child(8), #statementTxnTable td:nth-child(8) { width: 12% !important; }

            .print-only {
                display: flex !important;
            }
            .badge-id, .txn-deposit, .txn-withdrawal, span[style*="background"] {
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
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Admin Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                <script>
                    (function() {
                        const avatar = localStorage.getItem('admin_avatar');
                        if (avatar) {
                            document.getElementById('adminHeaderAvatar').src = avatar;
                        }
                    })();
                </script>
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
    <aside class="sidebar no-print">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list" class="active"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">

            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="no-print">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Manage Accounts</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer records, issue and update corporate assets, and review statements.</p>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;" class="no-print">
                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;" class="no-print">
                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px;" class="no-print">
                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-group"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Total Customers</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalCustomers}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-cyan);">
                    <div class="stat-icon" style="background: rgba(6, 182, 212, 0.1); color: var(--accent-cyan);">
                        <i class="bx bx-user"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings (Single)</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalSavingsSingle}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-group-work"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings (Joint)</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalSavingsJoint}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-briefcase"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Accounts</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalCurrent}</strong>
                    </div>
                </div>
            </div>
            </div>
            
            <!-- Collapsible Required Documents Guide -->
            <div class="glass-card no-print" style="margin-bottom: 30px; padding: 20px 25px;">
                <div style="display: flex; justify-content: space-between; align-items: center; cursor: pointer;" onclick="toggleDocsGuide()">
                    <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin: 0;">
                        <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                        KYC & Required Documents Guide for Account Opening
                    </h4>
                    <i class="bx bx-chevron-down" id="docsGuideArrow" style="font-size: 1.5rem; color: var(--gray-500); transition: transform 0.3s ease;"></i>
                </div>
                
                <div id="docsGuideContent" style="max-height: 0px; overflow: hidden; transition: max-height 0.3s cubic-bezier(0, 1, 0, 1);">
                    <hr style="border: none; border-top: 1px solid var(--gray-100); margin: 15px 0;">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px;" class="mobile-grid-1">
                        <!-- Savings Accounts -->
                        <div style="background: rgba(99, 102, 241, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border);">
                            <h5 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-600); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                <i class="bx bx-user" style="font-size: 1.1rem;"></i> Retail Savings Account (Single & Joint)
                            </h5>
                            <ul style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                <li><strong>Proof of Identity (POI):</strong> Aadhaar Card, PAN Card, Voter ID, Passport, or Driving License.</li>
                                <li><strong>Proof of Address (POA):</strong> Aadhaar Card, Utility Bills (Electricity, Water, Gas) not older than 2 months, or Rent Agreement.</li>
                                <li><strong>Photographs:</strong> 1 recent passport-size photograph (uploaded dynamically in the wizard).</li>
                                <li><strong>Nominee KYC:</strong> Basic ID details and nominee relationship declaration (required for Savings Single).</li>
                                <li><strong>Joint Signatory Documents:</strong> Full POI, POA, and photos for *both* account holders (required for Savings Joint).</li>
                            </ul>
                        </div>
                        
                        <!-- Current Accounts -->
                        <div style="background: rgba(16, 185, 129, 0.02); padding: 18px; border-radius: var(--radius-md); border: 1.5px solid rgba(16, 185, 129, 0.1);">
                            <h5 style="font-size: 0.9rem; font-weight: 700; color: var(--accent-emerald); margin-bottom: 12px; display: flex; align-items: center; gap: 6px;">
                                <i class="bx bx-briefcase" style="font-size: 1.1rem;"></i> Commercial Current / Entity Account
                            </h5>
                            <ul style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; margin: 0; line-height: 1.7;">
                                <li><strong>Business Registration:</strong> Certificate of Incorporation, Partnership Deed, or Shops & Establishment Certificate.</li>
                                <li><strong>Tax Registration:</strong> GSTIN Certificate (minimum 15 characters) and Entity Permanent Account Number (PAN Card).</li>
                                <li><strong>Signatories & Partners KYC:</strong> Aadhaar Card, PAN Card, and photos for all active partners or signing authorities.</li>
                                <li><strong>Board Resolution / Mandate:</strong> Letter of Authority authorizing account operation and specifying signing power.</li>
                                <li><strong>Business Location Proof:</strong> Registered office rent/lease deed or corporate utility bill under entity's legal name.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Customer List Table Card -->
            <div class="glass-card">
                <div class="search-container no-print" style="display: flex; gap: 15px; align-items: center; margin-bottom: 25px; flex-wrap: wrap;">
                    <div class="search-box" style="flex: 2; min-width: 280px; position: relative;">
                        <i class="bx bx-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.2rem;"></i>
                        <input type="text" id="accountSearchInput" placeholder="Search customer ID, account number, or name..." onkeyup="filterAccountsTable()" style="width: 100%; padding: 12px 15px 12px 45px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: var(--white); color: var(--gray-800); transition: all var(--transition-normal);">
                    </div>
                    <div style="flex: 1; min-width: 160px;">
                        <select id="accountTypeFilter" onchange="filterAccountsTable()" class="form-group" style="padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); color: var(--gray-700); width: 100%; outline: none; transition: border-color 0.2s; font-size: 0.85rem; font-weight: 500; height: 48px;">
                            <option value="">All Account Types</option>
                            <option value="savings">Savings Account</option>
                            <option value="current">Current Account</option>
                        </select>
                    </div>
                    <div style="flex: 1; min-width: 160px;">
                        <select id="accountStatusFilter" onchange="filterAccountsTable()" class="form-group" style="padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--white); color: var(--gray-700); width: 100%; outline: none; transition: border-color 0.2s; font-size: 0.85rem; font-weight: 500; height: 48px;">
                            <option value="">All Statuses</option>
                            <option value="active">Active</option>
                            <option value="closed">Closed</option>
                        </select>
                    </div>
                    <button class="btn btn-primary" onclick="openWizardModal()" style="display: inline-flex; align-items: center; gap: 8px; height: 48px; border-radius: var(--radius-md); padding: 0 20px;">
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
                                        <tr class="account-row-data" data-account-type="${acc.accountType}" data-account-status="${acc.status}">
                                            <td style="font-weight: 600; color: var(--gray-500);">${status.index + 1}</td>
                                            <td><span class="badge-id td-cust-id">#CUST-${acc.customerId}</span></td>
                                            <td style="font-weight: 600; color: var(--gray-800);" class="td-cust-name">${acc.customerName}</td>
                                            <td><span class="badge-id td-acc-num">${acc.accountNumber}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${acc.accountType eq 'savings'}">
                                                        <span style="color: var(--primary-500); background: rgba(99, 102, 241, 0.1); padding: 4px 8px; border-radius: var(--radius-sm); font-weight: 600; font-size: 0.8rem;">Savings</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--accent-emerald); background: rgba(16, 185, 129, 0.1); padding: 4px 8px; border-radius: var(--radius-sm); font-weight: 600; font-size: 0.8rem;">Current</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right; font-weight: 700; color: var(--gray-800);">
                                                ₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2" />
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
                                                <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                    <button type="button" class="btn-action-circle btn-action-view" title="View Details" onclick="openViewModal(Number('${status.index}'))">
                                                        <i class="bx bx-show"></i>
                                                    </button>
                                                    <button type="button" class="btn-action-circle btn-action-edit" title="Edit Account" onclick="openEditModal(Number('${status.index}'))">
                                                        <i class="bx bx-edit"></i>
                                                    </button>
                                                    <c:if test="${acc.status ne 'closed'}">
                                                        <button type="button" class="btn-action-circle btn-action-block" title="Close Account" onclick="openCloseModal(Number('${status.index}'))">
                                                            <i class="bx bx-block"></i>
                                                        </button>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/account?action=delete&id=${acc.accountId}" class="btn-action-circle btn-action-delete" title="Delete Profile" onclick="return confirm('WARNING: Are you sure you want to delete account ${acc.accountNumber} and all associated signatories permanently?');">
                                                        <i class="bx bx-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 40px; color: var(--gray-400); font-style: italic;">
                                            <i class="bx bx-info-circle" style="font-size: 2.5rem; display: block; margin-bottom: 15px;"></i>
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
                <div class="modal-header" style="background: rgba(16, 185, 129, 0.05); border-bottom: 1px solid var(--gray-100);">
                    <h3 style="font-weight: 700; color: #047857; display: flex; align-items: center; gap: 8px; margin: 0;">
                        <i class="bx bx-check-circle" style="color: #10b981; font-size: 1.6rem;"></i> Bank Account Opened Successfully
                    </h3>
                    <button type="button" class="close-modal-btn" onclick="closeModal('newAccountSummaryModal')"><i class="bx bx-x"></i></button>
                </div>
                <div class="modal-body" style="padding: 25px;">
                    <div style="background: rgba(16, 185, 129, 0.05); border: 1px solid rgba(16, 185, 129, 0.2); border-radius: var(--radius-md); padding: 15px; margin-bottom: 20px; text-align: center;" class="no-print">
                        <span style="font-size: 0.85rem; color: #047857; font-weight: 600;">
                            The bank account has been successfully registered in the ledger. Please note down or print the customer credentials below.
                        </span>
                    </div>
                    
                    <div class="statement-print-area">
                        <!-- Header for print -->
                        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 10px; margin-bottom: 20px;">
                            <div>
                                <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--primary-500); letter-spacing: 0.5px; margin: 0; line-height: 1;">VERTEX GALAXY BANK</h2>
                                <p style="font-size: 0.75rem; color: var(--gray-500); margin: 3px 0 0; font-weight: 500;">Account Opening Credentials Summary</p>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-family: monospace; font-size: 0.8rem; color: var(--gray-500); font-weight: 700;">BRANCH: RAJKOT</span>
                            </div>
                        </div>

                        <!-- Summary Content -->
                        <h4 style="font-weight: 700; color: var(--gray-800); border-bottom: 1.5px solid var(--gray-100); padding-bottom: 5px; margin-bottom: 12px; font-size: 0.95rem;">
                            <i class="bx bx-wallet" style="color: var(--primary-500);"></i> Core Account Information
                        </h4>
                        <table style="width: 100%; font-size: 0.85rem; line-height: 1.8; margin-bottom: 20px;">
                            <tr>
                                <td style="color: var(--gray-500); width: 35%;">Account Number:</td>
                                <td style="font-weight: 800; font-family: monospace; color: var(--gray-800); font-size: 0.95rem;">${newAccountSummary.accountNumber}</td>
                            </tr>
                            <tr>
                                <td style="color: var(--gray-500);">IFSC Code:</td>
                                <td style="font-weight: 700; font-family: monospace;">${newAccountSummary.ifscCode}</td>
                            </tr>
                            <tr>
                                <td style="color: var(--gray-500);">Account Type:</td>
                                <td style="font-weight: 700; text-transform: uppercase;">${newAccountSummary.accountType} (${newAccountSummary.holdingType})</td>
                            </tr>
                            <tr>
                                <td style="color: var(--gray-500);">Initial Deposit:</td>
                                <td style="font-weight: 800; color: var(--accent-emerald);">₹ <fmt:formatNumber value="${newAccountSummary.initialAmount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                            </tr>
                            <tr style="border-top: 1px dashed var(--gray-200); padding-top: 5px; margin-top: 5px;">
                                <td style="color: var(--primary-500); font-weight: 700;">Secure ATM/Counter PIN:</td>
                                <td style="font-weight: 800; color: var(--primary-700); font-size: 1.1rem; letter-spacing: 2px; font-family: monospace;">${newAccountSummary.pin}</td>
                            </tr>
                        </table>

                        <h4 style="font-weight: 700; color: var(--gray-800); border-bottom: 1.5px solid var(--gray-100); padding-bottom: 5px; margin-bottom: 12px; font-size: 0.95rem;">
                            <i class="bx bx-key" style="color: var(--primary-500);"></i> Access Credentials
                        </h4>
                        
                        <c:choose>
                            <c:when test="${newAccountSummary.accountType eq 'savings'}">
                                <!-- Savings Account Credentials -->
                                <table style="width: 100%; font-size: 0.85rem; line-height: 1.8; margin-bottom: 20px;">
                                    <tr>
                                        <td style="color: var(--gray-500); width: 35%;">Primary Holder Name:</td>
                                        <td style="font-weight: 700; color: var(--gray-800);">${newAccountSummary.primaryName}</td>
                                    </tr>
                                    <tr>
                                        <td style="color: var(--gray-500);">Login Username:</td>
                                        <td style="font-weight: 700; font-family: monospace; color: var(--primary-600);">${newAccountSummary.primaryUsername}</td>
                                    </tr>
                                    <tr>
                                        <td style="color: var(--gray-500);">Login Password:</td>
                                        <td style="font-weight: 700; font-family: monospace;">${newAccountSummary.primaryPassword}</td>
                                    </tr>
                                    
                                    <c:if test="${newAccountSummary.holdingType eq 'joint'}">
                                        <tr style="border-top: 1px dashed var(--gray-100); padding-top: 10px; margin-top: 10px;">
                                            <td style="color: var(--gray-500);">Joint Holder Name:</td>
                                            <td style="font-weight: 700; color: var(--gray-800);">${newAccountSummary.jointName}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Login Username:</td>
                                            <td style="font-weight: 700; font-family: monospace; color: var(--primary-600);">${newAccountSummary.jointUsername}</td>
                                        </tr>
                                        <tr>
                                            <td style="color: var(--gray-500);">Login Password:</td>
                                            <td style="font-weight: 700; font-family: monospace;">${newAccountSummary.jointPassword}</td>
                                        </tr>
                                    </c:if>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <!-- Current Corporate Credentials -->
                                <table style="width: 100%; font-size: 0.85rem; line-height: 1.8; margin-bottom: 20px;">
                                    <tr>
                                        <td style="color: var(--gray-500); width: 35%;">Business Name:</td>
                                        <td style="font-weight: 700; color: var(--gray-800);">${newAccountSummary.businessName}</td>
                                    </tr>
                                    <tr>
                                        <td style="color: var(--gray-500);">GSTIN:</td>
                                        <td style="font-weight: 700; font-family: monospace;">${newAccountSummary.gstin}</td>
                                    </tr>
                                </table>
                                
                                <div style="margin-top: 10px; margin-bottom: 20px;">
                                    <span style="font-weight: 700; font-size: 0.8rem; color: var(--gray-600); display: block; margin-bottom: 8px;">Signatory / Partner Credentials:</span>
                                    <c:forEach var="partner" items="${newAccountSummary.partners}">
                                        <div style="margin-bottom: 10px; background: rgba(99, 102, 241, 0.02); border: 1.5px solid var(--gray-200); padding: 12px; border-radius: var(--radius-sm);">
                                            <div style="font-weight: 700; font-size: 0.8rem; color: var(--gray-800); margin-bottom: 4px;">${partner.name} (${partner.role})</div>
                                            <div style="display: flex; gap: 20px; font-size: 0.8rem;">
                                                <span><strong>Username:</strong> <code style="font-weight:700; color:var(--primary-600);">${partner.username}</code></span>
                                                <span><strong>Password:</strong> <code style="font-weight:700;">${partner.password}</code></span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <h4 style="font-weight: 700; color: var(--gray-800); border-bottom: 1.5px solid var(--gray-100); padding-bottom: 5px; margin-bottom: 12px; font-size: 0.95rem;">
                            <i class="bx bx-chip" style="color: var(--primary-500);"></i> Requested Instruments
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
                        
                        <div style="margin-top: 30px; text-align: center; font-size: 0.75rem; color: var(--gray-400); border-top: 1px dashed var(--gray-300); padding-top: 15px;" class="print-only">
                            This is a system generated secure credentials sheet. Please change your password and PIN upon first login.
                        </div>
                    </div>
                </div>
                <div class="modal-footer no-print">
                    <button type="button" class="btn btn-primary" onclick="window.print()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <i class="bx bx-printer"></i> Print Summary
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('newAccountSummaryModal')">Close</button>
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
                <h3 style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-user" style="color: var(--primary-500);"></i> Account Details Summary
                </h3>
                <button type="button" class="close-modal-btn" onclick="closeModal('viewAccountModal')"><i class="bx bx-x"></i></button>
            </div>
            <div class="modal-body" id="viewModalBody">
                <!-- Dynamically populated via JS -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('viewAccountModal')">Close</button>
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
                    <h3 style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                        <i class="bx bx-edit" style="color: var(--accent-cyan);"></i> Edit Account Parameters
                    </h3>
                    <button type="button" class="close-modal-btn" onclick="closeModal('editAccountModal')"><i class="bx bx-x"></i></button>
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

                    <div style="margin: 25px 0; background: rgba(99, 102, 241, 0.02); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border);">
                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px;">
                            <i class="bx bx-chip"></i> Enabled Services Options
                        </h4>
                        <div style="display:flex; gap:30px; flex-wrap:wrap;">
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                <input type="checkbox" name="atmCard" id="editAtmCard" value="on"> ATM Debit Card
                            </label>
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                <input type="checkbox" name="chequeBook" id="editChequeBook" value="on"> Cheque Book Request
                            </label>
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                <input type="checkbox" name="passbook" id="editPassbook" value="on"> Offline Passbook
                            </label>
                        </div>
                    </div>

                    <!-- Savings Specific Edit Controls -->
                    <div id="savingsEditFields" style="display:none;">
                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                            Savings Terms
                        </h4>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Nominee Name</label>
                                <input type="text" name="nomineeName" id="editNominee">
                            </div>
                            <div class="form-group">
                                <label>Holding Mode</label>
                                <select name="holdingType" id="editHoldingType" onchange="toggleEditHoldingType()">
                                    <option value="single">Single Owner</option>
                                    <option value="joint">Joint Account</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Daily Cash Limit (₹)</label>
                                <input type="number" step="0.01" name="dailyWithdrawalLimit" id="editDailyLimit">
                            </div>
                        </div>

                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-top:20px; margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
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

                        <!-- Joint Holder Edit Fields -->
                        <div id="jointCustomerEditFields" style="display:none; margin-top:20px;">
                            <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
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
                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
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
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editAccountModal')">Cancel</button>
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
                <div style="background: rgba(239, 68, 68, 0.08); border-left: 4px solid #ef4444; color: #b91c1c; padding: 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.9rem;">
                    <h4 style="font-weight:700; margin-bottom:5px;"><i class="bx bx-error-circle"></i> Warning</h4>
                    <span>Are you sure you want to close this account? This will mark the ledger status as closed and restrict future operations. This action cannot be undone.</span>
                </div>

                <table style="width:100%; font-size:0.9rem; line-height:2.0; border-collapse:collapse;">
                    <tr>
                        <td style="color:var(--gray-500); width:40%; padding: 8px 0;">Account Number:</td>
                        <td style="font-weight:700; font-family:monospace; color:var(--gray-800);" id="closeAccNum">-</td>
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
                        <td style="font-weight:800; color:#ef4444; font-size:1.1rem;" id="closeBalance">-</td>
                    </tr>
                    <tr>
                        <td style="color:var(--gray-500); padding: 8px 0;">Current Ledger Status:</td>
                        <td style="font-weight:700; text-transform:uppercase;" id="closeStatus">-</td>
                    </tr>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('closeAccountModal')">Cancel</button>
                <button type="button" class="btn btn-danger" onclick="confirmCloseAccount()">Confirm Close Account</button>
            </div>
        </div>
    </div>

    <!-- ==========================================
         CREATE NEW ACCOUNT WIZARD MODAL
         ========================================== -->
    <div class="modal" id="createAccountModal">
        <div class="modal-content modal-large">
            <form action="${pageContext.request.contextPath}/account?action=create&csrfToken=${sessionScope.csrfToken}" method="POST" id="createAccountForm" enctype="multipart/form-data" onsubmit="return validateA4FormSubmit()">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                <div class="a4-container">
                    
                    <!-- OFFICE USE ONLY SECTION -->
                    <div class="office-use-box no-print">
                        <h5 style="font-size: 0.72rem; font-weight: 800; color: #475569; text-transform: uppercase; margin-bottom: 10px; display: flex; align-items: center; gap: 6px;">
                            <i class="bx bx-lock" style="font-size: 0.9rem;"></i> For Office Use Only
                        </h5>
                        <div class="office-use-grid">
                            <div class="office-use-item"><label>Customer ID</label><span>Auto-Gen</span></div>
                            <div class="office-use-item"><label>CIF Number</label><span>Auto-Gen</span></div>
                            <div class="office-use-item"><label>Account No.</label><span>Auto-Gen</span></div>
                            <div class="office-use-item"><label>Application ID</label><span>VGB-2026-T</span></div>
                            <div class="office-use-item"><label>Branch Name</label><span>Galaxy Main</span></div>
                            <div class="office-use-item"><label>Branch Code</label><span>VGB001</span></div>
                            <div class="office-use-item"><label>IFSC Code</label><span>VGBB0000001</span></div>
                            <div class="office-use-item"><label>App Date</label><span id="officeAppDate">-</span></div>
                        </div>
                    </div>

                    <!-- PREMIUM HEADER -->
                    <div style="text-align: center; margin-bottom: 30px; border-bottom: 3px double #e2e8f0; padding-bottom: 25px; position: relative;">
                        <div style="display: flex; justify-content: center; align-items: center; gap: 15px; margin-bottom: 12px;">
                            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; object-fit: contain;">
                            <h2 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-600); letter-spacing: 2px; margin: 0;">VERTEX GALAXY BANK</h2>
                        </div>
                        <h3 style="font-size: 1.15rem; font-weight: 700; color: #334155; text-transform: uppercase; letter-spacing: 1.5px; margin: 0 0 5px 0;">Account Opening Application Form</h3>
                        <p style="font-size: 0.85rem; font-weight: 600; color: #64748b; margin: 0 0 8px 0; text-transform: uppercase; letter-spacing: 1px;">For Individual Customers</p>
                        <span style="font-size: 0.72rem; font-style: italic; color: var(--primary-500); font-weight: 700; letter-spacing: 0.5px;">"Your Future. Your Trust. Your Bank."</span>
                    </div>

                    <!-- SECTION A – ACCOUNT INFORMATION -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-info-circle"></i> Section A – Account Information
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Branch *</label>
                                <input type="text" name="branch" value="Galaxy Main" readonly style="background: #f1f5f9;">
                            </div>
                            <div class="a4-form-group">
                                <label>Branch Code</label>
                                <input type="text" name="branchCode" value="VGB001" readonly style="background: #f1f5f9;">
                            </div>
                            <div class="a4-form-group">
                                <label>IFSC Code</label>
                                <input type="text" name="ifscCode" value="VGBB0000001" readonly style="background: #f1f5f9;">
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Account Type *</label>
                                <select name="accountType" id="a4AccountType" onchange="handleAccountTypeChange()" required>
                                    <option value="savings">Savings Account</option>
                                    <option value="current">Current Account</option>
                                    <option value="salary">Salary Account</option>
                                    <option value="student">Student Account</option>
                                    <option value="fd">Fixed Deposit (FD)</option>
                                    <option value="rd">Recurring Deposit (RD)</option>
                                </select>
                            </div>
                            <div class="a4-form-group">
                                <label>Currency</label>
                                <input type="text" name="currency" value="INR (₹)" readonly style="background: #f1f5f9;">
                            </div>
                            <div class="a4-form-group">
                                <label>Initial Deposit Amount (₹) *</label>
                                <input type="number" step="0.01" name="initialAmount" id="a4InitialAmount" value="1000.00" onkeyup="validateA4InitialAmount()">
                                <small style="color: var(--primary-500); font-weight: 700; font-size: 0.72rem; margin-top: 4px;" id="a4MinDepositNote">Minimum initial amount required is ₹1,000.00.</small>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Customer Type *</label>
                                <select name="holdingType" id="a4HoldingType" onchange="handleHoldingTypeChange()" required>
                                    <option value="single">Individual (Single)</option>
                                    <option value="joint">Joint Account Holder</option>
                                </select>
                            </div>
                        </div>
                        <div class="a4-form-row" style="margin-top: 15px; border-top: 1px dashed #e2e8f0; padding-top: 15px;">
                            <div class="a4-form-group">
                                <label>Internet Banking Requested?</label>
                                <div class="a4-radio-group">
                                    <label class="a4-radio-label"><input type="radio" name="internetBanking" value="yes" checked> Yes</label>
                                    <label class="a4-radio-label"><input type="radio" name="internetBanking" value="no"> No</label>
                                </div>
                            </div>
                            <div class="a4-form-group">
                                <label>Mobile Banking Requested?</label>
                                <div class="a4-radio-group">
                                    <label class="a4-radio-label"><input type="radio" name="mobileBanking" value="yes" checked> Yes</label>
                                    <label class="a4-radio-label"><input type="radio" name="mobileBanking" value="no"> No</label>
                                </div>
                            </div>
                            <div class="a4-form-group">
                                <label>SMS Alerts Requested?</label>
                                <div class="a4-radio-group">
                                    <label class="a4-radio-label"><input type="radio" name="smsAlerts" value="yes" checked> Yes</label>
                                    <label class="a4-radio-label"><input type="radio" name="smsAlerts" value="no"> No</label>
                                </div>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>ATM / Debit Card Requested?</label>
                                <div class="a4-radio-group">
                                    <label class="a4-radio-label"><input type="radio" name="atmCard" value="yes" checked> Yes</label>
                                    <label class="a4-radio-label"><input type="radio" name="atmCard" value="no"> No</label>
                                </div>
                            </div>
                            <div class="a4-form-group">
                                <label>Cheque Book Requested?</label>
                                <div class="a4-radio-group">
                                    <label class="a4-radio-label"><input type="radio" name="chequeBook" value="yes" checked> Yes</label>
                                    <label class="a4-radio-label"><input type="radio" name="chequeBook" value="no"> No</label>
                                </div>
                            </div>
                            <div class="a4-form-group">
                                <label>Offline Passbook Booklet?</label>
                                <div class="a4-radio-group">
                                    <label class="a4-radio-label"><input type="radio" name="passbook" value="yes" checked> Yes</label>
                                    <label class="a4-radio-label"><input type="radio" name="passbook" value="no"> No</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION B – PERSONAL DETAILS -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-user"></i> Section B – Personal Details
                        </div>
                        <div style="display: flex; gap: 20px; align-items: flex-start;" class="mobile-grid-1">
                            <div style="flex-grow: 1;">
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
                            <div class="a4-photo-upload no-print">
                                <i class="bx bx-camera"></i>
                                <span>Upload Photo *</span>
                                <input type="file" name="primaryAvatar" accept="image/*">
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Date of Birth *</label>
                                <input type="date" name="dob" id="a4Dob" required>
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
                                <input type="text" name="nationality" value="Indian" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Occupation *</label>
                                <input type="text" name="occupation" placeholder="e.g. Salaried, Self-Employed" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Annual Income (₹) *</label>
                                <input type="number" name="income" value="300000" required>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION C – CONTACT INFORMATION -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-phone"></i> Section C – Contact Information
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Mobile Number *</label>
                                <input type="tel" name="phone" id="a4Phone" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Alternate Number</label>
                                <input type="tel" name="altPhone">
                            </div>
                            <div class="a4-form-group">
                                <label>Email Address *</label>
                                <input type="email" name="email" id="a4Email" required>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Emergency Contact Name *</label>
                                <input type="text" name="emergencyContact" placeholder="Full name of contact" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Emergency Contact Phone *</label>
                                <input type="tel" name="emergencyPhone" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Relationship *</label>
                                <input type="text" name="emergencyRelationship" placeholder="e.g. Spouse, Parent" required>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION D – ADDRESS INFORMATION -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-map"></i> Section D – Address Information
                        </div>
                        
                        <!-- Current Address Card -->
                        <div style="background: #f8fafc; padding: 15px; border-radius: var(--radius-sm); border: 1px solid #e2e8f0; margin-bottom: 20px;">
                            <h5 style="font-size: 0.85rem; font-weight: 700; color: #334155; margin-bottom: 12px;">Current Residential Address</h5>
                            <div class="a4-form-row">
                                <div class="a4-form-group" style="grid-column: span 2;">
                                    <label>Address Line 1 *</label>
                                    <input type="text" name="address" id="a4Address" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>Address Line 2</label>
                                    <input type="text" name="address2">
                                </div>
                            </div>
                            <div class="a4-form-row">
                                <div class="a4-form-group">
                                    <label>City *</label>
                                    <input type="text" name="city" id="a4City" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>District *</label>
                                    <input type="text" name="district" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>State *</label>
                                    <input type="text" name="state" id="a4State" required>
                                </div>
                            </div>
                            <div class="a4-form-row">
                                <div class="a4-form-group">
                                    <label>Country *</label>
                                    <input type="text" name="country" value="India" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>PIN Code *</label>
                                    <input type="text" name="zip" id="a4Zip" required>
                                </div>
                            </div>
                        </div>

                        <!-- Permanent Address Card -->
                        <div style="background: #f8fafc; padding: 15px; border-radius: var(--radius-sm); border: 1px solid #e2e8f0;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                <h5 style="font-size: 0.85rem; font-weight: 700; color: #334155;">Permanent Address</h5>
                                <label style="display: flex; align-items: center; gap: 6px; font-size: 0.78rem; font-weight: 600; color: var(--primary-600); cursor: pointer;" class="no-print">
                                    <input type="checkbox" id="a4SameAddress" onchange="syncPermanentAddress(this.checked)"> Same as Current Address
                                </label>
                            </div>
                            <div class="a4-form-row">
                                <div class="a4-form-group" style="grid-column: span 2;">
                                    <label>Address Line 1 *</label>
                                    <input type="text" name="permAddress" id="a4PermAddress" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>Address Line 2</label>
                                    <input type="text" name="permAddress2" id="a4PermAddress2">
                                </div>
                            </div>
                            <div class="a4-form-row">
                                <div class="a4-form-group">
                                    <label>City *</label>
                                    <input type="text" name="permCity" id="a4PermCity" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>District *</label>
                                    <input type="text" name="permDistrict" id="a4PermDistrict" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>State *</label>
                                    <input type="text" name="permState" id="a4PermState" required>
                                </div>
                            </div>
                            <div class="a4-form-row">
                                <div class="a4-form-group">
                                    <label>Country *</label>
                                    <input type="text" name="permCountry" id="a4PermCountry" value="India" required>
                                </div>
                                <div class="a4-form-group">
                                    <label>PIN Code *</label>
                                    <input type="text" name="permZip" id="a4PermZip" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION E – KYC DETAILS -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-check-shield"></i> Section E – KYC Verification Details
                        </div>
                        <p style="font-size: 0.72rem; color: #64748b; margin-top: -10px; margin-bottom: 15px;">Please provide legal documentation details. Attach copies of verification documents beside each field.</p>
                        
                        <div class="a4-form-row" style="align-items: center;">
                            <div class="a4-form-group" style="flex: 2;">
                                <label>Aadhaar Card Number * (12 Digits)</label>
                                <input type="text" name="aadhaar" id="a4Aadhaar" placeholder="Enter Aadhaar Number" required>
                            </div>
                            <div class="a4-form-group" style="flex: 1;" class="no-print">
                                <label>Aadhaar Proof Card</label>
                                <input type="file" name="aadhaarFile">
                            </div>
                        </div>

                        <div class="a4-form-row" style="align-items: center; margin-top: 10px;">
                            <div class="a4-form-group" style="flex: 2;">
                                <label>PAN Card Number * (10 Alpha-Numeric)</label>
                                <input type="text" name="pan" id="a4Pan" placeholder="Enter PAN Number" required>
                            </div>
                            <div class="a4-form-group" style="flex: 1;" class="no-print">
                                <label>PAN Card Proof</label>
                                <input type="file" name="panFile">
                            </div>
                        </div>

                        <div class="a4-form-row" style="align-items: center; margin-top: 10px;">
                            <div class="a4-form-group" style="flex: 2;">
                                <label>Passport Number (Optional)</label>
                                <input type="text" name="passportNo" placeholder="Passport Number">
                            </div>
                            <div class="a4-form-group" style="flex: 1;" class="no-print">
                                <label>Passport Copy</label>
                                <input type="file" name="passportFile">
                            </div>
                        </div>

                        <div class="a4-form-row" style="align-items: center; margin-top: 10px;">
                            <div class="a4-form-group" style="flex: 2;">
                                <label>Driving License No. (Optional)</label>
                                <input type="text" name="dlNo" placeholder="DL Number">
                            </div>
                            <div class="a4-form-group" style="flex: 1;" class="no-print">
                                <label>Driving License Copy</label>
                                <input type="file" name="dlFile">
                            </div>
                        </div>

                        <div class="a4-form-row" style="align-items: center; margin-top: 10px;">
                            <div class="a4-form-group" style="flex: 2;">
                                <label>Voter Identity Card (Optional)</label>
                                <input type="text" name="voterNo" placeholder="Voter Card ID">
                            </div>
                            <div class="a4-form-group" style="flex: 1;" class="no-print">
                                <label>Voter ID Card Copy</label>
                                <input type="file" name="voterFile">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION F – LOGIN CREDENTIALS -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-key"></i> Section F – E-Banking Login Credentials
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Banking Username *</label>
                                <input type="text" name="username" id="a4Username" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Account Password *</label>
                                <input type="password" name="password" id="a4Password" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Confirm Password *</label>
                                <input type="password" id="a4ConfirmPassword" required>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>4-Digit Secure PIN *</label>
                                <input type="password" name="pin" id="a4Pin" maxlength="4" placeholder="••••" required style="font-family: monospace; text-align: center; font-size: 1.1rem; letter-spacing: 4px;">
                            </div>
                            <div class="a4-form-group">
                                <label>Security Question *</label>
                                <select name="securityQuestion">
                                    <option value="pet">What was the name of your first pet?</option>
                                    <option value="city">In which city were you born?</option>
                                    <option value="school">What was the name of your primary school?</option>
                                </select>
                            </div>
                            <div class="a4-form-group">
                                <label>Security Answer *</label>
                                <input type="text" name="securityAnswer" required>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION G – NOMINEE DETAILS -->
                    <div class="a4-section-card" id="a4NomineeSection">
                        <div class="a4-section-title">
                            <i class="bx bx-user-voice"></i> Section G – Nominee Details
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Nominee Name *</label>
                                <input type="text" name="nomineeName" id="a4NomineeName" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Relationship to Holder *</label>
                                <input type="text" name="nomineeRelationship" id="a4NomineeRel" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Date of Birth *</label>
                                <input type="date" name="nomineeDob" id="a4NomineeDob" required>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Mobile Number *</label>
                                <input type="tel" name="nomineePhone" id="a4NomineePhone" required>
                            </div>
                            <div class="a4-form-group">
                                <label>Aadhaar Card No. *</label>
                                <input type="text" name="nomineeAadhaar" id="a4NomineeAadh" required>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group" style="grid-column: span 3;">
                                <label>Address *</label>
                                <input type="text" name="nomineeAddress" id="a4NomineeAddr" required>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION H – JOINT ACCOUNT HOLDER -->
                    <div class="a4-section-card" id="a4JointHolderSection" style="display: none;">
                        <div class="a4-section-title">
                            <i class="bx bx-group"></i> Section H – Joint Account Holder Details
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Full Name *</label>
                                <input type="text" name="joint_firstName" id="a4JointName">
                            </div>
                            <div class="a4-form-group">
                                <label>Relationship to Primary *</label>
                                <input type="text" name="joint_relationship" id="a4JointRel">
                            </div>
                            <div class="a4-form-group">
                                <label>Mobile Number *</label>
                                <input type="tel" name="joint_phone" id="a4JointPhone">
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Email Address *</label>
                                <input type="email" name="joint_email" id="a4JointEmail">
                            </div>
                            <div class="a4-form-group">
                                <label>Aadhaar Number *</label>
                                <input type="text" name="joint_aadhaar" id="a4JointAadh">
                            </div>
                            <div class="a4-form-group">
                                <label>PAN Card Number *</label>
                                <input type="text" name="joint_pan" id="a4JointPan">
                            </div>
                        </div>
                        <div class="a4-form-row" style="margin-top: 15px; border-top: 1.5px dashed #e2e8f0; padding-top: 15px;">
                            <div class="a4-form-group">
                                <label>Upload Joint Holder Photograph</label>
                                <input type="file" name="jointAvatar">
                            </div>
                            <div class="a4-form-group">
                                <label>Joint Holder Signature Proof</label>
                                <input type="file" name="jointSignatureFile">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION I – SAVINGS ACCOUNT DETAILS -->
                    <div class="a4-section-card" id="a4SavingsDetailsCard">
                        <div class="a4-section-title">
                            <i class="bx bx-percentage"></i> Section I – Savings Account Terms
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>Interest Rate (p.a.)</label>
                                <input type="text" value="4.00 %" readonly style="background: #f1f5f9; font-weight: 700;">
                            </div>
                            <div class="a4-form-group">
                                <label>Minimum Balance Requirement</label>
                                <input type="text" value="₹ 1,000.00" readonly style="background: #f1f5f9; font-weight: 700;">
                            </div>
                            <div class="a4-form-group">
                                <label>Interest Calculation Frequency</label>
                                <input type="text" value="Quarterly Accrual" readonly style="background: #f1f5f9; font-weight: 700;">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION J – CURRENT ACCOUNT DETAILS -->
                    <div class="a4-section-card" id="a4CurrentDetailsCard" style="display: none;">
                        <div class="a4-section-title">
                            <i class="bx bx-briefcase-alt-2"></i> Section J – Current Account Terms & Entity Details
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group" style="grid-column: span 2;">
                                <label>Business Legal Name *</label>
                                <input type="text" name="businessName" id="a4BusName" placeholder="Enter Business Legal Name">
                            </div>
                            <div class="a4-form-group">
                                <label>Business Type / Constitution *</label>
                                <select name="companyCategory" id="a4BusCategory">
                                    <option value="proprietorship">Sole Proprietorship</option>
                                    <option value="partnership">Partnership Firm</option>
                                    <option value="private_limited">Private Limited Company</option>
                                    <option value="public_limited">Public Limited Company</option>
                                </select>
                            </div>
                        </div>
                        <div class="a4-form-row">
                            <div class="a4-form-group">
                                <label>GST Registration Number * (15 Characters)</label>
                                <input type="text" name="gstin" id="a4BusGst" placeholder="Enter 15-digit GSTIN">
                            </div>
                            <div class="a4-form-group">
                                <label>Business Registration / Incorporation No. *</label>
                                <input type="text" name="businessRegNo" id="a4BusRegNo" placeholder="Enter Incorporation Certificate Number">
                            </div>
                            <div class="a4-form-group">
                                <label>Minimum Balance Requirement</label>
                                <input type="text" value="₹ 5,000.00" readonly style="background: #f1f5f9; font-weight: 700;">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION K – DOCUMENT CHECKLIST -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-checkbox-checked"></i> Section K – Attached Document Checklist
                        </div>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                            <label style="display: flex; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">
                                <input type="checkbox" name="checklist_photo" checked> Passport Size Photograph
                            </label>
                            <label style="display: flex; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">
                                <input type="checkbox" name="checklist_aadhaar" checked> Aadhaar Card (Copy)
                            </label>
                            <label style="display: flex; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">
                                <input type="checkbox" name="checklist_pan" checked> PAN Card (Copy)
                            </label>
                            <label style="display: flex; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">
                                <input type="checkbox" name="checklist_address" checked> Residential Address Proof
                            </label>
                            <label style="display: flex; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">
                                <input type="checkbox" name="checklist_income"> Income Proof / Salary Slips
                            </label>
                            <label style="display: flex; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;">
                                <input type="checkbox" name="checklist_signature" checked> Signature Verification Proof
                            </label>
                            <label style="display: none; gap: 8px; cursor: pointer; font-size: 0.8rem; font-weight: 600;" id="a4ChecklistBusLabel">
                                <input type="checkbox" name="checklist_business"> Business Registration Certificate
                            </label>
                        </div>
                    </div>

                    <!-- SECTION L – DECLARATION -->
                    <div class="a4-section-card">
                        <div class="a4-section-title">
                            <i class="bx bx-check-square"></i> Section L – Declaration & Agreement
                        </div>
                        <p style="font-size: 0.82rem; line-height: 1.6; text-align: justify; color: #475569; margin: 0 0 25px 0;">
                            I/We hereby declare that all details, certificates, and address validations provided above are true, complete, and correct to the best of my/our knowledge. I/We understand and agree that any false, misleading, or incorrect statement will result in the immediate closure of this bank ledger account. I/We declare that I/we have read, understood, and agreed to be bound by the Terms and Conditions of Vertex Galaxy Bank governing ledger operations, minimum balances, charge regimes, and online transactions.
                        </p>
                        
                        <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; margin-top: 30px;" class="mobile-grid-1">
                            <div>
                                <div class="a4-form-row">
                                    <div class="a4-form-group">
                                        <label>Place *</label>
                                        <input type="text" name="place" id="a4Place" value="Galaxy City" required>
                                    </div>
                                    <div class="a4-form-group">
                                        <label>Date *</label>
                                        <input type="date" name="applicationDate" id="a4AppDate" required>
                                    </div>
                                </div>
                            </div>
                            <div style="display: flex; flex-direction: column; justify-content: flex-end; align-items: center; border-left: 1.5px dashed #cbd5e1; padding-left: 20px;">
                                <div style="width: 100%; border-bottom: 1.5px solid #1e293b; height: 50px;"></div>
                                <span style="font-size: 0.72rem; font-weight: 700; color: #475569; text-transform: uppercase; margin-top: 8px;">Applicant Signature</span>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 30px; margin-top: 40px; border-top: 1.5px dashed #e2e8f0; padding-top: 25px;" class="mobile-grid-1">
                            <div style="display: flex; flex-direction: column; justify-content: flex-end;">
                                <div style="width: 80%; border-bottom: 1px solid #94a3b8; height: 35px;"></div>
                                <span style="font-size: 0.68rem; font-weight: 700; color: #64748b; text-transform: uppercase; margin-top: 6px;">Bank Verifying Official Signature</span>
                            </div>
                            <div style="border: 1px solid #cbd5e1; border-radius: var(--radius-sm); height: 110px; display: flex; align-items: center; justify-content: center; background: #fafafa; border-style: dotted;">
                                <span style="font-size: 0.65rem; color: #94a3b8; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Galaxy Branch Stamp</span>
                            </div>
                        </div>
                    </div>

                    <!-- SYSTEM GENERATED INFORMATION -->
                    <div style="border: 1px solid #e2e8f0; border-radius: var(--radius-sm); padding: 15px; margin-bottom: 25px; background: #fafafa;">
                        <h6 style="font-size: 0.7rem; font-weight: 800; color: #64748b; text-transform: uppercase; margin: 0 0 10px 0;">System Generated Information (Database Sync)</h6>
                        <table style="width: 100%; border-collapse: collapse; font-size: 0.72rem; line-height: 1.8;">
                            <tr style="border-bottom: 1px solid #e2e8f0;">
                                <td style="color: #64748b; font-weight: 600; width: 25%;">Customer ID:</td>
                                <td style="font-weight: 700; color: #1e293b;">[PENDING AUTO-GENERATION]</td>
                                <td style="color: #64748b; font-weight: 600; width: 25%;">CIF Number:</td>
                                <td style="font-weight: 700; color: #1e293b;">[PENDING AUTO-GENERATION]</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e2e8f0;">
                                <td style="color: #64748b; font-weight: 600;">Account Number:</td>
                                <td style="font-weight: 700; color: #1e293b;">[PENDING AUTO-GENERATION]</td>
                                <td style="color: #64748b; font-weight: 600;">Account Status:</td>
                                <td style="font-weight: 700; color: #10b981; text-transform: uppercase;">ACTIVE</td>
                            </tr>
                            <tr style="border-bottom: 1px solid #e2e8f0;">
                                <td style="color: #64748b; font-weight: 600;">KYC Status:</td>
                                <td style="font-weight: 700; color: #3b82f6; text-transform: uppercase;">VERIFIED & APPROVED</td>
                                <td style="color: #64748b; font-weight: 600;">ATM Card Number:</td>
                                <td style="font-weight: 700; color: #1e293b;">[AUTO-GENERATED UPON APPROVAL]</td>
                            </tr>
                            <tr>
                                <td style="color: #64748b; font-weight: 600;">Passbook Booklet Number:</td>
                                <td style="font-weight: 700; color: #1e293b;">[AUTO-GENERATED ON PRINT]</td>
                                <td style="color: #64748b; font-weight: 600;">Created Date:</td>
                                <td style="font-weight: 700; color: #1e293b;" id="systemCreatedDate">-</td>
                            </tr>
                        </table>
                    </div>

                    <!-- FIVE ACTION BUTTONS (FOOTER) -->
                    <div style="display: flex; gap: 10px; justify-content: space-between; flex-wrap: wrap; margin-top: 30px;" class="no-print">
                        <button type="submit" class="btn btn-success" style="background: #10b981; color: white; border: none; font-weight: 700; padding: 12px 20px; border-radius: var(--radius-md); font-size: 0.85rem; cursor: pointer; flex-grow: 1; transition: background 0.2s;">
                            <i class="bx bx-check-circle"></i> Submit Application
                        </button>
                        <button type="button" onclick="saveA4FormDraft()" class="btn btn-primary" style="background: #3b82f6; color: white; border: none; font-weight: 700; padding: 12px 20px; border-radius: var(--radius-md); font-size: 0.85rem; cursor: pointer; flex-grow: 1; transition: background 0.2s;">
                            <i class="bx bx-save"></i> Save as Draft
                        </button>
                        <button type="button" onclick="window.print()" class="btn" style="background: #8b5cf6; color: white; border: none; font-weight: 700; padding: 12px 20px; border-radius: var(--radius-md); font-size: 0.85rem; cursor: pointer; flex-grow: 1; transition: background 0.2s;">
                            <i class="bx bx-printer"></i> Print Application
                        </button>
                        <button type="button" onclick="resetA4Form()" class="btn" style="background: #f97316; color: white; border: none; font-weight: 700; padding: 12px 20px; border-radius: var(--radius-md); font-size: 0.85rem; cursor: pointer; flex-grow: 1; transition: background 0.2s;">
                            <i class="bx bx-refresh"></i> Reset
                        </button>
                        <button type="button" onclick="closeModal('createAccountModal')" class="btn" style="background: #ef4444; color: white; border: none; font-weight: 700; padding: 12px 20px; border-radius: var(--radius-md); font-size: 0.85rem; cursor: pointer; flex-grow: 1; transition: background 0.2s;">
                            <i class="bx bx-x"></i> Cancel
                        </button>
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
            <div class="modal-header no-print" style="padding: 20px 30px; border-bottom: 1px solid var(--gray-100);">
                <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--gray-900); display: flex; align-items: center; gap: 10px; margin: 0;">
                    <i class="bx bx-file" style="color: var(--primary-500);"></i> Vertex Galaxy Bank Account Statement
                </h3>
                <button type="button" class="close-modal-btn" onclick="closeModal('statementModal')" style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none;"><i class="bx bx-x"></i></button>
            </div>
            <div class="modal-body" style="padding: 30px;">
                <!-- FILTERS BLOCK -->
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom:25px;" class="no-print">
                    <div>
                        <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Date Filter Range</label>
                        <select id="stmtDateFilter" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                            <option value="all">All Available ledger</option>
                            <option value="current_month">Current Month</option>
                            <option value="last_month">Last Month</option>
                            <option value="year">Current Financial Year</option>
                            <option value="custom">Custom Date Range...</option>
                        </select>
                    </div>
                    <div>
                        <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Transaction Type</label>
                        <select id="stmtTypeFilter" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                            <option value="all">All Transactions</option>
                            <option value="received">Received / Credits</option>
                            <option value="paid">Paid / Debits</option>
                        </select>
                    </div>
                </div>

                <!-- Custom Dates group -->
                <div id="stmtCustomDateGroup" style="display:none; border-top:1px dashed var(--gray-200); padding-top:15px;" class="no-print">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:20px;">
                        <div>
                            <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Start Date</label>
                            <input type="date" id="stmtStartDate" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                        </div>
                        <div>
                            <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">End Date</label>
                            <input type="date" id="stmtEndDate" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                        </div>
                    </div>
                </div>

                <!-- Statement Document Body -->
                <div class="statement-print-area">
                    <!-- Official Bank Logo & Name -->
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 15px; margin-bottom: 25px;">
                        <div>
                            <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-500); letter-spacing: 1px; line-height: 1;">VERTEX GALAXY BANK</h1>
                            <p style="font-size: 0.8rem; color: var(--gray-500); margin-top: 5px; font-weight: 500;">Secure Credit &amp; Lending Divisions</p>
                        </div>
                        <div style="text-align: right;">
                            <span style="font-family: monospace; font-size: 0.85rem; color: var(--gray-500); font-weight: 700;" id="lblStmtRef">ACC-REF: -</span>
                            <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 3px;">Date Generated: <span id="lblStmtDateGenerated">-</span></p>
                        </div>
                    </div>

                    <!-- Official Header Subtitle (shown in both screen and print) -->
                    <div style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                        <span style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official Account Transaction Ledger Statement</span>
                    </div>

                    <!-- Details Grid -->
                    <div class="statement-meta-grid" style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);">
                        <!-- Left: Bank Information -->
                        <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                            <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank Details</span>
                            <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate HQ)</strong>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers, BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code: <strong style="font-family: monospace;">VGBK0000001</strong></p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free: 1800-VGB-BANK</p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal: www.vertexgalaxybank.com</p>
                        </div>
                        
                        <!-- Right: Customer & Account Details -->
                        <div>
                            <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer &amp; Account Details</span>
                            <strong style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;" id="lblStmtName">-</strong>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong style="font-family: monospace;" id="lblStmtCustId">-</strong></p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address: <strong style="color: var(--gray-800); font-weight: 600;" id="lblStmtAddress">-</strong></p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Account Reference: <strong style="font-family: monospace;" id="lblStmtAccNum">-</strong> (<span id="lblStmtAccType" style="text-transform: uppercase; font-weight: 600;">-</span> Account)</p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Total Balance: <strong style="color: var(--primary-500); font-size: 1.05rem;" id="lblStmtBalance">-</strong></p>
                        </div>
                    </div>

                    <!-- Ledger Section Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                            <i class="bx bx-history" style="color: var(--primary-500);"></i> Transaction Ledger Log
                        </h4>
                        <button type="button" onclick="window.print()" class="btn btn-primary no-print" style="display: inline-flex; align-items: center; gap: 6px;">
                            <span>Print Document</span>
                            <i class="bx bx-printer"></i>
                        </button>
                    </div>

                    <!-- Table Responsive Wrapper -->
                    <div style="overflow-x: auto; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); box-shadow: var(--shadow-sm); margin-bottom: 25px;">
                        <table id="statementTxnTable" style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem; margin-bottom: 0;">
                            <thead>
                                <tr style="background: rgba(99, 102, 241, 0.04); color: var(--gray-700); border-bottom: 2px solid var(--gray-200);">
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; width: 80px;">Sr. No.</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Transaction Date</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Type</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Description</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Status</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Credit Amount</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Debit Amount</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Total Amount</th>
                                </tr>
                            </thead>
                            <tbody id="statementTxnTbody">
                                <!-- Populated dynamically via AJAX -->
                            </tbody>
                        </table>
                    </div>

                    <!-- Footer Signatures -->
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px; margin-bottom: 25px;" class="print-only">
                        <div style="text-align: center; width: 200px;">
                            <div style="border-bottom: 1.5px solid var(--gray-400); height: 40px; margin-bottom: 8px;"></div>
                            <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; text-transform: capitalize;">Authorized Signatory</span>
                        </div>
                        <div style="text-align: center; width: 200px;">
                            <div style="border-bottom: 1.5px solid var(--gray-400); height: 40px; margin-bottom: 8px;"></div>
                            <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; text-transform: capitalize;">System Generated Seals</span>
                        </div>
                    </div>
                </div>

                <!-- Modal Controls (hidden in print) -->
                <div style="display: flex; justify-content: center; align-items: center; margin-top: 35px; border-top: 1px solid var(--gray-100); padding-top: 25px;" class="no-print">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('statementModal')">Close View</button>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer no-print">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; <span>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
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
            phoneNo: "${acc.companyPhone}" // temporary, we can retrieve via API if needed
        });
        // </c:forEach>
    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
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
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
                    <div>
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Account Credentials</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500);">Account Number:</td><td style="font-weight:700; font-family:monospace;">\${acc.accountNumber}</td></tr>
                            <tr><td style="color:var(--gray-500);">IFSC Code:</td><td style="font-weight:600; font-family:monospace;">\${acc.ifscCode}</td></tr>
                            <tr><td style="color:var(--gray-500);">Account Type:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.accountType}</td></tr>
                            <tr><td style="color:var(--gray-500);">Ledger Balance:</td><td style="font-weight:800; color:var(--primary-500);">₹ \${acc.balance.toFixed(2)}</td></tr>
                            <tr><td style="color:var(--gray-500);">Status:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.status}</td></tr>
                        </table>
                    </div>
                    <div>
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Enabled Services</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500);">ATM Debit Card:</td><td style="font-weight:700;">\${acc.hasAtmCard ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Cheque Book:</td><td style="font-weight:700;">\${acc.hasChequeBook ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Offline Passbook:</td><td style="font-weight:700;">\${acc.hasPassbook ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                        </table>
                    </div>
                </div>
            `;

            if (acc.accountType === 'savings') {
                detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Savings Ledger Specifics</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Registered Nominee:</td><td style="font-weight:700;">\${acc.nomineeName || 'No Nominee'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Holding Mode:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.holdingType}</td></tr>
                            <tr><td style="color:var(--gray-500);">Daily Cash Limit:</td><td style="font-weight:700;">₹ \${acc.dailyWithdrawalLimit || '50,000.00'}</td></tr>
                        </table>
                    </div>
                `;
            } else {
                detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Corporate Registry</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Business Trade Name:</td><td style="font-weight:700;">\${acc.businessName}</td></tr>
                            <tr><td style="color:var(--gray-500);">GSTIN Identification:</td><td style="font-weight:700; font-family:monospace;">\${acc.gstin}</td></tr>
                            <tr><td style="color:var(--gray-500);">Overdraft limit:</td><td style="font-weight:700;">₹ \${acc.overdraftLimit}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Category:</td><td style="font-weight:700;">\${acc.companyCategory || 'Partnership'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company PAN:</td><td style="font-weight:700; font-family:monospace;">\${acc.companyPan}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Aadhaar:</td><td style="font-weight:700; font-family:monospace;">\${acc.companyAadhaar}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Phone/Email:</td><td style="font-weight:700;">\${acc.companyPhone} / \${acc.companyEmail}</td></tr>
                            <tr><td style="color:var(--gray-500);">Registered Address:</td><td style="font-weight:700;">\${acc.companyAddress}</td></tr>
                        </table>
                    </div>
                `;
            }

            // Add Primary Customer details section
            if (acc.primaryFirstName) {
                detailsHtml += `
                    <div style="margin-top:25px; background: rgba(99, 102, 241, 0.03); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.1);">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">
                            <i class="bx bx-user" style="color:var(--primary-500);"></i> Primary Holder Details
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
                                <td style="color:var(--gray-500);">Father's Name / Mother's Name:</td>
                                <td style="font-weight:700;">\${acc.primaryFatherName || 'N/A'} / \${acc.primaryMotherName || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Nationality / Alternate Phone:</td>
                                <td style="font-weight:700;">\${acc.primaryNationality || 'Indian'} / \${acc.primaryAltPhone || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Registered Address:</td>
                                <td style="font-weight:700;">\${acc.primaryAddress ? acc.primaryAddress + ', ' + acc.primaryCity + ', ' + acc.primaryState + ' - ' + acc.primaryZip : 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Permanent Address:</td>
                                <td style="font-weight:700;">\${acc.primaryPermAddress || 'N/A'}</td>
                            </tr>
                        </table>
                    </div>
                `;
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
                                <td style="color:var(--gray-500);">Father's Name / Mother's Name:</td>
                                <td style="font-weight:700;">\${acc.jointFatherName || 'N/A'} / \${acc.jointMotherName || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Nationality / Alternate Phone:</td>
                                <td style="font-weight:700;">\${acc.jointNationality || 'Indian'} / \${acc.jointAltPhone || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Registered Address:</td>
                                <td style="font-weight:700;">\${acc.jointAddress ? acc.jointAddress + ', ' + acc.jointCity + ', ' + acc.jointState + ' - ' + acc.jointZip : 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Permanent Address:</td>
                                <td style="font-weight:700;">\${acc.jointPermAddress || 'N/A'}</td>
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

            var savingsBlock = document.getElementById('savingsEditFields');
            var currentBlock = document.getElementById('currentEditFields');

            if (acc.accountType === 'savings') {
                savingsBlock.style.display = 'block';
                currentBlock.style.display = 'none';
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

                // Populate joint customer details
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
                } else {
                    jointFields.style.display = 'none';
                    // Clear joint inputs
                    document.getElementById('editJointFirstName').value = '';
                    document.getElementById('editJointMiddleName').value = '';
                    document.getElementById('editJointLastName').value = '';
                    document.getElementById('editJointDob').value = '';
                    document.getElementById('editJointGender').value = 'male';
                    document.getElementById('editJointMarital').value = 'single';
                    document.getElementById('editJointEmail').value = '';
                    document.getElementById('editJointPhone').value = '';
                    document.getElementById('editJointAltPhone').value = '';
                    document.getElementById('editJointIncome').value = '';
                    document.getElementById('editJointOcc').value = '';
                    document.getElementById('editJointPan').value = '';
                    document.getElementById('editJointAadhaar').value = '';
                    document.getElementById('editJointAddress').value = '';
                    document.getElementById('editJointPermAddress').value = '';
                    document.getElementById('editJointFatherName').value = '';
                    document.getElementById('editJointMotherName').value = '';
                    document.getElementById('editJointNationality').value = 'Indian';
                    document.getElementById('editJointCity').value = '';
                    document.getElementById('editJointState').value = '';
                    document.getElementById('editJointZip').value = '';
                }
                updateEditRequiredFields('savings', acc.holdingType);
            } else {
                savingsBlock.style.display = 'none';
                currentBlock.style.display = 'block';
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

            if (accountType === 'savings') {
                primaryInputs.forEach(function(id) {
                    var elem = document.getElementById(id);
                    if (elem) elem.setAttribute('required', 'required');
                });

                if (holdingType === 'joint') {
                    jointInputs.forEach(function(id) {
                        var elem = document.getElementById(id);
                        if (elem) elem.setAttribute('required', 'required');
                    });
                } else {
                    jointInputs.forEach(function(id) {
                        var elem = document.getElementById(id);
                        if (elem) elem.removeAttribute('required');
                    });
                }
            } else {
                primaryInputs.forEach(function(id) {
                    var elem = document.getElementById(id);
                    if (elem) elem.removeAttribute('required');
                });
                jointInputs.forEach(function(id) {
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
                var a4AppDate = document.getElementById('a4AppDate');
                if (a4AppDate) a4AppDate.value = today;
                
                var officeAppDate = document.getElementById('officeAppDate');
                if (officeAppDate) officeAppDate.textContent = today;
                
                var systemCreatedDate = document.getElementById('systemCreatedDate');
                if (systemCreatedDate) systemCreatedDate.textContent = today;

                // Generate secure random PIN
                var randPin = Math.floor(1000 + Math.random() * 9000);
                var a4Pin = document.getElementById('a4Pin');
                if (a4Pin) a4Pin.value = randPin;

                // Generate random username & password
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

        // Handle Account Type Change logic
        function handleAccountTypeChange() {
            try {
                var typeElem = document.getElementById('a4AccountType');
                if (!typeElem) return;
                var type = typeElem.value;
                var minAmt = 1000;
                var noteText = "Minimum initial amount required is ₹1,000.00.";

                if (type === 'current') {
                    minAmt = 5000;
                    noteText = "Minimum initial amount required is ₹5,000.00.";
                    var savCard = document.getElementById('a4SavingsDetailsCard');
                    if (savCard) savCard.style.display = 'none';
                    var curCard = document.getElementById('a4CurrentDetailsCard');
                    if (curCard) curCard.style.display = 'block';
                    var chkBus = document.getElementById('a4ChecklistBusLabel');
                    if (chkBus) chkBus.style.display = 'flex';
                    var nomSec = document.getElementById('a4NomineeSection');
                    if (nomSec) nomSec.style.display = 'none';
                    
                    // Remove required attribute from Nominee details
                    setRequired('a4NomineeName', false);
                    setRequired('a4NomineeRel', false);
                    setRequired('a4NomineeDob', false);
                    setRequired('a4NomineePhone', false);
                    setRequired('a4NomineeAadh', false);
                    setRequired('a4NomineeAddr', false);
                    
                    // Current business inputs are required
                    setRequired('a4BusName', true);
                    setRequired('a4BusGst', true);
                    setRequired('a4BusRegNo', true);
                } else {
                    if (type === 'student') {
                        minAmt = 500;
                        noteText = "Minimum initial amount required is ₹500.00.";
                    } else if (type === 'salary') {
                        minAmt = 0;
                        noteText = "Initial deposit is ₹0.00 (Zero Balance).";
                    } else if (type === 'fd') {
                        minAmt = 10000;
                        noteText = "Minimum Fixed Deposit amount is ₹10,000.00.";
                    } else if (type === 'rd') {
                        minAmt = 1000;
                        noteText = "Minimum monthly RD installment is ₹1,000.00.";
                    }
                    var savCard = document.getElementById('a4SavingsDetailsCard');
                    if (savCard) savCard.style.display = 'block';
                    var curCard = document.getElementById('a4CurrentDetailsCard');
                    if (curCard) curCard.style.display = 'none';
                    var chkBus = document.getElementById('a4ChecklistBusLabel');
                    if (chkBus) chkBus.style.display = 'none';
                    var nomSec = document.getElementById('a4NomineeSection');
                    if (nomSec) nomSec.style.display = 'block';
                    
                    // Savings nominee details are required
                    setRequired('a4NomineeName', true);
                    setRequired('a4NomineeRel', true);
                    setRequired('a4NomineeDob', true);
                    setRequired('a4NomineePhone', true);
                    setRequired('a4NomineeAadh', true);
                    setRequired('a4NomineeAddr', true);

                    // Current business inputs are not required
                    setRequired('a4BusName', false);
                    setRequired('a4BusGst', false);
                    setRequired('a4BusRegNo', false);
                }

                var initAmtInput = document.getElementById('a4InitialAmount');
                if (initAmtInput) initAmtInput.value = minAmt.toFixed(2);
                var minDepNote = document.getElementById('a4MinDepositNote');
                if (minDepNote) minDepNote.textContent = noteText;
            } catch (err) {
                console.error("Error in handleAccountTypeChange:", err);
            }
        }

        // Helper to toggle required attribute
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
                    setRequired('a4JointName', true);
                    setRequired('a4JointRel', true);
                    setRequired('a4JointPhone', true);
                    setRequired('a4JointEmail', true);
                    setRequired('a4JointAadh', true);
                    setRequired('a4JointPan', true);
                } else {
                    if (jointSec) jointSec.style.display = 'none';
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

        // Address synchronization check
        function syncPermanentAddress(checked) {
            if (checked) {
                document.getElementById('a4PermAddress').value = document.getElementById('a4Address').value;
                document.getElementById('a4PermCity').value = document.getElementById('a4City').value;
                document.getElementById('a4PermState').value = document.getElementById('a4State').value;
                document.getElementById('a4PermZip').value = document.getElementById('a4Zip').value;
                
                document.getElementById('a4PermAddress').readOnly = true;
                document.getElementById('a4PermCity').readOnly = true;
                document.getElementById('a4PermState').readOnly = true;
                document.getElementById('a4PermZip').readOnly = true;
            } else {
                document.getElementById('a4PermAddress').readOnly = false;
                document.getElementById('a4PermCity').readOnly = false;
                document.getElementById('a4PermState').readOnly = false;
                document.getElementById('a4PermZip').readOnly = false;
                
                document.getElementById('a4PermAddress').value = '';
                document.getElementById('a4PermCity').value = '';
                document.getElementById('a4PermState').value = '';
                document.getElementById('a4PermZip').value = '';
            }
        }

        // Client-side validation on Submit
        function validateA4FormSubmit() {
            var pass = document.getElementById('a4Password').value;
            var confirmPass = document.getElementById('a4ConfirmPassword').value;
            if (pass !== confirmPass) {
                alert("Passwords do not match!");
                return false;
            }

            var pin = document.getElementById('a4Pin').value;
            if (pin.length !== 4 || isNaN(pin)) {
                alert("Transaction PIN must be exactly 4 numeric digits.");
                return false;
            }

            var aadhaar = document.getElementById('a4Aadhaar').value.trim();
            if (aadhaar.length !== 12 || isNaN(aadhaar)) {
                alert("Aadhaar Number must be exactly 12 numeric digits.");
                return false;
            }

            var pan = document.getElementById('a4Pan').value.trim();
            if (pan.length !== 10) {
                alert("PAN Card Number must be exactly 10 characters.");
                return false;
            }

            var type = document.getElementById('a4AccountType').value;
            var initialAmt = parseFloat(document.getElementById('a4InitialAmount').value);
            var minAmt = 1000;
            if (type === 'current') minAmt = 5000;
            else if (type === 'student') minAmt = 500;
            else if (type === 'salary') minAmt = 0;
            else if (type === 'fd') minAmt = 10000;
            else if (type === 'rd') minAmt = 1000;

            if (isNaN(initialAmt) || initialAmt < minAmt) {
                alert("Initial deposit must be at least ₹" + minAmt.toFixed(2));
                return false;
            }

            return true;
        }

        // Visualizer helpers removed.
        function updateChequeAmount(val) {
        }
        
        // Dynamic Partners Input fields
        var partnerCount = 1;
        function addNewPartnerField() {
            partnerCount++;
            document.getElementById('partnerCountInput').value = partnerCount;

            var container = document.getElementById('dynamicPartnersContainer');
            var cardHtml = 
                '<div class="partner-card" id="partner_card_' + partnerCount + '">' +
                    '<span class="remove-partner-btn" onclick="removePartnerField(' + partnerCount + ')"><i class="bx bx-trash"></i></span>' +
                    '<h5 style="font-size:0.85rem; font-weight:700; color:var(--primary-500); margin-bottom:15px;">Partner Profile #' + partnerCount + '</h5>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>First Name *</label>' +
                            '<input type="text" name="partner_firstName_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Middle Name</label>' +
                            '<input type="text" name="partner_middleName_' + partnerCount + '">' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Last Name *</label>' +
                            '<input type="text" name="partner_lastName_' + partnerCount + '" required>' +
                        '</div>' +
                    '</div>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>Date of Birth *</label>' +
                            '<input type="date" name="partner_dob_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Gender *</label>' +
                            '<select name="partner_gender_' + partnerCount + '">' +
                                '<option value="male">Male</option>' +
                                '<option value="female">Female</option>' +
                            '</select>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Marital Status</label>' +
                            '<select name="partner_maritalStatus_' + partnerCount + '">' +
                                '<option value="single">Single</option>' +
                                '<option value="married">Married</option>' +
                            '</select>' +
                        '</div>' +
                    '</div>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>Email *</label>' +
                            '<input type="email" name="partner_email_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Phone *</label>' +
                            '<input type="text" name="partner_phone_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>PAN Card *</label>' +
                            '<input type="text" name="partner_pan_' + partnerCount + '" required>' +
                        '</div>' +
                    '</div>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>Aadhaar Card *</label>' +
                            '<input type="text" name="partner_aadhaar_' + partnerCount + '" required>' +
                        '</div>' +
                    '</div>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>Partner Address *</label>' +
                            '<input type="text" name="partner_address_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>City *</label>' +
                            '<input type="text" name="partner_city_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>State *</label>' +
                            '<input type="text" name="partner_state_' + partnerCount + '" required>' +
                        '</div>' +
                    '</div>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>Zip Code *</label>' +
                            '<input type="text" name="partner_zip_' + partnerCount + '" required>' +
                        '</div>' +
                        '<div class="form-group">' +
                            '<label>Annual Income *</label>' +
                            '<input type="number" name="partner_income_' + partnerCount + '" value="500000">' +
                        '</div>' +
                    '</div>' +
                    '<div class="form-row row-3">' +
                        '<div class="form-group">' +
                            '<label>Occupation</label>' +
                            '<input type="text" name="partner_occupation_' + partnerCount + '" value="Business">' +
                        '</div>' +
                    '</div>' +
                    '<input type="hidden" name="partner_username_' + partnerCount + '">' +
                    '<input type="hidden" name="partner_password_' + partnerCount + '">' +
                    '<!-- Hidden PIN input -->' +
                    '<input type="hidden" name="partner_pin_' + partnerCount + '" value="' + document.getElementById('a4Pin').value + '">' +
                '</div>';

            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = cardHtml;
            container.appendChild(tempDiv.firstElementChild);
        }

        function removePartnerField(id) {
            var card = document.getElementById('partner_card_' + id);
            if (card) {
                card.remove();
                partnerCount--;
                document.getElementById('partnerCountInput').value = partnerCount;
            }
        }

        function validateA4InitialAmount() {
            var type = document.getElementById('a4AccountType').value;
            var initialAmt = parseFloat(document.getElementById('a4InitialAmount').value);
            var minAmt = 1000;
            if (type === 'current') minAmt = 5000;
            else if (type === 'student') minAmt = 500;
            else if (type === 'salary') minAmt = 0;
            else if (type === 'fd') minAmt = 10000;
            else if (type === 'rd') minAmt = 1000;

            var note = document.getElementById('a4MinDepositNote');
            if (isNaN(initialAmt) || initialAmt < minAmt) {
                note.style.color = '#ef4444'; // Red for validation error
            } else {
                note.style.color = 'var(--primary-500)'; // Default green/theme
            }
        }

        // Save Form Draft to LocalStorage
        function saveA4FormDraft() {
            try {
                var form = document.getElementById('createAccountForm');
                if (!form) return;
                var formData = {};
                var inputs = form.querySelectorAll('input:not([type="file"]), select, textarea');
                inputs.forEach(function(inp) {
                    if (inp.name) {
                        formData[inp.name] = inp.value;
                    }
                });
                localStorage.setItem('vgb_a4_form_draft', JSON.stringify(formData));
                alert("Draft saved to browser storage successfully!");
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
                            // Ignore any query selector compile errors for safe lookup
                        }
                    }
                    // Trigger manual change to refresh view
                    handleAccountTypeChange();
                    handleHoldingTypeChange();
                }
            } catch(e) {
                console.error("Error loading draft", e);
            }
        }

        // Reset A4 Form
        function resetA4Form() {
            try {
                var form = document.getElementById('createAccountForm');
                if (form) form.reset();
                localStorage.removeItem('vgb_a4_form_draft');
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
    </script>
</body>

</html>