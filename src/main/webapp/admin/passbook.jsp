<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Passbooks</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
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

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        /* --- STATS CARD ACCENTS --- */
        .stat-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        body.dark-mode .stat-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
            box-shadow: var(--panel-shadow);
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(99, 102, 241, 0.08);
        }

        body.dark-mode .stat-card:hover {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
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

        /* Status Badge Utilities */
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

        .badge-new {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-600);
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        body.dark-mode .badge-new {
            background: rgba(99, 102, 241, 0.2);
            color: var(--primary-400);
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
        body.dark-mode .badge-renew {
            background: rgba(236, 72, 153, 0.2);
            color: var(--secondary-400);
        }

        /* ===== 3D BOOKLET PASSBOOK PREVIEW AREA ===== */
        .passbook-preview-layout {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
            align-items: stretch;
        }

        @media (max-width: 991px) {
            .passbook-preview-layout {
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
            perspective: 1200px;
            position: relative;
            overflow: hidden;
            height: 100%;
            min-height: 340px;
        }
        body.dark-mode .passbook-visualizer-container {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.02) 0%, rgba(236, 72, 153, 0.02) 100%);
            border-color: rgba(255, 255, 255, 0.08);
        }

        .passbook-wrapper {
            width: 380px;
            height: 250px;
            position: relative;
            transform-style: preserve-3d;
            cursor: pointer;
            transform-origin: center center;
            transition: transform 0.3s ease;
        }

        .passbook-book {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateX(12deg) rotateY(-18deg);
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
        }

        /* Spine / spine shadow */
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

        /* 3D cover swing wrapper - transitions opacity and visibility to hide left cover when open */
        .passbook-cover-wrapper {
            position: absolute;
            inset: 0;
            transform-origin: left center;
            transform-style: preserve-3d;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.4s ease, visibility 0.4s ease;
            z-index: 30;
            opacity: 1;
            visibility: visible;
        }

        .passbook-book.open .passbook-cover-wrapper {
            transform: rotateY(-155deg);
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
        }

        .passbook-book.open {
            transform: rotateX(15deg) rotateY(10deg);
        }

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

        .passbook-cover-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: 
                radial-gradient(circle at 80% 20%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 10% 80%, rgba(236, 72, 153, 0.1) 0%, transparent 40%);
            pointer-events: none;
        }

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

        .bank-tagline {
            font-size: 0.55rem;
            letter-spacing: 1px;
            color: #a5b4fc;
            text-transform: uppercase;
            opacity: 0.7;
        }

        /* Inside Page */
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
            display: none;
        }

        .passbook-status-watermark.pending {
            display: block;
            color: rgba(245, 158, 11, 0.15);
        }

        .passbook-status-watermark.approved {
            display: block;
            color: rgba(16, 185, 129, 0.15);
        }

        .passbook-status-watermark.rejected {
            display: block;
            color: rgba(239, 68, 68, 0.15);
        }

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

        /* Show both pages side-by-side in modals on larger viewports */
        @media (min-width: 768px) {
            .modal .passbook-book.open .passbook-cover-wrapper {
                opacity: 1 !important;
                visibility: visible !important;
                pointer-events: auto !important;
            }
        }

        /* Responsive scaling for booklet sandbox */
        @media (max-width: 991px) {
            .modal .passbook-wrapper {
                transform: scale(0.8);
            }
        }

        @media (max-width: 767px) {
            .modal .passbook-wrapper {
                transform: scale(0.75);
            }
        }

        @media (max-width: 480px) {
            .modal .passbook-wrapper {
                transform: scale(0.65);
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
            max-width: 600px;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        body.dark-mode .modal-content {
            background: rgba(15, 23, 42, 0.85) !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
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
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions">
            <div style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary-500);">
                <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
            </div>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list" class="active"><i class="bx bx-book-open"></i> Passbook Requests</a>
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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Manage Passbook Requests</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Review customer passbook applications, inspect 3D booklet configurations, and issue approvals/refunds.</p>
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

            <!-- Dynamic Statistics Cards -->
            <c:set var="pendingCount" value="0"/>
            <c:set var="approvedCount" value="0"/>
            <c:set var="rejectedCount" value="0"/>
            <c:forEach var="r" items="${requests}">
                <c:if test="${r.status eq 'pending'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
                <c:if test="${r.status eq 'approved' or r.status eq 'delivered'}"><c:set var="approvedCount" value="${approvedCount + 1}"/></c:if>
                <c:if test="${r.status eq 'rejected'}"><c:set var="rejectedCount" value="${rejectedCount + 1}"/></c:if>
            </c:forEach>

            <div class="stat-grid">
                <div class="stat-card" style="border-left: 4px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-book-open"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Total Requests</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${requests.size()}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--accent-amber);">
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #fbbf24;">
                        <i class="bx bx-time"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Pending Review</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${pendingCount}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                        <i class="bx bx-check-double"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Approved Books</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${approvedCount}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                        <i class="bx bx-x-circle"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Rejected / Refunded</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${rejectedCount}</h3>
                    </div>
                </div>
            </div>

            <!-- Stats & Preview Split Grid -->
            <div class="passbook-preview-layout">
                <!-- Left Column: Stats + Preview Summary Info -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <!-- Booklet inspector instructions -->
                    <div class="glass-card" style="margin-bottom: 0; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between;">
                        <div>
                            <h4 style="font-size: 1.15rem; font-weight: 700; color: var(--gray-800); margin-bottom: 8px;"><i class="bx bx-search-alt" style="color: var(--primary-500);"></i> 3D Booklet Inspector Instructions</h4>
                            <p style="font-size: 0.82rem; color: var(--gray-500); line-height: 1.5;">
                                Select any passbook application from the table below to load its details into the 3D Booklet Visualizer. 
                            </p>
                            <ul style="font-size: 0.8rem; color: var(--gray-600); padding-left: 20px; line-height: 1.7; margin-top: 10px;">
                                <li>Verify that customer's legal name matches profile.</li>
                                <li>Verify account number integrity.</li>
                                <li>Approving changes the customer's account flag to active passbook transaction support.</li>
                                <li>Rejecting triggers an automatic transaction log and refunds the ₹100.00 debit fee instantly.</li>
                            </ul>
                        </div>
                        <div style="background: rgba(16,185,129,0.04); border: 1px dashed rgba(16,185,129,0.15); border-radius: var(--radius-md); padding: 12px; font-size: 0.75rem; color: var(--gray-500); margin-top: 15px;">
                            <strong>Note on System:</strong> Passbook modifications use transactional operations under auto-commit control with rollback configurations.
                        </div>
                    </div>
                </div>

                <!-- Right Column: Interactive 3D booklet visualizer -->
                <div class="passbook-visualizer-container">
                    <button type="button" class="btn" style="position: absolute; top: 12px; right: 15px; background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: 1px solid rgba(99, 102, 241, 0.2); padding: 5px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 4px; z-index: 100;" onclick="openFullPassbook3D(event)"><i class="bx bx-expand"></i> View Full 3D</button>
                    
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
                                            SELECT REQUEST
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Account No:</td>
                                        <td class="info-bold monospace" id="pbAccNum">
                                            - - - - - - - - - - - - -
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Account Type:</td>
                                        <td class="info-bold uppercase" id="pbAccType">
                                            - - - - -
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
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGrad)" />
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
            </div>

            <!-- Table of all requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; display: flex; align-items: center; gap: 8px;"><i class="bx bx-list-ol" style="color: var(--primary-500);"></i> Passbook Applications</h3>
                <div class="table-responsive" style="overflow-x: auto; width: 100%;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">ID</th>
                                <th style="padding: 12px 15px;">Customer Name</th>
                                <th style="padding: 12px 15px;">Account Number</th>
                                <th style="padding: 12px 15px;">Type</th>
                                <th style="padding: 12px 15px;">Fee Status</th>
                                <th style="padding: 12px 15px;">Requested Date</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: right;">Action Control</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="req" items="${requests}">
                                        <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; vertical-align: middle;">
                                            <td style="padding: 15px; font-weight: 700; color: var(--gray-700);"><span class="badge-id">#${req.requestId}</span></td>
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-800);">${req.customerName}</td>
                                            <td style="padding: 15px;"><span class="badge-id">${req.accountNumber}</span></td>
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
                                                        <span style="background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;">Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.12); color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;">Refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; color: var(--gray-500);">
                                                <fmt:formatDate value="${req.requestedAt}" pattern="dd-MMM-yyyy hh:mm a" />
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${req.status eq 'approved' or req.status eq 'delivered'}">
                                                        <span class="badge-approved"><i class="bx bxs-check-circle" style="vertical-align: middle; margin-right: 3px;"></i> Approved</span>
                                                    </c:when>
                                                    <c:when test="${req.status eq 'pending'}">
                                                        <span class="badge-pending"><i class="bx bxs-time" style="vertical-align: middle; margin-right: 3px;"></i> Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-rejected"><i class="bx bxs-x-circle" style="vertical-align: middle; margin-right: 3px;"></i> Rejected</span>
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
                                                    <c:if test="${req.status eq 'pending'}">
                                                        <a href="${pageContext.request.contextPath}/passbook?action=approve&id=${req.requestId}" 
                                                           class="btn btn-primary" 
                                                           style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); text-decoration: none; font-weight: 600;"
                                                           onclick="return confirm('Are you sure you want to approve this passbook request?');">
                                                            Approve
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/passbook?action=reject&id=${req.requestId}" 
                                                           class="btn btn-danger" 
                                                           style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #ef4444; color: white; border: none; text-decoration: none; font-weight: 600;"
                                                           onclick="return confirm('Are you sure you want to reject this request? Processing fees of ₹100.00 will be refunded.');">
                                                            Reject
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="padding: 30px; text-align: center; color: var(--gray-400); font-style: italic;">
                                            <i class="bx bx-info-circle" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i> No passbook requests have been submitted.
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

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Theme toggle logic
            const themeBtn = document.getElementById('themeToggle');
            if (themeBtn) {
                themeBtn.style.setProperty('display', 'flex', 'important');
                themeBtn.onclick = function () {
                    document.body.classList.toggle('dark-mode');
                    const isDark = document.body.classList.contains('dark-mode');
                    const icon = themeBtn.querySelector('i');
                    if (icon) icon.className = isDark ? 'bx bx-sun' : 'bx bx-moon';
                    localStorage.setItem('admin-theme', isDark ? 'dark' : 'light');
                };

                // Sync with stored theme preference
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

            // Mobile menu toggle logic
            const mobileToggle = document.getElementById('mobileNavToggle');
            const sidebar = document.querySelector('.sidebar');
            if (mobileToggle && sidebar) {
                mobileToggle.addEventListener('click', (e) => {
                    e.stopPropagation();
                    sidebar.classList.toggle('active');
                    const icon = mobileToggle.querySelector('i');
                    if (icon) {
                        icon.className = sidebar.classList.contains('active') ? 'bx bx-x' : 'bx bx-menu';
                    }
                });

                // Close sidebar when clicking outside
                document.addEventListener('click', (e) => {
                    if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                        sidebar.classList.remove('active');
                        const icon = mobileToggle.querySelector('i');
                        if (icon) icon.className = 'bx bx-menu';
                    }
                });
            }

            // Cursor glow follower
            const glow = document.querySelector('.cursor-glow');
            if (glow) {
                window.addEventListener('mousemove', (e) => {
                    requestAnimationFrame(() => {
                        glow.style.left = e.clientX + 'px';
                        glow.style.top = e.clientY + 'px';
                    });
                });
            }

            // Preloader fadeout
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                setTimeout(() => {
                    preloader.classList.add('hidden');
                }, 300);
            }
            
            // Set current year in footer dynamically
            const yearEl = document.querySelector('[data-current-year]');
            if (yearEl) {
                yearEl.textContent = new Date().getFullYear();
            }
        });

        // 3D passbook variables & interactivity
        const book = document.getElementById('3dPassbook');
        const container = document.querySelector('.passbook-visualizer-container');
        const wrapper = document.querySelector('.passbook-wrapper');
        const hint = document.getElementById('pbHint');

        if (wrapper && book) {
            wrapper.addEventListener('mousemove', (e) => {
                if (book.classList.contains('open')) return;

                const rect = wrapper.getBoundingClientRect();
                const x = e.clientX - rect.left - rect.width / 2;
                const y = e.clientY - rect.top - rect.height / 2;

                const rX = -(y / rect.height) * 15;
                const rY = (x / rect.width) * 22;

                requestAnimationFrame(() => {
                    book.style.transform = `rotateX(${12 + rX}deg) rotateY(${-18 + rY}deg) scale(1.025)`;
                });
            });

            wrapper.addEventListener('mouseleave', () => {
                if (book.classList.contains('open')) return;
                requestAnimationFrame(() => {
                    book.style.transform = `rotateX(12deg) rotateY(-18deg) scale(1)`;
                });
            });
        }

        function toggleBookOpen() {
            if (!book) return;
            book.classList.toggle('open');
            if (book.classList.contains('open')) {
                if (hint) hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Close';
                book.style.transform = 'rotateX(15deg) rotateY(10deg)';
            } else {
                if (hint) hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Open';
                book.style.transform = 'rotateX(12deg) rotateY(-18deg)';
            }
        }

        // Modal open/close functions
        function openFullPassbook3D(event) {
            if (event) event.stopPropagation();
            const modal = document.getElementById('fullPassbookModal');
            const modalScene = document.getElementById('modalPassbookScene');
            
            if (modal && modalScene && wrapper) {
                modalScene.appendChild(wrapper);
                modal.style.display = 'flex';
            }
        }

        function closeFullPassbook3D() {
            const modal = document.getElementById('fullPassbookModal');
            const inlineScene = document.querySelector('.passbook-visualizer-container');
            const hintEl = document.getElementById('pbHint');
            
            if (modal && inlineScene && wrapper) {
                inlineScene.insertBefore(wrapper, hintEl || null);
                modal.style.display = 'none';
            }
        }

        function closeFullPassbook3DOnOutsideClick(event) {
            const modal = document.getElementById('fullPassbookModal');
            if (modal && event.target === modal) {
                closeFullPassbook3D();
            }
        }

        // View dynamic preview for a selected request
        function inspectRequest(btn) {
            if (!btn) return;
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            const acc = btn.getAttribute('data-account');
            const type = btn.getAttribute('data-type');
            const acctype = btn.getAttribute('data-acctype');
            const status = btn.getAttribute('data-status');

            const nameEl = document.getElementById('pbCustName');
            const accEl = document.getElementById('pbAccNum');
            const accTypeEl = document.getElementById('pbAccType');
            const wm = document.getElementById('pbWatermark');

            if (nameEl) nameEl.innerText = name || '';
            if (accEl) accEl.innerText = acc || '';
            if (accTypeEl) accTypeEl.innerText = acctype || '';

            if (wm && status) {
                wm.innerText = status;
                wm.className = "passbook-status-watermark " + status.toLowerCase();
            }

            // Open book cover automatically to show info
            if (book && !book.classList.contains('open')) {
                toggleBookOpen();
            }

            // Scroll visualizer into view on mobile
            if (container) {
                container.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    </script>

    <!-- Full 3D Passbook Visualizer Modal Overlay -->
    <div id="fullPassbookModal" class="modal" onclick="closeFullPassbook3DOnOutsideClick(event)">
        <div class="modal-content" style="max-width: 600px; padding: 30px; position: relative;">
            <button type="button" onclick="closeFullPassbook3D()" class="close-btn" style="position: absolute; right: 20px; top: 20px; font-size: 1.8rem; z-index: 110;">&times;</button>
            
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <i class="bx bx-book-open" style="color: var(--primary-500); font-size: 1.4rem;"></i> VGB Premium 3D Passbook
            </h3>

            <!-- 3D Scene Container in Modal -->
            <div id="modalPassbookScene" style="perspective: 1200px; width: 100%; min-height: 340px; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, rgba(99, 102, 241, 0.02) 0%, rgba(236, 72, 153, 0.02) 100%); border-radius: var(--radius-md); padding: 40px 20px;">
                <!-- Passbook wrapper will be appended here dynamically on open -->
            </div>
            
            <div style="font-size: 0.8rem; color: var(--gray-500); margin-top: 15px; text-align: center; font-weight: 500;">
                <i class="bx bx-mouse-alt" style="vertical-align: middle;"></i> Move mouse inside card/book to rotate. Click to flip open or close.
            </div>
        </div>
    </div>
</body>
</html>
