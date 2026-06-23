<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Cheque Books</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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

        /* --- PREMIUM MODERN TABLES --- */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
            width: 100%;
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

        /* ===== 3D CHEQUE BOOK BOOKLET STYLING ===== */
        .cheque-top-layout {
            display: grid;
            grid-template-columns: 1fr 1.4fr;
            gap: 30px;
            margin-bottom: 35px;
            align-items: stretch;
        }
        @media (max-width: 991px) {
            .cheque-top-layout {
                grid-template-columns: 1fr !important;
            }
        }

        .cheque-visualizer-container {
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(30, 27, 75, 0.02) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 45px 20px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.02);
            height: 100%;
            perspective: 1200px;
            position: relative;
            overflow: hidden;
            min-height: 340px;
        }

        .chequebook-wrapper {
            width: 480px;
            height: 210px;
            position: relative;
            transform-style: preserve-3d;
            cursor: pointer;
        }
        @media (max-width: 576px) {
            .chequebook-wrapper {
                width: 340px;
                height: 150px;
            }
        }

        .chequebook-book {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateX(12deg) rotateY(-18deg);
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
        }

        /* 3D cover swing wrapper */
        .chequebook-cover-wrapper {
            position: absolute;
            inset: 0;
            transform-origin: center top;
            transform-style: preserve-3d;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 30;
        }

        .cover-flap {
            transform-origin: center top;
            transform: rotateX(0deg) translateZ(1px); /* Folds shut over base */
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 30;
        }

        /* Book states */
        .chequebook-book.open .cover-flap,
        .chequebook-book.open .chequebook-cover-wrapper {
            transform: rotateX(180deg) translateZ(0.5px); /* Opens upwards */
        }

        .chequebook-book.open {
            transform: rotateX(15deg) rotateY(10deg);
        }

        .chequebook-book.flipped-back {
            transform: rotateX(195deg) rotateY(10deg) !important;
        }

        .panel-face {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            border-radius: 12px;
            overflow: hidden;
        }

        .panel-front {
            transform: rotateX(0deg);
            z-index: 2;
        }

        .panel-back {
            transform: rotateX(180deg);
            z-index: 1;
        }

        .btn-flip-book {
            position: absolute;
            bottom: 12px;
            left: 15px;
            background: rgba(99, 102, 241, 0.08);
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            color: var(--primary-600);
            padding: 6px 12px;
            font-size: 0.72rem;
            font-weight: 700;
            border-radius: var(--radius-sm);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all var(--transition-normal);
            z-index: 100;
        }
        .btn-flip-book:hover {
            background: var(--gradient-primary);
            color: white !important;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
            transform: translateY(-1px);
        }
        .btn-flip-book i {
            font-size: 0.95rem;
        }

        /* Front side of the cover with leather spine */
        .chequebook-cover-front {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            background: radial-gradient(circle at 65% 50%, #151145 0%, #06041a 60%, #010008 100%);
            border-radius: 12px;
            box-shadow: 12px 18px 40px rgba(0, 0, 0, 0.45), inset -1px 0 2px rgba(255, 255, 255, 0.1);
            padding: 24px 20px 16px 20px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 2;
        }

        .chequebook-cover-front::before {
            content: '';
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            height: 12px;
            background: linear-gradient(180deg, #09090b 0%, #202025 45%, #09090b 85%, #020204 100%);
            z-index: 10;
            border-radius: 12px 12px 0 0;
            box-shadow: inset 0 -1px 2px rgba(255,255,255,0.05), 0 3px 5px rgba(0,0,0,0.45);
        }

        .chequebook-cover-front::after {
            content: '';
            position: absolute;
            left: 4px;
            right: 4px;
            top: 10px;
            height: 1px;
            border-bottom: 1px dashed rgba(191, 149, 63, 0.4);
            z-index: 11;
        }

        .chequebook-cover-front .cover-nebula-bg {
            position: absolute;
            inset: 0;
            background-image: 
                radial-gradient(circle at 80% 20%, rgba(139, 92, 246, 0.18) 0%, transparent 60%),
                radial-gradient(circle at 40% 80%, rgba(6, 182, 212, 0.15) 0%, transparent 50%);
            pointer-events: none;
            z-index: 1;
        }

        .cover-cosmic-logo {
            width: 85px;
            height: 85px;
            margin: 0 auto;
            position: relative;
            z-index: 5;
        }

        .cb-cosmic-v-svg {
            width: 100%;
            height: 100%;
        }

        .cover-text-group {
            text-align: center;
            position: relative;
            z-index: 5;
            margin-top: 5px;
        }

        .cover-bank-name {
            font-size: 1.45rem;
            font-weight: 800;
            letter-spacing: 5px;
            color: #ffffff;
            line-height: 1.1;
            text-shadow: 0 2px 10px rgba(0,0,0,0.5);
        }

        .cover-bank-sub {
            font-size: 0.68rem;
            font-weight: 600;
            letter-spacing: 3px;
            color: #00d2ff;
            margin-top: 3px;
            text-transform: uppercase;
        }

        .cover-checkbook-title {
            font-size: 0.65rem;
            font-weight: 500;
            letter-spacing: 6px;
            color: rgba(255,255,255,0.7);
            margin-top: 10px;
            text-transform: uppercase;
        }

        /* Inside side of the cover (visible when open) - Safety Protection Page */
        .chequebook-cover-inside {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            transform: rotateX(180deg);
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            border-radius: 12px;
            padding: 16px 20px;
            color: #334155;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-bottom: 1.5px solid rgba(0, 0, 0, 0.05);
            box-shadow: inset 0 -5px 10px rgba(0, 0, 0, 0.05);
            z-index: 1;
            font-family: 'Poppins', sans-serif;
        }

        .inside-rings-watermark {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 50% 50%, rgba(121, 40, 202, 0.025) 0%, transparent 70%);
            pointer-events: none;
            z-index: 1;
        }

        .protection-container {
            display: flex;
            align-items: center;
            gap: 15px;
            height: calc(100% - 22px);
            z-index: 2;
            position: relative;
        }

        .protection-left {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex: 0.85;
        }

        .protection-left svg {
            width: 45px;
            height: 45px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.15));
        }

        .protection-bank-name {
            font-size: 0.95rem;
            font-weight: 800;
            color: #0b0922;
            letter-spacing: 1.5px;
            margin-top: 4px;
            line-height: 1.1;
        }

        .protection-bank-sub {
            font-size: 0.48rem;
            font-weight: 700;
            color: #64748b;
            letter-spacing: 1px;
        }

        .protection-divider {
            width: 1px;
            height: 80%;
            background-color: #cbd5e1;
        }

        .protection-right {
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex: 1.15;
            align-items: flex-start;
        }

        .protection-item {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            text-align: left;
        }

        .protection-item i {
            font-size: 1.05rem;
            color: #0b0922;
            margin-top: 2px;
        }

        .protection-text {
            display: flex;
            flex-direction: column;
        }

        .protection-text strong {
            font-size: 0.52rem;
            color: #0b0922;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .protection-text span {
            font-size: 0.42rem;
            color: #475569;
            line-height: 1.25;
        }

        .protection-footer {
            font-size: 0.55rem;
            font-weight: 600;
            color: #8b5cf6;
            letter-spacing: 1.5px;
            text-align: center;
            border-top: 1px solid rgba(226, 232, 240, 0.8);
            padding-top: 4px;
            position: relative;
            z-index: 2;
        }

        /* Square digit boxes for inputs */
        .digit-boxes {
            display: inline-flex;
            gap: 2px;
            margin-left: 4px;
            vertical-align: middle;
        }
        .digit-boxes span {
            width: 13px;
            height: 15px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.6rem;
            font-weight: 700;
            color: #334155;
            font-family: monospace;
            border-radius: 1px;
        }

        /* Inside Page (bottom page/content page) */
        .chequebook-page {
            position: absolute;
            width: 98%;
            height: 96%;
            top: 2%;
            left: 1%;
            background: #faf8f5;
            border-radius: 4px 4px 10px 10px;
            box-shadow: inset 0 5px 15px rgba(0, 0, 0, 0.15), 5px 10px 20px rgba(0,0,0,0.15);
            padding: 0;
            color: #334155;
            overflow: hidden;
        }

        .chequebook-page.page-instructions {
            transform-origin: center top;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            z-index: 25;
        }


        /* Inside check register layout styling */
        .check-register-title-bar {
            background-color: #0b0922;
            color: #ffffff;
            font-size: 0.62rem;
            font-weight: 700;
            letter-spacing: 2px;
            padding: 4px 0;
            text-align: center;
            text-transform: uppercase;
        }

        .check-register-content {
            padding: 5px 8px;
            height: calc(100% - 22px);
            box-sizing: border-box;
            background: radial-gradient(circle at 70% 80%, rgba(139, 92, 246, 0.04) 0%, transparent 60%), #faf8f6;
            position: relative;
        }

        .check-register-table {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Poppins', sans-serif;
        }

        .check-register-table th {
            background-color: transparent;
            color: #0b0922;
            font-size: 0.42rem;
            font-weight: 800;
            padding: 3px 2px;
            border: 1px solid #cbd5e1;
            text-align: center;
            vertical-align: middle;
        }

        .check-register-table td {
            height: 18px;
            border: 1px solid #cbd5e1;
            background-color: rgba(255, 255, 255, 0.55);
        }

        .instructions-front, .instructions-back {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
        }
        .instructions-front {
            z-index: 2;
            background: #faf8f5;
        }
        .instructions-back {
            transform: rotateX(180deg);
            z-index: 1;
            background: #faf8f5;
            border-top: 1.5px solid rgba(0, 0, 0, 0.05);
            box-shadow: inset 0 5px 10px rgba(0, 0, 0, 0.05);
            height: 100%;
        }

        /* Dynamic classes for turned page */
        .chequebook-page.page-instructions.turned {
            transform: rotateX(175deg);
            z-index: 28 !important;
            box-shadow: 0 -5px 20px rgba(0,0,0,0.15);
        }

        /* Back Cover */
        .chequebook-back {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 50% 50%, #151145 0%, #06041a 60%, #010008 100%);
            border-radius: 12px;
            box-shadow: 3px 5px 15px rgba(0,0,0,0.5);
            z-index: 10;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 16px 20px;
            color: rgba(255, 255, 255, 0.4);
            border-top: 2px solid rgba(255,255,255,0.05);
            overflow: hidden;
            transform: rotateX(180deg);
            backface-visibility: hidden;
        }

        /* Technical Dotted pattern for back cover */
        .chequebook-back::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: radial-gradient(rgba(255, 255, 255, 0.04) 1px, transparent 1px);
            background-size: 12px 12px;
            opacity: 0.7;
            pointer-events: none;
            z-index: 1;
        }

        .chequebook-cover-title h2 {
            font-size: 1.4rem;
            font-weight: 700;
            letter-spacing: 3px;
            margin: 0;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 25%, #b38728 50%, #fbf5b7 75%, #aa771c 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .cheque-leaf-wrapper {
            position: relative;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .cheque-leaf-wrapper.flipped {
            transform: rotateY(180deg);
        }

        .cheque-leaf-front, .cheque-leaf-back-side {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            border-radius: 8px;
            box-sizing: border-box;
        }

        .cheque-leaf-front {
            background-color: #f5f3ff;
            background-image: 
                radial-gradient(circle at 80% 85%, #dbeafe 0%, #e0e7ff 50%, #f5f3ff 100%);
            border: 1.5px solid #a5b4fc;
            padding: 12px 16px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            z-index: 2;
        }

        .cheque-leaf-back-side {
            transform: rotateY(180deg);
            background: #f1f5f9;
            border: 1.5px solid #cbd5e1;
            color: #475569;
            padding: 12px 16px;
            z-index: 1;
        }

        /* Faint watermark logo in the center of booklet pages */
        .watermark-bg-svg {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 180px;
            height: 180px;
            opacity: 0.05;
            pointer-events: none;
            z-index: 1;
        }

        .cheque-hologram {
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 12px;
            background: linear-gradient(90deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
            border-left: 1px solid rgba(255,255,255,0.2);
            border-right: 1px solid rgba(255,255,255,0.2);
            opacity: 0.8;
            box-shadow: 0 0 5px rgba(0,0,0,0.05);
            z-index: 2;
        }

        .cheque-hologram::after {
            content: '';
            position: absolute;
            inset: 0;
            background: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(255, 255, 255, 0.15) 5px, rgba(255, 255, 255, 0.15) 10px);
        }

        .cheque-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            z-index: 3;
            margin-left: 10px;
        }

        .cheque-bank-info {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .cheque-bank-name {
            font-family: 'Poppins', sans-serif;
            font-weight: 800;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            color: #0b0922;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .cheque-branch-details {
            font-size: 0.48rem;
            color: #475569;
            line-height: 1.25;
            margin-top: 1px;
            text-align: left;
        }

        .cheque-date-box {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .date-squares {
            display: flex;
            gap: 1px;
            margin-bottom: 2px;
        }

        .date-squares span {
            width: 12px;
            height: 14px;
            border: 1px solid #0b0922;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.52rem;
            font-weight: 700;
            color: #0b0922;
            border-radius: 1px;
        }

        .date-validity {
            font-size: 0.4rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: bold;
        }

        .cheque-row {
            display: flex;
            align-items: flex-end;
            margin: 4px 0;
            z-index: 3;
            margin-left: 10px;
        }

        .cheque-label {
            font-weight: bold;
            font-size: 0.65rem;
            color: #0b0922;
            white-space: nowrap;
            display: flex;
            align-items: baseline;
            gap: 2px;
        }

        .hindi-text {
            font-size: 0.55rem;
            font-weight: normal;
            color: #64748b;
        }

        .cheque-line-fill {
            flex: 1;
            border-bottom: 1.5px dotted #64748b;
            margin: 0 6px;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.88rem;
            font-style: italic;
            font-weight: 700;
            color: #0f172a;
            padding-bottom: 1px;
            padding-left: 4px;
        }

        .bearer-text {
            font-size: 0.55rem !important;
        }

        .cheque-amount-box {
            width: 110px;
            height: 24px;
            border: 2px double #0b0922;
            background: white;
            border-radius: 2px;
            display: flex;
            align-items: center;
            padding: 0 6px;
            position: relative;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
        }

        .rupee-symbol {
            font-size: 0.8rem;
            font-weight: 800;
            color: #0b0922;
            border-right: 1.5px solid #0b0922;
            padding-right: 5px;
            height: 100%;
            display: flex;
            align-items: center;
        }

        .amount-val {
            flex: 1;
            font-family: monospace;
            font-size: 0.85rem;
            font-weight: 700;
            text-align: right;
            color: #0b0922;
        }

        .cheque-details-row {
            display: grid;
            grid-template-columns: 1.3fr 0.6fr 1.3fr 1fr;
            gap: 10px;
            align-items: flex-end;
            margin-top: 6px;
            z-index: 3;
            margin-left: 10px;
        }

        .cheque-acc-box {
            border: 1.5px solid #0b0922;
            background: white;
            border-radius: 3px;
            display: flex;
            align-items: center;
            padding: 3px 6px;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);
        }

        .acc-label {
            font-size: 0.45rem;
            font-weight: bold;
            color: #0b0922;
            border-right: 1px solid #cbd5e1;
            padding-right: 4px;
            margin-right: 4px;
            line-height: 1.2;
            white-space: nowrap;
        }

        .acc-val {
            font-family: monospace;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: #0f172a;
        }

        .cheque-branch-codes {
            font-size: 0.45rem;
            color: #475569;
            font-family: monospace;
            line-height: 1.2;
            font-weight: 600;
            text-align: left;
        }

        .cheque-payable-text {
            font-size: 0.42rem;
            color: #64748b;
            line-height: 1.2;
            border-left: 1px solid #cbd5e1;
            padding-left: 6px;
            text-align: left;
        }

        .cheque-sign-area {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            text-align: right;
        }

        .cheque-sign-name {
            font-family: 'Brush Script MT', cursive, sans-serif;
            font-size: 1.15rem;
            font-style: italic;
            color: #2563eb;
            margin-bottom: 1px;
            font-weight: 500;
            max-width: 110px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .cheque-sign-label {
            font-size: 0.44rem;
            color: #475569;
            font-weight: bold;
        }

        .cheque-micr-band {
            text-align: center;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 3px;
            color: #0b0922;
            margin-top: 10px;
            margin-bottom: 1px;
            border-top: 1px dashed rgba(99, 102, 241, 0.1);
            padding-top: 6px;
            z-index: 3;
            margin-left: 10px;
        }

        /* Watermark stamp for processed cheques */
        .cheque-processed-stamp {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-15deg);
            font-size: 2.5rem;
            font-weight: 900;
            padding: 6px 16px;
            border: 4px solid;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 3px;
            z-index: 50;
            pointer-events: none;
            display: none;
            background: rgba(255, 255, 255, 0.92);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .cheque-processed-stamp.approved {
            color: #10b981;
            border-color: #10b981;
        }

        .cheque-processed-stamp.rejected {
            color: #ef4444;
            border-color: #ef4444;
        }

        .cheque-processed-stamp.pending {
            color: #fbbf24;
            border-color: #fbbf24;
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
            z-index: 60;
        }

        /* Unified Class-Based styles for Cheque Book Visuals */
        .cb-back-logo-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-top: 10px;
            position: relative;
            z-index: 2;
        }
        .cb-back-logo-img-box {
            width: 45px;
            height: 45px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .cb-back-logo-img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .cb-back-bank-name {
            font-weight: 800;
            font-size: 0.9rem;
            letter-spacing: 2px;
            color: #fff;
            margin-top: 4px;
            font-family: 'Poppins', sans-serif;
            line-height: 1.1;
        }
        .cb-back-bank-sub {
            font-size: 0.52rem;
            letter-spacing: 1.5px;
            color: rgba(255,255,255,0.7);
            font-weight: bold;
            font-family: 'Poppins', sans-serif;
        }
        .cb-back-bank-motto {
            font-size: 0.42rem;
            letter-spacing: 1px;
            color: rgba(255,255,255,0.5);
            font-weight: 500;
            font-family: 'Poppins', sans-serif;
            margin-top: 3px;
            text-transform: uppercase;
        }
        .cb-back-footer-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            position: relative;
            z-index: 2;
            border-top: 1px solid rgba(255,255,255,0.08);
            padding-top: 6px;
        }
        .cb-back-address {
            font-family: 'Poppins', sans-serif;
            font-size: 0.42rem;
            line-height: 1.25;
            color: rgba(255,255,255,0.5);
            text-align: left;
        }
        .cb-back-contact-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.45rem;
            color: rgba(255,255,255,0.6);
            align-items: flex-end;
        }
        .cb-back-contact-info span i {
            vertical-align: middle;
            color: #00d2ff;
            margin-right: 3px;
        }
        
        .cb-inside-body {
            flex: 1;
            padding: 8px 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            font-size: 0.7rem;
            position: relative;
            z-index: 2;
        }
        .cb-inside-body-title {
            text-align: center;
            font-weight: bold;
            margin-bottom: 6px;
            color: #475569;
            font-size: 0.68rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .cb-inside-table {
            width: 100%;
            border-collapse: collapse;
            line-height: 1.35;
        }
        .cb-inside-row {
            border-bottom: 1px dashed #cbd5e1;
        }
        .cb-inside-label {
            color: #64748b;
            padding: 2px 0;
            font-size: 0.62rem;
        }
        .cb-inside-value {
            font-weight: 700;
            color: #0f172a;
            padding: 2px 0;
            font-size: 0.65rem;
        }
        .cb-inside-value.caps {
            text-transform: uppercase;
        }
        .cb-inside-value.mono {
            font-family: monospace;
        }

        @keyframes pulseHint {
            0%, 100% { opacity: 0.5; transform: translateX(0); }
            50% { opacity: 1; transform: translateX(3px); }
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
            background: rgba(255, 255, 255, 0.85) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            width: 100%;
            max-width: 680px;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            max-height: 90vh;
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
            flex-shrink: 0;
        }

        .modal-body {
            padding: 25px;
            overflow-y: auto;
            max-height: calc(90vh - 80px);
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

        /* --- DARK MODE SIMULATOR & CUSTOMIZER CONTROLS --- */
        body.dark-mode .control-label {
            color: var(--gray-400);
        }
        body.dark-mode .control-input, body.dark-mode .control-select {
            background: rgba(15, 23, 42, 0.45) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: var(--white) !important;
        }
        body.dark-mode .control-input:focus, body.dark-mode .control-select:focus {
            border-color: var(--primary-500) !important;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.25) !important;
        }
        body.dark-mode .simulator-display {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.02) 0%, rgba(6, 182, 212, 0.02) 100%) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
        }
        body.dark-mode .modal-content {
            background: rgba(15, 23, 42, 0.85) !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
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
            .mobile-grid-1 {
                grid-template-columns: 1fr !important;
            }
        }

        /* Show both pages side-by-side in modals on larger viewports */
        @media (min-width: 768px) {
            .modal .chequebook-book.open .chequebook-cover-wrapper {
                opacity: 1 !important;
                visibility: visible !important;
                pointer-events: auto !important;
            }

            .modal .chequebook-page.page-instructions.turned {
                opacity: 1 !important;
                visibility: visible !important;
                pointer-events: auto !important;
            }
        }

        /* Modal scaling rules to ensure perfect sizing and no cropping */
        .modal .chequebook-wrapper {
            transform: scale(1);
            transform-origin: center center;
            transition: transform 0.3s ease;
        }

        @media (max-width: 991px) {
            .modal .chequebook-wrapper {
                transform: scale(0.8);
            }
        }

        @media (max-width: 767px) {
            /* Fallback to centered single page mode on mobile modal viewports */
            .modal .chequebook-wrapper {
                transform: scale(0.75);
            }
        }

        @media (max-width: 480px) {
            .modal .chequebook-wrapper {
                transform: scale(0.65);
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
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
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
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list" class="active"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
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
            <!-- Page Header -->
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Cheque Book Request Management</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Manage customer cheque book requests. Rejections automatically refund upfront fees and post statement entries.</p>
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
                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-book-open"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Total Requests</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${requests.size()}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid #fbbf24;">
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #fbbf24;">
                        <i class="bx bx-time"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Pending Review</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${pendingCount}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                        <i class="bx bx-check-double"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Approved Books</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${approvedCount}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid #ef4444;">
                    <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                        <i class="bx bx-x-circle"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Rejected / Refunded</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${rejectedCount}</h3>
                    </div>
                </div>
            </div>


            <!-- Flagship Interactive VGB 3D Cheque Demo Showcase & Live Simulator -->
            <div class="glass-card" style="padding: 30px; margin-bottom: 40px; background: linear-gradient(135deg, rgba(255, 255, 255, 0.8) 0%, rgba(255, 255, 255, 0.65) 100%); border: 1px solid rgba(99, 102, 241, 0.2);">
                <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--gray-800); margin-bottom: 8px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-cube" style="color: var(--primary-500); font-size: 1.5rem;"></i> 
                    Flagship VGB Premium 3D Cheque Showcase & Live Simulator
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 25px;">
                    Explore the flagship dynamic 3D Cheque layout. Hover to trigger interactive tilt physics. Use the controls to adjust date squares, cursive signatory values, and capacity live!
                </p>
                
                <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; align-items: center;" class="mobile-grid-1">
                    <!-- Left: Cheque Visualizer Showcase -->
                    <div class="cheque-visualizer-container" style="padding: 40px 20px; min-height: 330px; background: linear-gradient(135deg, rgba(99, 102, 241, 0.04) 0%, rgba(6, 182, 212, 0.04) 100%); border: 1px solid rgba(99, 102, 241, 0.15); border-radius: var(--radius-lg); position: relative; box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.05); display: flex; align-items: center; justify-content: center;">
                        <div style="position: absolute; top: 12px; left: 15px; display: flex; gap: 8px; align-items: center; pointer-events: none;">
                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); font-size: 0.7rem; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 4px;">
                                <i class="bx bx-expand-alt" style="font-size: 0.8rem;"></i> 3D Sandbox
                            </span>
                        </div>
                        <button type="button" class="btn" style="position: absolute; top: 12px; right: 15px; background: rgba(99, 102, 241, 0.1); color: var(--primary-500); border: 1px solid rgba(99, 102, 241, 0.2); padding: 5px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 4px; z-index: 100;" onclick="openFullChequeDemo3D(event)"><i class="bx bx-expand"></i> View Full 3D</button>
                        <button type="button" class="btn-flip-book" onclick="toggleDemoBookFlip(event)">
                            <i class="bx bx-refresh"></i> Flip Booklet
                        </button>

                        <div class="chequebook-wrapper" id="demoChequebookWrapper" onclick="toggleDemoBookOpen()">
                            <div class="chequebook-book" id="demo3dChequebook">
                                <!-- 1. Back Cover -->
                                <div class="chequebook-back">
                                    <div class="cb-back-logo-section">
                                        <svg viewBox="0 0 100 100" style="width: 45px; height: 45px; filter: drop-shadow(0 0 8px rgba(121, 40, 202, 0.45));">
                                            <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="url(#vCoverGrad)" />
                                        </svg>
                                        <span class="cb-back-bank-name">VERTEX</span>
                                        <span class="cb-back-bank-sub">GALAXY BANK</span>
                                        <span class="cb-back-slogan">Your Universe. Your Bank.</span>
                                    </div>
                                    
                                    <div class="cb-back-info-block">
                                        <div class="cb-back-info-item">
                                            <i class="bx bx-map"></i>
                                            <span>123 Galaxy Avenue, Nebula City, Cosmos State 12345</span>
                                        </div>
                                        <div class="cb-back-info-item">
                                            <i class="bx bx-phone"></i>
                                            <span>+1 234 567 8900</span>
                                        </div>
                                        <div class="cb-back-info-item">
                                            <i class="bx bx-globe"></i>
                                            <span>www.vertexgalaxybank.com</span>
                                        </div>
                                        <div class="cb-back-info-item">
                                            <i class="bx bx-envelope"></i>
                                            <span>support@vertexgalaxybank.com</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 2. Page 2: Cheque Leaf (Front/Back) -->
                                <div class="chequebook-page page-cheque" style="z-index: 20;">
                                    <div class="cheque-leaf-wrapper" id="demoChequeLeafFlipWrapper">
                                        <!-- Cheque Leaf Front -->
                                        <div class="cheque-leaf-front" onclick="toggleDemoChequeLeafFlip(event)">
                                            <!-- Watermark background SVG -->
                                            <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                                <ellipse cx="80" cy="80" rx="40" ry="15" fill="none" stroke="#7928ca" stroke-width="1.2" transform="rotate(-15 80 80)" />
                                                <ellipse cx="80" cy="80" rx="60" ry="25" fill="none" stroke="#7928ca" stroke-width="1.8" transform="rotate(-15 80 80)" />
                                                <ellipse cx="80" cy="80" rx="80" ry="35" fill="none" stroke="#00d2ff" stroke-width="0.9" transform="rotate(-15 80 80)" />
                                            </svg>
                                            
                                            <!-- Hologram ribbon -->
                                            <div class="cheque-hologram"></div>
                                            
                                            <!-- Header -->
                                            <div class="cheque-header">
                                                <div class="cheque-bank-info">
                                                    <span class="cheque-bank-name">
                                                        <svg viewBox="0 0 100 100" style="width: 14px; height: 14px;">
                                                            <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="#0b0922" />
                                                        </svg>
                                                        VERTEX GALAXY BANK
                                                    </span>
                                                    <span class="cheque-branch-details">BHAKTINAGAR CIRCLE, BHAKTINAGAR CO-OP HOUSING SOC LTD,<br>80 FT ROAD CORNER, RAJKOT-360002 GUJARAT<br>RTGS / NEFT IFSC : VGB0000171</span>
                                                </div>
                                                <div class="cheque-date-box">
                                                    <div class="date-squares" id="demoChequeDateSquares">
                                                        <span>3</span><span>1</span><span>0</span><span>5</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                                    </div>
                                                    <div style="font-size: 0.45rem; color: #64748b; font-weight: bold; margin-top: 1px; text-transform: uppercase;">Valid for 3 months</div>
                                                </div>
                                            </div>
      
                                            <!-- Pay row -->
                                            <div class="cheque-row" style="margin-top: 5px;">
                                                <span class="cheque-label">PAY TO THE ORDER OF <span class="hindi-text">अदा करें</span></span>
                                                <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.82rem;" id="demoChequePayeeDisplay">Self or Bearer</span>
                                                <span class="cheque-label bearer-text">OR BEARER <span class="hindi-text">या धारक को</span></span>
                                            </div>
      
                                            <!-- Rupees row -->
                                            <div class="cheque-row">
                                                <span class="cheque-label">RUPEES / DOLLARS <span class="hindi-text">रुपये</span></span>
                                                <span class="cheque-line-fill" id="demoChequeRupeesTextDisplay">One Hundred and Fifty Rupees Only</span>
                                                <div class="cheque-amount-box">
                                                    <span class="rupee-symbol">₹</span>
                                                    <span class="amount-val" id="demoChequeAmountDisplay">150.00</span>
                                                </div>
                                            </div>
      
                                            <!-- Account details row -->
                                            <div class="cheque-details-row">
                                                <div class="cheque-acc-box">
                                                    <span class="acc-label">A/C No.<br><span class="hindi-text">खाता क्र.</span></span>
                                                    <span class="acc-val" id="demoChequeAccountDisplayVal">50100170255263</span>
                                                </div>
                                                <div class="cheque-branch-codes">
                                                    Brn: 0171 Pdt: 105<br>SB A/C
                                                </div>
                                                <div class="cheque-payable-text">
                                                    Payable at par through clearing/transfer at all branches of VERTEX GALAXY BANK LTD
                                                </div>
                                                <div class="cheque-sign-area">
                                                    <span class="cheque-sign-name" id="demoChequeSignatureVal">MIHIR BHAYANI</span>
                                                    <span class="cheque-sign-label">Please sign above / Authorized Signatory</span>
                                                </div>
                                            </div>
      
                                            <!-- Bottom MICR band -->
                                            <div class="cheque-micr-band" id="demoChequeMicrVal" style="display: flex; align-items: center; justify-content: center; gap: 20px;">
                                                <span>⑈000076⑈</span> <span>360240005⑆</span> <span>255263⑈</span> <span>31</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Cheque Leaf Back -->
                                        <div class="cheque-leaf-back-side" onclick="toggleDemoChequeLeafFlip(event)">
                                            <!-- Watermark background SVG -->
                                            <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                                <ellipse cx="80" cy="80" rx="40" ry="15" fill="none" stroke="#94a3b8" stroke-width="1.2" transform="rotate(-15 80 80)" />
                                                <ellipse cx="80" cy="80" rx="60" ry="25" fill="none" stroke="#94a3b8" stroke-width="1.8" transform="rotate(-15 80 80)" />
                                            </svg>
                                            
                                            <div style="display: flex; gap: 20px; height: 100%; box-sizing: border-box; position: relative; z-index: 2;">
                                                <!-- Signature Box -->
                                                <div style="flex: 1.1; display: flex; flex-direction: column; justify-content: space-between;">
                                                    <div style="border: 1px dashed #94a3b8; border-radius: 4px; background: rgba(255,255,255,0.7); height: 75px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 5px; box-sizing: border-box;">
                                                        <span class="cheque-sign-name" id="demoChequeSignatureBackVal" style="font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.2rem; font-style: italic; color: #2563eb; line-height: 1; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">MIHIR BHAYANI</span>
                                                        <span style="font-size: 0.42rem; color: #64748b; font-weight: bold; text-transform: uppercase; margin-top: 4px;">Please sign here</span>
                                                    </div>
                                                    <div style="height: 1.5px; border-bottom: 1px dashed #cbd5e1; width: 100%;"></div>
                                                    <div style="font-family: monospace; font-size: 0.72rem; letter-spacing: 2px; color: #334155; font-weight: bold; margin-top: 5px; text-align: center;">
                                                        ⑈123456⑈ 000123456789⑆ 123456⑈ 29
                                                    </div>
                                                </div>
                                                <!-- Notes -->
                                                <div style="flex: 0.9; display: flex; flex-direction: column; justify-content: space-between; border-left: 1px dashed #cbd5e1; padding-left: 15px; font-family: 'Poppins', sans-serif;">
                                                    <div>
                                                        <h4 style="margin: 0; font-size: 0.58rem; font-weight: bold; color: #0b0922; text-transform: uppercase; letter-spacing: 0.5px;">Notes / टिप्पणियां</h4>
                                                        <ul style="margin: 5px 0 0 10px; padding: 0; font-size: 0.45rem; color: #475569; display: flex; flex-direction: column; gap: 3px; list-style-type: disc;">
                                                            <li>This cheque is valid for three months from the date of issue.</li>
                                                            <li>Please ensure sufficient balance in your account.</li>
                                                            <li>Please cross the cheque if not used.</li>
                                                            <li style="font-weight: bold; color: #ef4444;">Do not write below this line.</li>
                                                        </ul>
                                                    </div>
                                                    <div style="font-size: 0.42rem; color: #94a3b8; font-weight: 500; text-transform: uppercase; text-align: right;">
                                                        * DO NOT WRITE BELOW THIS LINE
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 3. Page 1: Inside Middle Page (Check Register) -->
                                <div class="chequebook-page page-instructions" id="demoChequeInstructionsPage" onclick="toggleDemoInstructionsPage(event)" style="z-index: 25;">
                                    <!-- Front Face: Check Register Grid -->
                                    <div class="instructions-front">
                                        <div class="check-register-title-bar">CHECK REGISTER</div>
                                        <div class="check-register-content">
                                            <table class="check-register-table">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 12%;">DATE</th>
                                                        <th style="width: 32%;">DESCRIPTION</th>
                                                        <th style="width: 12%;">CHECK NO.</th>
                                                        <th style="width: 16%;">PAYMENT / DEBIT (-)</th>
                                                        <th style="width: 16%;">DEPOSIT / CREDIT (+)</th>
                                                        <th style="width: 4%;">✔</th>
                                                        <th style="width: 12%;">BALANCE</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                    <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <!-- Back Face: Watermark Blank Page -->
                                    <div class="instructions-back">
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <ellipse cx="50" cy="50" rx="30" ry="12" fill="none" stroke="#94a3b8" stroke-width="1.2" transform="rotate(-15 50 50)" />
                                            <ellipse cx="50" cy="50" rx="50" ry="20" fill="none" stroke="#94a3b8" stroke-width="1.8" transform="rotate(-15 50 50)" />
                                        </svg>
                                        <div style="display: flex; align-items: center; justify-content: center; height: 100%; font-size: 0.52rem; color: #94a3b8; font-weight: 500; font-family: 'Poppins', sans-serif; text-transform: uppercase; letter-spacing: 1px;">
                                            SAFE. SECURE. TRUSTED.
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 4. Folding Front Cover Wrapper -->
                                <div class="chequebook-cover-wrapper cover-flap">
                                    <!-- Front Cover Outer -->
                                    <div class="chequebook-cover-front">
                                        <div class="cover-nebula-bg"></div>
                                        <div class="cover-cosmic-logo">
                                            <svg viewBox="0 0 100 100" class="cb-cosmic-v-svg">
                                                <defs>
                                                    <linearGradient id="vCoverGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                                        <stop offset="0%" stop-color="#00d2ff" />
                                                        <stop offset="50%" stop-color="#7928ca" />
                                                        <stop offset="100%" stop-color="#ff007a" />
                                                    </linearGradient>
                                                    <filter id="coverGlow" x="-20%" y="-20%" width="140%" height="140%">
                                                        <feGaussianBlur stdDeviation="3.5" result="blur" />
                                                        <feMerge>
                                                            <feMergeNode in="blur" />
                                                            <feMergeNode in="SourceGraphic" />
                                                        </feMerge>
                                                    </filter>
                                                </defs>
                                                <ellipse cx="50" cy="58" rx="42" ry="11" fill="none" stroke="#00f0ff" stroke-width="1.8" transform="rotate(-18 50 58)" opacity="0.85" filter="url(#coverGlow)" />
                                                <ellipse cx="50" cy="58" rx="46" ry="6" fill="none" stroke="#d946ef" stroke-width="1.2" transform="rotate(18 50 58)" opacity="0.75" filter="url(#coverGlow)" />
                                                <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="url(#vCoverGrad)" filter="url(#coverGlow)" />
                                            </svg>
                                        </div>
                                        <div class="cover-text-group">
                                            <div class="cover-bank-name">VERTEX</div>
                                            <div class="cover-bank-sub">GALAXY BANK</div>
                                            <div class="cover-checkbook-title">CHECKBOOK</div>
                                        </div>
                                        <div class="cover-footer" style="display: flex; justify-content: space-between; align-items: center; font-size: 0.58rem; color: rgba(255,255,255,0.5); z-index: 5; margin-left: -20px;">
                                            <span>SAFE. SECURE. TRUSTED.</span>
                                            <span>SECURED BOOKLET</span>
                                        </div>
                                    </div>
                                    
                                    <!-- Front Cover Inner - Safety Protection Page -->
                                    <div class="chequebook-cover-inside">
                                        <div class="inside-rings-watermark"></div>
                                        
                                        <div class="protection-container">
                                            <div class="protection-left">
                                                <svg viewBox="0 0 100 100">
                                                    <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="url(#vCoverGrad)" />
                                                </svg>
                                                <span class="protection-bank-name">VERTEX</span>
                                                <span class="protection-bank-sub">GALAXY BANK</span>
                                            </div>
                                            
                                            <div class="protection-divider"></div>
                                            
                                            <div class="protection-right">
                                                <div class="protection-item">
                                                    <i class="bx bx-shield-alt-2"></i>
                                                    <div class="protection-text">
                                                        <strong>FOR YOUR PROTECTION</strong>
                                                        <span>Heat sensitive ink fades with heat.</span>
                                                    </div>
                                                </div>
                                                <div class="protection-item">
                                                    <i class="bx bx-file"></i>
                                                    <div class="protection-text">
                                                        <strong>SECURE PAPER</strong>
                                                        <span>Contains security fibers and watermark.</span>
                                                    </div>
                                                </div>
                                                <div class="protection-item">
                                                    <i class="bx bx-lock-alt"></i>
                                                    <div class="protection-text">
                                                        <strong>AUTHORIZED USE ONLY</strong>
                                                        <span>All checks are protected by strict security features.</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="protection-footer">
                                            Your Universe. Your Bank.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="click-hint" id="demoChequeHint" style="position: absolute; bottom: 12px; right: 15px; font-size: 0.65rem; color: var(--primary-500); display: flex; align-items: center; gap: 4px; font-weight: 500; animation: pulseHint 2s infinite; pointer-events: none;"><i class="bx bx-pointer"></i> Click to Open</div>
                    </div>

                    <!-- Right: Customizer Controls -->
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label style="font-size: 0.75rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; letter-spacing: 0.75px;">Book Capacity</label>
                                <select id="ctrlLeavesCount" class="control-select" onchange="syncDemoCheque()" style="width: 100%; padding: 11px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-size: 0.9rem; color: var(--gray-800); font-family: inherit;">
                                    <option value="25">25 Leaves (₹100)</option>
                                    <option value="50" selected>50 Leaves (₹150)</option>
                                    <option value="100">100 Leaves (₹250)</option>
                                </select>
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label style="font-size: 0.75rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; letter-spacing: 0.75px;">Cheque Color</label>
                                <select id="ctrlChequeTheme" class="control-select" onchange="syncDemoCheque()" style="width: 100%; padding: 11px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-size: 0.9rem; color: var(--gray-800); font-family: inherit;">
                                    <option value="sky" selected>Sky Blue (HDFC Style)</option>
                                    <option value="gold">Gold Mint (Royale)</option>
                                    <option value="emerald">Jade Emerald (Classic)</option>
                                    <option value="purple">Velvet Orchid (Premium)</option>
                                </select>
                            </div>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 6px;">
                            <label style="font-size: 0.75rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; letter-spacing: 0.75px;">Customer Account Name</label>
                            <input type="text" id="ctrlCustomerName" class="control-input" value="MIHIR BHAYANI" placeholder="CUSTOMER NAME" oninput="syncDemoCheque()" style="width: 100%; padding: 11px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-size: 0.9rem; color: var(--gray-800); font-family: inherit; text-transform: uppercase;">
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 6px;">
                            <label style="font-size: 0.75rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; letter-spacing: 0.75px;">Account Number</label>
                            <input type="text" id="ctrlAccountNumber" class="control-input" value="50100170255263" placeholder="14-Digit Account Number" oninput="syncDemoCheque()" style="width: 100%; padding: 11px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-size: 0.9rem; color: var(--gray-800); font-family: inherit;" maxlength="14">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label style="font-size: 0.75rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; letter-spacing: 0.75px;">Requested Date</label>
                                <input type="text" id="ctrlDate" class="control-input" value="31/05/2026" placeholder="DD/MM/YYYY" oninput="syncDemoCheque()" style="width: 100%; padding: 11px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-size: 0.9rem; color: var(--gray-800); font-family: inherit;" maxlength="10">
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label style="font-size: 0.75rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; letter-spacing: 0.75px;">Signature Pen</label>
                                <select id="ctrlPenColor" class="control-select" onchange="syncDemoCheque()" style="width: 100%; padding: 11px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; font-size: 0.9rem; color: var(--gray-800); font-family: inherit;">
                                    <option value="#2563eb" selected>Blue Pen</option>
                                    <option value="#0f172a">Black Pen</option>
                                    <option value="#10b981">Green Pen</option>
                                    <option value="#ef4444">Red Pen</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Global Requests Logs -->
            <div class="glass-card">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-task" style="color: var(--primary-500);"></i> Executive Cheque Book Request Ledger
                </h3>
                <div class="table-responsive">
                    <table class="table" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); padding-bottom: 10px; color: var(--gray-500); font-weight: 600; font-size: 0.85rem;">
                                <th style="padding: 12px;">ID</th>
                                <th style="padding: 12px;">Customer</th>
                                <th style="padding: 12px;">Linked Account</th>
                                <th style="padding: 12px;">Capacity</th>
                                <th style="padding: 12px;">Charges</th>
                                <th style="padding: 12px;">Requested Date</th>
                                <th style="padding: 12px;">Status</th>
                                <th style="padding: 12px; text-align: right;">Action Control</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                     <c:forEach var="req" items="${requests}">
                                         <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                         <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; vertical-align: middle;">
                                             <td style="padding: 15px;"><span class="badge-id">#${req.requestId}</span></td>
                                             <td style="padding: 15px; font-weight: 600; color: var(--gray-800);">${req.customerName}</td>
                                             <td style="padding: 15px;"><span class="badge-id">${req.accountNumber}</span></td>
                                             <td style="padding: 15px;"><strong>${req.leavesCount} Leaves</strong></td>
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
                                                     <c:when test="${req.status eq 'approved'}">
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
                                                 <c:choose>
                                                     <c:when test="${req.status eq 'pending'}">
                                                         <div style="display: flex; gap: 8px; justify-content: flex-end; align-items: center;">
                                                             <button type="button" class="btn" 
                                                                     data-id="${req.requestId}" 
                                                                     data-name="${req.customerName}" 
                                                                     data-account="${req.accountNumber}" 
                                                                     data-leaves="${req.leavesCount}" 
                                                                     data-charges="${req.charges}" 
                                                                     data-date="${formattedDate}" 
                                                                     data-status="${req.status}"
                                                                     style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #6366f1; color: white; border: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"
                                                                     onclick="inspectRequest(this)">
                                                                 <i class="bx bx-show"></i> View Leaf
                                                             </button>
                                                             <a href="${pageContext.request.contextPath}/chequebook?action=approve&id=${req.requestId}" 
                                                                class="btn btn-primary" 
                                                                style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); text-decoration: none; font-weight: 600;"
                                                                onclick="return confirm('Are you sure you want to approve this cheque book request? Account has_cheque_book will be activated.');">
                                                                 Approve
                                                             </a>
                                                             <a href="${pageContext.request.contextPath}/chequebook?action=reject&id=${req.requestId}" 
                                                                class="btn btn-danger" 
                                                                style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #ef4444; color: white; border: none; text-decoration: none; font-weight: 600;"
                                                                onclick="return confirm('Are you sure you want to reject this cheque book request? upfront fees of ₹${req.charges} will be refunded to customer account.');">
                                                                 Reject
                                                             </a>
                                                         </div>
                                                     </c:when>
                                                     <c:otherwise>
                                                         <div style="display: flex; gap: 8px; justify-content: flex-end; align-items: center;">
                                                             <button type="button" class="btn" 
                                                                     data-id="${req.requestId}" 
                                                                     data-name="${req.customerName}" 
                                                                     data-account="${req.accountNumber}" 
                                                                     data-leaves="${req.leavesCount}" 
                                                                     data-charges="${req.charges}" 
                                                                     data-date="${formattedDate}" 
                                                                     data-status="${req.status}"
                                                                     style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #6366f1; color: white; border: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"
                                                                     onclick="inspectRequest(this)">
                                                                 <i class="bx bx-show"></i> View Leaf
                                                             </button>
                                                             <span style="font-size: 0.8rem; color: var(--gray-400); font-style: italic;">Reviewed</span>
                                                         </div>
                                                     </c:otherwise>
                                                 </c:choose>
                                             </td>
                                         </tr>
                                     </c:forEach>
                                 </c:when>
                                 <c:otherwise>
                                     <tr>
                                         <td colspan="8" style="padding: 30px; text-align: center; color: var(--gray-400); font-style: italic;">
                                             <i class="bx bx-info-circle" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i> No cheque book requests have been submitted.
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

    <!-- Modal: Premium 3D Cheque Inspector -->
    <div id="inspectModal" class="modal">
        <div class="modal-content" style="max-width: 920px; width: 95%;">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-show"></i> Interactive Cheque Inspector</h3>
                <button type="button" onclick="closeInspectModal()" class="close-btn">&times;</button>
            </div>
            <div class="modal-body" style="padding-top: 20px;">
                
                <!-- Cheque Info Card Grid -->
                <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 0.85rem; color: var(--gray-600); padding: 0 10px;">
                    <div><strong>Request ID:</strong> <span id="inspectRequestId" style="font-weight: 700; color: var(--gray-900);">#--</span></div>
                    <div><strong>Capacity:</strong> <span id="inspectCapacity" style="font-weight: 700; color: var(--gray-900);">--</span></div>
                    <div><strong>Charges:</strong> <span id="inspectCharges" style="font-weight: 700; color: var(--gray-900);">--</span></div>
                </div>

                <!-- 3D Cheque Visualizer -->
                <div class="cheque-visualizer-container" style="margin-bottom: 20px;">
                    <button type="button" class="btn-flip-book" onclick="toggleInspectBookFlip(event)">
                        <i class="bx bx-refresh"></i> Flip Booklet
                    </button>
                    <div class="chequebook-wrapper" id="inspectChequebookWrapper" onclick="toggleInspectBookOpen()">
                        <div class="chequebook-book" id="inspect3dChequebook">
                            <!-- 1. Back Cover -->
                            <div class="chequebook-back">
                                <div class="cb-back-logo-section">
                                    <svg viewBox="0 0 100 100" style="width: 45px; height: 45px; filter: drop-shadow(0 0 8px rgba(121, 40, 202, 0.45));">
                                        <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="url(#vCoverGrad)" />
                                    </svg>
                                    <span class="cb-back-bank-name">VERTEX</span>
                                    <span class="cb-back-bank-sub">GALAXY BANK</span>
                                    <span class="cb-back-slogan">Your Universe. Your Bank.</span>
                                </div>
                                
                                <div class="cb-back-info-block">
                                    <div class="cb-back-info-item">
                                        <i class="bx bx-map"></i>
                                        <span>123 Galaxy Avenue, Nebula City, Cosmos State 12345</span>
                                    </div>
                                    <div class="cb-back-info-item">
                                        <i class="bx bx-phone"></i>
                                        <span>+1 234 567 8900</span>
                                    </div>
                                    <div class="cb-back-info-item">
                                        <i class="bx bx-globe"></i>
                                        <span>www.vertexgalaxybank.com</span>
                                    </div>
                                    <div class="cb-back-info-item">
                                        <i class="bx bx-envelope"></i>
                                        <span>support@vertexgalaxybank.com</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 2. Page 2: Cheque Leaf (Front/Back) -->
                            <div class="chequebook-page page-cheque" style="z-index: 20;">
                                <div class="cheque-leaf-wrapper" id="inspectChequeLeafFlipWrapper">
                                    <!-- Cheque Leaf Front -->
                                    <div class="cheque-leaf-front" onclick="toggleInspectChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <ellipse cx="80" cy="80" rx="40" ry="15" fill="none" stroke="#7928ca" stroke-width="1.2" transform="rotate(-15 80 80)" />
                                            <ellipse cx="80" cy="80" rx="60" ry="25" fill="none" stroke="#7928ca" stroke-width="1.8" transform="rotate(-15 80 80)" />
                                            <ellipse cx="80" cy="80" rx="80" ry="35" fill="none" stroke="#00d2ff" stroke-width="0.9" transform="rotate(-15 80 80)" />
                                        </svg>
                                        
                                        <!-- Hologram ribbon -->
                                        <div class="cheque-hologram"></div>
                                        
                                        <!-- Header -->
                                        <div class="cheque-header">
                                            <div class="cheque-bank-info">
                                                <span class="cheque-bank-name">
                                                    <svg viewBox="0 0 100 100" style="width: 14px; height: 14px;">
                                                        <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="#0b0922" />
                                                    </svg>
                                                    VERTEX GALAXY BANK
                                                </span>
                                                <span class="cheque-branch-details">BHAKTINAGAR CIRCLE, BHAKTINAGAR CO-OP HOUSING SOC LTD,<br>80 FT ROAD CORNER, RAJKOT-360002 GUJARAT<br>RTGS / NEFT IFSC : VGB0000171</span>
                                            </div>
                                            <div class="cheque-date-box">
                                                <div class="date-squares" id="inspectChequeDateSquares">
                                                    <!-- Populated by JS -->
                                                </div>
                                                <div style="font-size: 0.45rem; color: #64748b; font-weight: bold; margin-top: 1px; text-transform: uppercase;">Valid for 3 months</div>
                                            </div>
                                        </div>
  
                                        <!-- Pay row -->
                                        <div class="cheque-row" style="margin-top: 5px;">
                                            <span class="cheque-label">PAY TO THE ORDER OF <span class="hindi-text">अदा करें</span></span>
                                            <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.82rem;" id="inspectChequePayeeDisplay">Self or Bearer</span>
                                            <span class="cheque-label bearer-text">OR BEARER <span class="hindi-text">या धारक को</span></span>
                                        </div>
  
                                        <!-- Rupees row -->
                                        <div class="cheque-row">
                                            <span class="cheque-label">RUPEES / DOLLARS <span class="hindi-text">रुपये</span></span>
                                            <span class="cheque-line-fill" id="inspectChequeRupeesTextDisplay">--</span>
                                            <div class="cheque-amount-box">
                                                <span class="rupee-symbol">₹</span>
                                                <span class="amount-val" id="inspectChequeAmountDisplay">--</span>
                                            </div>
                                        </div>
  
                                        <!-- Account details row -->
                                        <div class="cheque-details-row">
                                            <div class="cheque-acc-box">
                                                <span class="acc-label">A/C No.<br><span class="hindi-text">खाता क्र.</span></span>
                                                <span class="acc-val" id="inspectChequeAccountDisplayVal">--</span>
                                            </div>
                                            <div class="cheque-branch-codes">
                                                Brn: 0171 Pdt: 105<br>SB A/C
                                            </div>
                                            <div class="cheque-payable-text">
                                                Payable at par through clearing/transfer at all branches of VERTEX GALAXY BANK LTD
                                            </div>
                                            <div class="cheque-sign-area">
                                                <span class="cheque-sign-name" id="inspectChequeSignatureVal">--</span>
                                                <span class="cheque-sign-label">Please sign above / Authorized Signatory</span>
                                            </div>
                                        </div>
  
                                        <!-- Bottom MICR band -->
                                        <div class="cheque-micr-band" id="inspectChequeMicrVal" style="display: flex; align-items: center; justify-content: center; gap: 20px;">
                                            <!-- Populated by JS -->
                                        </div>
                                    </div>
                                    
                                    <!-- Cheque Leaf Back -->
                                    <div class="cheque-leaf-back-side" onclick="toggleInspectChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <ellipse cx="80" cy="80" rx="40" ry="15" fill="none" stroke="#94a3b8" stroke-width="1.2" transform="rotate(-15 80 80)" />
                                            <ellipse cx="80" cy="80" rx="60" ry="25" fill="none" stroke="#94a3b8" stroke-width="1.8" transform="rotate(-15 80 80)" />
                                        </svg>
                                        
                                        <div style="display: flex; gap: 20px; height: 100%; box-sizing: border-box; position: relative; z-index: 2;">
                                            <!-- Signature Box -->
                                            <div style="flex: 1.1; display: flex; flex-direction: column; justify-content: space-between;">
                                                <div style="border: 1px dashed #94a3b8; border-radius: 4px; background: rgba(255,255,255,0.7); height: 75px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 5px; box-sizing: border-box;">
                                                    <span class="cheque-sign-name" id="inspectChequeSignatureBackVal" style="font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.2rem; font-style: italic; color: #2563eb; line-height: 1; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"></span>
                                                    <span style="font-size: 0.42rem; color: #64748b; font-weight: bold; text-transform: uppercase; margin-top: 4px;">Please sign here</span>
                                                </div>
                                                <div style="height: 1.5px; border-bottom: 1px dashed #cbd5e1; width: 100%;"></div>
                                                <div style="font-family: monospace; font-size: 0.72rem; letter-spacing: 2px; color: #334155; font-weight: bold; margin-top: 5px; text-align: center;">
                                                    ⑈123456⑈ 000123456789⑆ 123456⑈ 29
                                                </div>
                                            </div>
                                            <!-- Notes -->
                                            <div style="flex: 0.9; display: flex; flex-direction: column; justify-content: space-between; border-left: 1px dashed #cbd5e1; padding-left: 15px; font-family: 'Poppins', sans-serif;">
                                                <div>
                                                    <h4 style="margin: 0; font-size: 0.58rem; font-weight: bold; color: #0b0922; text-transform: uppercase; letter-spacing: 0.5px;">Notes / टिप्पणियां</h4>
                                                    <ul style="margin: 5px 0 0 10px; padding: 0; font-size: 0.45rem; color: #475569; display: flex; flex-direction: column; gap: 3px; list-style-type: disc;">
                                                        <li>This cheque is valid for three months from the date of issue.</li>
                                                        <li>Please ensure sufficient balance in your account.</li>
                                                        <li>Please cross the cheque if not used.</li>
                                                        <li style="font-weight: bold; color: #ef4444;">Do not write below this line.</li>
                                                    </ul>
                                                </div>
                                                <div style="font-size: 0.42rem; color: #94a3b8; font-weight: 500; text-transform: uppercase; text-align: right;">
                                                    * DO NOT WRITE BELOW THIS LINE
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 3. Page 1: Inside Middle Page (Check Register) -->
                            <div class="chequebook-page page-instructions" id="inspectChequeInstructionsPage" onclick="toggleInspectInstructionsPage(event)" style="z-index: 25;">
                                <!-- Front Face: Check Register Grid -->
                                <div class="instructions-front">
                                    <div class="check-register-title-bar">CHECK REGISTER</div>
                                    <div class="check-register-content">
                                        <table class="check-register-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 12%;">DATE</th>
                                                    <th style="width: 32%;">DESCRIPTION</th>
                                                    <th style="width: 12%;">CHECK NO.</th>
                                                    <th style="width: 16%;">PAYMENT / DEBIT (-)</th>
                                                    <th style="width: 16%;">DEPOSIT / CREDIT (+)</th>
                                                    <th style="width: 4%;">✔</th>
                                                    <th style="width: 12%;">BALANCE</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                                <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <!-- Back Face: Watermark Blank Page -->
                                <div class="instructions-back">
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <ellipse cx="50" cy="50" rx="30" ry="12" fill="none" stroke="#94a3b8" stroke-width="1.2" transform="rotate(-15 50 50)" />
                                        <ellipse cx="50" cy="50" rx="50" ry="20" fill="none" stroke="#94a3b8" stroke-width="1.8" transform="rotate(-15 50 50)" />
                                    </svg>
                                    <div style="display: flex; align-items: center; justify-content: center; height: 100%; font-size: 0.52rem; color: #94a3b8; font-weight: 500; font-family: 'Poppins', sans-serif; text-transform: uppercase; letter-spacing: 1px;">
                                        SAFE. SECURE. TRUSTED.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 4. Folding Front Cover Wrapper -->
                            <div class="chequebook-cover-wrapper cover-flap">
                                <!-- Front Cover Outer -->
                                <div class="chequebook-cover-front">
                                    <div class="cover-nebula-bg"></div>
                                    <div class="cover-cosmic-logo">
                                        <svg viewBox="0 0 100 100" class="cb-cosmic-v-svg">
                                            <ellipse cx="50" cy="58" rx="42" ry="11" fill="none" stroke="#00f0ff" stroke-width="1.8" transform="rotate(-18 50 58)" opacity="0.85" filter="url(#coverGlow)" />
                                            <ellipse cx="50" cy="58" rx="46" ry="6" fill="none" stroke="#d946ef" stroke-width="1.2" transform="rotate(18 50 58)" opacity="0.75" filter="url(#coverGlow)" />
                                            <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="url(#vCoverGrad)" filter="url(#coverGlow)" />
                                        </svg>
                                    </div>
                                    <div class="cover-text-group">
                                        <div class="cover-bank-name">VERTEX</div>
                                        <div class="cover-bank-sub">GALAXY BANK</div>
                                        <div class="cover-checkbook-title">CHECKBOOK</div>
                                    </div>
                                    <div class="cover-footer" style="display: flex; justify-content: space-between; align-items: center; font-size: 0.58rem; color: rgba(255,255,255,0.5); z-index: 5; margin-left: -20px;">
                                        <span>SAFE. SECURE. TRUSTED.</span>
                                        <span>SECURED BOOKLET</span>
                                    </div>
                                </div>
                                
                                <!-- Front Cover Inner - Safety Protection Page -->
                                <div class="chequebook-cover-inside">
                                    <div class="inside-rings-watermark"></div>
                                    
                                    <div class="protection-container">
                                        <div class="protection-left">
                                            <svg viewBox="0 0 100 100">
                                                <path d="M22 18 L46 82 L54 82 L78 18 L65 18 L50 58 L35 18 Z" fill="url(#vCoverGrad)" />
                                            </svg>
                                            <span class="protection-bank-name">VERTEX</span>
                                            <span class="protection-bank-sub">GALAXY BANK</span>
                                        </div>
                                        
                                        <div class="protection-divider"></div>
                                        
                                        <div class="protection-right">
                                            <div class="protection-item">
                                                <i class="bx bx-shield-alt-2"></i>
                                                <div class="protection-text">
                                                    <strong>FOR YOUR PROTECTION</strong>
                                                    <span>Heat sensitive ink fades with heat.</span>
                                                </div>
                                            </div>
                                            <div class="protection-item">
                                                <i class="bx bx-file"></i>
                                                <div class="protection-text">
                                                    <strong>SECURE PAPER</strong>
                                                    <span>Contains security fibers and watermark.</span>
                                                </div>
                                            </div>
                                            <div class="protection-item">
                                                <i class="bx bx-lock-alt"></i>
                                                <div class="protection-text">
                                                    <strong>AUTHORIZED USE ONLY</strong>
                                                    <span>All checks are protected by strict security features.</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="protection-footer">
                                        Your Universe. Your Bank.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="click-hint" id="inspectChequeHint" style="position: absolute; bottom: 12px; right: 15px; font-size: 0.65rem; color: var(--primary-500); display: flex; align-items: center; gap: 4px; font-weight: 500; animation: pulseHint 2s infinite; pointer-events: none;"><i class="bx bx-pointer"></i> Click to Open</div>
                    <!-- Diagonal Stamp overlay -->
                    <div class="cheque-processed-stamp" id="stampOverlay">APPROVED</div>
                </div>

                <!-- Admin Action Buttons (for pending requests) -->
                <div id="inspectActionButtons" style="display: flex; gap: 15px; margin-top: 20px;">
                    <a href="#" id="inspectApproveBtn" class="btn btn-primary" style="flex: 1; text-align: center; padding: 14px; font-weight: 600; font-family: 'Poppins', sans-serif; font-size: 1rem; border-radius: var(--radius-md); text-decoration: none;">
                        Approve Request
                    </a>
                    <a href="#" id="inspectRejectBtn" class="btn btn-danger" style="flex: 1; text-align: center; padding: 14px; font-weight: 600; font-family: 'Poppins', sans-serif; font-size: 1rem; border-radius: var(--radius-md); background: #ef4444; color: white; border: none; text-decoration: none;">
                        Reject Request
                    </a>
                </div>

                <div style="text-align: center; margin-top: 15px;">
                    <button type="button" class="btn btn-secondary" onclick="closeInspectModal()" style="padding: 10px 25px; font-size: 0.9rem; font-weight: 600;">Close View</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Standard Scripts -->
    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function openInspectModal(requestId, customerName, accountNumber, leavesCount, charges, requestedDateStr, status) {
            const modal = document.getElementById('inspectModal');
            
            // Set dynamic fields
            const reqIdEl = document.getElementById('inspectRequestId');
            if (reqIdEl) reqIdEl.innerHTML = '#' + requestId;
            
            const capEl = document.getElementById('inspectCapacity');
            if (capEl) capEl.innerHTML = leavesCount + ' Leaves';
            
            const charEl = document.getElementById('inspectCharges');
            if (charEl) charEl.innerHTML = '₹ ' + charges.toFixed(2);
            
            // Sync Cheque visualizer
            const payeeEl = document.getElementById('inspectChequePayeeDisplay');
            if (payeeEl) payeeEl.innerHTML = 'Self or Bearer';
            
            let words = "One Hundred and Fifty Rupees Only";
            if (leavesCount === 25) {
                words = "One Hundred Rupees Only";
            } else if (leavesCount === 50) {
                words = "One Hundred and Fifty Rupees Only";
            } else if (leavesCount === 100) {
                words = "Two Hundred and Fifty Rupees Only";
            }
            
            const rupeesEl = document.getElementById('inspectChequeRupeesTextDisplay');
            if (rupeesEl) rupeesEl.innerHTML = words;
            
            const amtEl = document.getElementById('inspectChequeAmountDisplay');
            if (amtEl) amtEl.innerHTML = charges.toFixed(2);
            
            const accEl = document.getElementById('inspectChequeAccountDisplayVal');
            if (accEl) accEl.innerHTML = accountNumber;
            
            const sigEl = document.getElementById('inspectChequeSignatureVal');
            if (sigEl) sigEl.innerHTML = customerName ? customerName.toUpperCase() : '';
            
            const sigBackEl = document.getElementById('inspectChequeSignatureBackVal');
            if (sigBackEl) sigBackEl.innerHTML = customerName ? customerName.toUpperCase() : '';
            
            const pbCustEl = document.getElementById('inspectpbCustName');
            if (pbCustEl) pbCustEl.innerHTML = customerName ? customerName.toUpperCase() : '';
            
            const pbAccEl = document.getElementById('inspectpbAccNum');
            if (pbAccEl) pbAccEl.innerHTML = accountNumber;
            
            // MICR Band parsing
            const last6 = accountNumber.length >= 6 ? accountNumber.substring(accountNumber.length - 6) : "018696";
            const micrEl = document.getElementById('inspectChequeMicrVal');
            if (micrEl) micrEl.innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;
            
            // Date Squares parsing (Format expected: ddMMyyyy)
            const squares = document.getElementById('inspectChequeDateSquares');
            if (squares) {
                let dateStr = requestedDateStr;
                if (!dateStr || dateStr.length !== 8) {
                    // Fallback to today
                    const today = new Date();
                    const dd = String(today.getDate()).padStart(2, '0');
                    const mm = String(today.getMonth() + 1).padStart(2, '0');
                    const yyyy = String(today.getFullYear());
                    dateStr = dd + mm + yyyy;
                }
                let dateHtml = "";
                for (let i = 0; i < dateStr.length; i++) {
                    dateHtml += `<span>${dateStr.charAt(i)}</span>`;
                }
                squares.innerHTML = dateHtml;
            }

            // Handle stamp overlay
            const stampOverlay = document.getElementById('stampOverlay');
            if (status === 'approved' || status === 'delivered') {
                stampOverlay.innerHTML = 'APPROVED';
                stampOverlay.className = 'cheque-processed-stamp approved';
                stampOverlay.style.display = 'block';
                document.getElementById('inspectActionButtons').style.display = 'none';
            } else if (status === 'rejected') {
                stampOverlay.innerHTML = 'REJECTED';
                stampOverlay.className = 'cheque-processed-stamp rejected';
                stampOverlay.style.display = 'block';
                document.getElementById('inspectActionButtons').style.display = 'none';
            } else {
                // Pending request
                stampOverlay.style.display = 'none';
                document.getElementById('inspectActionButtons').style.display = 'flex';
                
                // Bind links to buttons
                const approveBtn = document.getElementById('inspectApproveBtn');
                const rejectBtn = document.getElementById('inspectRejectBtn');
                
                approveBtn.href = `${pageContext.request.contextPath}/chequebook?action=approve&id=${requestId}`;
                approveBtn.onclick = function() {
                    return confirm('Are you sure you want to approve this cheque book request? Account has_cheque_book will be activated.');
                };
                
                rejectBtn.href = `${pageContext.request.contextPath}/chequebook?action=reject&id=${requestId}`;
                rejectBtn.onclick = function() {
                    return confirm(`Are you sure you want to reject this cheque book request? upfront fees of ₹${charges.toFixed(2)} will be refunded to customer account.`);
                };
            }
            
            // Reset inspector book to closed and unflipped when opening modal
            const inspectBook = document.getElementById('inspect3dChequebook');
            if (inspectBook) {
                inspectBook.classList.remove('open');
            }
            const inspectLeaf = document.getElementById('inspectChequeLeafFlipWrapper');
            if (inspectLeaf) {
                inspectLeaf.classList.remove('flipped');
            }
            const inspectPage = document.getElementById('inspectChequeInstructionsPage');
            if (inspectPage) {
                inspectPage.classList.remove('turned');
            }
            const inspectHint = document.getElementById('inspectChequeHint');
            if (inspectHint) {
                inspectHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
            }

            // Copy date squares to issue date squares in instructions page
            const instrSquares = document.getElementById('inspectInstrIssueDate');
            if (instrSquares && squares) {
                instrSquares.innerHTML = squares.innerHTML;
            }

            modal.style.display = 'flex';
        }

        function closeInspectModal() {
            document.getElementById('inspectModal').style.display = 'none';
        }

        function inspectRequest(btn) {
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            const account = btn.getAttribute('data-account');
            const leaves = parseInt(btn.getAttribute('data-leaves'));
            const charges = parseFloat(btn.getAttribute('data-charges'));
            const date = btn.getAttribute('data-date');
            const status = btn.getAttribute('data-status');
            openInspectModal(id, name, account, leaves, charges, date, status);
        }

        const demoBook = document.getElementById('demo3dChequebook');
        const demoContainer = document.querySelector('.cheque-visualizer-container');
        const demoHint = document.getElementById('demoChequeHint');

        function updateDemoBookTransform(rotX = 0, rotY = 0) {
            if (!demoBook || !demoContainer) return;
            const currentContainer = demoBook.closest('#modalChequeScene') || demoContainer;
            const containerWidth = currentContainer.clientWidth;
            if (demoBook.classList.contains('open')) {
                const openScale = Math.min((containerWidth - 30) / 480, 0.8);
                demoBook.style.transform = `rotateX(${25 + rotX}deg) rotateY(${-5 + rotY}deg) scale(${openScale})`;
            } else if (demoBook.classList.contains('flipped-back')) {
                const closedScale = Math.min((containerWidth - 20) / 480, 0.9);
                demoBook.style.transform = `rotateX(${195 + rotX}deg) rotateY(${10 + rotY}deg) scale(${closedScale})`;
            } else {
                const closedScale = Math.min((containerWidth - 20) / 480, 0.9);
                demoBook.style.transform = `rotateX(${15 + rotX}deg) rotateY(${-10 + rotY}deg) scale(${closedScale})`;
            }
        }

        const inspectBook = document.getElementById('inspect3dChequebook');
        const inspectContainer = document.querySelector('#inspectModal .cheque-visualizer-container');
        const inspectHint = document.getElementById('inspectChequeHint');

        function updateInspectBookTransform(rotX = 0, rotY = 0) {
            if (!inspectBook || !inspectContainer) return;
            const containerWidth = inspectContainer.clientWidth;
            if (inspectBook.classList.contains('open')) {
                const openScale = Math.min((containerWidth - 30) / 480, 0.8);
                inspectBook.style.transform = `rotateX(${25 + rotX}deg) rotateY(${-5 + rotY}deg) scale(${openScale})`;
            } else if (inspectBook.classList.contains('flipped-back')) {
                const closedScale = Math.min((containerWidth - 20) / 480, 0.9);
                inspectBook.style.transform = `rotateX(${195 + rotX}deg) rotateY(${10 + rotY}deg) scale(${closedScale})`;
            } else {
                const closedScale = Math.min((containerWidth - 20) / 480, 0.9);
                inspectBook.style.transform = `rotateX(${15 + rotX}deg) rotateY(${-10 + rotY}deg) scale(${closedScale})`;
            }
        }

        window.updateInspectBookTransform = updateInspectBookTransform;

        function toggleDemoBookOpen() {
            if (!demoBook) return;
            demoBook.classList.remove('flipped-back');
            demoBook.classList.toggle('open');
            if (demoBook.classList.contains('open')) {
                if (demoHint) demoHint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
            } else {
                if (demoHint) demoHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
                const leaf = document.getElementById('demoChequeLeafFlipWrapper');
                if (leaf) leaf.classList.remove('flipped');
                const page = document.getElementById('demoChequeInstructionsPage');
                if (page) page.classList.remove('turned');
            }
            updateDemoBookTransform(0, 0);
        }

        function toggleDemoBookFlip(event) {
            if (event) event.stopPropagation();
            if (!demoBook) return;
            demoBook.classList.remove('open');
            demoBook.classList.toggle('flipped-back');
            if (demoBook.classList.contains('flipped-back')) {
                if (demoHint) demoHint.innerHTML = `<i class="bx bx-refresh"></i> Back Cover View`;
            } else {
                if (demoHint) demoHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
            }
            updateDemoBookTransform(0, 0);
        }
        
        function toggleDemoInstructionsPage(event) {
            if (event) event.stopPropagation();
            const page = document.getElementById('demoChequeInstructionsPage');
            if (page) {
                page.classList.toggle('turned');
                if (demoHint) {
                    if (page.classList.contains('turned')) {
                        demoHint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Leaf to Flip`;
                    } else {
                        demoHint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                    }
                }
            }
        }
        
        function toggleDemoChequeLeafFlip(event) {
            if (event) event.stopPropagation();
            const leaf = document.getElementById('demoChequeLeafFlipWrapper');
            if (leaf) {
                leaf.classList.toggle('flipped');
            }
        }

        function toggleInspectBookOpen() {
            if (!inspectBook) return;
            inspectBook.classList.remove('flipped-back');
            inspectBook.classList.toggle('open');
            if (inspectBook.classList.contains('open')) {
                if (inspectHint) inspectHint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
            } else {
                if (inspectHint) inspectHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
                const leaf = document.getElementById('inspectChequeLeafFlipWrapper');
                if (leaf) leaf.classList.remove('flipped');
                const page = document.getElementById('inspectChequeInstructionsPage');
                if (page) page.classList.remove('turned');
            }
            updateInspectBookTransform(0, 0);
        }

        function toggleInspectBookFlip(event) {
            if (event) event.stopPropagation();
            if (!inspectBook) return;
            inspectBook.classList.remove('open');
            inspectBook.classList.toggle('flipped-back');
            if (inspectBook.classList.contains('flipped-back')) {
                if (inspectHint) inspectHint.innerHTML = `<i class="bx bx-refresh"></i> Back Cover View`;
            } else {
                if (inspectHint) inspectHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
            }
            updateInspectBookTransform(0, 0);
        }
        
        function toggleInspectInstructionsPage(event) {
            if (event) event.stopPropagation();
            const page = document.getElementById('inspectChequeInstructionsPage');
            if (page) {
                page.classList.toggle('turned');
                if (inspectHint) {
                    if (page.classList.contains('turned')) {
                        inspectHint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Leaf to Flip`;
                    } else {
                        inspectHint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                    }
                }
            }
        }
        
        function toggleInspectChequeLeafFlip(event) {
            if (event) event.stopPropagation();
            const leaf = document.getElementById('inspectChequeLeafFlipWrapper');
            if (leaf) {
                leaf.classList.toggle('flipped');
            }
        }
        
        // Add outside click close listener and 3D tilt interaction
        document.addEventListener('DOMContentLoaded', () => {
            const inspectWrapper = document.getElementById('inspectChequebookWrapper');
            if (inspectWrapper && inspectBook && inspectContainer) {
                inspectContainer.addEventListener('mousemove', (e) => {
                    const rect = inspectContainer.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    const centerX = rect.width / 2;
                    const centerY = rect.height / 2;
                    const maxRotX = inspectBook.classList.contains('open') ? 10 : 15;
                    const maxRotY = inspectBook.classList.contains('open') ? 8 : 15;
                    const rotX = -((y - centerY) / centerY) * maxRotX;
                    const rotY = ((x - centerX) / centerX) * maxRotY;
                    requestAnimationFrame(() => {
                        updateInspectBookTransform(rotX, rotY);
                    });
                });
                
                inspectContainer.addEventListener('mouseleave', () => {
                    requestAnimationFrame(() => {
                        updateInspectBookTransform(0, 0);
                    });
                });

                updateInspectBookTransform(0, 0);
                window.addEventListener('resize', () => {
                    updateInspectBookTransform(0, 0);
                });
            }

            const demoWrapper = document.getElementById('demoChequebookWrapper');
            if (demoWrapper && demoBook && demoContainer) {
                const activeContainer = () => demoBook.closest('#modalChequeScene') || demoContainer;
                
                const handleMouseMove = (e) => {
                    const cont = activeContainer();
                    const rect = cont.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    const centerX = rect.width / 2;
                    const centerY = rect.height / 2;
                    const maxRotX = demoBook.classList.contains('open') ? 10 : 15;
                    const maxRotY = demoBook.classList.contains('open') ? 8 : 15;
                    const rotX = -((y - centerY) / centerY) * maxRotX;
                    const rotY = ((x - centerX) / centerX) * maxRotY;
                    requestAnimationFrame(() => {
                        updateDemoBookTransform(rotX, rotY);
                    });
                };
                
                const handleMouseLeave = () => {
                    requestAnimationFrame(() => {
                        updateDemoBookTransform(0, 0);
                    });
                };

                demoContainer.addEventListener('mousemove', handleMouseMove);
                demoContainer.addEventListener('mouseleave', handleMouseLeave);

                // Also support mouse tilt inside full screen modal scene
                const modalScene = document.getElementById('modalChequeScene');
                if (modalScene) {
                    modalScene.addEventListener('mousemove', (e) => {
                        if (demoBook.closest('#modalChequeScene')) {
                            handleMouseMove(e);
                        }
                    });
                    modalScene.addEventListener('mouseleave', handleMouseLeave);
                }

                updateDemoBookTransform(0, 0);
                window.addEventListener('resize', () => {
                    updateDemoBookTransform(0, 0);
                });
            }



            // Mobile menu toggle handler
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

            // Cursor glow follower
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

            // Sync initial state of showcase cheque
            syncDemoCheque();
        });

        function syncDemoCheque() {
            const leaves = parseInt(document.getElementById('ctrlLeavesCount').value);
            const theme = document.getElementById('ctrlChequeTheme').value;
            const name = document.getElementById('ctrlCustomerName').value.toUpperCase();
            const accNum = document.getElementById('ctrlAccountNumber').value;
            const dateStr = document.getElementById('ctrlDate').value;
            const penColor = document.getElementById('ctrlPenColor').value;

            // 1. Fee and text update
            let charges = 150;
            let words = "One Hundred and Fifty Rupees Only";
            if (leaves === 25) {
                charges = 100;
                words = "One Hundred Rupees Only";
            } else if (leaves === 50) {
                charges = 150;
                words = "One Hundred and Fifty Rupees Only";
            } else if (leaves === 100) {
                charges = 250;
                words = "Two Hundred and Fifty Rupees Only";
            }
            document.getElementById('demoChequeRupeesTextDisplay').innerHTML = words;
            document.getElementById('demoChequeAmountDisplay').innerHTML = charges.toFixed(2);

            // 2. Name & Account & Signature
            document.getElementById('demoChequeAccountDisplayVal').innerHTML = accNum;
            document.getElementById('demoChequeSignatureVal').innerHTML = name;
            document.getElementById('demoChequeSignatureVal').style.color = penColor;
            
            // Inside Cover Name & Account Sync
            const demoInsideName = document.getElementById('demopbCustName');
            if (demoInsideName) {
                demoInsideName.innerHTML = name;
            }
            const demoInsideAcc = document.getElementById('demopbAccNum');
            if (demoInsideAcc) {
                demoInsideAcc.innerHTML = accNum;
            }

            const last6 = accNum.length >= 6 ? accNum.substring(accNum.length - 6) : "255263";
            document.getElementById('demoChequeMicrVal').innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;

            // 3. Theme application
            const cheque = document.getElementById('demoChequeLeaf3D');
            if (cheque) {
                if (theme === 'sky') {
                    cheque.style.backgroundColor = '#e0f2fe';
                    cheque.style.backgroundImage = 'radial-gradient(circle at 10% 90%, rgba(99, 102, 241, 0.05) 0%, transparent 60%), radial-gradient(circle at 90% 10%, rgba(6, 182, 212, 0.04) 0%, transparent 50%), linear-gradient(to right, #bae6fd, #e0f2fe)';
                    cheque.style.borderColor = '#93c5fd';
                } else if (theme === 'gold') {
                    cheque.style.backgroundColor = '#fef3c7';
                    cheque.style.backgroundImage = 'radial-gradient(circle at 10% 90%, rgba(245, 158, 11, 0.06) 0%, transparent 60%), radial-gradient(circle at 90% 10%, rgba(217, 119, 6, 0.04), transparent 50%), linear-gradient(to right, #fde68a, #fef3c7)';
                    cheque.style.borderColor = '#fcd34d';
                } else if (theme === 'emerald') {
                    cheque.style.backgroundColor = '#d1fae5';
                    cheque.style.backgroundImage = 'radial-gradient(circle at 10% 90%, rgba(16, 185, 129, 0.05) 0%, transparent 60%), radial-gradient(circle at 90% 10%, rgba(4, 120, 87, 0.04) 0%, transparent 50%), linear-gradient(to right, #a7f3d0, #d1fae5)';
                    cheque.style.borderColor = '#6ee7b7';
                } else if (theme === 'purple') {
                    cheque.style.backgroundColor = '#f3e8ff';
                    cheque.style.backgroundImage = 'radial-gradient(circle at 10% 90%, rgba(139, 92, 246, 0.05) 0%, transparent 60%), radial-gradient(circle at 90% 10%, rgba(109, 40, 217, 0.04) 0%, transparent 50%), linear-gradient(to right, #e9d5ff, #f3e8ff)';
                    cheque.style.borderColor = '#d8b4fe';
                }
            }

            // 4. Date parsing (Format dd/mm/yyyy or simple text)
            const squares = document.getElementById('demoChequeDateSquares');
            if (squares) {
                // Remove slashes
                const pureDate = dateStr.replace(/\//g, '');
                let dateHtml = "";
                for (let i = 0; i < Math.min(8, pureDate.length); i++) {
                    dateHtml += `<span>${pureDate.charAt(i)}</span>`;
                }
                // Fill up remaining squares
                for (let i = pureDate.length; i < 8; i++) {
                    dateHtml += `<span>-</span>`;
                }
                squares.innerHTML = dateHtml;
                
                // Sync issue date squares in instructions page
                const instrSquares = document.getElementById('demoInstrIssueDate');
                if (instrSquares) {
                    instrSquares.innerHTML = dateHtml;
                }
            }
        }

        window.onclick = function(event) {
            const inspectModal = document.getElementById('inspectModal');
            if (event.target === inspectModal) {
                closeInspectModal();
            }
            const fullChequeModal = document.getElementById('fullChequeModal');
            if (event.target === fullChequeModal) {
                closeFullChequeDemo3D();
            }
        }

        // Modal open/close functions for full 3D cheque sandbox
        function openFullChequeDemo3D(event) {
            if (event) event.stopPropagation();
            const modal = document.getElementById('fullChequeModal');
            const modalScene = document.getElementById('modalChequeScene');
            const wrapper = document.getElementById('demoChequebookWrapper');
            
            modalScene.appendChild(wrapper);
            modal.style.display = 'flex';
        }

        function closeFullChequeDemo3D() {
            const modal = document.getElementById('fullChequeModal');
            const inlineScene = document.querySelector('.cheque-visualizer-container');
            const wrapper = document.getElementById('demoChequebookWrapper');
            
            inlineScene.appendChild(wrapper);
            modal.style.display = 'none';
        }
    </script>

    <!-- Full 3D Cheque Visualizer Modal Overlay -->
    <div id="fullChequeModal" class="modal">
        <div class="modal-content" style="max-width: 920px; width: 95%; padding: 30px; position: relative; display: flex; flex-direction: column; align-items: center;">
            <button type="button" onclick="closeFullChequeDemo3D()" class="close-btn" style="position: absolute; right: 20px; top: 20px; font-size: 1.8rem; z-index: 110;">&times;</button>
            
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <i class="bx bx-book-bookmark" style="color: var(--primary-500); font-size: 1.4rem;"></i> VGB Premium 3D Chequebook
            </h3>

            <!-- 3D Scene Container in Modal -->
            <div id="modalChequeScene" style="position: relative; perspective: 1200px; width: 100%; min-height: 350px; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, rgba(99, 102, 241, 0.02) 0%, rgba(236, 72, 153, 0.02) 100%); border-radius: var(--radius-md); padding: 40px 20px;">
                <button type="button" class="btn-flip-book" onclick="toggleDemoBookFlip(event)" style="bottom: 20px; left: 20px;">
                    <i class="bx bx-refresh"></i> Flip Booklet
                </button>
                <!-- Cheque wrapper will be appended here dynamically on open -->
            </div>
            
            <div style="font-size: 0.8rem; color: var(--gray-500); margin-top: 15px; text-align: center; font-weight: 500;">
                <i class="bx bx-mouse-alt" style="vertical-align: middle;"></i> Move mouse inside card/book to rotate. Click to flip open or flip the cheque leaf.
            </div>
        </div>
    </div>
</body>
</html>
