<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --primary:   #2563EB;
            --primary-h: #1D4ED8;
            --bg:        #F1F5F9;
            --surface:   #FFFFFF;
            --border:    #E2E8F0;
            --text:      #1E293B;
            --muted:     #94A3B8;
            --error:     #EF4444;
            --radius:    12px;
            --shadow:    0 4px 24px rgba(0,0,0,0.08);
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            background: var(--surface);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 48px 40px;
            width: 100%;
            max-width: 420px;
            animation: fadeUp 0.4s ease both;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 32px;
        }

        .logo-icon {
            width: 36px;
            height: 36px;
            background: var(--primary);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-icon svg {
            width: 20px;
            height: 20px;
            fill: white;
        }

        .logo-text {
            font-size: 16px;
            font-weight: 700;
            color: var(--text);
            letter-spacing: -0.3px;
        }

        h1 {
            font-size: 22px;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 6px;
            letter-spacing: -0.5px;
        }

        .subtitle {
            font-size: 13px;
            color: var(--muted);
            margin-bottom: 32px;
        }

        .field {
            margin-bottom: 16px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: var(--text);
            margin-bottom: 6px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            height: 46px;
            padding: 0 14px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            color: var(--text);
            background: var(--surface);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
        }

        input::placeholder {
            color: var(--muted);
        }

        .btn {
            display: block;
            width: 100%;
            height: 48px;
            margin-top: 24px;
            background: var(--primary);
            color: white;
            font-size: 15px;
            font-weight: 600;
            font-family: inherit;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            letter-spacing: -0.2px;
            transition: background 0.2s, transform 0.1s;
        }

        .btn:hover  { background: var(--primary-h); }
        .btn:active { transform: scale(0.98); }

        .error-msg {
            background: #FEF2F2;
            border: 1px solid #FECACA;
            color: var(--error);
            font-size: 13px;
            padding: 10px 14px;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        .divider {
            height: 1px;
            background: var(--border);
            margin: 28px 0;
        }

        .footer-text {
            text-align: center;
            font-size: 12px;
            color: var(--muted);
        }
    </style>
</head>
<body>

<div class="card">

    <div class="logo">
<!--  
        <div class="logo-icon">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C9.243 2 7 4.243 7 7v3H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8a2 2 0 0 0-2-2h-1V7c0-2.757-2.243-5-5-5zm0 2c1.654 0 3 1.346 3 3v3H9V7c0-1.654 1.346-3 3-3zm0 10a2 2 0 1 1 0 4 2 2 0 0 1 0-4z"/>
            </svg>
        </div>
-->
        <span class="logo-text">전자정부 표준프레임워크</span>
    </div>

    <h1>로그인</h1>
    <p class="subtitle">서비스를 이용하려면 로그인이 필요합니다.</p>

    <!-- 에러 메시지 (로그인 실패 시 표시) -->
    <c:if test="${not empty errorMsg}">
        <div class="error-msg">${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/loginProcess.do" method="post">
        <div class="field">
            <label for="id">아이디</label>
            <input type="text" id="id" name="id" placeholder="아이디를 입력하세요" autocomplete="username">
        </div>
        <div class="field">
            <label for="pw">비밀번호</label>
            <input type="password" id="pw" name="pw" placeholder="비밀번호를 입력하세요" autocomplete="current-password">
        </div>
        <button type="submit" class="btn">로그인</button>
    </form>

    <div class="divider"></div>
    <p class="footer-text">© 2025 전자정부 표준프레임워크</p>

</div>

</body>
</html>
