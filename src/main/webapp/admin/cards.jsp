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
                <link
                    href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.5" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/assest/css/cards3d.css" rel="stylesheet">
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
                        box-sizing: border-box;
                        max-width: 100%;
                        overflow: hidden;
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
                        overflow: auto;
                        max-height: 400px;
                        border-radius: var(--radius-md);
                        border: 1px solid var(--glass-border);
                        -webkit-overflow-scrolling: touch;
                    }
                    .table-responsive::-webkit-scrollbar {
                        height: 8px;
                        width: 8px;
                    }
                    .table-responsive::-webkit-scrollbar-track {
                        background: rgba(99, 102, 241, 0.02);
                        border-radius: 10px;
                    }
                    .table-responsive::-webkit-scrollbar-thumb {
                        background: rgba(99, 102, 241, 0.15);
                        border-radius: 10px;
                        transition: background 0.2s ease;
                    }
                    .table-responsive::-webkit-scrollbar-thumb:hover {
                        background: rgba(99, 102, 241, 0.3);
                    }
                    body.dark-mode .table-responsive::-webkit-scrollbar-track {
                        background: rgba(255, 255, 255, 0.02);
                    }
                    body.dark-mode .table-responsive::-webkit-scrollbar-thumb {
                        background: rgba(255, 255, 255, 0.1);
                    }
                    body.dark-mode .table-responsive::-webkit-scrollbar-thumb:hover {
                        background: rgba(255, 255, 255, 0.2);
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                        text-align: left;
                    }

                    th {
                        position: sticky;
                        top: 0;
                        z-index: 10;
                        padding: 16px 20px;
                        color: var(--gray-500);
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        font-weight: 700;
                        letter-spacing: 1px;
                        border-bottom: 2px solid rgba(99, 102, 241, 0.1);
                        white-space: nowrap;
                        background: #ffffff;
                    }

                    body.dark-mode th {
                        color: var(--gray-400);
                        background: #1e293b;
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

                    .catalog-grid {
                        display: flex;
                        flex-direction: column;
                        gap: 25px;
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
                        background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, transparent 100%);
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
                        background: repeating-linear-gradient(45deg, rgba(255, 255, 255, 0.015) 0px, rgba(255, 255, 255, 0.015) 1px, transparent 1px, transparent 8px),
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
                        background: repeating-linear-gradient(45deg, rgba(0, 0, 0, 0.15) 0px, rgba(0, 0, 0, 0.15) 2px, transparent 2px, transparent 10px),
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

                    .debit-front-layout,
                    .credit-front-layout {
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
                        box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.4), 0 2px 4px rgba(0, 0, 0, 0.2);
                        border: 1px solid rgba(255, 255, 255, 0.15);
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
                    .debit-back-layout,
                    .credit-back-layout {
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
                        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
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

                    .control-input,
                    .control-select {
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

                    body.dark-mode .control-input,
                    body.dark-mode .control-select {
                        background: rgba(15, 23, 42, 0.45);
                        border-color: rgba(255, 255, 255, 0.1);
                        color: var(--white);
                    }

                    .control-input:focus,
                    .control-select:focus {
                        border-color: var(--primary-500);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
                    }

                    body.dark-mode .control-input:focus,
                    body.dark-mode .control-select:focus {
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
                        from {
                            opacity: 0;
                            transform: scale(0.95);
                        }

                        to {
                            opacity: 1;
                            transform: scale(1);
                        }
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

                    /* --- LOOKUP CONTAINER REDESIGN --- */
                    .lookup-container {
                        padding: 24px;
                        display: flex;
                        gap: 12px;
                        align-items: center;
                        border-bottom: 1px dashed rgba(99, 102, 241, 0.15);
                        width: 100%;
                        box-sizing: border-box;
                        background: #f8fafc;
                    }

                    body.dark-mode .lookup-container {
                        background: rgba(15, 23, 42, 0.3);
                    }

                    .modal-content {
                        background: #ffffff !important;
                        border: 1.5px solid var(--gray-200) !important;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04) !important;
                    }

                    body.dark-mode .modal-content {
                        background: #1e293b !important;
                        border-color: rgba(255, 255, 255, 0.08) !important;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3) !important;
                    }

                    .lookup-input-wrapper {
                        position: relative;
                        flex: 1;
                        display: flex;
                        align-items: center;
                    }

                    .lookup-input-wrapper i {
                        position: absolute;
                        left: 14px;
                        font-size: 1.2rem;
                        color: var(--primary-500);
                        pointer-events: none;
                    }

                    .lookup-input {
                        width: 100%;
                        padding: 12px 16px 12px 42px !important;
                        border: 2px solid rgba(99, 102, 241, 0.15) !important;
                        border-radius: var(--radius-md) !important;
                        font-size: 0.9rem !important;
                        outline: none !important;
                        background: #ffffff !important;
                        color: var(--gray-800) !important;
                        font-family: 'Poppins', sans-serif !important;
                        font-weight: 500 !important;
                        box-shadow: 0 4px 10px rgba(99, 102, 241, 0.04) !important;
                        transition: all 0.3s ease !important;
                    }

                    body.dark-mode .lookup-input {
                        background: rgba(15, 23, 42, 0.6) !important;
                        border-color: rgba(255, 255, 255, 0.1) !important;
                        color: #ffffff !important;
                        box-shadow: none !important;
                    }

                    .lookup-input::placeholder {
                        color: var(--gray-400) !important;
                        font-weight: 400;
                    }

                    .lookup-input:focus {
                        border-color: var(--primary-500) !important;
                        box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12) !important;
                    }

                    .btn-lookup {
                        padding: 12px 24px !important;
                        margin: 0 !important;
                        font-weight: 600 !important;
                        background: var(--gradient-primary) !important;
                        color: white !important;
                        border: none !important;
                        border-radius: var(--radius-md) !important;
                        cursor: pointer !important;
                        display: inline-flex !important;
                        align-items: center !important;
                        gap: 8px !important;
                        font-size: 0.9rem !important;
                        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2) !important;
                        transition: all 0.3s ease !important;
                    }

                    .btn-lookup:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 6px 15px rgba(99, 102, 241, 0.3) !important;
                    }

                    .btn-lookup:active {
                        transform: scale(0.96) !important;
                    }

                    /* --- LOOKUP RESULT CARDS --- */
                    .lookup-result-card {
                        background: #ffffff;
                        border: 1.5px solid var(--gray-200);
                        border-radius: var(--radius-md);
                        padding: 16px 20px;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02);
                        text-align: left;
                        margin-bottom: 12px;
                        display: block;
                        width: 100%;
                        box-sizing: border-box;
                    }

                    body.dark-mode .lookup-result-card {
                        background: rgba(15, 23, 42, 0.4);
                        border-color: rgba(255, 255, 255, 0.08);
                        box-shadow: none;
                    }

                    .lookup-result-card:hover {
                        border-color: var(--primary-400);
                        background: rgba(99, 102, 241, 0.02);
                        transform: translateY(-2px);
                        box-shadow: 0 6px 15px rgba(99, 102, 241, 0.06);
                    }

                    body.dark-mode .lookup-result-card:hover {
                        background: rgba(99, 102, 241, 0.08);
                        border-color: var(--primary-500);
                    }

                    .lookup-result-card-title {
                        font-size: 0.95rem;
                        font-weight: 700;
                        color: var(--gray-800);
                        margin: 0 0 6px 0;
                        font-family: 'Poppins', sans-serif;
                    }

                    body.dark-mode .lookup-result-card-title {
                        color: #ffffff;
                    }

                    .lookup-result-card-details {
                        font-size: 0.85rem;
                        color: var(--gray-400);
                        font-family: 'Poppins', sans-serif;
                        font-weight: 500;
                    }

                    body.dark-mode .lookup-result-card-details {
                        color: var(--gray-500);
                    }

                    .lookup-result-card-details span {
                        font-family: monospace;
                        font-weight: 600;
                        color: var(--gray-600);
                    }

                    body.dark-mode .lookup-result-card-details span {
                        color: var(--gray-300);
                    }

                    /* Card Subtype Badges */
                    .badge-card-type {
                        padding: 4px 8px !important;
                        border-radius: var(--radius-sm) !important;
                        font-size: 0.72rem !important;
                        font-weight: 600 !important;
                        text-transform: uppercase !important;
                        display: inline-block !important;
                        letter-spacing: 0.3px !important;
                        white-space: nowrap !important;
                    }

                    .badge-card-type.classic-debit {
                        background: rgba(14, 165, 233, 0.1) !important;
                        color: #0284c7 !important;
                    }

                    .badge-card-type.premium-debit {
                        background: rgba(139, 92, 246, 0.1) !important;
                        color: #7c3aed !important;
                    }

                    .badge-card-type.royale-credit {
                        background: rgba(225, 29, 72, 0.1) !important;
                        color: #e11d48 !important;
                    }

                    .badge-card-type.infinite-credit {
                        background: rgba(15, 23, 42, 0.08) !important;
                        color: #0f172a !important;
                        border: 1px solid rgba(15, 23, 42, 0.15) !important;
                    }

                    body.dark-mode .badge-card-type.infinite-credit {
                        background: rgba(255, 255, 255, 0.08) !important;
                        color: #f1f5f9 !important;
                        border: 1px solid rgba(255, 255, 255, 0.15) !important;
                    }

                    /* --- ADMIN CARDS REDESIGN STYLES --- */
                    .page-title-container {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 40px;
                    }
                    .page-title {
                        font-size: 2.2rem;
                        font-weight: 800;
                        color: var(--gray-900);
                        letter-spacing: -0.5px;
                    }
                    body.dark-mode .page-title {
                        color: #ffffff;
                    }
                    .page-subtitle {
                        color: var(--gray-500);
                        font-size: 0.95rem;
                        margin-top: 6px;
                    }
                    body.dark-mode .page-subtitle {
                        color: var(--gray-400);
                    }
                    .stat-label {
                        font-size: 0.8rem;
                        color: var(--gray-500);
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }
                    body.dark-mode .stat-label {
                        color: var(--gray-400);
                    }
                    .stat-value {
                        font-size: 1.75rem;
                        font-weight: 800;
                        color: var(--gray-800);
                        margin: 2px 0 0 0;
                        line-height: 1.1;
                    }
                    body.dark-mode .stat-value {
                        color: #ffffff;
                    }

                    .card-section-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        border-bottom: 1px solid rgba(99, 102, 241, 0.1);
                        padding-bottom: 15px;
                        margin-bottom: 20px;
                        flex-wrap: wrap;
                        gap: 15px;
                    }
                    .card-section-title {
                        font-size: 1.25rem;
                        font-weight: 700;
                        color: var(--gray-800);
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        margin: 0;
                    }
                    body.dark-mode .card-section-title {
                        color: #ffffff;
                    }
                    .card-section-actions {
                        display: flex;
                        gap: 10px;
                        flex-wrap: wrap;
                    }

                    .table-sr-no {
                        font-weight: 600;
                        color: var(--gray-500);
                    }
                    body.dark-mode .table-sr-no {
                        color: var(--gray-400);
                    }
                    .table-holder-name {
                        font-weight: 500;
                    }
                    body.dark-mode .table-holder-name {
                        color: #ffffff;
                    }
                    .table-provider {
                        text-transform: uppercase;
                        font-weight: 500;
                        color: var(--gray-600);
                    }
                    body.dark-mode .table-provider {
                        color: var(--gray-400);
                    }
                    .table-actions-cell {
                        text-align: center;
                        display: flex;
                        gap: 8px;
                        justify-content: center;
                        align-items: center;
                    }
                    .status-badge {
                        padding: 4px 8px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        display: inline-block;
                    }
                    .status-badge-active {
                        background: rgba(16, 185, 129, 0.1);
                        color: var(--accent-emerald);
                    }
                    .status-badge-pending {
                        background: rgba(245, 158, 11, 0.1);
                        color: #fbbf24;
                    }
                    .status-badge-expired {
                        background: rgba(239, 68, 68, 0.1);
                        color: #b91c1c;
                    }
                    .status-badge-closed {
                        background: rgba(156, 163, 175, 0.1);
                        color: var(--gray-500);
                    }

                    /* Catalog Card Container adjustments */
                    .catalog-scroll-container {
                        width: 100%;
                        overflow-x: auto;
                        padding-bottom: 12px;
                        margin-bottom: 10px;
                        -webkit-overflow-scrolling: touch;
                    }
                    .catalog-scroll-container::-webkit-scrollbar {
                        height: 8px;
                    }
                    .catalog-scroll-container::-webkit-scrollbar-track {
                        background: rgba(99, 102, 241, 0.02);
                        border-radius: 10px;
                    }
                    .catalog-scroll-container::-webkit-scrollbar-thumb {
                        background: rgba(99, 102, 241, 0.15);
                        border-radius: 10px;
                        transition: background 0.2s ease;
                    }
                    .catalog-scroll-container::-webkit-scrollbar-thumb:hover {
                        background: rgba(99, 102, 241, 0.3);
                    }
                    body.dark-mode .catalog-scroll-container::-webkit-scrollbar-track {
                        background: rgba(255, 255, 255, 0.02);
                    }
                    body.dark-mode .catalog-scroll-container::-webkit-scrollbar-thumb {
                        background: rgba(255, 255, 255, 0.1);
                    }
                    body.dark-mode .catalog-scroll-container::-webkit-scrollbar-thumb:hover {
                        background: rgba(255, 255, 255, 0.2);
                    }

                    .catalog-grid {
                        display: flex;
                        flex-direction: row;
                        gap: 24px;
                        width: max-content;
                        align-items: stretch;
                        padding: 4px;
                    }
                    .product-card {
                        width: 320px;
                        flex-shrink: 0;
                        border-radius: var(--radius-lg);
                        padding: 24px;
                        display: flex;
                        flex-direction: column !important;
                        gap: 16px;
                        position: relative;
                        overflow: hidden;
                        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
                        background: #ffffff;
                    }
                    body.dark-mode .product-card {
                        background: #1e293b;
                    }
                    .product-card-bg-debit-classic {
                        background: rgba(99, 102, 241, 0.02);
                        border: 1.5px solid rgba(99, 102, 241, 0.08);
                    }
                    body.dark-mode .product-card-bg-debit-classic {
                        background: rgba(99, 102, 241, 0.04);
                        border-color: rgba(99, 102, 241, 0.15);
                    }
                    .product-card-bg-debit-premium {
                        background: rgba(6, 182, 212, 0.02);
                        border: 1.5px solid rgba(6, 182, 212, 0.08);
                    }
                    body.dark-mode .product-card-bg-debit-premium {
                        background: rgba(6, 182, 212, 0.04);
                        border-color: rgba(6, 182, 212, 0.15);
                    }
                    .product-card-bg-credit-royale {
                        background: rgba(244, 63, 94, 0.02);
                        border: 1.5px solid rgba(244, 63, 94, 0.08);
                    }
                    body.dark-mode .product-card-bg-credit-royale {
                        background: rgba(244, 63, 94, 0.04);
                        border-color: rgba(244, 63, 94, 0.15);
                    }
                    .product-card-bg-credit-infinite {
                        background: rgba(245, 158, 11, 0.02);
                        border: 1.5px solid rgba(245, 158, 11, 0.08);
                    }
                    body.dark-mode .product-card-bg-credit-infinite {
                        background: rgba(245, 158, 11, 0.04);
                        border-color: rgba(245, 158, 11, 0.15);
                    }

                    .product-card-watermark {
                        position: absolute;
                        top: -10px;
                        right: -10px;
                        font-size: 5.5rem;
                        font-weight: 800;
                        transform: rotate(-15deg);
                        pointer-events: none;
                        user-select: none;
                        line-height: 1;
                    }
                    .watermark-debit {
                        color: rgba(99, 102, 241, 0.025);
                    }
                    body.dark-mode .watermark-debit {
                        color: rgba(255, 255, 255, 0.015);
                    }
                    .watermark-credit {
                        color: rgba(244, 63, 94, 0.025);
                    }
                    body.dark-mode .watermark-credit {
                        color: rgba(255, 255, 255, 0.015);
                    }

                    /* Card columns styling */
                    .catalog-details-col {
                        width: 100%;
                        display: flex;
                        flex-direction: column;
                        gap: 10px;
                    }
                    .catalog-spec-badge {
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-size: 0.75rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        align-self: flex-start;
                    }
                    .spec-badge-classic {
                        background: rgba(99, 102, 241, 0.08);
                        color: var(--primary-500);
                    }
                    .spec-badge-premium {
                        background: rgba(6, 182, 212, 0.08);
                        color: #0891b2;
                    }
                    .spec-badge-royale {
                        background: rgba(244, 63, 94, 0.08);
                        color: #e11d48;
                    }
                    .spec-badge-infinite {
                        background: rgba(245, 158, 11, 0.08);
                        color: #d97706;
                    }

                    .catalog-card-title {
                        font-size: 1.25rem;
                        font-weight: 800;
                        color: var(--gray-800);
                        margin: 0;
                    }
                    body.dark-mode .catalog-card-title {
                        color: #ffffff;
                    }

                    .catalog-card-desc {
                        font-size: 0.85rem;
                        color: var(--gray-500);
                        line-height: 1.5;
                        margin: 0;
                    }
                    body.dark-mode .catalog-card-desc {
                        color: var(--gray-400);
                    }

                    .catalog-specs-table {
                        display: flex;
                        flex-direction: column;
                        gap: 8px;
                        width: 100%;
                        margin-top: 5px;
                    }
                    .catalog-spec-row {
                        display: flex;
                        justify-content: space-between;
                        font-size: 0.82rem;
                        border-bottom: 1px dashed rgba(99, 102, 241, 0.08);
                        padding-bottom: 5px;
                    }
                    body.dark-mode .catalog-spec-row {
                        border-bottom-color: rgba(255, 255, 255, 0.05);
                    }
                    .catalog-spec-label {
                        color: var(--gray-500);
                    }
                    body.dark-mode .catalog-spec-label {
                        color: var(--gray-400);
                    }
                    .catalog-spec-value {
                        color: var(--gray-800);
                        font-weight: 700;
                    }
                    body.dark-mode .catalog-spec-value {
                        color: #ffffff;
                    }

                    .catalog-features-col {
                        width: 100%;
                        border-top: 1px dashed rgba(99, 102, 241, 0.12);
                        padding-top: 20px;
                        display: flex;
                        flex-direction: column;
                        gap: 10px;
                    }
                    body.dark-mode .catalog-features-col {
                        border-top-color: rgba(255, 255, 255, 0.1);
                    }
                    .catalog-features-heading {
                        font-size: 0.78rem;
                        font-weight: 700;
                        color: var(--gray-450);
                        text-transform: uppercase;
                        margin-bottom: 5px;
                        letter-spacing: 0.8px;
                    }
                    .catalog-features-list {
                        font-size: 0.82rem;
                        color: var(--gray-600);
                        padding-left: 16px;
                        margin: 0;
                        line-height: 1.6;
                        display: flex;
                        flex-direction: column;
                        gap: 6px;
                    }
                    body.dark-mode .catalog-features-list {
                        color: var(--gray-300);
                    }

                    .catalog-action-col {
                        width: 100%;
                        margin-top: auto;
                        padding-top: 15px;
                    }
                    .btn-apply-catalog {
                        width: 100% !important;
                        padding: 12px 24px !important;
                        white-space: nowrap !important;
                        margin: 0 !important;
                        font-weight: 600;
                        border-radius: var(--radius-md) !important;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                        font-size: 0.85rem !important;
                        box-shadow: 0 4px 15px rgba(99, 102, 241, 0.15);
                        transition: all 0.3s ease;
                    }
                    .btn-apply-catalog:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(99, 102, 241, 0.25);
                    }

                    /* Modals & Paper Application Form Styles */
                    .modal {
                        position: fixed;
                        inset: 0;
                        background: rgba(15, 23, 42, 0.5);
                        backdrop-filter: blur(8px);
                        display: none;
                        align-items: center;
                        justify-content: center;
                        z-index: 1100;
                        padding: 20px;
                    }
                    .modal-content {
                        background: var(--glass-bg);
                        border: 1px solid var(--glass-border);
                        backdrop-filter: blur(25px) saturate(180%);
                        box-shadow: var(--panel-shadow);
                    }
                    body.dark-mode .modal-content {
                        background: #1e293b;
                        border-color: rgba(255, 255, 255, 0.08);
                    }
                    .lookup-container {
                        display: flex;
                        gap: 12px;
                        padding: 24px;
                        background: rgba(99, 102, 241, 0.02);
                        border-bottom: 1px solid var(--glass-border);
                    }
                    .lookup-input-wrapper {
                        position: relative;
                        flex-grow: 1;
                    }
                    .lookup-input-wrapper i {
                        position: absolute;
                        left: 14px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--gray-400);
                        font-size: 1.1rem;
                    }
                    .lookup-input {
                        width: 100%;
                        padding: 12px 16px 12px 42px;
                        border: 1.5px solid var(--gray-200);
                        border-radius: var(--radius-md);
                        font-size: 0.88rem;
                        outline: none;
                        transition: all 0.3s ease;
                        box-shadow: var(--shadow-sm);
                        box-sizing: border-box;
                    }
                    body.dark-mode .lookup-input {
                        background: rgba(15, 23, 42, 0.6);
                        border-color: rgba(255, 255, 255, 0.1);
                        color: white;
                    }
                    .lookup-input:focus {
                        border-color: var(--primary-500);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
                    }
                    .btn-lookup {
                        padding: 12px 24px;
                        background: var(--primary-500);
                        color: white;
                        font-weight: 600;
                        border-radius: var(--radius-md);
                        border: none;
                        cursor: pointer;
                        white-space: nowrap;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 0.88rem;
                        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
                        transition: all 0.3s ease;
                    }
                    .btn-lookup:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 6px 15px rgba(99, 102, 241, 0.3);
                    }

                    .apply-paper-form {
                        background: #ffffff;
                        border: 1.5px solid var(--gray-200);
                        padding: 30px;
                        border-radius: var(--radius-sm);
                        color: #0f172a !important;
                        font-family: 'Times New Roman', Times, serif;
                        font-size: 0.98rem;
                        line-height: 1.6;
                        margin-top: 20px;
                        margin-bottom: 20px;
                        box-shadow: inset 0 0 15px rgba(0,0,0,0.01), var(--shadow-sm);
                        position: relative;
                        overflow: hidden;
                    }
                    body.dark-mode .apply-paper-form {
                        background: #ffffff !important;
                        border-color: #cbd5e1;
                        color: #0f172a !important;
                    }

                    /* Modal Header */
                    .modal-header-container {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 20px;
                        border-bottom: 1px solid rgba(99,102,241,0.1);
                        background: rgba(99,102,241,0.02);
                        width: 100%;
                        box-sizing: border-box;
                    }
                    .modal-title-text {
                        font-size: 1.25rem;
                        font-weight: 700;
                        color: var(--gray-800);
                        margin: 0;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }
                    body.dark-mode .modal-title-text {
                        color: #ffffff;
                    }
                    .modal-close-btn {
                        background: none;
                        border: none;
                        font-size: 1.5rem;
                        color: var(--gray-400);
                        cursor: pointer;
                        transition: color 0.2s;
                    }
                    .modal-close-btn:hover {
                        color: var(--gray-800);
                    }
                    body.dark-mode .modal-close-btn:hover {
                        color: #ffffff;
                    }

                    /* Search Results container */
                    .lookup-results-box {
                        display: none;
                        max-height: 200px;
                        overflow-y: auto;
                        padding: 15px 24px;
                        border-bottom: 1px dashed rgba(99,102,241,0.1);
                        box-sizing: border-box;
                        width: 100%;
                    }
                    .lookup-results-title {
                        margin: 0 0 10px;
                        font-size: 0.85rem;
                        color: var(--gray-500);
                        text-transform: uppercase;
                        font-weight: 700;
                        letter-spacing: 0.5px;
                        text-align: left;
                    }

                    /* Form styling inside paper form */
                    .paper-form-watermark {
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%) rotate(-30deg);
                        font-size: 7.5rem;
                        font-weight: 900;
                        color: rgba(99, 102, 241, 0.03);
                        pointer-events: none;
                        user-select: none;
                        font-family: 'Poppins', sans-serif;
                        letter-spacing: 5px;
                    }
                    .paper-form-header {
                        text-align: center;
                        border-bottom: 2px double #475569;
                        padding-bottom: 12px;
                        margin-bottom: 20px;
                        position: relative;
                    }
                    .paper-form-title {
                        font-size: 1.35rem;
                        font-weight: 800;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        color: #0f172a;
                        margin: 0;
                        font-family: 'Poppins', sans-serif;
                    }
                    .paper-form-subtitle {
                        font-size: 1rem;
                        font-weight: 700;
                        color: #475569;
                        margin: 4px 0 0;
                        text-transform: uppercase;
                        font-family: 'Poppins', sans-serif;
                        letter-spacing: 0.5px;
                    }
                    .paper-form-fee-badge {
                        position: absolute;
                        right: 0;
                        top: 50%;
                        transform: translateY(-50%);
                        background: rgba(16, 185, 129, 0.12);
                        color: #047857;
                        font-size: 0.75rem;
                        font-weight: 700;
                        padding: 4px 10px;
                        border-radius: var(--radius-sm);
                        font-family: 'Poppins', sans-serif;
                    }

                    .paper-form-section-title {
                        border-bottom: 1px solid #94a3b8;
                        padding-bottom: 3px;
                        margin: 0 0 10px;
                        text-transform: uppercase;
                        font-size: 0.85rem;
                        letter-spacing: 0.5px;
                        font-weight: 700;
                        color: #475569;
                        font-family: 'Poppins', sans-serif;
                    }

                    .paper-form-input-dotted {
                        width: 100%;
                        border: none;
                        border-bottom: 1px dotted #475569;
                        padding: 5px 8px;
                        font-weight: 600;
                        color: #0f172a;
                        outline: none;
                        background: transparent;
                    }

                    .catalog-card-container {
                        width: 100%;
                        height: 180px;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        margin: 10px 0;
                        flex-shrink: 0;
                    }
                    .catalog-card-wrapper {
                        transform: scale(0.8) !important;
                        transform-origin: center center;
                    }

                    /* General responsive breakpoints */
                    @media (max-width: 991px) {
                        .catalog-card-container {
                            align-self: center !important;
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
                        <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation"
                            style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                            <i class="bx bx-menu"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo"
                            style="display: flex; align-items: center; text-decoration: none;">
                            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB Logo"
                                style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
                        </a>
                    </div>
                    <div class="nav-actions" style="display: flex; align-items: center; gap: 20px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img id="adminHeaderAvatar" src="${pageContext.request.contextPath}/assest/images/image.png"
                                alt="Admin Profile Avatar"
                                style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                            <script>
                                (function () {
                                    const avatar = localStorage.getItem('admin_avatar');
                                    if (avatar) {
                                        document.getElementById('adminHeaderAvatar').src = avatar;
                                    }
                                })();
                            </script>
                            <div style="display: flex; flex-direction: column; text-align: left;" class="mobile-hide">
                                <span
                                    style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">Root
                                    Administrator</span>
                                <span
                                    style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                    <span
                                        style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-emerald); display: inline-block;"></span>
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
                        <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i>
                            Dashboard</a>
                        <a href="${pageContext.request.contextPath}/account?action=list"><i
                                class="bx bx-user-check"></i> Manage Accounts</a>
                        <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i
                                class="bx bx-transfer-alt"></i> Admin Counter</a>
                        <a href="${pageContext.request.contextPath}/card?action=list" class="active"><i
                                class="bx bx-credit-card"></i> Manage Cards</a>
                        <a href="${pageContext.request.contextPath}/chequebook?action=list"><i
                                class="bx bx-book-bookmark"></i> Cheque Requests</a>
                        <a href="${pageContext.request.contextPath}/passbook?action=list"><i
                                class="bx bx-book-open"></i> Passbook Requests</a>
                        <a href="${pageContext.request.contextPath}/loan?action=list"><i
                                class="bx bx-building-house"></i> Review Loans</a>
                        <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My
                            Profile</a>
                    </div>
                    <div
                        style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
                        <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
                        <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">
                            INTERNAL USE ONLY</p>
                    </div>
                </aside>

                <!-- Main Content -->
                <main class="main-content">
                    <div class="container" style="max-width: 1200px; padding: 0;">
                        <!-- Welcome Header -->
                        <div class="page-title-container">
                            <div>
                                <h2 class="page-title">ATM Cards Control Center</h2>
                                <p class="page-subtitle">Monitor customer debit/credit card applications, verify system card limits, and process card approvals.</p>
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
                                    <span class="stat-label">Total Requests</span>
                                    <h3 class="stat-value">${cards.size()}</h3>
                                </div>
                            </div>
                            <div class="stat-card" style="border-left: 4px solid #fbbf24;">
                                <div class="sparkline-decor" style="background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);"></div>
                                <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #fbbf24;">
                                    <i class="bx bx-time-five"></i>
                                </div>
                                <div>
                                    <span class="stat-label" style="display: flex; align-items: center;">
                                        Pending Review <span class="pulse-dot"></span>
                                    </span>
                                    <h3 class="stat-value">${pendingCount}</h3>
                                </div>
                            </div>
                            <div class="stat-card" style="border-left: 4px solid var(--accent-emerald);">
                                <div class="sparkline-decor" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);"></div>
                                <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                                    <i class="bx bx-badge-check"></i>
                                </div>
                                <div>
                                    <span class="stat-label">Approved Active</span>
                                    <h3 class="stat-value">${activeCount}</h3>
                                </div>
                            </div>
                            <div class="stat-card" style="border-left: 4px solid #ef4444;">
                                <div class="sparkline-decor" style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);"></div>
                                <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                                    <i class="bx bx-block"></i>
                                </div>
                                <div>
                                    <span class="stat-label">Revoked / Closed</span>
                                    <h3 class="stat-value">${closedCount}</h3>
                                </div>
                            </div>
                        </div>

                        <!-- VGB ATM Card Product Catalogue -->
                        <div class="glass-card">
                            <div class="card-section-header">
                                <h3 class="card-section-title">
                                    <i class="bx bx-book-open" style="color: var(--primary-500);"></i> VGB Bank Card Product Specifications & Suite
                                </h3>
                            <div class="catalog-scroll-container">
                                <div class="catalog-grid">

                                <!-- Card 1: Classic Debit -->
                                <div class="product-card product-card-bg-debit-classic">
                                    <div class="product-card-watermark watermark-debit">DEBIT</div>
                                    
                                    <div class="catalog-details-col">
                                        <span class="catalog-spec-badge spec-badge-classic">Classic Tier</span>
                                        <h4 class="catalog-card-title">VGB Classic Debit Card</h4>
                                        <p class="catalog-card-desc">Standard transactional card linked directly to savings/checking accounts for daily retail needs.</p>
                                    </div>

                                    <!-- Interactive 3D Card Preview -->
                                    <div class="catalog-card-container">
                                        <div class="catalog-card-wrapper card-3d-wrapper">
                                            <div class="vgb-atm-card debit visa">
                                                <!-- Front Face -->
                                                <div class="card-face card-front">
                                                    <div class="card-header">
                                                        <div class="bank-info">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png"
                                                                alt="VGB Logo" class="card-bank-logo">
                                                            <div class="bank-name">
                                                                 <span class="bank-title">VERTEX</span>
                                                                 <span class="bank-subtitle">GALAXY BANK</span>
                                                            </div>
                                                        </div>
                                                        <div class="card-type-label">
                                                            <span class="type-text">debit</span>
                                                            <span class="card-provider-name">visa</span>
                                                        </div>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="chip-wifi-row">
                                                            <svg class="card-chip-svg" viewBox="0 0 100 80"
                                                                width="36" height="28"
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <rect width="100" height="80" rx="10"
                                                                    fill="url(#chipGoldValC1)" />
                                                                <path
                                                                    d="M 0 30 H 100 M 0 50 H 100 M 40 0 V 80 M 60 0 V 80"
                                                                    stroke="#78350f" stroke-width="1.5" fill="none"
                                                                    opacity="0.4" />
                                                                <defs>
                                                                    <linearGradient id="chipGoldValC1" x1="0%"
                                                                        y1="0%" x2="100%" y2="100%">
                                                                        <stop offset="0%" stop-color="#fbbf24" />
                                                                        <stop offset="50%" stop-color="#d97706" />
                                                                        <stop offset="100%" stop-color="#b45309" />
                                                                    </linearGradient>
                                                                </defs>
                                                            </svg>
                                                            <i class="bx bx-wifi contactless-icon"></i>
                                                        </div>
                                                        <div class="card-number-display">4000 1234 5678 9010</div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <div class="footer-info">
                                                            <span class="footer-label">Card Holder</span>
                                                            <span class="footer-value holder-name-text">CLASSIC CUSTOMER</span>
                                                        </div>
                                                        <div class="footer-info expiry-container">
                                                            <span class="footer-label">Expires</span>
                                                            <span class="footer-value">12/30</span>
                                                        </div>
                                                        <div class="card-logo-container">
                                                            <div class="logo-visa">
                                                                <span class="brand-text">VISA</span>
                                                                <span class="brand-sub">SECURE</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Back Face -->
                                                <div class="card-face card-back">
                                                    <div class="magnetic-strip"></div>
                                                    <div class="back-body">
                                                        <div class="signature-cvv-section">
                                                            <div class="signature-strip">
                                                                    <span class="signature-watermark">VERTEX GALAXY BANK</span>
                                                            </div>
                                                            <div class="cvv-box"
                                                                onclick="event.stopPropagation(); toggleCvv(this, '123')"
                                                                title="Click to show CVV">
                                                                <span class="cvv-label">CVV</span>
                                                                <span class="cvv-value cvv-text">•••</span>
                                                            </div>
                                                        </div>
                                                        <div class="back-extra-info">
                                                            <p class="disclaimer-text">
                                                                This card is property of Vertex Galaxy Bank.
                                                                Subject to cardholder agreement.
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="back-footer">
                                                        <div class="back-bank-brand">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png"
                                                                alt="VGB" class="back-logo-img">
                                                            <span class="back-bank-name">VERTEX GALAXY BANK</span>
                                                        </div>
                                                        <div class="back-hologram">
                                                            <div class="hologram-seal"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="catalog-specs-table">
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Issuance/Renewal:</span>
                                            <strong class="catalog-spec-value">₹250.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Daily Limit:</span>
                                            <strong class="catalog-spec-value">₹50,000.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Validity Period:</span>
                                            <strong class="catalog-spec-value">4 Years</strong>
                                        </div>
                                    </div>

                                    <!-- Features & Usage -->
                                    <div class="catalog-features-col">
                                        <h5 class="catalog-features-heading">Features & Usage:</h5>
                                        <ul class="catalog-features-list">
                                            <li>Global ATM Cash Withdrawals & POS usage</li>
                                            <li>Zero Liability Fraud Protection coverage</li>
                                            <li>Real-time SMS & Email transaction alerts</li>
                                        </ul>
                                    </div>

                                    <!-- Apply Action Button -->
                                    <div class="catalog-action-col">
                                        <button type="button" onclick="openApplyModal('classic_debit')" class="btn-apply-catalog btn btn-primary">
                                            <i class="bx bx-plus-circle"></i> Apply Classic Debit
                                        </button>
                                    </div>
                                </div>

                                <!-- Card 2: Premium Debit -->
                                <div class="product-card product-card-bg-debit-premium">
                                    <div class="product-card-watermark watermark-debit">DEBIT</div>
                                    
                                    <div class="catalog-details-col">
                                        <span class="catalog-spec-badge spec-badge-premium">Premium Tier</span>
                                        <h4 class="catalog-card-title">VGB Premium Debit Card</h4>
                                        <p class="catalog-card-desc">High-limit savings-linked card for affluent customers requesting elevated transaction bounds.</p>
                                    </div>

                                    <!-- Interactive 3D Card Preview -->
                                    <div class="catalog-card-container">
                                        <div class="catalog-card-wrapper card-3d-wrapper">
                                            <div class="vgb-atm-card debit mastercard premium-tier">
                                                <!-- Front Face -->
                                                <div class="card-face card-front">
                                                    <div class="card-header">
                                                        <div class="bank-info">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png"
                                                                alt="VGB Logo" class="card-bank-logo">
                                                            <div class="bank-name">
                                                                <span class="bank-title">VERTEX</span>
                                                                <span class="bank-subtitle">GALAXY BANK</span>
                                                            </div>
                                                        </div>
                                                        <div class="card-type-label">
                                                            <span class="type-text">debit</span>
                                                            <span class="card-provider-name">mastercard</span>
                                                        </div>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="chip-wifi-row">
                                                            <svg class="card-chip-svg" viewBox="0 0 100 80"
                                                                width="36" height="28"
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <rect width="100" height="80" rx="10"
                                                                    fill="url(#chipGoldValC2)" />
                                                                <path
                                                                    d="M 0 30 H 100 M 0 50 H 100 M 40 0 V 80 M 60 0 V 80"
                                                                    stroke="#78350f" stroke-width="1.5" fill="none"
                                                                    opacity="0.4" />
                                                                <defs>
                                                                    <linearGradient id="chipGoldValC2" x1="0%"
                                                                        y1="0%" x2="100%" y2="100%">
                                                                        <stop offset="0%" stop-color="#fbbf24" />
                                                                        <stop offset="50%" stop-color="#d97706" />
                                                                        <stop offset="100%" stop-color="#b45309" />
                                                                    </linearGradient>
                                                                </defs>
                                                            </svg>
                                                            <i class="bx bx-wifi contactless-icon"></i>
                                                        </div>
                                                        <div class="card-number-display">5412 7512 3456 7890</div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <div class="footer-info">
                                                            <span class="footer-label">Card Holder</span>
                                                            <span class="footer-value holder-name-text">PREMIUM CUSTOMER</span>
                                                        </div>
                                                        <div class="footer-info expiry-container">
                                                            <span class="footer-label">Expires</span>
                                                            <span class="footer-value">12/30</span>
                                                        </div>
                                                        <div class="card-logo-container">
                                                            <div class="logo-mastercard">
                                                                <div class="mc-circles-wrapper">
                                                                    <span class="mc-circle mc-red"></span>
                                                                    <span class="mc-circle mc-orange"></span>
                                                                </div>
                                                                <span class="brand-text-mc">mastercard</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Back Face -->
                                                <div class="card-face card-back">
                                                    <div class="magnetic-strip"></div>
                                                    <div class="back-body">
                                                        <div class="signature-cvv-section">
                                                            <div class="signature-strip">
                                                                <span class="signature-watermark">VERTEX GALAXY BANK</span>
                                                            </div>
                                                            <div class="cvv-box" onclick="event.stopPropagation(); toggleCvv(this, '456')" title="Click to show CVV">
                                                                <span class="cvv-label">CVV</span>
                                                                <span class="cvv-value cvv-text">•••</span>
                                                            </div>
                                                        </div>
                                                        <div class="back-extra-info">
                                                            <p class="disclaimer-text">
                                                                This card is property of Vertex Galaxy Bank. Subject to cardholder agreement.
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="back-footer">
                                                        <div class="back-bank-brand">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB" class="back-logo-img">
                                                            <span class="back-bank-name">VERTEX GALAXY BANK</span>
                                                        </div>
                                                        <div class="back-hologram">
                                                            <div class="hologram-seal"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="catalog-specs-table">
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Issuance/Renewal:</span>
                                            <strong class="catalog-spec-value">₹500.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Daily Limit:</span>
                                            <strong class="catalog-spec-value">₹2,00,000.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Validity Period:</span>
                                            <strong class="catalog-spec-value">4 Years</strong>
                                        </div>
                                    </div>

                                    <!-- Features & Usage -->
                                    <div class="catalog-features-col">
                                        <h5 class="catalog-features-heading">Features & Usage:</h5>
                                        <ul class="catalog-features-list">
                                            <li>2 Free Domestic Airport Lounge Access per quarter</li>
                                            <li>Enhanced Purchase Insurance Protection</li>
                                            <li>Zero surcharge on select merchant terminal usage</li>
                                        </ul>
                                    </div>

                                    <!-- Apply Action Button -->
                                    <div class="catalog-action-col">
                                        <button type="button" onclick="openApplyModal('premium_debit')" class="btn-apply-catalog btn btn-primary">
                                            <i class="bx bx-plus-circle"></i> Apply Premium Debit
                                        </button>
                                    </div>
                                </div>

                                <!-- Card 3: Royale Credit -->
                                <div class="product-card product-card-bg-credit-royale">
                                    <div class="product-card-watermark watermark-credit">CREDIT</div>
                                    
                                    <div class="catalog-details-col">
                                        <span class="catalog-spec-badge spec-badge-royale">Royale Tier</span>
                                        <h4 class="catalog-card-title">VGB Royale Credit Card</h4>
                                        <p class="catalog-card-desc">General credit card providing flexible spending margins and revolving outstanding balances.</p>
                                    </div>

                                    <!-- Interactive 3D Card Preview -->
                                    <div class="catalog-card-container">
                                        <div class="catalog-card-wrapper card-3d-wrapper">
                                            <div class="vgb-atm-card credit rupay">
                                                <!-- Front Face -->
                                                <div class="card-face card-front">
                                                    <div class="card-header">
                                                        <div class="bank-info">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png"
                                                                alt="VGB Logo" class="card-bank-logo">
                                                            <div class="bank-name">
                                                                <span class="bank-title">VERTEX</span>
                                                                <span class="bank-subtitle">GALAXY BANK</span>
                                                            </div>
                                                        </div>
                                                        <div class="card-type-label">
                                                            <span class="type-text">credit</span>
                                                            <span class="card-provider-name">rupay</span>
                                                        </div>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="chip-wifi-row">
                                                            <svg class="card-chip-svg" viewBox="0 0 100 80"
                                                                width="36" height="28"
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <rect width="100" height="80" rx="10"
                                                                    fill="url(#chipGoldValC3)" />
                                                                <path
                                                                    d="M 0 30 H 100 M 0 50 H 100 M 40 0 V 80 M 60 0 V 80"
                                                                    stroke="#78350f" stroke-width="1.5" fill="none"
                                                                    opacity="0.4" />
                                                                <defs>
                                                                    <linearGradient id="chipGoldValC3" x1="0%"
                                                                        y1="0%" x2="100%" y2="100%">
                                                                        <stop offset="0%" stop-color="#fbbf24" />
                                                                        <stop offset="50%" stop-color="#d97706" />
                                                                        <stop offset="100%" stop-color="#b45309" />
                                                                    </linearGradient>
                                                                </defs>
                                                            </svg>
                                                            <i class="bx bx-wifi contactless-icon"></i>
                                                        </div>
                                                        <div class="card-number-display">3530 1111 2222 3333</div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <div class="footer-info">
                                                            <span class="footer-label">Card Holder</span>
                                                            <span class="footer-value holder-name-text">ROYALE CUSTOMER</span>
                                                        </div>
                                                        <div class="footer-info expiry-container">
                                                            <span class="footer-label">Expires</span>
                                                            <span class="footer-value">12/30</span>
                                                        </div>
                                                        <div class="card-logo-container">
                                                            <div class="logo-rupay">
                                                                <span class="rupay-text-main">RuPay</span>
                                                                <span class="rupay-sub-main">GLOBAL</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Back Face -->
                                                <div class="card-face card-back">
                                                    <div class="magnetic-strip"></div>
                                                    <div class="back-body">
                                                        <div class="signature-cvv-section">
                                                            <div class="signature-strip">
                                                                <span class="signature-watermark">VERTEX GALAXY BANK</span>
                                                            </div>
                                                            <div class="cvv-box" onclick="event.stopPropagation(); toggleCvv(this, '789')" title="Click to show CVV">
                                                                <span class="cvv-label">CVV</span>
                                                                <span class="cvv-value cvv-text">•••</span>
                                                            </div>
                                                        </div>
                                                        <div class="back-extra-info">
                                                            <p class="disclaimer-text">
                                                                This card is property of Vertex Galaxy Bank. Subject to cardholder agreement.
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="back-footer">
                                                        <div class="back-bank-brand">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB" class="back-logo-img">
                                                            <span class="back-bank-name">VERTEX GALAXY BANK</span>
                                                        </div>
                                                        <div class="back-hologram">
                                                            <div class="hologram-seal"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="catalog-specs-table">
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Issuance/Renewal:</span>
                                            <strong class="catalog-spec-value">₹500.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Credit Limit:</span>
                                            <strong class="catalog-spec-value">₹50,000.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Grace Period:</span>
                                            <strong class="catalog-spec-value">Up to 45 Days</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Validity Period:</span>
                                            <strong class="catalog-spec-value">4 Years</strong>
                                        </div>
                                    </div>

                                    <!-- Features & Usage -->
                                    <div class="catalog-features-col">
                                        <h5 class="catalog-features-heading">Features & Usage:</h5>
                                        <ul class="catalog-features-list">
                                            <li>3 Reward Points per ₹100 spent (redeemable)</li>
                                            <li>1% Fuel Surcharge Waiver at partner outlets</li>
                                            <li>Easy EMI conversion options via Mobile Portal</li>
                                        </ul>
                                    </div>

                                    <!-- Apply Action Button -->
                                    <div class="catalog-action-col">
                                        <button type="button" onclick="openApplyModal('royale_credit')" class="btn-apply-catalog btn btn-primary">
                                            <i class="bx bx-plus-circle"></i> Apply Royale Credit
                                        </button>
                                    </div>
                                </div>

                                <!-- Card 4: Infinite Credit -->
                                <div class="product-card product-card-bg-credit-infinite">
                                    <div class="product-card-watermark watermark-credit">CREDIT</div>
                                    
                                    <div class="catalog-details-col">
                                        <span class="catalog-spec-badge spec-badge-infinite">Infinite Tier</span>
                                        <h4 class="catalog-card-title">VGB Infinite Credit Card</h4>
                                        <p class="catalog-card-desc">Elite premium credit offering featuring extreme credit caps and exclusive lifestyle perks.</p>
                                    </div>

                                    <!-- Interactive 3D Card Preview -->
                                    <div class="catalog-card-container">
                                        <div class="catalog-card-wrapper card-3d-wrapper">
                                            <div class="vgb-atm-card credit visa premium-tier">
                                                <!-- Front Face -->
                                                <div class="card-face card-front">
                                                    <div class="card-header">
                                                        <div class="bank-info">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png"
                                                                alt="VGB Logo" class="card-bank-logo">
                                                            <div class="bank-name">
                                                                <span class="bank-title">VERTEX</span>
                                                                <span class="bank-subtitle">GALAXY BANK</span>
                                                            </div>
                                                        </div>
                                                        <div class="card-type-label">
                                                            <span class="type-text">credit</span>
                                                            <span class="card-provider-name">visa</span>
                                                        </div>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="chip-wifi-row">
                                                            <svg class="card-chip-svg" viewBox="0 0 100 80"
                                                                width="36" height="28"
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <rect width="100" height="80" rx="10"
                                                                    fill="url(#chipGoldValC4)" />
                                                                <path
                                                                    d="M 0 30 H 100 M 0 50 H 100 M 40 0 V 80 M 60 0 V 80"
                                                                    stroke="#78350f" stroke-width="1.5" fill="none"
                                                                    opacity="0.4" />
                                                                <defs>
                                                                    <linearGradient id="chipGoldValC4" x1="0%"
                                                                        y1="0%" x2="100%" y2="100%">
                                                                        <stop offset="0%" stop-color="#fbbf24" />
                                                                        <stop offset="50%" stop-color="#d97706" />
                                                                        <stop offset="100%" stop-color="#b45309" />
                                                                    </linearGradient>
                                                                </defs>
                                                            </svg>
                                                            <i class="bx bx-wifi contactless-icon"></i>
                                                        </div>
                                                        <div class="card-number-display">4111 2222 3333 4444</div>
                                                    </div>
                                                    <div class="card-footer">
                                                        <div class="footer-info">
                                                            <span class="footer-label">Card Holder</span>
                                                            <span class="footer-value holder-name-text">INFINITE CUSTOMER</span>
                                                        </div>
                                                        <div class="footer-info expiry-container">
                                                            <span class="footer-label">Expires</span>
                                                            <span class="footer-value">12/30</span>
                                                        </div>
                                                        <div class="card-logo-container">
                                                            <div class="logo-visa">
                                                                <span class="brand-text">VISA</span>
                                                                <span class="brand-sub">SECURE</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Back Face -->
                                                <div class="card-face card-back">
                                                    <div class="magnetic-strip"></div>
                                                    <div class="back-body">
                                                        <div class="signature-cvv-section">
                                                            <div class="signature-strip">
                                                                <span class="signature-watermark">VERTEX GALAXY BANK</span>
                                                            </div>
                                                            <div class="cvv-box" onclick="event.stopPropagation(); toggleCvv(this, '999')" title="Click to show CVV">
                                                                <span class="cvv-label">CVV</span>
                                                                <span class="cvv-value cvv-text">•••</span>
                                                            </div>
                                                        </div>
                                                        <div class="back-extra-info">
                                                            <p class="disclaimer-text">
                                                                This card is property of Vertex Galaxy Bank. Subject to cardholder agreement.
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="back-footer">
                                                        <div class="back-bank-brand">
                                                            <img src="${pageContext.request.contextPath}/assest/images/image.png" alt="VGB" class="back-logo-img">
                                                            <span class="back-bank-name">VERTEX GALAXY BANK</span>
                                                        </div>
                                                        <div class="back-hologram">
                                                            <div class="hologram-seal"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="catalog-specs-table">
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Issuance/Renewal:</span>
                                            <strong class="catalog-spec-value">₹2,000.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Credit Limit:</span>
                                            <strong class="catalog-spec-value">₹5,00,000.00</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Grace Period:</span>
                                            <strong class="catalog-spec-value">Up to 45 Days</strong>
                                        </div>
                                        <div class="catalog-spec-row">
                                            <span class="catalog-spec-label">Validity Period:</span>
                                            <strong class="catalog-spec-value">4 Years</strong>
                                        </div>
                                    </div>

                                    <!-- Features & Usage -->
                                    <div class="catalog-features-col">
                                        <h5 class="catalog-features-heading">Features & Usage:</h5>
                                        <ul class="catalog-features-list">
                                            <li>24/7 Dedicated Luxury Concierge Assistance</li>
                                            <li>Uncapped international airport lounge access</li>
                                            <li>Comprehensive Travel Insurance up to ₹1 Crore</li>
                                        </ul>
                                    </div>

                                    <!-- Apply Action Button -->
                                    <div class="catalog-action-col">
                                        <button type="button" onclick="openApplyModal('infinite_credit')" class="btn-apply-catalog btn btn-primary">
                                            <i class="bx bx-plus-circle"></i> Apply Infinite Credit
                                        </button>
                                </div>
                            </div>
                        </div>
                    </div>


                            <!-- Table 2: All System Cards (Debit & Credit) -->
                            <div class="glass-card">
                                <div class="card-section-header">
                                    <h3 class="card-section-title">
                                        <i class="bx bx-credit-card-front" style="color: var(--primary-500);"></i> All System Issued Cards Directory
                                    </h3>
                                    <div class="card-section-actions">
                                        <button onclick="openApplyModal('debit')" class="btn btn-primary">
                                            <i class="bx bx-plus-circle"></i> Apply Debit Card
                                        </button>
                                        <button onclick="openApplyModal('credit')" class="btn btn-primary">
                                            <i class="bx bx-plus-circle"></i> Apply Credit Card
                                        </button>
                                    </div>
                                </div>

                                <!-- Client-side real-time filter controls -->
                                <div class="search-filter-wrapper">
                                    <div class="search-input-group">
                                        <i class="bx bx-search search-icon"></i>
                                        <input type="text" id="directorySearchInput" onkeyup="filterDirectoryTable()"
                                            placeholder="Search by card number, holder name...">
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
                                                        <fmt:formatDate var="formattedExpiryDate"
                                                            value="${card.expiryDate}" pattern="MM/yy" />
                                                        <tr>
                                                            <td class="table-sr-no">${status.count}</td>
                                                            <td><span class="badge-id">${card.cardNumber}</span></td>
                                                            <td class="table-holder-name">${card.cardHolderName}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${card.cardType eq 'debit'}">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${card.cardTier eq 'premium'}">
                                                                                <span
                                                                                    class="badge-card-type premium-debit">Premium
                                                                                    Debit</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span
                                                                                    class="badge-card-type classic-debit">Classic
                                                                                    Debit</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${card.cardTier eq 'infinite'}">
                                                                                <span
                                                                                    class="badge-card-type infinite-credit">Infinite
                                                                                    Credit</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span
                                                                                    class="badge-card-type royale-credit">Royale
                                                                                    Credit</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="table-provider">${card.cardProvider}</td>
                                                            <td>
                                                                <fmt:formatDate value="${card.expiryDate}"
                                                                    pattern="yyyy-MM-dd" />
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${card.status eq 'active'}">
                                                                        <span class="status-badge status-badge-active">Active</span>
                                                                    </c:when>
                                                                    <c:when test="${card.status eq 'pending'}">
                                                                        <span class="status-badge status-badge-pending">Pending</span>
                                                                    </c:when>
                                                                    <c:when test="${card.status eq 'expired'}">
                                                                        <span class="status-badge status-badge-expired">Expired</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-badge status-badge-closed">Closed</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="table-actions-cell">
                                                                <c:if test="${card.status eq 'pending'}">
                                                                    <a href="${pageContext.request.contextPath}/card?action=approve&id=${card.cardId}"
                                                                        class="btn-action btn-action-approve">
                                                                        <i class="bx bx-check"></i> Approve
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}"
                                                                        class="btn-action btn-action-reject"
                                                                        onclick="return confirm('Reject and permanently close this card application?');">
                                                                        <i class="bx bx-x"></i> Reject
                                                                    </a>
                                                                </c:if>
                                                                <c:if test="${card.status eq 'active'}">
                                                                    <a href="${pageContext.request.contextPath}/card?action=close&id=${card.cardId}"
                                                                        class="btn-action btn-action-reject"
                                                                        onclick="return confirm('Are you sure you want to permanently close card #${card.cardId}?');">
                                                                        <i class="bx bx-power-off"></i> Close
                                                                    </a>
                                                                </c:if>
                                                                <c:if test="${card.status ne 'pending'}">
                                                                    <a href="${pageContext.request.contextPath}/card?action=renew&cardId=${card.cardId}&csrfToken=${sessionScope.csrfToken}"
                                                                        class="btn-action btn-action-approve"
                                                                        onclick="return confirm('Are you sure you want to renew/reissue card #${card.cardId}?');">
                                                                        <i class="bx bx-refresh"></i> Renew
                                                                    </a>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="8"
                                                            style="text-align: center; padding: 30px; color: var(--gray-400); font-weight: 500;">
                                                            No ATM cards registered in database directory.</td>
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
                <footer class="footer"
                    style="padding: 24px 0; margin-left: 280px; background: white; border-top: 1px solid rgba(99, 102, 241, 0.15);">
                    <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
                        <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; <span
                                data-current-year>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
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

                        // 3D Card Hover Tilt and Gloss Sheen Effect for Catalog Cards
                        const wrappers = document.querySelectorAll('.card-3d-wrapper');
                        wrappers.forEach(wrapper => {
                            const card = wrapper.querySelector('.vgb-atm-card');
                            if (!card) return;

                            const frontFace = wrapper.querySelector('.card-front');
                            const backFace = wrapper.querySelector('.card-back');

                            const shineFront = document.createElement('div');
                            shineFront.className = 'card-shine';
                            if (frontFace) frontFace.appendChild(shineFront);

                            const shineBack = document.createElement('div');
                            shineBack.className = 'card-shine';
                            if (backFace) backFace.appendChild(shineBack);

                            wrapper.addEventListener('mousemove', (e) => {
                                const rect = wrapper.getBoundingClientRect();
                                const x = e.clientX - rect.left;
                                const y = e.clientY - rect.top;

                                const px = x / rect.width;
                                const py = y / rect.height;

                                if (card.classList.contains('flipped')) {
                                    const ry = 180 + (px - 0.5) * 25;
                                    const rx = -(py - 0.5) * 25;
                                    card.style.transform = `rotateY(${ry}deg) rotateX(${rx}deg)`;

                                    const shineX = (1 - px) * 100;
                                    const shineY = py * 100;
                                    if (shineBack) {
                                        shineBack.style.background = `radial-gradient(circle at ${shineX}% ${shineY}%, rgba(255, 255, 255, 0.15) 0%, transparent 60%)`;
                                    }
                                } else {
                                    const ry = (px - 0.5) * 25;
                                    const rx = -(py - 0.5) * 25;
                                    card.style.transform = `rotateY(${ry}deg) rotateX(${rx}deg)`;

                                    const shineX = px * 100;
                                    const shineY = py * 100;
                                    if (shineFront) {
                                        shineFront.style.background = `radial-gradient(circle at ${shineX}% ${shineY}%, rgba(255, 255, 255, 0.15) 0%, transparent 60%)`;
                                    }
                                }
                            });

                            wrapper.addEventListener('mouseleave', () => {
                                card.style.transition = 'transform 0.5s ease';
                                if (card.classList.contains('flipped')) {
                                    card.style.transform = 'rotateY(180deg)';
                                } else {
                                    card.style.transform = 'rotateY(0deg)';
                                }

                                if (shineFront) shineFront.style.background = 'none';
                                if (shineBack) shineBack.style.background = 'none';

                                setTimeout(() => {
                                    card.style.transition = 'transform 0.6s cubic-bezier(0.25, 1, 0.5, 1)';
                                }, 500);
                            });
                        });
                    });

                    let selectedTier = 'classic_debit';

                    function openApplyModal(cardTypeOrTier) {
                        document.getElementById('lookupAccountNumber').value = '';
                        document.getElementById('lookupResultsContainer').style.display = 'none';
                        document.getElementById('lookupResultsList').innerHTML = '';
                        document.getElementById('applyCardForm').style.display = 'none';

                        selectedTier = cardTypeOrTier;
                        updateApplyFormForTier(cardTypeOrTier);

                        document.getElementById('applyModal').style.display = 'flex';
                    }

                    function closeApplyModal() {
                        document.getElementById('applyModal').style.display = 'none';
                    }

                    function escapeHtml(text) {
                        if (!text) return '';
                        return text
                            .replace(/&/g, "&amp;")
                            .replace(/</g, "&lt;")
                            .replace(/>/g, "&gt;")
                            .replace(/"/g, "&quot;")
                            .replace(/'/g, "&#039;");
                    }

                    function fetchCustomerDetails() {
                        const queryVal = document.getElementById('lookupAccountNumber').value.trim();
                        if (!queryVal) {
                            alert('Please enter Account Number, Customer ID, or Name');
                            return;
                        }

                        const resultsContainer = document.getElementById('lookupResultsContainer');
                        const resultsList = document.getElementById('lookupResultsList');
                        const loader = document.getElementById('lookupLoader');
                        const searchIcon = document.getElementById('lookupSearchIcon');

                        if (loader && searchIcon) {
                            loader.style.display = 'inline-block';
                            searchIcon.style.display = 'none';
                        }
                        resultsContainer.style.display = 'none';
                        resultsList.innerHTML = '';
                        document.getElementById('applyCardForm').style.display = 'none';

                        fetch('${pageContext.request.contextPath}/account?action=details&searchQuery=' + encodeURIComponent(queryVal))
                            .then(response => response.json())
                            .then(data => {
                                if (loader && searchIcon) {
                                    loader.style.display = 'none';
                                    searchIcon.style.display = 'inline-block';
                                }
                                if (!data || data.length === 0) {
                                    alert('No customer details found matching search query.');
                                    return;
                                }

                                resultsContainer.style.display = 'block';
                                data.forEach(item => {
                                    const card = document.createElement('div');
                                    card.className = 'lookup-result-card';

                                    card.innerHTML = `
                            <div class="lookup-result-card-title">
                                \${escapeHtml(item.customerName)} | \${item.accountType.toUpperCase()}
                            </div>
                            <div class="lookup-result-card-details">
                                Acc: <span>\${item.accountNumber}</span> | Bal: <span>₹\${parseFloat(item.balance).toLocaleString('en-IN', {minimumFractionDigits: 2})}</span>
                            </div>
                        `;

                                    card.addEventListener('click', () => {
                                        populateCustomerForm(item);
                                        resultsContainer.style.display = 'none';
                                    });
                                    resultsList.appendChild(card);
                                });
                            })
                            .catch(err => {
                                if (loader && searchIcon) {
                                    loader.style.display = 'none';
                                    searchIcon.style.display = 'inline-block';
                                }
                                console.error('Error fetching details:', err);
                                alert('Failed to fetch customer details. Please check the search query.');
                            });
                    }

                    function populateCustomerForm(data) {
                        // Populate form fields
                        document.getElementById('formAccountId').value = data.accountId;
                        document.getElementById('formAccountNumber').value = data.accountNumber;
                        document.getElementById('applyCardHolderName').value = data.customerName;

                        document.getElementById('paperAccountNumberDisplay').textContent = data.accountNumber + ' - ' + data.accountType + ' (Available: ₹ ' + parseFloat(data.balance).toLocaleString('en-IN', { minimumFractionDigits: 2 }) + ')';
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

                        // Trigger calculation of expiry, fee, limits and form labels
                        updateApplyFormForTier(selectedTier);
                    }

                    function updateApplyFormForTier(tier) {
                        // Tiers: 'classic_debit', 'premium_debit', 'royale_credit', 'infinite_credit', 'debit', 'credit'
                        let type = 'debit';
                        let actualTier = 'classic';
                        let fee = '250.00';
                        let heading = 'Classic Debit Card Application Request Form';
                        let subject = 'Request for Classic Debit Card Renewal & Issuance';
                        let detailsHeading = 'Classic Debit Card Details';
                        let limitText = '₹ 50,000.00 / Daily spending limit';

                        if (tier === 'classic_debit') {
                            type = 'debit';
                            actualTier = 'classic';
                            fee = '250.00';
                            heading = 'Classic Debit Card Application Request Form';
                            subject = 'Request for Classic Debit Card Renewal & Issuance';
                            detailsHeading = 'Classic Debit Card Details';
                            limitText = '₹ 50,000.00 / Daily spending limit';
                        } else if (tier === 'premium_debit') {
                            type = 'debit';
                            actualTier = 'premium';
                            fee = '500.00';
                            heading = 'Premium Debit Card Application Request Form';
                            subject = 'Request for Premium Debit Card Renewal & Issuance';
                            detailsHeading = 'Premium Debit Card Details';
                            limitText = '₹ 2,00,000.00 / Daily spending limit';
                        } else if (tier === 'royale_credit') {
                            type = 'credit';
                            actualTier = 'royale';
                            fee = '500.00';
                            heading = 'Royale Credit Card Application Request Form';
                            subject = 'Request for Royale Credit Card Renewal & Issuance';
                            detailsHeading = 'Royale Credit Card Details';
                            limitText = '₹ 50,000.00 / Credit Limit';
                        } else if (tier === 'infinite_credit') {
                            type = 'credit';
                            actualTier = 'infinite';
                            fee = '2000.00';
                            heading = 'Infinite Credit Card Application Request Form';
                            subject = 'Request for Infinite Credit Card Renewal & Issuance';
                            detailsHeading = 'Infinite Credit Card Details';
                            limitText = '₹ 5,00,000.00 / Credit Limit';
                        } else if (tier === 'credit') {
                            type = 'credit';
                            actualTier = 'royale'; // default for credit
                            fee = '500.00';
                            heading = 'Royale Credit Card Application Request Form';
                            subject = 'Request for Royale Credit Card Renewal & Issuance';
                            detailsHeading = 'Royale Credit Card Details';
                            limitText = '₹ 50,000.00 / Credit Limit';
                        } else {
                            // default 'debit' or general
                            type = 'debit';
                            actualTier = 'classic';
                            fee = '250.00';
                            heading = 'Classic Debit Card Application Request Form';
                            subject = 'Request for Classic Debit Card Renewal & Issuance';
                            detailsHeading = 'Classic Debit Card Details';
                            limitText = '₹ 50,000.00 / Daily spending limit';
                        }

                        // Sync checked state in radio group
                        if (tier === 'classic_debit') {
                            document.getElementById('applyTierClassicDebit').checked = true;
                        } else if (tier === 'premium_debit') {
                            document.getElementById('applyTierPremiumDebit').checked = true;
                        } else if (tier === 'royale_credit') {
                            document.getElementById('applyTierRoyaleCredit').checked = true;
                        } else if (tier === 'infinite_credit') {
                            document.getElementById('applyTierInfiniteCredit').checked = true;
                        } else if (type === 'debit') {
                            document.getElementById('applyTierClassicDebit').checked = true;
                        } else {
                            document.getElementById('applyTierRoyaleCredit').checked = true;
                        }

                        // Update hidden form inputs
                        document.getElementById('formCardType').value = type;
                        document.getElementById('formCardTier').value = actualTier;

                        document.getElementById('applyFeeValue').textContent = '₹ ' + fee;
                        document.getElementById('applyFormHeading').textContent = heading;
                        document.getElementById('applyFormSubject').textContent = subject;
                        document.getElementById('applyDetailsBoxHeading').textContent = detailsHeading;
                        document.getElementById('applyLimitValue').textContent = limitText;

                        // Hide/show the radio options based on the selection category
                        const classicDebitEl = document.getElementById('applyClassicDebitWrapper');
                        const premiumDebitEl = document.getElementById('applyPremiumDebitWrapper');
                        const royaleCreditEl = document.getElementById('applyRoyaleCreditWrapper');
                        const infiniteCreditEl = document.getElementById('applyInfiniteCreditWrapper');

                        if (type === 'debit') {
                            if (classicDebitEl) classicDebitEl.style.display = 'inline-flex';
                            if (premiumDebitEl) premiumDebitEl.style.display = 'inline-flex';
                            if (royaleCreditEl) royaleCreditEl.style.display = 'none';
                            if (infiniteCreditEl) infiniteCreditEl.style.display = 'none';
                        } else {
                            if (classicDebitEl) classicDebitEl.style.display = 'none';
                            if (premiumDebitEl) premiumDebitEl.style.display = 'none';
                            if (royaleCreditEl) royaleCreditEl.style.display = 'inline-flex';
                            if (infiniteCreditEl) infiniteCreditEl.style.display = 'inline-flex';
                        }

                        // Calculate expiry date: today + 4 years (MM/YYYY format)
                        const today = new Date();
                        const expiryYear = today.getFullYear() + 4;
                        const expiryMonth = String(today.getMonth() + 1).padStart(2, '0');
                        const expiryDateStr = expiryMonth + ' / ' + expiryYear;

                        const expiryInput = document.querySelector('#applyCardForm input[name="cardExpiry"]');
                        if (expiryInput) {
                            expiryInput.value = expiryDateStr;
                        }
                    }
                </script>

                <!-- Modal: Apply / Renew Card -->
                <div id="applyModal" class="modal">
                    <div class="modal-content"
                        style="max-width: 720px; width: 100%; border-radius: var(--radius-lg); overflow: hidden; display: flex; flex-direction: column;">
                        <div class="modal-header-container">
                            <h3 class="modal-title-text">
                                <i class="bx bx-plus-circle" style="color: var(--primary-500);"></i> Apply Customer ATM Card
                            </h3>
                            <button type="button" onclick="closeApplyModal()" class="modal-close-btn">&times;</button>
                        </div>

                        <div class="lookup-container">
                            <div class="lookup-input-wrapper">
                                <i class="bx bx-search-alt"></i>
                                <input type="text" id="lookupAccountNumber" class="lookup-input"
                                    placeholder="Enter Account Number, Customer ID or Name (e.g. 171931936244)"
                                    onkeypress="if(event.key === 'Enter') fetchCustomerDetails();">
                            </div>
                            <button type="button" onclick="fetchCustomerDetails()" class="btn-lookup"><i
                                    class="bx bx-loader-alt bx-spin" id="lookupLoader" style="display: none;"></i><i
                                    class="bx bx-search-alt" id="lookupSearchIcon"></i> Fetch Details</button>
                        </div>

                        <!-- Lookup Results Container -->
                        <div id="lookupResultsContainer" class="lookup-results-box">
                            <h4 class="lookup-results-title">Search Results</h4>
                            <div id="lookupResultsList" style="display: flex; flex-direction: column;"></div>
                        </div>

                        <!-- Beautiful Paper Form container (hidden by default until details loaded) -->
                        <form id="applyCardForm" action="${pageContext.request.contextPath}/card?action=apply"
                            method="post"
                            style="display: none; padding: 12px 20px; max-height: 70vh; overflow-y: auto; width: 100%; box-sizing: border-box; text-align: left;">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" id="formAccountId" name="accountId" value="">
                            <input type="hidden" id="formAccountNumber" name="accountNumber" value="">
                            <input type="hidden" id="formCardType" name="cardType" value="debit">
                            <input type="hidden" id="formCardTier" name="cardTier" value="classic">

                            <div class="apply-paper-form">
                                <!-- Watermark -->
                                <div class="paper-form-watermark">VGB</div>

                                <!-- Form Header -->
                                <div class="paper-form-header">
                                    <h2 class="paper-form-title">Vertex Galaxy Bank</h2>
                                    <h3 id="applyFormHeading" class="paper-form-subtitle">ATM Card Application Request Form</h3>
                                    <span class="paper-form-fee-badge">
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
                                            Branch: <input type="text" name="branch"
                                                style="width: 250px; border: none; border-bottom: 1px dotted #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; color: #0f172a;"
                                                value="Main Corporate Branch, Mumbai">
                                        </td>
                                        <td style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                            <strong>Date:</strong> <input type="text" name="formDate"
                                                id="applyFormDateStr"
                                                style="width: 120px; border: none; border-bottom: 1px solid #475569; padding: 0 5px; background: transparent; font-weight: 600; font-family: inherit; font-size: inherit; outline: none; text-align: center; color: #0f172a;"
                                                value="" readonly>
                                        </td>
                                    </tr>
                                </table>

                                <div style="margin-bottom: 20px;">
                                    <strong>Subject:</strong> <span id="applyFormSubject"
                                        style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;">Request
                                        for ATM/Debit Card Renewal & Issuance</span>
                                </div>

                                <!-- Customer Information -->
                                <div style="margin-bottom: 20px;">
                                    <h4 class="paper-form-section-title">Customer Information</h4>
                                    <table style="width: 100%; border-collapse: collapse;">
                                        <tr>
                                            <td style="width: 35%; padding: 5px 0;"><strong>Account Holder
                                                    Name:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                <input type="text" id="applyCardHolderName" name="cardHolderName"
                                                    required readonly class="paper-form-input-dotted"
                                                    style="font-family: monospace; font-size: 1rem; text-transform: uppercase;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Account Number:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;"
                                                id="paperAccountNumberDisplay">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Customer ID:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;"
                                                id="paperCustomerIdDisplay">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;"
                                                id="paperMobileDisplay">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Email ID:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1rem; color: #0f172a;"
                                                id="paperEmailDisplay">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong>
                                            </td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: inherit; font-size: 0.9rem; color: #0f172a; white-space: normal; word-break: break-word;"
                                                id="paperAddressDisplay">
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                                <!-- Card Details Box -->
                                <div style="margin-bottom: 25px;">
                                    <h4 id="applyDetailsBoxHeading" class="paper-form-section-title">
                                        ATM/Debit Card Details</h4>
                                    <table style="width: 100%; border-collapse: collapse;">
                                        <tr>
                                            <td style="width: 45%; padding: 5px 0;"><strong>Existing ATM/Debit Card
                                                    (Last 4 Digits):</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                <input type="text" name="existingCardLast4" readonly
                                                    style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 1.05rem; outline: none; background: transparent; color: #0f172a;"
                                                    value="N/A (NEW CARD APPLICATION)">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Card Expiry Date:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                                <input type="text" name="cardExpiry" readonly
                                                    style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; font-family: monospace; outline: none; background: transparent; color: #0f172a;"
                                                    value="____ / ____">
                                            </td>
                                        </tr>
                                        <tr id="applyLimitRow">
                                            <td style="padding: 5px 0;"><strong>Card Limits:</strong></td>
                                            <td style="border-bottom: 1px dotted #475569; padding: 5px 8px; font-weight: 600; font-family: monospace; font-size: 0.95rem; color: #0f172a;"
                                                id="applyLimitValue">
                                                ₹50,000 / Day
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Card Category:</strong></td>
                                            <td
                                                style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                                <!-- Debit Options -->
                                                <label id="applyClassicDebitWrapper"
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                                    <input type="radio" id="applyTierClassicDebit"
                                                        name="cardProductRadio" value="classic_debit" checked
                                                        onchange="updateApplyFormForTier('classic_debit')"
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    Classic Debit (Fee: ₹250)
                                                </label>
                                                <label id="applyPremiumDebitWrapper"
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                                    <input type="radio" id="applyTierPremiumDebit"
                                                        name="cardProductRadio" value="premium_debit"
                                                        onchange="updateApplyFormForTier('premium_debit')"
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    Premium Debit (Fee: ₹500)
                                                </label>
                                                <!-- Credit Options -->
                                                <label id="applyRoyaleCreditWrapper"
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                                    <input type="radio" id="applyTierRoyaleCredit"
                                                        name="cardProductRadio" value="royale_credit"
                                                        onchange="updateApplyFormForTier('royale_credit')"
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    Royale Credit (Fee: ₹500)
                                                </label>
                                                <label id="applyInfiniteCreditWrapper"
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; font-size: 0.85rem; color: #475569;">
                                                    <input type="radio" id="applyTierInfiniteCredit"
                                                        name="cardProductRadio" value="infinite_credit"
                                                        onchange="updateApplyFormForTier('infinite_credit')"
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    Infinite Credit (Fee: ₹2,000)
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 5px 0;"><strong>Card Network:</strong></td>
                                            <td
                                                style="padding: 5px 8px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                                                <label
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                    <input type="radio" name="cardProvider" id="applyProviderVisa"
                                                        value="visa" checked
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    Visa
                                                </label>
                                                <label
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                    <input type="radio" name="cardProvider" id="applyProviderMastercard"
                                                        value="mastercard"
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    MasterCard
                                                </label>
                                                <label
                                                    style="display: inline-flex; align-items: center; gap: 4px; font-weight: 600; cursor: pointer;">
                                                    <input type="radio" name="cardProvider" id="applyProviderRuPay"
                                                        value="rupay"
                                                        style="width: 13px; height: 13px; margin: 0; cursor: pointer;">
                                                    RuPay
                                                </label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                                <!-- Signatures Row -->
                                <div
                                    style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                                    <div>
                                        <span
                                            style="display: block; font-size: 0.8rem; font-style: italic; color: #3b82f6; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 1.4rem; padding-bottom: 5px;"
                                            id="applyFormSignature"></span>
                                        <span
                                            style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer
                                            Signature</span>
                                    </div>
                                    <div style="text-align: right;">
                                        <span
                                            style="display: block; font-family: monospace; font-size: 0.95rem; font-weight: 600; color: #0f172a; text-transform: uppercase; padding-bottom: 5px;"
                                            id="applyFormNameLabel"></span>
                                        <span
                                            style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Name</span>
                                    </div>
                                </div>
                            </div>

                            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                                <button type="button" onclick="closeApplyModal()" class="btn btn-danger">Cancel</button>
                                <button type="submit" class="btn btn-primary">Submit Application</button>
                            </div>
                        </form>
                    </div>
                </div>
            </body>

            </html>