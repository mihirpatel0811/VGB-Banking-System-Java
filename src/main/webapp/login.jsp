<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Portal Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        .pin-box:focus {
            border-color: var(--primary-500) !important;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.18) !important;
            transform: translateY(-2px);
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
                    <h2 style="font-size: 2.2rem; font-weight: 800; line-height: 1.2; margin-bottom: 20px;">Secure Digital <br>Gateway</h2>
                    <p style="opacity: 0.9; line-height: 1.6; font-size: 0.95rem;">Experience real-time Indian digital banking. Access deposits, instant checking accounts, and secure lending portals built with extreme precision and AI-based performance metrics.</p>
                </div>
                <div class="bank-card-container" style="margin-top: 30px; transform: scale(0.95);">
                    <div class="bank-card">
                        <div class="card-glare"></div>
                        <div class="bank-card-top">
                            <div class="bank-card-logo-container">
                                <svg class="vg-orbit-logo" viewBox="0 0 100 100" width="32" height="32" xmlns="http://www.w3.org/2000/svg">
                                    <ellipse cx="50" cy="50" rx="38" ry="12" fill="none" stroke="url(#goldGradLogin)" stroke-width="3" transform="rotate(-30 50 50)"/>
                                    <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif" font-size="28" font-weight="800" fill="#ffffff">V</text>
                                    <text x="48" y="65" font-family="'Playfair Display', 'Georgia', serif" font-style="italic" font-size="34" font-weight="bold" fill="url(#goldGradLogin)">G</text>
                                    <path d="M 80 22 L 81.5 25 L 85 26.5 L 81.5 28 L 80 31 L 78.5 28 L 75 26.5 L 78.5 25 Z" fill="#ffe875"/>
                                    <defs>
                                        <linearGradient id="goldGradLogin" x1="0%" y1="0%" x2="100%" y2="100%">
                                            <stop offset="0%" stop-color="#ffe875" />
                                            <stop offset="50%" stop-color="#f7c844" />
                                            <stop offset="100%" stop-color="#b88f14" />
                                        </linearGradient>
                                    </defs>
                                </svg>
                                <span class="bank-name-text">Vertex Galaxy Bank</span>
                            </div>
                            <svg class="bank-card-chip" viewBox="0 0 100 80" width="45" height="36" xmlns="http://www.w3.org/2000/svg">
                                <rect x="5" y="5" width="90" height="70" rx="10" fill="url(#chipGoldGradLogin)" stroke="#b59410" stroke-width="1.5"/>
                                <path d="M 5,25 H 45 V 55 H 5" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <path d="M 95,25 H 55 V 55 H 95" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <path d="M 45,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <path d="M 55,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5"/>
                                <rect x="30" y="25" width="40" height="30" rx="4" fill="#8c710c" opacity="0.3"/>
                                <defs>
                                    <linearGradient id="chipGoldGradLogin" x1="0%" y1="0%" x2="100%" y2="100%">
                                        <stop offset="0%" stop-color="#ffe875" />
                                        <stop offset="50%" stop-color="#f7c844" />
                                        <stop offset="100%" stop-color="#b88f14" />
                                    </linearGradient>
                                </defs>
                            </svg>
                        </div>
                        <div class="bank-card-number">••••  ••••  ••••  1719</div>
                        <div class="bank-card-bottom">
                            <span>VGB Smart Access</span>
                            <strong class="vgb-gradient-logo">VGB</strong>
                        </div>
                    </div>
                </div>
                <div style="font-size: 0.8rem; opacity: 0.7; display: flex; align-items: center; gap: 5px;">
                    <i class="bx bx-lock-alt"></i> End-to-end 256-bit SSL encrypted connection
                </div>
            </div>

            <!-- Right Login Form Side -->
            <div class="auth-form-side" id="loginFormContainer">
                <div style="margin-bottom: 30px;">
                    <h3 style="font-size: 1.8rem; font-weight: 700; color: var(--gray-900); margin-bottom: 10px;" id="loginTitle">Welcome Back</h3>
                    <p style="color: var(--gray-500); font-size: 0.9rem;">Please choose your portal and enter details.</p>
                </div>

                <!-- Tabs -->
                <div class="portal-tabs-container" id="portalTabs">
                    <button type="button" class="portal-tab-btn active" onclick="switchPortal('customer')" id="customerTab">
                        <i class="bx bx-user"></i> Customer
                    </button>
                    <button type="button" class="portal-tab-btn" onclick="switchPortal('admin')" id="adminTab">
                        <i class="bx bx-shield-quarter"></i> Admin
                    </button>
                </div>

                <!-- Secondary Toggle: Password vs. PIN -->
                <div class="portal-tabs-container" style="margin-top: -10px; margin-bottom: 25px; gap: 10px; background: rgba(99, 102, 241, 0.04); padding: 5px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.08);" id="loginModeToggle">
                    <button type="button" class="portal-tab-btn active" onclick="switchLoginMode('password')" id="passwordModeTab" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                        <i class="bx bx-key"></i> Password Login
                    </button>
                    <button type="button" class="portal-tab-btn" onclick="switchLoginMode('pin')" id="pinModeTab" style="padding: 8px 15px; font-size: 0.8rem; border-radius: var(--radius-sm);">
                        <i class="bx bx-dialpad"></i> PIN Login
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
                    <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                        <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                        <span>${success}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" id="actualLoginForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="userType" id="userTypeInput" value="customer">
                    <input type="hidden" name="loginMode" id="loginModeInput" value="password">

                    <div class="form-group" style="margin-bottom: 20px; position: relative;">
                        <label for="username" style="display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 8px;">Username / Customer ID</label>
                        <div style="position: relative;">
                            <i class="bx bx-user" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="text" id="username" name="username" required placeholder="Enter username" style="width: 100%; padding: 12px 15px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                        </div>
                    </div>

                    <!-- Password Field Group -->
                    <div class="form-group" id="passwordFieldGroup" style="margin-bottom: 25px; position: relative;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <label for="password" style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 0;">Password</label>
                            <div id="passwordLinksContainer" style="display: flex; gap: 8px; font-size: 0.8rem; align-items: center;">
                                <a href="${pageContext.request.contextPath}/forgot-password?type=password" id="forgotPasswordLink" style="color: var(--primary-500); font-weight: 600; transition: color var(--transition-fast);">Forgot Password?</a>
                                <span id="forgotDivider" style="color: var(--gray-300);">|</span>
                                <a href="${pageContext.request.contextPath}/forgot-password?type=username" id="forgotUsernameLink" style="color: var(--primary-500); font-weight: 600; transition: color var(--transition-fast);">Forgot Username?</a>
                            </div>
                        </div>
                        <div style="position: relative;">
                            <i class="bx bx-lock-alt" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray-400); font-size: 1.1rem;"></i>
                            <input type="password" id="password" name="password" required placeholder="Enter password" style="width: 100%; padding: 12px 45px 12px 42px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); background: white; color: var(--gray-800); outline: none; font-size: 0.95rem; transition: border var(--transition-fast);">
                            <button type="button" onclick="togglePasswordVisibility('password', 'passwordEyeIcon')" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; outline: none; transition: color var(--transition-fast);">
                                <i class="bx bx-show" id="passwordEyeIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- PIN Field Group (Box Format) -->
                    <div class="form-group" id="pinFieldGroup" style="margin-bottom: 25px; display: none;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                            <label style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700); margin-bottom: 0;">4-Digit Transaction PIN</label>
                            <div style="display: flex; gap: 8px; align-items: center; font-size: 0.8rem;">
                                <a href="${pageContext.request.contextPath}/forgot-password?type=pin" id="forgotPinLink" style="color: var(--primary-500); font-weight: 600; transition: color var(--transition-fast);">Forgot PIN?</a>
                                <span style="color: var(--gray-300);">|</span>
                                <button type="button" onclick="togglePinBoxesVisibility()" style="background: none; border: none; color: var(--gray-400); cursor: pointer; padding: 0; display: flex; align-items: center; font-size: 0.8rem; outline: none; gap: 4px; font-weight: 600;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'">
                                    <i class="bx bx-show" id="pinBoxEyeIcon"></i> <span style="font-size: 0.75rem;">Show PIN</span>
                                </button>
                            </div>
                        </div>
                        <div style="display: flex; gap: 15px; justify-content: center; margin-top: 15px;" id="pinBoxContainer">
                            <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1" class="pin-box" oninput="moveToNext(this, 'pin2')" onkeydown="moveToPrev(event, this, null)" id="pin1" style="width: 55px; height: 55px; text-align: center; font-size: 1.5rem; font-weight: 700; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; transition: all 0.3s; box-shadow: var(--shadow-sm); color: var(--gray-800);">
                            <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1" class="pin-box" oninput="moveToNext(this, 'pin3')" onkeydown="moveToPrev(event, this, 'pin1')" id="pin2" style="width: 55px; height: 55px; text-align: center; font-size: 1.5rem; font-weight: 700; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; transition: all 0.3s; box-shadow: var(--shadow-sm); color: var(--gray-800);">
                            <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1" class="pin-box" oninput="moveToNext(this, 'pin4')" onkeydown="moveToPrev(event, this, 'pin2')" id="pin3" style="width: 55px; height: 55px; text-align: center; font-size: 1.5rem; font-weight: 700; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; transition: all 0.3s; box-shadow: var(--shadow-sm); color: var(--gray-800);">
                            <input type="password" pattern="[0-9]*" inputmode="numeric" maxlength="1" class="pin-box" oninput="moveToNext(this, null)" onkeydown="moveToPrev(event, this, 'pin3')" id="pin4" style="width: 55px; height: 55px; text-align: center; font-size: 1.5rem; font-weight: 700; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; background: white; transition: all 0.3s; box-shadow: var(--shadow-sm); color: var(--gray-800);">
                        </div>
                        <input type="hidden" id="pin" name="pin">
                    </div>

                    <button type="submit" class="btn btn-primary btn-submit" style="margin-bottom: 0;">
                        <span>Verify &amp; Continue</span>
                        <i class="bx bx-right-arrow-alt"></i>
                    </button>
                </form>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0;">
        <div class="container" style="text-align: center;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Secured &amp; Regulated under RBI Guidelines.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function switchPortal(role) {
            const customerTab = document.getElementById('customerTab');
            const adminTab = document.getElementById('adminTab');
            const userTypeInput = document.getElementById('userTypeInput');
            const loginTitle = document.getElementById('loginTitle');
            
            const forgotPasswordLink = document.getElementById('forgotPasswordLink');
            const forgotUsernameLink = document.getElementById('forgotUsernameLink');
            const forgotDivider = document.getElementById('forgotDivider');
            const forgotPinLink = document.getElementById('forgotPinLink');
            
            // Default to Password mode when switching portals
            switchLoginMode('password');

            if (role === 'admin') {
                adminTab.classList.add('active');
                customerTab.classList.remove('active');

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
            
            const passwordInput = document.getElementById('password');
            const pinInput = document.getElementById('pin');

            // Clear any PIN boxes on mode switch
            clearPinBoxes();

            if (mode === 'pin') {
                pinTab.classList.add('active');
                passwordTab.classList.remove('active');
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
            // Force numeric character check
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
