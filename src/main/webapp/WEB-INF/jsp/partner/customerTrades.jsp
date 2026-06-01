<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header  { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:16px; }
    .page-title   { font-size:18px; font-weight:700; color:var(--text); }
    .page-sub     { font-size:12px; color:var(--muted); margin-top:2px; }
    .btn { height:32px; padding:0 14px; font-size:12px; font-family:inherit; font-weight:500; cursor:pointer; border:none; display:inline-flex; align-items:center; gap:5px; text-decoration:none; transition:opacity 0.15s; }
    .btn-outline  { background:var(--surface); color:var(--text); border:1px solid var(--border); } .btn-outline:hover { background:var(--bg); }

    /* 거래처 정보 카드 */
    .info-card { background:var(--surface); border:1px solid var(--border); padding:16px 20px; margin-bottom:16px; display:flex; gap:40px; flex-wrap:wrap; }
    .info-card .field { display:flex; flex-direction:column; gap:3px; }
    .info-card .field-label { font-size:10px; font-weight:700; color:var(--muted); text-transform:uppercase; letter-spacing:0.5px; }
    .info-card .field-value { font-size:13px; color:var(--text); font-weight:500; }
    .badge-status { display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:600; }
    .badge-active   { background:#ECFDF5; color:#059669; }
    .badge-inactive { background:#F1F5F9; color:#94A3B8; }

    /* 거래 요약 */
    .summary-row { display:flex; gap:12px; margin-bottom:16px; flex-wrap:wrap; }
    .summary-card { background:var(--surface); border:1px solid var(--border); padding:12px 18px; flex:1; min-width:120px; }
    .summary-card .s-num  { font-size:22px; font-weight:700; color:var(--text); }
    .summary-card .s-label { font-size:11px; color:var(--muted); margin-top:2px; }

    /* 테이블 */
    .table-wrap { background:var(--surface); border:1px solid var(--border); overflow-x:auto; -webkit-overflow-scrolling:touch; }
    .table-head { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; border-bottom:1px solid var(--border); }
    .table-head span { font-size:13px; font-weight:600; }
    .cnt-badge  { background:var(--bg); border:1px solid var(--border); border-radius:20px; padding:1px 9px; font-size:11px; color:var(--muted); }
    table { width:100%; border-collapse:collapse; min-width:620px; }
    thead th { background:#F8FAFC; font-size:11px; font-weight:600; color:var(--muted); text-align:left; padding:9px 14px; border-bottom:1px solid var(--border); white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9; transition:background 0.1s; }
    tbody tr:last-child  { border-bottom:none; }
    tbody tr:hover       { background:#F8FAFF; }
    tbody td  { padding:10px 14px; font-size:12px; color:var(--text); }
    .type-tag { display:inline-block; padding:2px 7px; border-radius:4px; font-size:10px; font-weight:700; }
    .type-approval { background:#EFF6FF; color:#2563EB; }
    .type-sales    { background:#F0FDF4; color:#16A34A; }
    .badge { display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:600; }
    .badge-pending    { background:#FEF9C3; color:#A16207; }
    .badge-progress   { background:#DBEAFE; color:#1D4ED8; }
    .badge-approved   { background:#ECFDF5; color:#059669; }
    .badge-rejected   { background:#FFF1F2; color:#E11D48; }
    .badge-draft      { background:#F1F5F9; color:#64748B; }
    .badge-confirmed  { background:#EFF6FF; color:#2563EB; }
    .badge-picking    { background:#FFFBEB; color:#D97706; }
    .badge-shipped    { background:#ECFDF5; color:#059669; }
    .badge-cancelled  { background:#FFF1F2; color:#E11D48; }
    .doc-link { color:var(--blue); text-decoration:none; font-weight:600; font-size:11px; }
    .doc-link:hover { text-decoration:underline; }
    .empty-row { text-align:center; padding:40px; color:var(--muted); }
    .empty-icon { font-size:32px; margin-bottom:8px; }

    @media (max-width:768px) {
        .info-card { gap:16px; }
        .summary-row { gap:8px; }
        .summary-card { padding:10px 14px; }
    }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">${customer.customerName}</div>
            <div class="page-sub">
                영업/재고 &gt; 거래처 관리 &gt;
                <a href="${pageContext.request.contextPath}/partner/customer/list.do" style="color:var(--blue); text-decoration:none;">고객사 관리</a>
                &gt; 거래 이력
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/partner/customer/list.do" class="btn btn-outline">← 목록으로</a>
    </div>

    <!-- 고객사 정보 카드 -->
    <div class="info-card">
        <div class="field">
            <span class="field-label">업체명</span>
            <span class="field-value">${customer.customerName}</span>
        </div>
        <div class="field">
            <span class="field-label">담당자</span>
            <span class="field-value">${empty customer.contact ? '-' : customer.contact}</span>
        </div>
        <div class="field">
            <span class="field-label">전화번호</span>
            <span class="field-value">${empty customer.phone ? '-' : customer.phone}</span>
        </div>
        <div class="field">
            <span class="field-label">주소</span>
            <span class="field-value">${empty customer.address ? '-' : customer.address}</span>
        </div>
        <div class="field">
            <span class="field-label">상태</span>
            <span class="field-value">
                <span class="badge-status ${customer.isActive eq 1 ? 'badge-active' : 'badge-inactive'}">
                    ${customer.isActive eq 1 ? '활성' : '비활성'}
                </span>
            </span>
        </div>
    </div>

    <!-- 요약 카드 -->
    <div class="summary-row">
        <div class="summary-card">
            <div class="s-num">${tradeCount}</div>
            <div class="s-label">총 거래 건수</div>
        </div>
        <div class="summary-card">
            <div class="s-num">
                <c:set var="approvalCnt" value="0"/>
                <c:forEach var="t" items="${tradeList}">
                    <c:if test="${t.tradeType eq '결재문서'}"><c:set var="approvalCnt" value="${approvalCnt + 1}"/></c:if>
                </c:forEach>
                ${approvalCnt}
            </div>
            <div class="s-label">수주 결재문서</div>
        </div>
        <div class="summary-card">
            <div class="s-num">
                <c:set var="salesCnt" value="0"/>
                <c:forEach var="t" items="${tradeList}">
                    <c:if test="${t.tradeType eq '수주'}"><c:set var="salesCnt" value="${salesCnt + 1}"/></c:if>
                </c:forEach>
                ${salesCnt}
            </div>
            <div class="s-label">수주 주문</div>
        </div>
    </div>

    <!-- 거래 이력 테이블 -->
    <div class="table-wrap">
        <div class="table-head">
            <span>거래 이력</span>
            <span class="cnt-badge">${tradeCount}건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>구분</th>
                    <th>문서번호</th>
                    <th>제목/내용</th>
                    <th>상태</th>
                    <th>작성자</th>
                    <th>거래일시</th>
                    <th>바로가기</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty tradeList}">
                        <tr>
                            <td colspan="7" class="empty-row">
                                <div class="empty-icon">📋</div>
                                거래 이력이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="t" items="${tradeList}">
                            <tr>
                                <td>
                                    <span class="type-tag ${t.tradeType eq '결재문서' ? 'type-approval' : 'type-sales'}">
                                        ${t.tradeType}
                                    </span>
                                </td>
                                <td style="font-family:monospace; font-size:11px;">${t.docNo}</td>
                                <td>${t.title}</td>
                                <td>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test="${t.status eq 'PENDING'}">badge-pending</c:when>
                                            <c:when test="${t.status eq 'IN_PROGRESS'}">badge-progress</c:when>
                                            <c:when test="${t.status eq 'APPROVED'}">badge-approved</c:when>
                                            <c:when test="${t.status eq 'REJECTED'}">badge-rejected</c:when>
                                            <c:when test="${t.status eq 'CONFIRMED'}">badge-confirmed</c:when>
                                            <c:when test="${t.status eq 'PICKING'}">badge-picking</c:when>
                                            <c:when test="${t.status eq 'SHIPPED'}">badge-shipped</c:when>
                                            <c:when test="${t.status eq 'CANCELLED'}">badge-cancelled</c:when>
                                            <c:otherwise>badge-draft</c:otherwise>
                                        </c:choose>">
                                        ${t.statusLabel}
                                    </span>
                                </td>
                                <td>${empty t.requesterName ? '-' : t.requesterName}</td>
                                <td style="color:var(--muted); font-size:11px;">${t.tradeDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.tradeType eq '결재문서'}">
                                            <a href="${pageContext.request.contextPath}/approval/detail.do?docId=${t.refId}"
                                               class="doc-link" target="_blank">결재 보기</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/sales/list.do"
                                               class="doc-link">수주 보기</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

</div>
</body>
</html>
