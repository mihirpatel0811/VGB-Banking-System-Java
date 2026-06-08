<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Customer Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
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
        }
        .stat-card-gradient {
            background: var(--gradient-secondary);
            color: white;
            border-radius: var(--radius-lg);
            padding: 25px;
            box-shadow: var(--shadow-lg);
        }

        /* VGB PREMIUM ATM CARD & 3D HOVER ANIMATIONS */
        .vgb-premium-atm-card {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.95) 0%, rgba(236, 72, 153, 0.9) 100%) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.25) !important;
            border-radius: var(--radius-xl) !important;
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.3), var(--shadow-glow) !important;
            padding: 30px !important;
            color: white !important;
            position: relative !important;
            overflow: hidden !important;
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1) !important;
            transform-style: preserve-3d !important;
            perspective: 1000px !important;
        }

        .vgb-premium-atm-card:hover {
            transform: translateY(-8px) scale(1.02) rotateX(4deg) rotateY(-8deg) !important;
            box-shadow: 0 25px 45px rgba(99, 102, 241, 0.4), var(--shadow-glow-pink) !important;
            border-color: rgba(255, 255, 255, 0.45) !important;
        }

        /* 3D Diagonal Sweep Light Reflection Shimmer Effect */
        .vgb-premium-atm-card::after {
            content: '' !important;
            position: absolute !important;
            top: -50% !important;
            left: -50% !important;
            width: 200% !important;
            height: 200% !important;
            background: linear-gradient(45deg, transparent 20%, rgba(255, 255, 255, 0.1) 40%, rgba(255, 255, 255, 0.25) 50%, rgba(255, 255, 255, 0.1) 60%, transparent 80%) !important;
            transform: rotate(-45deg) !important;
            transition: all 0.8s ease !important;
            pointer-events: none !important;
            opacity: 0.5 !important;
        }

        .vgb-premium-atm-card:hover::after {
            left: 100% !important;
        }

        /* Custom interactive scale animations for card toggle icon */
        #eyeIconBtn {
            transition: transform 0.2s ease, color 0.2s ease !important;
        }

        #eyeIconBtn:hover {
            transform: scale(1.2) !important;
            color: white !important;
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
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="active"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
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
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Digital Banking Dashboard</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Manage your premium VGB assets, transfer funds instantly, and review open loan lines.</p>
                </div>
                <div style="background: white; padding: 10px 20px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-calendar-check" style="font-size: 1.5rem; color: var(--primary-500);"></i>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">System Time</span>
                        <strong style="font-size: 0.9rem; color: var(--gray-700);">May 23, 2026</strong>
                    </div>
                </div>
            </div>

            <!-- Dynamic PIN Welcome Alert Banner -->
            <c:if test="${not empty customer}">
            <div class="glass-card" style="margin-bottom: 40px; border-left: 4px solid var(--primary-500); background: rgba(99, 102, 241, 0.03); display: flex; align-items: center; gap: 20px; padding: 20px;">
                <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(99, 102, 241, 0.1); color: var(--primary-500); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0;">
                    <i class="bx bx-shield-quarter"></i>
                </div>
                <div>
                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 4px;">Welcome to Vertex Galaxy Bank! Secure PIN Active</h4>
                    <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.5;">Your administrative account approval is complete. Your secure 4-digit Banking PIN is <strong style="color: var(--primary-600); font-family: monospace; font-size: 1rem; letter-spacing: 0.5px;">${customer.pin}</strong>. You can use this PIN for quick authentication and authorization. Visit the <a href="${pageContext.request.contextPath}/customer/notification.jsp" style="color: var(--primary-500); font-weight: 600; text-decoration: underline;">Alerts Hub</a> to view full security credentials details.</p>
                </div>
            </div>
            </c:if>

            <!-- Top Row Stat Cards -->
            <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <!-- VGB Credit Card Rendering + Total Balance -->
                <!-- VGB Credit Card Rendering + Total Balance -->
                <div class="vgb-premium-atm-card" style="display: flex; flex-direction: column; justify-content: space-between; min-height: 270px;">
                    <!-- Card Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-weight: 700; letter-spacing: 1px; font-size: 0.95rem; opacity: 0.95;"><i class="bx bx-shield-quarter"></i> Vertex Galaxy Bank</span>
                        <!-- Golden 3D Metallic Chip -->
                        <div style="width: 48px; height: 36px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #b45309 100%); border-radius: 6px; position: relative; border: 1.5px solid rgba(255, 255, 255, 0.35); box-shadow: inset 0 2px 5px rgba(255,255,255,0.4);">
                            <!-- Inner grid lines for authentic look -->
                            <div style="position: absolute; inset: 6px; border: 1px solid rgba(255,255,255,0.25); border-radius: 3px; background: rgba(0,0,0,0.05);"></div>
                        </div>
                    </div>

                    <!-- Balance & Card Number -->
                    <div style="margin-top: 15px;">
                        <span style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.8;">Total Net Balance</span>
                        <h3 style="font-size: 2.5rem; font-weight: 800; color: white; margin-top: 2px; text-shadow: 0 2px 10px rgba(0,0,0,0.15);">₹ <fmt:formatNumber value="${totalBalance}" minFractionDigits="2" maxFractionDigits="2"/></h3>
                        
                        <!-- Masked/Full Account Number -->
                        <div style="display: flex; align-items: center; gap: 10px; margin-top: 15px;">
                            <span id="cardNumberDisplay" data-full="${not empty accounts ? accounts[0].accountNumber : '000000000000'}" style="font-family: monospace; font-size: 1.35rem; letter-spacing: 2px; font-weight: 700; color: white; text-shadow: 0 1px 4px rgba(0,0,0,0.3);">
                                ••••  ••••  ••••  0000
                            </span>
                            <button type="button" onclick="toggleCardNumberVisibility()" style="background: none; border: none; color: rgba(255, 255, 255, 0.85); cursor: pointer; padding: 5px; font-size: 1.25rem; display: flex; align-items: center;" id="eyeIconBtn" title="Show/Hide Account Number">
                                <i class="bx bx-show" id="eyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Card Footer -->
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 15px; border-top: 1px solid rgba(255, 255, 255, 0.15); padding-top: 12px;">
                        <div style="display: flex; gap: 30px;">
                            <div>
                                <span style="display: block; font-size: 0.65rem; opacity: 0.75; text-transform: uppercase; letter-spacing: 0.5px;">Card Holder</span>
                                <span style="font-size: 1rem; font-weight: 600; text-transform: uppercase; color: white; letter-spacing: 1px;">${not empty customer ? customer.fullName : 'VGB CUSTOMER'}</span>
                            </div>
                            <div>
                                <span style="display: block; font-size: 0.65rem; opacity: 0.75; text-transform: uppercase; letter-spacing: 0.5px;">Birth Date</span>
                                <span style="font-size: 1rem; font-weight: 600; color: white; letter-spacing: 1px;">${not empty birthDate ? birthDate : '08/08/2002'}</span>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <span style="font-size: 1.1rem; font-weight: 800; background: linear-gradient(135deg, #ffffff 0%, #cbd5e1 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; font-style: italic;">PREMIUM</span>
                        </div>
                    </div>
                </div>

                <!-- Fast Actions Panel -->
                <div class="glass-card" style="display: flex; flex-direction: column; justify-content: space-between;">
                    <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 10px;"><i class="bx bx-bolt-circle"></i> Quick Portal Actions</h4>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; flex-grow: 1;">
                        <a href="${pageContext.request.contextPath}/account?action=transferPage" style="background: rgba(99, 102, 241, 0.05); border: 1.5px solid rgba(99, 102, 241, 0.1); border-radius: var(--radius-md); padding: 15px; text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; transition: all var(--transition-normal);">
                            <i class="bx bx-send" style="font-size: 1.8rem; color: var(--primary-500);"></i>
                            <span style="font-size: 0.85rem; font-weight: 600; color: var(--gray-700);">Send Money</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/loan?action=list" style="background: rgba(236, 72, 153, 0.05); border: 1.5px solid rgba(236, 72, 153, 0.1); border-radius: var(--radius-md); padding: 15px; text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px; transition: all var(--transition-normal);">
                            <i class="bx bx-building-house" style="font-size: 1.8rem; color: var(--secondary-500);"></i>
                            <span style="font-size: 0.85rem; font-weight: 600; color: var(--gray-700);">Apply Loan</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- List of Customer Accounts -->
            <div class="glass-card" style="margin-bottom: 40px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-wallet"></i> Linked Financial Accounts</h3>
                    <a href="${pageContext.request.contextPath}/account?action=list" class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.8rem;">View Detailed Ledger</a>
                </div>

                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Account Type</th>
                                <th style="padding: 12px 15px;">Account Number</th>
                                <th style="padding: 12px 15px;">IFSC Code</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: right;">Current Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}">
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700); transition: background var(--transition-fast);">
                                            <td style="padding: 15px; font-weight: 600; text-transform: capitalize;">
                                                <i class="bx bx-circle" style="color: var(--primary-500); margin-right: 5px;"></i> ${acc.accountType}
                                            </td>
                                            <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${acc.accountNumber}</td>
                                            <td style="padding: 15px; font-family: monospace;">${acc.ifscCode}</td>
                                            <td style="padding: 15px;">
                                                <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">${acc.status}</span>
                                            </td>
                                            <td style="padding: 15px; text-align: right; font-weight: 700; color: var(--gray-900);">₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 30px; color: var(--gray-400);">No active bank accounts linked yet.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Active Loans Panel -->
            <div class="glass-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-building-house"></i> Active Loans Overview</h3>
                    <a href="${pageContext.request.contextPath}/loan?action=list" class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.8rem;">Repay / View All</a>
                </div>

                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Loan ID</th>
                                <th style="padding: 12px 15px;">Loan Type</th>
                                <th style="padding: 12px 15px;">Principal Amount</th>
                                <th style="padding: 12px 15px;">Remaining Balance</th>
                                <th style="padding: 12px 15px;">Interest Rate</th>
                                <th style="padding: 12px 15px; text-align: right;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty activeLoans}">
                                    <c:forEach var="loan" items="${activeLoans}">
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-family: monospace;">#LN-${loan.loanId}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 500;">${loan.loanType} Loan</td>
                                            <td style="padding: 15px; font-weight: 600;">₹ <fmt:formatNumber value="${loan.principalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="padding: 15px; font-weight: 600; color: #ef4444;">₹ <fmt:formatNumber value="${loan.remainingBalance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td style="padding: 15px;">${loan.interestRate}% P.A.</td>
                                            <td style="padding: 15px; text-align: right;">
                                                <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">${loan.status}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 30px; color: var(--gray-400);">No active loans registered in database.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved. Secured by RBI.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const displayEl = document.getElementById('cardNumberDisplay');
            if (displayEl) {
                const fullNumber = displayEl.getAttribute('data-full');
                const last4 = fullNumber.slice(-4);
                displayEl.setAttribute('data-masked', `••••  ••••  ••••  ${last4}`);
                displayEl.textContent = `••••  ••••  ••••  ${last4}`;
            }
        });

        function toggleCardNumberVisibility() {
            const displayEl = document.getElementById('cardNumberDisplay');
            const iconEl = document.getElementById('eyeIcon');
            if (displayEl && iconEl) {
                const isMasked = displayEl.textContent === displayEl.getAttribute('data-masked');
                if (isMasked) {
                    displayEl.textContent = displayEl.getAttribute('data-full');
                    iconEl.className = 'bx bx-hide';
                } else {
                    displayEl.textContent = displayEl.getAttribute('data-masked');
                    iconEl.className = 'bx bx-show';
                }
            }
        }
    </script>
</body>
</html>
