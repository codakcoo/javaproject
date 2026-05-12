<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String uri = request.getRequestURI();
%>
<style>
    #sidebar {
        position: fixed;
        top: var(--header-h); left: 0;
        width: var(--sidebar-w);
        height: calc(100vh - var(--header-h));
        background: var(--surface);
        border-right: 1px solid var(--border);
        overflow-y: auto; overflow-x: hidden;
        user-select: none;
        z-index: 260;
        transition: transform 0.25s ease;
    }

    .sb-user {
        padding: 10px 14px 8px;
        border-bottom: 1px solid var(--border-lt);
        background: #FAFAFA;
    }
    .sb-user-name { font-size: 12px; font-weight: 700; color: var(--text); }
    .sb-user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }

    .nav-group { border-bottom: 1px solid var(--border-lt); }

    .nav-group-title {
        font-size: 11px; font-weight: 700;
        color: var(--muted); letter-spacing: 0.5px;
        padding: 8px 14px 4px;
        background: #FAFAFA;
        border-bottom: 1px solid var(--border-lt);
    }

    .nav-item {
        display: flex; align-items: center; gap: 8px;
        padding: 7px 14px;
        color: var(--text-sm); font-size: 12px;
        text-decoration: none; cursor: pointer;
        border-left: 2px solid transparent;
        transition: background 0.1s, color 0.1s;
        white-space: nowrap;
    }
    .nav-item:hover { background: #F0F6FF; color: var(--blue); }
    .nav-item.active {
        background: var(--blue-lt); color: var(--blue);
        border-left-color: var(--blue); font-weight: 600;
    }
    .nav-item svg { width: 14px; height: 14px; flex-shrink: 0; fill: currentColor; opacity: 0.75; }

    .nav-toggle { justify-content: space-between; }
    .nav-toggle .toggle-left { display: flex; align-items: center; gap: 8px; }
    .nav-toggle svg.arr {
        width: 12px; height: 12px; fill: var(--muted);
        transition: transform 0.2s; flex-shrink: 0;
    }
    .nav-toggle.open svg.arr { transform: rotate(90deg); }
    .nav-toggle.open { color: var(--text-sm); font-weight: 600; }

    .nav-sub { display: none; background: #FAFAFA; }
    .nav-sub.open { display: block; }
    .nav-sub .nav-item {
        padding-left: 34px; font-size: 12px;
        color: var(--text-sm); border-left: none;
        border-bottom: 1px solid var(--border-lt);
    }
    .nav-sub .nav-item:last-child { border-bottom: none; }
    .nav-sub .nav-item::before {
        content: ""; width: 4px; height: 4px;
        background: var(--muted); border-radius: 50%; flex-shrink: 0;
    }
    .nav-sub .nav-item.active { background: var(--blue-lt); color: var(--blue); font-weight: 600; }
    .nav-sub .nav-item.active::before { background: var(--blue); }

    .sb-ver {
        padding: 8px 14px; font-size: 10px; color: var(--muted);
        border-top: 1px solid var(--border-lt); background: #FAFAFA;
    }

    /* ── 모바일 반응형 ── */
    @media (max-width: 768px) {
        #sidebar {
            /* 기본: 왼쪽으로 숨김 */
            transform: translateX(-100%);
            box-shadow: none;
        }
        /* 열린 상태 */
        #sidebar.mobile-open {
            transform: translateX(0);
            box-shadow: 4px 0 20px rgba(0,0,0,0.15);
        }

        /* 모바일에서 nav-item 터치 영역 확대 */
        .nav-item { padding: 10px 14px; font-size: 13px; }
        .nav-sub .nav-item { padding: 9px 14px 9px 34px; font-size: 12px; }
        .nav-group-title { padding: 10px 14px 5px; font-size: 11px; }
        .sb-user { padding: 14px 14px 10px; }
        .sb-user-name { font-size: 13px; }
    }
</style>

