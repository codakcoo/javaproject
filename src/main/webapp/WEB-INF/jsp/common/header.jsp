<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    Object loginUser = session.getAttribute("loginUser");
    if(loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.do");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP 시스템</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

      :root {
    --blue:      #0066CC;
    --blue-h:    #0055AA;
    --blue-lt:   #E8F0FB;
    --bg:        #F2F3F5;
    --surface:   #FFFFFF;
    --border:    #DDDDDD;
    --border-lt: #EEEEEE;
    --text:      #222222;
    --text-sm:   #555555;
    --muted:     #999999;
    --accent:    #2563EB;   /* ← 이거 추가 */
    --sidebar-w: 180px;
    --header-h:  44px;
}

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Malgun Gothic", "맑은 고딕",
                         "Apple SD Gothic Neo", sans-serif;
            background: var(--bg);
            color: var(--text);
            font-size: 13px;
            min-height: 100vh;
        }

        #header {
            position: fixed; top: 0; left: 0; right: 0; z-index: 200;
            height: var(--header-h);
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 16px 0 0;
        }

        .header-logo {
            width: var(--sidebar-w);
            height: 100%;
            display: flex; align-items: center; gap: 8px;
            padding: 0 16px;
            border-right: 1px solid var(--border);
            background: var(--blue);
            flex-shrink: 0;
        }
        .header-logo svg { width: 18px; height: 18px; fill: white; flex-shrink: 0; }
        .header-logo span {
            font-size: 13px; font-weight: 700; color: white;
            white-space: nowrap; letter-spacing: -0.2px;
        }

        /* 햄버거 (모바일 전용) */
        .btn-hamburger {
            display: none;
            width: 34px; height: 34px; margin-left: 6px;
            background: none; border: none; cursor: pointer;
            flex-direction: column; align-items: center; justify-content: center; gap: 5px;
            flex-shrink: 0;
        }
        .btn-hamburger span {
            display: block; width: 20px; height: 2px;
            background: white; border-radius: 2px;
        }

        .header-right { display: flex; align-items: center; gap: 4px; }

        .header-menu-btn {
            height: 28px; padding: 0 10px;
            border: 1px solid var(--border); border-radius: 3px;
            background: var(--surface); font-size: 12px;
            font-family: inherit; color: var(--text-sm);
            cursor: pointer;
            display: flex; align-items: center; gap: 4px;
            text-decoration: none; transition: background 0.1s;
            white-space: nowrap;
        }
        .header-menu-btn:hover { background: #F5F5F5; border-color: #BBBBBB; }
        .header-menu-btn svg { width: 13px; height: 13px; fill: var(--muted); }

        .header-divider { width: 1px; height: 16px; background: var(--border-lt); margin: 0 4px; }

        .header-user {
            display: flex; align-items: center; gap: 6px;
            padding: 0 8px; height: 28px;
            border: 1px solid var(--border); border-radius: 3px;
            cursor: pointer; transition: background 0.1s;
        }
        .header-user:hover { background: #F5F5F5; }

        .user-avatar {
            width: 22px; height: 22px; background: var(--blue);
            border-radius: 50%; display: flex; align-items: center;
            justify-content: center; font-size: 11px; font-weight: 700; color: white;
        }
        .user-name { font-size: 12px; color: var(--text); font-weight: 500; }

        #layout { display: flex; padding-top: var(--header-h); min-height: 100vh; }

        #content {
            margin-left: var(--sidebar-w); flex: 1;
            padding: 16px 20px;
            min-height: calc(100vh - var(--header-h));
            background: var(--bg);
        }

        /* ── 공통 버튼 ── */
        .btn {
            height: 28px; padding: 0 12px; border-radius: 3px;
            font-size: 12px; font-family: inherit; font-weight: 500;
            cursor: pointer; border: 1px solid transparent;
            display: inline-flex; align-items: center; gap: 4px;
            text-decoration: none; transition: opacity 0.1s; white-space: nowrap;
        }
        .btn-primary { background: var(--blue); color: white; border-color: var(--blue-h); }
        .btn-primary:hover { background: var(--blue-h); }
        .btn-outline { background: var(--surface); color: var(--text-sm); border-color: var(--border); }
        .btn-outline:hover { background: #F5F5F5; }
        .btn-danger  { background: #DC3545; color: white; border-color: #BB2D3B; }
        .btn-danger:hover { opacity: 0.88; }

        /* ── 공통 테이블 ── */
        .tbl-wrap { border: 1px solid var(--border); overflow: auto; background: var(--surface); }

        /* ══════════════════════════════════════
           반응형 미디어 쿼리
           ══════════════════════════════════════ */

        /* 태블릿 (≤1024px) */
        @media (max-width: 1024px) {
            :root { --sidebar-w: 160px; }
            #content { padding: 12px 14px; }
        }

        /* 모바일 (≤768px) */
        @media (max-width: 768px) {
            :root { --sidebar-w: 220px; }

            .header-logo { width: auto; padding: 0 10px; border-right: none; }
            .header-logo span { font-size: 12px; }
            .btn-hamburger { display: flex; }
            .user-name { display: none; }
            .header-divider { display: none; }

            #content { margin-left: 0; padding: 10px; width: 100%; }

            /* 테이블 가로 스와이프 */
            .tbl-wrap {
                overflow-x: auto !important;
                -webkit-overflow-scrolling: touch;
                /* 스크롤 가능함을 시각적으로 힌트 */
                position: relative;
            }
            .tbl { min-width: 580px; }
            .tbl thead th,
            .tbl tbody td { font-size: 11px; padding: 5px 6px; }

            /* 페이지 헤더 */
            .page-header { flex-wrap: wrap; gap: 6px; }
            .page-title  { font-size: 14px; }

            /* 검색바 세로 정렬 */
            .search-bar { flex-direction: column; align-items: stretch; }
            .search-bar input[type=text],
            .search-bar select { width: 100%; }

            /* 버튼 */
            .btn { height: 32px; }

            /* 폼 테이블 세로 변환 */
            .form-tbl,
            .form-tbl tbody,
            .form-tbl tr,
            .form-tbl th,
            .form-tbl td { display: block; width: 100%; }
            .form-tbl th { text-align: left; border-bottom: none; padding: 6px 8px 2px; }
            .form-tbl td { border-top: none; padding: 2px 8px 6px; }
            .form-tbl input,
            .form-tbl select { width: 100%; }

            /* 카드 */
            .card-body { padding: 8px; }
        }

        /* 소형 모바일 (≤480px) */
        @media (max-width: 480px) {
            #content { padding: 8px; }
            .page-title { font-size: 13px; }
            .tbl thead th, .tbl tbody td { font-size: 10px; padding: 4px 5px; }
        }
        .tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .tbl thead th {
            background: #F5F5F5; border: 1px solid #CCCCCC;
            padding: 6px 8px; font-weight: 600; color: #333333;
            text-align: center; white-space: nowrap;
        }
        .tbl tbody td {
            border: 1px solid var(--border); padding: 5px 8px;
            color: var(--text); vertical-align: middle;
        }
        .tbl tbody tr:hover { background: #F0F6FF; }

        /* ── 페이지 헤더 ── */
        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 10px; padding-bottom: 8px;
            border-bottom: 2px solid var(--blue);
        }
        .page-title { font-size: 15px; font-weight: 700; color: var(--text); }
        .page-btns  { display: flex; gap: 4px; }

        /* ── 검색 영역 ── */
        .search-bar {
            background: var(--surface); border: 1px solid var(--border);
            padding: 8px 12px; margin-bottom: 8px;
            display: flex; gap: 6px; align-items: center; flex-wrap: wrap;
        }
        .search-bar label { font-size: 12px; color: var(--text-sm); white-space: nowrap; }
        .search-bar input[type=text], .search-bar select {
            height: 26px; padding: 0 6px; border: 1px solid #BBBBBB;
            border-radius: 2px; font-size: 12px; font-family: inherit;
            outline: none; color: var(--text);
        }
        .search-bar input:focus, .search-bar select:focus { border-color: var(--blue); }

        /* ── 폼 테이블 ── */
        .form-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .form-tbl th {
            background: #F5F5F5; border: 1px solid #CCCCCC;
            padding: 6px 10px; font-weight: 600; color: #444444;
            text-align: right; white-space: nowrap; width: 120px;
        }
        .form-tbl td { border: 1px solid var(--border); padding: 4px 8px; }
        .form-tbl input, .form-tbl select, .form-tbl textarea {
            height: 26px; padding: 0 6px; border: 1px solid #BBBBBB;
            border-radius: 2px; font-size: 12px; font-family: inherit;
            color: var(--text); outline: none; background: white;
        }
        .form-tbl input:focus, .form-tbl select:focus { border-color: var(--blue); }
        .form-tbl textarea { height: 70px; padding: 4px 6px; resize: vertical; }

        /* ── 배지 ── */
        .badge {
            display: inline-block; padding: 1px 6px;
            font-size: 11px; font-weight: 600; border-radius: 2px;
        }
        .badge-blue   { background: #E8F0FB; color: #0066CC; border: 1px solid #B8D0F0; }
        .badge-green  { background: #E8F5E9; color: #2E7D32; border: 1px solid #A5D6A7; }
        .badge-orange { background: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }
        .badge-red    { background: #FFEBEE; color: #C62828; border: 1px solid #EF9A9A; }
        .badge-gray   { background: #F5F5F5; color: #555555; border: 1px solid #CCCCCC; }

        /* ── 카드 ── */
        .card { background: var(--surface); border: 1px solid var(--border); margin-bottom: 12px; }
        .card-head {
            display: flex; align-items: center; justify-content: space-between;
            padding: 8px 12px; border-bottom: 1px solid var(--border); background: #FAFAFA;
        }
        .card-head h3 { font-size: 13px; font-weight: 700; color: var(--text); }
        .card-body { padding: 12px; }
    </style>
</head>
<body>

<header id="header">
    <div class="header-logo">
        <button class="btn-hamburger" id="hamburgerBtn" onclick="toggleSidebar()">
            <span></span><span></span><span></span>
        </button>
        <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
        <span>ERP 시스템</span>
    </div>
    <div class="header-right">
        <div class="header-user">
            <div class="user-avatar">${loginUser.name.substring(0,1)}</div>
            <div class="user-name">${loginUser.name} (${loginUser.role})</div>
        </div>
        <div class="header-divider"></div>
        <a href="${pageContext.request.contextPath}/logout.do" class="header-menu-btn">
            <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
            로그아웃
        </a>
    </div>
</header>

<div id="sidebar-overlay" onclick="closeSidebar()"
     style="display:none;position:fixed;inset:0;z-index:250;background:rgba(0,0,0,0.45);"></div>

<div id="layout">

<script>
function toggleSidebar() {
    var s = document.getElementById('sidebar');
    var o = document.getElementById('sidebar-overlay');
    var open = s && s.classList.contains('mobile-open');
    if (s) s.classList.toggle('mobile-open', !open);
    o.style.display = open ? 'none' : 'block';
}
function closeSidebar() {
    var s = document.getElementById('sidebar');
    var o = document.getElementById('sidebar-overlay');
    if (s) s.classList.remove('mobile-open');
    o.style.display = 'none';
}
window.addEventListener('resize', function() {
    if (window.innerWidth > 768) closeSidebar();
});
</script>
