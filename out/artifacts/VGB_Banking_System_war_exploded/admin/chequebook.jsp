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

        // Interactive Cheque visualizers removed.
        document.addEventListener('DOMContentLoaded', () => {
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
        });


    </script>
</body>
</html>
