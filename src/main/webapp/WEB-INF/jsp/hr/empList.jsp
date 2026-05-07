<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header {
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 20px;
    }
    .page-title { font-size: 20px; font-weight: 700; color: var(--text); letter-spacing: -0.4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; }

    /* 검색 영역 */
    .search-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 16px 20px;
        margin-bottom: 16px;
        display: flex; gap: 10px; align-items: center; flex-wrap: wrap;
    }
    .search-card input, .search-card select {
        height: 36px; padding: 0 12px;
        border: 1px solid var(--border); border-radius: 8px;
        font-size: 13px; font-family: inherit; color: var(--text);
        outline: none; background: var(--bg);
        transition: border-color 0.2s;
    }
    .search-card input:focus, .search-card select:focus { border-color: var(--accent); }
    .search-card input { width: 200px; }
    .search-card select { width: 140px; }

    .btn { height: 36px; padding: 0 16px; border-radius: 8px; font-size: 13px;
           font-family: inherit; font-weight: 500; cursor: pointer; border: none;
           display: inline-flex; align-items: center; gap: 6px; text-decoration: none;
           transition: opacity 0.15s, transform 0.1s; }
    .btn:active { transform: scale(0.97); }
    .btn-primary { background: var(--accent); color: white; }
    .btn-primary:hover { opacity: 0.88; }
    .btn-outline { background: var(--surface); color: var(--text);
                   border: 1px solid var(--border); }
    .btn-outline:hover { background: var(--bg); }
    .btn-success { background: #059669; color: white; }
    .btn-success:hover { opacity: 0.88; }
    .btn-sm { height: 28px; padding: 0 10px; font-size: 12px; }

    .ml-auto { margin-left: auto; }

    /* 테이블 카드 */
    .table-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    /* ── 모바일 반응형 ── */
    @media (max-width: 768px) {
        .table-card { border-radius: 6px; }
        table { min-width: 620px; }
        thead th { font-size: 11px; padding: 8px 10px; }
        tbody td  { font-size: 11px; padding: 8px 10px; }
        .table-card-head { padding: 10px 12px; }
    }

    .table-card-head {
        display: flex; align-items: center; justify-content: space-between;
        padding: 14px 20px;
        border-bottom: 1px solid var(--border);
    }
    .table-card-head span { font-size: 14px; font-weight: 600; color: var(--text); }
    .total-badge {
        background: var(--bg); border: 1px solid var(--border);
        border-radius: 20px; padding: 2px 10px;
        font-size: 12px; color: var(--muted);
    }

    table { width: 100%; border-collapse: collapse; }
    thead th {
        background: #F8FAFC; font-size: 12px; font-weight: 600;
        color: var(--muted); text-align: left; padding: 10px 16px;
        border-bottom: 1px solid var(--border); white-space: nowrap;
    }
    tbody tr { border-bottom: 1px solid #F1F5F9; transition: background 0.1s; }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: #F8FAFF; }
    tbody td { padding: 11px 16px; font-size: 13px; color: var(--text); }

    .status-badge {
        display: inline-block; padding: 3px 9px;
        border-radius: 20px; font-size: 11px; font-weight: 600;
    }
    .status-active  { background: #ECFDF5; color: #059669; }
    .status-leave   { background: #FFF7ED; color: #EA580C; }
    .status-resign  { background: #F1F5F9; color: #94A3B8; }

    .action-btns { display: flex; gap: 6px; }

    .btn-edit { background: #EFF6FF; color: #2563EB; border: none;
                padding: 4px 10px; border-radius: 6px; font-size: 12px;
                font-family: inherit; cursor: pointer; font-weight: 500;
                transition: background 0.15s; }
    .btn-edit:hover { background: #DBEAFE; }

    .btn-del  { background: #FFF1F2; color: #E11D48; border: none;
                padding: 4px 10px; border-radius: 6px; font-size: 12px;
                font-family: inherit; cursor: pointer; font-weight: 500;
                transition: background 0.15s; }
    .btn-del:hover { background: #FFE4E6; }

    .btn-approval { background: #FFF7ED; color: #EA580C; border: none;
                    padding: 4px 10px; border-radius: 6px; font-size: 12px;
                    font-family: inherit; cursor: pointer; font-weight: 500;
                    transition: background 0.15s; }
    .btn-approval:hover { background: #FFEDD5; }

    /* 빈 데이터 */
    .empty-row td { text-align: center; padding: 48px; color: var(--muted); font-size: 14px; }
</style>

<main id="content">

    <div class="page-header">
        <div>
            <div class="page-title">직원 목록</div>
            <div class="page-sub">전체 직원 목록을 조회하고 관리합니다.</div>
        </div>
        <a href="${pageContext.request.contextPath}/hr/insertForm.do" class="btn btn-success">
            + 직원 등록
        </a>
    </div>

    <!-- 검색 -->
    <form action="${pageContext.request.contextPath}/hr/list.do" method="get">
    <div class="search-card">
        <select name="deptId">
            <option value="">전체 부서</option>
            <%-- DB 연동 후 아래 주석 해제 --%>
            <%--
            <c:forEach items="${deptList}" var="dept">
                <option value="${dept.deptId}" <c:if test="${param.deptId == dept.deptId}">selected</c:if>>${dept.deptName}</option>
            </c:forEach>
            --%>
            <option value="D001">개발팀</option>
            <option value="D002">영업팀</option>
            <option value="D003">인사팀</option>
        </select>
        <select name="status">
            <option value="">전체 상태</option>
            <option value="ACTIVE"  <c:if test="${param.status == 'ACTIVE'}">selected</c:if>>재직</option>
            <option value="LEAVE"   <c:if test="${param.status == 'LEAVE'}">selected</c:if>>휴직</option>
            <option value="RESIGN"  <c:if test="${param.status == 'RESIGN'}">selected</c:if>>퇴직</option>
        </select>
        <input type="text" name="keyword" value="${param.keyword}" placeholder="이름 또는 사번 검색">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/hr/list.do" class="btn btn-outline">초기화</a>
    </div>
    </form>

    <!-- 테이블 -->
    <div class="table-card">
        <div class="table-card-head">
            <span>직원 목록</span>
            <span class="total-badge">총 <strong>${empty empList ? '0' : empList.size()}</strong>명</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>사번</th>
                    <th>이름</th>
                    <th>부서</th>
                    <th>직급</th>
                    <th>입사일</th>
                    <th>연락처</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty empList}">
                        <%-- 데이터 없을 때 (DB 연동 전 임시 샘플) --%>
                        <tr>
                            <td>EMP001</td>
                            <td>홍길동</td>
                            <td>개발팀</td>
                            <td>과장</td>
                            <td>2022-03-02</td>
                            <td>010-1234-5678</td>
                            <td><span class="status-badge status-active">재직</span></td>
                            <td>
                                <div class="action-btns">
                                    <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/hr/updateForm.do?empId=EMP001'">수정</button>
                                    <button class="btn-approval" onclick="openApproval('EMP001')">결재</button>
                                    <button class="btn-del" onclick="deleteEmp('EMP001')">삭제</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>EMP002</td>
                            <td>김철수</td>
                            <td>영업팀</td>
                            <td>대리</td>
                            <td>2023-01-09</td>
                            <td>010-9876-5432</td>
                            <td><span class="status-badge status-active">재직</span></td>
                            <td>
                                <div class="action-btns">
                                    <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/hr/updateForm.do?empId=EMP002'">수정</button>
                                    <button class="btn-approval" onclick="openApproval('EMP002')">결재</button>
                                    <button class="btn-del" onclick="deleteEmp('EMP002')">삭제</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>EMP003</td>
                            <td>이영희</td>
                            <td>인사팀</td>
                            <td>차장</td>
                            <td>2020-07-01</td>
                            <td>010-5555-7777</td>
                            <td><span class="status-badge status-leave">휴직</span></td>
                            <td>
                                <div class="action-btns">
                                    <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/hr/updateForm.do?empId=EMP003'">수정</button>
                                    <button class="btn-approval" onclick="openApproval('EMP003')">결재</button>
                                    <button class="btn-del" onclick="deleteEmp('EMP003')">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <%-- DB 연동 후 실제 데이터 --%>
                        <c:forEach items="${empList}" var="emp">
                        <tr>
                            <td>${emp.empId}</td>
                            <td>${emp.empName}</td>
                            <td>${emp.deptName}</td>
                            <td>${emp.position}</td>
                            <td>${emp.hireDate}</td>
                            <td>${emp.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.status == 'ACTIVE'}"><span class="status-badge status-active">재직</span></c:when>
                                    <c:when test="${emp.status == 'LEAVE'}"><span class="status-badge status-leave">휴직</span></c:when>
                                    <c:otherwise><span class="status-badge status-resign">퇴직</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/hr/updateForm.do?empId=${emp.empId}'">수정</button>
                                    <button class="btn-approval" onclick="openApproval('${emp.empId}')">결재</button>
                                    <form action="${pageContext.request.contextPath}/hr/delete.do" method="post" style="display:inline">
                                        <input type="hidden" name="empId" value="${emp.empId}">
                                        <button type="submit" class="btn-del" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                                    </form>
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
// 삭제 처리 (DB 미연동 시 alert)
function deleteEmp(empId) {
    if(confirm('정말 삭제하시겠습니까?')) {
        // DB 연동 후 form submit으로 교체
        alert('DB 연동 후 삭제 처리됩니다. empId: ' + empId);
    }
}

// 전자결재 팝업 (PC: 모달, 모바일: 페이지 이동)
function openApproval(empId) {
    var url = '${pageContext.request.contextPath}/approval/form.do?empId=' + empId;
    if (window.innerWidth <= 768) {
        location.href = url;
    } else {
        window.open(url, 'approvalPopup',
            'width=720,height=640,top=100,left=300,scrollbars=yes,resizable=no');
    }
}
</script>

</div><%-- layout 닫기 --%>
</body>
</html>
