<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.vgb.model.Customer" %>
<%@ page import="com.vgb.service.CustomerService" %>
<%@ page import="com.vgb.model.Account" %>
<%@ page import="com.vgb.service.AccountService" %>
<%@ page import="com.vgb.model.Card" %>
<%@ page import="com.vgb.service.CardService" %>
<%@ page import="com.vgb.model.Loan" %>
<%@ page import="com.vgb.service.LoanService" %>
<%@ page import="com.vgb.model.ChequeBookRequest" %>
<%@ page import="com.vgb.service.ChequeBookRequestService" %>
<%@ page import="com.vgb.constants.AppConstants" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Long customerId = null;
    Object sessionUser = session.getAttribute(AppConstants.USER_SESSION_KEY);
    if (sessionUser != null) {
        customerId = Long.parseLong(sessionUser.toString());
    }
    
    Customer customer = null;
    List<Account> customerAccounts = null;
    List<Card> customerCards = null;
    List<Loan> customerLoans = null;
    List<ChequeBookRequest> customerChequeRequests = null;
    BigDecimal totalBalance = BigDecimal.ZERO;
    
    if (customerId != null) {
        try {
            CustomerService customerService = new CustomerService();
            customer = customerService.getCustomerById(customerId);
            
            AccountService accountService = new AccountService();
            customerAccounts = accountService.getCustomerAccounts(customerId);
            if (customerAccounts != null) {
                for (Account acc : customerAccounts) {
                    if (acc.getBalance() != null) {
                        totalBalance = totalBalance.add(acc.getBalance());
                    }
                }
            }
            
            CardService cardService = new CardService();
            customerCards = cardService.getCustomerCards(customerId);
            
            LoanService loanService = new LoanService();
            customerLoans = loanService.getCustomerLoans(customerId);
            
            ChequeBookRequestService chequeBookService = new ChequeBookRequestService();
            customerChequeRequests = chequeBookService.getCustomerRequests(customerId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    request.setAttribute("customer", customer);
    request.setAttribute("accounts", customerAccounts);
    request.setAttribute("cards", customerCards);
    request.setAttribute("loans", customerLoans);
    request.setAttribute("chequeRequests", customerChequeRequests);
    request.setAttribute("totalBalance", totalBalance);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Profile Settings</title>
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
        .profile-tab {
            padding: 12px 25px;
            font-weight: 600;
            color: var(--gray-500);
            background: transparent;
            border: none;
            border-left: 3px solid transparent;
            cursor: pointer;
            text-align: left;
            transition: all var(--transition-normal);
            width: 100%;
        }
        .profile-tab.active {
            color: var(--primary-500);
            border-left-color: var(--primary-500);
            background: rgba(99, 102, 241, 0.05);
        }
        .profile-section {
            display: none;
        }
        .profile-section.active {
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
        <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center;">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
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
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp" class="active"><i class="bx bx-user"></i> My Profile</a>
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
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">My Profile &amp; Settings</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Review contact files, verify KYC, or update security credentials.</p>
            </div>

            <!-- Dynamic alerts -->
            <c:if test="${not empty sessionScope.success}">
                <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.3); border-radius: var(--radius-md); padding: 15px 20px; color: var(--accent-emerald); font-weight: 600; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;" class="no-print">
                    <i class="bx bx-check-circle" style="font-size: 1.3rem;"></i>
                    <span>${sessionScope.success}</span>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); border-radius: var(--radius-md); padding: 15px 20px; color: #ef4444; font-weight: 600; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;" class="no-print">
                    <i class="bx bx-error-circle" style="font-size: 1.3rem;"></i>
                    <span>${sessionScope.error}</span>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <!-- Toast alert -->
            <div id="toast" style="position: fixed; top: 100px; right: 40px; z-index: 1000; background: white; padding: 15px 25px; border-radius: var(--radius-md); box-shadow: var(--shadow-xl); border: 1px solid var(--gray-200); display: flex; align-items: center; gap: 10px; transform: translateY(-50px); opacity: 0; transition: all 0.4s ease;">
                <div class="toast-icon"><i class="bx bx-check-circle" style="color: #10b981; font-size: 1.5rem;"></i></div>
                <div class="toast-message" style="font-weight: 600; color: var(--gray-800);">Action executed successfully.</div>
            </div>

            <!-- Hidden Upload Form -->
            <form id="avatarUploadForm" style="display: none;">
                <input type="file" id="avatarFileInput" name="avatarFile" accept="image/*" onchange="uploadAvatarDynamically();">
            </form>

            <div style="display: grid; grid-template-columns: 1fr 3fr; gap: 30px;" class="mobile-grid-1">
                <!-- Left Tabs Menu -->
                <div class="glass-card" style="padding: 15px 0; align-self: start;">
                    <button class="profile-tab active" id="tabPers" onclick="showProfileSec('personal')"><i class="bx bx-user-pin"></i> Personal Details</button>
                    <button class="profile-tab" id="tabBank" onclick="showProfileSec('banking')"><i class="bx bx-wallet"></i> Banking Details</button>
                    <button class="profile-tab" id="tabCred" onclick="showProfileSec('credentials')"><i class="bx bx-shield-quarter"></i> Login &amp; Security</button>
                </div>

                <!-- Right Details Sections -->
                <div style="display: flex; flex-direction: column;">
                    <!-- 1. Personal Details -->
                    <div class="glass-card profile-section active" id="secPersonal">
                        <!-- Customer Avatar / Profile Banner -->
                        <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 30px; background: var(--gradient-primary); padding: 25px; border-radius: var(--radius-md); color: white;" class="profile-banner">
                            <div style="position: relative; display: inline-block;">
                                <c:set var="avatarUrl" value="" />
                                <c:if test="${not empty customer.avatarPath}">
                                    <c:set var="avatarUrl" value="${pageContext.request.contextPath}${customer.avatarPath}" />
                                </c:if>
                                <div id="avatarClickContainer" onclick="openLightbox('${avatarUrl}')" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; background: rgba(255, 255, 255, 0.2); border: 3px solid rgba(255, 255, 255, 0.4); display: flex; align-items: center; justify-content: center; backdrop-filter: blur(10px); cursor: pointer;" title="Click to View Profile Picture">
                                    <c:choose>
                                        <c:when test="${not empty customer.avatarPath}">
                                            <img id="avatarImageRef" src="${avatarUrl}" alt="Profile Avatar" style="width: 100%; height: 100%; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bx bxs-user-circle" style="font-size: 5rem; color: white;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div onclick="document.getElementById('avatarFileInput').click();" style="position: absolute; bottom: -2px; right: -2px; background: var(--primary-500); color: white; width: 26px; height: 26px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.95rem; border: 2px solid white; box-shadow: var(--shadow-sm); cursor: pointer;" title="Click to Change Profile Picture">
                                    <i class="bx bx-camera"></i>
                                </div>
                            </div>
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 700; margin: 0; color: white;">${customer.fullName}</h3>
                                <p style="font-size: 0.85rem; margin: 5px 0 0; opacity: 0.85;">Username: <strong style="font-weight: 600;">${customer.username}</strong></p>
                                <div style="display: flex; gap: 10px; margin-top: 10px; align-items: center;" class="mobile-flex-wrap">
                                    <span style="background: rgba(255, 255, 255, 0.25); color: white; padding: 4px 10px; border-radius: 30px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">
                                        ID: #VGB-CUST-${customer.customerId}
                                    </span>
                                    <span style="background: #10b981; color: white; padding: 4px 10px; border-radius: 30px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; display: flex; align-items: center; gap: 4px;">
                                        <i class="bx bx-check-shield"></i> ${customer.status}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 10px;"><i class="bx bx-user-pin"></i> Profile Contact Card</h3>
                        <form id="personalUpdateForm" onsubmit="submitContactUpdate(event)">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;" class="mobile-grid-1">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">First Name</label>
                                    <input type="text" id="firstName" value="${customer.firstName}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Last Name</label>
                                    <input type="text" id="lastName" value="${customer.lastName}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Email Address</label>
                                    <input type="email" id="email" value="${customer.email}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Mobile Number</label>
                                    <input type="text" id="phoneNo" value="${customer.phoneNo}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                            </div>
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Home Street Address</label>
                                <input type="text" id="address" value="${customer.address}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 20px;" class="mobile-grid-1">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">City</label>
                                    <input type="text" id="city" value="${customer.city}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">State</label>
                                    <input type="text" id="state" value="${customer.state}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Zip Code</label>
                                    <input type="text" id="zipCode" value="${customer.zipCode}" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                </div>
                            </div>
                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;" class="mobile-grid-1">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Aadhaar Card Number</label>
                                    <input type="text" value="${customer.aadhaarCard}" readonly style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: rgba(99, 102, 241, 0.05); color: var(--gray-600); cursor: not-allowed; font-weight: 500;">
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">PAN Card Number</label>
                                    <input type="text" value="${customer.panCard}" readonly style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: rgba(99, 102, 241, 0.05); color: var(--gray-600); cursor: not-allowed; font-weight: 500;">
                                </div>
                            </div>
 
                            <button type="submit" class="btn btn-primary" style="margin-top: 30px;">
                                <span>Save Changes</span>
                                <i class="bx bx-check"></i>
                            </button>
                        </form>
                    </div>

                    <!-- 2. Banking Details -->
                    <div class="glass-card profile-section" id="secBanking">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 10px;"><i class="bx bx-wallet"></i> Core Account Ledger Information</h3>
                        
                        <!-- Financial net worth banner -->
                        <div style="background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%); color: white; padding: 25px; border-radius: var(--radius-md); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;" class="mobile-grid-1">
                            <div>
                                <span style="font-size: 0.8rem; font-weight: 600; color: #a5b4fc; text-transform: uppercase; letter-spacing: 0.5px;">Combined Net Worth</span>
                                <h2 style="font-size: 2.2rem; font-weight: 800; color: white; margin-top: 5px;">₹<fmt:formatNumber value="${totalBalance}" minFractionDigits="2" maxFractionDigits="2"/></h2>
                                <p style="font-size: 0.8rem; color: #c7d2fe; margin-top: 5px; opacity: 0.9;">Consolidated balance across all savings, checking, and current accounts.</p>
                            </div>
                            <div style="text-align: right;" class="mobile-text-left">
                                <span style="background: rgba(255, 255, 255, 0.1); padding: 6px 12px; border-radius: var(--radius-md); font-size: 0.8rem; font-weight: 600; color: white; display: inline-block;">
                                    <i class="bx bx-check-shield"></i> Profile Secure
                                </span>
                            </div>
                        </div>

                        <!-- Core ledger parameters -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 35px;" class="mobile-grid-1">
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Linked Customer ID</span>
                                <strong style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 5px;">#VGB-CUST-${customer.customerId}</strong>
                            </div>
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">KYC Verification Status</span>
                                <strong style="font-size: 1.1rem; color: var(--accent-emerald); display: block; margin-top: 5px; text-transform: uppercase;"><i class="bx bx-check-shield"></i> ${customer.status}</strong>
                            </div>
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Primary IFSC Branch Code</span>
                                <strong style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 5px; font-family: monospace;">VGBK0000001</strong>
                            </div>
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Routing System Type</span>
                                <strong style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 5px;">Immediate Payment Service (IMPS)</strong>
                            </div>
                        </div>


                        <!-- Detailed Account Signature & Banking Records -->
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-top: 35px; margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.05); padding-bottom: 10px;"><i class="bx bx-file"></i> Detailed Banking &amp; Signatory Records</h4>
                        <div style="display: flex; flex-direction: column; gap: 20px; margin-bottom: 35px;">
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}">
                                        <div style="background: rgba(255, 255, 255, 0.5); border: 1.5px solid rgba(99, 102, 241, 0.12); border-radius: var(--radius-md); padding: 25px; box-shadow: var(--shadow-sm); position: relative; overflow: hidden; transition: all var(--transition-normal);" class="banking-detail-card">
                                            <!-- Ambient light badge inside card -->
                                            <div style="position: absolute; top: 0; right: 0; background: var(--gradient-primary); color: white; padding: 6px 15px; border-bottom-left-radius: var(--radius-md); font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">
                                                Active ${acc.accountType} Account
                                            </div>
                                            
                                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px 40px; margin-top: 15px;" class="mobile-grid-1">
                                                <!-- Left Columns -->
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Customer ID</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 3px;">#VGB-CUST-${acc.customerId > 0 ? acc.customerId : customer.customerId}</strong>
                                                </div>
                                                
                                                <!-- Right Columns -->
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Bank Name</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 3px;">Vertex Galaxy Bank (VGB)</strong>
                                                </div>
                                                
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Customer Name</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 3px;">${customer.fullName}</strong>
                                                </div>
                                                
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Bank Branch Address</span>
                                                    <strong style="font-size: 0.9rem; color: var(--gray-700); display: block; margin-top: 3px; line-height: 1.4;">VGB Corporate Towers, Bandra Kurla Complex, Mumbai, MH - 400051</strong>
                                                </div>
                                                
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Account Type</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 3px; text-transform: capitalize;">${acc.accountType} Ledger</strong>
                                                </div>
                                                
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">IFSC Routing Code</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 3px; font-family: monospace;">${acc.ifscCode}</strong>
                                                </div>
                                                
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Account Number</span>
                                                    <strong style="font-size: 1.1rem; color: var(--primary-500); display: block; margin-top: 3px; font-family: monospace; letter-spacing: 0.5px;">${acc.accountNumber}</strong>
                                                </div>
                                                
                                                <div>
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Nominee Person Details</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 3px;">
                                                        <c:choose>
                                                            <c:when test="${acc.accountType == 'savings' && not empty acc.nomineeName}">
                                                                ${acc.nomineeName}
                                                            </c:when>
                                                            <c:when test="${acc.accountType == 'savings'}">
                                                                No Nominee Assigned
                                                            </c:when>
                                                            <c:otherwise>
                                                                Not Applicable (Current Business Account)
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </div>
                                                
                                                <div style="grid-column: span 2;">
                                                    <span style="display: block; font-size: 0.75rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase; letter-spacing: 0.5px;">Account Signatories &amp; Authority</span>
                                                    <strong style="font-size: 1rem; color: var(--gray-800); display: block; margin-top: 5px; display: flex; align-items: center; gap: 8px;">
                                                        <i class="bx bx-check-double" style="color: var(--accent-emerald); font-size: 1.2rem;"></i>
                                                        <span>${acc.customerName} <span style="font-weight: 500; font-size: 0.8rem; color: var(--gray-500);">(${acc.holdingType != null ? acc.holdingType : 'primary'} authority)</span></span>
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; padding: 30px; background: rgba(99, 102, 241, 0.03); border: 1px dashed var(--gray-200); border-radius: var(--radius-md); color: var(--gray-400);">
                                        <i class="bx bx-wallet" style="font-size: 2.5rem; color: var(--gray-300);"></i>
                                        <p style="margin-top: 10px; font-weight: 500;">No active account signatories found on this profile.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>


                    </div>

                    <!-- 3. Security Credentials -->
                    <div class="glass-card profile-section" id="secCredentials">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 10px;"><i class="bx bx-shield-quarter"></i> Update Security Credentials</h3>
                                               <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;" class="mobile-grid-1">
                            <!-- Change Password -->
                            <form id="passwordUpdateForm" onsubmit="submitPasswordUpdate(event)" style="display: flex; flex-direction: column; gap: 15px;">
                                <h4 style="font-weight: 700; color: var(--gray-700); margin-bottom: 5px;"><i class="bx bx-key"></i> Change Login Password</h4>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Old Password</label>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="password" id="oldPasswordInput" required style="width: 100%; padding: 10px 40px 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                        <i class="bx bx-hide" onclick="togglePasswordVisibility('oldPasswordInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">New Password</label>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="password" id="newPasswordInput" required style="width: 100%; padding: 10px 40px 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                        <i class="bx bx-hide" onclick="togglePasswordVisibility('newPasswordInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="align-self: start; padding: 10px 20px;">Change Password</button>
                            </form>
 
                            <!-- Change PIN -->
                            <form id="pinUpdateForm" onsubmit="submitPinUpdate(event)" style="display: flex; flex-direction: column; gap: 15px;">
                                <h4 style="font-weight: 700; color: var(--gray-700); margin-bottom: 5px;"><i class="bx bx-lock-open"></i> Change Transaction PIN</h4>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">New 4-Digit PIN</label>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="password" id="newPinInput" maxlength="4" pattern="^[0-9]{4}$" required placeholder="E.g. 0000" style="width: 100%; padding: 10px 40px 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-family: monospace;">
                                        <i class="bx bx-hide" onclick="togglePasswordVisibility('newPinInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="align-self: start; padding: 10px 20px;">Update PIN</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Premium Image Lightbox Modal -->
    <div id="imageLightbox" style="position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(15px); z-index: 2000; display: none; align-items: center; justify-content: center; opacity: 0; transition: opacity 0.3s ease;">
        <!-- Close button -->
        <button onclick="closeLightbox()" style="position: absolute; top: 40px; right: 40px; background: rgba(255, 255, 255, 0.1); border: none; color: white; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; cursor: pointer; transition: all 0.3s; outline: none;" onmouseover="this.style.background='rgba(255, 255, 255, 0.25)'; this.style.transform='scale(1.1)'" onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'; this.style.transform='scale(1)'">
            <i class="bx bx-x"></i>
        </button>
        <!-- Image wrapper -->
        <div style="max-width: 80%; max-height: 80%; border-radius: var(--radius-lg); overflow: hidden; border: 4px solid rgba(255, 255, 255, 0.2); box-shadow: var(--shadow-2xl); transform: scale(0.9); transition: transform 0.3s ease;" id="lightboxImageWrapper">
            <img id="lightboxImg" src="" alt="Profile Lightbox" style="width: 100%; height: auto; max-height: 80vh; display: block; object-fit: contain;">
        </div>
    </div>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function showProfileSec(sec) {
            document.getElementById('tabPers').classList.remove('active');
            document.getElementById('tabBank').classList.remove('active');
            document.getElementById('tabCred').classList.remove('active');

            document.getElementById('secPersonal').classList.remove('active');
            document.getElementById('secBanking').classList.remove('active');
            document.getElementById('secCredentials').classList.remove('active');

            if (sec === 'personal') {
                document.getElementById('tabPers').classList.add('active');
                document.getElementById('secPersonal').classList.add('active');
            } else if (sec === 'banking') {
                document.getElementById('tabBank').classList.add('active');
                document.getElementById('secBanking').classList.add('active');
            } else {
                document.getElementById('tabCred').classList.add('active');
                document.getElementById('secCredentials').classList.add('active');
            }
        }

        function showResponseToast(message, isSuccess = true) {
            const toast = document.getElementById('toast');
            const toastIcon = toast.querySelector('.toast-icon');
            const toastMessage = toast.querySelector('.toast-message');
            
            if (isSuccess) {
                toastIcon.innerHTML = '<i class="bx bx-check-circle" style="color: #10b981; font-size: 1.5rem;"></i>';
                toast.style.borderColor = 'rgba(16, 185, 129, 0.3)';
                toast.style.background = 'rgba(255, 255, 255, 0.95)';
            } else {
                toastIcon.innerHTML = '<i class="bx bx-error-circle" style="color: #ef4444; font-size: 1.5rem;"></i>';
                toast.style.borderColor = 'rgba(239, 68, 68, 0.3)';
                toast.style.background = 'rgba(255, 255, 255, 0.95)';
            }
            
            toastMessage.innerText = message;
            toast.style.transform = 'translateY(0)';
            toast.style.opacity = '1';
            
            setTimeout(() => {
                toast.style.transform = 'translateY(-50px)';
                toast.style.opacity = '0';
            }, 4000);
        }

        function submitContactUpdate(e) {
            e.preventDefault();
            
            const params = new URLSearchParams();
            params.append('action', 'updateContact');
            params.append('firstName', document.getElementById('firstName').value);
            params.append('lastName', document.getElementById('lastName').value);
            params.append('email', document.getElementById('email').value);
            params.append('phoneNo', document.getElementById('phoneNo').value);
            params.append('address', document.getElementById('address').value);
            params.append('city', document.getElementById('city').value);
            params.append('state', document.getElementById('state').value);
            params.append('zipCode', document.getElementById('zipCode').value);
            
            fetch('${pageContext.request.contextPath}/update-profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || err.message || 'Failed to update contact card'); });
                }
                return response.json();
            })
            .then(data => {
                showResponseToast(data.message || 'Contact details updated successfully!', true);
                const fullName = document.getElementById('firstName').value + ' ' + document.getElementById('lastName').value;
                const bannerName = document.querySelector('.profile-banner h3');
                if (bannerName) {
                    bannerName.innerText = fullName;
                }
            })
            .catch(error => {
                showResponseToast(error.message, false);
            });
        }

        function submitPasswordUpdate(e) {
            e.preventDefault();
            
            const oldPassword = document.getElementById('oldPasswordInput').value;
            const newPassword = document.getElementById('newPasswordInput').value;
            
            const params = new URLSearchParams();
            params.append('action', 'updatePassword');
            params.append('oldPassword', oldPassword);
            params.append('newPassword', newPassword);
            
            fetch('${pageContext.request.contextPath}/update-profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || err.message || 'Failed to change password'); });
                }
                return response.json();
            })
            .then(data => {
                showResponseToast(data.message || 'Password changed successfully!', true);
                document.getElementById('passwordUpdateForm').reset();
            })
            .catch(error => {
                showResponseToast(error.message, false);
            });
        }

        function submitPinUpdate(e) {
            e.preventDefault();
            
            const newPin = document.getElementById('newPinInput').value;
            
            const params = new URLSearchParams();
            params.append('action', 'updatePin');
            params.append('newPin', newPin);
            
            fetch('${pageContext.request.contextPath}/update-profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || err.message || 'Failed to update transaction PIN'); });
                }
                return response.json();
            })
            .then(data => {
                showResponseToast(data.message || 'Transaction PIN updated successfully!', true);
                document.getElementById('pinUpdateForm').reset();
            })
            .catch(error => {
                showResponseToast(error.message, false);
            });
        }

        function togglePasswordVisibility(inputId, icon) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bx-hide');
                icon.classList.add('bx-show');
            } else {
                input.type = 'password';
                icon.classList.remove('bx-show');
                icon.classList.add('bx-hide');
            }
        }

        /* --- Full Screen Avatar Lightbox Methods --- */
        function openLightbox(imgSrc) {
            if (!imgSrc) {
                // If there's no custom avatar path, ignore preview request
                return;
            }
            const lightbox = document.getElementById('imageLightbox');
            const lightboxImg = document.getElementById('lightboxImg');
            const wrapper = document.getElementById('lightboxImageWrapper');
            
            lightboxImg.src = imgSrc;
            lightbox.style.display = 'flex';
            
            // Wait for display rendering then trigger entry animations
            setTimeout(() => {
                lightbox.style.opacity = '1';
                wrapper.style.transform = 'scale(1)';
            }, 15);
        }

        function closeLightbox() {
            const lightbox = document.getElementById('imageLightbox');
            const wrapper = document.getElementById('lightboxImageWrapper');
            
            lightbox.style.opacity = '0';
            wrapper.style.transform = 'scale(0.9)';
            
            setTimeout(() => {
                lightbox.style.display = 'none';
            }, 300);
        }

        function uploadAvatarDynamically() {
            const fileInput = document.getElementById('avatarFileInput');
            if (fileInput.files.length === 0) {
                return;
            }
            
            const file = fileInput.files[0];
            
            // Front-end validation for type
            if (!file.type.startsWith('image/')) {
                showResponseToast('Only image files (JPEG, PNG, GIF) are allowed.', false);
                fileInput.value = '';
                return;
            }
            
            // Show dynamic uploading feedback
            showResponseToast('Uploading profile picture...', true);
            
            const formData = new FormData();
            formData.append('avatarFile', file);
            
            fetch('${pageContext.request.contextPath}/upload-profile', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json'
                },
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { 
                        throw new Error(err.error || err.message || 'Failed to upload profile picture.'); 
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const relativePath = data.avatarPath;
                    const absolutePath = '${pageContext.request.contextPath}' + relativePath;
                    
                    // Update avatar elements dynamically
                    const clickContainer = document.getElementById('avatarClickContainer');
                    if (clickContainer) {
                        clickContainer.innerHTML = `<img id="avatarImageRef" src="${absolutePath}" alt="Profile Avatar" style="width: 100%; height: 100%; object-fit: cover;">`;
                        clickContainer.onclick = function() {
                            openLightbox(absolutePath);
                        };
                    }
                    
                    fileInput.value = '';
                    showResponseToast('Profile picture uploaded successfully!', true);
                } else {
                    showResponseToast('Failed to update profile picture.', false);
                }
            })
            .catch(error => {
                showResponseToast(error.message, false);
                fileInput.value = '';
            });
        }
    </script>
</body>
</html>
