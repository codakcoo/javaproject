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
    }

    /* 상단 사용자 영역 */
    .sb-user {
        padding: 10px 14px 8px;
        border-bottom: 1px solid var(--border-lt);
        background: #FAFAFA;
    }
    .sb-user-name { font-size: 12px; font-weight: 700; color: var(--text); }
    .sb-user-role { font-size: 11px; color: var(--muted); margin-top: 1px; }

    /* 메뉴 그룹 */
    .nav-group { border-bottom: 1px solid var(--border-lt); }

    .nav-group-title {
        font-size: 11px; font-weight: 700;
        color: var(--muted); letter-spacing: 0.5px;
        padding: 8px 14px 4px;
        background: #FAFAFA;
        border-bottom: 1px solid var(--border-lt);
    }

    /* 메뉴 아이템 */
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
    .nav-item svg {
        width: 14px; height: 14px; flex-shrink: 0;
        fill: currentColor; opacity: 0.75;
    }

    /* 토글 메뉴 */
    .nav-toggle { justify-content: space-between; }
    .nav-toggle .toggle-left { display: flex; align-items: center; gap: 8px; }
    .nav-toggle svg.arr {
        width: 12px; height: 12px; fill: var(--muted);
        transition: transform 0.2s; flex-shrink: 0;
    }
    .nav-toggle.open svg.arr { transform: rotate(90deg); }
    .nav-toggle.open { color: var(--blue); font-weight: 600; }

    /* 서브메뉴 */
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
        background: var(--muted); border-radius: 50%;
        flex-shrink: 0;
    }
    .nav-sub .nav-item.active {
        background: var(--blue-lt); color: var(--blue);
        font-weight: 600;
    }
    .nav-sub .nav-item.active::before { background: var(--blue); }

    /* 하단 버전 */
    .sb-ver {
        padding: 8px 14px;
        font-size: 10px; color: var(--muted);
        border-top: 1px solid var(--border-lt);
        background: #FAFAFA;
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
           class="nav-item <%= uri.contains("/main") ? "active" : "" %>">
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
        <div class="nav-sub <%= uri.contains("/hr") || uri.contains("/approval") ? "open" : "" %>" id="hrMenu">
            <a href="${pageContext.request.contextPath}/hr/list.do"
               class="nav-item <%= uri.contains("/hr/list") ? "active" : "" %>">직원 목록</a>
            <a href="${pageContext.request.contextPath}/hr/dept.do"
               class="nav-item <%= uri.contains("/hr/dept") ? "active" : "" %>">부서 관리</a>
<%--             <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/approval") ? "active" : "" %>">전자결재</a> --%>
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
               class="nav-item <%= uri.contains("/product") ? "active" : "" %>">상품 관리</a>
            <a href="${pageContext.request.contextPath}/sales/list.do"
               class="nav-item <%= uri.contains("/sales") ? "active" : "" %>">판매 현황</a>
            <a href="${pageContext.request.contextPath}/stock/list.do"
               class="nav-item <%= uri.contains("/stock") ? "active" : "" %>">재고 현황</a>
        </div>
    </div>
    
    <!-- 결재관리 -->
    <div class="nav-group">
        <div class="nav-group-title">결재관리</div>
        <div class="nav-item nav-toggle <%= uri.contains("/approval") ? "open" : "" %>"
             onclick="toggleMenu('approvalMenu', this)">
            <div class="toggle-left">
                <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                결재 관리
            </div>
            <svg class="arr" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
        </div>
        <div class="nav-sub <%=uri.contains("/approval") ? "open" : "" %>" id="approvalMenu">
            <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/hr/list") ? "active" : "" %>">총 결재</a>
            <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/hr/dept") ? "active" : "" %>">요청</a>
            <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/approval") ? "active" : "" %>">반려</a>
            <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/approval") ? "active" : "" %>">완료</a>
        </div>
    </div>

    <div class="sb-ver">ERP v1.0 · eGovFrame 4.3</div>
</nav>

<script>
function toggleMenu(menuId, btn) {
    const menu = document.getElementById(menuId);
    const isOpen = menu.classList.contains('open');
    document.querySelectorAll('.nav-sub').forEach(m => m.classList.remove('open'));
    document.querySelectorAll('.nav-toggle').forEach(b => b.classList.remove('open'));
    if (!isOpen) {
        menu.classList.add('open');
        btn.classList.add('open');
    }
}
</script>
