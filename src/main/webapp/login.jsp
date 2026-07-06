<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>VGB | Portal Login</title>
            <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">
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
                    min-height: 650px;
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
                    font-size: 0.92rem !important;
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

                /* Login Mode Pill Tab Selector */
                .login-mode-container {
                    display: flex;
                    position: relative;
                    background: rgba(148, 163, 184, 0.08);
                    padding: 5px;
                    border-radius: 10px;
                    margin-bottom: 25px;
                    border: 1px solid rgba(148, 163, 184, 0.1);
                }

                .login-mode-btn {
                    flex: 1;
                    position: relative;
                    z-index: 2;
                    padding: 10px 15px;
                    font-weight: 600;
                    border-radius: 8px;
                    font-size: 0.85rem;
                    border: none;
                    background: transparent;
                    color: var(--gray-500);
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 6px;
                    transition: color 0.3s ease;
                }

                .login-mode-btn.active {
                    color: var(--primary-600);
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
                    transform: scale(0.96) !important;
                }

                .btn-submit-premium i {
                    font-size: 1.35rem;
                    transition: transform var(--transition-fast);
                }

                .btn-submit-premium:hover i {
                    transform: translateX(4px);
                }

                /* 4-Box PIN Layout */
                .pin-box {
                    width: 58px;
                    height: 58px;
                    text-align: center;
                    font-size: 1.6rem;
                    font-weight: 700;
                    border: 1.5px solid var(--gray-200);
                    border-radius: 12px;
                    outline: none;
                    background: rgba(255, 255, 255, 0.95);
                    transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
                    box-shadow: var(--shadow-sm);
                    color: var(--gray-800);
                }

                .pin-box:focus {
                    border-color: var(--primary-500) !important;
                    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12) !important;
                    transform: translateY(-2px) scale(1.04);
                    background: white;
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

            <header class="header scrolled">
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo" aria-label="Vertex Galaxy Bank home"
                    style="display: flex; align-items: center; text-decoration: none;">
                    <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
                </a>
                <nav class="navbar" aria-label="Main navigation">
                    <a href="${pageContext.request.contextPath}/index.jsp#home"><i class="bx bx-home"></i> Home</a>
                    <a href="${pageContext.request.contextPath}/index.jsp#about"><i class="bx bx-info-circle"></i>
                        About</a>
                    <a href="${pageContext.request.contextPath}/index.jsp#services"><i class="bx bx-grid-alt"></i>
                        Services</a>
                </nav>
                <div class="nav-actions">
                </div>
            </header>

            <main
                style="padding-top: 100px; min-height: calc(100vh - 120px); display: flex; align-items: center; justify-content: center; position: relative; z-index: 2;">
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
                            <h2 class="branding-title">Secure Digital<br>Gateway</h2>
                            <p class="branding-desc">Experience real-time Indian digital banking. Access deposits,
                                instant checking accounts, and secure lending portals built with extreme precision and
                                AI-based performance metrics.</p>
                        </div>

                        <!-- Rotating/Floating 3D Card Mockup -->
                        <div class="bank-card-container" style="margin-top: 30px; transform: scale(1.05);">
                            <div class="bank-card" style="transform: rotateX(12deg) rotateY(-12deg);">
                                <div class="card-glare"></div>
                                <div class="bank-card-top">
                                    <div class="bank-card-logo-container">
                                        <img src="${pageContext.request.contextPath}/assest/images/logo.png" class="vg-orbit-logo" alt="VGB Logo" style="width: 32px; height: 32px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));">
                                        <span class="bank-name-text">Vertex Galaxy Bank</span>
                                    </div>
                                    <svg class="bank-card-chip" viewBox="0 0 100 80" width="45" height="36"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <rect x="5" y="5" width="90" height="70" rx="10" fill="url(#chipGoldGradLogin)"
                                            stroke="#b59410" stroke-width="1.5" />
                                        <path d="M 5,25 H 45 V 55 H 5" fill="none" stroke="#8c710c"
                                            stroke-width="1.5" />
                                        <path d="M 95,25 H 55 V 55 H 95" fill="none" stroke="#8c710c"
                                            stroke-width="1.5" />
                                        <path d="M 45,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                        <path d="M 55,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                        <rect x="30" y="25" width="40" height="30" rx="4" fill="#8c710c"
                                            opacity="0.3" />
                                        <defs>
                                            <linearGradient id="chipGoldGradLogin" x1="0%" y1="0%" x2="100%" y2="100%">
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
                                    <span>VGB Smart Access</span>
                                    <strong class="vgb-gradient-logo">VGB</strong>
                                </div>
                            </div>
                        </div>

                        <div class="secure-tag">
                            <i class="bx bx-shield-quarter"></i> End-to-end 256-bit SSL encrypted connection
                        </div>
                    </div>

                    <!-- Right Login Form Side -->
                    <div class="auth-form-side" id="loginFormContainer">
                        <div style="margin-bottom: 25px;">
                            <h3 style="font-size: 2rem; font-weight: 800; color: var(--gray-900); margin-bottom: 8px; letter-spacing: -0.5px;"
                                id="loginTitle">Welcome Back</h3>
                            <p style="color: var(--gray-500); font-size: 0.9rem;">Please choose your portal and enter
                                details.</p>
                        </div>

                        <!-- Role Tab Selectors with Smooth Slider -->
                        <div class="portal-tabs-container" id="portalTabs">
                            <div class="tabs-slider portal-slider"></div>
                            <button type="button" class="portal-tab-btn active" onclick="switchPortal('customer')"
                                id="customerTab">
                                <i class="bx bx-user"></i> Customer
                            </button>
                            <button type="button" class="portal-tab-btn" onclick="switchPortal('admin')" id="adminTab">
                                <i class="bx bx-shield-quarter"></i> Admin
                            </button>
                        </div>

                        <!-- Secondary Toggle: Password vs. PIN with Smooth Slider -->
                        <div class="login-mode-container" id="loginModeToggle">
                            <div class="tabs-slider mode-slider"
                                style="width: calc(50% - 5px); left: 5px; top: 5px; bottom: 5px;"></div>
                            <button type="button" class="login-mode-btn active" onclick="switchLoginMode('password')"
                                id="passwordModeTab">
                                <i class="bx bx-key"></i> Password Login
                            </button>
                            <button type="button" class="login-mode-btn" onclick="switchLoginMode('pin')"
                                id="pinModeTab">
                                <i class="bx bx-dialpad"></i> PIN Login
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

                        <form action="${pageContext.request.contextPath}/login" method="post" id="actualLoginForm">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="userType" id="userTypeInput" value="customer">
                            <input type="hidden" name="loginMode" id="loginModeInput" value="password">

                            <!-- Username / Customer ID -->
                            <div class="modern-form-group">
                                <label for="username"
                                    style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Username
                                    / Customer ID</label>
                                <div class="modern-input-wrapper">
                                    <input type="text" id="username" name="username" required
                                        placeholder="Enter username" autocomplete="username">
                                    <i class="bx bx-user input-icon"></i>
                                </div>
                            </div>

                            <!-- Password Field Group -->
                            <div class="modern-form-group" id="passwordFieldGroup">
                                <div
                                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                    <label for="password"
                                        style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 0;">Password</label>
                                    <div id="passwordLinksContainer"
                                        style="display: flex; gap: 8px; font-size: 0.8rem; align-items: center;">
                                        <a href="${pageContext.request.contextPath}/forgot-password?type=password"
                                            id="forgotPasswordLink" class="hover-link">Forgot Password?</a>
                                        <span id="forgotDivider" style="color: var(--gray-300);">|</span>
                                        <a href="${pageContext.request.contextPath}/forgot-password?type=username"
                                            id="forgotUsernameLink" class="hover-link">Forgot Username?</a>
                                    </div>
                                </div>
                                <div class="modern-input-wrapper">
                                    <input type="password" id="password" name="password" required
                                        placeholder="Enter password" autocomplete="current-password">
                                    <i class="bx bx-lock-alt input-icon"></i>
                                    <button type="button"
                                        onclick="togglePasswordVisibility('password', 'passwordEyeIcon')"
                                        class="field-view-btn" aria-label="Toggle password visibility">
                                        <i class="bx bx-show" id="passwordEyeIcon"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- PIN Field Group (Box Format) -->
                            <div class="modern-form-group" id="pinFieldGroup" style="display: none;">
                                <div
                                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                    <label
                                        style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 0;">4-Digit
                                        Transaction PIN</label>
                                    <div style="display: flex; gap: 8px; align-items: center; font-size: 0.8rem;">
                                        <a href="${pageContext.request.contextPath}/forgot-password?type=pin"
                                            id="forgotPinLink" class="hover-link">Forgot PIN?</a>
                                        <span style="color: var(--gray-300);">|</span>
                                        <button type="button" onclick="togglePinBoxesVisibility()"
                                            style="background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; font-size: 0.8rem; outline: none; gap: 4px; font-weight: 600;"
                                            onmouseover="this.style.color='var(--primary-500)'"
                                            onmouseout="this.style.color='var(--gray-400)'">
                                            <i class="bx bx-show" id="pinBoxEyeIcon"></i> <span
                                                style="font-size: 0.75rem;">Show PIN</span>
                                        </button>
                                    </div>
                                </div>
                                <div style="display: flex; gap: 15px; justify-content: center; margin-top: 15px;"
                                    id="pinBoxContainer">
                                    <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1"
                                        class="pin-box" oninput="moveToNext(this, 'pin2')"
                                        onkeydown="moveToPrev(event, this, null)" id="pin1" aria-label="PIN Digit 1">
                                    <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1"
                                        class="pin-box" oninput="moveToNext(this, 'pin3')"
                                        onkeydown="moveToPrev(event, this, 'pin1')" id="pin2" aria-label="PIN Digit 2">
                                    <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1"
                                        class="pin-box" oninput="moveToNext(this, 'pin4')"
                                        onkeydown="moveToPrev(event, this, 'pin2')" id="pin3" aria-label="PIN Digit 3">
                                    <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1"
                                        class="pin-box" oninput="moveToNext(this, null)"
                                        onkeydown="moveToPrev(event, this, 'pin3')" id="pin4" aria-label="PIN Digit 4">
                                </div>
                                <input type="hidden" id="pin" name="pin">
                            </div>

                            <button type="submit" class="btn-submit-premium" style="margin-top: 10px;">
                                <span>Verify &amp; Continue</span>
                                <i class="bx bx-right-arrow-alt"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </main>

            <footer class="footer" style="padding: 20px 0;">
                <div class="container" style="text-align: center;">
                    <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span>
                        Vertex Galaxy Bank. Secured &amp; Regulated under RBI Guidelines.</p>
                </div>
            </footer>

            <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
            <script>
                // Custom 3D Card tilt effect on hover for the credit card container
                const card = document.querySelector('.bank-card');
                const container = document.querySelector('.bank-card-container');
                if (card && container) {
                    container.addEventListener('mousemove', (e) => {
                        const rect = container.getBoundingClientRect();
                        const x = e.clientX - rect.left - (rect.width / 2);
                        const y = e.clientY - rect.top - (rect.height / 2);

                        // Tilt scaling
                        const tiltX = (y / (rect.height / 2)) * -12;
                        const tiltY = (x / (rect.width / 2)) * 12;

                        card.style.transform = `rotateX(${tiltX}deg) rotateY(${tiltY}deg) translateY(-8px) scale(1.02)`;
                    });

                    container.addEventListener('mouseleave', () => {
                        card.style.transform = 'rotateX(12deg) rotateY(-12deg) translateY(0px) scale(1)';
                    });
                }

                function switchPortal(role) {
                    const customerTab = document.getElementById('customerTab');
                    const adminTab = document.getElementById('adminTab');
                    const userTypeInput = document.getElementById('userTypeInput');
                    const loginTitle = document.getElementById('loginTitle');
                    const portalSlider = document.querySelector('.portal-slider');

                    const forgotPasswordLink = document.getElementById('forgotPasswordLink');
                    const forgotUsernameLink = document.getElementById('forgotUsernameLink');
                    const forgotDivider = document.getElementById('forgotDivider');
                    const forgotPinLink = document.getElementById('forgotPinLink');

                    // Default to Password mode when switching portals
                    switchLoginMode('password');

                    if (role === 'admin') {
                        adminTab.classList.add('active');
                        customerTab.classList.remove('active');
                        if (portalSlider) portalSlider.style.transform = 'translateX(100%)';

                        userTypeInput.value = 'admin';
                        loginTitle.textContent = 'Admin Workspace';

                        if (forgotPasswordLink) {
                            forgotPasswordLink.style.display = 'inline';
                            forgotPasswordLink.href = "${pageContext.request.contextPath}/forgot-password?type=password&role=admin";
                        }
                        if (forgotUsernameLink) forgotUsernameLink.style.display = 'none';
                        if (forgotDivider) forgotDivider.style.display = 'none';
                        if (forgotPinLink) {
                            forgotPinLink.href = "${pageContext.request.contextPath}/forgot-password?type=pin&role=admin";
                        }
                    } else {
                        customerTab.classList.add('active');
                        adminTab.classList.remove('active');
                        if (portalSlider) portalSlider.style.transform = 'translateX(0)';

                        userTypeInput.value = 'customer';
                        loginTitle.textContent = 'Welcome Back';

                        if (forgotPasswordLink) {
                            forgotPasswordLink.style.display = 'inline';
                            forgotPasswordLink.href = "${pageContext.request.contextPath}/forgot-password?type=password&role=customer";
                        }
                        if (forgotUsernameLink) {
                            forgotUsernameLink.style.display = 'inline';
                            forgotUsernameLink.href = "${pageContext.request.contextPath}/forgot-password?type=username&role=customer";
                        }
                        if (forgotDivider) forgotDivider.style.display = 'inline';
                        if (forgotPinLink) {
                            forgotPinLink.href = "${pageContext.request.contextPath}/forgot-password?type=pin&role=customer";
                        }
                    }
                }

                function switchLoginMode(mode) {
                    const passwordTab = document.getElementById('passwordModeTab');
                    const pinTab = document.getElementById('pinModeTab');
                    const loginModeInput = document.getElementById('loginModeInput');
                    const passwordGroup = document.getElementById('passwordFieldGroup');
                    const pinGroup = document.getElementById('pinFieldGroup');
                    const modeSlider = document.querySelector('.mode-slider');

                    const passwordInput = document.getElementById('password');
                    const pinInput = document.getElementById('pin');

                    // Clear any PIN boxes on mode switch
                    clearPinBoxes();

                    if (mode === 'pin') {
                        pinTab.classList.add('active');
                        passwordTab.classList.remove('active');
                        if (modeSlider) modeSlider.style.transform = 'translateX(100%)';
                        loginModeInput.value = 'pin';

                        passwordGroup.style.display = 'none';
                        pinGroup.style.display = 'block';

                        passwordInput.removeAttribute('required');
                        pinInput.setAttribute('required', 'required');

                        // Update pin link href based on current role
                        const userTypeInput = document.getElementById('userTypeInput');
                        const forgotPinLink = document.getElementById('forgotPinLink');
                        const role = (userTypeInput && userTypeInput.value === 'admin') ? 'admin' : 'customer';
                        if (forgotPinLink) {
                            forgotPinLink.href = "${pageContext.request.contextPath}/forgot-password?type=pin&role=" + role;
                        }

                        // Auto-focus first PIN box
                        setTimeout(() => {
                            const firstBox = document.getElementById('pin1');
                            if (firstBox) firstBox.focus();
                        }, 50);
                    } else {
                        passwordTab.classList.add('active');
                        pinTab.classList.remove('active');
                        if (modeSlider) modeSlider.style.transform = 'translateX(0)';
                        loginModeInput.value = 'password';

                        pinGroup.style.display = 'none';
                        passwordGroup.style.display = 'block';

                        pinInput.removeAttribute('required');
                        passwordInput.setAttribute('required', 'required');

                        // Update password links hrefs based on current role
                        const userTypeInput = document.getElementById('userTypeInput');
                        const forgotPasswordLink = document.getElementById('forgotPasswordLink');
                        const forgotUsernameLink = document.getElementById('forgotUsernameLink');
                        const forgotDivider = document.getElementById('forgotDivider');

                        if (userTypeInput && userTypeInput.value === 'admin') {
                            if (forgotPasswordLink) {
                                forgotPasswordLink.style.display = 'inline';
                                forgotPasswordLink.href = "${pageContext.request.contextPath}/forgot-password?type=password&role=admin";
                            }
                            if (forgotUsernameLink) forgotUsernameLink.style.display = 'none';
                            if (forgotDivider) forgotDivider.style.display = 'none';
                        } else {
                            if (forgotPasswordLink) {
                                forgotPasswordLink.style.display = 'inline';
                                forgotPasswordLink.href = "${pageContext.request.contextPath}/forgot-password?type=password&role=customer";
                            }
                            if (forgotUsernameLink) {
                                forgotUsernameLink.style.display = 'inline';
                                forgotUsernameLink.href = "${pageContext.request.contextPath}/forgot-password?type=username&role=customer";
                            }
                            if (forgotDivider) forgotDivider.style.display = 'inline';
                        }
                    }
                }

                function togglePasswordVisibility(inputId, iconId) {
                    const input = document.getElementById(inputId);
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

                /* --- 4-Box PIN Layout JavaScript --- */
                function moveToNext(current, nextId) {
                    current.value = current.value.replace(/[^0-9]/g, '');

                    if (current.value.length >= 1) {
                        if (nextId) {
                            const nextInput = document.getElementById(nextId);
                            if (nextInput) {
                                nextInput.focus();
                                nextInput.select();
                            }
                        }
                    }
                    updateConcatenatedPin();
                }

                function moveToPrev(e, current, prevId) {
                    if (e.key === 'Backspace' || e.key === 'Delete') {
                        if (current.value.length === 0) {
                            if (prevId) {
                                const prevInput = document.getElementById(prevId);
                                if (prevInput) {
                                    prevInput.focus();
                                    prevInput.value = '';
                                }
                            }
                        } else {
                            current.value = '';
                        }
                        updateConcatenatedPin();
                    }
                }

                function updateConcatenatedPin() {
                    const p1 = document.getElementById('pin1').value;
                    const p2 = document.getElementById('pin2').value;
                    const p3 = document.getElementById('pin3').value;
                    const p4 = document.getElementById('pin4').value;

                    const concatenated = p1 + p2 + p3 + p4;
                    document.getElementById('pin').value = concatenated;
                }

                function clearPinBoxes() {
                    document.getElementById('pin1').value = '';
                    document.getElementById('pin2').value = '';
                    document.getElementById('pin3').value = '';
                    document.getElementById('pin4').value = '';
                    document.getElementById('pin').value = '';
                }

                function togglePinBoxesVisibility() {
                    const boxes = ['pin1', 'pin2', 'pin3', 'pin4'];
                    const eyeIcon = document.getElementById('pinBoxEyeIcon');
                    const toggleSpan = eyeIcon.nextElementSibling;

                    const isPassword = document.getElementById('pin1').type === 'password';

                    boxes.forEach(id => {
                        const box = document.getElementById(id);
                        if (box) {
                            box.type = isPassword ? 'text' : 'password';
                        }
                    });

                    if (isPassword) {
                        eyeIcon.className = 'bx bx-hide';
                        if (toggleSpan) toggleSpan.textContent = 'Hide PIN';
                    } else {
                        eyeIcon.className = 'bx bx-show';
                        if (toggleSpan) toggleSpan.textContent = 'Show PIN';
                    }
                }
            </script>
        </body>

        </html>