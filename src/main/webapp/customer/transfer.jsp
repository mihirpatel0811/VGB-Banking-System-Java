<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (request.getAttribute("customer") == null) {
        Long customerId = null;
        Object sessionUser = session.getAttribute(com.vgb.constants.AppConstants.USER_SESSION_KEY);
        if (sessionUser != null) {
            customerId = Long.parseLong(sessionUser.toString());
        }
        if (customerId != null) {
            try {
                com.vgb.model.Customer sessionCustomer = new com.vgb.service.CustomerService().getCustomerById(customerId);
                request.setAttribute("customer", sessionCustomer);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Transfer Funds</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        /* Base page layout overrides */
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
        body.dark-mode .sidebar {
            background: rgba(30, 41, 59, 0.9) !important;
            border-right-color: rgba(255, 255, 255, 0.08) !important;
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
        body.dark-mode .sidebar-menu a {
            color: var(--gray-400) !important;
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
        body.dark-mode .sidebar-menu a.active {
            color: white !important;
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
        body.dark-mode .footer {
            background: var(--gray-100) !important;
            border-top-color: rgba(255, 255, 255, 0.08) !important;
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
        body.dark-mode .btn-logout {
            color: var(--gray-400) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
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

        /* Glass Cards and Containers */
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: var(--radius-lg);
            padding: 35px;
            box-shadow: var(--shadow-md), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        body.dark-mode .glass-card {
            background: rgba(30, 41, 59, 0.65) !important;
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
            box-shadow: var(--shadow-xl);
        }
        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.25);
        }

        /* Portal Navigation Tabs */
        .portal-tab-btn {
            padding: 14px 26px !important;
            font-weight: 600 !important;
            font-size: 0.88rem !important;
            border-radius: var(--radius-md) !important;
            cursor: pointer !important;
            border: 1.5px solid rgba(99, 102, 241, 0.15) !important;
            background: rgba(255, 255, 255, 0.6) !important;
            color: var(--gray-600) !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 10px !important;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
            backdrop-filter: blur(10px) !important;
            box-shadow: var(--shadow-sm) !important;
            outline: none;
        }
        body.dark-mode .portal-tab-btn {
            background: rgba(30, 41, 59, 0.5) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            color: var(--gray-400) !important;
        }
        .portal-tab-btn:hover {
            border-color: var(--primary-400) !important;
            color: var(--primary-500) !important;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.15) !important;
            background: rgba(99, 102, 241, 0.05) !important;
        }
        body.dark-mode .portal-tab-btn:hover {
            background: rgba(99, 102, 241, 0.08) !important;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3) !important;
            color: white !important;
        }
        .portal-tab-btn.active {
            background: var(--gradient-primary) !important;
            color: white !important;
            border-color: transparent !important;
            box-shadow: 0 10px 22px rgba(99, 102, 241, 0.25) !important;
            transform: translateY(-2px) !important;
        }
        body.dark-mode .portal-tab-btn.active {
            box-shadow: 0 10px 22px rgba(99, 102, 241, 0.35) !important;
        }

        .portal-form-section {
            display: none;
        }
        .portal-form-section.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Unified Form Styling */
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 10px;
        }
        body.dark-mode .form-group label {
            color: var(--gray-800);
        }

        /* Modern Input Styling with prepended icon wrappers */
        .input-icon-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-icon-wrapper i {
            position: absolute;
            left: 16px;
            color: var(--gray-400);
            font-size: 1.2rem;
            pointer-events: none;
            transition: color 0.3s ease;
        }
        .input-icon-wrapper .form-control-modern {
            padding-left: 46px;
        }
        .form-control-modern {
            width: 100%;
            padding: 14px 18px;
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            background: rgba(255, 255, 255, 0.85);
            color: var(--gray-800);
            font-family: inherit;
            font-size: 0.95rem;
            outline: none;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        body.dark-mode .form-control-modern {
            background: rgba(30, 41, 59, 0.6);
            border-color: rgba(255, 255, 255, 0.08);
            color: var(--gray-800);
        }
        .form-control-modern:focus {
            border-color: var(--primary-400);
            background: white;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15), 0 4px 12px rgba(99, 102, 241, 0.05);
        }
        body.dark-mode .form-control-modern:focus {
            background: rgba(30, 41, 59, 0.8);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.25);
        }
        .input-icon-wrapper:focus-within i {
            color: var(--primary-500);
        }

        /* Option Card Checkbox Switch */
        .custom-option-card {
            background: rgba(99, 102, 241, 0.02);
            border: 1.5px dashed rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            padding: 18px;
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }
        body.dark-mode .custom-option-card {
            background: rgba(99, 102, 241, 0.01);
            border-color: rgba(255, 255, 255, 0.08);
        }
        .custom-option-card:hover {
            background: rgba(99, 102, 241, 0.04);
            border-color: rgba(99, 102, 241, 0.3);
        }

        /* Premium Buttons */
        .btn-submit-premium {
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 15px 30px;
            font-weight: 700;
            font-size: 0.95rem;
            border-radius: var(--radius-md);
            border: none;
            background: var(--gradient-primary);
            color: white !important;
            cursor: pointer;
            box-shadow: 0 8px 24px rgba(99, 102, 241, 0.22);
            transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }
        .btn-submit-premium:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(99, 102, 241, 0.32);
        }
        .btn-submit-premium:active {
            transform: scale(0.96) !important;
        }
        .btn-submit-premium i {
            font-size: 1.2rem;
            transition: transform 0.3s ease;
        }
        .btn-submit-premium:hover i {
            transform: scale(1.15) rotate(5deg);
        }

        /* Premium Glassmorphic Account Cards */
        .account-selector-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
            margin-top: 8px;
        }
        /* Premium Physical Account Cards */
        .account-select-card {
            position: relative;
            border-radius: 16px;
            padding: 22px;
            cursor: pointer;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 160px;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white !important;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15);
        }

        /* Default Card Theme */
        .account-select-card.type-default {
            background: linear-gradient(135deg, #4f46e5 0%, #3730a3 100%);
        }
        /* Savings Account Theme (Deep Royal Blue/Violet Metallic) */
        .account-select-card.type-savings {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #1e1b4b 100%);
        }
        /* Current Account Theme (Sleek Charcoal/Carbon Black) */
        .account-select-card.type-current {
            background: linear-gradient(135deg, #2d3748 0%, #1a202c 60%, #0d1117 100%);
            border-color: rgba(255, 255, 255, 0.08);
        }
        /* Salary Account Theme (Teal/Emerald Green Accent) */
        .account-select-card.type-salary {
            background: linear-gradient(135deg, #0d9488 0%, #0f766e 60%, #115e59 100%);
        }
        /* Beneficiary Directory Theme (Mint/Emerald Green Accent) */
        .account-select-card.type-beneficiary {
            background: linear-gradient(135deg, #059669 0%, #047857 50%, #064e3b 100%);
        }

        /* Glossy specular shine overlay */
        .account-select-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 60%);
            pointer-events: none;
            transition: transform 0.6s ease;
        }
        .account-select-card:hover::before {
            transform: translate(10%, 10%);
        }

        /* Dark mode opacity adjustments to keep backgrounds vibrant */
        body.dark-mode .account-select-card {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
        }

        /* Hover elevation and slight scaling */
        .account-select-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25);
            filter: brightness(1.06);
        }

        /* Selected active state card styling */
        .account-select-card.active {
            border: 2.5px solid #ffffff;
            box-shadow: 0 0 22px rgba(255, 255, 255, 0.45), 0 16px 32px rgba(0, 0, 0, 0.3);
            transform: translateY(-4px) scale(1.02);
        }

        /* Active checkmark design inside card */
        .account-select-card.active::after {
            content: '✓';
            position: absolute;
            top: 14px;
            right: 14px;
            background: #ffffff;
            color: #1e3c72;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.82rem;
            font-weight: 800;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.25);
            z-index: 5;
        }

        /* Checkmark text color matching based on card theme */
        .account-select-card.active.type-savings::after {
            color: #1e3c72;
        }
        .account-select-card.active.type-current::after {
            color: #1a202c;
        }
        .account-select-card.active.type-salary::after {
            color: #0f766e;
        }
        .account-select-card.active.type-beneficiary::after {
            color: #047857;
        }
        .account-select-card.active.type-default::after {
            color: #3730a3;
        }

        .acc-card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .acc-chip-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .acc-card-chip {
            border-radius: 4px;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
        }
        .acc-card-bank {
            font-size: 0.75rem;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.9) !important;
            letter-spacing: 1.2px;
        }
        .account-select-card.active .acc-card-bank {
            color: rgba(255, 255, 255, 1) !important;
        }
        .acc-card-badge {
            font-size: 0.65rem;
            font-weight: 700;
            background: rgba(255, 255, 255, 0.18) !important;
            color: white !important;
            padding: 4px 10px;
            border-radius: 6px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(5px);
            text-transform: uppercase;
        }
        .account-select-card.active .acc-card-badge {
            background: rgba(255, 255, 255, 0.28) !important;
            border-color: rgba(255, 255, 255, 0.4);
        }
        .acc-card-body {
            margin-bottom: 10px;
        }
        .acc-card-num {
            display: block;
            font-family: monospace;
            font-size: 0.98rem;
            color: rgba(255, 255, 255, 0.85) !important;
            font-weight: 600;
            letter-spacing: 1.5px;
            margin-top: 15px;
        }
        .account-select-card.active .acc-card-num {
            color: rgba(255, 255, 255, 1) !important;
        }
        .acc-card-footer {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
        }
        .acc-bal-group {
            display: flex;
            flex-direction: column;
        }
        .acc-bal-label {
            font-size: 0.62rem;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.6) !important;
            font-weight: 600;
            letter-spacing: 0.8px;
        }
        .acc-bal-amount {
            display: block;
            font-size: 1.35rem;
            font-weight: 800;
            color: white !important;
            margin-top: 2px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.25);
        }

        /* Realistic ATM/Credit Cards selector */
        .card-selector-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 12px;
            margin-bottom: 12px;
        }
        .card-select-card {
            position: relative;
            border-radius: 16px;
            padding: 22px;
            color: white;
            cursor: pointer;
            overflow: hidden;
            aspect-ratio: 1.586;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.08);
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #334155 100%);
        }
        .card-select-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }
        .card-select-card:hover::before {
            opacity: 1;
        }
        .card-select-card:hover {
            transform: translateY(-6px) rotateX(4deg) rotateY(2deg);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }
        .card-select-card.active {
            box-shadow: 0 0 0 3px var(--primary-500), 0 20px 40px rgba(99, 102, 241, 0.3);
            border-color: transparent;
        }
        .card-select-card.active::after {
            content: '✓';
            position: absolute;
            top: 14px;
            right: 14px;
            background: var(--primary-500);
            color: white;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.25);
            z-index: 5;
        }
        
        /* Premium Card Brands gradients */
        .card-select-card.card-platinum,
        .card-select-card[class*="platinum"] {
            background: linear-gradient(135deg, #1e1b4b 0%, #311042 50%, #030712 100%);
        }
        .card-select-card.card-platinum.active,
        .card-select-card[class*="platinum"].active {
            box-shadow: 0 0 0 3px var(--primary-400), 0 20px 40px rgba(129, 140, 248, 0.35);
        }

        .card-select-card.card-gold,
        .card-select-card[class*="gold"] {
            background: linear-gradient(135deg, #27272a 0%, #1c1917 60%, #b45309 100%);
        }
        .card-select-card.card-gold.active,
        .card-select-card[class*="gold"].active {
            box-shadow: 0 0 0 3px var(--accent-amber), 0 20px 40px rgba(245, 158, 11, 0.35);
        }

        .card-select-card.card-signature,
        .card-select-card[class*="signature"] {
            background: linear-gradient(135deg, #064e3b 0%, #022c22 60%, #1e1b4b 100%);
        }
        .card-select-card.card-signature.active,
        .card-select-card[class*="signature"].active {
            box-shadow: 0 0 0 3px var(--accent-emerald), 0 20px 40px rgba(16, 185, 129, 0.35);
        }

        /* Inner card UI */
        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-brand-label {
            font-size: 0.8rem;
            font-weight: 800;
            letter-spacing: 1.5px;
            opacity: 0.9;
        }
        .card-contactless {
            font-size: 1.2rem;
            opacity: 0.7;
        }
        .card-chip-row {
            margin-top: 5px;
            display: flex;
            align-items: center;
        }
        .card-chip {
            border-radius: 4px;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
        }
        .card-middle {
            margin-top: 15px;
        }
        .card-number-display {
            font-family: 'Courier New', Courier, monospace;
            font-size: 1.15rem;
            font-weight: bold;
            letter-spacing: 2px;
            word-spacing: 4px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }
        .card-bottom {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 10px;
        }
        .card-holder-info {
            display: flex;
            flex-direction: column;
        }
        .card-field-lbl {
            font-size: 0.55rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.5;
        }
        .card-val {
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.3);
        }
        .card-brand-network {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        .card-network-name {
            font-size: 0.9rem;
            font-weight: 800;
            font-style: italic;
            opacity: 0.95;
            letter-spacing: 0.5px;
        }

        /* Quick amount buttons */
        .quick-amounts {
            display: flex;
            gap: 8px;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .quick-amount-chip {
            padding: 7px 14px;
            border-radius: var(--radius-full);
            border: 1px solid rgba(99, 102, 241, 0.15);
            background: rgba(255, 255, 255, 0.6);
            color: var(--gray-600);
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        body.dark-mode .quick-amount-chip {
            background: rgba(30, 41, 59, 0.5);
            border-color: rgba(255, 255, 255, 0.08);
            color: var(--gray-300);
        }
        .quick-amount-chip:hover {
            background: var(--primary-500);
            color: white !important;
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.2);
        }
        .quick-amount-chip:active {
            transform: translateY(0);
        }

        /* CVV Toggle styling */
        .cvv-input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
            width: 100%;
        }
        .btn-cvv-toggle {
            position: absolute;
            right: 14px;
            border: none;
            background: none;
            cursor: pointer;
            color: var(--gray-400);
            font-size: 1.15rem;
            padding: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            outline: none;
            transition: color 0.2s ease;
        }
        .btn-cvv-toggle:hover {
            color: var(--primary-500);
        }

        /* Verified Invoice Style Receipt */
        .verification-receipt-card {
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid rgba(16, 185, 129, 0.2);
            position: relative;
            padding: 30px 24px;
            border-radius: 4px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            margin-top: 30px;
            animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        body.dark-mode .verification-receipt-card {
            background: rgba(21, 32, 43, 0.95);
            border-color: rgba(16, 185, 129, 0.3);
        }
        /* Top torn edge */
        .verification-receipt-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background-size: 16px 8px;
            background-image: linear-gradient(135deg, var(--gray-50) 4px, transparent 0),
                              linear-gradient(225deg, var(--gray-50) 4px, transparent 0);
        }
        /* Bottom torn edge */
        .verification-receipt-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background-size: 16px 8px;
            background-image: linear-gradient(45deg, var(--gray-50) 4px, transparent 0),
                              linear-gradient(-45deg, var(--gray-50) 4px, transparent 0);
        }
        .receipt-dashed-line {
            border-top: 1.5px dashed rgba(16, 185, 129, 0.25);
            margin: 20px 0;
            position: relative;
        }
        .receipt-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px 20px;
        }
        @media (max-width: 480px) {
            .receipt-grid {
                grid-template-columns: 1fr;
            }
        }
        .receipt-item span {
            font-size: 0.72rem;
            text-transform: uppercase;
            color: var(--gray-400);
            font-weight: 700;
            letter-spacing: 0.5px;
            display: block;
        }
        .receipt-item strong {
            display: block;
            font-size: 0.95rem;
            color: var(--gray-800);
            margin-top: 4px;
        }
        body.dark-mode .receipt-item strong {
            color: white !important;
        }

        /* Receipt verified clearance stamp */
        .receipt-stamp {
            position: absolute;
            top: 20px;
            right: 25px;
            width: 75px;
            height: 75px;
            border: 3px double #10b981;
            border-radius: 50%;
            color: #10b981;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.62rem;
            text-transform: uppercase;
            transform: rotate(-15deg);
            opacity: 0.85;
            user-select: none;
            pointer-events: none;
            box-shadow: inset 0 0 0 2px #10b981;
            animation: stampIn 0.55s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
        }
        @keyframes stampIn {
            0% { transform: rotate(0deg) scale(2.2); opacity: 0; }
            100% { transform: rotate(-15deg) scale(1); opacity: 0.85; }
        }

        /* Glass Alerts */
        .glass-alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            border-radius: var(--radius-md);
            margin-bottom: 25px;
            font-size: 0.88rem;
            font-weight: 500;
            border: 1px solid transparent;
            backdrop-filter: blur(10px);
            animation: fadeIn 0.4s ease;
        }
        .glass-alert-danger {
            background: rgba(239, 68, 68, 0.08);
            border-color: rgba(239, 68, 68, 0.2);
            color: #b91c1c;
        }
        .glass-alert-success {
            background: rgba(16, 185, 129, 0.08);
            border-color: rgba(16, 185, 129, 0.2);
            color: #047857;
        }
        
        .btn-verify-modern {
            padding: 12px 26px;
            font-weight: 700;
            font-size: 0.85rem;
            border-radius: var(--radius-md);
            border: 1.5px solid rgba(99, 102, 241, 0.2);
            background: transparent;
            color: var(--primary-600) !important;
            cursor: pointer;
            transition: all var(--transition-normal);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            outline: none;
        }
        .btn-verify-modern:hover {
            background: rgba(99, 102, 241, 0.05);
            border-color: var(--primary-400);
            transform: translateY(-1px);
        }
        .btn-verify-modern:active {
            transform: scale(0.96) !important;
        }

        /* Search Autocomplete selects */
        .search-select-wrapper {
            position: relative;
            margin-bottom: 20px;
        }
        .search-select-input {
            width: 100%;
            padding: 14px 18px 14px 44px;
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            outline: none;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.85);
            color: var(--gray-800);
            font-size: 0.95rem;
            transition: all var(--transition-normal);
        }
        body.dark-mode .search-select-input {
            background: rgba(30, 41, 59, 0.6);
            border-color: rgba(255, 255, 255, 0.08);
            color: var(--gray-800);
        }
        .search-select-input:focus {
            border-color: var(--primary-500);
            background: white;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15), 0 4px 12px rgba(99, 102, 241, 0.05);
        }
        body.dark-mode .search-select-input:focus {
            background: rgba(30, 41, 59, 0.8);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.25);
        }
        .search-select-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.25rem;
        }
        .search-select-arrow {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.25rem;
            pointer-events: none;
            transition: transform 0.3s ease;
        }
        .search-select-wrapper.active .search-select-arrow {
            transform: translateY(-50%) rotate(180deg);
        }
        .search-select-wrapper.active .search-select-icon {
            color: var(--primary-500);
        }
        .search-select-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            z-index: 1000;
            max-height: 230px;
            overflow-y: auto;
            margin-top: 6px;
            display: none;
            animation: fadeIn 0.22s cubic-bezier(0.4, 0, 0.2, 1);
        }
        body.dark-mode .search-select-results {
            background: #1e293b;
            border-color: rgba(255, 255, 255, 0.08);
            box-shadow: var(--shadow-xl);
        }
        .search-select-item {
            padding: 12px 18px;
            cursor: pointer;
            border-bottom: 1px solid rgba(99, 102, 241, 0.08);
            display: flex;
            flex-direction: column;
            gap: 4px;
            transition: background 0.2s ease;
        }
        body.dark-mode .search-select-item {
            border-bottom-color: rgba(255, 255, 255, 0.05);
        }
        .search-select-item:hover {
            background: rgba(99, 102, 241, 0.06);
        }
        .search-select-item-title {
            font-weight: 600;
            color: var(--gray-800);
            font-size: 0.88rem;
        }
        body.dark-mode .search-select-item-title {
            color: var(--gray-200);
        }
        .search-select-item-subtitle {
            font-size: 0.78rem;
            color: var(--gray-400);
            font-family: monospace;
        }
        .search-select-empty {
            padding: 18px;
            color: var(--gray-400);
            text-align: center;
            font-size: 0.88rem;
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
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty customer}">
                        <c:choose>
                            <c:when test="${not empty customer.avatarPath}">
                                <img src="${pageContext.request.contextPath}${customer.avatarPath}" alt="Customer Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; border: 2px solid white; box-shadow: var(--shadow-sm); text-transform: uppercase;">
                                    ${customer.fullName.substring(0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                            <span style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                            <span style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
                                Customer Space
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gray-100); color: var(--gray-500); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1.5px solid var(--gray-200);">
                            <i class="bx bx-user"></i>
                        </div>
                        <span style="font-weight: 600; color: var(--gray-700); font-size: 0.85rem;" class="mobile-hide">Customer Space</span>
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
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage" class="active"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/card-repayment?action=history"><i class="bx bx-receipt"></i> Card Repayments</a>
            <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard"><i class="bx bx-sync"></i> Auto Pay</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Support Hotline</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">1800-VGB-BANK</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Digital Operations Portal</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Transfer funds or request cash counter withdrawals through our secure digital gateway.</p>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error or not empty sessionScope.error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                    <span>${not empty error ? error : sessionScope.error}</span>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>
            <c:if test="${not empty success or not empty sessionScope.success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                    <span>${not empty success ? success : sessionScope.success}</span>
                </div>
                <c:remove var="success" scope="session" />
            </c:if>

            <!-- Portal Tab Navigation Bar -->
            <div style="display: flex; gap: 15px; margin-bottom: 30px; flex-wrap: wrap;">
                <button type="button" id="tabBtnTransfer" onclick="showPortalTab('transfer')" class="portal-tab-btn active">
                    <i class="bx bx-send"></i> Fund Transfer
                </button>
                <button type="button" id="tabBtnWithdraw" onclick="showPortalTab('withdraw')" class="portal-tab-btn">
                    <i class="bx bx-down-arrow-circle"></i> Cash Withdrawal
                </button>

                <button type="button" id="tabBtnAddBeneficiary" onclick="showPortalTab('addBeneficiary')" class="portal-tab-btn">
                    <i class="bx bx-user-plus"></i> Add Beneficiary
                </button>
            </div>

            <div class="portal-workspace-grid">
                <!-- Portal Workspace -->
                <div class="glass-card">
                    
                    <!-- SECTION 1: FUND TRANSFER -->
                    <div id="secTransfer" class="portal-form-section active">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-send"></i> New Transfer Request
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=transfer" method="post" onsubmit="return validateTransferForm(event)">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Source Account Select Dropdown -->
                            <div class="form-group">
                                <label>Select Source Account</label>
                                <select id="transferSourceAccount" name="fromAccountId" required style="display: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="account-selector-grid" id="gridTransferSource">
                                    <c:forEach items="${accounts}" var="acc" varStatus="vs">
                                        <c:set var="cardTypeClass" value="type-default" />
                                        <c:if test="${acc.accountType == 'Savings' or acc.accountType == 'SAVINGS' or acc.accountType == 'savings'}">
                                            <c:set var="cardTypeClass" value="type-savings" />
                                        </c:if>
                                        <c:if test="${acc.accountType == 'Current' or acc.accountType == 'CURRENT' or acc.accountType == 'current'}">
                                            <c:set var="cardTypeClass" value="type-current" />
                                        </c:if>
                                        <c:if test="${acc.accountType == 'Salary' or acc.accountType == 'SALARY' or acc.accountType == 'salary'}">
                                            <c:set var="cardTypeClass" value="type-salary" />
                                        </c:if>
                                        <div class="account-select-card ${vs.first ? 'active' : ''} ${cardTypeClass}" data-value="${acc.accountId}">
                                            <div class="acc-card-top">
                                                <div class="acc-chip-container">
                                                    <svg class="acc-card-chip" width="28" height="20" viewBox="0 0 32 24" fill="none">
                                                        <defs>
                                                            <linearGradient id="chip-gold-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                                                                <stop offset="0%" stop-color="#ffe259"/>
                                                                <stop offset="100%" stop-color="#ffa751"/>
                                                            </linearGradient>
                                                        </defs>
                                                        <rect width="32" height="24" rx="4" fill="url(#chip-gold-grad)" />
                                                        <path d="M0 8H8V16H0V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M24 8H32V16H24V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M8 0V8H24V0H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M8 16V24H24V16H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M12 8V16H20V8H12Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                    </svg>
                                                    <span class="acc-card-bank">VGB BANK</span>
                                                </div>
                                                <span class="acc-card-badge">${acc.accountType}</span>
                                            </div>
                                            <div class="acc-card-body">
                                                <span class="acc-card-num">${acc.accountNumber}</span>
                                            </div>
                                            <div class="acc-card-footer">
                                                <div class="acc-bal-group">
                                                    <span class="acc-bal-label">Available Balance</span>
                                                    <span class="acc-bal-amount">₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ATM Card payment checkbox -->
                            <div class="custom-option-card">
                                <label style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primary-500); cursor: pointer; margin-bottom: 0;">
                                    <input type="checkbox" id="transferUseCard" name="useCard" value="true" onchange="toggleTransferCardFields()" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                    <span>Pay using active VGB ATM Card (Debit/Credit)</span>
                                </label>
                                
                                <div id="transferCardFields" style="display: none; margin-top: 20px; border-top: 1px solid rgba(99, 102, 241, 0.15); padding-top: 20px;">
                                    <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 20px; margin-bottom: 12px;" class="mobile-grid-1">
                                        <div>
                                            <label>Select ATM Card</label>
                                            <select id="transferCardId" name="cardId" style="display: none;">
                                                <c:forEach items="${cards}" var="card">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <option value="${card.cardId}">
                                                            ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                            <div class="card-selector-grid" id="gridTransferCard">
                                                <c:forEach items="${cards}" var="card" varStatus="vs">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <div class="card-select-card ${vs.first ? 'active' : ''} card-${card.cardType.toLowerCase()}" data-value="${card.cardId}">
                                                            <div class="card-top">
                                                                <span class="card-brand-label">VGB CARD</span>
                                                                <i class="bx bx-wifi card-contactless"></i>
                                                            </div>
                                                            <div class="card-chip-row">
                                                                <svg class="card-chip" width="34" height="26" viewBox="0 0 32 24" fill="none">
                                                                    <defs>
                                                                        <linearGradient id="chip-silver-grad" x1="0%" y1="0%" x2="100%" y2="100%">
                                                                            <stop offset="0%" stop-color="#f3f4f6"/>
                                                                            <stop offset="50%" stop-color="#d1d5db"/>
                                                                            <stop offset="100%" stop-color="#9ca3af"/>
                                                                        </linearGradient>
                                                                    </defs>
                                                                    <rect width="32" height="24" rx="4" fill="url(#chip-silver-grad)" />
                                                                    <path d="M0 8H8V16H0V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M24 8H32V16H24V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M8 0V8H24V0H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M8 16V24H24V16H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M12 8V16H20V8H12Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                </svg>
                                                            </div>
                                                            <div class="card-middle">
                                                                <span class="card-number-display">${card.getMaskedCardNumber()}</span>
                                                            </div>
                                                            <div class="card-bottom">
                                                                <div class="card-holder-info">
                                                                    <span class="card-field-lbl">Holder</span>
                                                                    <span class="card-val">${customer.fullName.toUpperCase()}</span>
                                                                </div>
                                                                <div class="card-brand-network">
                                                                    <span class="card-network-name">${card.cardProvider.toUpperCase()}</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div>
                                            <label for="transferCardCvv">3-Digit CVV</label>
                                            <div class="cvv-input-wrapper">
                                                <input type="password" maxlength="3" id="transferCardCvv" name="cvv" placeholder="•••" class="form-control-modern" style="font-family: monospace; letter-spacing: 3px; padding-right: 42px;">
                                                <button type="button" class="btn-cvv-toggle" onclick="toggleCvvVisibility('transferCardCvv', this)">
                                                    <i class="bx bx-hide"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <span style="font-size: 0.78rem; color: var(--gray-500); display: inline-flex; align-items: center; gap: 5px;"><i class="bx bx-info-circle" style="color: var(--primary-500);"></i> Selecting an ATM card overrides source account. Card transaction limits apply.</span>
                                </div>
                            </div>

                            <!-- Destination Type Selector -->
                            <div class="form-group">
                                <label>Transfer Destination Type</label>
                                <div style="display: flex; gap: 25px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; color: var(--gray-600); cursor: pointer;">
                                        <input type="radio" name="destType" value="own" checked onclick="toggleDestType('own')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Another Account of Yours (Internal)</span>
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 500; color: var(--gray-600); cursor: pointer;">
                                        <input type="radio" name="destType" value="p2p" onclick="toggleDestType('p2p')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Other Customer's Account (P2P)</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Target Account Autocomplete Selector -->
                            <div class="form-group" id="containerTargetAccount">
                                <label>Select Target Account</label>
                                <div class="search-select-wrapper" id="selectTargetAccWrapper">
                                    <input type="text" class="search-select-input" id="txtTargetAccount" placeholder="Type destination account type or number..." autocomplete="off" required>
                                    <input type="hidden" name="toAccountId" id="hidTargetAccountId">
                                    <i class="bx bx-search search-select-icon"></i>
                                    <i class="bx bx-chevron-down search-select-arrow"></i>
                                    <div class="search-select-results" id="dropdownTargetAccount"></div>
                                </div>
                            </div>

                            <!-- Transfer Amount -->
                            <div class="form-group">
                                <label for="amount">Amount to Transfer (INR)</label>
                                <div class="input-icon-wrapper">
                                    <i style="font-style: normal; font-weight: 700; font-size: 1rem; top: 15px; left: 18px;">₹</i>
                                    <input type="number" step="0.01" min="100" id="amount" name="amount" required placeholder="Min. ₹100" class="form-control-modern">
                                </div>
                                <div class="quick-amounts">
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('amount', 500)">₹500</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('amount', 1000)">₹1,000</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('amount', 5000)">₹5,000</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('amount', 10000)">₹10,000</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('amount', 25000)">₹25,000</button>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 30px;">
                                <label for="description">Transaction Description</label>
                                <div class="input-icon-wrapper">
                                    <i class="bx bx-note"></i>
                                    <input type="text" id="description" name="description" placeholder="E.g., Rent, Family Support" class="form-control-modern">
                                </div>
                            </div>

                            <button type="submit" class="btn-submit-premium">
                                <span>Authenticate Transfer</span>
                                <i class="bx bx-shield-quarter"></i>
                            </button>
                        </form>
                    </div>

                    <!-- SECTION 2: CASH WITHDRAWAL -->
                    <div id="secWithdraw" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-down-arrow-circle"></i> Counter Cash Withdrawal
                        </h3>
                        
                        <form action="${pageContext.request.contextPath}/account?action=withdraw" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="redirectUrl" value="/account?action=transferPage">

                            <!-- Source Account Select Dropdown -->
                            <div class="form-group">
                                <label>Select Source Account</label>
                                <select id="withdrawSourceAccount" name="accountId" required style="display: none;">
                                    <c:forEach items="${accounts}" var="acc">
                                        <option value="${acc.accountId}">
                                            ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="account-selector-grid" id="gridWithdrawSource">
                                    <c:forEach items="${accounts}" var="acc" varStatus="vs">
                                        <c:set var="cardTypeClass" value="type-default" />
                                        <c:if test="${acc.accountType == 'Savings' or acc.accountType == 'SAVINGS' or acc.accountType == 'savings'}">
                                            <c:set var="cardTypeClass" value="type-savings" />
                                        </c:if>
                                        <c:if test="${acc.accountType == 'Current' or acc.accountType == 'CURRENT' or acc.accountType == 'current'}">
                                            <c:set var="cardTypeClass" value="type-current" />
                                        </c:if>
                                        <c:if test="${acc.accountType == 'Salary' or acc.accountType == 'SALARY' or acc.accountType == 'salary'}">
                                            <c:set var="cardTypeClass" value="type-salary" />
                                        </c:if>
                                        <div class="account-select-card ${vs.first ? 'active' : ''} ${cardTypeClass}" data-value="${acc.accountId}">
                                            <div class="acc-card-top">
                                                <div class="acc-chip-container">
                                                    <svg class="acc-card-chip" width="28" height="20" viewBox="0 0 32 24" fill="none">
                                                        <defs>
                                                            <linearGradient id="chip-gold-grad-withdraw" x1="0%" y1="0%" x2="100%" y2="100%">
                                                                <stop offset="0%" stop-color="#ffe259"/>
                                                                <stop offset="100%" stop-color="#ffa751"/>
                                                            </linearGradient>
                                                        </defs>
                                                        <rect width="32" height="24" rx="4" fill="url(#chip-gold-grad-withdraw)" />
                                                        <path d="M0 8H8V16H0V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M24 8H32V16H24V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M8 0V8H24V0H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M8 16V24H24V16H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                        <path d="M12 8V16H20V8H12Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                    </svg>
                                                    <span class="acc-card-bank">VGB BANK</span>
                                                </div>
                                                <span class="acc-card-badge">${acc.accountType}</span>
                                            </div>
                                            <div class="acc-card-body">
                                                <span class="acc-card-num">${acc.accountNumber}</span>
                                            </div>
                                            <div class="acc-card-footer">
                                                <div class="acc-bal-group">
                                                    <span class="acc-bal-label">Available Balance</span>
                                                    <span class="acc-bal-amount">₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ATM Card withdraw checkbox -->
                            <div class="custom-option-card">
                                <label style="display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primary-500); cursor: pointer; margin-bottom: 0;">
                                    <input type="checkbox" id="withdrawUseCard" name="useCard" value="true" onchange="toggleWithdrawCardFields()" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                    <span>Withdraw using active VGB ATM Card (Debit/Credit)</span>
                                </label>
                                
                                <div id="withdrawCardFields" style="display: none; margin-top: 20px; border-top: 1px solid rgba(99, 102, 241, 0.15); padding-top: 20px;">
                                    <div style="display: grid; grid-template-columns: 1.8fr 1fr; gap: 20px; margin-bottom: 12px;" class="mobile-grid-1">
                                        <div>
                                            <label>Select ATM Card</label>
                                            <select id="withdrawCardId" name="cardId" style="display: none;">
                                                <c:forEach items="${cards}" var="card">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <option value="${card.cardId}">
                                                            ${card.cardProvider.toUpperCase()} ${card.cardType.toUpperCase()} (Number: ${card.getMaskedCardNumber()})
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                            <div class="card-selector-grid" id="gridWithdrawCard">
                                                <c:forEach items="${cards}" var="card" varStatus="vs">
                                                    <c:if test="${card.status eq 'active'}">
                                                        <div class="card-select-card ${vs.first ? 'active' : ''} card-${card.cardType.toLowerCase()}" data-value="${card.cardId}">
                                                            <div class="card-top">
                                                                <span class="card-brand-label">VGB CARD</span>
                                                                <i class="bx bx-wifi card-contactless"></i>
                                                            </div>
                                                            <div class="card-chip-row">
                                                                <svg class="card-chip" width="34" height="26" viewBox="0 0 32 24" fill="none">
                                                                    <defs>
                                                                        <linearGradient id="chip-silver-grad-withdraw" x1="0%" y1="0%" x2="100%" y2="100%">
                                                                            <stop offset="0%" stop-color="#f3f4f6"/>
                                                                            <stop offset="50%" stop-color="#d1d5db"/>
                                                                            <stop offset="100%" stop-color="#9ca3af"/>
                                                                        </linearGradient>
                                                                    </defs>
                                                                    <rect width="32" height="24" rx="4" fill="url(#chip-silver-grad-withdraw)" />
                                                                    <path d="M0 8H8V16H0V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M24 8H32V16H24V8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M8 0V8H24V0H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M8 16V24H24V16H8Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                    <path d="M12 8V16H20V8H12Z" stroke="rgba(0,0,0,0.15)" stroke-width="0.5" />
                                                                </svg>
                                                            </div>
                                                            <div class="card-middle">
                                                                <span class="card-number-display">${card.getMaskedCardNumber()}</span>
                                                            </div>
                                                            <div class="card-bottom">
                                                                <div class="card-holder-info">
                                                                    <span class="card-field-lbl">Holder</span>
                                                                    <span class="card-val">${customer.fullName.toUpperCase()}</span>
                                                                </div>
                                                                <div class="card-brand-network">
                                                                    <span class="card-network-name">${card.cardProvider.toUpperCase()}</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div>
                                            <label for="withdrawCardCvv">3-Digit CVV</label>
                                            <div class="cvv-input-wrapper">
                                                <input type="password" maxlength="3" id="withdrawCardCvv" name="cvv" placeholder="•••" class="form-control-modern" style="font-family: monospace; letter-spacing: 3px; padding-right: 42px;">
                                                <button type="button" class="btn-cvv-toggle" onclick="toggleCvvVisibility('withdrawCardCvv', this)">
                                                    <i class="bx bx-hide"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <span style="font-size: 0.78rem; color: var(--gray-500); display: inline-flex; align-items: center; gap: 5px;"><i class="bx bx-info-circle" style="color: var(--primary-500);"></i> Selecting an ATM card overrides source account. Card transaction limits apply.</span>
                                </div>
                            </div>

                            <!-- Withdrawal Amount -->
                            <div class="form-group">
                                <label for="withdrawAmount">Amount to Withdraw (INR)</label>
                                <div class="input-icon-wrapper">
                                    <i style="font-style: normal; font-weight: 700; font-size: 1rem; top: 15px; left: 18px;">₹</i>
                                    <input type="number" step="0.01" min="100" id="withdrawAmount" name="amount" required placeholder="Min. ₹100" class="form-control-modern">
                                </div>
                                <div class="quick-amounts">
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('withdrawAmount', 500)">₹500</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('withdrawAmount', 1000)">₹1,000</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('withdrawAmount', 5000)">₹5,000</button>
                                    <button type="button" class="quick-amount-chip" onclick="setQuickAmount('withdrawAmount', 10000)">₹10,000</button>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="form-group" style="margin-bottom: 30px;">
                                <label for="withdrawDescription">Transaction Description</label>
                                <div class="input-icon-wrapper">
                                    <i class="bx bx-note"></i>
                                    <input type="text" id="withdrawDescription" name="description" placeholder="E.g., Self counter cash withdrawal" class="form-control-modern">
                                </div>
                            </div>

                            <button type="submit" class="btn-submit-premium">
                                <span>Process Cash Withdrawal</span>
                                <i class="bx bx-check-shield"></i>
                            </button>
                        </form>
                    </div>



                    <!-- SECTION 3: ADD BENEFICIARY -->
                    <div id="secAddBeneficiary" class="portal-form-section">
                        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                            <i class="bx bx-user-plus"></i> Register New Beneficiary
                        </h3>
                        
                        <div id="beneficiaryAlertContainer" class="glass-alert" style="display: none;">
                            <i class="bx" id="beneficiaryAlertIcon" style="font-size: 1.2rem;"></i>
                            <span id="beneficiaryAlertMessage"></span>
                        </div>

                        <form id="addBeneficiaryForm" onsubmit="event.preventDefault(); return performBeneficiaryValidation();">
                            <!-- Beneficiary Bank Type Selection -->
                            <div class="form-group">
                                <label>Beneficiary Bank Type</label>
                                <div style="display: flex; gap: 25px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--primary-500); cursor: pointer;">
                                        <input type="radio" name="benBankType" value="vgb" checked onclick="toggleBenBankType('vgb')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Vertex Galaxy Bank (VGB) Customer</span>
                                    </label>
                                    <label style="display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--primary-500); cursor: pointer;">
                                        <input type="radio" name="benBankType" value="other" onclick="toggleBenBankType('other')" style="accent-color: var(--primary-500); width: 18px; height: 18px;">
                                        <span>Other Bank Customer</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Account Holder Name (Only shown for Other Bank) -->
                            <div class="form-group" id="containerBenHolderName" style="display: none;">
                                <label for="benHolderName">Account Holder Name (Required)</label>
                                <div class="input-icon-wrapper">
                                    <i class="bx bx-user"></i>
                                    <input type="text" id="benHolderName" placeholder="Enter recipient's full name" class="form-control-modern">
                                </div>
                            </div>

                            <!-- Beneficiary Account Number -->
                            <div class="form-group">
                                <label for="benAccountNumber">Beneficiary Account Number</label>
                                <div class="input-icon-wrapper">
                                    <i class="bx bx-hash"></i>
                                    <input type="text" id="benAccountNumber" required placeholder="Enter account number (e.g. 100087654321)" class="form-control-modern">
                                </div>
                            </div>

                            <!-- Beneficiary IFSC -->
                            <div class="form-group">
                                <label for="benIfscCode">Branch IFSC Code</label>
                                <div class="input-icon-wrapper">
                                    <i class="bx bx-building"></i>
                                    <input type="text" id="benIfscCode" required placeholder="Enter 11-digit IFSC code (e.g. VGBK0000001)" class="form-control-modern" style="font-family: monospace; text-transform: uppercase;">
                                </div>
                            </div>

                            <!-- Nickname Reference -->
                            <div class="form-group" style="margin-bottom: 30px;">
                                <label for="benNickName">Account Holder Name / Nickname Reference (Optional)</label>
                                <div class="input-icon-wrapper">
                                    <i class="bx bx-purchase-tag-alt"></i>
                                    <input type="text" id="benNickName" placeholder="E.g. Business Account, John Doe" class="form-control-modern">
                                </div>
                            </div>

                            <button type="submit" id="btnValidateBeneficiary" class="btn-verify-modern">
                                <span>Verify Account Details</span>
                                <i class="bx bx-check-double"></i>
                            </button>
                        </form>

                        <!-- Dynamically Injected Verification Result Preview Card -->
                        <div id="containerVerificationPreview" class="verification-receipt-card" style="display: none;">
                            <div class="receipt-stamp">Verified</div>
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
                                <h4 style="font-size: 1.05rem; font-weight: 700; color: #047857;"><i class="bx bx-badge-check"></i> Verified Receipt</h4>
                            </div>
                            
                            <div class="receipt-dashed-line"></div>
                            
                            <div class="receipt-grid">
                                <div class="receipt-item">
                                    <span>Verified Account Holder</span>
                                    <strong id="previewHolderName"></strong>
                                </div>
                                <div class="receipt-item">
                                    <span>Branch Routing IFSC</span>
                                    <strong id="previewIfscCode" style="font-family: monospace;"></strong>
                                </div>
                                <div class="receipt-item">
                                    <span>Account Number</span>
                                    <strong id="previewAccountNumber" style="font-family: monospace;"></strong>
                                </div>
                                <div class="receipt-item">
                                    <span>System Account Type</span>
                                    <strong id="previewAccountType" style="text-transform: uppercase;"></strong>
                                </div>
                            </div>
                            
                            <div class="receipt-dashed-line"></div>

                            <button type="button" id="btnSaveBeneficiary" onclick="performBeneficiarySave()" class="btn-submit-premium">
                                <span>Save Beneficiary to Directory</span>
                                <i class="bx bx-save"></i>
                            </button>
                        </div>
                    </div>

                </div>

                <!-- Guidelines Card -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <div class="glass-card" style="background: rgba(99, 102, 241, 0.04); border-color: rgba(99, 102, 241, 0.15);">
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--primary-600); margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                            <i class="bx bx-info-circle" style="font-size: 1.25rem;"></i>
                            <span>Service Routing Limits</span>
                        </h4>
                        <ul style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.7; padding-left: 0; list-style: none; margin: 0;">
                            <li style="margin-bottom: 12px; display: flex; align-items: flex-start; gap: 8px;">
                                <i class="bx bx-subdirectory-right" style="color: var(--primary-500); font-size: 1.1rem; margin-top: 2px; flex-shrink: 0;"></i>
                                <span>Minimum counter withdrawal or transfer amount is <strong>₹100</strong>.</span>
                            </li>
                            <li style="margin-bottom: 12px; display: flex; align-items: flex-start; gap: 8px;">
                                <i class="bx bx-subdirectory-right" style="color: var(--primary-500); font-size: 1.1rem; margin-top: 2px; flex-shrink: 0;"></i>
                                <span>Saved Beneficiary routing maps accounts securely with real-time verification checks.</span>
                            </li>
                            <li style="display: flex; align-items: flex-start; gap: 8px;">
                                <i class="bx bx-subdirectory-right" style="color: var(--primary-500); font-size: 1.1rem; margin-top: 2px; flex-shrink: 0;"></i>
                                <span>Ensure beneficiary account numbers match exactly to lock dynamic ledger clearances.</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
        </div>
    </footer>

    <!-- JSON Data Serialization Blocks -->
    <script id="accounts-data" type="application/json">
        [
            <c:forEach var="acc" items="${accounts}" varStatus="status">
                {
                    "accountId": "${acc.accountId}",
                    "accountNumber": "${acc.accountNumber}",
                    "accountType": "${acc.accountType}",
                    "balance": ${acc.balance != null ? acc.balance : 0.0},
                    "status": "${acc.status}"
                }${status.last ? '' : ','}
            </c:forEach>
        ]
    </script>
    <script id="beneficiaries-data" type="application/json">
        [
            <c:forEach var="ben" items="${beneficiaries}" varStatus="status">
                {
                    "nomineeName": "${ben.nomineeName}",
                    "customerName": "<c:out value="${ben.customerName}" />",
                    "accountNumber": "${ben.accountNumber}",
                    "accountType": "${ben.accountType}",
                    "ifscCode": "${ben.ifscCode}"
                }${status.last ? '' : ','}
            </c:forEach>
        ]
    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        const allAccounts = JSON.parse(document.getElementById('accounts-data').textContent);
        const allBeneficiaries = JSON.parse(document.getElementById('beneficiaries-data').textContent);

        function extractErrorMessage(text) {
            try {
                const parser = new DOMParser();
                const htmlDoc = parser.parseFromString(text, 'text/html');
                const paragraphs = htmlDoc.querySelectorAll('p');
                let errorMsg = '';
                for (let i = 0; i < paragraphs.length; i++) {
                    const cleanText = paragraphs[i].textContent.trim();
                    if (cleanText.toLowerCase().includes('message')) {
                        errorMsg = cleanText.replace(/^(Message\s*:?\s*)/i, '').trim();
                        break;
                    }
                }
                if (!errorMsg) {
                    for (let i = 0; i < paragraphs.length; i++) {
                        const cleanText = paragraphs[i].textContent.trim();
                        if (cleanText.toLowerCase().includes('description')) {
                            errorMsg = cleanText.replace(/^(Description\s*:?\s*)/i, '').trim();
                            break;
                        }
                    }
                }
                if (!errorMsg) {
                    for (let i = 0; i < paragraphs.length; i++) {
                        const cleanText = paragraphs[i].textContent.trim();
                        if (!cleanText.toLowerCase().startsWith('type')) {
                            errorMsg = cleanText;
                            break;
                        }
                    }
                }
                if (!errorMsg) {
                    const h1 = htmlDoc.querySelector('h1');
                    errorMsg = h1 ? h1.textContent : '';
                }
                if (errorMsg.includes("perceived to be a client error")) {
                    errorMsg = "Bad Request: The server received malformed parameters or an invalid request format.";
                }
                return errorMsg || 'Invalid response from server.';
            } catch (e) {
                return 'Invalid response from server.';
            }
        }

        function showPortalTab(tab) {
            const tabTransfer = document.getElementById('tabBtnTransfer');
            const tabWithdraw = document.getElementById('tabBtnWithdraw');
            const tabAddBeneficiary = document.getElementById('tabBtnAddBeneficiary');
            const secTransfer = document.getElementById('secTransfer');
            const secWithdraw = document.getElementById('secWithdraw');
            const secAddBeneficiary = document.getElementById('secAddBeneficiary');

            // Reset active classes
            tabTransfer.classList.remove('active');
            tabWithdraw.classList.remove('active');
            tabAddBeneficiary.classList.remove('active');
            secTransfer.classList.remove('active');
            secWithdraw.classList.remove('active');
            secAddBeneficiary.classList.remove('active');

            if (tab === 'transfer') {
                tabTransfer.classList.add('active');
                secTransfer.classList.add('active');
            } else if (tab === 'withdraw') {
                tabWithdraw.classList.add('active');
                secWithdraw.classList.add('active');
            } else {
                tabAddBeneficiary.classList.add('active');
                secAddBeneficiary.classList.add('active');
            }
        }

        function toggleTransferCardFields() {
            const useCard = document.getElementById('transferUseCard').checked;
            const fieldsDiv = document.getElementById('transferCardFields');
            const cardIdSelect = document.getElementById('transferCardId');
            const cvvInput = document.getElementById('transferCardCvv');
            if (useCard) {
                fieldsDiv.style.display = 'block';
                cardIdSelect.required = true;
                cvvInput.required = true;
            } else {
                fieldsDiv.style.display = 'none';
                cardIdSelect.required = false;
                cvvInput.required = false;
            }
        }

        function toggleWithdrawCardFields() {
            const useCard = document.getElementById('withdrawUseCard').checked;
            const fieldsDiv = document.getElementById('withdrawCardFields');
            const cardIdSelect = document.getElementById('withdrawCardId');
            const cvvInput = document.getElementById('withdrawCardCvv');
            if (useCard) {
                fieldsDiv.style.display = 'block';
                cardIdSelect.required = true;
                cvvInput.required = true;
            } else {
                fieldsDiv.style.display = 'none';
                cardIdSelect.required = false;
                cvvInput.required = false;
            }
        }

        function toggleDestType(type) {
            const input = document.getElementById('txtTargetAccount');
            const hidden = document.getElementById('hidTargetAccountId');
            const dropdown = document.getElementById('dropdownTargetAccount');
            
            if (input && hidden && dropdown) {
                input.value = '';
                hidden.value = '';
                dropdown.style.display = 'none';
                document.getElementById('selectTargetAccWrapper').classList.remove('active');
                
                if (type === 'own') {
                    input.placeholder = "Type destination account type or number...";
                } else {
                    input.placeholder = "Type beneficiary name or account number...";
                }
            }
        }

        function validateTransferForm(event) {
            const fromAcc = document.getElementById('transferSourceAccount').value;
            const toAcc = document.getElementById('hidTargetAccountId').value;
            const destType = document.querySelector('input[name="destType"]:checked').value;
            
            if (!toAcc) {
                event.preventDefault();
                alert("Please select a target account or beneficiary from the dropdown.");
                return false;
            }
            
            if (destType === 'own') {
                if (fromAcc.toString() === toAcc.toString()) {
                    event.preventDefault();
                    alert("Self-transfer Error: Source account and destination account cannot be the same. Please select a different destination account.");
                    return false;
                }
            }
            return true;
        }

        // Dropdown autocompletes builder for customer transfer
        function setupAutocomplete(inputId, dropdownId, hiddenInputId, wrapperId) {
            const input = document.getElementById(inputId);
            const dropdown = document.getElementById(dropdownId);
            const hidden = document.getElementById(hiddenInputId);
            const wrapper = document.getElementById(wrapperId);

            if (!input || !dropdown || !hidden || !wrapper) return;

            input.addEventListener('focus', () => {
                wrapper.classList.add('active');
                renderTargetResults(input.value);
            });

            input.addEventListener('input', (e) => {
                renderTargetResults(e.target.value);
            });

            document.addEventListener('click', (e) => {
                if (!wrapper.contains(e.target)) {
                    wrapper.classList.remove('active');
                    dropdown.style.display = 'none';
                }
            });
        }

        function renderTargetResults(query) {
            const dropdown = document.getElementById('dropdownTargetAccount');
            const hidden = document.getElementById('hidTargetAccountId');
            const input = document.getElementById('txtTargetAccount');
            const destType = document.querySelector('input[name="destType"]:checked').value;
            
            const q = query.toLowerCase().trim();
            dropdown.innerHTML = '';
            
            let filtered = [];
            if (destType === 'own') {
                const sourceAccId = document.getElementById('transferSourceAccount').value;
                filtered = allAccounts.filter(acc => {
                    if (acc.accountId.toString() === sourceAccId.toString()) return false;
                    const numMatch = acc.accountNumber.toLowerCase().includes(q);
                    const typeMatch = acc.accountType.toLowerCase().includes(q);
                    return numMatch || typeMatch;
                });
            } else {
                filtered = allBeneficiaries.filter(ben => {
                    const nameMatch = ben.customerName.toLowerCase().includes(q);
                    const numMatch = ben.accountNumber.toLowerCase().includes(q);
                    return nameMatch || numMatch;
                });
            }
            
            if (filtered.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'search-select-empty';
                empty.innerText = destType === 'own' ? 'No other active accounts found' : 'No matching beneficiaries found';
                dropdown.appendChild(empty);
            } else {
                filtered.forEach(itemData => {
                    const item = document.createElement('div');
                    item.className = 'search-select-item';
                    
                    const title = document.createElement('span');
                    title.className = 'search-select-item-title';
                    
                    const subtitle = document.createElement('span');
                    subtitle.className = 'search-select-item-subtitle';
                    
                    if (destType === 'own') {
                        title.innerText = 'VGB BANK | ' + itemData.accountType.toUpperCase();
                        subtitle.innerText = 'Acc: ' + itemData.accountNumber + ' | Bal: ₹' + parseFloat(itemData.balance).toLocaleString('en-IN', { minimumFractionDigits: 2 });
                        
                        item.addEventListener('click', () => {
                            input.value = 'VGB BANK | ' + itemData.accountType.toUpperCase() + ' (' + itemData.accountNumber + ')';
                            hidden.value = itemData.accountId;
                            dropdown.style.display = 'none';
                            document.getElementById('selectTargetAccWrapper').classList.remove('active');
                        });
                    } else {
                        title.innerText = itemData.customerName + ' | BENEFICIARY';
                        subtitle.innerText = 'Acc: ' + itemData.accountNumber + ' | IFSC: ' + itemData.ifscCode;
                        
                        item.addEventListener('click', () => {
                            input.value = itemData.customerName + ' (' + itemData.accountNumber + ')';
                            hidden.value = itemData.nomineeName;
                            dropdown.style.display = 'none';
                            document.getElementById('selectTargetAccWrapper').classList.remove('active');
                        });
                    }
                    
                    item.appendChild(title);
                    item.appendChild(subtitle);
                    dropdown.appendChild(item);
                });
            }
            dropdown.style.display = 'block';
        }

        // Beneficiary AJAX Operations
        let verifiedAccountId = 0;

        function showBeneficiaryAlert(message, type) {
            const container = document.getElementById('beneficiaryAlertContainer');
            const icon = document.getElementById('beneficiaryAlertIcon');
            const msgSpan = document.getElementById('beneficiaryAlertMessage');

            container.style.display = 'flex';
            msgSpan.textContent = message;

            if (type === 'success') {
                container.className = 'glass-alert glass-alert-success';
                icon.className = 'bx bx-check-circle';
            } else {
                container.className = 'glass-alert glass-alert-danger';
                icon.className = 'bx bx-error-circle';
            }
        }

        function hideBeneficiaryAlert() {
            document.getElementById('beneficiaryAlertContainer').style.display = 'none';
        }

        function toggleBenBankType(type) {
            const holderNameContainer = document.getElementById('containerBenHolderName');
            const holderNameInput = document.getElementById('benHolderName');
            
            if (type === 'other') {
                holderNameContainer.style.display = 'block';
                holderNameInput.required = true;
            } else {
                holderNameContainer.style.display = 'none';
                holderNameInput.required = false;
            }
        }

        function performBeneficiaryValidation() {
            const accNum = document.getElementById('benAccountNumber').value.trim();
            const ifsc = document.getElementById('benIfscCode').value.trim();
            const previewContainer = document.getElementById('containerVerificationPreview');
            const benType = document.querySelector('input[name="benBankType"]:checked').value;
            const holderName = document.getElementById('benHolderName').value.trim();

            hideBeneficiaryAlert();
            previewContainer.style.display = 'none';
            verifiedAccountId = 0;

            const btn = document.getElementById('btnValidateBeneficiary');
            btn.disabled = true;
            btn.classList.add('btn-loading');
            btn.querySelector('span').textContent = 'Validating Ledger Record...';

            let url = '${pageContext.request.contextPath}/account?action=verifyBeneficiary' + 
                      '&beneficiaryType=' + encodeURIComponent(benType) + 
                      '&accountNumber=' + encodeURIComponent(accNum) + 
                      '&ifscCode=' + encodeURIComponent(ifsc);
            
            if (benType === 'other') {
                url += '&holderName=' + encodeURIComponent(holderName);
            }

            fetch(url)
                .then(response => {
                    return response.text().then(text => {
                        try {
                            return JSON.parse(text);
                        } catch (err) {
                            throw new Error(extractErrorMessage(text));
                        }
                    });
                })
                .then(data => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Verify Account Details';

                    if (data.valid) {
                        verifiedAccountId = data.accountId;
                        
                        document.getElementById('previewHolderName').textContent = data.customerName;
                        document.getElementById('previewIfscCode').textContent = data.ifscCode;
                        document.getElementById('previewAccountNumber').textContent = data.accountNumber;
                        document.getElementById('previewAccountType').textContent = data.accountType;

                        previewContainer.style.display = 'block';
                        
                        // Restart stamp animation
                        const stamp = previewContainer.querySelector('.receipt-stamp');
                        if (stamp) {
                            stamp.style.animation = 'none';
                            stamp.offsetHeight; // Trigger reflow
                            stamp.style.animation = null;
                        }
                    } else {
                        showBeneficiaryAlert(data.message || 'Validation failed. No matching ledger accounts found.', 'error');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Verify Account Details';
                    showBeneficiaryAlert('Verification error: ' + error.message, 'error');
                });

            return false;
        }

        function performBeneficiarySave() {
            const benType = document.querySelector('input[name="benBankType"]:checked').value;
            if (benType === 'vgb' && verifiedAccountId === 0) return;

            const btn = document.getElementById('btnSaveBeneficiary');
            btn.disabled = true;
            btn.classList.add('btn-loading');
            btn.querySelector('span').textContent = 'Registering with core routing...';

            const csrfToken = '${sessionScope.csrfToken}';
            const accNum = document.getElementById('previewAccountNumber').textContent;
            const ifsc = document.getElementById('previewIfscCode').textContent;
            const holderName = document.getElementById('previewHolderName').textContent;
            const nickname = document.getElementById('benNickName').value.trim();

            let bodyParams = 'csrfToken=' + encodeURIComponent(csrfToken) + 
                             '&beneficiaryType=' + encodeURIComponent(benType) + 
                             '&beneficiaryAccountId=' + encodeURIComponent(verifiedAccountId) + 
                             '&accountNumber=' + encodeURIComponent(accNum) + 
                             '&ifscCode=' + encodeURIComponent(ifsc) + 
                             '&holderName=' + encodeURIComponent(holderName) + 
                             '&nickname=' + encodeURIComponent(nickname);

            fetch('${pageContext.request.contextPath}/account?action=saveBeneficiary', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: bodyParams
            })
                .then(response => {
                    return response.text().then(text => {
                        try {
                            return JSON.parse(text);
                        } catch (err) {
                            throw new Error(extractErrorMessage(text));
                        }
                    });
                })
                .then(data => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Save Beneficiary to Directory';

                    if (data.success) {
                        showBeneficiaryAlert(data.message || 'Beneficiary saved and locked successfully.', 'success');
                        document.getElementById('containerVerificationPreview').style.display = 'none';
                        document.getElementById('addBeneficiaryForm').reset();
                        document.getElementById('containerBenHolderName').style.display = 'none';
                        verifiedAccountId = 0;
                        
                        // Refresh beneficiary directory lists in the background
                        refreshBeneficiaryList();
                    } else {
                        showBeneficiaryAlert(data.message || 'Failed to save beneficiary.', 'error');
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.classList.remove('btn-loading');
                    btn.querySelector('span').textContent = 'Save Beneficiary to Directory';
                    showBeneficiaryAlert('Save error: ' + error.message, 'error');
                });
        }

        // Quick amount autofill
        function setQuickAmount(inputId, amount) {
            const input = document.getElementById(inputId);
            if (input) {
                input.value = amount;
                input.dispatchEvent(new Event('input'));
                input.focus();
            }
        }

        // CVV eye visibility toggle
        function toggleCvvVisibility(inputId, btn) {
            const input = document.getElementById(inputId);
            const icon = btn.querySelector('i');
            if (input && icon) {
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.className = 'bx bx-show';
                } else {
                    input.type = 'password';
                    icon.className = 'bx bx-hide';
                }
            }
        }

        // Visual Selector click synchronization logic
        function setupGridSelector(gridId, selectId) {
            const grid = document.getElementById(gridId);
            const select = document.getElementById(selectId);
            if (grid && select) {
                const cards = grid.querySelectorAll('.account-select-card, .card-select-card');
                
                // Set default initial value
                const activeCard = grid.querySelector('.active');
                if (activeCard) {
                    select.value = activeCard.getAttribute('data-value');
                }

                cards.forEach(card => {
                    card.addEventListener('click', () => {
                        cards.forEach(c => c.classList.remove('active'));
                        card.classList.add('active');
                        select.value = card.getAttribute('data-value');
                        select.dispatchEvent(new Event('change'));
                    });
                });
            }
        }

        function refreshBeneficiaryList() {
            fetch('${pageContext.request.contextPath}/account?action=transferPage')
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    
                    const dataElem = doc.getElementById('beneficiaries-data');
                    if (dataElem) {
                        try {
                            const updatedList = JSON.parse(dataElem.textContent);
                            allBeneficiaries.length = 0;
                            allBeneficiaries.push(...updatedList);
                            console.log('Successfully refreshed beneficiary list. Total count: ' + allBeneficiaries.length);
                        } catch (err) {
                            console.error('Error parsing refreshed beneficiaries:', err);
                        }
                    }
                })
                .catch(err => console.error('Error refreshing beneficiaries directory:', err));
        }

        document.addEventListener('DOMContentLoaded', () => {
            // Cursor glow movement logic
            const glow = document.querySelector('.cursor-glow');
            if (glow) {
                document.addEventListener('mousemove', (e) => {
                    glow.style.left = e.clientX + 'px';
                    glow.style.top = e.clientY + 'px';
                });
            }

            // Mobile sidebar menu toggle
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
                
                document.addEventListener('click', (e) => {
                    if (sidebar.classList.contains('active') && !sidebar.contains(e.target) && !mobileToggle.contains(e.target)) {
                        sidebar.classList.remove('active');
                        mobileToggle.querySelector('i').className = 'bx bx-menu';
                    }
                });
            }

            // Bind click selections
            setupGridSelector('gridTransferSource', 'transferSourceAccount');
            setupGridSelector('gridTransferCard', 'transferCardId');
            setupGridSelector('gridWithdrawSource', 'withdrawSourceAccount');
            setupGridSelector('gridWithdrawCard', 'withdrawCardId');

            // Setup Target account autocomplete
            setupAutocomplete('txtTargetAccount', 'dropdownTargetAccount', 'hidTargetAccountId', 'selectTargetAccWrapper');

            // Reset target account selection if source account changes
            const sourceSelect = document.getElementById('transferSourceAccount');
            if (sourceSelect) {
                sourceSelect.addEventListener('change', () => {
                    const destType = document.querySelector('input[name="destType"]:checked').value;
                    toggleDestType(destType);
                });
            }
        });
    </script>
</body>
</html>
