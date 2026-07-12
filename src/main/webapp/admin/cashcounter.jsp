<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Cash Counter</title>
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
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        body.dark-mode .glass-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
        }

        /* --- TABS --- */
        .tab-navigation {
            display: flex;
            gap: 10px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
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
        .tab-btn.active {
            background: rgba(99, 102, 241, 0.08);
            color: var(--primary-500);
        }
        body.dark-mode .tab-btn.active {
            background: rgba(99, 102, 241, 0.18);
            color: #818cf8;
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

        /* Form styling adjustments */
        .form-group {
            margin-bottom: 20px;
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
        .form-control, .form-select {
            width: 100%;
            padding: 12px 16px;
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
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }

        .btn-submit {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 0.9rem;
            font-weight: 600;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(99, 102, 241, 0.3);
        }

        /* Profile card summary info */
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
            border: 3px solid var(--primary-500);
            object-fit: cover;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.15);
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

        /* --- TOAST NOTIFICATIONS --- */
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
            backdrop-filter: blur(10px);
            border-left: 5px solid #10b981;
            padding: 16px 20px;
            border-radius: var(--radius-md);
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 300px;
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
            font-size: 1.5rem;
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

        @media (max-width: 991px) {
            .sidebar { left: -280px !important; }
            .main-content { margin-left: 0 !important; padding: 120px 20px 40px !important; }
            .footer { margin-left: 0 !important; }
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
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Cash Counter Desk</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Search customer profiles to execute instant, teller-assisted deposits, withdrawals, fund transfers, and credit dues/loan repayments.</p>
            </div>

            <!-- SEARCH COMPONENT -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px;">
                    <i class="bx bx-search-alt" style="color: var(--primary-500); margin-right: 5px;"></i> Search Account or Profile
                </h3>
                <div style="position: relative;">
                    <input type="text" id="counterSearchInput" class="form-control" placeholder="Search by Account Number, Name, Phone Number, Email, PAN or Aadhaar..." style="padding-left: 45px;">
                    <i class="bx bx-search" style="position: absolute; left: 16px; top: 16px; font-size: 1.2rem; color: var(--gray-400);"></i>
                </div>

                <!-- Search Results Auto-Suggest Panel -->
                <div id="searchResultsPanel" style="display: none; border: 1px solid rgba(99, 102, 241, 0.15); border-radius: var(--radius-md); margin-top: 10px; background: white; max-height: 250px; overflow-y: auto; box-shadow: 0 4px 15px rgba(0,0,0,0.05); z-index: 100;">
                    <!-- Appended dynamically -->
                </div>
            </div>

            <!-- CUSTOMER DETAILS PANEL (DISSOLVES IF EMPTY) -->
            <div id="customerSummaryCard" class="glass-card" style="display: none;">
                <div class="profile-summary-header">
                    <img id="summaryAvatar" src="" class="profile-summary-avatar" alt="Avatar">
                    <div>
                        <h3 id="summaryName" style="font-size: 1.4rem; font-weight: 700; color: var(--gray-800); margin-bottom: 4px;"></h3>
                        <p id="summaryDetails" style="font-size: 0.85rem; color: var(--gray-400); font-weight: 500;"></p>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;">
                    <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid var(--glass-border); padding: 15px; border-radius: var(--radius-md);">
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Active Account No.</span>
                        <strong id="summaryAccNo" style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 4px;"></strong>
                    </div>
                    <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid var(--glass-border); padding: 15px; border-radius: var(--radius-md);">
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Account Type</span>
                        <strong id="summaryAccType" style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 4px; text-transform: capitalize;"></strong>
                    </div>
                    <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid var(--glass-border); padding: 15px; border-radius: var(--radius-md);">
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Current Balance</span>
                        <strong id="summaryAccBalance" style="font-size: 1.1rem; color: var(--primary-500); display: block; margin-top: 4px;">₹ 0.00</strong>
                    </div>
                </div>
            </div>

            <!-- TRANSACTION TABS PANEL -->
            <div id="transactionTabsContainer" class="glass-card" style="display: none;">
                <div class="tab-navigation">
                    <button class="tab-btn active" data-tab="tabDeposit"><i class="bx bx-down-arrow-alt"></i> Deposit</button>
                    <button class="tab-btn" data-tab="tabWithdraw"><i class="bx bx-up-arrow-alt"></i> Withdraw</button>
                    <button class="tab-btn" data-tab="tabTransfer"><i class="bx bx-transfer"></i> Transfer</button>
                    <button class="tab-btn" data-tab="tabLoan"><i class="bx bx-building-house"></i> Pay Loan</button>
                    <button class="tab-btn" data-tab="tabCard"><i class="bx bx-credit-card"></i> Pay Credit Card</button>
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
                                <input type="number" name="amount" class="form-control" required min="100" placeholder="Min. ₹100">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Funding Method</label>
                                <select name="method" class="form-select" id="depositMethodSelect">
                                    <option value="cash">Physical Cash</option>
                                    <option value="cheque">Cheque Deposit</option>
                                </select>
                            </div>
                        </div>

                        <!-- CHEQUE DETAILS SUB-FORM -->
                        <div id="depositChequeDetails" style="display: none; background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Cheque Specifications</h4>
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Cheque Source</label>
                                    <select name="chequeSource" class="form-select" id="depositChequeSourceSelect">
                                        <option value="external">External Bank Cheque</option>
                                        <option value="internal">Internal VGB Cheque</option>
                                    </select>
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Cheque Number (6 digits)</label>
                                    <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6">
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <!-- External Cheque fields -->
                                <div class="form-group" id="depositExtBankField" style="margin-bottom: 0;">
                                    <label class="form-label">Drawing Bank Name</label>
                                    <input type="text" name="bankName" class="form-control" placeholder="HDFC, SBI, etc.">
                                </div>
                                <!-- Internal Cheque fields -->
                                <div class="form-group" id="depositIntFromAccField" style="display: none; margin-bottom: 0;">
                                    <label class="form-label">Source VGB Account Number</label>
                                    <input type="text" id="depositIntFromAccInput" class="form-control" placeholder="Enter source account...">
                                    <input type="hidden" name="fromAccountId" id="depositIntFromAccountId">
                                    <div id="depositIntChequeBooksField" style="margin-top: 10px; display: none;">
                                        <label class="form-label" style="font-size: 0.75rem;">Select Cheque Book</label>
                                        <select name="chequeBookNumber" class="form-select" id="depositChequeBookSelect" style="padding: 8px 12px; font-size: 0.8rem;"></select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Memo / Description</label>
                            <input type="text" name="description" class="form-control" placeholder="Counter Cash/Cheque Deposit" value="Counter Cash Deposit">
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
                                <input type="number" name="amount" class="form-control" required min="100" placeholder="Min. ₹100">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Withdrawal Mode</label>
                                <select name="method" class="form-select" id="withdrawMethodSelect">
                                    <option value="cash">Cash Withdrawal</option>
                                    <option value="cheque">Cheque-based Withdrawal</option>
                                </select>
                            </div>
                        </div>

                        <!-- WITHDRAW CHEQUE DETAILS SUB-FORM -->
                        <div id="withdrawChequeDetails" style="display: none; background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Cheque Leaf Identification</h4>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Select Cheque Book Number</label>
                                    <select name="chequeBookNumber" class="form-select account-cheque-books-dropdown" id="withdrawChequeBookSelect"></select>
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Cheque Number (6 digits)</label>
                                    <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Memo / Description</label>
                            <input type="text" name="description" class="form-control" placeholder="Counter Cash/Cheque Withdrawal" value="Counter Cash Withdrawal">
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
                                <select name="targetType" class="form-select" id="transferTargetTypeSelect">
                                    <option value="internal">Vertex Galaxy Bank (VGB)</option>
                                    <option value="external">External Bank (IFSC Transfer)</option>
                                </select>
                            </div>
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Source Funding</label>
                                <select name="method" class="form-select" id="transferMethodSelect">
                                    <option value="cash">Debited Account Balance</option>
                                    <option value="cheque">Cheque-based Funding</option>
                                </select>
                            </div>
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Transfer Amount (INR)</label>
                                <input type="number" name="amount" class="form-control" required min="100" placeholder="Min. ₹100">
                            </div>
                        </div>

                        <!-- TRANSFER CHEQUE DETAILS -->
                        <div id="transferChequeDetails" style="display: none; background: rgba(99, 102, 241, 0.02); border: 1px dashed rgba(99, 102, 241, 0.15); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Cheque Leaf Identification</h4>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Select Cheque Book Number</label>
                                    <select name="chequeBookNumber" class="form-select account-cheque-books-dropdown" id="transferChequeBookSelect"></select>
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Cheque Number (6 digits)</label>
                                    <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6">
                                </div>
                            </div>
                        </div>

                        <!-- TRANSFER DESTINATION DETAIL CARDS -->
                        <div style="background: rgba(99, 102, 241, 0.02); border: 1px solid rgba(99, 102, 241, 0.08); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px;">Destination Account Details</h4>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Beneficiary Account Number</label>
                                    <input type="text" name="toAccountNumber" class="form-control" required placeholder="Enter destination A/C...">
                                </div>
                                <div class="form-group external-transfer-fields" style="display: none; margin-bottom: 0;">
                                    <label class="form-label">Beneficiary Name</label>
                                    <input type="text" name="toHolderName" class="form-control" placeholder="John Doe">
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;" class="external-transfer-fields" style="display: none;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">IFSC Code</label>
                                    <input type="text" name="toIfscCode" class="form-control" placeholder="SBIN0001234" maxlength="11">
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Bank Name</label>
                                    <input type="text" name="toBankName" class="form-control" placeholder="State Bank of India">
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Branch Name</label>
                                    <input type="text" name="toBranchName" class="form-control" placeholder="Main Branch">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Memo / Description</label>
                            <input type="text" name="description" class="form-control" placeholder="Teller Transfer Description" value="Counter Fund Transfer">
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
                                <select name="loanId" class="form-select" id="loanSelect" required>
                                    <!-- Populated dynamically -->
                                </select>
                            </div>
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Repayment Amount (INR)</label>
                                <input type="number" name="amount" class="form-control" id="loanRepayAmount" required min="1" placeholder="Enter amount...">
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Payment Method</label>
                                <select name="method" class="form-select" id="loanPaymentMethodSelect">
                                    <option value="cash">Counter Cash Payment</option>
                                    <option value="account">Debit VGB Account Balance</option>
                                    <option value="cheque">Cheque-based Payment</option>
                                </select>
                            </div>
                            <div class="form-group" id="loanAccountSelectField" style="display: none; margin-bottom: 0;">
                                <label class="form-label">Source VGB Account Number</label>
                                <input type="text" id="loanSourceAccInput" class="form-control" placeholder="Enter account to debit...">
                                <input type="hidden" name="accountId" id="loanSourceAccountId">
                                <div id="loanChequeDetails" style="display: none; margin-top: 15px; border-top: 1px dashed rgba(99,102,241,0.15); padding-top: 15px;">
                                    <label class="form-label" style="font-size: 0.75rem;">Select Cheque Book</label>
                                    <select name="chequeBookNumber" class="form-select" id="loanChequeBookSelect" style="padding: 8px 12px; font-size: 0.8rem; margin-bottom: 10px;"></select>
                                    <label class="form-label" style="font-size: 0.75rem;">Cheque Number (6 digits)</label>
                                    <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6" style="padding: 8px 12px; font-size: 0.8rem;">
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
                                <select name="cardId" class="form-select" id="cardSelect" required>
                                    <!-- Populated dynamically -->
                                </select>
                            </div>
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Payment Amount (INR)</label>
                                <input type="number" name="amount" class="form-control" id="cardRepayAmount" required min="1" placeholder="Enter amount...">
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Payment Method</label>
                                <select name="method" class="form-select" id="cardPaymentMethodSelect">
                                    <option value="cash">Counter Cash Payment</option>
                                    <option value="account">Debit VGB Account Balance</option>
                                    <option value="cheque">Cheque-based Payment</option>
                                </select>
                            </div>
                            <div class="form-group" id="cardAccountSelectField" style="display: none; margin-bottom: 0;">
                                <label class="form-label">Source VGB Account Number</label>
                                <input type="text" id="cardSourceAccInput" class="form-control" placeholder="Enter account to debit...">
                                <input type="hidden" name="accountId" id="cardSourceAccountId">
                                <div id="cardChequeDetails" style="display: none; margin-top: 15px; border-top: 1px dashed rgba(99,102,241,0.15); padding-top: 15px;">
                                    <label class="form-label" style="font-size: 0.75rem;">Select Cheque Book</label>
                                    <select name="chequeBookNumber" class="form-select" id="cardChequeBookSelect" style="padding: 8px 12px; font-size: 0.8rem; margin-bottom: 10px;"></select>
                                    <label class="form-label" style="font-size: 0.75rem;">Cheque Number (6 digits)</label>
                                    <input type="text" name="chequeNumber" class="form-control" placeholder="000123" pattern="\d{6}" maxlength="6" style="padding: 8px 12px; font-size: 0.8rem;">
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit"><i class="bx bx-check-double"></i> Complete Payment</button>
                    </form>
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
            toast.className = `toast-card ${isError ? 'error' : ''}`;
            
            const icon = document.createElement('i');
            icon.className = `bx ${isError ? 'bx-error-circle' : 'bx-badge-check'} toast-icon`;
            
            const text = document.createElement('span');
            text.style.fontWeight = '500';
            text.innerText = message;
            
            toast.appendChild(icon);
            toast.appendChild(text);
            container.appendChild(toast);
            
            setTimeout(() => toast.classList.add('show'), 50);
            
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 400);
            }, 4000);
        }

        // --- TAB SWITCHING ---
        const tabs = document.querySelectorAll('.tab-btn');
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                
                const tabId = tab.getAttribute('data-tab');
                document.querySelectorAll('.tab-content-pane').forEach(pane => {
                    pane.classList.remove('active');
                });
                document.getElementById(tabId).classList.add('active');
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
                fetch(`${pageContext.request.contextPath}/cash-counter?action=search&query=${encodeURIComponent(query)}`)
                    .then(res => res.json())
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
                            div.innerHTML = `
                                <div>
                                    <strong style="color: var(--gray-800);">${item.firstName} ${item.lastName}</strong>
                                    <span style="color: var(--gray-400); font-size: 0.8rem; margin-left: 10px;">Phone: ${item.phoneNo}</span>
                                </div>
                                <span style="font-family: monospace; font-size: 0.85rem; font-weight: 700; color: var(--primary-500); background: rgba(99, 102, 241, 0.06); padding: 3px 8px; border-radius: var(--radius-sm);">${item.accountNumber}</span>
                            `;
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
            document.getElementById('summaryAvatar').src = account.avatarPath || '${pageContext.request.contextPath}/assest/img/avatars/default.png';
            document.getElementById('summaryName').innerText = `${account.firstName} ${account.lastName}`;
            document.getElementById('summaryDetails').innerText = `Customer ID: #CUST-${account.customerId} | Email: ${account.email} | Phone: +91 ${account.phoneNo}`;
            document.getElementById('summaryAccNo').innerText = account.accountNumber;
            document.getElementById('summaryAccType').innerText = account.accountType;
            document.getElementById('summaryAccBalance').innerText = `₹ ${parseFloat(account.balance).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
            
            document.getElementById('customerSummaryCard').style.display = 'block';

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
                        opt.innerText = `${cb.chequebookNumber} (Leaves: ${cb.startChequeNo} to ${cb.endChequeNo})`;
                        dropdown.appendChild(opt);
                    });
                } else {
                    dropdown.innerHTML = '<option value="">No Active Cheque Books Found</option>';
                }
            });

            // Populate Loan Select
            const loanSelect = document.getElementById('loanSelect');
            loanSelect.innerHTML = '';
            document.getElementById('loanCustomerId').value = account.customerId;
            if (account.loans && account.loans.length > 0) {
                account.loans.forEach(loan => {
                    const opt = document.createElement('option');
                    opt.value = loan.loanId;
                    opt.setAttribute('data-bal', loan.remainingBalance);
                    opt.innerText = `#LN-${loan.loanId} (${loan.loanType}) - Outstanding: ₹${parseFloat(loan.remainingBalance).toLocaleString('en-IN')}`;
                    loanSelect.appendChild(opt);
                });
                updateLoanRepayMax();
            } else {
                loanSelect.innerHTML = '<option value="">No Active Loans Found</option>';
            }

            // Populate Card Select
            const cardSelect = document.getElementById('cardSelect');
            cardSelect.innerHTML = '';
            if (account.cards && account.cards.length > 0) {
                account.cards.forEach(card => {
                    const opt = document.createElement('option');
                    opt.value = card.cardId;
                    opt.setAttribute('data-bal', card.outstandingBalance);
                    opt.innerText = `${card.cardNumber} (${card.cardTier}) - Dues: ₹${parseFloat(card.outstandingBalance).toLocaleString('en-IN')}`;
                    cardSelect.appendChild(opt);
                });
                updateCardRepayMax();
            } else {
                cardSelect.innerHTML = '<option value="">No Active Credit Cards Found</option>';
            }

            document.getElementById('transactionTabsContainer').style.display = 'block';
            showToast(`Loaded account desk for ${account.firstName} ${account.lastName}.`);
        }

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
                fetch(`${pageContext.request.contextPath}/cash-counter?action=search&query=${encodeURIComponent(accNum)}`)
                    .then(res => res.json())
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
                fetch(`${pageContext.request.contextPath}/cash-counter?action=search&query=${encodeURIComponent(accNum)}`)
                    .then(res => res.json())
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
                loanRepayInput.placeholder = `Max ₹${bal.toLocaleString('en-IN')}`;
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
                fetch(`${pageContext.request.contextPath}/cash-counter?action=search&query=${encodeURIComponent(accNum)}`)
                    .then(res => res.json())
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
                cardRepayInput.placeholder = `Max ₹${bal.toLocaleString('en-IN')}`;
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

                // Append header CSRF if present
                const headers = {
                    'Content-Type': 'application/x-www-form-urlencoded'
                };

                fetch(form.action, {
                    method: 'POST',
                    headers: headers,
                    body: params.toString()
                })
                .then(res => {
                    if (res.ok) {
                        return res.json();
                    } else {
                        return res.json().then(err => { throw new Error(err.error || 'Transaction failed') });
                    }
                })
                .then(data => {
                    showToast(data.message || 'Transaction executed successfully!');
                    form.reset();
                    // Hide cheque/account fields if they were open
                    if (depCheque) depCheque.style.display = 'none';
                    if (wthCheque) wthCheque.style.display = 'none';
                    if (trsfCheque) trsfCheque.style.display = 'none';
                    if (loanAccField) loanAccField.style.display = 'none';
                    if (cardAccField) cardAccField.style.display = 'none';

                    // Re-fetch the current selected customer account to update details and balance
                    if (currentSelectedAccount) {
                        const accNo = currentSelectedAccount.accountNumber;
                        fetch(`${pageContext.request.contextPath}/cash-counter?action=search&query=${encodeURIComponent(accNo)}`)
                            .then(r => r.json())
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
                });
            });
        });

    </script>
</body>
</html>
