<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Accounts</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.7" rel="stylesheet">
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.45);
            --glass-border: rgba(99, 102, 241, 0.08);
            --card-glow: rgba(99, 102, 241, 0.04);
            --panel-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
        }

        body {
            background-color: #f6f8fc !important;
            color: var(--gray-700) !important;
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
        }
        
        body.dark-mode {
            --glass-bg: rgba(30, 41, 59, 0.45);
            --glass-border: rgba(255, 255, 255, 0.08);
            --card-glow: rgba(99, 102, 241, 0.1);
            --panel-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            background-color: #0f172a !important;
        }

        /* Preloader styling fixes to match dashboard design */
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
            background: radial-gradient(circle, rgba(99, 102, 241, 0.08) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            z-index: 1;
            transition: left 0.1s ease-out, top 0.1s ease-out;
        }
        body.dark-mode .cursor-glow {
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
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

        /* Search & toolbar items */
        .search-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .search-box {
            position: relative;
            flex-grow: 1;
            min-width: 280px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.2rem;
        }

        .search-box input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            background: var(--white);
            color: var(--gray-800);
            transition: all var(--transition-normal);
        }

        body.dark-mode .search-box input {
            border-color: rgba(255, 255, 255, 0.1);
        }

        .search-box input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        /* --- TABLE STYLING --- */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
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
        }

        body.dark-mode th {
            color: var(--gray-400);
        }

        td {
            padding: 18px 20px;
            font-size: 0.875rem;
            color: var(--gray-700);
            border-bottom: 1px solid rgba(99, 102, 241, 0.05);
            vertical-align: middle;
            white-space: nowrap;
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

        /* --- MONOSPACE ID BADGE --- */
        .badge-id {
            font-family: 'Courier New', Courier, monospace;
            font-weight: 700;
            font-size: 0.8rem;
            background: rgba(99, 102, 241, 0.06);
            color: var(--primary-500);
            padding: 5px 10px;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(99, 102, 241, 0.08);
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        body.dark-mode .badge-id {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-300);
        }

        /* Custom circle table actions */
        .btn-action-circle {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: 1px solid var(--gray-200);
            background: var(--white);
            color: var(--gray-600);
            cursor: pointer;
            transition: all var(--transition-fast);
            font-size: 1rem;
            text-decoration: none;
        }

        body.dark-mode .btn-action-circle {
            border-color: rgba(255, 255, 255, 0.08);
            background: rgba(30, 41, 59, 0.5);
            color: var(--gray-300);
        }

        .btn-action-circle:hover {
            transform: scale(1.1);
            color: white !important;
        }

        .btn-action-view:hover {
            border-color: var(--primary-500);
            background: var(--primary-500);
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.3);
        }

        .btn-action-edit:hover {
            border-color: var(--accent-cyan);
            background: var(--accent-cyan);
            box-shadow: 0 4px 10px rgba(6, 182, 212, 0.3);
        }

        .btn-action-block:hover {
            border-color: var(--accent-amber);
            background: var(--accent-amber);
            box-shadow: 0 4px 10px rgba(245, 158, 11, 0.3);
        }

        .btn-action-delete:hover {
            border-color: #ef4444;
            background: #ef4444;
            box-shadow: 0 4px 10px rgba(239, 68, 68, 0.3);
        }

        /* Statuses */
        .status-pill-active {
            background: rgba(16, 185, 129, 0.12);
            color: var(--accent-emerald);
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .status-pill-closed {
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        /* Modals and Overlays */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1000;
            background: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(12px);
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-y: auto;
        }

        .modal-content {
            background: var(--white);
            color: var(--gray-800);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 900px;
            max-height: 90vh;
            overflow-y: auto;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-2xl);
            position: relative;
            animation: modalFadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
        
        body.dark-mode .modal-content {
            background: rgba(30, 41, 59, 0.95) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
        }

        .modal-large {
            max-width: 1100px;
        }

        .modal-header {
            padding: 20px 30px;
            border-bottom: 1px solid var(--gray-100);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            background: var(--white);
            z-index: 10;
        }
        
        body.dark-mode .modal-header {
            background: rgba(30, 41, 59, 0.98) !important;
            border-bottom-color: rgba(255, 255, 255, 0.08) !important;
        }

        .modal-body {
            padding: 30px;
        }

        .modal-footer {
            padding: 20px 30px;
            border-top: 1px solid var(--gray-100);
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            position: sticky;
            bottom: 0;
            background: var(--white);
            z-index: 10;
        }
        
        body.dark-mode .modal-footer {
            background: rgba(30, 41, 59, 0.98) !important;
            border-top-color: rgba(255, 255, 255, 0.08) !important;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: scale(0.95) translateY(10px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        .close-modal-btn {
            font-size: 1.5rem;
            color: var(--gray-400);
            background: none;
            border: none;
            cursor: pointer;
            transition: color var(--transition-normal);
        }

        .close-modal-btn:hover {
            color: #ef4444;
        }

        /* Forms inside modals styling */
        .form-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        @media (min-width: 768px) {
            .form-row.row-2 {
                grid-template-columns: 1fr 1fr;
            }
            .form-row.row-3 {
                grid-template-columns: 1fr 1fr 1fr;
            }
        }

        .form-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--gray-500);
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 11px 15px;
            border: 1.5px solid var(--gray-200);
            background: var(--white);
            color: var(--gray-800);
            border-radius: var(--radius-md);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        body.dark-mode .form-group input,
        body.dark-mode .form-group select,
        body.dark-mode .form-group textarea {
            border-color: rgba(255, 255, 255, 0.1);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }

        /* Signatories partners details box */
        .partner-card {
            background: rgba(99, 102, 241, 0.02);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-bottom: 20px;
            position: relative;
        }
        
        body.dark-mode .partner-card {
            background: rgba(255, 255, 255, 0.01);
        }

        .remove-partner-btn {
            position: absolute;
            right: 20px;
            top: 20px;
            color: #ef4444;
            font-size: 1.35rem;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .remove-partner-btn:hover {
            transform: scale(1.1);
        }

        /* Wizard Node Progress */
        .step-progress-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 55px;
            position: relative;
            counter-reset: step;
        }

        .step-progress-line-wrapper {
            position: absolute;
            top: 20px;
            left: 22px;
            right: 22px;
            height: 4px;
            z-index: 1;
        }

        .step-progress-line-bg {
            position: absolute;
            inset: 0;
            background: var(--gray-200);
            border-radius: 2px;
        }
        
        body.dark-mode .step-progress-line-bg {
            background: rgba(255, 255, 255, 0.1);
        }

        .step-indicator-line {
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            background: var(--gradient-primary);
            z-index: 2;
            width: 0%;
            transition: width 0.4s ease;
            border-radius: 2px;
        }

        .step-node {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--white);
            border: 3.5px solid var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: var(--gray-400);
            position: relative;
            z-index: 3;
            transition: all 0.4s ease;
            counter-increment: step;
        }

        body.dark-mode .step-node {
            background: #1e293b;
            border-color: rgba(255, 255, 255, 0.1);
        }

        .step-node::before {
            content: counter(step);
        }

        .step-node.active {
            border-color: var(--primary-500);
            color: var(--primary-500);
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.3);
        }

        .step-node.completed {
            border-color: var(--accent-emerald);
            background: var(--accent-emerald);
            color: white;
        }

        .step-node.completed::before {
            content: '✓';
            font-size: 1.1rem;
        }

        .step-node-label {
            position: absolute;
            top: 50px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.72rem;
            font-weight: 600;
            white-space: nowrap;
            color: var(--gray-400);
            text-transform: uppercase;
        }

        .step-node.active .step-node-label {
            color: var(--primary-500);
        }

        .step-node.completed .step-node-label {
            color: var(--accent-emerald);
        }

        .wizard-step {
            display: none;
        }

        .wizard-step.active {
            display: block;
        }

        /* 3D Visualizers Grid */
        .visualizer-preview-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
            margin-top: 20px;
        }

        @media (min-width: 768px) {
            .visualizer-preview-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        .visualizer-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: rgba(99, 102, 241, 0.02);
            border: 1.5px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 35px 20px;
            min-height: 250px;
            position: relative;
            perspective: 1200px;
        }

        /* ATM Cards 3D visualizers */
        .vgb-atm-card {
            width: 320px;
            height: 200px;
            position: relative;
            transform-style: preserve-3d;
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
            border-radius: 16px;
            cursor: pointer;
        }

        .vgb-atm-card.flipped {
            transform: rotateY(180deg);
        }

        .vgb-atm-card .card-face {
            position: absolute;
            inset: 0;
            padding: 20px;
            backface-visibility: hidden;
            border-radius: inherit;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-sizing: border-box;
        }

        .vgb-atm-card .card-front {
            z-index: 2;
        }

        .vgb-atm-card .card-back {
            transform: rotateY(180deg);
            z-index: 1;
            background: #080b11;
            padding: 20px;
            color: #ffffff;
        }

        .vgb-atm-card.visa {
            background: linear-gradient(135deg, #091326 0%, #030611 100%);
            box-shadow: 0 12px 25px rgba(29, 78, 216, 0.25);
        }

        .vgb-atm-card.visa .card-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 100% 0%, rgba(99, 102, 241, 0.35) 0%, transparent 60%),
                linear-gradient(125deg, transparent 40%, rgba(255, 255, 255, 0.18) 47%, rgba(255, 255, 255, 0.32) 50%, rgba(255, 255, 255, 0.18) 53%, transparent 60%);
            pointer-events: none;
            z-index: 1;
            border-radius: inherit;
        }

        .vgb-atm-card.mastercard {
            background: radial-gradient(circle at 75% 35%, #181105 0%, #000000 75%);
            box-shadow: 0 12px 25px rgba(191, 149, 63, 0.15);
        }

        .vgb-atm-card.mastercard .card-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 75% 35%, rgba(254, 240, 138, 0.35) 0%, rgba(202, 138, 4, 0.2) 20%, rgba(113, 63, 18, 0.05) 40%, transparent 65%),
                repeating-radial-gradient(ellipse 220px 110px at 75% 35%, transparent 0px, transparent 12px, rgba(217, 119, 6, 0.03) 15px, transparent 18px);
            pointer-events: none;
            transform: rotate(-15deg);
            z-index: 1;
            border-radius: inherit;
        }

        .vgb-atm-card.rupay {
            background: linear-gradient(135deg, #050d24 0%, #0c0822 50%, #030209 100%);
            box-shadow: 0 12px 25px rgba(99, 102, 241, 0.2);
        }

        .vgb-atm-card.rupay .card-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 10% 85%, rgba(59, 130, 246, 0.22) 0%, transparent 55%),
                radial-gradient(circle at 80% 15%, rgba(139, 92, 246, 0.18) 0%, transparent 55%),
                linear-gradient(55deg, transparent 30%, rgba(99, 102, 241, 0.12) 45%, rgba(236, 72, 153, 0.15) 55%, transparent 70%);
            pointer-events: none;
            z-index: 1;
            border-radius: inherit;
        }

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
        }

        .card-bank-name-stack .bank-subtitle {
            font-size: 0.45rem;
            font-weight: 600;
            letter-spacing: 1px;
            color: rgba(255, 255, 255, 0.7);
        }

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

        .brand-visa {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            line-height: 1;
        }

        .brand-visa .visa-text {
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
            font-size: 1.1rem;
            font-weight: 800;
            font-style: italic;
            color: #ffffff;
            letter-spacing: 0.5px;
        }

        .brand-rupay .rupay-sub {
            font-size: 0.45rem;
            font-weight: 700;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.8);
            letter-spacing: 0.5px;
            margin-top: -1px;
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

        .card-back-magnetic-strip {
            height: 35px;
            background: #000000;
            margin: 0 -20px;
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
            line-height: 1.2;
        }

        .signature-strip-text span {
            font-size: 0.45rem;
            font-weight: 700;
            color: #475569;
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

        .mc-hologram {
            width: 30px;
            height: 20px;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
            border-radius: 3px;
            opacity: 0.8;
            box-shadow: 0 0 4px rgba(255, 255, 255, 0.1);
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
        }

        .logo-text-stacked .text-bottom {
            font-size: 0.35rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            color: rgba(255, 255, 255, 0.7);
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

        /* 3D Cheque */
        .vgb-cheque-3d {
            width: 330px;
            aspect-ratio: 2.38 / 1;
            background: linear-gradient(to right, #bae6fd, #e0f2fe);
            border: 1px solid #93c5fd;
            border-radius: 8px;
            padding: 10px 14px;
            color: #334155;
            font-size: 0.55rem;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.1);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.5s ease;
            transform-style: preserve-3d;
            cursor: pointer;
        }

        .vgb-cheque-3d:hover {
            transform: translateY(-3px) rotateX(4deg);
        }

        .vgb-cheque-3d .cheque-hologram {
            position: absolute;
            left: 12px;
            top: 0;
            bottom: 0;
            width: 14px;
            background: linear-gradient(90deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
            border-left: 1px solid rgba(255, 255, 255, 0.2);
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            opacity: 0.85;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.05);
            z-index: 2;
        }

        .vgb-cheque-3d .cheque-hologram::after {
            content: '';
            position: absolute;
            inset: 0;
            background: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(255, 255, 255, 0.15) 5px, rgba(255, 255, 255, 0.15) 10px);
        }

        .vgb-cheque-3d .cheque-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            z-index: 3;
            margin-left: 14px;
        }

        .vgb-cheque-3d .cheque-bank-info {
            display: flex;
            flex-direction: column;
        }

        .vgb-cheque-3d .cheque-bank-name {
            font-weight: 800;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
            color: #1e3a8a;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .vgb-cheque-3d .cheque-branch-details {
            font-size: 0.45rem;
            color: #475569;
            line-height: 1.3;
            margin-top: 2px;
        }

        .vgb-cheque-3d .cheque-date-box {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .vgb-cheque-3d .date-squares {
            display: flex;
            gap: 1.5px;
            margin-bottom: 2px;
        }

        .vgb-cheque-3d .date-squares span {
            width: 12px;
            height: 14px;
            border: 1px solid #1e3a8a;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.5rem;
            font-weight: 600;
            color: #1e3a8a;
            border-radius: 1px;
        }

        .vgb-cheque-3d .cheque-row {
            display: flex;
            align-items: flex-end;
            margin: 4px 0;
            z-index: 3;
            margin-left: 14px;
        }

        .vgb-cheque-3d .cheque-label {
            font-weight: bold;
            font-size: 0.62rem;
            color: #1e3a8a;
            white-space: nowrap;
            display: flex;
            align-items: baseline;
            gap: 3px;
        }

        .vgb-cheque-3d .hindi-text {
            font-size: 0.55rem;
            font-weight: normal;
            color: #64748b;
        }

        .vgb-cheque-3d .cheque-line-fill {
            flex: 1;
            border-bottom: 1.5px dotted #64748b;
            margin: 0 8px;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.8rem;
            font-style: italic;
            font-weight: 700;
            color: #0f172a;
            padding-bottom: 1px;
            padding-left: 5px;
            letter-spacing: 0.5px;
        }

        .vgb-cheque-3d .bearer-text {
            font-size: 0.52rem !important;
        }

        .vgb-cheque-3d .cheque-amount-box {
            width: 100px;
            height: 24px;
            border: 1.5px solid #1e3a8a;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 0 6px;
            position: relative;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .vgb-cheque-3d .rupee-symbol {
            font-size: 0.8rem;
            font-weight: 800;
            color: #1e3a8a;
            border-right: 1.5px solid #1e3a8a;
            padding-right: 4px;
            height: 100%;
            display: flex;
            align-items: center;
        }

        .vgb-cheque-3d .amount-val {
            flex: 1;
            font-family: monospace;
            font-size: 0.8rem;
            font-weight: 700;
            text-align: right;
            letter-spacing: 0.5px;
            color: #0f172a;
        }

        .vgb-cheque-3d .cheque-details-row {
            display: grid;
            grid-template-columns: 1.4fr 0.6fr 1.2fr 1.2fr;
            gap: 8px;
            align-items: flex-end;
            margin-top: 6px;
            z-index: 3;
            margin-left: 14px;
        }

        .vgb-cheque-3d .cheque-acc-box {
            border: 1.5px solid #1e3a8a;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 2px 6px;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .vgb-cheque-3d .acc-label {
            font-size: 0.45rem;
            font-weight: bold;
            color: #1e3a8a;
            border-right: 1px solid #cbd5e1;
            padding-right: 4px;
            margin-right: 4px;
            line-height: 1.2;
            white-space: nowrap;
        }

        .vgb-cheque-3d .acc-val {
            font-family: monospace;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: #0f172a;
        }

        .vgb-cheque-3d .cheque-branch-codes {
            font-size: 0.45rem;
            color: #475569;
            font-family: monospace;
            line-height: 1.2;
            font-weight: 600;
        }

        .vgb-cheque-3d .cheque-payable-text {
            font-size: 0.4rem;
            color: #64748b;
            line-height: 1.2;
            border-left: 1px solid #cbd5e1;
            padding-left: 6px;
        }

        .vgb-cheque-3d .cheque-sign-area {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            text-align: right;
            padding-bottom: 2px;
        }

        .vgb-cheque-3d .cheque-sign-name {
            font-family: 'Brush Script MT', cursive, sans-serif;
            font-size: 1.1rem;
            font-style: italic;
            color: #2563eb;
            margin-bottom: 2px;
            font-weight: 500;
            letter-spacing: 0.5px;
            max-width: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .vgb-cheque-3d .cheque-sign-label {
            font-size: 0.45rem;
            color: #475569;
            font-weight: bold;
        }

        .vgb-cheque-3d .cheque-micr-band {
            text-align: center;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 2px;
            color: #0f172a;
            margin-top: 10px;
            margin-bottom: 2px;
            border-top: 1px dashed rgba(99, 102, 241, 0.1);
            padding-top: 6px;
            z-index: 3;
            margin-left: 14px;
        }

        /* 3D Passbook Booklet */
        .passbook-wrapper {
            width: 280px;
            height: 180px;
            position: relative;
            transform-style: preserve-3d;
            cursor: pointer;
            perspective: 800px;
        }

        .passbook-book {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateX(12deg) rotateY(-18deg);
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
        }

        .passbook-book::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 10px;
            background: linear-gradient(90deg, rgba(0, 0, 0, 0.5) 0%, rgba(255, 255, 255, 0.15) 30%, rgba(0, 0, 0, 0.2) 100%);
            z-index: 50;
            border-radius: 8px 0 0 8px;
        }

        .passbook-cover-wrapper {
            position: absolute;
            inset: 0;
            transform-origin: left center;
            transform-style: preserve-3d;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 30;
        }

        .passbook-book.open .passbook-cover-wrapper {
            transform: rotateY(-155deg);
        }

        .passbook-cover-front {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            background: radial-gradient(circle at 30% 30%, #1e1b4b 0%, #0c0a21 65%, #02000a 100%);
            border-radius: 8px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 2;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .passbook-cover-inside {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            transform: rotateY(180deg);
            background: linear-gradient(135deg, #0f0b29 0%, #03010f 100%);
            border-radius: 8px;
            padding: 15px;
            color: #e2e8f0;
            z-index: 1;
            font-size: 0.5rem;
        }

        .passbook-page {
            position: absolute;
            width: 98%;
            height: 96%;
            top: 2%;
            left: 1%;
            background: #faf8f5;
            border-radius: 4px 8px 8px 4px;
            padding: 15px;
            color: #334155;
            z-index: 20;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: inset 3px 0 10px rgba(0, 0, 0, 0.15);
        }

        /* Statement Meta Grid */
        .statement-meta-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }

        @media (min-width: 768px) {
            .statement-meta-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        .statement-ledger-section {
            margin-top: 15px;
        }

        .txn-deposit {
            color: var(--accent-emerald) !important;
        }

        .txn-withdrawal {
            color: var(--secondary-500) !important;
        }

        .txn-fee {
            color: var(--accent-amber) !important;
        }

        /* Print styling */
        @media print {
            .sidebar,
            .header,
            .no-print,
            .close-modal-btn,
            .modal-footer,
            #themeToggle {
                display: none !important;
            }

            .modal {
                position: absolute !important;
                background: white !important;
                padding: 0 !important;
                display: block !important;
                box-shadow: none !important;
                overflow: visible !important;
            }

            .modal-content {
                box-shadow: none !important;
                border: none !important;
                max-width: 100% !important;
                max-height: 100% !important;
                overflow: visible !important;
            }

            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
            }

            .statement-meta-grid {
                grid-template-columns: 1fr 1fr !important;
                display: grid !important;
                margin-bottom: 25px !important;
            }
        }

        /* Footer margin fix */
        .footer {
            margin-left: 280px;
            background: var(--white) !important;
            border-top: 1px solid var(--glass-border) !important;
            padding: 24px 0;
            transition: all 0.3s ease;
        }
        
        body.dark-mode .footer {
            background: rgba(15, 23, 42, 0.8) !important;
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
    <header class="header scrolled no-print">
        <div style="display: flex; align-items: center; gap: 15px;">
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation" style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                <i class="bx bx-menu"></i>
            </button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
            </a>
        </div>
        <div class="nav-actions">
            <div style="display: flex; align-items: center; gap: 8px;">
                <img src="${pageContext.request.contextPath}/assest/images/profile-logo.png" alt="Admin Profile Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--primary-500);">
                <span style="font-weight: 600; color: var(--gray-700);" class="admin-label"><i class="bx bx-shield-quarter"></i> Admin Workspace</span>
            </div>
            <button class="theme-toggle" id="themeToggle" type="button"><i class="bx bx-moon"></i></button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary" style="padding: 8px 18px; font-size: 0.8rem;"><i class="bx bx-log-out"></i> Logout</a>
        </div>
    </header>

    <!-- Sidebar Navigation -->
    <aside class="sidebar no-print">
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bx bx-grid-alt"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/account?action=list" class="active"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
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
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="no-print">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Manage Accounts</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Monitor customer records, issue and update corporate assets, and review statements.</p>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div style="background: rgba(239, 68, 68, 0.1); border-left: 4px solid #ef4444; color: #b91c1c; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;" class="no-print">
                    <i class="bx bx-error-circle" style="font-size: 1.2rem;"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="background: rgba(16, 185, 129, 0.1); border-left: 4px solid #10b981; color: #047857; padding: 12px 15px; border-radius: var(--radius-sm); margin-bottom: 25px; font-size: 0.875rem; display: flex; align-items: center; gap: 10px;" class="no-print">
                    <i class="bx bx-check-circle" style="font-size: 1.2rem;"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px;" class="no-print">
                <div class="stat-card" style="border-left: 5px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-group"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Total Customers</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalCustomers}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-cyan);">
                    <div class="stat-icon" style="background: rgba(6, 182, 212, 0.1); color: var(--accent-cyan);">
                        <i class="bx bx-user"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings (Single)</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalSavingsSingle}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.1); color: var(--secondary-500);">
                        <i class="bx bx-group-work"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Savings (Joint)</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalSavingsJoint}</strong>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 5px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald);">
                        <i class="bx bx-briefcase"></i>
                    </div>
                    <div>
                        <span style="display: block; font-size: 0.75rem; color: var(--gray-400); text-transform: uppercase; font-weight: 600;">Current Accounts</span>
                        <strong style="font-size: 1.6rem; color: var(--gray-800);">${totalCurrent}</strong>
                    </div>
                </div>
            </div>

            <!-- Customer List Table Card -->
            <div class="glass-card">
                <div class="search-container no-print">
                    <div class="search-box">
                        <i class="bx bx-search"></i>
                        <input type="text" id="accountSearchInput" placeholder="Search customer ID, account number, or name..." onkeyup="filterAccountsTable()">
                    </div>
                    <button class="btn btn-primary" onclick="openWizardModal()" style="display: inline-flex; align-items: center; gap: 8px;">
                        <i class="bx bx-plus-circle" style="font-size: 1.1rem;"></i>
                        <span>Create New Account</span>
                    </button>
                </div>

                <div class="table-responsive">
                    <table id="accountsTable">
                        <thead>
                            <tr>
                                <th>Sr No.</th>
                                <th>Customer ID</th>
                                <th>Customer Name</th>
                                <th>Account Number</th>
                                <th>Account Type</th>
                                <th style="text-align: right;">Total Balance</th>
                                <th style="text-align: center;">Status</th>
                                <th style="text-align: center;">Statement</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}" varStatus="status">
                                        <tr class="account-row-data">
                                            <td style="font-weight: 600; color: var(--gray-500);">${status.index + 1}</td>
                                            <td><span class="badge-id td-cust-id">#CUST-${acc.customerId}</span></td>
                                            <td style="font-weight: 600; color: var(--gray-800);" class="td-cust-name">${acc.customerName}</td>
                                            <td><span class="badge-id td-acc-num">${acc.accountNumber}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${acc.accountType eq 'savings'}">
                                                        <span style="color: var(--primary-500); background: rgba(99, 102, 241, 0.1); padding: 4px 8px; border-radius: var(--radius-sm); font-weight: 600; font-size: 0.8rem;">Savings</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--accent-emerald); background: rgba(16, 185, 129, 0.1); padding: 4px 8px; border-radius: var(--radius-sm); font-weight: 600; font-size: 0.8rem;">Current</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right; font-weight: 700; color: var(--gray-800);">
                                                ₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2" />
                                            </td>
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${acc.status eq 'active'}">
                                                        <span class="status-pill-active">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill-closed">${acc.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center;">
                                                <button type="button" class="btn btn-primary"
                                                    style="padding: 8px 14px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600; display: inline-flex; align-items: center; gap: 4px; border: none;"
                                                    onclick="openStatementModal(Number('${acc.accountId}'), '${acc.customerName}', '${acc.accountNumber}', '${acc.accountType}', Number('${acc.balance}'), '${acc.status}')">
                                                    <i class="bx bx-receipt"></i> View Statement
                                                </button>
                                            </td>
                                            <td style="text-align: center;">
                                                <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                    <button type="button" class="btn-action-circle btn-action-view" title="View Details" onclick="openViewModal(Number('${status.index}'))">
                                                        <i class="bx bx-show"></i>
                                                    </button>
                                                    <button type="button" class="btn-action-circle btn-action-edit" title="Edit Account" onclick="openEditModal(Number('${status.index}'))">
                                                        <i class="bx bx-edit"></i>
                                                    </button>
                                                    <c:if test="${acc.status ne 'closed'}">
                                                        <button type="button" class="btn-action-circle btn-action-block" title="Close Account" onclick="openCloseModal(Number('${status.index}'))">
                                                            <i class="bx bx-block"></i>
                                                        </button>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/account?action=delete&id=${acc.accountId}" class="btn-action-circle btn-action-delete" title="Delete Profile" onclick="return confirm('WARNING: Are you sure you want to delete account ${acc.accountNumber} and all associated signatories permanently?');">
                                                        <i class="bx bx-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 40px; color: var(--gray-400); font-style: italic;">
                                            <i class="bx bx-info-circle" style="font-size: 2.5rem; display: block; margin-bottom: 15px;"></i>
                                            No bank accounts registered in the database ledger.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>

    <!-- ==========================================
         VIEW ACCOUNT MODAL
         ========================================== -->
    <div class="modal" id="viewAccountModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-user" style="color: var(--primary-500);"></i> Account Details Summary
                </h3>
                <button type="button" class="close-modal-btn" onclick="closeModal('viewAccountModal')"><i class="bx bx-x"></i></button>
            </div>
            <div class="modal-body" id="viewModalBody">
                <!-- Dynamically populated via JS -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('viewAccountModal')">Close</button>
            </div>
        </div>
    </div>

    <!-- ==========================================
         EDIT ACCOUNT MODAL
         ========================================== -->
    <div class="modal" id="editAccountModal">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/account?action=edit" method="POST">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="accountId" id="editAccountId">

                <div class="modal-header">
                    <h3 style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                        <i class="bx bx-edit" style="color: var(--accent-cyan);"></i> Edit Account Parameters
                    </h3>
                    <button type="button" class="close-modal-btn" onclick="closeModal('editAccountModal')"><i class="bx bx-x"></i></button>
                </div>
                <div class="modal-body">
                    <div class="form-row row-2">
                        <div class="form-group">
                            <label>IFSC Code</label>
                            <input type="text" name="ifscCode" id="editIfsc" required>
                        </div>
                        <div class="form-group">
                            <label>Ledger Status</label>
                            <select name="status" id="editStatus">
                                <option value="active">Active</option>
                                <option value="frozen">Frozen</option>
                                <option value="dormant">Dormant</option>
                                <option value="closed">Closed</option>
                            </select>
                        </div>
                    </div>

                    <div style="margin: 25px 0; background: rgba(99, 102, 241, 0.02); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border);">
                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px;">
                            <i class="bx bx-chip"></i> Enabled Services Options
                        </h4>
                        <div style="display:flex; gap:30px; flex-wrap:wrap;">
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                <input type="checkbox" name="atmCard" id="editAtmCard" value="on"> ATM Debit Card
                            </label>
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                <input type="checkbox" name="chequeBook" id="editChequeBook" value="on"> Cheque Book Request
                            </label>
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                <input type="checkbox" name="passbook" id="editPassbook" value="on"> Offline Passbook
                            </label>
                        </div>
                    </div>

                    <!-- Savings Specific Edit Controls -->
                    <div id="savingsEditFields" style="display:none;">
                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                            Savings Terms
                        </h4>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Nominee Name</label>
                                <input type="text" name="nomineeName" id="editNominee">
                            </div>
                            <div class="form-group">
                                <label>Holding Mode</label>
                                <select name="holdingType" id="editHoldingType" onchange="toggleEditHoldingType()">
                                    <option value="single">Single Owner</option>
                                    <option value="joint">Joint Account</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Daily Cash Limit (₹)</label>
                                <input type="number" step="0.01" name="dailyWithdrawalLimit" id="editDailyLimit">
                            </div>
                        </div>

                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-top:20px; margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                            Primary Holder Personal Details
                        </h4>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>First Name *</label>
                                <input type="text" name="firstName" id="editFirstName">
                            </div>
                            <div class="form-group">
                                <label>Middle Name</label>
                                <input type="text" name="middleName" id="editMiddleName">
                            </div>
                            <div class="form-group">
                                <label>Last Name *</label>
                                <input type="text" name="lastName" id="editLastName">
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Date of Birth *</label>
                                <input type="date" name="dob" id="editDob">
                            </div>
                            <div class="form-group">
                                <label>Gender *</label>
                                <select name="gender" id="editGender">
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Marital Status</label>
                                <select name="maritalStatus" id="editMarital">
                                    <option value="single">Single</option>
                                    <option value="married">Married</option>
                                    <option value="divorced">Divorced</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Email *</label>
                                <input type="email" name="email" id="editEmail">
                            </div>
                            <div class="form-group">
                                <label>Phone *</label>
                                <input type="text" name="phone" id="editPhone">
                            </div>
                            <div class="form-group">
                                <label>Annual Income (₹)</label>
                                <input type="number" name="income" id="editIncome">
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Occupation</label>
                                <input type="text" name="occupation" id="editOcc">
                            </div>
                            <div class="form-group">
                                <label>PAN Number *</label>
                                <input type="text" name="pan" id="editPan">
                            </div>
                            <div class="form-group">
                                <label>Aadhaar Card *</label>
                                <input type="text" name="aadhaar" id="editAadhaar">
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Address *</label>
                                <input type="text" name="address" id="editAddress">
                            </div>
                            <div class="form-group">
                                <label>City *</label>
                                <input type="text" name="city" id="editCity">
                            </div>
                            <div class="form-group">
                                <label>State *</label>
                                <input type="text" name="state" id="editState">
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Zip Code *</label>
                                <input type="text" name="zip" id="editZip">
                            </div>
                        </div>

                        <!-- Joint Holder Edit Fields -->
                        <div id="jointCustomerEditFields" style="display:none; margin-top:20px;">
                            <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                                Joint Holder Personal Details
                            </h4>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>First Name *</label>
                                    <input type="text" name="joint_firstName" id="editJointFirstName">
                                </div>
                                <div class="form-group">
                                    <label>Middle Name</label>
                                    <input type="text" name="joint_middleName" id="editJointMiddleName">
                                </div>
                                <div class="form-group">
                                    <label>Last Name *</label>
                                    <input type="text" name="joint_lastName" id="editJointLastName">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Date of Birth *</label>
                                    <input type="date" name="joint_dob" id="editJointDob">
                                </div>
                                <div class="form-group">
                                    <label>Gender *</label>
                                    <select name="joint_gender" id="editJointGender">
                                        <option value="male">Male</option>
                                        <option value="female">Female</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Marital Status</label>
                                    <select name="joint_maritalStatus" id="editJointMarital">
                                        <option value="single">Single</option>
                                        <option value="married">Married</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Email *</label>
                                    <input type="email" name="joint_email" id="editJointEmail">
                                </div>
                                <div class="form-group">
                                    <label>Phone *</label>
                                    <input type="text" name="joint_phone" id="editJointPhone">
                                </div>
                                <div class="form-group">
                                    <label>Annual Income (₹)</label>
                                    <input type="number" name="joint_income" id="editJointIncome">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Occupation</label>
                                    <input type="text" name="joint_occupation" id="editJointOcc">
                                </div>
                                <div class="form-group">
                                    <label>PAN Number *</label>
                                    <input type="text" name="joint_pan" id="editJointPan">
                                </div>
                                <div class="form-group">
                                    <label>Aadhaar Card *</label>
                                    <input type="text" name="joint_aadhaar" id="editJointAadhaar">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Address *</label>
                                    <input type="text" name="joint_address" id="editJointAddress">
                                </div>
                                <div class="form-group">
                                    <label>City *</label>
                                    <input type="text" name="joint_city" id="editJointCity">
                                </div>
                                <div class="form-group">
                                    <label>State *</label>
                                    <input type="text" name="joint_state" id="editJointState">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Zip Code *</label>
                                    <input type="text" name="joint_zip" id="editJointZip">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Current Specific Edit Controls -->
                    <div id="currentEditFields" style="display:none;">
                        <h4 style="font-size:0.95rem; font-weight:700; color:var(--gray-800); margin-bottom:15px; border-bottom:1px solid rgba(99, 102, 241, 0.08); padding-bottom:8px;">
                            Corporate Registry Settings
                        </h4>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Registered Trade Name</label>
                                <input type="text" name="businessName" id="editBusinessName">
                            </div>
                            <div class="form-group">
                                <label>GSTIN Identification</label>
                                <input type="text" name="gstin" id="editGstin">
                            </div>
                            <div class="form-group">
                                <label>Overdraft Line (₹)</label>
                                <input type="number" step="0.01" name="overdraftLimit" id="editOverdraft">
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Company Category</label>
                                <input type="text" name="companyCategory" id="editCompanyCategory">
                            </div>
                            <div class="form-group">
                                <label>Company PAN</label>
                                <input type="text" name="companyPan" id="editCompanyPan">
                            </div>
                            <div class="form-group">
                                <label>Company Aadhaar</label>
                                <input type="text" name="companyAadhaar" id="editCompanyAadhaar">
                            </div>
                        </div>
                        <div class="form-row row-3">
                            <div class="form-group">
                                <label>Company Phone</label>
                                <input type="text" name="companyPhone" id="editCompanyPhone">
                            </div>
                            <div class="form-group">
                                <label>Company Email</label>
                                <input type="email" name="companyEmail" id="editCompanyEmail">
                            </div>
                            <div class="form-group">
                                <label>Corporate Address</label>
                                <input type="text" name="companyAddress" id="editCompanyAddress">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editAccountModal')">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ==========================================
         CLOSE ACCOUNT MODAL
         ========================================== -->
    <div class="modal" id="closeAccountModal">
        <div class="modal-content" style="max-width: 600px;">
            <div class="modal-header">
                <h3 style="font-weight: 700; color: #b91c1c; display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-error-alt" style="color: #ef4444;"></i> Close Account Confirmation
                </h3>
                <button type="button" class="close-modal-btn" onclick="closeModal('closeAccountModal')">
                    <i class="bx bx-x"></i>
                </button>
            </div>
            <div class="modal-body">
                <div style="background: rgba(239, 68, 68, 0.08); border-left: 4px solid #ef4444; color: #b91c1c; padding: 15px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.9rem;">
                    <h4 style="font-weight:700; margin-bottom:5px;"><i class="bx bx-error-circle"></i> Warning</h4>
                    <span>Are you sure you want to close this account? This will mark the ledger status as closed and restrict future operations. This action cannot be undone.</span>
                </div>

                <table style="width:100%; font-size:0.9rem; line-height:2.0; border-collapse:collapse;">
                    <tr>
                        <td style="color:var(--gray-500); width:40%; padding: 8px 0;">Account Number:</td>
                        <td style="font-weight:700; font-family:monospace; color:var(--gray-800);" id="closeAccNum">-</td>
                    </tr>
                    <tr>
                        <td style="color:var(--gray-500); padding: 8px 0;">Account Type:</td>
                        <td style="font-weight:700; text-transform:uppercase;" id="closeAccType">-</td>
                    </tr>
                    <tr>
                        <td style="color:var(--gray-500); padding: 8px 0;">Primary Holder Name:</td>
                        <td style="font-weight:700; color:var(--gray-800);" id="closeHolderName">-</td>
                    </tr>
                    <tr>
                        <td style="color:var(--gray-500); padding: 8px 0;">Current Ledger Balance:</td>
                        <td style="font-weight:800; color:#ef4444; font-size:1.1rem;" id="closeBalance">-</td>
                    </tr>
                    <tr>
                        <td style="color:var(--gray-500); padding: 8px 0;">Current Ledger Status:</td>
                        <td style="font-weight:700; text-transform:uppercase;" id="closeStatus">-</td>
                    </tr>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('closeAccountModal')">Cancel</button>
                <button type="button" class="btn" style="background:#ef4444; color:white; border:none;" onclick="confirmCloseAccount()">Confirm Close Account</button>
            </div>
        </div>
    </div>

    <!-- ==========================================
         CREATE NEW ACCOUNT WIZARD MODAL
         ========================================== -->
    <div class="modal" id="createAccountModal">
        <div class="modal-content modal-large">
            <form action="${pageContext.request.contextPath}/account?action=create" method="POST" id="createAccountForm" onsubmit="return validateWizardFormSubmit()">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="modal-header">
                    <h3 style="font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px;">
                        <i class="bx bx-plus-circle" style="color: var(--primary-500);"></i> Open Bank Ledger Account
                    </h3>
                    <button type="button" class="close-modal-btn" onclick="closeModal('createAccountModal')"><i class="bx bx-x"></i></button>
                </div>
                <div class="modal-body">
                    <!-- Progress Bar -->
                    <div class="step-progress-bar">
                        <div class="step-progress-line-wrapper">
                            <div class="step-progress-line-bg"></div>
                            <div class="step-indicator-line" id="stepLine"></div>
                        </div>
                        <div class="step-node active" id="node1"><span class="step-node-label">Type</span></div>
                        <div class="step-node" id="node2"><span class="step-node-label">Holders</span></div>
                        <div class="step-node" id="node3"><span class="step-node-label">Nominee</span></div>
                        <div class="step-node" id="node4"><span class="step-node-label">Assets</span></div>
                        <div class="step-node" id="node5"><span class="step-node-label">Auth</span></div>
                        <div class="step-node" id="node6"><span class="step-node-label">Deposit</span></div>
                        <div class="step-node" id="node7"><span class="step-node-label">Review</span></div>
                    </div>

                    <!-- STEP 1: Select Type -->
                    <div class="wizard-step active" id="step1">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px;">Choose Account Model Category</h4>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                            <div style="border: 2px solid var(--primary-300); border-radius: var(--radius-md); padding: 25px; cursor: pointer; text-align: center; background: rgba(99,102,241,0.03); transition: all 0.3s;" id="optSavingsSingle" onclick="selectAccountCategory('savings_single')">
                                <i class="bx bx-user" style="font-size: 2.5rem; color: var(--primary-500);"></i>
                                <h5 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-top: 10px;">Savings Single</h5>
                                <p style="font-size: 0.78rem; color: var(--gray-500); margin-top: 5px;">Retail individual deposits with passbook features.</p>
                            </div>
                            <div style="border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); padding: 25px; cursor: pointer; text-align: center; background: white; transition: all 0.3s;" id="optSavingsJoint" onclick="selectAccountCategory('savings_joint')">
                                <i class="bx bx-group" style="font-size: 2.5rem; color: var(--secondary-500);"></i>
                                <h5 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-top: 10px;">Savings Joint</h5>
                                <p style="font-size: 0.78rem; color: var(--gray-500); margin-top: 5px;">Joint account support for dual holders (max 2).</p>
                            </div>
                            <div style="border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); padding: 25px; cursor: pointer; text-align: center; background: white; transition: all 0.3s;" id="optCurrent" onclick="selectAccountCategory('current')">
                                <i class="bx bx-briefcase" style="font-size: 2.5rem; color: var(--accent-emerald);"></i>
                                <h5 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-top: 10px;">Current Corporate</h5>
                                <p style="font-size: 0.78rem; color: var(--gray-500); margin-top: 5px;">Trade accounts for businesses, merchants, and entities.</p>
                            </div>
                        </div>

                        <!-- Hidden form variables to post -->
                        <input type="hidden" name="accountType" id="wizAccountType" value="savings">
                        <input type="hidden" name="holdingType" id="wizHoldingType" value="single">
                    </div>

                    <!-- STEP 2: Holders details -->
                    <div class="wizard-step" id="step2">
                        <!-- Container for savings single customer -->
                        <div id="wizSavingsSingleFields" style="display:block;">
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1.5px solid var(--gray-100); padding-bottom: 8px;">
                                <i class="bx bx-id-card"></i> Customer Personal Details
                            </h4>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>First Name *</label>
                                    <input type="text" name="firstName" id="wizFirst">
                                </div>
                                <div class="form-group">
                                    <label>Middle Name</label>
                                    <input type="text" name="middleName" id="wizMiddle">
                                </div>
                                <div class="form-group">
                                    <label>Last Name *</label>
                                    <input type="text" name="lastName" id="wizLast">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Date of Birth *</label>
                                    <input type="date" name="dob" id="wizDob">
                                </div>
                                <div class="form-group">
                                    <label>Gender *</label>
                                    <select name="gender" id="wizGender">
                                        <option value="male">Male</option>
                                        <option value="female">Female</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Marital Status</label>
                                    <select name="maritalStatus" id="wizMarital">
                                        <option value="single">Single</option>
                                        <option value="married">Married</option>
                                        <option value="divorced">Divorced</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Email *</label>
                                    <input type="email" name="email" id="wizEmail">
                                </div>
                                <div class="form-group">
                                    <label>Phone *</label>
                                    <input type="text" name="phone" id="wizPhone">
                                </div>
                                <div class="form-group">
                                    <label>Annual Income (₹)</label>
                                    <input type="number" name="income" id="wizIncome" value="300000">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Occupation</label>
                                    <input type="text" name="occupation" id="wizOcc" value="Salaried">
                                </div>
                                <div class="form-group">
                                    <label>PAN Number *</label>
                                    <input type="text" name="pan" id="wizPan">
                                </div>
                                <div class="form-group">
                                    <label>Aadhaar Card (12 digits) *</label>
                                    <input type="text" name="aadhaar" id="wizAadhaar">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Address *</label>
                                    <input type="text" name="address" id="wizAddress">
                                </div>
                                <div class="form-group">
                                    <label>City *</label>
                                    <input type="text" name="city" id="wizCity">
                                </div>
                                <div class="form-group">
                                    <label>State *</label>
                                    <input type="text" name="state" id="wizState">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Zip Code *</label>
                                    <input type="text" name="zip" id="wizZip">
                                </div>
                            </div>
                        </div>

                        <!-- Container for savings joint customer -->
                        <div id="wizSavingsJointFields" style="display:none;">
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1.5px solid var(--gray-100); padding-bottom: 8px;">
                                <i class="bx bx-group"></i> Second Customer Details (Joint Holder)
                            </h4>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>First Name *</label>
                                    <input type="text" name="joint_firstName" id="wizJointFirst">
                                </div>
                                <div class="form-group">
                                    <label>Middle Name</label>
                                    <input type="text" name="joint_middleName" id="wizJointMiddle">
                                </div>
                                <div class="form-group">
                                    <label>Last Name *</label>
                                    <input type="text" name="joint_lastName" id="wizJointLast">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Date of Birth *</label>
                                    <input type="date" name="joint_dob" id="wizJointDob">
                                </div>
                                <div class="form-group">
                                    <label>Gender *</label>
                                    <select name="joint_gender" id="wizJointGender">
                                        <option value="male">Male</option>
                                        <option value="female">Female</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Marital Status</label>
                                    <select name="joint_maritalStatus" id="wizJointMarital">
                                        <option value="single">Single</option>
                                        <option value="married">Married</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Email *</label>
                                    <input type="email" name="joint_email" id="wizJointEmail">
                                </div>
                                <div class="form-group">
                                    <label>Phone *</label>
                                    <input type="text" name="joint_phone" id="wizJointPhone">
                                </div>
                                <div class="form-group">
                                    <label>Annual Income (₹)</label>
                                    <input type="number" name="joint_income" id="wizJointIncome" value="300000">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Occupation</label>
                                    <input type="text" name="joint_occupation" id="wizJointOcc" value="Salaried">
                                </div>
                                <div class="form-group">
                                    <label>PAN Number *</label>
                                    <input type="text" name="joint_pan" id="wizJointPan">
                                </div>
                                <div class="form-group">
                                    <label>Aadhaar Card *</label>
                                    <input type="text" name="joint_aadhaar" id="wizJointAadhaar">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Address *</label>
                                    <input type="text" name="joint_address" id="wizJointAddress">
                                </div>
                                <div class="form-group">
                                    <label>City *</label>
                                    <input type="text" name="joint_city" id="wizJointCity">
                                </div>
                                <div class="form-group">
                                    <label>State *</label>
                                    <input type="text" name="joint_state" id="wizJointState">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Zip Code *</label>
                                    <input type="text" name="joint_zip" id="wizJointZip">
                                </div>
                            </div>
                            <input type="hidden" name="joint_username" id="wizJointUser">
                            <input type="hidden" name="joint_password" id="wizJointPass">
                            <input type="hidden" name="joint_pin" id="wizJointPin" value="">
                        </div>

                        <!-- Container for corporate accounts -->
                        <div id="wizCurrentFields" style="display:none;">
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; border-bottom: 1.5px solid var(--gray-100); padding-bottom: 8px;">
                                <i class="bx bx-buildings"></i> Company Credentials
                            </h4>
                            <div class="form-row row-2">
                                <div class="form-group">
                                    <label>Business Name *</label>
                                    <input type="text" name="businessName" id="wizBusName">
                                </div>
                                <div class="form-group">
                                    <label>GSTIN (15 characters) *</label>
                                    <input type="text" name="gstin" id="wizGstin" placeholder="e.g. 24AAAAB1234C1Z9">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Company Category</label>
                                    <select name="companyCategory" id="wizBusCat">
                                        <option value="Sole Proprietorship">Sole Proprietorship</option>
                                        <option value="Partnership">Partnership Firm</option>
                                        <option value="Private Limited">Private Limited</option>
                                        <option value="Public Limited">Public Limited</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Company PAN *</label>
                                    <input type="text" name="companyPan" id="wizBusPan">
                                </div>
                                <div class="form-group">
                                    <label>Company Aadhaar (Entity) *</label>
                                    <input type="text" name="companyAadhaar" id="wizBusAadh">
                                </div>
                            </div>
                            <div class="form-row row-3">
                                <div class="form-group">
                                    <label>Company Phone *</label>
                                    <input type="text" name="companyPhone" id="wizBusPhone">
                                </div>
                                <div class="form-group">
                                    <label>Company Email *</label>
                                    <input type="email" name="companyEmail" id="wizBusEmail">
                                </div>
                                <div class="form-group">
                                    <label>Corporate Address *</label>
                                    <input type="text" name="companyAddress" id="wizBusAddr">
                                </div>
                            </div>

                            <!-- Partners dynamically added -->
                            <div style="margin-top: 30px;">
                                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; border-bottom: 1.5px solid var(--gray-100); padding-bottom:8px;">
                                    <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800);">
                                        <i class="bx bx-group"></i> Corporate Partners
                                    </h4>
                                    <button type="button" class="btn btn-secondary" onclick="addNewPartnerField()" style="padding: 6px 12px; font-size:0.75rem; border-color:var(--primary-500); color:var(--primary-500);">
                                        <i class="bx bx-plus"></i> Add Partner Profile
                                    </button>
                                </div>
                                <input type="hidden" name="partnerCount" id="partnerCountInput" value="1">
                                <div id="dynamicPartnersContainer">
                                    <!-- Partner 1 fields -->
                                    <div class="partner-card" id="partner_card_1">
                                        <h5 style="font-size:0.85rem; font-weight:700; color:var(--primary-500); margin-bottom:15px;">Partner Profile #1 (Primary signatory)</h5>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>First Name *</label>
                                                <input type="text" name="partner_firstName_1" id="p1_first">
                                            </div>
                                            <div class="form-group">
                                                <label>Middle Name</label>
                                                <input type="text" name="partner_middleName_1">
                                            </div>
                                            <div class="form-group">
                                                <label>Last Name *</label>
                                                <input type="text" name="partner_lastName_1" id="p1_last">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Date of Birth *</label>
                                                <input type="date" name="partner_dob_1">
                                            </div>
                                            <div class="form-group">
                                                <label>Gender *</label>
                                                <select name="partner_gender_1">
                                                    <option value="male">Male</option>
                                                    <option value="female">Female</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Marital Status</label>
                                                <select name="partner_maritalStatus_1">
                                                    <option value="single">Single</option>
                                                    <option value="married">Married</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Email *</label>
                                                <input type="email" name="partner_email_1">
                                            </div>
                                            <div class="form-group">
                                                <label>Phone *</label>
                                                <input type="text" name="partner_phone_1">
                                            </div>
                                            <div class="form-group">
                                                <label>PAN Card *</label>
                                                <input type="text" name="partner_pan_1">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Aadhaar Card *</label>
                                                <input type="text" name="partner_aadhaar_1">
                                            </div>
                                            <div class="form-group">
                                                <label>Partner Address *</label>
                                                <input type="text" name="partner_address_1">
                                            </div>
                                            <div class="form-group">
                                                <label>City *</label>
                                                <input type="text" name="partner_city_1">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>State *</label>
                                                <input type="text" name="partner_state_1">
                                            </div>
                                            <div class="form-group">
                                                <label>Zip Code *</label>
                                                <input type="text" name="partner_zip_1">
                                            </div>
                                            <div class="form-group">
                                                <label>Annual Income *</label>
                                                <input type="number" name="partner_income_1" value="500000">
                                            </div>
                                        </div>
                                        <div class="form-row row-3">
                                            <div class="form-group">
                                                <label>Occupation</label>
                                                <input type="text" name="partner_occupation_1" value="Business">
                                            </div>
                                        </div>
                                        <input type="hidden" name="partner_username_1" id="p1_user">
                                        <input type="hidden" name="partner_password_1" id="p1_pass">
                                        <!-- PIN auto-generated -->
                                        <input type="hidden" name="partner_pin_1" id="p1_pin" value="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 3: Nominee Details (Savings only) -->
                    <div class="wizard-step" id="step3">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Nominee Person Details (Optional)</h4>
                        <p style="font-size: 0.82rem; color: var(--gray-500); margin-bottom: 25px;">Add nominee details for account security and inheritance purposes.</p>

                        <div style="background: rgba(99, 102, 241, 0.02); padding: 30px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border); margin-bottom: 30px;">
                            <div class="form-group">
                                <label style="display:block; font-size:0.85rem; font-weight:600; color:var(--gray-600); margin-bottom:8px;">Nominee Full Name</label>
                                <input type="text" name="nomineeName" id="wizNominee" placeholder="Legal full name of Nominee">
                                <small style="display:block; color:var(--gray-500); font-size:0.75rem; margin-top:5px;">This field is optional. You can leave it blank if no nominee is registered at this time.</small>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 4: Assets selection (ATM, Cheque, Passbook) -->
                    <div class="wizard-step" id="step4">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Select Banking Services & Instruments</h4>
                        <p style="font-size: 0.82rem; color: var(--gray-500); margin-bottom: 25px;">Activate offline transacting items. Inspect real-time 3D mockups below.</p>

                        <div class="form-row row-3" style="background: rgba(99, 102, 241, 0.02); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid var(--glass-border); margin-bottom:30px;">
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-weight:600;">
                                <input type="checkbox" name="atmCard" id="wizAtmCard" onchange="toggleWizardAssetView('atm')" value="on"> ATM Debit Card
                            </label>
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-weight:600;">
                                <input type="checkbox" name="chequeBook" id="wizChequeBook" onchange="toggleWizardAssetView('cheque')" value="on"> Cheque Book Request
                            </label>
                            <label style="display:flex; align-items:center; gap:8px; cursor:pointer; font-weight:600;" id="wizPassbookLabel">
                                <input type="checkbox" name="passbook" id="wizPassbook" onchange="toggleWizardAssetView('passbook')" value="on" checked> Offline Passbook Booklet
                            </label>
                        </div>

                        <!-- Visualizers -->
                        <div class="visualizer-preview-grid">

                            <!-- ATM Card Visualizer -->
                            <div class="visualizer-container" id="wizCardVisualizer" style="display:none;">
                                <div style="position:absolute; top:12px; left:20px; font-size:0.75rem; font-weight:700; color:var(--gray-500); text-transform:uppercase;">ATM Card Visual Model</div>
                                <div style="position:absolute; top:12px; right:20px; font-size:0.7rem; color:var(--primary-500); cursor:pointer; font-weight:600;" onclick="flip3DCard()">Flip Card</div>

                                <div style="margin-bottom:12px;">
                                    <label style="font-size:0.7rem; font-weight:700; color:var(--gray-500);">Card Provider:</label>
                                    <select name="cardProvider" id="wizCardProvider" onchange="updateCardProvider(this.value)" style="padding:4px 8px; border:1px solid var(--gray-300); border-radius:4px; font-size:0.75rem; margin-left:5px;">
                                        <option value="visa">Visa Classic</option>
                                        <option value="mastercard">Mastercard Royale</option>
                                        <option value="rupay">RuPay Platinum</option>
                                    </select>
                                </div>

                                <div class="vgb-atm-card visa" id="3dAtmCard" onclick="flip3DCard()">
                                    <!-- Front Face -->
                                    <div class="card-face card-front">
                                        <!-- Gold V-Logo & Stacked Bank Name Header -->
                                        <div class="card-bank-header">
                                            <div class="card-logo-v">
                                                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 20px; height: 20px; object-fit: contain; filter: drop-shadow(0 1px 2px rgba(0,0,0,0.3));">
                                            </div>
                                            <div class="card-bank-name-stack">
                                                <span class="bank-title">VERTEX</span>
                                                <span class="bank-subtitle">GALAXY BANK</span>
                                            </div>
                                        </div>

                                        <!-- Metallic Chip & Wireless Waves Row -->
                                        <div class="card-middle-row">
                                            <div class="metallic-chip"></div>
                                            <i class="bx bx-wifi contactless-icon"></i>
                                        </div>

                                        <!-- Centered Card Number -->
                                        <div class="card-number-display" id="wizCardNumber">4000 1234 5678 9010</div>

                                        <!-- Details & Network Provider Footer Row -->
                                        <div class="card-bottom-row">
                                            <div class="card-holder-info">
                                                <div class="expiry-info">
                                                    <span class="expiry-label">VALID THRU</span>
                                                    <span class="expiry-value">12/30</span>
                                                </div>
                                                <div class="holder-name" id="wizCardHolderName">CUSTOMER NAME</div>
                                            </div>
                                            <div class="card-brand-logo" id="wizCardBrandLogo">
                                                <div class="brand-visa">
                                                    <span class="visa-text">Visa</span>
                                                    <span class="visa-sub">debit</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Back Face -->
                                    <div class="card-face card-back">
                                        <div class="card-back-header">
                                            <span class="back-helpline">For customer service, call 1800 123 4567 or visit www.vertexgalaxybank.com</span>
                                            <span class="back-card-id">VGB9999</span>
                                        </div>
                                        <div class="card-back-magnetic-strip"></div>
                                        <div class="card-back-signature-container">
                                            <div class="signature-strip-text">
                                                <span>AUTHORIZED SIGNATURE</span>
                                                <span>NOT VALID UNLESS SIGNED</span>
                                            </div>
                                            <div class="signature-strip-cvv">
                                                <span class="cvv-val" id="wizCardCvv">342</span>
                                            </div>
                                        </div>
                                        <div class="card-back-bottom">
                                            <div class="back-left-emblem">
                                                <div class="mc-hologram"></div>
                                            </div>
                                            <div class="back-right-logo">
                                                <div class="back-logo-v">
                                                    <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 15px; height: 15px; object-fit: contain; filter: drop-shadow(0 1px 1px rgba(0,0,0,0.3));">
                                                    <span class="logo-text-stacked">
                                                        <span class="text-top">VERTEX</span>
                                                        <span class="text-bottom">GALAXY BANK</span>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="back-property-text">
                                            This card is the property of Vertex Galaxy Bank. If found, please return to the nearest branch.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Cheque Visualizer -->
                            <div class="visualizer-container" id="wizChequeVisualizer" style="display:none;">
                                <div style="position:absolute; top:12px; left:20px; font-size:0.75rem; font-weight:700; color:var(--gray-500); text-transform:uppercase;">Cheque Book (Leaves)</div>
                                <div class="vgb-cheque-3d" onclick="toggleChequeOpen()">
                                    <div class="cheque-hologram"></div>
                                    <div class="cheque-header">
                                        <div class="cheque-bank-info">
                                            <div class="cheque-bank-name"><i class="bx bxs-bank"></i> VERTEX GALAXY BANK</div>
                                            <div class="cheque-branch-details">BHAKTINAGAR BRANCH, RAJKOT - 360002<br>IFS Code: VGB0000171</div>
                                        </div>
                                        <div class="cheque-date-box">
                                            <div class="date-squares">
                                                <span>D</span><span>D</span><span>M</span><span>M</span><span>Y</span><span>Y</span><span>Y</span><span>Y</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cheque-row">
                                        <span class="cheque-label">Pay <span class="hindi-text">/ पाने वाले को</span></span>
                                        <div class="cheque-line-fill bearer-text">Self or Bearer</div>
                                    </div>
                                    <div class="cheque-row">
                                        <span class="cheque-label">Rupees <span class="hindi-text">/ रुपये</span></span>
                                        <div class="cheque-line-fill" id="wizChequeWords">Initial Deposit Amount</div>
                                        <div class="cheque-amount-box">
                                            <span class="rupee-symbol">₹</span>
                                            <span class="amount-val" id="wizChequeAmount">***1,000.00</span>
                                        </div>
                                    </div>
                                    <div class="cheque-details-row">
                                        <div class="cheque-acc-box">
                                            <span class="acc-label">A/C NO.</span>
                                            <span class="acc-val" id="wizChequeAccNum">171931XXXXXX</span>
                                        </div>
                                        <div class="cheque-branch-codes">
                                            Brn: 0171 Pdt: 105<br>SB A/C
                                        </div>
                                        <div class="cheque-payable-text">PAYABLE AT PAR AT ALL BRANCHES</div>
                                        <div class="cheque-sign-area">
                                            <div class="cheque-sign-name" id="wizChequeSign">Sign</div>
                                            <span class="cheque-sign-label">AUTHORISED SIGNATORY</span>
                                        </div>
                                    </div>
                                    <div class="cheque-micr-band">
                                        "001254" 360240171: 014524" 10
                                    </div>
                                </div>
                            </div>

                            <!-- Passbook Visualizer -->
                            <div class="visualizer-container" id="wizPassbookVisualizer" style="display:block;">
                                <div style="position:absolute; top:12px; left:20px; font-size:0.75rem; font-weight:700; color:var(--gray-500); text-transform:uppercase;">Passbook Booklet</div>
                                <div class="passbook-wrapper" onclick="toggleWizardPassbook()">
                                    <div class="passbook-book" id="3dWizardPassbook">
                                        <!-- Inside details page -->
                                        <div class="passbook-page">
                                            <div style="border-bottom:1.5px solid #cbd5e1; padding-bottom:3px; text-align:center; font-size:0.5rem; font-weight:800; color:#1e293b;">
                                                OFFICIAL VGB PASSBOOK
                                            </div>
                                            <table style="width:100%; font-size:0.48rem; line-height:1.4; border-collapse:collapse; margin-top:5px;">
                                                <tr>
                                                    <td style="color:#64748b; padding:2px 0;">Holder Name:</td>
                                                    <td style="font-weight:700; color:#1e293b;" id="pbWizName">SELECT CUSTOMER</td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#64748b; padding:2px 0;">Account No:</td>
                                                    <td style="font-weight:700; font-family:monospace; color:#1e293b;" id="pbWizAccNum">17193XXXXXXXXX</td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#64748b; padding:2px 0;">Branch:</td>
                                                    <td style="font-weight:700; color:#1e293b;">RAJKOT MAIN, VGB</td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#64748b; padding:2px 0;">IFSC Code:</td>
                                                    <td style="font-weight:700; font-family:monospace; color:#1e293b;">VGB0000171</td>
                                                </tr>
                                            </table>
                                            <div style="font-size:0.42rem; color:rgba(99,102,241,0.2); font-weight:800; border:1px solid; border-radius:3px; padding:1px 4px; text-align:center; margin-top:3px;">
                                                ACTIVE LEDGER SUPPORT
                                            </div>
                                        </div>
                                        <!-- Cover wrapper -->
                                        <div class="passbook-cover-wrapper">
                                            <div class="passbook-cover-front">
                                                <div style="display:flex; justify-content:space-between; align-items:center;">
                                                    <span style="font-weight:800; font-size:0.75rem; letter-spacing:1px; background:linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%); -webkit-background-clip:text; background-clip:text; -webkit-text-fill-color:transparent;">VGB</span>
                                                    <span style="font-size:0.8rem; color:#d4af37;"><i class="bx bx-chip"></i></span>
                                                </div>
                                                <div style="text-align:center; margin-top:5px;">
                                                    <h3 style="font-size:0.95rem; font-weight:800; letter-spacing:2px; background:linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%); -webkit-background-clip:text; background-clip:text; -webkit-text-fill-color:transparent; margin:0;">PASSBOOK</h3>
                                                </div>
                                                <div style="font-size:0.35rem; color:#a5b4fc; text-transform:uppercase; text-align:center;">Vertex Galaxy Bank</div>
                                            </div>
                                            <div class="passbook-cover-inside">
                                                <div>VERTEX GALAXY BANK</div>
                                                <div style="margin-top:10px; font-size:0.4rem; line-height:1.2;">This document logs all deposits, transfers, interest ledger, and withdrawals. Keep securely.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 5: Login / Authorization -->
                    <div class="wizard-step" id="step5">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px;">
                            <i class="bx bx-key"></i> Customer Account Authorization
                        </h4>

                        <!-- Primary account user / Corporate admin login -->
                        <div class="form-row row-2">
                            <div class="form-group">
                                <label id="lblWizUsername">Customer Login Username *</label>
                                <input type="text" name="username" id="wizUsername">
                            </div>
                            <div class="form-group">
                                <label id="lblWizPassword">Customer Login Password *</label>
                                <input type="password" name="password" id="wizPassword">
                            </div>
                        </div>

                        <!-- Joint account user login (visible only for joint accounts) -->
                        <div class="form-row row-2" id="wizJointAuthRow" style="margin-top:20px; display:none;">
                            <div class="form-group">
                                <label>Joint Holder Login Username *</label>
                                <input type="text" id="wizJointUserDisplay" readonly style="background:rgba(99,102,241,0.01); color:var(--gray-700);">
                            </div>
                            <div class="form-group">
                                <label>Joint Holder Login Password *</label>
                                <input type="text" id="wizJointPassDisplay" readonly style="background:rgba(99,102,241,0.01); color:var(--gray-700);">
                            </div>
                        </div>

                        <!-- Corporate partners login details (visible only for corporate accounts) -->
                        <div id="wizPartnersAuthSection" style="margin-top:20px; display:none;">
                            <h5 style="font-size:0.9rem; font-weight:700; color:var(--primary-500); margin-bottom:12px; border-bottom:1.5px solid var(--gray-100); padding-bottom:5px;">Partner Login Credentials</h5>
                            <div id="wizPartnersAuthContainer">
                                <!-- Populated dynamically by JS -->
                            </div>
                        </div>

                        <!-- Read only auto-generated PIN box -->
                        <div class="form-row row-2" style="margin-top:20px;">
                            <div class="form-group">
                                <label style="color:var(--primary-500); font-weight:700;">Secure Signatory PIN (Auto-Generated) *</label>
                                <input type="text" name="pin" id="wizPin" readonly style="border:1.5px solid var(--primary-300); background:rgba(99,102,241,0.03); font-weight:800; font-family:monospace; font-size:1.15rem; color:var(--primary-700); text-align:center; letter-spacing:4px;">
                                <small style="display:block; color:var(--gray-500); font-size:0.75rem; margin-top:5px;">This 4-digit PIN is generated randomly for account card and counter operations.</small>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 6: Initial Deposit Payment -->
                    <div class="wizard-step" id="step6">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 25px;">
                            <i class="bx bx-wallet"></i> Initial Account Deposit
                        </h4>
                        <div class="form-row row-2">
                            <div class="form-group">
                                <label style="font-weight:700;">Initial Account Opening Deposit (₹) *</label>
                                <input type="number" step="0.01" name="initialAmount" id="wizDeposit" value="1000.00" onkeyup="updateChequeAmount(this.value)" style="font-weight:700; font-size:1.1rem; color:var(--gray-800);">
                                <small style="display:block; color:var(--gray-500); font-size:0.75rem; margin-top:5px;" id="wizMinDepositNote">Minimum initial amount required is ₹1,000.00.</small>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 7: Summary -->
                    <div class="wizard-step" id="step7">
                        <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 5px;">Verify Opened Account Summary</h4>
                        <p style="font-size: 0.82rem; color: var(--gray-500); margin-bottom: 25px;">Please confirm all profiles and deposits are entered accurately.</p>

                        <div style="background:var(--gray-50); border:1.5px solid var(--gray-200); border-radius:var(--radius-md); padding:25px;" id="wizSummaryCard">
                            <!-- Populated dynamically by JS -->
                        </div>

                        <!-- Mandatory Check Mandate Button -->
                        <div style="margin-top: 30px; background: rgba(16, 185, 129, 0.05); border: 1.5px dashed var(--accent-emerald); border-radius: var(--radius-md); padding: 20px;">
                            <label style="display: flex; gap: 12px; align-items: flex-start; cursor: pointer; font-weight: 600; font-size: 0.85rem; color: var(--gray-700);">
                                <input type="checkbox" id="wizMandateCheckbox" onchange="toggleWizardMandateState(this.checked)" style="margin-top: 4px; width: 16px; height: 16px; flex-shrink: 0;">
                                <span id="mandateLabelText">Mandate confirmation statement here</span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="wizPrevBtn" onclick="navigateWizardStep(-1)">Back</button>
                    <button type="button" class="btn btn-primary" id="wizNextBtn" onclick="navigateWizardStep(1)">Next Step</button>
                    <button type="submit" class="btn" style="background: var(--accent-emerald); color: white; border: none; display:none;" id="wizSubmitBtn" disabled>Open Account</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ==========================================
         ACCOUNT STATEMENT LEDGER MODAL
         ========================================== -->
    <!-- ==========================================
         ACCOUNT STATEMENT LEDGER MODAL
         ========================================== -->
    <div class="modal" id="statementModal">
        <div class="modal-content modal-large">
            <div class="modal-header no-print" style="padding: 20px 30px; border-bottom: 1px solid var(--gray-100);">
                <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--gray-900); display: flex; align-items: center; gap: 10px; margin: 0;">
                    <i class="bx bx-file" style="color: var(--primary-500);"></i> Vertex Galaxy Bank Account Statement
                </h3>
                <button type="button" class="close-modal-btn" onclick="closeModal('statementModal')" style="font-size: 1.5rem; color: var(--gray-400); cursor: pointer; background: transparent; border: none;"><i class="bx bx-x"></i></button>
            </div>
            <div class="modal-body" style="padding: 30px;">
                <!-- FILTERS BLOCK -->
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom:25px;" class="no-print">
                    <div>
                        <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Date Filter Range</label>
                        <select id="stmtDateFilter" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                            <option value="all">All Available ledger</option>
                            <option value="current_month">Current Month</option>
                            <option value="last_month">Last Month</option>
                            <option value="year">Current Financial Year</option>
                            <option value="custom">Custom Date Range...</option>
                        </select>
                    </div>
                    <div>
                        <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Transaction Type</label>
                        <select id="stmtTypeFilter" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                            <option value="all">All Transactions</option>
                            <option value="received">Received / Credits</option>
                            <option value="paid">Paid / Debits</option>
                        </select>
                    </div>
                </div>

                <!-- Custom Dates group -->
                <div id="stmtCustomDateGroup" style="display:none; border-top:1px dashed var(--gray-200); padding-top:15px;" class="no-print">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:20px;">
                        <div>
                            <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">Start Date</label>
                            <input type="date" id="stmtStartDate" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                        </div>
                        <div>
                            <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--gray-500); margin-bottom:6px;">End Date</label>
                            <input type="date" id="stmtEndDate" onchange="runStatementFilter()" style="width: 100%; padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-sm); font-size:0.85rem;">
                        </div>
                    </div>
                </div>

                <!-- Statement Document Body -->
                <div class="statement-print-area">
                    <!-- Official Bank Logo & Name -->
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary-500); padding-bottom: 15px; margin-bottom: 25px;">
                        <div>
                            <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--primary-500); letter-spacing: 1px; line-height: 1;">VERTEX GALAXY BANK</h1>
                            <p style="font-size: 0.8rem; color: var(--gray-500); margin-top: 5px; font-weight: 500;">Secure Credit &amp; Lending Divisions</p>
                        </div>
                        <div style="text-align: right;">
                            <span style="font-family: monospace; font-size: 0.85rem; color: var(--gray-500); font-weight: 700;" id="lblStmtRef">ACC-REF: -</span>
                            <p style="font-size: 0.8rem; color: var(--gray-400); margin-top: 3px;">Date Generated: <span id="lblStmtDateGenerated">-</span></p>
                        </div>
                    </div>

                    <!-- Official Header Subtitle (shown in both screen and print) -->
                    <div style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                        <span style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official Account Transaction Ledger Statement</span>
                    </div>

                    <!-- Details Grid -->
                    <div class="statement-meta-grid" style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);">
                        <!-- Left: Bank Information -->
                        <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                            <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank Details</span>
                            <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate HQ)</strong>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers, BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code: <strong style="font-family: monospace;">VGBK0000001</strong></p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free: 1800-VGB-BANK</p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal: www.vertexgalaxybank.com</p>
                        </div>
                        
                        <!-- Right: Customer & Account Details -->
                        <div>
                            <span style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer &amp; Account Details</span>
                            <strong style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;" id="lblStmtName">-</strong>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong style="font-family: monospace;" id="lblStmtCustId">-</strong></p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address: <strong style="color: var(--gray-800); font-weight: 600;" id="lblStmtAddress">-</strong></p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Account Reference: <strong style="font-family: monospace;" id="lblStmtAccNum">-</strong> (<span id="lblStmtAccType" style="text-transform: uppercase; font-weight: 600;">-</span> Account)</p>
                            <p style="margin: 4px 0 0; color: var(--gray-600);">Total Balance: <strong style="color: var(--primary-500); font-size: 1.05rem;" id="lblStmtBalance">-</strong></p>
                        </div>
                    </div>

                    <!-- Ledger Section Header -->
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                            <i class="bx bx-history" style="color: var(--primary-500);"></i> Transaction Ledger Log
                        </h4>
                        <button type="button" onclick="window.print()" class="btn btn-primary no-print" style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px; background: linear-gradient(135deg, #a855f7 0%, #ec4899 100%); border: none;">
                            <span>Print Document</span>
                            <i class="bx bx-printer"></i>
                        </button>
                    </div>

                    <!-- Table Responsive Wrapper -->
                    <div style="overflow-x: auto; border: 1.5px solid var(--gray-200); border-radius: var(--radius-md); box-shadow: var(--shadow-sm); margin-bottom: 25px;">
                        <table id="statementTxnTable" style="width: 100%; border-collapse: collapse; text-align: left; font-size: 0.85rem; margin-bottom: 0;">
                            <thead>
                                <tr style="background: rgba(99, 102, 241, 0.04); color: var(--gray-700); border-bottom: 2px solid var(--gray-200);">
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; width: 80px;">Sr. No.</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Transaction Date</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Type</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Description</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Status</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Credit Amount</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Debit Amount</th>
                                    <th style="padding: 14px 16px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Total Amount</th>
                                </tr>
                            </thead>
                            <tbody id="statementTxnTbody">
                                <!-- Populated dynamically via AJAX -->
                            </tbody>
                        </table>
                    </div>

                    <!-- Footer Signatures -->
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px; margin-bottom: 25px;">
                        <div style="text-align: center; width: 200px;">
                            <div style="border-bottom: 1.5px solid var(--gray-400); height: 40px; margin-bottom: 8px;"></div>
                            <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; text-transform: capitalize;">Authorized Signatory</span>
                        </div>
                        <div style="text-align: center; width: 200px;">
                            <div style="border-bottom: 1.5px solid var(--gray-400); height: 40px; margin-bottom: 8px;"></div>
                            <span style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; text-transform: capitalize;">System Generated Seals</span>
                        </div>
                    </div>
                </div>

                <!-- Modal Controls (hidden in print) -->
                <div style="display: flex; justify-content: center; align-items: center; margin-top: 35px; border-top: 1px solid var(--gray-100); padding-top: 25px;" class="no-print">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('statementModal')" style="border-radius: var(--radius-full); padding: 10px 32px; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; border: 1.5px solid var(--gray-300); background: transparent; color: var(--gray-700); transition: all 0.2s;" onmouseover="this.style.background='var(--gray-100)';" onmouseout="this.style.background='transparent';">Close View</button>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer no-print">
        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
            <p style="font-size: 0.85rem; color: var(--gray-500); font-weight: 500;">&copy; <span>2026</span> Vertex Galaxy Bank. Internal administrative access.</p>
        </div>
    </footer>

    <script>
        var accountsData = [];
        // <c:forEach var="acc" items="${accounts}">
        accountsData.push({
            accountId: Number("${acc.accountId}"),
            customerId: Number("${acc.customerId}"),
            customerName: "${acc.customerName}",
            accountNumber: "${acc.accountNumber}",
            accountType: "${acc.accountType}",
            balance: Number("${acc.balance}"),
            status: "${acc.status}",
            ifscCode: "${acc.ifscCode}",
            hasAtmCard: "${acc.hasAtmCard}" === "true",
            hasChequeBook: "${acc.hasChequeBook}" === "true",
            hasPassbook: "${acc.hasPassbook}" === "true",

            // Savings fields
            nomineeName: "${acc.nomineeName}",
            holdingType: "${acc.holdingType}",
            dailyWithdrawalLimit: "${acc.dailyWithdrawalLimit}",

            // Current fields
            businessName: "${acc.businessName}",
            gstin: "${acc.gstin}",
            overdraftLimit: "${acc.overdraftLimit}",
            companyCategory: "${acc.companyCategory}",
            companyPhone: "${acc.companyPhone}",
            companyEmail: "${acc.companyEmail}",
            companyAddress: "${acc.companyAddress}",
            companyPan: "${acc.companyPan}",
            companyAadhaar: "${acc.companyAadhaar}",

            // Primary Customer fields
            primaryFirstName: "${acc.primaryFirstName}",
            primaryMiddleName: "${acc.primaryMiddleName}",
            primaryLastName: "${acc.primaryLastName}",
            primaryEmail: "${acc.primaryEmail}",
            primaryPhone: "${acc.primaryPhone}",
            primaryAddress: "${acc.primaryAddress}",
            primaryCity: "${acc.primaryCity}",
            primaryState: "${acc.primaryState}",
            primaryZip: "${acc.primaryZip}",
            primaryPan: "${acc.primaryPan}",
            primaryAadhaar: "${acc.primaryAadhaar}",
            primaryGender: "${acc.primaryGender}",
            primaryMaritalStatus: "${acc.primaryMaritalStatus}",
            primaryOccupation: "${acc.primaryOccupation}",
            primaryIncome: "${acc.primaryIncome}",

            // Joint Customer fields
            jointCustomerId: Number("${acc.jointCustomerId}"),
            jointFirstName: "${acc.jointFirstName}",
            jointMiddleName: "${acc.jointMiddleName}",
            jointLastName: "${acc.jointLastName}",
            jointEmail: "${acc.jointEmail}",
            jointPhone: "${acc.jointPhone}",
            jointDob: "${acc.jointDob}",
            jointGender: "${acc.jointGender}",
            jointMaritalStatus: "${acc.jointMaritalStatus}",
            jointPan: "${acc.jointPan}",
            jointAadhaar: "${acc.jointAadhaar}",
            jointAddress: "${acc.jointAddress}",
            jointCity: "${acc.jointCity}",
            jointState: "${acc.jointState}",
            jointZip: "${acc.jointZip}",
            jointOccupation: "${acc.jointOccupation}",
            jointIncome: "${acc.jointIncome}",

            // DOB
            customerDob: "${acc.customerDob}",
            phoneNo: "${acc.companyPhone}" // temporary, we can retrieve via API if needed
        });
        // </c:forEach>
    </script>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        var currentWizardStep = 1;

        window.onload = function () {
            // Remove preloader
            const loader = document.querySelector('.preloader');
            if (loader) {
                loader.classList.add('hidden');
            }
        };

        // Theme toggle integration
        const themeBtn = document.getElementById('themeToggle');
        if (themeBtn) {
            themeBtn.onclick = function () {
                document.body.classList.toggle('dark-mode');
                const isDark = document.body.classList.contains('dark-mode');
                themeBtn.querySelector('i').className = isDark ? 'bx bx-sun' : 'bx bx-moon';
            };
        }

        // Live table search filtering
        function filterAccountsTable() {
            var input = document.getElementById('accountSearchInput');
            var filter = input.value.toLowerCase().trim();
            var rows = document.querySelectorAll('.account-row-data');

            rows.forEach(function (row) {
                var custId = row.querySelector('.td-cust-id').textContent.toLowerCase();
                var custName = row.querySelector('.td-cust-name').textContent.toLowerCase();
                var accNum = row.querySelector('.td-acc-num').textContent.toLowerCase();

                if (custId.includes(filter) || custName.includes(filter) || accNum.includes(filter)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Modal triggers
        function openModal(id) {
            document.getElementById(id).style.display = 'flex';
            var footer = document.querySelector('.footer');
            if (footer) footer.style.setProperty('display', 'none', 'important');
        }
        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
            var anyModalOpen = Array.from(document.querySelectorAll('.modal')).some(function (m) {
                return m.style.display === 'flex';
            });
            if (!anyModalOpen) {
                var footer = document.querySelector('.footer');
                if (footer) footer.style.display = '';
            }
        }

        // View details modal population
        function openViewModal(index) {
            var acc = accountsData[index];
            var body = document.getElementById('viewModalBody');

            var detailsHtml = `
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
                    <div>
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Account Credentials</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500);">Account Number:</td><td style="font-weight:700; font-family:monospace;">\${acc.accountNumber}</td></tr>
                            <tr><td style="color:var(--gray-500);">IFSC Code:</td><td style="font-weight:600; font-family:monospace;">\${acc.ifscCode}</td></tr>
                            <tr><td style="color:var(--gray-500);">Account Type:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.accountType}</td></tr>
                            <tr><td style="color:var(--gray-500);">Ledger Balance:</td><td style="font-weight:800; color:var(--primary-500);">₹ \${acc.balance.toFixed(2)}</td></tr>
                            <tr><td style="color:var(--gray-500);">Status:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.status}</td></tr>
                        </table>
                    </div>
                    <div>
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Enabled Services</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500);">ATM Debit Card:</td><td style="font-weight:700;">\${acc.hasAtmCard ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Cheque Book:</td><td style="font-weight:700;">\${acc.hasChequeBook ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Offline Passbook:</td><td style="font-weight:700;">\${acc.hasPassbook ? '✓ ENABLED' : '✗ DISABLED'}</td></tr>
                        </table>
                    </div>
                </div>
            `;

            if (acc.accountType === 'savings') {
                detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Savings Ledger Specifics</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Registered Nominee:</td><td style="font-weight:700;">\${acc.nomineeName || 'No Nominee'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Holding Mode:</td><td style="font-weight:700; text-transform:uppercase;">\${acc.holdingType}</td></tr>
                            <tr><td style="color:var(--gray-500);">Daily Cash Limit:</td><td style="font-weight:700;">₹ \${acc.dailyWithdrawalLimit || '50,000.00'}</td></tr>
                        </table>
                    </div>
                `;
            } else {
                detailsHtml += `
                    <div style="margin-top:25px;">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">Corporate Registry</h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr><td style="color:var(--gray-500); width:35%;">Business Trade Name:</td><td style="font-weight:700;">\${acc.businessName}</td></tr>
                            <tr><td style="color:var(--gray-500);">GSTIN Identification:</td><td style="font-weight:700; font-family:monospace;">\${acc.gstin}</td></tr>
                            <tr><td style="color:var(--gray-500);">Overdraft limit:</td><td style="font-weight:700;">₹ \${acc.overdraftLimit}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Category:</td><td style="font-weight:700;">\${acc.companyCategory || 'Partnership'}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company PAN:</td><td style="font-weight:700; font-family:monospace;">\${acc.companyPan}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Aadhaar:</td><td style="font-weight:700; font-family:monospace;">\${acc.companyAadhaar}</td></tr>
                            <tr><td style="color:var(--gray-500);">Company Phone/Email:</td><td style="font-weight:700;">\${acc.companyPhone} / \${acc.companyEmail}</td></tr>
                            <tr><td style="color:var(--gray-500);">Registered Address:</td><td style="font-weight:700;">\${acc.companyAddress}</td></tr>
                        </table>
                    </div>
                `;
            }

            // Add Primary Customer details section
            if (acc.primaryFirstName) {
                detailsHtml += `
                    <div style="margin-top:25px; background: rgba(99, 102, 241, 0.03); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid rgba(99, 102, 241, 0.1);">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">
                            <i class="bx bx-user" style="color:var(--primary-500);"></i> Primary Holder Details
                        </h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr>
                                <td style="color:var(--gray-500); width:35%;">Full Name:</td>
                                <td style="font-weight:700;">\${acc.primaryFirstName} \${acc.primaryMiddleName ? acc.primaryMiddleName + ' ' : ''}\${acc.primaryLastName}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Date of Birth / Gender:</td>
                                <td style="font-weight:700;">\${acc.customerDob || 'N/A'} / \${acc.primaryGender.toUpperCase()}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Marital Status / Occupation:</td>
                                <td style="font-weight:700;">\${acc.primaryMaritalStatus.toUpperCase()} / \${acc.primaryOccupation || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Email / Phone:</td>
                                <td style="font-weight:700;">\${acc.primaryEmail || 'N/A'} / \${acc.primaryPhone || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">PAN Card / Aadhaar:</td>
                                <td style="font-weight:700; font-family:monospace;">\${acc.primaryPan || 'N/A'} / \${acc.primaryAadhaar || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Annual Income:</td>
                                <td style="font-weight:700; color: var(--accent-emerald);">₹ \${parseFloat(acc.primaryIncome || 0).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Registered Address:</td>
                                <td style="font-weight:700;">\${acc.primaryAddress ? acc.primaryAddress + ', ' + acc.primaryCity + ', ' + acc.primaryState + ' - ' + acc.primaryZip : 'N/A'}</td>
                            </tr>
                        </table>
                    </div>
                `;
            }

            // Add Joint Customer details section if joint holding
            if (acc.holdingType === 'joint' && acc.jointCustomerId > 0) {
                detailsHtml += `
                    <div style="margin-top:25px; background: rgba(236, 72, 153, 0.03); padding: 20px; border-radius: var(--radius-md); border: 1.5px solid rgba(236, 72, 153, 0.1);">
                        <h4 style="font-weight:700; color:var(--gray-800); border-bottom:1.5px solid var(--gray-100); padding-bottom:5px; margin-bottom:12px;">
                            <i class="bx bx-group" style="color:var(--secondary-500);"></i> Joint Holder Details
                        </h4>
                        <table style="width:100%; font-size:0.85rem; line-height:1.8;">
                            <tr>
                                <td style="color:var(--gray-500); width:35%;">Full Name:</td>
                                <td style="font-weight:700;">\${acc.jointFirstName} \${acc.jointMiddleName ? acc.jointMiddleName + ' ' : ''}\${acc.jointLastName}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Date of Birth / Gender:</td>
                                <td style="font-weight:700;">\${acc.jointDob || 'N/A'} / \${acc.jointGender.toUpperCase()}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Marital Status / Occupation:</td>
                                <td style="font-weight:700;">\${acc.jointMaritalStatus.toUpperCase()} / \${acc.jointOccupation || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Email / Phone:</td>
                                <td style="font-weight:700;">\${acc.jointEmail || 'N/A'} / \${acc.jointPhone || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">PAN Card / Aadhaar:</td>
                                <td style="font-weight:700; font-family:monospace;">\${acc.jointPan || 'N/A'} / \${acc.jointAadhaar || 'N/A'}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Annual Income:</td>
                                <td style="font-weight:700; color: var(--accent-emerald);">₹ \${parseFloat(acc.jointIncome || 0).toLocaleString('en-IN', {minimumFractionDigits: 2})}</td>
                            </tr>
                            <tr>
                                <td style="color:var(--gray-500);">Registered Address:</td>
                                <td style="font-weight:700;">\${acc.jointAddress ? acc.jointAddress + ', ' + acc.jointCity + ', ' + acc.jointState + ' - ' + acc.jointZip : 'N/A'}</td>
                            </tr>
                        </table>
                    </div>
                `;
            }

            body.innerHTML = detailsHtml;
            openModal('viewAccountModal');
        }

        // Edit details modal population
        function openEditModal(index) {
            var acc = accountsData[index];
            document.getElementById('editAccountId').value = acc.accountId;
            document.getElementById('editIfsc').value = acc.ifscCode;
            document.getElementById('editStatus').value = acc.status;

            document.getElementById('editAtmCard').checked = acc.hasAtmCard;
            document.getElementById('editChequeBook').checked = acc.hasChequeBook;
            document.getElementById('editPassbook').checked = acc.hasPassbook;

            var savingsBlock = document.getElementById('savingsEditFields');
            var currentBlock = document.getElementById('currentEditFields');

            if (acc.accountType === 'savings') {
                savingsBlock.style.display = 'block';
                currentBlock.style.display = 'none';
                document.getElementById('editNominee').value = acc.nomineeName || '';
                document.getElementById('editHoldingType').value = acc.holdingType || 'single';
                document.getElementById('editDailyLimit').value = acc.dailyWithdrawalLimit || '';

                // Populate primary customer details
                document.getElementById('editFirstName').value = acc.primaryFirstName || '';
                document.getElementById('editMiddleName').value = acc.primaryMiddleName || '';
                document.getElementById('editLastName').value = acc.primaryLastName || '';
                document.getElementById('editDob').value = acc.customerDob || '';
                document.getElementById('editGender').value = acc.primaryGender || 'male';
                document.getElementById('editMarital').value = acc.primaryMaritalStatus || 'single';
                document.getElementById('editEmail').value = acc.primaryEmail || '';
                document.getElementById('editPhone').value = acc.primaryPhone || '';
                document.getElementById('editIncome').value = acc.primaryIncome || '';
                document.getElementById('editOcc').value = acc.primaryOccupation || '';
                document.getElementById('editPan').value = acc.primaryPan || '';
                document.getElementById('editAadhaar').value = acc.primaryAadhaar || '';
                document.getElementById('editAddress').value = acc.primaryAddress || '';
                document.getElementById('editCity').value = acc.primaryCity || '';
                document.getElementById('editState').value = acc.primaryState || '';
                document.getElementById('editZip').value = acc.primaryZip || '';

                // Populate joint customer details
                var jointFields = document.getElementById('jointCustomerEditFields');
                if (acc.holdingType === 'joint') {
                    jointFields.style.display = 'block';
                    document.getElementById('editJointFirstName').value = acc.jointFirstName || '';
                    document.getElementById('editJointMiddleName').value = acc.jointMiddleName || '';
                    document.getElementById('editJointLastName').value = acc.jointLastName || '';
                    document.getElementById('editJointDob').value = acc.jointDob || '';
                    document.getElementById('editJointGender').value = acc.jointGender || 'male';
                    document.getElementById('editJointMarital').value = acc.jointMaritalStatus || 'single';
                    document.getElementById('editJointEmail').value = acc.jointEmail || '';
                    document.getElementById('editJointPhone').value = acc.jointPhone || '';
                    document.getElementById('editJointIncome').value = acc.jointIncome || '';
                    document.getElementById('editJointOcc').value = acc.jointOccupation || '';
                    document.getElementById('editJointPan').value = acc.jointPan || '';
                    document.getElementById('editJointAadhaar').value = acc.jointAadhaar || '';
                    document.getElementById('editJointAddress').value = acc.jointAddress || '';
                    document.getElementById('editJointCity').value = acc.jointCity || '';
                    document.getElementById('editJointState').value = acc.jointState || '';
                    document.getElementById('editJointZip').value = acc.jointZip || '';
                } else {
                    jointFields.style.display = 'none';
                    // Clear joint inputs
                    document.getElementById('editJointFirstName').value = '';
                    document.getElementById('editJointMiddleName').value = '';
                    document.getElementById('editJointLastName').value = '';
                    document.getElementById('editJointDob').value = '';
                    document.getElementById('editJointGender').value = 'male';
                    document.getElementById('editJointMarital').value = 'single';
                    document.getElementById('editJointEmail').value = '';
                    document.getElementById('editJointPhone').value = '';
                    document.getElementById('editJointIncome').value = '';
                    document.getElementById('editJointOcc').value = '';
                    document.getElementById('editJointPan').value = '';
                    document.getElementById('editJointAadhaar').value = '';
                    document.getElementById('editJointAddress').value = '';
                    document.getElementById('editJointCity').value = '';
                    document.getElementById('editJointState').value = '';
                    document.getElementById('editJointZip').value = '';
                }
                updateEditRequiredFields('savings', acc.holdingType);
            } else {
                savingsBlock.style.display = 'none';
                currentBlock.style.display = 'block';
                document.getElementById('editBusinessName').value = acc.businessName || '';
                document.getElementById('editGstin').value = acc.gstin || '';
                document.getElementById('editOverdraft').value = acc.overdraftLimit || '';
                document.getElementById('editCompanyCategory').value = acc.companyCategory || '';
                document.getElementById('editCompanyPan').value = acc.companyPan || '';
                document.getElementById('editCompanyAadhaar').value = acc.companyAadhaar || '';
                document.getElementById('editCompanyPhone').value = acc.companyPhone || '';
                document.getElementById('editCompanyEmail').value = acc.companyEmail || '';
                document.getElementById('editCompanyAddress').value = acc.companyAddress || '';

                updateEditRequiredFields('current', 'single');
            }

            openModal('editAccountModal');
        }

        function toggleEditHoldingType() {
            var holdingType = document.getElementById('editHoldingType').value;
            var jointFields = document.getElementById('jointCustomerEditFields');
            if (holdingType === 'joint') {
                jointFields.style.display = 'block';
            } else {
                jointFields.style.display = 'none';
            }
            updateEditRequiredFields('savings', holdingType);
        }

        function updateEditRequiredFields(accountType, holdingType) {
            var primaryInputs = [
                'editFirstName', 'editLastName', 'editDob', 'editGender',
                'editEmail', 'editPhone', 'editPan', 'editAadhaar',
                'editAddress', 'editCity', 'editState', 'editZip'
            ];
            var jointInputs = [
                'editJointFirstName', 'editJointLastName', 'editJointDob', 'editJointGender',
                'editJointEmail', 'editJointPhone', 'editJointPan', 'editJointAadhaar',
                'editJointAddress', 'editJointCity', 'editJointState', 'editJointZip'
            ];

            if (accountType === 'savings') {
                primaryInputs.forEach(function(id) {
                    var elem = document.getElementById(id);
                    if (elem) elem.setAttribute('required', 'required');
                });

                if (holdingType === 'joint') {
                    jointInputs.forEach(function(id) {
                        var elem = document.getElementById(id);
                        if (elem) elem.setAttribute('required', 'required');
                    });
                } else {
                    jointInputs.forEach(function(id) {
                        var elem = document.getElementById(id);
                        if (elem) elem.removeAttribute('required');
                    });
                }
            } else {
                primaryInputs.forEach(function(id) {
                    var elem = document.getElementById(id);
                    if (elem) elem.removeAttribute('required');
                });
                jointInputs.forEach(function(id) {
                    var elem = document.getElementById(id);
                    if (elem) elem.removeAttribute('required');
                });
            }
        }

        var closingAccountId = 0;
        function openCloseModal(index) {
            var acc = accountsData[index];
            closingAccountId = acc.accountId;

            document.getElementById('closeAccNum').textContent = acc.accountNumber;
            document.getElementById('closeAccType').textContent = acc.accountType;
            document.getElementById('closeHolderName').textContent = acc.customerName;
            document.getElementById('closeBalance').textContent = "₹ " + acc.balance.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('closeStatus').textContent = acc.status;

            openModal('closeAccountModal');
        }

        function confirmCloseAccount() {
            if (closingAccountId > 0) {
                window.location.href = "${pageContext.request.contextPath}/account?action=close&id=" + closingAccountId;
            }
        }

        // WIZARD WIDE STEP MANAGEMENT
        function openWizardModal() {
            currentWizardStep = 1;
            updateWizardStepUI();

            // Clean/Reset some forms
            document.getElementById('createAccountForm').reset();
            document.getElementById('partnerCountInput').value = "1";
            document.getElementById('wizDeposit').value = "1000.00";

            // Clear extra partners
            var container = document.getElementById('dynamicPartnersContainer');
            var card1 = document.getElementById('partner_card_1');
            container.innerHTML = '';
            container.appendChild(card1);

            selectAccountCategory('savings_single');
            openModal('createAccountModal');
        }

        function selectAccountCategory(cat) {
            var opt1 = document.getElementById('optSavingsSingle');
            var opt2 = document.getElementById('optSavingsJoint');
            var opt3 = document.getElementById('optCurrent');

            opt1.style.borderColor = 'var(--gray-200)'; opt1.style.background = 'white';
            opt2.style.borderColor = 'var(--gray-200)'; opt2.style.background = 'white';
            opt3.style.borderColor = 'var(--gray-200)'; opt3.style.background = 'white';

            var wizType = document.getElementById('wizAccountType');
            var wizHold = document.getElementById('wizHoldingType');
            var depositInput = document.getElementById('wizDeposit');
            var minDepositNote = document.getElementById('wizMinDepositNote');

            if (cat === 'savings_single') {
                opt1.style.borderColor = 'var(--primary-500)'; opt1.style.background = 'rgba(99,102,241,0.03)';
                wizType.value = 'savings';
                wizHold.value = 'single';
                depositInput.value = "1000.00";
                minDepositNote.textContent = "Minimum initial amount required is ₹1,000.00.";
            } else if (cat === 'savings_joint') {
                opt2.style.borderColor = 'var(--secondary-500)'; opt2.style.background = 'rgba(236,72,153,0.03)';
                wizType.value = 'savings';
                wizHold.value = 'joint';
                depositInput.value = "1000.00";
                minDepositNote.textContent = "Minimum initial amount required is ₹1,000.00.";
            } else {
                opt3.style.borderColor = 'var(--accent-emerald)'; opt3.style.background = 'rgba(16,185,129,0.03)';
                wizType.value = 'current';
                wizHold.value = 'single';
                depositInput.value = "5000.00";
                minDepositNote.textContent = "Minimum initial amount required is ₹5,000.00.";
            }
            updateChequeAmount(depositInput.value);
        }

        function updateWizardStepUI() {
            // Hide all steps
            for (var i = 1; i <= 7; i++) {
                document.getElementById('step' + i).classList.remove('active');
                document.getElementById('node' + i).classList.remove('active', 'completed');
                document.getElementById('node' + i).style.display = ''; // reset display
            }

            var wizType = document.getElementById('wizAccountType').value;
            var wizHold = document.getElementById('wizHoldingType').value;
            if (wizType === 'current') {
                // Current has no step 3 (Nominee)
                document.getElementById('node3').style.display = 'none';
            }

            // Toggle step 2 container sub-fields visibility
            var singleFields = document.getElementById('wizSavingsSingleFields');
            var jointFields = document.getElementById('wizSavingsJointFields');
            var currentFields = document.getElementById('wizCurrentFields');

            if (wizType === 'savings') {
                if (singleFields) singleFields.style.display = 'block';
                if (jointFields) jointFields.style.display = (wizHold === 'joint') ? 'block' : 'none';
                if (currentFields) currentFields.style.display = 'none';
            } else if (wizType === 'current') {
                if (singleFields) singleFields.style.display = 'none';
                if (jointFields) jointFields.style.display = 'none';
                if (currentFields) currentFields.style.display = 'block';
            }

            // Set node states
            for (var i = 1; i <= 7; i++) {
                var node = document.getElementById('node' + i);
                if (i < currentWizardStep) {
                    node.classList.add('completed');
                } else if (i === currentWizardStep) {
                    node.classList.add('active');
                }
            }

            // Set active step visibility
            document.getElementById('step' + currentWizardStep).classList.add('active');

            // Set line indicator width
            var activeNodesCount = 0;
            var totalVisibleNodes = 0;
            for (var i = 1; i <= 7; i++) {
                var n = document.getElementById('node' + i);
                if (n.style.display !== 'none') {
                    totalVisibleNodes++;
                    if (i <= currentWizardStep) {
                        activeNodesCount++;
                    }
                }
            }
            var linePct = ((activeNodesCount - 1) / (totalVisibleNodes - 1)) * 100;
            document.getElementById('stepLine').style.width = linePct + '%';

            // Set buttons state
            var prevBtn = document.getElementById('wizPrevBtn');
            var nextBtn = document.getElementById('wizNextBtn');
            var submitBtn = document.getElementById('wizSubmitBtn');

            prevBtn.style.display = currentWizardStep === 1 ? 'none' : '';
            nextBtn.style.display = currentWizardStep === 7 ? 'none' : '';
            submitBtn.style.display = currentWizardStep === 7 ? '' : 'none';

            if (currentWizardStep === 4) {
                // ATM, Cheque and Passbook designs - hide/show assets depending on checkboxes
                toggleWizardAssetView('atm');
                toggleWizardAssetView('cheque');
                toggleWizardAssetView('passbook');
                
                var passbookLabel = document.getElementById('wizPassbookLabel');
                if (wizType === 'current') {
                    // Passbook not available for current accounts
                    document.getElementById('wizPassbook').checked = false;
                    passbookLabel.style.display = 'none';
                    document.getElementById('wizPassbookVisualizer').style.display = 'none';
                } else {
                    passbookLabel.style.display = '';
                }
            }

            if (currentWizardStep === 5) {
                // Generate secure random values
                if (!document.getElementById('wizPin').value) {
                    var randPin = Math.floor(1000 + Math.random() * 9000);
                    document.getElementById('wizPin').value = randPin;
                    document.getElementById('p1_pin').value = randPin;
                    
                    // Generate random login username & passwords
                    var wizHold = document.getElementById('wizHoldingType').value;
                    var randNum = Math.floor(100 + Math.random() * 900);
                    
                    if (wizType === 'savings') {
                        var first = document.getElementById('wizFirst').value.toLowerCase().replace(/[^a-z]/g, '');
                        var last = document.getElementById('wizLast').value.toLowerCase().replace(/[^a-z]/g, '');
                        document.getElementById('wizUsername').value = (first + last).substring(0, 8) + randNum;
                        document.getElementById('wizPassword').value = "VgbPass" + randPin;
                        
                        if (wizHold === 'joint') {
                            var jfirst = document.getElementById('wizJointFirst').value.toLowerCase().replace(/[^a-z]/g, '');
                            var jlast = document.getElementById('wizJointLast').value.toLowerCase().replace(/[^a-z]/g, '');
                            document.getElementById('wizJointUser').value = (jfirst + jlast).substring(0, 8) + randNum;
                            document.getElementById('wizJointPass').value = "VgbPass" + (randPin + 1);
                            document.getElementById('wizJointPin').value = randPin;
                        }
                    } else {
                        var bus = document.getElementById('wizBusName').value.toLowerCase().replace(/[^a-z]/g, '');
                        document.getElementById('wizUsername').value = bus.substring(0, 8) + randNum;
                        document.getElementById('wizPassword').value = "VgbCorp" + randPin;
                        document.getElementById('p1_pin').value = randPin;
                        
                        // Auto-generate credentials for Corporate Partner 1
                        var p1First = document.getElementById('p1_first').value.toLowerCase().replace(/[^a-z]/g, '');
                        var p1Last = document.getElementById('p1_last').value.toLowerCase().replace(/[^a-z]/g, '');
                        document.getElementById('p1_user').value = (p1First + p1Last).substring(0, 8) + randNum;
                        document.getElementById('p1_pass').value = "VgbPass" + (randPin + 1);

                        // Auto-generate credentials for any additional dynamic partners
                        for (var p = 2; p <= partnerCount; p++) {
                            var fInput = document.querySelector('input[name="partner_firstName_' + p + '"]');
                            var lInput = document.querySelector('input[name="partner_lastName_' + p + '"]');
                            var uInput = document.querySelector('input[name="partner_username_' + p + '"]');
                            var pInput = document.querySelector('input[name="partner_password_' + p + '"]');
                            
                            if (fInput && lInput && uInput && pInput) {
                                var pFirst = fInput.value.toLowerCase().replace(/[^a-z]/g, '');
                                var pLast = lInput.value.toLowerCase().replace(/[^a-z]/g, '');
                                uInput.value = (pFirst + pLast).substring(0, 8) + (randNum + p - 1);
                                pInput.value = "VgbPass" + (randPin + p);
                            }
                        }
                    }
                }
                
                // Show/hide joint auth display fields and sync values
                var wizHold = document.getElementById('wizHoldingType').value;
                var wizJointAuthRow = document.getElementById('wizJointAuthRow');
                if (wizJointAuthRow) {
                    if (wizType === 'savings' && wizHold === 'joint') {
                        wizJointAuthRow.style.display = 'flex';
                        var userVal = document.getElementById('wizJointUser').value;
                        var passVal = document.getElementById('wizJointPass').value;
                        document.getElementById('wizJointUserDisplay').value = userVal;
                        document.getElementById('wizJointPassDisplay').value = passVal;
                    } else {
                        wizJointAuthRow.style.display = 'none';
                    }
                }

                // Show/hide corporate partners auth display fields and sync values
                var wizPartnersAuthSection = document.getElementById('wizPartnersAuthSection');
                var wizPartnersAuthContainer = document.getElementById('wizPartnersAuthContainer');
                if (wizPartnersAuthSection && wizPartnersAuthContainer) {
                    if (wizType === 'current') {
                        wizPartnersAuthSection.style.display = 'block';
                        var html = '';
                        
                        // Partner 1
                        var p1First = document.getElementById('p1_first').value;
                        var p1Last = document.getElementById('p1_last').value;
                        var p1User = document.getElementById('p1_user').value;
                        var p1Pass = document.getElementById('p1_pass').value;
                        html += `
                            <div style="margin-bottom:15px; background:rgba(99,102,241,0.01); padding:12px; border-radius:var(--radius-sm); border:1px solid var(--gray-100);">
                                <div style="font-weight:700; font-size:0.8rem; color:var(--gray-800); margin-bottom:5px;">\${p1First} \${p1Last} (Partner #1)</div>
                                <div style="display:flex; gap:15px; font-size:0.8rem;">
                                    <span><strong>Username:</strong> \${p1User}</span>
                                    <span><strong>Password:</strong> \${p1Pass}</span>
                                </div>
                            </div>
                        `;
                        
                        // Dynamic partners
                        for (var p = 2; p <= partnerCount; p++) {
                            var fInput = document.querySelector('input[name="partner_firstName_' + p + '"]');
                            var lInput = document.querySelector('input[name="partner_lastName_' + p + '"]');
                            var uInput = document.querySelector('input[name="partner_username_' + p + '"]');
                            var pInput = document.querySelector('input[name="partner_password_' + p + '"]');
                            
                            if (fInput && lInput && uInput && pInput) {
                                html += `
                                    <div style="margin-bottom:15px; background:rgba(99,102,241,0.01); padding:12px; border-radius:var(--radius-sm); border:1px solid var(--gray-100);">
                                        <div style="font-weight:700; font-size:0.8rem; color:var(--gray-800); margin-bottom:5px;">\${fInput.value} \${lInput.value} (Partner #\${p})</div>
                                        <div style="display:flex; gap:15px; font-size:0.8rem;">
                                            <span><strong>Username:</strong> \${uInput.value}</span>
                                            <span><strong>Password:</strong> \${pInput.value}</span>
                                        </div>
                                    </div>
                                `;
                            }
                        }
                        wizPartnersAuthContainer.innerHTML = html;
                    } else {
                        wizPartnersAuthSection.style.display = 'none';
                    }
                }
            }

            if (currentWizardStep === 7) {
                // Bind all names inside cheque and passbook review
                var wizHold = document.getElementById('wizHoldingType').value;
                if (wizType === 'savings') {
                    var first = document.getElementById('wizFirst').value;
                    var last = document.getElementById('wizLast').value;
                    var name = first + " " + last;
                    document.getElementById('wizCardHolderName').textContent = name.toUpperCase();
                    document.getElementById('wizChequeSign').textContent = name;
                    document.getElementById('pbWizName').textContent = name.toUpperCase();
                } else {
                    var bus = document.getElementById('wizBusName').value;
                    var first = document.getElementById('p1_first').value;
                    var last = document.getElementById('p1_last').value;
                    document.getElementById('wizCardHolderName').textContent = bus.substring(0, 19).toUpperCase();
                    document.getElementById('wizChequeSign').textContent = first + " " + last;
                }
                
                // Build final summary card
                buildSummaryScreen();
            }
        }

        function navigateWizardStep(val) {
            var target = currentWizardStep + val;
            var wizType = document.getElementById('wizAccountType').value;

            if (val > 0) {
                // Validate before proceeding to next step
                if (!validateWizardStep(currentWizardStep)) return;
            }

            if (wizType === 'current' && target === 3) {
                // Skip nominee step for current accounts
                currentWizardStep = val > 0 ? 4 : 2;
            } else {
                currentWizardStep = target;
            }

            updateWizardStepUI();
        }

        function validateWizardStep(step) {
            if (step === 2) {
                var wizType = document.getElementById('wizAccountType').value;
                var wizHold = document.getElementById('wizHoldingType').value;

                if (wizType === 'savings') {
                    // Check primary customer inputs
                    var fields = ['wizFirst', 'wizLast', 'wizDob', 'wizEmail', 'wizPhone', 'wizPan', 'wizAadhaar', 'wizAddress', 'wizCity', 'wizState', 'wizZip'];
                    for (var i = 0; i < fields.length; i++) {
                        var inp = document.getElementById(fields[i]);
                        if (!inp.value.trim()) {
                            alert("Please fill in all primary customer details.");
                            inp.focus();
                            return false;
                        }
                    }
                    // Aadhaar validation
                    var aadh = document.getElementById('wizAadhaar').value.trim();
                    if (aadh.length !== 12 || isNaN(aadh)) {
                        alert("Aadhaar Card number must be exactly 12 numeric digits.");
                        return false;
                    }

                    if (wizHold === 'joint') {
                        // Check joint inputs
                        var jFields = ['wizJointFirst', 'wizJointLast', 'wizJointDob', 'wizJointEmail', 'wizJointPhone', 'wizJointPan', 'wizJointAadhaar', 'wizJointAddress', 'wizJointCity', 'wizJointState', 'wizJointZip'];
                        for (var i = 0; i < jFields.length; i++) {
                            var inp = document.getElementById(jFields[i]);
                            if (!inp.value.trim()) {
                                alert("Please fill in all second joint holder details.");
                                inp.focus();
                                return false;
                            }
                        }
                        var jaadh = document.getElementById('wizJointAadhaar').value.trim();
                        if (jaadh.length !== 12 || isNaN(jaadh)) {
                            alert("Joint holder Aadhaar Card number must be exactly 12 numeric digits.");
                            return false;
                        }
                    }
                } else {
                    // Check corporate inputs
                    var cFields = ['wizBusName', 'wizGstin', 'wizBusPan', 'wizBusAadh', 'wizBusPhone', 'wizBusEmail', 'wizBusAddr'];
                    for (var i = 0; i < cFields.length; i++) {
                        var inp = document.getElementById(cFields[i]);
                        if (!inp.value.trim()) {
                            alert("Please fill in all corporate company details.");
                            inp.focus();
                            return false;
                        }
                    }
                    var gstin = document.getElementById('wizGstin').value.trim();
                    if (gstin.length !== 15) {
                        alert("GSTIN must be exactly 15 characters long.");
                        return false;
                    }
                    // Validate partner 1
                    var p1Fields = ['p1_first', 'p1_last'];
                    for (var i = 0; i < p1Fields.length; i++) {
                        var inp = document.getElementById(p1Fields[i]);
                        if (!inp.value.trim()) {
                            alert("Please fill in partner #1 legal name details.");
                            inp.focus();
                            return false;
                        }
                    }
                }
            } else if (step === 5) {
                var user = document.getElementById('wizUsername').value.trim();
                var pass = document.getElementById('wizPassword').value.trim();

                if (user.length < 4) {
                    alert("Signatory username must be at least 4 characters.");
                    return false;
                }
                if (pass.length < 6) {
                    alert("Signatory password must be at least 6 characters.");
                    return false;
                }
            } else if (step === 6) {
                var dep = parseFloat(document.getElementById('wizDeposit').value);
                var wizType = document.getElementById('wizAccountType').value;
                var minReq = wizType === 'current' ? 5000.00 : 1000.00;
                if (isNaN(dep) || dep < minReq) {
                    alert("Validation failed: Initial amount paid must be at least ₹" + minReq.toFixed(2));
                    return false;
                }
            }
            return true;
        }

        // ATM, Cheque and Passbook 3D visualization triggers
        function toggleWizardAssetView(type) {
            var wizType = document.getElementById('wizAccountType').value;
            if (type === 'atm') {
                var checked = document.getElementById('wizAtmCard').checked;
                document.getElementById('wizCardVisualizer').style.display = checked ? 'flex' : 'none';
            } else if (type === 'cheque') {
                var checked = document.getElementById('wizChequeBook').checked;
                document.getElementById('wizChequeVisualizer').style.display = checked ? 'flex' : 'none';
            } else if (type === 'passbook') {
                var checked = document.getElementById('wizPassbook').checked;
                document.getElementById('wizPassbookVisualizer').style.display = checked ? 'flex' : 'none';
            }
        }

        function updateCardProvider(val) {
            var card = document.getElementById('3dAtmCard');
            var logo = document.getElementById('wizCardBrandLogo');
            card.className = "vgb-atm-card " + val;

            logo.className = "card-brand-logo";
            if (val === 'visa') {
                logo.innerHTML = '<div class="brand-visa"><span class="visa-text">Visa</span><span class="visa-sub">debit</span></div>';
            } else if (val === 'mastercard') {
                logo.innerHTML = '<div class="brand-mastercard"><div class="mc-circles"><div class="circle red"></div><div class="circle orange"></div></div><span class="mc-text">mastercard</span></div>';
            } else {
                logo.innerHTML = '<div class="brand-rupay"><span class="rupay-text">RuPay</span><span class="rupay-sub">platinum</span></div>';
            }
        }

        function flip3DCard() {
            var card = document.getElementById('3dAtmCard');
            card.classList.toggle('flipped');
        }

        function toggleChequeOpen() {
            // Cheque details alert
            var chq = document.querySelector('.vgb-cheque-3d');
            chq.style.transform = "scale(1.05) rotateX(15deg) rotateY(-5deg)";
            setTimeout(function () {
                chq.style.transform = "";
            }, 800);
        }

        function toggleWizardPassbook() {
            var book = document.getElementById('3dWizardPassbook');
            book.classList.toggle('open');
        }

        function updateChequeAmount(val) {
            var num = parseFloat(val);
            if (!isNaN(num)) {
                document.getElementById('wizChequeAmount').textContent = "***" + num.toLocaleString('en-IN', { minimumFractionDigits: 2 });
                document.getElementById('wizChequeWords').textContent = numberToWords(num) + " Rupees Only";
            }
        }

        // Dynamic Partners Input fields
        var partnerCount = 1;
        function addNewPartnerField() {
            partnerCount++;
            document.getElementById('partnerCountInput').value = partnerCount;

            var container = document.getElementById('dynamicPartnersContainer');
            var cardHtml = `
                <div class="partner-card" id="partner_card_\${partnerCount}">
                    <span class="remove-partner-btn" onclick="removePartnerField(\${partnerCount})"><i class="bx bx-trash"></i></span>
                    <h5 style="font-size:0.85rem; font-weight:700; color:var(--primary-500); margin-bottom:15px;">Partner Profile #\${partnerCount}</h5>
                    <div class="form-row row-3">
                        <div class="form-group">
                            <label>First Name *</label>
                            <input type="text" name="partner_firstName_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>Middle Name</label>
                            <input type="text" name="partner_middleName_\${partnerCount}">
                        </div>
                        <div class="form-group">
                            <label>Last Name *</label>
                            <input type="text" name="partner_lastName_\${partnerCount}" required>
                        </div>
                    </div>
                    <div class="form-row row-3">
                        <div class="form-group">
                            <label>Date of Birth *</label>
                            <input type="date" name="partner_dob_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>Gender *</label>
                            <select name="partner_gender_\${partnerCount}">
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Marital Status</label>
                            <select name="partner_maritalStatus_\${partnerCount}">
                                <option value="single">Single</option>
                                <option value="married">Married</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row row-3">
                        <div class="form-group">
                            <label>Email *</label>
                            <input type="email" name="partner_email_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>Phone *</label>
                            <input type="text" name="partner_phone_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>PAN Card *</label>
                            <input type="text" name="partner_pan_\${partnerCount}" required>
                        </div>
                    </div>
                    <div class="form-row row-3">
                        <div class="form-group">
                            <label>Aadhaar Card *</label>
                            <input type="text" name="partner_aadhaar_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>Partner Address *</label>
                            <input type="text" name="partner_address_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>City *</label>
                            <input type="text" name="partner_city_\${partnerCount}" required>
                        </div>
                    </div>
                    <div class="form-row row-3">
                        <div class="form-group">
                            <label>State *</label>
                            <input type="text" name="partner_state_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>Zip Code *</label>
                            <input type="text" name="partner_zip_\${partnerCount}" required>
                        </div>
                        <div class="form-group">
                            <label>Annual Income *</label>
                            <input type="number" name="partner_income_\${partnerCount}" value="500000">
                        </div>
                    </div>
                    <div class="form-row row-3">
                        <div class="form-group">
                            <label>Occupation</label>
                            <input type="text" name="partner_occupation_\${partnerCount}" value="Business">
                        </div>
                    </div>
                    <input type="hidden" name="partner_username_\${partnerCount}">
                    <input type="hidden" name="partner_password_\${partnerCount}">
                    <!-- Hidden PIN input -->
                    <input type="hidden" name="partner_pin_\${partnerCount}" value="\${document.getElementById('wizPin').value}">
                </div>
            `;

            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = cardHtml;
            container.appendChild(tempDiv.firstElementChild);
        }

        function removePartnerField(id) {
            var card = document.getElementById('partner_card_' + id);
            if (card) {
                card.remove();
                partnerCount--;
                document.getElementById('partnerCountInput').value = partnerCount;
            }
        }

        // Build review screen summary content
        function buildSummaryScreen() {
            var wizType = document.getElementById('wizAccountType').value;
            var wizHold = document.getElementById('wizHoldingType').value;
            var name = "";
            var detailsHtml = "";

            var atm = document.getElementById('wizAtmCard').checked ? '✓ ATM Card Active (' + document.getElementById('wizCardProvider').value.toUpperCase() + ')' : '✗ No Card';
            var cheque = document.getElementById('wizChequeBook').checked ? '✓ Cheque Book Active' : '✗ No Cheque Book';
            var pass = document.getElementById('wizPassbook').checked ? '✓ Passbook Booklet' : '✗ No Passbook';

            var user = document.getElementById('wizUsername').value;
            var pin = document.getElementById('wizPin').value;
            var amount = parseFloat(document.getElementById('wizDeposit').value).toFixed(2);

            var checkText = document.getElementById('mandateLabelText');

            if (wizType === 'savings') {
                name = document.getElementById('wizFirst').value + " " + document.getElementById('wizLast').value;
                var nominee = document.getElementById('wizNominee').value || "No Nominee";

                detailsHtml = `
                    <h5 style="font-weight:700; color:var(--gray-800); font-size:0.95rem; margin-bottom:12px; border-bottom:1px solid var(--gray-200); padding-bottom:5px;">Savings Account Details</h5>
                    <table style="width:100%; font-size:0.85rem; line-height:1.7;">
                        <tr><td style="color:var(--gray-500); width:35%;">Applicant Name:</td><td style="font-weight:700; color:var(--gray-800);">\${name.toUpperCase()}</td></tr>
                        <tr><td style="color:var(--gray-500);">Holding Mode:</td><td style="font-weight:700; text-transform:uppercase;">\${wizHold}</td></tr>
                        <tr><td style="color:var(--gray-500);">Nominee:</td><td style="font-weight:700;">\${nominee}</td></tr>
                        <tr><td style="color:var(--gray-500);">ATM & Services:</td><td style="font-weight:600; color:var(--primary-500);">\${atm} | \${cheque} | \${pass}</td></tr>
                        <tr><td style="color:var(--gray-500);">Login Username:</td><td style="font-weight:700; font-family:monospace;">\${user}</td></tr>
                        <tr><td style="color:var(--gray-500); font-weight:700;">Initial Deposit Amount:</td><td style="font-weight:800; color:var(--accent-emerald); font-size:1rem;">₹ \${amount}</td></tr>
                        <tr style="border-top:1px dashed var(--gray-200); padding-top:5px; margin-top:5px;"><td style="color:var(--primary-500); font-weight:700;">Auto-Generated PIN:</td><td style="font-weight:800; color:var(--primary-700); font-size:1.1rem; letter-spacing:2px; font-family:monospace;">\${pin}</td></tr>
                    </table>
                `;
                checkText.textContent = "I confirm that I have verified the identity cards, address validation, initial deposit of ₹" + amount + ", and mandate signatures for " + name.toUpperCase() + " to open this Savings Account.";
            } else {
                name = document.getElementById('wizBusName').value;
                var gstin = document.getElementById('wizGstin').value;

                detailsHtml = `
                    <h5 style="font-weight:700; color:var(--gray-800); font-size:0.95rem; margin-bottom:12px; border-bottom:1px solid var(--gray-200); padding-bottom:5px;">Current Corporate Account Details</h5>
                    <table style="width:100%; font-size:0.85rem; line-height:1.7;">
                        <tr><td style="color:var(--gray-500); width:35%;">Business Name:</td><td style="font-weight:700; color:var(--gray-800);">\${name.toUpperCase()}</td></tr>
                        <tr><td style="color:var(--gray-500);">GSTIN Registration:</td><td style="font-weight:700; font-family:monospace;">\${gstin}</td></tr>
                        <tr><td style="color:var(--gray-500);">ATM & Services:</td><td style="font-weight:600; color:var(--primary-500);">\${atm} | \${cheque} | \${pass}</td></tr>
                        <tr><td style="color:var(--gray-500);">Corporate Partners:</td><td style="font-weight:700;">\${partnerCount} registered partners</td></tr>
                        <tr><td style="color:var(--gray-500);">Primary Login User:</td><td style="font-weight:700; font-family:monospace;">\${user}</td></tr>
                        <tr><td style="color:var(--gray-500); font-weight:700;">Initial Corporate Deposit:</td><td style="font-weight:800; color:var(--accent-emerald); font-size:1rem;">₹ \${amount}</td></tr>
                        <tr style="border-top:1px dashed var(--gray-200); padding-top:5px; margin-top:5px;"><td style="color:var(--primary-500); font-weight:700;">Auto-Generated PIN:</td><td style="font-weight:800; color:var(--primary-700); font-size:1.1rem; letter-spacing:2px; font-family:monospace;">\${pin}</td></tr>
                    </table>
                `;
                checkText.textContent = "I confirm that I have verified the corporate registration documents, GSTIN number, initial deposit of ₹" + amount + ", and signatures of all partners for " + name.toUpperCase() + " to open this Current Account.";
            }

            document.getElementById('wizSummaryCard').innerHTML = detailsHtml;
            document.getElementById('wizMandateCheckbox').checked = false;
            document.getElementById('wizSubmitBtn').disabled = true;
        }

        function toggleWizardMandateState(checked) {
            document.getElementById('wizSubmitBtn').disabled = !checked;
        }

        function validateWizardFormSubmit() {
            var dep = parseFloat(document.getElementById('wizDeposit').value);
            var wizType = document.getElementById('wizAccountType').value;
            var minReq = wizType === 'current' ? 5000.00 : 1000.00;

            if (dep < minReq) {
                alert("Deposit must meet minimum requirement!");
                return false;
            }

            var mandate = document.getElementById('wizMandateCheckbox').checked;
            if (!mandate) {
                alert("You must verify the mandate checkbox before submitting!");
                return false;
            }
            return true;
        }

        // ==========================================
        // AJAX-BASED STATEMENT VIEW OVERLAY
        // ==========================================
        var statementTransactionsList = [];
        var statementAccountId = 0;
        var statementAccountBalance = 0;

        function openStatementModal(accountId, customerName, accountNumber, accountType, totalBalance, status) {
            statementAccountId = accountId;
            statementAccountBalance = totalBalance;

            var acc = accountsData.find(a => a.accountId === accountId);

            // Set customer detail labels in statement layout
            document.getElementById('lblStmtName').textContent = customerName.toUpperCase();
            document.getElementById('lblStmtCustId').textContent = "#VGB-CUST-" + acc.customerId;
            document.getElementById('lblStmtAccNum').textContent = "#" + accountNumber;
            document.getElementById('lblStmtAccType').textContent = accountType;
            
            var address = "";
            if (acc.accountType === 'savings') {
                address = (acc.primaryAddress || "") + ", " + (acc.primaryCity || "") + ", " + (acc.primaryState || "") + " - " + (acc.primaryZip || "");
            } else {
                address = acc.companyAddress || "";
            }
            document.getElementById('lblStmtAddress').textContent = address;
            document.getElementById('lblStmtBalance').textContent = "₹ " + totalBalance.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

            // Set print and screen labels
            document.getElementById('lblStmtRef').textContent = "ACC-REF: #ACC-" + accountId;
            var compiledDate = new Date();
            var options = { month: 'long', day: 'numeric', year: 'numeric' };
            var datePart = compiledDate.toLocaleDateString('en-US', options);
            var timePart = compiledDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true });
            document.getElementById('lblStmtDateGenerated').textContent = datePart + " at " + timePart;

            // Reset filters
            document.getElementById('stmtDateFilter').value = 'all';
            document.getElementById('stmtTypeFilter').value = 'all';
            document.getElementById('stmtCustomDateGroup').style.display = 'none';

            // Show preloader
            document.getElementById('statementTxnTbody').innerHTML = '<tr><td colspan="8" style="text-align:center; padding:30px; color:var(--gray-400);"><i class="bx bx-loader-alt bx-spin" style="font-size:2rem; display:block; margin-bottom:10px;"></i> Fetching ledger entries...</td></tr>';

            openModal('statementModal');

            // Fetch transaction logs via AJAX
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '${pageContext.request.contextPath}/account?action=getTransactionsJson&accountId=' + accountId, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            statementTransactionsList = JSON.parse(xhr.responseText);
                            runStatementFilter();
                        } catch (e) {
                            console.error("Failed to parse JSON transaction log.", e);
                            document.getElementById('statementTxnTbody').innerHTML = '<tr><td colspan="8" style="text-align:center; color:#ef4444; padding:30px;">Error parsing transactions list.</td></tr>';
                        }
                    } else {
                        document.getElementById('statementTxnTbody').innerHTML = '<tr><td colspan="8" style="text-align:center; color:#ef4444; padding:30px;">Failed to fetch transactions from server.</td></tr>';
                    }
                }
            };
            xhr.send();
        }

        function runStatementFilter() {
            var dateVal = document.getElementById('stmtDateFilter').value;
            var typeVal = document.getElementById('stmtTypeFilter').value;

            var customGroup = document.getElementById('stmtCustomDateGroup');
            if (dateVal === 'custom') {
                customGroup.style.display = 'block';
            } else {
                customGroup.style.display = 'none';
            }

            var tbody = document.getElementById('statementTxnTbody');
            tbody.innerHTML = '';

            var now = new Date();
            var startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            var startOfCurrentMonth = new Date(now.getFullYear(), now.getMonth(), 1);

            // Last month boundaries
            var startOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
            var endOfLastMonth = new Date(now.getFullYear(), now.getMonth(), 0, 23, 59, 59, 999);

            var startOfCurrentYear = new Date(now.getFullYear(), 0, 1);

            let customStart = null;
            let customEnd = null;
            if (dateVal === 'custom') {
                var sVal = document.getElementById('stmtStartDate').value;
                var eVal = document.getElementById('stmtEndDate').value;
                if (sVal) {
                    customStart = new Date(sVal);
                    customStart.setHours(0, 0, 0, 0);
                }
                if (eVal) {
                    customEnd = new Date(eVal);
                    customEnd.setHours(23, 59, 59, 999);
                }
            }

            var filteredCount = 0;

            for (var i = 0; i < statementTransactionsList.length; i++) {
                var t = statementTransactionsList[i];

                // Parse date & time
                var dateStr = t.transactionDate.replace('T', ' ');
                var txnDate = new Date(dateStr);

                // 1. Filter Type check
                var isCredit = t.transactionType === 'deposit' || t.transactionType === 'interest' || (t.transactionType === 'transfer' && t.toAccountId === statementAccountId);
                var isDebit = t.transactionType === 'withdrawal' || t.transactionType === 'fee' || (t.transactionType === 'transfer' && t.fromAccountId === statementAccountId);

                var typeMatches = true;
                if (typeVal === 'received') {
                    typeMatches = isCredit;
                } else if (typeVal === 'paid') {
                    typeMatches = isDebit;
                }

                // 2. Filter Date check
                var dateMatches = true;
                if (!isNaN(txnDate.getTime())) {
                    if (dateVal === 'current_month') {
                        dateMatches = (txnDate >= startOfCurrentMonth);
                    } else if (dateVal === 'last_month') {
                        dateMatches = (txnDate >= startOfLastMonth && txnDate <= endOfLastMonth);
                    } else if (dateVal === 'year') {
                        dateMatches = (txnDate >= startOfCurrentYear);
                    } else if (dateVal === 'custom') {
                        if (customStart && txnDate < customStart) dateMatches = false;
                        if (customEnd && txnDate > customEnd) dateMatches = false;
                    }
                }

                if (typeMatches && dateMatches) {
                    filteredCount++;

                    var dateFormatted = txnDate.toLocaleDateString('en-GB');
                    var timeFormatted = txnDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' });

                    var amountClass = isCredit ? 'txn-deposit' : 'txn-withdrawal';

                    var detailsString = t.description;
                    if (t.referenceNumber) {
                        detailsString += ' <small style="display:block; color:var(--gray-400); font-family:monospace;">Ref: ' + t.referenceNumber + '</small>';
                    }

                    var statusPill = '<span style="background: rgba(16, 185, 129, 0.1); color: var(--accent-emerald); padding: 4px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 600; text-transform: uppercase;">' + (t.status || 'COMPLETED').toUpperCase() + '</span>';

                    var creditVal = isCredit ? '+ ₹ ' + t.amount.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-';
                    var debitVal = isDebit ? '- ₹ ' + t.amount.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-';
                    var runningBalFormatted = t.runningBalance.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

                    var rowHtml = `
                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.85rem; color: var(--gray-700);">
                            <td style="padding: 14px 16px; font-weight:600; color:var(--gray-400);"><span class="badge-id">#\${filteredCount}</span></td>
                            <td style="padding: 14px 16px;">\${dateFormatted} \${timeFormatted}</td>
                            <td style="padding: 14px 16px; text-transform: capitalize; font-weight: 600;"><span class="\${amountClass}">\${t.transactionType}</span></td>
                            <td style="padding: 14px 16px;">\${detailsString}</td>
                            <td style="padding: 14px 16px;">\${statusPill}</td>
                            <td style="padding: 14px 16px; text-align:right; font-weight:700; color: #10b981;">\${creditVal}</td>
                            <td style="padding: 14px 16px; text-align:right; font-weight:700; color: #ef4444;">\${debitVal}</td>
                            <td style="padding: 14px 16px; text-align:right; font-weight:700; color: #1e3a8a; font-family: monospace;">₹ \${runningBalFormatted}</td>
                        </tr>
                    `;
                    tbody.insertAdjacentHTML('beforeend', rowHtml);
                }
            }

            if (filteredCount === 0) {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:30px; color:var(--gray-400);">No transactions match selected filter queries.</td></tr>';
            }
        }

        // Numbers to Words converter for Cheque
        function numberToWords(num) {
            var a = ['', 'One ', 'Two ', 'Three ', 'Four ', 'Five ', 'Six ', 'Seven ', 'Eight ', 'Nine ', 'Ten ', 'Eleven ', 'Twelve ', 'Thirteen ', 'Fourteen ', 'Fifteen ', 'Sixteen ', 'Seventeen ', 'Eighteen ', 'Nineteen '];
            var b = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

            if ((num = num.toString()).length > 9) return 'overflow';
            var n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
            if (!n) return '';
            var str = '';
            str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'Crore ' : '';
            str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'Lakh ' : '';
            str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'Thousand ' : '';
            str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'Hundred ' : '';
            str += (n[5] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) : '';
            return str.trim();
        }

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
    </script>
</body>

</html>