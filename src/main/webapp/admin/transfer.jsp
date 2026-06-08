<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.vgb.service.AccountService" %>
<%@ page import="com.vgb.service.LoanService" %>
<%@ page import="com.vgb.service.CustomerService" %>
<%@ page import="com.vgb.model.Account" %>
<%@ page import="com.vgb.model.Loan" %>
<%@ page import="com.vgb.model.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    AccountService accountService = new AccountService();
    List<Account> allAccounts = accountService.getAllAccounts();
    request.setAttribute("allAccounts", allAccounts);

    LoanService loanService = new LoanService();
    List<Loan> allLoans = loanService.getAllLoans();
    request.setAttribute("allLoans", allLoans);

    CustomerService customerService = new CustomerService();
    List<Customer> allCustomers = customerService.getAllCustomers();
    Map<Long, String> customerNames = new HashMap<>();
    for (Customer c : allCustomers) {
        customerNames.put(c.getCustomerId(), c.getFullName());
    }
    request.setAttribute("customerNames", customerNames);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Admin Teller Counter</title>
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
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 30px;
            box-shadow: var(--shadow-md);
            margin-bottom: 30px;
            animation: fadeIn 0.4s ease;
        }

        /* Teller Tab styling */
        .counter-tabs {
            display: flex;
            gap: 15px;
            border-bottom: 1.5px solid var(--gray-200);
            padding-bottom: 15px;
            margin-bottom: 35px;
        }
        .counter-tab-btn {
            padding: 12px 24px;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-500);
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .counter-tab-btn:hover {
            background: var(--gray-50);
            color: var(--primary-500);
            border-color: var(--primary-500);
        }
        .counter-tab-btn.active {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);
        }

        .counter-pane {
            display: none;
        }
        .counter-pane.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }

        /* Two-Column Layout */
        .counter-grid {
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 40px;
        }
        @media (max-width: 991px) {
            .counter-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }

        /* Live ticking clock style */
        .counter-clock-card {
            background: rgba(99, 102, 241, 0.03);
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: var(--radius-md);
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }
        .clock-icon-wrapper {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: rgba(99, 102, 241, 0.08);
            color: var(--primary-500);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }
        .clock-label {
            display: block;
            font-size: 0.72rem;
            color: var(--gray-400);
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .clock-display {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gray-700);
            font-family: monospace;
            margin-top: 2px;
        }
        .clock-pulse {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10b981;
            position: absolute;
            top: 18px;
            right: 18px;
            box-shadow: 0 0 8px #10b981;
            animation: clockPulse 1.5s infinite;
        }
        @keyframes clockPulse {
            0% { transform: scale(0.9); opacity: 0.6; }
            50% { transform: scale(1.2); opacity: 1; box-shadow: 0 0 12px #10b981; }
            100% { transform: scale(0.9); opacity: 0.6; }
        }

        /* Search Autocomplete selects */
        .search-select-wrapper {
            position: relative;
            margin-bottom: 20px;
        }
        .search-select-input {
            width: 100%;
            padding: 12px 15px 12px 40px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            font-weight: 500;
            background: white;
            font-size: 0.9rem;
            transition: all var(--transition-normal);
        }
        .search-select-input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3.5px rgba(99, 102, 241, 0.08);
        }
        .search-select-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.15rem;
        }
        .search-select-arrow {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.15rem;
            pointer-events: none;
            transition: transform 0.3s ease;
        }
        .search-select-wrapper.active .search-select-arrow {
            transform: translateY(-50%) rotate(180deg);
        }
        .search-select-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            z-index: 1000;
            max-height: 230px;
            overflow-y: auto;
            margin-top: 6px;
            display: none;
            animation: paneFadeIn 0.22s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .search-select-item {
            padding: 12px 15px;
            cursor: pointer;
            border-bottom: 1px solid var(--gray-100);
            display: flex;
            flex-direction: column;
            gap: 4px;
            transition: background 0.2s ease;
        }
        .search-select-item:hover {
            background: rgba(99, 102, 241, 0.03);
        }
        .search-select-item-title {
            font-weight: 600;
            color: var(--gray-800);
            font-size: 0.85rem;
        }
        .search-select-item-subtitle {
            font-size: 0.75rem;
            color: var(--gray-400);
            font-family: monospace;
        }
        .search-select-empty {
            padding: 18px;
            color: var(--gray-400);
            text-align: center;
            font-size: 0.85rem;
        }

        /* Verified Details Card visuals */
        .verified-preview-card {
            background: white;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        .verified-preview-card.selected {
            border-color: rgba(16, 185, 129, 0.25);
            background: rgba(16, 185, 129, 0.01);
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.03);
        }
        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.7rem;
            font-weight: 700;
            background: rgba(16, 185, 129, 0.08);
            color: var(--accent-emerald);
            padding: 4px 8px;
            border-radius: 4px;
            text-transform: uppercase;
            margin-bottom: 15px;
        }
        .wire-transfer-arrow {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 15px 0;
            color: var(--primary-500);
            font-size: 2rem;
            animation: bounceArrow 1.5s infinite;
        }
        @keyframes bounceArrow {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(6px); }
        }

        /* Real-Time alerts styling inside verified columns */
        .counter-alert-warning {
            background: rgba(245, 158, 11, 0.08);
            border-left: 4px solid #f59e0b;
            color: #b45309;
            padding: 12px 15px;
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            font-weight: 500;
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideIn 0.3s ease;
        }
        .counter-alert-danger {
            background: rgba(239, 68, 68, 0.08);
            border-left: 4px solid #ef4444;
            color: #b91c1c;
            padding: 12px 15px;
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            font-weight: 500;
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideIn 0.3s ease;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-5px); }
            to { opacity: 1; transform: translateY(0); }
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
    <script>
        // Fail-safe preloader removal
        (function() {
            var hide = function() {
                var p = document.querySelector('.preloader');
                if (p) {
                    p.classList.add('hidden');
                    document.body.style.overflow = 'auto';
                }
            };
            if (document.readyState === 'complete') {
                hide();
            } else {
                window.addEventListener('load', hide);
                // Hard timeout safety: remove preloader after 1.5 seconds under all conditions
                setTimeout(hide, 1500);
            }
        })();
    </script>

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
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp" class="active"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
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
            <div style="margin-bottom: 35px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Administrative Teller Desk</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Post physical counter deposits, withdrawals, or system wire routing tasks directly.</p>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty sessionScope.error or not empty error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 15px; border-radius: var(--radius-md); margin-bottom: 25px; font-size: 0.9rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-error-circle" style="font-size: 1.3rem;"></i>
                    <span>${not empty error ? error : sessionScope.error}</span>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.success or not empty success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 15px; border-radius: var(--radius-md); margin-bottom: 25px; font-size: 0.9rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-check-circle" style="font-size: 1.3rem;"></i>
                    <span>${not empty success ? success : sessionScope.success}</span>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <!-- Counter Tabs Switchers -->
            <div class="counter-tabs">
                <button type="button" class="counter-tab-btn active" id="btnTabDeposit" onclick="switchCounterPane('deposit')">
                    <i class="bx bx-down-arrow-alt"></i> <span>Cash Deposit</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabWithdraw" onclick="switchCounterPane('withdraw')">
                    <i class="bx bx-up-arrow-alt"></i> <span>Cash Withdrawal</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabTransfer" onclick="switchCounterPane('transfer')">
                    <i class="bx bx-transfer"></i> <span>Funds Transfer</span>
                </button>
                <button type="button" class="counter-tab-btn" id="btnTabLoanRepay" onclick="switchCounterPane('loanrepay')">
                    <i class="bx bx-credit-card"></i> <span>Loan Repayment</span>
                </button>
            </div>

            <!-- PANE 1: Cash Deposit -->
            <div class="counter-pane active" id="paneDeposit">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-down-arrow-alt"></i> Counter Cash Deposit
                        </h3>
                        
                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=deposit" method="post" id="formDeposit" onsubmit="return validateDepositForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="accountId" id="hidDepositAccId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Target Account</label>
                                <div class="search-select-wrapper" id="selectDepositAccWrapper">
                                    <input type="text" class="search-select-input" id="txtDepositAcc" placeholder="Type customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownDepositAcc"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Deposit Amount (INR)</label>
                                <input type="number" step="0.01" min="500" name="amount" id="numDepositAmt" required placeholder="Min. ₹500" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcDepositPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Audit Description</label>
                                <input type="text" name="description" id="txtDepositDesc" value="Teller counter cash load" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" style="width: 100%;">Post Deposit Amount</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Target Profile</h4>
                        
                        <div class="verified-preview-card" id="cardDepositPreview">
                            <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Awaiting Account Selection</div>
                            <p style="color: var(--gray-400); font-size: 0.85rem; text-align: center; padding: 30px 0;">Please search and choose a target account in the left panel to verify details.</p>
                        </div>
                        
                        <div id="depositAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 2: Cash Withdrawal -->
            <div class="counter-pane" id="paneWithdraw">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-up-arrow-alt"></i> Counter Cash Withdrawal
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=withdraw" method="post" id="formWithdraw" onsubmit="return validateWithdrawForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="accountId" id="hidWithdrawAccId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account</label>
                                <div class="search-select-wrapper" id="selectWithdrawAccWrapper">
                                    <input type="text" class="search-select-input" id="txtWithdrawAcc" placeholder="Type customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownWithdrawAcc"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Withdrawal Amount (INR)</label>
                                <input type="number" step="0.01" min="100" name="amount" id="numWithdrawAmt" required placeholder="Max. ₹3,00,000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcWithdrawPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Audit Description</label>
                                <input type="text" name="description" id="txtWithdrawDesc" value="Teller counter cash payout" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" id="btnSubmitWithdraw" style="width: 100%;">Post Withdrawal Amount</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Source Profile</h4>

                        <div class="verified-preview-card" id="cardWithdrawPreview">
                            <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Awaiting Account Selection</div>
                            <p style="color: var(--gray-400); font-size: 0.85rem; text-align: center; padding: 30px 0;">Please search and choose a source account in the left panel to verify details.</p>
                        </div>

                        <div id="withdrawAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 3: Funds Transfer -->
            <div class="counter-pane" id="paneTransfer">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-transfer"></i> Counter Funds Transfer
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/account?action=transfer" method="post" id="formTransfer" onsubmit="return validateTransferForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="fromAccountId" id="hidTransferFromId">
                            <input type="hidden" name="toAccountId" id="hidTransferToId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account (From)</label>
                                <div class="search-select-wrapper" id="selectTransferFromWrapper">
                                    <input type="text" class="search-select-input" id="txtTransferFrom" placeholder="Type source customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownTransferFrom"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Target Account (To)</label>
                                <div class="search-select-wrapper" id="selectTransferToWrapper">
                                    <input type="text" class="search-select-input" id="txtTransferTo" placeholder="Type target customer name or account number..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownTransferTo"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transfer Amount (INR)</label>
                                <input type="number" step="0.01" min="1" name="amount" id="numTransferAmt" required placeholder="Max. ₹3,50,000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcTransferPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Audit Description</label>
                                <input type="text" name="description" id="txtTransferDesc" value="Teller counter bank transfer" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" id="btnSubmitTransfer" style="width: 100%;">Post Funds Transfer</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Wire Route</h4>

                        <!-- Stacked panels representing wire flow -->
                        <div id="transferRouteContainer">
                            <div class="verified-preview-card" id="cardTransferSourcePreview" style="margin-bottom: 10px;">
                                <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Source Awaiting</div>
                                <p style="color: var(--gray-400); font-size: 0.82rem; text-align: center; padding: 10px 0;">Select source account.</p>
                            </div>

                            <div class="wire-transfer-arrow" id="transferVisualArrow" style="display: none;">
                                <i class="bx bx-down-arrow-alt"></i>
                            </div>

                            <div class="verified-preview-card" id="cardTransferTargetPreview">
                                <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Target Awaiting</div>
                                <p style="color: var(--gray-400); font-size: 0.82rem; text-align: center; padding: 10px 0;">Select target account.</p>
                            </div>
                        </div>

                        <div id="transferAlertContainer"></div>
                    </div>
                </div>
            </div>

            <!-- PANE 4: Loan Repayment -->
            <div class="counter-pane" id="paneLoanRepay">
                <div class="counter-grid">
                    <!-- Left: Form -->
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-credit-card"></i> Counter Loan Repayment
                        </h3>

                        <div class="counter-clock-card">
                            <div class="clock-icon-wrapper"><i class="bx bx-time-five"></i></div>
                            <div>
                                <span class="clock-label">Active Counter Session Time</span>
                                <div class="clock-display">Fetching system time...</div>
                            </div>
                            <div class="clock-pulse"></div>
                        </div>

                        <form action="${pageContext.request.contextPath}/loan?action=repayment" method="post" id="formLoanRepay" onsubmit="return validateLoanRepayForm()">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="loanId" id="hidRepayLoanId">
                            <input type="hidden" name="customerId" id="hidRepayCustomerId">
                            <input type="hidden" name="redirectUrl" value="/admin/transfer.jsp">

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Active Loan Profile</label>
                                <div class="search-select-wrapper" id="selectRepayLoanWrapper">
                                    <input type="text" class="search-select-input" id="txtRepayLoan" placeholder="Type customer name, loan ID or type..." autocomplete="off">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownRepayLoan"></div>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Customer Account to Debit</label>
                                <select name="accountId" id="repayAccount" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none; font-size: 0.9rem;" onchange="recalcLoanRepayPayout()">
                                    <option value="">-- Select Active Account --</option>
                                </select>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Repayment Amount (INR)</label>
                                <input type="number" step="0.01" min="1" name="amount" id="numRepayAmt" required placeholder="E.g., 5000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;" oninput="recalcLoanRepayPayout()">
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Audit Description</label>
                                <input type="text" name="description" id="txtRepayDesc" value="Teller counter loan repayment" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-size: 0.9rem;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit" style="width: 100%;">Post Loan Repayment</button>
                        </form>
                    </div>

                    <!-- Right: Verified Preview -->
                    <div style="display: flex; flex-direction: column;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-700); margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px;">Verified Loan Ledger</h4>

                        <div class="verified-preview-card" id="cardLoanRepayPreview">
                            <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Awaiting Loan Selection</div>
                            <p style="color: var(--gray-400); font-size: 0.85rem; text-align: center; padding: 30px 0;">Please search and select a loan portfolio in the left panel to verify details.</p>
                        </div>

                        <div id="loanRepayAlertContainer"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <!-- Account Database JSON Serialization (safely decoupled to avoid syntax parse warnings) -->
    <script id="accounts-data" type="application/json">
        [
            <c:forEach var="acc" items="${allAccounts}" varStatus="status">
                {
                    "accountId": "${acc.accountId}",
                    "customerId": "${acc.customerId}",
                    "accountNumber": "${acc.accountNumber}",
                    "accountType": "${acc.accountType}",
                    "balance": "${acc.balance != null ? acc.balance : 0.0}",
                    "status": "${acc.status}",
                    "customerName": "<c:out value="${acc.customerName}" />",
                    "businessName": "<c:out value="${acc.businessName}" />",
                    "ifscCode": "${acc.ifscCode != null ? acc.ifscCode : 'VGBK0000001'}"
                }${status.last ? '' : ','}
            </c:forEach>
        ]
    </script>
    
    <!-- Loans Database JSON Serialization (safely decoupled to avoid syntax parse warnings) -->
    <script id="loans-data" type="application/json">
        [
            <c:set var="firstLoan" value="true" />
            <c:forEach var="loan" items="${allLoans}">
                <c:if test="${loan.status == 'active' or loan.status == 'disbursed'}">
                    <c:if test="${not firstLoan}">,</c:if>
                    {
                        "loanId": "${loan.loanId}",
                        "customerId": "${loan.customerId}",
                        "customerName": "<c:out value="${customerNames[loan.customerId]}" />",
                        "loanType": "${loan.loanType}",
                        "principalAmount": "${loan.principalAmount}",
                        "remainingBalance": "${loan.remainingBalance}",
                        "status": "${loan.status}"
                    }
                    <c:set var="firstLoan" value="false" />
                </c:if>
            </c:forEach>
        ]
    </script>

    <script>
        const allAccounts = JSON.parse(document.getElementById('accounts-data').textContent);
        allAccounts.forEach(acc => {
            acc.balance = parseFloat(acc.balance) || 0.0;
        });
        const allLoans = JSON.parse(document.getElementById('loans-data').textContent);
        allLoans.forEach(loan => {
            loan.remainingBalance = parseFloat(loan.remainingBalance) || 0.0;
            loan.principalAmount = parseFloat(loan.principalAmount) || 0.0;
        });

        // Active State Selected Trackers
        let selectedDepositAcc = null;
        let selectedWithdrawAcc = null;
        let selectedTransferFrom = null;
        let selectedTransferTo = null;
        let selectedRepayLoan = null;

        // Switched tab controls
        function switchCounterPane(paneType) {
            document.querySelectorAll('.counter-pane').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.counter-tab-btn').forEach(el => el.classList.remove('active'));

            if (paneType === 'deposit') {
                document.getElementById('paneDeposit').classList.add('active');
                document.getElementById('btnTabDeposit').classList.add('active');
            } else if (paneType === 'withdraw') {
                document.getElementById('paneWithdraw').classList.add('active');
                document.getElementById('btnTabWithdraw').classList.add('active');
            } else if (paneType === 'transfer') {
                document.getElementById('paneTransfer').classList.add('active');
                document.getElementById('btnTabTransfer').classList.add('active');
            } else if (paneType === 'loanrepay') {
                document.getElementById('paneLoanRepay').classList.add('active');
                document.getElementById('btnTabLoanRepay').classList.add('active');
            }
        }

        // Dropdown autocompletes builder
        function setupAutocomplete(inputId, dropdownId, hiddenInputId, wrapperId, onSelectCallback) {
            const input = document.getElementById(inputId);
            const dropdown = document.getElementById(dropdownId);
            const hidden = document.getElementById(hiddenInputId);
            const wrapper = document.getElementById(wrapperId);

            if (!input || !dropdown || !hidden || !wrapper) return;

            input.addEventListener('focus', () => {
                wrapper.classList.add('active');
                renderResults(input.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            input.addEventListener('input', (e) => {
                renderResults(e.target.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            document.addEventListener('click', (e) => {
                if (!wrapper.contains(e.target)) {
                    wrapper.classList.remove('active');
                    dropdown.style.display = 'none';
                }
            });
        }

        function renderResults(query, dropdown, input, hidden, wrapper, onSelectCallback) {
            const q = query.toLowerCase().trim();
            dropdown.innerHTML = '';

            const filtered = allAccounts.filter(acc => {
                if (acc.status !== 'active') return false;
                const numMatch = acc.accountNumber.toLowerCase().includes(q);
                const custMatch = acc.customerName.toLowerCase().includes(q);
                const busMatch = acc.businessName.toLowerCase().includes(q);
                return numMatch || custMatch || busMatch;
            });

            if (filtered.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'search-select-empty';
                empty.innerText = 'No matching active accounts found';
                dropdown.appendChild(empty);
            } else {
                filtered.forEach(acc => {
                    const item = document.createElement('div');
                    item.className = 'search-select-item';

                    const title = document.createElement('span');
                    title.className = 'search-select-item-title';
                    const ownerName = acc.businessName ? acc.businessName + ' (Business)' : acc.customerName;
                    title.innerText = ownerName + ' | ' + acc.accountType.toUpperCase();

                    const subtitle = document.createElement('span');
                    subtitle.className = 'search-select-item-subtitle';
                    subtitle.innerText = 'Acc: ' + acc.accountNumber + ' | Bal: ₹' + acc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 });

                    item.appendChild(title);
                    item.appendChild(subtitle);

                    item.addEventListener('click', () => {
                        input.value = ownerName + ' (' + acc.accountNumber + ')';
                        hidden.value = acc.accountId;
                        dropdown.style.display = 'none';
                        wrapper.classList.remove('active');
                        if (onSelectCallback) onSelectCallback(acc);
                    });

                    dropdown.appendChild(item);
                });
            }

            dropdown.style.display = 'block';
        }

        // Live Clock Initializer
        function initLiveClocks() {
            const displays = document.querySelectorAll('.clock-display');
            function tick() {
                const now = new Date();
                const optDate = { day: '2-digit', month: 'short', year: 'numeric' };
                const dateStr = now.toLocaleDateString('en-IN', optDate).replace(/ /g, '-');
                const timeStr = now.toLocaleTimeString('en-IN', { hour12: false });
                displays.forEach(el => {
                    el.innerText = dateStr + ' ' + timeStr;
                });
            }
            setInterval(tick, 1000);
            tick();
        }

        // 1. Recalculate Payouts
        function recalcDepositPayout() {
            const amtVal = parseFloat(document.getElementById('numDepositAmt').value) || 0;
            const container = document.getElementById('depositAlertContainer');
            container.innerHTML = '';

            if (!selectedDepositAcc) return;

            const card = document.getElementById('cardDepositPreview');
            const ownerName = selectedDepositAcc.businessName ? selectedDepositAcc.businessName + ' (Business)' : selectedDepositAcc.customerName;
            const newBal = selectedDepositAcc.balance + amtVal;

            card.innerHTML = `
                <div class="verified-badge"><i class="bx bx-shield-quarter"></i> Verified Target Account</div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Owner Name</span>
                        <strong style="color: var(--gray-800); font-size: 0.9rem;">\${ownerName}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Number</span>
                        <strong style="color: var(--gray-800); font-family: monospace; font-size: 0.9rem;">\${selectedDepositAcc.accountNumber}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Type</span>
                        <strong style="color: var(--gray-700); font-size: 0.85rem; text-transform: capitalize;">\${selectedDepositAcc.accountType}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">IFSC Code</span>
                        <strong style="color: var(--gray-700); font-family: monospace; font-size: 0.85rem;">\${selectedDepositAcc.ifscCode}</strong>
                    </div>
                    <div style="grid-column: span 2; border-top: 1px solid var(--gray-100); padding-top: 12px; margin-top: 5px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <span style="display: block; font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Balance</span>
                            <span style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">₹ \${selectedDepositAcc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</span>
                        </div>
                        <div style="text-align: right;">
                            <span style="display: block; font-size: 0.72rem; color: var(--primary-400); text-transform: uppercase; font-weight: 600;">Balance Post-Deposit</span>
                            <strong style="color: var(--accent-emerald); font-size: 1.15rem;">₹ \${newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                    </div>
                </div>
            `;
            card.classList.add('selected');
        }

        function recalcWithdrawPayout() {
            const amtVal = parseFloat(document.getElementById('numWithdrawAmt').value) || 0;
            const alertContainer = document.getElementById('withdrawAlertContainer');
            alertContainer.innerHTML = '';

            if (!selectedWithdrawAcc) return;

            const card = document.getElementById('cardWithdrawPreview');
            const ownerName = selectedWithdrawAcc.businessName ? selectedWithdrawAcc.businessName + ' (Business)' : selectedWithdrawAcc.customerName;
            const newBal = selectedWithdrawAcc.balance - amtVal;

            card.innerHTML = `
                <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-shield-quarter"></i> Verified Source Account</div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Owner Name</span>
                        <strong style="color: var(--gray-800); font-size: 0.9rem;">\${ownerName}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Number</span>
                        <strong style="color: var(--gray-800); font-family: monospace; font-size: 0.9rem;">\${selectedWithdrawAcc.accountNumber}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Account Type</span>
                        <strong style="color: var(--gray-700); font-size: 0.85rem; text-transform: capitalize;">\${selectedWithdrawAcc.accountType}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">IFSC Code</span>
                        <strong style="color: var(--gray-700); font-family: monospace; font-size: 0.85rem;">\${selectedWithdrawAcc.ifscCode}</strong>
                    </div>
                    <div style="grid-column: span 2; border-top: 1px solid var(--gray-100); padding-top: 12px; margin-top: 5px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <span style="display: block; font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Balance</span>
                            <span style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">₹ \${selectedWithdrawAcc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</span>
                        </div>
                        <div style="text-align: right;">
                            <span style="display: block; font-size: 0.72rem; color: var(--primary-400); text-transform: uppercase; font-weight: 600;">Remaining Balance</span>
                            <strong style="color: \${newBal < 0 ? '#ef4444' : 'var(--gray-800)'}; font-size: 1.1rem;">₹ \${newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                    </div>
                </div>
            `;
            card.classList.add('selected');

            // Limit warning checks
            if (amtVal > 300000) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Withdrawal limit exceeded (Max ₹3,00,000 per cash transaction).</span>
                    </div>
                `;
            } else if (amtVal > selectedWithdrawAcc.balance) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-danger">
                        <i class="bx bx-error-circle"></i>
                        <span>Insufficient funds (Amount exceeds available counter balance).</span>
                    </div>
                `;
            }
        }

        function recalcTransferPayout() {
            const amtVal = parseFloat(document.getElementById('numTransferAmt').value) || 0;
            const alertContainer = document.getElementById('transferAlertContainer');
            alertContainer.innerHTML = '';

            const sourceCard = document.getElementById('cardTransferSourcePreview');
            const targetCard = document.getElementById('cardTransferTargetPreview');
            const arrow = document.getElementById('transferVisualArrow');

            if (selectedTransferFrom) {
                const ownerName = selectedTransferFrom.businessName ? selectedTransferFrom.businessName + ' (Business)' : selectedTransferFrom.customerName;
                const newBal = selectedTransferFrom.balance - amtVal;
                
                sourceCard.innerHTML = `
                    <div class="verified-badge" style="background: rgba(99,102,241,0.08); color: var(--primary-500);"><i class="bx bx-log-out"></i> Verified Source Account (Debit)</div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
                        <div style="grid-column: span 2;">
                            <span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Owner / Number</span>
                            <strong style="font-size: 0.85rem; color: var(--gray-800);">\${ownerName} (\${selectedTransferFrom.accountNumber})</strong>
                        </div>
                        <div>
                            <span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Balance</span>
                            <strong style="font-size: 0.85rem; color: var(--gray-700);">₹ \${selectedTransferFrom.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                        <div style="text-align: right;">
                            <span style="display: block; font-size: 0.7rem; color: var(--primary-400); text-transform: uppercase;">Remaining</span>
                            <strong style="font-size: 0.88rem; color: \${newBal < 0 ? '#ef4444' : 'var(--gray-800)'};">₹ \${newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                    </div>
                `;
                sourceCard.classList.add('selected');
            }

            if (selectedTransferTo) {
                const ownerName = selectedTransferTo.businessName ? selectedTransferTo.businessName + ' (Business)' : selectedTransferTo.customerName;
                const newBal = selectedTransferTo.balance + amtVal;

                targetCard.innerHTML = `
                    <div class="verified-badge" style="background: rgba(16,185,129,0.08); color: var(--accent-emerald);"><i class="bx bx-log-in"></i> Verified Target Account (Credit)</div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
                        <div style="grid-column: span 2;">
                            <span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Owner / Number</span>
                            <strong style="font-size: 0.85rem; color: var(--gray-800);">\${ownerName} (\${selectedTransferTo.accountNumber})</strong>
                        </div>
                        <div>
                            <span style="display: block; font-size: 0.7rem; color: var(--gray-400); text-transform: uppercase;">Balance</span>
                            <strong style="font-size: 0.85rem; color: var(--gray-700);">₹ \${selectedTransferTo.balance.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                        <div style="text-align: right;">
                            <span style="display: block; font-size: 0.7rem; color: var(--primary-400); text-transform: uppercase;">Post-Credit</span>
                            <strong style="font-size: 0.88rem; color: var(--accent-emerald);">₹ \${newBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                    </div>
                `;
                targetCard.classList.add('selected');
            }

            if (selectedTransferFrom && selectedTransferTo) {
                arrow.style.display = 'flex';
                
                if (selectedTransferFrom.accountId === selectedTransferTo.accountId) {
                    alertContainer.innerHTML = `
                        <div class="counter-alert-danger">
                            <i class="bx bx-error-circle"></i>
                            <span>Source and target accounts must be different.</span>
                        </div>
                    `;
                    return;
                }
            }

            // Transfer Limits check
            if (amtVal > 350000) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Transfer limit exceeded (Max ₹3,50,000 per routing wire transaction).</span>
                    </div>
                `;
            } else if (selectedTransferFrom && amtVal > selectedTransferFrom.balance) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-danger">
                        <i class="bx bx-error-circle"></i>
                        <span>Insufficient funds in source account.</span>
                    </div>
                `;
            }
        }

        // Form Submit Validators
        function validateDepositForm() {
            if (!selectedDepositAcc) {
                shakePane('paneDeposit');
                alert("Please select a target active account profile.");
                return false;
            }
            return true;
        }

        function validateWithdrawForm() {
            if (!selectedWithdrawAcc) {
                shakePane('paneWithdraw');
                alert("Please select a source active account profile.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numWithdrawAmt').value) || 0;
            if (amtVal > 300000) {
                shakePane('paneWithdraw');
                alert("Withdrawal amount cannot exceed ₹3,00,000.");
                return false;
            }
            if (amtVal > selectedWithdrawAcc.balance) {
                shakePane('paneWithdraw');
                alert("Insufficient available balance for this payout.");
                return false;
            }
            return true;
        }

        function validateTransferForm() {
            if (!selectedTransferFrom || !selectedTransferTo) {
                shakePane('paneTransfer');
                alert("Please choose both source and target active accounts.");
                return false;
            }
            if (selectedTransferFrom.accountId === selectedTransferTo.accountId) {
                shakePane('paneTransfer');
                alert("Source and target accounts must be different.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numTransferAmt').value) || 0;
            if (amtVal > 350000) {
                shakePane('paneTransfer');
                alert("Transfer amount cannot exceed ₹3,50,000.");
                return false;
            }
            if (amtVal > selectedTransferFrom.balance) {
                shakePane('paneTransfer');
                alert("Insufficient funds in the source account for transfer.");
                return false;
            }
            return true;
        }

        function shakePane(id) {
            const pane = document.getElementById(id);
            if (pane) {
                pane.classList.add('shake-input');
                setTimeout(() => {
                    pane.classList.remove('shake-input');
                }, 500);
            }
        }

        // ===== LOAN REPAYMENT TELLER METHODS =====
        function populateRepayAccounts(customerId) {
            const select = document.getElementById('repayAccount');
            select.innerHTML = '<option value="">-- Select Active Account --</option>';

            const customerAccounts = allAccounts.filter(acc => acc.customerId.toString() === customerId.toString() && acc.status.toLowerCase() === 'active');

            if (customerAccounts.length === 0) {
                const opt = document.createElement('option');
                opt.value = "";
                opt.textContent = "No active accounts found for this customer";
                select.appendChild(opt);
            } else {
                customerAccounts.forEach(acc => {
                    const opt = document.createElement('option');
                    opt.value = acc.accountId;
                    opt.textContent = "Account #" + acc.accountNumber + " (" + acc.accountType.toUpperCase() + ") - Bal: ₹" + parseFloat(acc.balance).toLocaleString('en-IN', { minimumFractionDigits: 2 });
                    select.appendChild(opt);
                });
            }
        }

        function recalcLoanRepayPayout() {
            const amtVal = parseFloat(document.getElementById('numRepayAmt').value) || 0;
            const alertContainer = document.getElementById('loanRepayAlertContainer');
            alertContainer.innerHTML = '';

            const select = document.getElementById('repayAccount');
            const selectedAccId = select.value;
            const selectedAcc = allAccounts.find(acc => acc.accountId.toString() === selectedAccId.toString());

            if (!selectedRepayLoan) return;

            const card = document.getElementById('cardLoanRepayPreview');
            const remBal = parseFloat(selectedRepayLoan.remainingBalance);
            const postRepayBal = remBal - amtVal;

            let accountDetailsHTML = '';
            if (selectedAcc) {
                const accBal = parseFloat(selectedAcc.balance);
                const postAccBal = accBal - amtVal;
                accountDetailsHTML = `
                    <div style="grid-column: span 2; border-top: 1px dashed var(--gray-200); padding-top: 10px; margin-top: 5px;">
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Selected Source Account Details</span>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 5px;">
                            <span style="font-size: 0.85rem; color: var(--gray-600); font-family: monospace;">Acc #\${selectedAcc.accountNumber}</span>
                            <span style="font-size: 0.85rem; color: \${postAccBal < 0 ? '#ef4444' : 'var(--gray-800)'}; font-weight: 600;">
                                ₹ \${accBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })} ➡️ ₹ \${postAccBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}
                            </span>
                        </div>
                    </div>
                `;

                if (amtVal > accBal) {
                    alertContainer.innerHTML = `
                        <div class="counter-alert-danger">
                            <i class="bx bx-error-circle"></i>
                            <span>Insufficient funds (Amount exceeds source account balance).</span>
                        </div>
                    `;
                }
            }

            card.innerHTML = `
                <div class="verified-badge" style="background: rgba(16, 185, 129, 0.08); color: var(--accent-emerald);"><i class="bx bx-shield-quarter"></i> Verified Loan Profile</div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Borrower Name</span>
                        <strong style="color: var(--gray-800); font-size: 0.9rem;">\${selectedRepayLoan.customerName}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Loan Account ID</span>
                        <strong style="color: var(--gray-800); font-family: monospace; font-size: 0.9rem;">#LN-\${selectedRepayLoan.loanId}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Loan Category</span>
                        <strong style="color: var(--gray-700); font-size: 0.85rem; text-transform: capitalize;">\${selectedRepayLoan.loanType}</strong>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Status</span>
                        <strong style="color: var(--primary-500); font-size: 0.85rem; text-transform: uppercase;">\${selectedRepayLoan.status}</strong>
                    </div>
                    <div style="grid-column: span 2; border-top: 1px solid var(--gray-100); padding-top: 12px; margin-top: 5px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <span style="display: block; font-size: 0.72rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Remaining Balance</span>
                            <span style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">₹ \${remBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</span>
                        </div>
                        <div style="text-align: right;">
                            <span style="display: block; font-size: 0.72rem; color: var(--primary-400); text-transform: uppercase; font-weight: 600;">Balance Post-Repayment</span>
                            <strong style="color: \${postRepayBal < 0 ? '#ef4444' : 'var(--gray-800)'}; font-size: 1.15rem;">₹ \${postRepayBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}</strong>
                        </div>
                    </div>
                    \${accountDetailsHTML}
                </div>
            `;
            card.classList.add('selected');

            if (amtVal > remBal) {
                alertContainer.innerHTML = `
                    <div class="counter-alert-warning">
                        <i class="bx bx-error"></i>
                        <span>Amount exceeds remaining loan balance (₹${remBal.toLocaleString('en-IN', { minimumFractionDigits: 2 })}). Extra payment is not allowed.</span>
                    </div>
                `;
            }
        }

        function validateLoanRepayForm() {
            if (!selectedRepayLoan) {
                shakePane('paneLoanRepay');
                alert("Please select an active loan profile.");
                return false;
            }
            const select = document.getElementById('repayAccount');
            if (!select.value) {
                shakePane('paneLoanRepay');
                alert("Please select a customer source checking/savings account to debit.");
                return false;
            }
            const amtVal = parseFloat(document.getElementById('numRepayAmt').value) || 0;
            if (amtVal <= 0) {
                shakePane('paneLoanRepay');
                alert("Please enter a valid repayment amount.");
                return false;
            }
            const remBal = parseFloat(selectedRepayLoan.remainingBalance);
            if (amtVal > remBal) {
                shakePane('paneLoanRepay');
                alert("Repayment amount cannot exceed the remaining loan balance.");
                return false;
            }
            const selectedAcc = allAccounts.find(acc => acc.accountId.toString() === select.value.toString());
            if (selectedAcc && amtVal > parseFloat(selectedAcc.balance)) {
                shakePane('paneLoanRepay');
                alert("Insufficient funds in the selected customer source account.");
                return false;
            }
            return true;
        }

        function renderLoanResults(query, dropdown, input, hidden, wrapper, onSelectCallback) {
            const q = query.toLowerCase().trim();
            dropdown.innerHTML = '';

            const filtered = allLoans.filter(loan => {
                const idMatch = loan.loanId.toLowerCase().includes(q);
                const nameMatch = loan.customerName.toLowerCase().includes(q);
                const typeMatch = loan.loanType.toLowerCase().includes(q);
                return idMatch || nameMatch || typeMatch;
            });

            if (filtered.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'search-select-empty';
                empty.innerText = 'No matching active/disbursed loans found';
                dropdown.appendChild(empty);
            } else {
                filtered.forEach(loan => {
                    const item = document.createElement('div');
                    item.className = 'search-select-item';

                    const title = document.createElement('span');
                    title.className = 'search-select-item-title';
                    title.innerText = loan.customerName + ' | ' + loan.loanType.toUpperCase() + ' LOAN';

                    const subtitle = document.createElement('span');
                    subtitle.className = 'search-select-item-subtitle';
                    subtitle.innerText = 'Loan ID: #LN-' + loan.loanId + ' | Bal: ₹' + parseFloat(loan.remainingBalance).toLocaleString('en-IN', { minimumFractionDigits: 2 });

                    item.appendChild(title);
                    item.appendChild(subtitle);

                    item.addEventListener('click', () => {
                        input.value = loan.customerName + ' (LN-' + loan.loanId + ')';
                        hidden.value = loan.loanId;
                        document.getElementById('hidRepayCustomerId').value = loan.customerId;
                        dropdown.style.display = 'none';
                        wrapper.classList.remove('active');
                        if (onSelectCallback) onSelectCallback(loan);
                    });

                    dropdown.appendChild(item);
                });
            }

            dropdown.style.display = 'block';
        }

        function setupLoanAutocomplete(inputId, dropdownId, hiddenInputId, wrapperId, onSelectCallback) {
            const input = document.getElementById(inputId);
            const dropdown = document.getElementById(dropdownId);
            const hidden = document.getElementById(hiddenInputId);
            const wrapper = document.getElementById(wrapperId);

            if (!input || !dropdown || !hidden || !wrapper) return;

            input.addEventListener('focus', () => {
                wrapper.classList.add('active');
                renderLoanResults(input.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            input.addEventListener('input', (e) => {
                renderLoanResults(e.target.value, dropdown, input, hidden, wrapper, onSelectCallback);
            });

            document.addEventListener('click', (e) => {
                if (!wrapper.contains(e.target)) {
                    wrapper.classList.remove('active');
                    dropdown.style.display = 'none';
                }
            });
        }

        // Document Ready Bindings
        document.addEventListener('DOMContentLoaded', () => {
            initLiveClocks();

            // Set up Autocomplete dropdowns
            setupAutocomplete(
                'txtDepositAcc', 
                'dropdownDepositAcc', 
                'hidDepositAccId', 
                'selectDepositAccWrapper', 
                (acc) => {
                    selectedDepositAcc = acc;
                    recalcDepositPayout();
                }
            );

            setupAutocomplete(
                'txtWithdrawAcc', 
                'dropdownWithdrawAcc', 
                'hidWithdrawAccId', 
                'selectWithdrawAccWrapper', 
                (acc) => {
                    selectedWithdrawAcc = acc;
                    recalcWithdrawPayout();
                }
            );

            setupAutocomplete(
                'txtTransferFrom', 
                'dropdownTransferFrom', 
                'hidTransferFromId', 
                'selectTransferFromWrapper', 
                (acc) => {
                    selectedTransferFrom = acc;
                    recalcTransferPayout();
                }
            );

            setupAutocomplete(
                'txtTransferTo', 
                'dropdownTransferTo', 
                'hidTransferToId', 
                'selectTransferToWrapper', 
                (acc) => {
                    selectedTransferTo = acc;
                    recalcTransferPayout();
                }
            );

            setupLoanAutocomplete(
                'txtRepayLoan',
                'dropdownRepayLoan',
                'hidRepayLoanId',
                'selectRepayLoanWrapper',
                (loan) => {
                    selectedRepayLoan = loan;
                    populateRepayAccounts(loan.customerId);
                    recalcLoanRepayPayout();
                }
            );
        });
    </script>
    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
