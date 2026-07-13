<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Vertex Galaxy Bank administrative cash counter desk dashboard. Teller assisted customer deposit, withdrawal, fund transfer, loan payment, and credit card dues management.">
    <title>VGB | Cash Counter Desk</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(99, 102, 241, 0.08);
            --card-glow: rgba(99, 102, 241, 0.04);
            --panel-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
            --primary-rgb: 99, 102, 241;
            
            /* Dynamic theme variable, overridden in JS */
            --tab-accent: var(--primary-500);
            --tab-accent-glow: rgba(99, 102, 241, 0.15);
        }

        body {
            background-color: #f6f8fc !important;
            color: var(--gray-700) !important;
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
        }
        
        body.dark-mode {
            --glass-bg: rgba(30, 41, 59, 0.75);
            --glass-border: rgba(255, 255, 255, 0.08);
            --card-glow: rgba(99, 102, 241, 0.15);
            --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            background-color: #0f172a !important;
            color: var(--gray-200) !important;
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
        }

        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.45) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
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
            border: 1px solid transparent;
            text-decoration: none;
        }
        body.dark-mode .sidebar-menu a {
            color: var(--gray-400) !important;
        }
        .sidebar-menu a:hover {
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500) !important;
        }
        .sidebar-menu a.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
        }

        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            position: relative;
            z-index: 10;
        }

        .glass-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.6) !important;
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        body.dark-mode .glass-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.02);
        }

        /* --- DUAL COLUMN DESK LAYOUT --- */
        .desk-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
            align-items: start;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .desk-grid.has-selection {
            grid-template-columns: 380px 1fr;
        }
        @media (max-width: 991px) {
            .sidebar { left: -280px !important; }
            .main-content { margin-left: 0 !important; padding: 120px 20px 40px !important; }
            .footer { margin-left: 0 !important; }
            .desk-grid, .desk-grid.has-selection { grid-template-columns: 1fr !important; }
        }

        /* --- TABS --- */
        .tab-navigation {
            display: flex;
            gap: 10px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.08);
            padding-bottom: 12px;
            margin-bottom: 30px;
            overflow-x: auto;
        }
        .tab-btn {
            background: none;
            border: none;
            padding: 10px 20px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--gray-500);
            cursor: pointer;
            border-radius: var(--radius-md);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        body.dark-mode .tab-btn {
            color: var(--gray-400);
        }
        
        /* Tab specific active colors using CSS variables set on container */
        .tab-btn.active {
            background: var(--tab-accent-glow) !important;
            color: var(--tab-accent) !important;
        }

        .tab-content-pane {
            display: none;
            animation: fadeIn 0.4s ease;
        }
        .tab-content-pane.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Forms & Inputs */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-600);
            margin-bottom: 8px;
        }
        body.dark-mode .form-label {
            color: var(--gray-300);
        }
        
        .form-control-container {
            position: relative;
        }
        .form-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2rem;
            color: var(--gray-400);
            transition: color 0.3s;
            z-index: 5;
        }
        .form-control, .form-select {
            width: 100%;
            padding: 12px 16px;
            padding-left: 45px; /* with icons */
            font-size: 0.9rem;
            border-radius: var(--radius-md);
            border: 1px solid rgba(99, 102, 241, 0.15);
            background: rgba(255, 255, 255, 0.8);
            color: var(--gray-800);
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        body.dark-mode .form-control, body.dark-mode .form-select {
            background: rgba(15, 23, 42, 0.6);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--gray-100);
        }
        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--tab-accent);
            box-shadow: 0 0 0 3px var(--tab-accent-glow);
        }
        .form-control:focus + .form-icon {
            color: var(--tab-accent);
        }

        /* Buttons & Actions */
        .btn-submit {
            background: var(--tab-accent);
            color: white;
            border: none;
            padding: 14px 28px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 14px var(--tab-accent-glow);
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px var(--tab-accent-glow);
            filter: brightness(1.08);
        }

        /* Preset Chips */
        .amount-presets {
            display: flex;
            gap: 8px;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .preset-chip {
            background: var(--tab-accent-glow);
            border: 1px solid transparent;
            color: var(--tab-accent);
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .preset-chip:hover {
            background: var(--tab-accent);
            color: white;
            transform: translateY(-1px);
        }

        /* Segmented Switches */
        .segmented-control {
            display: flex;
            background: rgba(99, 102, 241, 0.05);
            padding: 4px;
            border-radius: var(--radius-md);
            border: 1px solid rgba(99, 102, 241, 0.08);
            margin-bottom: 20px;
        }
        body.dark-mode .segmented-control {
            background: rgba(15, 23, 42, 0.4);
            border-color: rgba(255, 255, 255, 0.04);
        }
        .segmented-option {
            flex: 1;
            text-align: center;
            padding: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-600);
            cursor: pointer;
            border-radius: var(--radius-sm);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            border: none;
            background: transparent;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        body.dark-mode .segmented-option {
            color: var(--gray-400);
        }
        .segmented-option.active {
            background: white;
            color: var(--tab-accent);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04);
        }
        body.dark-mode .segmented-option.active {
            background: var(--gray-800);
            color: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        /* Profile & Summary */
        .profile-summary-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }
        .profile-summary-avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            border: 3px solid var(--tab-accent);
            object-fit: cover;
            box-shadow: 0 4px 14px var(--tab-accent-glow);
            transition: all 0.3s;
        }
        .profile-summary-avatar:hover {
            transform: scale(1.05);
        }

        .badge-status {
            display: inline-block;
            padding: 4px 10px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: var(--radius-sm);
            text-transform: capitalize;
        }
        .badge-status-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--accent-emerald);
        }
        .badge-status-suspended {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4444;
        }

        /* Collapsible Asset Tiles */
        .asset-list {
            margin-top: 25px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .asset-tile {
            background: rgba(99, 102, 241, 0.02);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 15px;
            transition: all 0.3s;
        }
        .asset-tile:hover {
            background: rgba(99, 102, 241, 0.04);
            border-color: rgba(99, 102, 241, 0.15);
        }
        .asset-tile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        .asset-tile-val {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        body.dark-mode .asset-tile-val {
            color: var(--gray-100);
        }

        /* Copy Button */
        .btn-copy {
            background: rgba(99, 102, 241, 0.06);
            border: none;
            color: var(--primary-500);
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.85rem;
            margin-left: 6px;
        }
        .btn-copy:hover {
            background: var(--primary-500);
            color: white;
        }

        /* Search Autocomplete Suggestion Panel */
        #searchResultsPanel {
            display: none;
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            margin-top: 10px;
            background: white;
            max-height: 280px;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            z-index: 1000;
            position: absolute;
            width: 100%;
            box-sizing: border-box;
        }
        body.dark-mode #searchResultsPanel {
            background: #1e293b;
            border-color: rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 30px rgba(0,0,0,0.4);
        }

        /* Welcome page elements */
        .welcome-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-pill {
            background: rgba(99, 102, 241, 0.03);
            border: 1px solid var(--glass-border);
            padding: 18px;
            border-radius: var(--radius-md);
            display: flex;
            flex-direction: column;
            gap: 5px;
            transition: all 0.3s;
        }
        .stat-pill:hover {
            transform: translateY(-2px);
            border-color: rgba(99, 102, 241, 0.2);
        }
        .operation-rules {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.02) 0%, rgba(236, 72, 153, 0.02) 100%);
            border: 1px dashed rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            padding: 20px;
            margin-top: 25px;
        }
        .operation-rules li {
            font-size: 0.85rem;
            margin-bottom: 8px;
            color: var(--gray-600);
        }
        body.dark-mode .operation-rules li {
            color: var(--gray-400);
        }

        /* TOAST NOTIFICATIONS */
        .toast-container {
            position: fixed;
            top: 100px;
            right: 40px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .toast-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-left: 5px solid #10b981;
            padding: 16px 22px;
            border-radius: var(--radius-md);
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 15px;
            min-width: 320px;
            transform: translateX(120%);
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        body.dark-mode .toast-card {
            background: rgba(30, 41, 59, 0.95);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .toast-card.show {
            transform: translateX(0);
        }
        .toast-card.error {
            border-left-color: #ef4444;
        }
        .toast-icon {
            font-size: 1.6rem;
        }
        .toast-card.error .toast-icon {
            color: #ef4444;
        }
        .toast-card:not(.error) .toast-icon {
            color: #10b981;
        }

        .footer {
            margin-left: 280px;
            background: var(--white) !important;
            border-top: 1px solid var(--glass-border) !important;
            padding: 24px 0;
            transition: all 0.3s ease;
        }
        body.dark-mode .footer {
            background: rgba(15, 23, 42, 0.8) !important;
        }
    </style>
</head>
<body class="bank-home-page">
    <div class="cursor-glow"></div>
    <div class="toast-container" id="toastContainer"></div>

    <!-- Header -->
    <header class="header scrolled">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" style="background: none; border: none; font-size: 1.8rem; cursor: pointer; color: var(--gray-700);">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Admin Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500);">
                <script>
                    (function() {
                        const avatar = localStorage.getItem('admin_avatar');
                        if (avatar) document.getElementById('adminHeaderAvatar').src = avatar;
                    })();
                </script>
                <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                    <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">Root Administrator</span>
                    <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Admin Desk
                    </span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout" style="text-decoration: none;">
                <i class="bx bx-log-out"></i>
                <span>Logout</span>
            </a>
        </div>
    </header>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=adminLogs"><i class="bx bx-receipt"></i> Repayment Logs</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/cash-counter" class="active"><i class="bx bx-wallet"></i> Cash Counter</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">TELLER DESK ACTIVE</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            
            <div style="margin-bottom: 40px;">
                <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900);">Cash Counter Desk</h1>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Search customer profiles to execute instant, teller-assisted deposits, withdrawals, fund transfers, and credit dues/loan repayments.</p>
            </div>

            <!-- SEARCH COMPONENT -->
            <div class="glass-card" style="position: relative; z-index: 100;">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px;">
                    <i class="bx bx-search-alt" style="color: var(--primary-500); margin-right: 5px;"></i> Search Account or Profile
                </h3>
                <div style="position: relative;">
                    <input type="text" id="counterSearchInput" class="form-control" placeholder="Search by Account Number, Name, Phone Number, Email, PAN or Aadhaar..." style="padding-left: 45px;">
                    <i class="bx bx-search" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); font-size: 1.2rem; color: var(--gray-400);"></i>
                </div>

                <!-- Search Results Auto-Suggest Panel -->
                <div id="searchResultsPanel">
                    <!-- Appended dynamically -->
                </div>
            </div>

            <div class="desk-grid">
                <!-- LEFT COLUMN: CUSTOMER SUMMARY PANEL -->
                <div id="customerSummaryCard" class="glass-card animate-slide" style="display: none;">
                    <div class="profile-summary-header">
                        <img id="summaryAvatar" src="" class="profile-summary-avatar" alt="Avatar">
                        <div>
                            <h3 id="summaryName" style="font-size: 1.3rem; font-weight: 700; color: var(--gray-800); margin-bottom: 4px;"></h3>
                            <span class="badge-status badge-status-active" id="summaryStatus">Active</span>
                        </div>
                    </div>

                    <div style="border-top: 1px solid rgba(99,102,241,0.08); padding-top: 20px;">
                        <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Active Account Number</span>
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 4px;">
                            <strong id="summaryAccNo" style="font-size: 1.1rem; color: var(--gray-800); font-family: monospace;"></strong>
                            <button type="button" class="btn-copy" id="btnCopyAcc" title="Copy Account Number"><i class="bx bx-copy"></i></button>
                        </div>
                    </div>

                    <div class="asset-list">
                        <!-- Balance Card -->
                        <div class="asset-tile" style="background: linear-gradient(135deg, rgba(99,102,241,0.03) 0%, rgba(236,72,153,0.03) 100%); border-color: rgba(99,102,241,0.1);">
                            <div class="asset-tile-header">
                                <span>Account Balance</span>
                                <span id="summaryAccType" style="text-transform: capitalize; color: var(--primary-500);"></span>
                            </div>
                            <div class="asset-tile-val" id="summaryAccBalance" style="color: var(--primary-500); font-size: 1.4rem;">₹ 0.00</div>
                        </div>

                        <!-- Loans Summary -->
                        <div class="asset-tile" id="summaryLoansTile" style="display: none;">
                            <div class="asset-tile-header">Active Loan Recourses</div>
                            <div id="summaryLoansList" style="display: flex; flex-direction: column; gap: 8px; margin-top: 8px;">
                                <!-- Dynamic items -->
                            </div>
                        </div>

                        <!-- Credit Cards Summary -->
                        <div class="asset-tile" id="summaryCardsTile" style="display: none;">
                            <div class="asset-tile-header">Active Credit Cards</div>
                            <div id="summaryCardsList" style="display: flex; flex-direction: column; gap: 8px; margin-top: 8px;">
                                <!-- Dynamic items -->
                            </div>
                        </div>

                        <div style="margin-top: 15px; font-size: 0.75rem; color: var(--gray-400);" id="customerDetailContact"></div>
                    </div>
                </div>

                <!-- RIGHT COLUMN: WELCOME OR TRANSACTION WORKSPACE -->
                <div class="desk-main-workspace">
                    
                    <!-- WELCOME DESK PANEL (DEFAULT VIEW) -->
                    <div id="welcomeDeskCard" class="glass-card animate-slide">
                        <div style="text-align: center; padding: 30px 10px;">
                            <i class="bx bx-wallet" style="font-size: 4rem; color: var(--primary-500); background: rgba(99, 102, 241, 0.06); padding: 20px; border-radius: 50%; margin-bottom: 20px; display: inline-block;"></i>
                            <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--gray-800);">Administrative Teller Desk</h2>
                            <p style="color: var(--gray-400); max-width: 500px; margin: 8px auto 35px; font-size: 0.9rem;">Ready for assisted customer transactions. Please search a customer profile by Account number, Name, or contact details to initialize.</p>
                        </div>

                        <!-- Modern Stats Grid -->
                        <div class="welcome-grid">
                            <div class="stat-pill">
                                <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Vault Status</span>
                                <strong style="font-size: 1.25rem; color: var(--gray-800); font-weight: 800;">₹ 8,450,000.00</strong>
                                <div style="width: 100%; height: 6px; background: rgba(99,102,241,0.08); border-radius: 3px; margin-top: 8px; overflow: hidden;">
                                    <div style="width: 70%; height: 100%; background: var(--gradient-primary); border-radius: 3px;"></div>
                                </div>
                            </div>
                            <div class="stat-pill">
                                <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Drawer Cash Limit</span>
                                <strong style="font-size: 1.25rem; color: var(--accent-emerald); font-weight: 800;">₹ 150,000.00</strong>
                                <div style="font-size: 0.7rem; color: var(--gray-400); margin-top: 5px;"><i class="bx bx-check-circle" style="color: var(--accent-emerald);"></i> Within safe limits</div>
                            </div>
                            <div class="stat-pill">
                                <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">System Connection</span>
                                <strong style="font-size: 1.25rem; color: var(--accent-cyan); font-weight: 800;">Secure TLS 1.3</strong>
                                <div style="font-size: 0.7rem; color: var(--gray-400); margin-top: 5px;"><i class="bx bxs-shield-alt-2" style="color: var(--accent-cyan);"></i> Session Active</div>
                            </div>
                        </div>

                        <div class="operation-rules">
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-shield-quarter" style="color: var(--primary-500); font-size: 1.2rem;"></i> Administrative Security Guidelines
                            </h4>
                            <ul style="padding-left: 20px; margin: 0; line-height: 1.6;">
                                <li>Always request customer signature and check government-issued ID proof (Aadhaar or PAN) for physical withdrawals exceeding ₹50,000.</li>
                                <li>Verify cheque leaf specifications, date validity, and drawer signatures before executing cheque deposits or transfers.</li>
                                <li>For internal VGB transfers, confirm target holder details on screen with the depositor before completing.</li>
                                <li>Keep teller drawer closed during inactive periods to maintain terminal security.</li>
                            </ul>
                        </div>
                    </div>

                    <!-- TRANSACTION TABS CONTAINER (REVEALED ON SELECTION) -->
                    <div id="transactionTabsContainer" class="glass-card tabs-card animate-slide" style="display: none;">
                        <div class="tab-navigation">
                            <button type="button" class="tab-btn active" data-tab="tabDeposit" data-theme="deposit"><i class="bx bx-down-arrow-alt"></i> Deposit</button>
                            <button type="button" class="tab-btn" data-tab="tabWithdraw" data-theme="withdraw"><i class="bx bx-up-arrow-alt"></i> Withdraw</button>
                            <button type="button" class="tab-btn" data-tab="tabTransfer" data-theme="transfer"><i class="bx bx-transfer"></i> Transfer</button>
                            <button type="button" class="tab-btn" data-tab="tabLoan" data-theme="loan"><i class="bx bx-building-house"></i> Pay Loan</button>
                            <button type="button" class="tab-btn" data-tab="tabCard" data-theme="card"><i class="bx bx-credit-card"></i> Pay Credit Card</button>
                        </div>

                        <!-- DEPOSIT TAB -->
                        <div class="tab-content-pane active" id="tabDeposit">
                            <form id="depositForm" method="post" action="${pageContext.request.contextPath}/cash-counter">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="action" value="deposit">
                                <input type="hidden" name="accountId" class="selected-account-id">

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                    <div class="form-group">
                                        <label class="form-label">Deposit Amount (INR)</label>
                                        <div class="form-control-container">
                                            <input type="number" name="amount" class="form-control" required min="100" placeholder="Min. ₹100">
                                            <i class="bx bx-rupee form-icon"></i>
                                        </div>
                                        <div class="amount-presets">
                                            <button type="button" class="preset-chip" data-amount="500">+₹500</button>
                                            <button type="button" class="preset-chip" data-amount="1000">+₹1k</button>
                                            <button type="button" class="preset-chip" data-amount="5000">+₹5k</button>
                                            <button type="button" class="preset-chip" data-amount="10000">+₹10k</button>
                                            <button type="button" class="preset-chip" data-amount="50000">+₹50k</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Funding Method</label>
                                        <select name="method" class="form-select" id="depositMethodSelect" style="display: none;">
                                            <option value="cash" selected>Physical Cash</option>
                                            <option value="cheque">Cheque Deposit</option>
                                        </select>
                                        <div class="segmented-control" data-target="depositMethodSelect">
                                            <button type="button" class="segmented-option active" data-value="cash"><i class="bx bx-money-withdraw"></i> Physical Cash</button>
                                            <button type="button" class="segmented-option" data-value="cheque"><i class="bx bx-receipt"></i> Cheque</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- CHEQUE DETAILS SUB-FORM -->
                                <div id="depositChequeDetails" style="display: none; background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Cheque Specifications</h4>
                                    
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Cheque Source</label>
                                            <select name="chequeSource" class="form-select" id="depositChequeSourceSelect" style="display: none;">
                                                <option value="external" selected>External Bank Cheque</option>
                                                <option value="internal">Internal VGB Cheque</option>
                                            </select>
                                            <div class="segmented-control" data-target="depositChequeSourceSelect" style="margin-bottom: 0;">
                                                <button type="button" class="segmented-option active" data-value="external">External Bank</button>
                                                <button type="button" class="segmented-option" data-value="internal">Internal VGB</button>
                                            </div>
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Cheque Number (6 digits)</label>
                                            <div class="form-control-container">
                                                <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6">
                                                <i class="bx bx-hash form-icon"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1fr; gap: 20px;">
                                        <!-- External Cheque fields -->
                                        <div class="form-group" id="depositExtBankField" style="margin-bottom: 0;">
                                            <label class="form-label">Drawing Bank Name</label>
                                            <div class="form-control-container">
                                                <input type="text" name="bankName" class="form-control" placeholder="HDFC, SBI, ICICI, etc.">
                                                <i class="bx bx-building form-icon"></i>
                                            </div>
                                        </div>
                                        <!-- Internal Cheque fields -->
                                        <div class="form-group" id="depositIntFromAccField" style="display: none; margin-bottom: 0;">
                                            <label class="form-label">Source VGB Account Number</label>
                                            <div class="form-control-container">
                                                <input type="text" id="depositIntFromAccInput" class="form-control" placeholder="Enter source account number...">
                                                <i class="bx bx-user-voice form-icon"></i>
                                            </div>
                                            <input type="hidden" name="fromAccountId" id="depositIntFromAccountId">
                                            <div id="depositIntChequeBooksField" style="margin-top: 15px; display: none;">
                                                <label class="form-label" style="font-size: 0.75rem;">Select Cheque Book</label>
                                                <select name="chequeBookNumber" class="form-select" id="depositChequeBookSelect" style="padding: 8px 12px; font-size: 0.8rem; padding-left: 15px;"></select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Memo / Description</label>
                                    <div class="form-control-container">
                                        <input type="text" name="description" class="form-control" placeholder="Counter Cash/Cheque Deposit" value="Counter Cash Deposit">
                                        <i class="bx bx-edit-alt form-icon"></i>
                                    </div>
                                </div>

                                <button type="submit" class="btn-submit"><i class="bx bx-check-double"></i> Complete Deposit</button>
                            </form>
                        </div>

                        <!-- WITHDRAWAL TAB -->
                        <div class="tab-content-pane" id="tabWithdraw">
                            <form id="withdrawForm" method="post" action="${pageContext.request.contextPath}/cash-counter">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="action" value="withdraw">
                                <input type="hidden" name="accountId" class="selected-account-id">

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                    <div class="form-group">
                                        <label class="form-label">Withdrawal Amount (INR)</label>
                                        <div class="form-control-container">
                                            <input type="number" name="amount" class="form-control" required min="100" placeholder="Min. ₹100">
                                            <i class="bx bx-rupee form-icon"></i>
                                        </div>
                                        <div class="amount-presets">
                                            <button type="button" class="preset-chip" data-amount="500">+₹500</button>
                                            <button type="button" class="preset-chip" data-amount="1000">+₹1k</button>
                                            <button type="button" class="preset-chip" data-amount="5000">+₹5k</button>
                                            <button type="button" class="preset-chip" data-amount="10000">+₹10k</button>
                                            <button type="button" class="preset-chip" data-amount="20000">+₹20k</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Withdrawal Mode</label>
                                        <select name="method" class="form-select" id="withdrawMethodSelect" style="display: none;">
                                            <option value="cash" selected>Cash Withdrawal</option>
                                            <option value="cheque">Cheque-based Withdrawal</option>
                                        </select>
                                        <div class="segmented-control" data-target="withdrawMethodSelect">
                                            <button type="button" class="segmented-option active" data-value="cash"><i class="bx bx-money-withdraw"></i> Cash</button>
                                            <button type="button" class="segmented-option" data-value="cheque"><i class="bx bx-receipt"></i> Cheque Leaf</button>
                                        </div>
                                    </div>
                                </div>

                                <!-- WITHDRAW CHEQUE DETAILS SUB-FORM -->
                                <div id="withdrawChequeDetails" style="display: none; background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Cheque Leaf Identification</h4>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Select Cheque Book Number</label>
                                            <select name="chequeBookNumber" class="form-select account-cheque-books-dropdown" id="withdrawChequeBookSelect" style="padding-left: 15px;"></select>
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Cheque Number (6 digits)</label>
                                            <div class="form-control-container">
                                                <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6">
                                                <i class="bx bx-hash form-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Memo / Description</label>
                                    <div class="form-control-container">
                                        <input type="text" name="description" class="form-control" placeholder="Counter Cash/Cheque Withdrawal" value="Counter Cash Withdrawal">
                                        <i class="bx bx-edit-alt form-icon"></i>
                                    </div>
                                </div>

                                <button type="submit" class="btn-submit"><i class="bx bx-check-double"></i> Complete Withdrawal</button>
                            </form>
                        </div>

                        <!-- TRANSFER TAB -->
                        <div class="tab-content-pane" id="tabTransfer">
                            <form id="transferForm" method="post" action="${pageContext.request.contextPath}/cash-counter">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="action" value="transfer">
                                <input type="hidden" name="fromAccountId" class="selected-account-id">

                                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Destination Bank</label>
                                        <select name="targetType" class="form-select" id="transferTargetTypeSelect" style="display: none;">
                                            <option value="internal" selected>Vertex Galaxy Bank (VGB)</option>
                                            <option value="external">External Bank (IFSC)</option>
                                        </select>
                                        <div class="segmented-control" data-target="transferTargetTypeSelect" style="margin-bottom: 0;">
                                            <button type="button" class="segmented-option active" data-value="internal">VGB A/C</button>
                                            <button type="button" class="segmented-option" data-value="external">Other Bank</button>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Source Funding</label>
                                        <select name="method" class="form-select" id="transferMethodSelect" style="display: none;">
                                            <option value="cash" selected>Debited Account</option>
                                            <option value="cheque">Cheque-based</option>
                                        </select>
                                        <div class="segmented-control" data-target="transferMethodSelect" style="margin-bottom: 0;">
                                            <button type="button" class="segmented-option active" data-value="cash">Debit Balance</button>
                                            <button type="button" class="segmented-option" data-value="cheque">Cheque Leaf</button>
                                        </div>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Transfer Amount (INR)</label>
                                        <div class="form-control-container">
                                            <input type="number" name="amount" class="form-control" required min="100" placeholder="Min. ₹100">
                                            <i class="bx bx-rupee form-icon"></i>
                                        </div>
                                    </div>
                                </div>

                                <!-- TRANSFER CHEQUE DETAILS -->
                                <div id="transferChequeDetails" style="display: none; background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Cheque Leaf Identification</h4>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Select Cheque Book Number</label>
                                            <select name="chequeBookNumber" class="form-select account-cheque-books-dropdown" id="transferChequeBookSelect" style="padding-left: 15px;"></select>
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Cheque Number (6 digits)</label>
                                            <div class="form-control-container">
                                                <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6">
                                                <i class="bx bx-hash form-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- TRANSFER DESTINATION DETAIL CARDS -->
                                <div style="background: rgba(99, 102, 241, 0.02); border: 1px solid rgba(99, 102, 241, 0.08); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Destination Account Details</h4>

                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Beneficiary Account Number</label>
                                            <div class="form-control-container">
                                                <input type="text" name="toAccountNumber" class="form-control" required placeholder="Enter destination account number...">
                                                <i class="bx bx-credit-card-front form-icon"></i>
                                            </div>
                                        </div>
                                        <div class="form-group external-transfer-fields" style="display: none; margin-bottom: 0;">
                                            <label class="form-label">Beneficiary Name</label>
                                            <div class="form-control-container">
                                                <input type="text" name="toHolderName" class="form-control" placeholder="John Doe">
                                                <i class="bx bx-user form-icon"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;" class="external-transfer-fields">
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">IFSC Code</label>
                                            <div class="form-control-container">
                                                <input type="text" name="toIfscCode" class="form-control" placeholder="SBIN0001234" maxlength="11">
                                                <i class="bx bx-code-alt form-icon"></i>
                                            </div>
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Bank Name</label>
                                            <div class="form-control-container">
                                                <input type="text" name="toBankName" class="form-control" placeholder="State Bank of India">
                                                <i class="bx bx-building form-icon"></i>
                                            </div>
                                        </div>
                                        <div class="form-group" style="margin-bottom: 0;">
                                            <label class="form-label">Branch Name</label>
                                            <div class="form-control-container">
                                                <input type="text" name="toBranchName" class="form-control" placeholder="Main Branch">
                                                <i class="bx bx-map-pin form-icon"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Memo / Description</label>
                                    <div class="form-control-container">
                                        <input type="text" name="description" class="form-control" placeholder="Teller Transfer Description" value="Counter Fund Transfer">
                                        <i class="bx bx-edit-alt form-icon"></i>
                                    </div>
                                </div>

                                <button type="submit" class="btn-submit"><i class="bx bx-check-double"></i> Complete Transfer</button>
                            </form>
                        </div>

                        <!-- LOAN REPAYMENT TAB -->
                        <div class="tab-content-pane" id="tabLoan">
                            <form id="loanForm" method="post" action="${pageContext.request.contextPath}/cash-counter">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="action" value="loan-payment">
                                <input type="hidden" name="customerId" id="loanCustomerId">

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Select Active Loan</label>
                                        <select name="loanId" class="form-select" id="loanSelect" required style="padding-left: 15px;">
                                            <!-- Populated dynamically -->
                                        </select>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Repayment Amount (INR)</label>
                                        <div class="form-control-container">
                                            <input type="number" name="amount" class="form-control" id="loanRepayAmount" required min="1" placeholder="Enter amount...">
                                            <i class="bx bx-rupee form-icon"></i>
                                        </div>
                                    </div>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Payment Method</label>
                                        <select name="method" class="form-select" id="loanPaymentMethodSelect" style="display: none;">
                                            <option value="cash" selected>Counter Cash Payment</option>
                                            <option value="account">Debit VGB Account</option>
                                            <option value="cheque">Cheque-based Payment</option>
                                        </select>
                                        <div class="segmented-control" data-target="loanPaymentMethodSelect" style="margin-bottom: 0;">
                                            <button type="button" class="segmented-option active" data-value="cash">Cash</button>
                                            <button type="button" class="segmented-option" data-value="account">Debit A/C</button>
                                            <button type="button" class="segmented-option" data-value="cheque">Cheque</button>
                                        </div>
                                    </div>
                                    <div class="form-group" id="loanAccountSelectField" style="display: none; margin-bottom: 0;">
                                        <label class="form-label">Source VGB Account Number</label>
                                        <div class="form-control-container">
                                            <input type="text" id="loanSourceAccInput" class="form-control" placeholder="Enter account to debit...">
                                            <i class="bx bx-credit-card-front form-icon"></i>
                                        </div>
                                        <input type="hidden" name="accountId" id="loanSourceAccountId">
                                        <div id="loanChequeDetails" style="display: none; margin-top: 15px; border-top: 1px dashed rgba(99,102,241,0.15); padding-top: 15px;">
                                            <label class="form-label" style="font-size: 0.75rem;">Select Cheque Book</label>
                                            <select name="chequeBookNumber" class="form-select" id="loanChequeBookSelect" style="padding: 8px 12px; font-size: 0.8rem; margin-bottom: 10px; padding-left: 15px;"></select>
                                            <label class="form-label" style="font-size: 0.75rem;">Cheque Number (6 digits)</label>
                                            <div class="form-control-container">
                                                <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6" style="padding: 8px 12px; font-size: 0.8rem; padding-left: 45px;">
                                                <i class="bx bx-hash form-icon" style="font-size: 1rem; left: 16px;"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn-submit"><i class="bx bx-check-double"></i> Complete Repayment</button>
                            </form>
                        </div>

                        <!-- CREDIT CARD BILL TAB -->
                        <div class="tab-content-pane" id="tabCard">
                            <form id="cardForm" method="post" action="${pageContext.request.contextPath}/cash-counter">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="action" value="card-payment">

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Select Active Credit Card</label>
                                        <select name="cardId" class="form-select" id="cardSelect" required style="padding-left: 15px;">
                                            <!-- Populated dynamically -->
                                        </select>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Payment Amount (INR)</label>
                                        <div class="form-control-container">
                                            <input type="number" name="amount" class="form-control" id="cardRepayAmount" required min="1" placeholder="Enter amount...">
                                            <i class="bx bx-rupee form-icon"></i>
                                        </div>
                                    </div>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label">Payment Method</label>
                                        <select name="method" class="form-select" id="cardPaymentMethodSelect" style="display: none;">
                                            <option value="cash" selected>Counter Cash Payment</option>
                                            <option value="account">Debit VGB Account</option>
                                            <option value="cheque">Cheque-based Payment</option>
                                        </select>
                                        <div class="segmented-control" data-target="cardPaymentMethodSelect" style="margin-bottom: 0;">
                                            <button type="button" class="segmented-option active" data-value="cash">Cash</button>
                                            <button type="button" class="segmented-option" data-value="account">Debit A/C</button>
                                            <button type="button" class="segmented-option" data-value="cheque">Cheque</button>
                                        </div>
                                    </div>
                                    <div class="form-group" id="cardAccountSelectField" style="display: none; margin-bottom: 0;">
                                        <label class="form-label">Source VGB Account Number</label>
                                        <div class="form-control-container">
                                            <input type="text" id="cardSourceAccInput" class="form-control" placeholder="Enter account to debit...">
                                            <i class="bx bx-credit-card-front form-icon"></i>
                                        </div>
                                        <input type="hidden" name="accountId" id="cardSourceAccountId">
                                        <div id="cardChequeDetails" style="display: none; margin-top: 15px; border-top: 1px dashed rgba(99,102,241,0.15); padding-top: 15px;">
                                            <label class="form-label" style="font-size: 0.75rem;">Select Cheque Book</label>
                                            <select name="chequeBookNumber" class="form-select" id="cardChequeBookSelect" style="padding: 8px 12px; font-size: 0.8rem; margin-bottom: 10px; padding-left: 15px;"></select>
                                            <label class="form-label" style="font-size: 0.75rem;">Cheque Number (6 digits)</label>
                                            <div class="form-control-container">
                                                <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6" style="padding: 8px 12px; font-size: 0.8rem; padding-left: 45px;">
                                                <i class="bx bx-hash form-icon" style="font-size: 1rem; left: 16px;"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn-submit"><i class="bx bx-check-double"></i> Complete Payment</button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; 2026 Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        // Cursor Glow
        const glow = document.querySelector('.cursor-glow');
        if (glow) {
            document.addEventListener('mousemove', (e) => {
                glow.style.left = e.clientX + 'px';
                glow.style.top = e.clientY + 'px';
            });
        }

        // Mobile Nav Toggle
        const mobileToggle = document.getElementById('mobileNavToggle');
        const sidebar = document.querySelector('.sidebar');
        if (mobileToggle && sidebar) {
            mobileToggle.addEventListener('click', (e) => {
                e.stopPropagation();
                sidebar.classList.toggle('active');
            });
        }

        // --- TOAST FUNCTIONALITY ---
        function showToast(message, isError = false) {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'toast-card ' + (isError ? 'error animate-slide' : 'animate-slide');
            
            const icon = document.createElement('i');
            icon.className = 'bx ' + (isError ? 'bx-error-circle' : 'bx-badge-check') + ' toast-icon';
            
            const text = document.createElement('span');
            text.style.fontWeight = '600';
            text.style.fontSize = '0.9rem';
            text.innerText = message;
            
            toast.appendChild(icon);
            toast.appendChild(text);
            container.appendChild(toast);
            
            setTimeout(() => toast.classList.add('show'), 50);
            
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 400);
            }, 4500);
        }

        function safeFetchJson(url, options = {}) {
            return fetch(url, options)
                .then(res => {
                    const contentType = res.headers.get("content-type");
                    if (contentType && contentType.includes("application/json")) {
                        return res.json().then(data => {
                            if (!res.ok) {
                                throw new Error(data.error || data.message || 'Transaction failed');
                            }
                            return data;
                        });
                    } else {
                        return res.text().then(text => {
                            const parser = new DOMParser();
                            const htmlDoc = parser.parseFromString(text, 'text/html');
                            const errorPara = htmlDoc.querySelector('p');
                            const errorMsg = errorPara ? errorPara.textContent : 'Invalid response from server.';
                            throw new Error(errorMsg);
                        });
                    }
                });
        }

        // --- TAB SWITCHING ---
        const tabs = document.querySelectorAll('.tab-btn');
        const tabsContainer = document.getElementById('transactionTabsContainer');

        // Initial tab color theme configuration
        function applyTabAccentTheme(themeName) {
            // Remove previous theme classes
            tabsContainer.classList.remove('theme-deposit', 'theme-withdraw', 'theme-transfer', 'theme-loan', 'theme-card');
            // Add new theme class
            tabsContainer.classList.add('theme-' + themeName);
        }

        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                
                const tabId = tab.getAttribute('data-tab');
                const theme = tab.getAttribute('data-theme');
                applyTabAccentTheme(theme);

                document.querySelectorAll('.tab-content-pane').forEach(pane => {
                    pane.classList.remove('active');
                });
                document.getElementById(tabId).classList.add('active');
            });
        });

        // Initialize active theme
        applyTabAccentTheme('deposit');

        // --- SEGMENTED SWITCH CONTROLS ---
        document.querySelectorAll('.segmented-control').forEach(control => {
            const targetId = control.getAttribute('data-target');
            const targetSelect = document.getElementById(targetId);
            const options = control.querySelectorAll('.segmented-option');
            
            options.forEach(opt => {
                opt.addEventListener('click', () => {
                    options.forEach(o => o.classList.remove('active'));
                    opt.classList.add('active');
                    
                    const val = opt.getAttribute('data-value');
                    targetSelect.value = val;
                    
                    // Dispatch change event on select to trigger any dependent toggles
                    targetSelect.dispatchEvent(new Event('change'));
                });
            });
        });

        // --- PRESET AMOUNT CHIPS HANDLER ---
        document.querySelectorAll('.preset-chip').forEach(chip => {
            chip.addEventListener('click', () => {
                const amountToAdd = parseFloat(chip.getAttribute('data-amount'));
                const formGroup = chip.closest('.form-group');
                const input = formGroup.querySelector('input[type="number"]');
                let currentVal = parseFloat(input.value) || 0;
                input.value = currentVal + amountToAdd;
                input.dispatchEvent(new Event('input')); // trigger validations if any
            });
        });

        // --- DYNAMIC SEARCH & AUTOCOMPLETE ---
        let searchTimeout = null;
        const searchInput = document.getElementById('counterSearchInput');
        const resultsPanel = document.getElementById('searchResultsPanel');

        searchInput.addEventListener('input', () => {
            clearTimeout(searchTimeout);
            const query = searchInput.value.trim();
            if (query.length < 3) {
                resultsPanel.style.display = 'none';
                return;
            }

            searchTimeout = setTimeout(() => {
                safeFetchJson('${pageContext.request.contextPath}/cash-counter?action=search&query=' + encodeURIComponent(query))
                    .then(data => {
                        resultsPanel.innerHTML = '';
                        if (data.length === 0) {
                            resultsPanel.innerHTML = '<div style="padding: 15px; color: var(--gray-400); font-weight: 500; text-align: center;">No accounts or customers found matching the search.</div>';
                            resultsPanel.style.display = 'block';
                            return;
                        }

                        data.forEach(item => {
                            const div = document.createElement('div');
                            div.style.cssText = 'padding: 12px 18px; border-bottom: 1px solid rgba(99, 102, 241, 0.05); cursor: pointer; display: flex; align-items: center; justify-content: space-between; transition: background 0.2s;';
                            
                            const avatarSrc = item.avatarPath ? ('${pageContext.request.contextPath}/' + item.avatarPath) : '${pageContext.request.contextPath}/assest/images/logo.png';
                            
                            div.innerHTML = 
                                '<div style="display: flex; align-items: center; gap: 12px;">' +
                                    '<img src="' + avatarSrc + '" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary-500);">' +
                                    '<div>' +
                                        '<strong style="color: var(--gray-800); display: block; font-size: 0.9rem;">' + item.firstName + ' ' + item.lastName + '</strong>' +
                                        '<span style="color: var(--gray-400); font-size: 0.75rem;">Phone: ' + item.phoneNo + '</span>' +
                                    '</div>' +
                                '</div>' +
                                '<span style="font-family: monospace; font-size: 0.85rem; font-weight: 700; color: var(--primary-500); background: rgba(99, 102, 241, 0.06); padding: 4px 8px; border-radius: var(--radius-sm);">' + item.accountNumber + '</span>';
                            
                            div.addEventListener('mouseover', () => div.style.background = 'rgba(99, 102, 241, 0.02)');
                            div.addEventListener('mouseout', () => div.style.background = 'none');
                            div.addEventListener('click', () => selectCustomer(item));
                            resultsPanel.appendChild(div);
                        });
                        resultsPanel.style.display = 'block';
                    })
                    .catch(err => {
                        console.error(err);
                        showToast('Error executing autocomplete search.', true);
                    });
            }, 300);
        });

        // Hide results panel if clicking outside
        document.addEventListener('click', (e) => {
            if (!searchInput.contains(e.target) && !resultsPanel.contains(e.target)) {
                resultsPanel.style.display = 'none';
            }
        });

        // --- SELECT CUSTOMER ACTION ---
        let currentSelectedAccount = null;

        function selectCustomer(account) {
            currentSelectedAccount = account;
            resultsPanel.style.display = 'none';
            searchInput.value = '';

            // Populate Customer summary
            document.getElementById('summaryAvatar').src = account.avatarPath ? ('${pageContext.request.contextPath}/' + account.avatarPath) : '${pageContext.request.contextPath}/assest/images/logo.png';
            document.getElementById('summaryName').innerText = account.firstName + ' ' + account.lastName;
            document.getElementById('summaryAccNo').innerText = account.accountNumber;
            document.getElementById('summaryAccType').innerText = account.accountType + ' account';
            document.getElementById('summaryAccBalance').innerText = '₹ ' + parseFloat(account.balance).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            
            // Set account status badge style
            const statusBadge = document.getElementById('summaryStatus');
            statusBadge.innerText = account.status || 'Active';
            if (account.status && account.status.toLowerCase() !== 'active') {
                statusBadge.className = 'badge-status badge-status-suspended';
            } else {
                statusBadge.className = 'badge-status badge-status-active';
            }

            // Contact Info
            document.getElementById('customerDetailContact').innerHTML = 
                '<div style="margin-top: 10px; font-weight: 500; color: var(--gray-500); display: flex; flex-direction: column; gap: 4px;">' +
                    '<span><i class="bx bx-envelope" style="margin-right: 5px;"></i>' + account.email + '</span>' +
                    '<span><i class="bx bx-phone" style="margin-right: 5px;"></i>+91 ' + account.phoneNo + '</span>' +
                '</div>';

            // Copy Action Setup
            const copyBtn = document.getElementById('btnCopyAcc');
            copyBtn.onclick = () => {
                navigator.clipboard.writeText(account.accountNumber);
                showToast('Account Number copied to clipboard!');
            };

            // Populate hidden inputs in forms
            document.querySelectorAll('.selected-account-id').forEach(input => {
                input.value = account.accountId;
            });

            // Populate Cheque books dropdowns
            const chequeDropdowns = document.querySelectorAll('.account-cheque-books-dropdown');
            chequeDropdowns.forEach(dropdown => {
                dropdown.innerHTML = '';
                if (account.chequeBooks && account.chequeBooks.length > 0) {
                    account.chequeBooks.forEach(cb => {
                        const opt = document.createElement('option');
                        opt.value = cb.chequebookNumber;
                        opt.innerText = cb.chequebookNumber + ' (Leaves: ' + cb.startChequeNo + ' to ' + cb.endChequeNo + ')';
                        dropdown.appendChild(opt);
                    });
                } else {
                    dropdown.innerHTML = '<option value="">No Active Cheque Books Found</option>';
                }
            });

            // Populate Loan Select & Left Sidebar Loans Section
            const loanSelect = document.getElementById('loanSelect');
            const loansTile = document.getElementById('summaryLoansTile');
            const loansList = document.getElementById('summaryLoansList');
            
            loanSelect.innerHTML = '';
            loansList.innerHTML = '';
            document.getElementById('loanCustomerId').value = account.customerId;

            if (account.loans && account.loans.length > 0) {
                account.loans.forEach(loan => {
                    // Dropdown
                    const opt = document.createElement('option');
                    opt.value = loan.loanId;
                    opt.setAttribute('data-bal', loan.remainingBalance);
                    opt.innerText = '#LN-' + loan.loanId + ' (' + loan.loanType + ') - Outstanding: ₹' + parseFloat(loan.remainingBalance).toLocaleString('en-IN');
                    loanSelect.appendChild(opt);

                    // Left card tile row
                    const row = document.createElement('div');
                    row.style.cssText = 'display: flex; justify-content: space-between; align-items: center; border-bottom: 1px dashed rgba(99, 102, 241, 0.06); padding-bottom: 6px;';
                    row.innerHTML = 
                        '<div>' +
                            '<span style="font-size: 0.8rem; font-weight: 600; display: block; color: var(--gray-600);">' + loan.loanType + ' (#LN-' + loan.loanId + ')</span>' +
                            '<span style="font-size: 0.85rem; font-weight: 700; color: #ef4444;">₹' + parseFloat(loan.remainingBalance).toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</span>' +
                        '</div>' +
                        '<button type="button" class="preset-chip" style="padding: 2px 8px; font-size: 0.75rem; border-radius: 4px;" onclick="quickNavigateToRepay(\'loan\', ' + loan.loanId + ')">Repay</button>';
                    loansList.appendChild(row);
                });
                updateLoanRepayMax();
                loansTile.style.display = 'block';
            } else {
                loanSelect.innerHTML = '<option value="">No Active Loans Found</option>';
                loansTile.style.display = 'none';
            }

            // Populate Card Select & Left Sidebar Cards Section
            const cardSelect = document.getElementById('cardSelect');
            const cardsTile = document.getElementById('summaryCardsTile');
            const cardsList = document.getElementById('summaryCardsList');
            
            cardSelect.innerHTML = '';
            cardsList.innerHTML = '';

            if (account.cards && account.cards.length > 0) {
                account.cards.forEach(card => {
                    // Dropdown
                    const opt = document.createElement('option');
                    opt.value = card.cardId;
                    opt.setAttribute('data-bal', card.outstandingBalance);
                    opt.innerText = card.cardNumber + ' (' + card.cardTier + ') - Dues: ₹' + parseFloat(card.outstandingBalance).toLocaleString('en-IN');
                    cardSelect.appendChild(opt);

                    // Left card tile row
                    const row = document.createElement('div');
                    row.style.cssText = 'display: flex; justify-content: space-between; align-items: center; border-bottom: 1px dashed rgba(99, 102, 241, 0.06); padding-bottom: 6px;';
                    row.innerHTML = 
                        '<div>' +
                            '<span style="font-size: 0.8rem; font-weight: 600; display: block; color: var(--gray-600);">' + card.cardTier + ' (' + card.cardNumber.substring(card.cardNumber.length - 4) + ')</span>' +
                            '<span style="font-size: 0.85rem; font-weight: 700; color: #ef4444;">₹' + parseFloat(card.outstandingBalance).toLocaleString('en-IN', { minimumFractionDigits: 2 }) + '</span>' +
                        '</div>' +
                        '<button type="button" class="preset-chip" style="padding: 2px 8px; font-size: 0.75rem; border-radius: 4px;" onclick="quickNavigateToRepay(\'card\', ' + card.cardId + ')">Pay</button>';
                    cardsList.appendChild(row);
                });
                updateCardRepayMax();
                cardsTile.style.display = 'block';
            } else {
                cardSelect.innerHTML = '<option value="">No Active Credit Cards Found</option>';
                cardsTile.style.display = 'none';
            }

            // Animate details page display
            document.querySelector('.desk-grid').classList.add('has-selection');
            document.getElementById('welcomeDeskCard').style.display = 'none';
            document.getElementById('customerSummaryCard').style.display = 'block';
            document.getElementById('transactionTabsContainer').style.display = 'block';
            
            showToast('Desk environment loaded for ' + account.firstName + ' ' + account.lastName + '.');
        }

        // Quick Navigation to repayment tabs from Left sidebar links
        window.quickNavigateToRepay = function(type, id) {
            let tabBtn = null;
            if (type === 'loan') {
                tabBtn = document.querySelector('.tab-btn[data-tab="tabLoan"]');
                document.getElementById('loanSelect').value = id;
                updateLoanRepayMax();
            } else if (type === 'card') {
                tabBtn = document.querySelector('.tab-btn[data-tab="tabCard"]');
                document.getElementById('cardSelect').value = id;
                updateCardRepayMax();
            }
            if (tabBtn) tabBtn.click();
        };

        // --- SUB-FORM VISIBILITY TOGGLES ---

        // Deposit Sub-Form Toggles
        const depMethod = document.getElementById('depositMethodSelect');
        const depCheque = document.getElementById('depositChequeDetails');
        depMethod.addEventListener('change', () => {
            if (depMethod.value === 'cheque') {
                depCheque.style.display = 'block';
                document.getElementById('depositForm').querySelector('input[name="description"]').value = "Cheque Counter Deposit";
            } else {
                depCheque.style.display = 'none';
                document.getElementById('depositForm').querySelector('input[name="description"]').value = "Counter Cash Deposit";
            }
        });

        const depChequeSource = document.getElementById('depositChequeSourceSelect');
        const depExtBank = document.getElementById('depositExtBankField');
        const depIntFromAcc = document.getElementById('depositIntFromAccField');
        depChequeSource.addEventListener('change', () => {
            if (depChequeSource.value === 'internal') {
                depExtBank.style.display = 'none';
                depIntFromAcc.style.display = 'block';
            } else {
                depExtBank.style.display = 'block';
                depIntFromAcc.style.display = 'none';
            }
        });

        // Autocomplete source account on Internal Cheque Deposit
        const depIntFromAccInput = document.getElementById('depositIntFromAccInput');
        depIntFromAccInput.addEventListener('change', () => {
            const accNum = depIntFromAccInput.value.trim();
            if (accNum.length > 0) {
                safeFetchJson('${pageContext.request.contextPath}/cash-counter?action=search&query=' + encodeURIComponent(accNum))
                    .then(data => {
                        const matched = data.find(a => a.accountNumber === accNum);
                        if (matched) {
                            document.getElementById('depositIntFromAccountId').value = matched.accountId;
                            // Load cheque books of source account
                            const cbSelect = document.getElementById('depositChequeBookSelect');
                            cbSelect.innerHTML = '';
                            if (matched.chequeBooks && matched.chequeBooks.length > 0) {
                                matched.chequeBooks.forEach(cb => {
                                    const opt = document.createElement('option');
                                    opt.value = cb.chequebookNumber;
                                    opt.innerText = cb.chequebookNumber;
                                    cbSelect.appendChild(opt);
                                });
                                document.getElementById('depositIntChequeBooksField').style.display = 'block';
                            } else {
                                cbSelect.innerHTML = '<option value="">No cheque books found</option>';
                                document.getElementById('depositIntChequeBooksField').style.display = 'block';
                            }
                        } else {
                            showToast('VGB source account not found.', true);
                            document.getElementById('depositIntFromAccountId').value = '';
                        }
                    });
            }
        });

        // Withdraw Sub-Form Toggles
        const wthMethod = document.getElementById('withdrawMethodSelect');
        const wthCheque = document.getElementById('withdrawChequeDetails');
        wthMethod.addEventListener('change', () => {
            if (wthMethod.value === 'cheque') {
                wthCheque.style.display = 'block';
                document.getElementById('withdrawForm').querySelector('input[name="description"]').value = "Cheque Counter Withdrawal";
            } else {
                wthCheque.style.display = 'none';
                document.getElementById('withdrawForm').querySelector('input[name="description"]').value = "Counter Cash Withdrawal";
            }
        });

        // Transfer Sub-Form Toggles
        const trsfMethod = document.getElementById('transferMethodSelect');
        const trsfCheque = document.getElementById('transferChequeDetails');
        trsfMethod.addEventListener('change', () => {
            trsfCheque.style.display = trsfMethod.value === 'cheque' ? 'block' : 'none';
        });

        const trsfType = document.getElementById('transferTargetTypeSelect');
        const extFields = document.querySelectorAll('.external-transfer-fields');
        trsfType.addEventListener('change', () => {
            const isExt = trsfType.value === 'external';
            extFields.forEach(f => f.style.display = isExt ? 'block' : 'none');
            const toAccInput = document.querySelector('input[name="toAccountNumber"]');
            if (isExt) {
                toAccInput.placeholder = "Enter external account number...";
            } else {
                toAccInput.placeholder = "Enter destination VGB account number...";
            }
        });

        // Loan Sub-Form Toggles
        const loanMethod = document.getElementById('loanPaymentMethodSelect');
        const loanAccField = document.getElementById('loanAccountSelectField');
        const loanCheque = document.getElementById('loanChequeDetails');
        loanMethod.addEventListener('change', () => {
            if (loanMethod.value === 'account' || loanMethod.value === 'cheque') {
                loanAccField.style.display = 'block';
                loanCheque.style.display = loanMethod.value === 'cheque' ? 'block' : 'none';
            } else {
                loanAccField.style.display = 'none';
                loanCheque.style.display = 'none';
            }
        });

        // Autocomplete source account on Loan Repayment Debit
        const loanSourceAccInput = document.getElementById('loanSourceAccInput');
        loanSourceAccInput.addEventListener('change', () => {
            const accNum = loanSourceAccInput.value.trim();
            if (accNum.length > 0) {
                safeFetchJson('${pageContext.request.contextPath}/cash-counter?action=search&query=' + encodeURIComponent(accNum))
                    .then(data => {
                        const matched = data.find(a => a.accountNumber === accNum);
                        if (matched) {
                            document.getElementById('loanSourceAccountId').value = matched.accountId;
                            // Load cheque books if cheque mode is selected
                            const cbSelect = document.getElementById('loanChequeBookSelect');
                            cbSelect.innerHTML = '';
                            if (matched.chequeBooks && matched.chequeBooks.length > 0) {
                                matched.chequeBooks.forEach(cb => {
                                    const opt = document.createElement('option');
                                    opt.value = cb.chequebookNumber;
                                    opt.innerText = cb.chequebookNumber;
                                    cbSelect.appendChild(opt);
                                });
                            }
                        } else {
                            showToast('VGB source account not found.', true);
                            document.getElementById('loanSourceAccountId').value = '';
                        }
                    });
            }
        });

        // Max values auto-setting on loan selection
        const loanSelect = document.getElementById('loanSelect');
        const loanRepayInput = document.getElementById('loanRepayAmount');
        loanSelect.addEventListener('change', updateLoanRepayMax);
        function updateLoanRepayMax() {
            const opt = loanSelect.options[loanSelect.selectedIndex];
            if (opt) {
                const bal = parseFloat(opt.getAttribute('data-bal'));
                loanRepayInput.max = bal;
                loanRepayInput.placeholder = 'Max ₹' + bal.toLocaleString('en-IN');
            }
        }

        // Card Sub-Form Toggles
        const cardMethod = document.getElementById('cardPaymentMethodSelect');
        const cardAccField = document.getElementById('cardAccountSelectField');
        const cardCheque = document.getElementById('cardChequeDetails');
        cardMethod.addEventListener('change', () => {
            if (cardMethod.value === 'account' || cardMethod.value === 'cheque') {
                cardAccField.style.display = 'block';
                cardCheque.style.display = cardMethod.value === 'cheque' ? 'block' : 'none';
            } else {
                cardAccField.style.display = 'none';
                cardCheque.style.display = 'none';
            }
        });

        // Autocomplete source account on Card Repayment Debit
        const cardSourceAccInput = document.getElementById('cardSourceAccInput');
        cardSourceAccInput.addEventListener('change', () => {
            const accNum = cardSourceAccInput.value.trim();
            if (accNum.length > 0) {
                safeFetchJson('${pageContext.request.contextPath}/cash-counter?action=search&query=' + encodeURIComponent(accNum))
                    .then(data => {
                        const matched = data.find(a => a.accountNumber === accNum);
                        if (matched) {
                            document.getElementById('cardSourceAccountId').value = matched.accountId;
                            // Load cheque books if cheque mode is selected
                            const cbSelect = document.getElementById('cardChequeBookSelect');
                            cbSelect.innerHTML = '';
                            if (matched.chequeBooks && matched.chequeBooks.length > 0) {
                                matched.chequeBooks.forEach(cb => {
                                    const opt = document.createElement('option');
                                    opt.value = cb.chequebookNumber;
                                    opt.innerText = cb.chequebookNumber;
                                    cbSelect.appendChild(opt);
                                });
                            }
                        } else {
                            showToast('VGB source account not found.', true);
                            document.getElementById('cardSourceAccountId').value = '';
                        }
                    });
            }
        });

        // Max values auto-setting on card selection
        const cardSelect = document.getElementById('cardSelect');
        const cardRepayInput = document.getElementById('cardRepayAmount');
        cardSelect.addEventListener('change', updateCardRepayMax);
        function updateCardRepayMax() {
            const opt = cardSelect.options[cardSelect.selectedIndex];
            if (opt) {
                const bal = parseFloat(opt.getAttribute('data-bal'));
                cardRepayInput.max = bal;
                cardRepayInput.placeholder = 'Max ₹' + bal.toLocaleString('en-IN');
            }
        }


        // --- AJAX FORM SUBMISSION HANDLERS ---
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                const formData = new FormData(form);
                
                // Construct URL-encoded body
                const params = new URLSearchParams();
                for (const pair of formData.entries()) {
                    params.append(pair[0], pair[1]);
                }

                const headers = {
                    'Content-Type': 'application/x-www-form-urlencoded'
                };

                // Add loading spinner or visual feedback
                const submitBtn = form.querySelector('.btn-submit');
                const originalBtnContent = submitBtn.innerHTML;
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="bx bx-loader-alt bx-spin"></i> Processing...';

                safeFetchJson(form.action, {
                    method: 'POST',
                    headers: headers,
                    body: params.toString()
                })
                .then(data => {
                    showToast(data.message || 'Transaction executed successfully!');
                    form.reset();
                    
                    // Reset segmented controls visual state
                    form.querySelectorAll('.segmented-control').forEach(ctrl => {
                        const targetSelect = document.getElementById(ctrl.getAttribute('data-target'));
                        const targetVal = targetSelect.value;
                        ctrl.querySelectorAll('.segmented-option').forEach(opt => {
                            if (opt.getAttribute('data-value') === targetVal) {
                                opt.classList.add('active');
                            } else {
                                opt.classList.remove('active');
                            }
                        });
                    });

                    // Hide cheque/account fields if they were open
                    if (depCheque) depCheque.style.display = 'none';
                    if (wthCheque) wthCheque.style.display = 'none';
                    if (trsfCheque) trsfCheque.style.display = 'none';
                    if (loanAccField) loanAccField.style.display = 'none';
                    if (cardAccField) cardAccField.style.display = 'none';

                    // Re-fetch the current selected customer account to update details and balance
                    if (currentSelectedAccount) {
                        const accNo = currentSelectedAccount.accountNumber;
                        safeFetchJson('${pageContext.request.contextPath}/cash-counter?action=search&query=' + encodeURIComponent(accNo))
                            .then(d => {
                                const matched = d.find(a => a.accountNumber === accNo);
                                if (matched) {
                                    selectCustomer(matched);
                                }
                            });
                    }
                })
                .catch(err => {
                    showToast(err.message || 'Database transaction error occurred.', true);
                })
                .finally(() => {
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalBtnContent;
                });
            });
        });

    </script>
</body>
</html>
