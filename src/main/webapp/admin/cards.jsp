<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage ATM Cards</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/image.png" type="image/png">
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

        /* --- PRODUCT CATALOGUE CARD STYLING --- */
        .catalog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }
        .product-card {
            border-radius: var(--radius-md);
            padding: 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(99, 102, 241, 0.08);
            border-color: rgba(99, 102, 241, 0.25) !important;
        }
        body.dark-mode .product-card:hover {
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.3);
        }
        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255,255,255,0.03) 0%, transparent 100%);
            pointer-events: none;
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

        /* --- PREMIUM ATM CARDS --- */
        .vgb-atm-card {
            width: 100%;
            height: 100%;
            position: relative;
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
            background: radial-gradient(circle at 80% 80%, #3a007c 0%, #080321 60%, #01000b 100%) !important;
            box-shadow: 0 12px 25px rgba(58, 0, 124, 0.25) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
        }
        .vgb-atm-card.debit.premium-tier {
            background: repeating-linear-gradient(45deg, rgba(255,255,255,0.015) 0px, rgba(255,255,255,0.015) 1px, transparent 1px, transparent 8px), 
                        linear-gradient(135deg, #1b1c21 0%, #0d0e11 100%) !important;
            box-shadow: 0 12px 25px rgba(15, 23, 42, 0.3) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.3) !important;
        }
        .vgb-atm-card.credit {
            background: 
                radial-gradient(circle at 75% 35%, rgba(212, 175, 55, 0.25) 0%, transparent 55%),
                linear-gradient(to right, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                linear-gradient(to bottom, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
                linear-gradient(135deg, #121316 0%, #08090a 100%) !important;
            background-size: cover, 16px 16px, 16px 16px, cover;
            box-shadow: 0 12px 25px rgba(124, 45, 18, 0.25) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.12) !important;
        }
        .vgb-atm-card.credit.premium-tier {
            background: radial-gradient(circle at 75% 35%, #18052b 0%, #030107 70%, #000000 100%) !important;
            box-shadow: 0 12px 25px rgba(168, 85, 247, 0.25) !important;
            border: 1.5px solid rgba(139, 92, 246, 0.3) !important;
        }
        .vgb-atm-card.inactive-card {
            background: repeating-linear-gradient(45deg, rgba(0,0,0,0.15) 0px, rgba(0,0,0,0.15) 2px, transparent 2px, transparent 10px), 
                        linear-gradient(135deg, #2e3035 0%, #151618 100%) !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
            border: 1.5px solid rgba(255, 255, 255, 0.08) !important;
            opacity: 0.75;
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
            box-shadow: inset 0 0 50px rgba(162, 23, 221, 0.3), 0 0 60px rgba(162, 23, 221, 0.2);
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
            box-shadow: 0 0 15px rgba(186, 85, 211, 0.2), inset 0 0 15px rgba(186, 85, 211, 0.1);
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
            margin: 0 auto;
            width: 340px;
            height: 220px;
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
                <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/image.png" alt="Admin Profile Avatar" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
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

            <!-- VGB ATM Card Product Catalogue -->
            <div class="glass-card" style="margin-bottom: 30px;">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1px solid rgba(99, 102, 241, 0.1); padding-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-book-open" style="color: var(--primary-500);"></i> VGB Bank Card Product Specifications & Suite
                </h3>
                <div class="catalog-grid">
                    
                    <!-- Card 1: Classic Debit -->
                    <div class="product-card" style="background: rgba(99, 102, 241, 0.03); border: 1.5px solid rgba(99, 102, 241, 0.1);">
                        <div style="position: absolute; top: -10px; right: -10px; font-size: 4rem; color: rgba(99, 102, 241, 0.05); font-weight: 800; transform: rotate(-15deg); pointer-events: none; user-select: none;">DEBIT</div>
                        <div>
                            <span style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.7rem; font-weight: 700; text-transform: uppercase;">Classic Tier</span>
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin: 10px 0 5px;">VGB Classic Debit Card</h4>
                            <p style="font-size: 0.8rem; color: var(--gray-500); line-height: 1.4; margin-bottom: 15px;">Standard transactional card linked directly to savings/checking accounts for daily retail needs.</p>
                            
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(99,102,241,0.1); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Issuance/Renewal:</span>
                                    <strong style="color: var(--gray-800);">₹250.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(99,102,241,0.1); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Daily Limit:</span>
                                    <strong style="color: var(--gray-800);">₹50,000.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(99,102,241,0.1); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Validity Period:</span>
                                    <strong style="color: var(--gray-800);">4 Years</strong>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h5 style="font-size: 0.75rem; font-weight: 700; color: var(--gray-500); text-transform: uppercase; margin-bottom: 8px; letter-spacing: 0.5px;">Features & Usage:</h5>
                            <ul style="font-size: 0.78rem; color: var(--gray-600); padding-left: 15px; margin: 0; line-height: 1.5; display: flex; flex-direction: column; gap: 4px;">
                                <li>Global ATM Cash Withdrawals & POS usage</li>
                                <li>Zero Liability Fraud Protection coverage</li>
                                <li>Real-time SMS & Email transaction alerts</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Card 2: Premium Debit -->
                    <div class="product-card" style="background: rgba(6, 182, 212, 0.03); border: 1.5px solid rgba(6, 182, 212, 0.1);">
                        <div style="position: absolute; top: -10px; right: -10px; font-size: 4rem; color: rgba(6, 182, 212, 0.05); font-weight: 800; transform: rotate(-15deg); pointer-events: none; user-select: none;">DEBIT</div>
                        <div>
                            <span style="background: rgba(6, 182, 212, 0.1); color: #0891b2; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.7rem; font-weight: 700; text-transform: uppercase;">Premium Tier</span>
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin: 10px 0 5px;">VGB Premium Debit Card</h4>
                            <p style="font-size: 0.8rem; color: var(--gray-500); line-height: 1.4; margin-bottom: 15px;">High-limit savings-linked card for affluent customers requesting elevated transaction bounds.</p>
                            
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(6,182,212,0.15); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Issuance/Renewal:</span>
                                    <strong style="color: var(--gray-800);">₹500.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(6,182,212,0.15); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Daily Limit:</span>
                                    <strong style="color: var(--gray-800);">₹2,00,000.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(6,182,212,0.15); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Validity Period:</span>
                                    <strong style="color: var(--gray-800);">4 Years</strong>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h5 style="font-size: 0.75rem; font-weight: 700; color: var(--gray-500); text-transform: uppercase; margin-bottom: 8px; letter-spacing: 0.5px;">Features & Usage:</h5>
                            <ul style="font-size: 0.78rem; color: var(--gray-600); padding-left: 15px; margin: 0; line-height: 1.5; display: flex; flex-direction: column; gap: 4px;">
                                <li>2 Free Domestic Airport Lounge Access per quarter</li>
                                <li>Enhanced Purchase Insurance Protection</li>
                                <li>Zero surcharge on select merchant terminal usage</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Card 3: Royale Credit -->
                    <div class="product-card" style="background: rgba(212, 175, 55, 0.03); border: 1.5px solid rgba(212, 175, 55, 0.15);">
                        <div style="position: absolute; top: -10px; right: -10px; font-size: 4rem; color: rgba(212, 175, 55, 0.05); font-weight: 800; transform: rotate(-15deg); pointer-events: none; user-select: none;">CREDIT</div>
                        <div>
                            <span style="background: rgba(212, 175, 55, 0.12); color: #b58d16; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.7rem; font-weight: 700; text-transform: uppercase;">Royale Tier</span>
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin: 10px 0 5px;">VGB Royale Credit Card</h4>
                            <p style="font-size: 0.8rem; color: var(--gray-500); line-height: 1.4; margin-bottom: 15px;">General credit card providing flexible spending margins and revolving outstanding balances.</p>
                            
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(212,175,55,0.2); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Issuance/Renewal:</span>
                                    <strong style="color: var(--gray-800);">₹500.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(212,175,55,0.2); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Credit Limit:</span>
                                    <strong style="color: var(--gray-800);">₹50,000.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(212,175,55,0.2); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Grace Period:</span>
                                    <strong style="color: var(--gray-800);">Up to 45 Days</strong>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h5 style="font-size: 0.75rem; font-weight: 700; color: var(--gray-500); text-transform: uppercase; margin-bottom: 8px; letter-spacing: 0.5px;">Features & Usage:</h5>
                            <ul style="font-size: 0.78rem; color: var(--gray-600); padding-left: 15px; margin: 0; line-height: 1.5; display: flex; flex-direction: column; gap: 4px;">
                                <li>3 Reward Points per ₹100 spent (redeemable)</li>
                                <li>1% Fuel Surcharge Waiver at partner outlets</li>
                                <li>Easy EMI conversion options via Mobile Portal</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Card 4: Infinite Credit -->
                    <div class="product-card" style="background: rgba(139, 92, 246, 0.03); border: 1.5px solid rgba(139, 92, 246, 0.12);">
                        <div style="position: absolute; top: -10px; right: -10px; font-size: 4rem; color: rgba(139, 92, 246, 0.05); font-weight: 800; transform: rotate(-15deg); pointer-events: none; user-select: none;">CREDIT</div>
                        <div>
                            <span style="background: rgba(139, 92, 246, 0.1); color: #7c3aed; padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.7rem; font-weight: 700; text-transform: uppercase;">Infinite Tier</span>
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin: 10px 0 5px;">VGB Infinite Credit Card</h4>
                            <p style="font-size: 0.8rem; color: var(--gray-500); line-height: 1.4; margin-bottom: 15px;">Elite premium credit offering featuring extreme credit caps and exclusive lifestyle perks.</p>
                            
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(139,92,246,0.2); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Issuance/Renewal:</span>
                                    <strong style="color: var(--gray-800);">₹2,000.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(139,92,246,0.2); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Credit Limit:</span>
                                    <strong style="color: var(--gray-800);">₹5,00,000.00</strong>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.8rem; border-bottom: 1px dashed rgba(139,92,246,0.2); padding-bottom: 4px;">
                                    <span style="color: var(--gray-500);">Grace Period:</span>
                                    <strong style="color: var(--gray-800);">Up to 45 Days</strong>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h5 style="font-size: 0.75rem; font-weight: 700; color: var(--gray-500); text-transform: uppercase; margin-bottom: 8px; letter-spacing: 0.5px;">Features & Usage:</h5>
                            <ul style="font-size: 0.78rem; color: var(--gray-600); padding-left: 15px; margin: 0; line-height: 1.5; display: flex; flex-direction: column; gap: 4px;">
                                <li>24/7 Dedicated Luxury Concierge Assistance</li>
                                <li>Uncapped international airport lounge access</li>
                                <li>Comprehensive Travel Insurance up to ₹1 Crore</li>
                            </ul>
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
                    <button onclick="openApplyModal()" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.8rem; border-radius: var(--radius-sm); font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; margin: 0; background: var(--gradient-primary); color: white; border: none; cursor: pointer; transition: all 0.3s ease;">
                        <i class="bx bx-plus-circle"></i> Apply / Renew Card
                    </button>
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
                                                <c:if test="${card.status eq 'active'}">
                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}" class="btn-action btn-action-reject" onclick="return confirm('Are you sure you want to permanently close card #${card.cardId}?');">
                                                        <i class="bx bx-power-off"></i> Close
                                                    </a>
                                                </c:if>
                                                <c:if test="${card.status ne 'pending'}">
                                                    <a href="${pageContext.request.contextPath}/card?action=renew&cardId=${card.cardId}&csrfToken=${sessionScope.csrfToken}" class="btn-action btn-action-approve" onclick="return confirm('Are you sure you want to renew/reissue card #${card.cardId}?');">
                                                        <i class="bx bx-refresh"></i> Renew
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



    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
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

        window.addEventListener('DOMContentLoaded', () => {

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

        function openApplyModal() {
            document.getElementById('lookupAccountNumber').value = '';
            document.getElementById('applyCardForm').style.display = 'none';
            document.getElementById('applyModal').style.display = 'flex';
        }

        function closeApplyModal() {
            document.getElementById('applyModal').style.display = 'none';
        }

        function fetchCustomerDetails() {
            const accNo = document.getElementById('lookupAccountNumber').value.trim();
            if (!accNo) {
                alert('Please enter a valid Account Number');
                return;
            }

            fetch('${pageContext.request.contextPath}/account?action=details&accountNumber=' + accNo)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        alert(data.error);
                        document.getElementById('applyCardForm').style.display = 'none';
                    } else {
                        // Populate form fields
                        document.getElementById('formAccountId').value = data.accountId;
                        document.getElementById('formAccountNumber').value = data.accountNumber;
                        document.getElementById('applyCardHolderName').value = data.customerName;
                        
                        document.getElementById('paperAccountNumberDisplay').textContent = data.accountNumber + ' - ' + data.accountType + ' (Available: ₹ ' + parseFloat(data.balance).toLocaleString('en-IN', {minimumFractionDigits: 2}) + ')';
                        document.getElementById('paperCustomerIdDisplay').textContent = data.customerId;
                        document.getElementById('paperMobileDisplay').textContent = data.phone;
                        document.getElementById('paperEmailDisplay').textContent = data.email;
                        document.getElementById('paperAddressDisplay').textContent = data.address;
                        
                        document.getElementById('applyFormSignature').textContent = data.customerName;
                        document.getElementById('applyFormNameLabel').textContent = data.customerName;

                        // Date
                        const today = new Date();
                        const dd = String(today.getDate()).padStart(2, '0');
                        const mm = String(today.getMonth() + 1).padStart(2, '0');
                        const yyyy = today.getFullYear();
                        document.getElementById('applyFormDateStr').value = dd + ' / ' + mm + ' / ' + yyyy;

                        // Show form
                        document.getElementById('applyCardForm').style.display = 'block';
                    }
                })
                .catch(err => {
                    console.error('Error fetching details:', err);
                    alert('Failed to fetch customer details. Please check the account number.');
                });
        }

        function updateApplyFeeAndNotice(type) {
            const feeVal = type === 'credit' ? '₹ 500.00' : '₹ 250.00';
            document.getElementById('applyFeeValue').textContent = feeVal;
        }
    </script>

    <!-- Modal: Apply / Renew Card -->
    <div id="applyModal" class="modal">
        <div class="modal-content" style="max-width: 720px; width: 100%; background: var(--glass-bg); backdrop-filter: blur(25px); border: 1.5px solid var(--glass-border); border-radius: var(--radius-lg); overflow: hidden; box-shadow: var(--panel-shadow); display: flex; flex-direction: column;">
            <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid rgba(99,102,241,0.1); background: rgba(99,102,241,0.02); width: 100%; box-sizing: border-box;">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--gray-800); margin: 0; display: flex; align-items: center; gap: 8px;"><i class="bx bx-plus-circle" style="color: var(--primary-500);"></i> Apply Customer ATM Card</h3>
                <button type="button" onclick="closeApplyModal()" style="background: none; border: none; font-size: 1.5rem; color: var(--gray-400); cursor: pointer; transition: color 0.2s;" onmouseover="this.style.color='var(--gray-800)'" onmouseout="this.style.color='var(--gray-400)'">&times;</button>
            </div>
            
            <div style="padding: 20px 24px 15px; display: flex; gap: 10px; align-items: center; border-bottom: 1px dashed rgba(99,102,241,0.1); width: 100%; box-sizing: border-box; background: rgba(99,102,241,0.01);">
                <input type="text" id="lookupAccountNumber" placeholder="Enter customer account number (e.g. 171931936244)" style="flex: 1; padding: 10px 14px; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); font-size: 0.9rem; outline: none; background: transparent; color: var(--gray-800); font-family: monospace; font-weight: 600;" onkeypress="if(event.key === 'Enter') fetchCustomerDetails();">
                <button type="button" onclick="fetchCustomerDetails()" class="btn btn-primary" style="padding: 10px 20px; margin: 0; font-weight: 600; background: var(--gradient-primary); color: white; border: none; border-radius: var(--radius-md); cursor: pointer; display: inline-flex; align-items: center; gap: 6px;"><i class="bx bx-search-alt"></i> Fetch Details</button>
            </div>

            <!-- Beautiful Paper Form container (hidden by default until details loaded) -->
            <form id="applyCardForm" action="${pageContext.request.contextPath}/card?action=apply" method="post" style="display: none; padding: 24px; max-height: 65vh; overflow-y: auto; width: 100%; box-sizing: border-box; text-align: left;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" id="formAccountId" name="accountId" value="">
                <input type="hidden" id="formAccountNumber" name="accountNumber" value="">
                
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
                                <strong>Date:</strong> <input type="text" name="formDate" id="applyFormDateStr" style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;" value="" readonly>
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
                                    <input type="text" id="applyCardHolderName" name="cardHolderName" required readonly style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Account Number:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperAccountNumberDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Customer ID:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperCustomerIdDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperMobileDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;" id="paperEmailDisplay">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: inherit; font-size: 0.9rem; color: #0f172a; white-space: normal; word-break: break-word;" id="paperAddressDisplay">
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- Card Details Box -->
                    <div style="margin-bottom: 25px;">
                        <h4 style="border-bottom: 1px solid #94a3b8; padding-bottom: 3px; margin: 0 0 10px; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px; font-weight: 700; color: #475569; font-family: 'Poppins', sans-serif;">ATM/Debit Card Details</h4>
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <td style="width: 45%; padding: 5px 0;"><strong>Existing ATM/Debit Card (Last 4 Digits):</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                    <input type="text" name="existingCardLast4" readonly style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1.05rem; outline: none; background: transparent; color: #0f172a;" value="N/A (NEW CARD APPLICATION)">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Card Expiry Date:</strong></td>
                                <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                    <input type="text" name="cardExpiry" readonly style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; outline: none; background: transparent; color: #0f172a;" value="____ / ____">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Card Category:</strong></td>
                                <td style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                        <input type="radio" id="applyCardTypeDebit" name="cardType" value="debit" checked onchange="updateApplyFeeAndNotice('debit')" style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                        Debit Card (Fee: ₹250)
                                    </label>
                                    <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                        <input type="radio" id="applyCardTypeCredit" name="cardType" value="credit" onchange="updateApplyFeeAndNotice('credit')" style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                        Credit Card (Fee: ₹500)
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0;"><strong>Card Network:</strong></td>
                                <td style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                    <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                        <input type="radio" name="cardProvider" id="applyProviderVisa" value="visa" checked style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                        Visa
                                    </label>
                                    <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                        <input type="radio" name="cardProvider" id="applyProviderMastercard" value="mastercard" style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                        MasterCard
                                    </label>
                                    <label style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                        <input type="radio" name="cardProvider" id="applyProviderRuPay" value="rupay" style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                        RuPay
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- Signatures Row -->
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                        <div>
                            <span style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;" id="applyFormSignature"></span>
                            <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer Signature</span>
                        </div>
                        <div style="text-align: right;">
                            <span style="display: block; font-family: monospace; font-size: 0.95rem; font-weight: 600; color: #0f172a; text-transform: uppercase; padding-bottom: 5px;" id="applyFormNameLabel"></span>
                            <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Name</span>
                        </div>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" onclick="closeApplyModal()" class="btn-action btn-action-reject" style="padding: 8px 16px; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; border: 1px solid rgba(239, 68, 68, 0.2); background: rgba(239, 68, 68, 0.05); color: #ef4444;">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="padding: 8px 20px; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; background: var(--gradient-primary); color: white; border: none;">Submit Application</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
