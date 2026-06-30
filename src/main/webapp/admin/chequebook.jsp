<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Cheque Books</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
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

        .filter-select-group select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
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
            transform: scale(0.96) !important;
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
    </style>
</head>
<body>
    <!-- Preloader -->
    <div class="preloader">
        <div class="loader-content">
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
                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/image.png" alt="Admin Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
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

            <!-- Global Requests Logs -->
            <div class="glass-card">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin: 0;">
                        <i class="bx bx-task" style="color: var(--primary-500);"></i> Executive Cheque Book Request Ledger
                    </h3>
                    <button onclick="openApplyModal()" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                        <i class="bx bx-plus-circle"></i> Apply Cheque Book
                    </button>
                </div>

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
                        <tbody id="directoryTableBody">
                            <c:choose>
                                <c:when test="${not empty requests}">
                                     <c:forEach var="req" items="${requests}">
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

     <!-- Standard Scripts -->
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

          function openApplyModal() {
              document.getElementById('lookupAccountNumber').value = '';
              document.getElementById('lookupResultsContainer').style.display = 'none';
              document.getElementById('lookupResultsList').innerHTML = '';
              document.getElementById('applyChequeBookForm').style.display = 'none';
              document.getElementById('applyChequeBookModal').style.display = 'flex';
          }

          function closeApplyModal() {
              document.getElementById('applyChequeBookModal').style.display = 'none';
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
              document.getElementById('applyChequeBookForm').style.display = 'none';

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
              document.getElementById('applyChequeBookForm').style.display = 'block';
          }

          function updateApplyFeeAndNotice(leaves) {
              let feeVal = '₹ 150.00';
              if (leaves === '25') feeVal = '₹ 100.00';
              if (leaves === '100') feeVal = '₹ 250.00';
              document.getElementById('applyFeeValue').textContent = feeVal;
          }
       </script>

       <!-- Modal: Apply Cheque Book -->
       <div id="applyChequeBookModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 1050; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px); align-items: center; justify-content: center; padding: 20px;">
           <div class="modal-content" style="max-width: 720px; width: 100%; border-radius: var(--radius-lg); overflow: hidden; display: flex; flex-direction: column;">
               <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid rgba(99,102,241,0.1); background: rgba(99,102,241,0.02); width: 100%; box-sizing: border-box;">
                   <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin: 0; display: flex; align-items: center; gap: 8px;"><i class="bx bx-plus-circle" style="color: var(--primary-500);"></i> Apply Customer Cheque Book</h3>
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
               <form id="applyChequeBookForm" action="${pageContext.request.contextPath}/chequebook?action=apply" method="post" style="display: none; padding: 12px 20px; max-height: 70vh; overflow-y: auto; width: 100%; box-sizing: border-box; text-align: left;">
                   <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                   <input type="hidden" id="formAccountId" name="accountId" value="">
                   <input type="hidden" id="formAccountNumber" name="accountNumber" value="">
                   
                   <div class="apply-paper-form" style="background: #fff; border: 1.5px solid var(--gray-200); padding: 25px 20px; border-radius: var(--radius-sm); color: #1e293b; font-family: 'Times New Roman', Times, serif; font-size: 0.95rem; line-height: 1.6; margin-top: 20px; margin-bottom: 15px; box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm); position: relative; overflow: hidden;">
                       <!-- Watermark -->
                       <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 7.5rem; font-weight: 900; color: rgba(99, 102, 241, 0.03); pointer-events: none; user-select: none; font-family: 'Poppins', sans-serif; letter-spacing: 5px;">VGB</div>

                       <!-- Form Header -->
                       <div style="text-align: center; border-bottom: 2px double #475569; padding-bottom: 12px; margin-bottom: 20px; position: relative;">
                           <h2 style="font-size: 1.35rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: #0f172a; margin: 0; font-family: 'Poppins', sans-serif;">Vertex Galaxy Bank</h2>
                           <h3 style="font-size: 1rem; font-weight: 700; color: #475569; margin: 4px 0 0; text-transform: uppercase; font-family: 'Poppins', sans-serif; letter-spacing: 0.5px;">Cheque Book Issuance Request Form</h3>
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
                           <strong>Subject:</strong> <span style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request for New Multi-City Cheque Book Issuance</span>
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
                           <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">Cheque Book Specifications</h4>
                           <table style="width: 100%; border-collapse: collapse;">
                               <tr>
                                   <td style="width: 45%; padding: 5px 0;"><strong>Book Capacity (Leaves):</strong></td>
                                   <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                       <select name="leavesCount" required onchange="updateApplyFeeAndNotice(this.value)" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: 'Poppins', sans-serif; font-size: 0.9rem; outline: none; background: transparent; color: #0f172a; cursor: pointer;">
                                           <option value="25">25 Leaves Booklet (₹100)</option>
                                           <option value="50" selected>50 Leaves Booklet (₹150)</option>
                                           <option value="100">100 Leaves Booklet (₹250)</option>
                                       </select>
                                   </td>
                               </tr>
                           </table>
                       </div>

                       <!-- Declaration -->
                       <div style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                           <p style="margin: 0 0 10px;"><strong>Request Description:</strong> I hereby request the bank to issue a new multi-city Cheque Book linked to my account number mentioned above. I confirm my account contains sufficient funds to cover the applicable service charge.</p>
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
                        <button type="button" onclick="closeApplyModal()" class="btn btn-danger">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit Application</button>
                   </div>
               </form>
           </div>
       </div>
  </body>
 </html>
