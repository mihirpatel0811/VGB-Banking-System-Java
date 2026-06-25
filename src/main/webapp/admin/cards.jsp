<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage ATM Cards</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(99, 102, 241, 0.08);
            --card-glow: rgba(99, 102, 241, 0.04);
            --panel-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --accent-gradient: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
        }

        body {
            background-color: #f6f8fc !important;
            color: var(--gray-700) !important;
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        body.dark-mode {
            --glass-bg: rgba(30, 41, 59, 0.45);
            --glass-border: rgba(255, 255, 255, 0.08);
            --card-glow: rgba(99, 102, 241, 0.1);
            --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            background-color: #0f172a !important;
        }

        /* Preloader override */
        .preloader {
            background: #f6f8fc;
            z-index: 9999;
        }
        body.dark-mode .preloader {
            background: #0f172a;
        }

        /* Background blur animation cursor glow */
        .cursor-glow {
            position: fixed;
            width: 350px;
            height: 350px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.06) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            z-index: 1;
            transition: left 0.1s ease-out, top 0.1s ease-out;
        }
        body.dark-mode .cursor-glow {
            background: radial-gradient(circle, rgba(99, 102, 241, 0.12) 0%, transparent 70%);
        }

        /* --- STICKY GLASSMORPHIC HEADER --- */
        .header {
            background: rgba(255, 255, 255, 0.6) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border-bottom: 1px solid var(--glass-border) !important;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.02);
            padding: 20px 40px;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            z-index: 1000;
        }
        
        body.dark-mode .header {
            background: rgba(15, 23, 42, 0.6) !important;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
        }

        .header.scrolled {
            background: rgba(255, 255, 255, 0.8) !important;
            padding: 14px 40px;
            border-bottom-color: rgba(99, 102, 241, 0.15) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
        }
        
        body.dark-mode .header.scrolled {
            background: rgba(15, 23, 42, 0.8) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .mobile-nav-toggle {
            display: none !important;
        }
        body.dark-mode .mobile-nav-toggle {
            color: var(--gray-300) !important;
        }

        /* --- STYLISH SIDEBAR --- */
        .sidebar {
            width: 280px;
            background: rgba(255, 255, 255, 0.45) !important;
            backdrop-filter: blur(25px) saturate(180%) !important;
            -webkit-backdrop-filter: blur(25px) saturate(180%) !important;
            border-right: 1px solid var(--glass-border) !important;
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
        
        body.dark-mode .sidebar {
            background: rgba(15, 23, 42, 0.45) !important;
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
        
        body.dark-mode .sidebar-menu a:hover {
            background: rgba(255, 255, 255, 0.03);
            color: var(--white) !important;
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
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.35);
        }

        /* --- MAIN CONTENT AREA --- */
        .main-content {
            margin-left: 280px;
            padding: 120px 40px 40px;
            min-height: 100vh;
            background: transparent;
            z-index: 10;
            position: relative;
        }

        /* --- PREMIUM GLASS CARDS --- */
        .glass-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }
        
        body.dark-mode .glass-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
            box-shadow: var(--panel-shadow);
        }

        .glass-card:hover {
            border-color: rgba(99, 102, 241, 0.2) !important;
        }

        /* --- KPI STAT CARDS --- */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--glass-bg) !important;
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.5) !important;
            border-radius: var(--radius-lg);
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: var(--panel-shadow), inset 0 0 2px 1px rgba(255, 255, 255, 0.7);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
        }
        
        body.dark-mode .stat-card {
            border: 1px solid rgba(255, 255, 255, 0.06) !important;
            box-shadow: var(--panel-shadow);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: rgba(99, 102, 241, 0.25) !important;
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.1);
        }

        .stat-icon {
            width: 54px;
            height: 54px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            flex-shrink: 0;
            transition: transform 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .sparkline-decor {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3.5px;
        }

        .pulse-dot {
            width: 8px;
            height: 8px;
            background: #f59e0b;
            border-radius: 50%;
            display: inline-block;
            box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7);
            animation: pulse-orange 1.6s infinite;
            margin-left: 6px;
        }
        @keyframes pulse-orange {
            0% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7);
            }
            70% {
                transform: scale(1);
                box-shadow: 0 0 0 6px rgba(245, 158, 11, 0);
            }
            100% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(245, 158, 11, 0);
            }
        }

        /* --- PREMIUM MODERN TABLES --- */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
            border: 1px solid var(--glass-border);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            padding: 16px 20px;
            color: var(--gray-500);
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
            white-space: nowrap;
            background: rgba(99, 102, 241, 0.02);
        }

        body.dark-mode th {
            color: var(--gray-400);
            background: rgba(15, 23, 42, 0.15);
        }

        td {
            padding: 16px 20px;
            font-size: 0.875rem;
            color: var(--gray-700);
            border-bottom: 1px solid rgba(99, 102, 241, 0.05);
            vertical-align: middle;
            white-space: nowrap;
            transition: background-color 0.2s ease;
        }

        body.dark-mode td {
            color: var(--gray-300);
            border-bottom-color: rgba(255, 255, 255, 0.04);
        }

        tr {
            transition: background 0.2s ease;
        }

        tr:hover td {
            background: rgba(99, 102, 241, 0.02);
        }

        body.dark-mode tr:hover td {
            background: rgba(255, 255, 255, 0.01);
        }

        /* --- SEARCH AND FILTER SYSTEM --- */
        .search-filter-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-input-group {
            position: relative;
            flex-grow: 1;
            max-width: 400px;
            min-width: 250px;
        }

        .search-input-group .search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2rem;
            color: var(--gray-400);
            pointer-events: none;
        }

        .search-input-group input {
            width: 100%;
            padding: 10px 15px 10px 42px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            font-size: 0.85rem;
            outline: none;
            color: var(--gray-800);
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }

        body.dark-mode .search-input-group input {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }

        .search-input-group input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }

        .filter-select-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .filter-select-group select {
            padding: 10px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            background: white;
            font-size: 0.85rem;
            outline: none;
            color: var(--gray-700);
            transition: all 0.3s ease;
            cursor: pointer;
            min-width: 150px;
            box-shadow: var(--shadow-sm);
        }

        body.dark-mode .filter-select-group select {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }

        .filter-select-group select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }

        /* --- MONOSPACE ID BADGE --- */
        .badge-id {
            font-family: 'Share Tech Mono', Courier, monospace;
            font-weight: 700;
            font-size: 0.85rem;
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500);
            padding: 5px 12px;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(99, 102, 241, 0.08);
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        body.dark-mode .badge-id {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-300);
        }

        /* --- SYSTEM LIMIT METRIC BADGE --- */
        .badge-limit {
            font-family: 'Share Tech Mono', monospace;
            font-weight: 700;
            font-size: 0.85rem;
            color: var(--accent-emerald);
        }

        /* --- CUSTOM ACTION BUTTONS --- */
        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 8px 14px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: all var(--transition-fast);
            text-decoration: none;
            width: 95px;
            min-width: 95px;
            border: 1px solid transparent;
            white-space: nowrap;
        }

        .btn-action-view {
            border-color: rgba(99, 102, 241, 0.3);
            background: rgba(99, 102, 241, 0.05);
            color: var(--primary-500) !important;
        }
        .btn-action-view:hover {
            background: var(--primary-500);
            color: white !important;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
            transform: translateY(-1px);
        }

        .btn-action-approve {
            border-color: rgba(16, 185, 129, 0.3);
            background: rgba(16, 185, 129, 0.05);
            color: var(--accent-emerald) !important;
        }
        .btn-action-approve:hover {
            background: var(--accent-emerald);
            color: white !important;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);
            transform: translateY(-1px);
        }

        .btn-action-reject {
            border-color: rgba(239, 68, 68, 0.3);
            background: rgba(239, 68, 68, 0.05);
            color: #ef4444 !important;
        }
        .btn-action-reject:hover {
            background: #ef4444;
            color: white !important;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
            transform: translateY(-1px);
        }

        /* --- PREMIUM 3D ATM CARDS --- */
        .vgb-atm-card {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1), box-shadow 0.3s ease;
            border-radius: 20px;
            cursor: pointer;
        }
        .vgb-atm-card.flipped {
            transform: rotateY(180deg);
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
            box-sizing: border-box;
            overflow: hidden;
        }
        .vgb-atm-card .card-front {
            z-index: 2;
        }
        .vgb-atm-card .card-back {
            transform: rotateY(180deg);
            z-index: 1;
            background: #080b11;
        }

        .vgb-atm-card .glass-reflection {
            position: absolute;
            inset: 0;
            background: linear-gradient(110deg, rgba(255, 255, 255, 0.12) 15%, rgba(255, 255, 255, 0.03) 25%, transparent 60%);
            border-radius: inherit;
            pointer-events: none;
            z-index: 4;
        }

        /* Gradient presets */
        .vgb-atm-card.debit {
            background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%) !important;
            box-shadow: 0 12px 25px rgba(30, 58, 138, 0.25) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
        }
        .vgb-atm-card.debit.premium-tier {
            background: linear-gradient(135deg, #475569 0%, #0f172a 100%) !important;
            box-shadow: 0 12px 25px rgba(15, 23, 42, 0.3) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.3) !important;
        }
        .vgb-atm-card.credit {
            background: linear-gradient(135deg, #7c2d12 0%, #1c1917 100%) !important;
            box-shadow: 0 12px 25px rgba(124, 45, 18, 0.25) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
        }
        .vgb-atm-card.credit.premium-tier {
            background: radial-gradient(circle at 75% 25%, #1e1b4b 0%, #030712 100%) !important;
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.45) !important;
            border: 1.5px solid rgba(139, 92, 246, 0.3) !important;
        }
        .vgb-atm-card.inactive-card {
            background: linear-gradient(135deg, #374151 0%, #111827 100%) !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.08) !important;
            opacity: 0.75;
        }

        /* 3D orbits for premium versions */
        .vgb-atm-card.premium-tier .card-front::before {
            content: '';
            position: absolute;
            top: -10%;
            left: 20%;
            width: 90%;
            height: 90%;
            border-radius: 50%;
            border: 1.5px dashed rgba(255, 255, 255, 0.1);
            pointer-events: none;
            z-index: 1;
            transform: rotate(-15deg) scaleY(0.4);
        }

        /* Layout overlays */
        .vgb-atm-card.credit .debit-front-layout,
        .vgb-atm-card.credit .debit-back-layout {
            display: none !important;
        }
        .vgb-atm-card.debit .credit-front-layout,
        .vgb-atm-card.debit .credit-back-layout {
            display: none !important;
        }

        .debit-front-layout, .credit-front-layout {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
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
            color: rgba(255, 255, 255, 0.8);
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }
        .contactless-icon-debit {
            font-size: 1.25rem;
            transform: rotate(90deg);
            opacity: 0.8;
            color: #ffffff;
            margin-top: 4px;
        }

        /* SIM Chip */
        .metallic-chip {
            width: 44px;
            height: 32px;
            background: linear-gradient(135deg, #ffd700 0%, #c5a059 40%, #ffd700 70%, #9a7628 100%);
            border-radius: 6px;
            position: relative;
            box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.4), 0 2px 4px rgba(0,0,0,0.2);
            border: 1px solid rgba(255,255,255,0.15);
        }
        .metallic-chip::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: rgba(0, 0, 0, 0.2);
        }
        .metallic-chip::after {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 50%;
            width: 1px;
            background: rgba(0, 0, 0, 0.2);
        }

        .card-number-display {
            font-family: 'Share Tech Mono', monospace;
            font-size: 1.25rem;
            letter-spacing: 2px;
            font-weight: 600;
            color: #ffffff;
            text-shadow: 0 1.5px 3px rgba(0, 0, 0, 0.5);
            margin: 15px 0 5px;
        }

        .debit-expiry-row {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: -3px;
        }
        .debit-expiry-row .expiry-label {
            font-size: 0.38rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.75;
            color: #ffffff;
            line-height: 1.1;
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
        }
        .holder-name {
            font-size: 0.85rem;
            font-weight: 500;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #ffffff;
            font-family: 'Share Tech Mono', monospace;
        }

        /* Provider Brand logos styling */
        .brand-visa-secure {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            line-height: 0.95;
        }
        .brand-visa-secure .visa-secure-text {
            font-family: 'Poppins', sans-serif;
            font-size: 1.35rem;
            font-weight: 800;
            font-style: italic;
            color: #ffffff;
            letter-spacing: 0.5px;
        }
        .brand-visa-secure .visa-secure-sub {
            font-size: 0.42rem;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.8);
            letter-spacing: 1.2px;
            margin-top: -2px;
        }

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
        }

        .brand-rupay-global {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            line-height: 0.95;
        }
        .brand-rupay-global .rupay-global-text {
            font-family: 'Poppins', sans-serif;
            font-size: 1.15rem;
            font-weight: 800;
            font-style: italic;
            color: #ffffff;
        }
        .brand-rupay-global .rupay-global-text .arrow-accent {
            color: #f59e0b;
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

        /* Back face details */
        .debit-back-layout, .credit-back-layout {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-sizing: border-box;
        }

        .card-back-magnetic-strip {
            height: 38px;
            background: #000000;
            margin: 0 -25px;
            z-index: 5;
        }

        .debit-back-info-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.45rem;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 5px;
            z-index: 5;
            padding: 0 5px;
        }

        .debit-back-grid {
            display: grid;
            grid-template-columns: 1.25fr 1fr;
            gap: 12px;
            align-items: flex-start;
            margin-top: 10px;
            flex-grow: 1;
            z-index: 5;
        }

        .debit-grid-left {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .debit-signature-area {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .debit-sig-label {
            font-size: 0.38rem;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.5);
            letter-spacing: 0.5px;
            text-transform: uppercase;
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
            height: 22px;
            width: 38px;
            border-radius: 3px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #cbd5e1;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
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
            gap: 8px;
            padding-left: 5px;
            border-left: 1px solid rgba(255, 255, 255, 0.1);
        }

        .debit-back-vgb-header {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .logo-text-stacked .text-top {
            font-size: 0.5rem;
            font-weight: 800;
            letter-spacing: 1px;
            color: #ffffff;
        }
        .logo-text-stacked .text-bottom {
            font-size: 0.35rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            color: rgba(255, 255, 255, 0.7);
        }

        .debit-property-disclaimer {
            font-size: 0.4rem;
            line-height: 1.3;
            color: rgba(255, 255, 255, 0.6);
            margin: 0;
            padding-top: 2px;
        }

        /* --- DUAL COLUMN SIMULATOR --- */
        .card-customizer-grid {
            display: grid;
            grid-template-columns: minmax(470px, 1.2fr) 1fr;
            gap: 40px;
            align-items: center;
        }
        @media (max-width: 1199px) {
            .card-customizer-grid {
                grid-template-columns: minmax(410px, 1.2fr) 1fr;
                gap: 30px;
            }
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
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.03) 0%, rgba(6, 182, 212, 0.03) 100%);
            border: 1.5px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 40px 15px;
            position: relative;
            min-height: 380px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.03);
            transition: all 0.3s ease;
        }
        body.dark-mode .simulator-display {
            border-color: rgba(255, 255, 255, 0.08);
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.01) 0%, rgba(6, 182, 212, 0.01) 100%);
        }

        .sandbox-card-wrapper {
            position: relative;
            transition: transform 0.1s ease;
            transform-style: preserve-3d;
            margin: 0 auto;
            width: 340px;
            height: 220px;
        }

        .card-3d-scene {
            perspective: 1200px;
            transform-style: preserve-3d;
        }

        /* Interactive card details scaling for dynamic responsiveness */
        @media (min-width: 1200px) {
            .sandbox-card-wrapper {
                width: 450px !important;
                height: 284px !important;
            }
            .sandbox-card-wrapper .card-face {
                padding: 26px 30px !important;
            }
            .sandbox-card-wrapper .logo-text-stacked .text-top {
                font-size: 0.65rem !important;
            }
            .sandbox-card-wrapper .logo-text-stacked .text-bottom {
                font-size: 0.45rem !important;
            }
            .sandbox-card-wrapper .debit-label-txt {
                font-size: 0.85rem !important;
                letter-spacing: 1.8px !important;
            }
            .sandbox-card-wrapper .contactless-icon-debit {
                font-size: 1.6rem !important;
                margin-top: 6px !important;
            }
            .sandbox-card-wrapper .metallic-chip {
                width: 54px !important;
                height: 38px !important;
                border-radius: 8px !important;
            }
            .sandbox-card-wrapper .card-number-display {
                font-size: 1.55rem !important;
                letter-spacing: 3px !important;
                margin: 22px 0 10px !important;
            }
            .sandbox-card-wrapper .debit-expiry-row .expiry-label {
                font-size: 0.48rem !important;
            }
            .sandbox-card-wrapper .debit-expiry-row .expiry-value {
                font-size: 1.05rem !important;
            }
            .sandbox-card-wrapper .holder-name {
                font-size: 1.05rem !important;
            }
            .sandbox-card-wrapper .brand-visa-secure .visa-secure-text {
                font-size: 1.65rem !important;
            }
            .sandbox-card-wrapper .brand-visa-secure .visa-secure-sub {
                font-size: 0.55rem !important;
            }
            .sandbox-card-wrapper .brand-mastercard-id .mc-circles-id {
                width: 38px !important;
                height: 24px !important;
            }
            .sandbox-card-wrapper .brand-mastercard-id .mc-circles-id .circle-id {
                width: 22px !important;
                height: 22px !important;
            }
            .sandbox-card-wrapper .brand-mastercard-id .mc-id-text {
                font-size: 0.55rem !important;
            }
            .sandbox-card-wrapper .brand-rupay-global .rupay-global-text {
                font-size: 1.45rem !important;
            }
            .sandbox-card-wrapper .brand-rupay-global .rupay-global-sub {
                font-size: 0.52rem !important;
            }
            .sandbox-card-wrapper .card-back-magnetic-strip {
                height: 48px !important;
            }
            .sandbox-card-wrapper .debit-back-info-bar {
                font-size: 0.55rem !important;
                margin-top: 8px !important;
            }
            .sandbox-card-wrapper .debit-sig-label {
                font-size: 0.52rem !important;
            }
            .sandbox-card-wrapper .debit-sig-strip-wrapper {
                height: 36px !important;
            }
            .sandbox-card-wrapper .debit-sig-cvv-box {
                height: 30px !important;
                width: 50px !important;
            }
            .sandbox-card-wrapper .debit-sig-cvv-box .cvv-val {
                font-size: 0.95rem !important;
            }
            .sandbox-card-wrapper .debit-property-disclaimer {
                font-size: 0.52rem !important;
                line-height: 1.4 !important;
            }
            .sandbox-card-wrapper .debit-back-network-logo {
                height: 36px !important;
            }
        }

        @media (min-width: 768px) and (max-width: 1199px) {
            .sandbox-card-wrapper {
                width: 390px !important;
                height: 246px !important;
            }
            .sandbox-card-wrapper .card-face {
                padding: 24px 28px !important;
            }
            .sandbox-card-wrapper .debit-label-txt {
                font-size: 0.75rem !important;
            }
            .sandbox-card-wrapper .contactless-icon-debit {
                font-size: 1.45rem !important;
            }
            .sandbox-card-wrapper .metallic-chip {
                width: 46px !important;
                height: 34px !important;
            }
            .sandbox-card-wrapper .card-number-display {
                font-size: 1.35rem !important;
                letter-spacing: 2.5px !important;
            }
            .sandbox-card-wrapper .debit-expiry-row .expiry-value {
                font-size: 0.9rem !important;
            }
            .sandbox-card-wrapper .holder-name {
                font-size: 0.9rem !important;
            }
            .sandbox-card-wrapper .brand-visa-secure .visa-secure-text {
                font-size: 1.4rem !important;
            }
            .sandbox-card-wrapper .brand-mastercard-id .mc-circles-id {
                width: 32px !important;
                height: 20px !important;
            }
            .sandbox-card-wrapper .brand-rupay-global .rupay-global-text {
                font-size: 1.25rem !important;
            }
            .sandbox-card-wrapper .card-back-magnetic-strip {
                height: 40px !important;
            }
            .sandbox-card-wrapper .debit-sig-strip-wrapper {
                height: 32px !important;
            }
            .sandbox-card-wrapper .debit-sig-cvv-box {
                height: 26px !important;
                width: 44px !important;
            }
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
            color: var(--gray-500);
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
        
        body.dark-mode .control-label {
            color: var(--gray-400);
        }
        body.dark-mode .control-input, body.dark-mode .control-select {
            background: rgba(15, 23, 42, 0.45);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }

        .control-input:focus, .control-select:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
        }
        body.dark-mode .control-input:focus, body.dark-mode .control-select:focus {
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.25);
        }
        .control-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        /* --- GLASSMORPHIC MODAL --- */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1050;
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

        .modal-card-spec {
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md);
            padding: 16px;
            font-size: 0.85rem;
            margin-top: 15px;
        }
        body.dark-mode .modal-card-spec {
            background: rgba(15, 23, 42, 0.3);
            border-color: rgba(255, 255, 255, 0.08);
        }

        /* --- RESPONSIVE SIDEBAR MOBILE --- */
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

    <!-- Sticky Header -->
    <header class="header scrolled">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
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
            <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/passbook?action=list"><i class="bx bx-book-open"></i> Passbook Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
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
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer debit/credit card applications, verify system card limits, and process card approvals.</p>
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
            <c:set var="pendingCount" value="0" />
            <c:set var="activeCount" value="0" />
            <c:set var="closedCount" value="0" />
            
            <c:forEach var="card" items="${cards}">
                <c:choose>
                    <c:when test="${card.status eq 'pending'}">
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:when>
                    <c:when test="${card.status eq 'active'}">
                        <c:set var="activeCount" value="${activeCount + 1}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="closedCount" value="${closedCount + 1}" />
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="stat-grid">
                <div class="stat-card" style="border-left: 4px solid var(--primary-500);">
                    <div class="sparkline-decor" style="background: var(--primary-gradient);"></div>
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-credit-card"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Total Requests</span>
                        <h3 style="font-size: 1.6rem; font-weight: 800; color: var(--gray-800); margin-top: 2px;">${cards.size()}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid #fbbf24;">
                    <div class="sparkline-decor" style="background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);"></div>
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #fbbf24;">
                        <i class="bx bx-time-five"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase; display: flex; align-items: center;">
                            Pending Review <span class="pulse-dot"></span>
                        </span>
                        <h3 style="font-size: 1.6rem; font-weight: 800; color: var(--gray-800); margin-top: 2px;">${pendingCount}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--accent-emerald);">
                    <div class="sparkline-decor" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);"></div>
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                        <i class="bx bx-badge-check"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Approved Active</span>
                        <h3 style="font-size: 1.6rem; font-weight: 800; color: var(--gray-800); margin-top: 2px;">${activeCount}</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid #ef4444;">
                    <div class="sparkline-decor" style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);"></div>
                    <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                        <i class="bx bx-block"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.8rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Revoked / Closed</span>
                        <h3 style="font-size: 1.6rem; font-weight: 800; color: var(--gray-800); margin-top: 2px;">${closedCount}</h3>
                    </div>
                </div>
            </div>

            <!-- Premium ATM Card Customizer & Live Simulator Sandbox -->
            <div class="glass-card" style="border-color: rgba(99, 102, 241, 0.2);">
                <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--gray-800); margin-bottom: 8px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-shape-polygon" style="color: var(--primary-500); font-size: 1.6rem;"></i> 
                    Flagship VGB Premium 3D ATM Card Showcase & Live Simulator
                </h3>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-bottom: 25px;">
                    Explore interactive 3D tilt tracking. Hover over the card to tilt, click to flip, and customize elements live using controls.
                </p>
                
                <div class="card-customizer-grid">
                    <!-- Left Column: The 3D Demo Card Display -->
                    <div class="simulator-display">
                        <div style="position: absolute; top: 15px; left: 15px; pointer-events: none;">
                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 4px;">
                                <i class="bx bx-expand-alt" style="font-size: 0.9rem;"></i> 3D Sandbox
                            </span>
                        </div>
                        
                        <!-- Flippable Card Scene -->
                        <div class="card-3d-scene sandbox-card-wrapper" id="demo3DCardTiltWrapper">
                            <div id="demo3DCard" class="vgb-atm-card debit interactive" onclick="flipDemoCard()">
                                <!-- Front Face -->
                                <div class="card-face card-front">
                                    <div class="glass-reflection"></div>
                                    <div class="card-tier-indicator" id="demoTierIndicator"></div>
                                    
                                    <!-- Bank Name Header -->
                                    <div class="card-bank-header" style="display: flex; align-items: center; gap: 8px;">
                                        <div class="card-logo-v">
                                            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 22px; height: 22px; object-fit: contain; filter: drop-shadow(0 1px 2px rgba(0,0,0,0.35));">
                                        </div>
                                        <div class="card-bank-name-stack">
                                            <span class="bank-title" style="font-size: 0.8rem; font-weight: 800; letter-spacing: 1.5px; color: #ffffff;">VERTEX</span>
                                            <span class="bank-subtitle" style="font-size: 0.45rem; font-weight: 600; letter-spacing: 1px; color: rgba(255, 255, 255, 0.7);">GALAXY BANK</span>
                                        </div>
                                    </div>

                                    <!-- DEBIT FRONT LAYOUT -->
                                    <div class="debit-front-layout">
                                        <div class="debit-header-right">
                                            <span class="debit-label-txt">DEBIT</span>
                                            <i class="bx bx-wifi contactless-icon-debit"></i>
                                        </div>

                                        <div style="margin-top: 15px;">
                                            <div class="metallic-chip"></div>
                                        </div>

                                        <div class="card-number-display" id="demoDebitNumber">4589  7321  6048  2190</div>

                                        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                            <div class="debit-expiry-row">
                                                <span class="expiry-label">VALID<br>THRU</span>
                                                <span class="expiry-value" id="demoDebitExpiry">12/30</span>
                                            </div>
                                            <div class="holder-name" id="demoDebitHolder">MIHIR BHAYANI</div>
                                            <div class="debit-brand-logo-container" id="demoDebitBrandLogo"></div>
                                        </div>
                                    </div>

                                    <!-- CREDIT FRONT LAYOUT -->
                                    <div class="credit-front-layout">
                                        <div class="debit-header-right">
                                            <span class="debit-label-txt">CREDIT</span>
                                            <i class="bx bx-wifi contactless-icon-debit"></i>
                                        </div>

                                        <div style="margin-top: 15px;">
                                            <div class="metallic-chip"></div>
                                        </div>

                                        <div class="card-number-display" id="demoNumber">4589  7321  6048  2190</div>

                                        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                            <div class="debit-expiry-row">
                                                <span class="expiry-label">VALID<br>THRU</span>
                                                <span class="expiry-value" id="demoExpiry">12/30</span>
                                            </div>
                                            <div class="holder-name" id="demoHolder">MIHIR BHAYANI</div>
                                            <div class="debit-brand-logo-container" id="demoBrandLogo"></div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Back Face -->
                                <div class="card-face card-back">
                                    <div class="glass-reflection"></div>
                                    
                                    <!-- DEBIT BACK LAYOUT -->
                                    <div class="debit-back-layout">
                                        <div class="card-back-magnetic-strip"></div>
                                        
                                        <div class="debit-back-info-bar">
                                            <span>www.vertexgalaxybank.com</span>
                                            <span>For service, call +1 234 567 8900</span>
                                        </div>
                                        
                                        <div class="debit-back-grid">
                                            <div class="debit-grid-left">
                                                <div class="debit-signature-area">
                                                    <span class="debit-sig-label">AUTHORIZED SIGNATURE</span>
                                                    <div class="debit-sig-strip-wrapper">
                                                        <div class="debit-signature-pattern"></div>
                                                        <div class="debit-sig-cvv-box">
                                                            <span class="cvv-val" id="demoDebitCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV" style="cursor: pointer;">•••</span>
                                                        </div>
                                                    </div>
                                                    <span class="debit-sig-label">NOT VALID UNLESS SIGNED</span>
                                                </div>
                                                <div class="debit-back-network-logo" id="demoDebitBackEmblem"></div>
                                            </div>
                                            
                                            <div class="debit-grid-right">
                                                <div class="debit-back-vgb-header">
                                                    <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 16px; height: 16px; object-fit: contain;">
                                                    <div class="logo-text-stacked">
                                                        <span class="text-top">VERTEX</span>
                                                        <span class="text-bottom">GALAXY BANK</span>
                                                    </div>
                                                </div>
                                                <p class="debit-property-disclaimer">
                                                    This card is corporate property of Vertex Galaxy Bank.
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- CREDIT BACK LAYOUT -->
                                    <div class="credit-back-layout">
                                        <div class="card-back-magnetic-strip"></div>
                                        
                                        <div class="debit-back-info-bar">
                                            <span>www.vertexgalaxybank.com</span>
                                            <span>For service, call +1 234 567 8900</span>
                                        </div>
                                        
                                        <div class="debit-back-grid">
                                            <div class="debit-grid-left">
                                                <div class="debit-signature-area">
                                                    <span class="debit-sig-label">AUTHORIZED SIGNATURE</span>
                                                    <div class="debit-sig-strip-wrapper">
                                                        <div class="debit-signature-pattern"></div>
                                                        <div class="debit-sig-cvv-box">
                                                            <span class="cvv-val" id="demoCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV" style="cursor: pointer;">•••</span>
                                                        </div>
                                                    </div>
                                                    <span class="debit-sig-label">NOT VALID UNLESS SIGNED</span>
                                                </div>
                                                <div class="debit-back-network-logo" id="demoBackEmblem"></div>
                                            </div>
                                            
                                            <div class="debit-grid-right">
                                                <div class="debit-back-vgb-header">
                                                    <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 16px; height: 16px; object-fit: contain;">
                                                    <div class="logo-text-stacked">
                                                        <span class="text-top">VERTEX</span>
                                                        <span class="text-bottom">GALAXY BANK</span>
                                                    </div>
                                                </div>
                                                <p class="debit-property-disclaimer">
                                                    This card is corporate property of Vertex Galaxy Bank.
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div style="margin-top: 25px; display: flex; gap: 15px; font-size: 0.75rem; color: var(--gray-400); align-items: center;">
                            <span><i class="bx bx-mouse" style="color: var(--primary-500);"></i> Hover to Tilt</span>
                            <span>|</span>
                            <span><i class="bx bx-pointer" style="color: var(--primary-500);"></i> Click Card to Flip</span>
                        </div>
                    </div>
                    
                    <!-- Right Column: Customizer Controls -->
                    <div class="simulator-controls">
                        <div class="control-row">
                            <div class="control-group">
                                <label class="control-label">Card Tier</label>
                                <select id="ctrlCardType" class="control-select" onchange="syncDemoCard()">
                                    <option value="debit">Sapphire Debit</option>
                                    <option value="debit-premium">Platinum Debit (Premium)</option>
                                    <option value="credit">Royale Credit</option>
                                    <option value="credit-premium">Infinite Credit (Premium)</option>
                                    <option value="inactive">Blocked / Inactive</option>
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
                            <input type="text" id="ctrlHolderName" class="control-input" value="MIHIR BHAYANI" placeholder="Card Holder Name" oninput="syncDemoCard()" style="text-transform: uppercase;">
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
                            <button type="button" class="btn btn-secondary" onclick="randomizeDemoCard()" style="padding: 11px; width: 100%; font-size: 0.85rem; font-weight: 600; margin-top: 0; display: inline-flex; align-items: center; justify-content: center; gap: 6px; border-color: var(--primary-500); color: var(--primary-500); background: transparent;">
                                <i class="bx bx-shuffle"></i> Randomize
                            </button>
                            <button type="button" class="btn btn-primary" onclick="flipDemoCard()" style="padding: 11px; width: 100%; font-size: 0.85rem; font-weight: 600; margin-top: 0; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
                                <i class="bx bx-rotate-right"></i> Flip Card
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table 1: Pending Card Approvals -->
            <div class="glass-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-hourglass" style="color: #fbbf24;"></i> Pending Card Applications Awaiting Review
                </h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Card Type</th>
                                <th>Provider</th>
                                <th>Holder Name</th>
                                <th>Linked Account</th>
                                <th>Fee Paid</th>
                                <th>Applied Date</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasPending" value="false" />
                            <c:forEach var="card" items="${cards}">
                                <c:if test="${card.status eq 'pending'}">
                                    <c:set var="hasPending" value="true" />
                                    <fmt:formatDate var="formattedAppliedDate" value="${card.createdAt}" pattern="MM/yy" />
                                    <tr>
                                        <td style="text-transform: capitalize; font-weight: 600;">
                                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 10px; border-radius: var(--radius-sm); font-size: 0.75rem;">${card.cardType}</span>
                                        </td>
                                        <td style="text-transform: uppercase; font-weight: 600; color: var(--gray-600);">${card.cardProvider}</td>
                                        <td style="font-weight: 500;">${card.cardHolderName}</td>
                                        <td><span class="badge-id">${card.accountNumber}</span></td>
                                        <td style="font-weight: 700; color: var(--accent-emerald);">₹ ${card.cardFee}</td>
                                        <td><fmt:formatDate value="${card.createdAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td style="text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center;">
                                            <button type="button" class="btn-action btn-action-view" onclick="open3DCardPreview('${card.cardNumber}', '${card.cardHolderName}', '${card.cardType}', '${card.cardProvider}', '${card.cvv}', '${formattedAppliedDate}', '${card.status}', '${card.dailyLimit}')">
                                                <i class="bx bx-show"></i> View 3D
                                            </button>
                                            <a href="${pageContext.request.contextPath}/card?action=approve&id=${card.cardId}" class="btn-action btn-action-approve">
                                                <i class="bx bx-check"></i> Approve
                                            </a>
                                            <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn-action btn-action-reject" onclick="return confirm('Reject and permanently close this card application?');">
                                                <i class="bx bx-x"></i> Reject
                                            </a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasPending}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: var(--gray-400); font-weight: 500;">
                                        <div style="display: flex; flex-direction: column; align-items: center; gap: 10px;">
                                            <i class="bx bx-badge-check" style="font-size: 2.2rem; color: var(--accent-emerald);"></i>
                                            <span>No pending ATM card applications awaiting review.</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Table 2: All System Cards (Debit & Credit) -->
            <div class="glass-card">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin: 0;">
                        <i class="bx bx-credit-card-front" style="color: var(--primary-500);"></i> All System Issued Cards Directory
                    </h3>
                </div>

                <!-- Client-side real-time filter controls -->
                <div class="search-filter-wrapper">
                    <div class="search-input-group">
                        <i class="bx bx-search search-icon"></i>
                        <input type="text" id="directorySearchInput" onkeyup="filterDirectoryTable()" placeholder="Search by card number, holder name...">
                    </div>
                    <div class="filter-select-group">
                        <select id="directoryTypeFilter" onchange="filterDirectoryTable()">
                            <option value="">All Card Types</option>
                            <option value="debit">Debit Cards</option>
                            <option value="credit">Credit Cards</option>
                        </select>
                        <select id="directoryStatusFilter" onchange="filterDirectoryTable()">
                            <option value="">All Statuses</option>
                            <option value="active">Active</option>
                            <option value="pending">Pending</option>
                            <option value="expired">Expired</option>
                            <option value="closed">Closed</option>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Sr No.</th>
                                <th>Card Number</th>
                                <th>Holder Name</th>
                                <th>Card Type</th>
                                <th>Provider</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="directoryTableBody">
                            <c:choose>
                                <c:when test="${not empty cards}">
                                    <c:forEach var="card" items="${cards}" varStatus="status">
                                        <fmt:formatDate var="formattedExpiryDate" value="${card.expiryDate}" pattern="MM/yy" />
                                        <tr>
                                            <td style="font-weight: 600; color: var(--gray-500);">${status.count}</td>
                                            <td><span class="badge-id">${card.cardNumber}</span></td>
                                            <td style="font-weight: 500;">${card.cardHolderName}</td>
                                            <td style="text-transform: capitalize; font-weight: 600;">${card.cardType}</td>
                                            <td style="text-transform: uppercase; font-weight: 500; color: var(--gray-600);">${card.cardProvider}</td>
                                            <td><fmt:formatDate value="${card.expiryDate}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${card.status eq 'active'}">
                                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Active</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.1); color: #fbbf24; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Pending</span>
                                                    </c:when>
                                                    <c:when test="${card.status eq 'expired'}">
                                                        <span style="background: rgba(239, 68, 68, 0.1); color: #b91c1c; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Expired</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(156, 163, 175, 0.1); color: var(--gray-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">Closed</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                <button type="button" class="btn-action btn-action-view" onclick="open3DCardPreview('${card.cardNumber}', '${card.cardHolderName}', '${card.cardType}', '${card.cardProvider}', '${card.cvv}', '${formattedExpiryDate}', '${card.status}', '${card.dailyLimit}')">
                                                    <i class="bx bx-show"></i> View 3D
                                                </button>
                                                <c:if test="${card.status eq 'active'}">
                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn-action btn-action-reject" onclick="return confirm('Are you sure you want to permanently close card #${card.cardId}?');">
                                                        <i class="bx bx-power-off"></i> Close
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="text-align: center; padding: 30px; color: var(--gray-400); font-weight: 500;">No ATM cards registered in database directory.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer" style="padding: 24px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; <span data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <!-- Premium 3D Card Visualizer Modal -->
    <div id="previewCardModal" class="modal" onclick="close3DCardPreviewOnClickOutside(event)">
        <div class="glass-card" style="background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(25px); border: 1px solid rgba(99, 102, 241, 0.2); width: 100%; max-width: 470px; border-radius: var(--radius-lg); padding: 30px; position: relative; animation: modalFadeIn 0.3s ease-out; box-shadow: var(--shadow-xl); margin-bottom: 0;">
            <span onclick="close3DCardPreview()" style="position: absolute; right: 20px; top: 18px; font-size: 1.6rem; color: var(--gray-400); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-800)'" onmouseout="this.style.color='var(--gray-400)'">&times;</span>
            
            <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--gray-800); margin-bottom: 25px; text-align: center; display: flex; align-items: center; justify-content: center; gap: 8px;">
                <i class="bx bx-credit-card-front" style="color: var(--primary-500); font-size: 1.5rem;"></i> VGB Premium Card Visualizer
            </h3>

            <!-- 3D Flippable Card -->
            <div class="card-3d-scene" id="visualizerCardTiltWrapper" style="perspective: 1000px; width: 100%; display: flex; justify-content: center; margin-bottom: 30px; transform-style: preserve-3d;">
                <div id="visualizerCard" class="vgb-atm-card interactive" style="width: 340px; height: 220px;" onclick="this.classList.toggle('flipped')">
                    <!-- Front Face -->
                    <div class="card-face card-front">
                        <div class="glass-reflection"></div>
                        <div class="card-tier-indicator" id="previewTierIndicator"></div>
                        
                        <!-- Bank Name Header -->
                        <div class="card-bank-header" style="display: flex; align-items: center; gap: 8px;">
                            <div class="card-logo-v">
                                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 22px; height: 22px; object-fit: contain;">
                            </div>
                            <div class="card-bank-name-stack">
                                <span class="bank-title" style="font-size: 0.8rem; font-weight: 800; letter-spacing: 1.5px; color: #ffffff;">VERTEX</span>
                                <span class="bank-subtitle" style="font-size: 0.45rem; font-weight: 600; letter-spacing: 1px; color: rgba(255, 255, 255, 0.7);">GALAXY BANK</span>
                            </div>
                        </div>
                        
                        <!-- DEBIT FRONT LAYOUT -->
                        <div class="debit-front-layout">
                            <div class="debit-header-right">
                                <span class="debit-label-txt">DEBIT</span>
                                <i class="bx bx-wifi contactless-icon-debit"></i>
                            </div>
                            <div style="margin-top: 15px;">
                                <div class="metallic-chip"></div>
                            </div>
                            <div class="card-number-display" id="previewDebitNumber">4589  7321  6048  2190</div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                <div class="debit-expiry-row">
                                    <span class="expiry-label">VALID<br>THRU</span>
                                    <span class="expiry-value" id="previewDebitExpiry">12/29</span>
                                </div>
                                <div class="holder-name" id="previewDebitHolder">John Doe</div>
                                <div class="debit-brand-logo-container" id="previewDebitBrandLogo"></div>
                            </div>
                        </div>

                        <!-- CREDIT FRONT LAYOUT -->
                        <div class="credit-front-layout">
                            <div class="debit-header-right">
                                <span class="debit-label-txt">CREDIT</span>
                                <i class="bx bx-wifi contactless-icon-debit"></i>
                            </div>
                            <div style="margin-top: 15px;">
                                <div class="metallic-chip"></div>
                            </div>
                            <div class="card-number-display" id="previewNumber">4589  7321  6048  2190</div>
                            <div style="display: flex; justify-content: space-between; align-items: flex-end;">
                                <div class="debit-expiry-row">
                                    <span class="expiry-label">VALID<br>THRU</span>
                                    <span class="expiry-value" id="previewExpiry">12/29</span>
                                </div>
                                <div class="holder-name" id="previewHolder">John Doe</div>
                                <div class="debit-brand-logo-container" id="previewBrandLogo"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Back Face -->
                    <div class="card-face card-back">
                        <div class="glass-reflection"></div>
                        
                        <!-- DEBIT BACK LAYOUT -->
                        <div class="debit-back-layout">
                            <div class="card-back-magnetic-strip"></div>
                            <div class="debit-back-info-bar">
                                <span>www.vertexgalaxybank.com</span>
                                <span>For service, call +1 234 567 8900</span>
                            </div>
                            <div class="debit-back-grid">
                                <div class="debit-grid-left">
                                    <div class="debit-signature-area">
                                        <span class="debit-sig-label">AUTHORIZED SIGNATURE</span>
                                        <div class="debit-sig-strip-wrapper">
                                            <div class="debit-signature-pattern"></div>
                                            <div class="debit-sig-cvv-box">
                                                <span class="cvv-val" id="previewDebitCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV" style="cursor: pointer;">•••</span>
                                            </div>
                                        </div>
                                        <span class="debit-sig-label">NOT VALID UNLESS SIGNED</span>
                                    </div>
                                    <div class="debit-back-network-logo" id="previewDebitBackEmblem"></div>
                                </div>
                                <div class="debit-grid-right">
                                    <div class="debit-back-vgb-header">
                                        <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 16px; height: 16px; object-fit: contain;">
                                        <div class="logo-text-stacked">
                                            <span class="text-top">VERTEX</span>
                                            <span class="text-bottom">GALAXY BANK</span>
                                        </div>
                                    </div>
                                    <p class="debit-property-disclaimer">
                                        This card is corporate property of Vertex Galaxy Bank.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- CREDIT BACK LAYOUT -->
                        <div class="credit-back-layout">
                            <div class="card-back-magnetic-strip"></div>
                            <div class="debit-back-info-bar">
                                <span>www.vertexgalaxybank.com</span>
                                <span>For service, call +1 234 567 8900</span>
                            </div>
                            <div class="debit-back-grid">
                                <div class="debit-grid-left">
                                    <div class="debit-signature-area">
                                        <span class="debit-sig-label">AUTHORIZED SIGNATURE</span>
                                        <div class="debit-sig-strip-wrapper">
                                            <div class="debit-signature-pattern"></div>
                                            <div class="debit-sig-cvv-box">
                                                <span class="cvv-val" id="previewCvv" data-cvv="907" onclick="toggle3DCardCvv(event, this)" title="Click to show CVV" style="cursor: pointer;">•••</span>
                                            </div>
                                        </div>
                                        <span class="debit-sig-label">NOT VALID UNLESS SIGNED</span>
                                    </div>
                                    <div class="debit-back-network-logo" id="previewBackEmblem"></div>
                                </div>
                                <div class="debit-grid-right">
                                    <div class="debit-back-vgb-header">
                                        <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 16px; height: 16px; object-fit: contain;">
                                        <div class="logo-text-stacked">
                                            <span class="text-top">VERTEX</span>
                                            <span class="text-bottom">GALAXY BANK</span>
                                        </div>
                                    </div>
                                    <p class="debit-property-disclaimer">
                                        This card is corporate property of Vertex Galaxy Bank.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Spec Sheet -->
            <div class="modal-card-spec">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div>
                        <span style="color: var(--gray-400); display: block; font-size: 0.72rem; text-transform: uppercase; font-weight: 600;">Status</span>
                        <strong id="previewSpecStatus" style="font-size: 0.85rem; text-transform: uppercase; color: var(--accent-emerald);">Active</strong>
                    </div>
                    <div>
                        <span style="color: var(--gray-400); display: block; font-size: 0.72rem; text-transform: uppercase; font-weight: 600;">System Limit</span>
                        <strong id="previewSpecLimit" style="font-size: 0.85rem; color: var(--gray-800);">₹ 50,000.00</strong>
                    </div>
                </div>
            </div>

            <div style="display: flex; justify-content: center; margin-top: 25px;">
                <button type="button" class="btn btn-secondary" onclick="close3DCardPreview()" style="padding: 12px 25px; font-weight: 600; width: 100%; margin-top: 0; box-shadow: var(--shadow-md);">Close Visualizer</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        function updateDynamicCardDetails(cardElementId, tierElId, brandLogoElId, backEmblemElId, cardType, provider, dailyLimit, status = 'active') {
            const card = document.getElementById(cardElementId);
            const tierEl = document.getElementById(tierElId);
            const brandLogoEl = document.getElementById(brandLogoElId);
            const backEmblemEl = document.getElementById(backEmblemElId);
            
            if (!card) return;

            let isDebit = true;
            let isPremium = false;
            let isInactive = status.toLowerCase() !== 'active' && status.toLowerCase() !== 'pending';

            const normType = cardType.toLowerCase();
            if (normType === 'debit') {
                isDebit = true;
                isPremium = dailyLimit > 50000;
            } else if (normType === 'debit-premium' || normType === 'debit_premium') {
                isDebit = true;
                isPremium = true;
            } else if (normType === 'credit') {
                isDebit = false;
                isPremium = dailyLimit > 50000;
            } else if (normType === 'credit-premium' || normType === 'credit_premium') {
                isDebit = false;
                isPremium = true;
            } else if (normType === 'inactive') {
                isInactive = true;
            }

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

            // Set Tier Text
            if (tierEl) {
                if (!isInactive && (isPremium || (!isDebit && provider.toLowerCase() === 'rupay'))) {
                    let tierText = 'PLATINUM';
                    if (!isDebit && provider.toLowerCase() === 'visa') {
                        tierText = 'INFINITE';
                    }
                    tierEl.innerHTML = `<span style="font-size: 0.55rem; font-weight: 800; background: linear-gradient(135deg, #ffd700 0%, #b38728 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">\${tierText}</span>`;
                } else {
                    tierEl.innerHTML = '';
                }
            }

            // Set Front Brand Logo
            if (brandLogoEl) {
                const prov = provider.toLowerCase();
                if (prov === 'visa') {
                    brandLogoEl.innerHTML = `
                        <div class="brand-visa-secure">
                            <span class="visa-secure-text">VISA</span>
                            <span class="visa-secure-sub">SECURE</span>
                        </div>
                    `;
                } else if (prov === 'mastercard') {
                    brandLogoEl.innerHTML = `
                        <div class="brand-mastercard-id">
                            <div class="mc-circles-id">
                                <span class="circle-id red-id"></span>
                                <span class="circle-id orange-id"></span>
                            </div>
                            <span class="mc-id-text">mastercard<br><span style="font-weight:800; text-transform:uppercase; font-size:0.45rem;">ID</span></span>
                        </div>
                    `;
                } else {
                    brandLogoEl.innerHTML = `
                        <div class="brand-rupay-global">
                            <span class="rupay-global-text">RuPay<span class="arrow-accent">▶</span></span>
                            <span class="rupay-global-sub">GLOBAL</span>
                        </div>
                    `;
                }
            }

            // Set Back Emblem
            if (backEmblemEl) {
                const prov = provider.toLowerCase();
                if (prov === 'visa') {
                    backEmblemEl.innerHTML = `
                        <div class="brand-visa-secure" style="transform: scale(0.85); transform-origin: left bottom;">
                            <span class="visa-secure-text">VISA</span>
                            <span class="visa-secure-sub">SECURE</span>
                        </div>
                    `;
                } else if (prov === 'mastercard') {
                    backEmblemEl.innerHTML = `
                        <div class="brand-mastercard-id" style="flex-direction: row; gap: 5px; align-items: center; transform: scale(0.85); transform-origin: left bottom;">
                            <div class="mc-circles-id">
                                <span class="circle-id red-id"></span>
                                <span class="circle-id orange-id"></span>
                            </div>
                            <span class="mc-id-text" style="text-align: left;">mastercard<br><span style="font-weight:800; text-transform:uppercase; font-size:0.45rem;">ID</span></span>
                        </div>
                    `;
                } else {
                    backEmblemEl.innerHTML = `
                        <div class="brand-rupay-global" style="transform: scale(0.85); transform-origin: left bottom;">
                            <span class="rupay-global-text">RuPay<span class="arrow-accent">▶</span></span>
                            <span class="rupay-global-sub">GLOBAL</span>
                        </div>
                    `;
                }
            }

            // Sync debit details
            const isDemo = brandLogoElId && brandLogoElId.startsWith('demo');
            const debitBrandLogoElId = isDemo ? 'demoDebitBrandLogo' : 'previewDebitBrandLogo';
            const debitBackEmblemElId = isDemo ? 'demoDebitBackEmblem' : 'previewDebitBackEmblem';
            const debitBrandLogoEl = document.getElementById(debitBrandLogoElId);
            const debitBackEmblemEl = document.getElementById(debitBackEmblemElId);

            if (isDebit) {
                if (debitBrandLogoEl) debitBrandLogoEl.innerHTML = brandLogoEl ? brandLogoEl.innerHTML : '';
                if (debitBackEmblemEl) debitBackEmblemEl.innerHTML = backEmblemEl ? backEmblemEl.innerHTML : '';
            }
        }

        function open3DCardPreview(number, holder, type, provider, cvv, expiry, status, limit) {
            const modal = document.getElementById('previewCardModal');
            
            // Set front values
            document.getElementById('previewNumber').innerText = number;
            document.getElementById('previewHolder').innerText = holder;
            document.getElementById('previewExpiry').innerText = expiry;
            
            const previewDebitNum = document.getElementById('previewDebitNumber');
            if (previewDebitNum) previewDebitNum.innerText = number;
            const previewDebitHol = document.getElementById('previewDebitHolder');
            if (previewDebitHol) previewDebitHol.innerText = holder;
            const previewDebitExp = document.getElementById('previewDebitExpiry');
            if (previewDebitExp) previewDebitExp.innerText = expiry;
            
            const previewCvvEl = document.getElementById('previewCvv');
            previewCvvEl.innerText = "•••";
            previewCvvEl.setAttribute('data-cvv', cvv);
            
            const previewDebitCvvEl = document.getElementById('previewDebitCvv');
            if (previewDebitCvvEl) {
                previewDebitCvvEl.innerText = "•••";
                previewDebitCvvEl.setAttribute('data-cvv', cvv);
            }
            
            const numLimit = parseFloat(limit) || 0;
            
            updateDynamicCardDetails('visualizerCard', 'previewTierIndicator', 'previewBrandLogo', 'previewBackEmblem', type, provider, numLimit, status);
            
            const specStatus = document.getElementById('previewSpecStatus');
            const specLimit = document.getElementById('previewSpecLimit');
            
            const normStatus = status.toLowerCase();
            if (normStatus === 'active') {
                specStatus.innerText = "Active";
                specStatus.style.color = "var(--accent-emerald)";
            } else if (normStatus === 'pending') {
                specStatus.innerText = "Pending Review";
                specStatus.style.color = "#fbbf24";
            } else if (normStatus === 'expired') {
                specStatus.innerText = "Expired";
                specStatus.style.color = "#ef4444";
            } else {
                specStatus.innerText = "Closed";
                specStatus.style.color = "var(--gray-500)";
            }
            
            specLimit.innerText = type.toLowerCase() === 'credit' ? "₹ " + numLimit.toLocaleString('en-IN', {minimumFractionDigits:2}) + " Limit" : "₹ " + numLimit.toLocaleString('en-IN', {minimumFractionDigits:2}) + " Daily";
            
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

        function close3DCardPreviewOnClickOutside(event) {
            if (event.target === document.getElementById('previewCardModal')) {
                close3DCardPreview();
            }
        }

        // Live 3D customizer sync
        function syncDemoCard() {
            const type = document.getElementById('ctrlCardType').value;
            const provider = document.getElementById('ctrlCardProvider').value;
            const holder = document.getElementById('ctrlHolderName').value.trim().toUpperCase() || "DEMO HOLDER";
            const number = document.getElementById('ctrlCardNumber').value.trim() || "4589 7321 6048 2190";
            const expiry = document.getElementById('ctrlExpiry').value.trim() || "12/30";
            const cvv = document.getElementById('ctrlCvv').value.trim() || "907";

            document.getElementById('demoNumber').innerText = number;
            document.getElementById('demoHolder').innerText = holder;
            document.getElementById('demoExpiry').innerText = expiry;
            
            const demoDebitNum = document.getElementById('demoDebitNumber');
            if (demoDebitNum) demoDebitNum.innerText = number;
            const demoDebitHol = document.getElementById('demoDebitHolder');
            if (demoDebitHol) demoDebitHol.innerText = holder;
            const demoDebitExp = document.getElementById('demoDebitExpiry');
            if (demoDebitExp) demoDebitExp.innerText = expiry;

            const demoCvvEl = document.getElementById('demoCvv');
            demoCvvEl.setAttribute('data-cvv', cvv);
            if (demoCvvEl.innerText !== '•••') {
                demoCvvEl.innerText = cvv;
            }
            
            const demoDebitCvvEl = document.getElementById('demoDebitCvv');
            if (demoDebitCvvEl) {
                demoDebitCvvEl.setAttribute('data-cvv', cvv);
                if (demoDebitCvvEl.innerText !== '•••') {
                    demoDebitCvvEl.innerText = cvv;
                }
            }

            const status = type === 'inactive' ? 'inactive' : 'active';
            const limit = type.includes('premium') ? 100000 : 50000;

            updateDynamicCardDetails('demo3DCard', 'demoTierIndicator', 'demoBrandLogo', 'demoBackEmblem', type, provider, limit, status);
        }

        function toggle3DCardCvv(event, element) {
            if (event) event.stopPropagation();
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
            const names = ["MIHIR BHAYANI", "PARTH TANK", "KARAN PATEL", "SNEHA RAO", "ROHAN SHARMA", "VERTEX MEMBER"];
            const providers = ["visa", "mastercard", "rupay"];
            const types = ["debit", "debit-premium", "credit", "credit-premium"];
            
            const randomName = names[Math.floor(Math.random() * names.length)];
            const randomProvider = providers[Math.floor(Math.random() * providers.length)];
            const randomType = types[Math.floor(Math.random() * types.length)];
            
            let cardPrefix = "4";
            if (randomProvider === 'mastercard') cardPrefix = "5";
            if (randomProvider === 'rupay') cardPrefix = "6";
            
            let cardNumber = cardPrefix;
            for (let i = 0; i < 15; i++) {
                if (i > 0 && i % 4 === 3) cardNumber += "  ";
                cardNumber += Math.floor(Math.random() * 10);
            }

            const months = ["01", "03", "04", "05", "07", "08", "10", "11", "12"];
            const randomMonth = months[Math.floor(Math.random() * months.length)];
            const randomYear = 26 + Math.floor(Math.random() * 5);

            const randomCvv = Math.floor(100 + Math.random() * 900);

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

        // Live 3D Tilt Effect calculations
        function apply3DTilt(wrapperId, innerCardId) {
            const wrapper = document.getElementById(wrapperId);
            const card = document.getElementById(innerCardId);
            if (!wrapper || !card) return;
            
            wrapper.addEventListener('mousemove', function(e) {
                const rect = wrapper.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const width = rect.width;
                const height = rect.height;
                
                const percentX = (x / width) - 0.5;
                const percentY = (y / height) - 0.5;
                
                const maxRotation = 14; 
                
                const rotateX = -(percentY * maxRotation).toFixed(2);
                const rotateY = (percentX * maxRotation).toFixed(2);
                
                wrapper.style.transform = `perspective(1000px) rotateX(\${rotateX}deg) rotateY(\${rotateY}deg) scale3d(1.04, 1.04, 1.04)`;
            });
            
            wrapper.addEventListener('mouseleave', function() {
                wrapper.style.transition = "transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
                wrapper.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)";
            });

            wrapper.addEventListener('mouseenter', function() {
                wrapper.style.transition = "none";
            });
        }

        // Client side real-time directory table search & filter
        function filterDirectoryTable() {
            const searchVal = document.getElementById('directorySearchInput').value.toLowerCase();
            const typeVal = document.getElementById('directoryTypeFilter').value.toLowerCase();
            const statusVal = document.getElementById('directoryStatusFilter').value.toLowerCase();
            
            const table = document.getElementById('directoryTableBody');
            if (!table) return;
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                if (row.cells.length < 8) continue; // Skip empty list state rows
                
                const cardNum = row.cells[1].textContent.toLowerCase();
                const holder = row.cells[2].textContent.toLowerCase();
                const type = row.cells[3].textContent.toLowerCase();
                const status = row.cells[6].textContent.trim().toLowerCase();
                
                const matchesSearch = cardNum.includes(searchVal) || holder.includes(searchVal);
                const matchesType = typeVal === '' || type.includes(typeVal);
                const matchesStatus = statusVal === '' || status === statusVal;
                
                if (matchesSearch && matchesType && matchesStatus) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        }

        function init3DCardTiltEffect() {
            apply3DTilt('demo3DCardTiltWrapper', 'demo3DCard');
            apply3DTilt('visualizerCardTiltWrapper', 'visualizerCard');
        }

        window.addEventListener('DOMContentLoaded', () => {
            init3DCardTiltEffect();
            syncDemoCard();

            // Mobile menu toggle handler
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

            // Glow follower
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
    </script>
</body>
</html>
