<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Reset Password</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
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
            <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle theme">
                <i class="bx bx-moon"></i>
            </button>
        </div>
    </header>

    <main style="padding-top: 100px; min-height: calc(100vh - 120px); display: flex; align-items: center; justify-content: center; position: relative; z-index: 2;">
        <div class="hero-bg">
            <div class="gradient-orb orb-1"></div>
            <div class="gradient-orb orb-2"></div>
        </div>

        <div class="auth-card-container">
            <!-- Left Branding Side -->
            <div style="flex: 1; background: var(--gradient-primary); padding: 50px; color: white; display: flex; flex-direction: column; justify-content: space-between; position: relative;" class="mobile-hide">
                <div>
                    <h2 style="font-size: 2.2rem; font-weight: 800; line-height: 1.2; margin-bottom: 20px;">Recover Your <br>Smart Access</h2>
                    <p style="opacity: 0.9; line-height: 1.6; font-size: 0.95rem;">Verify your secure customer identity using your registered email and 4-digit PIN to set a new password instantly. Access to your ledgers and wire routes will resume immediately.</p>
                </div>
                <div class="bank-card-container" style="margin-top: 30px; transform: scale(0.95);">
                    <div class="bank-card">
                        <div class="card-glare"></div>
                        <div class="bank-card-top">
                            <div class="bank-card-logo-container">
                                <svg class="vg-orbit-logo" viewBox="0 0 100 100" width="32" height="32" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="50" cy="50" rx="38" ry="12" fill="none" stroke="url(#goldGradForgot)" stroke-width="3" transform="rotate(-30 50 50)"/>
                                    <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif" font-size="28" font-weight="800" fill="#ffffff">V</text>
                                    <text x="48" y="65" font-family="'Playfair Display', 'Georgia', serif" font-style="italic" font-size="34" font-weight="bold" fill="url(#goldGradForgot)">G</text>
                                    <path d="M 80 22 L 81.5 25 L 85 26.5 L 81.5 28 L 80 31 L 78.5 28 L 75 26.5 L 78.5 25 Z" fill="#ffe875"/>
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
                                <rect x="5" y="5" width="90" height="70" rx="10" fill="url(#chipGoldGradForgot)" stroke="#b59410" stroke-width="1.5"/>
                                <path d="M 5,25 H 45 V 55 H 5" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <path d="M 95,25 H 55 V 55 H 95" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <path d="M 45,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <path d="M 55,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <rect x="30" y="25" width="40" height="30" rx="4" fill="#8c710c" opacity="0.3"/>
                                <defs>
                                    <linearGradient id="chipGoldGradForgot" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#ffe875" />
                                        <stop offset="50%" stop-color="#f7c844" />
                                        <stop offset="100%" stop-color="#b88f14" />
                                    </linearGradient>
                                </defs>
                            </svg>
                        </div>
                        <div class="bank-card-number">••••  ••••  ••••  1719</div>
                        <div class="bank-card-bottom">
                            <span>VGB Verification</span>
                            <strong class="vgb-gradient-logo">VGB</strong>
                        </div>
                    </div>
                </div>
                <div style="font-size: 0.8rem; opacity: 0.7; display: flex; align-items: center; gap: 5px;">
                    <i class="bx bx-lock-alt"></i> Secure encrypted password update
                </div>
            </div>

            <!-- Right Reset Form Side -->
            <div class="auth-form-side">
                <div style="margin-bottom: 25px;">
                    <h3 style="font-size: 1.8rem; font-weight: 700; color: var(--gray-900); margin-bottom: 8px;" id="recoveryTitle">Recovery Center</h3>
                    <p style="color: var(--gray-500); font-size: 0.9rem;" id="recoverySubtitle">Retrieve your username or reset credentials.</p>
                </div>

                <!-- Recovery Mode Tabs -->
                <div class="portal-tabs-container" id="recoveryTypeTabs" style="margin-bottom: 25px;">
                    <button type="button" class="portal-tab-btn active" onclick="switchRecoveryType('password')" id="tabResetPassword" style="padding: 10px; font-size: 0.85rem;">
                        <i class="bx bx-key"></i> Password
                    </button>
                    <button type="button" class="portal-tab-btn" onclick="switchRecoveryType('pin')" id="tabResetPin" style="padding: 10px; font-size: 0.85rem;">
                        <i class="bx bx-dialpad"></i> PIN
                    </button>
                    <button type="button" class="portal-tab-btn" onclick="switchRecoveryType('username')" id="tabRecoverUsername" style="padding: 10px; font-size: 0.85rem;">
                        <i class="bx bx-user"></i> Username
                    </button>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty error}">
                    <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                        <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                        <span>${error}</span>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.9rem; display: flex; flex-direction: column; gap: 8px; box-shadow: var(--shadow-sm); border: 1px solid rgba(16, 185, 129, 0.2);">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <i class="bx bx-check-circle" style="font-size: 1.3rem; color: #10b981;"></i>
                            <span style="font-weight: 600;">System Callback</span>
                        </div>
                        <p style="margin: 0; line-height: 1.4;">${success}</p>
                    </div>
                </c:if>

                <!-- Form 1: Reset Password -->
                <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="resetPasswordForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="resetPassword">
                    <input type="hidden" name="userType" id="pwdUserType" value="customer">

                    <!-- Role Switcher for Password Reset -->
                    <div class="portal-tabs-container" style="margin-top: -10px; margin-bottom: 20px; gap: 10px; background: rgba(99, 102, 241, 0.04); padding: 5px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.08);" id="pwdRoleToggle">
                        <button type="button" class="portal-tab-btn active" onclick="switchPwdRole('customer')" id="pwdCustomerBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-user"></i> Customer Reset
                        </button>
                        <button type="button" class="portal-tab-btn" onclick="switchPwdRole('admin')" id="pwdAdminBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-shield-quarter"></i> Admin Reset
                        </button>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="username" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Username</label>
                        <div style="position: relative;">
                            <i class="bx bx-user" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="text" id="username" name="username" required placeholder="Enter username" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="email" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Registered Email</label>
                        <div style="position: relative;">
                            <i class="bx bx-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="email" id="email" name="email" required placeholder="name@example.com" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="pin" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Security PIN (4 digits)</label>
                        <div style="position: relative;">
                            <i class="bx bx-key" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="password" id="pin" name="pin" maxlength="4" pattern="^[0-9]{4}$" required placeholder="Enter security PIN" style="width: 100%; padding: 12px 45px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                            <button type="button" onclick="toggleFieldVisibility('pin', 'pinEyeIcon')" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; outline: none; transition: color var(--transition-fast);">
                                <i class="bx bx-show" id="pinEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 25px; position: relative;">
                        <label for="newPassword" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Create New Password</label>
                        <div style="position: relative;">
                            <i class="bx bx-lock-alt" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="password" id="newPassword" name="newPassword" required placeholder="Min 4 chars password" style="width: 100%; padding: 12px 45px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                            <button type="button" onclick="toggleFieldVisibility('newPassword', 'newPasswordEyeIcon')" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; outline: none; transition: color var(--transition-fast);">
                                <i class="bx bx-show" id="newPasswordEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-submit" style="margin-bottom: 20px; width: 100%;">
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
                    <div class="portal-tabs-container" style="margin-top: -10px; margin-bottom: 20px; gap: 10px; background: rgba(99, 102, 241, 0.04); padding: 5px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.08);" id="pinRoleToggle">
                        <button type="button" class="portal-tab-btn active" onclick="switchPinRole('customer')" id="pinCustomerBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-user"></i> Customer Reset
                        </button>
                        <button type="button" class="portal-tab-btn" onclick="switchPinRole('admin')" id="pinAdminBtn" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                            <i class="bx bx-shield-quarter"></i> Admin Reset
                        </button>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="pinUsername" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Username</label>
                        <div style="position: relative;">
                            <i class="bx bx-user" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="text" id="pinUsername" name="username" required placeholder="Enter username" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="pinEmail" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Registered Email</label>
                        <div style="position: relative;">
                            <i class="bx bx-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="email" id="pinEmail" name="email" required placeholder="name@example.com" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="pinPassword" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Login Password</label>
                        <div style="position: relative;">
                            <i class="bx bx-lock-alt" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="password" id="pinPassword" name="password" required placeholder="Enter login password" style="width: 100%; padding: 12px 45px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                            <button type="button" onclick="toggleFieldVisibility('pinPassword', 'pinPasswordEyeIcon')" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; outline: none; transition: color var(--transition-fast);">
                                <i class="bx bx-show" id="pinPasswordEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 25px; position: relative;">
                        <label for="newPin" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Create New PIN</label>
                        <div style="position: relative;">
                            <i class="bx bx-dialpad" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="password" id="newPin" name="newPin" maxlength="4" pattern="^[0-9]{4}$" required placeholder="4 digits PIN" style="width: 100%; padding: 12px 45px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                            <button type="button" onclick="toggleFieldVisibility('newPin', 'newPinEyeIcon')" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; outline: none; transition: color var(--transition-fast);">
                                <i class="bx bx-show" id="newPinEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-submit" style="margin-bottom: 20px; width: 100%;">
                        <span>Reset Security PIN</span>
                        <i class="bx bx-dialpad"></i>
                    </button>
                </form>

                <!-- Form 3: Retrieve Username -->
                <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="recoverUsernameForm" style="display: none;">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" value="recoverUsername">

                    <div style="background: rgba(99, 102, 241, 0.05); padding: 12px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.825rem; color: var(--primary-600); display: flex; align-items: center; gap: 8px; border: 1px solid rgba(99, 102, 241, 0.1);">
                        <i class="bx bx-info-circle" style="font-size: 1.1rem;"></i>
                        <span>Available for customers only. Verify your profile specs to retrieve username.</span>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="firstName" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">First Name</label>
                        <div style="position: relative;">
                            <i class="bx bx-id-card" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="text" id="firstName" name="firstName" required placeholder="E.g. John" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="lastName" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Last Name</label>
                        <div style="position: relative;">
                            <i class="bx bx-id-card" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="text" id="lastName" name="lastName" required placeholder="E.g. Doe" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px; position: relative;">
                        <label for="usrEmail" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Registered Email</label>
                        <div style="position: relative;">
                            <i class="bx bx-envelope" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="email" id="usrEmail" name="email" required placeholder="john.doe@example.com" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 25px; position: relative;">
                        <label for="phone" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Phone Number</label>
                        <div style="position: relative;">
                            <i class="bx bx-phone" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="text" id="phone" name="phone" required placeholder="10-digit mobile number" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-submit" style="margin-bottom: 20px; width: 100%;">
                        <span>Retrieve Username</span>
                        <i class="bx bx-search-alt"></i>
                    </button>
                </form>

                <div style="text-align: center; font-size: 0.875rem; color: var(--gray-500);">
                    Remember your credentials? <a href="${pageContext.request.contextPath}/login" style="color: var(--primary-500); font-weight: 600; transition: color var(--transition-fast);">Back to login</a>
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
            } else if (type === 'username') {
                if (tabRecoverUsername) tabRecoverUsername.classList.add('active');
                if (formRecoverUsername) formRecoverUsername.style.display = 'block';
                activeForm = formRecoverUsername;
                if (title) title.textContent = "Retrieve Username";
                if (subtitle) subtitle.textContent = "Verify profile details to recover your customer username.";
            } else {
                if (tabResetPassword) tabResetPassword.classList.add('active');
                if (formResetPassword) formResetPassword.style.display = 'block';
                activeForm = formResetPassword;
                if (title) title.textContent = "Reset Password";
                if (subtitle) subtitle.textContent = "Provide username, email, and security PIN to reset password.";
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
            
            if (role === 'admin') {
                adminBtn.classList.add('active');
                customerBtn.classList.remove('active');
                userTypeInput.value = 'admin';
            } else {
                customerBtn.classList.add('active');
                adminBtn.classList.remove('active');
                userTypeInput.value = 'customer';
            }
        }

        function switchPinRole(role) {
            const customerBtn = document.getElementById('pinCustomerBtn');
            const adminBtn = document.getElementById('pinAdminBtn');
            const userTypeInput = document.getElementById('pinUserType');
            
            if (role === 'admin') {
                adminBtn.classList.add('active');
                customerBtn.classList.remove('active');
                userTypeInput.value = 'admin';
            } else {
                customerBtn.classList.add('active');
                adminBtn.classList.remove('active');
                userTypeInput.value = 'customer';
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
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
        });
    </script>
</body>
</html>
