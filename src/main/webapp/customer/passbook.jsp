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
    <title>VGB | Passbook Services</title>
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

        /* Preloader override */
        .preloader {
            background: #f6f8fc;
            z-index: 9999;
        }
        body.dark-mode .preloader {
            background: #0f172a;
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

        /* --- FOOTER PANEL --- */
        .footer {
            margin-left: 280px;
            background: rgba(255, 255, 255, 0.45) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border-top: 1px solid var(--glass-border) !important;
            padding: 20px 0;
            transition: all 0.3s ease;
        }
        body.dark-mode .footer {
            background: rgba(15, 23, 42, 0.45) !important;
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

        /* --- LOGOUT BUTTON --- */
        .btn-logout {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: var(--radius-full);
            border: 1.5px solid rgba(99, 102, 241, 0.2) !important;
            background: transparent;
            color: var(--gray-700) !important;
            transition: all var(--transition-normal);
            cursor: pointer;
            text-decoration: none;
        }
        body.dark-mode .btn-logout {
            color: var(--gray-300) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
        }
        .btn-logout:hover {
            border-color: transparent !important;
            background: var(--gradient-primary);
            color: white !important;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
            transform: translateY(-1px);
        }
        .btn-logout i {
            font-size: 1.05rem;
            transition: transform var(--transition-fast);
        }
        .btn-logout:hover i {
            transform: translateX(3px);
        }

        /* --- MOBILE LAYOUTS --- */
        @media (max-width: 991px) {
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
        @media (max-width: 480px) {
            .mobile-hide {
                display: none !important;
            }
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
            animation: modalScaleUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        body.dark-mode .modal-content {
            background: rgba(30, 41, 59, 0.95);
            border-color: rgba(255, 255, 255, 0.1);
        }

        @keyframes modalScaleUp {
            from {
                transform: perspective(1000px) rotateX(15deg) scale(0.9) translateY(30px);
                opacity: 0;
            }
            to {
                transform: perspective(1000px) rotateX(0deg) scale(1) translateY(0);
                opacity: 1;
            }
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
            background: #fdfbf7;
            border: 1px solid rgba(191, 149, 63, 0.3);
            padding: 30px;
            border-radius: var(--radius-md);
            color: #334155;
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            line-height: 1.6;
            box-shadow: inset 0 0 15px rgba(0,0,0,0.02), 0 10px 30px rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }
        body.dark-mode .paper-form {
            background: #1e293b;
            color: #f1f5f9;
            border-color: rgba(255, 255, 255, 0.15);
        }

        .paper-header {
            text-align: center;
            border-bottom: 2px double rgba(191, 149, 63, 0.4);
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
        body.dark-mode .paper-header h2 {
            color: #ffffff;
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
        body.dark-mode .paper-header h3 {
            color: var(--gray-400);
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
            border-bottom: 1.5px dotted #475569;
            padding: 2px 5px;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
            cursor: pointer;
        }
        body.dark-mode .paper-select, body.dark-mode .paper-input {
            border-bottom-color: rgba(255, 255, 255, 0.2);
            color: #ffffff;
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
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.04) 0%, rgba(6, 182, 212, 0.04) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 40px 20px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.05);
            height: 100%;
            perspective: 1200px;
            position: relative;
            overflow: hidden;
            min-height: 350px;
        }
        body.dark-mode .passbook-visualizer-container {
            border-color: rgba(255, 255, 255, 0.08);
        }

        .passbook-wrapper {
            width: 420px;
            height: 180px;
            position: relative;
            transform-style: preserve-3d;
            cursor: pointer;
        }

        .passbook-book {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateX(15deg) rotateY(-10deg);
            transition: transform 0.8s cubic-bezier(0.25, 1, 0.5, 1);
        }

        /* Spine binding edge decoration at top */
        .passbook-book::before {
            content: '';
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            height: 10px;
            background: linear-gradient(180deg, rgba(0,0,0,0.5) 0%, rgba(255,255,255,0.15) 30%, rgba(0,0,0,0.2) 100%);
            z-index: 50;
            pointer-events: none;
            opacity: 0.8;
        }

        /* 3D panels */
        .passbook-panel {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* Base Page (stationary bottom ledger) */
        .base-page {
            z-index: 10;
        }

        /* Cover Flap (flips upward from the top edge) */
        .cover-flap {
            transform-origin: center top;
            transform: rotateX(0deg) translateZ(1px); /* Folds shut over base */
            transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 20;
        }

        .passbook-book.open .cover-flap {
            transform: rotateX(180deg) translateZ(0.5px); /* Unfolds upwards */
        }

        .passbook-book.flipped-back {
            transform: rotateX(195deg) rotateY(10deg) !important;
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
        body.dark-mode .btn-flip-book {
            background: rgba(255, 255, 255, 0.05);
            color: var(--primary-400);
            border-color: rgba(255, 255, 255, 0.1);
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

        /* Panel face styling */
        .panel-face {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: inset 0 0 2px rgba(255, 255, 255, 0.1);
        }

        .panel-front {
            transform: rotateX(0deg);
            z-index: 2;
        }

        .panel-back {
            transform: rotateX(180deg);
            z-index: 1;
        }

        /* Cosmic styles */
        .cosmic-cover {
            background: radial-gradient(circle at 50% 50%, #0d0a2d 0%, #030211 80%, #000005 100%) !important;
            color: #ffffff;
            padding: 16px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            box-sizing: border-box;
            position: relative;
            border: 1.5px solid rgba(191, 149, 63, 0.35) !important;
            box-shadow: inset 0 0 15px rgba(191, 149, 63, 0.15);
        }

        .cosmic-cover::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 30% 30%, rgba(99, 102, 241, 0.25) 0%, transparent 60%),
                        radial-gradient(circle at 80% 80%, rgba(236, 72, 153, 0.2) 0%, transparent 50%);
            pointer-events: none;
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

        .cosmic-orbits ellipse {
            stroke-dasharray: 200;
            animation: dashOrbit 15s linear infinite;
        }
        @keyframes dashOrbit {
            from { stroke-dashoffset: 200; }
            to { stroke-dashoffset: 0; }
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

        /* Dark High-Tech background inside panels */
        .inside-tech-panel {
            background: radial-gradient(circle at 100% 100%, #0d0925 0%, #040212 90%);
            color: #e2e8f0;
            padding: 16px;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
        }

        .inside-tech-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            background-image: 
                radial-gradient(circle at 80% 80%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 10% 20%, rgba(0, 240, 255, 0.08) 0%, transparent 40%);
            pointer-events: none;
        }

        /* Page Headers */
        .tech-page-header-pill {
            background: linear-gradient(90deg, #d900ff 0%, #6366f1 100%);
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.3);
            margin-bottom: 8px;
        }

        .tech-page-header-pill h4 {
            font-size: 0.65rem !important;
            font-weight: 800 !important;
            letter-spacing: 0.75px !important;
            color: #ffffff !important;
            margin: 0 !important;
            text-transform: uppercase !important;
            font-family: 'Poppins', sans-serif;
        }

        /* Credentials info grid */
        .tech-credentials-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.50rem;
            line-height: 1.4;
        }

        .tech-credentials-table td {
            padding: 4px 0;
            border-bottom: 1px dotted rgba(255, 255, 255, 0.1);
        }

        .tech-credentials-table td:first-child {
            color: #94a3b8;
            width: 38%;
            font-weight: 500;
        }

        .tech-credentials-table td:last-child {
            color: #f8fafc;
            font-weight: 700;
        }

        /* Circular Lock Shield */
        .circular-lock-badge {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(0, 240, 255, 0.15) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1.5px solid rgba(0, 240, 255, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 10px rgba(0, 240, 255, 0.2);
            flex-shrink: 0;
        }

        .circular-lock-badge i {
            font-size: 1.05rem;
            color: #00f0ff;
            text-shadow: 0 0 8px rgba(0, 240, 255, 0.5);
        }

        .tech-security-icons {
            display: flex;
            gap: 6px;
            font-size: 0.38rem;
            color: #94a3b8;
            font-weight: 600;
            align-items: center;
        }

        .tech-security-icon-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1px;
            opacity: 0.8;
        }

        .tech-security-icon-box i {
            font-size: 0.72rem;
            color: #00f0ff;
        }

        /* Important Instructions Panel inside */
        .instructions-panel-inside {
            background: radial-gradient(circle at 50% 50%, #0b071e 0%, #03010b 90%);
            color: #e2e8f0;
            padding: 16px;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 12px;
        }

        .instructions-panel-inside h4 {
            font-size: 0.65rem;
            font-weight: 800;
            letter-spacing: 0.5px;
            color: #ffffff;
            text-transform: uppercase;
            text-align: center;
            margin: 0 0 8px 0;
            font-family: 'Poppins', sans-serif;
            border-bottom: 1.5px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 4px;
        }

        .instructions-tech-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .instructions-tech-list li {
            font-size: 0.48rem;
            color: #cbd5e1;
            line-height: 1.25;
            display: flex;
            align-items: flex-start;
            gap: 6px;
        }

        .instructions-tech-list li i {
            color: #d900ff;
            font-size: 0.75rem;
            text-shadow: 0 0 5px rgba(217, 0, 255, 0.4);
            margin-top: 1px;
            flex-shrink: 0;
        }

        /* Transaction Record style */
        .transaction-panel-inside {
            background: #fdfbf7;
            color: #334155;
            padding: 14px;
            box-sizing: border-box;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            border-radius: 12px;
            border: 1.5px solid rgba(191, 149, 63, 0.25);
        }
        body.dark-mode .transaction-panel-inside {
            background: #1e293b;
            color: #cbd5e1;
            border-color: rgba(255, 255, 255, 0.1);
        }

        /* Watermark V for transaction page */
        .transaction-watermark-v {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 110px;
            height: 110px;
            opacity: 0.05;
            pointer-events: none;
            z-index: 1;
        }

        /* Transaction table grid */
        .tech-ledger-grid {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.35rem;
            z-index: 2;
            position: relative;
            table-layout: fixed;
        }

        .tech-ledger-grid th {
            padding: 3px 2px !important;
            background: #334155 !important;
            color: #f8fafc !important;
            font-weight: 700 !important;
            font-size: 0.34rem !important;
            text-transform: uppercase !important;
            border: 1px solid #475569 !important;
            letter-spacing: 0.1px !important;
            text-align: center !important;
            white-space: nowrap !important;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        body.dark-mode .tech-ledger-grid th {
            background: #0f172a !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
        }

        .tech-ledger-grid td {
            padding: 3px 2px !important;
            border: 1px solid #cbd5e1 !important;
            color: #475569 !important;
            font-weight: 600 !important;
            text-align: center !important;
            font-family: monospace !important;
            white-space: nowrap !important;
            font-size: 0.34rem !important;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        body.dark-mode .tech-ledger-grid td {
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: #cbd5e1 !important;
        }

        .tech-ledger-grid td.particulars {
            text-align: left !important;
            font-family: inherit !important;
        }

        .tech-ledger-footer {
            font-size: 0.38rem;
            color: #64748b;
            text-align: center;
            font-weight: bold;
            border-top: 1.5px solid #cbd5e1;
            padding-top: 5px;
            font-family: 'Poppins', sans-serif;
            letter-spacing: 0.2px;
        }
        body.dark-mode .tech-ledger-footer {
            color: var(--gray-400);
            border-top-color: rgba(255, 255, 255, 0.1);
        }

        /* Status watermark overlays */
        .passbook-status-watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-25deg);
            font-size: 1.8rem;
            font-weight: 900;
            color: rgba(245, 158, 11, 0.15); /* default pending */
            border: 3.5px solid currentColor;
            padding: 4px 14px;
            border-radius: 6px;
            pointer-events: none;
            letter-spacing: 2px;
            text-transform: uppercase;
            user-select: none;
            z-index: 10;
        }

        .passbook-status-watermark.approved {
            color: rgba(16, 185, 129, 0.22) !important;
        }

        .passbook-status-watermark.rejected {
            color: rgba(239, 68, 68, 0.22) !important;
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

        /* --- REDESIGNED LIST TABLE & STATUS GLOWS --- */
        .passbook-history-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .passbook-history-table th {
            padding: 14px 18px;
            color: var(--gray-500);
            font-size: 0.85rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
            white-space: nowrap;
        }
        body.dark-mode .passbook-history-table th {
            color: var(--gray-400);
            border-bottom-color: rgba(255, 255, 255, 0.1);
        }
        .passbook-history-table td {
            padding: 16px 18px;
            font-size: 0.9rem;
            color: var(--gray-700);
            border-bottom: 1px solid rgba(99, 102, 241, 0.05);
            vertical-align: middle;
            white-space: nowrap;
            transition: all var(--transition-fast);
        }
        body.dark-mode .passbook-history-table td {
            color: var(--gray-300);
            border-bottom-color: rgba(255, 255, 255, 0.04);
        }
        .passbook-history-table tr {
            transition: background 0.2s ease;
        }
        .passbook-history-table tr:hover td {
            background: rgba(99, 102, 241, 0.02);
        }
        body.dark-mode .passbook-history-table tr:hover td {
            background: rgba(255, 255, 255, 0.01);
        }

        /* Glowing status badges */
        .status-badge {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        .status-badge i {
            font-size: 0.45rem;
        }
        .status-badge.approved {
            background: rgba(16, 185, 129, 0.12);
            color: #10b981;
            box-shadow: 0 0 12px rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        .status-badge.pending {
            background: rgba(245, 158, 11, 0.12);
            color: #f59e0b;
            box-shadow: 0 0 12px rgba(245, 158, 11, 0.15);
            border: 1px solid rgba(245, 158, 11, 0.2);
        }
        .status-badge.rejected {
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
            box-shadow: 0 0 12px rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .btn-inspect {
            padding: 6px 12px;
            font-size: 0.75rem;
            border-radius: var(--radius-sm);
            background: var(--gradient-primary) !important;
            color: white !important;
            border: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.15);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
        }
        .btn-inspect:hover {
            box-shadow: 0 6px 15px rgba(99, 102, 241, 0.3);
            transform: translateY(-1px);
        }

        .btn-renew-action {
            padding: 6px 12px;
            font-size: 0.75rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            border: 1.5px solid rgba(99, 102, 241, 0.2) !important;
            background: transparent !important;
            color: var(--gray-700) !important;
            transition: all var(--transition-normal);
            cursor: pointer;
        }
        body.dark-mode .btn-renew-action {
            color: var(--gray-300) !important;
            border-color: rgba(255, 255, 255, 0.15) !important;
        }
        .btn-renew-action:hover {
            background: var(--gradient-primary) !important;
            color: white !important;
            border-color: transparent !important;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
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
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty customer}">
                        <c:choose>
                            <c:when test="${not empty customer.avatarPath}">
                                <img src="${pageContext.request.contextPath}${customer.avatarPath}" alt="Customer Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                                    ${customer.fullName.substring(0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                            <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                            <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                                Customer Space
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gray-100); color: var(--gray-500); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1.5px solid var(--gray-200);">
                            <i class="bx bx-user"></i>
                        </div>
                        <span style="font-weight: 600; color: var(--gray-700); font-size: 0.85rem;" class="mobile-hide">Customer Space</span>
                    </c:otherwise>
                </c:choose>
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
                    <button type="button" class="btn-flip-book" onclick="toggleBookFlip(event)">
                        <i class="bx bx-refresh"></i> Flip Booklet
                    </button>
                    <div class="passbook-wrapper" onclick="toggleBookOpen()">
                        <div class="passbook-book" id="3dPassbook">
                            <!-- SVG Gradients Definition -->
                            <svg style="position: absolute; width: 0; height: 0;">
                                <defs>
                                    <linearGradient id="logoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#00f0ff" />
                                        <stop offset="50%" stop-color="#d900ff" />
                                        <stop offset="100%" stop-color="#ffffff" />
                                    </linearGradient>
                                </defs>
                            </svg>

                            <!-- 1. Base Page (Stationary Bottom Panel: Transaction Ledger & Back Cover) -->
                            <div class="passbook-panel base-page">
                                <!-- Base Page Front: Transaction Ledger -->
                                <div class="panel-face panel-front">
                                    <div class="transaction-panel-inside">
                                        <!-- Watermark V logo in background -->
                                        <div class="transaction-watermark-v">
                                            <svg viewBox="0 0 100 100" style="width: 100%; height: 100%; fill: #334155;">
                                                <path d="M15 15 L32 15 L50 62 L68 15 L85 15 L55 85 L45 85 Z" />
                                            </svg>
                                        </div>
                                        
                                        <!-- Top layout -->
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                                            <div class="tech-page-header-pill" style="background: linear-gradient(90deg, #6366f1 0%, #3b82f6 100%); margin-bottom: 0;">
                                                <h4 style="font-size: 0.55rem !important;">Transaction Record</h4>
                                            </div>
                                            <div style="width: 16px; height: 16px; display: flex; align-items: center; justify-content: center;">
                                                <svg viewBox="0 0 100 100" style="width: 100%; height: 100%;">
                                                    <path d="M15 15 L32 15 L50 62 L68 15 L85 15 L55 85 L45 85 Z" fill="url(#logoGrad)" />
                                                </svg>
                                            </div>
                                        </div>

                                        <!-- Ledger Table -->
                                        <table class="tech-ledger-grid">
                                            <colgroup>
                                                <col style="width: 16%;">
                                                <col style="width: 29%;">
                                                <col style="width: 10%;">
                                                <col style="width: 15%;">
                                                <col style="width: 15%;">
                                                <col style="width: 15%;">
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th>Date</th>
                                                    <th>Particulars</th>
                                                    <th>Chq No.</th>
                                                    <th>Withdrawal</th>
                                                    <th>Deposit</th>
                                                    <th>Balance</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>07-Jun-26</td>
                                                    <td class="particulars">Opening Bal</td>
                                                    <td>-</td>
                                                    <td>-</td>
                                                    <td>10,000.00</td>
                                                    <td>10,000.00</td>
                                                </tr>
                                                <tr>
                                                    <td>12-Jun-26</td>
                                                    <td class="particulars">Interest Paid</td>
                                                    <td>-</td>
                                                    <td>-</td>
                                                    <td>150.00</td>
                                                    <td>10,150.00</td>
                                                </tr>
                                                <tr>
                                                    <td>18-Jun-26</td>
                                                    <td class="particulars">ATM Wdl</td>
                                                    <td>-</td>
                                                    <td>2,000.00</td>
                                                    <td>-</td>
                                                    <td>8,150.00</td>
                                                </tr>
                                                <tr>
                                                    <td>22-Jun-26</td>
                                                    <td class="particulars">Passbook Fee</td>
                                                    <td>-</td>
                                                    <td>100.00</td>
                                                    <td>-</td>
                                                    <td>8,050.00</td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <div class="tech-ledger-footer" style="font-size: 0.35rem; margin-top: 2px; border-top: 1px solid #cbd5e1; padding-top: 3px;">
                                            BANKING BEYOND BOUNDARIES. BUILDING YOUR GALAXY OF WEALTH.
                                        </div>
                                    </div>
                                </div>
                                <!-- Base Page Back: Back Cover -->
                                <div class="panel-face panel-back">
                                    <div class="cosmic-cover">
                                        <!-- Cosmic Orbits background -->
                                        <div class="cosmic-orbits">
                                            <svg viewBox="0 0 100 100">
                                                <ellipse cx="50" cy="40" rx="35" ry="8" fill="none" stroke="rgba(0, 240, 255, 0.25)" stroke-width="0.8" transform="rotate(-25 50 40)" />
                                                <ellipse cx="50" cy="40" rx="42" ry="12" fill="none" stroke="rgba(217, 0, 255, 0.2)" stroke-width="0.6" transform="rotate(-25 50 40)" />
                                            </svg>
                                        </div>
                                        
                                        <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; margin-top: 5px;">
                                            <div style="width: 26px; height: 26px; margin-bottom: 2px;">
                                                <svg viewBox="0 0 100 100" style="width: 100%; height: 100%;">
                                                    <path d="M15 15 L32 15 L50 62 L68 15 L85 15 L55 85 L45 85 Z" fill="url(#logoGrad)" />
                                                </svg>
                                            </div>
                                            <span style="font-weight: 800; font-size: 0.52rem; letter-spacing: 1.5px; color: #fff; font-family: 'Poppins', sans-serif;">VERTEX GALAXY BANK</span>
                                            <span style="font-size: 0.38rem; letter-spacing: 0.5px; color: rgba(255,255,255,0.6); margin-top: 2px; font-family: 'Poppins', sans-serif; text-align: center;">Your Universe. Your Future. Our Commitment.</span>
                                        </div>

                                        <div class="cover-icons-row" style="margin: 4px 0;">
                                            <div class="cover-icon-box">
                                                <i class="bx bx-lock-alt"></i>
                                                <span>SECURE</span>
                                            </div>
                                            <div class="cover-icon-box">
                                                <i class="bx bx-atom"></i>
                                                <span>INNOVATIVE</span>
                                            </div>
                                            <div class="cover-icon-box">
                                                <i class="bx bx-shield-quarter"></i>
                                                <span>RELIABLE</span>
                                            </div>
                                            <div class="cover-icon-box">
                                                <i class="bx bx-rocket"></i>
                                                <span>FUTURISTIC</span>
                                            </div>
                                        </div>

                                        <div class="cover-contacts-row" style="padding-top: 4px;">
                                            <span><i class="bx bx-phone" style="color: #00f0ff;"></i> 1800 123 4567</span>
                                            <span><i class="bx bx-globe" style="color: #00f0ff;"></i> www.vertexgalaxybank.com</span>
                                            <span><i class="bx bx-envelope" style="color: #00f0ff;"></i> support@vertexgalaxybank.com</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2. Cover Flap (Top Panel: Front Cover & Split Info/Instructions) -->
                            <div class="passbook-panel cover-flap">
                                <!-- Cover Flap Front: Front Cover (visible when closed) -->
                                <div class="panel-face panel-front">
                                    <div class="cosmic-cover">
                                        <!-- Spine label text (only visible when book is closed and rotated) -->
                                        <div class="spine-text">
                                            <span>VERTEX GALAXY BANK</span>
                                            <span>PASSBOOK</span>
                                        </div>
                                        
                                        <!-- Cosmic Orbits background -->
                                        <div class="cosmic-orbits">
                                            <svg viewBox="0 0 100 100">
                                                <ellipse cx="50" cy="50" rx="36" ry="9" fill="none" stroke="rgba(0, 240, 255, 0.4)" stroke-width="1" transform="rotate(-25 50 50)" />
                                                <ellipse cx="50" cy="50" rx="44" ry="14" fill="none" stroke="rgba(217, 0, 255, 0.35)" stroke-width="0.8" transform="rotate(-25 50 50)" />
                                                <circle cx="20" cy="30" r="0.6" fill="#fff" opacity="0.8" />
                                                <circle cx="85" cy="25" r="0.8" fill="#fff" opacity="0.9" />
                                                <circle cx="75" cy="75" r="0.5" fill="#fff" opacity="0.6" />
                                                <circle cx="15" cy="80" r="0.7" fill="#fff" opacity="0.7" />
                                            </svg>
                                        </div>
                                        
                                        <!-- Top row -->
                                        <div style="display: flex; justify-content: space-between; align-items: center; padding-left: 12px;">
                                            <span style="font-weight: 800; font-size: 0.72rem; letter-spacing: 1px; color: #fff; text-shadow: 0 0 5px rgba(255,255,255,0.3); font-family: 'Poppins', sans-serif;">VERTEX</span>
                                            <span style="font-size: 0.95rem; color: #00f0ff; text-shadow: 0 0 8px rgba(0, 240, 255, 0.4);"><i class="bx bx-chip"></i></span>
                                        </div>
                                        
                                        <!-- Large Glowing V Logo in middle -->
                                        <div style="align-self: center; width: 62px; height: 62px; filter: drop-shadow(0 0 15px rgba(0, 240, 255, 0.45)); margin: 2px 0; display: flex; align-items: center; justify-content: center; position: relative;">
                                            <svg viewBox="0 0 100 100" style="width: 100%; height: 100%;">
                                                <path d="M15 15 L32 15 L50 62 L68 15 L85 15 L55 85 L45 85 Z" fill="url(#logoGrad)" />
                                            </svg>
                                        </div>

                                        <!-- Title section -->
                                        <div style="text-align: center; padding-left: 12px;">
                                            <div style="font-size: 0.46rem; letter-spacing: 2px; color: rgba(255,255,255,0.7); font-weight: 700; text-transform: uppercase; font-family: 'Poppins', sans-serif;">VERTEX GALAXY BANK</div>
                                            <div class="cover-title-frame">
                                                <h2>PASSBOOK</h2>
                                            </div>
                                        </div>

                                        <div style="font-size: 0.38rem; color: rgba(255,255,255,0.4); text-align: center; font-weight: 600; letter-spacing: 1.5px; text-transform: uppercase; font-family: 'Poppins', sans-serif; padding-left: 12px;">
                                            Always Beyond Boundaries
                                        </div>
                                    </div>
                                </div>
                                <!-- Cover Flap Back: Split Account Info & Instructions (visible when open) -->
                                <div class="panel-face panel-back">
                                    <div class="inside-tech-panel" style="padding: 10px 14px; flex-direction: row; gap: 12px; align-items: stretch; justify-content: space-between;">
                                        <!-- Left Column: Account Information -->
                                        <div style="flex: 1.3; display: flex; flex-direction: column; justify-content: space-between;">
                                            <div>
                                                <div class="tech-page-header-pill" style="margin-bottom: 4px;">
                                                    <h4>Account Info</h4>
                                                </div>
                                                <table class="tech-credentials-table">
                                                    <tr>
                                                        <td>Name</td>
                                                        <td>: <span class="uppercase text-ellipsis" id="pbCustName"><c:out value="${customer.firstName} ${customer.lastName}" default="CUSTOMER NAME"/></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>A/C No.</td>
                                                        <td>: <span class="monospace" id="pbAccNum">
                                                            <c:choose>
                                                                <c:when test="${not empty accounts}">
                                                                    ${accounts[0].accountNumber}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    SELECT ACCOUNT
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>IFSC Code</td>
                                                        <td>: <span class="monospace">VGB0000171</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>A/C Type</td>
                                                        <td>: <span class="uppercase" id="pbAccType">
                                                            <c:choose>
                                                                <c:when test="${not empty accounts}">
                                                                    ${accounts[0].accountType}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    SAVINGS
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Branch</td>
                                                        <td>: <span>BHAKTINAGAR, RAJKOT</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Date</td>
                                                        <td>: <span>08-AUG-2022</span></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div style="font-size: 0.33rem; color: rgba(255,255,255,0.4); text-align: left; font-weight: 500; font-family: 'Poppins', sans-serif;">
                                                Thank you for banking with VERTEX GALAXY BANK
                                            </div>
                                        </div>
                                        
                                        <!-- Right Column: Important Instructions -->
                                        <div style="flex: 1; display: flex; flex-direction: column; justify-content: space-between; border-left: 1px dashed rgba(255,255,255,0.15); padding-left: 12px;">
                                            <div>
                                                <h4 style="font-size: 0.52rem; font-weight: 800; letter-spacing: 0.5px; color: #ffffff; text-transform: uppercase; margin: 0 0 6px 0; font-family: 'Poppins', sans-serif; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 3px; text-align: center;">Instructions</h4>
                                                <ul class="instructions-tech-list" style="gap: 4px;">
                                                    <li><i class="bx bx-check-shield" style="font-size: 0.6rem;"></i> Bring passbook for all counter transactions.</li>
                                                    <li><i class="bx bx-shield-quarter" style="font-size: 0.6rem;"></i> Report any discrepancy immediately.</li>
                                                    <li><i class="bx bx-credit-card-front" style="font-size: 0.6rem;"></i> Property of Vertex Galaxy Bank.</li>
                                                    <li><i class="bx bx-error-alt" style="font-size: 0.6rem;"></i> Keep secure. Do not fold/tear.</li>
                                                </ul>
                                            </div>
                                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                                <div class="circular-lock-badge" style="width: 22px; height: 22px; border-width: 1px;">
                                                    <i class="bx bx-shield-quarter" style="font-size: 0.75rem;"></i>
                                                </div>
                                                <div style="width: 22px; height: 11px; opacity: 0.8;">
                                                    <svg viewBox="0 0 100 100" style="width: 100%; height: 100%;">
                                                        <path d="M15 15 L32 15 L50 62 L68 15 L85 15 L55 85 L45 85 Z" fill="url(#logoGrad)" />
                                                    </svg>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="passbook-status-watermark" id="pbWatermark">PREVIEW</div>
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
                            <li>Flat processing fee of <strong>â‚¹100.00</strong> (fully refunded if request is rejected by Admin)</li>
                        </ul>
                    </div>
                    <div style="background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-md); padding: 18px; margin-top: 15px;">
                        <span style="font-size: 0.75rem; font-weight: 700; color: var(--primary-600); text-transform: uppercase; letter-spacing: 0.5px; display: block; margin-bottom: 6px;">Important Policy</span>
                        <p style="font-size: 0.8rem; color: var(--gray-500); margin: 0; line-height: 1.5;">
                            Applying for a Passbook will automatically deduct â‚¹100.00 from your account balance. Upon approval, your account parameters will be updated to enable passbook transactions.
                        </p>
                    </div>
                </div>
            </div>

            <!-- List of previous requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-list-ol"></i> Application History</h3>
                <div style="overflow-x: auto;">
                    <table class="passbook-history-table">
                        <thead>
                            <tr>
                                <th>Request ID</th>
                                <th>Account Number</th>
                                <th>Type</th>
                                <th>Fee Status</th>
                                <th>Requested Date</th>
                                <th>Status</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="req" items="${requests}">
                                        <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                        <tr>
                                            <td style="font-weight: 700;">#${req.requestId}</td>
                                            <td style="font-family: monospace; font-weight: 600;">${req.accountNumber}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${req.requestType eq 'new'}">
                                                        <span class="badge-new">New Cover</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-renew">Renewal</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span style="font-weight: 600;">â‚¹<fmt:formatNumber value="${req.charges}" minFractionDigits="2"/></span>
                                                <c:choose>
                                                    <c:when test="${req.chargesPaid}">
                                                        <span class="status-badge approved" style="font-size: 0.7rem; padding: 2px 6px; margin-left: 5px;"><i class="bx bx-check"></i> Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge rejected" style="font-size: 0.7rem; padding: 2px 6px; margin-left: 5px;"><i class="bx bx-x"></i> Refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${req.requestedAt}" pattern="dd-MMM-yyyy hh:mm a" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${req.status eq 'approved' or req.status eq 'delivered'}">
                                                        <span class="status-badge approved"><i class="bx bxs-circle"></i> Approved</span>
                                                    </c:when>
                                                    <c:when test="${req.status eq 'pending'}">
                                                        <span class="status-badge pending"><i class="bx bxs-circle"></i> Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge rejected"><i class="bx bxs-circle"></i> Rejected</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; gap: 8px; justify-content: flex-end; align-items: center;">
                                                    <button type="button" class="btn-inspect" 
                                                            data-id="${req.requestId}" 
                                                            data-name="${req.customerName}" 
                                                            data-account="${req.accountNumber}" 
                                                            data-type="${req.requestType}" 
                                                            data-acctype="${req.accountType}"
                                                            data-status="${req.status}"
                                                            onclick="inspectRequest(this)">
                                                        <i class="bx bx-show"></i> Inspect
                                                    </button>
                                                    <c:if test="${req.status eq 'approved'}">
                                                        <button onclick="openRequestModal('renew', '${req.accountId}')" class="btn-renew-action">Renew</button>
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
                        <div class="fee-badge">Fee: â‚¹100.00</div>
                        <div class="paper-header">
                            <h2>VERTEX GALAXY BANK</h2>
                            <h3>PASSBOOK APPLICATION FORM</h3>
                        </div>
                        
                        <div style="margin-bottom: 20px;">
                            <label style="font-weight: bold; font-size: 0.85rem; color: #475569; display: block; margin-bottom: 5px;">SELECT LINKED ACCOUNT</label>
                            <select name="accountId" id="modalAccountId" class="paper-select" style="width: 100%; padding: 6px 0;" onchange="updateModalPreview()" required>
                                <c:forEach var="acc" items="${accounts}">
                                    <option value="${acc.accountId}" data-accnum="${acc.accountNumber}" data-acctype="${acc.accountType}">
                                        ${acc.accountNumber} (${acc.accountType}) - Bal: â‚¹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2"/>
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
                        <button type="submit" class="btn btn-primary" style="padding: 10px 20px; font-weight: 600;">Confirm & Debit â‚¹100.00</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
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
        });

        const book = document.getElementById('3dPassbook');
        const container = document.querySelector('.passbook-visualizer-container');
        const hint = document.getElementById('pbHint');

        // Dynamically scale book to fit container width without clipping
        function updateBookTransform(rotX = 0, rotY = 0) {
            if (!book || !container) return;
            const currentContainer = book.closest('#modalPassbookScene') || container;
            const containerWidth = currentContainer.clientWidth;
            if (book.classList.contains('open')) {
                // Open vertical book height is 360px, width is 420px
                const openScale = Math.min((containerWidth - 30) / 420, 0.75);
                book.style.transform = `rotateX(${25 + rotX}deg) rotateY(${-5 + rotY}deg) scale(${openScale})`;
            } else if (book.classList.contains('flipped-back')) {
                // Flipped closed book
                const closedScale = Math.min((containerWidth - 20) / 420, 0.85);
                book.style.transform = `rotateX(${195 + rotX}deg) rotateY(${10 + rotY}deg) scale(${closedScale})`;
            } else {
                // Closed book width is 420px, height is 180px
                const closedScale = Math.min((containerWidth - 20) / 420, 0.85);
                book.style.transform = `rotateX(${15 + rotX}deg) rotateY(${-10 + rotY}deg) scale(${closedScale})`;
            }
        }

        if (container && book) {
            container.addEventListener('mousemove', (e) => {
                const rect = container.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;

                const centerX = rect.width / 2;
                const centerY = rect.height / 2;

                const maxRotX = book.classList.contains('open') ? 10 : 15;
                const maxRotY = book.classList.contains('open') ? 8 : 15;

                const rotX = -((y - centerY) / centerY) * maxRotX;
                const rotY = ((x - centerX) / centerX) * maxRotY;

                requestAnimationFrame(() => {
                    updateBookTransform(rotX, rotY);
                });
            });

            container.addEventListener('mouseleave', () => {
                requestAnimationFrame(() => {
                    updateBookTransform(0, 0);
                });
            });

            // Initial scale update
            updateBookTransform(0, 0);
            
            // Re-scale on window resize
            window.addEventListener('resize', () => {
                updateBookTransform(0, 0);
            });
        }

        function toggleBookOpen() {
            if (!book) return;
            book.classList.remove('flipped-back');
            book.classList.toggle('open');
            if (book.classList.contains('open')) {
                if (hint) hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Close';
            } else {
                if (hint) hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Open';
            }
            updateBookTransform(0, 0);
        }

        function toggleBookFlip(event) {
            if (event) event.stopPropagation();
            if (!book) return;
            book.classList.remove('open');
            book.classList.toggle('flipped-back');
            if (book.classList.contains('flipped-back')) {
                if (hint) hint.innerHTML = '<i class="bx bx-refresh"></i> Back Cover View';
            } else {
                if (hint) hint.innerHTML = '<i class="bx bx-pointer"></i> Click to Open';
            }
            updateBookTransform(0, 0);
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
            book.classList.remove('flipped-back');
            if (!book.classList.contains('open')) {
                toggleBookOpen();
            }

            // Scroll visualizer into view on mobile
            container.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    </script>
</body>
</html>

