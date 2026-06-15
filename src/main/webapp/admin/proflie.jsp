<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Admin Profile Settings</title>
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
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center;">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
        </a>
        <div class="nav-actions">
            <div style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary-500);">
                <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
            </div>
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
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp" class="active"><i class="bx bx-user"></i> My Profile</a>

        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Admin Credentials Settings</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Review root systems details or update administrative password files.</p>
            </div>

            <!-- Toast alert -->
            <div id="toast" style="position: fixed; top: 100px; right: 40px; z-index: 1000; background: white; padding: 15px 25px; border-radius: var(--radius-md); box-shadow: var(--shadow-xl); border: 1px solid var(--gray-200); display: flex; align-items: center; gap: 10px; transform: translateY(-50px); opacity: 0; transition: all 0.4s ease;">
                <div class="toast-icon"><i class="bx bx-check-circle" style="color: #10b981; font-size: 1.5rem;"></i></div>
                <div class="toast-message" style="font-weight: 600; color: var(--gray-800);">Action executed successfully.</div>
            </div>

            <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px;" class="mobile-grid-1">
                <!-- Credentials Info & PIN Card -->
                <div>
                    <div class="glass-card">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-shield-quarter"></i> Root Systems Profile Specs</h3>
                        <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 25px;">
                            <div style="width: 75px; height: 75px; border-radius: 50%; border: 3px solid var(--primary-500); overflow: hidden; box-shadow: var(--shadow-md); flex-shrink: 0;">
                                <img src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Logo" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                            <div>
                                <h4 style="font-size: 1.15rem; font-weight: 700; color: var(--gray-800);">Root Administrator</h4>
                                <p style="font-size: 0.8rem; color: var(--gray-400);">System Security Operations</p>
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr; gap: 20px;">
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Username</span>
                                <strong style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 5px; font-family: monospace;">vgb@admin$17193</strong>
                            </div>
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Linked Email Contact</span>
                                <strong style="font-size: 1.1rem; color: var(--gray-800); display: block; margin-top: 5px;">admin@vgb.com</strong>
                            </div>
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Security Level Role</span>
                                <strong style="font-size: 1.1rem; color: var(--primary-500); display: block; margin-top: 5px;"><i class="bx bx-badge-check"></i> ROOT SYSTEM ADMINISTRATOR</strong>
                            </div>
                        </div>
                    </div>

                    <!-- Update PIN Card -->
                    <div class="glass-card" style="margin-top: 30px;">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-lock-open"></i> Update Administrative PIN</h3>
                        <form id="pinUpdateForm" onsubmit="submitPinUpdate(event)" style="display: flex; flex-direction: column; gap: 15px;">
                            <div class="form-group">
                                <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">New 4-Digit PIN</label>
                                <div style="position: relative; display: flex; align-items: center;">
                                    <input type="password" id="newPinInput" maxlength="4" pattern="^[0-9]{4}$" required placeholder="E.g. 0000" style="width: 100%; padding: 10px 40px 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none; font-family: monospace;">
                                    <i class="bx bx-hide" onclick="togglePasswordVisibility('newPinInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary" style="align-self: start;">Update PIN</button>
                        </form>
                    </div>
                </div>
 
                <!-- Update Password -->
                <div class="glass-card" style="align-self: start;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;"><i class="bx bx-key"></i> Update Root Password</h3>
                    <form id="passwordUpdateForm" onsubmit="submitPasswordUpdate(event)" style="display: flex; flex-direction: column; gap: 15px;">
                        <div class="form-group">
                            <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">Old System Password</label>
                            <div style="position: relative; display: flex; align-items: center;">
                                <input type="password" id="oldPasswordInput" required style="width: 100%; padding: 10px 40px 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                <i class="bx bx-hide" onclick="togglePasswordVisibility('oldPasswordInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                            </div>
                        </div>
                        <div class="form-group">
                            <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--gray-500); margin-bottom: 5px;">New System Password</label>
                            <div style="position: relative; display: flex; align-items: center;">
                                <input type="password" id="newPasswordInput" required style="width: 100%; padding: 10px 40px 10px 15px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); outline: none;">
                                <i class="bx bx-hide" onclick="togglePasswordVisibility('newPasswordInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.2rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary" style="align-self: start;">Update Password</button>
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
    </script>
</body>
</html>
