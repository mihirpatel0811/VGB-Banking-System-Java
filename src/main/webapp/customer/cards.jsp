<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | My Cards</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
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

        /* 3D ATM CARD GRID LAYOUT */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        /* 3D ATM CARD SCENE STYLING */
        .card-3d-wrapper {
            width: 340px;
            height: 220px;
            perspective: 1200px;
            cursor: pointer;
            margin-bottom: 20px;
        }
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
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
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
            from { transform: scale(0.9) translateY(10px); opacity: 0; }
            to { transform: scale(1) translateY(0); opacity: 1; }
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
            .apply-paper-form, .renewal-paper-form {
                padding: 20px 15px !important;
                font-size: 0.85rem !important;
            }
            .apply-paper-form h2, .renewal-paper-form h2 {
                font-size: 1.1rem !important;
            }
            .apply-paper-form h3, .renewal-paper-form h3 {
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

        .form-select, .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            margin-top: 5px;
            background: white;
            font-family: inherit;
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
        <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center;">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="Vertex Galaxy Bank Logo" style="height: 38px; width: auto;">
        </a>
        <div class="nav-actions">
            <span style="font-weight: 600; color: var(--gray-700);"><i class="bx bx-user-circle"></i> Customer Space</span>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/customer-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list"><i class="bx bx-wallet"></i> Accounts</a>
            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i class="bx bx-transfer-alt"></i> Fund Transfer</a>
            <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Loans</a>
            <a href="${pageContext.request.contextPath}/account?action=statement"><i class="bx bx-file"></i> Statements</a>
            <a href="${pageContext.request.contextPath}/customer/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/customer/notification.jsp"><i class="bx bx-bell"></i> Alerts</a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Support Hotline</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">1800-VGB-BANK</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">My Premium ATM Cards</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Manage VGB Debit and Credit Cards, clear dues, and extend your cards validity dynamically.</p>
                </div>
                <div>
                    <button onclick="openApplyModal()" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <i class="bx bx-plus-circle"></i> Apply New Card
                    </button>
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

            <!-- Cards Rendering Grid -->
            <div class="cards-grid">
                <c:choose>
                    <c:when test="${not empty cards}">
                        <c:forEach var="card" items="${cards}">
                            <div style="display: flex; flex-direction: column; align-items: center; gap: 15px;">
                                <div class="card-3d-wrapper" onclick="this.querySelector('.vgb-atm-card').classList.toggle('flipped')">
                                    <div class="vgb-atm-card ${card.cardType} ${card.cardProvider} ${card.dailyLimit gt 50000 ? 'premium-tier' : ''} ${card.status ne 'active' ? 'inactive-card' : ''}">
                                        <!-- Front Face -->
                                        <div class="card-face card-front">
                                            <!-- Gold V-Logo & Stacked Bank Name Header -->
                                            <div class="card-bank-header">
                                                <div class="card-logo-v">
                                                    <svg viewBox="0 0 100 100" style="width: 22px; height: 22px;">
                                                        <defs>
                                                            <linearGradient id="goldGradCard_${card.cardId}" x1="0%" y1="0%" x2="100%" y2="100%">
                                                                <stop offset="0%" stop-color="#bf953f" />
                                                                <stop offset="25%" stop-color="#fcf6ba" />
                                                                <stop offset="50%" stop-color="#b38728" />
                                                                <stop offset="75%" stop-color="#fbf5b7" />
                                                                <stop offset="100%" stop-color="#aa771c" />
                                                            </linearGradient>
                                                        </defs>
                                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGradCard_${card.cardId})" />
                                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGradCard_${card.cardId})" />
                                                    </svg>
                                                </div>
                                                <div class="card-bank-name-stack">
                                                    <span class="bank-title">VERTEX</span>
                                                    <span class="bank-subtitle">GELEXY BANK</span>
                                                </div>
                                            </div>
                                            
                                            <!-- Platinum Tier Indicator Text -->
                                            <div class="card-tier-indicator">
                                                <c:if test="${card.dailyLimit gt 50000 or (card.cardType eq 'credit' and card.cardProvider eq 'rupay') or (card.cardType eq 'credit' and card.cardProvider eq 'visa' and card.dailyLimit gt 50000)}">
                                                    <span class="platinum-text">${card.cardType eq 'credit' and card.cardProvider eq 'visa' ? 'INFINITE' : 'PLATINUM'}</span>
                                                </c:if>
                                            </div>

                                            <!-- Metallic Chip & Wireless Waves Row -->
                                            <div class="card-middle-row">
                                                <div class="metallic-chip"></div>
                                                <i class="bx bx-wifi contactless-icon"></i>
                                            </div>

                                            <!-- Centered Card Number -->
                                            <div class="card-number-display">
                                                ${card.cardNumber}
                                            </div>

                                            <!-- Details & Network Provider Footer Row -->
                                            <div class="card-bottom-row">
                                                <div class="card-holder-info">
                                                    <div class="expiry-info">
                                                        <span class="expiry-label">VALID THRU</span>
                                                        <span class="expiry-value"><fmt:formatDate value="${card.expiryDate}" pattern="MM/yy" /></span>
                                                    </div>
                                                    <div class="holder-name">${card.cardHolderName}</div>
                                                </div>
                                                <div class="card-brand-logo">
                                                    <c:choose>
                                                        <c:when test="${card.cardProvider eq 'visa'}">
                                                            <div class="brand-visa">
                                                                <span class="visa-text">VISA</span>
                                                                <span class="visa-sub">${card.cardType eq 'debit' ? (card.dailyLimit gt 50000 ? 'Platinum' : 'Debit') : (card.dailyLimit gt 50000 ? 'Infinite' : 'Signature')}</span>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${card.cardProvider eq 'mastercard'}">
                                                            <div class="brand-mastercard">
                                                                <div class="mc-circles">
                                                                    <span class="circle red"></span>
                                                                    <span class="circle orange"></span>
                                                                </div>
                                                                <span class="mc-text">${card.cardType eq 'debit' ? 'debit' : 'mastercard'}</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="brand-rupay">
                                                                <span class="rupay-text">RuPay<span class="arrow-accent">▶</span></span>
                                                                <span class="rupay-sub">${card.cardType eq 'debit' ? 'DEBIT' : 'CREDIT'}</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Back Face -->
                                        <div class="card-face card-back">
                                            <div class="card-back-header">
                                                <span class="back-helpline">For customer service, call 1800 123 4567 or visit www.vertexgelexybank.com</span>
                                                <span class="back-card-id">VGB${card.cardId}</span>
                                            </div>
                                            <div class="card-back-magnetic-strip"></div>
                                            <div class="card-back-signature-container">
                                                <div class="signature-strip-text">
                                                    <span>AUTHORISED SIGNATURE</span>
                                                    <span>NOT VALID UNLESS SIGNED</span>
                                                </div>
                                                <div class="signature-strip-cvv" onclick="toggleCvv(this, '${card.cvv}')" title="Click to show CVV" style="cursor: pointer;">
                                                    <span class="cvv-val cvv-text">•••</span>
                                                </div>
                                            </div>
                                            <div class="card-back-bottom">
                                                <div class="back-left-emblem">
                                                    <c:choose>
                                                        <c:when test="${card.cardProvider eq 'visa'}">
                                                            <div class="dove-hologram"></div>
                                                        </c:when>
                                                        <c:when test="${card.cardProvider eq 'mastercard'}">
                                                            <div class="mc-hologram"></div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="rupay-back-emblem">RuPay<span class="arrow-accent">▶</span></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="back-right-logo">
                                                    <div class="back-logo-v">
                                                        <svg viewBox="0 0 100 100" style="width: 15px; height: 15px;">
                                                            <defs>
                                                                <linearGradient id="goldGradBack_${card.cardId}" x1="0%" y1="0%" x2="100%" y2="100%">
                                                                    <stop offset="0%" stop-color="#bf953f" />
                                                                    <stop offset="25%" stop-color="#fcf6ba" />
                                                                    <stop offset="50%" stop-color="#b38728" />
                                                                    <stop offset="75%" stop-color="#fbf5b7" />
                                                                    <stop offset="100%" stop-color="#aa771c" />
                                                                </linearGradient>
                                                            </defs>
                                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGradBack_${card.cardId})" />
                                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGradBack_${card.cardId})" />
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

                                <!-- External Control Bar under the 3D card wrapper -->
                                <div style="display: flex; justify-content: space-between; align-items: center; width: 100%; max-width: 340px; background: rgba(255,255,255,0.7); backdrop-filter: blur(10px); padding: 10px 15px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); box-shadow: var(--shadow-sm);">
                                    <div>
                                        <c:choose>
                                            <c:when test="${card.status eq 'active'}">
                                                <span style="background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Active</span>
                                            </c:when>
                                            <c:when test="${card.status eq 'pending'}">
                                                <span style="background: rgba(245, 158, 11, 0.12); color: #b45309; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Pending</span>
                                            </c:when>
                                            <c:when test="${card.status eq 'expired'}">
                                                <span style="background: rgba(239, 68, 68, 0.12); color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Expired</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="background: rgba(156, 163, 175, 0.12); color: #4b5563; font-size: 0.7rem; font-weight: 700; padding: 4px 8px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Closed</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="display: flex; gap: 8px;">
                                        <c:if test="${card.cardType eq 'credit' and card.status eq 'active' and card.outstandingBalance gt 0}">
                                            <button type="button" onclick="openPayDuesModal('${card.cardId}', '${card.outstandingBalance}')" class="btn" style="background: var(--gradient-primary); color: white; padding: 4px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; border: none; margin: 0; box-shadow: var(--shadow-sm);">Pay Dues</button>
                                        </c:if>
                                        <c:if test="${card.status eq 'expired' or card.status eq 'closed'}">
                                            <fmt:formatDate value="${card.expiryDate}" pattern="MM/yy" var="formattedExpiryDate" />
                                            <button type="button" onclick="openRenewModal('${card.cardId}', '${card.cardType}', '${card.cardFee}', '${card.cardNumber}', '${formattedExpiryDate}', '${card.cardProvider}')" class="btn" style="background: #10b981; color: white; padding: 4px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; border: none; margin: 0;">Renew</button>
                                        </c:if>
                                        <c:if test="${card.status eq 'active'}">
                                            <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn" onclick="return confirm('Are you sure you want to permanently close this VGB card?');" style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 4px 10px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; text-decoration: none; border: 1px solid rgba(239, 68, 68, 0.2); margin: 0;">Close</a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="glass-card" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--gray-400);">
                            <i class="bx bx-credit-card-front" style="font-size: 3rem; color: var(--gray-300); margin-bottom: 10px; display: block;"></i>
                            <span>No ATM/Debit/Credit cards registered to your profile. Apply for a new card below!</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- VGB Card Services Guideline Card -->
            <div class="glass-card" style="background: rgba(99, 102, 241, 0.03);">
                <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--primary-500); margin-bottom: 15px;"><i class="bx bx-info-circle"></i> VGB Premium Card Services Terms & Limits</h4>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;" class="mobile-grid-1">
                    <div>
                        <strong style="color: var(--gray-800); font-size: 0.9rem; display: block; margin-bottom: 5px;">VGB Debit Card</strong>
                        <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            - **Issuance / Renewal Fee**: ₹250.00 (debited upfront).<br>
                            - **Daily Card Limit**: ₹50,000.00 per day.<br>
                            - **Card Validity**: 4 years (automatically closes, renewable upon paying the renewal fee).<br>
                            - **Ledger Source**: Directly debited from linked bank account balance.
                        </p>
                    </div>
                    <div>
                        <strong style="color: var(--gray-800); font-size: 0.9rem; display: block; margin-bottom: 5px;">VGB Credit Card</strong>
                        <p style="font-size: 0.85rem; color: var(--gray-600); line-height: 1.6;">
                            - **Issuance / Renewal Fee**: ₹500.00 (debited upfront).<br>
                            - **Credit Limit**: ₹50,000.00 outstanding capacity.<br>
                            - **Card Validity**: 4 years (automatically closes, renewable upon paying the renewal fee).<br>
                            - **Ledger Source**: Outstanding balance billed, clear dues from any linked VGB bank account.
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
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-plus-circle"></i> Apply VGB ATM Card</h3>
                <button type="button" onclick="closeApplyModal()" class="close-btn">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/card?action=apply" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <div class="modal-body" style="padding-top: 15px;">
                    <!-- The Formal Banking Paper Form -->
                    <div class="apply-paper-form" style="background: #fff; border: 1.5px solid var(--gray-200); padding: 35px 30px; border-radius: var(--radius-sm); color: #1e293b; font-family: 'Times New Roman', Times, serif; font-size: 0.95rem; line-height: 1.6; margin-bottom: 25px; box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm); position: relative; overflow: hidden;">
                        <!-- Watermark -->
                        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 7.5rem; font-weight: 900; color: rgba(99, 102, 241, 0.03); pointer-events: none; user-select: none; font-family: 'Poppins', sans-serif; letter-spacing: 5px;">VGB</div>
                        
                        <!-- Form Header -->
                        <div style="text-align: center; border-bottom: 2px double #475569; padding-bottom: 12px; margin-bottom: 20px; position: relative;">
                            <h2 style="font-size: 1.35rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: #0f172a; margin: 0; font-family: 'Poppins', sans-serif;">Vertex Galaxy Bank</h2>
                            <h3 style="font-size: 1rem; font-weight: 700; color: #475569; margin: 4px 0 0; text-transform: uppercase; font-family: 'Poppins', sans-serif; letter-spacing: 0.5px;">ATM Card Application Request Form</h3>
                            <span style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); font-family: 'Poppins', sans-serif;">
                                Issuance Fee Due: <strong id="applyFeeValue" style="font-weight: 800;">₹ 250.00</strong>
                            </span>
                        </div>
                        
                        <!-- Header Details -->
                        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
                            <tr>
                                <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                    <strong>To,</strong><br>
                                    The Branch Manager<br>
                                    <strong>Vertex Galaxy Bank</strong><br>
                                    Branch: <input type="text" name="branch" style="width: 250px; border: none; border-bottom: 1px dotted #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; color: #0f172a;" value="Main Corporate Branch, Mumbai">
                                </td>
                                <td style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                    <strong>Date:</strong> <input type="text" name="formDate" id="applyFormDateStr" style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;" value="">
                                </td>
                            </tr>
                        </table>
                        
                        <div style="margin-bottom: 20px;">
                            <strong>Subject:</strong> <span style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request for ATM/Debit Card Renewal & Issuance</span>
                        </div>
                        
                        <!-- Customer Information -->
                        <div style="margin-bottom: 20px;">
                            <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">Customer Information</h4>
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td style="width: 35%; padding: 5px 0;"><strong>Account Holder Name:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" id="applyCardHolderName" name="cardHolderName" required value="${cards[0].cardHolderName ne null ? cards[0].cardHolderName : 'MIHIR BHAYANI'}" oninput="updateApplyFormHolderName(this.value)" placeholder="ENTER HOLDER NAME" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Account Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <select id="applyAccountId" name="accountId" required style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent; cursor: pointer; -webkit-appearance: none; -moz-appearance: none; appearance: none;">
                                            <c:forEach items="${accounts}" var="acc">
                                                <option value="${acc.accountId}">
                                                    ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Customer ID (if applicable):</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="customerId" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;" value="${customer.customerId}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="mobileNumber" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;" value="${customer.phoneNo}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="emailId" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;" value="${customer.email}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="address" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-size: 0.85rem; outline: none; background: transparent; color: #0f172a;" value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Card Details Box -->
                        <div style="margin-bottom: 25px;">
                            <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">ATM/Debit Card Details</h4>
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td style="width: 45%; padding: 5px 0;"><strong>Existing ATM/Debit Card Number (Last 4 Digits):</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="existingCardLast4" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1.05rem; outline: none; background: transparent; color: #0f172a;" value="N/A (NEW CARD APPLICATION)">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Card Expiry Date:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="cardExpiry" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; outline: none; background: transparent; color: #0f172a;" value="____ / ____">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Card Category:</strong></td>
                                    <td style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                            <input type="radio" id="applyCardTypeDebit" name="cardType" value="debit" checked onchange="updateApplyFeeAndNotice('debit')" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> Debit Card (Fee: ₹250)
                                        </label>
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                            <input type="radio" id="applyCardTypeCredit" name="cardType" value="credit" onchange="updateApplyFeeAndNotice('credit')" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> Credit Card (Fee: ₹500)
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Card Network:</strong></td>
                                    <td style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                            <input type="radio" name="cardProvider" id="applyProviderRuPay" value="rupay" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> RuPay
                                        </label>
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                            <input type="radio" name="cardProvider" id="applyProviderVisa" value="visa" checked style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> Visa
                                        </label>
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                            <input type="radio" name="cardProvider" id="applyProviderMastercard" value="mastercard" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> MasterCard
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Declaration & Request text -->
                        <div style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                            <p style="margin: 0 0 10px;"><strong>Request:</strong> I request the bank to renew and issue a new ATM/Debit Card linked to my account mentioned above. My existing card is approaching expiry/has expired. I kindly request you to process my application and issue a renewed card at the earliest.</p>
                            <p style="margin: 0;"><strong>Declaration:</strong> I declare that the information provided above is true and correct.</p>
                        </div>
                        
                        <!-- Signatures Row -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;" id="applyFormSignature">${cards[0].cardHolderName ne null ? cards[0].cardHolderName : 'MIHIR BHAYANI'}</span>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer Signature</span>
                            </div>
                            <div style="text-align: right;">
                                <span style="display: block; font-family: monospace; font-size: 0.95rem; font-weight: 600; color: #0f172a; text-transform: uppercase; padding-bottom: 5px;" id="applyFormNameLabel">${cards[0].cardHolderName ne null ? cards[0].cardHolderName : 'MIHIR BHAYANI'}</span>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Name</span>
                            </div>
                        </div>
                        
                        <!-- For Bank Use Only Stamp Card -->
                        <div style="background: rgba(248, 250, 252, 0.9); border: 2px dashed #94a3b8; border-radius: var(--radius-md); padding: 20px; font-size: 0.8rem; color: #475569; font-family: 'Poppins', sans-serif; box-shadow: var(--shadow-sm);">
                            <h5 style="margin: 0 0 12px; font-size: 0.85rem; font-weight: 800; text-transform: uppercase; color: #334155; text-align: center; border-bottom: 1px dashed #cbd5e1; padding-bottom: 8px; letter-spacing: 0.75px;">For Bank Use Only</h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px 20px;">
                                <div><strong>Application Received On:</strong> <span id="applyFormReceivedOnStr" style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px;">____ / ____ / ______</span></div>
                                <div><strong>Verified By:</strong> <span style="border-bottom: 1px solid #64748b; font-weight: 700; font-family: monospace; padding: 0 4px; color: #1e3a8a; text-transform: uppercase;">SYSTEM_AUTOMATION</span></div>
                                <div><strong>Renewal Request Processed:</strong> <span style="display: inline-flex; align-items: center; gap: 4px; margin-left: 5px;"><input type="checkbox" checked disabled style="width: 11px; height: 11px; margin: 0;"> Yes</span> <span style="display: inline-flex; align-items: center; gap: 4px; margin-left: 10px;"><input type="checkbox" disabled style="width: 11px; height: 11px; margin: 0;"> No</span></div>
                                <div><strong>New Card Issued On:</strong> <span style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px; color: #047857;">AUTO_APPROVE</span></div>
                            </div>
                            <div style="text-align: right; margin-top: 15px;">
                                <div style="display: inline-block; text-align: center;">
                                    <span style="display: block; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.25rem; color: #1e3a8a; font-weight: 700;">VertexGalaxyBank</span>
                                    <span style="border-top: 1px solid #94a3b8; display: inline-block; width: 170px; text-align: center; font-size: 0.7rem; font-weight: 700; padding-top: 2px;">Authorized Signature & Seal</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; background: #3b82f6; border-color: #3b82f6; font-weight: 600; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-family: 'Poppins', sans-serif;"><i class="bx bx-check-shield"></i> Confirm and Submit Application Form</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 2. Modal: Pay Credit Card Dues -->
    <div id="payDuesModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-shield-quarter"></i> Pay Credit Card Dues</h3>
                <button type="button" onclick="closePayDuesModal()" class="close-btn">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/card?action=payDues" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" id="duesCardId" name="cardId">
                <div class="modal-body">
                    <div style="background: rgba(99, 102, 241, 0.05); padding: 15px; border-radius: var(--radius-md); border: 1px solid rgba(99, 102, 241, 0.15); margin-bottom: 20px;">
                        <span style="font-size: 0.8rem; color: var(--gray-500); display: block;">Total Outstanding Dues Billing</span>
                        <strong id="outstandingDuesValue" style="font-size: 1.4rem; color: #ef4444; font-weight: 700;">₹ 0.00</strong>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="duesSourceAccount" style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700);">Select VGB Account to Pay Dues</label>
                        <select id="duesSourceAccount" name="accountId" required class="form-select">
                            <c:forEach items="${accounts}" var="acc">
                                <option value="${acc.accountId}">
                                    ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 25px;">
                        <label for="duesAmount" style="font-size: 0.85rem; font-weight: 500; color: var(--gray-700);">Dues Clearing Payment Amount (INR)</label>
                        <input type="number" step="0.01" min="1" id="duesAmount" name="amount" required placeholder="Enter dues amount to pay" class="form-input">
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Process Card Dues Settlement</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 3. Modal: Renew Expired/Closed Card -->
    <div id="renewModal" class="modal">
        <div class="modal-content" style="max-width: 720px; width: 100%;">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-check-shield"></i> ATM Card Renewal request</h3>
                <button type="button" onclick="closeRenewModal()" class="close-btn">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/card?action=renew" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" id="renewCardId" name="cardId">
                <div class="modal-body" style="padding-top: 15px;">
                    <!-- The Formal Banking Paper Form -->
                    <div class="renewal-paper-form" style="background: #fff; border: 1.5px solid var(--gray-200); padding: 35px 30px; border-radius: var(--radius-sm); color: #1e293b; font-family: 'Times New Roman', Times, serif; font-size: 0.95rem; line-height: 1.6; margin-bottom: 25px; box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm); position: relative; overflow: hidden;">
                        <!-- Watermark -->
                        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-30deg); font-size: 7.5rem; font-weight: 900; color: rgba(99, 102, 241, 0.03); pointer-events: none; user-select: none; font-family: 'Poppins', sans-serif; letter-spacing: 5px;">VGB</div>
                        
                        <!-- Form Header -->
                        <div style="text-align: center; border-bottom: 2px double #475569; padding-bottom: 12px; margin-bottom: 20px; position: relative;">
                            <h2 style="font-size: 1.35rem; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: #0f172a; margin: 0; font-family: 'Poppins', sans-serif;">Vertex Galaxy Bank</h2>
                            <h3 style="font-size: 1rem; font-weight: 700; color: #475569; margin: 4px 0 0; text-transform: uppercase; font-family: 'Poppins', sans-serif; letter-spacing: 0.5px;">ATM Card Renewal Request Form</h3>
                            <span style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); font-family: 'Poppins', sans-serif;">
                                Renewal Fee Due: <strong id="renewFeeValue" style="font-weight: 800;">₹ 250.00</strong>
                            </span>
                        </div>
                        
                        <!-- Header Details -->
                        <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
                            <tr>
                                <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                    <strong>To,</strong><br>
                                    The Branch Manager<br>
                                    <strong>Vertex Galaxy Bank</strong><br>
                                    Branch: <input type="text" name="branch" style="width: 250px; border: none; border-bottom: 1px dotted #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; color: #0f172a;" value="Main Corporate Branch, Mumbai">
                                </td>
                                <td style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                    <strong>Date:</strong> <input type="text" name="formDate" id="renewFormDateStr" style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;" value="">
                                </td>
                            </tr>
                        </table>
                        
                        <div style="margin-bottom: 20px;">
                            <strong>Subject:</strong> <span style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request for ATM/Debit Card Renewal</span>
                        </div>
                        
                        <!-- Customer Info Box -->
                        <div style="margin-bottom: 20px;">
                            <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">Customer Information</h4>
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td style="width: 35%; padding: 5px 0;"><strong>Account Holder Name:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" id="renewCardHolderName" name="cardHolderName" required value="${customer.firstName} ${customer.lastName}" oninput="updateRenewFormHolderName(this.value)" placeholder="ENTER HOLDER NAME" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Account Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <select id="renewAccountId" name="accountId" required style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent; cursor: pointer; -webkit-appearance: none; -moz-appearance: none; appearance: none;">
                                            <c:forEach items="${accounts}" var="acc">
                                                <option value="${acc.accountId}">
                                                    ${acc.accountNumber} - ${acc.accountType} (Available: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Customer ID (if applicable):</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="customerId" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;" value="${customer.customerId}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="mobileNumber" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;" value="${customer.phoneNo}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="emailId" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; outline: none; background: transparent;" value="${customer.email}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="address" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-size: 0.85rem; outline: none; background: transparent; color: #0f172a;" value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Card Details Box -->
                        <div style="margin-bottom: 25px;">
                            <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">ATM/Debit Card Details</h4>
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td style="width: 45%; padding: 5px 0;"><strong>Existing ATM/Debit Card Number (Last 4 Digits):</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" id="renewExistingCardLast4" name="existingCardLast4" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1.05rem; outline: none; background: transparent; color: #0f172a;" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Card Expiry Date:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" id="renewCardExpiry" name="cardExpiry" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; outline: none; background: transparent; color: #0f172a;" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Card Network:</strong></td>
                                    <td style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                            <input type="radio" name="cardProvider" id="renewProviderRuPay" value="rupay" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> RuPay
                                        </label>
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                            <input type="radio" name="cardProvider" id="renewProviderVisa" value="visa" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> Visa
                                        </label>
                                        <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                            <input type="radio" name="cardProvider" id="renewProviderMastercard" value="mastercard" style="width: 13px; height: 13px; margin: 0; cursor: pointer;"> MasterCard
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Declaration & Request text -->
                        <div style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                            <p style="margin: 0 0 10px;"><strong>Request:</strong> I request the bank to renew and issue a new ATM/Debit Card linked to my account mentioned above. My existing card is approaching expiry/has expired. I kindly request you to process my application and issue a renewed card at the earliest.</p>
                            <p style="margin: 0;"><strong>Declaration:</strong> I declare that the information provided above is true and correct.</p>
                        </div>
                        
                        <!-- Signatures Row -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                            <div>
                                <span style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;" id="renewFormSignature">${customer.firstName} ${customer.lastName}</span>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer Signature</span>
                            </div>
                            <div style="text-align: right;">
                                <span style="display: block; font-family: monospace; font-size: 0.95rem; font-weight: 600; color: #0f172a; text-transform: uppercase; padding-bottom: 5px;" id="renewFormNameLabel">${customer.firstName} ${customer.lastName}</span>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Name</span>
                            </div>
                        </div>
                        
                        <!-- For Bank Use Only Stamp Card -->
                        <div style="background: rgba(248, 250, 252, 0.9); border: 2px dashed #94a3b8; border-radius: var(--radius-md); padding: 20px; font-size: 0.8rem; color: #475569; font-family: 'Poppins', sans-serif; box-shadow: var(--shadow-sm);">
                            <h5 style="margin: 0 0 12px; font-size: 0.85rem; font-weight: 800; text-transform: uppercase; color: #334155; text-align: center; border-bottom: 1px dashed #cbd5e1; padding-bottom: 8px; letter-spacing: 0.75px;">For Bank Use Only</h5>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px 20px;">
                                <div><strong>Application Received On:</strong> <span id="renewFormReceivedOnStr" style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px;">____ / ____ / ______</span></div>
                                <div><strong>Verified By:</strong> <span style="border-bottom: 1px solid #64748b; font-weight: 700; font-family: monospace; padding: 0 4px; color: #1e3a8a; text-transform: uppercase;">SYSTEM_AUTOMATION</span></div>
                                <div><strong>Renewal Request Processed:</strong> <span style="display: inline-flex; align-items: center; gap: 4px; margin-left: 5px;"><input type="checkbox" checked disabled style="width: 11px; height: 11px; margin: 0;"> Yes</span> <span style="display: inline-flex; align-items: center; gap: 4px; margin-left: 10px;"><input type="checkbox" disabled style="width: 11px; height: 11px; margin: 0;"> No</span></div>
                                <div><strong>New Card Issued On:</strong> <span style="border-bottom: 1px solid #64748b; font-weight: 600; font-family: monospace; padding: 0 4px; color: #047857;">AUTO_APPROVE</span></div>
                            </div>
                            <div style="text-align: right; margin-top: 15px;">
                                <div style="display: inline-block; text-align: center;">
                                    <span style="display: block; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.25rem; color: #1e3a8a; font-weight: 700;">VertexGalaxyBank</span>
                                    <span style="border-top: 1px solid #94a3b8; display: inline-block; width: 170px; text-align: center; font-size: 0.7rem; font-weight: 700; padding-top: 2px;">Authorized Signature & Seal</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; background: #10b981; border-color: #10b981; font-weight: 600; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-family: 'Poppins', sans-serif;"><i class="bx bx-check-shield"></i> Confirm and Submit Renewal Form</button>
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
        window.onclick = function(event) {
            const applyModal = document.getElementById('applyModal');
            const duesModal = document.getElementById('payDuesModal');
            const renewModal = document.getElementById('renewModal');
            if (event.target === applyModal) {
                closeApplyModal();
            }
            if (event.target === duesModal) {
                closePayDuesModal();
            }
            if (event.target === renewModal) {
                closeRenewModal();
            }
        }
    </script>
</body>
</html>
