<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Vertex Galaxy Bank | Secure Digital Banking</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
        <style>
            /* ==========================================================
               INTERACTIVE 3D FLIPPABLE CEO BUSINESS CARD
               ========================================================== */
            .bank-about-panel {
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                min-height: 320px !important;
            }
            
            .ceo-card-container {
                perspective: 1500px;
                width: 100%;
                max-width: 440px;
                height: 260px;
                margin: 0 auto;
                cursor: pointer;
                position: relative;
            }
            
            .flip-card-inner {
                position: relative;
                width: 100%;
                height: 100%;
                text-align: left;
                transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
                transform-style: preserve-3d;
            }
            
            /* Hover flip support for desktop */
            .ceo-card-container:hover .flip-card-inner {
                transform: rotateY(180deg);
            }
            .ceo-card-container:hover.clicked-flip .flip-card-inner {
                transform: rotateY(0deg);
            }
            
            /* Toggle flip on class 'flipped' */
            .ceo-card-container.flipped .flip-card-inner {
                transform: rotateY(180deg);
            }
            
            .flip-card-front,
            .flip-card-back {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                -webkit-backface-visibility: hidden;
                backface-visibility: hidden;
                border-radius: 16px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
                overflow: hidden;
            }
            
            /* === CARD FRONT SIDE === */
            .flip-card-front {
                background: #ffffff;
                color: #1e293b;
                display: flex;
                border: 1px solid rgba(0, 0, 0, 0.08);
                z-index: 2;
                transform: rotateY(0deg);
            }
            
            /* Left Half of Front (Details) */
            .ceo-card-left {
                flex: 1.3;
                padding: 24px 20px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                background: #ffffff;
            }
            
            .ceo-profile-info {
                border-bottom: 2px solid #e2e8f0;
                padding-bottom: 10px;
                margin-bottom: 10px;
                position: relative;
            }
            
            .ceo-profile-info::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 35px;
                height: 2px;
                background: #b88f14;
            }
            
            .ceo-name {
                font-size: 1.35rem;
                font-weight: 800;
                color: #0f172a;
                line-height: 1.1;
                margin-bottom: 2px;
            }
            
            .ceo-title {
                font-size: 0.75rem;
                font-weight: 600;
                color: #b88f14;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .ceo-contact-list {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            
            .ceo-contact-item {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.78rem;
                color: #475569;
            }
            
            .ceo-contact-icon {
                width: 24px;
                height: 24px;
                background: #0f172a;
                color: #ffffff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
                flex-shrink: 0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            /* Right Half of Front (Navy Angle) */
            .ceo-card-right {
                flex: 0.85;
                background: #070b16;
                color: #ffffff;
                position: relative;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 15px;
                overflow: hidden;
            }
            
            /* Angular chevron separator */
            .ceo-card-right::before {
                content: '';
                position: absolute;
                top: 0;
                left: -20px;
                width: 0;
                height: 0;
                border-top: 130px solid transparent;
                border-bottom: 130px solid transparent;
                border-right: 20px solid #070b16;
                z-index: 2;
            }
            
            .ceo-card-right::after {
                content: '';
                position: absolute;
                top: 0;
                left: -23px;
                width: 0;
                height: 0;
                border-top: 130px solid transparent;
                border-bottom: 130px solid transparent;
                border-right: 23px solid rgba(212, 175, 55, 0.95);
                z-index: 1;
            }
            
            .ceo-card-watermark {
                position: absolute;
                opacity: 0.05;
                width: 120%;
                height: auto;
                pointer-events: none;
                z-index: 0;
                top: 10%;
                right: -10%;
            }
            
            .ceo-front-logo-block {
                position: relative;
                z-index: 3;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 4px;
            }
            
            .ceo-front-logo-block .vg-orbit-logo {
                width: 36px;
                height: 36px;
            }
            
            .ceo-front-logo-block h4 {
                font-family: 'Poppins', sans-serif;
                font-size: 0.65rem;
                font-weight: 700;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                color: #ffffff;
                margin: 0;
            }
            
            .ceo-front-logo-block span {
                font-size: 0.45rem;
                letter-spacing: 1px;
                color: #f7c844;
                text-transform: uppercase;
                font-weight: 600;
                border-top: 1px solid rgba(255, 255, 255, 0.15);
                border-bottom: 1px solid rgba(255, 255, 255, 0.15);
                padding: 1px 4px;
                margin-top: 1px;
            }
            
            /* === CARD BACK SIDE === */
            .flip-card-back {
                background: #070b16;
                transform: rotateY(180deg);
                border: 1px solid rgba(212, 175, 55, 0.2);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                position: relative;
                z-index: 1;
            }
            
            .ceo-card-back-marble {
                position: absolute;
                bottom: 0;
                right: 0;
                width: 42%;
                height: 100%;
                background: #fdfdfd;
                background-image: 
                    linear-gradient(115deg, rgba(0,0,0,0.01) 23%, transparent 23%), 
                    linear-gradient(290deg, rgba(0,0,0,0.008) 4%, transparent 4%),
                    linear-gradient(115deg, rgba(0,0,0,0.008) 10%, transparent 10%);
                z-index: 1;
            }
            
            .ceo-card-back-marble::before {
                content: '';
                position: absolute;
                top: 0;
                left: -38px;
                width: 0;
                height: 0;
                border-bottom: 260px solid #fdfdfd;
                border-left: 38px solid transparent;
                z-index: 2;
            }
            
            .ceo-card-back-marble::after {
                content: '';
                position: absolute;
                top: 0;
                left: -41px;
                width: 0;
                height: 0;
                border-bottom: 260px solid rgba(212, 175, 55, 0.95);
                border-left: 41px solid transparent;
                z-index: 1;
            }
            
            .ceo-back-content {
                position: relative;
                z-index: 3;
                width: 100%;
                height: 100%;
                display: flex;
                padding: 24px;
                align-items: center;
                box-sizing: border-box;
            }
            
            .ceo-back-logo-section {
                flex: 1.2;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: flex-start;
                gap: 8px;
            }
            
            .ceo-back-logo-section .vg-orbit-logo {
                width: 64px;
                height: 64px;
            }
            
            .ceo-back-title {
                font-size: 1.2rem;
                font-weight: 800;
                letter-spacing: 0.5px;
                color: #ffffff;
                line-height: 1.1;
            }
            
            .ceo-back-sub {
                font-size: 0.65rem;
                letter-spacing: 2px;
                color: #ffe875;
                text-transform: uppercase;
                font-weight: 600;
            }
            
            .ceo-back-web {
                flex: 0.8;
                display: flex;
                justify-content: flex-end;
                align-items: flex-end;
                height: 100%;
                font-size: 0.68rem;
                font-weight: 700;
                color: #0f172a;
                letter-spacing: 0.3px;
                text-decoration: none;
                z-index: 4;
            }
            
            .ceo-back-web:hover {
                color: #b88f14;
            }
            
            body.dark-mode .flip-card-front {
                background: #ffffff !important;
                border-color: rgba(255, 255, 255, 0.08) !important;
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

        <header class="header">
            <a href="#home" class="logo" aria-label="Vertex Galaxy Bank home" style="display: flex; align-items: center;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
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
                                <span class="char">V</span><span class="char">e</span><span class="char">r</span><span
                                    class="char">t</span><span class="char">e</span><span class="char">x</span>
                                <span class="char">G</span><span class="char">a</span><span class="char">l</span><span
                                    class="char">a</span><span class="char">x</span><span class="char">y</span>
                                <span class="highlight">Bank</span>
                            </h1>
                            <div class="typing-wrapper">
                                <span class="profession">Banking for <span class="typed-text"></span></span>
                            </div>
                            <p class="hero-description">
                                Manage accounts, transfer money, track statements, apply for loans, and receive
                                important
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
                                <div class="bank-card-container">
                                    <div class="bank-card">
                                        <div class="card-glare"></div>
                                        <div class="bank-card-top">
                                            <div class="bank-card-logo-container">
                                                <svg class="vg-orbit-logo" viewBox="0 0 100 100" width="32" height="32"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <ellipse cx="50" cy="50" rx="38" ry="12" fill="none"
                                                        stroke="url(#goldGradIndex)" stroke-width="3"
                                                        transform="rotate(-30 50 50)" />
                                                    <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif"
                                                        font-size="28" font-weight="800" fill="#ffffff">V</text>
                                                    <text x="48" y="65"
                                                        font-family="'Playfair Display', 'Georgia', serif"
                                                        font-style="italic" font-size="34" font-weight="bold"
                                                        fill="url(#goldGradIndex)">G</text>
                                                    <path
                                                        d="M 80 22 L 81.5 25 L 85 26.5 L 81.5 28 L 80 31 L 78.5 28 L 75 26.5 L 78.5 25 Z"
                                                        fill="#ffe875" />
                                                    <defs>
                                                        <linearGradient id="goldGradIndex" x1="0%" y1="0%" x2="100%"
                                                            y2="100%">
                                                            <stop offset="0%" stop-color="#ffe875" />
                                                            <stop offset="50%" stop-color="#f7c844" />
                                                            <stop offset="100%" stop-color="#b88f14" />
                                                        </linearGradient>
                                                    </defs>
                                                </svg>
                                                <span class="bank-name-text">Vertex Galaxy Bank</span>
                                            </div>
                                            <svg class="bank-card-chip" viewBox="0 0 100 80" width="45" height="36"
                                                xmlns="http://www.w3.org/2000/svg">
                                                <rect x="5" y="5" width="90" height="70" rx="10"
                                                    fill="url(#chipGoldGradIndex)" stroke="#b59410"
                                                    stroke-width="1.5" />
                                                <path d="M 5,25 H 45 V 55 H 5" fill="none" stroke="#8c710c"
                                                    stroke-width="1.5" />
                                                <path d="M 95,25 H 55 V 55 H 95" fill="none" stroke="#8c710c"
                                                    stroke-width="1.5" />
                                                <path d="M 45,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                                <path d="M 55,5 V 75" fill="none" stroke="#8c710c" stroke-width="1.5" />
                                                <rect x="30" y="25" width="40" height="30" rx="4" fill="#8c710c"
                                                    opacity="0.3" />
                                                <defs>
                                                    <linearGradient id="chipGoldGradIndex" x1="0%" y1="0%" x2="100%"
                                                        y2="100%">
                                                        <stop offset="0%" stop-color="#ffe875" />
                                                        <stop offset="50%" stop-color="#f7c844" />
                                                        <stop offset="100%" stop-color="#b88f14" />
                                                    </linearGradient>
                                                </defs>
                                            </svg>
                                        </div>
                                        <div class="bank-card-number">4589 7321 6048 2190</div>
                                        <div class="bank-card-bottom">
                                            <span>Digital Account</span>
                                            <strong class="vgb-gradient-logo">VGB</strong>
                                        </div>
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
                            <div class="ceo-card-container" id="ceoCard">
                                <div class="flip-card-inner">
                                    <!-- FRONT SIDE -->
                                    <div class="flip-card-front">
                                        <div class="ceo-card-left">
                                            <div class="ceo-profile-info">
                                                <h3 class="ceo-name">Dani Martinez</h3>
                                                <span class="ceo-title">Chief Executive Officer</span>
                                            </div>
                                            <div class="ceo-contact-list">
                                                <div class="ceo-contact-item">
                                                    <div class="ceo-contact-icon"><i class="bx bx-phone"></i></div>
                                                    <span>+123 456 7890</span>
                                                </div>
                                                <div class="ceo-contact-item">
                                                    <div class="ceo-contact-icon"><i class="bx bx-envelope"></i></div>
                                                    <span>hello@vertexgelexybank.com</span>
                                                </div>
                                                <div class="ceo-contact-item">
                                                    <div class="ceo-contact-icon"><i class="bx bx-map"></i></div>
                                                    <span>123 Anywhere St., Any City</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ceo-card-right">
                                            <!-- Watermark Background -->
                                            <svg class="ceo-card-watermark" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                                <ellipse cx="50" cy="50" rx="38" ry="12" fill="none" stroke="rgba(212, 175, 55, 0.12)" stroke-width="3" transform="rotate(-30 50 50)"/>
                                                <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif" font-size="28" font-weight="800" fill="rgba(255, 255, 255, 0.12)">V</text>
                                                <text x="48" y="65" font-family="'Playfair Display', 'Georgia', serif" font-style="italic" font-size="34" font-weight="bold" fill="rgba(212, 175, 55, 0.12)">G</text>
                                            </svg>
                                            
                                            <div class="ceo-front-logo-block">
                                                <svg class="vg-orbit-logo" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                                    <ellipse cx="50" cy="50" rx="38" ry="12" fill="none" stroke="url(#goldGradCard)" stroke-width="3" transform="rotate(-30 50 50)"/>
                                                    <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif" font-size="28" font-weight="800" fill="#ffffff">V</text>
                                                    <text x="48" y="65" font-family="'Playfair Display', 'Georgia', serif" font-style="italic" font-size="34" font-weight="bold" fill="url(#goldGradCard)">G</text>
                                                    <path d="M 80 22 L 81.5 25 L 85 26.5 L 81.5 28 L 80 31 L 78.5 28 L 75 26.5 L 78.5 25 Z" fill="#ffe875"/>
                                                    <defs>
                                                        <linearGradient id="goldGradCard" x1="0%" y1="0%" x2="100%" y2="100%">
                                                            <stop offset="0%" stop-color="#ffe875" />
                                                            <stop offset="50%" stop-color="#f7c844" />
                                                            <stop offset="100%" stop-color="#b88f14" />
                                                        </linearGradient>
                                                    </defs>
                                                </svg>
                                                <h4>Vertex Gelexy</h4>
                                                <span>Bank</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- BACK SIDE -->
                                    <div class="flip-card-back">
                                        <div class="ceo-card-back-marble"></div>
                                        <div class="ceo-back-content">
                                            <div class="ceo-back-logo-section">
                                                <svg class="vg-orbit-logo" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                                    <ellipse cx="50" cy="50" rx="38" ry="12" fill="none" stroke="url(#goldGradCardBack)" stroke-width="3" transform="rotate(-30 50 50)"/>
                                                    <text x="28" y="58" font-family="'Cinzel', 'Georgia', serif" font-size="28" font-weight="800" fill="#ffffff">V</text>
                                                    <text x="48" y="65" font-family="'Playfair Display', 'Georgia', serif" font-style="italic" font-size="34" font-weight="bold" fill="url(#goldGradCardBack)">G</text>
                                                    <path d="M 80 22 L 81.5 25 L 85 26.5 L 81.5 28 L 80 31 L 78.5 28 L 75 26.5 L 78.5 25 Z" fill="#ffe875"/>
                                                    <defs>
                                                        <linearGradient id="goldGradCardBack" x1="0%" y1="0%" x2="100%" y2="100%">
                                                            <stop offset="0%" stop-color="#ffe875" />
                                                            <stop offset="50%" stop-color="#f7c844" />
                                                            <stop offset="100%" stop-color="#b88f14" />
                                                        </linearGradient>
                                                    </defs>
                                                </svg>
                                                <div class="ceo-back-title">Vertex Gelexy</div>
                                                <div class="ceo-back-sub">Bank</div>
                                            </div>
                                            <a href="https://www.vertexgelexybank.com" class="ceo-back-web" target="_blank" onclick="event.stopPropagation();">www.vertexgelexybank.com</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="about-text" data-aos="fade-left">
                            <h3>Designed for customers and bank administrators</h3>
                            <p>
                                Vertex Galaxy Bank provides a clean banking workflow for customer account management and
                                administrative review. Customers can view accounts, transfer funds, check statements,
                                apply
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
                                <a href="#services" class="btn btn-primary">View Services <i
                                        class="bx bx-down-arrow-alt"></i></a>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Access
                                    Portal</a>
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
                            <p>View account details, balances, customer information, and current account status from the
                                dashboard.</p>
                            <div class="card-tags"><span>Accounts</span><span>Balance</span></div>
                        </article>

                        <article class="service-card" data-aos="fade-up">
                            <div class="card-icon"><i class="bx bx-transfer-alt"></i></div>
                            <h3>Money Transfer</h3>
                            <p>Transfer funds through the customer portal with a structured banking transaction
                                workflow.</p>
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
                            <p>Submit loan requests and allow bank staff to review pending applications from the admin
                                area.</p>
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
                            <p>Maintain customer profile details used for banking records and account service workflows.
                            </p>
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
                        <a href="${pageContext.request.contextPath}/login" class="bank-login-card"
                            data-aos="fade-right">
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

        <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    </body>

    </html>