<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header {
        display: flex; align-items: center; gap: 12px;
        margin-bottom: 24px;
    }
    .btn-back {
        width: 32px; height: 32px; border-radius: 8px;
        background: var(--surface); border: 1px solid var(--border);
        display: flex; align-items: center; justify-content: center;
        cursor: pointer; text-decoration: none; color: var(--muted);
        transition: background 0.15s;
    }
    .btn-back:hover { background: var(--bg); }
    .btn-back svg { width: 16px; height: 16px; fill: currentColor; }

    .page-title { font-size: 20px; font-weight: 700; color: var(--text); letter-spacing: -0.4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; }

    /* 폼 카드 */
    .form-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        max-width: 760px;
    }

    .form-section {
        padding: 20px 24px;
        border-bottom: 1px solid var(--border);
    }
    .form-section:last-of-type { border-bottom: none; }

    .section-title {
        font-size: 13px; font-weight: 600; color: var(--navy);
        margin-bottom: 16px; padding-bottom: 8px;
        border-bottom: 2px solid var(--accent);
        display: inline-block;
    }

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }
    .form-grid.col3 { grid-template-columns: 1fr 1fr 1fr; }
    .form-full { grid-column: 1 / -1; }

    .form-group { display: flex; flex-direction: column; gap: 5px; }
    .form-group label {
        font-size: 12px; font-weight: 600; color: var(--muted);
    }
    .form-group label .req { color: #E11D48; margin-left: 2px; }

    .form-group input,
    .form-group select,
    .form-group textarea {
        height: 38px; padding: 0 12px;
        border: 1px solid var(--border); border-radius: 8px;
        font-size: 13px; font-family: inherit; color: var(--text);
        background: var(--bg); outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        border-color: var(--accent);
        box-shadow: 0 0 0 3px rgba(74,144,217,0.12);
        background: var(--surface);
    }
    .form-group textarea {
        height: 80px; padding: 10px 12px; resize: vertical;
    }

    /* 버튼 영역 */
    .form-actions {
        padding: 16px 24px;
        background: #F8FAFC;
        border-top: 1px solid var(--border);
        display: flex; gap: 10px; justify-content: flex-end;
    }

    .btn { height: 38px; padding: 0 20px; border-radius: 8px; font-size: 13px;
           font-family: inherit; font-weight: 500; cursor: pointer; border: none;
           display: inline-flex; align-items: center; gap: 6px; text-decoration: none;
           transition: opacity 0.15s; }
    .btn-primary { background: var(--accent); color: white; }
    .btn-primary:hover { opacity: 0.88; }
    .btn-outline { background: var(--surface); color: var(--text); border: 1px solid var(--border); }
    .btn-outline:hover { background: var(--bg); }
</style>

<main id="content">

    <div class="page-header">
        <a href="${pageContext.request.contextPath}/hr/list.do" class="btn-back">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
        </a>
        <div>
            <div class="page-title">
                <c:choose>
                    <c:when test="${empty emp}">직원 등록</c:when>
                    <c:otherwise>직원 수정</c:otherwise>
                </c:choose>
            </div>
            <div class="page-sub">직원 정보를 입력해주세요. <span style="color:#E11D48">*</span> 표시는 필수 항목입니다.</div>
        </div>
    </div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/hr/<c:choose><c:when test="${empty emp}">insert</c:when><c:otherwise>update</c:otherwise></c:choose>.do" method="post">
            <c:if test="${not empty emp}">
                <input type="hidden" name="empId" value="${emp.empId}">
            </c:if>

            <!-- 기본 정보 -->
            <div class="form-section">
                <div class="section-title">기본 정보</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>사번 <span class="req">*</span></label>
                        <input type="text" name="empId" value="${emp.empId}"
                               placeholder="예: EMP001"
                               <c:if test="${not empty emp}">readonly style="background:#F1F5F9;color:#94A3B8"</c:if>
                               required>
                    </div>
                    <div class="form-group">
                        <label>이름 <span class="req">*</span></label>
                        <input type="text" name="empName" value="${emp.empName}" placeholder="이름 입력" required>
                    </div>
                    <div class="form-group">
                        <label>부서 <span class="req">*</span></label>
                        <select name="deptId" required>
                            <option value="">부서 선택</option>
                            <%-- DB 연동 후 forEach로 교체 --%>
                            <option value="D001" <c:if test="${emp.deptId == 'D001'}">selected</c:if>>개발팀</option>
                            <option value="D002" <c:if test="${emp.deptId == 'D002'}">selected</c:if>>영업팀</option>
                            <option value="D003" <c:if test="${emp.deptId == 'D003'}">selected</c:if>>인사팀</option>
                            <option value="D004" <c:if test="${emp.deptId == 'D004'}">selected</c:if>>재무팀</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>직급 <span class="req">*</span></label>
                        <select name="position" required>
                            <option value="">직급 선택</option>
                            <option value="사원"  <c:if test="${emp.position == '사원'}">selected</c:if>>사원</option>
                            <option value="대리"  <c:if test="${emp.position == '대리'}">selected</c:if>>대리</option>
                            <option value="과장"  <c:if test="${emp.position == '과장'}">selected</c:if>>과장</option>
                            <option value="차장"  <c:if test="${emp.position == '차장'}">selected</c:if>>차장</option>
                            <option value="부장"  <c:if test="${emp.position == '부장'}">selected</c:if>>부장</option>
                            <option value="이사"  <c:if test="${emp.position == '이사'}">selected</c:if>>이사</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 연락처 정보 -->
            <div class="form-section">
                <div class="section-title">연락처 정보</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>연락처</label>
                        <input type="text" name="phone" value="${emp.phone}" placeholder="010-0000-0000">
                    </div>
                    <div class="form-group">
                        <label>이메일</label>
                        <input type="email" name="email" value="${emp.email}" placeholder="example@company.com">
                    </div>
                </div>
            </div>

            <!-- 인사 정보 -->
            <div class="form-section">
                <div class="section-title">인사 정보</div>
                <div class="form-grid col3">
                    <div class="form-group">
                        <label>입사일 <span class="req">*</span></label>
                        <input type="date" name="hireDate" value="${emp.hireDate}" required>
                    </div>
                    <div class="form-group">
                        <label>재직 상태</label>
                        <select name="status">
                            <option value="ACTIVE"  <c:if test="${emp.status == 'ACTIVE' || empty emp}">selected</c:if>>재직</option>
                            <option value="LEAVE"   <c:if test="${emp.status == 'LEAVE'}">selected</c:if>>휴직</option>
                            <option value="RESIGN"  <c:if test="${emp.status == 'RESIGN'}">selected</c:if>>퇴직</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>급여 (원)</label>
                        <input type="number" name="salary" value="${emp.salary}" placeholder="예: 3500000">
                    </div>
                    <div class="form-group form-full">
                        <label>비고</label>
                        <textarea name="remark" placeholder="특이사항 입력">${emp.remark}</textarea>
                    </div>
                </div>
            </div>

            <!-- 버튼 -->
            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/hr/list.do" class="btn btn-outline">취소</a>
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${empty emp}">등록하기</c:when>
                        <c:otherwise>수정하기</c:otherwise>
                    </c:choose>
                </button>
            </div>

        </form>
    </div>

</main>

</div>
</body>
</html>
