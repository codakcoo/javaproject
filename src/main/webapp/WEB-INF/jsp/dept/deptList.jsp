<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-title { font-size: 20px; font-weight: 700; color: var(--text); letter-spacing: -0.4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; margin-bottom: 20px; }
    .table-card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); overflow: hidden; margin-bottom: 20px; }
    .table-card-head { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-bottom: 1px solid var(--border); }
    .table-card-head span { font-size: 14px; font-weight: 600; color: var(--text); }
    .table-wrap { overflow-x: auto; -webkit-overflow-scrolling: touch; width: 100%; }
    table { width: 100%; border-collapse: collapse; min-width: 500px; }
    thead th { background: #F8FAFC; font-size: 12px; font-weight: 600; color: var(--muted); text-align: left; padding: 10px 16px; border-bottom: 1px solid var(--border); }
    tbody tr { border-bottom: 1px solid #F1F5F9; transition: background 0.1s; }
    tbody tr:hover { background: #F8FAFF; }
    tbody td { padding: 11px 16px; font-size: 13px; color: var(--text); }
    .action-btns { display: flex; gap: 6px; }
    .btn-edit { background: #EFF6FF; color: #2563EB; border: none; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-family: inherit; cursor: pointer; font-weight: 500; }
    .btn-del  { background: #FFF1F2; color: #E11D48; border: none; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-family: inherit; cursor: pointer; font-weight: 500; }
    .add-card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
    .add-card h3 { font-size: 15px; font-weight: 700; margin-bottom: 16px; color: var(--text); }
    .form-row { display: flex; gap: 10px; align-items: flex-end; flex-wrap: wrap; }
    .form-group { display: flex; flex-direction: column; gap: 6px; }
    .form-group label { font-size: 12px; font-weight: 600; color: var(--text); }
    .form-group input, .form-group select { height: 36px; padding: 0 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 13px; font-family: inherit; outline: none; }
    .btn-add { height: 36px; padding: 0 20px; background: #059669; color: white; border: none; border-radius: 8px; font-size: 13px; font-family: inherit; font-weight: 600; cursor: pointer; }

    /* 수정 모달 */
    .modal-bg { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 999; align-items: center; justify-content: center; }
    .modal-bg.active { display: flex; }
    .modal { background: white; border-radius: 16px; padding: 32px; width: 400px; max-width: 90%; box-shadow: 0 8px 32px rgba(0,0,0,0.18); }
    .modal h3 { font-size: 16px; font-weight: 700; margin-bottom: 20px; color: var(--text); }
    .modal .form-group { margin-bottom: 14px; }
    .modal .form-group input, .modal .form-group select { width: 100%; box-sizing: border-box; }
    .modal-btns { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; }
    .modal-btn-cancel { padding: 8px 20px; border-radius: 8px; font-size: 13px; font-family: inherit; cursor: pointer; background: #F1F5F9; color: #64748B; border: none; }
    .modal-btn-save { padding: 8px 20px; border-radius: 8px; font-size: 13px; font-family: inherit; cursor: pointer; background: #2563EB; color: white; border: none; font-weight: 600; }
</style>

<!-- 수정 모달 -->
<div class="modal-bg" id="editModal">
    <div class="modal">
        <h3>부서 수정</h3>
        <form id="editForm" action="${pageContext.request.contextPath}/dept/update.do" method="post">
            <input type="hidden" id="editDeptId" name="deptId">
            <div class="form-group">
                <label>부서코드</label>
                <input type="text" id="editDeptIdShow" readonly style="background:#F1F5F9; color:#94A3B8;">
            </div>
            <div class="form-group">
                <label>부서명</label>
                <input type="text" id="editDeptName" name="deptName" required>
            </div>
        </form>
        <div class="modal-btns">
            <button class="modal-btn-cancel" onclick="closeEditModal()">취소</button>
            <button class="modal-btn-save" onclick="document.getElementById('editForm').submit()">저장</button>
        </div>
    </div>
</div>

<main id="content">
    <div class="page-title">부서 관리</div>
    <div class="page-sub">부서 목록을 조회하고 추가/수정/삭제합니다.</div>

    <!-- 부서 목록 -->
    <div class="table-card">
        <div class="table-card-head">
            <span>부서 목록</span>
            <span style="font-size:12px; color:var(--muted);">총 <strong>${empty deptList ? '0' : deptList.size()}</strong>개</span>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>부서코드</th>
                        <th>부서명</th>
                        <th>부서장</th>
                        <th>소속 직원 수</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty deptList}">
                            <tr><td colspan="5" style="text-align:center; padding:48px; color:#999;">부서 데이터가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="dept" items="${deptList}">
                                <tr>
                                    <td>${dept.deptId}</td>
                                    <td>${dept.deptName}</td>
                                    <td>${empty dept.managerName ? '-' : dept.managerName}</td>
                                    <td>${dept.empCount}명</td>
                                    <td>
                                        <div class="action-btns">
                                            <c:if test="${loginUser.role == 'ADMIN' or loginUser.department == '인사팀'}">
                                                <button class="btn-edit"
                                                    onclick="openEditModal('${dept.deptId}', '${dept.deptName}')">수정</button>
                                                <form action="${pageContext.request.contextPath}/dept/delete.do" method="post" style="display:inline">
                                                    <input type="hidden" name="deptId" value="${dept.deptId}">
                                                    <button type="submit" class="btn-del"
                                                        onclick="return confirm('${dept.deptName} 부서를 삭제하시겠습니까?\\n소속 직원이 있으면 삭제할 수 없습니다.')">삭제</button>
                                                </form>
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
    </div>

    <!-- 부서 추가 (ADMIN/인사팀만) -->
    <c:if test="${loginUser.role == 'ADMIN' or loginUser.department == '인사팀'}">
    <div class="add-card">
        <h3>부서 추가</h3>
        <form action="${pageContext.request.contextPath}/dept/insert.do" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>부서코드</label>
                    <input type="text" name="deptId" placeholder="예: D004" required style="width:120px;">
                </div>
                <div class="form-group">
                    <label>부서명</label>
                    <input type="text" name="deptName" placeholder="예: 기획팀" required style="width:160px;">
                </div>
                <button type="submit" class="btn-add">+ 추가</button>
            </div>
        </form>
    </div>
    </c:if>
</main>

<script>
function openEditModal(deptId, deptName) {
    document.getElementById('editDeptId').value = deptId;
    document.getElementById('editDeptIdShow').value = deptId;
    document.getElementById('editDeptName').value = deptName;
    document.getElementById('editModal').classList.add('active');
}
function closeEditModal() {
    document.getElementById('editModal').classList.remove('active');
}
document.getElementById('editModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditModal();
});
</script>

</div>
</body>
</html>
