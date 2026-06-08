<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage ATM Cards</title>
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
        .stat-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--shadow-sm);
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .card-dues-warning {
            color: #ef4444;
        }
        .card-dues-normal {
            color: var(--gray-800);
        }

        /* PREMIUM VGB 3D GLOWING CARDS FOR VISUALIZER */
        .vgb-atm-card {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
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
        .vgb-atm-card .card-back {
            transform: rotateY(180deg);
            z-index: 1;
            background: #080b11;
        }

        /* 8 DYNAMIC PREMIUM BACKGROUNDS & ACCENTS */
        /* 1. Visa Debit */
        .vgb-atm-card.debit.visa {
            background: linear-gradient(135deg, #091326 0%, #030611 100%);
            box-shadow: 0 12px 25px rgba(29, 78, 216, 0.25);
        }
        .vgb-atm-card.debit.visa .card-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                radial-gradient(circle at 100% 0%, rgba(99, 102, 241, 0.35) 0%, transparent 60%),
                linear-gradient(125deg, transparent 40%, rgba(255, 255, 255, 0.18) 47%, rgba(255, 255, 255, 0.32) 50%, rgba(255, 255, 255, 0.18) 53%, transparent 60%);
            pointer-events: none;
            z-index: 1;
        }
        /* 2. Premium Visa Debit (Visa Platinum) */
        .vgb-atm-card.debit.visa.premium-tier {
            background: linear-gradient(135deg, #18181b 0%, #09090b 100%) !important;
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.4);
        }
        .vgb-atm-card.debit.visa.premium-tier .card-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                linear-gradient(120deg, transparent 35%, rgba(191, 149, 63, 0.2) 45%, rgba(252, 211, 77, 0.35) 50%, rgba(191, 149, 63, 0.2) 55%, transparent 65%),
                repeating-linear-gradient(45deg, rgba(255, 255, 255, 0.01) 0px, rgba(255, 255, 255, 0.01) 2px, transparent 2px, transparent 10px);
            pointer-events: none;
            z-index: 1;
        }
        /* 3. Mastercard Debit */
        .vgb-atm-card.debit.mastercard {
            background: radial-gradient(circle at 75% 35%, #181105 0%, #000000 75%);
            box-shadow: 0 12px 25px rgba(191, 149, 63, 0.15);
        }
        .vgb-atm-card.debit.mastercard .card-front::after {
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
        /* 4. Rupay Debit */
        .vgb-atm-card.debit.rupay {
            background: linear-gradient(135deg, #050d24 0%, #0c0822 50%, #030209 100%);
            box-shadow: 0 12px 25px rgba(99, 102, 241, 0.2);
        }
        .vgb-atm-card.debit.rupay .card-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                radial-gradient(circle at 10% 85%, rgba(59, 130, 246, 0.22) 0%, transparent 55%),
                radial-gradient(circle at 80% 15%, rgba(139, 92, 246, 0.18) 0%, transparent 55%),
                linear-gradient(55deg, transparent 30%, rgba(99, 102, 241, 0.12) 45%, rgba(236, 72, 153, 0.15) 55%, transparent 70%);
            pointer-events: none;
            z-index: 1;
        }
        /* 5. Classic Credit (Visa Signature) */
        .vgb-atm-card.credit.visa {
            background: radial-gradient(circle at 70% 35%, #18153c 0%, #080517 75%, #020108 100%);
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
            background: radial-gradient(circle at 75% 35%, #181105 0%, #000000 75%);
            box-shadow: 0 12px 25px rgba(245, 158, 11, 0.2);
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
            background: linear-gradient(135deg, #1c1c24 0%, #0c0c10 100%);
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
            background: linear-gradient(135deg, #111111 0%, #030303 100%) !important;
            box-shadow: 0 12px 25px rgba(191, 149, 63, 0.25);
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
            background: linear-gradient(135deg, #374151 0%, #4b5563 100%) !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
            opacity: 0.8;
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
            font-family: monospace;
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
            box-shadow: 0 0 4px rgba(255,255,255,0.1);
        }
        .dove-hologram::after {
            content: '🕊';
            position: absolute;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            color: rgba(255,255,255,0.8);
            text-shadow: 0 0 2px rgba(0,0,0,0.2);
        }
        .mc-hologram {
            width: 30px;
            height: 20px;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
            border-radius: 3px;
            opacity: 0.8;
            box-shadow: 0 0 4px rgba(255,255,255,0.1);
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

        /* Gold Card Back customization */
        .vgb-atm-card.credit.mastercard .card-back {
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%) !important;
            color: #0f172a !important;
        }
        .vgb-atm-card.credit.mastercard .card-back .card-back-header {
            color: rgba(15, 23, 42, 0.7) !important;
        }
        .vgb-atm-card.credit.mastercard .card-back .signature-strip-text span:first-child {
            color: #0f172a !important;
        }
        .vgb-atm-card.credit.mastercard .card-back .signature-strip-text span:last-child {
            color: #1e293b !important;
        }
        .vgb-atm-card.credit.mastercard .card-back .logo-text-stacked .text-top {
            color: #0f172a !important;
        }
        .vgb-atm-card.credit.mastercard .card-back .logo-text-stacked .text-bottom {
            color: rgba(15, 23, 42, 0.7) !important;
        }
        .vgb-atm-card.credit.mastercard .card-back .back-property-text {
            color: #0f172a !important;
            border-top: 1px solid rgba(15, 23, 42, 0.15) !important;
        }

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
            font-family: monospace;
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
            font-family: monospace;
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
            font-family: monospace;
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

        /* PREMIUM DYNAMIC INTERACTIVE CARD CLASSES */
        .vgb-atm-card.interactive {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }

        .vgb-atm-card.interactive:hover {
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.25);
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
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        /* PREMIUM ATM CARD CUSTOMIZER & SIMULATOR */
        .card-customizer-grid {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            gap: 40px;
            align-items: center;
        }
        @media (max-width: 991px) {
            .card-customizer-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }
        }
        .simulator-display {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.04) 0%, rgba(6, 182, 212, 0.04) 100%);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 40px 30px;
            position: relative;
            min-height: 330px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.05);
        }
        .simulator-controls {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .control-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .control-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.75px;
        }
        .control-input, .control-select {
            width: 100%;
            padding: 11px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            background: white;
            font-size: 0.9rem;
            color: var(--gray-800);
            font-family: inherit;
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
        }
        .control-input:focus, .control-select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
        }
        .control-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .card-3d-scene {
            perspective: 1200px;
            transform-style: preserve-3d;
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
        <a href="#" class="logo">
            <span class="logo-text">V</span>
            <span class="logo-text">G</span>
            <span class="logo-text">B</span>
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
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
            <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/admin/notification.jsp"><i class="bx bx-bell"></i> Audit Logs</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="mobile-grid-1">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Atm Cards Control Center</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer debit/credit card applications, audit system card limits, and process card approvals.</p>
                </div>
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

            <!-- Stats Rows (Dynamic Card Metrics) -->
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 30px; margin-bottom: 40px;" class="mobile-grid-1">
                <c:set var="pendingCount" value="0" />
                <c:set var="activeCount" value="0" />
                <c:set var="feeRevenue" value="0" />
                
                <c:forEach var="card" items="${cards}">
                    <c:choose>
                        <c:when test="${card.status eq 'pending'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                        </c:when>
                        <c:when test="${card.status eq 'active'}">
                            <c:set var="activeCount" value="${activeCount + 1}" />
                        </c:when>
                    </c:choose>
                    <c:if test="${card.feePaid}">
                        <c:set var="feeRevenue" value="${feeRevenue + card.cardFee}" />
                    </c:if>
                </c:forEach>

                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-credit-card"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Active Cards Issued</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${activeCount}</strong>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-time-five"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Pending Approvals</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">${pendingCount}</strong>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-wallet"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.8rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Card Service Revenue</span>
                        <strong style="font-size: 1.8rem; color: var(--gray-800);">₹ <fmt:formatNumber value="${feeRevenue}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                    </div>
                </div>
            </div>

            <!-- Flagship Interactive VGB 3D Card Demo Simulator -->
            <div class="glass-card" style="padding: 30px; margin-bottom: 40px; background: linear-gradient(135deg, rgba(255, 255, 255, 0.8) 0%, rgba(255, 255, 255, 0.65) 100%); border: 1px solid rgba(99, 102, 241, 0.2);">
                <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--gray-800); margin-bottom: 8px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-cube" style="color: var(--primary-500); font-size: 1.5rem;"></i> 
                    Flagship VGB Premium 3D ATM Card Showcase & Live Simulator
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 25px;">
                    Hover over the card to explore the interactive 3D tilt tracking. Click to flip and inspect CVV/signatory zones. Use the customizer controls to customize the visual assets live!
                </p>
                
                <div class="card-customizer-grid">
                    <!-- Left Column: The 3D Demo Card Display -->
                    <div class="simulator-display">
                        <div style="position: absolute; top: 12px; left: 15px; display: flex; gap: 8px; align-items: center; pointer-events: none;">
                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); font-size: 0.7rem; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 4px;">
                                <i class="bx bx-expand-alt" style="font-size: 0.8rem;"></i> 3D Sandbox
                            </span>
                        </div>
                        
                        <!-- The Flippable Card Scene -->
                        <div class="card-3d-scene" id="demo3DCardTiltWrapper" style="width: 340px; height: 220px; position: relative; transition: transform 0.1s ease; transform-style: preserve-3d;">
                            <div id="demo3DCard" class="vgb-atm-card debit interactive" style="width: 100%; height: 100%; position: absolute; border-radius: 20px; margin: 0; transform-style: preserve-3d;" onclick="flipDemoCard()">
                                <!-- Front Face -->
                                <div class="card-face card-front">
                                    <!-- Gold V-Logo & Stacked Bank Name Header -->
                                    <div class="card-bank-header">
                                        <div class="card-logo-v">
                                            <svg viewBox="0 0 100 100" style="width: 22px; height: 22px;">
                                                <defs>
                                                    <linearGradient id="goldGradCard_demo" x1="0%" y1="0%" x2="100%" y2="100%">
                                                        <stop offset="0%" stop-color="#bf953f" />
                                                        <stop offset="25%" stop-color="#fcf6ba" />
                                                        <stop offset="50%" stop-color="#b38728" />
                                                        <stop offset="75%" stop-color="#fbf5b7" />
                                                        <stop offset="100%" stop-color="#aa771c" />
                                                    </linearGradient>
                                                </defs>
                                                <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGradCard_demo)" />
                                                <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGradCard_demo)" />
                                            </svg>
                                        </div>
                                        <div class="card-bank-name-stack">
                                            <span class="bank-title">VERTEX</span>
                                            <span class="bank-subtitle">GELEXY BANK</span>
                                        </div>
                                    </div>
                                    
                                    <!-- Platinum Tier Indicator Text -->
                                    <div class="card-tier-indicator" id="demoTierIndicator"></div>

                                    <!-- Metallic Chip & Wireless Waves Row -->
                                    <div class="card-middle-row">
                                        <div class="metallic-chip"></div>
                                        <i class="bx bx-wifi contactless-icon"></i>
                                    </div>

                                    <!-- Centered Card Number -->
                                    <div class="card-number-display" id="demoNumber">4589  7321  6048  2190</div>

                                    <!-- Details & Network Provider Footer Row -->
                                    <div class="card-bottom-row">
                                        <div class="card-holder-info">
                                            <div class="expiry-info">
                                                <span class="expiry-label">VALID THRU</span>
                                                <span class="expiry-value" id="demoExpiry">12/30</span>
                                            </div>
                                            <div class="holder-name" id="demoHolder">MIHIR BHAYANI</div>
                                        </div>
                                        <div class="card-brand-logo" id="demoBrandLogo"></div>
                                    </div>
                                </div>
                                
                                <!-- Back Face -->
                                <div class="card-face card-back">
                                    <div class="card-back-header">
                                        <span class="back-helpline">For customer service, call 1800 123 4567 or visit www.vertexgelexybank.com</span>
                                        <span class="back-card-id" id="demoCardId">VGB000</span>
                                    </div>
                                    <div class="card-back-magnetic-strip"></div>
                                    <div class="card-back-signature-container">
                                        <div class="signature-strip-text">
                                            <span>AUTHORISED SIGNATURE</span>
                                            <span>NOT VALID UNLESS SIGNED</span>
                                        </div>
                                        <div class="signature-strip-cvv">
                                            <span class="cvv-val" id="demoCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV" style="cursor: pointer;">•••</span>
                                        </div>
                                    </div>
                                    <div class="card-back-bottom">
                                        <div class="back-left-emblem" id="demoBackEmblem"></div>
                                        <div class="back-right-logo">
                                            <div class="back-logo-v">
                                                <svg viewBox="0 0 100 100" style="width: 15px; height: 15px;">
                                                    <defs>
                                                        <linearGradient id="goldGradBack_demo" x1="0%" y1="0%" x2="100%" y2="100%">
                                                            <stop offset="0%" stop-color="#bf953f" />
                                                            <stop offset="25%" stop-color="#fcf6ba" />
                                                            <stop offset="50%" stop-color="#b38728" />
                                                            <stop offset="75%" stop-color="#fbf5b7" />
                                                            <stop offset="100%" stop-color="#aa771c" />
                                                        </linearGradient>
                                                    </defs>
                                                    <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGradBack_demo)" />
                                                    <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGradBack_demo)" />
                                                </svg>
                                                <span class="logo-text-stacked">
                                                    <span class="text-top">VERTEX</span>
                                                    <span class="text-bottom">GELEXY BANK</span>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="back-property-text">
                                        This card is the property of Vertex Gelexy Bank. If found, please return to the nearest branch.
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div style="margin-top: 25px; display: flex; gap: 15px; font-size: 0.75rem; color: var(--gray-500); align-items: center;">
                            <span><i class="bx bx-mouse" style="color: var(--primary-500);"></i> Hover to Tilt</span>
                            <span>|</span>
                            <span><i class="bx bx-pointer" style="color: var(--primary-500);"></i> Click Card to Flip</span>
                        </div>
                    </div>
                    
                    <!-- Right Column: Customizer Controls -->
                    <div class="simulator-controls">
                        <div class="control-row">
                            <div class="control-group">
                                <label class="control-label">Card Type</label>
                                <select id="ctrlCardType" class="control-select" onchange="syncDemoCard()">
                                    <option value="debit">VGB Sapphire Debit</option>
                                    <option value="debit-premium">VGB Platinum Debit (Premium)</option>
                                    <option value="credit">VGB Royale Credit</option>
                                    <option value="credit-premium">VGB Infinite Credit (Premium)</option>
                                    <option value="inactive">VGB Blocked/Inactive</option>
                                </select>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Network Provider</label>
                                <select id="ctrlCardProvider" class="control-select" onchange="syncDemoCard()">
                                    <option value="visa">Visa Secure</option>
                                    <option value="mastercard">Mastercard ID</option>
                                    <option value="rupay">RuPay Global</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Embossed Name</label>
                            <input type="text" id="ctrlHolderName" class="control-input" value="MIHIR BHAYANI" placeholder="CARD HOLDER NAME" oninput="syncDemoCard()" style="text-transform: uppercase;">
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Card Number</label>
                            <input type="text" id="ctrlCardNumber" class="control-input" value="4589 7321 6048 2190" placeholder="16-Digit Card Number" oninput="syncDemoCard()" maxlength="19">
                        </div>
                        
                        <div class="control-row">
                            <div class="control-group">
                                <label class="control-label">Expiry Date</label>
                                <input type="text" id="ctrlExpiry" class="control-input" value="12/30" placeholder="MM/YY" oninput="syncDemoCard()" maxlength="5">
                            </div>
                            <div class="control-group">
                                <label class="control-label">CVV Code</label>
                                <input type="text" id="ctrlCvv" class="control-input" value="907" placeholder="3 Digits" oninput="syncDemoCard()" maxlength="3">
                            </div>
                        </div>
                        
                        <div class="control-row" style="margin-top: 10px;">
                            <button type="button" class="btn btn-secondary" onclick="randomizeDemoCard()" style="padding: 10px; width: 100%; font-size: 0.85rem; font-weight: 600; margin-top: 0; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-color: var(--primary-500); color: var(--primary-500); background: transparent;">
                                <i class="bx bx-shuffle"></i> Randomize
                            </button>
                            <button type="button" class="btn btn-primary" onclick="flipDemoCard()" style="padding: 10px; width: 100%; font-size: 0.85rem; font-weight: 600; margin-top: 0; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
                                <i class="bx bx-rotate-right"></i> Flip Card
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table 1: Pending Card Approvals -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-time"></i> Pending Card Applications Awaiting Review
                </h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Card Type</th>
                                <th style="padding: 12px 15px;">Provider</th>
                                <th style="padding: 12px 15px;">Holder Name</th>
                                <th style="padding: 12px 15px;">Linked Account</th>
                                <th style="padding: 12px 15px;">Fee Paid</th>
                                <th style="padding: 12px 15px;">Applied Date</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasPending" value="false" />
                            <c:forEach var="card" items="${cards}">
                                <c:if test="${card.status eq 'pending'}">
                                    <c:set var="hasPending" value="true" />
                                    <fmt:formatDate var="formattedAppliedDate" value="${card.createdAt}" pattern="MM/yy" />
                                    <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                        <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">
                                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 3px 8px; border-radius: var(--radius-sm); font-size: 0.75rem;">${card.cardType}</span>
                                        </td>
                                        <td style="padding: 15px; text-transform: uppercase; font-weight: 500;">${card.cardProvider}</td>
                                        <td style="padding: 15px; font-weight: 500;">${card.cardHolderName}</td>
                                        <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${card.accountNumber}</td>
                                        <td style="padding: 15px; font-weight: 600; color: var(--accent-emerald);">₹ ${card.cardFee}</td>
                                        <td style="padding: 15px;"><fmt:formatDate value="${card.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td style="padding: 15px; text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; white-space: nowrap;">
                                            <button type="button" class="btn btn-secondary" onclick="open3DCardPreview('${card.cardNumber}', '${card.cardHolderName}', '${card.cardType}', '${card.cardProvider}', '${card.cvv}', '${formattedAppliedDate}', '${card.status}', '${card.dailyLimit}')" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500); background: transparent; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-show"></i> View 3D</button>
                                            <a href="${pageContext.request.contextPath}/card?action=approve&id=${card.cardId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--accent-emerald); color: var(--accent-emerald); margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-check"></i> Approve</a>
                                            <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn btn-secondary" onclick="return confirm('Reject and permanently close this card application?');" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444; margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-x"></i> Reject</a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasPending}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 30px; color: var(--gray-400);">No pending ATM card applications at this time.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Table 2: All System Cards (Debit & Credit) -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px;">
                    <i class="bx bx-credit-card-front"></i> All System Issued Cards Directory
                </h3>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); color: var(--gray-500); font-size: 0.85rem; font-weight: 600;">
                                <th style="padding: 12px 15px;">Sr No.</th>
                                <th style="padding: 12px 15px;">Card Number</th>
                                <th style="padding: 12px 15px;">Holder Name</th>
                                <th style="padding: 12px 15px;">Card Type</th>
                                <th style="padding: 12px 15px;">Provider</th>
                                <th style="padding: 12px 15px;">Expiry Date</th>
                                <th style="padding: 12px 15px;">Dues (Credit)</th>
                                <th style="padding: 12px 15px;">Status</th>
                                <th style="padding: 12px 15px; text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty cards}">
                                    <c:forEach var="card" items="${cards}" varStatus="status">
                                        <fmt:formatDate var="formattedExpiryDate" value="${card.expiryDate}" pattern="MM/yy" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; color: var(--gray-700);">
                                            <td style="padding: 15px; font-weight: 600; color: var(--gray-600);">${status.count}</td>
                                            <td style="padding: 15px; font-family: monospace; letter-spacing: 1px;">${card.cardNumber}</td>
                                            <td style="padding: 15px; font-weight: 500;">${card.cardHolderName}</td>
                                            <td style="padding: 15px; text-transform: capitalize; font-weight: 600;">${card.cardType}</td>
                                            <td style="padding: 15px; text-transform: uppercase;">${card.cardProvider}</td>
                                            <td style="padding: 15px;"><fmt:formatDate value="${card.expiryDate}" pattern="yyyy-MM-dd" /></td>
                                            <td style="padding: 15px; font-weight: 700;" class="${card.outstandingBalance gt 0 ? 'card-dues-warning' : 'card-dues-normal'}">
                                                ₹ <fmt:formatNumber value="${card.outstandingBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${card.status eq 'active'}">
                                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Active</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.1); color: var(--accent-amber); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Pending</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'expired'}">
                                                        <span style="background: rgba(239, 68, 68, 0.1); color: #b91c1c; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Expired</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(156, 163, 175, 0.1); color: var(--gray-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Closed</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; white-space: nowrap;">
                                                <button type="button" class="btn btn-secondary" onclick="open3DCardPreview('${card.cardNumber}', '${card.cardHolderName}', '${card.cardType}', '${card.cardProvider}', '${card.cvv}', '${formattedExpiryDate}', '${card.status}', '${card.dailyLimit}')" style="padding: 6px 12px; font-size: 0.75rem; border-color: var(--primary-500); color: var(--primary-500); background: transparent; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-show"></i> View 3D</button>
                                                <c:if test="${card.status eq 'active'}">
                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn btn-secondary" onclick="return confirm('Are you sure you want to permanently close card #${card.cardId}?');" style="padding: 6px 12px; font-size: 0.75rem; border-color: #ef4444; color: #ef4444; margin-top: 0; width: 95px; min-width: 95px; white-space: nowrap; display: inline-flex; align-items: center; justify-content: center; gap: 4px;"><i class="bx bx-power-off"></i> Close</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 30px; color: var(--gray-400);">No ATM cards registered in database directory.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer" style="padding: 20px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <!-- Premium 3D Card Visualizer Modal -->
    <div id="previewCardModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 1000; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px); align-items: center; justify-content: center; padding: 20px;">
        <div class="glass-card" style="background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(25px); border: 1px solid rgba(99, 102, 241, 0.2); width: 100%; max-width: 450px; border-radius: var(--radius-lg); padding: 30px; position: relative; animation: modalFadeIn 0.3s ease-out; box-shadow: var(--shadow-xl); margin-bottom: 0;">
            <span onclick="close3DCardPreview()" style="position: absolute; right: 20px; top: 20px; font-size: 1.5rem; color: var(--gray-400); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-800)'" onmouseout="this.style.color='var(--gray-400)'">&times;</span>
            
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <i class="bx bx-credit-card-front" style="color: var(--primary-500); font-size: 1.4rem;"></i> VGB Premium Card Visualizer
            </h3>

            <!-- 3D Flippable Card -->
            <div class="card-3d-scene" id="visualizerCardTiltWrapper" style="perspective: 1000px; width: 100%; display: flex; justify-content: center; margin-bottom: 30px; transition: transform 0.1s ease; transform-style: preserve-3d;">
                <div id="visualizerCard" class="vgb-atm-card interactive" style="width: 340px; height: 220px; border-radius: 20px; position: relative; margin: 0; box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15); transform-style: preserve-3d; border: 1.5px solid rgba(255, 255, 255, 0.2); cursor: pointer;" onclick="this.classList.toggle('flipped')">
                    <!-- Front Face -->
                    <div class="card-face card-front">
                        <!-- Gold V-Logo & Stacked Bank Name Header -->
                        <div class="card-bank-header">
                            <div class="card-logo-v">
                                <svg viewBox="0 0 100 100" style="width: 22px; height: 22px;">
                                    <defs>
                                        <linearGradient id="goldGradCard_preview" x1="0%" y1="0%" x2="100%" y2="100%">
                                            <stop offset="0%" stop-color="#bf953f" />
                                            <stop offset="25%" stop-color="#fcf6ba" />
                                            <stop offset="50%" stop-color="#b38728" />
                                            <stop offset="75%" stop-color="#fbf5b7" />
                                            <stop offset="100%" stop-color="#aa771c" />
                                        </linearGradient>
                                    </defs>
                                    <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGradCard_preview)" />
                                    <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGradCard_preview)" />
                                </svg>
                            </div>
                            <div class="card-bank-name-stack">
                                <span class="bank-title">VERTEX</span>
                                <span class="bank-subtitle">GELEXY BANK</span>
                            </div>
                        </div>
                        
                        <!-- Platinum Tier Indicator Text -->
                        <div class="card-tier-indicator" id="previewTierIndicator"></div>

                        <!-- Metallic Chip & Wireless Waves Row -->
                        <div class="card-middle-row">
                            <div class="metallic-chip"></div>
                            <i class="bx bx-wifi contactless-icon"></i>
                        </div>

                        <!-- Centered Card Number -->
                        <div class="card-number-display" id="previewNumber">4589  7321  6048  2190</div>

                        <!-- Details & Network Provider Footer Row -->
                        <div class="card-bottom-row">
                            <div class="card-holder-info">
                                <div class="expiry-info">
                                    <span class="expiry-label">VALID THRU</span>
                                    <span class="expiry-value" id="previewExpiry">12/29</span>
                                </div>
                                <div class="holder-name" id="previewHolder">John Doe</div>
                            </div>
                            <div class="card-brand-logo" id="previewBrandLogo"></div>
                        </div>
                    </div>

                    <!-- Back Face -->
                    <div class="card-face card-back">
                        <div class="card-back-header">
                            <span class="back-helpline">For customer service, call 1800 123 4567 or visit www.vertexgelexybank.com</span>
                            <span class="back-card-id" id="previewCardId">VGB000</span>
                        </div>
                        <div class="card-back-magnetic-strip"></div>
                        <div class="card-back-signature-container">
                            <div class="signature-strip-text">
                                <span>AUTHORISED SIGNATURE</span>
                                <span>NOT VALID UNLESS SIGNED</span>
                            </div>
                            <div class="signature-strip-cvv">
                                <span class="cvv-val" id="previewCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV" style="cursor: pointer;">•••</span>
                            </div>
                        </div>
                        <div class="card-back-bottom">
                            <div class="back-left-emblem" id="previewBackEmblem"></div>
                            <div class="back-right-logo">
                                <div class="back-logo-v">
                                    <svg viewBox="0 0 100 100" style="width: 15px; height: 15px;">
                                        <defs>
                                            <linearGradient id="goldGradBack_preview" x1="0%" y1="0%" x2="100%" y2="100%">
                                                <stop offset="0%" stop-color="#bf953f" />
                                                <stop offset="25%" stop-color="#fcf6ba" />
                                                <stop offset="50%" stop-color="#b38728" />
                                                <stop offset="75%" stop-color="#fbf5b7" />
                                                <stop offset="100%" stop-color="#aa771c" />
                                            </linearGradient>
                                        </defs>
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGradBack_preview)" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGradBack_preview)" />
                                    </svg>
                                    <span class="logo-text-stacked">
                                        <span class="text-top">VERTEX</span>
                                        <span class="text-bottom">GELEXY BANK</span>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="back-property-text">
                            This card is the property of Vertex Gelexy Bank. If found, please return to the nearest branch.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Spec Sheet -->
            <div style="background: var(--gray-50); border: 1px solid var(--gray-200); border-radius: var(--radius-md); padding: 15px; font-size: 0.85rem;">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                    <div>
                        <span style="color: var(--gray-400); display: block; font-size: 0.7rem; text-transform: uppercase; font-weight: 600;">Status</span>
                        <strong id="previewSpecStatus" style="font-size: 0.85rem; text-transform: uppercase; color: var(--accent-emerald);">Active</strong>
                    </div>
                    <div>
                        <span style="color: var(--gray-400); display: block; font-size: 0.7rem; text-transform: uppercase; font-weight: 600;">Daily Limit</span>
                        <strong id="previewSpecLimit" style="font-size: 0.85rem; color: var(--gray-800);">₹ 50,000.00</strong>
                    </div>
                </div>
            </div>

            <div style="display: flex; justify-content: center; margin-top: 25px;">
                <button type="button" class="btn btn-secondary" onclick="close3DCardPreview()" style="padding: 10px 25px; font-weight: 600; width: 100%; margin-top: 0;">Close Visualizer</button>
            </div>
        </div>
    </div>

    <script>
        function updateDynamicCardDetails(cardElementId, tierElId, brandLogoElId, backEmblemElId, cardType, provider, dailyLimit, status = 'active') {
            const card = document.getElementById(cardElementId);
            const tierEl = document.getElementById(tierElId);
            const brandLogoEl = document.getElementById(brandLogoElId);
            const backEmblemEl = document.getElementById(backEmblemElId);
            
            if (!card) return;

            // Normalise cardType
            let isDebit = true;
            let isPremium = false;
            let isInactive = status.toLowerCase() !== 'active';

            if (cardType === 'debit') {
                isDebit = true;
                isPremium = dailyLimit > 50000;
            } else if (cardType === 'debit-premium') {
                isDebit = true;
                isPremium = true;
            } else if (cardType === 'credit') {
                isDebit = false;
                isPremium = dailyLimit > 50000;
            } else if (cardType === 'credit-premium') {
                isDebit = false;
                isPremium = true;
            } else if (cardType === 'inactive') {
                isInactive = true;
            }

            // Set classes on card element
            card.className = "vgb-atm-card interactive";
            if (isInactive) {
                card.classList.add('inactive-card');
            } else {
                card.classList.add(isDebit ? 'debit' : 'credit');
                card.classList.add(provider.toLowerCase());
                if (isPremium) {
                    card.classList.add('premium-tier');
                }
            }

            // Set Tier text
            if (tierEl) {
                if (!isInactive && (isPremium || (!isDebit && provider.toLowerCase() === 'rupay'))) {
                    let tierText = 'PLATINUM';
                    if (!isDebit && provider.toLowerCase() === 'visa') {
                        tierText = 'INFINITE';
                    }
                    tierEl.innerHTML = `<span class="platinum-text">${tierText}</span>`;
                } else {
                    tierEl.innerHTML = '';
                }
            }

            // Set Front Brand Logo
            if (brandLogoEl) {
                const prov = provider.toLowerCase();
                if (prov === 'visa') {
                    let subText = isDebit ? (isPremium ? 'Platinum' : 'Debit') : (isPremium ? 'Infinite' : 'Signature');
                    brandLogoEl.innerHTML = `
                        <div class="brand-visa">
                            <span class="visa-text">VISA</span>
                            <span class="visa-sub">${subText}</span>
                        </div>
                    `;
                } else if (prov === 'mastercard') {
                    let subText = isDebit ? 'debit' : 'mastercard';
                    brandLogoEl.innerHTML = `
                        <div class="brand-mastercard">
                            <div class="mc-circles">
                                <span class="circle red"></span>
                                <span class="circle orange"></span>
                            </div>
                            <span class="mc-text">${subText}</span>
                        </div>
                    `;
                } else {
                    let subText = isDebit ? 'DEBIT' : 'CREDIT';
                    brandLogoEl.innerHTML = `
                        <div class="brand-rupay">
                            <span class="rupay-text">RuPay<span class="arrow-accent">▶</span></span>
                            <span class="rupay-sub">${subText}</span>
                        </div>
                    `;
                }
            }

            // Set Back Emblem
            if (backEmblemEl) {
                const prov = provider.toLowerCase();
                if (prov === 'visa') {
                    backEmblemEl.innerHTML = `<div class="dove-hologram"></div>`;
                } else if (prov === 'mastercard') {
                    backEmblemEl.innerHTML = `<div class="mc-hologram"></div>`;
                } else {
                    backEmblemEl.innerHTML = `<span class="rupay-back-emblem">RuPay<span class="arrow-accent">▶</span></span>`;
                }
            }
        }

        function open3DCardPreview(number, holder, type, provider, cvv, expiry, status, limit) {
            const modal = document.getElementById('previewCardModal');
            
            // Set text values
            document.getElementById('previewNumber').innerText = number;
            document.getElementById('previewHolder').innerText = holder;
            document.getElementById('previewExpiry').innerText = expiry;
            
            const previewCvvEl = document.getElementById('previewCvv');
            previewCvvEl.innerText = "•••";
            previewCvvEl.setAttribute('data-cvv', cvv);
            
            const numLimit = parseFloat(limit) || 0;
            
            // Call helper to set all classes, tier indicators, brand logos, and back emblems
            updateDynamicCardDetails('visualizerCard', 'previewTierIndicator', 'previewBrandLogo', 'previewBackEmblem', type.toLowerCase(), provider.toLowerCase(), numLimit, status);
            
            const specStatus = document.getElementById('previewSpecStatus');
            const specLimit = document.getElementById('previewSpecLimit');
            
            if (status.toLowerCase() === 'active') {
                specStatus.innerText = "Active";
                specStatus.style.color = "var(--accent-emerald)";
            } else if (status.toLowerCase() === 'pending') {
                specStatus.innerText = "Pending Approval";
                specStatus.style.color = "var(--accent-amber)";
            } else if (status.toLowerCase() === 'expired') {
                specStatus.innerText = "Expired";
                specStatus.style.color = "#ef4444";
            } else {
                specStatus.innerText = "Closed";
                specStatus.style.color = "var(--gray-500)";
            }
            
            // Set Limit Spec
            specLimit.innerText = type.toLowerCase() === 'credit' ? "₹ " + numLimit.toLocaleString('en-IN', {minimumFractionDigits:2}) + " Outstanding" : "₹ " + numLimit.toLocaleString('en-IN', {minimumFractionDigits:2}) + " Daily Limit";
            
            // Ensure card front face is showing by default
            const card = document.getElementById('visualizerCard');
            card.classList.remove('flipped');
            
            const wrapper = document.getElementById('visualizerCardTiltWrapper');
            if (wrapper) {
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            }
            
            modal.style.display = 'flex';
        }

        function close3DCardPreview() {
            document.getElementById('previewCardModal').style.display = 'none';
        }

        // Flagship Card Customizer & Interactive Simulator Logic
        function syncDemoCard() {
            const type = document.getElementById('ctrlCardType').value;
            const provider = document.getElementById('ctrlCardProvider').value;
            const holder = document.getElementById('ctrlHolderName').value.trim().toUpperCase() || "DEMO HOLDER";
            const number = document.getElementById('ctrlCardNumber').value.trim() || "4589 7321 6048 2190";
            const expiry = document.getElementById('ctrlExpiry').value.trim() || "12/30";
            const cvv = document.getElementById('ctrlCvv').value.trim() || "907";

            // Set Text values
            document.getElementById('demoNumber').innerText = number;
            document.getElementById('demoHolder').innerText = holder;
            document.getElementById('demoExpiry').innerText = expiry;

            // Handle secure CVV storage and masking update
            const demoCvvEl = document.getElementById('demoCvv');
            demoCvvEl.setAttribute('data-cvv', cvv);
            if (demoCvvEl.innerText !== '•••') {
                demoCvvEl.innerText = cvv;
            }

            // Set status based on selected type
            const status = type === 'inactive' ? 'inactive' : 'active';
            const limit = type.includes('premium') ? 100000 : 50000;

            // Call helper to sync all classes, tier indicators, brand logos, and back emblems
            updateDynamicCardDetails('demo3DCard', 'demoTierIndicator', 'demoBrandLogo', 'demoBackEmblem', type, provider, limit, status);
        }

        // Mask/Unmask CVV on the back face securely without flipping card
        function toggle3DCardCvv(event, element) {
            if (event) event.stopPropagation(); // Stop click from flipping the card!
            const realCvv = element.getAttribute('data-cvv') || "907";
            if (element.innerText === '•••') {
                element.innerText = realCvv;
                element.title = "Click to hide CVV";
            } else {
                element.innerText = '•••';
                element.title = "Click to show CVV";
            }
        }

        function randomizeDemoCard() {
            const names = ["MIHIR BHAYANI", "PARTH TANK", "KARAN PATEL", "SNEHA RAO", "ROHAN SHARMA", "VERTEX GELEXY BANK SPECIAL"];
            const providers = ["visa", "mastercard", "rupay"];
            const types = ["debit", "debit-premium", "credit", "credit-premium"];
            
            const randomName = names[Math.floor(Math.random() * names.length)];
            const randomProvider = providers[Math.floor(Math.random() * providers.length)];
            const randomType = types[Math.floor(Math.random() * types.length)];
            
            // Generate standard spaced card sequences based on network provider prefix
            let cardPrefix = "4";
            if (randomProvider === 'mastercard') cardPrefix = "5";
            if (randomProvider === 'rupay') cardPrefix = "6";
            
            let cardNumber = cardPrefix;
            for (let i = 0; i < 15; i++) {
                if (i > 0 && i % 4 === 3) cardNumber += "  ";
                cardNumber += Math.floor(Math.random() * 10);
            }

            // Expiry Month / Year (4-year offset max)
            const months = ["01", "03", "04", "05", "07", "08", "10", "11", "12"];
            const randomMonth = months[Math.floor(Math.random() * months.length)];
            const randomYear = 26 + Math.floor(Math.random() * 5); // 2026 to 2030

            // 3-digit CVV
            const randomCvv = Math.floor(100 + Math.random() * 900);

            // Populate form elements
            document.getElementById('ctrlCardType').value = randomType;
            document.getElementById('ctrlCardProvider').value = randomProvider;
            document.getElementById('ctrlHolderName').value = randomName;
            document.getElementById('ctrlCardNumber').value = cardNumber;
            document.getElementById('ctrlExpiry').value = randomMonth + "/" + randomYear;
            document.getElementById('ctrlCvv').value = randomCvv;

            syncDemoCard();
        }

        function flipDemoCard() {
            document.getElementById('demo3DCard').classList.toggle('flipped');
        }

        // Live 3D Tilt Effect calculations using a dual wrapper approach
        function apply3DTilt(wrapperId, innerCardId) {
            const wrapper = document.getElementById(wrapperId);
            const card = document.getElementById(innerCardId);
            if (!wrapper || !card) return;
            
            wrapper.addEventListener('mousemove', function(e) {
                const rect = wrapper.getBoundingClientRect();
                const x = e.clientX - rect.left; // x coordinate inside element
                const y = e.clientY - rect.top;  // y coordinate inside element
                
                const width = rect.width;
                const height = rect.height;
                
                // Normalise coordinates around centre point (-0.5 to +0.5)
                const percentX = (x / width) - 0.5;
                const percentY = (y / height) - 0.5;
                
                // Scale coordinate vector values for yaw/pitch thresholds
                const maxRotation = 14; 
                
                const rotateX = -(percentY * maxRotation).toFixed(2);
                const rotateY = (percentX * maxRotation).toFixed(2);
                
                wrapper.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.04, 1.04, 1.04)`;
            });
            
            wrapper.addEventListener('mouseleave', function() {
                wrapper.style.transition = "transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            });

            wrapper.addEventListener('mouseenter', function() {
                wrapper.style.transition = "none";
            });
        }

        function init3DCardTiltEffect() {
            apply3DTilt('demo3DCardTiltWrapper', 'demo3DCard');
            apply3DTilt('visualizerCardTiltWrapper', 'visualizerCard');
        }

        // Initialize elements on load
        window.addEventListener('DOMContentLoaded', () => {
            init3DCardTiltEffect();
            syncDemoCard();
        });
    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
