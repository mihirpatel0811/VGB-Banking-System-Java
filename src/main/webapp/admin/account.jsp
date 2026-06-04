<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Manage Accounts</title>
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
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-lg);
            padding: 25px;
            box-shadow: var(--shadow-md);
            margin-bottom: 30px;
        }
        
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
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
            transition: transform var(--transition-normal);
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
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

        /* Search Control Bar styling */
        .control-hub {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        .search-wrapper {
            position: relative;
            flex: 1;
            min-width: 250px;
        }
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.25rem;
        }
        .search-input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            background: white;
            font-size: 0.9rem;
            color: var(--gray-800);
            font-family: inherit;
            transition: all var(--transition-fast);
        }
        .search-input:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        .filter-select {
            padding: 12px 15px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            background: white;
            font-size: 0.9rem;
            color: var(--gray-800);
            font-family: inherit;
            min-width: 140px;
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        .filter-select:focus {
            border-color: var(--primary-500);
        }

        /* Table custom styling */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--radius-md);
            border: 1px solid var(--gray-200);
            background: white;
        }
        .vgb-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .vgb-table th {
            background: var(--gray-50);
            padding: 15px 20px;
            color: var(--gray-500);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid var(--gray-200);
        }
        .vgb-table td {
            padding: 15px 20px;
            border-bottom: 1px solid var(--gray-100);
            font-size: 0.9rem;
            color: var(--gray-700);
            vertical-align: middle;
        }
        .vgb-table tbody tr {
            transition: background var(--transition-fast);
        }
        .vgb-table tbody tr:hover {
            background: rgba(99, 102, 241, 0.02);
        }

        /* Status & Type Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-savings {
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-500);
        }
        .badge-current {
            background: rgba(236, 72, 153, 0.12);
            color: var(--secondary-500);
        }
        .badge-status-active {
            background: rgba(16, 185, 129, 0.12);
            color: #10b981;
        }
        .badge-status-closed {
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
        }
        .badge-status-frozen {
            background: rgba(59, 130, 246, 0.12);
            color: #3b82f6;
        }
        .badge-status-dormant {
            background: rgba(245, 158, 11, 0.12);
            color: #f59e0b;
        }

        /* Custom buttons styling */
        .btn-action-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            padding: 6px 12px;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: var(--radius-sm);
            cursor: pointer;
            border: 1.5px solid transparent;
            transition: all var(--transition-fast);
            text-decoration: none;
            background: transparent;
        }
        .btn-view {
            border-color: var(--primary-500);
            color: var(--primary-500);
        }
        .btn-view:hover {
            background: var(--primary-500);
            color: white;
        }
        .btn-edit {
            border-color: var(--accent-cyan);
            color: var(--accent-cyan);
        }
        .btn-edit:hover {
            background: var(--accent-cyan);
            color: white;
        }
        .btn-close-acc {
            border-color: #f59e0b;
            color: #f59e0b;
        }
        .btn-close-acc:hover:not([disabled]) {
            background: #f59e0b;
            color: white;
        }
        .btn-close-acc[disabled] {
            opacity: 0.4;
            cursor: not-allowed;
        }
        .btn-delete {
            border-color: #ef4444;
            color: #ef4444;
        }
        .btn-delete:hover {
            background: #ef4444;
            color: white;
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
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(99, 102, 241, 0.2);
            width: 100%;
            max-width: 780px;
            border-radius: var(--radius-lg);
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            animation: modalScaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }
        
        .modal-view-statement {
            max-width: 900px;
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
            background: linear-gradient(to right, rgba(99, 102, 241, 0.03), rgba(236, 72, 153, 0.03));
        }

        .modal-body {
            padding: 25px;
            overflow-y: auto;
            flex: 1;
        }
        
        .modal-footer {
            padding: 15px 25px;
            border-top: 1px solid rgba(99, 102, 241, 0.1);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: var(--gray-50);
            flex-shrink: 0;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 1.6rem;
            color: var(--gray-400);
            cursor: pointer;
            transition: color 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .close-btn:hover {
            color: #ef4444;
        }

        /* Multi-tab container */
        .tabs-header {
            display: flex;
            border-bottom: 1px solid var(--gray-200);
            margin-bottom: 20px;
            gap: 5px;
        }
        .tab-link {
            padding: 10px 18px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--gray-500);
            border-bottom: 2px solid transparent;
            cursor: pointer;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .tab-link:hover {
            color: var(--primary-500);
        }
        .tab-link.active {
            color: var(--primary-500);
            border-bottom-color: var(--primary-500);
        }
        .tab-pane {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .tab-pane.active {
            display: block;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Form grids layout inside modals */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px 20px;
        }
        @media(max-width: 767px) {
            .form-grid { grid-template-columns: 1fr; }
            .wizard-steps-indicator { flex-direction: column; align-items: stretch; }
        }
        @media (max-width: 900px) {
            #wizardStepPreferences > div:first-child {
                grid-template-columns: 1fr !important;
            }
            #wizardStepPreferences .vgb-service-card-3d {
                max-width: 100% !important;
            }
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .form-group-full {
            grid-column: 1 / -1;
        }
        .form-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-control {
            padding: 10px 14px;
            border: 1.5px solid var(--gray-200);
            border-radius: var(--radius-md);
            outline: none;
            font-size: 0.9rem;
            color: var(--gray-800);
            font-family: inherit;
            background: white;
            transition: all var(--transition-fast);
        }
        .form-control:focus {
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        .form-checkbox-label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            color: var(--gray-700);
            cursor: pointer;
            padding: 10px;
            background: rgba(99, 102, 241, 0.03);
            border-radius: var(--radius-md);
            border: 1px dashed rgba(99, 102, 241, 0.15);
        }
        .form-checkbox-label input {
            width: 17px;
            height: 17px;
            accent-color: var(--primary-500);
        }

        /* Ledger card header details */
        .ledger-cust-profile {
            display: flex;
            gap: 20px;
            background: rgba(99, 102, 241, 0.04);
            border-radius: var(--radius-lg);
            padding: 20px;
            border: 1px solid rgba(99, 102, 241, 0.1);
            margin-bottom: 25px;
            align-items: center;
        }
        .ledger-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: var(--shadow-sm);
            object-fit: cover;
        }
        .ledger-summary-info {
            flex: 1;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 15px;
        }
        .ledger-info-block span {
            display: block;
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--gray-400);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .ledger-info-block strong {
            font-size: 0.95rem;
            color: var(--gray-700);
        }

        .ledger-table-wrapper {
            max-height: 380px;
            overflow-y: auto;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md);
        }
        .ledger-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.85rem;
        }
        .ledger-table th {
            position: sticky;
            top: 0;
            background: var(--gray-100);
            padding: 10px 15px;
            font-weight: 600;
            color: var(--gray-600);
            border-bottom: 2px solid var(--gray-200);
            z-index: 10;
        }
        .ledger-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--gray-100);
            color: var(--gray-700);
        }
        .text-credit {
            color: #10b981;
            font-weight: 700;
        }
        .text-debit {
            color: #ef4444;
            font-weight: 700;
        }

        /* Wizard indicators style */
        .step-indicator-item {
            transition: all var(--transition-normal);
        }
        .step-indicator-item.active {
            color: var(--primary-500) !important;
            transform: scale(1.03);
        }
        .step-indicator-item.active span {
            background: var(--primary-500) !important;
            color: white !important;
            box-shadow: 0 0 10px rgba(99,102,241,0.3);
        }
        .step-indicator-item.completed {
            color: #10b981 !important;
        }
        .step-indicator-item.completed span {
            background: #10b981 !important;
            color: white !important;
        }
        .wizard-step-pane {
            display: none;
            animation: fadeIn 0.4s ease;
        }
        .wizard-step-pane.active {
            display: block;
        }
        
