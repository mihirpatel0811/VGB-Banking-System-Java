<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <% if (request.getAttribute("customer")==null) { Long customerId=null; Object
                sessionUser=session.getAttribute(com.vgb.constants.AppConstants.USER_SESSION_KEY); if (sessionUser
                !=null) { customerId=Long.parseLong(sessionUser.toString()); } if (customerId !=null) { try {
                com.vgb.model.Customer sessionCustomer=new
                com.vgb.service.CustomerService().getCustomerById(customerId); request.setAttribute("customer",
                sessionCustomer); } catch (Exception e) { e.printStackTrace(); } } } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>VGB | My Cards</title>
                    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
                    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
                    <style>
                        .sidebar {
                            width: 280px;
                            background: rgba(255, 255, 255, 0.9) !important;
                            backdrop-filter: blur(25px) saturate(180%) !important;
                            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
                            border-right: 1px solid rgba(99, 102, 241, 0.15) !important;
                            padding: 30px 20px;
                            position: fixed;
                            top: 80px;
                            bottom: 0;
                            left: 0;
                            z-index: 100;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
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

                        .footer {
                            margin-left: 280px;
                            background: white;
                            border-top: 1px solid rgba(99, 102, 241, 0.15);
                            padding: 20px 0;
                            transition: all 0.3s ease;
                        }

                        .mobile-nav-toggle {
                            display: none !important;
                        }

                        @media (max-width: 991px) {
                            .mobile-nav-toggle {
                                display: flex !important;
                            }

                            .sidebar {
                                left: -280px !important;
                                top: 80px;
                                height: calc(100vh - 80px);
                                z-index: 1000;
                            }

                            .sidebar.active {
                                left: 0 !important;
                            }

                            .main-content {
                                margin-left: 0 !important;
                                padding: 120px 20px 40px !important;
                            }

                            .footer {
                                margin-left: 0 !important;
                            }
                        }

                        .glass-card {
                            background: rgba(255, 255, 255, 0.75);
                            backdrop-filter: blur(25px);
                            -webkit-backdrop-filter: blur(25px);
                            border: 1px solid rgba(255, 255, 255, 0.6);
                            border-radius: var(--radius-lg);
                            padding: 28px;
                            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
                            transition: border-color 0.3s ease, box-shadow 0.3s ease;
                        }

                        .glass-card:hover {
                            border-color: rgba(99, 102, 241, 0.2);
                        }

                        .btn-logout {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            padding: 8px 20px;
                            font-size: 0.78rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            border-radius: var(--radius-full);
                            border: 1.5px solid rgba(99, 102, 241, 0.2) !important;
                            background: transparent;
                            color: var(--gray-700) !important;
                            transition: all var(--transition-normal);
                            cursor: pointer;
                            text-decoration: none;
                        }

                        .btn-logout:hover {
                            border-color: transparent !important;
                            background: var(--gradient-primary);
                            color: white !important;
                            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
                            transform: translateY(-1px);
                        }

                        .btn-logout i {
                            font-size: 1.05rem;
                            transition: transform var(--transition-fast);
                        }

                        .btn-logout:hover i {
                            transform: translateX(3px);
                        }

                        @media (max-width: 480px) {
                            .mobile-hide {
                                display: none !important;
                            }
                        }

                        /* 3D ATM CARD GRID LAYOUT */
                        .cards-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                            gap: 30px;
                            margin-bottom: 40px;
                        }

                        /* ATM CARD SCENE STYLING */
                        .card-3d-wrapper {
                            width: 340px;
                            height: 220px;
                            cursor: pointer;
                            margin-bottom: 20px;
                        }

                        .vgb-atm-card {
                            width: 100%;
                            height: 100%;
                            position: relative;
                            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1), box-shadow 0.3s ease;
                            border-radius: 20px;
                        }

                        .vgb-atm-card.flipped {
                            transform: rotateY(180deg);
                        }

                        .vgb-atm-card:hover {
                            box-shadow: 0 25px 45px rgba(99, 102, 241, 0.25);
                        }

                        .vgb-atm-card .card-face {
                            position: absolute;
                            inset: 0;
                            padding: 22px 25px;
                            backface-visibility: hidden;
                            border-radius: inherit;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                            border: 1.5px solid rgba(255, 255, 255, 0.15);
                            box-sizing: border-box;
                        }

                        .vgb-atm-card .card-front {
                            z-index: 2;
                        }

                        .vgb-atm-card.debit .card-front {
                            background: url('${pageContext.request.contextPath}/assest/images/debit card.png') no-repeat center/cover !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.15) !important;
                        }

                        .vgb-atm-card.credit .card-front {
                            background: url('${pageContext.request.contextPath}/assest/images/credit card.png') no-repeat center/cover !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.15) !important;
                        }

                        .vgb-atm-card .card-back {
                            transform: rotateY(180deg);
                            z-index: 1;
                            background: #080b11;
                        }

                        .vgb-atm-card.debit .card-back {
                            background: radial-gradient(circle at 50% 50%, #1e0a3d 0%, #0a0314 100%) !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.15) !important;
                        }

                        .vgb-atm-card.credit .card-back {
                            background: radial-gradient(circle at 50% 50%, #1a1612 0%, #080706 100%) !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.15) !important;
                        }

                        .vgb-atm-card.debit .card-front::before,
                        .vgb-atm-card.debit .card-front::after,
                        .vgb-atm-card.debit.premium-tier .card-front::before,
                        .vgb-atm-card.debit.premium-tier .card-front::after,
                        .vgb-atm-card.credit .card-front::before,
                        .vgb-atm-card.credit .card-front::after,
                        .vgb-atm-card.credit.premium-tier .card-front::before,
                        .vgb-atm-card.credit.premium-tier .card-front::after,
                        .vgb-atm-card.credit.visa .card-front::after,
                        .vgb-atm-card.credit.mastercard .card-front::after,
                        .vgb-atm-card.credit.rupay .card-front::after,
                        .vgb-atm-card.credit.visa.premium-tier .card-front::after {
                            display: none !important;
                        }

                        /* --- DEBIT & CREDIT CARD REDESIGN --- */
                        .vgb-atm-card.debit {
                            background: radial-gradient(circle at 80% 80%, #3a007c 0%, #080321 60%, #01000b 100%) !important;
                            box-shadow: 0 12px 30px rgba(58, 0, 124, 0.25) !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
                        }
                        .vgb-atm-card.debit.premium-tier {
                            background: repeating-linear-gradient(45deg, rgba(255,255,255,0.015) 0px, rgba(255,255,255,0.015) 1px, transparent 1px, transparent 8px), 
                                        linear-gradient(135deg, #1b1c21 0%, #0d0e11 100%) !important;
                            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.3) !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.3) !important;
                        }
                        
                        .vgb-atm-card.credit {
                            background: 
                                radial-gradient(circle at 75% 35%, rgba(212, 175, 55, 0.25) 0%, transparent 55%),
                                linear-gradient(to right, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                                linear-gradient(to bottom, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                                linear-gradient(135deg, #121316 0%, #08090a 100%) !important;
                            background-size: cover, 16px 16px, 16px 16px, cover;
                            box-shadow: 0 12px 30px rgba(124, 45, 18, 0.25) !important;
                            border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
                        }
                        .vgb-atm-card.credit.premium-tier {
                            background: radial-gradient(circle at 75% 35%, #18052b 0%, #030107 70%, #000000 100%) !important;
                            box-shadow: 0 12px 30px rgba(168, 85, 247, 0.25) !important;
                            border: 1.5px solid rgba(139, 92, 246, 0.3) !important;
                        }

                        /* Clear original provider-specific background overrides */
                        .vgb-atm-card.debit.visa, 
                        .vgb-atm-card.debit.visa.premium-tier, 
                        .vgb-atm-card.debit.mastercard, 
                        .vgb-atm-card.debit.rupay,
                        .vgb-atm-card.credit.visa, 
                        .vgb-atm-card.credit.visa.premium-tier, 
                        .vgb-atm-card.credit.mastercard, 
                        .vgb-atm-card.credit.rupay {
                            /* inherit from base card styles */
                        }

                        /* 3D orbits and decorative structures based on debit/credit card designs */
                        .vgb-atm-card.debit .card-front::before {
                            content: '';
                            position: absolute;
                            width: 250px;
                            height: 250px;
                            bottom: -90px;
                            right: -70px;
                            background: radial-gradient(circle, rgba(162, 23, 221, 0.45) 0%, rgba(93, 23, 221, 0.2) 45%, rgba(20, 10, 80, 0.05) 70%, transparent 80%);
                            border-radius: 50%;
                            transform: rotateX(65deg) rotateY(-15deg);
                            box-shadow: inset 0 0 50px rgba(162, 23, 221, 0.3), 0 0 60px rgba(162, 23, 221, 0.25);
                            pointer-events: none;
                            z-index: 1;
                        }
                        .vgb-atm-card.debit .card-front::after {
                            content: '';
                            position: absolute;
                            width: 190px;
                            height: 190px;
                            bottom: -60px;
                            right: -40px;
                            border: 1px dashed rgba(186, 85, 211, 0.35);
                            border-radius: 50%;
                            transform: rotateX(65deg) rotateY(-15deg);
                            box-shadow: 0 0 15px rgba(186, 85, 211, 0.25), inset 0 0 15px rgba(186, 85, 211, 0.15);
                            pointer-events: none;
                            z-index: 1;
                        }

                        .vgb-atm-card.debit.premium-tier .card-front::before {
                            content: '';
                            position: absolute;
                            width: 320px;
                            height: 180px;
                            bottom: -50px;
                            left: -50px;
                            border-top: 4px solid #a855f7;
                            border-right: 2px solid transparent;
                            border-radius: 50%;
                            transform: rotate(-12deg);
                            box-shadow: 0 -3px 12px rgba(168, 85, 247, 0.6);
                            filter: drop-shadow(0 0 6px #a855f7);
                            pointer-events: none;
                            z-index: 1;
                        }
                        .vgb-atm-card.debit.premium-tier .card-front::after {
                            content: '';
                            position: absolute;
                            width: 280px;
                            height: 150px;
                            bottom: -40px;
                            left: -40px;
                            border-top: 2px solid rgba(0, 210, 255, 0.6);
                            border-right: 2px solid transparent;
                            border-radius: 50%;
                            transform: rotate(-10deg);
                            box-shadow: 0 -3px 12px rgba(0, 210, 255, 0.4);
                            filter: drop-shadow(0 0 6px rgba(0, 210, 255, 0.4));
                            pointer-events: none;
                            z-index: 1;
                        }

                        .vgb-atm-card.credit .card-front::before {
                            content: '';
                            position: absolute;
                            width: 180px;
                            height: 180px;
                            top: 20px;
                            right: 20px;
                            border: 2px double #d4af37;
                            border-radius: 50%;
                            transform: rotateX(75deg) rotateY(-20deg);
                            box-shadow: 0 0 25px rgba(212, 175, 55, 0.6), inset 0 0 25px rgba(212, 175, 55, 0.3);
                            filter: drop-shadow(0 0 4px rgba(212, 175, 55, 0.5));
                            pointer-events: none;
                            z-index: 1;
                        }
                        .vgb-atm-card.credit .card-front::after {
                            content: '';
                            position: absolute;
                            width: 130px;
                            height: 130px;
                            top: 35px;
                            right: 40px;
                            border: 1px dashed rgba(212, 175, 55, 0.45);
                            border-radius: 50%;
                            transform: rotateX(75deg) rotateY(-20deg);
                            box-shadow: 0 0 15px rgba(212, 175, 55, 0.25);
                            pointer-events: none;
                            z-index: 1;
                        }

                        .vgb-atm-card.credit.premium-tier .card-front::before {
                            content: '';
                            position: absolute;
                            width: 180px;
                            height: 180px;
                            top: 20px;
                            right: 20px;
                            border: 2px double #a855f7;
                            border-radius: 50%;
                            transform: rotateX(75deg) rotateY(-20deg);
                            box-shadow: 0 0 25px rgba(168, 85, 247, 0.65), inset 0 0 25px rgba(168, 85, 247, 0.35);
                            filter: drop-shadow(0 0 4px rgba(168, 85, 247, 0.5));
                            pointer-events: none;
                            z-index: 1;
                        }
                        .vgb-atm-card.credit.premium-tier .card-front::after {
                            content: '';
                            position: absolute;
                            width: 130px;
                            height: 130px;
                            top: 35px;
                            right: 40px;
                            border: 1px dashed rgba(0, 210, 255, 0.4);
                            border-radius: 50%;
                            transform: rotateX(75deg) rotateY(-20deg);
                            box-shadow: 0 0 15px rgba(0, 210, 255, 0.25);
                            pointer-events: none;
                            z-index: 1;
                        }

                        /* Gold styled text for Royale credit card */
                        .vgb-atm-card.credit:not(.premium-tier) .card-number-display,
                        .vgb-atm-card.credit:not(.premium-tier) .holder-name,
                        .vgb-atm-card.credit:not(.premium-tier) .expiry-value,
                        .vgb-atm-card.credit:not(.premium-tier) .expiry-label {
                            color: #d4af37 !important;
                            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8) !important;
                        }
                        .vgb-atm-card.debit.visa .card-front::after,
                        .vgb-atm-card.debit.visa.premium-tier .card-front::after,
                        .vgb-atm-card.debit.mastercard .card-front::after,
                        .vgb-atm-card.debit.rupay .card-front::after,
                        .vgb-atm-card.credit.visa .card-front::after,
                        .vgb-atm-card.credit.visa.premium-tier .card-front::after,
                        .vgb-atm-card.credit.mastercard .card-front::after,
                        .vgb-atm-card.credit.rupay .card-front::after {
                            display: none !important; /* disable credit style backgrounds */
                        }

                        /* Toggle visual displays */
                        .vgb-atm-card.credit .debit-front-layout,
                        .vgb-atm-card.credit .debit-back-layout {
                            display: none !important;
                        }
                        .vgb-atm-card.debit .credit-front-layout,
                        .vgb-atm-card.debit .credit-back-layout {
                            display: none !important;
                        }

                        /* Debit & Credit Front Layout */
                        .debit-front-layout,
                        .credit-front-layout {
                            width: 100%;
                            height: 100%;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                            box-sizing: border-box;
                            z-index: 5;
                            position: relative;
                        }
                        .debit-header-right {
                            position: absolute;
                            top: 0px;
                            right: 0px;
                            display: flex;
                            flex-direction: column;
                            align-items: flex-end;
                            line-height: 1.1;
                        }
                        .debit-label-txt {
                            font-size: 0.65rem;
                            font-weight: 700;
                            color: rgba(255, 255, 255, 0.9);
                            letter-spacing: 1px;
                            text-transform: uppercase;
                        }
                        .contactless-icon-debit {
                            font-size: 1.25rem;
                            transform: rotate(90deg);
                            opacity: 0.8;
                            color: #ffffff;
                            margin-top: 4px;
                        }
                        .debit-chip-row {
                            margin-top: 15px;
                            display: flex;
                        }
                        .vgb-atm-card.debit .card-number-display.debit-number {
                            margin: 15px 0 5px;
                            text-align: left;
                            font-size: 1.2rem;
                            letter-spacing: 2.5px;
                            font-weight: 600;
                            color: #ffffff;
                            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.6);
                            font-family: 'Share Tech Mono', monospace;
                        }
                        .debit-expiry-row {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 6px;
                            margin-top: -5px;
                        }
                        .debit-expiry-row .expiry-label {
                            font-size: 0.35rem;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            opacity: 0.75;
                            color: #ffffff;
                            line-height: 1.1;
                            text-align: right;
                        }
                        .debit-expiry-row .expiry-value {
                            font-size: 0.8rem;
                            font-weight: 600;
                            color: #ffffff;
                            font-family: 'Share Tech Mono', monospace;
                        }
                        .debit-bottom-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-end;
                            margin-top: 5px;
                        }
                        .debit-bottom-row .holder-name.debit-holder {
                            font-size: 0.8rem;
                            font-weight: 500;
                            letter-spacing: 1px;
                            text-transform: uppercase;
                            color: #ffffff;
                            font-family: 'Poppins', sans-serif;
                        }
                        .debit-brand-logo-container {
                            display: flex;
                            align-items: flex-end;
                            height: 30px;
                        }

                        /* Visa Secure */
                        .brand-visa-secure {
                            display: flex;
                            flex-direction: column;
                            align-items: flex-end;
                            line-height: 0.95;
                        }
                        .brand-visa-secure .visa-secure-text {
                            font-family: 'Poppins', sans-serif;
                            font-size: 1.25rem;
                            font-weight: 800;
                            font-style: italic;
                            color: #ffffff;
                            letter-spacing: 0.5px;
                        }
                        .brand-visa-secure .visa-secure-sub {
                            font-size: 0.4rem;
                            font-weight: 700;
                            color: rgba(255, 255, 255, 0.8);
                            letter-spacing: 1.2px;
                            margin-top: -1px;
                        }

                        /* Mastercard ID */
                        .brand-mastercard-id {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            line-height: 1;
                            gap: 3px;
                        }
                        .mc-circles-id {
                            display: flex;
                            align-items: center;
                            width: 28px;
                            height: 18px;
                            position: relative;
                        }
                        .mc-circles-id .circle-id {
                            width: 16px;
                            height: 16px;
                            border-radius: 50%;
                            position: absolute;
                        }
                        .mc-circles-id .circle-id.red-id {
                            background: #eb001b;
                            left: 0;
                        }
                        .mc-circles-id .circle-id.orange-id {
                            background: #ff5f00;
                            right: 0;
                            opacity: 0.9;
                        }
                        .mc-id-text {
                            font-size: 0.42rem;
                            font-weight: 700;
                            color: #ffffff;
                            text-align: center;
                            letter-spacing: 0.5px;
                            line-height: 1.1;
                        }
                        .mc-id-text .id-text {
                            font-size: 0.45rem;
                            text-transform: uppercase;
                            font-weight: 800;
                        }

                        /* RuPay Global */
                        .brand-rupay-global {
                            display: flex;
                            flex-direction: column;
                            align-items: flex-end;
                            line-height: 0.95;
                        }
                        .brand-rupay-global .rupay-global-text {
                            font-family: 'Poppins', sans-serif;
                            font-size: 1.1rem;
                            font-weight: 800;
                            font-style: italic;
                            color: #ffffff;
                            letter-spacing: 0.5px;
                        }
                        .brand-rupay-global .rupay-global-text .arrow-accent {
                            color: #ca8a04;
                            font-size: 0.8rem;
                            margin-left: 2px;
                        }
                        .brand-rupay-global .rupay-global-sub {
                            font-size: 0.4rem;
                            font-weight: 700;
                            color: rgba(255, 255, 255, 0.8);
                            letter-spacing: 1px;
                            margin-top: -1px;
                        }

                        /* Debit & Credit Back Layout */
                        .debit-back-layout,
                        .credit-back-layout {
                            width: 100%;
                            height: 100%;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                            box-sizing: border-box;
                            padding: 0px 0;
                        }
                        .debit-back-info-bar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            font-size: 0.42rem;
                            color: rgba(255, 255, 255, 0.7);
                            margin-top: 6px;
                            z-index: 5;
                            padding: 0 5px;
                        }
                        .debit-back-grid {
                            display: grid;
                            grid-template-columns: 1.2fr 1fr;
                            gap: 15px;
                            align-items: flex-start;
                            margin-top: 10px;
                            flex-grow: 1;
                            z-index: 5;
                        }
                        .debit-grid-left {
                            display: flex;
                            flex-direction: column;
                            gap: 10px;
                        }
                        .debit-signature-area {
                            display: flex;
                            flex-direction: column;
                            gap: 2px;
                        }
                        .debit-sig-label {
                            font-size: 0.38rem;
                            font-weight: 600;
                            color: rgba(255, 255, 255, 0.6);
                            letter-spacing: 0.5px;
                        }
                        .debit-sig-strip-wrapper {
                            display: flex;
                            align-items: center;
                            background: repeating-linear-gradient(45deg, #e2e8f0, #e2e8f0 4px, #cbd5e1 4px, #cbd5e1 8px);
                            height: 28px;
                            border-radius: 4px;
                            padding-right: 2px;
                            box-sizing: border-box;
                            position: relative;
                            overflow: hidden;
                        }
                        .debit-signature-pattern {
                            flex-grow: 1;
                            height: 100%;
                        }
                        .debit-sig-cvv-box {
                            background: #ffffff;
                            height: 24px;
                            width: 38px;
                            border-radius: 3px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            border: 1px solid #cbd5e1;
                        }
                        .debit-sig-cvv-box .cvv-val {
                            font-family: 'Share Tech Mono', monospace;
                            font-size: 0.75rem;
                            font-weight: 700;
                            color: #334155;
                            letter-spacing: 0.5px;
                        }
                        .debit-back-network-logo {
                            display: flex;
                            align-items: center;
                            height: 28px;
                            margin-top: 2px;
                        }
                        .debit-grid-right {
                            display: flex;
                            flex-direction: column;
                            gap: 10px;
                            padding-left: 5px;
                        }
                        .debit-back-vgb-header {
                            display: flex;
                            align-items: center;
                            gap: 6px;
                        }
                        .debit-back-vgb-header .logo-text-stacked .text-top {
                            font-size: 0.48rem;
                            font-weight: 800;
                            letter-spacing: 1px;
                            color: #ffffff;
                        }
                        .debit-back-vgb-header .logo-text-stacked .text-bottom {
                            font-size: 0.32rem;
                            font-weight: 600;
                            letter-spacing: 0.5px;
                            color: rgba(255, 255, 255, 0.7);
                        }
                        .debit-property-disclaimer {
                            font-size: 0.4rem;
                            line-height: 1.3;
                            color: rgba(255, 255, 255, 0.7);
                            margin: 0;
                            border-top: 1px solid rgba(255, 255, 255, 0.1);
                            padding-top: 5px;
                        }

                        /* 5. Classic Credit (Visa Signature) */
                        .vgb-atm-card.credit.visa {
                            background: radial-gradient(circle at 70% 35%, #18153c 0%, #080517 75%, #020108 100%) !important;
                            box-shadow: 0 12px 25px rgba(99, 102, 241, 0.2);
                        }

                        .vgb-atm-card.credit.visa .card-front::after {
                            content: '';
                            position: absolute;
                            inset: 0;
                            background:
                                radial-gradient(circle at 70% 35%, rgba(147, 197, 253, 0.35) 0%, rgba(99, 102, 241, 0.2) 25%, rgba(67, 56, 202, 0.05) 50%, transparent 70%),
                                repeating-radial-gradient(ellipse 180px 90px at 70% 35%, transparent 0px, transparent 15px, rgba(99, 102, 241, 0.04) 18px, transparent 22px);
                            pointer-events: none;
                            transform: rotate(10deg);
                            z-index: 1;
                        }

                        /* 6. Gold Credit (Mastercard Royale) */
                        .vgb-atm-card.credit.mastercard {
                            background: 
                                radial-gradient(circle at 75% 35%, rgba(212, 175, 55, 0.25) 0%, transparent 55%),
                                linear-gradient(to right, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                                linear-gradient(to bottom, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                                linear-gradient(135deg, #121316 0%, #08090a 100%) !important;
                            background-size: cover, 16px 16px, 16px 16px, cover;
                            box-shadow: 0 12px 25px rgba(212, 175, 55, 0.2);
                        }

                        .vgb-atm-card.credit.mastercard .card-front::after {
                            content: '';
                            position: absolute;
                            inset: 0;
                            background:
                                radial-gradient(circle at 75% 35%, rgba(254, 240, 138, 0.35) 0%, rgba(202, 138, 4, 0.2) 20%, rgba(113, 63, 18, 0.05) 40%, transparent 65%),
                                repeating-radial-gradient(ellipse 220px 110px at 75% 35%, transparent 0px, transparent 12px, rgba(217, 119, 6, 0.03) 15px, transparent 18px);
                            pointer-events: none;
                            transform: rotate(-15deg);
                            z-index: 1;
                        }

                        /* 7. Platinum Credit (RuPay Platinum) */
                        .vgb-atm-card.credit.rupay {
                            background: linear-gradient(135deg, #1c1c24 0%, #0c0c10 100%) !important;
                            box-shadow: 0 12px 25px rgba(255, 255, 255, 0.08);
                        }

                        .vgb-atm-card.credit.rupay .card-front::after {
                            content: '';
                            position: absolute;
                            inset: 0;
                            background:
                                radial-gradient(circle at 100% 0%, rgba(255, 255, 255, 0.08) 0%, transparent 60%),
                                linear-gradient(110deg, transparent 30%, rgba(255, 255, 255, 0.05) 40%, rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0.05) 60%, transparent 70%);
                            pointer-events: none;
                            z-index: 1;
                        }

                        /* 8. Infinite Credit (Visa Infinite) */
                        .vgb-atm-card.credit.visa.premium-tier {
                            background: radial-gradient(circle at 75% 35%, #18052b 0%, #030107 70%, #000000 100%) !important;
                            box-shadow: 0 12px 25px rgba(168, 85, 247, 0.25);
                        }

                        .vgb-atm-card.credit.visa.premium-tier .card-front::after {
                            content: '';
                            position: absolute;
                            inset: 0;
                            background:
                                linear-gradient(120deg, transparent 40%, #bf953f 44%, #fcf6ba 47%, #b38728 50%, transparent 54%);
                            pointer-events: none;
                            z-index: 1;
                        }

                        .vgb-atm-card.inactive-card {
                            background: repeating-linear-gradient(45deg, rgba(0,0,0,0.15) 0px, rgba(0,0,0,0.15) 2px, transparent 2px, transparent 10px), 
                                        linear-gradient(135deg, #2e3035 0%, #151618 100%) !important;
                            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
                            opacity: 0.8;
                        }
                        .vgb-atm-card.inactive-card .card-front,
                        .vgb-atm-card.inactive-card .card-back {
                            filter: grayscale(100%) brightness(0.65) contrast(90%) !important;
                        }

                        /* Card Back Visual Layouts */
                        .card-back-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            font-size: 0.45rem;
                            color: rgba(255, 255, 255, 0.6);
                            margin-bottom: 2px;
                            z-index: 5;
                            background: transparent;
                        }

                        .card-back-header .back-helpline {
                            font-size: 0.45rem;
                        }

                        .card-back-header .back-card-id {
                            font-family: monospace;
                            font-weight: bold;
                            font-size: 0.48rem;
                        }

                        .card-back-magnetic-strip {
                            height: 35px;
                            background: #000000;
                            margin: 0 -25px;
                            z-index: 5;
                        }

                        .card-back-signature-container {
                            margin-top: 10px;
                            display: grid;
                            grid-template-columns: 1fr auto;
                            gap: 15px;
                            align-items: center;
                            z-index: 5;
                            background: transparent;
                        }

                        .signature-strip-text {
                            background: repeating-linear-gradient(45deg, #e2e8f0, #e2e8f0 4px, #cbd5e1 4px, #cbd5e1 8px);
                            height: 32px;
                            border-radius: 4px;
                            display: flex;
                            flex-direction: column;
                            justify-content: center;
                            padding-left: 12px;
                            font-family: 'Poppins', sans-serif;
                            line-height: 1.2;
                        }

                        .signature-strip-text span:first-child {
                            font-size: 0.45rem;
                            font-weight: 700;
                            color: #475569;
                            letter-spacing: 0.5px;
                        }

                        .signature-strip-text span:last-child {
                            font-size: 0.4rem;
                            font-weight: 500;
                            color: #64748b;
                            letter-spacing: 0.5px;
                        }

                        .signature-strip-cvv {
                            background: #ffffff;
                            height: 32px;
                            width: 45px;
                            border-radius: 4px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            border: 1px solid #cbd5e1;
                        }

                        .signature-strip-cvv .cvv-val {
                            font-family: 'Share Tech Mono', monospace;
                            font-size: 0.85rem;
                            font-weight: 700;
                            color: #334155;
                            letter-spacing: 1px;
                        }

                        .card-back-bottom {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: 8px;
                            z-index: 5;
                            background: transparent;
                        }

                        .back-left-emblem {
                            display: flex;
                            align-items: center;
                        }

                        .dove-hologram {
                            width: 32px;
                            height: 22px;
                            background: linear-gradient(135deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
                            border-radius: 3px;
                            opacity: 0.75;
                            position: relative;
                            box-shadow: 0 0 4px rgba(255, 255, 255, 0.1);
                        }

                        .dove-hologram::after {
                            content: '🕊';
                            position: absolute;
                            inset: 0;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 0.7rem;
                            color: rgba(255, 255, 255, 0.8);
                            text-shadow: 0 0 2px rgba(0, 0, 0, 0.2);
                        }

                        .mc-hologram {
                            width: 30px;
                            height: 20px;
                            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
                            border-radius: 3px;
                            opacity: 0.8;
                            box-shadow: 0 0 4px rgba(255, 255, 255, 0.1);
                        }

                        .rupay-back-emblem {
                            font-family: 'Poppins', sans-serif;
                            font-size: 0.85rem;
                            font-weight: 800;
                            font-style: italic;
                            color: rgba(255, 255, 255, 0.4);
                        }

                        .rupay-back-emblem .arrow-accent {
                            color: rgba(202, 138, 4, 0.4);
                            font-size: 0.6rem;
                            margin-left: 1px;
                        }

                        .back-right-logo {
                            display: flex;
                            align-items: center;
                        }

                        .back-logo-v {
                            display: flex;
                            align-items: center;
                            gap: 4px;
                        }

                        .logo-text-stacked {
                            display: flex;
                            flex-direction: column;
                            line-height: 1;
                        }

                        .logo-text-stacked .text-top {
                            font-size: 0.52rem;
                            font-weight: 800;
                            letter-spacing: 1px;
                            color: #ffffff;
                            font-family: 'Poppins', sans-serif;
                        }

                        .logo-text-stacked .text-bottom {
                            font-size: 0.35rem;
                            font-weight: 600;
                            letter-spacing: 0.5px;
                            color: rgba(255, 255, 255, 0.7);
                            font-family: 'Poppins', sans-serif;
                        }

                        .back-property-text {
                            font-size: 0.45rem;
                            opacity: 0.45;
                            text-align: center;
                            line-height: 1.3;
                            margin-top: 4px;
                            color: #ffffff;
                            border-top: 1px solid rgba(255, 255, 255, 0.08);
                            padding-top: 4px;
                            z-index: 5;
                        }

                        /* Gold Card Back customization deactivated - unified cosmic theme now active */

                        /* Card Bank Header */
                        .card-bank-header {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            background: transparent;
                            z-index: 5;
                        }

                        .card-bank-name-stack {
                            display: flex;
                            flex-direction: column;
                            line-height: 1.1;
                        }

                        .card-bank-name-stack .bank-title {
                            font-size: 0.8rem;
                            font-weight: 800;
                            letter-spacing: 1.5px;
                            color: #ffffff;
                            font-family: 'Poppins', sans-serif;
                        }

                        .card-bank-name-stack .bank-subtitle {
                            font-size: 0.45rem;
                            font-weight: 600;
                            letter-spacing: 1px;
                            color: rgba(255, 255, 255, 0.7);
                            font-family: 'Poppins', sans-serif;
                        }

                        /* Tier indicator */
                        .card-tier-indicator {
                            position: absolute;
                            top: 22px;
                            right: 25px;
                            font-size: 0.52rem;
                            font-weight: 700;
                            color: #d4af37;
                            letter-spacing: 1px;
                            text-transform: uppercase;
                        }

                        .card-tier-indicator .platinum-text {
                            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
                            -webkit-background-clip: text;
                            background-clip: text;
                            -webkit-text-fill-color: transparent;
                            font-size: 0.55rem;
                            font-weight: 800;
                        }

                        /* Middle section */
                        .card-middle-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: 15px;
                            z-index: 5;
                            background: transparent;
                        }

                        .contactless-icon {
                            font-size: 1.5rem;
                            transform: rotate(90deg);
                            opacity: 0.8;
                            color: #ffffff;
                        }

                        /* Card Number */
                        .card-number-display {
                            font-family: 'Share Tech Mono', monospace;
                            font-size: 1.2rem;
                            letter-spacing: 2px;
                            font-weight: 600;
                            margin: 20px 0 10px;
                            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
                            color: #ffffff;
                            z-index: 5;
                        }

                        /* Bottom row */
                        .card-bottom-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-end;
                            z-index: 5;
                            background: transparent;
                        }

                        .card-holder-info {
                            display: flex;
                            flex-direction: column;
                            gap: 2px;
                        }

                        .expiry-info {
                            display: flex;
                            align-items: center;
                            gap: 6px;
                        }

                        .expiry-label {
                            font-size: 0.45rem;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            opacity: 0.7;
                            color: #ffffff;
                        }

                        .expiry-value {
                            font-family: 'Share Tech Mono', monospace;
                            font-size: 0.72rem;
                            font-weight: 700;
                            color: #ffffff;
                        }

                        .holder-name {
                            font-size: 0.85rem;
                            font-weight: 700;
                            letter-spacing: 0.5px;
                            text-transform: uppercase;
                            color: #ffffff;
                            font-family: 'Share Tech Mono', monospace;
                        }

                        /* Brand logos */
                        .brand-visa {
                            display: flex;
                            flex-direction: column;
                            align-items: flex-end;
                            line-height: 1;
                        }

                        .brand-visa .visa-text {
                            font-family: 'Poppins', sans-serif;
                            font-size: 1.35rem;
                            font-weight: 800;
                            font-style: italic;
                            color: #ffffff;
                            letter-spacing: 0.5px;
                        }

                        .brand-visa .visa-sub {
                            font-size: 0.45rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            color: rgba(255, 255, 255, 0.8);
                            letter-spacing: 0.5px;
                            margin-top: -2px;
                        }

                        .brand-mastercard {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            line-height: 1;
                            gap: 2px;
                        }

                        .mc-circles {
                            display: flex;
                            align-items: center;
                            width: 28px;
                            height: 18px;
                            position: relative;
                        }

                        .mc-circles .circle {
                            width: 16px;
                            height: 16px;
                            border-radius: 50%;
                            position: absolute;
                        }

                        .mc-circles .circle.red {
                            background: #eb001b;
                            left: 0;
                        }

                        .mc-circles .circle.orange {
                            background: #ff5f00;
                            right: 0;
                            opacity: 0.9;
                        }

                        .mc-text {
                            font-size: 0.42rem;
                            font-weight: 700;
                            color: #ffffff;
                            text-transform: lowercase;
                            letter-spacing: 0.5px;
                        }

                        .brand-rupay {
                            display: flex;
                            flex-direction: column;
                            align-items: flex-end;
                            line-height: 1;
                        }

                        .brand-rupay .rupay-text {
                            font-family: 'Poppins', sans-serif;
                            font-size: 1.1rem;
                            font-weight: 800;
                            font-style: italic;
                            color: #ffffff;
                            letter-spacing: 0.5px;
                        }

                        .brand-rupay .rupay-text .arrow-accent {
                            color: #ca8a04;
                            font-size: 0.8rem;
                            margin-left: 2px;
                        }

                        .brand-rupay .rupay-sub {
                            font-size: 0.45rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            color: rgba(255, 255, 255, 0.8);
                            letter-spacing: 0.5px;
                            margin-top: -1px;
                        }

                        /* Card Elements */
                        .card-top {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .card-provider-logo {
                            font-size: 1.4rem;
                            font-weight: 800;
                            letter-spacing: 1px;
                            text-transform: uppercase;
                            font-style: italic;
                            background: linear-gradient(135deg, #ffffff 0%, #e2e8f0 100%);
                            -webkit-background-clip: text;
                            background-clip: text;
                            -webkit-text-fill-color: transparent;
                        }

                        .metallic-chip {
                            width: 42px;
                            height: 32px;
                            background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #b45309 100%);
                            border-radius: 6px;
                            border: 1px solid rgba(255, 255, 255, 0.25);
                            box-shadow: inset 0 1px 3px rgba(255, 255, 255, 0.4);
                            position: relative;
                        }

                        .metallic-chip::after {
                            content: '';
                            position: absolute;
                            inset: 5px;
                            border: 1px solid rgba(255, 255, 255, 0.2);
                            border-radius: 2px;
                        }

                        .card-number {
                            font-family: 'Share Tech Mono', monospace;
                            font-size: 1.25rem;
                            letter-spacing: 2px;
                            font-weight: 600;
                            margin: 20px 0 10px;
                            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
                        }

                        .card-details {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-end;
                        }

                        .card-label {
                            font-size: 0.6rem;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            opacity: 0.75;
                            display: block;
                            margin-bottom: 2px;
                        }

                        .card-value {
                            font-size: 0.85rem;
                            font-weight: 600;
                            letter-spacing: 0.5px;
                            text-transform: uppercase;
                        }

                        /* Glassmorphic Modal */
                        .modal {
                            display: none;
                            position: fixed;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            z-index: 1000;
                            background: rgba(15, 23, 42, 0.6);
                            backdrop-filter: blur(8px);
                            align-items: center;
                            justify-content: center;
                            padding: 20px;
                        }

                        .modal-content {
                            background: rgba(255, 255, 255, 0.95);
                            backdrop-filter: blur(25px);
                            border: 1px solid rgba(99, 102, 241, 0.2);
                            width: 100%;
                            max-width: 500px;
                            border-radius: var(--radius-lg);
                            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
                            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                            overflow: hidden;
                            max-height: 90vh;
                            display: flex;
                            flex-direction: column;
                        }

                        .modal-content form {
                            display: flex;
                            flex-direction: column;
                            overflow: hidden;
                            margin: 0;
                        }

                        @keyframes modalScaleUp {
                            from {
                                transform: scale(0.9) translateY(10px);
                                opacity: 0;
                            }

                            to {
                                transform: scale(1) translateY(0);
                                opacity: 1;
                            }
                        }

                        .modal-header {
                            padding: 20px 25px;
                            border-bottom: 1px solid rgba(99, 102, 241, 0.1);
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            flex-shrink: 0;
                        }

                        .modal-body {
                            padding: 25px;
                            overflow-y: auto;
                            max-height: calc(90vh - 80px);
                        }

                        /* Responsive Modal & Paper Form adjustments */
                        @media (max-width: 768px) {
                            .modal-content {
                                max-width: 95% !important;
                                max-height: 95vh !important;
                            }

                            .modal-body {
                                padding: 15px !important;
                                max-height: calc(95vh - 70px) !important;
                            }

                            .apply-paper-form,
                            .renewal-paper-form {
                                padding: 20px 15px !important;
                                font-size: 0.85rem !important;
                            }

                            .apply-paper-form h2,
                            .renewal-paper-form h2 {
                                font-size: 1.1rem !important;
                            }

                            .apply-paper-form h3,
                            .renewal-paper-form h3 {
                                font-size: 0.85rem !important;
                            }
                        }

                        .close-btn {
                            background: none;
                            border: none;
                            font-size: 1.5rem;
                            color: var(--gray-400);
                            cursor: pointer;
                            transition: color 0.2s;
                        }

                        .close-btn:hover {
                            color: #ef4444;
                        }

                        .form-select,
                        .form-input {
                            width: 100%;
                            padding: 12px 15px;
                            border: 1.5px solid var(--gray-200);
                            border-radius: var(--radius-md);
                            outline: none;
                            margin-top: 5px;
                            background: white;
                            font-family: inherit;
                        }

                        /* Switch Toggle Style */
                        .switch-toggle {
                            position: relative;
                            display: inline-block;
                            width: 50px;
                            height: 26px;
                        }

                        .switch-toggle input {
                            opacity: 0;
                            width: 0;
                            height: 0;
                        }

                        .slider-toggle-round {
                            position: absolute;
                            cursor: pointer;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            background-color: #cbd5e1;
                            transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
                            border-radius: 34px;
                        }

                        .slider-toggle-round:before {
                            position: absolute;
                            content: "";
                            height: 20px;
                            width: 20px;
                            left: 3px;
                            bottom: 3px;
                            background-color: white;
                            transition: .3s cubic-bezier(0.4, 0, 0.2, 1);
                            border-radius: 50%;
                            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
                        }

                        .switch-toggle input:checked + .slider-toggle-round {
                            background: var(--gradient-primary);
                        }

                        .switch-toggle input:checked + .slider-toggle-round:before {
                            transform: translateX(24px);
                        }

                        /* Beautiful Slider Custom Styling */
                        .limit-slider {
                            -webkit-appearance: none;
                            height: 6px;
                            border-radius: 5px;
                            background: var(--gray-200);
                            outline: none;
                            transition: background 0.2s;
                        }

                        .limit-slider::-webkit-slider-thumb {
                            -webkit-appearance: none;
                            appearance: none;
                            width: 18px;
                            height: 18px;
                            border-radius: 50%;
                            background: var(--primary-500);
                            cursor: pointer;
                            border: 2px solid white;
                            box-shadow: 0 1px 4px rgba(0,0,0,0.2);
                            transition: transform 0.1s;
                        }

                        .limit-slider::-webkit-slider-thumb:hover {
                            transform: scale(1.15);
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
                            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo"
                                style="display: flex; align-items: center; text-decoration: none;">
                                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo"
                                    style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
                            </a>
                        </div>
                        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <c:choose>
                                    <c:when test="${not empty customer}">
                                        <c:choose>
                                            <c:when test="${not empty customer.avatarPath}">
                                                <img src="${pageContext.request.contextPath}${customer.avatarPath}"
                                                    alt="Customer Profile Avatar"
                                                    style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                                            </c:when>
                                            <c:otherwise>
                                                <div
                                                    style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                                                    ${customer.fullName.substring(0, 1)}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div style="display: flex; flex-direction: column; text-align: left;"
                                            class="mobile-hide">
                                            <span
                                                style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                                            <span
                                                style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                                <span
                                                    style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                                                Customer Space
                                            </span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div
                                            style="width: 36px; height: 36px; border-radius: 50%; background: var(--gray-100); color: var(--gray-500); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1.5px solid var(--gray-200);">
                                            <i class="bx bx-user"></i>
                                        </div>
                                        <span style="font-weight: 600; color: var(--gray-700); font-size: 0.85rem;"
                                            class="mobile-hide">Customer Space</span>
                                    </c:otherwise>
                                </c:choose>
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
                            <a href="${pageContext.request.contextPath}/customer-dashboard"><i
                                    class="bx bx-grid-alt"></i> Dashboard</a>
                            <a href="${pageContext.request.contextPath}/account?action=list"><i
                                    class="bx bx-wallet"></i> Accounts</a>
                            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i
                                    class="bx bx-transfer-alt"></i> Fund Transfer</a>
                            <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i
                                    class="bx bx-credit-card"></i> My Cards</a>
                            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i
                                    class="bx bx-book-bookmark"></i> Cheque Books</a>
                            <a href="${pageContext.request.contextPath}/passbook?action=list"><i
                                    class="bx bx-book-open"></i> Passbook Requests</a>
                            <a href="${pageContext.request.contextPath}/loan?action=list"><i
                                    class="bx bx-building-house"></i> Loans</a>
                            <a href="${pageContext.request.contextPath}/account?action=statement"><i
                                    class="bx bx-file"></i> Statements</a>
                            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i>
                                My Profile</a>
                        </div>
                        <div
                            style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
                            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Support Hotline</p>
                            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">
                                1800-VGB-BANK</p>
                        </div>
                    </aside>

                    <!-- Main Content -->
                    <main class="main-content">
                        <div class="container" style="max-width: 1200px; padding: 0;">
                            <!-- Welcome Header -->
                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                                <div>
                                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">My Premium
                                        ATM Cards</h2>
                                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Manage VGB
                                        Debit and Credit Cards, clear dues, and extend your cards validity dynamically.
                                    </p>
                                </div>
                                <div>
                                    <button onclick="openApplyModal()" class="btn btn-primary"
                                        style="display: inline-flex; align-items: center; gap: 8px;">
                                        <i class="bx bx-plus-circle"></i> Apply New Card
                                    </button>
                                </div>
                            </div>

                            <!-- Alerts -->
                            <c:if test="${not empty error or not empty sessionScope.error}">
                                <div
                                    style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                                    <span>${not empty error ? error : sessionScope.error}</span>
                                </div>
                                <c:remove var="error" scope="session" />
                            </c:if>
                            <c:if test="${not empty success or not empty sessionScope.success}">
                                <div
                                    style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                                    <span>${not empty success ? success : sessionScope.success}</span>
                                </div>
                                <c:remove var="success" scope="session" />
                            </c:if>

                            <!-- Cards Rendering Grid -->
                            <div class="cards-grid">
                                <c:choose>
                                    <c:when test="${not empty cards}">
                                        <c:forEach var="card" items="${cards}">
                                            <div
                                                style="display: flex; flex-direction: column; align-items: center; gap: 15px;">
                                                <div class="card-3d-wrapper"
                                                    onclick="this.querySelector('.vgb-atm-card').classList.toggle('flipped')">
                                                    <div
                                                        class="vgb-atm-card ${card.cardType} ${card.cardProvider} ${card.dailyLimit gt 50000 ? 'premium-tier' : ''} ${card.status ne 'active' ? 'inactive-card' : ''}">
                                                        <!-- Front Face -->
                                                        <div class="card-face card-front">
                                                            <!-- Shared/Common: Bank Name Header -->
                                                            <div class="card-bank-header">
                                                                <div class="card-logo-v">
                                                                    <img src="${pageContext.request.contextPath}/assest/images/image.png"
                                                                        alt="VGB"
                                                                        style="width: 22px; height: 22px; object-fit: contain;">
                                                                </div>
                                                                <div class="card-bank-name-stack">
                                                                    <span class="bank-title">VERTEX</span>
                                                                    <span class="bank-subtitle">GALAXY BANK</span>
                                                                </div>
                                                            </div>

                                                            <!-- DEBIT FRONT LAYOUT -->
                                                            <div class="debit-front-layout">
                                                                <div class="debit-header-right">
                                                                    <span class="debit-label-txt">DEBIT</span>
                                                                    <i class="bx bx-wifi contactless-icon-debit"></i>
                                                                </div>

                                                                <div class="debit-chip-row">
                                                                    <div class="metallic-chip"></div>
                                                                </div>

                                                                <div class="card-number-display debit-number">
                                                                    ${card.cardNumber}
                                                                </div>

                                                                <div class="debit-expiry-row">
                                                                    <span class="expiry-label">VALID<br>THRU</span>
                                                                    <span class="expiry-value">
                                                                        <fmt:formatDate value="${card.expiryDate}" pattern="MM/yy" />
                                                                    </span>
                                                                </div>

                                                                <div class="debit-bottom-row">
                                                                    <div class="holder-name debit-holder">${card.cardHolderName}</div>
                                                                    <div class="debit-brand-logo-container">
                                                                        <c:choose>
                                                                            <c:when test="${card.cardProvider eq 'visa'}">
                                                                                <div class="brand-visa-secure">
                                                                                    <span class="visa-secure-text">VISA</span>
                                                                                    <span class="visa-secure-sub">SECURE</span>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:when test="${card.cardProvider eq 'mastercard'}">
                                                                                <div class="brand-mastercard-id">
                                                                                    <div class="mc-circles-id">
                                                                                        <span class="circle-id red-id"></span>
                                                                                        <span class="circle-id orange-id"></span>
                                                                                    </div>
                                                                                    <span class="mc-id-text">mastercard<br><span class="id-text">ID</span></span>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div class="brand-rupay-global">
                                                                                    <span class="rupay-global-text">RuPay<span class="arrow-accent">▶</span></span>
                                                                                    <span class="rupay-global-sub">GLOBAL</span>
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- CREDIT FRONT LAYOUT -->
                                                            <div class="credit-front-layout">
                                                                <div class="debit-header-right">
                                                                    <span class="debit-label-txt">CREDIT</span>
                                                                    <i class="bx bx-wifi contactless-icon-debit"></i>
                                                                </div>

                                                                <div class="debit-chip-row">
                                                                    <div class="metallic-chip"></div>
                                                                </div>

                                                                <div class="card-number-display debit-number">
                                                                    ${card.cardNumber}
                                                                </div>

                                                                <div class="debit-expiry-row">
                                                                    <span class="expiry-label">VALID<br>THRU</span>
                                                                    <span class="expiry-value">
                                                                        <fmt:formatDate value="${card.expiryDate}" pattern="MM/yy" />
                                                                    </span>
                                                                </div>

                                                                <div class="debit-bottom-row">
                                                                    <div class="holder-name debit-holder">${card.cardHolderName}</div>
                                                                    <div class="debit-brand-logo-container">
                                                                        <c:choose>
                                                                            <c:when test="${card.cardProvider eq 'visa'}">
                                                                                <div class="brand-visa-secure">
                                                                                    <span class="visa-secure-text">VISA</span>
                                                                                    <span class="visa-secure-sub">SECURE</span>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:when test="${card.cardProvider eq 'mastercard'}">
                                                                                <div class="brand-mastercard-id">
                                                                                    <div class="mc-circles-id">
                                                                                        <span class="circle-id red-id"></span>
                                                                                        <span class="circle-id orange-id"></span>
                                                                                    </div>
                                                                                    <span class="mc-id-text">mastercard<br><span class="id-text">ID</span></span>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div class="brand-rupay-global">
                                                                                    <span class="rupay-global-text">RuPay<span class="arrow-accent">▶</span></span>
                                                                                    <span class="rupay-global-sub">GLOBAL</span>
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Back Face -->
                                                        <div class="card-face card-back">
                                                            <!-- DEBIT BACK LAYOUT -->
                                                            <div class="debit-back-layout">
                                                                <div class="card-back-magnetic-strip" style="margin: 0 -25px;"></div>
                                                                
                                                                <div class="debit-back-info-bar">
                                                                    <span class="debit-info-web">www.vertexgalaxybank.com</span>
                                                                    <span class="debit-info-phone">For customer service, call +1 234 567 8900</span>
                                                                </div>
                                                                
                                                                <div class="debit-back-grid">
                                                                    <div class="debit-grid-left">
                                                                        <div class="debit-signature-area">
                                                                            <span class="debit-sig-label">AUTHORIZED SIGNATURE</span>
                                                                            <div class="debit-sig-strip-wrapper">
                                                                                <div class="debit-signature-pattern"></div>
                                                                                <div class="debit-sig-cvv-box" onclick="toggleCvv(this, '${card.cvv}')" title="Click to show CVV" style="cursor: pointer;">
                                                                                    <span class="cvv-val cvv-text">•••</span>
                                                                                </div>
                                                                            </div>
                                                                            <span class="debit-sig-label">NOT VALID UNLESS SIGNED</span>
                                                                        </div>
                                                                        
                                                                        <div class="debit-back-network-logo">
                                                                            <c:choose>
                                                                                <c:when test="${card.cardProvider eq 'visa'}">
                                                                                    <div class="brand-visa-secure">
                                                                                        <span class="visa-secure-text" style="font-size: 1rem;">VISA</span>
                                                                                        <span class="visa-secure-sub" style="font-size: 0.35rem; letter-spacing: 0.8px;">SECURE</span>
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${card.cardProvider eq 'mastercard'}">
                                                                                    <div class="brand-mastercard-id" style="flex-direction: row; gap: 6px; align-items: center;">
                                                                                        <div class="mc-circles-id">
                                                                                            <span class="circle-id red-id"></span>
                                                                                            <span class="circle-id orange-id"></span>
                                                                                        </div>
                                                                                        <span class="mc-id-text" style="text-align: left;">mastercard<br><span class="id-text">ID</span></span>
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <div class="brand-rupay-global">
                                                                                        <span class="rupay-global-text" style="font-size: 0.95rem;">RuPay<span class="arrow-accent">▶</span></span>
                                                                                        <span class="rupay-global-sub" style="font-size: 0.35rem;">GLOBAL</span>
                                                                                    </div>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <div class="debit-grid-right">
                                                                        <div class="debit-back-vgb-header">
                                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB" style="width: 16px; height: 16px; object-fit: contain;">
                                                                            <div class="logo-text-stacked">
                                                                                <span class="text-top">VERTEX</span>
                                                                                <span class="text-bottom">GALAXY BANK</span>
                                                                            </div>
                                                                        </div>
                                                                        <p class="debit-property-disclaimer">
                                                                            This card is the property of Vertex Galaxy Bank and must be returned upon request.
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- CREDIT BACK LAYOUT -->
                                                            <div class="credit-back-layout">
                                                                <div class="card-back-magnetic-strip" style="margin: 0 -25px;"></div>
                                                                
                                                                <div class="debit-back-info-bar">
                                                                    <span class="debit-info-web">www.vertexgalaxybank.com</span>
                                                                    <span class="debit-info-phone">For customer service, call +1 234 567 8900</span>
                                                                </div>
                                                                
                                                                <div class="debit-back-grid">
                                                                    <div class="debit-grid-left">
                                                                        <div class="debit-signature-area">
                                                                            <span class="debit-sig-label">AUTHORIZED SIGNATURE</span>
                                                                            <div class="debit-sig-strip-wrapper">
                                                                                <div class="debit-signature-pattern"></div>
                                                                                <div class="debit-sig-cvv-box" onclick="toggleCvv(this, '${card.cvv}')" title="Click to show CVV" style="cursor: pointer;">
                                                                                    <span class="cvv-val cvv-text">•••</span>
                                                                                </div>
                                                                            </div>
                                                                            <span class="debit-sig-label">NOT VALID UNLESS SIGNED</span>
                                                                        </div>
                                                                        
                                                                        <div class="debit-back-network-logo">
                                                                            <c:choose>
                                                                                <c:when test="${card.cardProvider eq 'visa'}">
                                                                                    <div class="brand-visa-secure">
                                                                                        <span class="visa-secure-text" style="font-size: 1rem;">VISA</span>
                                                                                        <span class="visa-secure-sub" style="font-size: 0.35rem; letter-spacing: 0.8px;">SECURE</span>
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${card.cardProvider eq 'mastercard'}">
                                                                                    <div class="brand-mastercard-id" style="flex-direction: row; gap: 6px; align-items: center;">
                                                                                        <div class="mc-circles-id">
                                                                                            <span class="circle-id red-id"></span>
                                                                                            <span class="circle-id orange-id"></span>
                                                                                        </div>
                                                                                        <span class="mc-id-text" style="text-align: left;">mastercard<br><span class="id-text">ID</span></span>
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <div class="brand-rupay-global">
                                                                                        <span class="rupay-global-text" style="font-size: 0.95rem;">RuPay<span class="arrow-accent">▶</span></span>
                                                                                        <span class="rupay-global-sub" style="font-size: 0.35rem;">GLOBAL</span>
                                                                                    </div>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <div class="debit-grid-right">
                                                                        <div class="debit-back-vgb-header">
                                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB" style="width: 16px; height: 16px; object-fit: contain;">
                                                                            <div class="logo-text-stacked">
                                                                                <span class="text-top">VERTEX</span>
                                                                                <span class="text-bottom">GALAXY BANK</span>
                                                                            </div>
                                                                        </div>
                                                                        <p class="debit-property-disclaimer">
                                                                            This card is the property of Vertex Galaxy Bank and must be returned upon request.
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- External Control Bar & Limits summary under the 3D card wrapper -->
                                                <div style="width: 100%; max-width: 340px; display: flex; flex-direction: column; gap: 8px;">
                                                    <!-- Limits Badges Summary -->
                                                    <c:if test="${card.status eq 'active'}">
                                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; width: 100%;">
                                                             <div style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(10px); padding: 6px 10px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.12); display: flex; flex-direction: column; gap: 1px; box-shadow: var(--shadow-sm);">
                                                                 <span style="font-size: 0.65rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600; display: flex; align-items: center; gap: 4px;"><i class="bx bx-atm" style="font-size: 0.8rem; color: var(--accent-emerald);"></i> ATM Limit</span>
                                                                 <strong style="font-size: 0.8rem; color: var(--gray-700);">₹ <fmt:formatNumber value="${card.atmLimit}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                                                             </div>
                                                             <div style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(10px); padding: 6px 10px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.12); display: flex; flex-direction: column; gap: 1px; box-shadow: var(--shadow-sm);">
                                                                 <span style="font-size: 0.65rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600; display: flex; align-items: center; gap: 4px;"><i class="bx bx-shopping-bag" style="font-size: 0.8rem; color: #d97706;"></i> Online Limit</span>
                                                                 <strong style="font-size: 0.8rem; color: var(--gray-700);">₹ <fmt:formatNumber value="${card.onlineLimit}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                                                             </div>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <div
                                                        style="display: flex; justify-content: space-between; align-items: center; width: 100%; background: rgba(255,255,255,0.7); backdrop-filter: blur(10px); padding: 10px 15px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); box-shadow: var(--shadow-sm);">
                                                        <div>
                                                            <c:choose>
                                                                <c:when test="${card.status eq 'active'}">
                                                                    <span
                                                                        style="background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i
                                                                            class="bx bxs-circle"
                                                                            style="font-size: 0.5rem; vertical-align: middle;"></i>
                                                                        Active</span>
                                                                </c:when>
                                                                <c:when test="${card.status eq 'pending'}">
                                                                    <span
                                                                        style="background: rgba(245, 158, 11, 0.12); color: #b45309; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i
                                                                            class="bx bxs-circle"
                                                                            style="font-size: 0.5rem; vertical-align: middle;"></i>
                                                                        Pending</span>
                                                                </c:when>
                                                                <c:when test="${card.status eq 'expired'}">
                                                                    <span
                                                                        style="background: rgba(239, 68, 68, 0.12); color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i
                                                                            class="bx bxs-circle"
                                                                            style="font-size: 0.5rem; vertical-align: middle;"></i>
                                                                        Expired</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        style="background: rgba(156, 163, 175, 0.12); color: #4b5563; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i
                                                                            class="bx bxs-circle"
                                                                            style="font-size: 0.5rem; vertical-align: middle;"></i>
                                                                        Closed</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div style="display: flex; gap: 8px; align-items: center;">
                                                            <c:if test="${card.status eq 'active'}">
                                                                <button type="button"
                                                                    onclick="openLimitsModal('${card.cardId}', '${card.dailyLimit}', '${card.atmLimit}', '${card.onlineLimit}', '${card.internationalEnabled}')"
                                                                    class="btn"
                                                                    style="background: rgba(99, 102, 241, 0.08); color: var(--primary-500); padding: 4px 8px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; border: 1px solid rgba(99, 102, 241, 0.15); margin: 0; display: inline-flex; align-items: center; gap: 3px;"
                                                                    title="Manage Limits & Controls">
                                                                    <i class="bx bx-slider-alt" style="font-size: 0.9rem;"></i> Limits
                                                                </button>
                                                            </c:if>
                                                            <c:if
                                                                test="${card.cardType eq 'credit' and card.status eq 'active' and card.outstandingBalance gt 0}">
                                                                <button type="button"
                                                                    onclick="openPayDuesModal('${card.cardId}', '${card.outstandingBalance}')"
                                                                    class="btn"
                                                                    style="background: var(--gradient-primary); color: white; padding: 4px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; border: none; margin: 0; box-shadow: var(--shadow-sm);">Pay
                                                                    Dues</button>
                                                            </c:if>
                                                            <c:if
                                                                test="${card.status eq 'expired' or card.status eq 'closed'}">
                                                                <fmt:formatDate value="${card.expiryDate}" pattern="MM/yy"
                                                                    var="formattedExpiryDate" />
                                                                <button type="button"
                                                                    onclick="openRenewModal('${card.cardId}', '${card.cardType}', '${card.cardFee}', '${card.cardNumber}', '${formattedExpiryDate}', '${card.cardProvider}')"
                                                                    class="btn"
                                                                    style="background: #10b981; color: white; padding: 4px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; border: none; margin: 0;">Renew</button>
                                                            </c:if>
                                                            <c:if test="${card.status eq 'active'}">
                                                                <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}"
                                                                    class="btn"
                                                                    onclick="return confirm('Are you sure you want to permanently close this VGB card?');"
                                                                    style="background: rgba(239, 68, 68, 0.08); color: #ef4444; padding: 4px 8px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; text-decoration: none; border: 1px solid rgba(239, 68, 68, 0.15); margin: 0;">Close</a>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="glass-card"
                                            style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray-400);">
                                            <i class="bx bx-credit-card-front"
                                                style="font-size: 3rem; color: var(--gray-300); margin-bottom: 10px; display: block;"></i>
                                            <span>No ATM/Debit/Credit cards registered to your profile. Apply for a new
                                                card below!</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- VGB Card Services Guideline Card -->
                            <div class="glass-card" style="background: rgba(99, 102, 241, 0.03);">
                                <h4
                                    style="font-size: 1.1rem; font-weight: 700; color: var(--primary-500); margin-bottom: 15px;">
                                    <i class="bx bx-info-circle"></i> VGB Premium Card Services Terms & Limits</h4>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;"
                                    class="mobile-grid-1">
                                    <div>
                                        <strong
                                            style="color: var(--gray-800); font-size: 0.9rem; display: block; margin-bottom: 5px;">VGB
                                            Debit Card</strong>
                                        <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                                            - **Issuance / Renewal Fee**: ₹250.00 (debited upfront).<br>
                                            - **Daily Card Limit**: ₹50,000.00 per day.<br>
                                            - **Card Validity**: 4 years (automatically closes, renewable upon paying
                                            the renewal fee).<br>
                                            - **Ledger Source**: Directly debited from linked bank account balance.
                                        </p>
                                    </div>
                                    <div>
                                        <strong
                                            style="color: var(--gray-800); font-size: 0.9rem; display: block; margin-bottom: 5px;">VGB
                                            Credit Card</strong>
                                        <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                                            - **Issuance / Renewal Fee**: ₹500.00 (debited upfront).<br>
                                            - **Credit Limit**: ₹50,000.00 outstanding capacity.<br>
                                            - **Card Validity**: 4 years (automatically closes, renewable upon paying
                                            the renewal fee).<br>
                                            - **Ledger Source**: Outstanding balance billed, clear dues from any linked
                                            VGB bank account.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>

                    <!-- 1. Modal: Apply For Card -->
                    <div id="applyModal" class="modal">
                        <div class="modal-content" style="max-width: 720px; width: 100%;">
                            <div class="modal-header">
                                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i
                                        class="bx bx-plus-circle"></i> Apply VGB ATM Card</h3>
                                <button type="button" onclick="closeApplyModal()" class="close-btn">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/card?action=apply" method="post">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <div class="modal-body" style="padding-top: 15px;">
                                    <!-- The Formal Banking Paper Form -->
                                    <div class="apply-paper-form"
                                        style="background: #fff; border: 1.5px solid var(--gray-200); padding: 25px 20px; border-radius: var(--radius-sm); color: #1e293b; font-family: 'Times New Roman', Times, serif; font-size: 0.95rem; line-height: 1.6; margin-top: 20px; margin-bottom: 15px; width: calc(100% - 40px); box-sizing: border-box; box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm); position: relative; overflow: hidden;">
                                        <!-- Watermark -->
                                        <div
                                            style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 7.5rem; font-weight: 900; color: rgba(99, 102, 241, 0.03); pointer-events: none; user-select: none; font-family: 'Poppins', sans-serif; letter-spacing: 5px;">
                                            VGB</div>

                                        <!-- Form Header -->
                                        <div
                                            style="text-align: center; border-bottom: 2px double #475569; padding-bottom: 12px; margin-bottom: 20px; position: relative;">
                                            <h2
                                                style="font-size: 1.35rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: #0f172a; margin: 0; font-family: 'Poppins', sans-serif;">
                                                Vertex Galaxy Bank</h2>
                                            <h3
                                                style="font-size: 1rem; font-weight: 700; color: #475569; margin: 4px 0 0; text-transform: uppercase; font-family: 'Poppins', sans-serif; letter-spacing: 0.5px;">
                                                ATM Card Application Request Form</h3>
                                            <span
                                                style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); font-family: 'Poppins', sans-serif;">
                                                Issuance Fee Due: <strong id="applyFeeValue" style="font-weight: 800;">₹
                                                    250.00</strong>
                                            </span>
                                        </div>

                                        <!-- Header Details -->
                                        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
                                            <tr>
                                                <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                                    <strong>To,</strong><br>
                                                    The Branch Manager<br>
                                                    <strong>Vertex Galaxy Bank</strong><br>
                                                    Branch: <input type="text" name="branch"
                                                        style="width: 250px; border: none; border-bottom: 1px dotted #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; color: #0f172a;"
                                                        value="Main Corporate Branch, Mumbai">
                                                </td>
                                                <td
                                                    style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                                    <strong>Date:</strong> <input type="text" name="formDate"
                                                        id="applyFormDateStr"
                                                        style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;"
                                                        value="">
                                                </td>
                                            </tr>
                                        </table>

                                        <div style="margin-bottom: 20px;">
                                            <strong>Subject:</strong> <span
                                                style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request
                                                for ATM/Debit Card Renewal & Issuance</span>
                                        </div>

                                        <!-- Customer Information -->
                                        <div style="margin-bottom: 20px;">
                                            <h4
                                                style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">
                                                Customer Information</h4>
                                            <table style="width: 100%; border-collapse: collapse;">
                                                <tr>
                                                    <td style="width: 35%; padding: 5px 0;"><strong>Account Holder
                                                            Name:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" id="applyCardHolderName"
                                                            name="cardHolderName" required
                                                            value="${cards[0].cardHolderName ne null ? cards[0].cardHolderName : 'MIHIR BHAYANI'}"
                                                            oninput="updateApplyFormHolderName(this.value)"
                                                            placeholder="ENTER HOLDER NAME"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Account Number:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <select id="applyAccountId" name="accountId" required
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent; cursor: pointer; -webkit-appearance: none; -moz-appearance: none; appearance: none;">
                                                            <c:forEach items="${accounts}" var="acc">
                                                                <option value="${acc.accountId}">
                                                                    ${acc.accountNumber} - ${acc.accountType}
                                                                    (Available: ₹
                                                                    <fmt:formatNumber value="${acc.balance}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />)
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Customer ID (if
                                                            applicable):</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="customerId"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;"
                                                            value="${customer.customerId}">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="mobileNumber"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;"
                                                            value="${customer.phoneNo}">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="emailId"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;"
                                                            value="${customer.email}">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0; vertical-align: top;">
                                                        <strong>Address:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="address"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-size: 0.85rem; outline: none; background: transparent; color: #0f172a;"
                                                            value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Card Details Box -->
                                        <div style="margin-bottom: 25px;">
                                            <h4
                                                style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">
                                                ATM/Debit Card Details</h4>
                                            <table style="width: 100%; border-collapse: collapse;">
                                                <tr>
                                                    <td style="width: 45%; padding: 5px 0;"><strong>Existing ATM/Debit
                                                            Card Number (Last 4 Digits):</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="existingCardLast4"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1.05rem; outline: none; background: transparent; color: #0f172a;"
                                                            value="N/A (NEW CARD APPLICATION)">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Card Expiry Date:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="cardExpiry"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; outline: none; background: transparent; color: #0f172a;"
                                                            value="____ / ____">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Card Category:</strong></td>
                                                    <td
                                                        style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                                            <input type="radio" id="applyCardTypeDebit" name="cardType"
                                                                value="debit" checked
                                                                onchange="updateApplyFeeAndNotice('debit')"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            Debit Card (Fee: ₹250)
                                                        </label>
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                                            <input type="radio" id="applyCardTypeCredit" name="cardType"
                                                                value="credit"
                                                                onchange="updateApplyFeeAndNotice('credit')"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            Credit Card (Fee: ₹500)
                                                        </label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Card Network:</strong></td>
                                                    <td
                                                        style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                            <input type="radio" name="cardProvider"
                                                                id="applyProviderRuPay" value="rupay"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            RuPay
                                                        </label>
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                            <input type="radio" name="cardProvider"
                                                                id="applyProviderVisa" value="visa" checked
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            Visa
                                                        </label>
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                            <input type="radio" name="cardProvider"
                                                                id="applyProviderMastercard" value="mastercard"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            MasterCard
                                                        </label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Declaration & Request text -->
                                        <div
                                            style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                                            <p style="margin: 0 0 10px;"><strong>Request:</strong> I request the bank to
                                                renew and issue a new ATM/Debit Card linked to my account mentioned
                                                above. My existing card is approaching expiry/has expired. I kindly
                                                request you to process my application and issue a renewed card at the
                                                earliest.</p>
                                            <p style="margin: 0;"><strong>Declaration:</strong> I declare that the
                                                information provided above is true and correct.</p>
                                        </div>

                                        <!-- Signatures Row -->
                                        <div
                                            style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                                            <div>
                                                <span
                                                    style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;"
                                                    id="applyFormSignature">${cards[0].cardHolderName ne null ?
                                                    cards[0].cardHolderName : 'MIHIR BHAYANI'}</span>
                                                <span
                                                    style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer
                                                    Signature</span>
                                            </div>
                                            <div style="text-align: right;">
                                                <span
                                                    style="display: block; font-family: monospace; font-size: 0.95rem; font-weight: 600; color: #0f172a; text-transform: uppercase; padding-bottom: 5px;"
                                                    id="applyFormNameLabel">${cards[0].cardHolderName ne null ?
                                                    cards[0].cardHolderName : 'MIHIR BHAYANI'}</span>
                                                <span
                                                    style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Name</span>
                                            </div>
                                        </div>

                                        <!-- For Bank Use Only Stamp Card -->
                                        <div
                                            style="background: rgba(248, 250, 252, 0.9); border: 2px dashed #94a3b8; border-radius: var(--radius-md); padding: 20px; font-size: 0.8rem; color: #475569; font-family: 'Poppins', sans-serif; box-shadow: var(--shadow-sm);">
                                            <h5
                                                style="margin: 0 0 12px; font-size: 0.85rem; font-weight: 800; text-transform: uppercase; color: #334155; text-align: center; border-bottom: 1px dashed #cbd5e1; padding-bottom: 8px; letter-spacing: 0.75px;">
                                                For Bank Use Only</h5>
                                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px 20px;">
                                                <div><strong>Application Received On:</strong> <span
                                                        id="applyFormReceivedOnStr"
                                                        style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px;">____
                                                        / ____ / ______</span></div>
                                                <div><strong>Verified By:</strong> <span
                                                        style="border-bottom: 1px solid #64748b; font-weight: 700; font-family: monospace; padding: 0 4px; color: #1e3a8a; text-transform: uppercase;">SYSTEM_AUTOMATION</span>
                                                </div>
                                                <div><strong>Renewal Request Processed:</strong> <span
                                                        style="display: inline-flex; align-items: center; gap: 4px; margin-left: 5px;"><input
                                                            type="checkbox" checked disabled
                                                            style="width: 11px; height: 11px; margin: 0;"> Yes</span>
                                                    <span
                                                        style="display: inline-flex; align-items: center; gap: 4px; margin-left: 10px;"><input
                                                            type="checkbox" disabled
                                                            style="width: 11px; height: 11px; margin: 0;"> No</span>
                                                </div>
                                                <div><strong>New Card Issued On:</strong> <span
                                                        style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px; color: #047857;">AUTO_APPROVE</span>
                                                </div>
                                            </div>
                                            <div style="text-align: right; margin-top: 15px;">
                                                <div style="display: inline-block; text-align: center;">
                                                    <span
                                                        style="display: block; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.25rem; color: #1e3a8a; font-weight: 700;">VertexGalaxyBank</span>
                                                    <span
                                                        style="border-top: 1px solid #94a3b8; display: inline-block; width: 170px; text-align: center; font-size: 0.7rem; font-weight: 700; padding-top: 2px;">Authorized
                                                        Signature & Seal</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary"
                                        style="width: 100%; padding: 12px; background: #3b82f6; border-color: #3b82f6; font-weight: 600; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-family: 'Poppins', sans-serif;"><i
                                            class="bx bx-check-shield"></i> Confirm and Submit Application Form</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- 2. Modal: Pay Credit Card Dues -->
                    <div id="payDuesModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i
                                        class="bx bx-shield-quarter"></i> Pay Credit Card Dues</h3>
                                <button type="button" onclick="closePayDuesModal()" class="close-btn">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/card?action=payDues" method="post">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" id="duesCardId" name="cardId">
                                <div class="modal-body">
                                    <div
                                        style="background: rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); margin-bottom: 20px;">
                                        <span style="font-size: 0.8rem; color: var(--gray-500); display: block;">Total
                                            Outstanding Dues Billing</span>
                                        <strong id="outstandingDuesValue"
                                            style="font-size: 1.4rem; color: #ef4444; font-weight: 700;">₹ 0.00</strong>
                                    </div>

                                    <div class="form-group" style="margin-bottom: 15px;">
                                        <label for="duesSourceAccount"
                                            style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700);">Select
                                            VGB Account to Pay Dues</label>
                                        <select id="duesSourceAccount" name="accountId" required class="form-select">
                                            <c:forEach items="${accounts}" var="acc">
                                                <option value="${acc.accountId}">
                                                    ${acc.accountNumber} - ${acc.accountType} (Available: ₹
                                                    <fmt:formatNumber value="${acc.balance}" minFractionDigits="2"
                                                        maxFractionDigits="2" />)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group" style="margin-bottom: 25px;">
                                        <label for="duesAmount"
                                            style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700);">Dues
                                            Clearing Payment Amount (INR)</label>
                                        <input type="number" step="0.01" min="1" id="duesAmount" name="amount" required
                                            placeholder="Enter dues amount to pay" class="form-input">
                                    </div>

                                    <button type="submit" class="btn btn-primary"
                                        style="width: 100%; padding: 12px;">Process Card Dues Settlement</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- 3. Modal: Renew Expired/Closed Card -->
                    <div id="renewModal" class="modal">
                        <div class="modal-content" style="max-width: 720px; width: 100%;">
                            <div class="modal-header">
                                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i
                                        class="bx bx-check-shield"></i> ATM Card Renewal request</h3>
                                <button type="button" onclick="closeRenewModal()" class="close-btn">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/card?action=renew" method="post">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" id="renewCardId" name="cardId">
                                <div class="modal-body" style="padding-top: 15px;">
                                    <!-- The Formal Banking Paper Form -->
                                    <div class="renewal-paper-form"
                                        style="background: #fff; border: 1.5px solid var(--gray-200); padding: 25px 20px; border-radius: var(--radius-sm); color: #1e293b; font-family: 'Times New Roman', Times, serif; font-size: 0.95rem; line-height: 1.6; margin-top: 20px; margin-bottom: 15px; width: calc(100% - 40px); box-sizing: border-box; box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm); position: relative; overflow: hidden;">
                                        <!-- Watermark -->
                                        <div
                                            style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 7.5rem; font-weight: 900; color: rgba(99, 102, 241, 0.03); pointer-events: none; user-select: none; font-family: 'Poppins', sans-serif; letter-spacing: 5px;">
                                            VGB</div>

                                        <!-- Form Header -->
                                        <div
                                            style="text-align: center; border-bottom: 2px double #475569; padding-bottom: 12px; margin-bottom: 20px; position: relative;">
                                            <h2
                                                style="font-size: 1.35rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: #0f172a; margin: 0; font-family: 'Poppins', sans-serif;">
                                                Vertex Galaxy Bank</h2>
                                            <h3
                                                style="font-size: 1rem; font-weight: 700; color: #475569; margin: 4px 0 0; text-transform: uppercase; font-family: 'Poppins', sans-serif; letter-spacing: 0.5px;">
                                                ATM Card Renewal Request Form</h3>
                                            <span
                                                style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); font-family: 'Poppins', sans-serif;">
                                                Renewal Fee Due: <strong id="renewFeeValue" style="font-weight: 800;">₹
                                                    250.00</strong>
                                            </span>
                                        </div>

                                        <!-- Header Details -->
                                        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
                                            <tr>
                                                <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                                    <strong>To,</strong><br>
                                                    The Branch Manager<br>
                                                    <strong>Vertex Galaxy Bank</strong><br>
                                                    Branch: <input type="text" name="branch"
                                                        style="width: 250px; border: none; border-bottom: 1px dotted #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; color: #0f172a;"
                                                        value="Main Corporate Branch, Mumbai">
                                                </td>
                                                <td
                                                    style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                                    <strong>Date:</strong> <input type="text" name="formDate"
                                                        id="renewFormDateStr"
                                                        style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;"
                                                        value="">
                                                </td>
                                            </tr>
                                        </table>

                                        <div style="margin-bottom: 20px;">
                                            <strong>Subject:</strong> <span
                                                style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request
                                                for ATM/Debit Card Renewal</span>
                                        </div>

                                        <!-- Customer Info Box -->
                                        <div style="margin-bottom: 20px;">
                                            <h4
                                                style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">
                                                Customer Information</h4>
                                            <table style="width: 100%; border-collapse: collapse;">
                                                <tr>
                                                    <td style="width: 35%; padding: 5px 0;"><strong>Account Holder
                                                            Name:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" id="renewCardHolderName"
                                                            name="cardHolderName" required
                                                            value="${customer.firstName} ${customer.lastName}"
                                                            oninput="updateRenewFormHolderName(this.value)"
                                                            placeholder="ENTER HOLDER NAME"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Account Number:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <select id="renewAccountId" name="accountId" required
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent; cursor: pointer; -webkit-appearance: none; -moz-appearance: none; appearance: none;">
                                                            <c:forEach items="${accounts}" var="acc">
                                                                <option value="${acc.accountId}">
                                                                    ${acc.accountNumber} - ${acc.accountType}
                                                                    (Available: ₹
                                                                    <fmt:formatNumber value="${acc.balance}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />)
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Customer ID (if
                                                            applicable):</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="customerId"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;"
                                                            value="${customer.customerId}">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="mobileNumber"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;"
                                                            value="${customer.phoneNo}">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="emailId"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;"
                                                            value="${customer.email}">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0; vertical-align: top;">
                                                        <strong>Address:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" name="address"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-size: 0.85rem; outline: none; background: transparent; color: #0f172a;"
                                                            value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Card Details Box -->
                                        <div style="margin-bottom: 25px;">
                                            <h4
                                                style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">
                                                ATM/Debit Card Details</h4>
                                            <table style="width: 100%; border-collapse: collapse;">
                                                <tr>
                                                    <td style="width: 45%; padding: 5px 0;"><strong>Existing ATM/Debit
                                                            Card Number (Last 4 Digits):</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" id="renewExistingCardLast4"
                                                            name="existingCardLast4"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1.05rem; outline: none; background: transparent; color: #0f172a;"
                                                            value="">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Card Expiry Date:</strong></td>
                                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                        <input type="text" id="renewCardExpiry" name="cardExpiry"
                                                            style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; outline: none; background: transparent; color: #0f172a;"
                                                            value="">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding: 5px 0;"><strong>Card Network:</strong></td>
                                                    <td
                                                        style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                            <input type="radio" name="cardProvider"
                                                                id="renewProviderRuPay" value="rupay"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            RuPay
                                                        </label>
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                            <input type="radio" name="cardProvider"
                                                                id="renewProviderVisa" value="visa"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            Visa
                                                        </label>
                                                        <label
                                                            style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                            <input type="radio" name="cardProvider"
                                                                id="renewProviderMastercard" value="mastercard"
                                                                style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                            MasterCard
                                                        </label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Declaration & Request text -->
                                        <div
                                            style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                                            <p style="margin: 0 0 10px;"><strong>Request:</strong> I request the bank to
                                                renew and issue a new ATM/Debit Card linked to my account mentioned
                                                above. My existing card is approaching expiry/has expired. I kindly
                                                request you to process my application and issue a renewed card at the
                                                earliest.</p>
                                            <p style="margin: 0;"><strong>Declaration:</strong> I declare that the
                                                information provided above is true and correct.</p>
                                        </div>

                                        <!-- Signatures Row -->
                                        <div
                                            style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                                            <div>
                                                <span
                                                    style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;"
                                                    id="renewFormSignature">${customer.firstName}
                                                    ${customer.lastName}</span>
                                                <span
                                                    style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer
                                                    Signature</span>
                                            </div>
                                            <div style="text-align: right;">
                                                <span
                                                    style="display: block; font-family: monospace; font-size: 0.95rem; font-weight: 600; color: #0f172a; text-transform: uppercase; padding-bottom: 5px;"
                                                    id="renewFormNameLabel">${customer.firstName}
                                                    ${customer.lastName}</span>
                                                <span
                                                    style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Name</span>
                                            </div>
                                        </div>

                                        <!-- For Bank Use Only Stamp Card -->
                                        <div
                                            style="background: rgba(248, 250, 252, 0.9); border: 2px dashed #94a3b8; border-radius: var(--radius-md); padding: 20px; font-size: 0.8rem; color: #475569; font-family: 'Poppins', sans-serif; box-shadow: var(--shadow-sm);">
                                            <h5
                                                style="margin: 0 0 12px; font-size: 0.85rem; font-weight: 800; text-transform: uppercase; color: #334155; text-align: center; border-bottom: 1px dashed #cbd5e1; padding-bottom: 8px; letter-spacing: 0.75px;">
                                                For Bank Use Only</h5>
                                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px 20px;">
                                                <div><strong>Application Received On:</strong> <span
                                                        id="renewFormReceivedOnStr"
                                                        style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px;">____
                                                        / ____ / ______</span></div>
                                                <div><strong>Verified By:</strong> <span
                                                        style="border-bottom: 1px solid #64748b; font-weight: 700; font-family: monospace; padding: 0 4px; color: #1e3a8a; text-transform: uppercase;">SYSTEM_AUTOMATION</span>
                                                </div>
                                                <div><strong>Renewal Request Processed:</strong> <span
                                                        style="display: inline-flex; align-items: center; gap: 4px; margin-left: 5px;"><input
                                                            type="checkbox" checked disabled
                                                            style="width: 11px; height: 11px; margin: 0;"> Yes</span>
                                                    <span
                                                        style="display: inline-flex; align-items: center; gap: 4px; margin-left: 10px;"><input
                                                            type="checkbox" disabled
                                                            style="width: 11px; height: 11px; margin: 0;"> No</span>
                                                </div>
                                                <div><strong>New Card Issued On:</strong> <span
                                                        style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px; color: #047857;">AUTO_APPROVE</span>
                                                </div>
                                            </div>
                                            <div style="text-align: right; margin-top: 15px;">
                                                <div style="display: inline-block; text-align: center;">
                                                    <span
                                                        style="display: block; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.25rem; color: #1e3a8a; font-weight: 700;">VertexGalaxyBank</span>
                                                    <span
                                                        style="border-top: 1px solid #94a3b8; display: inline-block; width: 170px; text-align: center; font-size: 0.7rem; font-weight: 700; padding-top: 2px;">Authorized
                                                        Signature & Seal</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary"
                                        style="width: 100%; padding: 12px; background: #10b981; border-color: #10b981; font-weight: 600; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-family: 'Poppins', sans-serif;"><i
                                            class="bx bx-check-shield"></i> Confirm and Submit Renewal Form</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- 4. Modal: Manage Card Controls & Limits -->
                    <div id="limitsModal" class="modal">
                        <div class="modal-content" style="max-width: 500px; width: 100%;">
                            <div class="modal-header">
                                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;"><i
                                        class="bx bx-slider-alt" style="color: var(--primary-500);"></i> Card Controls & Limits</h3>
                                <button type="button" onclick="closeLimitsModal()" class="close-btn">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/card?action=updateLimits" method="post">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" id="limitsCardId" name="cardId">
                                <div class="modal-body" style="padding: 25px; display: flex; flex-direction: column; gap: 20px;">
                                    <!-- Daily Limit Slider -->
                                    <div class="form-group">
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                            <label for="dailyLimitRange" style="font-size: 0.9rem; font-weight: 600; color: var(--gray-700);">Daily Transaction Limit</label>
                                            <span id="dailyLimitVal" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); font-weight: 700; font-size: 0.85rem; padding: 2px 8px; border-radius: var(--radius-sm);">₹ 50,000</span>
                                        </div>
                                        <input type="range" id="dailyLimitRange" min="1000" max="200000" step="1000" class="limit-slider" style="width: 100%; cursor: pointer;" oninput="updateLimitVal('dailyLimit', this.value)">
                                        <input type="hidden" id="dailyLimitInput" name="dailyLimit">
                                        <small style="color: var(--gray-400); font-size: 0.75rem;">Max daily spend capacity across all transactions</small>
                                    </div>

                                    <!-- ATM Limit Slider -->
                                    <div class="form-group">
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                            <label for="atmLimitRange" style="font-size: 0.9rem; font-weight: 600; color: var(--gray-700);">ATM Cash Withdrawal Limit</label>
                                            <span id="atmLimitVal" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); font-weight: 700; font-size: 0.85rem; padding: 2px 8px; border-radius: var(--radius-sm);">₹ 25,000</span>
                                        </div>
                                        <input type="range" id="atmLimitRange" min="1000" max="100000" step="1000" class="limit-slider" style="width: 100%; cursor: pointer;" oninput="updateLimitVal('atmLimit', this.value)">
                                        <input type="hidden" id="atmLimitInput" name="atmLimit">
                                        <small style="color: var(--gray-400); font-size: 0.75rem;">Max daily withdrawal capacity at ATMs</small>
                                    </div>

                                    <!-- Online Limit Slider -->
                                    <div class="form-group">
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                            <label for="onlineLimitRange" style="font-size: 0.9rem; font-weight: 600; color: var(--gray-700);">Online & POS Shopping Limit</label>
                                            <span id="onlineLimitVal" style="background: rgba(245, 158, 11, 0.1); color: #d97706; font-weight: 700; font-size: 0.85rem; padding: 2px 8px; border-radius: var(--radius-sm);">₹ 50,000</span>
                                        </div>
                                        <input type="range" id="onlineLimitRange" min="1000" max="200000" step="1000" class="limit-slider" style="width: 100%; cursor: pointer;" oninput="updateLimitVal('onlineLimit', this.value)">
                                        <input type="hidden" id="onlineLimitInput" name="onlineLimit">
                                        <small style="color: var(--gray-400); font-size: 0.75rem;">Max daily limit for E-Commerce, online, and POS store purchases</small>
                                    </div>

                                    <!-- International Toggle -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; background: rgba(99, 102, 241, 0.04); padding: 15px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.08); margin-bottom: 5px;">
                                        <div style="display: flex; flex-direction: column; gap: 2px;">
                                            <strong style="font-size: 0.9rem; color: var(--gray-800);">International Usage</strong>
                                            <small style="color: var(--gray-400); font-size: 0.75rem;">Allow transactions outside India</small>
                                        </div>
                                        <label class="switch-toggle">
                                            <input type="checkbox" id="intlEnabledCheckbox" onchange="updateIntlInput(this.checked)">
                                            <span class="slider-toggle-round"></span>
                                        </label>
                                        <input type="hidden" id="intlEnabledInput" name="internationalEnabled">
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 5px; font-weight: 600;">
                                        Save Control Preferences
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
                    <script>
                        function openApplyModal() {
                            // Initialize dates inside the paper form
                            const today = new Date();
                            const dd = String(today.getDate()).padStart(2, '0');
                            const mm = String(today.getMonth() + 1).padStart(2, '0'); // January is 0!
                            const yyyy = today.getFullYear();
                            const dateStr = dd + ' / ' + mm + ' / ' + yyyy;

                            document.getElementById('applyFormDateStr').value = dateStr;
                            document.getElementById('applyFormReceivedOnStr').textContent = dateStr;

                            // Sync card type fee
                            updateApplyFeeAndNotice('debit');

                            // Sync holder name & signature
                            const inputName = document.getElementById('applyCardHolderName').value;
                            updateApplyFormHolderName(inputName);

                            document.getElementById('applyModal').style.display = 'flex';
                        }
                        function closeApplyModal() {
                            document.getElementById('applyModal').style.display = 'none';
                        }

                        function openPayDuesModal(cardId, outstanding) {
                            document.getElementById('duesCardId').value = cardId;
                            document.getElementById('outstandingDuesValue').textContent = '₹ ' + parseFloat(outstanding).toFixed(2);
                            document.getElementById('duesAmount').value = parseFloat(outstanding).toFixed(2);
                            document.getElementById('duesAmount').max = outstanding;
                            document.getElementById('payDuesModal').style.display = 'flex';
                        }
                        function closePayDuesModal() {
                            document.getElementById('payDuesModal').style.display = 'none';
                        }

                        function openRenewModal(cardId, cardType, fee, cardNumber, expiry, provider) {
                            document.getElementById('renewCardId').value = cardId;
                            document.getElementById('renewFeeValue').textContent = '₹ ' + parseFloat(fee).toFixed(2);

                            // Extract last 4 digits of card number
                            const cleanCardNo = cardNumber.replace(/\s+/g, '');
                            const last4 = cleanCardNo.slice(-4);
                            document.getElementById('renewExistingCardLast4').value = last4;

                            // Set expiry date
                            document.getElementById('renewCardExpiry').value = expiry;

                            // Check the matching provider radio button
                            const provClean = provider.toLowerCase();
                            if (provClean === 'rupay') {
                                document.getElementById('renewProviderRuPay').checked = true;
                            } else if (provClean === 'visa') {
                                document.getElementById('renewProviderVisa').checked = true;
                            } else if (provClean === 'mastercard') {
                                document.getElementById('renewProviderMastercard').checked = true;
                            }

                            // Dynamic form date (today)
                            const today = new Date();
                            const dd = String(today.getDate()).padStart(2, '0');
                            const mm = String(today.getMonth() + 1).padStart(2, '0'); // January is 0!
                            const yyyy = today.getFullYear();
                            const dateStr = dd + ' / ' + mm + ' / ' + yyyy;
                            document.getElementById('renewFormDateStr').value = dateStr;
                            document.getElementById('renewFormReceivedOnStr').textContent = dateStr;

                            // Bind default signature
                            const nameVal = document.getElementById('renewCardHolderName').value;
                            updateRenewFormHolderName(nameVal);

                            document.getElementById('renewModal').style.display = 'flex';
                        }
                        function closeRenewModal() {
                            document.getElementById('renewModal').style.display = 'none';
                        }

                        function openLimitsModal(cardId, dailyLimit, atmLimit, onlineLimit, internationalEnabled) {
                            document.getElementById('limitsCardId').value = cardId;
                            
                            const dLim = parseInt(parseFloat(dailyLimit)) || 50000;
                            const aLim = parseInt(parseFloat(atmLimit)) || 25000;
                            const oLim = parseInt(parseFloat(onlineLimit)) || 50000;
                            
                            document.getElementById('dailyLimitRange').value = dLim;
                            document.getElementById('dailyLimitInput').value = dLim;
                            document.getElementById('dailyLimitVal').textContent = '₹ ' + dLim.toLocaleString('en-IN');
                            
                            document.getElementById('atmLimitRange').value = aLim;
                            document.getElementById('atmLimitInput').value = aLim;
                            document.getElementById('atmLimitVal').textContent = '₹ ' + aLim.toLocaleString('en-IN');
                            
                            document.getElementById('onlineLimitRange').value = oLim;
                            document.getElementById('onlineLimitInput').value = oLim;
                            document.getElementById('onlineLimitVal').textContent = '₹ ' + oLim.toLocaleString('en-IN');
                            
                            const isIntl = internationalEnabled === true || internationalEnabled === 'true' || internationalEnabled === 1;
                            document.getElementById('intlEnabledCheckbox').checked = isIntl;
                            document.getElementById('intlEnabledInput').value = isIntl ? 'true' : 'false';
                            
                            document.getElementById('limitsModal').style.display = 'flex';
                        }

                        function closeLimitsModal() {
                            document.getElementById('limitsModal').style.display = 'none';
                        }

                        function updateLimitVal(type, val) {
                            const parsedVal = parseInt(val) || 0;
                            document.getElementById(type + 'Input').value = parsedVal;
                            document.getElementById(type + 'Val').textContent = '₹ ' + parsedVal.toLocaleString('en-IN');
                        }

                        function updateIntlInput(checked) {
                            document.getElementById('intlEnabledInput').value = checked ? 'true' : 'false';
                        }

                        function updateApplyFeeAndNotice(cardType) {
                            const feeValue = cardType === 'credit' ? '500.00' : '250.00';
                            document.getElementById('applyFeeValue').textContent = '₹ ' + feeValue;
                        }

                        function updateApplyFormHolderName(nameValue) {
                            const cleanName = nameValue.trim().toUpperCase() || '_________________________________';
                            const cleanSign = nameValue.trim().toUpperCase() || '____________________';
                            document.getElementById('applyFormNameLabel').textContent = cleanName;
                            document.getElementById('applyFormSignature').textContent = cleanSign;
                        }

                        function updateRenewFormHolderName(nameValue) {
                            const cleanName = nameValue.trim().toUpperCase() || '_________________________________';
                            const cleanSign = nameValue.trim().toUpperCase() || '____________________';
                            document.getElementById('renewFormNameLabel').textContent = cleanName;
                            document.getElementById('renewFormSignature').textContent = cleanSign;
                        }

                        function toggleCvv(element, cvv) {
                            const cvvText = element.querySelector('.cvv-text');
                            if (cvvText.textContent === '•••') {
                                cvvText.textContent = cvv;
                                element.title = "Click to hide CVV";
                            } else {
                                cvvText.textContent = '•••';
                                element.title = "Click to show CVV";
                            }
                        }

                        // Click outside modals to close
                        window.onclick = function (event) {
                            const applyModal = document.getElementById('applyModal');
                            const duesModal = document.getElementById('payDuesModal');
                            const renewModal = document.getElementById('renewModal');
                            const limitsModal = document.getElementById('limitsModal');
                            if (event.target === applyModal) {
                                closeApplyModal();
                            }
                            if (event.target === duesModal) {
                                closePayDuesModal();
                            }
                            if (event.target === renewModal) {
                                closeRenewModal();
                            }
                            if (event.target === limitsModal) {
                                closeLimitsModal();
                            }
                        }

                        document.addEventListener('DOMContentLoaded', () => {
                            // Mobile sidebar toggle handler
                            const mobileToggle = document.getElementById('mobileNavToggle');
                            const sidebar = document.querySelector('.sidebar');
                            if (mobileToggle && sidebar) {
                                mobileToggle.addEventListener('click', (e) => {
                                    e.stopPropagation();
                                    sidebar.classList.toggle('active');
                                    const icon = mobileToggle.querySelector('i');
                                    if (sidebar.classList.contains('active')) {
                                        icon.className = 'bx bx-x';
                                    } else {
                                        icon.className = 'bx bx-menu';
                                    }
                                });

                                // Close sidebar if clicking outside
                                document.addEventListener('click', (e) => {
                                    if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                                        sidebar.classList.remove('active');
                                        mobileToggle.querySelector('i').className = 'bx bx-menu';
                                    }
                                });
                            }
                        });
                    </script>
                </body>

                </html>