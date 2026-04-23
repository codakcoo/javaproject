<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // 로그인 체크 - 세션 없으면 로그인 페이지로
    Object loginUser = session.getAttribute("loginUser");
    if(loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.do");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP 시스템</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy:    #1E2761;
            --navy-d:  #141B47;
            --accent:  #4A90D9;
            --bg:      #F0F4FF;
            --surface: #FFFFFF;
            --border:  #E2E8F0;
            --text:    #1E293B;
            --muted:   #64748B;
            --sidebar-w: 220px;
            --header-h:  56px;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── 헤더 ── */
        #header {
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            height: var(--header-h);
            background: var(--navy);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 20px 0 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.18);
        }

        .header-logo {
            width: var(--sidebar-w);
            display: flex; align-items: center; gap: 10px;
            padding: 0 20px;
            border-right: 1px solid rgba(255,255,255,0.1);
            height: 100%;
        }

        .header-logo .logo-icon {
            width: 30px; height: 30px;
            background: var(--accent);
            border-radius: 6px;
            display: flex; align-items: center; justify-content: center;
        }

        .header-logo .logo-icon svg { width: 16px; height: 16px; fill: white; }

        .header-logo span {
            font-size: 14px; font-weight: 700;
            color: white; letter-spacing: -0.3px;
        }

        .header-right {
            display: flex; align-items: center; gap: 16px;
        }

        .header-user {
            display: flex; align-items: center; gap: 8px;
        }

        .user-avatar {
            width: 32px; height: 32px;
            background: var(--accent);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: white;
        }

        .user-name { font-size: 13px; color: rgba(255,255,255,0.9); font-weight: 500; }
        .user-role { font-size: 11px; color: rgba(255,255,255,0.5); }

        .btn-logout {
            padding: 6px 14px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 6px;
            color: rgba(255,255,255,0.85);
            font-size: 12px; font-family: inherit;
            cursor: pointer; text-decoration: none;
            transition: background 0.2s;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.2); }

        /* ── 레이아웃 ── */
        #layout {
            display: flex;
            padding-top: var(--header-h);
            min-height: 100vh;
        }

        #content {
            margin-left: var(--sidebar-w);
            flex: 1;
            padding: 28px;
            min-height: calc(100vh - var(--header-h));
        }
    </style>
</head>
<body>

<header id="header">
    <div class="header-logo">
        <div class="logo-icon">
            <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
        </div>
        <span>ERP 시스템</span>
    </div>
    <div class="header-right">
        <div class="header-user">
            <div class="user-avatar">${loginUser.name.substring(0,1)}</div>
            <div>
                <div class="user-name">${loginUser.name}님</div>
                <div class="user-role">${loginUser.role}</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout.do" class="btn-logout">로그아웃</a>
    </div>
</header>

<div id="layout">
