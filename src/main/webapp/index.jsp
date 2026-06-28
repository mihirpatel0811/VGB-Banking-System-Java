<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Vertex Galaxy Bank | Next-Gen Digital Banking</title>
        <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">

        <!-- Premium Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet">

        <!-- Icons & Global Stylesheet -->
        <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">

        <style>
            :root {
                --font-display: 'Outfit', sans-serif;
                --accent-gold: linear-gradient(135deg, #ffe875 0%, #f7c844 50%, #b88f14 100%);
                --glass-bg: rgba(255, 255, 255, 0.75);
                --glass-border: rgba(99, 102, 241, 0.12);
                --card-glow: rgba(99, 102, 241, 0.08);
            }

            body {
                font-family: 'Poppins', sans-serif;
                overflow-x: hidden;
                background-color: #f8fafc !important;
                color: #334155 !important;
            }

            h1,
            h2,
            h3,
            h4,
            .logo-text,
            .display-font {
                font-family: var(--font-display);
            }

            /* --- STICKY GLASSMORPHIC HEADER --- */
            .header {
                background: rgba(255, 255, 255, 0.75) !important;
                backdrop-filter: blur(25px) saturate(180%);
                -webkit-backdrop-filter: blur(25px) saturate(180%);
                border-bottom: 1px solid rgba(99, 102, 241, 0.08) !important;
                box-shadow: 0 4px 30px rgba(0, 0, 0, 0.02);
                padding: 20px 50px;
                transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            }

            .header.scrolled {
                background: rgba(255, 255, 255, 0.9) !important;
                padding: 14px 50px;
                border-bottom-color: rgba(99, 102, 241, 0.15) !important;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            }

            .logo img {
                height: 40px;
                width: auto;
                transition: transform var(--transition-normal);
            }

            .logo:hover img {
                transform: scale(1.03);
            }

            .navbar a {
                font-weight: 600;
                color: var(--gray-600) !important;
                margin-left: 30px;
                transition: all var(--transition-fast);
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .navbar a i {
                font-size: 1.1rem;
            }

            .navbar a:hover,
            .navbar a.active {
                color: var(--primary-600) !important;
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
                opacity: 0.18;
                animation: blobFloat 14s infinite alternate ease-in-out;
            }

            .glow-blob-1 {
                width: 450px;
                height: 450px;
                background: radial-gradient(circle, var(--primary-300) 0%, transparent 70%);
                top: -100px;
                right: -50px;
            }

            .glow-blob-2 {
                width: 500px;
                height: 500px;
                background: radial-gradient(circle, var(--secondary-300) 0%, transparent 70%);
                bottom: -150px;
                left: -100px;
                animation-delay: -5s;
            }

            .glow-blob-3 {
                width: 350px;
                height: 350px;
                background: radial-gradient(circle, var(--accent-cyan) 0%, transparent 70%);
                top: 40%;
                left: 30%;
                animation-delay: -9s;
            }

            @keyframes blobFloat {
                0% {
                    transform: translate(0, 0) scale(1);
                }

                50% {
                    transform: translate(40px, -60px) scale(1.15);
                }

                100% {
                    transform: translate(-20px, 20px) scale(0.9);
                }
            }

            /* --- HERO CONTAINER & GRID --- */
            .bank-hero {
                position: relative;
                padding: 150px 0 100px;
                z-index: 2;
                background: #f8fafc !important;
            }

            .hero-text .name {
                font-size: 3.8rem;
                font-weight: 900;
                letter-spacing: -1.5px;
                margin-bottom: 15px;
                line-height: 1.05;
                color: var(--gray-900) !important;
            }

            .hero-text .highlight {
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .hero-text .greeting {
                background: rgba(99, 102, 241, 0.05);
                border: 1px solid rgba(99, 102, 241, 0.1);
                padding: 8px 16px;
                border-radius: 50px;
                font-size: 0.85rem;
                color: var(--primary-600);
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 25px;
                font-weight: 600;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }

            .typing-wrapper {
                font-size: 1.6rem;
                font-weight: 700;
                color: var(--gray-800) !important;
                margin-bottom: 25px;
                font-family: var(--font-display);
            }

            .typed-text {
                color: var(--primary-600);
                border-right: 3px solid var(--primary-600);
                padding-right: 5px;
                animation: caretBlink 0.8s step-end infinite;
            }

            @keyframes caretBlink {

                from,
                to {
                    border-color: transparent
                }

                50% {
                    border-color: var(--primary-600);
                }
            }

            /* --- STATS COUNTER BLOCKS --- */
            .hero-stats {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin: 40px 0;
                padding: 24px;
                background: rgba(255, 255, 255, 0.5);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1.5px solid var(--glass-border);
                border-radius: var(--radius-lg);
                box-shadow: 0 8px 32px rgba(99, 102, 241, 0.03);
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
                right: -10px;
                top: 20%;
                height: 60%;
                width: 1px;
                background: var(--glass-border);
            }

            .hero-stats .stat-number {
                font-size: 2.2rem;
                font-weight: 800;
                font-family: var(--font-display);
                background: linear-gradient(135deg, var(--gray-900) 0%, var(--primary-700) 100%);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                margin-bottom: 4px;
            }

            .hero-stats .stat-label {
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: var(--gray-600);
                font-weight: 600;
            }

            /* --- PREMIUM 3D BANK CARD VISUALIZER --- */
            .bank-card-container {
                perspective: 2000px;
                position: relative;
            }

            .bank-card {
                width: 100%;
                max-width: 440px;
                height: 270px;
                background: linear-gradient(135deg, #090e1a 0%, #030408 100%);
                border: 1px solid rgba(212, 175, 55, 0.25);
                border-radius: 20px;
                padding: 30px;
                box-shadow: 0 30px 60px rgba(0, 0, 0, 0.15), inset 0 1px 2px rgba(255, 255, 255, 0.15);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                position: relative;
                overflow: hidden;
                transform-style: preserve-3d;
                transform: rotateX(12deg) rotateY(-12deg);
                transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1), box-shadow 0.3s ease;
                cursor: pointer;
            }

            .bank-card:hover {
                transform: rotateX(8deg) rotateY(-4deg) translateY(-8px);
                box-shadow: 0 40px 80px rgba(99, 102, 241, 0.15), inset 0 1px 2px rgba(255, 255, 255, 0.25);
            }

            /* Card Shimmer */
            .bank-card::after {
                content: '';
                position: absolute;
                inset: 0;
                background: linear-gradient(125deg, transparent 40%, rgba(255, 255, 255, 0.12) 48%, rgba(255, 255, 255, 0.25) 50%, rgba(255, 255, 255, 0.12) 52%, transparent 60%);
                pointer-events: none;
                z-index: 1;
            }

            .bank-card-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                z-index: 5;
                background: transparent;
            }

            .bank-card-logo-container {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .bank-name-text {
                font-family: var(--font-display);
                font-weight: 800;
                font-size: 0.85rem;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                color: #ffffff;
            }

            .bank-card-chip {
                background: transparent;
            }

            .bank-card-number {
                display: flex !important;
                flex-direction: row !important;
                align-items: center !important;
                justify-content: flex-start !important;
                gap: 12px !important;
                margin: 25px 0 15px;
                z-index: 5;
                background: transparent;
            }

            .bank-card-number .dots {
                font-size: 1.4rem !important;
                letter-spacing: 4px !important;
                color: rgba(255, 255, 255, 0.85) !important;
                line-height: 1 !important;
                white-space: nowrap !important;
            }

            .bank-card-number .digits {
                font-size: 1.4rem !important;
                color: var(--white) !important;
                font-family: var(--font-display) !important;
                letter-spacing: 2px !important;
                line-height: 1 !important;
                white-space: nowrap !important;
            }


            .bank-card-bottom {
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
                z-index: 5;
                background: transparent;
            }

            .bank-card-bottom span {
                font-size: 0.65rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                color: rgba(255, 255, 255, 0.6);
                font-weight: 500;
            }

            .vgb-gradient-logo {
                font-family: var(--font-display);
                font-weight: 900;
                font-size: 1.4rem;
                letter-spacing: 1px;
                background: var(--accent-gold);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            /* Floating Interactive Icons */
            .floating-icons .float-icon {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.6);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(99, 102, 241, 0.15);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--primary-600);
                font-size: 1.3rem;
                position: absolute;
                z-index: 6;
                box-shadow: 0 10px 25px rgba(99, 102, 241, 0.08);
                animation: floatUpDown 6s ease-in-out infinite;
                cursor: default;
            }

            .floating-icons .float-icon:nth-child(1) {
                top: -20px;
                left: -10px;
                animation-delay: 0s;
                color: var(--primary-600);
            }

            .floating-icons .float-icon:nth-child(2) {
                top: 70px;
                right: -25px;
                animation-delay: -1.5s;
                color: var(--secondary-600);
            }

            .floating-icons .float-icon:nth-child(3) {
                bottom: -20px;
                left: 60px;
                animation-delay: -3s;
                color: var(--accent-cyan);
            }

            .floating-icons .float-icon:nth-child(4) {
                bottom: 80px;
                left: -30px;
                animation-delay: -4.5s;
                color: var(--accent-emerald);
            }

            @keyframes floatUpDown {

                0%,
                100% {
                    transform: translateY(0) rotate(0deg);
                }

                50% {
                    transform: translateY(-15px) rotate(10deg);
                }
            }

            .experience-badge {
                background: rgba(255, 255, 255, 0.7) !important;
                backdrop-filter: blur(25px);
                -webkit-backdrop-filter: blur(25px);
                border: 1.5px solid var(--glass-border) !important;
                border-radius: var(--radius-lg);
                padding: 18px 24px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
                color: var(--gray-700) !important;
                position: absolute;
                bottom: -30px;
                right: 20px;
                z-index: 7;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .experience-badge .years {
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                font-family: var(--font-display);
                font-weight: 800;
                font-size: 2rem;
                line-height: 1;
            }

            .experience-badge .text {
                font-size: 0.75rem;
                font-weight: 600;
                color: var(--gray-600);
                line-height: 1.25;
            }

            /* --- ABOUT & CEO FLIPPABLE CARD REDESIGN --- */
            .about {
                position: relative;
                padding: 100px 0;
                z-index: 2;
                background: #ffffff !important;
                border-top: 1px solid var(--glass-border);
                border-bottom: 1px solid var(--glass-border);
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
                border-radius: 20px;
                box-shadow: 0 20px 45px rgba(0, 0, 0, 0.08);
                overflow: hidden;
            }

            /* FRONT SIDE */
            .flip-card-front {
                background: rgba(255, 255, 255, 0.8) !important;
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(99, 102, 241, 0.15);
                color: var(--gray-800);
                display: flex;
                z-index: 2;
                transform: rotateY(0deg);
            }

            .ceo-card-left {
                flex: 1.35;
                padding: 28px 24px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                background: transparent;
            }

            .ceo-profile-info {
                border-bottom: 1px solid rgba(0, 0, 0, 0.08);
                padding-bottom: 12px;
                margin-bottom: 12px;
            }

            .ceo-name {
                font-size: 1.5rem;
                font-weight: 800;
                color: var(--gray-900) !important;
                line-height: 1.1;
                letter-spacing: -0.5px;
            }

            .ceo-title {
                font-size: 0.72rem;
                font-weight: 700;
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-top: 4px;
                display: inline-block;
            }

            .ceo-contact-list {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .ceo-contact-item {
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 0.78rem;
                color: var(--gray-600);
            }

            .ceo-contact-icon {
                width: 28px;
                height: 28px;
                background: rgba(99, 102, 241, 0.06);
                color: var(--primary-600);
                border: 1px solid rgba(99, 102, 241, 0.15);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.85rem;
                flex-shrink: 0;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02);
            }

            .ceo-card-right {
                flex: 0.85;
                background: #09122c !important;
                border-left: 1.5px solid rgba(212, 175, 55, 0.2);
                position: relative;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 20px;
                overflow: hidden;
            }

            .ceo-front-logo-block {
                z-index: 3;
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 6px;
            }

            .ceo-front-logo-block h4 {
                font-size: 0.7rem;
                font-weight: 800;
                letter-spacing: 1px;
                color: #ffffff;
                text-transform: uppercase;
            }

            .ceo-front-logo-block span {
                font-size: 0.5rem;
                letter-spacing: 2px;
                color: #f7c844;
                border: 1px solid rgba(247, 200, 68, 0.3);
                border-radius: 3px;
                padding: 2px 6px;
            }

            /* BACK SIDE */
            .flip-card-back {
                background: #09122c !important;
                transform: rotateY(180deg);
                border: 1.5px solid rgba(212, 175, 55, 0.25);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .ceo-back-content {
                width: 100%;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                gap: 15px;
                padding: 30px;
            }

            .ceo-back-logo-section {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 8px;
            }

            .ceo-back-logo-section .vg-orbit-logo {
                width: 70px;
                height: 70px;
            }

            .ceo-back-title {
                font-family: var(--font-display);
                font-size: 1.4rem;
                font-weight: 800;
                letter-spacing: 1px;
                color: #ffffff;
            }

            .ceo-back-sub {
                font-size: 0.7rem;
                letter-spacing: 3px;
                background: var(--accent-gold);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                text-transform: uppercase;
                font-weight: 700;
            }

            .ceo-back-web {
                font-size: 0.75rem;
                font-weight: 700;
                color: var(--primary-300) !important;
                letter-spacing: 0.5px;
                border-bottom: 1px dashed var(--primary-300);
                padding-bottom: 2px;
                margin-top: 10px;
                text-decoration: none;
            }

            .ceo-back-web:hover {
                color: #ffffff !important;
                border-bottom-color: #ffffff;
            }

            /* --- SERVICES CARD GRID REDESIGN --- */
            .services {
                position: relative;
                padding: 100px 0;
                z-index: 2;
                background: #f8fafc !important;
            }

            .services-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 30px;
                margin-top: 50px;
            }

            @media (max-width: 991px) {
                .services-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 575px) {
                .services-grid {
                    grid-template-columns: 1fr;
                }
            }

            .service-card {
                background: rgba(255, 255, 255, 0.65) !important;
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid var(--glass-border) !important;
                border-radius: var(--radius-lg);
                padding: 35px 30px;
                box-shadow: 0 10px 30px rgba(99, 102, 241, 0.02);
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
                border-color: rgba(99, 102, 241, 0.25) !important;
                background: rgba(255, 255, 255, 0.95) !important;
                box-shadow: 0 20px 45px rgba(99, 102, 241, 0.08);
            }

            .service-card:hover::before {
                opacity: 1;
            }

            .service-card .card-icon {
                width: 50px;
                height: 50px;
                background: rgba(99, 102, 241, 0.05);
                border: 1px solid rgba(99, 102, 241, 0.12);
                border-radius: var(--radius-md);
                color: var(--primary-600);
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 24px;
                box-shadow: 0 4px 10px rgba(99, 102, 241, 0.01);
                transition: all var(--transition-fast);
            }

            .service-card:hover .card-icon {
                background: var(--gradient-primary);
                color: white;
                border-color: transparent;
            }

            .service-card h3 {
                font-size: 1.25rem;
                font-weight: 700;
                color: var(--gray-900) !important;
                margin-bottom: 12px;
            }

            .service-card p {
                font-size: 0.85rem;
                color: var(--gray-600) !important;
                line-height: 1.6;
                margin-bottom: 20px;
                flex-grow: 1;
            }

            .service-card .card-tags {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            .service-card .card-tags span {
                font-size: 0.7rem;
                font-weight: 600;
                background: rgba(99, 102, 241, 0.04);
                border: 1px solid rgba(99, 102, 241, 0.08);
                color: var(--gray-500);
                padding: 4px 10px;
                border-radius: 4px;
            }

            /* --- PORTAL ACCESS SECTION REDESIGN --- */
            .bank-login-section {
                position: relative;
                padding: 120px 0 !important;
                z-index: 2;
                background: #ffffff !important;
                border-top: 1.5px solid var(--glass-border);
                border-bottom: 1.5px solid var(--glass-border);
            }

            .bank-login-section::before {
                content: '';
                position: absolute;
                top: 20%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 600px;
                height: 300px;
                background: radial-gradient(circle, rgba(99, 102, 241, 0.05) 0%, transparent 75%);
                pointer-events: none;
                z-index: 0;
            }

            .bank-login-section .subtitle {
                color: var(--primary-600) !important;
                text-shadow: none;
            }

            .bank-login-section .heading {
                color: var(--gray-900) !important;
                font-size: 2.6rem !important;
                font-weight: 800 !important;
                letter-spacing: -0.5px;
            }

            .bank-login-section .heading .highlight {
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%) !important;
                -webkit-background-clip: text !important;
                background-clip: text !important;
                -webkit-text-fill-color: transparent !important;
            }

            .bank-login-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 40px;
                margin-top: 50px;
                position: relative;
                z-index: 1;
            }

            @media (max-width: 767px) {
                .bank-login-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }
            }

            .bank-login-card {
                background: rgba(255, 255, 255, 0.75) !important;
                backdrop-filter: blur(25px);
                -webkit-backdrop-filter: blur(25px);
                border: 1px solid var(--glass-border) !important;
                border-radius: 24px;
                padding: 45px 40px !important;
                box-shadow: 0 15px 35px rgba(99, 102, 241, 0.03) !important;
                transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1) !important;
                display: flex;
                flex-direction: column;
                gap: 15px;
                position: relative;
                overflow: hidden;
                text-align: left;
                text-decoration: none;
            }

            .bank-login-card::after {
                content: '';
                position: absolute;
                right: -60px;
                bottom: -60px;
                width: 180px;
                height: 180px;
                border-radius: 50%;
                filter: blur(50px);
                opacity: 0.06;
                transition: all 0.4s ease;
            }

            .bank-login-card:nth-child(1)::after {
                background: var(--primary-500);
            }

            .bank-login-card:nth-child(2)::after {
                background: var(--secondary-500);
            }

            .bank-login-card:hover {
                transform: translateY(-8px);
                border-color: rgba(99, 102, 241, 0.25) !important;
                background: rgba(255, 255, 255, 0.95) !important;
                box-shadow: 0 25px 50px rgba(99, 102, 241, 0.08) !important;
            }

            .bank-login-card:hover::after {
                opacity: 0.1;
                transform: scale(1.2);
            }

            .bank-login-card .icon-wrapper {
                width: 60px;
                height: 60px;
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2rem;
                margin-bottom: 8px;
                transition: transform 0.4s ease;
            }

            .bank-login-card:nth-child(1) .icon-wrapper {
                background: rgba(99, 102, 241, 0.05);
                border: 1px solid rgba(99, 102, 241, 0.12);
                color: var(--primary-600);
                box-shadow: 0 4px 10px rgba(99, 102, 241, 0.01);
            }

            .bank-login-card:nth-child(2) .icon-wrapper {
                background: rgba(236, 72, 153, 0.05);
                border: 1px solid rgba(236, 72, 153, 0.12);
                color: var(--secondary-600);
                box-shadow: 0 4px 10px rgba(236, 72, 153, 0.01);
            }

            .bank-login-card:hover .icon-wrapper {
                transform: scale(1.08) rotate(5deg);
            }

            .bank-login-card:nth-child(1):hover .icon-wrapper {
                background: var(--gradient-primary);
                color: white;
                border-color: transparent;
            }

            .bank-login-card:nth-child(2):hover .icon-wrapper {
                background: linear-gradient(135deg, var(--secondary-500) 0%, var(--secondary-600) 100%);
                color: white;
                border-color: transparent;
            }

            .bank-login-card h3 {
                font-size: 1.5rem;
                font-weight: 800;
                color: var(--gray-900) !important;
                margin: 0;
            }

            .bank-login-card p {
                font-size: 0.9rem;
                color: var(--gray-600) !important;
                line-height: 1.6;
                margin: 0;
            }

            .bank-login-card span {
                font-size: 0.85rem;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 6px;
                margin-top: 10px;
                transition: gap var(--transition-fast);
            }

            .bank-login-card:nth-child(1) span {
                color: var(--primary-600);
            }

            .bank-login-card:nth-child(2) span {
                color: var(--secondary-600);
            }

            .bank-login-card:hover span {
                gap: 10px;
            }

            /* --- SCROLL MOUSE INDICATOR --- */
            .scroll-indicator {
                bottom: 30px;
                text-decoration: none;
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%) !important;
                color: white !important;
                box-shadow: 0 4px 15px rgba(79, 70, 229, 0.2);
                transition: all var(--transition-normal) !important;
                border: none !important;
                font-weight: 600;
                padding: 12px 24px;
                border-radius: var(--radius-md);
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
                background: linear-gradient(135deg, var(--primary-500) 0%, var(--primary-600) 100%) !important;
            }

            .btn-primary i {
                transition: transform var(--transition-fast);
            }

            .btn-primary:hover i {
                transform: translateX(4px);
            }

            .btn-secondary {
                background: white !important;
                border: 1.5px solid var(--gray-200) !important;
                color: var(--gray-700) !important;
                transition: all var(--transition-normal) !important;
                font-weight: 600;
                padding: 12px 24px;
                border-radius: var(--radius-md);
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-secondary:hover {
                border-color: var(--primary-500) !important;
                color: var(--primary-600) !important;
                background: rgba(99, 102, 241, 0.02) !important;
                transform: translateY(-2px);
            }

            /* --- WHITE THEME FOOTER OVERRIDES --- */
            .footer {
                background: #f8fafc !important;
                border-top: 1px solid rgba(99, 102, 241, 0.08) !important;
                padding: 50px 0 20px !important;
            }

            .footer .footer-logo span {
                font-family: var(--font-display);
                font-weight: 800;
                font-size: 1.4rem;
                color: var(--gray-900) !important;
            }

            .footer .footer-links a {
                color: var(--gray-600) !important;
                font-size: 0.9rem;
                text-decoration: none;
                transition: color var(--transition-fast) !important;
            }

            .footer .footer-links a:hover {
                color: var(--primary-600) !important;
            }

            .footer .footer-bottom {
                border-top: 1px solid rgba(99, 102, 241, 0.08) !important;
            }

            .footer .footer-bottom p {
                color: var(--gray-500) !important;
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

        <!-- Glowing Background Blobs -->
        <div class="glow-blobs-container">
            <div class="glow-blob glow-blob-1"></div>
            <div class="glow-blob glow-blob-2"></div>
            <div class="glow-blob glow-blob-3"></div>
        </div>

        <!-- Header Navigation -->
        <header class="header">
            <a href="#home" class="logo" aria-label="Vertex Galaxy Bank Home"
                style="display: flex; align-items: center; text-decoration: none;">
            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>

            <nav class="navbar" aria-label="Main navigation">
                <a href="#home" class="active"><i class="bx bx-home"></i> Home</a>
                <a href="#about"><i class="bx bx-info-circle"></i> About</a>
                <a href="#services"><i class="bx bx-grid-alt"></i> Services</a>
                <a href="#login"><i class="bx bx-log-in-circle"></i> Login</a>
            </nav>

            <div class="nav-actions">
                <button class="mobile-menu-btn" type="button" aria-label="Open menu">
                    <i class="bx bx-menu"></i>
                </button>
            </div>
        </header>

        <main>
            <!-- Hero Section -->
            <section class="home bank-hero" id="home">
                <div class="container">
                    <div class="home-content">
                        <div class="hero-text">
                            <p class="greeting">
                                <i class="bx bx-shield-quarter"></i>
                                Secure digital banking systems active
                            </p>
                            <h1 class="name">
                                Vertex Galaxy <span class="highlight">Bank</span>
                            </h1>
                            <div class="typing-wrapper">
                                <span>Elevated <span class="typed-text"></span></span>
                            </div>
                            <p class="hero-description"
                                style="color: var(--gray-600); line-height: 1.7; font-size: 0.95rem; margin-bottom: 25px;">
                                Manage your accounts, route secure funds transfers, audit real-time statements, and
                                request loan approvals from one integrated, high-security digital banking dashboard.
                            </p>

                            <div class="hero-stats" aria-label="Bank highlights">
                                <div class="stat">
                                    <span class="stat-number" data-target="24">24</span>
                                    <span class="stat-label">Hours Access</span>
                                </div>
                                <div class="stat">
                                    <span class="stat-number" data-target="100">100%</span>
                                    <span class="stat-label">Secured Systems</span>
                                </div>
                                <div class="stat">
                                    <span class="stat-number" data-target="6">6</span>
                                    <span class="stat-label">Core Modules</span>
                                </div>
                            </div>

                            <div class="hero-btns">
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary">
                                    <span>Access Secure Portal</span>
                                    <i class="bx bx-right-arrow-alt" style="font-size: 1.25rem;"></i>
                                </a>
                            </div>
                        </div>

                        <!-- Right Column: Interactive 3D Bank Card visualizer -->
                        <div class="home-img bank-visual" aria-label="Digital banking overview">
                            <div class="img-wrapper bank-card-wrapper" style="border: none;">
                                <div class="img-border" style="display: none;"></div>
                                <div class="bank-card-container">
                                    <div class="bank-card">
                                        <div class="bank-card-top">
                                            <div class="bank-card-logo-container">
                                                <img src="${pageContext.request.contextPath}/assest/images/image.png" class="vg-orbit-logo" alt="VGB Logo" style="width: 32px; height: 32px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));">
                                                <span class="bank-name-text">Vertex Galaxy Bank</span>
                                            </div>
                                            <svg class="bank-card-chip" viewBox="0 0 100 80" width="45" height="36"
                                                xmlns="http://www.w3.org/2000/svg">
                                                <rect x="5" y="5" width="90" height="70" rx="10"
                                                    fill="url(#chipGoldGradIndexRedesigned)" stroke="#b59410"
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
                                                    <linearGradient id="chipGoldGradIndexRedesigned" x1="0%" y1="0%"
                                                        x2="100%" y2="100%">
                                                        <stop offset="0%" stop-color="#ffe875" />
                                                        <stop offset="50%" stop-color="#f7c844" />
                                                        <stop offset="100%" stop-color="#b88f14" />
                                                    </linearGradient>
                                                </defs>
                                            </svg>
                                        </div>
                                        <div class="bank-card-number">
                                            <span class="dots">•••• &nbsp; •••• &nbsp; ••••</span>
                                            <span class="digits">2190</span>
                                        </div>
                                        <div class="bank-card-bottom">
                                            <span>Infinite Digital Account</span>
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
                                <span class="text">Instant Ledger<br>Update</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Scroll Indicator mouse -->
                <a href="#about" class="scroll-indicator" aria-label="Scroll to about section">
                    <span>Scroll Down</span>
                    <span class="mouse"><span class="wheel"></span></span>
                </a>
            </section>

            <!-- About Section -->
            <section class="about" id="about">
                <div class="container">
                    <div class="section-header" style="text-align: center;">
                        <span class="subtitle"
                            style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Corporate
                            Profile</span>
                        <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">
                            Reliable Banking, <span class="highlight">Uncompromised Access</span></h2>
                    </div>

                    <div class="about-content"
                        style="margin-top: 50px; display: grid; grid-template-columns: 1fr 1fr; gap: 80px; align-items: center;">
                        <!-- Left: Interactive flippable CEO Card -->
                        <div class="about-img bank-about-panel">
                            <div class="ceo-card-container" id="ceoCard">
                                <div class="flip-card-inner">
                                    <!-- FRONT -->
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
                                                    <span>hello@vertexgalaxybank.com</span>
                                                </div>
                                                <div class="ceo-contact-item">
                                                    <div class="ceo-contact-icon"><i class="bx bx-map"></i></div>
                                                    <span>123 Security Blvd, Cyber City</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ceo-card-right">
                                            <div class="ceo-front-logo-block">
                                                <img src="${pageContext.request.contextPath}/assest/images/image.png" class="vg-orbit-logo" alt="VGB Logo" style="width: 36px; height: 36px; object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));">
                                                <h4 style="margin: 0; font-size: 0.62rem; color: #ffffff;">Vertex Galaxy
                                                </h4>
                                                <span>Bank</span>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- BACK -->
                                    <div class="flip-card-back">
                                        <div class="ceo-back-content">
                                            <div class="ceo-back-logo-section">
                                                <img src="${pageContext.request.contextPath}/assest/images/image.png" class="vg-orbit-logo" alt="VGB Logo" style="object-fit: contain; filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));">
                                                <div class="ceo-back-title">Vertex Galaxy</div>
                                                <div class="ceo-back-sub">Bank</div>
                                            </div>
                                            <a href="https://www.vertexgalaxybank.com" class="ceo-back-web"
                                                target="_blank"
                                                onclick="event.stopPropagation();">www.vertexgalaxybank.com</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right: About Descriptions -->
                        <div class="about-text">
                            <h3
                                style="color: var(--gray-900); font-size: 1.6rem; font-weight: 700; margin-bottom: 15px;">
                                Tailored workflows for customers and bank administrators</h3>
                            <p
                                style="color: var(--gray-600); margin-bottom: 15px; font-size: 0.9rem; line-height: 1.7;">
                                Vertex Galaxy Bank provides an integrated digital environment designed to handle account
                                profiles, balances, and cash transactions. Customers can view savings/current accounts,
                                execute funds transfers, request cheque books, download offline passbooks, and track
                                loans from their secure dashboard.
                            </p>
                            <p
                                style="color: var(--gray-600); margin-bottom: 25px; font-size: 0.9rem; line-height: 1.7;">
                                Bank administrators have access to an internal administrative workspace where they can
                                monitor register records, approve loan portfolios, issue checkbook leaves, and post
                                cashier deposits directly.
                            </p>

                            <div class="about-info"
                                style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 30px;">
                                <div class="info-item"
                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                    <i class="bx bx-user-check"
                                        style="font-size: 1.25rem; color: var(--primary-600);"></i>
                                    <span>Customer: <strong>Digital Workspaces</strong></span>
                                </div>
                                <div class="info-item"
                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                    <i class="bx bx-shield-alt-2"
                                        style="font-size: 1.25rem; color: var(--primary-600);"></i>
                                    <span>Admin: <strong>Security Approvals</strong></span>
                                </div>
                                <div class="info-item"
                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                    <i class="bx bx-wallet" style="font-size: 1.25rem; color: var(--primary-600);"></i>
                                    <span>Ledger: <strong>Automatic Updates</strong></span>
                                </div>
                                <div class="info-item"
                                    style="display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--gray-700);">
                                    <i class="bx bx-file" style="font-size: 1.25rem; color: var(--primary-600);"></i>
                                    <span>Auditing: <strong>Passbooks &amp; Statements</strong></span>
                                </div>
                            </div>

                            <div class="about-btns" style="display: flex; gap: 15px;">
                                <a href="#services" class="btn-primary">Explore Services <i
                                        class="bx bx-down-arrow-alt"></i></a>
                                <a href="${pageContext.request.contextPath}/login" class="btn-secondary">Access Banking
                                    Portal</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Services Section -->
            <section class="services" id="services">
                <div class="container">
                    <div class="section-header" style="text-align: center;">
                        <span class="subtitle"
                            style="display: block; color: var(--primary-600); text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Product
                            Offerings</span>
                        <h2 class="heading" style="color: var(--gray-900); font-size: 2.5rem; font-weight: 800;">Banking
                            Capabilities <span class="highlight">Built-in</span></h2>
                    </div>

                    <div class="services-grid">
                        <article class="service-card">
                            <div class="card-icon"><i class="bx bx-wallet-alt"></i></div>
                            <h3>Account Management</h3>
                            <p>View accounts, monitor real-time balances, view transactions, and track savings vs.
                                current profiles dynamically.</p>
                            <div class="card-tags"><span>Accounts</span><span>Balances</span></div>
                        </article>

                        <article class="service-card">
                            <div class="card-icon"><i class="bx bx-transfer-alt"></i></div>
                            <h3>Fast Wire Routing</h3>
                            <p>Transfer money to target accounts instantly through a high-speed bank routing system with
                                verification audits.</p>
                            <div class="card-tags"><span>Transfers</span><span>Payments</span></div>
                        </article>

                        <article class="service-card">
                            <div class="card-icon"><i class="bx bx-file-find"></i></div>
                            <h3>Auditing &amp; Statements</h3>
                            <p>Track historical transaction records, query ledger ranges, and generate detailed PDF
                                statement printouts.</p>
                            <div class="card-tags"><span>History</span><span>Statements</span></div>
                        </article>

                        <article class="service-card">
                            <div class="card-icon"><i class="bx bx-building-house"></i></div>
                            <h3>Review &amp; Loan Approvals</h3>
                            <p>Apply for customizable loan products (Housing, Personal, Vehicle) and track
                                administrative approval progress.</p>
                            <div class="card-tags"><span>Loans</span><span>Approvals</span></div>
                        </article>

                        <article class="service-card">
                            <div class="card-icon"><i class="bx bx-bell"></i></div>
                            <h3>Security Notifications</h3>
                            <p>Stay informed with automated transaction alerts, password modifications, and registration
                                validations.</p>
                            <div class="card-tags"><span>Alerts</span><span>System Updates</span></div>
                        </article>

                        <article class="service-card">
                            <div class="card-icon"><i class="bx bx-id-card"></i></div>
                            <h3>Secure Profiles</h3>
                            <p>Update personal profiles, verify identity credentials, and edit passwords and transaction
                                PIN records securely.</p>
                            <div class="card-tags"><span>Profiles</span><span>Credentials</span></div>
                        </article>
                    </div>
                </div>
            </section>

            <!-- Portal Entry Points -->
            <section class="contact bank-login-section" id="login">
                <div class="container">
                    <div class="section-header" style="text-align: center; margin-bottom: 50px;">
                        <span class="subtitle"
                            style="display: block; text-transform: uppercase; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 8px;">Portal
                            Gates</span>
                        <h2 class="heading">Secure Identity <span class="highlight">Login</span></h2>
                    </div>

                    <div class="bank-login-grid">
                        <a href="${pageContext.request.contextPath}/login" class="bank-login-card">
                            <div class="icon-wrapper">
                                <i class="bx bx-user-circle"></i>
                            </div>
                            <h3>Customer Portal</h3>
                            <p>Enter the customer gateway to check profiles, initiate transfers, request
                                passbooks/cheques, and verify loan files.</p>
                            <span>Access Client Portal <i class="bx bx-right-arrow-alt"></i></span>
                        </a>

                        <a href="${pageContext.request.contextPath}/login" class="bank-login-card">
                            <div class="icon-wrapper">
                                <i class="bx bx-shield-quarter"></i>
                            </div>
                            <h3>Administrative Desk</h3>
                            <p>Enter the root systems administration gate to monitor registries, post deposits, review
                                cheque books, and audit loans.</p>
                            <span>Access Administrator Portal <i class="bx bx-right-arrow-alt"></i></span>
                        </a>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content"
                    style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                    <div class="footer-logo">
                        <span>Vertex Galaxy <span
                                style="background: linear-gradient(135deg, var(--primary-600) 0%, var(--secondary-600) 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">Bank</span></span>
                    </div>
                    <div class="footer-links" style="display: flex; gap: 30px;">
                        <a href="#home">Home</a>
                        <a href="#about">About</a>
                        <a href="#services">Services</a>
                        <a href="${pageContext.request.contextPath}/login">Portal Access</a>
                    </div>
                </div>
                <div class="footer-bottom" style="text-align: center; margin-top: 40px; padding-top: 20px;">
                    <p style="font-size: 0.8rem;">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Secured
                        and encrypted digital banking systems.</p>
                </div>
            </div>
        </footer>

        <!-- Scroll to Top button -->
        <button class="scroll-top" id="scrollTop" type="button" aria-label="Scroll to top">
            <i class="bx bx-up-arrow-alt"></i>
        </button>

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

            // Manual flip control for CEO Card
            const ceoCard = document.getElementById('ceoCard');
            if (ceoCard) {
                ceoCard.addEventListener('click', () => {
                    ceoCard.classList.toggle('flipped');
                });
            }

            // Dynamic counter animation for stats
            const statNumbers = document.querySelectorAll('.stat-number');
            statNumbers.forEach(stat => {
                const target = parseInt(stat.getAttribute('data-target'));
                let count = 0;
                const increment = target / 40; // speed
                const suffix = stat.textContent.includes('%') ? '%' : '';
                const updateCount = () => {
                    count += increment;
                    if (count < target) {
                        stat.textContent = Math.ceil(count) + suffix;
                        setTimeout(updateCount, 25);
                    } else {
                        stat.textContent = target + suffix;
                    }
                };

                // Simple IntersectionObserver to fire when stat is visible
                const observer = new IntersectionObserver((entries) => {
                    if (entries[0].isIntersecting) {
                        updateCount();
                        observer.disconnect();
                    }
                }, { threshold: 0.1 });
                observer.observe(stat);
            });
        </script>
    </body>

    </html>