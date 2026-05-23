<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:16px; }
    .page-title  { font-size:18px; font-weight:700; color:var(--text); }
    .page-sub    { font-size:12px; color:var(--muted); margin-top:2px; }
    .search-bar  { background:var(--surface); border:1px solid var(--border); padding:12px 16px; margin-bottom:12px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
    .search-bar input, .search-bar select { height:32px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .search-bar input:focus, .search-bar select:focus { border-color:var(--blue); }
    .search-bar input  { width:200px; }
    .search-bar select { width:120px; }
    .btn { height:32px; padding:0 14px; font-size:12px; font-family:inherit; font-weight:500; cursor:pointer; border:none; display:inline-flex; align-items:center; gap:5px; text-decoration:none; transition:opacity 0.15s; }
    .btn-primary { background:var(--blue); color:white; } .btn-primary:hover { opacity:0.85; }
    .btn-outline { background:var(--surface); color:var(--text); border:1px solid var(--border); } .btn-outline:hover { background:var(--bg); }
    .ml-auto { margin-left:auto; }
    .table-wrap { background:var(--surface); border:1px solid var(--border); overflow-x:auto; -webkit-overflow-scrolling:touch; }
    .table-head { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; border-bottom:1px solid var(--border); }
    .table-head span { font-size:13px; font-weight:600; }
    .cnt-badge { background:var(--bg); border:1px solid var(--border); border-radius:20px; padding:1px 9px; font-size:11px; color:var(--muted); }
    table { width:100%; border-collapse:collapse; min-width:650px; }
    thead th { background:#F8FAFC; font-size:11px; font-weight:600; color:var(--muted); text-align:left; padding:9px 14px; border-bottom:1px solid var(--border); white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9; transition:background 0.1s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#F8FAFF; }
    tbody td { padding:10px 14px; font-size:12px; color:var(--text); }
    .badge { display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:600; }
    .badge-active   { background:#ECFDF5; color:#059669; }
    .badge-inactive { background:#F1F5F9; color:#94A3B8; }
    .action-btns { display:flex; gap:5px; }
    .btn-edit { background:#EFF6FF; color:#2563EB; border:none; padding:3px 9px; font-size:11px; font-family:inherit; cursor:pointer; font-weight:500; }
    .btn-edit:hover { background:#DBEAFE; }
    .btn-del  { background:#FFF1F2; color:#E11D48; border:none; padding:3px 9px; font-size:11px; font-family:inherit; cursor:pointer; font-weight:500; }
    .btn-del:hover  { background:#FFE4E6; }
    .modal-bg { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:500; align-items:center; justify-content:center; }
    .modal-bg.open  { display:flex; }
    .modal { background:var(--surface); width:460px; padding:24px; box-shadow:0 8px 32px rgba(0,0,0,0.18); }
    .modal-title  { font-size:15px; font-weight:700; margin-bottom:18px; }
    .form-row { margin-bottom:12px; }
    .form-row label { display:block; font-size:11px; font-weight:600; color:var(--muted); margin-bottom:4px; }
    .form-row input, .form-row select { width:100%; height:34px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); box-sizing:border-box; }
    .form-row input:focus, .form-row select:focus { border-color:var(--blue); background:var(--surface); }
    .form-2col { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
    .modal-footer { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }
    .partner-link { text-decoration:none; color:inherit; display:flex; align-items:center; gap:6px; }
    .partner-link:hover strong { color:var(--blue); text-decoration:underline; }
    .trade-hint { font-size:10px; color:var(--muted); opacity:0; transition:opacity 0.15s; white-space:nowrap; }
    .partner-link:hover .trade-hint { opacity:1; color:var(--blue); }
    .info-tip { font-size:11px; color:var(--muted); margin-top:12px; padding:8px 12px; background:#FFFBEB; border-left:3px solid #F59E0B; }
    @media (max-width:768px) {
        .modal-bg { align-items:flex-end !important; }
        .modal { width:100% !important; max-width:100vw !important; max-height:85vh !important;
                 overflow-y:auto !important; border-radius:12px 12px 0 0 !important; padding:20px 16px !important; }
        .form-2col { grid-template-columns:1fr; }
    }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">고객사 관리</div>
            <div class="page-sub">영업/재고 &gt; 거래처 관리 &gt; 고객사 (수주)</div>
        </div>
        <button class="btn btn-primary" onclick="openInsertModal()">+ 고객사 등록</button>
    </div>

    <div class="info-tip">
        고객사는 <strong>수주(출고) 결재서 작성</strong> 시 거래처 드롭다운에 표시됩니다.
        비활성화 처리 시 기존 결재 이력은 보존되며, 신규 결재서 작성에서만 제외됩니다.
    </div>

    <form method="get" action="${pageContext.request.contextPath}/partner/customer/list.do" style="margin-top:12px;">
        <div class="search-bar">
            <input type="text" name="searchKeyword" value="${searchVO.searchKeyword}" placeholder="업체명 / 담당자 / 전화번호">
            <select name="searchActive">
                <option value="">전체 상태</option>
                <option value="1" ${searchVO.searchActive eq '1' ? 'selected' : ''}>활성</option>
                <option value="0" ${searchVO.searchActive eq '0' ? 'selected' : ''}>비활성</option>
            </select>
            <button type="submit" class="btn btn-primary">검색</button>
            <a href="${pageContext.request.contextPath}/partner/customer/list.do" class="btn btn-outline">초기화</a>
            <span class="ml-auto" style="font-size:12px; color:var(--muted);">총 <strong>${totalCount}</strong>개</span>
        </div>
    </form>

    <div class="table-wrap">
        <div class="table-head">
            <span>고객사 목록</span>
            <span class="cnt-badge">${totalCount}건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>업체명</th>
                    <th>담당자</th>
                    <th>전화번호</th>
                    <th>주소</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty customerList}">
                        <tr><td colspan="7" style="text-align:center; padding:30px; color:var(--muted);">등록된 고객사가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${customerList}">
                            <tr>
                                <td style="color:var(--muted)">${c.customerId}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/partner/customer/trades.do?customerId=${c.customerId}"
                                       class="partner-link">
                                        <strong>${c.customerName}</strong>
                                        <span class="trade-hint">거래이력 →</span>
                                    </a>
                                </td>
                                <td>${empty c.contact ? '-' : c.contact}</td>
                                <td>${empty c.phone   ? '-' : c.phone}</td>
                                <td style="max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"
                                    title="${c.address}">${empty c.address ? '-' : c.address}</td>
                                <td>
                                    <span class="badge ${c.isActive eq 1 ? 'badge-active' : 'badge-inactive'}">
                                        ${c.isActive eq 1 ? '활성' : '비활성'}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-edit"
                                            onclick="openUpdateModal(${c.customerId},'${c.customerName}','${c.contact}','${c.phone}','${c.address}',${c.isActive})">
                                            수정
                                        </button>
                                        <c:if test="${c.isActive eq 1}">
                                            <button class="btn-del" onclick="doDeactivate(${c.customerId},'${c.customerName}')">비활성화</button>
                                        </c:if>
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

<!-- 등록 모달 -->
<div class="modal-bg" id="insertModal">
    <div class="modal">
        <div class="modal-title">고객사 등록</div>
        <form method="post" action="${pageContext.request.contextPath}/partner/customer/insert.do">
            <div class="form-row">
                <label>업체명 *</label>
                <input type="text" name="customerName" required placeholder="예) (주)대전상사">
            </div>
            <div class="form-2col">
                <div class="form-row">
                    <label>담당자</label>
                    <input type="text" name="contact" placeholder="예) 홍길동">
                </div>
                <div class="form-row">
                    <label>전화번호</label>
                    <input type="text" name="phone" placeholder="예) 042-000-0000">
                </div>
            </div>
            <div class="form-row">
                <label>주소</label>
                <input type="text" name="address" placeholder="예) 대전광역시 유성구 ...">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('insertModal')">취소</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>

<!-- 수정 모달 -->
<div class="modal-bg" id="updateModal">
    <div class="modal">
        <div class="modal-title">고객사 수정</div>
        <form method="post" action="${pageContext.request.contextPath}/partner/customer/update.do">
            <input type="hidden" name="customerId" id="u_id">
            <div class="form-row">
                <label>업체명 *</label>
                <input type="text" name="customerName" id="u_name" required>
            </div>
            <div class="form-2col">
                <div class="form-row">
                    <label>담당자</label>
                    <input type="text" name="contact" id="u_contact">
                </div>
                <div class="form-row">
                    <label>전화번호</label>
                    <input type="text" name="phone" id="u_phone">
                </div>
            </div>
            <div class="form-row">
                <label>주소</label>
                <input type="text" name="address" id="u_address">
            </div>
            <div class="form-row">
                <label>상태</label>
                <select name="isActive" id="u_active">
                    <option value="1">활성</option>
                    <option value="0">비활성</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('updateModal')">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>

<!-- 비활성화 폼 -->
<form id="deactivateForm" method="post" action="${pageContext.request.contextPath}/partner/customer/deactivate.do">
    <input type="hidden" name="customerId" id="del_id">
</form>

<script>
function openInsertModal() {
    document.getElementById('insertModal').classList.add('open');
}
function openUpdateModal(id, name, contact, phone, address, active) {
    document.getElementById('u_id').value      = id;
    document.getElementById('u_name').value    = name;
    document.getElementById('u_contact').value = contact;
    document.getElementById('u_phone').value   = phone;
    document.getElementById('u_address').value = address;
    document.getElementById('u_active').value  = active;
    document.getElementById('updateModal').classList.add('open');
}
function doDeactivate(id, name) {
    if (!confirm('[' + name + '] 을(를) 비활성화하시겠습니까?\n\n기존 수주 이력은 보존됩니다.')) return;
    document.getElementById('del_id').value = id;
    document.getElementById('deactivateForm').submit();
}
function closeModal(id) {
    document.getElementById(id).classList.remove('open');
}
document.querySelectorAll('.modal-bg').forEach(function(bg) {
    bg.addEventListener('click', function(e) { if (e.target === this) this.classList.remove('open'); });
});
</script>

</div>
</body>
</html>
