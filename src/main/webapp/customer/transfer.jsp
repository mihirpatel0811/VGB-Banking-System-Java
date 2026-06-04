<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Transfer Funds</title>
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
        .portal-tab-btn {
            padding: 12px 25px !important;
            font-weight: 600 !important;
            border-radius: var(--radius-md) !important;
            cursor: pointer !important;
            border: 1.5px solid rgba(99, 102, 241, 0.15) !important;
            background: rgba(255, 255, 255, 0.75) !important;
            color: var(--gray-600) !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
            backdrop-filter: blur(10px) !important;
            box-shadow: var(--shadow-sm) !important;
        }
        
        body.dark-mode .portal-tab-btn {
            background: rgba(30, 41, 59, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            color: var(--gray-300) !important;
        }

        .portal-tab-btn:hover {
            border-color: var(--primary-400) !important;
            color: var(--primary-500) !important;
            transform: translateY(-3px) scale(1.02) !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.15) !important;
            background: rgba(99, 102, 241, 0.05) !important;
        }
        
        body.dark-mode .portal-tab-btn:hover {
            background: rgba(99, 102, 241, 0.1) !important;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3) !important;
        }

        .portal-tab-btn.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            border-color: transparent !important;
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3), 0 0 15px rgba(236, 72, 153, 0.2) !important;
            transform: translateY(-2px) !important;
        }
        
        body.dark-mode .portal-tab-btn.active {
            box-shadow: 0 10px 25px rgba(99, 102, 241, 0.35), 0 0 15px rgba(236, 72, 153, 0.25) !important;
        }
        .portal-form-section {
            display: none;
        }
        .portal-form-section.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
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
            <a href="${pageContext.request.contextPath}/account?action=transferPage" class="active"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
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
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Digital Operations Portal</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Transfer funds or request cash counter withdrawals through our secure digital gateway.</p>
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

            <!-- Portal Tab Navigation Bar -->
            <div style="display: flex; gap: 15px; margin-bottom: 30px; flex-wrap: wrap;">
                <button type="button" id="tabBtnTransfer" onclick="showPortalTab('transfer')" class="portal-tab-btn active">
                    <i class="bx bx-send"></i> Fund Transfer
                </button>
                <button type="button" id="tabBtnWithdraw" onclick="showPortalTab('withdraw')" class="portal-tab-btn">
                    <i class="bx bx-down-arrow-circle"></i> Cash Withdrawal
                </button>
                <button type="button" id="tabBtnCardDeposit" onclick="showPortalTab('cardDeposit')" class="portal-tab-btn">
                    <i class="bx bx-credit-card-front"></i> Card Deposit
                </button>
                <button type="button" id="tabBtnAddBeneficiary" onclick="showPortalTab('addBeneficiary')" class="portal-tab-btn">
                    <i class="bx bx-user-plus"></i> Add Beneficiary
                </button>
            </div>

            <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 30px;" class="mobile-grid-1">
                <!-- Portal Workspace -->
                <div class="glass-card">
                    
                    <!-- SECTION 1: FUND TRANSFER -->
                    <div id="secTransfer" class="portal-form-section active">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-send"></i> New Transfer Request
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=transfer" method="post" onsubmit="return validateTransferForm(event)">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Source Account Select Dropdown -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="transferSourceAccount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account</label>
                                <select id="transferSourceAccount" name="fromAccountId" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- ATM Card payment checkbox -->
                            <div class="form-group" style="margin-bottom: 20px; background: rgba(99, 102, 241, 0.05); padding: 12px; border-radius: var(--radius-md); border: 1.5px dashed rgba(99, 102, 241, 0.2);">
                                <label style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primary-500); cursor: pointer; margin-bottom: 0;">
                                    <input type="checkbox" id="transferUseCard" name="useCard" value="true" onchange="toggleTransferCardFields()" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                    <span>Pay using active VGB ATM Card (Debit/Credit)</span>
                                </label>
                                
                                <div id="transferCardFields" style="display: none; margin-top: 15px; border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px;">
                                    <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 15px; margin-bottom: 10px;" class="mobile-grid-1">
                                        <div>
                                            <label for="transferCardId" style="display: block; font-size: 0.8rem; font-weight: 500; color: var(--gray-700); margin-bottom: 5px;">Select Card</label>
                                            <select id="transferCardId" name="cardId" class="form-select" style="margin-top: 0; width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md);">
                                                <c:forEach items="${cards}" var="card">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <option value="${card.cardId}">
                                                            ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div>
                                            <label for="transferCardCvv" style="display: block; font-size: 0.8rem; font-weight: 500; color: var(--gray-700); margin-bottom: 5px;">Enter 3-Digit CVV</label>
                                            <input type="password" maxlength="3" id="transferCardCvv" name="cvv" placeholder="•••" class="form-input" style="margin-top: 0; font-family: monospace; width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md);">
                                        </div>
                                    </div>
                                    <span style="font-size: 0.75rem; color: var(--gray-400);"><i class="bx bx-info-circle"></i> Selecting a card overrides the source account selection. Standard card limits will apply.</span>
                                </div>
                            </div>

                            <!-- Destination Type Selector -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transfer Destination Type</label>
                                <div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; color: var(--gray-600); cursor: pointer;">
                                        <input type="radio" name="destType" value="own" checked onclick="toggleDestType('own')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Another Account of Yours (Internal)</span>
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; color: var(--gray-600); cursor: pointer;">
                                        <input type="radio" name="destType" value="p2p" onclick="toggleDestType('p2p')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Other Customer's Account (P2P)</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Target Own Account Dropdown (Active by default) -->
                            <div class="form-group" id="containerInternalTarget" style="margin-bottom: 20px;">
                                <label for="toAccountIdInternal" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Destination Account</label>
                                <select id="toAccountIdInternal" name="toAccountId" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Target Other Customer Beneficiary Dropdown (Disabled/Hidden by default) -->
                            <div class="form-group" id="containerExternalTarget" style="margin-bottom: 20px; display: none;">
                                <label for="toAccountIdExternal" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Saved Customer Beneficiary</label>
                                <select id="toAccountIdExternal" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                    <c:forEach items="${beneficiaries}" var="ben">
                                        <option value="${ben.nomineeName}">
                                            ${ben.customerName} - ${ben.accountNumber} (${ben.accountType}) [IFSC: ${ben.ifscCode}]
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Transfer Amount -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="amount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Amount to Transfer (INR)</label>
                                <input type="number" step="0.01" min="100" id="amount" name="amount" required placeholder="Min. ₹100" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="description" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" id="description" name="description" placeholder="E.g., Rent, Family Support" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit">
                                <span>Authenticate Transfer</span>
                                <i class="bx bx-shield-quarter"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 2: CASH WITHDRAWAL -->
                    <div id="secWithdraw" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-down-arrow-circle"></i> Counter Cash Withdrawal
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=withdraw" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Source Account Select Dropdown -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="withdrawSourceAccount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Source Account</label>
                                <select id="withdrawSourceAccount" name="accountId" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- ATM Card withdraw checkbox -->
                            <div class="form-group" style="margin-bottom: 20px; background: rgba(99, 102, 241, 0.05); padding: 12px; border-radius: var(--radius-md); border: 1.5px dashed rgba(99, 102, 241, 0.2);">
                                <label style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primary-500); cursor: pointer; margin-bottom: 0;">
                                    <input type="checkbox" id="withdrawUseCard" name="useCard" value="true" onchange="toggleWithdrawCardFields()" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                    <span>Withdraw using active VGB ATM Card (Debit/Credit)</span>
                                </label>
                                
                                <div id="withdrawCardFields" style="display: none; margin-top: 15px; border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px;">
                                    <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 15px; margin-bottom: 10px;" class="mobile-grid-1">
                                        <div>
                                            <label for="withdrawCardId" style="display: block; font-size: 0.8rem; font-weight: 500; color: var(--gray-700); margin-bottom: 5px;">Select Card</label>
                                            <select id="withdrawCardId" name="cardId" class="form-select" style="margin-top: 0; width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md);">
                                                <c:forEach items="${cards}" var="card">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <option value="${card.cardId}">
                                                            ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div>
                                            <label for="withdrawCardCvv" style="display: block; font-size: 0.8rem; font-weight: 500; color: var(--gray-700); margin-bottom: 5px;">Enter 3-Digit CVV</label>
                                            <input type="password" maxlength="3" id="withdrawCardCvv" name="cvv" placeholder="•••" class="form-input" style="margin-top: 0; font-family: monospace; width: 100%; padding: 8px 12px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md);">
                                        </div>
                                    </div>
                                    <span style="font-size: 0.75rem; color: var(--gray-400);"><i class="bx bx-info-circle"></i> Selecting a card overrides the source account selection. Standard card limits will apply.</span>
                                </div>
                            </div>

                            <!-- Withdrawal Amount -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="withdrawAmount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Amount to Withdraw (INR)</label>
                                <input type="number" step="0.01" min="100" id="withdrawAmount" name="amount" required placeholder="Min. ₹100" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="withdrawDescription" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" id="withdrawDescription" name="description" placeholder="E.g., Self counter cash withdrawal" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit">
                                <span>Process Cash Withdrawal</span>
                                <i class="bx bx-check-shield"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 2A: CARD DEPOSIT -->
                    <div id="secCardDeposit" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-credit-card-front"></i> VGB ATM Card Deposit
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=deposit" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="useCard" value="true">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Target/Link select card -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="depositCardId" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Card to Charge</label>
                                <select id="depositCardId" name="cardId" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                    <c:forEach items="${cards}" var="card">
                                        <c:if test="${card.status eq 'active'}">
                                            <option value="${card.cardId}">
                                                ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- CVV -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="depositCardCvv" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Card Security Code (3-Digit CVV)</label>
                                <input type="password" maxlength="3" id="depositCardCvv" name="cvv" required placeholder="•••" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-family: monospace;">
                            </div>

                            <!-- Deposit Amount -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="depositAmount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Amount to Deposit (INR)</label>
                                <input type="number" step="0.01" min="100" id="depositAmount" name="amount" required placeholder="Min. ₹100" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="depositDescription" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Transaction Description</label>
                                <input type="text" id="depositDescription" name="description" placeholder="E.g., Self card deposit" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-submit">
                                <span>Process Card Deposit</span>
                                <i class="bx bx-check-double"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 3: ADD BENEFICIARY -->
                    <div id="secAddBeneficiary" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-user-plus"></i> Register New Beneficiary
                        </h3>
                        
                        <div id="beneficiaryAlertContainer" style="display: none; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.875rem; align-items: center; gap: 10px;">
                            <i class="bx" id="beneficiaryAlertIcon" style="font-size: 1.2rem;"></i>
                            <span id="beneficiaryAlertMessage"></span>
                        </div>

                        <form id="addBeneficiaryForm" onsubmit="event.preventDefault(); return performBeneficiaryValidation();">
                            <!-- Beneficiary Bank Type Selection -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Beneficiary Bank Type</label>
                                <div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--primary-500); cursor: pointer;">
                                        <input type="radio" name="benBankType" value="vgb" checked onclick="toggleBenBankType('vgb')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Vertex Galaxy Bank (VGB) Customer</span>
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--primary-500); cursor: pointer;">
                                        <input type="radio" name="benBankType" value="other" onclick="toggleBenBankType('other')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Other Bank Customer</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Account Holder Name (Only shown for Other Bank) -->
                            <div class="form-group" id="containerBenHolderName" style="margin-bottom: 20px; display: none;">
                                <label for="benHolderName" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Account Holder Name (Required)</label>
                                <input type="text" id="benHolderName" placeholder="Enter recipient's full name" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <!-- Beneficiary Account Number -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="benAccountNumber" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Beneficiary Account Number</label>
                                <input type="text" id="benAccountNumber" required placeholder="Enter account number (e.g. 100087654321)" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <!-- Beneficiary IFSC -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label for="benIfscCode" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Branch IFSC Code</label>
                                <input type="text" id="benIfscCode" required placeholder="Enter 11-digit IFSC code (e.g. VGBK0000001)" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-family: monospace;">
                            </div>

                            <!-- Nickname Reference -->
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="benNickName" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Account Holder Name / Nickname Reference (Optional)</label>
                                <input type="text" id="benNickName" placeholder="E.g. Business Account, John Doe" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>

                            <button type="submit" id="btnValidateBeneficiary" class="btn btn-secondary" style="padding: 12px 25px;">
                                <span>Verify Account Details</span>
                                <i class="bx bx-check-double"></i>
                            </button>
                        </form>

                        <!-- Dynamically Injected Verification Result Preview Card -->
                        <div id="containerVerificationPreview" style="display: none; margin-top: 30px; padding: 20px; border-radius: var(--radius-md); background: rgba(16, 185, 129, 0.05); border: 1.5px dashed #10b981; animation: fadeIn 0.4s ease;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 15px;">
                                <h4 style="font-size: 1.05rem; font-weight: 700; color: #047857;"><i class="bx bx-badge-check"></i> Account Verified Successfully</h4>
                                <i class="bx bxs-check-circle" style="color: #10b981; font-size: 1.8rem;"></i>
                            </div>
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px;" class="mobile-grid-1">
                                <div>
                                    <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Verified Account Holder</span>
                                    <strong id="previewHolderName" style="display: block; font-size: 0.95rem; color: var(--gray-800); margin-top: 3px;"></strong>
                                </div>
                                <div>
                                    <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Branch Routing IFSC</span>
                                    <strong id="previewIfscCode" style="display: block; font-size: 0.95rem; color: var(--gray-800); margin-top: 3px; font-family: monospace;"></strong>
                                </div>
                                <div>
                                    <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">Account Number</span>
                                    <strong id="previewAccountNumber" style="display: block; font-size: 0.95rem; color: var(--gray-800); margin-top: 3px; font-family: monospace;"></strong>
                                </div>
                                <div>
                                    <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 600;">System Account Type</span>
                                    <strong id="previewAccountType" style="display: block; font-size: 0.95rem; color: var(--gray-800); margin-top: 3px; text-transform: uppercase;"></strong>
                                </div>
                            </div>

                            <button type="button" id="btnSaveBeneficiary" onclick="performBeneficiarySave()" class="btn btn-primary">
                                <span>Save Beneficiary to Directory</span>
                                <i class="bx bx-save"></i>
                            </button>
                        </div>
                    </div>

                </div>

                <!-- Guidelines Card -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <div class="glass-card" style="background: rgba(99, 102, 241, 0.05);">
                        <h4 style="font-size: 1rem; font-weight: 700; color: var(--primary-500); margin-bottom: 10px;"><i class="bx bx-info-circle"></i> Service Routing Limits</h4>
                        <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            - Minimum counter withdrawal / transfer is **₹100**.<br>
                            - Saved Beneficiary routing maps accounts securely with real-time verification.<br>
                            - Ensure beneficiary account numbers match exactly to lock dynamic ledger clearances.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function showPortalTab(tab) {
            const tabTransfer = document.getElementById('tabBtnTransfer');
            const tabWithdraw = document.getElementById('tabBtnWithdraw');
            const tabCardDeposit = document.getElementById('tabBtnCardDeposit');
            const tabAddBeneficiary = document.getElementById('tabBtnAddBeneficiary');
            const secTransfer = document.getElementById('secTransfer');
            const secWithdraw = document.getElementById('secWithdraw');
            const secCardDeposit = document.getElementById('secCardDeposit');
            const secAddBeneficiary = document.getElementById('secAddBeneficiary');

            // Reset active classes
            tabTransfer.classList.remove('active');
            tabWithdraw.classList.remove('active');
            if (tabCardDeposit) tabCardDeposit.classList.remove('active');
            tabAddBeneficiary.classList.remove('active');
            secTransfer.classList.remove('active');
            secWithdraw.classList.remove('active');
            if (secCardDeposit) secCardDeposit.classList.remove('active');
            secAddBeneficiary.classList.remove('active');

            if (tab === 'transfer') {
                tabTransfer.classList.add('active');
                secTransfer.classList.add('active');
            } else if (tab === 'withdraw') {
                tabWithdraw.classList.add('active');
                secWithdraw.classList.add('active');
            } else if (tab === 'cardDeposit') {
                if (tabCardDeposit) tabCardDeposit.classList.add('active');
                if (secCardDeposit) secCardDeposit.classList.add('active');
            } else {
                tabAddBeneficiary.classList.add('active');
                secAddBeneficiary.classList.add('active');
            }
        }

        function toggleTransferCardFields() {
            const useCard = document.getElementById('transferUseCard').checked;
            const fieldsDiv = document.getElementById('transferCardFields');
            const cardIdSelect = document.getElementById('transferCardId');
            const cvvInput = document.getElementById('transferCardCvv');
            if (useCard) {
                fieldsDiv.style.display = 'block';
                cardIdSelect.required = true;
                cvvInput.required = true;
            } else {
                fieldsDiv.style.display = 'none';
                cardIdSelect.required = false;
                cvvInput.required = false;
            }
        }

        function toggleWithdrawCardFields() {
            const useCard = document.getElementById('withdrawUseCard').checked;
            const fieldsDiv = document.getElementById('withdrawCardFields');
            const cardIdSelect = document.getElementById('withdrawCardId');
            const cvvInput = document.getElementById('withdrawCardCvv');
            if (useCard) {
                fieldsDiv.style.display = 'block';
                cardIdSelect.required = true;
                cvvInput.required = true;
            } else {
                fieldsDiv.style.display = 'none';
                cardIdSelect.required = false;
                cvvInput.required = false;
            }
        }

        function toggleDestType(type) {
            const internalSelect = document.getElementById('toAccountIdInternal');
            const externalSelect = document.getElementById('toAccountIdExternal');
            const internalContainer = document.getElementById('containerInternalTarget');
            const externalContainer = document.getElementById('containerExternalTarget');

            if (type === 'own') {
                internalContainer.style.display = 'block';
                internalSelect.name = 'toAccountId';
                internalSelect.disabled = false;
                internalSelect.required = true;

                externalContainer.style.display = 'none';
                externalSelect.removeAttribute('name');
                externalSelect.disabled = true;
                externalSelect.required = false;
            } else {
                externalContainer.style.display = 'block';
                externalSelect.name = 'toAccountId';
                externalSelect.disabled = false;
                externalSelect.required = true;

                internalContainer.style.display = 'none';
                internalSelect.removeAttribute('name');
                internalSelect.disabled = true;
                internalSelect.required = false;
            }
        }

        function validateTransferForm(event) {
            const fromAcc = document.getElementById('transferSourceAccount').value;
            const destType = document.querySelector('input[name="destType"]:checked').value;
            
            if (destType === 'own') {
                const toAcc = document.getElementById('toAccountIdInternal').value;
                if (fromAcc === toAcc) {
                    event.preventDefault();
                    alert("Self-transfer Error: Source account and destination account cannot be the same. Please select a different destination account.");
                    return false;
                }
            }
            return true;
        }

        // Beneficiary AJAX Operations
        let verifiedAccountId = 0;

        function showBeneficiaryAlert(message, type) {
            const container = document.getElementById('beneficiaryAlertContainer');
            const icon = document.getElementById('beneficiaryAlertIcon');
            const msgSpan = document.getElementById('beneficiaryAlertMessage');

            container.style.display = 'flex';
            msgSpan.textContent = message;

            if (type === 'success') {
                container.style.background = 'rgba(16, 185, 129, 0.1)';
                container.style.borderLeft = '4px solid #10b981';
                container.style.color = '#047857';
                icon.className = 'bx bx-check-circle';
            } else {
                container.style.background = 'rgba(239, 68, 68, 0.1)';
                container.style.borderLeft = '4px solid #ef4444';
                container.style.color = '#b91c1c';
                icon.className = 'bx bx-error-circle';
            }
        }

        function hideBeneficiaryAlert() {
            document.getElementById('beneficiaryAlertContainer').style.display = 'none';
        }

        function toggleBenBankType(type) {
            const holderNameContainer = document.getElementById('containerBenHolderName');
            const holderNameInput = document.getElementById('benHolderName');
            
            if (type === 'other') {
                holderNameContainer.style.display = 'block';
                holderNameInput.required = true;
            } else {
                holderNameContainer.style.display = 'none';
                holderNameInput.required = false;
            }
        }

        function performBeneficiaryValidation() {
            const accNum = document.getElementById('benAccountNumber').value.trim();
            const ifsc = document.getElementById('benIfscCode').value.trim();
            const previewContainer = document.getElementById('containerVerificationPreview');
            const benType = document.querySelector('input[name="benBankType"]:checked').value;
            const holderName = document.getElementById('benHolderName').value.trim();

            hideBeneficiaryAlert();
            previewContainer.style.display = 'none';
            verifiedAccountId = 0;

            const btn = document.getElementById('btnValidateBeneficiary');
            btn.disabled = true;
            btn.querySelector('span').textContent = 'Validating Ledger Record...';

            let url = '${pageContext.request.contextPath}/account?action=verifyBeneficiary' + 
                      '&beneficiaryType=' + encodeURIComponent(benType) + 
                      '&accountNumber=' + encodeURIComponent(accNum) + 
                      '&ifscCode=' + encodeURIComponent(ifsc);
            
            if (benType === 'other') {
                url += '&holderName=' + encodeURIComponent(holderName);
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    btn.disabled = false;
                    btn.querySelector('span').textContent = 'Verify Account Details';

                    if (data.valid) {
                        verifiedAccountId = data.accountId;
                        
                        document.getElementById('previewHolderName').textContent = data.customerName;
                        document.getElementById('previewIfscCode').textContent = data.ifscCode;
                        document.getElementById('previewAccountNumber').textContent = data.accountNumber;
                        document.getElementById('previewAccountType').textContent = data.accountType;

                        previewContainer.style.display = 'block';
                    } else {
                        showBeneficiaryAlert(data.message || 'Validation failed. No matching ledger accounts found.', 'error');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.querySelector('span').textContent = 'Verify Account Details';
                    showBeneficiaryAlert('Network connection error during verification: ' + error, 'error');
                });

            return false;
        }

        function performBeneficiarySave() {
            const benType = document.querySelector('input[name="benBankType"]:checked').value;
            if (benType === 'vgb' && verifiedAccountId === 0) return;

            const btn = document.getElementById('btnSaveBeneficiary');
            btn.disabled = true;
            btn.querySelector('span').textContent = 'Registering with core routing...';

            const csrfToken = '${sessionScope.csrfToken}';
            const accNum = document.getElementById('previewAccountNumber').textContent;
            const ifsc = document.getElementById('previewIfscCode').textContent;
            const holderName = document.getElementById('previewHolderName').textContent;
            const nickname = document.getElementById('benNickName').value.trim();

            let bodyParams = 'csrfToken=' + encodeURIComponent(csrfToken) + 
                             '&beneficiaryType=' + encodeURIComponent(benType) + 
                             '&beneficiaryAccountId=' + encodeURIComponent(verifiedAccountId) + 
                             '&accountNumber=' + encodeURIComponent(accNum) + 
                             '&ifscCode=' + encodeURIComponent(ifsc) + 
                             '&holderName=' + encodeURIComponent(holderName) + 
                             '&nickname=' + encodeURIComponent(nickname);

            fetch('${pageContext.request.contextPath}/account?action=saveBeneficiary', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: bodyParams
            })
                .then(response => response.json())
                .then(data => {
                    btn.disabled = false;
                    btn.querySelector('span').textContent = 'Save Beneficiary to Directory';

                    if (data.success) {
                        showBeneficiaryAlert(data.message || 'Beneficiary saved and locked successfully.', 'success');
                        document.getElementById('containerVerificationPreview').style.display = 'none';
                        document.getElementById('addBeneficiaryForm').reset();
                        document.getElementById('containerBenHolderName').style.display = 'none';
                        verifiedAccountId = 0;
                        
                        // Dynamically refresh select box options in the background
                        refreshBeneficiaryList();
                    } else {
                        showBeneficiaryAlert(data.message || 'Failed to save beneficiary.', 'error');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.querySelector('span').textContent = 'Save Beneficiary to Directory';
                    showBeneficiaryAlert('Network save error: ' + error, 'error');
                });
        }

        function refreshBeneficiaryList() {
            fetch('${pageContext.request.contextPath}/account?action=transferPage')
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const newSelect = doc.getElementById('toAccountIdExternal');
                    
                    if (newSelect) {
                        const targetSelect = document.getElementById('toAccountIdExternal');
                        targetSelect.innerHTML = newSelect.innerHTML;
                    }
                })
                .catch(err => console.error('Error refreshing beneficiaries directory:', err));
        }
    </script>
</body>
</html>
