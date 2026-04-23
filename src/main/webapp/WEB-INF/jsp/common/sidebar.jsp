<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // 현재 URL로 활성 메뉴 판별
    String uri = request.getRequestURI();
%>
<style>
    /* ── 사이드바 ── */
    #sidebar {
        position: fixed;
        top: var(--header-h); left: 0;
        width: var(--sidebar-w);
        height: calc(100vh - var(--header-h));
        background: var(--navy-d);
        overflow-y: auto;
        padding: 16px 0;
    }

    .nav-section { margin-bottom: 8px; }

    .nav-section-title {
        font-size: 10px; font-weight: 700;
        color: rgba(255,255,255,0.3);
        letter-spacing: 1px; text-transform: uppercase;
        padding: 8px 20px 4px;
    }

    .nav-item {
        display: flex; align-items: center; gap: 10px;
        padding: 9px 20px;
        color: rgba(255,255,255,0.65);
        font-size: 13px; font-weight: 400;
        text-decoration: none;
        border-left: 3px solid transparent;
        transition: all 0.15s;
        cursor: pointer;
    }

    .nav-item:hover {
        background: rgba(255,255,255,0.06);
        color: rgba(255,255,255,0.9);
        border-left-color: rgba(74,144,217,0.5);
    }

    .nav-item.active {
        background: rgba(74,144,217,0.15);
        color: #7BB8F0;
        border-left-color: var(--accent);
        font-weight: 500;
    }

    .nav-item svg {
        width: 16px; height: 16px;
        flex-shrink: 0; opacity: 0.8;
        fill: currentColor;
    }

    /* 서브메뉴 */
    .nav-sub { display: none; }
    .nav-sub.open { display: block; }

    .nav-sub .nav-item {
        padding-left: 46px;
        font-size: 12px;
    }

    .nav-toggle svg.arrow {
        margin-left: auto;
        transition: transform 0.2s;
    }
    .nav-toggle.open svg.arrow { transform: rotate(180deg); }

    /* 구분선 */
    .nav-divider {
        height: 1px;
        background: rgba(255,255,255,0.07);
        margin: 8px 16px;
    }

    .sidebar-bottom {
        position: absolute; bottom: 16px; left: 0; right: 0;
        padding: 0 16px;
    }

    .sidebar-ver {
        font-size: 10px; color: rgba(255,255,255,0.2);
        text-align: center; padding-top: 8px;
        border-top: 1px solid rgba(255,255,255,0.07);
    }
</style>

<nav id="sidebar">
    <div class="nav-section">
        <div class="nav-section-title">메인</div>
        <a href="${pageContext.request.contextPath}/main.do"
           class="nav-item <%= uri.contains("/main") ? "active" : "" %>">
            <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
            대시보드
        </a>
    </div>

    <div class="nav-divider"></div>

    <div class="nav-section">
        <div class="nav-section-title">인사관리</div>

        <!-- 토글 메뉴 -->
        <div class="nav-item nav-toggle <%= uri.contains("/hr") || uri.contains("/approval") ? "open active" : "" %>"
             onclick="toggleMenu('hrMenu', this)">
            <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
            인사/조직 관리
            <svg class="arrow" viewBox="0 0 24 24" width="12" height="12"><path d="M7 10l5 5 5-5z"/></svg>
        </div>
        <div class="nav-sub <%= uri.contains("/hr") || uri.contains("/approval") ? "open" : "" %>" id="hrMenu">
            <a href="${pageContext.request.contextPath}/hr/list.do"
               class="nav-item <%= uri.contains("/hr/list") ? "active" : "" %>">직원 목록</a>
            <a href="${pageContext.request.contextPath}/hr/dept.do"
               class="nav-item <%= uri.contains("/hr/dept") ? "active" : "" %>">부서 관리</a>
            <a href="${pageContext.request.contextPath}/approval/list.do"
               class="nav-item <%= uri.contains("/approval") ? "active" : "" %>">전자결재</a>
        </div>
    </div>

    <div class="nav-divider"></div>

    <div class="nav-section">
        <div class="nav-section-title">영업/재고</div>

        <div class="nav-item nav-toggle <%= uri.contains("/product") || uri.contains("/sales") ? "open active" : "" %>"
             onclick="toggleMenu('productMenu', this)">
            <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4zM13.5 3c.83 0 1.5.67 1.5 1.65 0 1.56-1.78 2.7-3 3.35C10.78 7.35 9 6.21 9 4.65 9 3.67 9.67 3 10.5 3h3zM4 7h7.5v.17C10.62 7.85 9 8.91 9 9.5H4V7zm16 11H4v-6.5h5c0 .83 1.79 1.5 3 1.5s3-.67 3-1.5h5V18zm0-8.5h-5c0-.59-1.62-1.65-2.5-1.83V8H20v1.5z"/></svg>
            영업/재고 관리
            <svg class="arrow" viewBox="0 0 24 24" width="12" height="12"><path d="M7 10l5 5 5-5z"/></svg>
        </div>
        <div class="nav-sub <%= uri.contains("/product") || uri.contains("/sales") ? "open" : "" %>" id="productMenu">
            <a href="${pageContext.request.contextPath}/product/list.do"
               class="nav-item <%= uri.contains("/product") ? "active" : "" %>">상품 관리</a>
            <a href="${pageContext.request.contextPath}/sales/list.do"
               class="nav-item <%= uri.contains("/sales") ? "active" : "" %>">판매 현황</a>
            <a href="${pageContext.request.contextPath}/stock/list.do"
               class="nav-item <%= uri.contains("/stock") ? "active" : "" %>">재고 현황</a>
        </div>
    </div>

    <div class="sidebar-bottom">
        <div class="sidebar-ver">ERP v1.0 · eGovFrame 4.3</div>
    </div>
</nav>

<script>
function toggleMenu(menuId, btn) {
    const menu = document.getElementById(menuId);
    const isOpen = menu.classList.contains('open');
    // 모든 서브메뉴 닫기
    document.querySelectorAll('.nav-sub').forEach(m => m.classList.remove('open'));
    document.querySelectorAll('.nav-toggle').forEach(b => b.classList.remove('open'));
    // 클릭한 것만 토글
    if (!isOpen) {
        menu.classList.add('open');
        btn.classList.add('open');
    }
}
</script>
