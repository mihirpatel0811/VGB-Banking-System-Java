<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | Cheque Book Services</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assest/images/logo.png" type="image/png">
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

        .services-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 35px;
        }

        .service-feature-card {
            border-radius: 16px;
            padding: 24px;
            color: white;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 160px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .service-feature-card.primary {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
        }
        .service-feature-card.secondary {
            background: linear-gradient(135deg, #0d9488 0%, #14b8a6 100%);
        }

        .service-feature-card .icon-bg {
            position: absolute;
            right: -20px;
            bottom: -20px;
            font-size: 8rem;
            color: rgba(255, 255, 255, 0.08);
            pointer-events: none;
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
            max-width: 720px;
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

        @media (max-width: 768px) {
            .modal-content {
                max-width: 95% !important;
                max-height: 95vh !important;
            }
            .modal-body {
                padding: 15px !important;
                max-height: calc(95vh - 70px) !important;
            }
            .paper-form {
                padding: 20px 15px !important;
                font-size: 0.85rem !important;
            }
            .paper-form h2 {
                font-size: 1.1rem !important;
            }
            .paper-form h3 {
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

        /* Borderless Paper Form styles */
        .paper-form {
            background: #fff;
            border: 1.5px solid var(--gray-200);
            padding: 35px 30px;
            border-radius: var(--radius-sm);
            color: #1e293b;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 25px;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.02), var(--shadow-sm);
            position: relative;
            overflow: hidden;
        }

        .paper-watermark {
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

        .paper-header {
            text-align: center;
            border-bottom: 2px double #475569;
            padding-bottom: 12px;
            margin-bottom: 20px;
            position: relative;
        }

        .paper-header h2 {
            font-size: 1.35rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #0f172a;
            margin: 0;
            font-family: 'Poppins', sans-serif;
        }

        .paper-header h3 {
            font-size: 1rem;
            font-weight: 700;
            color: #475569;
            margin: 4px 0 0;
            text-transform: uppercase;
            font-family: 'Poppins', sans-serif;
            letter-spacing: 0.5px;
        }

        .fee-badge {
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(99, 102, 241, 0.12);
            color: var(--primary-600);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-family: 'Poppins', sans-serif;
        }

        .paper-table {
            width: 100%;
            border-collapse: collapse;
        }

        .paper-input {
            border: none;
            border-bottom: 1px dotted #475569;
            padding: 2px 5px;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
        }

        .paper-select {
            border: none;
            border-bottom: 1px dotted #475569;
            padding: 2px 5px;
            background: transparent;
            font-weight: 600;
            font-family: inherit;
            font-size: inherit;
            outline: none;
            color: #0f172a;
            cursor: pointer;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }

        .paper-section-title {
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

        .signature-font {
            display: block;
            font-size: 1.4rem;
            font-style: italic;
            color: #3b82f6;
            font-family: 'Brush Script MT', cursive, sans-serif;
            padding-bottom: 5px;
        }

        /* ===== 3D CHEQUE BOOK BOOKLET STYLING ===== */
        .cheque-top-layout {
            display: grid;
            grid-template-columns: 1fr 1.4fr;
            gap: 30px;
            margin-bottom: 35px;
            align-items: stretch;
        }
        @media (max-width: 991px) {
            .cheque-top-layout {
                grid-template-columns: 1fr !important;
            }
        }

        .cheque-visualizer-container {
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(30, 27, 75, 0.02) 0%, rgba(99, 102, 241, 0.05) 100%);
            border: 1px solid rgba(99, 102, 241, 0.12);
            border-radius: var(--radius-lg);
            padding: 45px 20px;
            box-shadow: inset 0 2px 8px rgba(99, 102, 241, 0.02);
            height: 100%;
            perspective: 1200px;
            position: relative;
            overflow: hidden;
            min-height: 340px;
        }

        .chequebook-wrapper {
            width: 420px;
            height: 250px;
            position: relative;
            transform-style: preserve-3d;
            cursor: pointer;
        }
        @media (max-width: 480px) {
            .chequebook-wrapper {
                width: 320px;
                height: 200px;
            }
        }

        .chequebook-book {
            width: 100%;
            height: 100%;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateX(12deg) rotateY(-18deg);
            transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1);
        }

        /* Spine / binding decoration */
        .chequebook-book::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 15px;
            background: linear-gradient(90deg, rgba(0,0,0,0.5) 0%, rgba(255,255,255,0.15) 30%, rgba(0,0,0,0.2) 100%);
            z-index: 50;
            border-radius: 12px 0 0 12px;
            pointer-events: none;
            opacity: 0.8;
        }

        /* 3D cover swing wrapper */
        .chequebook-cover-wrapper {
            position: absolute;
            inset: 0;
            transform-origin: left center;
            transform-style: preserve-3d;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 30;
        }

        /* Book states */
        .chequebook-book.open .chequebook-cover-wrapper {
            transform: rotateY(-155deg);
        }

        .chequebook-book.open {
            transform: rotateX(15deg) rotateY(10deg);
        }

        /* Front side of the cover */
        .chequebook-cover-front {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            background: radial-gradient(circle at 30% 30%, #0c214d 0%, #030815 85%);
            border-radius: 12px;
            box-shadow: 10px 15px 35px rgba(0, 0, 0, 0.4), inset -1px 0 2px rgba(255, 255, 255, 0.1);
            padding: 24px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 2;
        }

        /* Wave lines on cover */
        .chequebook-cover-front::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: 
                radial-gradient(circle at 80% 20%, rgba(99, 102, 241, 0.2) 0%, transparent 60%),
                radial-gradient(circle at 10% 80%, rgba(6, 182, 212, 0.15) 0%, transparent 50%);
            pointer-events: none;
        }

        /* Front cover features list style */
        .cover-features-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
            position: absolute;
            right: 25px;
            top: 45px;
            z-index: 5;
        }
        .cover-feature-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #d4af37;
            font-size: 0.52rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }
        .cover-feature-item i {
            font-size: 0.9rem;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Gold ribbon on front cover */
        .cover-gold-ribbon {
            position: absolute;
            right: 0;
            bottom: 24px;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%);
            color: #0f172a;
            font-size: 0.5rem;
            font-weight: 800;
            padding: 4px 12px 4px 20px;
            border-radius: 4px 0 0 4px;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            z-index: 5;
            text-transform: uppercase;
        }

        /* Inside side of the cover (visible when open) */
        .chequebook-cover-inside {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            transform: rotateY(180deg);
            background: #ffffff;
            border-radius: 12px;
            padding: 20px 24px;
            color: #334155;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-right: 1.5px solid rgba(0, 0, 0, 0.05);
            box-shadow: inset -5px 0 10px rgba(0, 0, 0, 0.05);
            z-index: 1;
            font-family: 'Poppins', sans-serif;
        }

        /* Square digit boxes for inputs */
        .digit-boxes {
            display: inline-flex;
            gap: 2.5px;
            margin-left: 5px;
            vertical-align: middle;
        }
        .digit-boxes span {
            width: 14px;
            height: 16px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.65rem;
            font-weight: 700;
            color: #334155;
            font-family: monospace;
            border-radius: 1px;
        }

        /* Inside Page (bottom page/content page) */
        .chequebook-page {
            position: absolute;
            width: 98%;
            height: 96%;
            top: 2%;
            left: 1%;
            background: #faf8f5;
            border-radius: 4px 10px 10px 4px;
            box-shadow: inset 5px 0 15px rgba(0, 0, 0, 0.15), 5px 10px 20px rgba(0,0,0,0.15);
            padding: 0;
            color: #334155;
            overflow: hidden;
        }

        .chequebook-page.page-instructions {
            transform-origin: left center;
            transition: transform 1.2s cubic-bezier(0.4, 0, 0.2, 1);
            transform-style: preserve-3d;
            z-index: 25;
        }


        /* Inside instructions layout styling */
        .instructions-container {
            display: grid;
            grid-template-columns: 1.10fr 0.90fr;
            gap: 15px;
            padding: 16px 20px;
            height: 100%;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            position: relative;
            z-index: 2;
        }
        .instructions-left, .instructions-right {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
        }
        .instructions-title {
            font-size: 0.7rem;
            font-weight: 800;
            color: #1e3a8a;
            border-bottom: 1.5px solid #cbd5e1;
            padding-bottom: 3px;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .instructions-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .instructions-list li {
            font-size: 0.5rem;
            color: #475569;
            line-height: 1.3;
            display: flex;
            align-items: flex-start;
            gap: 5px;
        }
        .instructions-list li i {
            color: #1e3a8a;
            font-size: 0.65rem;
            margin-top: 1px;
        }
        .instructions-info-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.52rem;
            color: #475569;
        }
        .instructions-info-table td {
            padding: 3px 0;
            border-bottom: 1px dashed rgba(203, 213, 225, 0.5);
        }
        .instructions-info-table tr:last-child td {
            border-bottom: none;
        }
        .instructions-info-table td.label {
            font-weight: 600;
            color: #1e3a8a;
        }

        .instructions-front, .instructions-back {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
        }
        .instructions-front {
            z-index: 2;
            background: #faf8f5;
        }
        .instructions-back {
            transform: rotateY(180deg);
            z-index: 1;
            background: #ffffff;
            border-left: 1.5px solid rgba(0, 0, 0, 0.05);
            box-shadow: inset 5px 0 10px rgba(0, 0, 0, 0.05);
        }

        /* Dynamic classes for turned page */
        .chequebook-page.page-instructions.turned {
            transform: rotateY(-165deg);
            z-index: 28 !important;
            box-shadow: -5px 10px 20px rgba(0,0,0,0.15);
        }

        /* Back Cover */
        .chequebook-back {
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 50% 50%, #0c214d 0%, #030815 85%);
            border-radius: 12px;
            box-shadow: 3px 5px 15px rgba(0,0,0,0.5);
            z-index: 10;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 24px;
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.65rem;
            border-left: 2px solid rgba(255,255,255,0.05);
            overflow: hidden;
        }

        /* Technical Dotted pattern for back cover */
        .chequebook-back::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: radial-gradient(rgba(255, 255, 255, 0.08) 1px, transparent 1px);
            background-size: 12px 12px;
            opacity: 0.7;
            pointer-events: none;
            z-index: 1;
        }

        .chequebook-cover-title h2 {
            font-size: 1.4rem;
            font-weight: 700;
            letter-spacing: 3px;
            margin: 0;
            background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 25%, #b38728 50%, #fbf5b7 75%, #aa771c 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .cheque-leaf-wrapper {
            position: relative;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .cheque-leaf-wrapper.flipped {
            transform: rotateY(180deg);
        }

        .cheque-leaf-front, .cheque-leaf-back-side {
            position: absolute;
            inset: 0;
            backface-visibility: hidden;
            border-radius: 8px;
            background-color: #e0f2fe;
            background-image: 
                radial-gradient(circle at 10% 90%, rgba(99, 102, 241, 0.05) 0%, transparent 60%),
                radial-gradient(circle at 90% 10%, rgba(6, 182, 212, 0.04) 0%, transparent 50%),
                linear-gradient(to right, #bae6fd, #e0f2fe);
            border: 1px solid #93c5fd;
            padding: 12px 15px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            box-sizing: border-box;
        }

        .cheque-leaf-back-side {
            transform: rotateY(180deg);
            background: #f1f5f9;
            border-color: #cbd5e1;
            color: #475569;
            padding: 15px 20px;
        }

        /* Faint grey watermark logo in the center of booklet pages */
        .watermark-bg-svg {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 150px;
            height: 150px;
            opacity: 0.04;
            pointer-events: none;
            z-index: 1;
        }

        .cheque-hologram {
            position: absolute;
            left: 12px;
            top: 0;
            bottom: 0;
            width: 14px;
            background: linear-gradient(90deg, #94a3b8 0%, #cbd5e1 50%, #94a3b8 100%);
            border-left: 1px solid rgba(255,255,255,0.2);
            border-right: 1px solid rgba(255,255,255,0.2);
            opacity: 0.85;
            box-shadow: 0 0 5px rgba(0,0,0,0.05);
            z-index: 2;
        }

        .cheque-hologram::after {
            content: '';
            position: absolute;
            inset: 0;
            background: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(255, 255, 255, 0.15) 5px, rgba(255, 255, 255, 0.15) 10px);
        }

        .cheque-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            z-index: 3;
            margin-left: 14px;
        }

        .cheque-bank-info {
            display: flex;
            flex-direction: column;
        }

        .cheque-bank-name {
            font-family: 'Poppins', sans-serif;
            font-weight: 800;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
            color: #1e3a8a;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .cheque-branch-details {
            font-size: 0.55rem;
            color: #475569;
            line-height: 1.3;
            margin-top: 2px;
        }

        .cheque-date-box {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .date-squares {
            display: flex;
            gap: 1.5px;
            margin-bottom: 2px;
        }

        .date-squares span {
            width: 14px;
            height: 16px;
            border: 1px solid #1e3a8a;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.58rem;
            font-weight: 600;
            color: #1e3a8a;
            border-radius: 1px;
        }

        .date-validity {
            font-size: 0.45rem;
            color: #64748b;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 0.2px;
        }

        .cheque-row {
            display: flex;
            align-items: flex-end;
            margin: 6px 0;
            z-index: 3;
            margin-left: 14px;
        }

        .cheque-label {
            font-weight: bold;
            font-size: 0.72rem;
            color: #1e3a8a;
            white-space: nowrap;
            display: flex;
            align-items: baseline;
            gap: 3px;
        }

        .hindi-text {
            font-size: 0.65rem;
            font-weight: normal;
            color: #64748b;
        }

        .cheque-line-fill {
            flex: 1;
            border-bottom: 1.5px dotted #64748b;
            margin: 0 8px;
            font-family: 'Times New Roman', Times, serif;
            font-size: 0.95rem;
            font-style: italic;
            font-weight: 700;
            color: #0f172a;
            padding-bottom: 1px;
            padding-left: 5px;
            letter-spacing: 0.5px;
        }

        .bearer-text {
            font-size: 0.62rem !important;
        }

        .cheque-amount-box {
            width: 125px;
            height: 28px;
            border: 1.5px solid #1e3a8a;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 0 8px;
            position: relative;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
        }

        .rupee-symbol {
            font-size: 0.95rem;
            font-weight: 800;
            color: #1e3a8a;
            border-right: 1.5px solid #1e3a8a;
            padding-right: 6px;
            height: 100%;
            display: flex;
            align-items: center;
        }

        .amount-val {
            flex: 1;
            font-family: monospace;
            font-size: 0.95rem;
            font-weight: 700;
            text-align: right;
            letter-spacing: 0.5px;
            color: #0f172a;
        }

        .cheque-details-row {
            display: grid;
            grid-template-columns: 1.4fr 0.6fr 1.2fr 1.2fr;
            gap: 12px;
            align-items: flex-end;
            margin-top: 8px;
            z-index: 3;
            margin-left: 14px;
        }
        @media (max-width: 576px) {
            .cheque-details-row {
                grid-template-columns: 1.5fr 1fr;
                gap: 8px;
            }
            .cheque-payable-text {
                display: none;
            }
        }

        .cheque-acc-box {
            border: 1.5px solid #1e3a8a;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 4px 8px;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);
        }

        .acc-label {
            font-size: 0.5rem;
            font-weight: bold;
            color: #1e3a8a;
            border-right: 1px solid #cbd5e1;
            padding-right: 6px;
            margin-right: 6px;
            line-height: 1.2;
            white-space: nowrap;
        }

        .acc-val {
            font-family: monospace;
            font-size: 0.88rem;
            font-weight: 700;
            letter-spacing: 1px;
            color: #0f172a;
        }

        .cheque-branch-codes {
            font-size: 0.5rem;
            color: #475569;
            font-family: monospace;
            line-height: 1.2;
            font-weight: 600;
        }

        .cheque-payable-text {
            font-size: 0.45rem;
            color: #64748b;
            line-height: 1.2;
            border-left: 1px solid #cbd5e1;
            padding-left: 8px;
        }

        .cheque-sign-area {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            text-align: right;
            padding-bottom: 2px;
        }

        .cheque-sign-name {
            font-family: 'Brush Script MT', cursive, sans-serif;
            font-size: 1.2rem;
            font-style: italic;
            color: #2563eb;
            margin-bottom: 2px;
            font-weight: 500;
            letter-spacing: 0.5px;
            max-width: 140px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .cheque-sign-label {
            font-size: 0.48rem;
            color: #475569;
            font-weight: bold;
        }

        .cheque-micr-band {
            text-align: center;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 3px;
            color: #0f172a;
            margin-top: 15px;
            margin-bottom: 2px;
            border-top: 1px dashed rgba(99, 102, 241, 0.1);
            padding-top: 8px;
            z-index: 3;
            margin-left: 14px;
        }

        /* Watermark stamp for processed cheques */
        .cheque-processed-stamp {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-15deg);
            font-size: 3rem;
            font-weight: 900;
            padding: 10px 20px;
            border: 5px solid;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: 4px;
            z-index: 50;
            pointer-events: none;
            display: none;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .cheque-processed-stamp.approved {
            color: #10b981;
            border-color: #10b981;
        }

        .cheque-processed-stamp.rejected {
            color: #ef4444;
            border-color: #ef4444;
        }

        .cheque-processed-stamp.pending {
            color: #fbbf24;
            border-color: #fbbf24;
        }

        /* Interactive hint animation */
        .click-hint {
            position: absolute;
            bottom: 12px;
            right: 15px;
            font-size: 0.65rem;
            color: var(--primary-400);
            display: flex;
            align-items: center;
            gap: 4px;
            font-weight: 500;
            animation: pulseHint 2s infinite;
            pointer-events: none;
            z-index: 60;
        }

        @keyframes pulseHint {
            0%, 100% { opacity: 0.5; transform: translateX(0); }
            50% { opacity: 1; transform: translateX(3px); }
        }
    </style>
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
        <a href="${pageContext.request.contextPath}/customer-dashboard" class="logo" style="display: flex; align-items: center; text-decoration: none;">
            <img src="${pageContext.request.contextPath}/assest/images/logo.png" alt="VGB Logo" style="width: 38px; height: 38px; flex-shrink: 0; object-fit: contain;">
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
            <a href="${pageContext.request.contextPath}/card?action=list"><i class="bx bx-credit-card"></i> My Cards</a>
            <a href="${pageContext.request.contextPath}/chequebook?action=list" class="active"><i class="bx bx-book-bookmark"></i> Cheque Books</a>
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
            <!-- Welcome Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--gray-900);">Cheque Book Services</h2>
                    <p style="color: var(--gray-500); font-size: 0.95rem; margin-top: 5px;">Apply for standard or high-capacity cheque books, track status, and view leaf configurations.</p>
                </div>
                <div>
                    <button onclick="openRequestModal('apply')" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <i class="bx bx-plus-circle"></i> Request Cheque Book
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

            <!-- Split Dashboard: Service Features & Interactive 3D Cheque Visualizer -->
            <div class="cheque-top-layout">
                <!-- Left: Quick Features Summary -->
                <div style="display: flex; flex-direction: column; gap: 20px; height: 100%;">
                    <div class="service-feature-card primary" style="flex: 1; min-height: 140px; padding: 20px;">
                        <div>
                            <span style="font-size: 0.8rem; font-weight: 700; opacity: 0.85; text-transform: uppercase;">Standard Services</span>
                            <h3 style="font-size: 1.3rem; font-weight: 800; margin-top: 5px;">Cheque Books</h3>
                            <p style="font-size: 0.82rem; opacity: 0.9; margin-top: 5px;">Select from 25, 50, or 100 leaf booklets linked securely to your savings or current accounts.</p>
                        </div>
                        <div style="font-size: 0.8rem; font-weight: 700; margin-top: 15px;">
                            <span>Charges: From ₹100.00 only</span>
                        </div>
                        <i class="bx bx-book-open icon-bg" style="font-size: 6rem;"></i>
                    </div>

                    <div class="service-feature-card secondary" style="flex: 1; min-height: 140px; padding: 20px;">
                        <div>
                            <span style="font-size: 0.8rem; font-weight: 700; opacity: 0.85; text-transform: uppercase;">Safety First</span>
                            <h3 style="font-size: 1.3rem; font-weight: 800; margin-top: 5px;">Secured Delivery</h3>
                            <p style="font-size: 0.82rem; opacity: 0.9; margin-top: 5px;">All new cheque books are dispatched via speed post to your registered address with tamper-proof seal packaging.</p>
                        </div>
                        <div style="font-size: 0.8rem; font-weight: 700; margin-top: 15px;">
                            <span>Deliveries fully tracked in dashboard</span>
                        </div>
                        <i class="bx bx-shield-quarter icon-bg" style="font-size: 6rem;"></i>
                    </div>
                </div>

                <!-- Right: Interactive 3D Cheque Visualizer Booklet -->
                <div class="cheque-visualizer-container">
                    <div class="chequebook-wrapper" id="chequebookWrapper" onclick="toggleBookOpen()">
                        <div class="chequebook-book" id="3dChequebook">
                            <!-- 1. Back Cover -->
                            <div class="chequebook-back">
                                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; margin-top: 15px; position: relative; z-index: 2;">
                                    <div style="width: 50px; height: 50px; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));">
                                        <svg viewBox="0 0 100 100" class="v-logo-svg" style="width: 100%; height: 100%;">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGrad)" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGrad)" />
                                        </svg>
                                    </div>
                                    <span style="font-weight: 800; font-size: 0.95rem; letter-spacing: 2px; color: #fff; margin-top: 5px; font-family: 'Poppins', sans-serif;">VERTEX</span>
                                    <span style="font-size: 0.55rem; letter-spacing: 1.5px; color: rgba(255,255,255,0.7); font-weight: bold; font-family: 'Poppins', sans-serif;">GALAXY BANK</span>
                                    <span style="font-size: 0.42rem; letter-spacing: 1px; color: rgba(255,255,255,0.5); font-weight: 500; font-family: 'Poppins', sans-serif; margin-top: 4px; text-transform: uppercase;">Connecting Today, Empowering Tomorrow</span>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between; align-items: flex-end; position: relative; z-index: 2; border-top: 1px solid rgba(255,255,255,0.08); padding-top: 8px;">
                                    <div style="font-family: 'Poppins', sans-serif; font-size: 0.45rem; line-height: 1.3; color: rgba(255,255,255,0.5);">
                                        <strong>Head Office:</strong><br>
                                        Vertex Galaxy Bank,<br>
                                        123, Business Avenue, Financial District,<br>
                                        City - 000001
                                    </div>
                                    <div style="display: flex; gap: 15px; font-family: 'Poppins', sans-serif; font-size: 0.48rem; color: rgba(255,255,255,0.6);">
                                        <span><i class="bx bx-phone" style="vertical-align: middle; color: #d4af37;"></i> 1800 123 4567</span>
                                        <span><i class="bx bx-globe" style="vertical-align: middle; color: #d4af37;"></i> www.vertexgalaxybank.com</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 2. Page 2: Cheque Leaf (Front/Back) -->
                            <div class="chequebook-page page-cheque" style="z-index: 20;">
                                <div class="cheque-leaf-wrapper" id="chequeLeafFlipWrapper">
                                    <!-- Cheque Leaf Front -->
                                    <div class="cheque-leaf-front" onclick="toggleChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                        </svg>
                                        
                                        <!-- Hologram ribbon -->
                                        <div class="cheque-hologram"></div>
                                        
                                        <!-- Header -->
                                        <div class="cheque-header">
                                            <div class="cheque-bank-info">
                                                <span class="cheque-bank-name"><i class="bx bx-shield-quarter"></i> VERTEX GALAXY BANK</span>
                                                <span class="cheque-branch-details">BHAKTINAGAR CIRCLE, BHAKTINAGAR CO-OP HOUSING SOC LTD,<br>80 FT ROAD CORNER, RAJKOT-360002 GUJARAT<br>RTGS / NEFT IFSC : VGB0000171</span>
                                            </div>
                                            <div class="cheque-date-box">
                                                <div style="font-size: 0.45rem; color: #64748b; font-weight: bold; margin-bottom: 2px; text-transform: uppercase;">Valid for three months from the date of issue</div>
                                                <div class="date-squares" id="chequeDateSquares">
                                                    <span>3</span><span>1</span><span>0</span><span>5</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                                </div>
                                            </div>
                                        </div>
 
                                        <!-- Pay row -->
                                        <div class="cheque-row" style="margin-top: 10px;">
                                            <span class="cheque-label">Pay <span class="hindi-text">अदा करें</span></span>
                                            <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.85rem;" id="chequePayeeDisplay">Self or Bearer</span>
                                            <span class="cheque-label bearer-text">Or Bearer <span class="hindi-text">या धारक को</span></span>
                                        </div>
 
                                        <!-- Rupees row -->
                                        <div class="cheque-row">
                                            <span class="cheque-label">Rupees <span class="hindi-text">रुपये</span></span>
                                            <span class="cheque-line-fill" id="chequeRupeesTextDisplay">One Hundred and Fifty Rupees Only</span>
                                            <div class="cheque-amount-box">
                                                <span class="rupee-symbol">₹</span>
                                                <span class="amount-val" id="chequeAmountDisplay">150.00</span>
                                            </div>
                                        </div>
 
                                        <!-- Account details row -->
                                        <div class="cheque-details-row">
                                            <div class="cheque-acc-box">
                                                <span class="acc-label">A/c No.<br><span class="hindi-text">खाता क्र.</span></span>
                                                <span class="acc-val" id="chequeAccountDisplayVal">50100170255263</span>
                                            </div>
                                            <div class="cheque-branch-codes">
                                                Brn: 0171 Pdt: 105<br>SB A/C
                                            </div>
                                            <div class="cheque-payable-text">
                                                Payable at par through clearing/transfer at all branches of VERTEX GALAXY BANK LTD
                                            </div>
                                            <div class="cheque-sign-area">
                                                <span class="cheque-sign-name" id="chequeSignatureVal">${customer.firstName} ${customer.lastName}</span>
                                                <span class="cheque-sign-label">Please sign above / कृपया यहाँ हस्ताक्षर करें</span>
                                            </div>
                                        </div>
 
                                        <!-- Bottom MICR band -->
                                        <div class="cheque-micr-band" id="chequeMicrVal" style="display: flex; align-items: center; justify-content: center; gap: 20px;">
                                            <span>⑈000076⑈</span> <span>360240005⑆</span> <span>018696⑈</span> <span>31</span>
                                        </div>
                                    </div>
                                    
                                    <!-- Cheque Leaf Back -->
                                    <div class="cheque-leaf-back-side" onclick="toggleChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                        </svg>
                                        
                                        <div style="display: flex; gap: 20px; height: 100%; box-sizing: border-box; position: relative; z-index: 2;">
                                            <!-- Signature Box -->
                                            <div style="flex: 1.1; display: flex; flex-direction: column; justify-content: space-between;">
                                                <div style="border: 1px dashed #94a3b8; border-radius: 4px; background: rgba(255,255,255,0.7); height: 75px; display: flex; align-items: center; justify-content: center; font-size: 0.58rem; color: #64748b; font-weight: 600; text-transform: uppercase;">
                                                    Please sign here / कृपया यहाँ हस्ताक्षर करें
                                                </div>
                                                <div style="height: 1.5px; border-bottom: 1px dashed #cbd5e1; width: 100%;"></div>
                                                <div style="font-family: monospace; font-size: 0.72rem; letter-spacing: 2px; color: #334155; font-weight: bold; margin-top: 5px; text-align: center;">
                                                    ⑈123456⑈ 000123456789⑆ 123456⑈ 29
                                                </div>
                                            </div>
                                            <!-- Notes -->
                                            <div style="flex: 0.9; display: flex; flex-direction: column; justify-content: space-between; border-left: 1px dashed #cbd5e1; padding-left: 15px; font-family: 'Poppins', sans-serif;">
                                                <div>
                                                    <h4 style="margin: 0; font-size: 0.58rem; font-weight: bold; color: #1e3a8a; text-transform: uppercase; letter-spacing: 0.5px;">Notes / टिप्पणियां</h4>
                                                    <ul style="margin: 5px 0 0 10px; padding: 0; font-size: 0.45rem; color: #475569; display: flex; flex-direction: column; gap: 3px; list-style-type: disc;">
                                                        <li>This cheque is valid for three months from the date of issue.</li>
                                                        <li>Please ensure sufficient balance in your account.</li>
                                                        <li>Please cross the cheque if not used.</li>
                                                        <li style="font-weight: bold; color: #ef4444;">Do not write below this line.</li>
                                                    </ul>
                                                </div>
                                                <div style="font-size: 0.42rem; color: #94a3b8; font-weight: 500; text-transform: uppercase; text-align: right;">
                                                    * DO NOT WRITE BELOW THIS LINE
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 3. Page 1: Inside Middle Page (Instructions & Information) -->
                            <div class="chequebook-page page-instructions" id="chequeInstructionsPage" onclick="toggleInstructionsPage(event)" style="z-index: 25;">
                                <!-- Front Face: Instructions & Info -->
                                <div class="instructions-front">
                                    <!-- Watermark background SVG -->
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                    </svg>
                                    
                                    <div class="instructions-container">
                                        <!-- Left: Instructions -->
                                        <div class="instructions-left">
                                            <div>
                                                <h4 class="instructions-title"><i class="bx bx-list-check"></i> Instructions</h4>
                                                <ul class="instructions-list">
                                                    <li><i class="bx bx-check-circle"></i> Please write the date clearly.</li>
                                                    <li><i class="bx bx-check-circle"></i> Write the payee's name after 'Pay'.</li>
                                                    <li><i class="bx bx-check-circle"></i> Write the amount in words clearly.</li>
                                                    <li><i class="bx bx-check-circle"></i> Write the amount in figures in the box.</li>
                                                    <li><i class="bx bx-check-circle"></i> Please do not sign on the cheque book.</li>
                                                    <li><i class="bx bx-check-circle"></i> Do not tear any cheque leaf.</li>
                                                    <li><i class="bx bx-check-circle"></i> Please keep your cheque book in a safe place.</li>
                                                </ul>
                                            </div>
                                            <div style="background: rgba(239, 68, 68, 0.05); padding: 5px 8px; border-left: 2.5px solid #ef4444; border-radius: 2px;">
                                                <span style="font-size: 0.48rem; font-weight: bold; color: #ef4444; text-transform: uppercase;">Important</span>
                                                <p style="margin: 2px 0 0; font-size: 0.44rem; color: #ef4444; line-height: 1.2;">Report immediately if your cheque book is lost, stolen or if any cheque leaf is missing.</p>
                                            </div>
                                        </div>
                                        
                                        <!-- Right: General Info -->
                                        <div class="instructions-right">
                                            <div>
                                                <h4 class="instructions-title"><i class="bx bx-info-circle"></i> General Information</h4>
                                                <table class="instructions-info-table">
                                                    <tr>
                                                        <td class="label">Customer Care</td>
                                                        <td style="text-align: right; font-weight: 600;">1800 123 4567</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Email</td>
                                                        <td style="text-align: right;">support@vertexgalaxybank.com</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Website</td>
                                                        <td style="text-align: right;">www.vertexgalaxybank.com</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Cheque Book No.</td>
                                                        <td style="text-align: right; font-weight: 600; font-family: monospace;">VGB-CB-004128</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Issue Date squares -->
                                            <div style="display: flex; flex-direction: column; align-items: flex-end;">
                                                <span style="font-size: 0.45rem; font-weight: 600; color: #1e3a8a; text-transform: uppercase; margin-bottom: 2px;">Issue Date</span>
                                                <div class="digit-boxes" id="instrIssueDate">
                                                    <span>0</span><span>7</span><span>0</span><span>6</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Back Face: Watermark Blank Page -->
                                <div class="instructions-back">
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                    </svg>
                                    <div style="display: flex; align-items: center; justify-content: center; height: 100%; font-size: 0.52rem; color: #94a3b8; font-weight: 500; font-family: 'Poppins', sans-serif; text-transform: uppercase; letter-spacing: 1px;">
                                        SAFE. SECURE. TRUSTED.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 4. Folding Front Cover Wrapper -->
                            <div class="chequebook-cover-wrapper">
                                <!-- Front Cover Outer -->
                                <div class="chequebook-cover-front">
                                    <div class="cover-header" style="display: flex; justify-content: space-between; align-items: center;">
                                        <span class="bank-abbrev" style="font-weight: 800; font-size: 1.2rem; letter-spacing: 1.5px; background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">VGB</span>
                                        <span class="chip-icon" style="font-size: 1.6rem; color: #d4af37; opacity: 0.85;"><i class="bx bx-shield-quarter"></i></span>
                                    </div>
                                    
                                    <!-- Features list from mockup -->
                                    <div class="cover-features-list">
                                        <div class="cover-feature-item">
                                            <i class="bx bx-shield-quarter"></i> Safe Banking
                                        </div>
                                        <div class="cover-feature-item">
                                            <i class="bx bx-lock-alt"></i> Secure Future
                                        </div>
                                        <div class="cover-feature-item">
                                            <i class="bx bx-group"></i> Trusted Partner
                                        </div>
                                    </div>
                                    
                                    <!-- Gold Ribbon from mockup -->
                                    <div class="cover-gold-ribbon">
                                        Your Trust, Our Priority
                                    </div>
                                    
                                    <div class="cover-logo" style="align-self: center; width: 70px; height: 70px; filter: drop-shadow(0 4px 8px rgba(0,0,0,0.4)); margin-top: 10px;">
                                        <svg viewBox="0 0 100 100" class="v-logo-svg" style="width: 100%; height: 100%;">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGrad)" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGrad)" />
                                        </svg>
                                    </div>
                                    <div class="chequebook-cover-title" style="text-align: center;">
                                        <h2>CHEQUE BOOK</h2>
                                        <p style="margin: 4px 0 0; font-size: 0.75rem; letter-spacing: 2px; color: rgba(255, 255, 255, 0.7); font-weight: bold;">VERTEX GALAXY BANK</p>
                                    </div>
                                    <div class="cover-footer" style="display: flex; justify-content: space-between; align-items: center; font-size: 0.58rem; color: rgba(255,255,255,0.5);">
                                        <span>SAFE. SECURE. TRUSTED.</span>
                                        <span>SECURED BOOKLET</span>
                                    </div>
                                </div>
                                
                                <!-- Front Cover Inner (Page 1: Inside Front Page / Belong To Details) -->
                                <div class="chequebook-cover-inside">
                                    <!-- Faint watermark background -->
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                    </svg>
                                    
                                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px double #cbd5e1; padding-bottom: 6px; position: relative; z-index: 2;">
                                        <div style="display: flex; flex-direction: column;">
                                            <span style="font-weight: 800; font-size: 0.8rem; color: #1e3a8a; text-transform: uppercase; letter-spacing: 1px;">VERTEX</span>
                                            <span style="font-size: 0.5rem; color: #475569; font-weight: 600; text-transform: uppercase; margin-top: -2px;">GALAXY BANK</span>
                                        </div>
                                        <span style="font-size: 0.8rem; color: #bf953f;"><i class="bx bx-shield-quarter"></i></span>
                                    </div>
                                    
                                    <div class="cover-inside-body" style="flex: 1; padding: 10px 0; display: flex; flex-direction: column; justify-content: space-between; font-size: 0.75rem; position: relative; z-index: 2;">
                                        <div style="text-align: center; font-weight: bold; margin-bottom: 8px; color: #475569; font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.5px;">This Cheque Book Belongs To:</div>
                                        <table style="width: 100%; border-collapse: collapse; line-height: 1.4;">
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">Name:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; text-transform: uppercase; font-size: 0.68rem;" id="pbCustName">
                                                    ${customer.firstName} ${customer.lastName}
                                                </td>
                                            </tr>
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">Account No:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; font-family: monospace;" id="pbAccNum">
                                                    <c:choose>
                                                        <c:when test="${not empty accounts}">
                                                            ${accounts[0].accountNumber}
                                                        </c:when>
                                                        <c:otherwise>
                                                            SELECT ACCOUNT
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">IFSC Code:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; font-family: monospace;">
                                                    <div class="digit-boxes">
                                                        <span>V</span><span>G</span><span>B</span><span>0</span><span>0</span><span>0</span><span>0</span><span>1</span><span>7</span><span>1</span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">Branch:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; font-size: 0.68rem;">BHAKTINAGAR, RAJKOT</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="cover-inside-footer" style="font-size: 0.52rem; color: #64748b; text-align: center; border-top: 1px solid #e2e8f0; padding-top: 6px; font-weight: bold; position: relative; z-index: 2;">
                                        SAFE. SECURE. TRUSTED.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="click-hint" id="chequeHint" style="position: absolute; bottom: 12px; right: 15px; font-size: 0.65rem; color: var(--primary-500); display: flex; align-items: center; gap: 4px; font-weight: 500; animation: pulseHint 2s infinite; pointer-events: none;"><i class="bx bx-pointer"></i> Click to Open</div>
                </div>
            </div>

            <!-- List of Previous Requests -->
            <div class="glass-card">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="bx bx-list-ul" style="color: var(--primary-500);"></i> Request Status & Log Tracker
                </h3>
                <div style="overflow-x: auto;">
                    <table class="table" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--gray-200); padding-bottom: 10px; color: var(--gray-500); font-weight: 600; font-size: 0.85rem;">
                                <th style="padding: 12px;">Request ID</th>
                                <th style="padding: 12px;">Linked Account</th>
                                <th style="padding: 12px;">Book Capacity</th>
                                <th style="padding: 12px;">Charges Paid</th>
                                <th style="padding: 12px;">Submission Date</th>
                                <th style="padding: 12px;">Current Status</th>
                                <th style="padding: 12px; text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requests}">
                                    <c:forEach var="req" items="${requests}">
                                        <fmt:formatDate value="${req.requestedAt}" pattern="ddMMyyyy" var="formattedDate" />
                                        <tr style="border-bottom: 1px solid var(--gray-100); font-size: 0.9rem; vertical-align: middle;">
                                            <td style="padding: 15px; font-weight: 700; color: var(--gray-700);">#${req.requestId}</td>
                                            <td style="padding: 15px; font-family: monospace; font-weight: 600;">${req.accountNumber}</td>
                                            <td style="padding: 15px;"><strong>${req.leavesCount} Leaves</strong></td>
                                            <td style="padding: 15px;">
                                                <span style="font-weight: 600; color: var(--gray-700);">₹<fmt:formatNumber value="${req.charges}" minFractionDigits="2"/></span>
                                                <c:choose>
                                                    <c:when test="${req.chargesPaid}">
                                                        <span style="background: rgba(16, 185, 129, 0.12); color: #047857; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;"><i class="bx bx-check"></i> Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.12); color: #b91c1c; font-size: 0.7rem; font-weight: 700; padding: 2px 6px; border-radius: var(--radius-sm); margin-left: 5px;"><i class="bx bx-x"></i> Refunded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; color: var(--gray-500);">
                                                <fmt:formatDate value="${req.requestedAt}" pattern="dd-MMM-yyyy hh:mm a" />
                                            </td>
                                            <td style="padding: 15px;">
                                                <c:choose>
                                                    <c:when test="${req.status eq 'approved' or req.status eq 'delivered'}">
                                                        <span style="background: rgba(16, 185, 129, 0.2); color: #10b981; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Approved</span>
                                                    </c:when>
                                                    <c:when test="${req.status eq 'pending'}">
                                                        <span style="background: rgba(245, 158, 11, 0.2); color: #fbbf24; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background: rgba(239, 68, 68, 0.2); color: #ef4444; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); text-transform: uppercase;"><i class="bx bxs-circle" style="font-size: 0.5rem; vertical-align: middle;"></i> Rejected</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 15px; text-align: right;">
                                                <div style="display: flex; gap: 8px; justify-content: flex-end; align-items: center;">
                                                    <button type="button" class="btn" 
                                                            data-id="${req.requestId}" 
                                                            data-name="${req.customerName}" 
                                                            data-account="${req.accountNumber}" 
                                                            data-leaves="${req.leavesCount}" 
                                                            data-charges="${req.charges}" 
                                                            data-date="${formattedDate}" 
                                                            data-status="${req.status}"
                                                            style="padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); background: #6366f1; color: white; border: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"
                                                            onclick="inspectRequest(this)">
                                                        <i class="bx bx-show"></i> View Leaf
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${req.status eq 'approved'}">
                                                            <button onclick="openRequestModal('renew')" class="btn" style="background: var(--gradient-primary); color: white; border: none; padding: 6px 12px; font-size: 0.75rem; border-radius: var(--radius-sm); font-weight: 600;">Renew</button>
                                                        </c:when>
                                                        <c:when test="${req.status eq 'rejected'}">
                                                            <span style="font-size: 0.75rem; color: var(--gray-400); font-style: italic;">Refunded</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 0.75rem; color: var(--gray-400); font-style: italic;">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="padding: 30px; text-align: center; color: var(--gray-400); font-style: italic;">
                                            <i class="bx bx-info-circle" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i> No cheque book requests submitted yet.
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

    <!-- Modal: Premium Borderless Cheque Request / Renewal Form -->
    <div id="requestModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);" id="modalTitle"><i class="bx bx-edit"></i> Cheque Book Application Request</h3>
                <button type="button" onclick="closeRequestModal()" class="close-btn">&times;</button>
            </div>
            <form id="chequeBookForm" action="${pageContext.request.contextPath}/chequebook?action=apply" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <div class="modal-body" style="padding-top: 15px;">
                    
                    <!-- Digital Paper Form -->
                    <div class="paper-form">
                        <!-- Watermark -->
                        <div class="paper-watermark">VGB</div>
                        
                        <!-- Form Header -->
                        <div class="paper-header">
                            <h2>Vertex Galaxy Bank</h2>
                            <h3 id="formSubTitle">Cheque Book Issuance & Renewal Request Form</h3>
                            <span class="fee-badge">
                                Total Fee Due: <strong id="formFeeDisplay" style="font-weight: 800; color: var(--primary-700);">₹ 150.00</strong>
                            </span>
                        </div>
                        
                        <!-- Header Details -->
                        <table class="paper-table" style="margin-bottom: 20px;">
                            <tr>
                                <td style="width: 60%; vertical-align: top; padding: 2px 0;">
                                    <strong>To,</strong><br>
                                    The Branch Manager<br>
                                    <strong>Vertex Galaxy Bank</strong><br>
                                    Branch: <input type="text" name="branch" class="paper-input" style="width: 250px;" value="Main Corporate Branch, Mumbai">
                                </td>
                                <td style="width: 40%; text-align: right; vertical-align: top; padding: 2px 0;">
                                    <strong>Date:</strong> <input type="text" name="formDate" id="formDateStr" class="paper-input" style="width: 120px; text-align: center;" value="">
                                </td>
                            </tr>
                        </table>
                        
                        <div style="margin-bottom: 20px;">
                            <strong>Subject:</strong> <span style="font-weight: 600; border-bottom: 1px solid #475569; padding-bottom: 2px;" id="subjectLine">Request for New Cheque Book Issuance</span>
                        </div>
                        
                        <!-- Customer Information -->
                        <div style="margin-bottom: 20px;">
                            <h4 class="paper-section-title">Customer Information</h4>
                            <table class="paper-table">
                                <tr>
                                    <td style="width: 35%; padding: 5px 0;"><strong>Account Holder Name:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" id="custNameInput" name="customerName" required value="${customer.firstName} ${customer.lastName}" oninput="updateSignature(this.value)" placeholder="ENTER HOLDER NAME" style="width: 100%; border: none; padding: 5px 8px; font-weight: 600; text-transform: uppercase; font-family: monospace; font-size: 1rem; color: #0f172a; outline: none; background: transparent;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Linked Account Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <select id="accountIdSelect" name="accountId" required class="paper-select" style="width: 100%;">
                                            <c:forEach items="${accounts}" var="acc">
                                                <option value="${acc.accountId}">
                                                    ${acc.accountNumber} - ${acc.accountType} (Balance: ₹<fmt:formatNumber value="${acc.balance}" minFractionDigits="2" maxFractionDigits="2"/>)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Customer ID:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="customerIdVal" class="paper-input" style="width: 100%;" value="${customer.customerId}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Mobile Number:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="mobile" class="paper-input" style="width: 100%;" value="${customer.phoneNo}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0;"><strong>Email Address:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="email" class="paper-input" style="width: 100%;" value="${customer.email}">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5px 0; vertical-align: top;"><strong>Address:</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <input type="text" name="address" class="paper-input" style="width: 100%; font-size: 0.85rem;" value="${customer.address}, ${customer.city}, ${customer.state} - ${customer.zipCode}">
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Cheque Book Specifications -->
                        <div style="margin-bottom: 25px;">
                            <h4 class="paper-section-title">Cheque Book Details</h4>
                            <table class="paper-table">
                                <tr>
                                    <td style="width: 35%; padding: 5px 0;"><strong>Book Capacity (Leaves):</strong></td>
                                    <td style="border-bottom: 1px dotted #475569; padding: 0;">
                                        <select id="leavesCountSelect" name="leavesCount" required class="paper-select" style="width: 100%; font-weight: bold;" onchange="updateFeeDue()">
                                            <option value="25">25 Leaves Booklet (₹100.00)</option>
                                            <option value="50" selected>50 Leaves Booklet (₹150.00)</option>
                                            <option value="100">100 Leaves Booklet (₹250.00)</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <!-- Declaration & Terms -->
                        <div style="margin-bottom: 25px; text-align: justify; font-size: 0.85rem; line-height: 1.5; border-top: 1px dashed #cbd5e1; padding-top: 12px;">
                            <p style="margin: 0 0 10px;"><strong>Request Description:</strong> I hereby request the bank to issue a new multi-city Cheque Book linked to my account number mentioned above. I confirm my account contains sufficient funds to cover the applicable service charge.</p>
                            <p style="margin: 0;"><strong>Declaration:</strong> I declare that all signatures are mine and the information provided is correct. The bank holds the right to reject this application if any details are invalid.</p>
                        </div>
                        
                        <!-- Signatures Row -->
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; padding: 0 10px;">
                            <div>
                                <span class="signature-font" id="formSignature">${customer.firstName} ${customer.lastName}</span>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 170px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif;">Customer Signature</span>
                            </div>
                            <div style="text-align: center;">
                                <div style="width: 150px; height: 50px; border: 1px dashed #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: #64748b; font-family: 'Poppins', sans-serif;">BANK USE ONLY</div>
                                <span style="border-top: 1px solid #475569; display: inline-block; width: 150px; text-align: center; font-size: 0.8rem; font-weight: 600; padding-top: 3px; font-family: 'Poppins', sans-serif; margin-top: 5px;">Officer Signature</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Submit -->
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-weight: 600; font-family: 'Poppins', sans-serif; font-size: 1rem; border-radius: var(--radius-md);" id="submitFormBtn">Process Cheque Book Order</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Scripting for Modal Operations -->
    <script>
        function openRequestModal(action) {
            const modal = document.getElementById('requestModal');
            const form = document.getElementById('chequeBookForm');
            const title = document.getElementById('modalTitle');
            const subTitle = document.getElementById('formSubTitle');
            const subject = document.getElementById('subjectLine');
            const submitBtn = document.getElementById('submitFormBtn');
            
            // Set current date in Form
            const today = new Date();
            const dd = String(today.getDate()).padStart(2, '0');
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const yyyy = today.getFullYear();
            document.getElementById('formDateStr').value = dd + ' / ' + mm + ' / ' + yyyy;
            
            if (action === 'renew') {
                form.action = "${pageContext.request.contextPath}/chequebook?action=renew";
                title.innerHTML = '<i class="bx bx-check-shield"></i> Cheque Book Renewal Request';
                subTitle.innerHTML = 'Cheque Book Renewal Request Form';
                subject.innerHTML = 'Request for Cheque Book Renewal / Replacement';
                submitBtn.innerHTML = 'Process Cheque Book Renewal';
            } else {
                form.action = "${pageContext.request.contextPath}/chequebook?action=apply";
                title.innerHTML = '<i class="bx bx-plus-circle"></i> Cheque Book Application Request';
                subTitle.innerHTML = 'Cheque Book Issuance Request Form';
                subject.innerHTML = 'Request for New Cheque Book Issuance';
                submitBtn.innerHTML = 'Process Cheque Book Order';
            }
            
            updateFeeDue();
            modal.style.display = 'flex';
        }

        function closeRequestModal() {
            document.getElementById('requestModal').style.display = 'none';
        }

        function updateSignature(name) {
            document.getElementById('formSignature').innerHTML = name ? name.toUpperCase() : '';
            const sig3D = document.getElementById('chequeSignatureVal');
            if (sig3D) {
                sig3D.innerHTML = name ? name.toUpperCase() : '';
            }
        }

        function updateFeeDue() {
            const leavesSelect = document.getElementById('leavesCountSelect');
            const leaves = parseInt(leavesSelect.value);
            let charges = 150;
            let words = "One Hundred and Fifty Rupees Only";
            
            if (leaves === 25) {
                charges = 100;
                words = "One Hundred Rupees Only";
            } else if (leaves === 50) {
                charges = 150;
                words = "One Hundred and Fifty Rupees Only";
            } else if (leaves === 100) {
                charges = 250;
                words = "Two Hundred and Fifty Rupees Only";
            }
            
            document.getElementById('formFeeDisplay').innerHTML = '₹ ' + charges.toFixed(2);
            
            const amtDisplay = document.getElementById('chequeAmountDisplay');
            const rupeesDisplay = document.getElementById('chequeRupeesTextDisplay');
            if (amtDisplay) amtDisplay.innerHTML = charges.toFixed(2);
            if (rupeesDisplay) rupeesDisplay.innerHTML = words;
        }

        function syncChequeVisualizer() {
            const accSelect = document.getElementById('accountIdSelect');
            const accDisplay = document.getElementById('chequeAccountDisplayVal');
            if (accSelect && accDisplay && accSelect.options.length > 0) {
                const text = accSelect.options[accSelect.selectedIndex].text;
                const num = text.split(" - ")[0].trim();
                accDisplay.innerHTML = num;

                const micrDisplay = document.getElementById('chequeMicrVal');
                if (micrDisplay) {
                    const last6 = num.length >= 6 ? num.substring(num.length - 6) : "018696";
                    micrDisplay.innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;
                }
            }

            const nameInput = document.getElementById('custNameInput');
            const sigDisplay = document.getElementById('chequeSignatureVal');
            if (nameInput && sigDisplay) {
                sigDisplay.innerHTML = nameInput.value ? nameInput.value.toUpperCase() : '';
            }

            const squares = document.getElementById('chequeDateSquares');
            if (squares) {
                const today = new Date();
                const dd = String(today.getDate()).padStart(2, '0');
                const mm = String(today.getMonth() + 1).padStart(2, '0');
                const yyyy = String(today.getFullYear());
                const dateStr = dd + mm + yyyy;
                let dateHtml = "";
                for (let i = 0; i < dateStr.length; i++) {
                    dateHtml += `<span>${dateStr.charAt(i)}</span>`;
                }
                squares.innerHTML = dateHtml;
            }

            updateFeeDue();
        }

        document.addEventListener('DOMContentLoaded', () => {
            const accSelect = document.getElementById('accountIdSelect');
            const leavesSelect = document.getElementById('leavesCountSelect');
            const nameInput = document.getElementById('custNameInput');

            if (accSelect) accSelect.addEventListener('change', syncChequeVisualizer);
            if (leavesSelect) leavesSelect.addEventListener('change', syncChequeVisualizer);
            if (nameInput) nameInput.addEventListener('input', (e) => {
                updateSignature(e.target.value);
            });

            syncChequeVisualizer();

            const chequeWrapper = document.querySelector('.chequebook-wrapper');
            if (chequeWrapper) {
                const book = document.getElementById('3dChequebook');
                chequeWrapper.addEventListener('mousemove', (e) => {
                    if (book && book.classList.contains('open')) return;
                    
                    const rect = chequeWrapper.getBoundingClientRect();
                    const x = e.clientX - rect.left - rect.width / 2;
                    const y = e.clientY - rect.top - rect.height / 2;
                    const rX = -(y / rect.height) * 15;
                    const rY = (x / rect.width) * 15;
                    
                    requestAnimationFrame(() => {
                        book.style.transform = `rotateX(${12 + rX}deg) rotateY(${-18 + rY}deg) scale(1.025)`;
                    });
                });
                
                chequeWrapper.addEventListener('mouseleave', () => {
                    requestAnimationFrame(() => {
                        book.style.transform = 'rotateX(12deg) rotateY(-18deg) scale(1)';
                    });
                });
            }
        });

        window.onclick = function(event) {
            const requestModal = document.getElementById('requestModal');
            const inspectModal = document.getElementById('inspectModal');
            if (event.target === requestModal) {
                closeRequestModal();
            }
            if (event.target === inspectModal) {
                closeInspectModal();
            }
        }
    </script>

    <!-- Modal: Premium 3D Cheque Inspector -->
    <div id="inspectModal" class="modal">
        <div class="modal-content" style="max-width: 680px;">
            <div class="modal-header">
                <h3 style="font-size: 1.2rem; font-weight: 700; color: var(--gray-800);"><i class="bx bx-show"></i> Cheque Leaf Inspector</h3>
                <button type="button" onclick="closeInspectModal()" class="close-btn">&times;</button>
            </div>
            <div class="modal-body" style="padding-top: 20px;">
                
                <!-- Cheque Info Card Grid -->
                <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 0.85rem; color: var(--gray-600); padding: 0 10px;">
                    <div><strong>Request ID:</strong> <span id="inspectRequestId" style="font-weight: 700; color: var(--gray-900);">#--</span></div>
                    <div><strong>Capacity:</strong> <span id="inspectCapacity" style="font-weight: 700; color: var(--gray-900);">--</span></div>
                    <div><strong>Charges:</strong> <span id="inspectCharges" style="font-weight: 700; color: var(--gray-900);">--</span></div>
                </div>

                <!-- 3D Cheque Visualizer -->
                <div class="cheque-visualizer-container" style="margin-bottom: 20px;">
                    <div class="chequebook-wrapper" id="inspectChequebookWrapper" onclick="toggleInspectBookOpen()">
                        <div class="chequebook-book" id="inspect3dChequebook">
                            <!-- 1. Back Cover -->
                            <div class="chequebook-back">
                                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; margin-top: 15px; position: relative; z-index: 2;">
                                    <div style="width: 50px; height: 50px; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));">
                                        <svg viewBox="0 0 100 100" class="v-logo-svg" style="width: 100%; height: 100%;">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGrad)" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGrad)" />
                                        </svg>
                                    </div>
                                    <span style="font-weight: 800; font-size: 0.95rem; letter-spacing: 2px; color: #fff; margin-top: 5px; font-family: 'Poppins', sans-serif;">VERTEX</span>
                                    <span style="font-size: 0.55rem; letter-spacing: 1.5px; color: rgba(255,255,255,0.7); font-weight: bold; font-family: 'Poppins', sans-serif;">GALAXY BANK</span>
                                    <span style="font-size: 0.42rem; letter-spacing: 1px; color: rgba(255,255,255,0.5); font-weight: 500; font-family: 'Poppins', sans-serif; margin-top: 4px; text-transform: uppercase;">Connecting Today, Empowering Tomorrow</span>
                                </div>
                                
                                <div style="display: flex; justify-content: space-between; align-items: flex-end; position: relative; z-index: 2; border-top: 1px solid rgba(255,255,255,0.08); padding-top: 8px;">
                                    <div style="font-family: 'Poppins', sans-serif; font-size: 0.45rem; line-height: 1.3; color: rgba(255,255,255,0.5);">
                                        <strong>Head Office:</strong><br>
                                        Vertex Galaxy Bank,<br>
                                        123, Business Avenue, Financial District,<br>
                                        City - 000001
                                    </div>
                                    <div style="display: flex; gap: 15px; font-family: 'Poppins', sans-serif; font-size: 0.48rem; color: rgba(255,255,255,0.6);">
                                        <span><i class="bx bx-phone" style="vertical-align: middle; color: #d4af37;"></i> 1800 123 4567</span>
                                        <span><i class="bx bx-globe" style="vertical-align: middle; color: #d4af37;"></i> www.vertexgalaxybank.com</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 2. Page 2: Cheque Leaf (Front/Back) -->
                            <div class="chequebook-page page-cheque" style="z-index: 20;">
                                <div class="cheque-leaf-wrapper" id="inspectChequeLeafFlipWrapper">
                                    <!-- Cheque Leaf Front -->
                                    <div class="cheque-leaf-front" onclick="toggleInspectChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                        </svg>
                                        
                                        <!-- Hologram ribbon -->
                                        <div class="cheque-hologram"></div>
                                        
                                        <!-- Header -->
                                        <div class="cheque-header">
                                            <div class="cheque-bank-info">
                                                <span class="cheque-bank-name"><i class="bx bx-shield-quarter"></i> VERTEX GALAXY BANK</span>
                                                <span class="cheque-branch-details">BHAKTINAGAR CIRCLE, BHAKTINAGAR CO-OP HOUSING SOC LTD,<br>80 FT ROAD CORNER, RAJKOT-360002 GUJARAT<br>RTGS / NEFT IFSC : VGB0000171</span>
                                            </div>
                                            <div class="cheque-date-box">
                                                <div style="font-size: 0.45rem; color: #64748b; font-weight: bold; margin-bottom: 2px; text-transform: uppercase;">Valid for three months from the date of issue</div>
                                                <div class="date-squares" id="inspectChequeDateSquares">
                                                    <!-- Populated by JS -->
                                                </div>
                                            </div>
                                        </div>
 
                                        <!-- Pay row -->
                                        <div class="cheque-row" style="margin-top: 10px;">
                                            <span class="cheque-label">Pay <span class="hindi-text">अदा करें</span></span>
                                            <span class="cheque-line-fill" style="text-transform: uppercase; font-family: monospace; font-size: 0.85rem;" id="inspectChequePayeeDisplay">Self or Bearer</span>
                                            <span class="cheque-label bearer-text">Or Bearer <span class="hindi-text">या धारक को</span></span>
                                        </div>
 
                                        <!-- Rupees row -->
                                        <div class="cheque-row">
                                            <span class="cheque-label">Rupees <span class="hindi-text">रुपये</span></span>
                                            <span class="cheque-line-fill" id="inspectChequeRupeesTextDisplay">--</span>
                                            <div class="cheque-amount-box">
                                                <span class="rupee-symbol">₹</span>
                                                <span class="amount-val" id="inspectChequeAmountDisplay">--</span>
                                            </div>
                                        </div>
 
                                        <!-- Account details row -->
                                        <div class="cheque-details-row">
                                            <div class="cheque-acc-box">
                                                <span class="acc-label">A/c No.<br><span class="hindi-text">खाता क्र.</span></span>
                                                <span class="acc-val" id="inspectChequeAccountDisplayVal">--</span>
                                            </div>
                                            <div class="cheque-branch-codes">
                                                Brn: 0171 Pdt: 105<br>SB A/C
                                            </div>
                                            <div class="cheque-payable-text">
                                                Payable at par through clearing/transfer at all branches of VERTEX GALAXY BANK LTD
                                            </div>
                                            <div class="cheque-sign-area">
                                                <span class="cheque-sign-name" id="inspectChequeSignatureVal">--</span>
                                                <span class="cheque-sign-label">Please sign above / कृपया यहाँ हस्ताक्षर करें</span>
                                            </div>
                                        </div>
 
                                        <!-- Bottom MICR band -->
                                        <div class="cheque-micr-band" id="inspectChequeMicrVal">
                                            <!-- Populated by JS -->
                                        </div>
                                    </div>
                                    
                                    <!-- Cheque Leaf Back -->
                                    <div class="cheque-leaf-back-side" onclick="toggleInspectChequeLeafFlip(event)">
                                        <!-- Watermark background SVG -->
                                        <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                        </svg>
                                        
                                        <div style="display: flex; gap: 20px; height: 100%; box-sizing: border-box; position: relative; z-index: 2;">
                                            <!-- Signature Box -->
                                            <div style="flex: 1.1; display: flex; flex-direction: column; justify-content: space-between;">
                                                <div style="border: 1px dashed #94a3b8; border-radius: 4px; background: rgba(255,255,255,0.7); height: 75px; display: flex; align-items: center; justify-content: center; font-size: 0.58rem; color: #64748b; font-weight: 600; text-transform: uppercase;">
                                                    Please sign here / कृपया यहाँ हस्ताक्षर करें
                                                </div>
                                                <div style="height: 1.5px; border-bottom: 1px dashed #cbd5e1; width: 100%;"></div>
                                                <div style="font-family: monospace; font-size: 0.72rem; letter-spacing: 2px; color: #334155; font-weight: bold; margin-top: 5px; text-align: center;">
                                                    ⑈123456⑈ 000123456789⑆ 123456⑈ 29
                                                </div>
                                            </div>
                                            <!-- Notes -->
                                            <div style="flex: 0.9; display: flex; flex-direction: column; justify-content: space-between; border-left: 1px dashed #cbd5e1; padding-left: 15px; font-family: 'Poppins', sans-serif;">
                                                <div>
                                                    <h4 style="margin: 0; font-size: 0.58rem; font-weight: bold; color: #1e3a8a; text-transform: uppercase; letter-spacing: 0.5px;">Notes / टिप्पणियां</h4>
                                                    <ul style="margin: 5px 0 0 10px; padding: 0; font-size: 0.45rem; color: #475569; display: flex; flex-direction: column; gap: 3px; list-style-type: disc;">
                                                        <li>This cheque is valid for three months from the date of issue.</li>
                                                        <li>Please ensure sufficient balance in your account.</li>
                                                        <li>Please cross the cheque if not used.</li>
                                                        <li style="font-weight: bold; color: #ef4444;">Do not write below this line.</li>
                                                    </ul>
                                                </div>
                                                <div style="font-size: 0.42rem; color: #94a3b8; font-weight: 500; text-transform: uppercase; text-align: right;">
                                                    * DO NOT WRITE BELOW THIS LINE
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 3. Page 1: Inside Middle Page (Instructions & Information) -->
                            <div class="chequebook-page page-instructions" id="inspectChequeInstructionsPage" onclick="toggleInspectInstructionsPage(event)" style="z-index: 25;">
                                <div class="instructions-front">
                                    <!-- Watermark background SVG -->
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                    </svg>
                                    
                                    <div class="instructions-container">
                                        <!-- Left: Instructions -->
                                        <div class="instructions-left">
                                            <div>
                                                <h4 class="instructions-title"><i class="bx bx-list-check"></i> Instructions</h4>
                                                <ul class="instructions-list">
                                                    <li><i class="bx bx-check-circle"></i> Please write the date clearly.</li>
                                                    <li><i class="bx bx-check-circle"></i> Write the payee's name after 'Pay'.</li>
                                                    <li><i class="bx bx-check-circle"></i> Write the amount in words clearly.</li>
                                                    <li><i class="bx bx-check-circle"></i> Write the amount in figures in the box.</li>
                                                    <li><i class="bx bx-check-circle"></i> Please do not sign on the cheque book.</li>
                                                    <li><i class="bx bx-check-circle"></i> Do not tear any cheque leaf.</li>
                                                    <li><i class="bx bx-check-circle"></i> Please keep your cheque book in a safe place.</li>
                                                </ul>
                                            </div>
                                            <div style="background: rgba(239, 68, 68, 0.05); padding: 5px 8px; border-left: 2.5px solid #ef4444; border-radius: 2px;">
                                                <span style="font-size: 0.48rem; font-weight: bold; color: #ef4444; text-transform: uppercase;">Important</span>
                                                <p style="margin: 2px 0 0; font-size: 0.44rem; color: #ef4444; line-height: 1.2;">Report immediately if your cheque book is lost, stolen or if any cheque leaf is missing.</p>
                                            </div>
                                        </div>
                                        
                                        <!-- Right: General Info -->
                                        <div class="instructions-right">
                                            <div>
                                                <h4 class="instructions-title"><i class="bx bx-info-circle"></i> General Information</h4>
                                                <table class="instructions-info-table">
                                                    <tr>
                                                        <td class="label">Customer Care</td>
                                                        <td style="text-align: right; font-weight: 600;">1800 123 4567</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Email</td>
                                                        <td style="text-align: right;">support@vertexgalaxybank.com</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Website</td>
                                                        <td style="text-align: right;">www.vertexgalaxybank.com</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="label">Cheque Book No.</td>
                                                        <td style="text-align: right; font-weight: 600; font-family: monospace;">VGB-CB-004128</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Issue Date squares -->
                                            <div style="display: flex; flex-direction: column; align-items: flex-end;">
                                                <span style="font-size: 0.45rem; font-weight: 600; color: #1e3a8a; text-transform: uppercase; margin-bottom: 2px;">Issue Date</span>
                                                <div class="digit-boxes" id="inspectInstrIssueDate">
                                                    <span>0</span><span>7</span><span>0</span><span>6</span><span>2</span><span>0</span><span>2</span><span>6</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Back Face: Watermark Blank Page -->
                                <div class="instructions-back">
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                    </svg>
                                    <div style="display: flex; align-items: center; justify-content: center; height: 100%; font-size: 0.52rem; color: #94a3b8; font-weight: 500; font-family: 'Poppins', sans-serif; text-transform: uppercase; letter-spacing: 1px;">
                                        SAFE. SECURE. TRUSTED.
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 4. Folding Front Cover Wrapper -->
                            <div class="chequebook-cover-wrapper">
                                <!-- Front Cover Outer -->
                                <div class="chequebook-cover-front">
                                    <div class="cover-header" style="display: flex; justify-content: space-between; align-items: center;">
                                        <span class="bank-abbrev" style="font-weight: 800; font-size: 1.2rem; letter-spacing: 1.5px; background: linear-gradient(135deg, #bf953f 0%, #fcf6ba 50%, #b38728 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">VGB</span>
                                        <span class="chip-icon" style="font-size: 1.6rem; color: #d4af37; opacity: 0.85;"><i class="bx bx-shield-quarter"></i></span>
                                    </div>
                                    
                                    <div class="cover-features-list">
                                        <div class="cover-feature-item">
                                            <i class="bx bx-shield-quarter"></i> Safe Banking
                                        </div>
                                        <div class="cover-feature-item">
                                            <i class="bx bx-lock-alt"></i> Secure Future
                                        </div>
                                        <div class="cover-feature-item">
                                            <i class="bx bx-group"></i> Trusted Partner
                                        </div>
                                    </div>
                                    
                                    <div class="cover-gold-ribbon">
                                        Your Trust, Our Priority
                                    </div>
                                    
                                    <div class="cover-logo" style="align-self: center; width: 70px; height: 70px; filter: drop-shadow(0 4px 8px rgba(0,0,0,0.4)); margin-top: 10px;">
                                        <svg viewBox="0 0 100 100" class="v-logo-svg" style="width: 100%; height: 100%;">
                                            <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="url(#goldGrad)" />
                                            <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="url(#goldGrad)" />
                                        </svg>
                                    </div>
                                    <div class="chequebook-cover-title" style="text-align: center;">
                                        <h2>CHEQUE BOOK</h2>
                                        <p style="margin: 4px 0 0; font-size: 0.75rem; letter-spacing: 2px; color: rgba(255, 255, 255, 0.7); font-weight: bold;">VERTEX GALAXY BANK</p>
                                    </div>
                                    <div class="cover-footer" style="display: flex; justify-content: space-between; align-items: center; font-size: 0.58rem; color: rgba(255,255,255,0.5);">
                                        <span>SAFE. SECURE. TRUSTED.</span>
                                        <span>SECURED BOOKLET</span>
                                    </div>
                                </div>
                                
                                <!-- Front Cover Inner -->
                                <div class="chequebook-cover-inside">
                                    <svg viewBox="0 0 100 100" class="watermark-bg-svg">
                                        <path d="M15 15 L45 85 L55 85 L85 15 L70 15 L50 62 L30 15 Z" fill="#475569" />
                                        <path d="M50 25 L53 32 L60 32 L55 36 L57 43 L50 39 L43 43 L45 36 L40 32 L47 32 Z" fill="#475569" />
                                    </svg>
                                    
                                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px double #cbd5e1; padding-bottom: 6px; position: relative; z-index: 2;">
                                        <div style="display: flex; flex-direction: column;">
                                            <span style="font-weight: 800; font-size: 0.8rem; color: #1e3a8a; text-transform: uppercase; letter-spacing: 1px;">VERTEX</span>
                                            <span style="font-size: 0.5rem; color: #475569; font-weight: 600; text-transform: uppercase; margin-top: -2px;">GALAXY BANK</span>
                                        </div>
                                        <span style="font-size: 0.8rem; color: #bf953f;"><i class="bx bx-shield-quarter"></i></span>
                                    </div>
                                    
                                    <div class="cover-inside-body" style="flex: 1; padding: 10px 0; display: flex; flex-direction: column; justify-content: space-between; font-size: 0.75rem; position: relative; z-index: 2;">
                                        <div style="text-align: center; font-weight: bold; margin-bottom: 8px; color: #475569; font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.5px;">This Cheque Book Belongs To:</div>
                                        <table style="width: 100%; border-collapse: collapse; line-height: 1.4;">
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">Name:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; text-transform: uppercase; font-size: 0.68rem;" id="inspectpbCustName">
                                                    --
                                                </td>
                                            </tr>
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">Account No:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; font-family: monospace;" id="inspectpbAccNum">
                                                    --
                                                </td>
                                            </tr>
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">IFSC Code:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; font-family: monospace;">
                                                    <div class="digit-boxes">
                                                        <span>V</span><span>G</span><span>B</span><span>0</span><span>0</span><span>0</span><span>0</span><span>1</span><span>7</span><span>1</span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="border-bottom: 1px dashed #cbd5e1;">
                                                <td style="color: #64748b; padding: 3px 0; font-size: 0.65rem;">Branch:</td>
                                                <td style="font-weight: 700; color: #0f172a; padding: 3px 0; font-size: 0.68rem;">BHAKTINAGAR, RAJKOT</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="cover-inside-footer" style="font-size: 0.52rem; color: #64748b; text-align: center; border-top: 1px solid #e2e8f0; padding-top: 6px; font-weight: bold; position: relative; z-index: 2;">
                                        SAFE. SECURE. TRUSTED.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="click-hint" id="inspectChequeHint" style="position: absolute; bottom: 12px; right: 15px; font-size: 0.65rem; color: var(--primary-500); display: flex; align-items: center; gap: 4px; font-weight: 500; animation: pulseHint 2s infinite; pointer-events: none;"><i class="bx bx-pointer"></i> Click to Open</div>
                    <!-- Diagonal Stamp overlay -->
                    <div class="cheque-processed-stamp" id="stampOverlay">APPROVED</div>
                </div>

                <div style="text-align: center; margin-top: 15px;">
                    <button type="button" class="btn btn-secondary" onclick="closeInspectModal()" style="padding: 10px 25px; font-size: 0.9rem; font-weight: 600;">Close View</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripting for Inspector Operations -->
    <script>
        function openInspectModal(requestId, customerName, accountNumber, leavesCount, charges, requestedDateStr, status) {
            const modal = document.getElementById('inspectModal');
            
            // Set dynamic fields
            document.getElementById('inspectRequestId').innerHTML = '#' + requestId;
            document.getElementById('inspectCapacity').innerHTML = leavesCount + ' Leaves';
            document.getElementById('inspectCharges').innerHTML = '₹ ' + charges.toFixed(2);
            
            // Sync Cheque visualizer
            document.getElementById('inspectChequePayeeDisplay').innerHTML = 'Self or Bearer';
            
            let words = "One Hundred and Fifty Rupees Only";
            if (leavesCount === 25) {
                words = "One Hundred Rupees Only";
            } else if (leavesCount === 50) {
                words = "One Hundred and Fifty Rupees Only";
            } else if (leavesCount === 100) {
                words = "Two Hundred and Fifty Rupees Only";
            }
            
            document.getElementById('inspectChequeRupeesTextDisplay').innerHTML = words;
            document.getElementById('inspectChequeAmountDisplay').innerHTML = charges.toFixed(2);
            document.getElementById('inspectChequeAccountDisplayVal').innerHTML = accountNumber;
            document.getElementById('inspectChequeSignatureVal').innerHTML = customerName ? customerName.toUpperCase() : '';
            document.getElementById('inspectChequeSignatureBackVal').innerHTML = customerName ? customerName.toUpperCase() : '';
            document.getElementById('inspectpbCustName').innerHTML = customerName ? customerName.toUpperCase() : '';
            document.getElementById('inspectpbAccNum').innerHTML = accountNumber;
            
            // MICR Band parsing
            const last6 = accountNumber.length >= 6 ? accountNumber.substring(accountNumber.length - 6) : "018696";
            document.getElementById('inspectChequeMicrVal').innerHTML = `⑈000076⑈ 360240005⑆ ${last6}⑈ 31`;
            
            // Date Squares parsing (Format expected: ddMMyyyy)
            const squares = document.getElementById('inspectChequeDateSquares');
            if (squares) {
                let dateStr = requestedDateStr;
                if (!dateStr || dateStr.length !== 8) {
                    // Fallback to today
                    const today = new Date();
                    const dd = String(today.getDate()).padStart(2, '0');
                    const mm = String(today.getMonth() + 1).padStart(2, '0');
                    const yyyy = String(today.getFullYear());
                    dateStr = dd + mm + yyyy;
                }
                let dateHtml = "";
                for (let i = 0; i < dateStr.length; i++) {
                    dateHtml += `<span>${dateStr.charAt(i)}</span>`;
                }
                squares.innerHTML = dateHtml;
            }

            // Handle stamp overlay
            const stampOverlay = document.getElementById('stampOverlay');
            if (status === 'approved' || status === 'delivered') {
                stampOverlay.innerHTML = 'APPROVED';
                stampOverlay.className = 'cheque-processed-stamp approved';
                stampOverlay.style.display = 'block';
            } else if (status === 'rejected') {
                stampOverlay.innerHTML = 'REJECTED';
                stampOverlay.className = 'cheque-processed-stamp rejected';
                stampOverlay.style.display = 'block';
            } else {
                stampOverlay.innerHTML = 'PENDING';
                stampOverlay.className = 'cheque-processed-stamp pending';
                stampOverlay.style.display = 'block';
            }
            
            // Reset inspector book to closed and unflipped when opening modal
            const inspectBook = document.getElementById('inspect3dChequebook');
            if (inspectBook) {
                inspectBook.classList.remove('open');
            }
            const inspectLeaf = document.getElementById('inspectChequeLeafFlipWrapper');
            if (inspectLeaf) {
                inspectLeaf.classList.remove('flipped');
            }
            const inspectHint = document.getElementById('inspectChequeHint');
            if (inspectHint) {
                inspectHint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
            }
            
            modal.style.display = 'flex';
        }

        function closeInspectModal() {
            document.getElementById('inspectModal').style.display = 'none';
        }

        function inspectRequest(btn) {
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            const account = btn.getAttribute('data-account');
            const leaves = parseInt(btn.getAttribute('data-leaves'));
            const charges = parseFloat(btn.getAttribute('data-charges'));
            const date = btn.getAttribute('data-date');
            const status = btn.getAttribute('data-status');
            openInspectModal(id, name, account, leaves, charges, date, status);
        }

        function toggleBookOpen() {
            const book = document.getElementById('3dChequebook');
            const hint = document.getElementById('chequeHint');
            if (book) {
                book.classList.toggle('open');
                if (book.classList.contains('open')) {
                    if (hint) hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                } else {
                    if (hint) hint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
                    const leaf = document.getElementById('chequeLeafFlipWrapper');
                    if (leaf) leaf.classList.remove('flipped');
                    const page = document.getElementById('chequeInstructionsPage');
                    if (page) page.classList.remove('turned');
                }
            }
        }
        
        function toggleInstructionsPage(event) {
            if (event) event.stopPropagation();
            const page = document.getElementById('chequeInstructionsPage');
            const hint = document.getElementById('chequeHint');
            if (page) {
                page.classList.toggle('turned');
                if (hint) {
                    if (page.classList.contains('turned')) {
                        hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Leaf to Flip`;
                    } else {
                        hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                    }
                }
            }
        }
        
        function toggleChequeLeafFlip(event) {
            if (event) event.stopPropagation();
            const leaf = document.getElementById('chequeLeafFlipWrapper');
            if (leaf) {
                leaf.classList.toggle('flipped');
            }
        }
        
        function toggleInspectBookOpen() {
            const book = document.getElementById('inspect3dChequebook');
            const hint = document.getElementById('inspectChequeHint');
            if (book) {
                book.classList.toggle('open');
                if (book.classList.contains('open')) {
                    if (hint) hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                } else {
                    if (hint) hint.innerHTML = `<i class="bx bx-pointer"></i> Click to Open`;
                    const leaf = document.getElementById('inspectChequeLeafFlipWrapper');
                    if (leaf) leaf.classList.remove('flipped');
                    const page = document.getElementById('inspectChequeInstructionsPage');
                    if (page) page.classList.remove('turned');
                }
            }
        }
        
        function toggleInspectInstructionsPage(event) {
            if (event) event.stopPropagation();
            const page = document.getElementById('inspectChequeInstructionsPage');
            const hint = document.getElementById('inspectChequeHint');
            if (page) {
                page.classList.toggle('turned');
                if (hint) {
                    if (page.classList.contains('turned')) {
                        hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Leaf to Flip`;
                    } else {
                        hint.innerHTML = `<i class="bx bx-rotate-right"></i> Click Page to Turn`;
                    }
                }
            }
        }
        
        function toggleInspectChequeLeafFlip(event) {
            if (event) event.stopPropagation();
            const leaf = document.getElementById('inspectChequeLeafFlipWrapper');
            if (leaf) {
                leaf.classList.toggle('flipped');
            }
        }
        
        // Add 3D tilt interaction for inspector modal cheque
        document.addEventListener('DOMContentLoaded', () => {
            const inspectWrapper = document.getElementById('inspectChequebookWrapper');
            if (inspectWrapper) {
                const book = document.getElementById('inspect3dChequebook');
                inspectWrapper.addEventListener('mousemove', (e) => {
                    if (book && book.classList.contains('open')) return;
                    
                    const rect = inspectWrapper.getBoundingClientRect();
                    const x = e.clientX - rect.left - rect.width / 2;
                    const y = e.clientY - rect.top - rect.height / 2;
                    const rX = -(y / rect.height) * 15;
                    const rY = (x / rect.width) * 15;
                    
                    requestAnimationFrame(() => {
                        book.style.transform = `rotateX(${12 + rX}deg) rotateY(${-18 + rY}deg) scale(1.025)`;
                    });
                });
                
                inspectWrapper.addEventListener('mouseleave', () => {
                    requestAnimationFrame(() => {
                        book.style.transform = 'rotateX(12deg) rotateY(-18deg) scale(1)';
                    });
                });
            }
        });
    </script>
    
    <!-- Standard Core Scripts -->
    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
