<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary:   #2563EB;
            --primary-h: #1D4ED8;
            --bg:        #F1F5F9;
            --surface:   #FFFFFF;
            --border:    #E2E8F0;
            --text:      #1E293B;
            --muted:     #94A3B8;
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
        h1 { font-size: 22px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
        .subtitle { font-size: 13px; color: var(--muted); margin-bottom: 32px; }
        .field { margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 500; color: var(--text); margin-bottom: 6px; }
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
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
        }
        input::placeholder { color: var(--muted); }
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
            transition: background 0.2s, transform 0.1s;
        }
        .btn:hover  { background: var(--primary-h); }
        .btn:active { transform: scale(0.98); }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--muted);
            text-decoration: none;
        }
        .back-link:hover { color: var(--primary); }
    </style>
</head>
<body>
<div class="card">
    <h1>회원가입</h1>
    <p class="subtitle">정보를 입력하고 가입하세요.</p>
    <form action="${pageContext.request.contextPath}/registerProcess.do" method="post">
        <div class="field">
            <label>아이디</label>
            <input type="text" name="memberId" placeholder="아이디를 입력하세요">
        </div>
        <div class="field">
            <label>비밀번호</label>
            <input type="password" name="password" placeholder="비밀번호를 입력하세요">
        </div>
        <div class="field">
            <label>이름</label>
            <input type="text" name="name" placeholder="이름을 입력하세요">
        </div>
        <div class="field">
            <label>이메일</label>
            <input type="text" name="email" placeholder="이메일을 입력하세요">
        </div>
        <button type="submit" class="btn">가입하기</button>
    </form>
    <a href="${pageContext.request.contextPath}/login.do" class="back-link">로그인으로 돌아가기</a>
</div>
</body>
</html>