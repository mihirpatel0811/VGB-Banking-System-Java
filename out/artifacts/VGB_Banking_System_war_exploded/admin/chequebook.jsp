<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Cheque Books</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
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
        
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-sm);
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
        .badge-pending {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-approved {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-rejected {
            background: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        /* ===== 3D CHEQUE VISUALIZER IN MODAL ===== */
        .cheque-visualizer-container {
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.03) 0%, rgba(6, 182, 212, 0.03) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 30px 20px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.02);
            margin-bottom: 25px;
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
            margin-left: 14px;
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
            background: rgba(255,255,255,0.9);
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
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
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
            <a href="${pageContext.request.contextPath}/chequebook?action=list" class="active"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/admin/notification.jsp">
                <i class="bx bx-bell"></i> Audit Logs
                <span class="notif-badge" id="sidebar-notif-count" style="display: none; background: #ef4444; color: white; padding: 2px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; margin-left: auto;">0</span>
            </a>
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
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-book-open"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Total Requests</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${requests.size()}</h3>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #fbbf24;">
                        <i class="bx bx-time"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Pending Review</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${pendingCount}</h3>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                        <i class="bx bx-check-double"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-500); font-weight: 500; text-transform: uppercase;">Approved Books</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-top: 2px;">${approvedCount}</h3>
                    </div>
                </div>
                <div class="stat-card">
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

                        <div class="vgb-cheque-3d" id="demoChequeLeaf3D">
                            <!-- Hologram ribbon -->
                            <div class="cheque-hologram"></div>
                            
                            <!-- Header -->
                            <div class="cheque-header">
                                <div class="cheque-bank-info">
                                    <span class="cheque-bank-name"><i class="bx bx-shield-quarter"></i> VERTEX GALAXY BANK</span>
                                    <span class="cheque-branch-details">BHAKTINAGAR CIRCLE, BHAKTINAGAR CO-OP HOUSING SOC LTD,<br>80 FT ROAD CORNER, RAJKOT-360002 GUJARAT<br>RTGS / NEFT IFSC : VGB0000171</span>
                                </div>
                                <div class="cheque-date-box">
                                    <div class="date-squares" id="demoChequeDateSquares">
                                        <span>3</span><span>1</span><span>0</span><span>5</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                    </div>
                                    <span class="date-validity">Valid for 3 months only</span>
                                </div>
                            </div>

                            <!-- Pay row -->
                            <div class="cheque-row" style="margin-top: 12px;">
                                <span class="cheque-label">Pay <span class="hindi-text">अदा करें</span></span>
                                <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.85rem;" id="demoChequePayeeDisplay">Self or Bearer</span>
                                <span class="cheque-label bearer-text">Or Bearer <span class="hindi-text">या धारक को</span></span>
                            </div>

                            <!-- Rupees row -->
                            <div class="cheque-row">
                                <span class="cheque-label">Rupees <span class="hindi-text">रुपये</span></span>
                                <span class="cheque-line-fill" id="demoChequeRupeesTextDisplay">One Hundred and Fifty Rupees Only</span>
                                <div class="cheque-amount-box">
                                    <span class="rupee-symbol">₹</span>
                                    <span class="amount-val" id="demoChequeAmountDisplay">150.00</span>
                                </div>
                            </div>

                            <!-- Account details row -->
                            <div class="cheque-details-row">
                                <div class="cheque-acc-box">
                                    <span class="acc-label">A/c No.<br><span class="hindi-text">खाता क्र.</span></span>
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
                                    <span class="cheque-sign-label">Please sign above / कृपया यहाँ हस्ताक्षर करें</span>
                                </div>
                            </div>

                            <!-- Bottom MICR band -->
                            <div class="cheque-micr-band" id="demoChequeMicrVal">
                                ⑈000076⑈ 360240005⑆ 255263⑈ 31
                            </div>
                        </div>
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
                <div style="overflow-x: auto;">
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
                                            <td style="padding: 15px; font-weight: 700; color: var(--gray-700);">#${req.requestId}</td>
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-800);">${req.customerName}</td>
                                            <td style="padding: 15px; font-family: monospace; font-weight: 600;">${req.accountNumber}</td>
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
        <div class="modal-content" style="max-width: 680px;">
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
                <div class="cheque-visualizer-container">
                    <div class="vgb-cheque-3d" id="inspectChequeLeaf3D">
                        <!-- Hologram ribbon -->
                        <div class="cheque-hologram"></div>
                        
                        <!-- Header -->
                        <div class="cheque-header">
                            <div class="cheque-bank-info">
                                <span class="cheque-bank-name"><i class="bx bx-shield-quarter"></i> VERTEX GALAXY BANK</span>
                                <span class="cheque-branch-details">BHAKTINAGAR CIRCLE, BHAKTINAGAR CO-OP HOUSING SOC LTD,<br>80 FT ROAD CORNER, RAJKOT-360002 GUJARAT<br>RTGS / NEFT IFSC : VGB0000171</span>
                            </div>
                            <div class="cheque-date-box">
                                <div class="date-squares" id="inspectChequeDateSquares">
                                    <!-- Populated by JS -->
                                </div>
                                <span class="date-validity">Valid for 3 months only</span>
                            </div>
                        </div>

                        <!-- Pay row -->
                        <div class="cheque-row" style="margin-top: 12px;">
                            <span class="cheque-label">Pay <span class="hindi-text">अदा करें</span></span>
                            <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.85rem;" id="inspectChequePayeeDisplay">Self or Bearer</span>
                            <span class="cheque-label bearer-text">Or Bearer <span class="hindi-text">या धारक को</span></span>
                        </div>

                        <!-- Rupees row -->
                        <div class="cheque-row">
                            <span class="cheque-label">Rupees <span class="hindi-text">रुपये</span></span>
                            <span class="cheque-line-fill" id="inspectChequeRupeesTextDisplay">--</span>
                            <div class="cheque-amount-box">
                                <span class="rupee-symbol">₹</span>
                                <span class="amount-val" id="inspectChequeAmountDisplay">--</span>
                            </div>
                        </div>

                        <!-- Account details row -->
                        <div class="cheque-details-row">
                            <div class="cheque-acc-box">
                                <span class="acc-label">A/c No.<br><span class="hindi-text">खाता क्र.</span></span>
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
                                <span class="cheque-sign-label">Please sign above / कृपया यहाँ हस्ताक्षर करें</span>
                            </div>
                        </div>

                        <!-- Bottom MICR band -->
                        <div class="cheque-micr-band" id="inspectChequeMicrVal">
                            <!-- Populated by JS -->
                        </div>

                        <!-- Diagonal Stamp overlay -->
                        <div class="cheque-processed-stamp" id="stampOverlay">APPROVED</div>
                    </div>
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
        
        // Add outside click close listener and 3D tilt interaction
        document.addEventListener('DOMContentLoaded', () => {
            const cheque = document.getElementById('inspectChequeLeaf3D');
            if (cheque) {
                const container = cheque.parentElement;
                container.addEventListener('mousemove', (e) => {
                    const rect = cheque.getBoundingClientRect();
                    const x = e.clientX - rect.left - rect.width / 2;
                    const y = e.clientY - rect.top - rect.height / 2;
                    const rX = -(y / rect.height) * 15;
                    const rY = (x / rect.width) * 15;
                    
                    requestAnimationFrame(() => {
                        cheque.style.transform = `translateY(-5px) rotateX(${rX}deg) rotateY(${rY}deg) scale(1.025)`;
                    });
                });
                
                container.addEventListener('mouseleave', () => {
                    requestAnimationFrame(() => {
                        cheque.style.transform = 'translateY(0) rotateX(0) rotateY(0) scale(1)';
                    });
                });
            }

            const demoCheque = document.getElementById('demoChequeLeaf3D');
            if (demoCheque) {
                const container = demoCheque.parentElement;
                container.addEventListener('mousemove', (e) => {
                    const rect = demoCheque.getBoundingClientRect();
                    const x = e.clientX - rect.left - rect.width / 2;
                    const y = e.clientY - rect.top - rect.height / 2;
                    const rX = -(y / rect.height) * 15;
                    const rY = (x / rect.width) * 15;
                    
                    requestAnimationFrame(() => {
                        demoCheque.style.transform = `translateY(-5px) rotateX(${rX}deg) rotateY(${rY}deg) scale(1.025)`;
                    });
                });
                
                container.addEventListener('mouseleave', () => {
                    requestAnimationFrame(() => {
                        demoCheque.style.transform = 'translateY(0) rotateX(0) rotateY(0) scale(1)';
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

            const last6 = accNum.length >= 6 ? accNum.substring(accNum.length - 6) : "255263";
            document.getElementById('demoChequeMicrVal').innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;

            // 3. Theme application
            const cheque = document.getElementById('demoChequeLeaf3D');
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
            }
        }

        window.onclick = function(event) {
            const inspectModal = document.getElementById('inspectModal');
            if (event.target === inspectModal) {
                closeInspectModal();
            }
        }
    </script>
</body>
</html>
