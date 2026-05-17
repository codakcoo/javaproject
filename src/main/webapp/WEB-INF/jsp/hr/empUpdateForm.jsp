<!-- 직원 정보 수정 코드 (ADMIN) 권한만  -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-title { font-size: 20px; font-weight: 700; color: var(--text); letter-spacing: -0.4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; margin-bottom: 20px; }

    .form-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 28px;
        max-width: 600px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .form-group {
        margin-bottom: 18px;
    }
    .form-group label {
        display: block;
        font-size: 13px; font-weight: 600;
        color: var(--text); margin-bottom: 6px;
    }
    .form-group input, .form-group select {
        width: 100%; height: 38px;
        padding: 0 12px;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 13px; font-family: inherit;
        color: var(--text); background: var(--bg);
        outline: none;
        transition: border-color 0.2s;
        box-sizing: border-box;
    }
    .form-group input:focus, .form-group select:focus {
        border-color: var(--accent);
    }
    .form-group input[readonly] {
        background: #F1F5F9; color: var(--muted); cursor: not-allowed;
    }
    .admin-only {
        background: #FFFBEB;
        border: 1px solid #FDE68A;
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 18px;
    }
    .admin-only-title {
        font-size: 12px; font-weight: 700;
        color: #D97706; margin-bottom: 12px;
    }
    .btn-row {
        display: flex; gap: 10px; margin-top: 24px;
    }
    .btn { height: 38px; padding: 0 20px; border-radius: 8px; font-size: 13px;
           font-family: inherit; font-weight: 500; cursor: pointer; border: none;
           transition: opacity 0.15s; }
    .btn-primary { background: var(--accent); color: white; }
    .btn-primary:hover { opacity: 0.88; }
    .btn-outline { background: var(--surface); color: var(--text);
                   border: 1px solid var(--border); }
    .btn-outline:hover { background: var(--bg); }
      .btn-primary { 
        background: #2563EB !important; 
        color: white !important;
        display: inline-flex !important;
        visibility: visible !important;
    }
    
</style>

<main id="content">

    <div class="page-title">직원 정보 수정</div>
    <div class="page-sub">직원의 기본 정보를 수정합니다.</div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/hr/update.do" method="post">
            <input type="hidden" name="memberId" value="${member.memberId}">

            <!-- 기본 정보 (모두 수정 가능) -->
            <div class="form-group">
                <label>아이디</label>
                <input type="text" value="${member.memberId}" readonly>
            </div>
            <div class="form-group">
                <label>이름</label>
                <input type="text" name="name" value="${member.name}" required>
            </div>
            <div class="form-group">
                <label>이메일</label>
                <input type="email" name="email" value="${member.email}">
            </div>
            <div class="form-group">
                <label>전화번호</label>
                <input type="text" name="phone" value="${member.phone}">
            </div>
        <div class="form-group">
    <label>부서</label>
    <c:choose>
        <c:when test="${loginUser.role == 'ADMIN' or loginUser.department == '인사팀'}">
         <select name="department">
    <option value="">선택하세요</option>
    <c:forEach var="dept" items="${deptList}">
        <option value="${dept.deptName}" ${member.department == dept.deptName ? 'selected' : ''}>${dept.deptName}</option>
    </c:forEach>
</select>
            <select name="department">
                <option value="">선택하세요</option>
                <option value="개발팀" ${member.department == '개발팀' ? 'selected' : ''}>개발팀</option>
                <option value="인사팀" ${member.department == '인사팀' ? 'selected' : ''}>인사팀</option>
                <option value="영업팀" ${member.department == '영업팀' ? 'selected' : ''}>영업팀</option>
            </select>
        </c:when>
        <c:otherwise>
            <input type="text" value="${member.department}" readonly>
            <input type="hidden" name="department" value="${member.department}">
        </c:otherwise>
    </c:choose>
</div>

            <!-- ADMIN 및 인사팀 전용 (사번/직급/권한 수정) -->
          	<c:if test="${loginUser.role == 'ADMIN' or loginUser.department == '인사팀'}">
            <div class="admin-only">
                <div class="admin-only-title">⚙ 관리자 전용 — 사번 / 직급 / 권한</div>
                <div class="form-group">
                    <label>사번</label>
                    <input type="text" name="empNo" value="${member.empNo}" placeholder="예: EMP001">
                </div>
                <div class="form-group">
                    <label>직급</label>
                    <input type="text" name="position" value="${member.position}" placeholder="예: 과장">
                </div>
                <div class="form-group">
                    <label>권한</label>
                    <select name="role">
                        <option value="USER"  ${member.role == 'USER'  ? 'selected' : ''}>USER (일반)</option>
                        <option value="ADMIN" ${member.role == 'ADMIN' ? 'selected' : ''}>ADMIN (관리자)</option>
                    </select>
                </div>
            </div>
            </c:if>

            <div class="btn-row">
                <button type="submit" class="btn btn-primary">수정 완료</button>
                <button type="button" class="btn btn-outline"
                    onclick="location.href='${pageContext.request.contextPath}/hr/list.do'">취소</button>
            </div>
        </form>
    </div>

</main>

</div>
</body>
</html>