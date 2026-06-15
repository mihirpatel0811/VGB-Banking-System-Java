<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Reset Credentials</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">

    <style>
        :root {
            --font-display: 'Outfit', sans-serif;
            --accent-gold: linear-gradient(135deg, #ffe875 0%, #f7c844 50%, #b88f14 100%);
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(99, 102, 241, 0.08);
            --card-glow: rgba(99, 102, 241, 0.05);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f6f8fc !important;
            color: #334155 !important;
            overflow-x: hidden;
        }

        h1,
        h2,
        h3,
        h4,
        .display-font {
            font-family: var(--font-display);
        }

        /* --- STICKY GLASSMORPHIC HEADER --- */
        .header {
            background: rgba(255, 255, 255, 0.7) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border-bottom: 1px solid rgba(99, 102, 241, 0.08) !important;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.02);
            padding: 20px 50px;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .header.scrolled {
            background: rgba(255, 255, 255, 0.85) !important;
            padding: 14px 50px;
            border-bottom-color: rgba(99, 102, 241, 0.12) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
        }

        /* --- BACKGROUND GLOWING BLOBS --- */
        .glow-blobs-container {
            position: absolute;
            inset: 0;
            overflow: hidden;
            pointer-events: none;
            z-index: 0;
        }

        .glow-blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(130px);
            opacity: 0.12;
            animation: blobFloat 16s infinite alternate ease-in-out;
        }

        .glow-blob-1 {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, var(--primary-300) 0%, transparent 70%);
            top: -150px;
            right: -100px;
        }

        .glow-blob-2 {
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, var(--secondary-300) 0%, transparent 70%);
            bottom: -200px;
            left: -150px;
            animation-delay: -5s;
        }

        .glow-blob-3 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, var(--accent-cyan) 0%, transparent 70%);
            top: 35%;
            left: 25%;
            animation-delay: -9s;
        }

        @keyframes blobFloat {
            0% {
                transform: translate(0, 0) scale(1);
            }
            50% {
                transform: translate(60px, -80px) scale(1.1);
            }
            100% {
                transform: translate(-30px, 30px) scale(0.9);
            }
        }

        /* --- AUTH CONTAINER DESIGN --- */
        .auth-card-container {
            width: 100%;
            max-width: 1060px;
            min-height: 680px;
            background: var(--glass-bg) !important;
            backdrop-filter: blur(35px) saturate(200%) !important;
            -webkit-backdrop-filter: blur(35px) saturate(200%) !important;
            border-radius: 28px !important;
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            box-shadow: 0 40px 80px rgba(15, 23, 42, 0.06),
                inset 0 0 2px 1px rgba(255, 255, 255, 0.7) !important;
            overflow: hidden !important;
            display: flex !important;
            margin: 40px 20px !important;
            transition: all var(--transition-normal) !important;
        }

        /* Left Side Panel (Branding) */
        .auth-branding-side {
            flex: 1;
            background: linear-gradient(135deg, rgba(241, 245, 249, 0.75) 0%, rgba(226, 232, 240, 0.75) 100%) !important;
            padding: 55px;
            color: var(--gray-700);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            border-top-left-radius: 28px;
            border-bottom-left-radius: 28px;
            border-right: 1px solid var(--glass-border);
        }

        .auth-branding-side::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 10% 20%, rgba(99, 102, 241, 0.05) 0%, transparent 40%),
                radial-gradient(circle at 90% 90%, rgba(236, 72, 153, 0.04) 0%, transparent 45%);
            pointer-events: none;
            z-index: 1;
        }

        .auth-branding-side::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: linear-gradient(rgba(99, 102, 241, 0.015) 1px, transparent 1px),
                linear-gradient(90deg, rgba(99, 102, 241, 0.015) 1px, transparent 1px);
            background-size: 25px 25px;
            pointer-events: none;
            z-index: 1;
        }

        .branding-content {
            position: relative;
            z-index: 2;
        }

        .branding-title {
            font-size: 2.6rem;
            font-weight: 850;
            line-height: 1.15;
            margin-bottom: 20px;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, var(--gray-900) 0%, var(--primary-700) 100%) !important;
            -webkit-background-clip: text !important;
            background-clip: text !important;
            -webkit-text-fill-color: transparent !important;
        }

        .branding-desc {
            opacity: 0.9;
            line-height: 1.65;
            font-size: 0.95rem;
            color: var(--gray-600) !important;
        }

        /* Right Side Panel (Form) */
        .auth-form-side {
            flex: 1.15 !important;
            padding: 55px 60px !important;
            background: rgba(255, 255, 255, 0.85) !important;
            display: flex !important;
            flex-direction: column !important;
            justify-content: center !important;
            position: relative;
            z-index: 2;
        }

        /* Portal Switching Pill Tab */
        .portal-tabs-container {
            display: flex !important;
            position: relative;
            background: rgba(99, 102, 241, 0.04) !important;
            padding: 6px !important;
            border-radius: 14px !important;
            border: 1px solid rgba(99, 102, 241, 0.08) !important;
            margin-bottom: 25px !important;
        }

        .tabs-slider {
            position: absolute;
            top: 6px;
            bottom: 6px;
            left: 6px;
            width: calc(50% - 6px);
            background: white !important;
            border-radius: 10px !important;
            box-shadow: 0 6px 18px rgba(99, 102, 241, 0.08) !important;
            transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1) !important;
            z-index: 1;
        }

        .portal-tab-btn {
            flex: 1 !important;
            position: relative;
            z-index: 2;
            padding: 12px 20px !important;
            font-weight: 600 !important;
            border-radius: 10px !important;
            text-align: center !important;
            font-size: 0.92rem;
            border: none !important;
            background: transparent !important;
            color: var(--gray-500) !important;
            cursor: pointer !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 8px !important;
            transition: color 0.3s ease !important;
        }

        .portal-tab-btn.active {
            color: var(--primary-600) !important;
        }

        /* Form Inputs Redesign */
        .modern-form-group {
            margin-bottom: 22px;
            position: relative;
        }

        .modern-input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .modern-input-wrapper i.input-icon {
            position: absolute;
            left: 18px;
            color: var(--gray-400);
            font-size: 1.25rem;
            transition: color 0.25s ease;
            pointer-events: none;
        }

        .modern-input-wrapper input {
            width: 100%;
            padding: 14px 16px 14px 50px;
            border: 1.5px solid var(--gray-200);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.9);
            color: var(--gray-800);
            outline: none;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.25s ease;
        }

        .modern-input-wrapper input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12);
            background: white;
        }

        .modern-input-wrapper input:focus+i.input-icon {
            color: var(--primary-500);
        }

        /* Password and PIN view toggles */
        .field-view-btn {
            position: absolute;
            right: 15px;
            background: none;
            border: none;
            color: var(--gray-400);
            cursor: pointer;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            outline: none;
            transition: color 0.25s ease;
        }

        .field-view-btn:hover {
            color: var(--primary-500);
        }

        /* Underline slider links */
        .hover-link {
            position: relative;
            color: var(--primary-600);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.25s ease;
        }

        .hover-link::after {
            content: '';
            position: absolute;
            width: 100%;
            transform: scaleX(0);
            height: 1.5px;
            bottom: -2px;
            left: 0;
            background-color: var(--primary-500);
            transform-origin: bottom right;
            transition: transform 0.25s ease-out;
        }

        .hover-link:hover {
            color: var(--primary-500);
        }

        .hover-link:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }

        /* Toasted Alert Boxes */
        .toast-alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 22px;
            font-size: 0.9rem;
            font-weight: 500;
            animation: alertSlideDown 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
        }

        .toast-alert-error {
            background: rgba(239, 68, 68, 0.05);
            border: 1px solid rgba(239, 68, 68, 0.15);
            border-left: 4px solid #ef4444;
            color: #b91c1c;
        }

        .toast-alert-success {
            background: rgba(16, 185, 129, 0.05);
            border: 1px solid rgba(16, 185, 129, 0.15);
            border-left: 4px solid #10b981;
            color: #065f46;
        }

        @keyframes alertSlideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Submit Button Redesign */
        .btn-submit-premium {
            width: 100%;
            padding: 14px 24px;
            font-size: 1rem;
            font-weight: 600;
            color: white;
            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
            border: none;
            border-radius: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all var(--transition-normal);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.15);
            font-family: var(--font-display);
        }

        .btn-submit-premium:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(79, 70, 229, 0.25);
            background: linear-gradient(135deg, var(--primary-500) 0%, var(--primary-600) 100%);
        }

        .btn-submit-premium:active {
            transform: translateY(0);
        }

        .btn-submit-premium i {
            font-size: 1.35rem;
            transition: transform var(--transition-fast);
        }

        .btn-submit-premium:hover i {
            transform: translateX(4px);
        }

        /* Secure indicator */
        .secure-tag {
            font-size: 0.8rem;
            opacity: 0.9;
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--gray-500);
            margin-top: 15px;
        }

        .secure-tag i {
            color: #10b981;
            font-size: 0.95rem;
        }

        /* Premium Bank Card Number layout adjustment to stay on single line */
        .bank-card-number {
            display: flex !important;
            flex-direction: row !important;
            align-items: center !important;
            justify-content: flex-start !important;
            gap: 8px !important;
            flex-wrap: nowrap !important;
            width: 100% !important;
        }

        .bank-card-number .dots {
            font-size: 1.15rem !important;
            letter-spacing: 1.5px !important;
            white-space: nowrap !important;
            display: inline-block !important;
        }

        .bank-card-number .digits {
            font-size: 1.15rem !important;
            letter-spacing: 0.5px !important;
            white-space: nowrap !important;
            display: inline-block !important;
        }

        /* Responsive stack changes */
        @media (max-width: 900px) {
            .auth-card-container {
                flex-direction: column !important;
                margin: 20px 15px !important;
            }

            .auth-branding-side {
                display: none !important;
            }

            .auth-form-side {
                padding: 40px 30px !important;
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

    <header class="header scrolled">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo" aria-label="Vertex Galaxy Bank home" style="display: flex; align-items: center;">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
        </a>
        <nav class="navbar" aria-label="Main navigation">
            <a href="${pageContext.request.contextPath}/index.jsp#home"><i class="bx bx-home"></i> Home</a>
            <a href="${pageContext.request.contextPath}/index.jsp#about"><i class="bx bx-info-circle"></i> About</a>
            <a href="${pageContext.request.contextPath}/index.jsp#services"><i class="bx bx-grid-alt"></i> Services</a>
        </nav>
        <div class="nav-actions">
            <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle theme" style="display: none;">
                <i class="bx bx-moon"></i>
            </button>
        </div>
    </header>

    <main style="padding-top: 100px; min-height: calc(100vh - 120px); display: flex; align-items: center; justify-content: center; position: relative; z-index: 2;">
        <!-- Glowing background blobs -->
        <div class="glow-blobs-container">
            <div class="glow-blob glow-blob-1"></div>
            <div class="glow-blob glow-blob-2"></div>
            <div class="glow-blob glow-blob-3"></div>
        </div>

        <div class="auth-card-container">
            <!-- Left Branding Side -->
            <div class="auth-branding-side">
                <div class="branding-content">
                    <h2 class="branding-title" id="brandingTitle">Recover Your<br>Smart Access</h2>
                    <p class="branding-desc" id="brandingDesc">Verify your secure customer identity using your registered email and 4-digit PIN to set a new password instantly. Access to your ledgers and wire routes will resume immediately.</p>
                </div>

                <!-- Rotating/Floating 3D Card Mockup -->
                <div class="bank-card-container" style="margin-top: 30px; transform: scale(1.05);">
                    <div class="bank-card" style="transform: rotateX(12deg) rotateY(-12deg);">
                        <div class="card-glare"></div>
                        <div class="bank-card-top">
                            <div class="bank-card-logo-container">
                                <svg class="vg-orbit-logo" viewBox="0 0 100 100" width="32" height="32" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="50" cy="50" rx="38" ry="12" fill="none" stroke="url(#goldGradForgot)" stroke-width="3" transform="rotate(-30 50 50)" />
                                    <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif" font-size="28" font-weight="800" fill="#ffffff">V</text>
                                    <text x="48" y="65" font-family="'Playfair Display', 'Georgia', serif" font-style="italic" font-size="34" font-weight="bold" fill="url(#goldGradForgot)">G</text>
                                    <path d="M 80 22 L 81.5 25 L 85 26.5 L 81.5 28 L 80 31 L 78.5 28 L 75 26.5 L 78.5 25 Z" fill="#ffe875" />
                                    <defs>
                                        <linearGradient id="goldGradForgot" x1="0%" y1="0%" x2="100%" y2="100%">
                                            <stop offset="0%" stop-color="#ffe875" />
                                            <stop offset="50%" stop-color="#f7c844" />
                                            <stop offset="100%" stop-color="#b88f14" />
                                        </linearGradient>
                                    </defs>
                                </svg>
                                <span class="bank-name-text">Vertex Galaxy Bank</span>
                            </div>
                            <svg class="bank-card-chip" viewBox="0 0 100 80" width="45" height="36" xmlns="http://www.w3.org/2000/svg">
                                <rect x="5" y="5" width="90" height="70" rx="10" fill="url(#chipGoldGradForgot)" stroke="#b59410" stroke-width="1.5" />
                                <path d="M 5,25 H 45 V 55 H 5" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                <path d="M 95,25 H 55 V 55 H 95" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                <path d="M 45,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                <path d="M 55,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                <rect x="30" y="25" width="40" height="30" rx="4" fill="#8c710c" opacity="0.3" />
                                <defs>
                                    <linearGradient id="chipGoldGradForgot" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#ffe875" />
                                        <stop offset="50%" stop-color="#f7c844" />
                                        <stop offset="100%" stop-color="#b88f14" />
                                    </linearGradient>
                                </defs>
                            </svg>
                        </div>
                        <div class="bank-card-number">
                            <span class="dots">•••• &nbsp; •••• &nbsp; ••••</span>
                            <span class="digits">1719</span>
                        </div>
                        <div class="bank-card-bottom">
                            <span>VGB Verification</span>
                            <strong class="vgb-gradient-logo">VGB</strong>
                        </div>
                    </div>
                </div>

                <div class="secure-tag">
                    <i class="bx bx-shield-quarter"></i> Secure encrypted password update
                </div>
            </div>

            <!-- Right Reset Form Side -->
            <div class="auth-form-side">
                <div style="margin-bottom: 25px;">
                    <h3 style="font-size: 2rem; font-weight: 800; color: var(--gray-900); margin-bottom: 8px; letter-spacing: -0.5px;" id="recoveryTitle">Recovery Center</h3>
                    <p style="color: var(--gray-500); font-size: 0.9rem;" id="recoverySubtitle">Retrieve your username or reset credentials.</p>
                </div>

                <!-- Recovery Mode Tabs -->
                <div class="portal-tabs-container" id="recoveryTabs" style="margin-bottom: 25px;">
                    <div class="tabs-slider" id="recoverySlider" style="width: calc(33.333% - 6px);"></div>
                    <button type="button" class="portal-tab-btn active" onclick="switchRecoveryType('password')" id="tabResetPassword">
                        <i class="bx bx-key"></i> Password
                    </button>
                    <button type="button" class="portal-tab-btn" onclick="switchRecoveryType('pin')" id="tabResetPin">
                        <i class="bx bx-dialpad"></i> PIN
                    </button>
                    <button type="button" class="portal-tab-btn" onclick="switchRecoveryType('username')" id="tabRecoverUsername">
                        <i class="bx bx-user"></i> Username
                    </button>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty error}">
                    <div class="toast-alert toast-alert-error">
                        <i class="bx bx-error-circle" style="font-size: 1.3rem;"></i>
                        <span>${error}</span>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="toast-alert toast-alert-success">
                        <i class="bx bx-check-circle" style="font-size: 1.3rem;"></i>
                        <span>${success}</span>
                    </div>
                </c:if>

                <!-- Form 1: Reset Password -->
                <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="resetPasswordForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="resetPassword">
                    <input type="hidden" name="userType" id="pwdUserType" value="customer">

                    <!-- Role Switcher for Password Reset -->
                    <div class="portal-tabs-container" style="margin-top: -10px; margin-bottom: 20px; gap: 10px; background: rgba(99, 102, 241, 0.04); padding: 5px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.08); position: relative;" id="pwdRoleToggle">
                        <div class="tabs-slider" id="pwdRoleSlider" style="width: calc(50% - 5px); left: 5px; top: 5px; bottom: 5px;"></div>
                        <button type="button" class="portal-tab-btn active" onclick="switchPwdRole('customer')" id="pwdCustomerBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-user"></i> Customer Reset
                        </button>
                        <button type="button" class="portal-tab-btn" onclick="switchPwdRole('admin')" id="pwdAdminBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-shield-quarter"></i> Admin Reset
                        </button>
                    </div>

                    <!-- Username Field -->
                    <div class="modern-form-group">
                        <label for="username" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Username</label>
                        <div class="modern-input-wrapper">
                            <input type="text" id="username" name="username" required placeholder="Enter username">
                            <i class="bx bx-user input-icon"></i>
                        </div>
                    </div>

                    <!-- Email Field -->
                    <div class="modern-form-group">
                        <label for="email" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Registered Email</label>
                        <div class="modern-input-wrapper">
                            <input type="email" id="email" name="email" required placeholder="name@example.com">
                            <i class="bx bx-envelope input-icon"></i>
                        </div>
                    </div>

                    <!-- Security PIN Field -->
                    <div class="modern-form-group">
                        <label for="pin" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Security PIN (4 digits)</label>
                        <div class="modern-input-wrapper">
                            <input type="password" id="pin" name="pin" maxlength="4" pattern="^[0-9]{4}$" required placeholder="Enter security PIN">
                            <i class="bx bx-key input-icon"></i>
                            <button type="button" class="field-view-btn" onclick="toggleFieldVisibility('pin', 'pinEyeIcon')">
                                <i class="bx bx-show" id="pinEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- New Password Field -->
                    <div class="modern-form-group" style="margin-bottom: 25px;">
                        <label for="newPassword" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Create New Password</label>
                        <div class="modern-input-wrapper">
                            <input type="password" id="newPassword" name="newPassword" required placeholder="Min 4 chars password">
                            <i class="bx bx-lock-alt input-icon"></i>
                            <button type="button" class="field-view-btn" onclick="toggleFieldVisibility('newPassword', 'newPasswordEyeIcon')">
                                <i class="bx bx-show" id="newPasswordEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit-premium">
                        <span>Reset Password &amp; Continue</span>
                        <i class="bx bx-check-circle"></i>
                    </button>
                </form>

                <!-- Form 2: Reset PIN -->
                <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="resetPinForm" style="display: none;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="resetPIN">
                    <input type="hidden" name="userType" id="pinUserType" value="customer">

                    <!-- Role Switcher for PIN Reset -->
                    <div class="portal-tabs-container" style="margin-top: -10px; margin-bottom: 20px; gap: 10px; background: rgba(99, 102, 241, 0.04); padding: 5px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.08); position: relative;" id="pinRoleToggle">
                        <div class="tabs-slider" id="pinRoleSlider" style="width: calc(50% - 5px); left: 5px; top: 5px; bottom: 5px;"></div>
                        <button type="button" class="portal-tab-btn active" onclick="switchPinRole('customer')" id="pinCustomerBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-user"></i> Customer Reset
                        </button>
                        <button type="button" class="portal-tab-btn" onclick="switchPinRole('admin')" id="pinAdminBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-shield-quarter"></i> Admin Reset
                        </button>
                    </div>

                    <!-- Username Field -->
                    <div class="modern-form-group">
                        <label for="pinUsername" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Username</label>
                        <div class="modern-input-wrapper">
                            <input type="text" id="pinUsername" name="username" required placeholder="Enter username">
                            <i class="bx bx-user input-icon"></i>
                        </div>
                    </div>

                    <!-- Email Field -->
                    <div class="modern-form-group">
                        <label for="pinEmail" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Registered Email</label>
                        <div class="modern-input-wrapper">
                            <input type="email" id="pinEmail" name="email" required placeholder="name@example.com">
                            <i class="bx bx-envelope input-icon"></i>
                        </div>
                    </div>

                    <!-- Password Field -->
                    <div class="modern-form-group">
                        <label for="pinPassword" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Login Password</label>
                        <div class="modern-input-wrapper">
                            <input type="password" id="pinPassword" name="password" required placeholder="Enter login password">
                            <i class="bx bx-lock-alt input-icon"></i>
                            <button type="button" class="field-view-btn" onclick="toggleFieldVisibility('pinPassword', 'pinPasswordEyeIcon')">
                                <i class="bx bx-show" id="pinPasswordEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- New PIN Field -->
                    <div class="modern-form-group" style="margin-bottom: 25px;">
                        <label for="newPin" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Create New PIN</label>
                        <div class="modern-input-wrapper">
                            <input type="password" id="newPin" name="newPin" maxlength="4" pattern="^[0-9]{4}$" required placeholder="4 digits PIN">
                            <i class="bx bx-dialpad input-icon"></i>
                            <button type="button" class="field-view-btn" onclick="toggleFieldVisibility('newPin', 'newPinEyeIcon')">
                                <i class="bx bx-show" id="newPinEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit-premium">
                        <span>Reset Security PIN</span>
                        <i class="bx bx-dialpad"></i>
                    </button>
                </form>

                <!-- Form 3: Retrieve Username -->
                <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="recoverUsernameForm" style="display: none;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="recoverUsername">

                    <!-- Info Alert Info Box -->
                    <div style="background: rgba(99, 102, 241, 0.05); padding: 14px; border-radius: 12px; margin-bottom: 22px; font-size: 0.825rem; color: var(--primary-600); display: flex; align-items: center; gap: 10px; border: 1px solid rgba(99, 102, 241, 0.1);">
                        <i class="bx bx-info-circle" style="font-size: 1.25rem;"></i>
                        <span>Available for customers only. Verify your profile specs to retrieve username.</span>
                    </div>

                    <!-- First Name Field -->
                    <div class="modern-form-group">
                        <label for="firstName" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">First Name</label>
                        <div class="modern-input-wrapper">
                            <input type="text" id="firstName" name="firstName" required placeholder="E.g. John">
                            <i class="bx bx-id-card input-icon"></i>
                        </div>
                    </div>

                    <!-- Last Name Field -->
                    <div class="modern-form-group">
                        <label for="lastName" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Last Name</label>
                        <div class="modern-input-wrapper">
                            <input type="text" id="lastName" name="lastName" required placeholder="E.g. Doe">
                            <i class="bx bx-id-card input-icon"></i>
                        </div>
                    </div>

                    <!-- Email Field -->
                    <div class="modern-form-group">
                        <label for="usrEmail" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Registered Email</label>
                        <div class="modern-input-wrapper">
                            <input type="email" id="usrEmail" name="email" required placeholder="john.doe@example.com">
                            <i class="bx bx-envelope input-icon"></i>
                        </div>
                    </div>

                    <!-- Phone Field -->
                    <div class="modern-form-group" style="margin-bottom: 25px;">
                        <label for="phone" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Phone Number</label>
                        <div class="modern-input-wrapper">
                            <input type="text" id="phone" name="phone" required placeholder="10-digit mobile number">
                            <i class="bx bx-phone input-icon"></i>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit-premium">
                        <span>Retrieve Username</span>
                        <i class="bx bx-search-alt"></i>
                    </button>
                </form>

                <div style="text-align: center; font-size: 0.875rem; color: var(--gray-500); margin-top: 25px;">
                    Remember your credentials? <a href="${pageContext.request.contextPath}/login" class="hover-link">Back to login</a>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0;">
        <div class="container" style="text-align: center;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Secured RBI regulated platform.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function toggleFieldVisibility(fieldId, iconId) {
            const input = document.getElementById(fieldId);
            const eyeIcon = document.getElementById(iconId);
            if (input && eyeIcon) {
                if (input.type === 'password') {
                    input.type = 'text';
                    eyeIcon.className = 'bx bx-hide';
                } else {
                    input.type = 'password';
                    eyeIcon.className = 'bx bx-show';
                }
            }
        }

        function switchRecoveryType(type) {
            const tabs = ['tabResetPassword', 'tabResetPin', 'tabRecoverUsername'];
            const forms = ['resetPasswordForm', 'resetPinForm', 'recoverUsernameForm'];

            const tabResetPassword = document.getElementById('tabResetPassword');
            const tabResetPin = document.getElementById('tabResetPin');
            const tabRecoverUsername = document.getElementById('tabRecoverUsername');

            const formResetPassword = document.getElementById('resetPasswordForm');
            const formResetPin = document.getElementById('resetPinForm');
            const formRecoverUsername = document.getElementById('recoverUsernameForm');

            const title = document.getElementById('recoveryTitle');
            const subtitle = document.getElementById('recoverySubtitle');
            
            const brandingTitle = document.getElementById('brandingTitle');
            const brandingDesc = document.getElementById('brandingDesc');

            const recoverySlider = document.getElementById('recoverySlider');

            // Remove active from all tabs
            tabs.forEach(id => {
                const tab = document.getElementById(id);
                if (tab) tab.classList.remove('active');
            });

            // Hide all forms and disable their inputs
            forms.forEach(id => {
                const form = document.getElementById(id);
                if (form) {
                    form.style.display = 'none';
                    const inputs = form.querySelectorAll('input');
                    inputs.forEach(input => {
                        if (input.type !== 'hidden') {
                            input.setAttribute('disabled', 'disabled');
                        }
                    });
                }
            });

            let activeForm = null;
            if (type === 'pin') {
                if (tabResetPin) tabResetPin.classList.add('active');
                if (formResetPin) formResetPin.style.display = 'block';
                activeForm = formResetPin;
                if (title) title.textContent = "Reset Security PIN";
                if (subtitle) subtitle.textContent = "Provide username, email, and password to recover PIN.";
                
                if (brandingTitle) brandingTitle.innerHTML = "Recover Your<br>Access PIN";
                if (brandingDesc) brandingDesc.textContent = "Verify your customer identity details and password to configure a new security PIN. Instantly recover access to checkbooks and statement authorizations.";
                if (recoverySlider) recoverySlider.style.transform = 'translateX(100%)';
            } else if (type === 'username') {
                if (tabRecoverUsername) tabRecoverUsername.classList.add('active');
                if (formRecoverUsername) formRecoverUsername.style.display = 'block';
                activeForm = formRecoverUsername;
                if (title) title.textContent = "Retrieve Username";
                if (subtitle) subtitle.textContent = "Verify profile details to recover your customer username.";
                
                if (brandingTitle) brandingTitle.innerHTML = "Retrieve Your<br>Customer ID";
                if (brandingDesc) brandingDesc.textContent = "Submit your registered name, phone, and email coordinates. Our secure ledgers will instantly trace and reveal your VGB username.";
                if (recoverySlider) recoverySlider.style.transform = 'translateX(200%)';
            } else {
                if (tabResetPassword) tabResetPassword.classList.add('active');
                if (formResetPassword) formResetPassword.style.display = 'block';
                activeForm = formResetPassword;
                if (title) title.textContent = "Reset Password";
                if (subtitle) subtitle.textContent = "Provide username, email, and security PIN to reset password.";
                
                if (brandingTitle) brandingTitle.innerHTML = "Recover Your<br>Smart Access";
                if (brandingDesc) brandingDesc.textContent = "Verify your secure customer identity using your registered email and 4-digit PIN to set a new password instantly. Access to your ledgers and wire routes will resume immediately.";
                if (recoverySlider) recoverySlider.style.transform = 'translateX(0%)';
            }

            // Enable inputs on active form
            if (activeForm) {
                const inputs = activeForm.querySelectorAll('input');
                inputs.forEach(input => {
                    input.removeAttribute('disabled');
                });
            }
        }

        function switchPwdRole(role) {
            const customerBtn = document.getElementById('pwdCustomerBtn');
            const adminBtn = document.getElementById('pwdAdminBtn');
            const userTypeInput = document.getElementById('pwdUserType');
            const pwdRoleSlider = document.getElementById('pwdRoleSlider');

            if (role === 'admin') {
                if (adminBtn) adminBtn.classList.add('active');
                if (customerBtn) customerBtn.classList.remove('active');
                if (userTypeInput) userTypeInput.value = 'admin';
                if (pwdRoleSlider) pwdRoleSlider.style.transform = 'translateX(100%)';
            } else {
                if (customerBtn) customerBtn.classList.add('active');
                if (adminBtn) adminBtn.classList.remove('active');
                if (userTypeInput) userTypeInput.value = 'customer';
                if (pwdRoleSlider) pwdRoleSlider.style.transform = 'translateX(0%)';
            }
        }

        function switchPinRole(role) {
            const customerBtn = document.getElementById('pinCustomerBtn');
            const adminBtn = document.getElementById('pinAdminBtn');
            const userTypeInput = document.getElementById('pinUserType');
            const pinRoleSlider = document.getElementById('pinRoleSlider');

            if (role === 'admin') {
                if (adminBtn) adminBtn.classList.add('active');
                if (customerBtn) customerBtn.classList.remove('active');
                if (userTypeInput) userTypeInput.value = 'admin';
                if (pinRoleSlider) pinRoleSlider.style.transform = 'translateX(100%)';
            } else {
                if (customerBtn) customerBtn.classList.add('active');
                if (adminBtn) adminBtn.classList.remove('active');
                if (userTypeInput) userTypeInput.value = 'customer';
                if (pinRoleSlider) pinRoleSlider.style.transform = 'translateX(0%)';
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            // Read URL query parameter
            const urlParams = new URLSearchParams(window.location.search);
            const type = urlParams.get('type') || 'password';
            const role = urlParams.get('role') || 'customer';

            // Or get tab forwarded back from servlet
            let activeTab = "${activeTab}";
            if (!activeTab) {
                activeTab = type;
            }

            if (activeTab === 'resetPIN' || activeTab === 'pin') {
                switchRecoveryType('pin');
                switchPinRole(role);
            } else if (activeTab === 'recoverUsername' || activeTab === 'username') {
                switchRecoveryType('username');
            } else {
                switchRecoveryType('password');
                switchPwdRole(role);
            }

            // Tilt Hover Effect for 3D Card
            const card = document.querySelector('.bank-card');
            const container = document.querySelector('.bank-card-container');
            if (card && container) {
                container.addEventListener('mousemove', (e) => {
                    const rect = container.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    
                    const midX = rect.width / 2;
                    const midY = rect.height / 2;
                    
                    const tiltX = -(y - midY) / 10;
                    const tiltY = (x - midX) / 10;
                    
                    card.style.transform = `rotateX(${tiltX}deg) rotateY(${tiltY}deg) translateY(-8px) scale(1.02)`;
                });
                
                container.addEventListener('mouseleave', () => {
                    card.style.transform = 'rotateX(12deg) rotateY(-12deg) translateY(0px) scale(1)';
                });
            }
        });
    </script>
</body>

</html>