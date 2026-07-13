<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Auto Pay Manager</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
    <style>
        .tabs-header {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            border-bottom: 1.5px solid var(--gray-200);
            padding-bottom: 10px;
            flex-wrap: wrap;
        }
        .tab-btn {
            padding: 10px 20px;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-500);
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tab-btn:hover {
            color: var(--primary-500);
        }
        .tab-btn.active {
            color: var(--primary-500);
            border-bottom-color: var(--primary-500);
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Auto pay cards */
        .autopay-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .autopay-card:hover {
            box-shadow: var(--shadow-md);
            border-color: rgba(99, 102, 241, 0.2);
        }
        .autopay-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .autopay-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(99, 102, 241, 0.05);
            color: var(--primary-500);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .autopay-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: var(--radius-full);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .autopay-status-badge.active {
            background: #e6f4ea;
            color: #137333;
        }
        .autopay-status-badge.paused {
            background: #fef3c7;
            color: #d97706;
        }
        .autopay-status-badge.disabled {
            background: #f3f4f6;
            color: #4b5563;
        }
        
        /* Form segmented selector */
        .form-segmented {
            display: flex;
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            padding: 6px;
            border-radius: var(--radius-md);
            gap: 6px;
            margin-bottom: 25px;
        }
        .form-segmented-btn {
            flex: 1;
            padding: 12px;
            text-align: center;
            font-weight: 600;
            border: none;
            background: none;
            color: var(--gray-500);
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .form-segmented-btn.active {
            background: white;
            color: var(--primary-500);
            box-shadow: var(--shadow-sm);
        }

        .notif-card {
            border-left: 4px solid var(--primary-500);
            background: white;
            border: 1px solid var(--gray-200);
            border-left-width: 4px;
            border-radius: var(--radius-md);
            padding: 16px 20px;
            margin-bottom: 15px;
            box-shadow: var(--shadow-sm);
        }
        .notif-card.unread {
            border-left-color: var(--accent-emerald);
            background: rgba(16, 185, 129, 0.01);
        }
        .notif-card.fail {
            border-left-color: #ef4444;
        }
        .text-completed {
            color: var(--accent-emerald);
        }
        .text-failed {
            color: var(--gray-500);
        }
        .text-normal-gray {
            color: var(--gray-600);
        }
        .text-error-red {
            color: #b91c1c;
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
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation"
                style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo"
                style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo"
                    style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty customer && not empty customer.avatarPath}">
                        <img src="${pageContext.request.contextPath}${customer.avatarPath}"
                            alt="Customer Profile Avatar"
                            style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                    </c:when>
                    <c:otherwise>
                        <div
                            style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                            ${customer.firstName.substring(0, 1)}
                        </div>
                    </c:otherwise>
                </c:choose>
                <div style="display: flex; flex-direction: column; text-align: left;"
                    class="mobile-hide">
                    <span
                        style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                    <span
                        style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span
                            style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Customer Space
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
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i
                    class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i
                    class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i
                    class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i
                    class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=history"><i class="bx bx-receipt"></i> Card Repayments</a>
            <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard" class="active"><i
                    class="bx bx-sync"></i> Auto Pay</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i
                    class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i
                    class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i
                    class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i
                    class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i>
                My Profile</a>
        </div>
        <div
            style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Support Hotline</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">
                1800-VGB-BANK</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Auto Pay Center</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Configure automatic payments for your active Credit Cards and Loan EMIs directly from your bank accounts.</p>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Tabs Header -->
            <div class="tabs-header">
                <button type="button" class="tab-btn active" onclick="switchTab(event, 'active-rules')">Active Rules</button>
                <button type="button" class="tab-btn" onclick="switchTab(event, 'setup-autopay')">Setup Auto Pay</button>
                <button type="button" class="tab-btn" onclick="switchTab(event, 'history-logs')">Repayment History</button>
                <button type="button" class="tab-btn" onclick="switchTab(event, 'alert-notifications')">Alerts &amp; Notifications</button>
            </div>

            <!-- TAB 1: ACTIVE RULES -->
            <div id="active-rules" class="tab-content active">
                <c:choose>
                    <c:when test="${not empty instructions}">
                        <c:forEach var="ins" items="${instructions}">
                            <div class="autopay-card">
                                <div class="autopay-info">
                                    <div class="autopay-icon">
                                        <c:choose>
                                            <c:when test="${ins.targetType == 'credit_card'}">
                                                <i class="bx bx-credit-card"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bx bx-home-alt"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <h3 style="font-weight: 700; color: var(--gray-800); margin: 0 0 4px;">
                                            <c:choose>
                                                <c:when test="${ins.targetType == 'credit_card'}">
                                                    Credit Card Bill: ${ins.maskedCardNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    Loan Repayment: ${ins.loanType} (ID: ${ins.loanId})
                                                </c:otherwise>
                                            </c:choose>
                                        </h3>
                                        <p style="font-size: 0.85rem; color: var(--gray-400); margin: 0 0 6px;">
                                            Source: <strong>Account ${ins.maskedSourceAccountNumber}</strong> &bull;
                                            Type: <strong style="text-transform: capitalize;">${ins.paymentType.replace('_', ' ')}</strong>
                                        </p>
                                        <p style="font-size: 0.82rem; color: var(--gray-500); margin: 0;">
                                            Next Payment Date: <span style="font-weight: 600; color: var(--primary-500);">${ins.nextPaymentDate}</span> &bull; 
                                            Last Run: <span>${not empty ins.lastProcessedDate ? ins.lastProcessedDate : 'Never'}</span>
                                        </p>
                                    </div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 15px;">
                                    <span class="autopay-status-badge ${ins.status}">${ins.status}</span>
                                    <div style="display: flex; gap: 8px;">
                                        <c:choose>
                                            <c:when test="${ins.status == 'active'}">
                                                <a href="${pageContext.request.contextPath}/auto-pay?action=pause&id=${ins.autoPayId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); text-decoration: none;">Pause</a>
                                            </c:when>
                                            <c:when test="${ins.status == 'paused'}">
                                                <a href="${pageContext.request.contextPath}/auto-pay?action=resume&id=${ins.autoPayId}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); text-decoration: none;">Resume</a>
                                            </c:when>
                                        </c:choose>
                                        <a href="javascript:void(0)" onclick="confirmCancel('${ins.autoPayId}')" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); text-decoration: none; background: #ef4444; border-color: #ef4444; color: white;">Cancel</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 60px 40px; background: white; border: 1px dashed var(--gray-300); border-radius: var(--radius-lg);">
                            <i class="bx bx-sync" style="font-size: 3rem; color: var(--gray-400); animation: spin 4s linear infinite; display: inline-block;"></i>
                            <h3 style="font-weight: 700; color: var(--gray-700); margin: 15px 0 5px;">No Auto Pay Configurations</h3>
                            <p style="color: var(--gray-400); max-width: 400px; margin: 0 auto 20px; font-size: 0.9rem;">Automate your utility EMI and credit card payments to avoid manual late fees and bills penalty.</p>
                            <button type="button" class="btn btn-primary" onclick="document.querySelector('[onclick*=\'setup-autopay\']').click()" style="padding: 8px 20px; font-weight: 600; border-radius: var(--radius-md);">Configure New Setup</button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- TAB 2: SETUP AUTOPAY FORM -->
            <div id="setup-autopay" class="tab-content">
                <div class="glass-card" style="max-width: 650px; margin: 0 auto; background: white;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px;">Configure Auto Pay</h3>
                    
                    <form action="${pageContext.request.contextPath}/auto-pay?action=create" method="POST" onsubmit="return validateForm()">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">

                        <!-- Segmented selector -->
                        <div class="form-segmented">
                            <button type="button" id="segCC" class="form-segmented-btn active" onclick="setTargetType('credit_card')">Credit Card Bill</button>
                            <button type="button" id="segLoan" class="form-segmented-btn" onclick="setTargetType('loan')">Loan EMI Payment</button>
                        </div>
                        <input type="hidden" name="targetType" id="targetType" value="credit_card">

                        <!-- Source Bank Account selection -->
                        <div style="margin-bottom: 20px;">
                            <label style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase; color: var(--gray-400); display: block; margin-bottom: 6px;">Source Bank Account</label>
                            <select name="sourceAccountId" class="form-control" required style="height: 48px; border: 1.5px solid var(--gray-200);">
                                <option value="" disabled selected>-- Select source savings/current account --</option>
                                <c:forEach var="acc" items="${accounts}">
                                    <option value="${acc.accountId}">VGB ${acc.accountType.toUpperCase()} - Account No: ••••${acc.accountNumber.substring(acc.accountNumber.length() - 4)} (Bal: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Target Credit Card Selection -->
                        <div style="margin-bottom: 20px;" id="ccSelectorGroup">
                            <label style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase; color: var(--gray-400); display: block; margin-bottom: 6px;">Target Credit Card</label>
                            <select name="cardId" id="cardId" class="form-control" style="height: 48px; border: 1.5px solid var(--gray-200);">
                                <option value="" disabled selected>-- Select Credit Card --</option>
                                <c:forEach var="c" items="${cards}">
                                    <option value="${c.cardId}" data-outstanding="${c.outstandingBalance}">${c.cardTier.toUpperCase()} ${c.cardProvider.toUpperCase()} - ${c.getMaskedCardNumber()} (Outstanding: ₹<fmt:formatNumber value="${c.outstandingBalance}" minFractionDigits="2" maxFractionDigits="2"/>)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Target Loan Selection -->
                        <div style="margin-bottom: 20px; display: none;" id="loanSelectorGroup">
                            <label style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase; color: var(--gray-400); display: block; margin-bottom: 6px;">Target Loan Account</label>
                            <select name="loanId" id="loanId" class="form-control" style="height: 48px; border: 1.5px solid var(--gray-200);" onchange="updateEMIInfo(this)">
                                <option value="" disabled selected>-- Select Loan Account --</option>
                                <c:forEach var="l" items="${loans}">
                                    <option value="${l.loanId}" data-emi="${l.getMonthlyEMI()}" data-outstanding="${l.remainingBalance}">VGB ${l.loanType.toUpperCase()} Loan - Reference: #LN-${l.loanId} (Remaining: ₹<fmt:formatNumber value="${l.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/>)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Payment Type Selection -->
                        <div style="margin-bottom: 20px;">
                            <label style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase; color: var(--gray-400); display: block; margin-bottom: 6px;">Payment Mode / Type</label>
                            <select name="paymentType" id="paymentType" class="form-control" required style="height: 48px; border: 1.5px solid var(--gray-200);">
                                <option value="" disabled selected>-- Select payment mode --</option>
                                <option value="full_amount_due" class="cc-only">Full Outstanding Amount Due</option>
                                <option value="minimum_due" class="cc-only">Minimum Amount Due (5% of outstanding dues, min ₹500)</option>
                                <option value="monthly_emi" class="loan-only" style="display: none;">Monthly EMI Component Repayment</option>
                            </select>
                            <div id="emiInfoBox" style="display: none; margin-top: 10px; background: rgba(99, 102, 241, 0.05); padding: 12px 16px; border-radius: var(--radius-sm); border-left: 4px solid var(--primary-500); font-size: 0.85rem; font-weight: 600; color: var(--primary-600);">
                                Calculated Loan Monthly EMI: ₹<span id="lblCalculatedEMI">0.00</span>
                            </div>
                        </div>

                        <!-- First Run / Start Date selection -->
                        <div style="margin-bottom: 25px;">
                            <label style="font-size: 0.8rem; font-weight: 600; text-transform: uppercase; color: var(--gray-400); display: block; margin-bottom: 6px;">First Payment Run Date</label>
                            <input type="date" name="startDate" id="startDate" class="form-control" required style="height: 48px; border: 1.5px solid var(--gray-200);" min="">
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-weight: 700; border-radius: var(--radius-md);">Register Auto Pay Instructions</button>
                    </form>
                </div>
            </div>

            <!-- TAB 3: HISTORY LOGS -->
            <div id="history-logs" class="tab-content">
                <div class="glass-card" style="background: white; padding: 0;">
                    <div style="padding: 20px; border-bottom: 1.5px solid var(--gray-100);">
                        <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--gray-800); margin: 0;">Auto Pay Execution Ledger</h3>
                    </div>
                    <div style="overflow-x: auto;">
                        <table style="width: 100%; border-collapse: collapse; text-align: left;">
                            <thead>
                                <tr>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Date &amp; Time</th>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Payment Target</th>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Source Account</th>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Payment Mode</th>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Amount Paid</th>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Status</th>
                                    <th style="padding: 15px 20px; font-size: 0.72rem; text-transform: uppercase; font-weight: 700; color: var(--gray-400); border-bottom: 2.5px solid var(--gray-100);">Txn Reference / Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty historyList}">
                                        <c:forEach var="h" items="${historyList}">
                                            <tr style="border-bottom: 1px solid var(--gray-100); transition: background-color 0.2s;">
                                                <td style="padding: 16px 20px; font-size: 0.85rem; color: var(--gray-700);"><fmt:formatDate value="${h.paymentDate}" pattern="dd MMM yyyy, hh:mm a"/></td>
                                                <td style="padding: 16px 20px; font-size: 0.85rem; font-weight: 600; color: var(--gray-800);">
                                                    <c:choose>
                                                        <c:when test="${h.targetType == 'credit_card'}">
                                                            Credit Card ${h.maskedCardNumber}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Loan: ${h.loanType} (ID: ${h.autoPayId})
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 16px 20px; font-size: 0.85rem; color: var(--gray-600);">${h.maskedSourceAccountNumber}</td>
                                                <td style="padding: 16px 20px; font-size: 0.82rem; font-weight: 600; text-transform: capitalize; color: var(--gray-600);">${h.paymentType.replace('_', ' ')}</td>
                                                <td class="${h.status == 'completed' ? 'text-completed' : 'text-failed'}" style="padding: 16px 20px; font-size: 0.85rem; font-weight: 700;">
                                                    <c:choose>
                                                        <c:when test="${h.status == 'completed'}">
                                                            ₹<fmt:formatNumber value="${h.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            --
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 16px 20px; font-size: 0.85rem;">
                                                    <span class="autopay-status-badge ${h.status}">${h.status}</span>
                                                </td>
                                                <td class="${h.status == 'completed' ? 'text-normal-gray' : 'text-error-red'}" style="padding: 16px 20px; font-size: 0.85rem;">
                                                    <c:choose>
                                                        <c:when test="${h.status == 'completed'}">
                                                            <span style="font-family: monospace; font-weight: 600;">${h.transactionReference}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${h.failureReason}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--gray-400);">No auto payments executed yet.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Paginator -->
                    <c:if test="${totalPages > 1}">
                        <div class="paginator-container">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard&page=${currentPage - 1}" class="paginator-btn"><i class="bx bx-chevron-left"></i> Prev</a>
                            </c:if>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard&page=${p}" class="paginator-btn ${currentPage == p ? 'active' : ''}">${p}</a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard&page=${currentPage + 1}" class="paginator-btn">Next <i class="bx bx-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- TAB 4: ALERT NOTIFICATIONS -->
            <div id="alert-notifications" class="tab-content">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--gray-800); margin: 0;">In-App Alert Activity</h3>
                    <c:if test="${not empty notifications}">
                        <a href="${pageContext.request.contextPath}/auto-pay?action=markRead" class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.8rem; font-weight: 600; border-radius: var(--radius-sm); text-decoration: none;">Mark All as Read</a>
                    </c:if>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <c:forEach var="n" items="${notifications}">
                                <div class="notif-card ${n.read ? '' : 'unread'} ${n.title.toLowerCase().contains('fail') ? 'fail' : ''}">
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 5px;">
                                        <strong style="font-size: 0.95rem; color: var(--gray-800);">${n.title}</strong>
                                        <span style="font-size: 0.72rem; color: var(--gray-400); font-weight: 500;"><fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
                                    </div>
                                    <p style="margin: 0; font-size: 0.88rem; color: var(--gray-600); line-height: 1.4;">${n.message}</p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 40px; background: white; border: 1px dashed var(--gray-200); border-radius: var(--radius-md); color: var(--gray-400);">No alerts recorded.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <!-- Confirmation Modal Overlay -->
    <div id="cancelOverlay" class="overlay" style="display: none; align-items: center; justify-content: center; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999;">
        <div class="confirm-dialog" style="background: white; border-radius: var(--radius-lg); padding: 30px; max-width: 400px; width: 90%; text-align: center;">
            <h3 style="font-weight: 700; color: var(--gray-800); margin: 0 0 10px;">Cancel Auto Pay?</h3>
            <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 20px;">Are you sure you want to completely cancel this Auto Pay setup? You can re-configure it at any time.</p>
            <div style="display: flex; gap: 15px;">
                <button type="button" class="btn btn-secondary" onclick="closeCancel()" style="flex: 1; padding: 10px; border-radius: var(--radius-sm); font-weight: 600;">Back</button>
                <a id="confirmCancelBtn" href="" class="btn btn-danger" style="flex: 1; padding: 10px; border-radius: var(--radius-sm); font-weight: 600; text-decoration: none; text-align: center; background: #ef4444; border-color: #ef4444; color: white;">Yes, Cancel</a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; 2026 Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        // Set tomorrow as minimum start date
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const yyyy = tomorrow.getFullYear();
        const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
        const dd = String(tomorrow.getDate()).padStart(2, '0');
        document.getElementById('startDate').min = `${yyyy}-${mm}-${dd}`;
        document.getElementById('startDate').value = `${yyyy}-${mm}-${dd}`;

        function switchTab(e, tabId) {
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            e.currentTarget.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        }

        function setTargetType(type) {
            document.getElementById('targetType').value = type;
            document.querySelectorAll('.form-segmented-btn').forEach(btn => btn.classList.remove('active'));
            
            if (type === 'credit_card') {
                document.getElementById('segCC').classList.add('active');
                document.getElementById('ccSelectorGroup').style.display = 'block';
                document.getElementById('loanSelectorGroup').style.display = 'none';
                
                // Toggle payment modes
                document.querySelectorAll('.cc-only').forEach(opt => opt.style.display = 'block');
                document.querySelectorAll('.loan-only').forEach(opt => opt.style.display = 'none');
                document.getElementById('paymentType').value = '';
                document.getElementById('emiInfoBox').style.display = 'none';
                document.getElementById('cardId').required = true;
                document.getElementById('loanId').required = false;
            } else {
                document.getElementById('segLoan').classList.add('active');
                document.getElementById('ccSelectorGroup').style.display = 'none';
                document.getElementById('loanSelectorGroup').style.display = 'block';
                
                document.querySelectorAll('.cc-only').forEach(opt => opt.style.display = 'none');
                document.querySelectorAll('.loan-only').forEach(opt => opt.style.display = 'block');
                document.getElementById('paymentType').value = 'monthly_emi';
                document.getElementById('cardId').required = false;
                document.getElementById('loanId').required = true;
                
                updateEMIInfo(document.getElementById('loanId'));
            }
        }

        function updateEMIInfo(selectElem) {
            const selectedOpt = selectElem.options[selectElem.selectedIndex];
            if (selectedOpt && selectedOpt.value) {
                const emi = parseFloat(selectedOpt.getAttribute('data-emi') || 0);
                document.getElementById('lblCalculatedEMI').textContent = emi.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                document.getElementById('emiInfoBox').style.display = 'block';
            } else {
                document.getElementById('emiInfoBox').style.display = 'none';
            }
        }

        function confirmCancel(id) {
            document.getElementById('confirmCancelBtn').href = '${pageContext.request.contextPath}/auto-pay?action=cancel&id=' + id;
            document.getElementById('cancelOverlay').style.display = 'flex';
        }

        function closeCancel() {
            document.getElementById('cancelOverlay').style.display = 'none';
        }

        function validateForm() {
            const target = document.getElementById('targetType').value;
            if (target === 'credit_card') {
                const card = document.getElementById('cardId').value;
                if (!card) {
                    alert('Please select a Credit Card.');
                    return false;
                }
            } else {
                const loan = document.getElementById('loanId').value;
                if (!loan) {
                    alert('Please select a Loan Account.');
                    return false;
                }
            }
            return true;
        }
    </script>
</body>
</html>
