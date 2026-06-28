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
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
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

        /* Ambient Glow */
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
            border: 1.5px solid rgba(191, 149, 63, 0.35);
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

        .paper-select {
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
        body.dark-mode .paper-select {
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

        /* ===== FLAT BOOKLET PASSBOOK PREVIEW ===== */
        .passbook-top-layout {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 30px;
            margin-bottom: 35px;
            align-items: stretch;
        }

        @media (max-width: 991px) {
            .passbook-top-layout {
                grid-template-columns: 1fr !important;
            }
        }

        .passbook-visualizer-container {
            position: relative;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.03) 0%, rgba(6, 182, 212, 0.03) 100%);
            border: 1px solid rgba(99, 102, 241, 0.1);
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
            border-color: rgba(255, 255, 255, 0.08);
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.06) 0%, rgba(6, 182, 212, 0.06) 100%);
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
                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
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

            <!-- Split Dashboard: Service Features -->
            <div class="passbook-top-layout" style="display: block;">
                <!-- Quick Features Summary -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; width: 100%;" class="mobile-grid-1">
                    <div class="glass-card" style="margin-bottom: 0;">
                        <h3 style="font-size: 1.4rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-shield-quarter" style="color: var(--primary-500);"></i> Premium Galaxy Passbook
                        </h3>
                        <p style="color: var(--gray-500); font-size: 0.9rem; line-height: 1.6;">
                            Our galaxy-class physical passbook comes standard with:
                        </p>
                        <ul style="color: var(--gray-600); font-size: 0.85rem; padding-left: 20px; line-height: 1.8; margin: 15px 0;">
                            <li>Galaxy navy-blue textured covers with gold foil accents</li>
                            <li>Inline smart EMV-style chip simulator representing security</li>
                            <li>Quick-scan machine-readable ledger columns</li>
                            <li>Flat processing fee of <strong>₹100.00</strong> (refunded if request rejected)</li>
                        </ul>
                    </div>
                    <div class="glass-card" style="margin-bottom: 0; display: flex; flex-direction: column; justify-content: space-between;">
                        <div>
                            <h3 style="font-size: 1.4rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-info-circle" style="color: var(--primary-500);"></i> Important Policy
                            </h3>
                            <p style="color: var(--gray-500); font-size: 0.9rem; line-height: 1.6;">
                                Applying for a Passbook will automatically deduct ₹100.00 from your account balance. Upon approval, your account parameters will be updated to enable passbook transactions.
                            </p>
                        </div>
                        <div style="background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-md); padding: 18px; margin-top: 15px;">
                            <span style="font-size: 0.75rem; font-weight: 700; color: var(--primary-600); text-transform: uppercase; letter-spacing: 0.5px; display: block; margin-bottom: 6px;">Note on System</span>
                            <p style="font-size: 0.8rem; color: var(--gray-500); margin: 0; line-height: 1.5;">
                                Passbook details are secure and linked to your digital account transactions in real-time.
                            </p>
                        </div>
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
                                                    <c:when test="${req.requestType eq 'new' or req.requestType eq 'apply'}">
                                                        <span class="badge-new">New Cover</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-renew">Renewal</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span style="font-weight: 600;">₹<fmt:formatNumber value="${req.charges}" minFractionDigits="2"/></span>
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
                                                     <button type="button" class="btn-inspect" style="display:none;" 
                                                            data-id="${req.requestId}" 
                                                            data-name="${req.customerName}" 
                                                            data-account="${req.accountNumber}" 
                                                            data-type="${req.requestType}" 
                                                            data-acctype="${req.accountType} Account"
                                                            data-ifsc="${req['ifscCode']}"
                                                            data-phone="${req['phoneNo']}"
                                                            data-nominee="${req['nomineeName']}"
                                                            data-status="${req.status}"
                                                            onclick="inspectRequest(this)">
                                                        <i class="bx bx-show"></i> Inspect
                                                    </button>
                                                    <c:if test="${req.status eq 'approved' or req.status eq 'delivered'}">
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
                        <div class="fee-badge">Fee: ₹100.00</div>
                        <div class="paper-header">
                            <h2>VERTEX GALAXY BANK</h2>
                            <h3>PASSBOOK APPLICATION FORM</h3>
                        </div>
                        
                        <div style="margin-bottom: 20px;">
                            <label style="font-weight: bold; font-size: 0.85rem; color: #475569; display: block; margin-bottom: 5px;">SELECT LINKED ACCOUNT</label>
                            <select name="accountId" id="modalAccountId" class="paper-select" style="width: 100%; padding: 6px 0;" onchange="updateModalPreview()" required>
                                <c:forEach var="acc" items="${accounts}">
                                    <option value="${acc.accountId}" 
                                            data-accnum="${acc.accountNumber}" 
                                            data-acctype="${acc.accountType} Account"
                                            data-ifsc="${acc.ifscCode}"
                                            data-nominee="${acc.accountType eq 'current' ? acc.businessName : (not empty acc.nomineeName ? acc.nomineeName : 'None')}"
                                            data-phone="${customer.phoneNo}">
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
        }

        function closeRequestModal() {
            document.getElementById('requestModal').style.display = 'none';
        }

        function updateFormAction() {
            const selectType = document.getElementById('modalRequestType');
            const formAction = document.getElementById('formAction');
            formAction.value = selectType.value;
        }
    </script>
</body>
</html>
