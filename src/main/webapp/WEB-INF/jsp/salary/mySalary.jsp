<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-title { font-size: 20px; font-weight: 700; color: var(--text); margin-bottom: 4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-bottom: 20px; }
    .salary-card {
        background: var(--surface); border: 1px solid var(--border);
        border-radius: 12px; padding: 28px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        max-width: 500px;
    }
    .salary-row {
        display: flex; justify-content: space-between; align-items: center;
        padding: 12px 0; border-bottom: 1px solid #F1F5F9;
        font-size: 14px;
    }
    .salary-row:last-child { border-bottom: none; }
    .salary-label { color: var(--muted); font-weight: 500; }
    .salary-value { font-weight: 600; color: var(--text); }
    .salary-amount { font-size: 20px; font-weight: 700; color: #2563EB; }
    .empty-msg { text-align: center; padding: 48px; color: var(--muted); font-size: 14px; }
</style>

<main id="content">
    <div class="page-title">내 급여</div>
    <div class="page-sub">나의 급여 정보를 확인합니다.</div>

    <c:choose>
        <c:when test="${empty salary}">
            <div class="salary-card">
                <div class="empty-msg">등록된 급여 정보가 없습니다.</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="salary-card">
                <div class="salary-row">
                    <span class="salary-label">이름</span>
                    <span class="salary-value">${salary.name}</span>
                </div>
                <div class="salary-row">
                    <span class="salary-label">부서</span>
                    <span class="salary-value">${salary.department}</span>
                </div>
                <div class="salary-row">
                    <span class="salary-label">직급</span>
                    <span class="salary-value">${salary.position}</span>
                </div>
                <div class="salary-row">
                    <span class="salary-label">지급 연월</span>
                    <span class="salary-value">${salary.payYear}년 ${salary.payMonth}월</span>
                </div>
                <div class="salary-row">
                    <span class="salary-label">기본급</span>
                    <span class="salary-amount">
                        <fmt:formatNumber value="${salary.baseSalary}" pattern="#,###"/>원
                    </span>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

</div>
</body>
</html>
