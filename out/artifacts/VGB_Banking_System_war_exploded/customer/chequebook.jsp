<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Cheque Book Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
    <style>
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(99, 102, 241, 0.15);
            padding: 30px 20px;
            position: fixed;
            top: 80px;
            bottom: 0;
            left: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 14px 20px;
            color: var(--gray-600);
            font-weight: 500;
            border-radius: var(--radius-md);
            margin-bottom: 8px;
            transition: all var(--transition-normal);
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);
        }
        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: var(--gray-50);
        }
        @media (max-width: 991px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; padding: 120px 20px 20px; }
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 25px;
            box-shadow: var(--shadow-md);
            margin-bottom: 30px;
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

        /* ===== 3D CHEQUE VISUALIZER ===== */
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
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.03) 0%, rgba(6, 182, 212, 0.03) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 30px 20px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.02);
            height: 100%;
            perspective: 1000px;
        }

        .vgb-cheque-3d {
            width: 100%;
            max-width: 620px;
            aspect-ratio: 2.38 / 1;
            background-color: #e0f2fe;
            background-image: 
                radial-gradient(circle at 10% 90%, rgba(99, 102, 241, 0.05) 0%, transparent 60%),
                radial-gradient(circle at 90% 10%, rgba(6, 182, 212, 0.04) 0%, transparent 50%),
                linear-gradient(to right, #bae6fd, #e0f2fe);
            border: 1px solid #93c5fd;
            border-radius: 8px;
            padding: 16px 20px;
            color: #334155;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 0.8rem;
            line-height: 1.4;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.1), 0 5px 15px rgba(0, 0, 0, 0.05);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1), box-shadow 0.3s ease;
            transform-style: preserve-3d;
            cursor: pointer;
            user-select: none;
        }

        .vgb-cheque-3d:hover {
            transform: translateY(-5px) rotateX(4deg) rotateY(-4deg);
            box-shadow: 0 22px 40px rgba(99, 102, 241, 0.18), 0 8px 24px rgba(0,0,0,0.06);
        }

        /* Diagonal shiny reflection overlay */
        .vgb-cheque-3d::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.12) 48%, rgba(255, 255, 255, 0.25) 50%, rgba(255, 255, 255, 0.12) 52%, transparent 70%);
            transform: rotate(-45deg);
            transition: all 0.8s ease;
            pointer-events: none;
            opacity: 0.5;
        }
        .vgb-cheque-3d:hover::after {
            left: 100%;
        }

        .cheque-hologram {
            position: absolute;
            left: 12px;
            top: 0;
            bottom: 0;
            width: 14px;
            background: linear-gradient(90deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
            border-left: 1px solid rgba(255,255,255,0.2);
            border-right: 1px solid rgba(255,255,255,0.2);
            opacity: 0.85;
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
            margin-left: 14px; /* offset for hologram */
        }

        .cheque-bank-info {
            display: flex;
            flex-direction: column;
        }

        .cheque-bank-name {
            font-family: 'Poppins', sans-serif;
            font-weight: 800;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
            color: #1e3a8a;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .cheque-branch-details {
            font-size: 0.55rem;
            color: #475569;
            line-height: 1.3;
            margin-top: 2px;
        }

        .cheque-date-box {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .date-squares {
            display: flex;
            gap: 1.5px;
            margin-bottom: 2px;
        }

        .date-squares span {
            width: 14px;
            height: 16px;
            border: 1px solid #1e3a8a;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.58rem;
            font-weight: 600;
            color: #1e3a8a;
            border-radius: 1px;
        }

        .date-validity {
            font-size: 0.45rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 0.2px;
        }

        .cheque-row {
            display: flex;
            align-items: flex-end;
            margin: 6px 0;
            z-index: 3;
            margin-left: 14px;
        }

        .cheque-label {
            font-weight: bold;
            font-size: 0.72rem;
            color: #1e3a8a;
            white-space: nowrap;
            display: flex;
            align-items: baseline;
            gap: 3px;
        }

        .hindi-text {
            font-size: 0.65rem;
            font-weight: normal;
            color: #64748b;
        }

        .cheque-line-fill {
            flex: 1;
            border-bottom: 1.5px dotted #64748b;
            margin: 0 8px;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.95rem;
            font-style: italic;
            font-weight: 700;
            color: #0f172a;
            padding-bottom: 1px;
            padding-left: 5px;
            letter-spacing: 0.5px;
        }

        .bearer-text {
            font-size: 0.62rem !important;
        }

        .cheque-amount-box {
            width: 125px;
            height: 28px;
            border: 1.5px solid #1e3a8a;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 0 8px;
            position: relative;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
        }

        .rupee-symbol {
            font-size: 0.95rem;
            font-weight: 800;
            color: #1e3a8a;
            border-right: 1.5px solid #1e3a8a;
            padding-right: 6px;
            height: 100%;
            display: flex;
            align-items: center;
        }

        .amount-val {
            flex: 1;
            font-family: monospace;
            font-size: 0.95rem;
            font-weight: 700;
            text-align: right;
            letter-spacing: 0.5px;
            color: #0f172a;
        }

        .cheque-details-row {
            display: grid;
            grid-template-columns: 1.4fr 0.6fr 1.2fr 1.2fr;
            gap: 12px;
            align-items: flex-end;
            margin-top: 8px;
            z-index: 3;
            margin-left: 14px;
        }
        @media (max-width: 576px) {
            .cheque-details-row {
                grid-template-columns: 1.5fr 1fr;
                gap: 8px;
            }
            .cheque-payable-text {
                display: none;
            }
        }

        .cheque-acc-box {
            border: 1.5px solid #1e3a8a;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 4px 8px;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);
        }

        .acc-label {
            font-size: 0.5rem;
            font-weight: bold;
            color: #1e3a8a;
            border-right: 1px solid #cbd5e1;
            padding-right: 6px;
            margin-right: 6px;
            line-height: 1.2;
            white-space: nowrap;
        }

        .acc-val {
            font-family: monospace;
            font-size: 0.88rem;
            font-weight: 700;
            letter-spacing: 1px;
            color: #0f172a;
        }

        .cheque-branch-codes {
            font-size: 0.5rem;
            color: #475569;
            font-family: monospace;
            line-height: 1.2;
            font-weight: 600;
        }

        .cheque-payable-text {
            font-size: 0.45rem;
            color: #64748b;
            line-height: 1.2;
            border-left: 1px solid #cbd5e1;
            padding-left: 8px;
        }

        .cheque-sign-area {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            text-align: right;
            padding-bottom: 2px;
        }

        .cheque-sign-name {
            font-family: 'Brush Script MT', cursive, sans-serif;
            font-size: 1.2rem;
            font-style: italic;
            color: #2563eb;
            margin-bottom: 2px;
            font-weight: 500;
            letter-spacing: 0.5px;
            max-width: 140px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .cheque-sign-label {
            font-size: 0.48rem;
            color: #475569;
            font-weight: bold;
        }

        .cheque-micr-band {
            text-align: center;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 3px;
            color: #0f172a;
            margin-top: 15px;
            margin-bottom: 2px;
            border-top: 1px dashed rgba(99, 102, 241, 0.1);
            padding-top: 8px;
            z-index: 3;
            margin-left: 14px;
        }

        /* Watermark stamp for processed cheques */
        .cheque-processed-stamp {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-15deg);
            font-size: 3rem;
            font-weight: 900;
            padding: 10px 20px;
            border: 5px solid;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 4px;
            z-index: 10;
            pointer-events: none;
            display: none;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
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
        <a href="#" class="logo">
            <span class="logo-text">V</span>
            <span class="logo-text">G</span>
            <span class="logo-text">B</span>
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-user-circle"></i> Customer Space</span>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
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
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/customer/notification.jsp"><i class="bx bx-bell"></i> Alerts</a>
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

            <!-- Split Dashboard: Service Features -->
            <div class="cheque-top-layout" style="display: block;">
                <!-- Quick Features Summary -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; width: 100%;" class="mobile-grid-1">
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
            </div>

            <!-- List of Previous Requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-list-ul" style="color: var(--primary-500);"></i> Request Status & Log Tracker
                </h3>
                <div style="overflow-x: auto;">
                    <table class="table" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); padding-bottom: 10px; color: var(--gray-500); font-weight: 600; font-size: 0.85rem;">
                                <th style="padding: 12px;">Request ID</th>
                                <th style="padding: 12px;">Linked Account</th>
                                <th style="padding: 12px;">Book Capacity</th>
                                <th style="padding: 12px;">Charges Paid</th>
                                <th style="padding: 12px;">Submission Date</th>
                                <th style="padding: 12px;">Current Status</th>
                                <th style="padding: 12px; text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="req" items="${requests}">
                                        <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; vertical-align: middle;">
                                            <td style="padding: 15px; font-weight: 700; color: var(--gray-700);">#${req.requestId}</td>
                                            <td style="padding: 15px; font-family: monospace; font-weight: 600;">${req.accountNumber}</td>
                                            <td style="padding: 15px;"><strong>${req.leavesCount} Leaves</strong></td>
                                            <td style="padding: 15px;">
                                                <span style="font-weight: 600; color: var(--gray-700);">₹<fmt:formatNumber value="${req.charges}" minFractionDigits="2"/></span>
                                                <c:choose>
                                                    <c:when test="${req.chargesPaid}">
                                                        <span style="background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;"><i class="bx bx-check"></i> Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.12); color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;"><i class="bx bx-x"></i> Refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; color: var(--gray-500);">
                                                <fmt:formatDate value="${req.requestedAt}" pattern="dd-MMM-yyyy hh:mm a" />
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${req.status eq 'approved' or req.status eq 'delivered'}">
                                                        <span style="background: rgba(16, 185, 129, 0.2); color: #10b981; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Approved</span>
                                                    </c:when>
                                                    <c:when test="${req.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.2); color: #fbbf24; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.2); color: #ef4444; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Rejected</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: right;">
                                                <div style="display: flex; gap: 8px; justify-content: flex-end; align-items: center;">
                                                    <button type="button" class="btn" style="display:none;" 
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
                                                    <c:choose>
                                                        <c:when test="${req.status eq 'approved'}">
                                                            <button onclick="openRequestModal('renew')" class="btn" style="background: var(--gradient-primary); color: white; border: none; padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600;">Renew</button>
                                                        </c:when>
                                                        <c:when test="${req.status eq 'rejected'}">
                                                            <span style="font-size: 0.75rem; color: var(--gray-400); font-style: italic;">Refunded</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 0.75rem; color: var(--gray-400); font-style: italic;">Pending</span>
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
            if (nameInput && sigDisplay) {
                sigDisplay.innerHTML = nameInput.value ? nameInput.value.toUpperCase() : '';
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

        window.onclick = function(event) {
            const requestModal = document.getElementById('requestModal');
            if (event.target === requestModal) {
                closeRequestModal();
            }
        }
    </script>


    
    <!-- Standard Core Scripts -->
    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
