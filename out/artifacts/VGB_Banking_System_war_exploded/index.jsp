<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vertex Galaxy Bank | Secure Digital Banking</title>
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

    <header class="header">
        <a href="#home" class="logo" aria-label="Vertex Galaxy Bank home">
            <span class="logo-text">V</span>
            <span class="logo-text">G</span>
            <span class="logo-text">B</span>
        </a>

        <nav class="navbar" aria-label="Main navigation">
            <a href="#home" class="active"><i class="bx bx-home"></i> Home</a>
            <a href="#about"><i class="bx bx-info-circle"></i> About</a>
            <a href="#services"><i class="bx bx-grid-alt"></i> Services</a>
            <a href="#login"><i class="bx bx-log-in-circle"></i> Login</a>
        </nav>

        <div class="nav-actions">
            <button class="theme-toggle" id="themeToggle" type="button" aria-label="Toggle theme">
                <i class="bx bx-moon"></i>
            </button>
            <button class="mobile-menu-btn" type="button" aria-label="Open menu">
                <i class="bx bx-menu"></i>
            </button>
        </div>
    </header>

    <main>
        <section class="home bank-hero" id="home">
            <div class="hero-bg">
                <div class="hero-particles" id="heroParticles"></div>
            </div>

            <div class="container">
                <div class="home-content">
                    <div class="hero-text">
                        <p class="greeting">
                            <i class="bx bx-shield-quarter"></i>
                            Welcome to secure banking
                        </p>
                        <h1 class="name">
                            <span class="char">V</span><span class="char">e</span><span class="char">r</span><span class="char">t</span><span class="char">e</span><span class="char">x</span>
                            <span class="char">G</span><span class="char">a</span><span class="char">l</span><span class="char">a</span><span class="char">x</span><span class="char">y</span>
                            <span class="highlight">Bank</span>
                        </h1>
                        <div class="typing-wrapper">
                            <span class="profession">Banking for <span class="typed-text"></span></span>
                        </div>
                        <p class="hero-description">
                            Manage accounts, transfer money, track statements, apply for loans, and receive important
                            notifications from one reliable digital banking platform.
                        </p>

                        <div class="hero-stats" aria-label="Bank highlights">
                            <div class="stat">
                                <span class="stat-number" data-target="24">0</span>
                                <span class="stat-label">Hour Access</span>
                            </div>
                            <div class="stat">
                                <span class="stat-number" data-target="100">0</span>
                                <span class="stat-label">Secure</span>
                            </div>
                            <div class="stat">
                                <span class="stat-number" data-target="6">0</span>
                                <span class="stat-label">Core Services</span>
                            </div>
                        </div>

                        <div class="hero-btns">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                <span>Login Now</span>
                                <i class="bx bx-right-arrow-alt"></i>
                            </a>
                        </div>
                    </div>

                    <div class="home-img bank-visual" aria-label="Digital banking overview">
                        <div class="img-wrapper bank-card-wrapper">
                            <div class="img-border"></div>
                            <div class="bank-card">
                                <div class="bank-card-top">
                                    <span>Vertex Galaxy Bank</span>
                                    <i class="bx bx-chip"></i>
                                </div>
                                <div class="bank-card-number">4589  7321  6048  2190</div>
                                <div class="bank-card-bottom">
                                    <span>Digital Account</span>
                                    <strong>VGB</strong>
                                </div>
                            </div>
                            <div class="floating-icons">
                                <span class="float-icon"><i class="bx bx-lock-alt"></i></span>
                                <span class="float-icon"><i class="bx bx-transfer"></i></span>
                                <span class="float-icon"><i class="bx bx-receipt"></i></span>
                                <span class="float-icon"><i class="bx bx-credit-card"></i></span>
                            </div>
                        </div>
                        <div class="experience-badge">
                            <span class="years">24/7</span>
                            <span class="text">Online<br>Banking</span>
                        </div>
                    </div>
                </div>
            </div>

            <a href="#about" class="scroll-indicator" aria-label="Scroll to about section">
                <span>Scroll</span>
                <span class="mouse"><span class="wheel"></span></span>
            </a>
        </section>

        <section class="about" id="about">
            <div class="section-bg">
                <span class="shape shape-1"></span>
                <span class="shape shape-2"></span>
            </div>

            <div class="container">
                <div class="section-header" data-aos="fade-up">
                    <span class="subtitle">About VGB</span>
                    <h2 class="heading">Reliable Banking, <span class="highlight">Simple Access</span></h2>
                </div>

                <div class="about-content">
                    <div class="about-img bank-about-panel" data-aos="fade-right">
                        <div class="bank-security-box">
                            <i class="bx bx-fingerprint"></i>
                            <h3>Protected Customer Access</h3>
                            <p>Role-based login, customer sessions, and secure account operations keep banking activity organized.</p>
                        </div>
                    </div>

                    <div class="about-text" data-aos="fade-left">
                        <h3>Designed for customers and bank administrators</h3>
                        <p>
                            Vertex Galaxy Bank provides a clean banking workflow for customer account management and
                            administrative review. Customers can view accounts, transfer funds, check statements, apply
                            for loans, and stay updated through notifications.
                        </p>
                        <p>
                            Administrators can monitor customer requests, review pending approvals, manage account
                            records, and support day-to-day banking operations from a dedicated dashboard.
                        </p>

                        <div class="about-info">
                            <div class="info-item">
                                <i class="bx bx-user-check"></i>
                                <span>Customer: <strong>Dashboard Access</strong></span>
                            </div>
                            <div class="info-item">
                                <i class="bx bx-shield-alt-2"></i>
                                <span>Admin: <strong>Review Control</strong></span>
                            </div>
                            <div class="info-item">
                                <i class="bx bx-wallet"></i>
                                <span>Accounts: <strong>Balance Tracking</strong></span>
                            </div>
                            <div class="info-item">
                                <i class="bx bx-file"></i>
                                <span>Records: <strong>Statements</strong></span>
                            </div>
                        </div>

                        <div class="about-btns">
                            <a href="#services" class="btn btn-primary">View Services <i class="bx bx-down-arrow-alt"></i></a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Access Portal</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="services" id="services">
            <div class="container">
                <div class="section-header" data-aos="fade-up">
                    <span class="subtitle">Services</span>
                    <h2 class="heading">Banking Features <span class="highlight">Available Online</span></h2>
                </div>

                <div class="services-grid">
                    <article class="service-card" data-aos="fade-up">
                        <div class="card-icon"><i class="bx bx-wallet-alt"></i></div>
                        <h3>Account Management</h3>
                        <p>View account details, balances, customer information, and current account status from the dashboard.</p>
                        <div class="card-tags"><span>Accounts</span><span>Balance</span></div>
                    </article>

                    <article class="service-card" data-aos="fade-up">
                        <div class="card-icon"><i class="bx bx-transfer-alt"></i></div>
                        <h3>Money Transfer</h3>
                        <p>Transfer funds through the customer portal with a structured banking transaction workflow.</p>
                        <div class="card-tags"><span>Transfer</span><span>Payments</span></div>
                    </article>

                    <article class="service-card" data-aos="fade-up">
                        <div class="card-icon"><i class="bx bx-file-find"></i></div>
                        <h3>Statements</h3>
                        <p>Check transaction history and account statements for clear financial tracking.</p>
                        <div class="card-tags"><span>History</span><span>Records</span></div>
                    </article>

                    <article class="service-card" data-aos="fade-up">
                        <div class="card-icon"><i class="bx bx-building-house"></i></div>
                        <h3>Loan Services</h3>
                        <p>Submit loan requests and allow bank staff to review pending applications from the admin area.</p>
                        <div class="card-tags"><span>Loans</span><span>Approval</span></div>
                    </article>

                    <article class="service-card" data-aos="fade-up">
                        <div class="card-icon"><i class="bx bx-bell"></i></div>
                        <h3>Notifications</h3>
                        <p>Receive account-related updates, approval notices, and important banking messages.</p>
                        <div class="card-tags"><span>Alerts</span><span>Updates</span></div>
                    </article>

                    <article class="service-card" data-aos="fade-up">
                        <div class="card-icon"><i class="bx bx-id-card"></i></div>
                        <h3>Profile</h3>
                        <p>Maintain customer profile details used for banking records and account service workflows.</p>
                        <div class="card-tags"><span>Profile</span><span>KYC</span></div>
                    </article>
                </div>
            </div>
        </section>

        <section class="contact bank-login-section" id="login">
            <div class="container">
                <div class="section-header" data-aos="fade-up">
                    <span class="subtitle">Portal Access</span>
                    <h2 class="heading">Login To <span class="highlight">Continue Banking</span></h2>
                </div>

                <div class="bank-login-grid">
                    <a href="${pageContext.request.contextPath}/login" class="bank-login-card" data-aos="fade-right">
                        <i class="bx bx-user-circle"></i>
                        <h3>Customer Login</h3>
                        <p>Access accounts, transfers, statements, loans, and notifications.</p>
                        <span>Login <i class="bx bx-right-arrow-alt"></i></span>
                    </a>

                    <a href="${pageContext.request.contextPath}/login" class="bank-login-card" data-aos="fade-up">
                        <i class="bx bx-shield-quarter"></i>
                        <h3>Admin Login</h3>
                        <p>Review customers, pending loans, account requests, and operational records.</p>
                        <span>Admin Access <i class="bx bx-right-arrow-alt"></i></span>
                    </a>


                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-logo">
                    <span>Vertex Galaxy Bank</span>
                </div>
                <div class="footer-links">
                    <a href="#home">Home</a>
                    <a href="#about">About</a>
                    <a href="#services">Services</a>
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <button class="scroll-top" id="scrollTop" type="button" aria-label="Scroll to top">
        <i class="bx bx-up-arrow-alt"></i>
    </button>

    <script src="${pageContext.request.contextPath}/assest/js/script.js?v=2.0.1"></script>
</body>

</html>
