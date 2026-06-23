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
    <title>VGB | Cheque Book Services</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
    <style>
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.9) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border-right: 1px solid rgba(99, 102, 241, 0.15) !important;
            padding: 30px 20px;
            position: fixed;
            top: 80px;
            bottom: 0;
            left: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
        .sidebar-menu a:hover i {
            transform: scale(1.1);
        }
        .sidebar-menu a.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
            border-color: transparent;
        }
        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: var(--gray-50);
            transition: all 0.3s ease;
        }
        .footer {
            margin-left: 280px;
            background: white;
            border-top: 1px solid rgba(99, 102, 241, 0.15);
            padding: 20px 0;
            transition: all 0.3s ease;
        }
        .mobile-nav-toggle {
            display: none !important;
        }
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
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
        }
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
        @media (max-width: 480px) {
            .mobile-hide {
                display: none !important;
            }
        }

        .services-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 35px;
        }

        .service-feature-card {
            border-radius: 16px;
            padding: 24px;
            color: white;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 160px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .service-feature-card.primary {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
        }
        .service-feature-card.secondary {
            background: linear-gradient(135deg, #0d9488 0%, #14b8a6 100%);
        }

        .service-feature-card .icon-bg {
            position: absolute;
            right: -20px;
            bottom: -20px;
            font-size: 8rem;
            color: rgba(255, 255, 255, 0.08);
            pointer-events: none;
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
            max-width: 720px;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }

        .modal-content form {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            margin: 0;
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

        @media (max-width: 768px) {
            .modal-content {
                max-width: 95% !important;
                max-height: 95vh !important;
            }
            .modal-body {
                padding: 15px !important;
                max-height: calc(95vh - 70px) !important;
            }
            .paper-form {
                padding: 20px 15px !important;
                font-size: 0.85rem !important;
            }
            .paper-form h2 {
                font-size: 1.1rem !important;
            }
            .paper-form h3 {
                font-size: 0.85rem !important;
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
            color: #ef4444;
        }

        /* Borderless Paper Form styles */
        .paper-form {
            background: #fff;
            border: 1.5px solid var(--gray-200);
            padding: 35px 30px;
            border-radius: var(--radius-sm);
            color: #1e293b;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 25px;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm);
            position: relative;
            overflow: hidden;
        }

        .paper-watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 7.5rem;
            font-weight: 900;
            color: rgba(99, 102, 241, 0.03);
            pointer-events: none;
            user-select: none;
            font-family: 'Poppins', sans-serif;
            letter-spacing: 5px;
        }

        .paper-header {
            text-align: center;
            border-bottom: 2px double #475569;
            padding-bottom: 12px;
            margin-bottom: 20px;
            position: relative;
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

        .paper-header h3 {
            font-size: 1rem;
            font-weight: 700;
            color: #475569;
            margin: 4px 0 0;
            text-transform: uppercase;
            font-family: 'Poppins', sans-serif;
            letter-spacing: 0.5px;
        }

        .fee-badge {
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-600);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-family: 'Poppins', sans-serif;
        }

        .paper-table {
            width: 100%;
            border-collapse: collapse;
        }

        .paper-input {
            border: none;
            border-bottom: 1px dotted #475569;
            padding: 2px 5px;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
        }

        .paper-select {
            border: none;
            border-bottom: 1px dotted #475569;
            padding: 2px 5px;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
            cursor: pointer;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }

        .paper-section-title {
            border-bottom: 1px solid #94a3b8;
            padding-bottom: 3px;
            margin: 0 0 10px;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            font-weight: 700;
            color: #475569;
            font-family: 'Poppins', sans-serif;
        }

        .signature-font {
            display: block;
            font-size: 1.4rem;
            font-style: italic;
            color: #3b82f6;
            font-family: 'Brush Script MT', cursive, sans-serif;
            padding-bottom: 5px;
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
            transform: rotateX(15deg) rotateY(-10deg);
            transition: transform 0.8s cubic-bezier(0.25, 1, 0.5, 1);
        }

        /* 3D panels */
        .chequebook-panel {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .base-page {
            z-index: 10;
        }

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

        .chequebook-book.open .cover-flap {
            transform: rotateX(180deg) translateZ(0.5px); /* Opens upwards */
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

        @keyframes pulseHint {
            0%, 100% { opacity: 0.5; transform: translateX(0); }
            50% { opacity: 1; transform: translateX(3px); }
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

        /* Modern Request Log Table UI */
        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            text-align: left;
        }
        
        .modern-table th {
            padding: 16px 20px;
            color: var(--gray-500);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid var(--gray-100);
            background: rgba(248, 250, 252, 0.5);
            white-space: nowrap;
        }
        
        .modern-table tbody tr {
            transition: all var(--transition-normal);
            border-bottom: 1px solid var(--gray-100);
        }
        
        .modern-table tbody tr:hover {
            background-color: rgba(99, 102, 241, 0.02);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.03);
        }
        
        .modern-table td {
            padding: 18px 20px;
            font-size: 0.9rem;
            color: var(--gray-700);
            vertical-align: middle;
            white-space: nowrap;
        }

        /* Status Badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 6px 12px;
            border-radius: var(--radius-full);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: var(--shadow-sm);
        }
        
        .status-badge.approved, .status-badge.delivered {
            background: rgba(16, 185, 129, 0.1) !important;
            color: var(--accent-emerald) !important;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .status-badge.pending {
            background: rgba(245, 158, 11, 0.1) !important;
            color: #d97706 !important;
            border: 1px solid rgba(245, 158, 11, 0.2);
        }
        
        .status-badge.rejected {
            background: rgba(239, 68, 68, 0.1) !important;
            color: #dc2626 !important;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        
        .status-badge i {
            font-size: 0.5rem;
        }

        /* Charges Badge */
        .charge-status-badge {
            font-size: 0.7rem;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: var(--radius-sm);
            margin-left: 6px;
            display: inline-flex;
            align-items: center;
            gap: 3px;
        }
        
        .charge-status-badge.paid {
            background: rgba(16, 185, 129, 0.08);
            color: #047857;
            border: 1px solid rgba(16, 185, 129, 0.15);
        }
        
        .charge-status-badge.refunded {
            background: rgba(239, 68, 68, 0.08);
            color: #b91c1c;
            border: 1px solid rgba(239, 68, 68, 0.15);
        }
        
        /* Action Button Refinements */
        .btn-view-leaf {
            padding: 8px 16px;
            font-size: 0.78rem;
            border-radius: var(--radius-md);
            background: rgba(99, 102, 241, 0.08) !important;
            color: var(--primary-600) !important;
            border: 1.5px solid rgba(99, 102, 241, 0.15) !important;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all var(--transition-normal);
            cursor: pointer;
        }
        
        .btn-view-leaf:hover {
            background: var(--gradient-primary) !important;
            color: white !important;
            border-color: transparent !important;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
            transform: translateY(-1px);
        }
        
        .btn-renew-action {
            background: rgba(16, 185, 129, 0.08) !important;
            color: #047857 !important;
            border: 1.5px solid rgba(16, 185, 129, 0.15) !important;
            padding: 8px 16px;
            font-size: 0.78rem;
            border-radius: var(--radius-md);
            font-weight: 700;
            cursor: pointer;
            transition: all var(--transition-normal);
        }
        
        .btn-renew-action:hover {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important;
            color: white !important;
            border-color: transparent !important;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
            transform: translateY(-1px);
        }
        
        .info-tag-text {
            font-size: 0.78rem;
            color: var(--gray-400);
            font-style: italic;
            font-weight: 500;
        }

        /* Custom Scrollbar for modern tables */
        .table-responsive-wrapper {
            overflow-x: auto;
            scrollbar-width: thin;
            scrollbar-color: rgba(99, 102, 241, 0.35) rgba(241, 245, 249, 0.5);
            padding-bottom: 8px; /* Extra padding to prevent clipping shadow */
        }
        
        .table-responsive-wrapper::-webkit-scrollbar {
            height: 6px;
            width: 6px;
        }
        
        .table-responsive-wrapper::-webkit-scrollbar-track {
            background: rgba(241, 245, 249, 0.4);
            border-radius: var(--radius-full);
        }
        
        .table-responsive-wrapper::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.25);
            border-radius: var(--radius-full);
            border: 1px solid transparent;
            background-clip: padding-box;
            transition: all 0.3s ease;
        }
        
        .table-responsive-wrapper::-webkit-scrollbar-thumb:hover {
            background: rgba(99, 102, 241, 0.5);
            border: 1px solid transparent;
            background-clip: padding-box;
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
            <a href="${pageContext.request.contextPath}/chequebook?action=list" class="active"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
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
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Cheque Book Services</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Apply for standard or high-capacity cheque books, track status, and view leaf configurations.</p>
                </div>
                <div>
                    <button onclick="openRequestModal('apply')" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <i class="bx bx-plus-circle"></i> Request Cheque Book
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

            <!-- Split Dashboard: Service Features & Interactive 3D Cheque Visualizer -->
            <div class="cheque-top-layout">
                <!-- Left: Quick Features Summary -->
                <div style="display: flex; flex-direction: column; gap: 20px; height: 100%;">
                    <div class="service-feature-card primary" style="flex: 1; min-height: 140px; padding: 20px;">
                        <div>
                            <span style="font-size: 0.8rem; font-weight: 700; opacity: 0.85; text-transform: uppercase;">Standard Services</span>
                            <h3 style="font-size: 1.3rem; font-weight: 800; margin-top: 5px;">Cheque Books</h3>
                            <p style="font-size: 0.82rem; opacity: 0.9; margin-top: 5px;">Select from 25, 50, or 100 leaf booklets linked securely to your savings or current accounts.</p>
                        </div>
                        <div style="font-size: 0.8rem; font-weight: 700; margin-top: 15px;">
                            <span>Charges: From ₹100.00 only</span>
                        </div>
                        <i class="bx bx-book-open icon-bg" style="font-size: 6rem;"></i>
                    </div>

                    <div class="service-feature-card secondary" style="flex: 1; min-height: 140px; padding: 20px;">
                        <div>
                            <span style="font-size: 0.8rem; font-weight: 700; opacity: 0.85; text-transform: uppercase;">Safety First</span>
                            <h3 style="font-size: 1.3rem; font-weight: 800; margin-top: 5px;">Secured Delivery</h3>
                            <p style="font-size: 0.82rem; opacity: 0.9; margin-top: 5px;">All new cheque books are dispatched via speed post to your registered address with tamper-proof seal packaging.</p>
                        </div>
                        <div style="font-size: 0.8rem; font-weight: 700; margin-top: 15px;">
                            <span>Deliveries fully tracked in dashboard</span>
                        </div>
                        <i class="bx bx-shield-quarter icon-bg" style="font-size: 6rem;"></i>
                    </div>
                </div>

                <!-- Right: Interactive 3D Cheque Visualizer Booklet -->
                <div class="cheque-visualizer-container">
                    <button type="button" class="btn-flip-book" onclick="toggleBookFlip(event)">
                        <i class="bx bx-refresh"></i> Flip Booklet
                    </button>
                    <div class="chequebook-wrapper" id="chequebookWrapper" onclick="toggleBookOpen()">
                        <div class="chequebook-book" id="3dChequebook">
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
                                <div class="cheque-leaf-wrapper" id="chequeLeafFlipWrapper">
                                    <!-- Cheque Leaf Front -->
                                    <div class="cheque-leaf-front" onclick="toggleChequeLeafFlip(event)">
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
                                                <div class="date-squares" id="chequeDateSquares">
                                                    <span>3</span><span>1</span><span>0</span><span>5</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                                </div>
                                                <div style="font-size: 0.45rem; color: #64748b; font-weight: bold; margin-top: 1px; text-transform: uppercase;">Valid for 3 months</div>
                                            </div>
                                        </div>
  
                                        <!-- Pay row -->
                                        <div class="cheque-row" style="margin-top: 5px;">
                                            <span class="cheque-label">PAY TO THE ORDER OF <span class="hindi-text">अदा करें</span></span>
                                            <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.82rem;" id="chequePayeeDisplay">Self or Bearer</span>
                                            <span class="cheque-label bearer-text">OR BEARER <span class="hindi-text">या धारक को</span></span>
                                        </div>
  
                                        <!-- Rupees row -->
                                        <div class="cheque-row">
                                            <span class="cheque-label">RUPEES / DOLLARS <span class="hindi-text">रुपये</span></span>
                                            <span class="cheque-line-fill" id="chequeRupeesTextDisplay">One Hundred and Fifty Rupees Only</span>
                                            <div class="cheque-amount-box">
                                                <span class="rupee-symbol">₹</span>
                                                <span class="amount-val" id="chequeAmountDisplay">150.00</span>
                                            </div>
                                        </div>
  
                                        <!-- Account details row -->
                                        <div class="cheque-details-row">
                                            <div class="cheque-acc-box">
                                                <span class="acc-label">A/C No.<br><span class="hindi-text">खाता क्र.</span></span>
                                                <span class="acc-val" id="chequeAccountDisplayVal">50100170255263</span>
                                            </div>
                                            <div class="cheque-branch-codes">
                                                Brn: 0171 Pdt: 105<br>SB A/C
                                            </div>
                                            <div class="cheque-payable-text">
                                                Payable at par through clearing/transfer at all branches of VERTEX GALAXY BANK LTD
                                            </div>
                                            <div class="cheque-sign-area">
                                                <span class="cheque-sign-name" id="chequeSignatureVal">${customer.firstName} ${customer.lastName}</span>
                                                <span class="cheque-sign-label">Please sign above / Authorized Signatory</span>
                                            </div>
                                        </div>
  
                                        <!-- Bottom MICR band -->
                                        <div class="cheque-micr-band" id="chequeMicrVal" style="display: flex; align-items: center; justify-content: center; gap: 20px;">
                                            <span>⑈000076⑈</span> <span>360240005⑆</span> <span>018696⑈</span> <span>31</span>
                                        </div>
                                    </div>
                                    
                                    <!-- Cheque Leaf Back -->
                                    <div class="cheque-leaf-back-side" onclick="toggleChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <ellipse cx="80" cy="80" rx="40" ry="15" fill="none" stroke="#94a3b8" stroke-width="1.2" transform="rotate(-15 80 80)" />
                                            <ellipse cx="80" cy="80" rx="60" ry="25" fill="none" stroke="#94a3b8" stroke-width="1.8" transform="rotate(-15 80 80)" />
                                        </svg>
                                        
                                        <div style="display: flex; gap: 20px; height: 100%; box-sizing: border-box; position: relative; z-index: 2;">
                                            <!-- Signature Box -->
                                            <div style="flex: 1.1; display: flex; flex-direction: column; justify-content: space-between;">
                                                <div style="border: 1px dashed #94a3b8; border-radius: 4px; background: rgba(255,255,255,0.7); height: 75px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 5px; box-sizing: border-box;">
                                                    <span class="cheque-sign-name" id="chequeSignatureBackVal" style="font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.2rem; font-style: italic; color: #2563eb; line-height: 1; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${customer.firstName} ${customer.lastName}</span>
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
                            <div class="chequebook-page page-instructions" id="chequeInstructionsPage" onclick="toggleInstructionsPage(event)" style="z-index: 25;">
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
                    <div class="click-hint" id="chequeHint" style="position: absolute; bottom: 12px; right: 15px; font-size: 0.65rem; color: var(--primary-500); display: flex; align-items: center; gap: 4px; font-weight: 500; animation: pulseHint 2s infinite; pointer-events: none;"><i class="bx bx-pointer"></i> Click to Open</div>
                </div>
            </div>

            <!-- List of Previous Requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-list-ul" style="color: var(--primary-500);"></i> Request Status & Log Tracker
                </h3>
                <div class="table-responsive-wrapper">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>Request ID</th>
                                <th>Linked Account</th>
                                <th>Book Capacity</th>
                                <th>Charges Paid</th>
                                <th>Submission Date</th>
                                <th>Current Status</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="req" items="${requests}">
                                        <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                        <tr>
                                            <td style="font-weight: 700; color: var(--gray-800);">#${req.requestId}</td>
                                            <td style="font-family: monospace; font-weight: 600;">${req.accountNumber}</td>
                                            <td><strong>${req.leavesCount} Leaves</strong></td>
                                            <td>
                                                <span style="font-weight: 600; color: var(--gray-700);">₹<fmt:formatNumber value="${req.charges}" minFractionDigits="2"/></span>
                                                <c:choose>
                                                    <c:when test="${req.chargesPaid}">
                                                        <span class="charge-status-badge paid"><i class="bx bx-check"></i> Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="charge-status-badge refunded"><i class="bx bx-x"></i> Refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="color: var(--gray-500);">
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
                                                    <button type="button" class="btn-view-leaf" 
                                                            data-id="${req.requestId}" 
                                                            data-name="${req.customerName}" 
                                                            data-account="${req.accountNumber}" 
                                                            data-leaves="${req.leavesCount}" 
                                                            data-charges="${req.charges}" 
                                                            data-date="${formattedDate}" 
                                                            data-status="${req.status}"
                                                            onclick="inspectRequest(this)">
                                                        <i class="bx bx-show"></i> View Leaf
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${req.status eq 'approved'}">
                                                            <button onclick="openRequestModal('renew')" class="btn-renew-action">Renew</button>
                                                        </c:when>
                                                        <c:when test="${req.status eq 'rejected'}">
                                                            <span class="info-tag-text">Refunded</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="info-tag-text">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="padding: 30px; text-align: center; color: var(--gray-400); font-style: italic;">
                                            <i class="bx bx-info-circle" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i> No cheque book requests submitted yet.
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

    <!-- Modal: Premium Borderless Cheque Request / Renewal Form -->
    <div id="requestModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);" id="modalTitle"><i class="bx bx-edit"></i> Cheque Book Application Request</h3>
                <button type="button" onclick="closeRequestModal()" class="close-btn">&times;</button>
            </div>
            <form id="chequeBookForm" action="${pageContext.request.contextPath}/chequebook?action=apply" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <div class="modal-body" style="padding-top: 15px;">
                    
                    <!-- Digital Paper Form -->
                    <div class="paper-form">
                        <!-- Watermark -->
                        <div class="paper-watermark">VGB</div>
                        
                        <!-- Form Header -->
                        <div class="paper-header">
                            <h2>Vertex Galaxy Bank</h2>
                            <h3 id="formSubTitle">Cheque Book Issuance & Renewal Request Form</h3>
                            <span class="fee-badge">
                                Total Fee Due: <strong id="formFeeDisplay" style="font-weight: 800; color: var(--primary-700);">₹ 150.00</strong>
                            </span>
                        </div>
                        
                        <!-- Header Details -->
                        <table class="paper-table" style="margin-bottom: 20px;">
                            <tr>
                                <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                    <strong>To,</strong><br>
                                    The Branch Manager<br>
                                    <strong>Vertex Galaxy Bank</strong><br>
                                    Branch: <input type="text" name="branch" class="paper-input" style="width: 250px;" value="Main Corporate Branch, Mumbai">
                                </td>
                                <td style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                    <strong>Date:</strong> <input type="text" name="formDate" id="formDateStr" class="paper-input" style="width: 120px; text-align: center;" value="">
                                </td>
                            </tr>
                        </table>
                        
                        <div style="margin-bottom: 20px;">
                            <strong>Subject:</strong> <span style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;" id="subjectLine">Request for New Cheque Book Issuance</span>
                        </div>
                        
                        <!-- Customer Information -->
                        <div style="margin-bottom: 20px;">
                            <h4 class="paper-section-title">Customer Information</h4>
                            <table class="paper-table">
                                <tr>
                                    <td style="width: 35%; padding: 5px 0;"><strong>Account Holder Name:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" id="custNameInput" name="customerName" required value="${customer.firstName} ${customer.lastName}" oninput="updateSignature(this.value)" placeholder="ENTER HOLDER NAME" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Linked Account Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <select id="accountIdSelect" name="accountId" required class="paper-select" style="width: 100%;">
                                            <c:forEach items="${accounts}" var="acc">
                                                <option value="${acc.accountId}">
                                                    ${acc.accountNumber} - ${acc.accountType} (Balance: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Customer ID:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="customerIdVal" class="paper-input" style="width: 100%;" value="${customer.customerId}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="mobile" class="paper-input" style="width: 100%;" value="${customer.phoneNo}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Email Address:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="email" class="paper-input" style="width: 100%;" value="${customer.email}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="address" class="paper-input" style="width: 100%; font-size: 0.85rem;" value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Cheque Book Specifications -->
                        <div style="margin-bottom: 25px;">
                            <h4 class="paper-section-title">Cheque Book Details</h4>
                            <table class="paper-table">
                                <tr>
                                    <td style="width: 35%; padding: 5px 0;"><strong>Book Capacity (Leaves):</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <select id="leavesCountSelect" name="leavesCount" required class="paper-select" style="width: 100%; font-weight: bold;" onchange="updateFeeDue()">
                                            <option value="25">25 Leaves Booklet (₹100.00)</option>
                                            <option value="50" selected>50 Leaves Booklet (₹150.00)</option>
                                            <option value="100">100 Leaves Booklet (₹250.00)</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Declaration & Terms -->
                        <div style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                            <p style="margin: 0 0 10px;"><strong>Request Description:</strong> I hereby request the bank to issue a new multi-city Cheque Book linked to my account number mentioned above. I confirm my account contains sufficient funds to cover the applicable service charge.</p>
                            <p style="margin: 0;"><strong>Declaration:</strong> I declare that all signatures are mine and the information provided is correct. The bank holds the right to reject this application if any details are invalid.</p>
                        </div>
                        
                        <!-- Signatures Row -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                            <div>
                                <span class="signature-font" id="formSignature">${customer.firstName} ${customer.lastName}</span>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer Signature</span>
                            </div>
                            <div style="text-align: center;">
                                <div style="width: 150px; height: 50px; border: 1px dashed #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: #64748b; font-family: 'Poppins', sans-serif;">BANK USE ONLY</div>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 150px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif; margin-top: 5px;">Officer Signature</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Submit -->
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-weight: 600; font-family: 'Poppins', sans-serif; font-size: 1rem; border-radius: var(--radius-md);" id="submitFormBtn">Process Cheque Book Order</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripting for Modal Operations -->
    <script>
        function openRequestModal(action) {
            const modal = document.getElementById('requestModal');
            const form = document.getElementById('chequeBookForm');
            const title = document.getElementById('modalTitle');
            const subTitle = document.getElementById('formSubTitle');
            const subject = document.getElementById('subjectLine');
            const submitBtn = document.getElementById('submitFormBtn');
            
            // Set current date in Form
            const today = new Date();
            const dd = String(today.getDate()).padStart(2, '0');
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const yyyy = today.getFullYear();
            document.getElementById('formDateStr').value = dd + ' / ' + mm + ' / ' + yyyy;
            
            if (action === 'renew') {
                form.action = "${pageContext.request.contextPath}/chequebook?action=renew";
                title.innerHTML = '<i class="bx bx-check-shield"></i> Cheque Book Renewal Request';
                subTitle.innerHTML = 'Cheque Book Renewal Request Form';
                subject.innerHTML = 'Request for Cheque Book Renewal / Replacement';
                submitBtn.innerHTML = 'Process Cheque Book Renewal';
            } else {
                form.action = "${pageContext.request.contextPath}/chequebook?action=apply";
                title.innerHTML = '<i class="bx bx-plus-circle"></i> Cheque Book Application Request';
                subTitle.innerHTML = 'Cheque Book Issuance Request Form';
                subject.innerHTML = 'Request for New Cheque Book Issuance';
                submitBtn.innerHTML = 'Process Cheque Book Order';
            }
            
            updateFeeDue();
            modal.style.display = 'flex';
        }

        function closeRequestModal() {
            document.getElementById('requestModal').style.display = 'none';
        }

        function updateSignature(name) {
            document.getElementById('formSignature').innerHTML = name ? name.toUpperCase() : '';
            const sig3D = document.getElementById('chequeSignatureVal');
            if (sig3D) {
                sig3D.innerHTML = name ? name.toUpperCase() : '';
            }
            const sigBack = document.getElementById('chequeSignatureBackVal');
            if (sigBack) {
                sigBack.innerHTML = name ? name.toUpperCase() : '';
            }
        }

        function updateFeeDue() {
            const leavesSelect = document.getElementById('leavesCountSelect');
            const leaves = parseInt(leavesSelect.value);
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
            
            document.getElementById('formFeeDisplay').innerHTML = '₹ ' + charges.toFixed(2);
            
            const amtDisplay = document.getElementById('chequeAmountDisplay');
            const rupeesDisplay = document.getElementById('chequeRupeesTextDisplay');
            if (amtDisplay) amtDisplay.innerHTML = charges.toFixed(2);
            if (rupeesDisplay) rupeesDisplay.innerHTML = words;
        }

        function syncChequeVisualizer() {
            const accSelect = document.getElementById('accountIdSelect');
            const accDisplay = document.getElementById('chequeAccountDisplayVal');
            if (accSelect && accDisplay && accSelect.options.length > 0) {
                const text = accSelect.options[accSelect.selectedIndex].text;
                const num = text.split(" - ")[0].trim();
                accDisplay.innerHTML = num;

                const micrDisplay = document.getElementById('chequeMicrVal');
                if (micrDisplay) {
                    const last6 = num.length >= 6 ? num.substring(num.length - 6) : "018696";
                    micrDisplay.innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;
                }
            }

            const nameInput = document.getElementById('custNameInput');
            const sigDisplay = document.getElementById('chequeSignatureVal');
            const sigBack = document.getElementById('chequeSignatureBackVal');
            if (nameInput) {
                const upperName = nameInput.value ? nameInput.value.toUpperCase() : '';
                if (sigDisplay) sigDisplay.innerHTML = upperName;
                if (sigBack) sigBack.innerHTML = upperName;
            }

            const squares = document.getElementById('chequeDateSquares');
            if (squares) {
                const today = new Date();
                const dd = String(today.getDate()).padStart(2, '0');
                const mm = String(today.getMonth() + 1).padStart(2, '0');
                const yyyy = String(today.getFullYear());
                const dateStr = dd + mm + yyyy;
                let dateHtml = "";
                for (let i = 0; i < dateStr.length; i++) {
                    dateHtml += `<span>${dateStr.charAt(i)}</span>`;
                }
                squares.innerHTML = dateHtml;
            }

            updateFeeDue();
        }

        document.addEventListener('DOMContentLoaded', () => {
            const accSelect = document.getElementById('accountIdSelect');
            const leavesSelect = document.getElementById('leavesCountSelect');
            const nameInput = document.getElementById('custNameInput');

            if (accSelect) accSelect.addEventListener('change', syncChequeVisualizer);
            if (leavesSelect) leavesSelect.addEventListener('change', syncChequeVisualizer);
            if (nameInput) nameInput.addEventListener('input', (e) => {
                updateSignature(e.target.value);
            });

            syncChequeVisualizer();
        });

        const book = document.getElementById('3dChequebook');
        const container = document.querySelector('.cheque-visualizer-container');
        const hint = document.getElementById('chequeHint');

        function updateBookTransform(rotX = 0, rotY = 0) {
            if (!book || !container) return;
            const containerWidth = container.clientWidth;
            if (book.classList.contains('open')) {
                const openScale = Math.min((containerWidth - 30) / 480, 0.8);
                book.style.transform = `rotateX(${25 + rotX}deg) rotateY(${-5 + rotY}deg) scale(${openScale})`;
            } else if (book.classList.contains('flipped-back')) {
                const closedScale = Math.min((containerWidth - 20) / 480, 0.9);
                book.style.transform = `rotateX(${195 + rotX}deg) rotateY(${10 + rotY}deg) scale(${closedScale})`;
            } else {
                const closedScale = Math.min((containerWidth - 20) / 480, 0.9);
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

            updateBookTransform(0, 0);
            window.addEventListener('resize', () => {
                updateBookTransform(0, 0);
            });
        }

        window.onclick = function(event) {
            const requestModal = document.getElementById('requestModal');
            const inspectModal = document.getElementById('inspectModal');
            if (event.target === requestModal) {
                closeRequestModal();
            }
            if (event.target === inspectModal) {
                closeInspectModal();
            }
        }
    </script>

    <!-- Modal: Premium 3D Cheque Inspector -->
    <div id="inspectModal" class="modal">
        <div class="modal-content" style="max-width: 680px;">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-show"></i> Cheque Leaf Inspector</h3>
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
                                        <div class="cheque-micr-band" id="inspectChequeMicrVal">
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

                <div style="text-align: center; margin-top: 15px;">
                    <button type="button" class="btn btn-secondary" onclick="closeInspectModal()" style="padding: 10px 25px; font-size: 0.9rem; font-weight: 600;">Close View</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripting for Inspector Operations -->
    <script>
        function openInspectModal(requestId, customerName, accountNumber, leavesCount, charges, requestedDateStr, status) {
            const modal = document.getElementById('inspectModal');
            
            // Set dynamic fields
            document.getElementById('inspectRequestId').innerHTML = '#' + requestId;
            document.getElementById('inspectCapacity').innerHTML = leavesCount + ' Leaves';
            document.getElementById('inspectCharges').innerHTML = '₹ ' + charges.toFixed(2);
            
            // Sync Cheque visualizer
            document.getElementById('inspectChequePayeeDisplay').innerHTML = 'Self or Bearer';
            
            let words = "One Hundred and Fifty Rupees Only";
            if (leavesCount === 25) {
                words = "One Hundred Rupees Only";
            } else if (leavesCount === 50) {
                words = "One Hundred and Fifty Rupees Only";
            } else if (leavesCount === 100) {
                words = "Two Hundred and Fifty Rupees Only";
            }
            
            document.getElementById('inspectChequeRupeesTextDisplay').innerHTML = words;
            document.getElementById('inspectChequeAmountDisplay').innerHTML = charges.toFixed(2);
            document.getElementById('inspectChequeAccountDisplayVal').innerHTML = accountNumber;
            document.getElementById('inspectChequeSignatureVal').innerHTML = customerName ? customerName.toUpperCase() : '';
            document.getElementById('inspectChequeSignatureBackVal').innerHTML = customerName ? customerName.toUpperCase() : '';
            document.getElementById('inspectpbCustName').innerHTML = customerName ? customerName.toUpperCase() : '';
            document.getElementById('inspectpbAccNum').innerHTML = accountNumber;
            
            // MICR Band parsing
            const last6 = accountNumber.length >= 6 ? accountNumber.substring(accountNumber.length - 6) : "018696";
            document.getElementById('inspectChequeMicrVal').innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;
            
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
            } else if (status === 'rejected') {
                stampOverlay.innerHTML = 'REJECTED';
                stampOverlay.className = 'cheque-processed-stamp rejected';
                stampOverlay.style.display = 'block';
            } else {
                stampOverlay.innerHTML = 'PENDING';
                stampOverlay.className = 'cheque-processed-stamp pending';
                stampOverlay.style.display = 'block';
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
            const inspectHint = document.getElementById('inspectChequeHint');
            if (inspectHint) {
                inspectHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
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

        function toggleBookOpen() {
            if (!book) return;
            book.classList.remove('flipped-back');
            book.classList.toggle('open');
            if (book.classList.contains('open')) {
                if (hint) hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
            } else {
                if (hint) hint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
                const leaf = document.getElementById('chequeLeafFlipWrapper');
                if (leaf) leaf.classList.remove('flipped');
                const page = document.getElementById('chequeInstructionsPage');
                if (page) page.classList.remove('turned');
            }
            updateBookTransform(0, 0);
        }

        function toggleBookFlip(event) {
            if (event) event.stopPropagation();
            if (!book) return;
            book.classList.remove('open');
            book.classList.toggle('flipped-back');
            if (book.classList.contains('flipped-back')) {
                if (hint) hint.innerHTML = `<i class="bx bx-refresh"></i> Back Cover View`;
            } else {
                if (hint) hint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
            }
            updateBookTransform(0, 0);
        }
        
        function toggleInstructionsPage(event) {
            if (event) event.stopPropagation();
            const page = document.getElementById('chequeInstructionsPage');
            if (page) {
                page.classList.toggle('turned');
                if (hint) {
                    if (page.classList.contains('turned')) {
                        hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Leaf to Flip`;
                    } else {
                        hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                    }
                }
            }
        }
        
        function toggleChequeLeafFlip(event) {
            if (event) event.stopPropagation();
            const leaf = document.getElementById('chequeLeafFlipWrapper');
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
        
        // Add 3D tilt interaction for inspector modal cheque
        document.addEventListener('DOMContentLoaded', () => {
            const inspectWrapper = document.getElementById('inspectChequebookWrapper');
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

            if (inspectContainer && inspectBook) {
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
    </script>
    
    <!-- Standard Core Scripts -->
    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
