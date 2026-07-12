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

        /* ===== FLAT BOOKLET PASSBOOK PREVIEW AREA ===== */
        .passbook-preview-layout {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
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
            position: relative;
            background: linear-gradient(135deg, rgba(30, 27, 75, 0.02) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.02);
            height: 100%;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        body.dark-mode .passbook-visualizer-container {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.02) 0%, rgba(236, 72, 153, 0.02) 100%);
            border-color: rgba(255, 255, 255, 0.08);
        }

        .passbook-flat-preview {
            display: grid;
            grid-template-columns: 1fr 1.1fr;
            gap: 20px;
            width: 100%;
        }
        @media (max-width: 768px) {
            .passbook-flat-preview {
                grid-template-columns: 1fr;
            }
        }

        .passbook-flat-page {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.12);
            background: #ffffff;
            height: 250px;
            box-sizing: border-box;
            position: relative;
            transition: transform 0.3s ease;
        }
        body.dark-mode .passbook-flat-page {
            border-color: rgba(255, 255, 255, 0.08);
            background: rgba(30, 41, 59, 0.5);
        }
        .passbook-flat-page:hover {
            transform: translateY(-2px);
        }

        /* Cosmic styles */
        .cosmic-cover {
            background: radial-gradient(circle at 50% 50%, #0d0a2d 0%, #030211 80%, #000005 100%);
            color: #ffffff;
            padding: 16px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            box-sizing: border-box;
            position: relative;
        }

        .passbook-front-cover {
            background-image: url('${pageContext.request.contextPath}/assest/images/passbook/front-cover.png') !important;
            background-size: 100% 100% !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            border: none !important;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.3), 0 15px 35px rgba(0, 0, 0, 0.4) !important;
        }

        .passbook-back-cover {
            background-image: url('${pageContext.request.contextPath}/assest/images/passbook/back-cover.png') !important;
            background-size: 100% 100% !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            border: none !important;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.3), 0 15px 35px rgba(0, 0, 0, 0.4) !important;
        }

        .cosmic-cover::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 30% 30%, rgba(99, 102, 241, 0.25) 0%, transparent 60%),
                        radial-gradient(circle at 80% 80%, rgba(236, 72, 153, 0.2) 0%, transparent 50%);
            pointer-events: none;
        }

        .passbook-front-cover::before,
        .passbook-back-cover::before {
            display: none !important;
        }

        /* Orbits background for cover */
        .cosmic-orbits {
            position: absolute;
            inset: 0;
            pointer-events: none;
            opacity: 0.7;
        }

        .cosmic-orbits svg {
            width: 100%;
            height: 100%;
        }

        /* Spine vertical text */
        .spine-text {
            position: absolute;
            left: 2px;
            top: 20px;
            bottom: 20px;
            width: 12px;
            font-size: 0.38rem;
            font-weight: 800;
            color: rgba(255, 255, 255, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
            writing-mode: vertical-rl;
            text-orientation: mixed;
            display: flex;
            align-items: center;
            justify-content: space-between;
            pointer-events: none;
        }

        /* Cover Title Frame */
        .cover-title-frame {
            border-top: 1.5px solid rgba(0, 240, 255, 0.3);
            border-bottom: 1.5px solid rgba(0, 240, 255, 0.3);
            padding: 4px 0;
            margin: 5px 0;
            text-align: center;
            box-shadow: 0 0 10px rgba(0, 240, 255, 0.1);
        }

        .cover-title-frame h2 {
            font-size: 1.25rem !important;
            font-weight: 800 !important;
            letter-spacing: 4px !important;
            margin: 0 !important;
            background: linear-gradient(135deg, #00f0ff 0%, #d900ff 50%, #ffffff 100%);
            -webkit-background-clip: text !important;
            background-clip: text !important;
            -webkit-text-fill-color: transparent !important;
            text-shadow: 0 2px 10px rgba(0, 240, 255, 0.2);
            font-family: 'Poppins', sans-serif;
        }

        /* Cover Info / Contact line */
        .cover-contacts-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.42rem;
            color: rgba(255, 255, 255, 0.5);
            border-top: 1.5px solid rgba(255, 255, 255, 0.08);
            padding-top: 6px;
            font-family: 'Poppins', sans-serif;
        }

        .cover-contacts-row span {
            display: flex;
            align-items: center;
            gap: 3px;
        }

        /* Cover Icons row */
        .cover-icons-row {
            display: flex;
            justify-content: space-around;
            margin: 8px 0;
        }

        .cover-icon-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2px;
            font-size: 0.38rem;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 500;
        }

        .cover-icon-box i {
            font-size: 0.95rem;
            color: #d900ff;
            text-shadow: 0 0 8px rgba(236, 72, 153, 0.4);
        }

        /* Premium background inside panels style */
        .instructions-panel-inside {
            background-image: url('${pageContext.request.contextPath}/assest/images/passbook/inside-page-1.png') !important;
            background-size: 100% 100% !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            color: #0f172a !important;
            padding: 12px 16px !important;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            border: 1px solid rgba(99, 102, 241, 0.1) !important;
            border-radius: 12px;
        }

        .account-panel-inside {
            background-image: url('${pageContext.request.contextPath}/assest/images/passbook/inside-page-2.png') !important;
            background-size: 100% 100% !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            color: #0f172a !important;
            padding: 10px 14px !important;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            border: 1px solid rgba(99, 102, 241, 0.1) !important;
            border-radius: 12px;
        }

        .ledger-top-panel-inside {
            background-image: url('${pageContext.request.contextPath}/assest/images/passbook/inside-page-3.png') !important;
            background-size: 100% 100% !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            color: #0f172a !important;
            padding: 12px 14px !important;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            border: 1px solid rgba(99, 102, 241, 0.1) !important;
            border-radius: 12px;
        }

        .transaction-panel-inside {
            background-image: url('${pageContext.request.contextPath}/assest/images/passbook/inside-page-3.png') !important;
            background-size: 100% 100% !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            color: #0f172a !important;
            padding: 12px 14px !important;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            border: 1px solid rgba(99, 102, 241, 0.15) !important;
            border-radius: 12px;
        }

        /* Top header bar for Account Info Page */
        .inside-page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #6366f1;
            padding-bottom: 4px;
            margin-bottom: 6px;
        }

        .inside-page-header .header-left {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .inside-page-header .header-left img {
            width: 14px;
            height: 14px;
            object-fit: contain;
        }

        .inside-page-header .header-center {
            font-size: 0.52rem !important;
            font-weight: 800 !important;
            letter-spacing: 0.75px !important;
            color: #1e1b4b !important;
            text-transform: uppercase !important;
            font-family: 'Poppins', sans-serif;
        }

        .inside-page-header .header-right {
            font-size: 0.50rem !important;
            font-weight: 700 !important;
            color: #312e81 !important;
            letter-spacing: 0.5px !important;
            text-transform: uppercase !important;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 3px;
        }

        /* Credentials info grid updated */
        .tech-credentials-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.42rem !important;
            line-height: 1.3;
        }

        .tech-credentials-table td {
            padding: 2.5px 0 !important;
            border-bottom: 1px solid rgba(99, 102, 241, 0.08) !important;
            color: #1e293b !important;
        }

        .tech-credentials-table td:first-child {
            color: #475569 !important;
            width: 42%;
            font-weight: 600 !important;
        }

        .tech-credentials-table td:last-child {
            color: #0f172a !important;
            font-weight: 700 !important;
        }

        /* Important Instructions Box */
        .instructions-box-premium {
            border: 1px solid rgba(99, 102, 241, 0.25);
            background: rgba(255, 255, 255, 0.45);
            border-radius: 8px;
            padding: 8px 10px;
            height: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .instructions-box-premium h5 {
            font-size: 0.46rem !important;
            font-weight: 700 !important;
            color: #1e1b4b !important;
            margin: 0 0 5px 0 !important;
            text-transform: uppercase !important;
            text-align: center;
            border-bottom: 1px solid rgba(99, 102, 241, 0.15);
            padding-bottom: 3px;
        }

        .instructions-list-premium {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .instructions-list-premium li {
            font-size: 0.36rem !important;
            color: #475569 !important;
            line-height: 1.25;
            display: flex;
            align-items: flex-start;
            gap: 4px;
        }

        .instructions-list-premium li::before {
            content: "•";
            color: #4f46e5;
            font-weight: bold;
            margin-right: 2px;
        }

        /* Footer badges */
        .premium-footer-badges {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1.5px solid rgba(99, 102, 241, 0.15);
            padding-top: 4px;
            margin-top: 2px;
        }

        .badge-item-premium {
            display: flex;
            align-items: center;
            gap: 3px;
            font-size: 0.32rem !important;
            color: #1e1b4b !important;
            font-weight: 600 !important;
        }

        .badge-item-premium i {
            font-size: 0.50rem !important;
            color: #4f46e5 !important;
        }

        /* Cleaned old definition */

        /* Watermark V for transaction page */
        .transaction-watermark-v {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 100px;
            height: 100px;
            opacity: 0.035 !important;
            pointer-events: none;
            z-index: 1;
        }

        /* Transaction table grid */
        .tech-ledger-grid {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.34rem !important;
            z-index: 2;
            position: relative;
            table-layout: fixed;
        }

        .tech-ledger-grid th {
            padding: 3px 2px !important;
            background: #1e1b4b !important; /* Deep navy/purple */
            color: #ffffff !important;
            font-weight: 700 !important;
            font-size: 0.32rem !important;
            text-transform: uppercase !important;
            border: 1px solid rgba(99, 102, 241, 0.25) !important;
            letter-spacing: 0.1px !important;
            text-align: center !important;
            white-space: nowrap !important;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        body.dark-mode .tech-ledger-grid th {
            background: #1e1b4b !important;
            border-color: rgba(99, 102, 241, 0.25) !important;
        }

        .tech-ledger-grid td {
            padding: 3px 2px !important;
            border: 1px solid rgba(99, 102, 241, 0.12) !important;
            color: #334155 !important;
            font-weight: 600 !important;
            text-align: center !important;
            font-family: monospace !important;
            white-space: nowrap !important;
            font-size: 0.34rem !important;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        body.dark-mode .tech-ledger-grid td {
            border-color: rgba(99, 102, 241, 0.12) !important;
            color: #334155 !important;
        }

        .tech-ledger-grid td.particulars {
            text-align: left !important;
            font-family: inherit !important;
        }

        .tech-ledger-footer {
            font-size: 0.34rem !important;
            color: #475569 !important;
            text-align: left !important;
            font-weight: 500 !important;
            border-top: none !important;
            padding-top: 3px !important;
            font-family: 'Poppins', sans-serif;
            letter-spacing: 0.2px;
            font-style: italic;
        }

        body.dark-mode .tech-ledger-footer {
            color: #475569 !important;
        }

        /* Status watermark overlays */
        .passbook-status-watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-25deg);
            font-size: 1.8rem;
            font-weight: 900;
            color: rgba(99, 102, 241, 0.18); /* default preview */
            border: 3.5px solid currentColor;
            padding: 4px 14px;
            border-radius: 6px;
            pointer-events: none;
            letter-spacing: 2px;
            text-transform: uppercase;
            user-select: none;
            z-index: 10;
            transition: all 0.3s ease;
        }

        .passbook-status-watermark.approved,
        .passbook-status-watermark.delivered {
            color: rgba(16, 185, 129, 0.25) !important;
        }

        .passbook-status-watermark.pending {
            color: rgba(245, 158, 11, 0.25) !important;
        }

        .passbook-status-watermark.rejected {
            color: rgba(239, 68, 68, 0.25) !important;
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

        /* --- LOOKUP CONTAINER REDESIGN --- */
        .lookup-container {
            padding: 24px;
            display: flex;
            gap: 12px;
            align-items: center;
            border-bottom: 1px dashed rgba(99, 102, 241, 0.15);
            width: 100%;
            box-sizing: border-box;
            background: #f8fafc;
        }

        body.dark-mode .lookup-container {
            background: rgba(15, 23, 42, 0.3);
        }

        .modal-content {
            background: #ffffff !important;
            border: 1.5px solid var(--gray-200) !important;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04) !important;
        }

        body.dark-mode .modal-content {
            background: #1e293b !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3) !important;
        }

        .lookup-input-wrapper {
            position: relative;
            flex: 1;
            display: flex;
            align-items: center;
        }

        .lookup-input-wrapper i {
            position: absolute;
            left: 14px;
            font-size: 1.2rem;
            color: var(--primary-500);
            pointer-events: none;
        }

        .lookup-input {
            width: 100%;
            padding: 12px 16px 12px 42px !important;
            border: 2px solid rgba(99, 102, 241, 0.15) !important;
            border-radius: var(--radius-md) !important;
            font-size: 0.9rem !important;
            outline: none !important;
            background: #ffffff !important;
            color: var(--gray-800) !important;
            font-family: 'Poppins', sans-serif !important;
            font-weight: 500 !important;
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.04) !important;
            transition: all 0.3s ease !important;
        }

        body.dark-mode .lookup-input {
            background: rgba(15, 23, 42, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
            box-shadow: none !important;
        }

        .lookup-input::placeholder {
            color: var(--gray-400) !important;
            font-weight: 400;
        }

        .lookup-input:focus {
            border-color: var(--primary-500) !important;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12) !important;
        }

        .btn-lookup {
            padding: 12px 24px !important;
            margin: 0 !important;
            font-weight: 600 !important;
            background: var(--gradient-primary) !important;
            color: white !important;
            border: none !important;
            border-radius: var(--radius-md) !important;
            cursor: pointer !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            font-size: 0.9rem !important;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2) !important;
            transition: all 0.3s ease !important;
        }

        .btn-lookup:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(99, 102, 241, 0.3) !important;
        }

        .btn-lookup:active {
            transform: translateY(1px);
        }

        /* --- LOOKUP RESULT CARDS --- */
        .lookup-result-card {
            background: #ffffff;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02);
            text-align: left;
            margin-bottom: 12px;
            display: block;
            width: 100%;
            box-sizing: border-box;
        }

        body.dark-mode .lookup-result-card {
            background: rgba(15, 23, 42, 0.4);
            border-color: rgba(255, 255, 255, 0.08);
            box-shadow: none;
        }

        .lookup-result-card:hover {
            border-color: var(--primary-400);
            background: rgba(99, 102, 241, 0.02);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(99, 102, 241, 0.06);
        }

        body.dark-mode .lookup-result-card:hover {
            background: rgba(99, 102, 241, 0.08);
            border-color: var(--primary-500);
        }

        .lookup-result-card-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--gray-800);
            margin: 0 0 6px 0;
            font-family: 'Poppins', sans-serif;
        }

        body.dark-mode .lookup-result-card-title {
            color: #ffffff;
        }

        .lookup-result-card-details {
            font-size: 0.85rem;
            color: var(--gray-400);
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
        }

        body.dark-mode .lookup-result-card-details {
            color: var(--gray-500);
        }

        .lookup-result-card-details span {
            font-family: monospace;
            font-weight: 600;
            color: var(--gray-600);
        }

        body.dark-mode .lookup-result-card-details span {
            color: var(--gray-300);
        }

        /* --- SEARCH AND FILTER SYSTEM --- */
        .search-filter-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-input-group {
            position: relative;
            flex-grow: 1;
            max-width: 400px;
            min-width: 250px;
        }

        .search-input-group .search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2rem;
            color: var(--gray-400);
            pointer-events: none;
        }

        .search-input-group input {
            width: 100%;
            padding: 10px 15px 10px 42px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            font-size: 0.85rem;
            outline: none;
            color: var(--gray-800);
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }

        body.dark-mode .search-input-group input {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }

        .search-input-group input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }

        .filter-select-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .filter-select-group select {
            padding: 10px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            font-size: 0.85rem;
            outline: none;
            color: var(--gray-700);
            transition: all 0.3s ease;
            cursor: pointer;
            min-width: 150px;
            box-shadow: var(--shadow-sm);
        }

        body.dark-mode .filter-select-group select {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }

        /* Product Catalogue Styles adapted from cards.jsp / chequebook.jsp */
        .catalog-scroll-container {
            width: 100%;
            overflow-x: auto;
            padding-bottom: 12px;
            margin-bottom: 30px;
            -webkit-overflow-scrolling: touch;
        }
        .catalog-scroll-container::-webkit-scrollbar {
            height: 8px;
        }
        .catalog-scroll-container::-webkit-scrollbar-track {
            background: rgba(99, 102, 241, 0.02);
            border-radius: 10px;
        }
        .catalog-scroll-container::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.15);
            border-radius: 10px;
            transition: background 0.2s ease;
        }
        .catalog-scroll-container::-webkit-scrollbar-thumb:hover {
            background: rgba(99, 102, 241, 0.3);
        }
        body.dark-mode .catalog-scroll-container::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.02);
        }
        body.dark-mode .catalog-scroll-container::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.1);
        }
        body.dark-mode .catalog-scroll-container::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .catalog-grid {
            display: flex;
            flex-direction: row;
            gap: 24px;
            width: max-content;
            align-items: stretch;
            padding: 4px;
        }
        .product-card {
            width: 320px;
            flex-shrink: 0;
            border-radius: var(--radius-lg);
            padding: 24px;
            display: flex;
            flex-direction: column !important;
            gap: 16px;
            position: relative;
            overflow: visible;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
            background: #ffffff;
        }
        body.dark-mode .product-card {
            background: #1e293b;
        }
        .product-card-bg-debit-classic {
            background: rgba(99, 102, 241, 0.02);
            border: 1.5px solid rgba(99, 102, 241, 0.08);
        }
        body.dark-mode .product-card-bg-debit-classic {
            background: rgba(99, 102, 241, 0.04);
            border-color: rgba(99, 102, 241, 0.15);
        }
        .product-card-bg-debit-premium {
            background: rgba(6, 182, 212, 0.02);
            border: 1.5px solid rgba(6, 182, 212, 0.08);
        }
        body.dark-mode .product-card-bg-debit-premium {
            background: rgba(6, 182, 212, 0.04);
            border-color: rgba(6, 182, 212, 0.15);
        }
        .product-card-bg-credit-infinite {
            background: rgba(245, 158, 11, 0.02);
            border: 1.5px solid rgba(245, 158, 11, 0.08);
        }
        body.dark-mode .product-card-bg-credit-infinite {
            background: rgba(245, 158, 11, 0.04);
            border-color: rgba(245, 158, 11, 0.15);
        }
        .product-card-watermark {
            position: absolute;
            top: -10px;
            right: -10px;
            font-size: 5.5rem;
            font-weight: 800;
            transform: rotate(-15deg);
            pointer-events: none;
            user-select: none;
            line-height: 1;
        }
        .watermark-debit {
            color: rgba(99, 102, 241, 0.025);
        }
        body.dark-mode .watermark-debit {
            color: rgba(255, 255, 255, 0.015);
        }
        .catalog-details-col {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .catalog-spec-badge {
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            align-self: flex-start;
        }
        .spec-badge-classic {
            background: rgba(99, 102, 241, 0.08);
            color: var(--primary-500);
        }
        .catalog-card-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--gray-800);
            margin: 0;
        }
        body.dark-mode .catalog-card-title {
            color: #ffffff;
        }
        .catalog-card-desc {
            font-size: 0.85rem;
            color: var(--gray-500);
            line-height: 1.5;
            margin: 0;
        }
        body.dark-mode .catalog-card-desc {
            color: var(--gray-400);
        }
        .catalog-specs-table {
            display: flex;
            flex-direction: column;
            gap: 8px;
            width: 100%;
            margin-top: 5px;
        }
        .catalog-spec-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.82rem;
            border-bottom: 1px dashed rgba(99, 102, 241, 0.08);
            padding-bottom: 5px;
        }
        body.dark-mode .catalog-spec-row {
            border-bottom-color: rgba(255, 255, 255, 0.05);
        }
        .catalog-spec-label {
            color: var(--gray-500);
        }
        body.dark-mode .catalog-spec-label {
            color: var(--gray-400);
        }
        .catalog-spec-value {
            color: var(--gray-800);
            font-weight: 700;
        }
        body.dark-mode .catalog-spec-value {
            color: #ffffff;
        }
        .catalog-features-col {
            width: 100%;
            border-top: 1px dashed rgba(99, 102, 241, 0.12);
            padding-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        body.dark-mode .catalog-features-col {
            border-top-color: rgba(255, 255, 255, 0.1);
        }
        .catalog-features-heading {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--gray-450);
            text-transform: uppercase;
            margin-bottom: 5px;
            letter-spacing: 0.8px;
        }
        .catalog-features-list {
            font-size: 0.82rem;
            color: var(--gray-600);
            padding-left: 16px;
            margin: 0;
            line-height: 1.6;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        body.dark-mode .catalog-features-list {
            color: var(--gray-300);
        }
        .catalog-action-col {
            width: 100%;
            margin-top: auto;
            padding-top: 15px;
        }
        .btn-apply-catalog {
            width: 100% !important;
            padding: 12px 24px !important;
            white-space: nowrap !important;
            margin: 0 !important;
            font-weight: 600;
            border-radius: var(--radius-md) !important;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 0.85rem !important;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15);
            transition: all 0.3s ease;
        }
        .btn-apply-catalog:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.25);
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
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list" class="active"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/cash-counter"><i class="bx bx-wallet"></i> Cash Counter</a>
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
                      <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Review customer passbook applications, inspect booklet configurations, and issue approvals/refunds.</p>
                  </div>
                  <button onclick="openApplyModal()" class="btn btn-primary" style="padding: 8px 16px; font-size: 0.8rem; border-radius: var(--radius-sm); font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; margin: 0; background: var(--gradient-primary); color: white; border: none; cursor: pointer; transition: all 0.3s ease;">
                      <i class="bx bx-plus-circle"></i> Apply / Renew Passbook
                  </button>
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

            <!-- VGB Passbook Product Catalogue -->
            <div class="glass-card">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; margin-bottom: 20px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin: 0;">
                        <i class="bx bx-book-open" style="color: var(--primary-500);"></i> VGB Bank Passbook Suite & Specifications
                    </h3>
                </div>
                <div class="catalog-scroll-container">
                    <div class="catalog-grid">
                    
                        <!-- Product 1: New Cover Passbook -->
                        <div class="product-card product-card-bg-debit-classic">
                            <div class="product-card-watermark watermark-debit">NEW</div>
                            <div class="catalog-details-col">
                                <span class="catalog-spec-badge spec-badge-classic">New Cover</span>
                                <h4 class="catalog-card-title">Standard Booklet</h4>
                                <p class="catalog-card-desc">Brand new passbook booklet with premium binding, custom holograph logo, and metallic cover.</p>
                            </div>

                            <div class="catalog-specs-table">
                                <div class="catalog-spec-row">
                                    <span class="catalog-spec-label">Upfront Fee:</span>
                                    <strong class="catalog-spec-value">₹150.00</strong>
                                </div>
                                <div class="catalog-spec-row">
                                    <span class="catalog-spec-label">Capacity Limit:</span>
                                    <strong class="catalog-spec-value">40 Pages</strong>
                                </div>
                                <div class="catalog-spec-row">
                                    <span class="catalog-spec-label">Verification Time:</span>
                                    <strong class="catalog-spec-value">Instant Issuance</strong>
                                </div>
                            </div>

                            <div class="catalog-features-col">
                                <h5 class="catalog-features-heading">Features & Benefits:</h5>
                                <ul class="catalog-features-list">
                                    <li>Metallic Embossed Outer Cover</li>
                                    <li>High-Density Security Watermark</li>
                                    <li>Initial Account Ledger Setup</li>
                                </ul>
                            </div>

                            <div class="catalog-action-col">
                                <button type="button" onclick="openApplyModal('apply')" class="btn-apply-catalog btn btn-primary">
                                    <i class="bx bx-plus-circle"></i> Apply New Cover
                                </button>
                            </div>
                        </div>

                        <!-- Product 2: Renewal Booklet -->
                        <div class="product-card product-card-bg-debit-premium">
                            <div class="product-card-watermark watermark-debit" style="color: rgba(6, 182, 212, 0.025);">RENEW</div>
                            <div class="catalog-details-col">
                                <span class="catalog-spec-badge spec-badge-premium" style="background: rgba(6, 182, 212, 0.08); color: #0891b2;">Renewal</span>
                                <h4 class="catalog-card-title">Renewal Extension</h4>
                                <p class="catalog-card-desc">Renewal or page extension booklet for accounts with filled or damaged passbooks.</p>
                            </div>

                            <div class="catalog-specs-table">
                                <div class="catalog-spec-row">
                                    <span class="catalog-spec-label">Upfront Fee:</span>
                                    <strong class="catalog-spec-value">₹100.00</strong>
                                </div>
                                <div class="catalog-spec-row">
                                    <span class="catalog-spec-label">Capacity Limit:</span>
                                    <strong class="catalog-spec-value">40 Pages</strong>
                                </div>
                                <div class="catalog-spec-row">
                                    <span class="catalog-spec-label">Verification Time:</span>
                                    <strong class="catalog-spec-value">Instant Sync</strong>
                                </div>
                            </div>

                            <div class="catalog-features-col">
                                <h5 class="catalog-features-heading">Features & Benefits:</h5>
                                <ul class="catalog-features-list">
                                    <li>Priority Branch Printing & Sync</li>
                                    <li>Low-cost replacement booklet</li>
                                    <li>Extended transaction logging</li>
                                </ul>
                            </div>

                            <div class="catalog-action-col">
                                <button type="button" onclick="openApplyModal('renew')" class="btn-apply-catalog btn btn-primary" style="background: var(--gradient-primary); border: none;">
                                    <i class="bx bx-refresh"></i> Apply Renewal
                                </button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Table of all requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; display: flex; align-items: center; gap: 8px;"><i class="bx bx-list-ol" style="color: var(--primary-500);"></i> Passbook Applications</h3>
                
                <!-- Client-side real-time filter controls -->
                <div class="search-filter-wrapper">
                    <div class="search-input-group">
                        <i class="bx bx-search search-icon"></i>
                        <input type="text" id="directorySearchInput" onkeyup="filterDirectoryTable()" placeholder="Search by request ID, customer, account...">
                    </div>
                    <div class="filter-select-group">
                        <select id="directoryStatusFilter" onchange="filterDirectoryTable()">
                            <option value="">All Statuses</option>
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>
                </div>

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
                        <tbody id="directoryTableBody">
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
                                                     <button type="button" class="btn" style="display:none;" 
                                                             data-id="${req.requestId}" 
                                                             data-name="${req.customerName}" 
                                                             data-account="${req.accountNumber}" 
                                                             data-type="${req.requestType}" 
                                                             data-acctype="${req.accountType} Account"
                                                             data-ifsc="${req['ifscCode']}"
                                                             data-phone="${req['phoneNo']}"
                                                             data-nominee="${req['nomineeName']}"
                                                             data-status="${req.status}"
                                                             style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #6366f1; color: white; border: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"
                                                             onclick="inspectRequest(this)">
                                                         <i class="bx bx-show"></i> Inspect
                                                     </button>
                                                     <c:choose>
                                                         <c:when test="${req.status eq 'pending'}">
                                                             <a href="${pageContext.request.contextPath}/passbook?action=approve&id=${req.requestId}&csrfToken=${sessionScope.csrfToken}" 
                                                                class="btn btn-primary" 
                                                                style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); text-decoration: none; font-weight: 600;"
                                                                onclick="return confirm('Are you sure you want to approve this passbook request?');">
                                                                 Approve
                                                             </a>
                                                             <a href="${pageContext.request.contextPath}/passbook?action=reject&id=${req.requestId}&csrfToken=${sessionScope.csrfToken}" 
                                                                class="btn btn-danger" 
                                                                style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #ef4444; color: white; border: none; text-decoration: none; font-weight: 600;"
                                                                onclick="return confirm('Are you sure you want to reject this request? Processing fees of ₹100.00 will be refunded.');">
                                                                 Reject
                                                             </a>
                                                         </c:when>
                                                         <c:otherwise>
                                                             <span style="font-size: 0.8rem; color: var(--gray-400); font-style: italic;">Reviewed</span>
                                                         </c:otherwise>
                                                     </c:choose>
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
        // Client-side real-time table search & filter
        function filterDirectoryTable() {
            const searchVal = document.getElementById('directorySearchInput').value.toLowerCase();
            const statusVal = document.getElementById('directoryStatusFilter').value.toLowerCase();
            
            const table = document.getElementById('directoryTableBody');
            if (!table) return;
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                if (row.cells.length < 8) continue; // Skip empty list state rows
                
                const requestId = row.cells[0].textContent.toLowerCase();
                const customerName = row.cells[1].textContent.toLowerCase();
                const accountNumber = row.cells[2].textContent.toLowerCase();
                const status = row.cells[6].textContent.trim().toLowerCase();
                
                const matchesSearch = requestId.includes(searchVal) || customerName.includes(searchVal) || accountNumber.includes(searchVal);
                const matchesStatus = statusVal === '' || status.includes(statusVal);
                
                if (matchesSearch && matchesStatus) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        }

        document.addEventListener('DOMContentLoaded', () => {


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

        function openApplyModal(preselectedAction) {
            document.getElementById('lookupAccountNumber').value = '';
            document.getElementById('lookupResultsContainer').style.display = 'none';
            document.getElementById('lookupResultsList').innerHTML = '';
            document.getElementById('passbookForm').style.display = 'none';
            document.getElementById('applyPassbookModal').style.display = 'flex';

            if (preselectedAction) {
                const selectEl = document.querySelector('select[name="actionType"]');
                if (selectEl) {
                    selectEl.value = preselectedAction;
                    updateApplyFeeAndNotice(preselectedAction);
                }
            }
        }

        function closeApplyModal() {
            document.getElementById('applyPassbookModal').style.display = 'none';
        }

        function escapeHtml(text) {
            if (!text) return '';
            return text
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function fetchCustomerDetails() {
            const queryVal = document.getElementById('lookupAccountNumber').value.trim();
            if (!queryVal) {
                alert('Please enter Account Number, Customer ID, or Name');
                return;
            }

            const resultsContainer = document.getElementById('lookupResultsContainer');
            const resultsList = document.getElementById('lookupResultsList');
            const loader = document.getElementById('lookupLoader');
            const searchIcon = document.getElementById('lookupSearchIcon');

            if (loader && searchIcon) {
                loader.style.display = 'inline-block';
                searchIcon.style.display = 'none';
            }
            resultsContainer.style.display = 'none';
            resultsList.innerHTML = '';
            document.getElementById('passbookForm').style.display = 'none';

            fetch('${pageContext.request.contextPath}/account?action=details&searchQuery=' + encodeURIComponent(queryVal))
                .then(response => response.json())
                .then(data => {
                    if (loader && searchIcon) {
                        loader.style.display = 'none';
                        searchIcon.style.display = 'inline-block';
                    }
                    if (!data || data.length === 0) {
                        alert('No customer details found matching search query.');
                        return;
                    }
                    
                    resultsContainer.style.display = 'block';
                    data.forEach(item => {
                        const card = document.createElement('div');
                        card.className = 'lookup-result-card';
                        
                        card.innerHTML = `
                            <div class="lookup-result-card-title">
                                \${escapeHtml(item.customerName)} | \${item.accountType.toUpperCase()}
                            </div>
                            <div class="lookup-result-card-details">
                                Acc: <span>\${item.accountNumber}</span> | Bal: <span>₹\${parseFloat(item.balance).toLocaleString('en-IN', {minimumFractionDigits: 2})}</span>
                            </div>
                        `;
                        
                        card.addEventListener('click', () => {
                            populateCustomerForm(item);
                            resultsContainer.style.display = 'none';
                        });
                        resultsList.appendChild(card);
                    });
                })
                .catch(err => {
                    if (loader && searchIcon) {
                        loader.style.display = 'none';
                        searchIcon.style.display = 'inline-block';
                    }
                    console.error('Error fetching details:', err);
                    alert('Failed to fetch customer details. Please check the search query.');
                });
        }

        function populateCustomerForm(data) {
            // Populate form fields
            document.getElementById('formAccountId').value = data.accountId;
            document.getElementById('formAccountNumber').value = data.accountNumber;
            
            document.getElementById('paperAccountNumberDisplay').textContent = data.accountNumber + ' - ' + data.accountType + ' (Available: ₹ ' + parseFloat(data.balance).toLocaleString('en-IN', {minimumFractionDigits: 2}) + ')';
            document.getElementById('paperCustomerIdDisplay').textContent = data.customerId;
            document.getElementById('paperMobileDisplay').textContent = data.phone;
            document.getElementById('paperEmailDisplay').textContent = data.email;
            document.getElementById('paperAddressDisplay').textContent = data.address;
            
            document.getElementById('applyFormSignature').textContent = data.customerName;

            // Date
            const today = new Date();
            const dd = String(today.getDate()).padStart(2, '0');
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const yyyy = today.getFullYear();
            document.getElementById('applyFormDateStr').value = dd + ' / ' + mm + ' / ' + yyyy;

            // Show form
            document.getElementById('passbookForm').style.display = 'block';
        }

        function updateApplyFeeAndNotice(actionType) {
            let feeVal = '₹ 150.00';
            if (actionType === 'renew') feeVal = '₹ 100.00';
            document.getElementById('applyFeeValue').textContent = feeVal;
            document.getElementById('passbookForm').action = '${pageContext.request.contextPath}/passbook?action=' + actionType;
        }
    </script>

    <!-- Modal: Apply / Renew Passbook -->
    <div id="applyPassbookModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 1050; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px); align-items: center; justify-content: center; padding: 20px;">
        <div class="modal-content" style="max-width: 720px; width: 100%; border-radius: var(--radius-lg); overflow: hidden; display: flex; flex-direction: column;">
            <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid rgba(99,102,241,0.1); background: rgba(99,102,241,0.02); width: 100%; box-sizing: border-box;">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin: 0; display: flex; align-items: center; gap: 8px;"><i class="bx bx-plus-circle" style="color: var(--primary-500);"></i> Apply Customer Passbook</h3>
                <button type="button" onclick="closeApplyModal()" style="background: none; border: none; font-size: 1.5rem; color: var(--gray-400); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-800)'" onmouseout="this.style.color='var(--gray-400)'">&times;</button>
            </div>
            
            <div class="lookup-container">
                <div class="lookup-input-wrapper">
                    <i class="bx bx-search-alt"></i>
                    <input type="text" id="lookupAccountNumber" class="lookup-input" placeholder="Enter Account Number, Customer ID or Name (e.g. 171931936244)" onkeypress="if(event.key === 'Enter') fetchCustomerDetails();">
                </div>
                <button type="button" onclick="fetchCustomerDetails()" class="btn-lookup"><i class="bx bx-loader-alt bx-spin" id="lookupLoader" style="display: none;"></i><i class="bx bx-search-alt" id="lookupSearchIcon"></i> Fetch Details</button>
            </div>

            <!-- Lookup Results Container -->
            <div id="lookupResultsContainer" style="display: none; max-height: 200px; overflow-y: auto; padding: 15px 24px; border-bottom: 1px dashed rgba(99,102,241,0.1); box-sizing: border-box; width: 100%;">
                <h4 style="margin: 0 0 10px; font-size: 0.85rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; text-align: left;">Search Results</h4>
                <div id="lookupResultsList" style="display: flex; flex-direction: column;"></div>
            </div>

            <!-- Beautiful Paper Form container (hidden by default until details loaded) -->
            <form id="passbookForm" action="${pageContext.request.contextPath}/passbook?action=apply" method="post" style="display: none; padding: 12px 20px; max-height: 70vh; overflow-y: auto; width: 100%; box-sizing: border-box; text-align: left;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" id="formAccountId" name="accountId" value="">
                <input type="hidden" id="formAccountNumber" name="accountNumber" value="">
                
                <div class="apply-paper-form" style="background: #fff; border: 1.5px solid var(--gray-200); padding: 25px 20px; border-radius: var(--radius-sm); color: #1e293b; font-family: 'Times New Roman', Times, serif; font-size: 0.95rem; line-height: 1.6; margin-top: 20px; margin-bottom: 15px; box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm); position: relative; overflow: hidden;">
                    <!-- Watermark -->
                    <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 7.5rem; font-weight: 900; color: rgba(99, 102, 241, 0.03); pointer-events: none; user-select: none; font-family: 'Poppins', sans-serif; letter-spacing: 5px;">VGB</div>

                    <!-- Form Header -->
                    <div style="text-align: center; border-bottom: 2px double #475569; padding-bottom: 12px; margin-bottom: 20px; position: relative;">
                        <h2 style="font-size: 1.35rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: #0f172a; margin: 0; font-family: 'Poppins', sans-serif;">Vertex Galaxy Bank</h2>
                        <h3 style="font-size: 1rem; font-weight: 700; color: #475569; margin: 4px 0 0; text-transform: uppercase; font-family: 'Poppins', sans-serif; letter-spacing: 0.5px;">Passbook Issuance & Renewal Form</h3>
                        <span style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); font-family: 'Poppins', sans-serif;">
                            Fee Due: <strong id="applyFeeValue" style="font-weight: 800;">₹ 150.00</strong>
                        </span>
                    </div>

                    <!-- Header Details -->
                    <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
                        <tr>
                            <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                <strong>To,</strong><br>
                                The Branch Manager<br>
                                <strong>Vertex Galaxy Bank</strong><br>
                                Branch: <input type="text" name="branch" style="width: 250px; border: none; border-bottom: 1px dotted #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; color: #0f172a;" value="Main Corporate Branch, Mumbai">
                            </td>
                            <td style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                <strong>Date:</strong> <input type="text" name="formDate" id="applyFormDateStr" style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;" value="" readonly>
                            </td>
                        </tr>
                    </table>

                    <div style="margin-bottom: 20px;">
                        <strong>Subject:</strong> <span style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request for Customer Passbook Issuance & Custom Cover Setup</span>
                    </div>

                    <!-- Customer Information -->
                    <div style="margin-bottom: 20px;">
                        <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">Customer Information</h4>
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <td style="width: 35%; padding: 5px 0;"><strong>Account Number:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperAccountNumberDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Customer ID:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperCustomerIdDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperMobileDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperEmailDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: inherit; font-size: 0.9rem; color: #0f172a; white-space: normal; word-break: break-word;" id="paperAddressDisplay">
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- Specification Details Box -->
                    <div style="margin-bottom: 25px;">
                        <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">Passbook Specifications</h4>
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <td style="width: 45%; padding: 5px 0;"><strong>Application Request Type:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                    <select name="actionType" required onchange="updateApplyFeeAndNotice(this.value)" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: 'Poppins', sans-serif; font-size: 0.9rem; outline: none; background: transparent; color: #0f172a; cursor: pointer;">
                                        <option value="apply">New Cover Passbook Booklet (₹150)</option>
                                        <option value="renew">Renewal Passbook Booklet (₹100)</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- Declaration -->
                    <div style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                        <p style="margin: 0 0 10px;"><strong>Request Description:</strong> I hereby request the bank to issue a passbook booklet for my account registered in the system. I confirm my account contains sufficient funds to cover the applicable service charge.</p>
                        <p style="margin: 0;"><strong>Declaration:</strong> I declare that all signatures are mine and the information provided is correct. The bank holds the right to reject this application if any details are invalid.</p>
                    </div>

                    <!-- Signatures Row -->
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                        <div>
                            <span style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;" id="applyFormSignature"></span>
                            <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer Signature</span>
                        </div>
                        <div style="text-align: center;">
                            <div style="width: 150px; height: 50px; border: 1px dashed #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: #64748b; font-family: 'Poppins', sans-serif;">BANK USE ONLY</div>
                            <span style="border-top: 1px solid #475569; display: inline-block; width: 150px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif; margin-top: 5px;">Officer Signature</span>
                        </div>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" onclick="closeApplyModal()" class="btn-action btn-action-reject" style="padding: 8px 16px; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; border: 1px solid rgba(239, 68, 68, 0.2); background: rgba(239, 68, 68, 0.05); color: #ef4444;">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="padding: 8px 20px; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; background: var(--gradient-primary); color: white; border: none;">Submit Application</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
