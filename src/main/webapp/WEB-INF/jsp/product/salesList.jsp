<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:16px; }
    .page-title  { font-size:18px; font-weight:700; color:var(--text); }
    .page-sub    { font-size:12px; color:var(--muted); margin-top:2px; }
    .search-bar  { background:var(--surface); border:1px solid var(--border); padding:12px 16px; margin-bottom:12px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
    .search-bar input, .search-bar select { height:32px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .search-bar input[type="text"] { width:160px; }
    .search-bar input[type="date"] { width:130px; }
    .search-bar select { width:130px; }
    .btn { height:32px; padding:0 14px; font-size:12px; font-family:inherit; font-weight:500; cursor:pointer; border:none; display:inline-flex; align-items:center; gap:5px; text-decoration:none; transition:opacity 0.15s; }
    .btn-primary { background:var(--blue); color:white; } .btn-primary:hover { opacity:0.85; }
    .btn-outline { background:var(--surface); color:var(--text); border:1px solid var(--border); } .btn-outline:hover { background:var(--bg); }
    .ml-auto { margin-left:auto; }
    .table-wrap { background:var(--surface); border:1px solid var(--border); overflow-x:auto; -webkit-overflow-scrolling:touch; }
    table { min-width: 650px; }

    @media (max-width: 768px) {
        table { min-width: 580px; }
        thead th { font-size: 11px; padding: 7px 8px; }
        tbody td  { font-size: 11px; padding: 7px 8px; }
        /* 모달: 모바일에서 하단 시트 */
        .modal-bg { align-items: flex-end !important; }
        .modal {
            width: 100% !important;
            max-width: 100vw !important;
            max-height: 85vh !important;
            overflow-y: auto !important;
            border-radius: 12px 12px 0 0 !important;
            padding: 20px 16px !important;
        }
    }
    .table-head { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; border-bottom:1px solid var(--border); }
    .table-head span { font-size:13px; font-weight:600; }
    .cnt-badge { background:var(--bg); border:1px solid var(--border); border-radius:20px; padding:1px 9px; font-size:11px; color:var(--muted); }
    table { width:100%; border-collapse:collapse; }
    thead th { background:#F8FAFC; font-size:11px; font-weight:600; color:var(--muted); text-align:left; padding:9px 14px; border-bottom:1px solid var(--border); white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9; transition:background 0.1s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#F8FAFF; }
    tbody td { padding:10px 14px; font-size:12px; color:var(--text); }
    .badge { display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:600; }
    .badge-draft     { background:#F1F5F9; color:#64748B; }
    .badge-confirmed { background:#EFF6FF; color:#2563EB; }
    .badge-picking   { background:#FFFBEB; color:#D97706; }
    .badge-shipped   { background:#ECFDF5; color:#059669; }
    .badge-cancelled { background:#FFF1F2; color:#E11D48; }
    .modal-bg { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:500; align-items:center; justify-content:center; }
    .modal-bg.open { display:flex; }
    .modal { background:var(--surface); width:440px; padding:24px; box-shadow:0 8px 32px rgba(0,0,0,0.18); }
    .modal-title { font-size:15px; font-weight:700; margin-bottom:18px; }
    .form-row { margin-bottom:12px; }
    .form-row label { display:block; font-size:11px; font-weight:600; color:var(--muted); margin-bottom:4px; }
    .form-row input, .form-row select { width:100%; height:34px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .form-row input:focus, .form-row select:focus { border-color:var(--blue); background:var(--surface); }
    .form-2col { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
    .modal-footer { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">판매 현황</div>
            <div class="page-sub">영업/재고 &gt; 판매 현황</div>
        </div>
        <button class="btn btn-primary" onclick="openInsertModal()">+ 수주 등록</button>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/sales/list.do">
        <div class="search-bar">
            <select name="searchStatus">
                <option value="">전체 상태</option>
                <option value="DRAFT"     ${searchVO.searchStatus eq 'DRAFT'     ? 'selected' : ''}>초안</option>
                <option value="CONFIRMED" ${searchVO.searchStatus eq 'CONFIRMED' ? 'selected' : ''}>확정</option>
                <option value="PICKING"   ${searchVO.searchStatus eq 'PICKING'   ? 'selected' : ''}>피킹중</option>
                <option value="SHIPPED"   ${searchVO.searchStatus eq 'SHIPPED'   ? 'selected' : ''}>출하완료</option>
                <option value="CANCELLED" ${searchVO.searchStatus eq 'CANCELLED' ? 'selected' : ''}>취소</option>
            </select>
            <input type="text" name="searchKeyword" value="${searchVO.searchKeyword}" placeholder="수주번호 / 고객명 검색">
            <input type="date" name="dateFrom" value="${searchVO.dateFrom}">
            <span style="font-size:12px;color:var(--muted)">~</span>
            <input type="date" name="dateTo"   value="${searchVO.dateTo}">
            <button type="submit" class="btn btn-primary">검색</button>
            <a href="${pageContext.request.contextPath}/sales/list.do" class="btn btn-outline">초기화</a>
            <span class="ml-auto" style="font-size:12px; color:var(--muted);">총 <strong>${totalCount}</strong>건</span>
        </div>
    </form>

    <div class="table-wrap">
        <div class="table-head">
            <span>수주 목록</span>
            <span class="cnt-badge">${totalCount}건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>No</th><th>수주번호</th><th>고객명</th><th>수주일</th><th>납기예정일</th><th>상태</th><th>작성자</th><th>등록일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty salesList}">
                        <tr><td colspan="8" style="text-align:center; padding:30px; color:var(--muted);">수주 내역이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="s" items="${salesList}" varStatus="st">
                            <tr>
                                <td style="color:var(--muted)">${st.index+1}</td>
                                <td><strong>${s.soNo}</strong></td>
                                <td>${s.customerName}</td>
                                <td>${s.orderDate}</td>
                                <td>${s.deliveryDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.status eq 'DRAFT'}">     <span class="badge badge-draft">초안</span></c:when>
                                        <c:when test="${s.status eq 'CONFIRMED'}"> <span class="badge badge-confirmed">확정</span></c:when>
                                        <c:when test="${s.status eq 'PICKING'}">   <span class="badge badge-picking">피킹중</span></c:when>
                                        <c:when test="${s.status eq 'SHIPPED'}">   <span class="badge badge-shipped">출하완료</span></c:when>
                                        <c:when test="${s.status eq 'CANCELLED'}"> <span class="badge badge-cancelled">취소</span></c:when>
                                        <c:otherwise><span class="badge badge-draft">${s.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color:var(--muted)">${s.createdBy}</td>
                                <td style="color:var(--muted)">${s.createdAt}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<!-- 수주 등록 모달 -->
<div class="modal-bg" id="insertModal">
    <div class="modal">
        <div class="modal-title">수주 등록</div>
        <form method="post" action="${pageContext.request.contextPath}/sales/insert.do">
            <div class="form-row"><label>수주번호 *</label><input type="text" name="soNo" placeholder="예: SO-2026-001" required></div>
            <div class="form-row"><label>고객 ID *</label><input type="number" name="customerId" placeholder="고객 ID 입력" required></div>
            <div class="form-2col">
                <div class="form-row"><label>수주일 *</label><input type="date" name="orderDate" required value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"></div>
                <div class="form-row"><label>납기예정일</label><input type="date" name="deliveryDate"></div>
            </div>
            <div class="form-row"><label>상태</label>
                <select name="status">
                    <option value="DRAFT">초안</option>
                    <option value="CONFIRMED">확정</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="document.getElementById('insertModal').classList.remove('open')">취소</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>

<script>
// PC: 모달, 모바일: 하단 시트형 모달 (같은 방식으로 통일)
function openInsertModal() {
    document.getElementById('insertModal').classList.add('open');
}

document.getElementById('insertModal').addEventListener('click',function(e){ if(e.target===this) this.classList.remove('open'); });
</script>

</div><%-- layout 닫기 --%>
</body>
</html>
