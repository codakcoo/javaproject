<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:20px; }
    .page-title  { font-size:20px;font-weight:700;color:var(--text);letter-spacing:-.4px; }
    .page-sub    { font-size:13px;color:var(--muted);margin-top:3px; }

    .search-card { background:var(--surface);border:1px solid var(--border);border-radius:12px;
                   padding:16px 20px;margin-bottom:16px;display:flex;gap:10px;align-items:center;flex-wrap:wrap; }
    .search-card input,.search-card select { height:36px;padding:0 12px;border:1px solid var(--border);
        border-radius:8px;font-size:13px;font-family:inherit;color:var(--text);
        outline:none;background:var(--bg);transition:border-color .2s; }
    .search-card input:focus,.search-card select:focus { border-color:var(--accent); }
    .search-card input[type=text] { width:200px; }
    .search-card input[type=date] { width:140px; }
    .search-card select { width:140px; }

    .btn { height:36px;padding:0 16px;border-radius:8px;font-size:13px;font-family:inherit;
           font-weight:500;cursor:pointer;border:none;display:inline-flex;align-items:center;
           gap:6px;text-decoration:none;transition:opacity .15s,transform .1s; }
    .btn:active { transform:scale(.97); }
    .btn-primary { background:var(--accent);color:white; } .btn-primary:hover { opacity:.88; }
    .btn-outline { background:var(--surface);color:var(--text);border:1px solid var(--border); }
    .btn-outline:hover { background:var(--bg); }
    .btn-success { background:#059669;color:white; } .btn-success:hover { opacity:.88; }

    .table-card { background:var(--surface);border:1px solid var(--border);border-radius:12px;
                  overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.05); }
    .table-card-head { display:flex;align-items:center;justify-content:space-between;
                       padding:14px 20px;border-bottom:1px solid var(--border); }
    .table-card-head span { font-size:14px;font-weight:600;color:var(--text); }
    .total-badge { background:var(--bg);border:1px solid var(--border);border-radius:20px;
                   padding:2px 10px;font-size:12px;color:var(--muted); }

    table { width:100%;border-collapse:collapse; }
    thead th { background:#F8FAFC;font-size:12px;font-weight:600;color:var(--muted);
               text-align:left;padding:10px 16px;border-bottom:1px solid var(--border);white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9;transition:background .1s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#F8FAFF; }
    tbody td { padding:11px 16px;font-size:13px;color:var(--text); }

    .status-badge { display:inline-block;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600; }
    .s-DRAFT     { background:#F1F5F9;color:#64748B; }
    .s-CONFIRMED { background:#EFF6FF;color:#2563EB; }
    .s-PICKING   { background:#FFF7ED;color:#EA580C; }
    .s-SHIPPED   { background:#ECFDF5;color:#059669; }
    .s-CANCELLED { background:#FFF1F2;color:#E11D48; }

    /* 상태 변경 드롭다운 */
    .status-select {
        height:28px;padding:0 8px;border:1px solid var(--border);border-radius:6px;
        font-size:12px;font-family:inherit;color:var(--text);
        background:var(--bg);outline:none;cursor:pointer;
    }
    .status-select:focus { border-color:var(--accent); }

    .action-btns { display:flex;gap:6px;align-items:center; }
    .btn-edit { background:#EFF6FF;color:#2563EB;border:none;padding:4px 10px;border-radius:6px;
                font-size:12px;font-family:inherit;cursor:pointer;font-weight:500; }
    .btn-edit:hover { background:#DBEAFE; }

    .empty-row td { text-align:center;padding:48px;color:var(--muted);font-size:14px; }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">판매 현황</div>
            <div class="page-sub">수주서 목록을 조회하고 상태를 관리합니다.</div>
        </div>
        <a href="${pageContext.request.contextPath}/sales/insertForm.do" class="btn btn-success">+ 수주서 등록</a>
    </div>

    <form action="${pageContext.request.contextPath}/sales/list.do" method="get">
    <div class="search-card">
        <select name="status">
            <option value="">전체 상태</option>
            <option value="DRAFT"     <c:if test="${searchVO.status == 'DRAFT'}">selected</c:if>>임시저장</option>
            <option value="CONFIRMED" <c:if test="${searchVO.status == 'CONFIRMED'}">selected</c:if>>확정</option>
            <option value="PICKING"   <c:if test="${searchVO.status == 'PICKING'}">selected</c:if>>피킹중</option>
            <option value="SHIPPED"   <c:if test="${searchVO.status == 'SHIPPED'}">selected</c:if>>출고완료</option>
            <option value="CANCELLED" <c:if test="${searchVO.status == 'CANCELLED'}">selected</c:if>>취소</option>
        </select>
        <input type="text" name="keyword" value="${searchVO.keyword}" placeholder="수주번호 또는 고객명">
        <input type="date" name="fromDate" value="${searchVO.fromDate}">
        <span style="color:var(--muted);font-size:13px">~</span>
        <input type="date" name="toDate" value="${searchVO.toDate}">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/sales/list.do" class="btn btn-outline">초기화</a>
    </div>
    </form>

    <div class="table-card">
        <div class="table-card-head">
            <span>수주서 목록</span>
            <span class="total-badge">총 <strong>${empty salesList ? '0' : salesList.size()}</strong>건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>수주번호</th>
                    <th>고객명</th>
                    <th>수주일자</th>
                    <th>납기일자</th>
                    <th>상태</th>
                    <th>상태변경</th>
                    <th>작성자</th>
                    <th>등록일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty salesList}">
                        <tr class="empty-row"><td colspan="9">등록된 수주서가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${salesList}" var="so">
                        <tr>
                            <td><strong>${so.soNo}</strong></td>
                            <td>${so.customerName}</td>
                            <td>${so.orderDate}</td>
                            <td>${so.deliveryDate}</td>
                            <td>
                                <span class="status-badge s-${so.status}">
                                    <c:choose>
                                        <c:when test="${so.status == 'DRAFT'}">임시저장</c:when>
                                        <c:when test="${so.status == 'CONFIRMED'}">확정</c:when>
                                        <c:when test="${so.status == 'PICKING'}">피킹중</c:when>
                                        <c:when test="${so.status == 'SHIPPED'}">출고완료</c:when>
                                        <c:when test="${so.status == 'CANCELLED'}">취소</c:when>
                                        <c:otherwise>${so.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <select class="status-select" onchange="changeStatus(${so.soId}, this.value, '${so.soNo}')">
                                    <option value="DRAFT"     <c:if test="${so.status == 'DRAFT'}">selected</c:if>>임시저장</option>
                                    <option value="CONFIRMED" <c:if test="${so.status == 'CONFIRMED'}">selected</c:if>>확정</option>
                                    <option value="PICKING"   <c:if test="${so.status == 'PICKING'}">selected</c:if>>피킹중</option>
                                    <option value="SHIPPED"   <c:if test="${so.status == 'SHIPPED'}">selected</c:if>>출고완료</option>
                                    <option value="CANCELLED" <c:if test="${so.status == 'CANCELLED'}">selected</c:if>>취소</option>
                                </select>
                            </td>
                            <td style="color:var(--muted)">${so.createdByName}</td>
                            <td style="color:var(--muted)">${so.createdAt}</td>
                            <td>
                                <div class="action-btns">
                                    <button class="btn-edit"
                                        onclick="location.href='${pageContext.request.contextPath}/sales/updateForm.do?soId=${so.soId}'">수정</button>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<script>
const ctx = '${pageContext.request.contextPath}';

function changeStatus(soId, status, soNo) {
    const labels = { DRAFT:'임시저장', CONFIRMED:'확정', PICKING:'피킹중', SHIPPED:'출고완료', CANCELLED:'취소' };
    if (!confirm('[' + soNo + '] 상태를 "' + labels[status] + '"(으)로 변경하시겠습니까?')) {
        location.reload();
        return;
    }
    fetch(ctx + '/sales/updateStatus.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'soId=' + soId + '&status=' + status
    }).then(res => res.text()).then(result => {
        if (result === 'ok') location.reload();
        else alert('상태 변경 실패');
    }).catch(() => alert('서버 오류'));
}
</script>

</div>
</body>
</html>
