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
                    <title>VGB | Financial Statements</title>
                    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Share+Tech+Mono&display=swap"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/assest/css/styles.css?v=2.6" rel="stylesheet">
                    <style>
                        :root {
                            --glass-bg: rgba(255, 255, 255, 0.45);
                            --glass-bg-hover: rgba(255, 255, 255, 0.65);
                            --glass-border: rgba(255, 255, 255, 0.4);
                            --glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.06);
                            --glass-glow: inset 0 0 20px rgba(255, 255, 255, 0.2);
                            --accent-green: #10b981;
                            --accent-red: #ef4444;
                            --accent-blue: #3b82f6;
                        }

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
                            background: var(--glass-bg);
                            backdrop-filter: blur(20px) saturate(180%);
                            -webkit-backdrop-filter: blur(20px) saturate(180%);
                            border: 1px solid var(--glass-border);
                            border-radius: var(--radius-lg);
                            padding: 28px;
                            box-shadow: var(--glass-shadow), var(--glass-glow);
                            transition: border-color 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
                            margin-bottom: 30px;
                        }

                        .glass-card:hover {
                            background: var(--glass-bg-hover);
                            border-color: rgba(99, 102, 241, 0.25);
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

                        /* Premium Tab Buttons */
                        .statement-tabs-container {
                            display: flex;
                            gap: 15px;
                            margin-bottom: 30px;
                            flex-wrap: wrap;
                        }

                        .statement-type-btn-premium {
                            display: inline-flex;
                            align-items: center;
                            gap: 10px;
                            padding: 14px 28px;
                            font-weight: 600;
                            font-size: 0.92rem;
                            border-radius: 14px;
                            cursor: pointer;
                            border: 1.5px solid rgba(99, 102, 241, 0.1);
                            background: rgba(255, 255, 255, 0.7);
                            color: var(--gray-600);
                            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                            box-shadow: 0 4px 15px rgba(31, 38, 135, 0.03);
                            backdrop-filter: blur(10px);
                        }

                        .statement-type-btn-premium i {
                            font-size: 1.25rem;
                            transition: transform 0.3s ease;
                        }

                        .statement-type-btn-premium:hover {
                            background: rgba(255, 255, 255, 0.95);
                            border-color: rgba(99, 102, 241, 0.3);
                            color: var(--primary-500);
                            transform: translateY(-2px);
                        }

                        .statement-type-btn-premium:hover i {
                            transform: scale(1.1);
                        }

                        .statement-type-btn-premium.active {
                            background: var(--gradient-primary);
                            color: white;
                            border-color: transparent;
                            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.25);
                        }

                        .statement-type-btn-premium:active {
                            transform: scale(0.96) !important;
                        }

                        /* Redesigned Premium Filters & Option Section */
                        .filter-card {
                            background: rgba(255, 255, 255, 0.7);
                            backdrop-filter: blur(20px) saturate(180%);
                            -webkit-backdrop-filter: blur(20px) saturate(180%);
                            border: 1px solid rgba(99, 102, 241, 0.15);
                            border-radius: 16px;
                            padding: 24px;
                            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
                            transition: all 0.3s ease;
                            margin-bottom: 30px;
                        }

                        .filter-card:hover {
                            border-color: rgba(99, 102, 241, 0.25);
                            box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.08);
                        }

                        .filter-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                            gap: 20px;
                        }

                        .filter-group-premium {
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                            position: relative;
                        }

                        .filter-label-premium {
                            font-size: 0.8rem;
                            font-weight: 700;
                            color: var(--gray-500);
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            display: flex;
                            align-items: center;
                            gap: 6px;
                        }

                        .filter-label-premium i {
                            color: var(--primary-500);
                            font-size: 1rem;
                        }

                        .filter-select-premium,
                        .filter-input-premium {
                            width: 100%;
                            padding: 12px 16px;
                            border: 1.5px solid rgba(99, 102, 241, 0.15);
                            border-radius: 12px;
                            background: rgba(255, 255, 255, 0.9);
                            outline: none;
                            font-weight: 600;
                            font-size: 0.9rem;
                            color: var(--gray-700);
                            transition: all 0.2s ease;
                            cursor: pointer;
                            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.02);
                        }

                        .filter-select-premium:focus,
                        .filter-input-premium:focus {
                            border-color: var(--primary-400);
                            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
                            background: white;
                        }

                        .filter-select-premium:hover,
                        .filter-input-premium:hover {
                            border-color: rgba(99, 102, 241, 0.3);
                        }

                        .custom-date-container {
                            grid-column: span 3;
                            background: rgba(99, 102, 241, 0.03);
                            padding: 20px;
                            border-radius: 14px;
                            border: 1px dashed rgba(99, 102, 241, 0.2);
                            margin-top: 10px;
                            animation: slideDownFade 0.3s ease forwards;
                        }

                        @keyframes slideDownFade {
                            from {
                                opacity: 0;
                                transform: translateY(-10px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }

                        /* Ledger Table Styles */
                        .ledger-table-container {
                            overflow-x: auto;
                            border: 1px solid rgba(255, 255, 255, 0.5);
                            border-radius: var(--radius-md);
                            box-shadow: var(--shadow-sm);
                            margin-bottom: 25px;
                            background: rgba(255, 255, 255, 0.6);
                        }

                        .ledger-table {
                            width: 100%;
                            border-collapse: collapse;
                            text-align: left;
                            font-size: 0.85rem;
                            margin-bottom: 0;
                        }

                        .ledger-table th {
                            background: rgba(99, 102, 241, 0.05);
                            color: var(--gray-800);
                            padding: 14px 16px;
                            font-weight: 700;
                            font-size: 0.75rem;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            border-bottom: 2px solid rgba(99, 102, 241, 0.1);
                        }

                        .ledger-table td {
                            padding: 15px 16px;
                            border-bottom: 1px solid var(--gray-100);
                            color: var(--gray-700);
                        }

                        .ledger-table tbody tr {
                            transition: background-color 0.2s;
                        }

                        .ledger-table tbody tr:hover {
                            background-color: rgba(99, 102, 241, 0.02);
                        }

                        .txn-deposit-val {
                            color: var(--accent-green) !important;
                            font-weight: 700;
                        }

                        .txn-withdrawal-val {
                            color: var(--accent-red) !important;
                            font-weight: 700;
                        }

                        .txn-balance-val {
                            font-family: 'Share Tech Mono', monospace;
                            font-weight: 700;
                            color: var(--gray-900);
                        }

                        .badge-status {
                            display: inline-block;
                            padding: 4px 8px;
                            border-radius: var(--radius-sm);
                            font-size: 0.72rem;
                            font-weight: 700;
                            text-transform: uppercase;
                        }

                        .badge-status-completed {
                            background: rgba(16, 185, 129, 0.1);
                            color: var(--accent-green);
                        }

                        .badge-status-pending {
                            background: rgba(245, 158, 11, 0.1);
                            color: #d97706;
                        }

                        .badge-status-failed {
                            background: rgba(239, 68, 68, 0.1);
                            color: var(--accent-red);
                        }

                        .badge-type {
                            font-weight: 600;
                            text-transform: capitalize;
                        }

                        .badge-type.deposit {
                            color: var(--accent-green);
                        }

                        .badge-type.withdrawal {
                            color: var(--accent-red);
                        }

                        .badge-type.transfer {
                            color: var(--accent-blue);
                        }

                        .print-bg-container{
                            display:none;
                            position:fixed;
                            inset:0;
                            width:100%;
                            height:100%;
                            overflow:hidden;
                        }

                        .print-only {
                            display: none !important;
                        }

                        /* Print Layout Table Helper to avoid overlap with fixed headers/footers */
                        .print-layout-table {
                            display: block;
                            width: 100%;
                            border: none;
                            margin: 0;
                            padding: 0;
                        }
                        .print-layout-thead,
                        .print-layout-tbody,
                        .print-layout-tfoot,
                        .print-layout-tr,
                        .print-layout-td {
                            display: block;
                            width: 100%;
                        }
                        .print-header-space,
                        .print-footer-space {
                            display: none;
                        }

                        /* Print Optimized CSS for Professional Multi-Page Statements */
                        @media print {
                            @page {
                                size: A4 portrait;
                                margin-top: 15mm;
                                margin-bottom: 15mm;
                                margin-left: 15mm;
                                margin-right: 15mm;
                            }

                            html,
                            body {
                                width: 100% !important;
                                height: auto !important;
                                min-height: auto !important;
                                margin: 0 !important;
                                padding: 0 !important;
                                overflow: visible !important;
                                background: white !important;
                                -webkit-print-color-adjust: exact;
                                print-color-adjust: exact;
                            }

                            /* Hide all non-printable elements */
                            .header,
                            .sidebar,
                            .footer,
                            .no-print,
                            aside,
                            .preloader,
                            .cursor-glow {
                                display: none !important;
                            }

                            .main-content {
                                margin-left: 0 !important;
                                padding: 0 !important;
                                min-height: auto !important;
                                width: 100% !important;
                            }

                            .container {
                                max-width: 100% !important;
                                padding: 0 !important;
                                margin: 0 !important;
                            }

                            /* Refactored Page & Layout Wrappers */
                            .statement-page {
                                background: transparent !important;
                                border: none !important;
                                box-shadow: none !important;
                                padding: 0 !important;
                                margin: 0 !important;
                                width: 100% !important;
                                height: auto !important;
                                min-height: auto !important;
                                max-height: none !important;
                                overflow: visible !important;
                                box-sizing: border-box !important;
                                page-break-inside: auto !important;
                            }

                            .statement-page:not([style*="display: none"]) {
                                display: block !important;
                                position: relative !important;
                                z-index: 2 !important;
                                page-break-after: auto !important;
                            }

                            .statement-content {
                                position: relative !important;
                                z-index: 5 !important;
                                width: 100% !important;
                            }

                            /* Hide the background letterpad image as requested */
                            .print-bg-container,
                            .print-bg-img,
                            .letterpad {
                                display: none !important;
                            }

                            /* Repeating bank header - repeats on every printed page */
                            .print-header {
                                display: block !important;
                                width: 100% !important;
                                box-sizing: border-box !important;
                            }

                            /* Fixed bank footer with page numbers - repeats on every printed page */
                            .print-footer {
                                display: block !important;
                                width: 100% !important;
                                box-sizing: border-box !important;
                            }

                            .print-layout-table {
                                display: table !important;
                                width: 100% !important;
                                border-collapse: collapse !important;
                                border: none !important;
                            }
                            .print-layout-thead {
                                display: table-header-group !important;
                            }
                            .print-layout-tbody {
                                display: table-row-group !important;
                            }
                            .print-layout-tfoot {
                                display: table-footer-group !important;
                            }
                            .print-layout-tr {
                                display: table-row !important;
                            }
                            .print-layout-td {
                                display: table-cell !important;
                                border: none !important;
                                padding: 0 !important;
                            }
                            .print-header-space {
                                display: block !important;
                                height: 38mm !important; /* height of header (30mm) + safety margin (8mm) */
                            }
                            .print-footer-space {
                                display: block !important;
                                height: 32mm !important; /* height of footer (22mm) + safety margin (10mm) */
                            }

                            .print-page-number::after {
                                content: "Page " counter(page);
                            }

                            /* Hide the on-screen plain-text bank name/tagline in print,
                               since the repeated print-header already carries the branding */
                            .print-hide-header {
                                display: none !important;
                            }

                            /* Table Styling and Wrapper Cleanups */
                            .statement-page div[style*="overflow"],
                            .statement-content div[style*="overflow"],
                            .ledger-table-container {
                                overflow: visible !important;
                                border: none !important;
                                box-shadow: none !important;
                                background: transparent !important;
                                margin-bottom: 0 !important;
                                padding: 0 !important;
                            }

                            .ledger-table {
                                width: 100% !important;
                                table-layout: auto !important;
                                border-collapse: collapse !important;
                                page-break-inside: auto !important;
                                border-top: 1.5px solid #cbd5e0 !important;
                                border-bottom: 1.5px solid #cbd5e0 !important;
                            }

                            .ledger-table thead {
                                display: table-header-group !important; /* Repeats table header at top of every page */
                            }

                            .ledger-table tr {
                                page-break-inside: avoid !important;   /* Prevent row from splitting across pages */
                                page-break-after: auto !important;
                            }

                            .ledger-table th,
                            .ledger-table td {
                                padding: 8px 10px !important;
                                font-size: 9.5pt !important;
                                line-height: 1.4 !important;
                                white-space: normal !important;
                                word-wrap: break-word !important;
                                border-bottom: 1px solid #cbd5e0 !important;
                                page-break-inside: avoid !important;
                            }

                            .ledger-table th {
                                background-color: #f7fafc !important;
                                color: #2d3748 !important;
                                font-weight: 700 !important;
                                border-bottom: 2px solid #cbd5e0 !important;
                            }

                            .print-only {
                                display: flex !important;
                            }

                            /* Clean up badges and values for printer-friendly output */
                            .badge-id,
                            .txn-deposit-val,
                            .txn-withdrawal-val,
                            .txn-balance-val,
                            .badge-status,
                            .badge-type,
                            span[style*="background"] {
                                background: transparent !important;
                                padding: 0 !important;
                                box-shadow: none !important;
                            }
                            
                            .txn-deposit-val {
                                color: #2f855a !important; /* Dark green for print readability */
                            }

                            .txn-withdrawal-val {
                                color: #c53030 !important; /* Dark red for print readability */
                            }

                            .txn-balance-val {
                                color: #1a202c !important;
                                font-weight: 700 !important;
                            }

                            .badge-status-completed {
                                color: #2f855a !important;
                            }

                            .badge-status-pending {
                                color: #b7791f !important;
                            }

                            .badge-status-failed {
                                color: #c53030 !important;
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

                    <!-- Header -->
                    <header class="header scrolled no-print">
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Toggle Navigation"
                                style="align-items: center; justify-content: center; background: none; border: none; font-size: 1.8rem; color: var(--gray-700); cursor: pointer; padding: 5px; border-radius: var(--radius-sm); transition: background 0.2s;">
                                <i class="bx bx-menu"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo"
                                style="display: flex; align-items: center; text-decoration: none;">
                                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo"
                                    style="width: 50px; height: 50px; flex-shrink: 0; object-fit: contain;">
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
                                                      onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assest/images/default-avatar.jpg';"
                                                      style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                                              </c:when>
                                              <c:otherwise>
                                                  <img src="${pageContext.request.contextPath}/assest/images/default-avatar.jpg" alt="Customer Profile Avatar" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assest/images/logo.png';" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary-500); box-shadow: 0 0 10px rgba(99, 102, 241, 0.15);">
                                              </c:otherwise>
                                         </c:choose>
                                        <div style="display: flex; flex-direction: column; text-align: left;"
                                            class="mobile-hide">
                                            <span
                                                style="font-weight: 700; color: var(--gray-800); font-size: 0.85rem; line-height: 1.2;">${customer.fullName}</span>
                                            <span
                                                style="font-size: 0.7rem; color: var(--gray-400); font-weight: 600; display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                                <span
                                                    style="width: 6px; height: 6px; border-radius: 50%; background: var(--accent-green); display: inline-block;"></span>
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
                            <!-- Theme Toggle Button -->
                            <button type="button" class="theme-toggle-btn" id="themeToggleBtn" onclick="toggleTheme()" title="Toggle Dark / Light Theme" aria-label="Toggle Theme" style="display: inline-flex; align-items: center; justify-content: center; width: 38px; height: 38px; border-radius: 50%; background: rgba(99, 102, 241, 0.08); border: 1.5px solid rgba(99, 102, 241, 0.2); color: var(--primary-600); cursor: pointer; transition: all 0.3s ease;">
                                <i class="bx bx-moon" id="themeToggleIcon" style="font-size: 1.2rem;"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                                <i class="bx bx-log-out"></i>
                                <span>Logout</span>
                            </a>
                        </div>
                    </header>

                    <!-- Sidebar Navigation -->
                    <aside class="sidebar no-print">
                        <div class="sidebar-menu">
                            <a href="${pageContext.request.contextPath}/customer-dashboard"><i
                                    class="bx bx-grid-alt"></i> Dashboard</a>
                            <a href="${pageContext.request.contextPath}/account?action=list"><i
                                    class="bx bx-wallet"></i> Accounts</a>
                            <a href="${pageContext.request.contextPath}/account?action=transferPage"><i
                                    class="bx bx-transfer-alt"></i> Fund Transfer</a>
                            <a href="${pageContext.request.contextPath}/card?action=list"><i
                                    class="bx bx-credit-card"></i> My Cards</a>
                            <a href="${pageContext.request.contextPath}/card-repayment?action=history"><i
                                    class="bx bx-receipt"></i> Card Repayments</a>
                            <a href="${pageContext.request.contextPath}/auto-pay?action=dashboard"><i
                                    class="bx bx-sync"></i> Auto Pay</a>
                            <a href="${pageContext.request.contextPath}/chequebook?action=list"><i
                                    class="bx bx-book-bookmark"></i> Cheque Books</a>
                            <a href="${pageContext.request.contextPath}/passbook?action=list"><i
                                    class="bx bx-book-open"></i> Passbook Requests</a>
                            <a href="${pageContext.request.contextPath}/loan?action=list"><i
                                    class="bx bx-building-house"></i> Loans</a>
                            <a href="${pageContext.request.contextPath}/account?action=statement" class="active"><i
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
                            <!-- Page Header -->
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;"
                                class="no-print">
                                <div>
                                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Transaction
                                        Ledger Statements</h2>
                                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Filter by
                                        date, category type, or print official bank transcripts.</p>
                                </div>
                                <button type="button"
                                    onclick="printStatement(document.getElementById('regularStatement').style.display !== 'none' ? 'regularStatement' : 'loanStatement')"
                                    class="btn btn-primary"
                                    style="display: inline-flex; align-items: center; gap: 8px;">
                                    <span>Export Statement</span>
                                    <i class="bx bx-printer"></i>
                                </button>
                            </div>

                            <!-- Tabs Section -->
                            <div class="statement-tabs-container no-print">
                                <button class="statement-type-btn-premium active" id="btnRegular"
                                    onclick="switchStmt('regular')">
                                    <i class="bx bx-receipt"></i> Regular Ledger Statement
                                </button>
                                <button class="statement-type-btn-premium" id="btnLoan" onclick="switchStmt('loan')">
                                    <i class="bx bx-building-house"></i> Loan Statement
                                </button>
                            </div>

                            <!-- Regular Search Filters -->
                            <div class="filter-card no-print" id="regularFilters">
                                <h4
                                    style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-slider" style="color: var(--primary-500); font-size: 1.3rem;"></i>
                                    Filters &amp; Query Range
                                </h4>
                                <div class="filter-grid">
                                    <div class="filter-group-premium">
                                        <label class="filter-label-premium">
                                            <i class="bx bx-calendar"></i> Date Range
                                        </label>
                                        <select id="dateFilter" onchange="runFilter()" class="filter-select-premium">
                                            <option value="all">Full Statement</option>
                                            <option value="today">Today Only</option>
                                            <option value="month">Current Month</option>
                                            <option value="year">Current Year</option>
                                            <option value="custom">Custom Date Range</option>
                                        </select>
                                    </div>
                                    <div class="filter-group-premium">
                                        <label class="filter-label-premium">
                                            <i class="bx bx-transfer"></i> Transaction Type
                                        </label>
                                        <select id="typeFilter" onchange="runFilter()" class="filter-select-premium">
                                            <option value="all">All Types</option>
                                            <option value="deposit">Deposits</option>
                                            <option value="withdrawal">Withdrawals</option>
                                            <option value="transfer">Transfers</option>
                                        </select>
                                    </div>
                                    <div class="filter-group-premium">
                                        <label class="filter-label-premium">
                                            <i class="bx bx-wallet"></i> Select Account
                                        </label>
                                        <select id="accountFilter" onchange="switchAccount(this.value)"
                                            class="filter-select-premium">
                                            <c:forEach items="${accounts}" var="acc">
                                                <option value="${acc.accountId}" ${acc.accountId==selectedAccountId
                                                    ? 'selected' : '' }>
                                                    ${acc.accountNumber} - ${acc.accountType} (₹
                                                    <fmt:formatNumber value="${acc.balance}" minFractionDigits="2"
                                                        maxFractionDigits="2" />)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="custom-date-container" id="customDateRangeGroup" style="display: none;">
                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;"
                                            class="mobile-grid-1">
                                            <div class="filter-group-premium">
                                                <label class="filter-label-premium">
                                                    <i class="bx bx-time-five"></i> Start Date
                                                </label>
                                                <input type="date" id="startDate" onchange="runFilter()"
                                                    class="filter-input-premium">
                                            </div>
                                            <div class="filter-group-premium">
                                                <label class="filter-label-premium">
                                                    <i class="bx bx-time"></i> End Date
                                                </label>
                                                <input type="date" id="endDate" onchange="runFilter()"
                                                    class="filter-input-premium">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Loan Search Filters -->
                            <div class="filter-card no-print" id="loanFilters" style="display: none;">
                                <h4
                                    style="font-size: 1.1rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                                    <i class="bx bx-slider" style="color: var(--primary-500); font-size: 1.3rem;"></i>
                                    Loan Statement Filters
                                </h4>
                                <div class="filter-grid" style="grid-template-columns: 1fr;">
                                    <div class="filter-group-premium">
                                        <label class="filter-label-premium">
                                            <i class="bx bx-building-house"></i> Select Active Loan
                                        </label>
                                        <select id="loanSelectFilter" onchange="switchLoan(this.value)"
                                            class="filter-select-premium">
                                            <c:choose>
                                                <c:when test="${not empty customerLoans}">
                                                    <c:forEach items="${customerLoans}" var="ln">
                                                        <option value="${ln.loanId}" ${ln.loanId==selectedLoanId
                                                            ? 'selected' : '' }>
                                                            Loan ID: ${ln.loanId} - ${ln.loanType} Loan (Principal: ₹
                                                            <fmt:formatNumber value="${ln.principalAmount}"
                                                                minFractionDigits="2" maxFractionDigits="2" />) -
                                                            Status: ${ln.status}
                                                        </option>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="0">No active loans found</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="glass-card statement-page" id="regularStatement">
                                <!-- Reusable Letter Pad Background -->
                                <div class="letterpad">
                                    <div class="print-bg-container">
                                        <img src="${pageContext.request.contextPath}/assest/images/All Forms/Letter%20Pad.png"
                                            class="print-bg-img" alt="VGB Letterhead">
                                    </div>
                                </div>

                                <div class="statement-content">
                                    <table class="print-layout-table">
                                         <thead class="print-layout-thead">
                                             <tr class="print-layout-tr">
                                                 <td class="print-layout-td">
                                                     <div class="print-header" style="font-family: 'Poppins', sans-serif; width: 100%; margin-bottom: 20px;">
                                                         <!-- Top Row: Logo & Corporate HQ Details -->
                                                         <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2.5px solid #6366f1; padding-bottom: 8px;">
                                                             <div style="display: flex; align-items: center; gap: 12px; text-align: left;">
                                                                 <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 45px; height: 45px; object-fit: contain;">
                                                                 <div style="text-align: left;">
                                                                     <h1 style="font-size: 1.45rem; font-weight: 800; color: #6366f1; letter-spacing: 0.5px; margin: 0;">VERTEX GALAXY BANK</h1>
                                                                     <p style="font-size: 0.75rem; color: #718096; margin: 2px 0 0; font-weight: 600;">Always Beyond Boundaries</p>
                                                                 </div>
                                                             </div>
                                                             <div style="text-align: right; line-height: 1.3;">
                                                                 <p style="margin: 0; font-size: 7.5pt; color: #4a5568; font-weight: 600;">Corporate HQ: VGB Corporate Towers, BKC Road,</p>
                                                                 <p style="margin: 0; font-size: 7.5pt; color: #4a5568; font-weight: 600;">Bandra Kurla Complex, Mumbai, MH - 400051</p>
                                                                 <p style="margin: 0; font-size: 7.5pt; color: #718096; font-weight: 500;">Toll Free: 1800-VGB-BANK | www.vertexgalaxybank.com</p>
                                                             </div>
                                                         </div>
                                                         <!-- Bottom Row: Statement Subtitle & Reference Details -->
                                                         <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 6px; font-size: 8pt; color: #4a5568; font-weight: 600;">
                                                             <div style="font-weight: 700; text-transform: uppercase;">Transaction Ledger Log</div>
                                                             <div style="display: flex; gap: 15px;">
                                                                 <span style="font-family: monospace;">ACC-REF: #ACC-${selectedAccount.accountNumber}</span>
                                                                 <span>Date: <span class="currentDatePrint"></span></span>
                                                             </div>
                                                         </div>
                                                     </div>
                                                 </td>
                                             </tr>
                                         </thead>
                                         <tbody class="print-layout-tbody">
                                             <tr class="print-layout-tr">
                                                 <td class="print-layout-td">
                                    <!-- Official Header Subtitle -->
                                    <div
                                        style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                                        <span
                                            style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official
                                            Account Transaction Ledger Statement</span>
                                    </div>

                                    <!-- Details grid (Bank details vs Customer details) -->
                                    <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);"
                                        class="mobile-grid-1 print-row-format">
                                        <!-- Left: Bank Information -->
                                        <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                                            <span
                                                style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank
                                                Details</span>
                                            <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate
                                                HQ)</strong>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers,
                                                BKC Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code:
                                                <strong style="font-family: monospace;">VGBK0000001</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free:
                                                1800-VGB-BANK</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal:
                                                www.vertexgalaxybank.com</p>
                                        </div>

                                        <!-- Right: Customer & Account Details -->
                                        <div>
                                            <span
                                                style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer
                                                &amp; Account Details</span>
                                            <strong
                                                style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;">${customer.fullName}</strong>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong
                                                    style="font-family: monospace;">#VGB-CUST-${customer.customerId}</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address:
                                                ${customer.address}, ${customer.city}, ${customer.state} -
                                                ${customer.zipCode}</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Account Number: <strong
                                                    style="font-family: monospace;">${selectedAccount.accountNumber}</strong>
                                                (${selectedAccount.accountType} Account)</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Account Balance:
                                                <strong>₹
                                                    <fmt:formatNumber value="${selectedAccount.balance}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                        </div>
                                    </div>

                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                                        <h4
                                            style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                                            <i class="bx bx-history" style="color: var(--primary-500);"></i> Transaction
                                            Ledger Log
                                        </h4>
                                        <button type="button" onclick="printStatement('regularStatement')"
                                            class="btn btn-primary no-print"
                                            style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px; background: var(--gradient-primary); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                                            <span>Print Document</span>
                                            <i class="bx bx-printer"></i>
                                        </button>
                                    </div>

                                    <div class="ledger-table-container">
                                        <table class="ledger-table" id="txnTable">
                                            <thead>
                                                <tr>
                                                    <th style="width: 80px;">Sr. No.</th>
                                                    <th>Transaction Date</th>
                                                    <th>Type</th>
                                                    <th>Description</th>
                                                    <th>Status</th>
                                                    <th style="text-align: right;">Credit Amount</th>
                                                    <th style="text-align: right;">Debit Amount</th>
                                                    <th style="text-align: right;">Running Balance</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty transactions}">
                                                        <c:set var="txnSr" value="0" />
                                                        <c:forEach var="txn" items="${transactions}">
                                                            <c:set var="txnSr" value="${txnSr + 1}" />
                                                            <tr class="txn-row" data-type="${txn.transactionType}">
                                                                <td style="font-weight: 600; color: var(--gray-500);">
                                                                    ${txnSr}</td>
                                                                <td class="txn-date">${txn.transactionDate}</td>
                                                                <td>
                                                                    <span
                                                                        class="badge-type ${txn.transactionType}">${txn.transactionType}</span>
                                                                </td>
                                                                <td>${txn.description}</td>
                                                                <td>
                                                                    <span
                                                                        class="badge-status badge-status-${txn.status.toLowerCase()}">${txn.status}</span>
                                                                </td>
                                                                <td style="text-align: right;">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${txn.transactionType == 'deposit' || txn.transactionType == 'interest' || (txn.transactionType == 'transfer' && txn.toAccountId == selectedAccountId)}">
                                                                            <span class="txn-deposit-val">+ ₹
                                                                                <fmt:formatNumber value="${txn.amount}"
                                                                                    minFractionDigits="2"
                                                                                    maxFractionDigits="2" />
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td style="text-align: right;">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${txn.transactionType == 'withdrawal' || txn.transactionType == 'fee' || (txn.transactionType == 'transfer' && txn.fromAccountId == selectedAccountId)}">
                                                                            <span class="txn-withdrawal-val">- ₹
                                                                                <fmt:formatNumber value="${txn.amount}"
                                                                                    minFractionDigits="2"
                                                                                    maxFractionDigits="2" />
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td style="text-align: right;" class="txn-balance-val">
                                                                    ₹
                                                                    <fmt:formatNumber value="${txn.runningBalance}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr class="txn-row">
                                                            <td colspan="8"
                                                                style="text-align: center; padding: 35px; color: var(--gray-400);">
                                                                No transactions retrieved for this account.</td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Footer Signatures (print only) -->
                                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px; page-break-inside: avoid; break-inside: avoid;"
                                        class="print-only">
                                        <div style="text-align: center; width: 200px;">
                                            <div
                                                style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;">
                                            </div>
                                            <span
                                                style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Authorized
                                                Signatory</span>
                                        </div>
                                        <div style="text-align: center; width: 200px;">
                                            <div
                                                style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;">
                                            </div>
                                            <span
                                                style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">System Generated Seals</span>
                                        </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tfoot class="print-layout-tfoot">
                                        <tr class="print-layout-tr">
                                            <td class="print-layout-td">
                                                <div class="print-footer" style="padding-top: 10px;">
                                                    <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1.5px solid #cbd5e0; padding-top: 8px; font-family: 'Poppins', sans-serif; width: 100%;">
                                                        <div style="font-size: 8pt; color: #4a5568; font-weight: 500; line-height: 1.4; text-align: left;">
                                                            Vertex Galaxy Bank &bull; Support Toll Free: 1800-VGB-BANK &bull; Online Portal: www.vertexgalaxybank.com
                                                            <br>
                                                            <span style="font-size: 7.5pt; color: #718096;">Corporate HQ: VGB Corporate Towers, BKC Road, Bandra Kurla Complex, Mumbai - 400051</span>
                                                        </div>
                                                        <div class="print-page-number" style="font-size: 8pt; color: #2d3748; font-weight: 700; white-space: nowrap; align-self: flex-start; padding-top: 2px;"></div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>

                            <div class="glass-card statement-page" id="loanStatement" style="display: none;">
                                <!-- Reusable Letter Pad Background -->
                                <div class="letterpad">
                                    <div class="print-bg-container">
                                        <img src="${pageContext.request.contextPath}/assest/images/All Forms/Letter-Pad.png"
                                            class="print-bg-img" alt="VGB Letterhead">
                                    </div>
                                </div>

                                <div class="statement-content">
                                    <table class="print-layout-table">
                                        <thead class="print-layout-thead">
                                            <tr class="print-layout-tr">
                                                <td class="print-layout-td">
                                                    <div class="print-header" style="font-family: 'Poppins', sans-serif; width: 100%; margin-bottom: 20px;">
                                                        <!-- Top Row: Logo & Corporate HQ Details -->
                                                        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2.5px solid #6366f1; padding-bottom: 8px;">
                                                            <div style="display: flex; align-items: center; gap: 12px; text-align: left;">
                                                                <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 45px; height: 45px; object-fit: contain;">
                                                                <div style="text-align: left;">
                                                                    <h1 style="font-size: 1.45rem; font-weight: 800; color: #6366f1; letter-spacing: 0.5px; margin: 0;">VERTEX GALAXY BANK</h1>
                                                                    <p style="font-size: 0.75rem; color: #718096; margin: 2px 0 0; font-weight: 600;">Always Beyond Boundaries</p>
                                                                </div>
                                                            </div>
                                                            <div style="text-align: right; line-height: 1.3;">
                                                                <p style="margin: 0; font-size: 7.5pt; color: #4a5568; font-weight: 600;">Corporate HQ: VGB Corporate Towers, BKC Road,</p>
                                                                <p style="margin: 0; font-size: 7.5pt; color: #4a5568; font-weight: 600;">Bandra Kurla Complex, Mumbai, MH - 400051</p>
                                                                <p style="margin: 0; font-size: 7.5pt; color: #718096; font-weight: 500;">Toll Free: 1800-VGB-BANK | www.vertexgalaxybank.com</p>
                                                            </div>
                                                        </div>
                                                        <!-- Bottom Row: Statement Subtitle & Reference Details -->
                                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 6px; font-size: 8pt; color: #4a5568; font-weight: 600;">
                                                            <div style="font-weight: 700; text-transform: uppercase;">Loan Account Ledger Log</div>
                                                            <div style="display: flex; gap: 15px;">
                                                                <span style="font-family: monospace;">LN-REF: #LN-${selectedLoan.loanId}</span>
                                                                <span>Date: <span class="currentDatePrint"></span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody class="print-layout-tbody">
                                            <tr class="print-layout-tr">
                                                <td class="print-layout-td">
                                    <!-- Official Header Subtitle -->
                                    <div
                                        style="text-align: center; background: rgba(99, 102, 241, 0.04); border: 1px dashed rgba(99, 102, 241, 0.15); border-radius: var(--radius-sm); padding: 10px 15px; margin-bottom: 25px;">
                                        <span
                                            style="font-size: 0.85rem; font-weight: 700; color: var(--primary-500); text-transform: uppercase; letter-spacing: 1.5px;">Official
                                            Loan Amortization &amp; Repayment Statement</span>
                                    </div>

                                    <c:set var="totalRepaid" value="0.0" />
                                    <c:if test="${not empty repayments}">
                                        <c:forEach var="rpy" items="${repayments}">
                                            <c:set var="totalRepaid" value="${totalRepaid + rpy.amountPaid}" />
                                        </c:forEach>
                                    </c:if>

                                    <!-- Details grid (Bank details vs Customer details) -->
                                    <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 25px; margin-bottom: 30px; font-size: 0.85rem; line-height: 1.5; color: var(--gray-700);"
                                        class="mobile-grid-1 print-row-format">
                                        <!-- Left: Bank Information -->
                                        <div style="border-right: 1px dashed var(--gray-300); padding-right: 20px;">
                                            <span
                                                style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Bank
                                                Details</span>
                                            <strong style="color: var(--gray-900);">Vertex Galaxy Bank (Corporate
                                                HQ)</strong>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">VGB Corporate Towers,
                                                BKC
                                                Road, Bandra Kurla Complex,<br>Mumbai, Maharashtra - 400051</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">IFSC Branch Code:
                                                <strong style="font-family: monospace;">VGBK0000001</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Support Toll Free:
                                                1800-VGB-BANK</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Online Portal:
                                                www.vertexgalaxybank.com</p>
                                        </div>

                                        <!-- Right: Customer & Loan Details -->
                                        <div>
                                            <span
                                                style="display: block; font-size: 0.75rem; text-transform: uppercase; color: var(--gray-400); font-weight: 700; letter-spacing: 0.5px; margin-bottom: 5px;">Customer
                                                &amp; Loan Details</span>
                                            <strong
                                                style="color: var(--gray-900); font-size: 0.95rem; text-transform: uppercase;">${customer.fullName}</strong>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Customer ID: <strong
                                                    style="font-family: monospace;">#VGB-CUST-${customer.customerId}</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Res. Address:
                                                ${customer.address}, ${customer.city}, ${customer.state} -
                                                ${customer.zipCode}</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Loan Reference: <strong
                                                    style="font-family: monospace;">#LN-${selectedLoan.loanId}</strong>
                                                (${selectedLoan.loanType} Loan)</p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Principal Amount:
                                                <strong>₹
                                                    <fmt:formatNumber value="${selectedLoan.principalAmount}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Interest Rate / Term:
                                                <strong>${selectedLoan.interestRate}% P.A. / ${selectedLoan.termMonths}
                                                    Mos</strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Accumulated Repaid:
                                                <strong style="color: var(--accent-green);">₹
                                                    <fmt:formatNumber value="${totalRepaid}" minFractionDigits="2"
                                                        maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                            <p style="margin: 4px 0 0; color: var(--gray-600);">Outstanding Balance:
                                                <strong style="color: var(--accent-red);">₹
                                                    <fmt:formatNumber value="${selectedLoan.remainingBalance}"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </strong>
                                            </p>
                                        </div>
                                    </div>

                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; margin-top: 35px; margin-bottom: 15px;">
                                        <h4
                                            style="font-size: 1.05rem; font-weight: 700; color: var(--gray-800); display: flex; align-items: center; gap: 8px; margin-bottom: 0;">
                                            <i class="bx bx-history" style="color: var(--primary-500);"></i> Repayment
                                            Ledger Log
                                        </h4>
                                        <button type="button" onclick="printStatement('loanStatement')"
                                            class="btn btn-primary no-print"
                                            style="padding: 8px 18px; font-size: 0.8rem; border-radius: var(--radius-full); display: inline-flex; align-items: center; gap: 6px; background: var(--gradient-primary); border: none; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.25);">
                                            <span>Print Document</span>
                                            <i class="bx bx-printer"></i>
                                        </button>
                                    </div>

                                    <div class="ledger-table-container">
                                        <table class="ledger-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 80px;">Sr. No.</th>
                                                    <th>Payment Date</th>
                                                    <th>Type</th>
                                                    <th>Description</th>
                                                    <th>Status</th>
                                                    <th style="text-align: right;">Credit Amount</th>
                                                    <th style="text-align: right;">Debit Amount</th>
                                                    <th style="text-align: right;">Outstanding Principal</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty repayments || not empty selectedLoan}">
                                                        <c:set var="repaySr" value="0" />
                                                        <c:set var="runningLoanBal"
                                                            value="${selectedLoan.remainingBalance}" />

                                                        <!-- Repayment rows -->
                                                        <c:forEach var="repay" items="${repayments}">
                                                            <c:set var="repaySr" value="${repaySr + 1}" />
                                                            <tr>
                                                                <td style="font-weight: 600; color: var(--gray-500);">
                                                                    <span class="badge-id">#${repaySr}</span>
                                                                </td>
                                                                <td class="txn-date">${repay.repaymentDate}</td>
                                                                <td>
                                                                    <span class="badge-type deposit">Repayment</span>
                                                                </td>
                                                                <td>EMI Repayment (Principal: ₹
                                                                    <fmt:formatNumber
                                                                        value="${repay.principalComponent}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />,
                                                                    Interest: ₹
                                                                    <fmt:formatNumber value="${repay.interestComponent}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />)
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge-status badge-status-completed">COMPLETED</span>
                                                                </td>
                                                                <td style="text-align: right;" class="txn-deposit-val">
                                                                    + ₹
                                                                    <fmt:formatNumber value="${repay.amountPaid}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                                <td style="text-align: right;">-</td>
                                                                <td style="text-align: right;" class="txn-balance-val">
                                                                    ₹
                                                                    <fmt:formatNumber value="${runningLoanBal}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                            </tr>
                                                            <c:set var="runningLoanBal"
                                                                value="${runningLoanBal + repay.principalComponent}" />
                                                        </c:forEach>

                                                        <!-- Initial Disbursal row -->
                                                        <c:if test="${not empty selectedLoan}">
                                                            <c:set var="repaySr" value="${repaySr + 1}" />
                                                            <tr>
                                                                <td style="font-weight: 600; color: var(--gray-500);">
                                                                    <span class="badge-id">#${repaySr}</span>
                                                                </td>
                                                                <td class="txn-date">${selectedLoan.startDate}</td>
                                                                <td>
                                                                    <span class="badge-type withdrawal">Disbursal</span>
                                                                </td>
                                                                <td>Initial ${selectedLoan.loanType} Loan Disbursal</td>
                                                                <td>
                                                                    <span
                                                                        class="badge-status badge-status-completed">COMPLETED</span>
                                                                </td>
                                                                <td style="text-align: right;">-</td>
                                                                <td style="text-align: right;"
                                                                    class="txn-withdrawal-val">
                                                                    - ₹
                                                                    <fmt:formatNumber
                                                                        value="${selectedLoan.principalAmount}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                                <td style="text-align: right;" class="txn-balance-val">
                                                                    ₹
                                                                    <fmt:formatNumber
                                                                        value="${selectedLoan.principalAmount}"
                                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr style="text-align: center;">
                                                            <td colspan="8"
                                                                style="padding: 35px; color: var(--gray-400);">
                                                                No loan statement entries found.</td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Footer Signatures (print only) -->
                                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 50px; page-break-inside: avoid; break-inside: avoid;"
                                        class="print-only">
                                        <div style="text-align: center; width: 200px;">
                                            <div
                                                style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;">
                                            </div>
                                            <span
                                                style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">Authorized
                                                Signatory</span>
                                        </div>
                                        <div style="text-align: center; width: 200px;">
                                            <div
                                                style="border-bottom: 1px solid var(--gray-400); height: 40px; margin-bottom: 5px;">
                                            </div>
                                            <span
                                                style="font-size: 0.75rem; color: var(--gray-500); font-weight: 500;">System
                                                Generated Seals</span>
                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                        <tfoot class="print-layout-tfoot">
                                            <tr class="print-layout-tr">
                                                <td class="print-layout-td">
                                                    <div class="print-footer" style="padding-top: 10px;">
                                                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1.5px solid #cbd5e0; padding-top: 8px; font-family: 'Poppins', sans-serif; width: 100%;">
                                                            <div style="font-size: 8pt; color: #4a5568; font-weight: 500; line-height: 1.4; text-align: left;">
                                                                Vertex Galaxy Bank &bull; Support Toll Free: 1800-VGB-BANK &bull; Online Portal: www.vertexgalaxybank.com
                                                                <br>
                                                                <span style="font-size: 7.5pt; color: #718096;">Corporate HQ: VGB Corporate Towers, BKC Road, Bandra Kurla Complex, Mumbai - 400051</span>
                                                            </div>
                                                            <div class="print-page-number" style="font-size: 8pt; color: #2d3748; font-weight: 700; white-space: nowrap; align-self: flex-start; padding-top: 2px;"></div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </main>

                    <footer class="footer no-print">
                        <div class="container" style="text-align: center; max-width: 1200px; padding: 0;">
                            <p style="font-size: 0.85rem; color: var(--gray-500);">&copy; <span
                                    data-current-year>2026</span> Vertex Galaxy Bank. All rights reserved.</p>
                        </div>
                    </footer>

                    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
                    <script>
                        window.onload = function () {
                            // Populate generated dates dynamically
                            const currentDateStr = new Date().toLocaleDateString('en-IN', {
                                day: '2-digit',
                                month: 'short',
                                year: 'numeric',
                                hour: '2-digit',
                                minute: '2-digit',
                                hour12: true
                            });
                            const rDateSpan = document.getElementById('currentDateRegular');
                            if (rDateSpan) rDateSpan.innerText = currentDateStr;
                            const lDateSpan = document.getElementById('currentDateLoan');
                            if (lDateSpan) lDateSpan.innerText = currentDateStr;
                            document.querySelectorAll('.currentDatePrint').forEach(el => {
                                el.innerText = currentDateStr;
                            });

                            // Format dates inside lists beautifully
                            document.querySelectorAll('.txn-date').forEach(el => {
                                const rawVal = el.innerText.trim();
                                if (rawVal) {
                                    const normalizedStr = rawVal.replace('T', ' ');
                                    const dateObj = new Date(normalizedStr);
                                    if (!isNaN(dateObj.getTime())) {
                                        el.innerText = dateObj.toLocaleDateString('en-IN', {
                                            day: '2-digit',
                                            month: 'short',
                                            year: 'numeric',
                                            hour: '2-digit',
                                            minute: '2-digit',
                                            hour12: true
                                        });
                                    }
                                }
                            });

                            // Initialize active tab from query params
                            const urlParams = new URLSearchParams(window.location.search);
                            const tab = urlParams.get('tab');
                            if (tab === 'loan') {
                                switchStmt('loan');
                            } else {
                                switchStmt('regular');
                            }
                        };

                        function switchStmt(type) {
                            document.getElementById('btnRegular').classList.remove('active');
                            document.getElementById('btnLoan').classList.remove('active');

                            document.getElementById('regularStatement').style.display = 'none';
                            document.getElementById('loanStatement').style.display = 'none';
                            document.getElementById('regularFilters').style.display = 'none';
                            document.getElementById('loanFilters').style.display = 'none';

                            if (type === 'regular') {
                                document.getElementById('btnRegular').classList.add('active');
                                document.getElementById('regularStatement').style.display = 'block';
                                document.getElementById('regularFilters').style.display = 'block';
                            } else {
                                document.getElementById('btnLoan').classList.add('active');
                                document.getElementById('loanStatement').style.display = 'block';
                                document.getElementById('loanFilters').style.display = 'block';
                            }
                        }

                        function switchAccount(accountId) {
                            window.location.href = '${pageContext.request.contextPath}/account?action=statement&accountId=' + accountId + '&tab=regular';
                        }

                        function switchLoan(loanId) {
                            window.location.href = '${pageContext.request.contextPath}/account?action=statement&loanId=' + loanId + '&tab=loan';
                        }

                        function runFilter() {
                            const dateVal = document.getElementById('dateFilter').value;
                            const customGroup = document.getElementById('customDateRangeGroup');
                            if (customGroup) {
                                if (dateVal === 'custom') {
                                    customGroup.style.display = 'block';
                                } else {
                                    customGroup.style.display = 'none';
                                }
                            }

                            const type = document.getElementById('typeFilter').value;
                            const rows = document.querySelectorAll('.txn-row');

                            const now = new Date();
                            const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                            const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
                            const startOfYear = new Date(now.getFullYear(), 0, 1);

                            let customStart = null;
                            let customEnd = null;
                            if (dateVal === 'custom') {
                                const sVal = document.getElementById('startDate').value;
                                const eVal = document.getElementById('endDate').value;
                                if (sVal) {
                                    customStart = new Date(sVal);
                                    customStart.setHours(0, 0, 0, 0);
                                }
                                if (eVal) {
                                    customEnd = new Date(eVal);
                                    customEnd.setHours(23, 59, 59, 999);
                                }
                            }

                            rows.forEach(row => {
                                // Skips empty state row
                                if (row.cells.length < 8) return;
                                const rowType = row.getAttribute('data-type') || '';

                                // Type check
                                const typeMatch = (type === 'all' || rowType === type);

                                // Date check
                                let dateMatch = true;
                                const dateCellText = row.cells[1].innerText.trim();
                                if (dateCellText) {
                                    const normalizedDateStr = dateCellText.replace('T', ' ');
                                    const txnDate = new Date(normalizedDateStr);

                                    if (!isNaN(txnDate.getTime())) {
                                        if (dateVal === 'today') {
                                            dateMatch = (txnDate >= startOfToday);
                                        } else if (dateVal === 'month') {
                                            dateMatch = (txnDate >= startOfMonth);
                                        } else if (dateVal === 'year') {
                                            dateMatch = (txnDate >= startOfYear);
                                        } else if (dateVal === 'custom') {
                                            if (customStart && txnDate < customStart) {
                                                dateMatch = false;
                                            }
                                            if (customEnd && txnDate > customEnd) {
                                                dateMatch = false;
                                            }
                                        }
                                    }
                                }

                                if (typeMatch && dateMatch) {
                                    row.style.display = '';
                                } else {
                                    row.style.display = 'none';
                                }
                            });
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

                        function printStatement(id) {
                            window.print();
                        }


                    </script>
                </body>

                </html>