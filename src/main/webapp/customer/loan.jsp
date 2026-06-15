<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Apply and Manage Loans</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
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

        /* Loan Card Grid Styling */
        .loans-category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .loan-product-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 22px 20px;
            text-align: center;
            cursor: pointer;
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .loan-product-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-500);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.15);
        }
        .loan-product-card h4 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 8px;
            font-family: 'Poppins', sans-serif;
        }
        .loan-product-card p {
            font-size: 0.75rem;
            color: var(--gray-400);
            line-height: 1.5;
            margin-bottom: 15px;
            flex-grow: 1;
        }
        .loan-product-card .rate-badge {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--primary-500);
            margin-bottom: 12px;
        }
        .loan-product-card .btn {
            margin-top: auto;
        }

        /* Printable paper layout */
        .loan-paper-form {
            background: #fff;
            border: 1.5px solid var(--gray-200);
            padding: 40px;
            border-radius: var(--radius-sm);
            color: #1e293b;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.95rem;
            line-height: 1.6;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-lg);
            position: relative;
            max-width: 800px;
            margin: 0 auto;
        }
        .loan-paper-form h1, .loan-paper-form h2, .loan-paper-form h3, .loan-paper-form h4 {
            font-family: 'Poppins', sans-serif;
            color: #0f172a;
        }
        .loan-paper-form h1 {
            font-size: 1.5rem;
            font-weight: 800;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px double #475569;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }
        .loan-paper-form h2 {
            font-size: 1.05rem;
            font-weight: 700;
            border-bottom: 1px solid #94a3b8;
            padding-bottom: 4px;
            margin-top: 25px;
            margin-bottom: 15px;
            text-transform: uppercase;
            color: #475569;
            letter-spacing: 0.5px;
        }
        .loan-paper-form table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        .loan-paper-form td {
            padding: 6px 0;
            vertical-align: middle;
        }
        .loan-paper-form input[type="text"], .loan-paper-form input[type="date"], .loan-paper-form input[type="number"], .loan-paper-form select {
            border: none;
            border-bottom: 1px dotted #475569 !important;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
            width: 100%;
            padding: 2px 5px;
        }
        .loan-paper-form input[type="radio"], .loan-paper-form input[type="checkbox"] {
            cursor: pointer;
            margin-right: 5px;
        }
        
        /* Centered modal customizer */
        .modal-body::-webkit-scrollbar {
            width: 6px;
        }
        .modal-body::-webkit-scrollbar-thumb {
            background-color: var(--gray-300);
            border-radius: var(--radius-full);
        }

        /* Print layout centering using absolute target */
        @media print {
            body * {
                visibility: hidden !important;
            }
            #loanApplicationModal, #loanApplicationModal * {
                visibility: visible !important;
            }
            #loanApplicationModal {
                position: absolute !important;
                left: 0 !important;
                top: 0 !important;
                width: 100% !important;
                height: auto !important;
                overflow: visible !important;
                background: white !important;
                padding: 0 !important;
                display: flex !important;
            }
            .modal-content {
                box-shadow: none !important;
                border: none !important;
                width: 100% !important;
                max-width: 100% !important;
                padding: 0 !important;
                margin: 0 !important;
                background: white !important;
            }
            .modal-body {
                overflow: visible !important;
                max-height: none !important;
                padding: 0 !important;
            }
            .loan-paper-form {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                width: 100% !important;
                max-width: 100% !important;
            }
            .no-print {
                display: none !important;
            }
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
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list" class="active"><i class="bx bx-building-house"></i> Loans</a>
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
        <div class="container" style="max-width: 1200px; padding: 0;">
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Secure Lending Solutions</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Simulate monthly EMI payments, submit digital application requests, and pay active balances.</p>
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

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <!-- EMI Simulator -->
                <div class="glass-card">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 10px;"><i class="bx bx-calculator"></i> VGB Premium EMI Calculator</h3>
                    
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="calcAmount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Principal Amount (₹)</label>
                        <input type="number" id="calcAmount" value="500000" min="50000" max="50000000" oninput="calculateEMI()" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;" class="mobile-grid-1">
                        <div class="form-group">
                            <label for="calcRate" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Annual Interest Rate (%)</label>
                            <select id="calcRate" onchange="calculateEMI()" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
                                <option value="7.50" selected>Home Secure Loan (7.50%)</option>
                                <option value="8.50">Vehicle Purchase Loan (8.50%)</option>
                                <option value="6.50">Higher Education Loan (6.50%)</option>
                                <option value="12.00">Personal Cash Loan (12.00%)</option>
                                <option value="10.50">Business Capital Loan (10.50%)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="displayCalcTermVal" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Tenure Duration</label>
                            <div style="display: flex; gap: 10px;">
                                <input type="number" id="displayCalcTermVal" value="10" min="1" max="30" required style="flex-grow: 1; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;" oninput="syncCalcTerm()">
                                <select id="calcTermUnit" style="width: 110px; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;" onchange="syncCalcTerm()">
                                    <option value="years" selected>Years</option>
                                    <option value="months">Months</option>
                                </select>
                            </div>
                            <input type="hidden" id="calcTerm" value="120">
                        </div>
                    </div>                    <div style="background: var(--gradient-secondary); padding: 20px; border-radius: var(--radius-md); color: white; text-align: center; margin-top: 25px; box-shadow: var(--shadow-sm);">
                        <span style="display: block; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9;">Estimated Monthly Payment</span>
                        <strong style="font-size: 2.2rem; font-weight: 800; display: block; margin-top: 5px;" id="emiResult">₹ 0.00</strong>
                        <span style="font-size: 0.75rem; opacity: 0.85; display: block; margin-top: 3px;">Subject to terms &amp; final physical document verification.</span>
                    </div>
                </div>

                <!-- Promotional Info Column -->
                <div class="glass-card" style="display: flex; flex-direction: column; justify-content: space-between; background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(168, 85, 247, 0.05) 100%);">
                    <div>
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); margin-bottom: 15px;"><i class="bx bx-star" style="color: #eab308;"></i> Why VGB Premium Lending?</h3>
                        <p style="font-size: 0.9rem; color: var(--gray-600); line-height: 1.6; margin-bottom: 20px;">
                            Vertex Galaxy Bank offers custom-tailored credit solutions featuring highly competitive fixed interest rates, flexible tenure options up to 30 years, and instant digital credit assessment. 
                        </p>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                <i class="bx bx-check-double" style="color: var(--primary-500); font-size: 1.2rem;"></i>
                                <span>Zero hidden charges &amp; fully transparent terms</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                <i class="bx bx-check-double" style="color: var(--primary-500); font-size: 1.2rem;"></i>
                                <span>Flexible EMI repayments auto-debited securely</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                <i class="bx bx-check-double" style="color: var(--primary-500); font-size: 1.2rem;"></i>
                                <span>Direct administrative verification with instant updates</span>
                            </div>
                        </div>
                    </div>
                    <div style="border-top: 1px solid rgba(99, 102, 241, 0.1); padding-top: 15px; margin-top: 20px; font-size: 0.85rem; color: var(--gray-50); font-style: italic;">
                        Please select one of the loan products below to fill in your printable formal application form.
                    </div>
                </div>
            </div>

            <!-- Premium Loan Products Section -->
            <div style="margin-bottom: 40px;">
                <h3 style="font-size: 1.5rem; font-weight: 800; color: var(--gray-900); margin-bottom: 10px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-gift" style="color: var(--primary-500);"></i>
                    <span>Select a Premium Loan Solution</span>
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 20px;">Choose a specialized loan product based on your financial goals. Click **Apply Now** to open the formal application form.</p>
                
                <div class="loans-category-grid">
                    <!-- Personal Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('personal', 12.00, 1500000)">
                        <div>
                            <h4>Personal Cash Loan</h4>
                            <p>Unsecured personal financing for instant cash requirements, medical expenses, or emergency funds.</p>
                        </div>
                        <div>
                            <div class="rate-badge">12.00% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">Max: ₹ 15,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 8px 12px; font-size: 0.75rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Home Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('home', 7.50, 50000000)">
                        <div>
                            <h4>Home Secure Loan</h4>
                            <p>Realize your dream home with low rates, customized repayment timelines, and easy paper processing.</p>
                        </div>
                        <div>
                            <div class="rate-badge">7.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">Max: ₹ 5,00,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 8px 12px; font-size: 0.75rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Vehicle Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('vehicle', 8.50, 5000000)">
                        <div>
                            <h4>Vehicle Purchase Loan</h4>
                            <p>Drive your dream car or vehicle home with instant disbursals, high limits, and flexible tenure plans.</p>
                        </div>
                        <div>
                            <div class="rate-badge">8.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">Max: ₹ 50,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 8px 12px; font-size: 0.75rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Education Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('education', 6.50, 4000000)">
                        <div>
                            <h4>Higher Education Loan</h4>
                            <p>Fund premium global academic pursuits, covering university fees, travel, and accommodation costs.</p>
                        </div>
                        <div>
                            <div class="rate-badge">6.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">Max: ₹ 40,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 8px 12px; font-size: 0.75rem;">Apply Now</button>
                        </div>
                    </div>

                    <!-- Business Loan -->
                    <div class="loan-product-card" onclick="showLoanDetails('business', 10.50, 10000000)">
                        <div>
                            <h4>Business Capital Loan</h4>
                            <p>Power your business venture, purchase heavy equipment, expand infrastructure, or boost cashflow.</p>
                        </div>
                        <div>
                            <div class="rate-badge">10.50% <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 500;">P.A.</span></div>
                            <div style="font-size: 0.75rem; color: var(--gray-500); margin-bottom: 12px; font-weight: 600;">Max: ₹ 1,00,00,000</div>
                            <button type="button" class="btn btn-primary" style="width: 100%; padding: 8px 12px; font-size: 0.75rem;">Apply Now</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Existing Loans Ledger -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-receipt"></i> Active Loan Portfolio Ledger</h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Loan ID</th>
                                <th style="padding: 12px 15px;">Loan Type</th>
                                <th style="padding: 12px 15px;">Interest Rate</th>
                                <th style="padding: 12px 15px;">Principal</th>
                                <th style="padding: 12px 15px;">Remaining Balance</th>
                                <th style="padding: 12px 15px; text-align: right;">Monthly EMI</th>
                                <th style="padding: 12px 15px;">Maturity Date</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: center;">Repay EMI</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty loans}">
                                    <c:forEach var="loan" items="${loans}">
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-family: monospace;">#LN-${loan.loanId}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 500;">${loan.loanType}</td>
                                            <td style="padding: 15px;">${loan.interestRate}% P.A.</td>
                                            <td style="padding: 15px; font-weight: 600;">₹ <fmt:formatNumber value="${loan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="padding: 15px; font-weight: 600; color: #ef4444;">₹ <fmt:formatNumber value="${loan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="padding: 15px; text-align: right; font-weight: 600; color: var(--gray-800);">₹ <fmt:formatNumber value="${loan.monthlyEMI}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${not empty loan.endDate}">
                                                        ${loan.endDate}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-400); font-style: italic;">Pending Approval</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px;">
                                                <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">${loan.status}</span>
                                            </td>
                                            <td style="padding: 15px; text-align: center;">
                                                <c:if test="${loan.status == 'active' or loan.status == 'approved' or loan.status == 'disbursed'}">
                                                    <button type="button" class="btn btn-secondary" onclick="openRepayModal('${loan.loanId}', '${loan.remainingBalance}')" style="padding: 6px 12px; font-size: 0.75rem;"><i class="bx bx-wallet-alt"></i> Repay EMI</button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 30px; color: var(--gray-400);">No active or pending loans found for this profile.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Repay EMI Modal Overlay (Simple Glassmorphic Alert Box) -->
        <div id="repayModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; padding: 20px;">
            <div class="glass-card" style="width: 100%; max-width: 500px; background: white; border: 1px solid rgba(99, 102, 241, 0.2); box-shadow: var(--shadow-2xl); position: relative;">
                <button type="button" onclick="closeRepayModal()" style="position: absolute; top: 20px; right: 20px; font-size: 1.5rem; color: var(--gray-400); cursor: pointer; border: none; background: transparent;"><i class="bx bx-x"></i></button>
                
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); margin-bottom: 15px;"><i class="bx bx-wallet-alt"></i> Process Loan EMI Auto-Debit</h3>
                <form action="${pageContext.request.contextPath}/loan?action=repayment" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="loanId" id="modalLoanId">

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="modalRemaining" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Remaining Balance (₹)</label>
                        <input type="text" id="modalRemaining" readonly style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: var(--gray-100); outline: none;">
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="modalAccount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Select Checking/Savings Account to Debit</label>
                        <select id="modalAccount" name="accountId" required style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; outline: none;">
                            <c:forEach var="acc" items="${accounts}">
                                <option value="${acc.accountId}">Account #${acc.accountId} (${acc.accountType}) - Bal: ₹ ${acc.balance}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 25px;">
                        <label for="modalAmount" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Payment Amount (₹)</label>
                        <input type="number" step="0.01" min="100" id="modalAmount" name="amount" required placeholder="E.g., 5000" style="width: 100%; padding: 12px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                    </div>

                    <div style="display: flex; gap: 15px; justify-content: flex-end;">
                        <button type="button" class="btn btn-secondary" onclick="closeRepayModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <span>Execute Debit</span>
                            <i class="bx bx-check-double"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- High-Fidelity Premium Loan Details Modal -->
        <div id="loanDetailsModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); z-index: 1050; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
            <div class="modal-content" style="width: 100%; max-width: 650px; background: white; border-radius: var(--radius-lg); box-shadow: var(--shadow-2xl); border: 1px solid rgba(99, 102, 241, 0.2); display: flex; flex-direction: column; overflow: hidden;">
                <!-- Header with premium gradient background -->
                <div style="padding: 25px 30px; background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%); display: flex; justify-content: space-between; align-items: center; color: white;">
                    <h3 id="detailsModalTitle" style="font-size: 1.35rem; font-weight: 800; display: flex; align-items: center; gap: 10px; margin: 0; letter-spacing: 0.5px;">
                        <i class="bx bx-info-circle" style="font-size: 1.6rem;"></i>
                        <span>Loan Product Specification</span>
                    </h3>
                    <button type="button" onclick="closeDetailsModal()" style="font-size: 1.6rem; color: rgba(255, 255, 255, 0.8); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='rgba(255, 255, 255, 0.8)'"><i class="bx bx-x"></i></button>
                </div>
                
                <!-- Body with loan type specifications -->
                <div style="padding: 30px; background: var(--gray-50); flex-grow: 1; max-height: 70vh; overflow-y: auto;">
                    <!-- Overview Section -->
                    <div style="background: white; padding: 20px; border-radius: var(--radius-md); border: 1px solid var(--gray-200); margin-bottom: 20px;">
                        <p id="detailsDescription" style="font-size: 0.95rem; color: var(--gray-700); line-height: 1.6; margin: 0;"></p>
                    </div>
                    
                    <!-- Rate & Limit badges -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px;">
                        <div style="background: rgba(99, 102, 241, 0.05); border: 1.5px solid rgba(99, 102, 241, 0.15); padding: 15px; border-radius: var(--radius-md); text-align: center;">
                            <span style="font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; display: block;">Fixed Interest Rate</span>
                            <strong id="detailsInterestRate" style="font-size: 1.6rem; color: var(--primary-600); font-weight: 800; display: block; margin-top: 5px;"></strong>
                        </div>
                        <div style="background: rgba(16, 185, 129, 0.05); border: 1.5px solid rgba(16, 185, 129, 0.15); padding: 15px; border-radius: var(--radius-md); text-align: center;">
                            <span style="font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; display: block;">Maximum Credit Limit</span>
                            <strong id="detailsMaxLimit" style="font-size: 1.6rem; color: var(--accent-emerald); font-weight: 800; display: block; margin-top: 5px;"></strong>
                        </div>
                    </div>
                    
                    <!-- Benefits grid -->
                    <div style="margin-bottom: 25px;">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-check-shield" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                            <span>Key Product Benefits</span>
                        </h4>
                        <ul id="detailsBenefits" style="list-style: none; padding: 0; margin: 0; display: grid; grid-template-columns: 1fr; gap: 8px;">
                        </ul>
                    </div>

                    <!-- Eligibility & Docs columns -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;" class="mobile-grid-1">
                        <div>
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-user" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                <span>Eligibility Criteria</span>
                            </h4>
                            <ul id="detailsEligibility" style="padding-left: 20px; margin: 0; font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            </ul>
                        </div>
                        <div>
                            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.25rem;"></i>
                                <span>Required Documentation</span>
                            </h4>
                            <ul id="detailsDocuments" style="padding-left: 20px; margin: 0; font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Footer buttons -->
                <div style="padding: 20px 30px; border-top: 1px solid var(--gray-200); display: flex; justify-content: flex-end; gap: 15px; background: white;">
                    <button type="button" class="btn btn-secondary" onclick="closeDetailsModal()" style="padding: 10px 22px;">Close</button>
                    <button type="button" id="detailsApplyBtn" class="btn btn-primary" style="padding: 10px 25px; display: flex; align-items: center; gap: 8px; background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                        <span>Apply Now</span>
                        <i class="bx bx-chevron-right"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Printable formal Loan Application Form Modal -->
        <div id="loanApplicationModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); z-index: 1000; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
            <div class="modal-content" style="width: 100%; max-width: 850px; background: white; border-radius: var(--radius-lg); box-shadow: var(--shadow-2xl); border: 1px solid rgba(99, 102, 241, 0.2); display: flex; flex-direction: column; max-height: 90vh;">
                <div class="modal-header no-print" style="padding: 20px 30px; border-bottom: 1px solid var(--gray-200); display: flex; justify-content: space-between; align-items: center; background: var(--gray-50); border-top-left-radius: var(--radius-lg); border-top-right-radius: var(--radius-lg);">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 10px;">
                        <i class="bx bx-file" style="color: var(--primary-500); font-size: 1.5rem;"></i>
                        <span>Official Loan Application Form</span>
                    </h3>
                    <button type="button" onclick="closeLoanModal()" style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none; outline: none; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-900)'" onmouseout="this.style.color='var(--gray-400)'"><i class="bx bx-x"></i></button>
                </div>
                
                <div class="modal-body" style="padding: 30px; overflow-y: auto; flex-grow: 1; background: var(--gray-100);">
                    <form id="actualLoanForm" action="${pageContext.request.contextPath}/loan?action=apply" method="post" onsubmit="serializeLoanForm(event)">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        
                        <!-- Main hidden inputs submitted to server -->
                        <input type="hidden" id="submitLoanType" name="loanType">
                        <input type="hidden" id="submitAmount" name="amount">
                        <input type="hidden" id="submitTermMonths" name="termMonths">
                        <input type="hidden" id="submitInterestRate" name="interestRate">
                        <input type="hidden" id="submitFormDetails" name="formDetails">

                        <div class="loan-paper-form">
                            <h1>Loan Application Form</h1>
                            
                            <!-- 1. Applicant Information -->
                            <h2>1. Applicant Information</h2>
                            <table>
                                <tr>
                                    <td style="width: 30%; font-weight: bold;">Full Name:</td>
                                    <td style="width: 70%;"><input type="text" id="formFullName" value="${customer.fullName}" readonly style="font-weight: 600;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Father's / Husband's Name:</td>
                                    <td><input type="text" id="formRelationName" placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Date of Birth:</td>
                                    <td><input type="date" id="formDob" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Gender:</td>
                                    <td>
                                        <div style="display: flex; gap: 20px;">
                                            <label><input type="radio" name="formGender" value="Male" required> Male</label>
                                            <label><input type="radio" name="formGender" value="Female"> Female</label>
                                            <label><input type="radio" name="formGender" value="Other"> Other</label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Mobile Number:</td>
                                    <td><input type="text" id="formMobile" value="${customer.phoneNo}" readonly></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Email Address:</td>
                                    <td><input type="text" id="formEmail" value="${customer.email}" readonly></td>
                                </tr>
                            </table>

                            <!-- 2. Address Details -->
                            <h2>2. Address Details</h2>
                            <h3 style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 10px 0 5px 0;">Current Address</h3>
                            <div style="border-bottom: 1px dotted #475569; padding: 5px 0 10px 0; margin-bottom: 10px; font-weight: 600;">
                                ${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}
                                <input type="hidden" id="formCurrentAddress" value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                            </div>

                            <h3 style="font-size: 0.95rem; font-weight: 700; color: #475569; margin: 15px 0 5px 0;">Permanent Address</h3>
                            <div style="margin-bottom: 10px;" class="no-print">
                                <label style="font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                    <input type="checkbox" id="sameAsCurrent" onchange="copyCurrentAddress(this)"> Same as Current Address
                                </label>
                            </div>
                            <textarea id="formPermanentAddress" placeholder="______________________________________________________" required style="width: 100%; border: none; border-bottom: 1px dotted #475569; font-family: inherit; font-size: inherit; font-weight: 600; outline: none; background: transparent; resize: none; height: 50px;"></textarea>

                            <!-- 3. Identity Details -->
                            <h2>3. Identity Details</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Aadhaar Number:</td>
                                    <td style="width: 65%;"><input type="text" id="formAadhaar" value="${customer.aadhaarCard}" readonly></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">PAN Number:</td>
                                    <td><input type="text" id="formPan" value="${customer.panCard}" readonly style="text-transform: uppercase;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Voter ID / Driving License No.:</td>
                                    <td><input type="text" id="formVoterDl" placeholder="___________________________" required></td>
                                </tr>
                            </table>

                            <!-- 4. Employment Information -->
                            <h2>4. Employment Information</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Occupation:</td>
                                    <td style="width: 65%;"><input type="text" id="formOccupation" placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Company / Business Name:</td>
                                    <td><input type="text" id="formCompanyName" placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Monthly Income:</td>
                                    <td><input type="number" id="formMonthlyIncome" placeholder="₹ ______________________" required min="1000"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Work Experience:</td>
                                    <td><input type="text" id="formExperience" placeholder="_____________________" required></td>
                                </tr>
                            </table>

                            <!-- 5. Bank Account Details -->
                            <h2>5. Bank Account Details</h2>
                            <p style="font-size: 0.85rem; font-style: italic; color: #64748b; margin-bottom: 10px;" class="no-print">Choose one of your active VGB savings or checking accounts to link with this loan for disbursal and EMI payments.</p>
                            <table>
                                <tr class="no-print">
                                    <td style="width: 35%; font-weight: bold;">Select Account to Link:</td>
                                    <td style="width: 65%;">
                                        <select id="formLinkAccount" onchange="syncLinkedAccountDetails(this)" style="font-weight: 600; padding: 5px; cursor: pointer;">
                                            <option value="" disabled selected>-- Select Your VGB Account --</option>
                                            <c:forEach var="acc" items="${accounts}">
                                                <option value="${acc.accountId}" data-acc-no="${acc.accountNumber}" data-ifsc="${acc.ifscCode}" data-type="${acc.accountType}">
                                                    Account #${acc.accountId} (${acc.accountType})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Account Holder Name:</td>
                                    <td style="width: 65%;"><input type="text" id="formAccHolderName" value="${customer.fullName}" readonly></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Account Number:</td>
                                    <td><input type="text" id="formAccNo" readonly placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">IFSC Code:</td>
                                    <td><input type="text" id="formIfsc" readonly placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Branch:</td>
                                    <td><input type="text" id="formBranch" readonly value="VGB Main Branch" style="font-weight: 600;"></td>
                                </tr>
                            </table>

                            <!-- 6. Loan Details -->
                            <h2>6. Loan Details</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Loan Type:</td>
                                    <td style="width: 65%;"><input type="text" id="formLoanTypeDisplay" readonly style="font-weight: bold; text-transform: uppercase;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Requested Amount (₹):</td>
                                    <td><input type="number" id="formLoanAmount" placeholder="______________________" required oninput="calculatePaperEMI()"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Tenure Duration:</td>
                                    <td>
                                        <div style="display: flex; gap: 10px;">
                                            <input type="number" id="formLoanTermVal" placeholder="Tenure" required style="width: 60%;" oninput="syncPaperTermMonths()">
                                            <select id="formLoanTermUnit" style="width: 40%; font-weight: 600;" onchange="syncPaperTermMonths()">
                                                <option value="years" selected>Years</option>
                                                <option value="months">Months</option>
                                            </select>
                                        </div>
                                        <input type="hidden" id="formLoanTermMonths">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Fixed Interest Rate:</td>
                                    <td><input type="text" id="formLoanRate" readonly style="font-weight: 600; color: var(--primary-500);"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Purpose of Loan:</td>
                                    <td><input type="text" id="formLoanPurpose" placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Estimated Monthly EMI:</td>
                                    <td style="font-weight: bold; font-size: 1.1rem; color: #0f172a;" id="formPaperEmiDisplay">₹ 0.00</td>
                                </tr>
                            </table>

                            <!-- 7. Nominee Information -->
                            <h2>7. Nominee Information</h2>
                            <table>
                                <tr>
                                    <td style="width: 35%; font-weight: bold;">Nominee Name:</td>
                                    <td style="width: 65%;"><input type="text" id="formNomineeName" placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Relationship with Applicant:</td>
                                    <td><input type="text" id="formNomineeRelationship" placeholder="___________________________" required></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold;">Nominee Mobile Number:</td>
                                    <td><input type="text" id="formNomineeMobile" placeholder="___________________________" required pattern="[0-9]{10}"></td>
                                </tr>
                            </table>

                            <!-- 8. Declaration -->
                            <h2>8. Declaration</h2>
                            <div style="margin-bottom: 20px; font-size: 0.9rem; text-align: justify; line-height: 1.5; color: #334155;">
                                <label style="cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                    <input type="checkbox" id="formDeclarationCheckbox" required style="margin-top: 4px;">
                                    <span>I hereby declare that the details furnished above are true and correct to the best of my knowledge and belief and I undertake to inform Vertex Galaxy Bank of any changes therein, immediately. In case any of the above information is found to be false or untrue or misleading, I am aware that I may be held liable for it. I authorize the Bank to debit my linked account for recovery of EMI.</span>
                                </label>
                            </div>

                            <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; margin-top: 30px;">
                                <div>
                                    <table style="margin-bottom: 0;">
                                        <tr>
                                            <td style="width: 30%; font-weight: bold;">Date:</td>
                                            <td style="width: 70%;"><input type="text" id="formDeclarationDate" readonly></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight: bold;">Place:</td>
                                            <td><input type="text" id="formDeclarationPlace" placeholder="___________________________" required></td>
                                        </tr>
                                    </table>
                                </div>
                                <div style="text-align: center; display: flex; flex-direction: column; justify-content: flex-end; align-items: center;">
                                    <input type="text" id="formSignature" placeholder="Type to sign" required style="text-align: center; font-family: 'Brush Script MT', cursive, Georgia, serif; font-size: 1.5rem; border-bottom: 1.5px solid #000 !important; width: 85%;">
                                    <span style="font-size: 0.75rem; font-weight: bold; color: #475569; text-transform: uppercase; margin-top: 5px; display: block;">Applicant's Signature</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons (inside form, shown only on screen) -->
                        <div class="no-print" style="margin-top: 30px; display: flex; gap: 15px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid var(--gray-200);">
                            <button type="button" class="btn btn-secondary" onclick="closeLoanModal()" style="padding: 10px 22px;">Close</button>
                            <button type="button" class="btn btn-secondary" onclick="printApplicationForm()" style="padding: 10px 22px; display: flex; align-items: center; gap: 8px; border: 1.5px solid var(--gray-300); color: var(--gray-700); background: white;">
                                <i class="bx bx-printer"></i>
                                <span>Print Form</span>
                            </button>
                            <button type="submit" class="btn btn-primary" style="padding: 10px 25px;">
                                <span>Submit Application</span>
                                <i class="bx bx-paper-plane"></i>
                            </button>
                        </div>
                    </form>
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
        let currentMaxLimit = 50000000;

        const loanSpecs = {
            'personal': {
                title: 'Personal Cash Loan',
                description: 'Unsecured personal financing tailored for instant cash requirements, medical expenses, vacation planning, or emergency funds. No collateral required, with direct instant disbursal to your active savings or checking account.',
                benefits: [
                    'Zero collateral or security requirements',
                    'Flexible repayment tenure ranges from 12 to 60 months',
                    'Direct bank transfer with minimal digital paperwork',
                    'Fully transparent pricing - zero hidden charges'
                ],
                eligibility: [
                    'Age: 21 to 60 years old',
                    'Salaried or self-employed with stable income stream',
                    'Minimum monthly net income: ₹ 25,000'
                ],
                documents: [
                    'Valid PAN Card & Aadhaar Card',
                    'Last 3 months salary slips or income proofs',
                    '6 months active bank account statements'
                ]
            },
            'home': {
                title: 'Home Secure Loan',
                description: 'Realize your dream home with Vertex Galaxy Bank\'s purchase, construction, or renovation lending solution. Featuring our lowest rates, high tenure lengths up to 30 years, and tax exemption benefits.',
                benefits: [
                    'Extremely low fixed interest rates at 7.50% P.A.',
                    'Repayment tenure flexibility up to 360 months (30 years)',
                    'Income tax deduction benefits on principal and interest',
                    'Property evaluation and legal consulting services included'
                ],
                eligibility: [
                    'Age: 21 to 65 years old',
                    'Consistent salaried/business income profiles',
                    'Minimum monthly net income: ₹ 40,000',
                    'Clear, marketable legal title of the property'
                ],
                documents: [
                    'Valid PAN Card & Aadhaar Card',
                    'Property sale agreement & builder NOC',
                    '3 years filed income tax returns (ITR)',
                    'Last 6 months active bank statements'
                ]
            },
            'vehicle': {
                title: 'Vehicle Purchase Loan',
                description: 'Drive your dream car or commercial vehicle home with high credit limits, up to 90% funding of the on-road price, and flexible repayment structures tailored to your monthly cashflow.',
                benefits: [
                    'Up to 90% financing on the vehicle\'s on-road price',
                    'Instant digital credit validation and quick disbursals',
                    'Flexible tenure periods up to 84 months (7 years)',
                    'Attractive dealership tie-ups for added savings'
                ],
                eligibility: [
                    'Age: 18 to 65 years old',
                    'Stable source of salaried or self-employed income',
                    'Minimum monthly net income: ₹ 30,000'
                ],
                documents: [
                    'Valid PAN Card & Aadhaar Card',
                    'Proforma invoice of the selected vehicle',
                    '3 months salary slips or business income proofs',
                    '6 months active bank statements'
                ]
            },
            'education': {
                title: 'Higher Education Loan',
                description: 'Fund global academic pursuits at premium national and international universities. Vertex Galaxy Bank covers all your academic fees, boarding, travel, and laptop requirements, with a moratorium period during course completion.',
                benefits: [
                    'Attractive low rate of 6.50% P.A. for meritorious students',
                    'Covers 100% of college fee, hostel, travel, and study tools',
                    'Moratorium period: Repayments start 1 year after course completion',
                    'Section 80E income tax interest deduction benefits'
                ],
                eligibility: [
                    'Confirmed admission in recognized global/national institution',
                    'Co-applicant (parent/spouse/guardian) with active income',
                    'Acceptable academic credentials (10th, 12th, or graduation)'
                ],
                documents: [
                    'Admission letter from university with fee structure',
                    'Applicant\'s academic marks sheets (10th/12th/Graduation)',
                    'KYC of both student applicant and co-borrower',
                    'Income proof and bank statements of co-borrower'
                ]
            },
            'business': {
                title: 'Business Capital Loan',
                description: 'Power your business operations, upgrade machinery, expand operations, or bolster working capital with our premium, high-limit Business Capital Loan offering quick processing and customized corporate repayment schedules.',
                benefits: [
                    'High credit funding limits up to ₹ 1,00,00,000',
                    'Flexible repayment structures based on business cashflow cycles',
                    'Quick credit scoring and streamlined administrative approvals',
                    'Helps scale operations, inventory stock, or raw material procurement'
                ],
                eligibility: [
                    'Minimum 2 years of active business vintage',
                    'Satisfactory business credit score (CIBIL/CRF)',
                    'Profitable operations for the last two financial years'
                ],
                documents: [
                    'Entity business PAN Card, GST registration certificates',
                    '2 years audited business financial statement papers',
                    '1 year business primary checking statements',
                    'KYC of all directors/promoters/partners'
                ]
            }
        };

        function showLoanDetails(type, rate, maxLimit) {
            const spec = loanSpecs[type];
            if (!spec) return;
            
            document.getElementById('detailsModalTitle').querySelector('span').textContent = spec.title + " Specification";
            document.getElementById('detailsDescription').textContent = spec.description;
            document.getElementById('detailsInterestRate').textContent = rate.toFixed(2) + "% Fixed P.A.";
            document.getElementById('detailsMaxLimit').textContent = "₹ " + maxLimit.toLocaleString('en-IN');
            
            // Benefits list
            const benefitsList = document.getElementById('detailsBenefits');
            benefitsList.innerHTML = '';
            spec.benefits.forEach(benefit => {
                const li = document.createElement('li');
                li.style.display = 'flex';
                li.style.alignItems = 'flex-start';
                li.style.gap = '10px';
                li.style.fontSize = '0.88rem';
                li.style.color = 'var(--gray-700)';
                li.style.lineHeight = '1.5';
                li.innerHTML = '<i class="bx bx-check" style="color: var(--accent-emerald); font-size: 1.25rem; margin-top: 2px;"></i><span>' + benefit + '</span>';
                benefitsList.appendChild(li);
            });
            
            // Eligibility list
            const eligibilityList = document.getElementById('detailsEligibility');
            eligibilityList.innerHTML = '';
            spec.eligibility.forEach(el => {
                const li = document.createElement('li');
                li.textContent = el;
                eligibilityList.appendChild(li);
            });
            
            // Documents list
            const documentsList = document.getElementById('detailsDocuments');
            documentsList.innerHTML = '';
            spec.documents.forEach(doc => {
                const li = document.createElement('li');
                li.textContent = doc;
                documentsList.appendChild(li);
            });
            
            // Bind the Apply Button action
            const applyBtn = document.getElementById('detailsApplyBtn');
            applyBtn.onclick = function() {
                closeDetailsModal();
                openLoanForm(type, rate, maxLimit);
            };
            
            document.getElementById('loanDetailsModal').style.display = 'flex';
        }
        
        function closeDetailsModal() {
            document.getElementById('loanDetailsModal').style.display = 'none';
        }

        function openLoanForm(type, rate, maxLimit) {
            currentMaxLimit = maxLimit;
            document.getElementById('formLoanTypeDisplay').value = type;
            document.getElementById('submitLoanType').value = type;
            
            document.getElementById('formLoanRate').value = rate.toFixed(2) + "% Fixed P.A.";
            document.getElementById('submitInterestRate').value = rate;

            const amountInput = document.getElementById('formLoanAmount');
            amountInput.max = maxLimit;
            amountInput.placeholder = "Max limit: ₹ " + maxLimit.toLocaleString('en-IN');
            amountInput.value = "";

            // Pre-fill today's date
            const today = new Date();
            const yyyy = today.getFullYear();
            let mm = today.getMonth() + 1;
            let dd = today.getDate();
            if (dd < 10) dd = '0' + dd;
            if (mm < 10) mm = '0' + mm;
            document.getElementById('formDeclarationDate').value = dd + '/' + mm + '/' + yyyy;

            // Reset other form fields
            document.getElementById('actualLoanForm').reset();
            
            // Re-populate readonly fields that standard reset might clear
            document.getElementById('formFullName').value = "${customer.fullName}";
            document.getElementById('formMobile').value = "${customer.phoneNo}";
            document.getElementById('formEmail').value = "${customer.email}";
            document.getElementById('formAadhaar').value = "${customer.aadhaarCard}";
            document.getElementById('formPan').value = "${customer.panCard}";
            document.getElementById('formLoanTypeDisplay').value = type;
            document.getElementById('formLoanRate').value = rate.toFixed(2) + "% Fixed P.A.";
            document.getElementById('formDeclarationDate').value = dd + '/' + mm + '/' + yyyy;
            document.getElementById('formBranch').value = "VGB Main Branch";
            document.getElementById('formAccHolderName').value = "${customer.fullName}";

            // Trigger term syncing to initial value
            document.getElementById('formLoanTermVal').value = 10;
            document.getElementById('formLoanTermUnit').value = "years";
            syncPaperTermMonths();

            document.getElementById('loanApplicationModal').style.display = 'flex';
        }

        function closeLoanModal() {
            document.getElementById('loanApplicationModal').style.display = 'none';
        }

        function copyCurrentAddress(checkbox) {
            const currentAddr = document.getElementById('formCurrentAddress').value;
            const permAddrField = document.getElementById('formPermanentAddress');
            if (checkbox.checked) {
                permAddrField.value = currentAddr;
            } else {
                permAddrField.value = "";
            }
        }

        function syncLinkedAccountDetails(select) {
            if (!select.value) return;
            const selectedOpt = select.options[select.selectedIndex];
            const accNo = selectedOpt.getAttribute('data-acc-no');
            const ifsc = selectedOpt.getAttribute('data-ifsc');
            
            document.getElementById('formAccNo').value = accNo;
            document.getElementById('formIfsc').value = ifsc;
        }

        function syncPaperTermMonths() {
            const valInput = document.getElementById('formLoanTermVal');
            const unit = document.getElementById('formLoanTermUnit').value;
            
            if (unit === 'years') {
                valInput.min = "1";
                valInput.max = "30";
                if (parseFloat(valInput.value) > 30) valInput.value = "30";
            } else {
                valInput.min = "12";
                valInput.max = "360";
                if (parseFloat(valInput.value) > 360) valInput.value = "360";
            }
            
            const val = parseInt(valInput.value) || 0;
            let months = val;
            if (unit === 'years') {
                months = val * 12;
            }
            document.getElementById('formLoanTermMonths').value = months;
            document.getElementById('submitTermMonths').value = months;
            calculatePaperEMI();
        }

        function calculatePaperEMI() {
            const amount = parseFloat(document.getElementById('formLoanAmount').value) || 0;
            const rateStr = document.getElementById('submitInterestRate').value;
            const rate = parseFloat(rateStr) || 0;
            const term = parseInt(document.getElementById('formLoanTermMonths').value) || 0;
            
            const emiDisplay = document.getElementById('formPaperEmiDisplay');
            
            if (amount <= 0 || rate <= 0 || term <= 0) {
                emiDisplay.textContent = "₹ 0.00";
                return;
            }

            const monthlyRate = (rate / 12) / 100;
            const emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, term)) / (Math.pow(1 + monthlyRate, term) - 1);
            
            emiDisplay.textContent = "₹ " + emi.toLocaleString('en-IN', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
        }

        function serializeLoanForm(event) {
            const amount = parseFloat(document.getElementById('formLoanAmount').value) || 0;
            if (amount > currentMaxLimit) {
                alert("The requested amount exceeds the maximum limit of ₹ " + currentMaxLimit.toLocaleString('en-IN') + " for this loan category.");
                event.preventDefault();
                return false;
            }

            const linkAcc = document.getElementById('formLinkAccount').value;
            if (!linkAcc) {
                alert("Please select a bank account to link to this loan.");
                event.preventDefault();
                return false;
            }

            // Gather all details for JSON serialization
            const details = {
                relationName: document.getElementById('formRelationName').value,
                dob: document.getElementById('formDob').value,
                gender: document.querySelector('input[name="formGender"]:checked')?.value || '',
                permanentAddress: document.getElementById('formPermanentAddress').value,
                voterDlNo: document.getElementById('formVoterDl').value,
                occupation: document.getElementById('formOccupation').value,
                companyName: document.getElementById('formCompanyName').value,
                monthlyIncome: document.getElementById('formMonthlyIncome').value,
                workExperience: document.getElementById('formExperience').value,
                linkedAccountId: document.getElementById('formLinkAccount').value,
                linkedAccountNo: document.getElementById('formAccNo').value,
                linkedIfsc: document.getElementById('formIfsc').value,
                linkedBranch: document.getElementById('formBranch').value,
                loanPurpose: document.getElementById('formLoanPurpose').value,
                nomineeName: document.getElementById('formNomineeName').value,
                nomineeRelationship: document.getElementById('formNomineeRelationship').value,
                nomineeMobile: document.getElementById('formNomineeMobile').value,
                declarationPlace: document.getElementById('formDeclarationPlace').value,
                declarationDate: document.getElementById('formDeclarationDate').value,
                signature: document.getElementById('formSignature').value
            };

            // Bind serialized string to hidden parameter
            document.getElementById('submitFormDetails').value = JSON.stringify(details);

            // Bind values to high level fields for back compatibility
            document.getElementById('submitAmount').value = amount;
            document.getElementById('submitTermMonths').value = document.getElementById('formLoanTermMonths').value;
            
            return true;
        }

        function printApplicationForm() {
            window.print();
        }

        function calculateEMI() {
            const amount = parseFloat(document.getElementById('calcAmount').value) || 0;
            const rate = parseFloat(document.getElementById('calcRate').value) || 0;
            const term = parseInt(document.getElementById('calcTerm').value) || 0;
            
            if (amount <= 0 || rate <= 0 || term <= 0) {
                document.getElementById('emiResult').textContent = "₹ 0.00";
                return;
            }

            const monthlyRate = (rate / 12) / 100;
            const emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, term)) / (Math.pow(1 + monthlyRate, term) - 1);
            
            document.getElementById('emiResult').textContent = "₹ " + emi.toLocaleString('en-IN', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });
        }

        // Initialize Calculator
        function syncCalcTerm() {
            const valInput = document.getElementById('displayCalcTermVal');
            const unit = document.getElementById('calcTermUnit').value;
            
            if (unit === 'years') {
                valInput.min = "1";
                valInput.max = "30";
                if (parseFloat(valInput.value) > 30) {
                    valInput.value = "30";
                }
            } else {
                valInput.min = "12";
                valInput.max = "360";
                if (parseFloat(valInput.value) > 360) {
                    valInput.value = "360";
                }
            }
            
            const val = parseInt(valInput.value) || 0;
            let months = val;
            if (unit === 'years') {
                months = val * 12;
            }
            document.getElementById('calcTerm').value = months;
            calculateEMI();
        }

        document.addEventListener('DOMContentLoaded', () => {
            syncCalcTerm();
            calculateEMI();
        });

        function openRepayModal(loanId, remaining) {
            document.getElementById('modalLoanId').value = loanId;
            document.getElementById('modalRemaining').value = "₹ " + parseFloat(remaining).toLocaleString('en-IN', { minimumFractionDigits: 2 });
            document.getElementById('repayModal').style.display = 'flex';
        }

        function closeRepayModal() {
            document.getElementById('repayModal').style.display = 'none';
        }
    </script>
</body>
</html>