/* PREMIUM VGB 3D GLOWING CARDS FOR VISUALIZER */
        .vgb-3d-card {
            border-radius: 20px;
            padding: 25px;
            color: white;
            position: relative;
            overflow: hidden;
            min-height: 220px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            perspective: 1000px;
            border: 1.5px solid rgba(255, 255, 255, 0.2);
            cursor: pointer;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .vgb-3d-card:hover:not(.interactive) {
            transform: translateY(-8px) rotateX(6deg) rotateY(-6deg);
            box-shadow: 0 22px 40px rgba(0, 0, 0, 0.25);
        }

        .vgb-3d-card::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 20%, rgba(255, 255, 255, 0.08) 40%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.08) 60%, transparent 80%);
            transform: rotate(-45deg);
            transition: all 0.8s ease;
            pointer-events: none;
            opacity: 0.6;
        }

        .vgb-3d-card:hover::after {
            left: 100%;
        }

        .vgb-3d-card.flipped {
            transform: rotateY(180deg);
        }

        .vgb-3d-card.flipped:hover:not(.interactive) {
            transform: rotateY(180deg) translateY(-8px) rotateX(-6deg) rotateY(6deg);
        }

        .vgb-3d-card.interactive {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }

        .vgb-3d-card.interactive:hover {
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.25);
        }

        /* ATM Card Specific Styles */
        .vgb-atm-card {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #06b6d4 100%);
            box-shadow: 0 12px 25px rgba(59, 130, 246, 0.3);
        }

        .vgb-atm-card.debit {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #06b6d4 100%);
            box-shadow: 0 12px 25px rgba(59, 130, 246, 0.3);
        }

        .vgb-atm-card.credit {
            background: linear-gradient(135deg, #4c1d95 0%, #8b5cf6 50%, #ec4899 100%);
            box-shadow: 0 12px 25px rgba(139, 92, 246, 0.3);
        }

        .vgb-atm-card.inactive-card {
            background: linear-gradient(135deg, #374151 0%, #4b5563 100%) !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
            opacity: 0.8;
        }

        .vgb-atm-card.debit:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(59, 130, 246, 0.4), 0 0 15px rgba(6, 182, 212, 0.3);
        }

        .vgb-atm-card.credit:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(139, 92, 246, 0.4), 0 0 15px rgba(236, 72, 153, 0.3);
        }

        /* Cheque Book Specific Styles */
        .vgb-cheque-card {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 50%, #0ea5e9 100%);
            box-shadow: 0 12px 25px rgba(30, 64, 175, 0.3);
            background-image: 
                repeating-linear-gradient(
                    45deg,
                    transparent,
                    transparent 10px,
                    rgba(255, 255, 255, 0.1) 10px,
                    rgba(255, 255, 255, 0.1) 20px
                );
        }

        .vgb-cheque-card:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(30, 64, 175, 0.4), 0 0 15px rgba(14, 165, 233, 0.3);
        }

        /* Passbook Specific Styles */
        .vgb-passbook-card {
            background: linear-gradient(135deg, #059669 0%, #10b981 50%, #34d399 100%);
            box-shadow: 0 12px 25px rgba(16, 185, 129, 0.3);
            background-image: 
                repeating-linear-gradient(
                    0deg,
                    transparent,
                    transparent 8px,
                    rgba(255, 255, 255, 0.15) 8px,
                    rgba(255, 255, 255, 0.15) 12px
                );
        }

        .vgb-passbook-card:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(16, 185, 129, 0.4), 0 0 15px rgba(52, 211, 153, 0.3);
        }

        .card-face {
            backface-visibility: hidden;
        }

        .card-front {
            background: inherit;
            border-radius: inherit;
        }

        .card-back {
            transform: rotateY(180deg);
            background: inherit;
            border-radius: inherit;
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

        /* Enhanced Glass Effects for Previews */
        .card-preview-container {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.03) 0%, rgba(6, 182, 212, 0.03) 100%);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: var(--radius-md);
            padding: 15px;
            backdrop-filter: blur(10px);
        }

        .card-preview-title {
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--gray-600);
            text-transform: uppercase;
            margin-bottom: 12px;
            text-align: center;
            letter-spacing: 0.5px;
        }

        .card-preview-footer {
            font-size: 0.7rem;
            color: var(--gray-400);
            text-align: center;
            margin-top: 8px;
            font-style: italic;
        }

        /* Summary Visual Cards styles */
        .summary-card {
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md);
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: var(--shadow-sm);
        }
        .summary-card h5 {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--primary-500);
            border-bottom: 1px solid var(--gray-100);
            padding-bottom: 6px;
            margin-bottom: 10px;
            text-transform: uppercase;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 10px 15px;
        }
        .summary-field span {
            display: block;
            font-size: 0.68rem;
            color: var(--gray-400);
            font-weight: 700;
            text-transform: uppercase;
        }
        .summary-field strong {
            font-size: 0.88rem;
            color: var(--gray-800);
        }

        /* ===== WIZARD ENHANCED ANIMATIONS ===== */
        @keyframes wizardSlideIn {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        @keyframes wizardSlideOut {
            from {
                opacity: 1;
                transform: translateX(0);
            }
            to {
                opacity: 0;
                transform: translateX(-30px);
            }
        }
        @keyframes wizardFadeScale {
            from {
                opacity: 0;
                transform: scale(0.96);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        .wizard-step-pane.active {
            animation: wizardFadeScale 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ===== 3D SERVICE CARD SHARED STYLES ===== */
        .vgb-service-card-3d {
            border-radius: 20px;
            padding: 0;
            color: white;
            position: relative;
            overflow: hidden;
            min-height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            perspective: 1000px;
            border: 1.5px solid rgba(255, 255, 255, 0.2);
            cursor: pointer;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        .vgb-service-card-3d:hover:not(.interactive) {
            transform: translateY(-8px) rotateX(6deg) rotateY(-6deg);
            box-shadow: 0 22px 40px rgba(0, 0, 0, 0.25);
        }
        .vgb-service-card-3d::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 20%, rgba(255, 255, 255, 0.08) 40%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.08) 60%, transparent 80%);
            transform: rotate(-45deg);
            transition: all 0.8s ease;
            pointer-events: none;
            opacity: 0.6;
        }
        .vgb-service-card-3d:hover::after {
            left: 100%;
        }
        .vgb-service-card-3d.flipped {
            transform: rotateY(180deg);
        }
        .vgb-service-card-3d.flipped:hover:not(.interactive) {
            transform: rotateY(180deg) translateY(-8px) rotateX(-6deg) rotateY(6deg);
        }
        .vgb-service-card-3d.interactive {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }
        .vgb-service-card-3d.interactive:hover {
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.25);
        }
        .vgb-service-card-3d .card-face {
            backface-visibility: hidden;
        }
        .vgb-service-card-3d .card-front {
            background: inherit;
            border-radius: inherit;
        }
        .vgb-service-card-3d .card-back {
            transform: rotateY(180deg);
            background: inherit;
            border-radius: inherit;
        }

        /* Cheque Book Card */
        .vgb-cheque-3d {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 50%, #0ea5e9 100%);
            box-shadow: 0 12px 25px rgba(30, 64, 175, 0.3);
            background-image: repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(255, 255, 255, 0.1) 10px, rgba(255, 255, 255, 0.1) 20px);
        }
        .vgb-cheque-3d:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(30, 64, 175, 0.4), 0 0 15px rgba(14, 165, 233, 0.3);
        }
        .cheque-watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 4rem;
            font-weight: 900;
            color: rgba(255, 255, 255, 0.08);
            pointer-events: none;
            white-space: nowrap;
            letter-spacing: 5px;
        }
        .cheque-number-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 5px;
        }
        .cheque-micr-line {
            font-family: monospace;
            font-size: 0.65rem;
            letter-spacing: 2px;
            opacity: 0.9;
            background: rgba(0,0,0,0.2);
            padding: 3px 8px;
            border-radius: 3px;
        }

        /* Passbook Card */
        .vgb-passbook-3d {
            background: linear-gradient(135deg, #059669 0%, #10b981 50%, #34d399 100%);
            box-shadow: 0 12px 25px rgba(16, 185, 129, 0.3);
            background-image: repeating-linear-gradient(0deg, transparent, transparent 8px, rgba(255, 255, 255, 0.15) 8px, rgba(255, 255, 255, 0.15) 12px);
        }
        .vgb-passbook-3d:hover:not(.interactive) {
            box-shadow: 0 22px 40px rgba(16, 185, 129, 0.4), 0 0 15px rgba(52, 211, 153, 0.3);
        }
        .passbook-spiral {
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            width: 22px;
            background: repeating-linear-gradient(to bottom, #d1d5db 0px, #d1d5db 3px, #9ca3af 3px, #9ca3af 6px);
            border-left: 2px solid rgba(0,0,0,0.15);
            border-radius: 0 16px 16px 0;
        }
        .passbook-stamp {
            position: absolute;
            bottom: 18px;
            right: 35px;
            border: 2px solid rgba(255,255,255,0.5);
            border-radius: 8px;
            padding: 4px 10px;
            font-size: 0.55rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transform: rotate(-8deg);
            opacity: 0.7;
        }
    </style>
</head>
<body class="bank-home-page">
    <!-- Preloader -->
    <div class="preloader">
        <div class="loader">
            <div class="loader-ring"></div>
            <span>VGB</span>
        </div>
    </div>

    <!-- Background glow cursor effect -->
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
            <a href="${pageContext.request.contextPath}/account?action=list" class="active"><i class="bx bx-user-check"></i> Manage Accounts</a>
            <a href="${pageContext.request.contextPath}/admin/transfer.jsp"><i class="bx bx-transfer-alt"></i> Admin Counter</a>
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> Manage Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i class="bx bx-book-bookmark"></i> Cheque Requests</a>
            <a href="${pageContext.request.contextPath}/loan?action=list"><i class="bx bx-building-house"></i> Review Loans</a>
            <a href="${pageContext.request.contextPath}/admin/proflie.jsp"><i class="bx bx-user"></i> My Profile</a>
            <a href="${pageContext.request.contextPath}/admin/notification.jsp">
                <i class="bx bx-bell"></i> Audit Logs
                <span class="notif-badge" id="sidebar-notif-count" style="display: none; background: #ef4444; color: white; padding: 2px 8px; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 700; margin-left: auto;">0</span>
            </a>
        </div>
        <div style="padding: 15px; background: rgba(99, 102, 241, 0.05); border-radius: var(--radius-md); text-align: center;">
            <p style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Admin Controls</p>
            <p style="font-size: 0.9rem; color: var(--primary-500); font-weight: 700; margin-top: 3px;">INTERNAL USE ONLY</p>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container" style="max-width: 1200px; padding: 0;">
            <!-- Page Title -->
            <div style="margin-bottom: 40px;">
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Customer Account Directory</h2>
                <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Directory of all primary and joint holders. Perform balance statements review, modify core configurations, or soft-close/delete signatories.</p>
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

            <!-- Dynamic Statistics Computations -->
            <c:set var="totalAccs" value="${accounts.size()}"/>
            <c:set var="savingsAccs" value="0"/>
            <c:set var="currentAccs" value="0"/>
            <c:set var="totalBalance" value="0"/>
            <c:forEach var="acc" items="${accounts}">
                <c:if test="${acc.accountType eq 'savings'}"><c:set var="savingsAccs" value="${savingsAccs + 1}"/></c:if>
                <c:if test="${acc.accountType eq 'current'}"><c:set var="currentAccs" value="${currentAccs + 1}"/></c:if>
                <c:set var="totalBalance" value="${totalBalance + acc.balance}"/>
            </c:forEach>

            <div class="stat-grid">
                <div class="stat-card" style="border-left: 4px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-500);">
                        <i class="bx bx-group"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Total Registrations</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-700); margin-top: 2px;">${totalAccs} Accounts</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--primary-500);">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.08); color: var(--primary-500);">
                        <i class="bx bx-bank"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Savings Accounts</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-700); margin-top: 2px;">${savingsAccs} Portfolios</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--secondary-500);">
                    <div class="stat-icon" style="background: rgba(236, 72, 153, 0.08); color: var(--secondary-500);">
                        <i class="bx bx-briefcase"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Current / Business</span>
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-700); margin-top: 2px;">${currentAccs} Portfolios</h3>
                    </div>
                </div>
                <div class="stat-card" style="border-left: 4px solid var(--accent-emerald);">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.08); color: var(--accent-emerald);">
                        <i class="bx bx-money"></i>
                    </div>
                    <div>
                        <span style="font-size: 0.75rem; color: var(--gray-400); font-weight: 600; text-transform: uppercase;">Cumulative Balances</span>
                        <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--gray-700); margin-top: 2px;">₹ <fmt:formatNumber value="${totalBalance}" minFractionDigits="2" maxFractionDigits="2"/></h3>
                    </div>
                </div>
            </div>

            <!-- Management Glass Hub -->
            <div class="glass-card">
                <!-- Search & Filters Hub -->
                <div class="control-hub">
                    <div class="search-wrapper">
                        <i class="bx bx-search search-icon"></i>
                        <input type="text" id="searchInput" onkeyup="filterAccountsTable()" class="search-input" placeholder="Search by customer ID, name, or account number...">
                    </div>
                    <select id="typeFilter" onchange="filterAccountsTable()" class="filter-select">
                        <option value="all">All Types</option>
                        <option value="savings">Savings</option>
                        <option value="current">Current</option>
                    </select>
                    <select id="statusFilter" onchange="filterAccountsTable()" class="filter-select">
                        <option value="all">All Statuses</option>
                        <option value="active">Active</option>
                        <option value="closed">Closed</option>
                        <option value="frozen">Frozen</option>
                        <option value="dormant">Dormant</option>
                    </select>
                    <button type="button" class="btn btn-primary" onclick="openCreateAccountModal()" style="background: var(--gradient-primary); border: none; height: 48px; border-radius: var(--radius-md); display: flex; align-items: center; gap: 8px; font-weight: 600; padding: 0 20px; box-shadow: var(--shadow-sm); flex-shrink: 0; color: white;">
                        <i class="bx bx-user-plus" style="font-size: 1.25rem;"></i> Open New Account
                    </button>
                </div>

                <!-- Table Content -->
                <div class="table-responsive">
                    <table class="vgb-table" id="accountsTable">
                        <thead>
                            <tr>
                                <th>Sr.No.</th>
                                <th>Customer ID</th>
                                <th>Customer Name</th>
                                <th>Account No.</th>
                                <th>Account Type</th>
                                <th>Balance</th>
                                <th>Status</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty accounts}">
                                    <c:forEach var="acc" items="${accounts}" varStatus="status">
                                        <tr data-cust-id="#CUST-${acc.customerId}" data-cust-name="${acc.customerName}" data-acc-number="${acc.accountNumber}" data-acc-type="${acc.accountType}" data-acc-status="${acc.status}">
                                            <td style="font-weight: 600; color: var(--gray-400);">${status.count}</td>
                                            <td style="font-family: monospace; font-weight: 700;">#CUST-${acc.customerId}</td>
                                            <td style="font-weight: 600; color: var(--gray-900);">${acc.customerName}</td>
                                            <td style="font-family: monospace; font-weight: 600;">${acc.accountNumber}</td>
                                            <td>
                                                <span class="badge ${acc.accountType eq 'savings' ? 'badge-savings' : 'badge-current'}">
                                                    <i class="bx ${acc.accountType eq 'savings' ? 'bx-save' : 'bx-briefcase'}"></i> ${acc.accountType}
                                                </span>
                                            </td>
                                            <td style="font-weight: 700; color: var(--gray-800);">₹ <fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td>
                                                <span class="badge badge-status-${acc.status}">
                                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block; margin-right: 3px;"></span>
                                                    ${acc.status}
                                                </span>
                                            </td>
                                            <td style="text-align: center;">
                                                <div class="btn-action-group" style="justify-content: center;">
                                                    <a href="${pageContext.request.contextPath}/account?action=transactions&accountId=${acc.accountId}" class="btn-action btn-view" title="View Transaction Ledger">
                                                        <i class="bx bx-show"></i> View
                                                    </a>
                                                    <button type="button" class="btn-action btn-edit" onclick="openEditAccountModal('${acc.customerId}', '${acc.accountId}')" title="Edit Signatory Details">
                                                        <i class="bx bx-edit"></i> Edit
                                                    </button>
                                                    <button type="button" class="btn-action btn-close-acc" onclick="triggerSoftCloseAccount('${acc.accountId}', '${acc.accountNumber}')" title="Terminate Account" ${acc.status eq 'closed' ? 'disabled' : ''}>
                                                        <i class="bx bx-power-off"></i> Close
                                                    </button>
                                                    <button type="button" class="btn-action btn-delete" onclick="triggerHardDeleteAccount('${acc.accountId}', '${acc.accountNumber}')" title="Hard Purge Profile">
                                                        <i class="bx bx-trash"></i> Delete
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="text-align: center; padding: 40px; color: var(--gray-400); font-weight: 500;">
                                            <i class="bx bx-folder-open" style="font-size: 2.5rem; display: block; margin-bottom: 10px; opacity: 0.6;"></i>
                                            No active accounts found in vertex system.
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

    <!-- Hidden Security POST Action Forms -->
    <form id="closeAccountForm" action="${pageContext.request.contextPath}/account?action=close" method="POST" style="display: none;">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="accountId" id="closeFormAccountId">
    </form>
    
    <form id="deleteAccountForm" action="${pageContext.request.contextPath}/account?action=delete" method="POST" style="display: none;">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="accountId" id="deleteFormAccountId">
    </form>

    <!-- MODAL 1: VIEW/STATEMENT LEDGER VISUALIZER -->
    <c:if test="${not empty statementAccount}">
        <div class="modal" id="statementModal" style="display: flex;">
            <div class="modal-content modal-view-statement">
                <div class="modal-header">
                    <h3 style="font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 8px;">
                        <i class="bx bx-receipt" style="color: var(--primary-500);"></i>
                        Account Ledger Statement
                    </h3>
                    <button type="button" class="close-btn" onclick="closeStatementModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <!-- Customer Card Banner -->
                    <div class="ledger-cust-profile">
                        <img src="${pageContext.request.contextPath}${not empty statementCustomer.avatarPath ? statementCustomer.avatarPath : '/assest/img/avatars/default.png'}" class="ledger-avatar" alt="Avatar">
                        <div class="ledger-summary-info">
                            <div class="ledger-info-block">
                                <span>Holder Profile</span>
                                <strong>${statementCustomer.firstName} ${statementCustomer.lastName}</strong>
                            </div>
                            <div class="ledger-info-block">
                                <span>Account Number</span>
                                <strong style="font-family: monospace;">${statementAccount.accountNumber}</strong>
                            </div>
                            <div class="ledger-info-block">
                                <span>IFSC Routing</span>
                                <strong style="font-family: monospace;">${statementAccount.ifscCode}</strong>
                            </div>
                            <div class="ledger-info-block">
                                <span>System Status</span>
                                <strong style="text-transform: capitalize;">${statementAccount.status}</strong>
                            </div>
                            <div class="ledger-info-block">
                                <span>Current Ledger Balance</span>
                                <strong style="color: var(--primary-500);">₹ <fmt:formatNumber value="${statementAccount.balance}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                            </div>
                        </div>
                    </div>

                    <!-- Ledger Table -->
                    <h4 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 12px; color: var(--gray-700); display: flex; align-items: center; gap: 6px;">
                        <i class="bx bx-list-ul"></i> Transaction Ledger Dues
                    </h4>
                    <div class="ledger-table-wrapper">
                        <table class="ledger-table">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>Reference ID</th>
                                    <th>Type</th>
                                    <th>Description</th>
                                    <th style="text-align: right;">Amount</th>
                                    <th style="text-align: right;">Running Balance</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty transactions}">
                                        <c:forEach var="txn" items="${transactions}">
                                            <tr>
                                                <td style="white-space: nowrap;">${txn.createdAt != null ? txn.createdAt.toString().replace('T', ' ') : 'N/A'}</td>
                                                <td style="font-family: monospace; font-weight: 600;">#${txn.referenceNumber}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${txn.transactionType eq 'deposit' or txn.transactionType eq 'interest' or (txn.transactionType eq 'transfer' and txn.toAccountId eq statementAccount.accountId)}">
                                                            <span class="text-credit"><i class="bx bx-down-arrow-alt"></i> CREDIT</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-debit"><i class="bx bx-up-arrow-alt"></i> DEBIT</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${txn.description}</td>
                                                <td style="text-align: right; font-weight: 700;" class="${txn.transactionType eq 'deposit' or txn.transactionType eq 'interest' or (txn.transactionType eq 'transfer' and txn.toAccountId eq statementAccount.accountId) ? 'text-credit' : 'text-debit'}">
                                                    ₹ <fmt:formatNumber value="${txn.amount}" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                                <td style="text-align: right; font-family: monospace; font-weight: 600; color: var(--gray-600);">
                                                    ₹ <fmt:formatNumber value="${txn.runningBalance}" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 25px; color: var(--gray-400);">No historical records recorded in this ledger.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeStatementModal()">Dismiss Ledger</button>
                </div>
            </div>
        </div>
    </c:if>

    <!-- MODAL 2: TABBED EDIT PROFILE OVERLAY -->
    <div class="modal" id="editAccountModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-user-pin" style="color: var(--accent-cyan);"></i>
                    Update Signatory & Core Profile
                </h3>
                <button type="button" class="close-btn" onclick="closeEditAccountModal()">&times;</button>
            </div>
            
            <form id="editAccountForm" action="${pageContext.request.contextPath}/account?action=update" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="customerId" id="editCustomerId">
                <input type="hidden" name="accountId" id="editAccountId">

                <div class="modal-body">
                    <!-- Tab Links Navigation -->
                    <div class="tabs-header">
                        <div class="tab-link active" onclick="switchModalTab(event, 'tabPersonal')">
                            <i class="bx bx-user"></i> Primary Profile
                        </div>
                        <div class="tab-link" id="tabJointLink" onclick="switchModalTab(event, 'tabJoint')" style="display: none;">
                            <i class="bx bx-group"></i> Joint Signee
                        </div>
                        <div class="tab-link" onclick="switchModalTab(event, 'tabBanking')">
                            <i class="bx bx-slider"></i> Banking & Subclass
                        </div>
                        <div class="tab-link" onclick="switchModalTab(event, 'tabSecurity')">
                            <i class="bx bx-lock-open"></i> Credentials
                        </div>
                    </div>

                    <!-- TAB 1: Primary Personal Details -->
                    <div class="tab-pane active" id="tabPersonal">
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">First Name</label>
                                <input type="text" name="firstName" id="editFirstName" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name</label>
                                <input type="text" name="lastName" id="editLastName" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Signature</label>
                                <input type="email" name="email" id="editEmail" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Signature</label>
                                <input type="text" name="phoneNo" id="editPhoneNo" class="form-control" maxlength="10" required>
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Physical Address</label>
                                <input type="text" name="address" id="editAddress" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">City</label>
                                <input type="text" name="city" id="editCity" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">State</label>
                                <input type="text" name="state" id="editState" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Zip Code</label>
                                <input type="text" name="zipCode" id="editZipCode" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Permanent PAN Card</label>
                                <input type="text" name="panCard" id="editPanCard" class="form-control" placeholder="ABCDE1234F">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Aadhaar Ident. (12 Digits)</label>
                                <input type="text" name="aadhaarCard" id="editAadhaarCard" class="form-control" placeholder="12-digit number">
                            </div>
                        </div>
                    </div>

                    <!-- TAB 2: Joint Holder Details -->
                    <div class="tab-pane" id="tabJoint">
                        <input type="hidden" name="jointCustomerId" id="editJointCustomerId">
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Joint First Name</label>
                                <input type="text" name="jointFirstName" id="editJointFirstName" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Last Name</label>
                                <input type="text" name="jointLastName" id="editJointLastName" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Email</label>
                                <input type="email" name="jointEmail" id="editJointEmail" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Phone No</label>
                                <input type="text" name="jointPhoneNo" id="editJointPhoneNo" class="form-control" maxlength="10">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Joint Address</label>
                                <input type="text" name="jointAddress" id="editJointAddress" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint City</label>
                                <input type="text" name="jointCity" id="editJointCity" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint State</label>
                                <input type="text" name="jointState" id="editJointState" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Zip Code</label>
                                <input type="text" name="jointZipCode" id="editJointZipCode" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint PAN Card</label>
                                <input type="text" name="jointPanCard" id="editJointPanCard" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Aadhaar</label>
                                <input type="text" name="jointAadhaarCard" id="editJointAadhaarCard" class="form-control">
                            </div>
                        </div>
                    </div>

                    <!-- TAB 3: Banking subclass Details -->
                    <div class="tab-pane" id="tabBanking">
                        <!-- Subclass 1: SAVINGS DETAILS -->
                        <div id="subclassSavingsFields" style="display: none; margin-bottom: 20px;">
                            <h4 style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 12px; border-bottom: 1px dashed rgba(99,102,241,0.2); padding-bottom: 5px;">Savings Account Configurations</h4>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Nominee Name</label>
                                    <input type="text" name="nomineeName" id="editNomineeName" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Holding Classification</label>
                                    <select name="holdingType" id="editHoldingType" class="form-control" onchange="toggleJointTabOnHoldingChange()">
                                        <option value="single">Single Holding</option>
                                        <option value="joint">Joint Signatory</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Daily ATM Withdrawal Limit (₹)</label>
                                    <input type="number" name="dailyWithdrawalLimit" id="editDailyWithdrawalLimit" class="form-control" min="500" step="500">
                                </div>
                            </div>
                        </div>

                        <!-- Subclass 2: CURRENT BUSINESS DETAILS -->
                        <div id="subclassCurrentFields" style="display: none; margin-bottom: 20px;">
                            <h4 style="font-size: 0.85rem; font-weight: 700; color: var(--secondary-500); text-transform: uppercase; margin-bottom: 12px; border-bottom: 1px dashed rgba(236,72,193,0.2); padding-bottom: 5px;">Business Current Account Details</h4>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Registered Business Name</label>
                                    <input type="text" name="businessName" id="editBusinessName" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">GSTIN ID Number</label>
                                    <input type="text" name="gstin" id="editGstin" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Overdraft Limit Allowed (₹)</label>
                                    <input type="number" name="overdraftLimit" id="editOverdraftLimit" class="form-control" min="0" step="1000">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Category</label>
                                    <input type="text" name="companyCategory" id="editCompanyCategory" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Phone Signature</label>
                                    <input type="text" name="companyPhone" id="editCompanyPhone" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Company Business Email</label>
                                    <input type="email" name="companyEmail" id="editCompanyEmail" class="form-control">
                                </div>
                                <div class="form-group form-group-full">
                                    <label class="form-label">Business Registered Office Address</label>
                                    <input type="text" name="companyAddress" id="editCompanyAddress" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Business PAN Ident.</label>
                                    <input type="text" name="companyPan" id="editCompanyPan" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Business Aadhaar / Lic. No.</label>
                                    <input type="text" name="companyAadhaar" id="editCompanyAadhaar" class="form-control">
                                </div>
                            </div>
                        </div>

                        <!-- Banking System Preferences -->
                        <h4 style="font-size: 0.85rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; margin-bottom: 12px; margin-top: 10px;">Preferences Dues</h4>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <label class="form-checkbox-label">
                                <input type="checkbox" name="hasAtmCard" id="editHasAtmCard" value="1">
                                <div>
                                    <strong style="display: block; font-size: 0.85rem;">ATM Debit Card</strong>
                                    <span style="font-size: 0.7rem; color: var(--gray-400);">Activate counter limits and visa/master network cards</span>
                                </div>
                            </label>
                            <label class="form-checkbox-label">
                                <input type="checkbox" name="hasChequeBook" id="editHasChequeBook" value="1">
                                <div>
                                    <strong style="display: block; font-size: 0.85rem;">Cheque Book Ledger</strong>
                                    <span style="font-size: 0.7rem; color: var(--gray-400);">Enable physical book applications and par clearings</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- TAB 4: Credentials optional updates -->
                    <div class="tab-pane" id="tabSecurity">
                        <div style="background: rgba(245,158,11,0.05); border-left: 4px solid #f59e0b; padding: 12px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.8rem; color: #b45309; line-height: 1.4;">
                            <i class="bx bx-info-circle"></i> Keep password and PIN fields completely **blank** unless you explicitly intend to reset the customer's secure credentials.
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Secure Access Username (Read Only)</label>
                                <input type="text" id="editUsername" class="form-control" style="background: var(--gray-100); color: var(--gray-500); cursor: not-allowed;" readonly>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Secure 4-Digit PIN Reset</label>
                                <input type="text" name="pin" id="editPin" class="form-control" placeholder="Blank to keep current (E.g. 1234)" maxlength="4">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Password Master Reset</label>
                                <input type="password" name="password" id="editPassword" class="form-control" placeholder="Blank to keep current. (Min 8 chars, 1 Upper, 1 Lower, 1 Special)">
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditAccountModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="background: var(--gradient-primary); border: none; box-shadow: var(--shadow-sm);">Save Profile Modifications</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 3: SPECIAL ONBOARDING WIZARD MODAL -->
    <div class="modal" id="createAccountModal">
        <div class="modal-content" style="max-width: 850px;">
            <div class="modal-header">
                <h3 style="font-weight: 700; color: var(--gray-900); display: flex; align-items: center; gap: 8px;">
                    <i class="bx bx-user-plus" style="color: var(--primary-500); font-size: 1.6rem;"></i>
                    <span id="wizHeaderTitle">Onboard New Customer</span>
                </h3>
                <button type="button" class="close-btn" onclick="closeCreateAccountModal()">&times;</button>
            </div>
            
            <!-- Steps Progress indicator -->
            <div class="wizard-steps-indicator" id="wizardStepsIndicator" style="display: flex; justify-content: space-between; padding: 18px 30px; background: var(--gray-50); border-bottom: 1px solid var(--gray-100); flex-wrap: wrap; gap: 10px;">
                <!-- Dynamically populated in JS based on active flow -->
            </div>

            <form id="createAccountForm" action="${pageContext.request.contextPath}/account?action=createProcess" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <!-- Auto-Generated PIN hidden parameter -->
                <input type="hidden" name="pin" id="wizPin">

                <div class="modal-body" style="max-height: 55vh; overflow-y: auto;">
                    
                    <!-- STEP 1: Account Classification Selector -->
                    <div class="wizard-step-pane" id="wizardStepClassification">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 20px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Choose Onboarding Classification</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Classification Type *</label>
                                <select name="accountType" id="wizAccountType" class="form-control" onchange="toggleClassificationFlowSelection()" required>
                                    <option value="savings" selected>Savings Account Portfolio</option>
                                    <option value="current">Current Business Portfolio</option>
                                </select>
                            </div>
                            <div class="form-group" id="wizHoldingTypeWrapper">
                                <label class="form-label">Holding Classification *</label>
                                <select name="holdingType" id="wizHoldingType" class="form-control" onchange="toggleClassificationFlowSelection()">
                                    <option value="single" selected>Single User Account</option>
                                    <option value="joint">Joining Account (Max - 2 Signatories)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 2 (Savings flows): Primary Holder Demographics -->
                    <div class="wizard-step-pane" id="wizardStepPrimaryHolder">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Primary Holder Personal Details</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">First Name *</label>
                                <input type="text" name="firstName" id="wizFirstName" class="form-control" placeholder="John">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Middle Name</label>
                                <input type="text" name="middleName" id="wizMiddleName" class="form-control" placeholder="Middle Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name *</label>
                                <input type="text" name="lastName" id="wizLastName" class="form-control" placeholder="Doe">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Signature *</label>
                                <input type="email" name="email" id="wizEmail" class="form-control" placeholder="john.doe@example.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Signature * (10 Digits)</label>
                                <input type="text" name="phoneNo" id="wizPhoneNo" class="form-control" placeholder="9876543210" maxlength="10">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Alternate Phone</label>
                                <input type="text" name="altPhoneNo" id="wizAltPhoneNo" class="form-control" placeholder="Alt Phone" maxlength="10">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Father's Name</label>
                                <input type="text" name="fatherName" id="wizFatherName" class="form-control" placeholder="Father's Full Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Mother's Name</label>
                                <input type="text" name="motherName" id="wizMotherName" class="form-control" placeholder="Mother's Full Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Date of Birth</label>
                                <input type="date" name="dob" id="wizDob" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Gender</label>
                                <select name="gender" id="wizGender" class="form-control">
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Marital Status</label>
                                <select name="maritalStatus" id="wizMaritalStatus" class="form-control">
                                    <option value="single">Single</option>
                                    <option value="married">Married</option>
                                    <option value="divorced">Divorced</option>
                                    <option value="widowed">Widowed</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nationality</label>
                                <input type="text" name="nationality" id="wizNationality" class="form-control" value="Indian">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Occupation</label>
                                <input type="text" name="occupation" id="wizOccupation" class="form-control" placeholder="Occupation">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Annual Income (₹)</label>
                                <input type="number" name="annualIncome" id="wizAnnualIncome" class="form-control" value="500000" min="0" step="50000">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Residential Address *</label>
                                <input type="text" name="address" id="wizAddress" class="form-control" placeholder="Flat No., Apt, Street Address...">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Permanent Address</label>
                                <input type="text" name="permAddress" id="wizPermAddress" class="form-control" placeholder="Same as residential address if left blank">
                            </div>
                            <div class="form-group">
                                <label class="form-label">City *</label>
                                <input type="text" name="city" id="wizCity" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">State *</label>
                                <input type="text" name="state" id="wizState" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Zip Code *</label>
                                <input type="text" name="zipCode" id="wizZipCode" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">PAN Card *</label>
                                <input type="text" name="panCard" id="wizPanCard" class="form-control" placeholder="ABCDE1234F">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Aadhaar Identification * (12 Digits)</label>
                                <input type="text" name="aadhaarCard" id="wizAadhaarCard" class="form-control" placeholder="12 Digits" maxlength="12">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Primary Holder Avatar Upload</label>
                                <input type="file" name="primaryAvatarFile" class="form-control" accept="image/*">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 3 (Savings Flows): Nominee Person (Optional) -->
                    <div class="wizard-step-pane" id="wizardStepNominee">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Nominee Details (Optional)</h4>
                        <div style="background: rgba(99,102,241,0.04); border-left: 4px solid var(--primary-500); padding: 12px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.8rem; color: var(--primary-500); line-height: 1.4;">
                            <i class="bx bx-info-circle"></i> Nominee information is optional. You may fill it in below or safely skip to the next step by clicking <strong>Next Step</strong>.
                        </div>
                        <div class="form-grid">
                            <div class="form-group form-group-full">
                                <label class="form-label">Nominee Person Full Name</label>
                                <input type="text" name="nomineeName" id="wizNomineeName" class="form-control" placeholder="Leave blank if not registered">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Daily ATM Withdrawal Limit (₹)</label>
                                <input type="number" name="dailyWithdrawalLimit" id="wizDailyWithdrawalLimit" class="form-control" value="50000" min="1000" step="5000">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 3 (Savings Joint flow): Joint Holder Signee Details -->
                    <div class="wizard-step-pane" id="wizardStepJointHolder">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                            <span>Joint Account Holder Demographics</span>
                            <select name="jointCustomerMode" id="wizJointCustomerMode" class="filter-select" style="padding: 5px 10px; font-size: 0.75rem; min-width: 130px; height: 32px;" onchange="toggleJointModeFields()">
                                <option value="existing">Existing Customer</option>
                                <option value="new">Register New Profile</option>
                            </select>
                        </h4>

                        <!-- Joint Option A: Existing Customer Select -->
                        <div id="wizJointExistingSelector" class="form-group" style="margin-bottom: 15px;">
                            <label class="form-label">Choose Existing Customer *</label>
                            <select name="jointCustomerId" id="wizJointCustomerId" class="form-control">
                                <option value="">-- Select Customer --</option>
                                <c:forEach var="c" items="${customers}">
                                    <option value="${c.customerId}">${c.firstName} ${c.lastName} (#CUST-${c.customerId})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Joint Option B: Brand New Joint Registration Form -->
                        <div id="wizJointNewFields" style="display: none;" class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Joint First Name *</label>
                                <input type="text" name="jointFirstName" id="wizJointFirstName" class="form-control" placeholder="First Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Last Name *</label>
                                <input type="text" name="jointLastName" id="wizJointLastName" class="form-control" placeholder="Last Name">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Email *</label>
                                <input type="email" name="jointEmail" id="wizJointEmail" class="form-control" placeholder="joint@example.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Phone *</label>
                                <input type="text" name="jointPhone" id="wizJointPhone" class="form-control" maxlength="10" placeholder="10 Digits">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Joint Address *</label>
                                <input type="text" name="jointAddress" id="wizJointAddress" class="form-control" placeholder="Street Address">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint City *</label>
                                <input type="text" name="jointCity" id="wizJointCity" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint State *</label>
                                <input type="text" name="jointState" id="wizJointState" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Zip Code *</label>
                                <input type="text" name="jointZipCode" id="wizJointZipCode" class="form-control">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint PAN Card *</label>
                                <input type="text" name="jointPan" id="wizJointPan" class="form-control" placeholder="ABCDE1234F">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Joint Aadhaar * (12 Digits)</label>
                                <input type="text" name="jointAadhaar" id="wizJointAadhaar" class="form-control" maxlength="12" placeholder="12 Digits">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Joint Signee Profile Photo</label>
                                <input type="file" name="jointAvatarFile" class="form-control" accept="image/*">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 2 (Current Flow): Corporate Company Details -->
                    <div class="wizard-step-pane" id="wizardStepCompanyDetails">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--secondary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Registered Corporate details</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Corporate Company Name *</label>
                                <input type="text" name="businessName" id="wizBusinessName" class="form-control" placeholder="E.g. Vertex Galaxy Ltd">
                            </div>
                            <div class="form-group">
                                <label class="form-label">GSTIN ID Number *</label>
                                <input type="text" name="gstin" id="wizGstin" class="form-control" placeholder="15-digit alphanumeric">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Overdraft Limit Allowed (₹) *</label>
                                <input type="number" name="overdraftLimit" id="wizOverdraftLimit" class="form-control" value="100000" min="0" step="5000">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Category</label>
                                <input type="text" name="companyCategory" id="wizCompanyCategory" class="form-control" placeholder="E.g. Technology Services">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Phone *</label>
                                <input type="text" name="companyPhone" id="wizCompanyPhone" class="form-control" placeholder="Company Office Phone">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Email *</label>
                                <input type="email" name="companyEmail" id="wizCompanyEmail" class="form-control" placeholder="corporate@company.com">
                            </div>
                            <div class="form-group form-group-full">
                                <label class="form-label">Corporate Registered Address *</label>
                                <input type="text" name="companyAddress" id="wizCompanyAddress" class="form-control" placeholder="Full Registered Corporate Address">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate PAN Ident. *</label>
                                <input type="text" name="companyPan" id="wizCompanyPan" class="form-control" placeholder="Company PAN Card">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Corporate Aadhaar / Registration *</label>
                                <input type="text" name="companyAadhaar" id="wizCompanyAadhaar" class="form-control" placeholder="Company Registration / Aadhaar">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 3 (Current Flow): Dynamic Partner Signatories -->
                    <div class="wizard-step-pane" id="wizardStepPartnerDetails">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--secondary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Corporate Partner Signatories</h4>
                        <div style="background: rgba(236,72,153,0.04); border-left: 4px solid var(--secondary-500); padding: 12px; border-radius: var(--radius-sm); margin-bottom: 20px; font-size: 0.8rem; color: var(--secondary-500); line-height: 1.4;">
                            <i class="bx bx-info-circle"></i> Add details for company partner signatories. You may click the <strong>Add Partner Signatory</strong> button to register multiple partners dynamically.
                        </div>

                        <!-- Dynamic list of partners -->
                        <div id="partnerListContainer">
                            <!-- Dynamically appends partner cards here -->
                        </div>

                        <div class="form-group form-group-full" style="margin-top: 10px;">
                            <button type="button" class="btn btn-secondary" onclick="addPartnerCard()" style="border: 1px dashed var(--gray-400); width: 100%; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600; padding: 12px; border-radius: var(--radius-md); background: rgba(99,102,241,0.02);">
                                <i class="bx bx-plus"></i> Add Partner Signatory
                            </button>
                        </div>
                    </div>

<!-- STEP 4: Preferences (ATM/Cheque/Passbook defaults) -->
                      <div class="wizard-step-pane" id="wizardStepPreferences">
                          <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Services Preferences</h4>
                          
                          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px; align-items: start;" class="mobile-grid-1">
                              <div>
                                  <div class="form-grid">
                                      <label class="form-checkbox-label form-group-full">
                                          <input type="checkbox" name="hasAtmCard" id="wizHasAtmCard" value="1" onchange="toggleCardOptionWiz(); syncWizAtmCardPreview();">
                                          <div>
                                              <strong style="display: block; font-size: 0.85rem;">ATM Card Required</strong>
                                              <span style="font-size: 0.75rem; color: var(--gray-400);">Requests pending ATM card approval. Valid cards are accessible inside Manage Cards menu.</span>
                                          </div>
                                      </label>
                                      
                                      <!-- ATM Options -->
                                      <div id="wizAtmCardDetails" style="display: none; grid-column: 1 / -1; margin-left: 20px; border-left: 2px solid var(--primary-200); padding-left: 15px;" class="form-grid">
                                          <div class="form-group">
                                              <label class="form-label">ATM Card Type</label>
                                              <select name="wizardCardType" id="wizCardType" class="form-control" onchange="syncWizAtmCardPreview()">
                                                  <option value="debit" selected>Debit Card (Counter Linked)</option>
                                                  <option value="credit">Credit Card (Cash Advance OD)</option>
                                              </select>
                                          </div>
                                          <div class="form-group">
                                              <label class="form-label">ATM Provider</label>
                                              <select name="wizardCardProvider" id="wizCardProvider" class="form-control" onchange="syncWizAtmCardPreview()">
                                                  <option value="visa" selected>Visa Classic Network</option>
                                                  <option value="mastercard">MasterCard Premium</option>
                                                  <option value="rupay">RuPay Sovereign</option>
                                              </select>
                                          </div>
                                      </div>

                                      <label class="form-checkbox-label form-group-full">
                                          <input type="checkbox" name="hasChequeBook" id="wizHasChequeBook" value="1" onchange="toggleChequeOptionWiz();">
                                          <div>
                                              <strong style="display: block; font-size: 0.85rem;">Cheque Book Required</strong>
                                              <span style="font-size: 0.75rem; color: var(--gray-400);">Submits cheque clearance requests. Requests are reviewable under Cheque Requests menu.</span>
                                          </div>
                                      </label>
                                      
                                      <!-- Passbook selection (Savings default) -->
                                      <label class="form-checkbox-label form-group-full" id="wizPassbookCheckboxWrapper">
                                          <input type="checkbox" name="hasPassbook" id="wizHasPassbook" value="1" checked onclick="return false;" style="cursor: not-allowed;">
                                          <div>
                                              <strong style="display: block; font-size: 0.85rem; color: var(--gray-600);">Passbook Option (Default Selected)</strong>
                                              <span style="font-size: 0.75rem; color: var(--gray-400);">Vertex physical passbooks are by default issued and selected for Savings Signatories.</span>
                                          </div>
                                      </label>
                                  </div>
                              </div>
                              
                              <!-- 3D Service Card Previews -->
                              <div style="display: flex; flex-direction: column; gap: 18px;">
                                  <!-- ATM Card 3D Preview -->
                                  <div style="background: linear-gradient(135deg, rgba(99, 102, 241, 0.03) 0%, rgba(6, 182, 212, 0.03) 100%); border: 1px solid rgba(99, 102, 241, 0.15); border-radius: var(--radius-md); padding: 15px;">
                                      <h5 style="font-size: 0.8rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; margin-bottom: 12px; text-align: center;">ATM Card Preview</h5>
                                      <div class="card-3d-scene" id="wizAtmTiltWrapper" style="perspective: 1000px; width: 100%; display: flex; justify-content: center; transition: transform 0.1s ease; transform-style: preserve-3d;">
                                          <div id="wizAtmPreviewCard" class="vgb-atm-card debit interactive" onclick="flipWizAtmCard()" style="width: 100%; max-width: 300px; height: 190px; border-radius: 16px; position: relative; box-shadow: 0 12px 25px rgba(0, 0, 0, 0.12); transform-style: preserve-3d; border: 1.5px solid rgba(255, 255, 255, 0.2); cursor: pointer;">
                                              <!-- Front Face -->
                                              <div class="card-face card-front" style="position: absolute; inset: 0; padding: 18px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; background: inherit; border-radius: inherit;">
                                                  <div class="card-top" style="display: flex; justify-content: space-between; align-items: center; background: transparent;">
                                                      <span id="wizProviderLabel" style="font-size: 1.1rem; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase; font-style: italic; background: linear-gradient(135deg, #ffffff 0%, #e2e8f0 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">VISA</span>
                                                      <div class="metallic-chip" style="width: 32px; height: 24px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 50%, #b45309 100%); border-radius: 5px; border: 1px solid rgba(255, 255, 255, 0.25); box-shadow: inset 0 1px 2px rgba(255, 255, 255, 0.3);"></div>
                                                  </div>
                                                  <div class="card-number" id="wizNumberLabel" style="font-family: monospace; font-size: 1rem; letter-spacing: 1.5px; font-weight: 600; margin: 12px 0 8px; text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);">4589  7321  6048  2190</div>
                                                  <div class="card-details" style="display: flex; justify-content: space-between; align-items: flex-end; background: transparent;">
                                                      <div>
                                                          <span style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.3px; opacity: 0.7; display: block; margin-bottom: 2px;">Card Holder</span>
                                                          <span class="card-value" id="wizHolderLabel" style="font-size: 0.75rem; font-weight: 600; letter-spacing: 0.3px; text-transform: uppercase;">DEMO HOLDER</span>
                                                      </div>
                                                      <div>
                                                          <span style="font-size: 0.55rem; text-transform: uppercase; letter-spacing: 0.3px; opacity: 0.7; display: block; margin-bottom: 2px;">Expires</span>
                                                          <span class="card-value" id="wizExpiryLabel" style="font-size: 0.75rem; font-weight: 600; letter-spacing: 0.3px;">12/30</span>
                                                      </div>
                                                      <span style="font-size: 0.8rem; font-weight: 700; font-style: italic; color: rgba(255, 255, 255, 0.85);">VGB</span>
                                                  </div>
                                              </div>
                                              
                                              <!-- Back Face -->
                                              <div class="card-face card-back" style="position: absolute; inset: 0; padding: 18px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; transform: rotateY(180deg); background: inherit; border-radius: inherit;">
                                                  <div style="height: 32px; background: #000; margin: 0 -18px; margin-top: 3px;"></div>
                                                  <div style="padding: 0 8px;">
                                                      <div style="font-size: 0.45rem; opacity: 0.7; margin-bottom: 2px; text-transform: uppercase; letter-spacing: 0.3px;">Authorized Signature</div>
                                                      <div style="background: rgba(255, 255, 255, 0.9); height: 28px; border-radius: 4px; display: flex; align-items: center; justify-content: flex-end; padding-right: 12px; color: #1e293b; font-family: 'Brush Script MT', cursive, sans-serif; font-size: 0.9rem;">
                                                          <span style="font-family: monospace; font-size: 0.75rem; font-weight: 600; color: #334155; margin-left: 15px; font-style: normal; letter-spacing: 1px; cursor: pointer;" id="wizCvvLabel" data-cvv="907" onclick="event.stopPropagation(); toggle3DCardCvv(event, this)" title="Click to show CVV">•••</span>
                                                      </div>
                                                  </div>
                                                  <div style="font-size: 0.5rem; opacity: 0.6; text-align: center; line-height: 1.2;">
                                                      VGB ATM Card. Click to flip • Hover to tilt • Inspect CVV.
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                      <div style="font-size: 0.7rem; color: var(--gray-400); text-align: center; margin-top: 8px;">
                                          Hover to tilt • Click card to flip • Click CVV to reveal
                                      </div>
                                  </div>

                                  <!-- Cheque Book 3D Preview -->
                                  <div id="wizChequePreviewContainer" style="background: linear-gradient(135deg, rgba(59, 130, 246, 0.03) 0%, rgba(14, 165, 233, 0.03) 100%); border: 1px solid rgba(59, 130, 246, 0.15); border-radius: var(--radius-md); padding: 15px; display: none;">
                                      <h5 style="font-size: 0.8rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; margin-bottom: 12px; text-align: center;">Cheque Book Preview</h5>
                                      <div style="perspective: 1000px; width: 100%; display: flex; justify-content: center;">
                                          <div id="wizChequePreviewCard" class="vgb-service-card-3d vgb-cheque-3d" onclick="flipWizServiceCard('wizChequePreviewCard')" style="width: 100%; max-width: 300px; height: 180px; border-radius: 16px; position: relative; box-shadow: 0 12px 25px rgba(30, 64, 175, 0.3); transform-style: preserve-3d; border: 1.5px solid rgba(255, 255, 255, 0.2); cursor: pointer;">
                                              <!-- Front Face -->
                                              <div class="card-face card-front" style="position: absolute; inset: 0; padding: 18px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; background: inherit; border-radius: inherit;">
                                                  <div style="display: flex; justify-content: space-between; align-items: center;">
                                                      <span style="font-size: 1rem; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; color: white;">VGB</span>
                                                      <span style="font-size: 0.65rem; font-weight: 600; color: rgba(255,255,255,0.8); letter-spacing: 0.5px;">CHEQUE BOOK</span>
                                                  </div>
                                                  <div class="cheque-watermark">VGB</div>
                                                  <div>
                                                      <div style="font-size: 0.6rem; color: rgba(255,255,255,0.7); margin-bottom: 4px; text-transform: uppercase; letter-spacing: 0.5px;">Pay To</div>
                                                      <div style="font-size: 0.85rem; font-weight: 700; color: white; margin-bottom: 8px;">____________________</div>
                                                      <div class="cheque-number-row">
                                                          <span style="font-size: 0.55rem; color: rgba(255,255,255,0.6);">№ VGB-0000001</span>
                                                          <span class="cheque-micr-line">VGBK · 000 · 000</span>
                                                      </div>
                                                  </div>
                                              </div>
                                              <!-- Back Face -->
                                              <div class="card-face card-back" style="position: absolute; inset: 0; padding: 18px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; transform: rotateY(180deg); background: inherit; border-radius: inherit;">
                                                  <div style="height: 28px; background: rgba(255,255,255,0.1); margin: 0 -18px; margin-top: 3px; border-bottom: 1px dashed rgba(255,255,255,0.2);"></div>
                                                  <div style="text-align: center; padding: 15px 0;">
                                                      <div style="font-size: 0.5rem; color: rgba(255,255,255,0.6); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px;">Authorized Signature</div>
                                                      <div style="background: rgba(255,255,255,0.9); height: 24px; border-radius: 3px; display: flex; align-items: center; justify-content: center; color: #1e293b; font-family: 'Brush Script MT', cursive; font-size: 0.85rem; padding: 0 20px;">
                                                          _________________________
                                                      </div>
                                                  </div>
                                                  <div style="font-size: 0.5rem; color: rgba(255,255,255,0.5); text-align: center; line-height: 1.3;">
                                                      VGB Cheque Book • Leaf 1/20<br>Click to flip back
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                      <div style="font-size: 0.7rem; color: var(--gray-400); text-align: center; margin-top: 8px;">
                                          Click to flip • Inspect both sides
                                      </div>
                                  </div>

                                  <!-- Passbook 3D Preview -->
                                  <div id="wizPassbookPreviewContainer" style="background: linear-gradient(135deg, rgba(16, 185, 129, 0.03) 0%, rgba(52, 211, 153, 0.03) 100%); border: 1px solid rgba(16, 185, 129, 0.15); border-radius: var(--radius-md); padding: 15px;">
                                      <h5 style="font-size: 0.8rem; font-weight: 700; color: var(--gray-600); text-transform: uppercase; margin-bottom: 12px; text-align: center;">Passbook Preview</h5>
                                      <div style="perspective: 1000px; width: 100%; display: flex; justify-content: center;">
                                          <div id="wizPassbookPreviewCard" class="vgb-service-card-3d vgb-passbook-3d" onclick="flipWizServiceCard('wizPassbookPreviewCard')" style="width: 100%; max-width: 300px; height: 180px; border-radius: 16px; position: relative; box-shadow: 0 12px 25px rgba(16, 185, 129, 0.3); transform-style: preserve-3d; border: 1.5px solid rgba(255, 255, 255, 0.2); cursor: pointer;">
                                              <div class="passbook-spiral"></div>
                                              <!-- Front Face -->
                                              <div class="card-face card-front" style="position: absolute; inset: 0; padding: 18px; padding-right: 35px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; background: inherit; border-radius: inherit;">
                                                  <div style="display: flex; justify-content: space-between; align-items: center;">
                                                      <span style="font-size: 1rem; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; color: white;">VGB</span>
                                                      <span style="font-size: 0.65rem; font-weight: 600; color: rgba(255,255,255,0.8); letter-spacing: 0.5px;">PASSBOOK</span>
                                                  </div>
                                                  <div>
                                                      <div style="font-size: 0.6rem; color: rgba(255,255,255,0.7); margin-bottom: 3px; text-transform: uppercase; letter-spacing: 0.5px;">Account Holder</div>
                                                      <div style="font-size: 0.85rem; font-weight: 700; color: white; margin-bottom: 6px;">NEW ACCOUNT</div>
                                                      <div style="font-size: 0.6rem; color: rgba(255,255,255,0.7); margin-bottom: 3px; text-transform: uppercase; letter-spacing: 0.5px;">Account Number</div>
                                                      <div style="font-size: 0.75rem; font-weight: 600; color: white; font-family: monospace; letter-spacing: 1px;">VGBK-0000001</div>
                                                  </div>
                                                  <div class="passbook-stamp">OFFICIAL</div>
                                              </div>
                                              <!-- Back Face -->
                                              <div class="card-face card-back" style="position: absolute; inset: 0; padding: 18px; padding-right: 35px; display: flex; flex-direction: column; justify-content: space-between; backface-visibility: hidden; transform: rotateY(180deg); background: inherit; border-radius: inherit;">
                                                  <div style="height: 28px; background: rgba(255,255,255,0.1); margin: 0 -18px; margin-top: 3px; border-bottom: 1px dashed rgba(255,255,255,0.2);"></div>
                                                  <div style="text-align: center; padding: 10px 0;">
                                                      <div style="font-size: 0.5rem; color: rgba(255,255,255,0.6); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px;">Branch Seal</div>
                                                      <div style="width: 60px; height: 60px; border: 2px solid rgba(255,255,255,0.4); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto; font-size: 0.45rem; font-weight: 700; color: rgba(255,255,255,0.7); text-transform: uppercase; letter-spacing: 0.5px;">VGB<br>SEAL</div>
                                                  </div>
                                                  <div style="font-size: 0.5rem; color: rgba(255,255,255,0.5); text-align: center; line-height: 1.3;">
                                                      VGB Savings Passbook • Official Document<br>Click to flip back
                                                  </div>
                                              </div>
                                          </div>
                                      </div>
                                      <div style="font-size: 0.7rem; color: var(--gray-400); text-align: center; margin-top: 8px;">
                                          Click to flip • Inspect both sides
                                      </div>
                                  </div>
                              </div>
                          </div>
                      </div>

                    <!-- STEP 5: Credentials & Auto-Gen PIN -->
                    <div class="wizard-step-pane" id="wizardStepCredentials">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Access Username & Passwords</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Secure Login Username *</label>
                                <input type="text" name="username" id="wizUsername" class="form-control" placeholder="E.g. vertex_john">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Secure Access Password *</label>
                                <input type="password" name="password" id="wizPassword" class="form-control" placeholder="Min 8 chars, Upper, Lower, Special">
                            </div>
                            
                            <!-- Auto-Generated PIN visual representation -->
                            <div style="grid-column: 1 / -1; background: rgba(16,185,129,0.04); border: 1px dashed rgba(16,185,129,0.2); padding: 15px; border-radius: var(--radius-md); text-align: center; margin-top: 15px;">
                                <span style="font-size: 0.75rem; font-weight: 700; color: #10b981; display: block; text-transform: uppercase; letter-spacing: 0.5px;">Auto-Generated Secure PIN</span>
                                <strong style="font-size: 2.2rem; font-family: monospace; letter-spacing: 3px; color: var(--gray-800);" id="wizAutoPinLabel">0000</strong>
                                <span style="font-size: 0.7rem; color: var(--gray-400); display: block; margin-top: 5px;">This PIN is automatically generated for secure ATM card activation. It is read-only.</span>
                            </div>
                        </div>
                    </div>

                    <!-- STEP 6: Ledger Initial Funding deposit -->
                    <div class="wizard-step-pane" id="wizardStepFunding">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Initial Onboarding Deposit</h4>
                        
                        <div style="background: rgba(99,102,241,0.05); border-left: 4px solid var(--primary-500); padding: 15px; border-radius: var(--radius-sm); margin-bottom: 25px;">
                            <span style="font-size: 0.75rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; display: block; letter-spacing: 0.5px;">Fixed Minimum deposit boundaries:</span>
                            <strong style="font-size: 1.15rem; color: var(--gray-700); display: block; margin-top: 3px;" id="wizMinDepositLabel">₹1,000.00 Minimum</strong>
                            <span style="font-size: 0.7rem; color: var(--gray-400); display: block; margin-top: 5px;">You may deposit a larger amount, but payments below the minimum require limit will be rejected.</span>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">Ledger Onboarding Deposit Amount (₹) *</label>
                                <input type="number" name="initialDeposit" id="wizInitialDeposit" class="form-control" value="1000" min="500" step="100">
                            </div>
                            <div class="form-group">
                                <label class="form-label">VGB Branch IFSC Routing</label>
                                <input type="text" name="ifscCode" id="wizIfscCode" class="form-control" value="VGBK0000001" readonly style="background: var(--gray-100); color: var(--gray-500); cursor: not-allowed;">
                            </div>
                        </div>
                    </div>

                    <!-- STEP 7: Comprehensive Summary Page -->
                    <div class="wizard-step-pane" id="wizardStepSummary">
                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid var(--gray-200); padding-bottom: 8px;">Review Account Summary</h4>
                        
                        <div id="wizardSummaryContainer">
                            <!-- Dynamically populated in JavaScript before this step opens -->
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="wizBackBtn" onclick="navigateWizardStep(-1)">Back</button>
                    <button type="button" class="btn btn-primary" id="wizNextBtn" onclick="navigateWizardStep(1)" style="background: var(--gradient-primary); border: none; color: white;">Next Step</button>
                    <button type="submit" class="btn btn-primary" id="wizSubmitBtn" style="background: var(--gradient-primary); border: none; display: none; color: white;">Finish Onboarding</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripting controls -->
    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
    <script>
        window.VGB_CONTEXT_PATH = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/assest/js/admin-account.js?v=1.0"></script>
</body>
</html>
