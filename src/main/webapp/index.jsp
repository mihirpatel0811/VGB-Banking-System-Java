<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vertex Galaxy Bank | Next-Gen Digital Banking Platform</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">

    <!-- Premium Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Boxicons & Core Stylesheet -->
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=3.0" rel="stylesheet">

    <!-- Fast Theme Initialization Script (Zero-Flicker) -->
    <script>
        (function () {
            const savedTheme = localStorage.getItem('vgb_theme') || localStorage.getItem('theme');
            if (savedTheme === 'dark') {
                document.documentElement.classList.add('dark-mode');
                document.documentElement.setAttribute('data-theme', 'dark');
            } else {
                document.documentElement.classList.remove('dark-mode');
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

    <style>
        /* --- DESIGN SYSTEM TOKENS & OVERRIDES --- */
        :root {
            --font-display: 'Outfit', sans-serif;
            --font-body: 'Poppins', sans-serif;
            --accent-gold: linear-gradient(135deg, #ffe875 0%, #f7c844 50%, #b88f14 100%);
            --glass-bg: rgba(255, 255, 255, 0.78);
            --glass-bg-hover: rgba(255, 255, 255, 0.9);
            --glass-border: rgba(99, 102, 241, 0.14);
            --card-glow: rgba(99, 102, 241, 0.08);
            --bg-canvas: #f8fafc;
            --text-heading: #0f172a;
            --text-muted: #475569;
            --primary-glow: rgba(99, 102, 241, 0.35);
        }

        html[data-theme="dark"],
        body.dark-mode {
            --glass-bg: rgba(15, 23, 42, 0.82);
            --glass-bg-hover: rgba(30, 41, 59, 0.92);
            --glass-border: rgba(255, 255, 255, 0.12);
            --card-glow: rgba(99, 102, 241, 0.18);
            --bg-canvas: #090d16;
            --text-heading: #f8fafc;
            --text-muted: #cbd5e1;
            --primary-glow: rgba(99, 102, 241, 0.45);
        }

        body {
            font-family: var(--font-body);
            overflow-x: hidden;
            background-color: var(--bg-canvas) !important;
            color: var(--text-muted) !important;
            transition: background-color 0.4s ease, color 0.4s ease;
        }

        h1, h2, h3, h4, h5, .display-font {
            font-family: var(--font-display);
        }

        /* --- STICKY GLASSMORPHIC HEADER --- */
        .header {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border-bottom: 1px solid var(--glass-border) !important;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.03);
            padding: 14px 40px;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-sizing: border-box;
        }

        .header.scrolled {
            padding: 10px 40px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            background: var(--glass-bg-hover) !important;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            flex-shrink: 0;
        }

        .logo img {
            height: 44px !important;
            width: auto !important;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .logo:hover img {
            transform: scale(1.08) rotate(-4deg);
        }

        .logo-brand-text {
            font-family: var(--font-display) !important;
            font-weight: 800 !important;
            font-size: 1.35rem !important;
            color: var(--gray-900) !important;
            letter-spacing: -0.5px !important;
            display: flex !important;
            gap: 6px !important;
            align-items: center !important;
        }

        .logo-brand-text span {
            background: var(--gradient-primary) !important;
            -webkit-background-clip: text !important;
            background-clip: text !important;
            -webkit-text-fill-color: transparent !important;
        }

        .navbar {
            display: flex;
            align-items: center;
            gap: 4px;
            background: rgba(99, 102, 241, 0.05);
            padding: 5px 8px;
            border-radius: var(--radius-full);
            border: 1px solid var(--glass-border);
        }

        .navbar a {
            font-weight: 600;
            font-size: 0.88rem;
            color: var(--gray-600) !important;
            padding: 8px 16px;
            border-radius: var(--radius-full);
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            position: relative;
            white-space: nowrap;
            border: 1px solid transparent;
        }

        .navbar a i {
            font-size: 1.1rem;
            transition: transform 0.2s ease;
        }

        .navbar a:hover {
            color: var(--primary-600) !important;
            background: rgba(99, 102, 241, 0.1);
            transform: translateY(-1px);
        }

        .navbar a:hover i {
            transform: scale(1.15);
        }

        .navbar a.active {
            color: #ffffff !important;
            background: var(--gradient-primary) !important;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
            font-weight: 700;
        }

        .nav-right-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-shrink: 0;
        }

        .theme-toggle-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(99, 102, 241, 0.08);
                border: 1.5px solid var(--glass-border);
            color: var(--primary-600);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .theme-toggle-btn:hover {
            transform: scale(1.1) rotate(15deg);
            background: rgba(99, 102, 241, 0.18);
        }

        .header-portal-btn {
            background: var(--gradient-primary) !important;
            color: white !important;
            font-weight: 600;
            font-size: 0.88rem;
            padding: 10px 22px;
            border-radius: var(--radius-full);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 18px rgba(99, 102, 241, 0.35);
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .header-portal-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(99, 102, 241, 0.5);
        }

        @media (max-width: 1120px) {
            .header { padding: 12px 20px; }
            .navbar { display: none; }
            .navbar.active {
                display: flex;
                flex-direction: column;
                position: absolute;
                top: 100%;
                left: 0;
                width: 100%;
                background: var(--glass-bg-hover);
                backdrop-filter: blur(25px);
                -webkit-backdrop-filter: blur(25px);
                padding: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
                gap: 10px;
                align-items: flex-start;
            }
            .navbar.active a { width: 100%; padding: 10px 16px; }
            .mobile-menu-btn {
                display: inline-flex !important;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                border-radius: 12px;
                background: rgba(99, 102, 241, 0.08);
                border: 1px solid var(--glass-border);
                color: var(--primary-600);
                font-size: 1.5rem;
                cursor: pointer;
            }
        }

        /* --- AMBIENT GLOW BLOBS --- */
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
            filter: blur(140px);
            opacity: 0.22;
            animation: blobFloat 16s infinite alternate ease-in-out;
        }

        .glow-blob-1 {
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, var(--primary-500) 0%, transparent 70%);
            top: -150px;
            right: -80px;
        }

        .glow-blob-2 {
            width: 580px;
            height: 580px;
            background: radial-gradient(circle, var(--secondary-500) 0%, transparent 70%);
            bottom: -100px;
            left: -100px;
            animation-delay: -6s;
        }

        .glow-blob-3 {
            width: 450px;
            height: 450px;
            background: radial-gradient(circle, var(--accent-cyan) 0%, transparent 70%);
            top: 40%;
            left: 30%;
            animation-delay: -10s;
        }

        @keyframes blobFloat {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(45px, -70px) scale(1.15); }
            100% { transform: translate(-30px, 30px) scale(0.92); }
        }

        /* --- HERO SECTION --- */
        .bank-hero {
            position: relative;
            padding: 165px 0 90px;
            z-index: 2;
        }

        .hero-badge {
            background: rgba(99, 102, 241, 0.08);
            border: 1px solid rgba(99, 102, 241, 0.2);
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.82rem;
            color: var(--primary-600);
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 25px;
            font-weight: 600;
            letter-spacing: 0.6px;
            text-transform: uppercase;
        }

        .pulse-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            background-color: var(--accent-emerald);
            box-shadow: 0 0 12px var(--accent-emerald);
            animation: pulseGlow 1.8s infinite;
        }

        @keyframes pulseGlow {
            0%, 100% { transform: scale(0.9); opacity: 0.8; }
            50% { transform: scale(1.35); opacity: 1; }
        }

        .hero-text .name {
            font-size: 3.8rem;
            font-weight: 900;
            letter-spacing: -1.8px;
            margin-bottom: 18px;
            line-height: 1.05;
            color: var(--gray-900) !important;
        }

        .hero-text .highlight {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .typing-wrapper {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--gray-800) !important;
            margin-bottom: 25px;
            font-family: var(--font-display);
            min-height: 42px;
        }

        .typed-text {
            color: var(--primary-600);
            border-right: 3px solid var(--primary-600);
            padding-right: 6px;
            animation: caretBlink 0.8s step-end infinite;
        }

        @keyframes caretBlink {
            from, to { border-color: transparent; }
            50% { border-color: var(--primary-600); }
        }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin: 32px 0;
            padding: 22px 26px;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-xl);
            box-shadow: 0 12px 35px var(--card-glow);
        }

        .hero-stats .stat {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
        }

        .hero-stats .stat:not(:last-child)::after {
            content: '';
            position: absolute;
            right: -8px;
            top: 20%;
            height: 60%;
            width: 1px;
            background: var(--glass-border);
        }

        .hero-stats .stat-number {
            font-size: 2rem;
            font-weight: 800;
            font-family: var(--font-display);
            background: linear-gradient(135deg, var(--gray-900) 0%, var(--primary-600) 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 2px;
        }

        .hero-stats .stat-label {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--gray-600);
            font-weight: 600;
        }

        /* --- 3D BANK CARD VISUALIZER --- */
        .bank-card-container {
            perspective: 2000px;
            position: relative;
            display: flex;
            justify-content: center;
        }

        .bank-card {
            width: 100%;
            max-width: 440px;
            height: 270px;
            border-radius: 24px;
            box-shadow: 0 30px 65px rgba(0, 0, 0, 0.22), inset 0 1px 2px rgba(255, 255, 255, 0.3);
            position: relative;
            overflow: hidden;
            transform-style: preserve-3d;
            transform: rotateX(12deg) rotateY(-12deg);
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1), box-shadow 0.3s ease;
            cursor: pointer;
        }

        .bank-card:hover {
            transform: rotateX(6deg) rotateY(-4deg) translateY(-8px) scale(1.03);
            box-shadow: 0 45px 90px rgba(99, 102, 241, 0.3), inset 0 1px 2px rgba(255, 255, 255, 0.4);
        }

        .floating-icons .float-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--glass-bg);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            position: absolute;
            z-index: 6;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.1);
            animation: floatUpDown 6s ease-in-out infinite;
        }

        .floating-icons .float-icon:nth-child(1) { top: -22px; left: 10px; animation-delay: 0s; color: var(--primary-600); }
        .floating-icons .float-icon:nth-child(2) { top: 60px; right: -22px; animation-delay: -1.5s; color: var(--secondary-600); }
        .floating-icons .float-icon:nth-child(3) { bottom: -22px; left: 60px; animation-delay: -3s; color: var(--accent-cyan); }
        .floating-icons .float-icon:nth-child(4) { bottom: 70px; left: -25px; animation-delay: -4.5s; color: var(--accent-emerald); }

        @keyframes floatUpDown {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-16px) rotate(8deg); }
        }

        .experience-badge {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1.5px solid var(--glass-border) !important;
            border-radius: var(--radius-lg);
            padding: 16px 24px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.09);
            position: absolute;
            bottom: -28px;
            right: 15px;
            z-index: 7;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .experience-badge .years {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            font-family: var(--font-display);
            font-weight: 900;
            font-size: 2.1rem;
            line-height: 1;
        }

        .experience-badge .text {
            font-size: 0.76rem;
            font-weight: 600;
            color: var(--gray-600);
            line-height: 1.3;
        }

        /* --- LIVE MARKET RATES TICKER BAR --- */
        .market-ticker-section {
            background: var(--glass-bg);
            border-top: 1px solid var(--glass-border);
            border-bottom: 1px solid var(--glass-border);
            padding: 14px 0;
            position: relative;
            z-index: 3;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
        }

        .ticker-wrapper {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            overflow: hidden;
        }

        .ticker-label {
            font-size: 0.8rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--primary-600);
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .ticker-items {
            display: flex;
            align-items: center;
            gap: 30px;
            overflow-x: auto;
            scrollbar-width: none;
            padding: 4px 0;
        }
        .ticker-items::-webkit-scrollbar { display: none; }

        .ticker-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .ticker-pair { color: var(--gray-800); }
        .ticker-rate { font-family: var(--font-display); font-weight: 700; color: var(--gray-900); }
        .ticker-change.up { color: var(--accent-emerald); font-weight: 700; }
        .ticker-change.down { color: var(--secondary-600); font-weight: 700; }

        .ticker-refresh-btn {
            background: rgba(99, 102, 241, 0.08);
            border: 1px solid var(--glass-border);
            color: var(--primary-600);
            padding: 6px 12px;
            border-radius: var(--radius-full);
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
            transition: all 0.2s ease;
        }

        .ticker-refresh-btn:hover {
            background: var(--primary-600);
            color: white;
        }

        /* --- PORTAL ENTRY SECTION --- */
        .bank-login-section {
            position: relative;
            padding: 100px 0;
            z-index: 2;
        }

        .bank-login-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 35px;
            margin-top: 45px;
        }

        .bank-login-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1.5px solid var(--glass-border) !important;
            border-radius: 24px;
            padding: 44px 38px !important;
            box-shadow: 0 15px 38px var(--card-glow) !important;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1) !important;
            display: flex;
            flex-direction: column;
            gap: 14px;
            position: relative;
            overflow: hidden;
            text-decoration: none;
        }

        .bank-login-card:hover {
            transform: translateY(-8px);
            border-color: rgba(99, 102, 241, 0.35) !important;
            box-shadow: 0 25px 55px rgba(99, 102, 241, 0.15) !important;
        }

        .bank-login-card .icon-wrapper {
            width: 62px;
            height: 62px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.1rem;
            margin-bottom: 6px;
            transition: transform 0.4s ease;
        }

        .bank-login-card:nth-child(1) .icon-wrapper {
            background: rgba(99, 102, 241, 0.08);
            border: 1px solid rgba(99, 102, 241, 0.18);
            color: var(--primary-600);
        }

        .bank-login-card:nth-child(2) .icon-wrapper {
            background: rgba(236, 72, 153, 0.08);
            border: 1px solid rgba(236, 72, 153, 0.18);
            color: var(--secondary-600);
        }

        .bank-login-card:hover .icon-wrapper {
            transform: scale(1.12) rotate(6deg);
        }

        .bank-login-card h3 {
            font-size: 1.55rem;
            font-weight: 800;
            color: var(--gray-900) !important;
            margin: 0;
        }

        .bank-login-card p {
            font-size: 0.92rem;
            color: var(--gray-600) !important;
            line-height: 1.65;
            margin: 0;
        }

        .bank-login-card .portal-link-text {
            font-size: 0.88rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 10px;
            transition: gap 0.2s ease;
        }

        .bank-login-card:nth-child(1) .portal-link-text { color: var(--primary-600); }
        .bank-login-card:nth-child(2) .portal-link-text { color: var(--secondary-600); }

        .bank-login-card:hover .portal-link-text { gap: 12px; }

        /* --- INTERACTIVE BANKING FEATURE TABBED DEMO --- */
        .feature-demo-section {
            padding: 90px 0;
            position: relative;
            z-index: 2;
        }

        .tab-controls {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 35px;
            flex-wrap: wrap;
        }

        .tab-btn {
            background: var(--glass-bg);
            border: 1.5px solid var(--glass-border);
            padding: 12px 24px;
            border-radius: var(--radius-full);
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--gray-700);
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tab-btn:hover {
            background: rgba(99, 102, 241, 0.08);
            color: var(--primary-600);
        }

        .tab-btn.active {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 18px rgba(99, 102, 241, 0.35);
        }

        .tab-content-container {
            margin-top: 35px;
        }

        .tab-panel {
            display: none;
            background: var(--glass-bg);
            backdrop-filter: blur(25px);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 40px;
            box-shadow: 0 15px 40px var(--card-glow);
            animation: fadeIn 0.4s ease;
        }

        .tab-panel.active { display: block; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* --- SERVICES GRID --- */
        .services {
            position: relative;
            padding: 100px 0;
            z-index: 2;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            margin-top: 45px;
        }

        @media (max-width: 1199px) { .services-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 640px) { .services-grid { grid-template-columns: 1fr; } }

        .service-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1.5px solid var(--glass-border) !important;
            border-radius: var(--radius-xl);
            padding: 34px 28px;
            box-shadow: 0 10px 30px var(--card-glow);
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .service-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--gradient-primary);
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .service-card:hover {
            transform: translateY(-8px);
            border-color: rgba(99, 102, 241, 0.3) !important;
            box-shadow: 0 20px 45px rgba(99, 102, 241, 0.14);
        }

        .service-card:hover::before { opacity: 1; }

        .service-card .card-icon {
            width: 54px;
            height: 54px;
            background: rgba(99, 102, 241, 0.08);
            border: 1px solid rgba(99, 102, 241, 0.16);
            border-radius: var(--radius-md);
            color: var(--primary-600);
            font-size: 1.65rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .service-card:hover .card-icon {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            transform: scale(1.08);
        }

        .service-card h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-900) !important;
            margin-bottom: 10px;
        }

        .service-card p {
            font-size: 0.88rem;
            color: var(--gray-600) !important;
            line-height: 1.65;
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .service-card .card-tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .service-card .card-tags span {
            font-size: 0.72rem;
            font-weight: 600;
            background: rgba(99, 102, 241, 0.06);
            border: 1px solid rgba(99, 102, 241, 0.14);
            color: var(--primary-600);
            padding: 4px 10px;
            border-radius: 6px;
        }

        /* --- INTERACTIVE FINANCIAL CALCULATOR SECTION --- */
        .calc-section {
            padding: 100px 0;
            position: relative;
            z-index: 2;
        }

        .calc-card {
            background: var(--glass-bg);
            backdrop-filter: blur(30px) saturate(180%);
            -webkit-backdrop-filter: blur(30px) saturate(180%);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 45px;
            box-shadow: 0 25px 60px -15px var(--card-glow);
            margin-top: 35px;
            position: relative;
            overflow: hidden;
        }

        .calc-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .calc-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 45px;
            align-items: center;
        }

        @media (max-width: 991px) {
            .calc-grid { grid-template-columns: 1fr; gap: 30px; }
        }

        .calc-control-group { margin-bottom: 28px; }

        .calc-control-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            font-size: 0.95rem;
            color: var(--gray-800);
            margin-bottom: 12px;
        }

        .calc-val-badge {
            font-family: var(--font-display);
            font-weight: 700;
            font-size: 1.05rem;
            color: var(--primary-600);
            background: rgba(99, 102, 241, 0.08);
            border: 1px solid rgba(99, 102, 241, 0.2);
            padding: 4px 14px;
            border-radius: var(--radius-full);
        }

        .calc-slider-wrapper { position: relative; padding: 8px 0; }

        .calc-slider {
            width: 100%;
            height: 10px;
            border-radius: 20px;
            background: var(--gray-200);
            outline: none;
            -webkit-appearance: none;
            appearance: none;
            cursor: pointer;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.08);
        }

        body.dark-mode .calc-slider { background: #334155; }

        .calc-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-500) 0%, var(--secondary-500) 100%);
            border: 3px solid #ffffff;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.45);
            transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.25s ease;
        }

        .calc-slider::-webkit-slider-thumb:hover {
            transform: scale(1.25);
            box-shadow: 0 0 0 10px rgba(99, 102, 241, 0.2), 0 6px 20px rgba(99, 102, 241, 0.5);
        }

        .calc-preset-chips {
            display: flex;
            gap: 8px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .calc-chip {
            font-size: 0.75rem;
            font-weight: 600;
            background: rgba(99, 102, 241, 0.06);
            border: 1px solid rgba(99, 102, 241, 0.16);
            color: var(--primary-600);
            padding: 5px 12px;
            border-radius: var(--radius-full);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .calc-chip:hover {
            background: var(--primary-600);
            color: white;
            transform: translateY(-1px);
        }

        .calc-output-box {
            background: linear-gradient(145deg, rgba(99, 102, 241, 0.05) 0%, rgba(236, 72, 153, 0.05) 100%);
            border: 1.5px solid rgba(99, 102, 241, 0.2);
            border-radius: var(--radius-lg);
            padding: 32px 28px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.05);
        }

        .calc-output-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 12px;
            border-bottom: 1px dashed var(--glass-border);
        }

        .calc-output-item:last-child { border-bottom: none; padding-bottom: 0; }

        .calc-output-val {
            font-family: var(--font-display);
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--primary-600);
            transition: transform 0.15s ease;
        }

        .calc-output-val.pulse { animation: calcPop 0.25s ease-out; }

        @keyframes calcPop {
            0% { transform: scale(1); }
            50% { transform: scale(1.08); }
            100% { transform: scale(1); }
        }

        .calc-breakdown-bar {
            height: 10px;
            border-radius: 20px;
            overflow: hidden;
            display: flex;
            background: var(--gray-200);
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
        }

        .calc-principal-fill {
            height: 100%;
            background: linear-gradient(90deg, #6366f1, #818cf8);
            transition: width 0.3s ease;
        }

        .calc-interest-fill {
            height: 100%;
            background: linear-gradient(90deg, #ec4899, #f472b6);
            transition: width 0.3s ease;
        }

        /* --- SECURITY SHOWCASE SECTION --- */
        .security-section {
            padding: 100px 0;
            position: relative;
            z-index: 2;
        }

        .security-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin-top: 45px;
        }

        @media (max-width: 991px) { .security-grid { grid-template-columns: 1fr; } }

        .security-item {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 35px 30px;
            display: flex;
            align-items: flex-start;
            gap: 20px;
            box-shadow: 0 10px 30px var(--card-glow);
            transition: transform 0.3s ease;
        }

        .security-item:hover { transform: translateY(-5px); }

        .security-icon {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            background: rgba(16, 185, 129, 0.08);
            border: 1px solid rgba(16, 185, 129, 0.22);
            color: var(--accent-emerald);
            font-size: 1.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .security-item h4 {
            font-size: 1.18rem;
            font-weight: 700;
            color: var(--gray-900) !important;
            margin-bottom: 8px;
        }

        .security-item p {
            font-size: 0.88rem;
            color: var(--gray-600) !important;
            line-height: 1.6;
            margin: 0;
        }

        /* --- ABOUT & CEO FLIPPABLE CARD --- */
        .about {
            position: relative;
            padding: 100px 0;
            z-index: 2;
        }

        .ceo-card-container {
            perspective: 2000px;
            width: 100%;
            max-width: 440px;
            height: 270px;
            margin: 0 auto;
            cursor: pointer;
            position: relative;
        }

        .flip-card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            transition: transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
            transform-style: preserve-3d;
        }

        .ceo-card-container:hover .flip-card-inner,
        .ceo-card-container.flipped .flip-card-inner {
            transform: rotateY(180deg);
        }

        .flip-card-front,
        .flip-card-back {
            position: absolute;
            inset: 0;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            border-radius: 22px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.14);
            overflow: hidden;
        }

        .flip-card-front {
            background: url('${pageContext.request.contextPath}/assest/images/Extra/front-card.png') no-repeat center center !important;
            background-size: cover !important;
            transform: rotateY(0deg);
        }

        .flip-card-back {
            background: url('${pageContext.request.contextPath}/assest/images/Extra/back-side card.png') no-repeat center center !important;
            background-size: cover !important;
            transform: rotateY(180deg);
        }

        /* --- FAQ ACCORDION SECTION --- */
        .faq-section {
            padding: 100px 0;
            position: relative;
            z-index: 2;
        }

        .faq-list {
            max-width: 860px;
            margin: 40px auto 0;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .faq-item {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .faq-question {
            padding: 22px 28px;
            font-weight: 700;
            font-size: 1.05rem;
            color: var(--gray-900) !important;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            user-select: none;
        }

        .faq-question i {
            font-size: 1.4rem;
            color: var(--primary-600);
            transition: transform 0.3s ease;
        }

        .faq-item.active .faq-question i { transform: rotate(180deg); }

        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s cubic-bezier(0, 1, 0, 1), padding 0.3s ease;
            padding: 0 28px;
            font-size: 0.9rem;
            color: var(--gray-600) !important;
            line-height: 1.7;
        }

        .faq-item.active .faq-answer {
            max-height: 300px;
            padding: 0 28px 24px;
        }

        /* --- BUTTON STYLES --- */
        .btn-primary {
            background: var(--gradient-primary) !important;
            color: white !important;
            box-shadow: 0 4px 20px rgba(79, 70, 229, 0.35);
            transition: all 0.3s ease !important;
            border: none !important;
            font-weight: 600;
            padding: 14px 30px;
            border-radius: var(--radius-full);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(79, 70, 229, 0.48);
        }

        .btn-secondary {
            background: var(--glass-bg) !important;
            border: 1.5px solid var(--glass-border) !important;
            color: var(--gray-800) !important;
            backdrop-filter: blur(15px);
            transition: all 0.3s ease !important;
            font-weight: 600;
            padding: 14px 30px;
            border-radius: var(--radius-full);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-secondary:hover {
            border-color: var(--primary-500) !important;
            color: var(--primary-600) !important;
            transform: translateY(-3px);
        }

        /* --- FOOTER OVERRIDES --- */
        .footer {
            background: var(--glass-bg) !important;
            border-top: 1.5px solid var(--glass-border) !important;
            padding: 60px 0 30px !important;
            position: relative;
            z-index: 2;
        }
    </style>
</head>

<body class="bank-home-page">
    <!-- Preloader -->
    <div class="preloader">
        <div class="loader">
            <div class="loader-ring"></div>
            <div class="loader-ring-outer"></div>
            <span class="loader-watermark">VGB</span>
        </div>
    </div>

    <!-- Mouse Tracking Background Glow -->
    <div class="cursor-glow"></div>

    <!-- Ambient Background Blobs -->
    <div class="glow-blobs-container">
        <div class="glow-blob glow-blob-1"></div>
        <div class="glow-blob glow-blob-2"></div>
        <div class="glow-blob glow-blob-3"></div>
    </div>

    <!-- Sticky Glass Header Navigation -->
    <header class="header" id="siteHeader">
        <a href="#home" class="logo" aria-label="Vertex Galaxy Bank Home">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo">
            <span class="logo-brand-text">Vertex Galaxy <span>Bank</span></span>
        </a>

        <nav class="navbar" aria-label="Main navigation">
            <a href="#home" class="active"><i class="bx bx-home"></i> Home</a>
            <a href="#login"><i class="bx bx-log-in-circle"></i> Portals</a>
            <a href="#features"><i class="bx bx-star"></i> Demo</a>
            <a href="#services"><i class="bx bx-grid-alt"></i> Services</a>
            <a href="#calculator"><i class="bx bx-calculator"></i> Calculator</a>
            <a href="#security"><i class="bx bx-shield-quarter"></i> Security</a>
            <a href="#about"><i class="bx bx-info-circle"></i> About</a>
            <a href="#faq"><i class="bx bx-help-circle"></i> FAQ</a>
        </nav>

        <div class="nav-right-actions">
            <button type="button" class="theme-toggle-btn" id="themeToggleBtn" onclick="toggleTheme()"
                title="Toggle Dark / Light Theme" aria-label="Toggle Theme">
                <i class="bx bx-moon" id="themeToggleIcon" style="font-size: 1.25rem;"></i>
            </button>
            <a href="${pageContext.request.contextPath}/login" class="header-portal-btn">
                <span>Portal Sign In</span>
                <i class="bx bx-right-arrow-alt"></i>
            </a>
            <button class="mobile-menu-btn" type="button" aria-label="Open menu" style="display: none;">
                <i class="bx bx-menu"></i>
            </button>
        </div>
    </header>

    <main>
        <!-- Hero Section -->
        <section class="home bank-hero" id="home">
            <div class="container">
                <div class="home-content" style="display: grid; grid-template-columns: 1.25fr 1fr; gap: 50px; align-items: center;">
                    <div class="hero-text">
                        <div class="hero-badge">
                            <span class="pulse-dot"></span>
                            Vertex Galaxy Core System v2.6 Online
                        </div>
                        <h1 class="name">
                            Next-Gen Digital <span class="highlight">Banking</span>
                        </h1>
                        <div class="typing-wrapper">
                            <span>Engineered for <span class="typed-text"></span></span>
                        </div>
                        <p class="hero-description" style="color: var(--gray-600); line-height: 1.75; font-size: 1.02rem; margin-bottom: 28px;">
                            Manage savings & current accounts, route high-speed wire transfers, audit passbooks,
                            request cheque books, and apply for instant loan approvals in one unified banking environment.
                        </p>

                        <!-- Hero Stats Grid -->
                        <div class="hero-stats" aria-label="Bank highlights">
                            <div class="stat">
                                <span class="stat-number">24/7</span>
                                <span class="stat-label">System Access</span>
                            </div>
                            <div class="stat">
                                <span class="stat-number">100%</span>
                                <span class="stat-label">Encrypted</span>
                            </div>
                            <div class="stat">
                                <span class="stat-number">8+</span>
                                <span class="stat-label">Core Modules</span>
                            </div>
                            <div class="stat">
                                <span class="stat-number">99.9%</span>
                                <span class="stat-label">Uptime</span>
                            </div>
                        </div>

                        <div class="hero-btns" style="display: flex; gap: 16px;">
                            <a href="${pageContext.request.contextPath}/login" class="btn-primary">
                                <span>Access Banking Gateway</span>
                                <i class="bx bx-right-arrow-alt" style="font-size: 1.25rem;"></i>
                            </a>
                            <a href="#services" class="btn-secondary">
                                <span>Explore Suite</span>
                                <i class="bx bx-down-arrow-alt"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Interactive 3D Bank Card Visualizer -->
                    <div class="home-img bank-visual">
                        <div class="bank-card-container">
                            <div class="bank-card" style="background: url('${pageContext.request.contextPath}/assest/images/Extra/card.png') no-repeat center center; background-size: cover; border: none;">
                            </div>
                            <div class="floating-icons">
                                <span class="float-icon" title="256-Bit Encryption"><i class="bx bx-lock-alt"></i></span>
                                <span class="float-icon" title="Instant Wire Transfer"><i class="bx bx-transfer"></i></span>
                                <span class="float-icon" title="E-Statement Export"><i class="bx bx-receipt"></i></span>
                                <span class="float-icon" title="Smart Card Facility"><i class="bx bx-credit-card"></i></span>
                            </div>
                        </div>
                        <div class="experience-badge">
                            <span class="years">24/7</span>
                            <span class="text">Instant Real-Time<br>Ledger Auditing</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Live Currency Exchange Rates & Market Ticker -->
        <section class="market-ticker-section" id="rates">
            <div class="container">
                <div class="ticker-wrapper">
                    <div class="ticker-label">
                        <i class="bx bx-line-chart" style="font-size: 1.2rem;"></i>
                        <span>Live Rates:</span>
                    </div>
                    <div class="ticker-items" id="tickerItems">
                        <div class="ticker-item">
                            <span class="ticker-pair">USD / INR:</span>
                            <span class="ticker-rate" id="rateUSD">₹ 83.42</span>
                            <span class="ticker-change up"><i class="bx bx-up-arrow-alt"></i>+0.14%</span>
                        </div>
                        <div class="ticker-item">
                            <span class="ticker-pair">EUR / INR:</span>
                            <span class="ticker-rate" id="rateEUR">₹ 90.15</span>
                            <span class="ticker-change up"><i class="bx bx-up-arrow-alt"></i>+0.08%</span>
                        </div>
                        <div class="ticker-item">
                            <span class="ticker-pair">GBP / INR:</span>
                            <span class="ticker-rate" id="rateGBP">₹ 105.80</span>
                            <span class="ticker-change down"><i class="bx bx-down-arrow-alt"></i>-0.05%</span>
                        </div>
                        <div class="ticker-item">
                            <span class="ticker-pair">AED / INR:</span>
                            <span class="ticker-rate" id="rateAED">₹ 22.71</span>
                            <span class="ticker-change up"><i class="bx bx-up-arrow-alt"></i>+0.02%</span>
                        </div>
                        <div class="ticker-item">
                            <span class="ticker-pair">Gold (24K/g):</span>
                            <span class="ticker-rate" id="rateGold">₹ 7,240</span>
                            <span class="ticker-change up"><i class="bx bx-up-arrow-alt"></i>+0.35%</span>
                        </div>
                    </div>
                    <button type="button" class="ticker-refresh-btn" onclick="refreshMarketRates()">
                        <i class="bx bx-refresh" id="refreshIcon"></i> Update
                    </button>
                </div>
            </div>
        </section>

        <!-- Dual Portal Gateway Access Section -->
        <section class="bank-login-section" id="login">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Unified Gateways</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.6rem; font-weight: 800;">Choose Your <span class="highlight">Portal</span></h2>
                </div>

                <div class="bank-login-grid">
                    <a href="${pageContext.request.contextPath}/login" class="bank-login-card">
                        <div class="icon-wrapper">
                            <i class="bx bx-user-circle"></i>
                        </div>
                        <h3>Customer Digital Portal</h3>
                        <p>Access personal savings and current accounts, initiate funds transfers, request passbooks & cheque leaves, set up AutoPay instructions, and track loan applications.</p>
                        <span class="portal-link-text">Enter Customer Workspace <i class="bx bx-right-arrow-alt"></i></span>
                    </a>

                    <a href="${pageContext.request.contextPath}/login" class="bank-login-card">
                        <div class="icon-wrapper">
                            <i class="bx bx-shield-quarter"></i>
                        </div>
                        <h3>Administrative &amp; Cashier Desk</h3>
                        <p>Access high-security administrative controls to monitor customer account registries, post cashier cash counter transactions, review cheque books, and approve loan portfolios.</p>
                        <span class="portal-link-text">Enter Administrator Workspace <i class="bx bx-right-arrow-alt"></i></span>
                    </a>
                </div>
            </div>
        </section>

        <!-- Interactive Live Banking Feature Demo Tabs -->
        <section class="feature-demo-section" id="features">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Interactive Preview</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">Live Core <span class="highlight">Modules</span></h2>
                </div>

                <div class="tab-controls">
                    <button type="button" class="tab-btn active" onclick="switchFeatureTab('transferTab', this)">
                        <i class="bx bx-transfer-alt"></i> Instant Wire Transfer
                    </button>
                    <button type="button" class="tab-btn" onclick="switchFeatureTab('passbookTab', this)">
                        <i class="bx bx-book-content"></i> E-Passbook &amp; Auditing
                    </button>
                    <button type="button" class="tab-btn" onclick="switchFeatureTab('cardsTab', this)">
                        <i class="bx bx-credit-card-front"></i> Smart Card Security
                    </button>
                </div>

                <div class="tab-content-container">
                    <!-- Tab 1: Wire Transfer Demo -->
                    <div class="tab-panel active" id="transferTab">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: center;">
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-900); margin-bottom: 12px;">High-Speed Intra-Bank Wire Transfers</h3>
                                <p style="color: var(--gray-600); line-height: 1.7; font-size: 0.95rem; margin-bottom: 20px;">
                                    Execute instant transfers between savings and current accounts with end-to-end PIN validation and live receipt generation.
                                </p>
                                <ul style="list-style: none; padding: 0; margin: 0 0 25px 0; display: flex; flex-direction: column; gap: 10px;">
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> Zero-latency internal ledger postings
                                    </li>
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> Multi-tier PIN verification step
                                    </li>
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> Instant SMS & Email notification logs
                                    </li>
                                </ul>
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary">Try Money Transfer</a>
                            </div>
                            <div style="background: rgba(99, 102, 241, 0.05); border: 1px solid var(--glass-border); border-radius: 16px; padding: 25px;">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-weight: 700; color: var(--gray-900);">
                                    <span>Wire Transfer Preview</span>
                                    <span style="color: var(--accent-emerald);"><i class="bx bx-shield-check"></i> Encrypted</span>
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 12px;">
                                    <div style="background: var(--glass-bg); padding: 12px 16px; border-radius: 10px; border: 1px solid var(--glass-border); font-size: 0.88rem;">
                                        <span style="color: var(--gray-500); display: block; font-size: 0.75rem;">Source Account</span>
                                        <strong style="color: var(--gray-900);">VGB Savings - **** 8492</strong>
                                    </div>
                                    <div style="text-align: center; color: var(--primary-600); font-size: 1.4rem;">
                                        <i class="bx bx-down-arrow-alt"></i>
                                    </div>
                                    <div style="background: var(--glass-bg); padding: 12px 16px; border-radius: 10px; border: 1px solid var(--glass-border); font-size: 0.88rem;">
                                        <span style="color: var(--gray-500); display: block; font-size: 0.75rem;">Beneficiary Account</span>
                                        <strong style="color: var(--gray-900);">VGB Current - **** 1104</strong>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tab 2: Passbook Demo -->
                    <div class="tab-panel" id="passbookTab">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: center;">
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-900); margin-bottom: 12px;">Real-Time E-Passbook &amp; Statements</h3>
                                <p style="color: var(--gray-600); line-height: 1.7; font-size: 0.95rem; margin-bottom: 20px;">
                                    Audit historical debit/credit transactions dynamically, filter custom date intervals, and export official PDF statements.
                                </p>
                                <ul style="list-style: none; padding: 0; margin: 0 0 25px 0; display: flex; flex-direction: column; gap: 10px;">
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> Instant date-range statement filtering
                                    </li>
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> PDF e-statement offline generation
                                    </li>
                                </ul>
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary">View E-Passbook</a>
                            </div>
                            <div style="background: rgba(99, 102, 241, 0.05); border: 1px solid var(--glass-border); border-radius: 16px; padding: 25px;">
                                <div style="font-weight: 700; color: var(--gray-900); margin-bottom: 15px;">Recent Transaction Audit</div>
                                <div style="display: flex; flex-direction: column; gap: 10px;">
                                    <div style="display: flex; justify-content: space-between; align-items: center; background: var(--glass-bg); padding: 10px 14px; border-radius: 10px; font-size: 0.85rem;">
                                        <div><strong>Salary Credit</strong><br><small style="color: var(--gray-500);">28 Jul 2026</small></div>
                                        <span style="color: var(--accent-emerald); font-weight: 700;">+ ₹ 75,000</span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; align-items: center; background: var(--glass-bg); padding: 10px 14px; border-radius: 10px; font-size: 0.85rem;">
                                        <div><strong>AutoPay Utility Bill</strong><br><small style="color: var(--gray-500);">25 Jul 2026</small></div>
                                        <span style="color: var(--secondary-600); font-weight: 700;">- ₹ 2,450</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tab 3: Smart Cards Demo -->
                    <div class="tab-panel" id="cardsTab">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: center;">
                            <div>
                                <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-900); margin-bottom: 12px;">Smart Card Management &amp; Security Controls</h3>
                                <p style="color: var(--gray-600); line-height: 1.7; font-size: 0.95rem; margin-bottom: 20px;">
                                    Manage physical and virtual debit/credit cards, adjust online transaction limits, toggle international usage, and freeze cards instantly.
                                </p>
                                <ul style="list-style: none; padding: 0; margin: 0 0 25px 0; display: flex; flex-direction: column; gap: 10px;">
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> One-click instant card lock & unlock
                                    </li>
                                    <li style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--gray-800);">
                                        <i class="bx bx-check-circle" style="color: var(--accent-emerald); font-size: 1.2rem;"></i> Custom daily ATM & POS limit sliders
                                    </li>
                                </ul>
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary">Manage Cards</a>
                            </div>
                            <div style="background: rgba(99, 102, 241, 0.05); border: 1px solid var(--glass-border); border-radius: 16px; padding: 25px; text-align: center;">
                                <i class="bx bx-credit-card" style="font-size: 4rem; color: var(--primary-600); margin-bottom: 10px;"></i>
                                <h4 style="color: var(--gray-900); margin-bottom: 5px;">Vertex Platinum Debit Card</h4>
                                <span style="color: var(--accent-emerald); font-weight: 700; font-size: 0.85rem;"><i class="bx bx-radio-circle-marked"></i> Status: Active & Secured</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Product Services Showcase Grid -->
        <section class="services" id="services">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Banking Capabilities</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">
                        Complete Digital <span class="highlight">Financial Suite</span></h2>
                </div>

                <div class="services-grid">
                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-wallet"></i></div>
                        <h3>Account Management</h3>
                        <p>Monitor real-time ledger balances, manage savings and current account profiles, and track account numbers dynamically.</p>
                        <div class="card-tags"><span>Savings</span><span>Current</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-transfer"></i></div>
                        <h3>Fast Wire Transfers</h3>
                        <p>Execute instant funds transfers to beneficiary accounts with automated PIN verification and transaction receipts.</p>
                        <div class="card-tags"><span>Wire</span><span>Payments</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-file-find"></i></div>
                        <h3>E-Passbook &amp; Audits</h3>
                        <p>Review comprehensive historical transactions, query date ranges, and export official statement records.</p>
                        <div class="card-tags"><span>Statements</span><span>PDF Export</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-credit-card"></i></div>
                        <h3>Smart Card Services</h3>
                        <p>Issue debit/credit cards, manage security PINs, set daily withdrawal limits, and clear outstanding balances.</p>
                        <div class="card-tags"><span>Debit</span><span>Credit Card</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-building-house"></i></div>
                        <h3>Loan Approvals</h3>
                        <p>Apply for Housing, Personal, or Vehicle loans with transparent EMI terms and live administrative processing updates.</p>
                        <div class="card-tags"><span>Loans</span><span>EMIs</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-book-open"></i></div>
                        <h3>Cheque &amp; Cash Counter</h3>
                        <p>Request new cheque book leaves, audit issued cheque leaves, and process counter deposit/withdrawal vouchers.</p>
                        <div class="card-tags"><span>Cheques</span><span>Cashier</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-time-five"></i></div>
                        <h3>AutoPay Scheduler</h3>
                        <p>Schedule recurring payment mandates for utility bills, loan EMIs, and standing instructions automatically.</p>
                        <div class="card-tags"><span>AutoPay</span><span>Recurring</span></div>
                    </article>

                    <article class="service-card">
                        <div class="card-icon"><i class="bx bx-lock-alt"></i></div>
                        <h3>Bank-Grade Security</h3>
                        <p>Protected by end-to-end encryption, multi-tier session validation, password security hashes, and instant alerts.</p>
                        <div class="card-tags"><span>256-Bit</span><span>PCI-DSS</span></div>
                    </article>
                </div>
            </div>
        </section>

        <!-- Interactive Financial Calculators (Loan EMI & Fixed Deposit Tabs) -->
        <section class="calc-section" id="calculator">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Financial Planning</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">
                        Interactive <span class="highlight">Financial Calculators</span></h2>
                </div>

                <div class="tab-controls" style="margin-top: 25px;">
                    <button type="button" class="tab-btn active" id="calcEmiTabBtn" onclick="switchCalcType('emi')">
                        <i class="bx bx-calculator"></i> Loan EMI Calculator
                    </button>
                    <button type="button" class="tab-btn" id="calcFdTabBtn" onclick="switchCalcType('fd')">
                        <i class="bx bx-line-chart-down"></i> Fixed Deposit Growth
                    </button>
                </div>

                <div class="calc-card">
                    <!-- EMI Calculator View -->
                    <div id="emiCalcView" class="calc-grid">
                        <div class="calc-controls">
                            <!-- Loan Amount Slider -->
                            <div class="calc-control-group">
                                <div class="calc-control-label">
                                    <span><i class="bx bx-rupee"></i> Loan Amount</span>
                                    <span class="calc-val-badge" id="loanAmtVal">₹ 5,00,000</span>
                                </div>
                                <div class="calc-slider-wrapper">
                                    <input type="range" class="calc-slider" id="loanAmtSlider" min="10000" max="5000000" step="10000" value="500000">
                                </div>
                                <div class="calc-preset-chips">
                                    <button type="button" class="calc-chip" onclick="setPresetLoan(100000)">₹ 1 Lakh</button>
                                    <button type="button" class="calc-chip" onclick="setPresetLoan(500000)">₹ 5 Lakh</button>
                                    <button type="button" class="calc-chip" onclick="setPresetLoan(1000000)">₹ 10 Lakh</button>
                                    <button type="button" class="calc-chip" onclick="setPresetLoan(2500000)">₹ 25 Lakh</button>
                                    <button type="button" class="calc-chip" onclick="setPresetLoan(5000000)">₹ 50 Lakh</button>
                                </div>
                            </div>

                            <!-- Interest Rate Slider -->
                            <div class="calc-control-group">
                                <div class="calc-control-label">
                                    <span><i class="bx bx-percentage"></i> Interest Rate (% p.a.)</span>
                                    <span class="calc-val-badge" id="interestRateVal">8.5%</span>
                                </div>
                                <div class="calc-slider-wrapper">
                                    <input type="range" class="calc-slider" id="interestRateSlider" min="4" max="18" step="0.25" value="8.5">
                                </div>
                            </div>

                            <!-- Tenure Slider -->
                            <div class="calc-control-group" style="margin-bottom: 0;">
                                <div class="calc-control-label">
                                    <span><i class="bx bx-calendar-event"></i> Loan Tenure (Years)</span>
                                    <span class="calc-val-badge" id="tenureVal">5 Years</span>
                                </div>
                                <div class="calc-slider-wrapper">
                                    <input type="range" class="calc-slider" id="tenureSlider" min="1" max="30" step="1" value="5">
                                </div>
                            </div>
                        </div>

                        <div class="calc-output-box">
                            <div class="calc-output-item">
                                <span style="font-weight: 600; color: var(--gray-600);">Monthly EMI</span>
                                <span class="calc-output-val" id="monthlyEmiResult">₹ 10,258</span>
                            </div>
                            <div class="calc-output-item">
                                <span style="font-weight: 600; color: var(--gray-600);">Principal Amount</span>
                                <span class="calc-output-val" id="principalAmtResult" style="color: var(--primary-600);">₹ 5,00,000</span>
                            </div>
                            <div class="calc-output-item">
                                <span style="font-weight: 600; color: var(--gray-600);">Total Interest Payable</span>
                                <span class="calc-output-val" id="totalInterestResult" style="color: var(--secondary-500);">₹ 1,15,480</span>
                            </div>
                            <div class="calc-output-item">
                                <span style="font-weight: 700; color: var(--gray-800);">Total Amount Payable</span>
                                <span class="calc-output-val" id="totalPaymentResult" style="color: var(--gray-900); font-size: 1.5rem;">₹ 6,15,480</span>
                            </div>

                            <!-- Visual Ratio Breakdown Bar -->
                            <div style="margin-top: 10px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.78rem; font-weight: 600; margin-bottom: 6px;">
                                    <span style="color: #6366f1;">Principal (<span id="principalPctLabel">81%</span>)</span>
                                    <span style="color: #ec4899;">Interest (<span id="interestPctLabel">19%</span>)</span>
                                </div>
                                <div class="calc-breakdown-bar">
                                    <div class="calc-principal-fill" id="principalFillBar" style="width: 81%;"></div>
                                    <div class="calc-interest-fill" id="interestFillBar" style="width: 19%;"></div>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/login" class="btn-primary" style="justify-content: center; width: 100%; margin-top: 5px;">
                                <span>Apply For Instant Loan</span>
                                <i class="bx bx-right-arrow-alt" style="font-size: 1.25rem;"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Fixed Deposit Calculator View -->
                    <div id="fdCalcView" class="calc-grid" style="display: none;">
                        <div class="calc-controls">
                            <!-- Deposit Amount Slider -->
                            <div class="calc-control-group">
                                <div class="calc-control-label">
                                    <span><i class="bx bx-rupee"></i> Total Deposit Amount</span>
                                    <span class="calc-val-badge" id="fdAmtVal">₹ 1,00,000</span>
                                </div>
                                <div class="calc-slider-wrapper">
                                    <input type="range" class="calc-slider" id="fdAmtSlider" min="10000" max="2000000" step="10000" value="100000">
                                </div>
                            </div>

                            <!-- FD Interest Rate Slider -->
                            <div class="calc-control-group">
                                <div class="calc-control-label">
                                    <span><i class="bx bx-percentage"></i> Annual Interest Rate</span>
                                    <span class="calc-val-badge" id="fdRateVal">7.25%</span>
                                </div>
                                <div class="calc-slider-wrapper">
                                    <input type="range" class="calc-slider" id="fdRateSlider" min="3" max="10" step="0.25" value="7.25">
                                </div>
                            </div>

                            <!-- FD Tenure Slider -->
                            <div class="calc-control-group" style="margin-bottom: 0;">
                                <div class="calc-control-label">
                                    <span><i class="bx bx-time"></i> Investment Period (Years)</span>
                                    <span class="calc-val-badge" id="fdYearsVal">3 Years</span>
                                </div>
                                <div class="calc-slider-wrapper">
                                    <input type="range" class="calc-slider" id="fdYearsSlider" min="1" max="10" step="1" value="3">
                                </div>
                            </div>
                        </div>

                        <div class="calc-output-box">
                            <div class="calc-output-item">
                                <span style="font-weight: 600; color: var(--gray-600);">Invested Amount</span>
                                <span class="calc-output-val" id="fdInvestedResult" style="color: var(--primary-600);">₹ 1,00,000</span>
                            </div>
                            <div class="calc-output-item">
                                <span style="font-weight: 600; color: var(--gray-600);">Est. Interest Earned</span>
                                <span class="calc-output-val" id="fdInterestResult" style="color: var(--accent-emerald);">₹ 23,369</span>
                            </div>
                            <div class="calc-output-item">
                                <span style="font-weight: 700; color: var(--gray-800);">Total Maturity Value</span>
                                <span class="calc-output-val" id="fdMaturityResult" style="color: var(--gray-900); font-size: 1.5rem;">₹ 1,23,369</span>
                            </div>

                            <a href="${pageContext.request.contextPath}/login" class="btn-primary" style="justify-content: center; width: 100%; margin-top: 15px;">
                                <span>Open Fixed Deposit Account</span>
                                <i class="bx bx-right-arrow-alt" style="font-size: 1.25rem;"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Security & Infrastructure Showcase -->
        <section class="security-section" id="security">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Uncompromised Protection</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">
                        Enterprise <span class="highlight">Security Standard</span></h2>
                </div>

                <div class="security-grid">
                    <div class="security-item">
                        <div class="security-icon"><i class="bx bx-shield-check"></i></div>
                        <div>
                            <h4>256-Bit SSL Encryption</h4>
                            <p>All client communications and database operations are transmitted through TLS 1.3 encrypted channels.</p>
                        </div>
                    </div>

                    <div class="security-item">
                        <div class="security-icon"><i class="bx bx-key"></i></div>
                        <div>
                            <h4>Multi-Factor PIN Guard</h4>
                            <p>Critical financial operations such as wire routing and cheque book requests require secondary PIN authorization.</p>
                        </div>
                    </div>

                    <div class="security-item">
                        <div class="security-icon"><i class="bx bx-data"></i></div>
                        <div>
                            <h4>Real-Time Ledger Audits</h4>
                            <p>Every transaction triggers an immediate immutable balance calculation preventing double-spending anomalies.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Corporate Profile & Flippable Card Section -->
        <section class="about" id="about">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Corporate Profile</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">
                        Reliable Banking, <span class="highlight">Uncompromised Access</span></h2>
                </div>

                <div class="about-content" style="margin-top: 45px; display: grid; grid-template-columns: 1fr 1.2fr; gap: 60px; align-items: center;">
                    <!-- Left: Interactive Flippable CEO / Corporate Card -->
                    <div class="about-img bank-about-panel">
                        <div class="ceo-card-container" id="ceoCard">
                            <div class="flip-card-inner">
                                <div class="flip-card-front"></div>
                                <div class="flip-card-back"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Corporate Information -->
                    <div class="about-text">
                        <h3 style="color: var(--gray-900); font-size: 1.6rem; font-weight: 700; margin-bottom: 15px;">
                            Tailored workflows for customers and bank administrators
                        </h3>
                        <p style="color: var(--gray-600); margin-bottom: 15px; font-size: 0.94rem; line-height: 1.7;">
                            Vertex Galaxy Bank provides an integrated digital environment designed to handle account profiles, balances, and cash transactions. Customers can view savings/current accounts, execute funds transfers, request cheque books, download offline passbooks, and track loans from their secure dashboard.
                        </p>
                        <p style="color: var(--gray-600); margin-bottom: 25px; font-size: 0.94rem; line-height: 1.7;">
                            Bank administrators have access to an internal administrative workspace where they can monitor register records, approve loan portfolios, issue checkbook leaves, and post cashier deposits directly.
                        </p>

                        <div class="about-info" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 30px;">
                            <div class="info-item" style="display: flex; align-items: center; gap: 10px; font-size: 0.88rem; color: var(--gray-700);">
                                <i class="bx bx-user-check" style="font-size: 1.3rem; color: var(--primary-600);"></i>
                                <span>Customer: <strong>Digital Workspaces</strong></span>
                            </div>
                            <div class="info-item" style="display: flex; align-items: center; gap: 10px; font-size: 0.88rem; color: var(--gray-700);">
                                <i class="bx bx-shield-alt-2" style="font-size: 1.3rem; color: var(--primary-600);"></i>
                                <span>Admin: <strong>Security Approvals</strong></span>
                            </div>
                            <div class="info-item" style="display: flex; align-items: center; gap: 10px; font-size: 0.88rem; color: var(--gray-700);">
                                <i class="bx bx-wallet" style="font-size: 1.3rem; color: var(--primary-600);"></i>
                                <span>Ledger: <strong>Automatic Updates</strong></span>
                            </div>
                            <div class="info-item" style="display: flex; align-items: center; gap: 10px; font-size: 0.88rem; color: var(--gray-700);">
                                <i class="bx bx-file" style="font-size: 1.3rem; color: var(--primary-600);"></i>
                                <span>Auditing: <strong>Passbooks &amp; Statements</strong></span>
                            </div>
                        </div>

                        <div class="about-btns" style="display: flex; gap: 15px;">
                            <a href="${pageContext.request.contextPath}/login" class="btn-primary">Access Banking Portal</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Interactive FAQ Accordion Section -->
        <section class="faq-section" id="faq">
            <div class="container">
                <div class="section-header" style="text-align: center;">
                    <span class="subtitle" style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Got Questions?</span>
                    <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">
                        Frequently Asked <span class="highlight">Questions</span></h2>
                </div>

                <div class="faq-list">
                    <div class="faq-item active">
                        <div class="faq-question">
                            <span>How do I access my Vertex Galaxy Bank account online?</span>
                            <i class="bx bx-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            You can log in to your account by clicking the "Portal Sign In" button at the top right corner of the page or navigating to the Customer Digital Portal section. Enter your registered Account Number/Username and Password to access your dashboard.
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <span>How fast are money transfers processed?</span>
                            <i class="bx bx-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Intra-bank transfers within Vertex Galaxy Bank are executed instantly with real-time balance deductions and ledger updates. Inter-bank wire transfers are routed through secure verification channels.
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <span>How do I apply for a loan through VGB?</span>
                            <i class="bx bx-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Log in to your Customer Portal, navigate to the Loans section, select your desired loan category (Housing, Personal, or Vehicle), specify the amount and tenure, and submit your application for administrative review.
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Can I download account statements offline?</span>
                            <i class="bx bx-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            Yes! The Passbook &amp; Statements module allows you to query transactions for custom date ranges and generate official PDF e-statements directly from your dashboard.
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Glass Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                <div class="footer-logo">
                    <span style="font-family: var(--font-display); font-weight: 800; font-size: 1.4rem; color: var(--gray-900);">
                        Vertex Galaxy <span style="background: var(--gradient-primary); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Bank</span>
                    </span>
                </div>
                <div class="footer-links" style="display: flex; gap: 25px;">
                    <a href="#home" style="color: var(--gray-600); text-decoration: none;">Home</a>
                    <a href="#services" style="color: var(--gray-600); text-decoration: none;">Services</a>
                    <a href="#calculator" style="color: var(--gray-600); text-decoration: none;">Calculator</a>
                    <a href="#about" style="color: var(--gray-600); text-decoration: none;">About</a>
                    <a href="${pageContext.request.contextPath}/login" style="color: var(--gray-600); text-decoration: none;">Portal Access</a>
                </div>
            </div>
            <div class="footer-bottom" style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid var(--glass-border);">
                <p style="font-size: 0.82rem; color: var(--gray-500); margin: 0;">
                    &copy; <span id="currentYear">2026</span> Vertex Galaxy Bank. All rights reserved. PCI-DSS Encrypted Banking Systems.
                </p>
            </div>
        </div>
    </footer>

    <!-- Scroll to Top Button -->
    <button class="scroll-top" id="scrollTop" type="button" aria-label="Scroll to top">
        <i class="bx bx-up-arrow-alt"></i>
    </button>

    <!-- Global App JS -->
    <script src="${pageContext.request.contextPath}/assest/js/script.js?v=2.0.1"></script>

    <!-- Custom Landing Page Interactive Handlers -->
    <script>
        // Set dynamic year in footer
        const yearEl = document.getElementById('currentYear');
        if (yearEl) yearEl.textContent = new Date().getFullYear();

        // Theme Toggle Functionality
        function toggleTheme() {
            const htmlEl = document.documentElement;
            const bodyEl = document.body;
            const iconEl = document.getElementById('themeToggleIcon');
            const isDark = htmlEl.classList.contains('dark-mode') || htmlEl.getAttribute('data-theme') === 'dark';

            if (isDark) {
                htmlEl.classList.remove('dark-mode');
                bodyEl.classList.remove('dark-mode');
                htmlEl.setAttribute('data-theme', 'light');
                localStorage.setItem('vgb_theme', 'light');
                localStorage.setItem('theme', 'light');
                if (iconEl) iconEl.className = 'bx bx-moon';
            } else {
                htmlEl.classList.add('dark-mode');
                bodyEl.classList.add('dark-mode');
                htmlEl.setAttribute('data-theme', 'dark');
                localStorage.setItem('vgb_theme', 'dark');
                localStorage.setItem('theme', 'dark');
                if (iconEl) iconEl.className = 'bx bx-sun';
            }
        }

        // Initialize Theme Toggle Icon on Load
        document.addEventListener('DOMContentLoaded', () => {
            const savedTheme = localStorage.getItem('vgb_theme') || localStorage.getItem('theme');
            const iconEl = document.getElementById('themeToggleIcon');
            if (savedTheme === 'dark' && iconEl) {
                iconEl.className = 'bx bx-sun';
            }
        });

        // Header Scroll Shadow effect
        const siteHeader = document.getElementById('siteHeader');
        window.addEventListener('scroll', () => {
            if (window.scrollY > 40) {
                siteHeader.classList.add('scrolled');
            } else {
                siteHeader.classList.remove('scrolled');
            }
        });

        // Interactive 3D Card tilt effect on hero card
        const card = document.querySelector('.bank-card');
        const container = document.querySelector('.bank-card-container');
        if (card && container) {
            container.addEventListener('mousemove', (e) => {
                const rect = container.getBoundingClientRect();
                const x = e.clientX - rect.left - (rect.width / 2);
                const y = e.clientY - rect.top - (rect.height / 2);

                const tiltX = (y / (rect.height / 2)) * -12;
                const tiltY = (x / (rect.width / 2)) * 12;

                card.style.transform = `rotateX(${tiltX}deg) rotateY(${tiltY}deg) translateY(-8px) scale(1.03)`;
            });

            container.addEventListener('mouseleave', () => {
                card.style.transform = 'rotateX(12deg) rotateY(-12deg) translateY(0px) scale(1)';
            });
        }

        // Flippable CEO Card manual toggle
        const ceoCard = document.getElementById('ceoCard');
        if (ceoCard) {
            ceoCard.addEventListener('click', () => {
                ceoCard.classList.toggle('flipped');
            });
        }

        // Typewriter animation is initialized smoothly via script.js App.initTypewriter()


        // Feature Demo Tab Switcher
        function switchFeatureTab(panelId, btnEl) {
            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.tab-controls .tab-btn').forEach(b => b.classList.remove('active'));
            const targetPanel = document.getElementById(panelId);
            if (targetPanel) targetPanel.classList.add('active');
            if (btnEl) btnEl.classList.add('active');
        }

        // Market Rates Live Simulation Update
        function refreshMarketRates() {
            const icon = document.getElementById('refreshIcon');
            if (icon) icon.classList.add('bx-spin');

            setTimeout(() => {
                const usd = (83.30 + Math.random() * 0.3).toFixed(2);
                const eur = (90.00 + Math.random() * 0.4).toFixed(2);
                const gbp = (105.70 + Math.random() * 0.5).toFixed(2);
                const aed = (22.65 + Math.random() * 0.15).toFixed(2);
                const gold = Math.round(7230 + Math.random() * 30);

                document.getElementById('rateUSD').textContent = '₹ ' + usd;
                document.getElementById('rateEUR').textContent = '₹ ' + eur;
                document.getElementById('rateGBP').textContent = '₹ ' + gbp;
                document.getElementById('rateAED').textContent = '₹ ' + aed;
                document.getElementById('rateGold').textContent = '₹ ' + gold.toLocaleString('en-IN');

                if (icon) icon.classList.remove('bx-spin');
            }, 600);
        }

        // Financial Calculator Switcher (EMI vs FD)
        function switchCalcType(type) {
            const emiView = document.getElementById('emiCalcView');
            const fdView = document.getElementById('fdCalcView');
            const emiBtn = document.getElementById('calcEmiTabBtn');
            const fdBtn = document.getElementById('calcFdTabBtn');

            if (type === 'emi') {
                emiView.style.display = 'grid';
                fdView.style.display = 'none';
                emiBtn.classList.add('active');
                fdBtn.classList.remove('active');
                calculateEMI();
            } else {
                emiView.style.display = 'none';
                fdView.style.display = 'grid';
                fdBtn.classList.add('active');
                emiBtn.classList.remove('active');
                calculateFD();
            }
        }

        // EMI Calculator Script
        const loanAmtSlider = document.getElementById('loanAmtSlider');
        const interestRateSlider = document.getElementById('interestRateSlider');
        const tenureSlider = document.getElementById('tenureSlider');

        const loanAmtVal = document.getElementById('loanAmtVal');
        const interestRateVal = document.getElementById('interestRateVal');
        const tenureVal = document.getElementById('tenureVal');

        const monthlyEmiResult = document.getElementById('monthlyEmiResult');
        const principalAmtResult = document.getElementById('principalAmtResult');
        const totalInterestResult = document.getElementById('totalInterestResult');
        const totalPaymentResult = document.getElementById('totalPaymentResult');

        const principalFillBar = document.getElementById('principalFillBar');
        const interestFillBar = document.getElementById('interestFillBar');
        const principalPctLabel = document.getElementById('principalPctLabel');
        const interestPctLabel = document.getElementById('interestPctLabel');

        function formatINR(val) {
            return '₹ ' + Math.round(val).toLocaleString('en-IN');
        }

        function setPresetLoan(val) {
            if (loanAmtSlider) {
                loanAmtSlider.value = val;
                calculateEMI();
            }
        }

        function updateSliderFill(slider) {
            if (!slider) return;
            const min = parseFloat(slider.min) || 0;
            const max = parseFloat(slider.max) || 100;
            const val = parseFloat(slider.value) || 0;
            const pct = ((val - min) / (max - min)) * 100;
            slider.style.background = `linear-gradient(to right, #6366f1 0%, #6366f1 ${pct}%, var(--gray-200) ${pct}%, var(--gray-200) 100%)`;
        }

        function triggerPulseAnimation() {
            [monthlyEmiResult, principalAmtResult, totalInterestResult, totalPaymentResult].forEach(el => {
                if (el) {
                    el.classList.remove('pulse');
                    void el.offsetWidth;
                    el.classList.add('pulse');
                }
            });
        }

        function calculateEMI() {
            if (!loanAmtSlider) return;
            const P = parseFloat(loanAmtSlider.value);
            const r = parseFloat(interestRateSlider.value) / 12 / 100;
            const n = parseFloat(tenureSlider.value) * 12;

            loanAmtVal.textContent = formatINR(P);
            interestRateVal.textContent = interestRateSlider.value + '%';
            tenureVal.textContent = tenureSlider.value + ' Years';

            updateSliderFill(loanAmtSlider);
            updateSliderFill(interestRateSlider);
            updateSliderFill(tenureSlider);

            const emi = (P * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
            const totalPayment = emi * n;
            const totalInterest = totalPayment - P;

            monthlyEmiResult.textContent = formatINR(emi);
            if (principalAmtResult) principalAmtResult.textContent = formatINR(P);
            totalInterestResult.textContent = formatINR(totalInterest);
            totalPaymentResult.textContent = formatINR(totalPayment);

            if (totalPayment > 0) {
                const principalPct = Math.round((P / totalPayment) * 100);
                const interestPct = 100 - principalPct;

                if (principalFillBar) principalFillBar.style.width = principalPct + '%';
                if (interestFillBar) interestFillBar.style.width = interestPct + '%';
                if (principalPctLabel) principalPctLabel.textContent = principalPct + '%';
                if (interestPctLabel) interestPctLabel.textContent = interestPct + '%';
            }

            triggerPulseAnimation();
        }

        // Fixed Deposit Calculator Script
        const fdAmtSlider = document.getElementById('fdAmtSlider');
        const fdRateSlider = document.getElementById('fdRateSlider');
        const fdYearsSlider = document.getElementById('fdYearsSlider');

        function calculateFD() {
            if (!fdAmtSlider) return;
            const P = parseFloat(fdAmtSlider.value);
            const r = parseFloat(fdRateSlider.value) / 100;
            const t = parseFloat(fdYearsSlider.value);

            document.getElementById('fdAmtVal').textContent = formatINR(P);
            document.getElementById('fdRateVal').textContent = fdRateSlider.value + '%';
            document.getElementById('fdYearsVal').textContent = t + ' Years';

            updateSliderFill(fdAmtSlider);
            updateSliderFill(fdRateSlider);
            updateSliderFill(fdYearsSlider);

            // Compound quarterly (n=4)
            const n = 4;
            const A = P * Math.pow(1 + (r / n), n * t);
            const interest = A - P;

            document.getElementById('fdInvestedResult').textContent = formatINR(P);
            document.getElementById('fdInterestResult').textContent = formatINR(interest);
            document.getElementById('fdMaturityResult').textContent = formatINR(A);
        }

        if (loanAmtSlider) {
            loanAmtSlider.addEventListener('input', calculateEMI);
            interestRateSlider.addEventListener('input', calculateEMI);
            tenureSlider.addEventListener('input', calculateEMI);
            calculateEMI();
        }

        if (fdAmtSlider) {
            fdAmtSlider.addEventListener('input', calculateFD);
            fdRateSlider.addEventListener('input', calculateFD);
            fdYearsSlider.addEventListener('input', calculateFD);
        }

        // FAQ Accordion Handler
        const faqQuestions = document.querySelectorAll('.faq-question');
        faqQuestions.forEach(q => {
            q.addEventListener('click', () => {
                const item = q.parentElement;
                const isActive = item.classList.contains('active');
                document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));
                if (!isActive) {
                    item.classList.add('active');
                }
            });
        });

        // Mobile Navigation Menu Toggle Handler
        const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
        const mainNavbar = document.querySelector('.navbar');
        if (mobileMenuBtn && mainNavbar) {
            mobileMenuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                mainNavbar.classList.toggle('active');
                const icon = mobileMenuBtn.querySelector('i');
                if (icon) {
                    if (mainNavbar.classList.contains('active')) {
                        icon.className = 'bx bx-x';
                    } else {
                        icon.className = 'bx bx-menu';
                    }
                }
            });

            document.addEventListener('click', (e) => {
                if (mainNavbar.classList.contains('active') && !mainNavbar.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
                    mainNavbar.classList.remove('active');
                    const icon = mobileMenuBtn.querySelector('i');
                    if (icon) icon.className = 'bx bx-menu';
                }
            });
        }
    </script>
</body>

</html>