<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VGB | File Not Found (404)</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assest/css/styles.css" rel="stylesheet">
</head>
<body class="bank-home-page" style="min-height: 100vh; display: flex; align-items: center; justify-content: center; position: relative;">
    <div class="cursor-glow"></div>
    <div class="hero-bg">
        <div class="gradient-orb orb-1"></div>
        <div class="gradient-orb orb-2"></div>
    </div>

    <div style="text-align: center; max-width: 500px; padding: 40px 20px; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(99, 102, 241, 0.2); border-radius: var(--radius-xl); box-shadow: var(--shadow-2xl); position: relative; z-index: 10;">
        <i class="bx bx-error-circle" style="font-size: 5rem; color: var(--primary-500); margin-bottom: 20px;"></i>
        <h1 style="font-size: 4rem; font-weight: 800; color: var(--gray-900); line-height: 1; margin-bottom: 10px;">404</h1>
        <h2 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-800); margin-bottom: 15px;">Page File Not Found</h2>
        <p style="color: var(--gray-500); font-size: 0.95rem; line-height: 1.6; margin-bottom: 30px;">The requested banking link or transaction route is not recognized on our server logs.</p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">
            <span>Return to Home</span>
            <i class="bx bx-home"></i>
        </a>
    </div>

    <script src="${pageContext.request.contextPath}/assest/js/script.js"></script>
</body>
</html>
