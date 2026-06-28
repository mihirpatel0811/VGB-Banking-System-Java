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
    <title>VGB | Linked Accounts</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
        .sidebar-menu a:hover i {
            transform: scale(1.1);
        }
        .sidebar-menu a.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
            border-color: transparent;
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
        .mobile-nav-toggle {
            display: none !important;
        }
        @media (max-width: 991px) {
            .mobile-nav-toggle {
                display: flex !important;
            }
            .sidebar {
                left: -280px !important;
                top: 80px;
                height: calc(100vh - 80px);
                z-index: 1000;
            }
            .sidebar.active {
                left: 0 !important;
            }
            .main-content {
                margin-left: 0 !important;
                padding: 120px 20px 40px !important;
            }
            .footer {
                margin-left: 0 !important;
            }
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
        }

        /* Modern Tables & Badges */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        th {
            padding: 14px 18px;
            color: var(--gray-500);
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.75px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
            white-space: nowrap;
        }
        td {
            padding: 16px 18px;
            font-size: 0.875rem;
            color: var(--gray-700);
            border-bottom: 1px solid rgba(99, 102, 241, 0.05);
            vertical-align: middle;
            white-space: nowrap;
        }
        tr {
            transition: background 0.2s ease;
        }
        tr:hover td {
            background: rgba(99, 102, 241, 0.01);
        }
        .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge-active {
            background: rgba(16, 185, 129, 0.1);
            color: var(--accent-emerald);
        }
        .badge-id {
            font-family: monospace;
            font-weight: 600;
            background: rgba(99, 102, 241, 0.05);
            color: var(--primary-600);
            padding: 3px 8px;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: var(--gray-400);
        }
        .empty-state svg {
            width: 80px;
            height: 80px;
            margin-bottom: 20px;
            color: var(--primary-300);
            filter: drop-shadow(0 4px 6px rgba(99, 102, 241, 0.1));
        }
        .empty-state h4 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 8px;
        }
        .empty-state p {
            font-size: 0.88rem;
            font-weight: 500;
            max-width: 360px;
            margin: 0 auto;
            line-height: 1.5;
        }

        /* Premium Logout Button */
        .btn-logout {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: var(--radius-full);
            border: 1.5px solid rgba(99, 102, 241, 0.2) !important;
            background: transparent;
            color: var(--gray-700) !important;
            transition: all var(--transition-normal);
            cursor: pointer;
            text-decoration: none;
        }
        .btn-logout:hover {
            border-color: transparent !important;
            background: var(--gradient-primary);
            color: white !important;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
            transform: translateY(-1px);
        }
        .btn-logout i {
            font-size: 1.05rem;
            transition: transform var(--transition-fast);
        }
        .btn-logout:hover i {
            transform: translateX(3px);
        }

        /* Ledger Button styling */
        .btn-ledger {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: var(--radius-md);
            border: 1px solid rgba(99, 102, 241, 0.25);
            background: rgba(255, 255, 255, 0.8);
            color: var(--primary-600);
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-ledger:hover {
            background: var(--gradient-primary);
            color: white !important;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.15);
            transform: translateY(-1px);
        }
        .btn-ledger i {
            font-size: 0.95rem;
        }

        @media (max-width: 480px) {
            .mobile-hide {
                display: none !important;
            }
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
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty customer}">
                        <c:choose>
                            <c:when test="${not empty customer.avatarPath}">
                                <img src="${pageContext.request.contextPath}${customer.avatarPath}" alt="Customer Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                                    ${customer.fullName.substring(0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                            <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                            <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                                Customer Space
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gray-100); color: var(--gray-500); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1.5px solid var(--gray-200);">
                            <i class="bx bx-user"></i>
                        </div>
                        <span style="font-weight: 600; color: var(--gray-700); font-size: 0.85rem;" class="mobile-hide">Customer Space</span>
                    </c:otherwise>
                </c:choose>
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
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list" class="active"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
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
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Linked Bank Accounts</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Manage details, review status limits, or query transaction logs.</p>
                </div>
                <div style="background: white; padding: 10px 20px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); display: flex; align-items: center; gap: 10px; box-shadow: var(--shadow-sm);">
                    <i class="bx bx-calendar-check" style="font-size: 1.5rem; color: var(--primary-500);"></i>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase;">System Time</span>
                        <strong style="font-size: 0.9rem; color: var(--gray-700);" id="liveSystemTime">June 21, 2026</strong>
                    </div>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div style="background: rgba(239, 68, 68, 0.08); border-left: 4px solid #ef4444; color: #b91c1c; padding: 16px 20px; border-radius: var(--radius-md); margin-bottom: 30px; font-size: 0.88rem; display: flex; align-items: center; gap: 12px; backdrop-filter: blur(10px); border: 1px solid rgba(239, 68, 68, 0.15); border-left-width: 4px;">
                    <i class="bx bx-error-circle" style="font-size: 1.4rem; color: #ef4444;"></i>
                    <span style="font-weight: 500;">${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="background: rgba(16, 185, 129, 0.08); border-left: 4px solid #10b981; color: #047857; padding: 16px 20px; border-radius: var(--radius-md); margin-bottom: 30px; font-size: 0.88rem; display: flex; align-items: center; gap: 12px; backdrop-filter: blur(10px); border: 1px solid rgba(16, 185, 129, 0.15); border-left-width: 4px;">
                    <i class="bx bx-check-circle" style="font-size: 1.4rem; color: #10b981;"></i>
                    <span style="font-weight: 500;">${success}</span>
                </div>
            </c:if>

            <!-- Linked Accounts Card -->
            <div class="glass-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; flex-wrap: wrap; gap: 10px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                        <i class="bx bx-credit-card-front" style="color: var(--primary-500);"></i>
                        <span>Active Account Ledgers</span>
                    </h3>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Account Type</th>
                                <th>Account Number</th>
                                <th>IFSC Code</th>
                                <th>Status</th>
                                <th style="text-align: right;">Current Balance</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}">
                                        <tr>
                                            <td style="font-weight: 600; text-transform: capitalize;">
                                                <i class="bx bx-wallet" style="color: var(--primary-500); margin-right: 8px; font-size: 1.1rem; vertical-align: middle;"></i>
                                                <span>${acc.accountType}</span>
                                            </td>
                                            <td>
                                                <span class="badge-id">${acc.accountNumber}</span>
                                            </td>
                                            <td>
                                                <span style="font-family: monospace; font-weight: 500; color: var(--gray-600);">${acc.ifscCode}</span>
                                            </td>
                                            <td>
                                                <span class="badge-status badge-active">
                                                    <i class="bx bx-check-shield"></i>
                                                    <span>${acc.status}</span>
                                                </span>
                                            </td>
                                            <td style="text-align: right; font-weight: 700; color: var(--gray-900); font-size: 0.95rem;">
                                                ₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="text-align: center;">
                                                <a href="${pageContext.request.contextPath}/account?action=transactions&accountId=${acc.accountId}" class="btn-ledger">
                                                    <i class="bx bx-receipt"></i>
                                                    <span>Ledger</span>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="padding: 0;">
                                            <div class="empty-state">
                                                <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                    <circle cx="32" cy="32" r="30" fill="rgba(99, 102, 241, 0.03)" stroke="var(--primary-300)" stroke-width="2" stroke-dasharray="4 4" />
                                                    <rect x="18" y="22" width="28" height="20" rx="3" fill="none" stroke="var(--primary-500)" stroke-width="2" />
                                                    <line x1="18" y1="28" x2="46" y2="28" stroke="var(--primary-500)" stroke-width="2" />
                                                    <circle cx="25" cy="35" r="2" fill="var(--secondary-500)" />
                                                    <line x1="32" y1="35" x2="40" y2="35" stroke="var(--gray-400)" stroke-width="2" stroke-linecap="round" />
                                                </svg>
                                                <h4>No Linked Accounts Found</h4>
                                                <p>You don't have any active VGB accounts linked at the moment. Please contact your nearest branch or support hotline to initialize one.</p>
                                            </div>
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

    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved. Secured by RBI.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Dynamic live time update
            function updateLiveTime() {
                const timeEl = document.getElementById('liveSystemTime');
                if (timeEl) {
                    const now = new Date();
                    const options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
                    timeEl.textContent = now.toLocaleDateString('en-US', options);
                }
            }
            setInterval(updateLiveTime, 1000);
            updateLiveTime();

            // Cursor glow follow
            const glow = document.querySelector('.cursor-glow');
            if (glow) {
                document.addEventListener('mousemove', (e) => {
                    glow.style.left = e.clientX + 'px';
                    glow.style.top = e.clientY + 'px';
                });
            }

            // Mobile sidebar toggle handler
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
    </script>
</body>
</html>
