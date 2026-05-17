<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-title { font-size: 20px; font-weight: 700; color: var(--text); letter-spacing: -0.4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; margin-bottom: 20px; }
    .table-card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); overflow: hidden; }
    .table-card-head { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-bottom: 1px solid var(--border); }
    .table-card-head span { font-size: 14px; font-weight: 600; color: var(--text); }
    .total-badge { background: var(--bg); border: 1px solid var(--border); border-radius: 20px; padding: 2px 10px; font-size: 12px; color: var(--muted); }
    .table-wrap { overflow-x: auto; -webkit-overflow-scrolling: touch; width: 100%; }
    table { width: 100%; border-collapse: collapse; min-width: 600px; }
    thead th { background: #F8FAFC; font-size: 12px; font-weight: 600; color: var(--muted); text-align: left; padding: 10px 16px; border-bottom: 1px solid var(--border); }
    tbody tr { border-bottom: 1px solid #F1F5F9; transition: background 0.1s; }
    tbody tr:hover { background: #F8FAFF; }
    tbody td { padding: 11px 16px; font-size: 13px; color: var(--text); }
    .salary-amount { font-weight: 700; color: #2563EB; }
</style>

<main id="content">
    <div class="page-title">급여 관리</div>
    <div class="page-sub">직원별 급여 현황을 조회합니다.</div>

    <div class="table-card">
        <div class="table-card-head">
            <span>급여 목록</span>
            <span class="total-badge">총 <strong>${empty salaryList ? '0' : salaryList.size()}</strong>건</span>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>직원 아이디</th>
                        <th>이름</th>
                        <th>부서</th>
                        <th>직급</th>
                        <th>기본급</th>
                        <th>지급 연월</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty salaryList}">
                            <tr><td colspan="6" style="text-align:center; padding:48px; color:#999;">급여 데이터가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="s" items="${salaryList}">
                                <tr>
                                    <td>${s.memberId}</td>
                                    <td>${s.name}</td>
                                    <td>${s.department}</td>
                                    <td>${s.position}</td>
                                    <td class="salary-amount"><fmt:formatNumber value="${s.baseSalary}" pattern="#,###"/>원</td>
                                    <td>${s.payYear}년 ${s.payMonth}월</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

</div>
</body>
</html>
