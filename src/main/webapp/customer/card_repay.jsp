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
    <title>
        <c:choose>
            <c:when test="${subView == 'receipt'}">VGB | Repayment Receipt</c:when>
            <c:when test="${subView == 'history'}">VGB | Repayment History</c:when>
            <c:otherwise>VGB | Credit Card Repayment</c:otherwise>
        </c:choose>
    </title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
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
            transition: all 0.3s ease;
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
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .sidebar-menu a:hover {
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500) !important;
            transform: translateX(4px);
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
        @media (max-width: 991px) {
            .sidebar { left: -280px !important; }
            .sidebar.active { left: 0 !important; }
            .main-content { margin-left: 0 !important; padding: 120px 20px 40px !important; }
            .footer { margin-left: 0 !important; }
        }

        /* Glass Cards */
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
        }

        /* Segmented Button Selection */
        .segmented-control {
            display: flex;
            background: rgba(99, 102, 241, 0.04);
            border: 1px solid rgba(99, 102, 241, 0.1);
            padding: 5px;
            border-radius: var(--radius-md);
            gap: 5px;
            margin-bottom: 20px;
        }
        .segmented-option {
            flex: 1;
            text-align: center;
            padding: 12px 15px;
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-600);
            transition: all 0.3s ease;
            user-select: none;
            border: 1px solid transparent;
        }
        .segmented-option.active {
            background: var(--white);
            color: var(--primary-500);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.08);
            border-color: rgba(99, 102, 241, 0.1);
        }

        /* Confirmation Dialog Styles */
        .overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
        }
        .confirm-dialog {
            width: 100%;
            max-width: 500px;
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            padding: 32px;
            animation: modalFadeIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        @keyframes modalFadeIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .confirm-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--gray-100);
            font-size: 0.95rem;
        }
        .confirm-row:last-child {
            border-bottom: none;
        }
        .confirm-label {
            color: var(--gray-500);
            font-weight: 500;
        }
        .confirm-value {
            color: var(--gray-800);
            font-weight: 700;
        }
        .confirm-value.highlight {
            color: var(--primary-500);
        }

        /* Status Pill */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 50px;
            text-transform: uppercase;
        }
        .status-pill.completed {
            background: rgba(16, 185, 129, 0.08);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.15);
        }

        /* Custom Table Styling */
        .vgb-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .vgb-table th {
            padding: 16px 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--gray-400);
            border-bottom: 1px solid var(--gray-100);
            letter-spacing: 0.5px;
        }
        .vgb-table td {
            padding: 18px 20px;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--gray-50);
            color: var(--gray-700);
        }
        .vgb-table tr:last-child td {
            border-bottom: none;
        }

        /* Printable Area CSS */
        .receipt-card {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--gray-200);
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.03);
            max-width: 600px;
            margin: 0 auto 30px;
            position: relative;
        }
        .receipt-header {
            text-align: center;
            border-bottom: 2px dashed var(--gray-200);
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        .receipt-logo {
            width: 60px;
            height: 60px;
            object-fit: contain;
            margin-bottom: 12px;
        }
        .receipt-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(16, 185, 129, 0.06);
            border: 1px solid rgba(16, 185, 129, 0.15);
            color: #10b981;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 10px;
        }
        .receipt-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--gray-50);
        }
        .receipt-row:last-child {
            border-bottom: none;
        }
        .receipt-label {
            color: var(--gray-400);
            font-weight: 500;
        }
        .receipt-value {
            color: var(--gray-800);
            font-weight: 600;
            text-align: right;
        }
        .receipt-total {
            background: rgba(99, 102, 241, 0.03);
            border: 1px solid rgba(99, 102, 241, 0.06);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            margin: 25px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Print Media Styles */
        @media print {
            body {
                background: white !important;
                color: black !important;
            }
            .header, .sidebar, .footer, .btn-print-actions, .mobile-nav-toggle, .no-print {
                display: none !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
                min-height: auto !important;
            }
            .receipt-card {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                max-width: 100% !important;
            }
        }
    </style>
</head>
<body class="bank-home-page">
    <div class="toast-container" id="toastContainer"></div>

    <!-- Header -->
    <header class="header scrolled">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" style="background: none; border: none; font-size: 1.8rem; cursor: pointer;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500);">
                <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                    <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">
                        ${customer.firstName} ${customer.lastName}
                    </span>
                    <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Customer Space
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
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list" class="${subView == 'repay' ? 'active' : ''}"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=history" class="${subView != 'repay' ? 'active' : ''}"><i class="bx bx-receipt"></i> Card Repayments</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
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
        <div class="container" style="max-width: 1000px; padding: 0;">

            <!-- ================= REPAY FORM VIEW ================= -->
            <c:if test="${subView == 'repay'}">
                <div class="no-print" style="margin-bottom: 30px;">
                    <a href="${pageContext.request.contextPath}/card?action=list" style="text-decoration: none; color: var(--primary-500); font-weight: 600; display: inline-flex; align-items: center; gap: 5px; margin-bottom: 15px;">
                        <i class="bx bx-left-arrow-alt" style="font-size: 1.2rem;"></i> Back to My Cards
                    </a>
                    <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900);">Credit Card Bill Repayment</h1>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Clear your card dues instantly and securely using your active savings or current account.</p>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: start;">
                    
                    <!-- Left: Bill Summary Panel -->
                    <div>
                        <div class="glass-card" style="margin-bottom: 0;">
                            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px;">
                                <i class="bx bx-file-find" style="color: var(--primary-500); margin-right: 5px;"></i> Bill Statement Summary
                            </h3>

                            <!-- Card Visual Mock -->
                            <div style="background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%); border-radius: var(--radius-md); padding: 25px; color: white; margin-bottom: 25px; position: relative; overflow: hidden; box-shadow: 0 10px 25px rgba(30, 27, 75, 0.25);">
                                <div style="position: absolute; right: -20px; bottom: -20px; width: 120px; height: 120px; border-radius: 50%; background: rgba(255,255,255,0.03);"></div>
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px;">
                                    <div>
                                        <p style="font-size: 0.65rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.7; font-weight: 600;">VGB Credit Card</p>
                                        <p style="font-size: 0.95rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 2px;">${card.cardTier} Tier</p>
                                    </div>
                                    <span style="font-size: 1.6rem; font-weight: 800; font-family: 'Poppins'; text-transform: uppercase; font-style: italic; color: #fbbf24;">VGB</span>
                                </div>
                                <p style="font-family: 'Share Tech Mono', monospace; font-size: 1.45rem; letter-spacing: 2px; margin-bottom: 25px;">${card.getMaskedCardNumber()}</p>
                                <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                    <div>
                                        <p style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.6;">Card Holder</p>
                                        <p style="font-size: 0.85rem; font-weight: 600; margin-top: 2px;">${card.cardHolderName}</p>
                                    </div>
                                    <div>
                                        <p style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.6; text-align: right;">Expiry</p>
                                        <p style="font-size: 0.85rem; font-weight: 600; margin-top: 2px; text-align: right;"><fmt:formatDate value="${card.expiryDate}" pattern="MM/yy" /></p>
                                    </div>
                                </div>
                            </div>

                            <!-- Statement Metrics Grid -->
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Billing Cycle</span>
                                    <p style="font-size: 0.9rem; font-weight: 700; color: var(--gray-700); margin-top: 4px;">${billingCycle}</p>
                                </div>
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Statement Date</span>
                                    <p style="font-size: 0.9rem; font-weight: 700; color: var(--gray-700); margin-top: 4px;">${statementDate}</p>
                                </div>
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Payment Due Date</span>
                                    <p style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); margin-top: 4px;">${dueDate}</p>
                                </div>
                                <div style="background: rgba(99, 102, 241, 0.03); border: 1px solid rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md);">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Payment Status</span>
                                    <c:choose>
                                        <c:when test="${card.outstandingBalance > 0}">
                                            <p style="font-size: 0.9rem; font-weight: 700; color: #ef4444; margin-top: 4px;">
                                                Dues Outstanding
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="font-size: 0.9rem; font-weight: 700; color: #10b981; margin-top: 4px;">
                                                All Dues Paid
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Card Limits detail -->
                            <div style="border-top: 1px solid var(--gray-100); margin-top: 25px; padding-top: 20px; display: flex; justify-content: space-between;">
                                <div>
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Total Credit Limit</span>
                                    <p style="font-size: 1.15rem; font-weight: 800; color: var(--gray-800); margin-top: 2px;">₹ <fmt:formatNumber value="${card.onlineLimit}" pattern="#,##,##0.00" /></p>
                                </div>
                                <div style="text-align: right;">
                                    <span style="font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Available Credit</span>
                                    <p style="font-size: 1.15rem; font-weight: 800; color: #10b981; margin-top: 2px;">₹ <fmt:formatNumber value="${availableLimit}" pattern="#,##,##0.00" /></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Payment Execution Panel -->
                    <div>
                        <div class="glass-card" style="margin-bottom: 0;">
                            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px;">
                                <i class="bx bx-credit-card-front" style="color: var(--primary-500); margin-right: 5px;"></i> Repayment Workspace
                            </h3>

                            <form id="repayForm" method="post" action="${pageContext.request.contextPath}/card-repayment">
                                <input type="hidden" name="action" value="repay">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="cardId" value="${card.cardId}">

                                <!-- Source Account Selection -->
                                <div class="form-group" style="margin-bottom: 25px;">
                                    <label style="display: block; font-weight: 600; font-size: 0.85rem; color: var(--gray-700); margin-bottom: 8px;">Select Source Bank Account</label>
                                    <div style="position: relative;">
                                        <select class="form-control" name="accountId" id="accountId" style="padding-left: 45px; font-weight: 600;" required>
                                            <option value="" disabled selected>-- Select savings or current account --</option>
                                            <c:forEach var="acc" items="${accounts}">
                                                <option value="${acc.accountId}" data-balance="${acc.balance}" data-number="${acc.accountNumber}">
                                                    VGB ${acc.accountType.toUpperCase()} - •••• ${acc.accountNumber.substring(acc.accountNumber.length() - 4)} (Bal: ₹ <fmt:formatNumber value="${acc.balance}" pattern="#,##,##0.00" />)
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <i class="bx bx-wallet" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); font-size: 1.2rem; color: var(--gray-400);"></i>
                                    </div>
                                </div>

                                <!-- Payment Option (Segmented Controls) -->
                                <label style="display: block; font-weight: 600; font-size: 0.85rem; color: var(--gray-700); margin-bottom: 8px;">Payment Option</label>
                                <div class="segmented-control" id="optionControl">
                                    <input type="hidden" name="paymentOption" id="paymentOption" value="full">
                                    <div class="segmented-option" data-value="minimum" id="optMin">
                                        Min Due<br>
                                        <span style="font-size: 0.75rem; font-weight: 700; opacity: 0.8;">₹${minimumDue}</span>
                                    </div>
                                    <div class="segmented-option active" data-value="full" id="optFull">
                                        Total Outstanding<br>
                                        <span style="font-size: 0.75rem; font-weight: 700; opacity: 0.8;">₹${card.outstandingBalance}</span>
                                    </div>
                                    <div class="segmented-option" data-value="custom" id="optCustom">
                                        Custom Amount<br>
                                        <span style="font-size: 0.75rem; font-weight: 700; opacity: 0.8;">Enter Below</span>
                                    </div>
                                </div>

                                <!-- Amount Details -->
                                <div class="form-group" style="margin-bottom: 25px;" id="customAmountGroup">
                                    <label style="display: block; font-weight: 600; font-size: 0.85rem; color: var(--gray-700); margin-bottom: 8px;">Repayment Amount (₹)</label>
                                    <div style="position: relative;">
                                        <input type="number" class="form-control" name="amount" id="amount" step="0.01" style="padding-left: 45px; font-weight: 700;" placeholder="0.00" value="${card.outstandingBalance}">
                                        <i class="bx bx-rupee" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); font-size: 1.25rem; color: var(--gray-400);"></i>
                                    </div>
                                    <small id="amountHelp" style="color: var(--gray-400); font-weight: 500; margin-top: 5px; display: block;"></small>
                                </div>

                                <button type="button" class="btn btn-primary w-100" id="btnSubmitPayment" style="padding: 14px 20px; font-weight: 700; border-radius: var(--radius-md);" ${card.outstandingBalance <= 0 ? 'disabled' : ''}>
                                    <i class="bx bx-check-shield" style="font-size: 1.15rem; margin-right: 5px;"></i> Proceed to Payment
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Overlay Confirmation Dialog -->
                <div class="overlay" id="confirmOverlay">
                    <div class="confirm-dialog">
                        <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--gray-900); margin-bottom: 5px;">Confirm Payment</h3>
                        <p style="color: var(--gray-400); font-size: 0.85rem; margin-bottom: 20px;">Please review the card repayment details before completing the secure transaction.</p>

                        <div style="background: var(--gray-50); border: 1px solid var(--gray-100); border-radius: var(--radius-md); padding: 10px 20px; margin-bottom: 25px;">
                            <div class="confirm-row">
                                <span class="confirm-label">Credit Card</span>
                                <span class="confirm-value" id="lblCard">${card.getMaskedCardNumber()}</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Debiting Account</span>
                                <span class="confirm-value" id="lblAccount">--</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Repayment Amount</span>
                                <span class="confirm-value highlight" id="lblAmount">₹ 0.00</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Projected Card Dues</span>
                                <span class="confirm-value" id="lblRemainingDues">₹ 0.00</span>
                            </div>
                            <div class="confirm-row">
                                <span class="confirm-label">Remaining Bank Balance</span>
                                <span class="confirm-value" id="lblRemainingAccountBalance">₹ 0.00</span>
                            </div>
                        </div>

                        <div style="display: flex; gap: 15px;">
                            <button type="button" class="btn btn-secondary" id="btnCancelPayment" style="flex: 1; padding: 12px 20px; font-weight: 600;">Cancel</button>
                            <button type="button" class="btn btn-primary" id="btnConfirmPayment" style="flex: 1; padding: 12px 20px; font-weight: 700; background: var(--accent-emerald); border-color: var(--accent-emerald);">Confirm & Pay</button>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- ================= REPAYMENT RECEIPT VIEW ================= -->
            <c:if test="${subView == 'receipt'}">
                <!-- Receipt Card -->
                <div class="receipt-card">
                    <div class="receipt-header">
                        <img class="receipt-logo" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo">
                        <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--gray-800);">VERTEX GALAXY BANK</h2>
                        <p style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500; margin-top: 3px; letter-spacing: 0.5px;">SECURE CARD PAYMENT RECEIPT</p>
                        <div class="receipt-status">
                            <i class="bx bx-shield-quarter"></i> Transaction Completed
                        </div>
                    </div>

                    <div>
                        <div class="receipt-row">
                            <span class="receipt-label">Transaction Reference ID</span>
                            <span class="receipt-value" style="font-family: 'Share Tech Mono', monospace; font-size: 1rem; color: var(--primary-500);">${repayment.transactionReference}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Payment Date & Time</span>
                            <span class="receipt-value"><fmt:formatDate value="${repayment.repaymentDate}" pattern="dd MMM yyyy, hh:mm:ss a" /></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Card Holder Name</span>
                            <span class="receipt-value" style="text-transform: uppercase;">${repayment.cardHolderName}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Credit Card Number</span>
                            <span class="receipt-value">${repayment.getMaskedCardNumber()}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Debited Bank Account</span>
                            <span class="receipt-value">${repayment.getSourceAccountNumber()}</span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Remaining Card Dues</span>
                            <span class="receipt-value">₹ <fmt:formatNumber value="${card.outstandingBalance}" pattern="#,##,##0.00" /></span>
                        </div>
                        <div class="receipt-row">
                            <span class="receipt-label">Available Credit Limit</span>
                            <span class="receipt-value" style="color: #10b981;">₹ <fmt:formatNumber value="${card.onlineLimit - card.outstandingBalance}" pattern="#,##,##0.00" /></span>
                        </div>

                        <div class="receipt-total">
                            <span style="font-weight: 600; color: var(--gray-600); font-size: 0.95rem;">Repayment Amount</span>
                            <span style="font-size: 1.4rem; font-weight: 800; color: var(--primary-500);">₹ <fmt:formatNumber value="${repayment.amountPaid}" pattern="#,##,##0.00" /></span>
                        </div>

                        <div style="text-align: center; color: var(--gray-400); font-size: 0.75rem; margin-top: 20px; font-weight: 500;">
                            This is a computer-generated transaction receipt and does not require a signature.
                        </div>
                    </div>
                </div>

                <!-- Print Actions -->
                <div class="btn-print-actions" style="max-width: 600px; margin: 0 auto; display: flex; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/card?action=list" class="btn btn-secondary" style="flex: 1; padding: 12px 20px; font-weight: 600; text-align: center; text-decoration: none;">
                        Go to Cards
                    </a>
                    <button type="button" class="btn btn-primary" onclick="window.print();" style="flex: 1; padding: 12px 20px; font-weight: 700; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
                        <i class="bx bx-printer" style="font-size: 1.2rem;"></i> Print Receipt / PDF
                    </button>
                    <a href="${pageContext.request.contextPath}/card-repayment?action=history" class="btn btn-secondary" style="flex: 1; padding: 12px 20px; font-weight: 600; text-align: center; text-decoration: none; color: var(--primary-500) !important;">
                        View History
                    </a>
                </div>
            </c:if>

            <!-- ================= REPAYMENT HISTORY VIEW ================= -->
            <c:if test="${subView == 'history'}">
                <div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <div>
                        <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900);">Repayment History</h1>
                        <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Track your past credit card repayments, download transaction vouchers, and audit statement logs.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/card?action=list" class="btn btn-secondary" style="text-decoration: none; padding: 10px 18px; display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                        <i class="bx bx-credit-card"></i> Card Console
                    </a>
                </div>

                <!-- List Card -->
                <div class="glass-card" style="padding: 0; overflow: hidden;">
                    <c:choose>
                        <c:when test="${not empty repayments}">
                            <div style="overflow-x: auto;">
                                <table class="vgb-table">
                                    <thead>
                                        <tr>
                                            <th>Date & Time</th>
                                            <th>Card Number</th>
                                            <th>Source A/C</th>
                                            <th>Method</th>
                                            <th>Reference ID</th>
                                            <th>Status</th>
                                            <th style="text-align: right;">Amount Paid</th>
                                            <th style="text-align: center;">Voucher</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${repayments}">
                                            <tr>
                                                <td style="font-weight: 500;"><fmt:formatDate value="${r.repaymentDate}" pattern="dd MMM yyyy, hh:mm a" /></td>
                                                <td style="font-family: 'Share Tech Mono', monospace; font-size: 0.95rem; letter-spacing: 0.5px;">${r.getMaskedCardNumber()}</td>
                                                <td style="font-weight: 500;">${r.getSourceAccountNumber()}</td>
                                                <td style="text-transform: capitalize; font-weight: 600; font-size: 0.8rem; color: var(--gray-500);">${r.paymentOption}</td>
                                                <td style="font-family: 'Share Tech Mono', monospace; font-size: 0.95rem; color: var(--primary-500);">${r.transactionReference}</td>
                                                <td>
                                                    <span class="status-pill completed">
                                                        <span style="width: 5px; height: 5px; border-radius: 50%; background: #10b981; display: inline-block;"></span>
                                                        ${r.status}
                                                    </span>
                                                </td>
                                                <td style="text-align: right; font-weight: 700; color: var(--gray-800);">
                                                    ₹ <fmt:formatNumber value="${r.amountPaid}" pattern="#,##,##0.00" />
                                                </td>
                                                <td style="text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/card-repayment?action=receipt&reference=${r.transactionReference}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.8rem; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                                                        <i class="bx bx-receipt"></i> View
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination Links -->
                            <c:if test="${totalPages > 1}">
                                <div class="no-print" style="display: flex; justify-content: center; gap: 8px; padding: 25px; border-top: 1px solid var(--gray-100);">
                                    <c:if test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/card-repayment?action=history&page=${currentPage - 1}" class="btn btn-secondary" style="padding: 8px 14px; text-decoration: none; font-size: 0.85rem;">&laquo; Prev</a>
                                    </c:if>
                                    
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="${pageContext.request.contextPath}/card-repayment?action=history&page=${i}" class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}" style="padding: 8px 14px; text-decoration: none; font-size: 0.85rem; font-weight: 600;">
                                            ${i}
                                        </a>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/card-repayment?action=history&page=${currentPage + 1}" class="btn btn-secondary" style="padding: 8px 14px; text-decoration: none; font-size: 0.85rem;">Next &raquo;</a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 60px 40px;">
                                <div style="width: 80px; height: 80px; border-radius: 50%; background: rgba(99, 102, 241, 0.05); color: var(--primary-500); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 20px;">
                                    <i class="bx bx-receipt"></i>
                                </div>
                                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-700);">No Repayment Logs</h3>
                                <p style="color: var(--gray-400); font-size: 0.9rem; margin-top: 5px; max-width: 400px; margin-left: auto; margin-right: auto;">You haven't made any credit card repayments yet. Dues will show up here as soon as payments are processed.</p>
                                <a href="${pageContext.request.contextPath}/card?action=list" class="btn btn-primary" style="margin-top: 25px; padding: 10px 22px; font-weight: 600; text-decoration: none; display: inline-block;">Pay Credit Card Bill</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div style="max-width: 1000px; margin: 0 auto; text-align: center;">
            <p style="font-size: 0.85rem; color: var(--gray-400); font-weight: 500;">&copy; 2026 Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Mobile Nav toggle (Universal)
        const sidebar = document.querySelector('.sidebar');
        const mobileToggle = document.getElementById('mobileNavToggle');
        if (mobileToggle && sidebar) {
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
            });
        }
    </script>

    <!-- ================= SCRIPTS FOR REPAY FORM ================= -->
    <c:if test="${subView == 'repay'}">
        <script>
            const cardOutstanding = parseFloat("${card.outstandingBalance}");
            const cardMinimum = parseFloat("${minimumDue}");

            // Segmented Control click handlers
            const options = document.querySelectorAll('.segmented-option');
            const hiddenOptionInput = document.getElementById('paymentOption');
            const amountInput = document.getElementById('amount');
            const customAmountGroup = document.getElementById('customAmountGroup');
            const amountHelp = document.getElementById('amountHelp');

            // Initial setup
            setPaymentSelection('full');

            options.forEach(opt => {
                opt.addEventListener('click', function() {
                    options.forEach(o => o.classList.remove('active'));
                    this.classList.add('active');
                    const val = this.getAttribute('data-value');
                    setPaymentSelection(val);
                });
            });

            function setPaymentSelection(val) {
                hiddenOptionInput.value = val;
                if (val === 'minimum') {
                    amountInput.value = cardMinimum.toFixed(2);
                    amountInput.readOnly = true;
                    customAmountGroup.style.display = 'block';
                    amountHelp.innerText = "Paying the Minimum Amount Due keeps your account active but interest is charged on the unpaid balance.";
                } else if (val === 'full') {
                    amountInput.value = cardOutstanding.toFixed(2);
                    amountInput.readOnly = true;
                    customAmountGroup.style.display = 'block';
                    amountHelp.innerText = "Paying the outstanding balance in full avoids interest charges on your billing cycle statement.";
                } else {
                    amountInput.value = "";
                    amountInput.readOnly = false;
                    customAmountGroup.style.display = 'block';
                    amountHelp.innerText = "Enter any custom payment amount between ₹1.00 and ₹" + cardOutstanding.toFixed(2);
                }
            }

            // Form Validation & Confirmation triggers
            const btnSubmit = document.getElementById('btnSubmitPayment');
            const confirmOverlay = document.getElementById('confirmOverlay');
            const btnCancel = document.getElementById('btnCancelPayment');
            const btnConfirm = document.getElementById('btnConfirmPayment');
            const accountSelect = document.getElementById('accountId');
            const repayForm = document.getElementById('repayForm');

            btnSubmit.addEventListener('click', function() {
                // Client-side validations
                const selectedOpt = accountSelect.options[accountSelect.selectedIndex];
                if (accountSelect.value === "") {
                    showToast("Please select a source bank account to debit.", "error");
                    return;
                }

                const paymentAmount = parseFloat(amountInput.value);
                if (isNaN(paymentAmount) || paymentAmount <= 0) {
                    showToast("Please enter a valid repayment amount greater than zero.", "error");
                    return;
                }

                if (paymentAmount > cardOutstanding) {
                    showToast("Payment amount cannot exceed the card outstanding dues of ₹" + cardOutstanding.toFixed(2), "error");
                    return;
                }

                const accountBalance = parseFloat(selectedOpt.getAttribute('data-balance'));
                if (accountBalance < paymentAmount) {
                    showToast("Insufficient balance in the selected account to clear this amount.", "error");
                    return;
                }

                // Populate overlay values
                document.getElementById('lblAccount').innerText = "VGB •••• " + selectedOpt.getAttribute('data-number').slice(-4);
                document.getElementById('lblAmount').innerText = "₹ " + paymentAmount.toLocaleString('en-IN', {minimumFractionDigits: 2});
                document.getElementById('lblRemainingDues').innerText = "₹ " + (cardOutstanding - paymentAmount).toLocaleString('en-IN', {minimumFractionDigits: 2});
                document.getElementById('lblRemainingAccountBalance').innerText = "₹ " + (accountBalance - paymentAmount).toLocaleString('en-IN', {minimumFractionDigits: 2});

                // Open overlay
                confirmOverlay.style.display = 'flex';
            });

            btnCancel.addEventListener('click', function() {
                confirmOverlay.style.display = 'none';
            });

            btnConfirm.addEventListener('click', function() {
                // Disable buttons to prevent duplicate submission
                btnConfirm.disabled = true;
                btnCancel.disabled = true;
                btnConfirm.innerHTML = '<i class="bx bx-loader-alt bx-spin" style="margin-right: 5px;"></i> Processing...';
                
                // Submit form
                repayForm.submit();
            });

            // Toast Helper
            function showToast(message, type = "success") {
                const container = document.getElementById('toastContainer');
                const card = document.createElement('div');
                card.className = "toast-card show " + (type === 'error' ? 'error' : '');
                
                const icon = document.createElement('i');
                icon.className = "bx " + (type === 'error' ? 'bx-error-circle' : 'bx-badge-check') + " toast-icon";
                
                const textSpan = document.createElement('span');
                textSpan.innerText = message;
                
                card.appendChild(icon);
                card.appendChild(textSpan);
                container.appendChild(card);
                
                setTimeout(() => {
                    card.classList.remove('show');
                    setTimeout(() => card.remove(), 400);
                }, 3500);
            }
        </script>
    </c:if>
</body>
</html>
