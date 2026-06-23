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
        /* Premium Extensions for Profile Layout */
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.45) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border-right: 1px solid rgba(99, 102, 241, 0.15) !important;
            padding: 30px 20px;
            position: fixed;
            top: 80px;
            bottom: 0;
            left: 0;
            z-index: 99;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--panel-shadow);
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
        .mobile-nav-toggle {
            display: none !important;
        }
        @media (max-width: 991px) {
            .sidebar { transform: translateX(-280px); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 120px 20px 20px; }
            .mobile-nav-toggle { display: flex !important; }
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 30px;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .profile-cover {
            background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%);
            height: 140px;
            border-radius: var(--radius-md);
            position: relative;
        }
        .profile-cover::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 50%);
        }
        .avatar-holder {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            background: white;
            margin-top: -50px;
            margin-left: 20px;
            position: relative;
            z-index: 10;
            transition: transform 0.3s ease;
        }
        .avatar-holder:hover {
            transform: scale(1.05);
        }
        .avatar-holder img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .tab-nav-btn {
            background: transparent;
            border: none;
            outline: none;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--gray-500);
            padding: 10px 18px;
            cursor: pointer;
            position: relative;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .tab-nav-btn.active {
            color: var(--primary-600);
        }
        .tab-nav-btn::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 3px;
            background: transparent;
            transition: all 0.25s ease;
        }
        .tab-nav-btn.active::after {
            background: linear-gradient(90deg, var(--primary-500), var(--secondary-500));
        }
        .profile-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .info-tile {
            background: white;
            border: 1px solid var(--gray-100);
            border-radius: var(--radius-md);
            padding: 15px 20px;
            transition: all 0.2s ease;
        }
        .info-tile:hover {
            border-color: rgba(99, 102, 241, 0.25);
            transform: translateY(-2px);
        }
        .control-input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            outline: none;
            font-size: 0.95rem;
            color: var(--gray-800);
            font-family: inherit;
            transition: all 0.3s ease;
        }
        .control-input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }
        .sub-card {
            background: rgba(255, 255, 255, 0.45);
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.01);
            transition: all 0.3s ease;
        }
        .sub-card:hover {
            border-color: rgba(99, 102, 241, 0.18);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.02);
            transform: translateY(-2px);
        }
        .password-strength-bar {
            height: 6px;
            border-radius: var(--radius-full);
            background: var(--gray-200);
            margin-top: 10px;
            overflow: hidden;
            position: relative;
        }
        .strength-indicator {
            height: 100%;
            width: 0;
            transition: all 0.4s ease;
        }
        .log-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            border-bottom: 1.5px solid var(--gray-100);
            transition: background 0.15s ease;
        }
        .log-row:last-child {
            border-bottom: none;
        }
        .log-row:hover {
            background: rgba(99, 102, 241, 0.02);
        }

        /* Dark Mode Color Overrides */
        body.dark-mode .sidebar {
            background: rgba(15, 23, 42, 0.45) !important;
        }
        body.dark-mode .sidebar-menu a {
            color: var(--gray-400) !important;
        }
        body.dark-mode .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.03);
            color: var(--white) !important;
        }
        body.dark-mode .sidebar-menu a.active {
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.35);
        }
        body.dark-mode .glass-card {
            background: rgba(30, 41, 59, 0.7) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
        }
        body.dark-mode .avatar-holder {
            border-color: var(--gray-800) !important;
            background: var(--gray-800) !important;
        }
        body.dark-mode .info-tile {
            background: rgba(15, 23, 42, 0.4) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
        }
        body.dark-mode .info-tile span {
            color: var(--gray-400) !important;
        }
        body.dark-mode .info-tile strong {
            color: white !important;
        }
        body.dark-mode .tab-nav-btn {
            color: var(--gray-400) !important;
        }
        body.dark-mode .tab-nav-btn.active {
            color: var(--primary-400) !important;
        }
        body.dark-mode .log-row {
            border-bottom-color: rgba(255, 255, 255, 0.05) !important;
        }
        body.dark-mode .log-row:hover {
            background: rgba(255, 255, 255, 0.02) !important;
        }
        body.dark-mode .form-group input {
            background: rgba(15, 23, 42, 0.6) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
        }
        body.dark-mode .sub-card {
            background: rgba(15, 23, 42, 0.3) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
            box-shadow: none !important;
        }
        body.dark-mode .sub-card:hover {
            border-color: rgba(255, 255, 255, 0.08) !important;
        }
        body.dark-mode .form-group label {
            color: var(--gray-300) !important;
        }
        body.dark-mode .toast-message {
            color: white !important;
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
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation"
                style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                    <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">Root Administrator</span>
                    <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                        <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                        Admin Workspace
                    </span>
                </div>
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
                <h2 style="font-size: 2.2rem; font-weight: 800; color: var(--gray-900);">Admin Portal Profile</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Review root systems details or update administrative password files.</p>
            </div>

            <!-- Toast alert -->
            <div id="toast" style="position: fixed; top: 100px; right: 40px; z-index: 1000; background: white; padding: 15px 25px; border-radius: var(--radius-md); box-shadow: var(--shadow-xl); border: 1px solid var(--gray-200); display: flex; align-items: center; gap: 10px; transform: translateY(-50px); opacity: 0; transition: all 0.4s ease;">
                <div class="toast-icon"><i class="bx bx-check-circle" style="color: #10b981; font-size: 1.5rem;"></i></div>
                <div class="toast-message" style="font-weight: 600; color: var(--gray-800);">Action executed successfully.</div>
            </div>

            <!-- Hidden Upload Form for Admin -->
            <form id="adminAvatarUploadForm" style="display: none;">
                <input type="file" id="adminAvatarFileInput" name="adminAvatarFile" accept="image/*" onchange="uploadAdminAvatarDynamically();">
            </form>

            <!-- Grid Layout -->
            <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 30px;" class="mobile-grid-1">
                <!-- Left Details Banner Block -->
                <div style="display: flex; flex-direction: column; gap: 30px;">
                    <div class="glass-card" style="padding: 0;">
                        <!-- Cover Banner -->
                        <div class="profile-cover"></div>
                        <!-- Floating Avatar -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; padding: 0 25px 25px;">
                            <div style="position: relative; display: inline-block;">
                                <div class="avatar-holder" id="adminAvatarContainer" style="cursor:  pointer;" onclick="openAdminLightbox();">
                                    <img id="adminAvatarImage" src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Admin Profile Logo">
                                </div>
                                <div onclick="document.getElementById('adminAvatarFileInput').click();" style="position: absolute; bottom: 0; right: 0; background: var(--primary-500); color: white; width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1rem; border: 2px solid white; box-shadow: var(--shadow-md); cursor: pointer; z-index: 20;" title="Click to Change Profile Picture">
                                    <i class="bx bx-camera"></i>
                                </div>
                            </div>
                            <div style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); font-size: 0.72rem; font-weight: 700; padding: 5px 12px; border-radius: var(--radius-full); text-transform: uppercase; letter-spacing: 0.5px; border: 1px solid rgba(16, 185, 129, 0.2);">
                                <i class="bx bxs-circle" style="font-size: 0.55rem; vertical-align: middle; margin-right: 4px;"></i> Active
                            </div>
                        </div>

                        <!-- User Profile Overview -->
                        <div style="padding: 0 25px 30px;">
                            <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--gray-900);">Root Administrator</h3>
                            <p style="font-size: 0.85rem; color: var(--gray-400); margin-top: 2px;">VGB System Operations</p>
                            
                            <hr style="border: none; border-top: 1px solid var(--gray-100); margin: 20px 0;">

                            <div style="display: flex; flex-direction: column; gap: 15px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span style="color: var(--gray-400);">System ID:</span>
                                    <strong style="color: var(--gray-700); font-family: monospace;">#VGB-ADM-001</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span style="color: var(--gray-400);">Linked Server:</span>
                                    <strong style="color: var(--gray-700); font-family: monospace;">IN-WEST-1C</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span style="color: var(--gray-400);">Security clearance:</span>
                                    <strong style="color: var(--primary-500);"><i class="bx bxs-lock-alt"></i> LEVEL 5</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Visual System Security Index metrics -->
                    <div class="glass-card" style="background: linear-gradient(135deg, rgba(99, 102, 241, 0.05) 0%, rgba(168, 85, 247, 0.05) 100%);">
                        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-check-shield" style="color: var(--accent-emerald);"></i> System Health Status
                        </h4>
                        <div style="font-size: 0.82rem; color: var(--gray-500); line-height: 1.5; margin-bottom: 15px;">
                            The administration console is locked and running under secure SSL. All actions are actively audited.
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.85rem; font-weight: 600; color: var(--gray-700); margin-bottom: 8px;">
                            <span>Audit Security Index</span>
                            <span style="color: var(--accent-emerald);">98% Secure</span>
                        </div>
                        <div class="password-strength-bar" style="margin-top: 0;">
                            <div class="strength-indicator" style="width: 98%; background: var(--accent-emerald);"></div>
                        </div>
                    </div>
                </div>

                <!-- Right Settings Card -->
                <div class="glass-card">
                    <!-- Tabs Navigation Bar -->
                    <div style="display: flex; gap: 15px; border-bottom: 2px solid var(--gray-200); margin-bottom: 30px; flex-wrap: wrap;">
                        <button type="button" class="tab-nav-btn active" id="btn-tab-info" onclick="switchProfileTab('info')">
                            <i class="bx bx-info-circle" style="font-size: 1.15rem;"></i> Profile Specs
                        </button>
                        <button type="button" class="tab-nav-btn" id="btn-tab-credentials" onclick="switchProfileTab('credentials')">
                            <i class="bx bx-shield-quarter" style="font-size: 1.15rem;"></i> Update Credentials
                        </button>
                        <button type="button" class="tab-nav-btn" id="btn-tab-logs" onclick="switchProfileTab('logs')">
                            <i class="bx bx-history" style="font-size: 1.15rem;"></i> Access Logs
                        </button>
                    </div>

                    <!-- Tab 1: Profile Specifications info -->
                    <div id="tab-content-info">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-shield-quarter" style="color: var(--primary-500);"></i> Administrative Profile Details
                        </h4>
                        <div class="profile-info-grid">
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Username</span>
                                <strong style="font-size: 0.95rem; color: var(--gray-800); display: block; margin-top: 5px; font-family: monospace;">vgb@admin$17193</strong>
                            </div>
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Linked Email Contact</span>
                                <strong style="font-size: 0.95rem; color: var(--gray-800); display: block; margin-top: 5px;">admin@vgb.com</strong>
                            </div>
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Security Level Role</span>
                                <strong style="font-size: 0.95rem; color: var(--primary-500); display: block; margin-top: 5px;"><i class="bx bx-badge-check" style="vertical-align: middle;"></i> Root Systems</strong>
                            </div>
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Allowed Access Port</span>
                                <strong style="font-size: 0.95rem; color: var(--gray-800); display: block; margin-top: 5px; font-family: monospace;">HTTPS (443)</strong>
                            </div>
                        </div>

                        <hr style="border: none; border-top: 1px solid var(--gray-100); margin: 30px 0;">

                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-server" style="color: var(--secondary-500);"></i> Core System Metrics
                        </h4>
                        <div class="profile-info-grid" style="margin-top: 0;">
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Database Server Connection</span>
                                <strong style="font-size: 0.95rem; color: var(--accent-emerald); display: block; margin-top: 5px;"><i class="bx bxs-cloud-upload"></i> Operational</strong>
                            </div>
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Audit Logging Driver</span>
                                <strong style="font-size: 0.95rem; color: var(--gray-800); display: block; margin-top: 5px;">Secure File System</strong>
                            </div>
                            <div class="info-tile">
                                <span style="font-size: 0.72rem; font-weight: 600; color: var(--gray-400); text-transform: uppercase;">Transaction Encryption</span>
                                <strong style="font-size: 0.95rem; color: var(--gray-800); display: block; margin-top: 5px;">AES-256 Bit</strong>
                            </div>
                        </div>
                    </div>

                    <!-- Tab 2: Security & Credentials Forms -->
                    <div id="tab-content-credentials" style="display: none;">
                        <!-- Update Password Card -->
                        <div class="sub-card">
                            <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="bx bx-key" style="color: var(--primary-500); font-size: 1.4rem; background: rgba(99, 102, 241, 0.1); padding: 8px; border-radius: 50%;"></i> Change Root Administrator Password
                            </h4>
                            <form id="passwordUpdateForm" onsubmit="submitPasswordUpdate(event)" style="display: flex; flex-direction: column; gap: 20px; max-width: 550px;">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">Old System Password</label>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="password" id="oldPasswordInput" required class="control-input" style="padding-right: 45px; font-weight: 500;">
                                        <i class="bx bx-hide" onclick="togglePasswordVisibility('oldPasswordInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.25rem; transition: color 0.2s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">New System Password</label>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="password" id="newPasswordInput" required class="control-input" style="padding-right: 45px; font-weight: 500;" oninput="updatePasswordStrengthMeter(this.value)">
                                        <i class="bx bx-hide" onclick="togglePasswordVisibility('newPasswordInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.25rem; transition: color 0.2s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                    </div>
                                    <!-- Dynamic Strength Indicator -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px; font-size: 0.75rem; font-weight: 600;">
                                        <span style="color: var(--gray-400);">Password Strength:</span>
                                        <span id="strengthText" style="color: #ef4444; font-weight: 700;">Too Short</span>
                                    </div>
                                    <div class="password-strength-bar">
                                        <div class="strength-indicator" id="strengthBar" style="background: #ef4444; width: 0%;"></div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="align-self: start; padding: 12px 28px; border-radius: var(--radius-md); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2); display: inline-flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-lock-alt" style="font-size: 1.1rem;"></i> Update Password
                                </button>
                            </form>
                        </div>

                        <!-- Update PIN Card -->
                        <div class="sub-card">
                            <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="bx bx-lock-open" style="color: var(--secondary-500); font-size: 1.4rem; background: rgba(168, 85, 247, 0.1); padding: 8px; border-radius: 50%;"></i> Change Transaction / Administrative PIN
                            </h4>
                            <form id="pinUpdateForm" onsubmit="submitPinUpdate(event)" style="display: flex; flex-direction: column; gap: 20px; max-width: 550px;">
                                <div class="form-group">
                                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--gray-600); margin-bottom: 8px;">New 4-Digit Secure PIN</label>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="password" id="newPinInput" maxlength="4" pattern="^[0-9]{4}$" required placeholder="E.g. 0000" class="control-input" style="padding-right: 45px; font-family: monospace; letter-spacing: 4px; font-weight: 700;">
                                        <i class="bx bx-hide" onclick="togglePasswordVisibility('newPinInput', this)" style="position: absolute; right: 15px; cursor: pointer; color: var(--gray-400); font-size: 1.25rem; transition: color 0.2s;" onmouseover="this.style.color='var(--primary-500)'" onmouseout="this.style.color='var(--gray-400)'"></i>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="align-self: start; padding: 12px 28px; border-radius: var(--radius-md); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2); display: inline-flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-shield" style="font-size: 1.1rem;"></i> Update PIN
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Tab 3: Mock Audit Logs of Admin actions -->
                    <div id="tab-content-logs" style="display: none;">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-history" style="color: var(--primary-500);"></i> Admin Activity & Security Log Ledger
                        </h4>
                        <p style="color: var(--gray-400); font-size: 0.82rem; margin-bottom: 20px;">Review recent administrative check-points executed by the root console.</p>
                        
                        <div style="border: 1.5px solid var(--gray-100); border-radius: var(--radius-md); overflow: hidden;">
                            <div class="log-row">
                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                    <strong style="font-size: 0.85rem; color: var(--gray-800);">Root Administrator Logged In</strong>
                                    <span style="font-size: 0.72rem; color: var(--gray-400); font-family: monospace;">Host: 192.168.1.100 - Web Access</span>
                                </div>
                                <div style="text-align: right; display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                    <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 2px 8px; border-radius: var(--radius-sm); font-size: 0.65rem; font-weight: 700; text-transform: uppercase;">SUCCESS</span>
                                    <span style="font-size: 0.7rem; color: var(--gray-400);">Today, 07:15 PM</span>
                                </div>
                            </div>
                            <div class="log-row">
                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                    <strong style="font-size: 0.85rem; color: var(--gray-800);">Database Table Optimization Executed</strong>
                                    <span style="font-size: 0.72rem; color: var(--gray-400); font-family: monospace;">Host: Localhost - System Daemon</span>
                                </div>
                                <div style="text-align: right; display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                    <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 2px 8px; border-radius: var(--radius-sm); font-size: 0.65rem; font-weight: 700; text-transform: uppercase;">SUCCESS</span>
                                    <span style="font-size: 0.7rem; color: var(--gray-400);">Today, 03:22 AM</span>
                                </div>
                            </div>
                            <div class="log-row">
                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                    <strong style="font-size: 0.85rem; color: var(--gray-800);">Loan Interest Specifications Modifed</strong>
                                    <span style="font-size: 0.72rem; color: var(--gray-400); font-family: monospace;">Host: 192.168.1.100 - Console Session</span>
                                </div>
                                <div style="text-align: right; display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                    <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 2px 8px; border-radius: var(--radius-sm); font-size: 0.65rem; font-weight: 700; text-transform: uppercase;">UPDATED</span>
                                    <span style="font-size: 0.7rem; color: var(--gray-400);">Yesterday, 02:40 PM</span>
                                </div>
                            </div>
                            <div class="log-row">
                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                    <strong style="font-size: 0.85rem; color: var(--gray-800);">Unauthenticated Request Signature Blocked</strong>
                                    <span style="font-size: 0.72rem; color: var(--gray-400); font-family: monospace;">Host: 45.122.9.22 - Port Scan</span>
                                </div>
                                <div style="text-align: right; display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                    <span style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 2px 8px; border-radius: var(--radius-sm); font-size: 0.65rem; font-weight: 700; text-transform: uppercase;">BLOCKED</span>
                                    <span style="font-size: 0.7rem; color: var(--gray-400);">June 18, 11:09 AM</span>
                                </div>
                            </div>
                        </div>
                    </div>
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
        // Tab switching controller
        function switchProfileTab(tabId) {
            // Remove active status on tab buttons
            document.querySelectorAll('.tab-nav-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            // Hide all tab contents
            document.getElementById('tab-content-info').style.display = 'none';
            document.getElementById('tab-content-credentials').style.display = 'none';
            document.getElementById('tab-content-logs').style.display = 'none';

            // Activate chosen tab button
            document.getElementById('btn-tab-' + tabId).classList.add('active');
            // Show chosen tab content
            document.getElementById('tab-content-' + tabId).style.display = 'block';
        }

        // Live Password Strength Checker Logic
        function updatePasswordStrengthMeter(password) {
            const bar = document.getElementById('strengthBar');
            const text = document.getElementById('strengthText');
            
            if (password.length === 0) {
                bar.style.width = '0%';
                text.innerText = 'Too Short';
                text.style.color = '#ef4444';
                return;
            }

            let score = 0;
            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;

            switch (score) {
                case 0:
                case 1:
                    bar.style.width = '25%';
                    bar.style.background = '#ef4444';
                    text.innerText = 'Weak Password';
                    text.style.color = '#ef4444';
                    break;
                case 2:
                    bar.style.width = '50%';
                    bar.style.background = '#f59e0b';
                    text.innerText = 'Medium Password';
                    text.style.color = '#f59e0b';
                    break;
                case 3:
                    bar.style.width = '75%';
                    bar.style.background = '#3b82f6';
                    text.innerText = 'Good Password';
                    text.style.color = '#3b82f6';
                    break;
                case 4:
                    bar.style.width = '100%';
                    bar.style.background = '#10b981';
                    text.innerText = 'Strong Secure Password';
                    text.style.color = '#10b981';
                    break;
            }
        }

        // Response Toast Alerts Display
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

        // Submitting Password Update Request (Preserved Backend Integration)
        function submitPasswordUpdate(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            if (btn) {
                btn.classList.add('btn-loading');
                btn.disabled = true;
                btn.setAttribute('data-orig-html', btn.innerHTML);
                btn.innerHTML = '<span>Updating...</span>';
            }
            
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
                if (btn) {
                    btn.classList.remove('btn-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(data.message || 'Password changed successfully!', true);
                document.getElementById('passwordUpdateForm').reset();
                updatePasswordStrengthMeter('');
            })
            .catch(error => {
                if (btn) {
                    btn.classList.remove('btn-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(error.message, false);
            });
        }

        // Submitting PIN Update Request (Preserved Backend Integration)
        function submitPinUpdate(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            if (btn) {
                btn.classList.add('btn-loading');
                btn.disabled = true;
                btn.setAttribute('data-orig-html', btn.innerHTML);
                btn.innerHTML = '<span>Updating...</span>';
            }
            
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
                if (btn) {
                    btn.classList.remove('btn-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(data.message || 'Transaction PIN updated successfully!', true);
                document.getElementById('pinUpdateForm').reset();
            })
            .catch(error => {
                if (btn) {
                    btn.classList.remove('btn-loading');
                    btn.disabled = false;
                    btn.innerHTML = btn.getAttribute('data-orig-html');
                }
                showResponseToast(error.message, false);
            });
        }

        // Input Password Toggle Visibility Handler
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

        // Handle Theme Selector sync & Nav toggles on page load
        document.addEventListener("DOMContentLoaded", function () {
            // Load saved admin avatar
            const savedAvatar = localStorage.getItem('admin_avatar');
            if (savedAvatar) {
                const headerAvatar = document.getElementById('adminHeaderAvatar');
                const adminAvatar = document.getElementById('adminAvatarImage');
                if (headerAvatar) headerAvatar.src = savedAvatar;
                if (adminAvatar) adminAvatar.src = savedAvatar;
            }

            // Mobile Menu Toggle
            const mobileToggle = document.getElementById('mobileNavToggle');
            const sidebar = document.querySelector('.sidebar');
            if (mobileToggle && sidebar) {
                mobileToggle.addEventListener('click', (e) => {
                    e.stopPropagation();
                    sidebar.classList.toggle('active');
                    const icon = mobileToggle.querySelector('i');
                    if (icon) {
                        icon.className = sidebar.classList.contains('active') ? 'bx bx-x' : 'bx bx-menu';
                    }
                });

                document.addEventListener('click', (e) => {
                    if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                        sidebar.classList.remove('active');
                        const icon = mobileToggle.querySelector('i');
                        if (icon) icon.className = 'bx bx-menu';
                    }
                });
            }



            // Cursor glow glow position tracking
            const glow = document.querySelector('.cursor-glow');
            if (glow) {
                window.addEventListener('mousemove', (e) => {
                    const { clientX, clientY } = e;
                    requestAnimationFrame(() => {
                        glow.style.left = clientX + 'px';
                        glow.style.top = clientY + 'px';
                    });
                });
            }
        });

        /* --- Admin Avatar Upload & Lightbox Methods --- */
        function openAdminLightbox() {
            const adminAvatar = document.getElementById('adminAvatarImage');
            if (!adminAvatar || adminAvatar.src.includes('logo.png')) {
                // If there's no custom avatar path, ignore preview request
                return;
            }
            const lightbox = document.getElementById('imageLightbox');
            const lightboxImg = document.getElementById('lightboxImg');
            const wrapper = document.getElementById('lightboxImageWrapper');
            
            lightboxImg.src = adminAvatar.src;
            lightbox.style.display = 'flex';
            
            // Wait for display rendering then trigger entry animations
            setTimeout(() => {
                lightbox.style.opacity = '1';
                wrapper.style.transform = 'scale(1)';
            }, 15);
        }

        function closeAdminLightbox(e) {
            if (e) {
                e.stopPropagation();
            }
            const lightbox = document.getElementById('imageLightbox');
            const wrapper = document.getElementById('lightboxImageWrapper');
            
            lightbox.style.opacity = '0';
            wrapper.style.transform = 'scale(0.9)';
            
            setTimeout(() => {
                lightbox.style.display = 'none';
            }, 300);
        }

        function uploadAdminAvatarDynamically() {
            const fileInput = document.getElementById('adminAvatarFileInput');
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
            showResponseToast('Updating profile picture...', true);
            
            const reader = new FileReader();
            reader.onload = function(e) {
                const base64String = e.target.result;
                try {
                    localStorage.setItem('admin_avatar', base64String);
                    
                    // Update avatar elements dynamically
                    const adminAvatar = document.getElementById('adminAvatarImage');
                    const headerAvatar = document.getElementById('adminHeaderAvatar');
                    if (adminAvatar) adminAvatar.src = base64String;
                    if (headerAvatar) headerAvatar.src = base64String;
                    
                    fileInput.value = '';
                    showResponseToast('Profile picture updated successfully!', true);
                } catch (err) {
                    showResponseToast('Failed to save profile picture: File might be too large.', false);
                    fileInput.value = '';
                }
            };
            reader.onerror = function() {
                showResponseToast('Error reading image file.', false);
                fileInput.value = '';
            };
            reader.readAsDataURL(file);
        }
    </script>

    <!-- Full-screen image lightbox -->
    <div id="imageLightbox" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.85); backdrop-filter: blur(15px); z-index: 9999; align-items: center; justify-content: center; opacity: 0; transition: opacity 0.3s ease;" onclick="closeAdminLightbox()">
        <div id="lightboxImageWrapper" style="position: relative; transform: scale(0.9); transition: transform 0.3s ease; max-width: 90%; max-height: 90%;">
            <img id="lightboxImg" src="" alt="Enlarged Avatar" style="max-width: 450px; max-height: 450px; border-radius: 50%; border: 6px solid rgba(255,255,255,0.25); box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); object-fit: cover; display: block;">
            <button style="position: absolute; top: -45px; right: -45px; background: none; border: none; color: white; font-size: 2.2rem; cursor: pointer; transition: transform 0.2s;" onclick="closeAdminLightbox(event)">
                <i class="bx bx-x"></i>
            </button>
        </div>
    </div>
</body>
</html>