<nav id="sidebar">
    <div class="sb-user">
        <div class="sb-user-name">${loginUser.name}</div>
        <div class="sb-user-role">${loginUser.role}</div>
    </div>

    <!-- 메인 -->
    <div class="nav-group">
        <a href="${pageContext.request.contextPath}/main.do"
           class="nav-item <%= uri.contains("/main") ? "active" : "" %>"
           onclick="closeSidebar()">
            <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
            대시보드
        </a>
    </div>

    <!-- 인사관리 -->
    <div class="nav-group">
        <div class="nav-group-title">인사관리</div>
        <div class="nav-item nav-toggle <%= uri.contains("/hr") ? "open" : "" %>"
             onclick="toggleMenu('hrMenu', this)">
            <div class="toggle-left">
                <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                인사/조직 관리
            </div>
            <svg class="arr" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
        </div>
        <div class="nav-sub <%= uri.contains("/hr") ? "open" : "" %>" id="hrMenu">
            <a href="${pageContext.request.contextPath}/hr/list.do"
               class="nav-item <%= uri.contains("/hr/list") ? "active" : "" %>"
               onclick="closeSidebar()">직원 목록</a>
         	<a href="${pageContext.request.contextPath}/dept/list.do"
   				class="nav-item <%= uri.contains("/dept/list") ? "active" : "" %>"
   				onclick="closeSidebar()">부서 관리</a>
            <a href="${pageContext.request.contextPath}/hr/approval.do"
      	 	    class="nav-item <%= uri.contains("/hr/approval") ? "active" : "" %>"
      	        onclick="closeSidebar()">가입 승인 관리</a>
        </div>
    </div>

    <!-- 영업/재고 -->
    <div class="nav-group">
        <div class="nav-group-title">영업/재고</div>
        <div class="nav-item nav-toggle <%= uri.contains("/product") || uri.contains("/sales") || uri.contains("/stock") ? "open" : "" %>"
             onclick="toggleMenu('productMenu', this)">
            <div class="toggle-left">
                <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4z"/></svg>
                영업/재고 관리
            </div>
            <svg class="arr" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
        </div>
        <div class="nav-sub <%= uri.contains("/product") || uri.contains("/sales") || uri.contains("/stock") ? "open" : "" %>" id="productMenu">
            <a href="${pageContext.request.contextPath}/product/list.do"
               class="nav-item <%= uri.contains("/product") ? "active" : "" %>"
               onclick="closeSidebar()">상품 관리</a>
            <a href="${pageContext.request.contextPath}/sales/list.do"
               class="nav-item <%= uri.contains("/sales") ? "active" : "" %>"
               onclick="closeSidebar()">판매 현황</a>
            <a href="${pageContext.request.contextPath}/stock/list.do"
               class="nav-item <%= uri.contains("/stock") ? "active" : "" %>"
               onclick="closeSidebar()">재고 현황</a>
        </div>
    </div>

    <!-- 결재관리 -->
    <div class="nav-group">
        <div class="nav-group-title">결재관리</div>
        <div class="nav-item nav-toggle <%= uri.contains("/approval") ? "open" : "" %>"
             onclick="toggleMenu('approvalMenu', this)">
            <div class="toggle-left">
                <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                결재 관리
            </div>
            <svg class="arr" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
        </div>
        <div class="nav-sub <%= uri.contains("/approval") ? "open" : "" %>" id="approvalMenu">
            <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/list") && uri.contains("/approval") ? "active" : "" %>"
               onclick="closeSidebar()">전체</a>
            <a href="${pageContext.request.contextPath}/approval/pending.do"
               class="nav-item <%= uri.contains("/pending") ? "active" : "" %>"
               onclick="closeSidebar()">기안중</a>
            <a href="${pageContext.request.contextPath}/approval/inProgress.do"
               class="nav-item <%= uri.contains("/inProgress") ? "active" : "" %>"
               onclick="closeSidebar()">진행중</a>
            <a href="${pageContext.request.contextPath}/approval/rejected.do"
               class="nav-item <%= uri.contains("/rejected") ? "active" : "" %>"
               onclick="closeSidebar()">반려</a>
            <a href="${pageContext.request.contextPath}/approval/approved.do"
               class="nav-item <%= uri.contains("/approved") ? "active" : "" %>"
               onclick="closeSidebar()">결재</a>
        </div>
    </div>

    <!-- 주문관리 -->
    <div class="nav-group">
        <div class="nav-group-title">주문관리</div>
        <div class="nav-item nav-toggle"
             onclick="toggleMenu('orderMenu', this)">
            <div class="toggle-left">
                <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                주문내역
            </div>
            <svg class="arr" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
        </div>
        <div class="nav-sub" id="orderMenu">
            <a href="${pageContext.request.contextPath}/order/list.do"
               class="nav-item <%= uri.contains("/list") ? "active" : "" %>"
               onclick="closeSidebar()">주문내역</a>
        </div>
    </div>

    <div class="sb-ver">ERP v1.0 · eGovFrame 4.3</div>
    <!--  급여관리 HTML  -->
<div class="nav-group">
    <div class="nav-group-title">급여관리</div>
    <div class="nav-item nav-toggle <%= uri.contains("/salary") ? "open" : "" %>"
         onclick="toggleMenu('salaryMenu', this)">
        <div class="toggle-left">
            <svg viewBox="0 0 24 24"><path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/></svg>
            급여 관리
        </div>
        <svg class="arr" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
    </div>
    <div class="nav-sub <%= uri.contains("/salary") ? "open" : "" %>" id="salaryMenu">
        <a href="${pageContext.request.contextPath}/salary/list.do"
           class="nav-item <%= uri.contains("/salary/list") ? "active" : "" %>"
           onclick="closeSidebar()">급여 목록</a>
        <a href="${pageContext.request.contextPath}/salary/my.do"
           class="nav-item <%= uri.contains("/salary/my") ? "active" : "" %>"
           onclick="closeSidebar()">내 급여</a>
    </div>
</div>


</nav>

<script>
function toggleMenu(menuId, btn) {
    var menu   = document.getElementById(menuId);
    var isOpen = menu.classList.contains('open');
    document.querySelectorAll('.nav-sub').forEach(function(m) { m.classList.remove('open'); });
    document.querySelectorAll('.nav-toggle').forEach(function(b) { b.classList.remove('open'); });
    if (!isOpen) {
        menu.classList.add('open');
        btn.classList.add('open');
    }
}

<!-- 급여관리 -->


</script>
