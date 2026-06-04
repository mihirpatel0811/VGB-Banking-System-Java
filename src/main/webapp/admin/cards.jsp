<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage ATM Cards</title>
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
        .stat-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-sm);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .card-dues-warning {
            color: #ef4444;
        }
        .card-dues-normal {
            color: var(--gray-800);
        }

        /* PREMIUM VGB 3D GLOWING CARDS FOR VISUALIZER */
        .vgb-atm-card {
            border-radius: 20px;
            padding: 25px;
            color: white;
            position: relative;
            overflow: hidden;
            min-height: 220px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            perspective: 1000px;
            border: 1.5px solid rgba(255, 255, 255, 0.2);
            cursor: pointer;
        }

        .vgb-atm-card.debit {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #06b6d4 100%);
            box-shadow: 0 12px 25px rgba(59, 130, 246, 0.3);
        }

        .vgb-atm-card.credit {
            background: linear-gradient(135deg, #4c1d95 0%, #8b5cf6 50%, #ec4899 100%);
            box-shadow: 0 12px 25px rgba(139, 92, 246, 0.3);
        }

        .vgb-atm-card.inactive-card {
            background: linear-gradient(135deg, #374151 0%, #4b5563 100%) !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
            opacity: 0.8;
        }

        .vgb-atm-card:hover:not(.interactive) {
            transform: translateY(-8px) rotateX(6deg) rotateY(-6deg);
            box-shadow: 0 22px 40px rgba(0, 0, 0, 0.25);
        }

        .vgb-atm-card.debit:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(59, 130, 246, 0.4), 0 0 15px rgba(6, 182, 212, 0.3);
        }

        .vgb-atm-card.credit:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(139, 92, 246, 0.4), 0 0 15px rgba(236, 72, 153, 0.3);
        }

        .vgb-atm-card::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 20%, rgba(255, 255, 255, 0.08) 40%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.08) 60%, transparent 80%);
            transform: rotate(-45deg);
            transition: all 0.8s ease;
            pointer-events: none;
            opacity: 0.6;
        }

        .vgb-atm-card:hover::after {
            left: 100%;
        }

        .vgb-atm-card.flipped {
            transform: rotateY(180deg);
        }
        
        .vgb-atm-card.flipped:hover:not(.interactive) {
            transform: rotateY(180deg) translateY(-8px) rotateX(-6deg) rotateY(6deg);
        }

        /* PREMIUM DYNAMIC INTERACTIVE CARD CLASSES */
        .vgb-atm-card.interactive {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }

        .vgb-atm-card.interactive:hover {
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.25);
        }

        /* Glassmorphic Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1000;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(8px);
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        /* PREMIUM ATM CARD CUSTOMIZER & SIMULATOR */
        .card-customizer-grid {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            gap: 40px;
            align-items: center;
        }
        @media (max-width: 991px) {
            .card-customizer-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }
        .simulator-display {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.04) 0%, rgba(6, 182, 212, 0.04) 100%);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 40px 30px;
            position: relative;
            min-height: 330px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.05);
        }
        .simulator-controls {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .control-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .control-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.75px;
        }
        .control-input, .control-select {
            width: 100%;
            padding: 11px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            background: white;
            font-size: 0.9rem;
            color: var(--gray-800);
            font-family: inherit;
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
        }
        .control-input:focus, .control-select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
        }
        .control-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .card-3d-scene {
            perspective: 1200px;
            transform-style: preserve-3d;
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
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/admin/notification.jsp"><i class="bx bx-bell"></i> Audit Logs</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="mobile-grid-1">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Atm Cards Control Center</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer debit/credit card applications, audit system card limits, and process card approvals.</p>
                </div>
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

            <!-- Stats Rows (Dynamic Card Metrics) -->
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <c:set var="pendingCount" value="0" />
                <c:set var="activeCount" value="0" />
                <c:set var="feeRevenue" value="0" />
                
                <c:forEach var="card" items="${cards}">
                    <c:choose>
                        <c:when test="${card.status eq 'pending'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                        </c:when>
                        <c:when test="${card.status eq 'active'}">
                            <c:set var="activeCount" value="${activeCount + 1}" />
                        </c:when>
                    </c:choose>
                    <c:if test="${card.feePaid}">
                        <c:set var="feeRevenue" value="${feeRevenue + card.cardFee}" />
                    </c:if>
                </c:forEach>

                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-credit-card"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Active Cards Issued</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${activeCount}</strong>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-time-five"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Pending Approvals</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${pendingCount}</strong>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-wallet"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Card Service Revenue</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">₹ <fmt:formatNumber value="${feeRevenue}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                    </div>
                </div>
            </div>

            <!-- Flagship Interactive VGB 3D Card Demo Simulator -->
            <div class="glass-card" style="padding: 30px; margin-bottom: 40px; background: linear-gradient(135deg, rgba(255, 255, 255, 0.8) 0%, rgba(255, 255, 255, 0.65) 100%); border: 1px solid rgba(99, 102, 241, 0.2);">
                <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--gray-800); margin-bottom: 8px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-cube" style="color: var(--primary-500); font-size: 1.5rem;"></i> 
                    Flagship VGB Premium 3D ATM Card Showcase & Live Simulator
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 25px;">
                    Hover over the card to explore the interactive 3D tilt tracking. Click to flip and inspect CVV/signatory zones. Use the customizer controls to customize the visual assets live!
                </p>
                
                <div class="card-customizer-grid">
                    <!-- Left Column: The 3D Demo Card Display -->
                    <div class="simulator-display">
                        <div style="position: absolute; top: 12px; left: 15px; display: flex; gap: 8px; align-items: center; pointer-events: none;">
                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); font-size: 0.7rem; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 4px;">
                                <i class="bx bx-expand-alt" style="font-size: 0.8rem;"></i> 3D Sandbox
                            </span>
                        </div>
                        
                        <!-- The Flippable Card Scene -->
                        <div class="card-3d-scene" id="demo3DCardTiltWrapper" style="width: 340px; height: 220px; position: relative; transition: transform 0.1s ease; transform-style: preserve-3d;">
                            <div id="demo3DCard" class="vgb-atm-card debit interactive" style="width: 100%; height: 100%; position: absolute; border-radius: 20px; margin: 0; transform-style: preserve-3d;" onclick="flipDemoCard()">
                                <!-- Front Face -->
                                <div class="card-face card-front" style="position: absolute; inset: 0; padding: 25px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; background: inherit; border-radius: inherit;">
                                    <div class="card-top" style="display: flex; justify-content: space-between; align-items: center; background: transparent;">
                                        <span id="demoProvider" style="font-size: 1.4rem; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; font-style: italic; background: linear-gradient(135deg, #ffffff 0%, #e2e8f0 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">VISA</span>
                                        <div class="metallic-chip" style="width: 42px; height: 32px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #b45309 100%); border-radius: 6px; border: 1px solid rgba(255, 255, 255, 0.25); box-shadow: inset 0 1px 3px rgba(255, 255, 255, 0.4); position: relative;"></div>
                                    </div>
                                    <div class="card-number" id="demoNumber" style="font-family: monospace; font-size: 1.25rem; letter-spacing: 2px; font-weight: 600; margin: 20px 0 10px; text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);">4589  7321  6048  2190</div>
                                    <div class="card-details" style="display: flex; justify-content: space-between; align-items: flex-end; background: transparent;">
                                        <div>
                                            <span style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.75; display: block; margin-bottom: 2px;">Card Holder</span>
                                            <span class="card-value" id="demoHolder" style="font-size: 0.85rem; font-weight: 600; letter-spacing: 0.5px; text-transform: uppercase;">MIHIR BHAYANI</span>
                                        </div>
                                        <div>
                                            <span style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.75; display: block; margin-bottom: 2px;">Expires</span>
                                            <span class="card-value" id="demoExpiry" style="font-size: 0.85rem; font-weight: 600; letter-spacing: 0.5px;">12/30</span>
                                        </div>
                                        <span style="font-size: 0.95rem; font-weight: 800; font-style: italic; color: rgba(255, 255, 255, 0.85);">VGB</span>
                                    </div>
                                </div>
                                
                                <!-- Back Face -->
                                <div class="card-face card-back" style="position: absolute; inset: 0; padding: 25px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; transform: rotateY(180deg); background: inherit; border-radius: inherit;">
                                    <div style="height: 40px; background: #000; margin: 0 -25px; margin-top: 5px;"></div>
                                    <div style="padding: 0 10px;">
                                        <div style="font-size: 0.5rem; opacity: 0.7; margin-bottom: 2px; text-transform: uppercase; letter-spacing: 0.5px;">Authorized Signature</div>
                                        <div style="background: rgba(255, 255, 255, 0.9); height: 35px; border-radius: 4px; display: flex; align-items: center; justify-content: flex-end; padding-right: 15px; color: #1e293b; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.1rem;">
                                            <span style="font-family: monospace; font-size: 0.9rem; font-weight: 700; color: #334155; margin-left: 20px; font-style: normal; letter-spacing: 1px; cursor: pointer;" id="demoCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV">•••</span>
                                        </div>
                                    </div>
                                    <div style="font-size: 0.55rem; opacity: 0.6; text-align: center; line-height: 1.3;">
                                        Property of Vertex Galaxy Bank. For customer support contact 1800-VGB-BANK. Strictly Confidential.
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div style="margin-top: 25px; display: flex; gap: 15px; font-size: 0.75rem; color: var(--gray-500); align-items: center;">
                            <span><i class="bx bx-mouse" style="color: var(--primary-500);"></i> Hover to Tilt</span>
                            <span>|</span>
                            <span><i class="bx bx-pointer" style="color: var(--primary-500);"></i> Click Card to Flip</span>
                        </div>
                    </div>
                    
                    <!-- Right Column: Customizer Controls -->
                    <div class="simulator-controls">
                        <div class="control-row">
                            <div class="control-group">
                                <label class="control-label">Card Type</label>
                                <select id="ctrlCardType" class="control-select" onchange="syncDemoCard()">
                                    <option value="debit">VGB Sapphire Debit</option>
                                    <option value="credit">VGB Royale Credit</option>
                                    <option value="inactive">VGB Blocked/Inactive</option>
                                </select>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Network Provider</label>
                                <select id="ctrlCardProvider" class="control-select" onchange="syncDemoCard()">
                                    <option value="visa">Visa Secure</option>
                                    <option value="mastercard">Mastercard ID</option>
                                    <option value="rupay">RuPay Global</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Embossed Name</label>
                            <input type="text" id="ctrlHolderName" class="control-input" value="MIHIR BHAYANI" placeholder="CARD HOLDER NAME" oninput="syncDemoCard()" style="text-transform: uppercase;">
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Card Number</label>
                            <input type="text" id="ctrlCardNumber" class="control-input" value="4589 7321 6048 2190" placeholder="16-Digit Card Number" oninput="syncDemoCard()" maxlength="19">
                        </div>
                        
                        <div class="control-row">
                            <div class="control-group">
                                <label class="control-label">Expiry Date</label>
                                <input type="text" id="ctrlExpiry" class="control-input" value="12/30" placeholder="MM/YY" oninput="syncDemoCard()" maxlength="5">
                            </div>
                            <div class="control-group">
                                <label class="control-label">CVV Code</label>
                                <input type="text" id="ctrlCvv" class="control-input" value="907" placeholder="3 Digits" oninput="syncDemoCard()" maxlength="3">
                            </div>
                        </div>
                        
                        <div class="control-row" style="margin-top: 10px;">
                            <button type="button" class="btn btn-secondary" onclick="randomizeDemoCard()" style="padding: 10px; width: 100%; font-size: 0.85rem; font-weight: 600; margin-top: 0; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-color: var(--primary-500); color: var(--primary-500); background: transparent;">
                                <i class="bx bx-shuffle"></i> Randomize
                            </button>
                            <button type="button" class="btn btn-primary" onclick="flipDemoCard()" style="padding: 10px; width: 100%; font-size: 0.85rem; font-weight: 600; margin-top: 0; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
                                <i class="bx bx-rotate-right"></i> Flip Card
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table 1: Pending Card Approvals -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-time"></i> Pending Card Applications Awaiting Review
                </h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Card Type</th>
                                <th style="padding: 12px 15px;">Provider</th>
                                <th style="padding: 12px 15px;">Holder Name</th>
                                <th style="padding: 12px 15px;">Linked Account</th>
                                <th style="padding: 12px 15px;">Fee Paid</th>
                                <th style="padding: 12px 15px;">Applied Date</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasPending" value="false" />
                            <c:forEach var="card" items="${cards}">
                                <c:if test="${card.status eq 'pending'}">
                                    <c:set var="hasPending" value="true" />
                                    <fmt:formatDate var="formattedAppliedDate" value="${card.createdAt}" pattern="MM/yy" />
                                    <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                        <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 3px 8px; border-radius: var(--radius-sm); font-size: 0.75rem;">${card.cardType}</span>
                                        </td>
                                        <td style="padding: 15px; text-transform: uppercase; font-weight: 500;">${card.cardProvider}</td>
                                        <td style="padding: 15px; font-weight: 500;">${card.cardHolderName}</td>
                                        <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${card.accountNumber}</td>
                                        <td style="padding: 15px; font-weight: 600; color: var(--accent-emerald);">₹ ${card.cardFee}</td>
                                        <td style="padding: 15px;"><fmt:formatDate value="${card.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td style="padding: 15px; text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; white-space: nowrap;">
                                            <button type="button" class="btn btn-secondary" onclick="open3DCardPreview('${card.cardNumber}', '${card.cardHolderName}', '${card.cardType}', '${card.cardProvider}', '${card.cvv}', '${formattedAppliedDate}', '${card.status}')" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500); background: transparent; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-show"></i> View 3D</button>
                                            <a href="${pageContext.request.contextPath}/card?action=approve&id=${card.cardId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-emerald); color: var(--accent-emerald); margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-check"></i> Approve</a>
                                            <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn btn-secondary" onclick="return confirm('Reject and permanently close this card application?');" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444; margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-x"></i> Reject</a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasPending}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 30px; color: var(--gray-400);">No pending ATM card applications at this time.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Table 2: All System Cards (Debit & Credit) -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-credit-card-front"></i> All System Issued Cards Directory
                </h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Sr No.</th>
                                <th style="padding: 12px 15px;">Card Number</th>
                                <th style="padding: 12px 15px;">Holder Name</th>
                                <th style="padding: 12px 15px;">Card Type</th>
                                <th style="padding: 12px 15px;">Provider</th>
                                <th style="padding: 12px 15px;">Expiry Date</th>
                                <th style="padding: 12px 15px;">Dues (Credit)</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty cards}">
                                    <c:forEach var="card" items="${cards}" varStatus="status">
                                        <fmt:formatDate var="formattedExpiryDate" value="${card.expiryDate}" pattern="MM/yy" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-600);">${status.count}</td>
                                            <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${card.cardNumber}</td>
                                            <td style="padding: 15px; font-weight: 500;">${card.cardHolderName}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">${card.cardType}</td>
                                            <td style="padding: 15px; text-transform: uppercase;">${card.cardProvider}</td>
                                            <td style="padding: 15px;"><fmt:formatDate value="${card.expiryDate}" pattern="yyyy-MM-dd" /></td>
                                            <td style="padding: 15px; font-weight: 700;" class="${card.outstandingBalance gt 0 ? 'card-dues-warning' : 'card-dues-normal'}">
                                                ₹ <fmt:formatNumber value="${card.outstandingBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${card.status eq 'active'}">
                                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Active</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Pending</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'expired'}">
                                                        <span style="background: rgba(239, 68, 68, 0.1); color: #b91c1c; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Expired</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(156, 163, 175, 0.1); color: var(--gray-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Closed</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; white-space: nowrap;">
                                                <button type="button" class="btn btn-secondary" onclick="open3DCardPreview('${card.cardNumber}', '${card.cardHolderName}', '${card.cardType}', '${card.cardProvider}', '${card.cvv}', '${formattedExpiryDate}', '${card.status}')" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500); background: transparent; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-show"></i> View 3D</button>
                                                <c:if test="${card.status eq 'active'}">
                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn btn-secondary" onclick="return confirm('Are you sure you want to permanently close card #${card.cardId}?');" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444; margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-power-off"></i> Close</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 30px; color: var(--gray-400);">No ATM cards registered in database directory.</td>
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
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <!-- Premium 3D Card Visualizer Modal -->
    <div id="previewCardModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 1000; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px); align-items: center; justify-content: center; padding: 20px;">
        <div class="glass-card" style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(25px); border: 1px solid rgba(99, 102, 241, 0.2); width: 100%; max-width: 450px; border-radius: var(--radius-lg); padding: 30px; position: relative; animation: modalFadeIn 0.3s ease-out; box-shadow: var(--shadow-xl); margin-bottom: 0;">
            <span onclick="close3DCardPreview()" style="position: absolute; right: 20px; top: 20px; font-size: 1.5rem; color: var(--gray-400); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-800)'" onmouseout="this.style.color='var(--gray-400)'">&times;</span>
            
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <i class="bx bx-credit-card-front" style="color: var(--primary-500); font-size: 1.4rem;"></i> VGB Premium Card Visualizer
            </h3>

            <!-- 3D Flippable Card -->
            <div class="card-3d-scene" id="visualizerCardTiltWrapper" style="perspective: 1000px; width: 100%; display: flex; justify-content: center; margin-bottom: 30px; transition: transform 0.1s ease; transform-style: preserve-3d;">
                <div id="visualizerCard" class="vgb-atm-card interactive" style="width: 340px; height: 220px; border-radius: 20px; position: relative; margin: 0; box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15); transform-style: preserve-3d; border: 1.5px solid rgba(255, 255, 255, 0.2); cursor: pointer;" onclick="this.classList.toggle('flipped')">
                    <!-- Front Face -->
                    <div class="card-face card-front" style="position: absolute; inset: 0; padding: 25px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; background: inherit; border-radius: inherit;">
                        <div class="card-top" style="display: flex; justify-content: space-between; align-items: center; background: transparent;">
                            <span id="previewProvider" style="font-size: 1.4rem; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; font-style: italic; background: linear-gradient(135deg, #ffffff 0%, #e2e8f0 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">VISA</span>
                            <div class="metallic-chip" style="width: 42px; height: 32px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #b45309 100%); border-radius: 6px; border: 1px solid rgba(255, 255, 255, 0.25); box-shadow: inset 0 1px 3px rgba(255, 255, 255, 0.4); position: relative;"></div>
                        </div>
                        <div class="card-number" id="previewNumber" style="font-family: monospace; font-size: 1.25rem; letter-spacing: 2px; font-weight: 600; margin: 20px 0 10px; text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);">4589  7321  6048  2190</div>
                        <div class="card-details" style="display: flex; justify-content: space-between; align-items: flex-end; background: transparent;">
                            <div>
                                <span style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.75; display: block; margin-bottom: 2px;">Card Holder</span>
                                <span class="card-value" id="previewHolder" style="font-size: 0.85rem; font-weight: 600; letter-spacing: 0.5px; text-transform: uppercase;">John Doe</span>
                            </div>
                            <div>
                                <span style="font-size: 0.6rem; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.75; display: block; margin-bottom: 2px;">Expires</span>
                                <span class="card-value" id="previewExpiry" style="font-size: 0.85rem; font-weight: 600; letter-spacing: 0.5px;">12/29</span>
                            </div>
                            <span style="font-size: 0.95rem; font-weight: 800; font-style: italic; color: rgba(255, 255, 255, 0.85);">VGB</span>
                        </div>
                    </div>

                    <!-- Back Face -->
                    <div class="card-face card-back" style="position: absolute; inset: 0; padding: 25px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; transform: rotateY(180deg); background: inherit; border-radius: inherit;">
                        <div style="height: 40px; background: #000; margin: 0 -25px; margin-top: 5px;"></div>
                        <div style="padding: 0 10px;">
                            <div style="font-size: 0.5rem; opacity: 0.7; margin-bottom: 2px; text-transform: uppercase; letter-spacing: 0.5px;">Authorized Signature</div>
                            <div style="background: rgba(255, 255, 255, 0.9); height: 35px; border-radius: 4px; display: flex; align-items: center; justify-content: flex-end; padding-right: 15px; color: #1e293b; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.1rem;">
                                <span style="font-family: monospace; font-size: 0.9rem; font-weight: 700; color: #334155; margin-left: 20px; font-style: normal; letter-spacing: 1px; cursor: pointer;" id="previewCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV">•••</span>
                            </div>
                        </div>
                        <div style="font-size: 0.55rem; opacity: 0.6; text-align: center; line-height: 1.3;">
                            Property of Vertex Galaxy Bank. For customer support contact 1800-VGB-BANK. Strictly Confidential.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Spec Sheet -->
            <div style="background: var(--gray-50); border: 1px solid var(--gray-200); border-radius: var(--radius-md); padding: 15px; font-size: 0.85rem;">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                    <div>
                        <span style="color: var(--gray-400); display: block; font-size: 0.7rem; text-transform: uppercase; font-weight: 600;">Status</span>
                        <strong id="previewSpecStatus" style="font-size: 0.85rem; text-transform: uppercase; color: var(--accent-emerald);">Active</strong>
                    </div>
                    <div>
                        <span style="color: var(--gray-400); display: block; font-size: 0.7rem; text-transform: uppercase; font-weight: 600;">Daily Limit</span>
                        <strong id="previewSpecLimit" style="font-size: 0.85rem; color: var(--gray-800);">₹ 50,000.00</strong>
                    </div>
                </div>
            </div>

            <div style="display: flex; justify-content: center; margin-top: 25px;">
                <button type="button" class="btn btn-secondary" onclick="close3DCardPreview()" style="padding: 10px 25px; font-weight: 600; width: 100%; margin-top: 0;">Close Visualizer</button>
            </div>
        </div>
    </div>

    <script>
        function open3DCardPreview(number, holder, type, provider, cvv, expiry, status) {
            const modal = document.getElementById('previewCardModal');
            const card = document.getElementById('visualizerCard');
            
            // Set text values
            document.getElementById('previewNumber').innerText = number;
            document.getElementById('previewHolder').innerText = holder;
            document.getElementById('previewExpiry').innerText = expiry;
            
            const previewCvvEl = document.getElementById('previewCvv');
            previewCvvEl.innerText = "•••";
            previewCvvEl.setAttribute('data-cvv', cvv);
            
            // Set Provider logo
            document.getElementById('previewProvider').innerText = provider.toUpperCase();
            
            // Apply Card Types & Status styles
            card.className = "vgb-atm-card " + type.toLowerCase();
            
            const specStatus = document.getElementById('previewSpecStatus');
            const specLimit = document.getElementById('previewSpecLimit');
            
            if (status.toLowerCase() === 'active') {
                specStatus.innerText = "Active";
                specStatus.style.color = "var(--accent-emerald)";
            } else if (status.toLowerCase() === 'pending') {
                specStatus.innerText = "Pending Approval";
                specStatus.style.color = "var(--accent-amber)";
                card.classList.add('inactive-card');
            } else if (status.toLowerCase() === 'expired') {
                specStatus.innerText = "Expired";
                specStatus.style.color = "#ef4444";
                card.classList.add('inactive-card');
            } else {
                specStatus.innerText = "Closed";
                specStatus.style.color = "var(--gray-500)";
                card.classList.add('inactive-card');
            }
            
            // Set Limit
            specLimit.innerText = type.toLowerCase() === 'credit' ? "₹ 50,000.00 Outstanding" : "₹ 50,000.00 Daily Limit";
            
            // Ensure card front face is showing by default and has interactive behaviors
            card.classList.remove('flipped');
            card.classList.add('interactive');
            
            const wrapper = document.getElementById('visualizerCardTiltWrapper');
            if (wrapper) {
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            }
            
            modal.style.display = 'flex';
        }

        function close3DCardPreview() {
            document.getElementById('previewCardModal').style.display = 'none';
        }

        // Flagship Card Customizer & Interactive Simulator Logic
        function syncDemoCard() {
            const card = document.getElementById('demo3DCard');
            const type = document.getElementById('ctrlCardType').value;
            const provider = document.getElementById('ctrlCardProvider').value;
            const holder = document.getElementById('ctrlHolderName').value.trim().toUpperCase() || "DEMO HOLDER";
            const number = document.getElementById('ctrlCardNumber').value.trim() || "4589 7321 6048 2190";
            const expiry = document.getElementById('ctrlExpiry').value.trim() || "12/30";
            const cvv = document.getElementById('ctrlCvv').value.trim() || "907";

            // Set Text values
            document.getElementById('demoNumber').innerText = number;
            document.getElementById('demoHolder').innerText = holder;
            document.getElementById('demoExpiry').innerText = expiry;
            document.getElementById('demoProvider').innerText = provider.toUpperCase();

            // Handle secure CVV storage and masking update
            const demoCvvEl = document.getElementById('demoCvv');
            demoCvvEl.setAttribute('data-cvv', cvv);
            if (demoCvvEl.innerText !== '•••') {
                demoCvvEl.innerText = cvv;
            }

            // Set background gradient and shadows depending on selection type
            card.className = "vgb-atm-card";
            if (type === 'debit') {
                card.classList.add('debit');
            } else if (type === 'credit') {
                card.classList.add('credit');
            } else {
                card.classList.add('inactive-card');
            }
        }

        // Mask/Unmask CVV on the back face securely without flipping card
        function toggle3DCardCvv(event, element) {
            if (event) event.stopPropagation(); // Stop click from flipping the card!
            const realCvv = element.getAttribute('data-cvv') || "907";
            if (element.innerText === '•••') {
                element.innerText = realCvv;
                element.title = "Click to hide CVV";
            } else {
                element.innerText = '•••';
                element.title = "Click to show CVV";
            }
        }

        function randomizeDemoCard() {
            const names = ["MIHIR BHAYANI", "PARTH TANK", "KARAN PATEL", "SNEHA RAO", "ROHAN SHARMA", "VERTEX GALAXY BANK SPECIAL"];
            const providers = ["visa", "mastercard", "rupay"];
            const types = ["debit", "credit"];
            
            const randomName = names[Math.floor(Math.random() * names.length)];
            const randomProvider = providers[Math.floor(Math.random() * providers.length)];
            const randomType = types[Math.floor(Math.random() * types.length)];
            
            // Generate standard spaced card sequences based on network provider prefix
            let cardPrefix = "4";
            if (randomProvider === 'mastercard') cardPrefix = "5";
            if (randomProvider === 'rupay') cardPrefix = "6";
            
            let cardNumber = cardPrefix;
            for (let i = 0; i < 15; i++) {
                if (i > 0 && i % 4 === 3) cardNumber += "  ";
                cardNumber += Math.floor(Math.random() * 10);
            }

            // Expiry Month / Year (4-year offset max)
            const months = ["01", "03", "04", "05", "07", "08", "10", "11", "12"];
            const randomMonth = months[Math.floor(Math.random() * months.length)];
            const randomYear = 26 + Math.floor(Math.random() * 5); // 2026 to 2030

            // 3-digit CVV
            const randomCvv = Math.floor(100 + Math.random() * 900);

            // Populate form elements
            document.getElementById('ctrlCardType').value = randomType;
            document.getElementById('ctrlCardProvider').value = randomProvider;
            document.getElementById('ctrlHolderName').value = randomName;
            document.getElementById('ctrlCardNumber').value = cardNumber;
            document.getElementById('ctrlExpiry').value = randomMonth + "/" + randomYear;
            document.getElementById('ctrlCvv').value = randomCvv;

            syncDemoCard();
        }

        function flipDemoCard() {
            document.getElementById('demo3DCard').classList.toggle('flipped');
        }

        // Live 3D Tilt Effect calculations using a dual wrapper approach
        function apply3DTilt(wrapperId, innerCardId) {
            const wrapper = document.getElementById(wrapperId);
            const card = document.getElementById(innerCardId);
            if (!wrapper || !card) return;
            
            wrapper.addEventListener('mousemove', function(e) {
                const rect = wrapper.getBoundingClientRect();
                const x = e.clientX - rect.left; // x coordinate inside element
                const y = e.clientY - rect.top;  // y coordinate inside element
                
                const width = rect.width;
                const height = rect.height;
                
                // Normalise coordinates around centre point (-0.5 to +0.5)
                const percentX = (x / width) - 0.5;
                const percentY = (y / height) - 0.5;
                
                // Scale coordinate vector values for yaw/pitch thresholds
                const maxRotation = 14; 
                
                const rotateX = -(percentY * maxRotation).toFixed(2);
                const rotateY = (percentX * maxRotation).toFixed(2);
                
                wrapper.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.04, 1.04, 1.04)`;
            });
            
            wrapper.addEventListener('mouseleave', function() {
                wrapper.style.transition = "transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            });

            wrapper.addEventListener('mouseenter', function() {
                wrapper.style.transition = "none";
            });
        }

        function init3DCardTiltEffect() {
            apply3DTilt('demo3DCardTiltWrapper', 'demo3DCard');
            apply3DTilt('visualizerCardTiltWrapper', 'visualizerCard');
        }

        // Initialize elements on load
        window.addEventListener('DOMContentLoaded', () => {
            init3DCardTiltEffect();
            syncDemoCard();
        });
    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
