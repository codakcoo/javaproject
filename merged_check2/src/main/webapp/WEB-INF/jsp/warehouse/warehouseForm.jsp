<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex;align-items:center;gap:12px;margin-bottom:24px; }
    .btn-back { width:32px;height:32px;border-radius:8px;background:var(--surface);
                border:1px solid var(--border);display:flex;align-items:center;
                justify-content:center;cursor:pointer;text-decoration:none;
                color:var(--muted);transition:background .15s; }
    .btn-back:hover { background:var(--bg); }
    .btn-back svg { width:16px;height:16px;fill:currentColor; }
    .page-title { font-size:20px;font-weight:700;color:var(--text);letter-spacing:-.4px; }
    .page-sub   { font-size:13px;color:var(--muted);margin-top:3px; }
    .form-card { background:var(--surface);border:1px solid var(--border);border-radius:12px;
                 overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.05);max-width:760px; }
    .form-section { padding:20px 24px;border-bottom:1px solid var(--border); }
    .form-section:last-of-type { border-bottom:none; }
    .section-title { font-size:13px;font-weight:600;color:var(--navy);margin-bottom:16px;
                     padding-bottom:8px;border-bottom:2px solid var(--accent);display:inline-block; }
    .form-grid { display:grid;grid-template-columns:1fr 1fr;gap:16px; }
    .form-full { grid-column:1/-1; }
    .form-group { display:flex;flex-direction:column;gap:5px; }
    .form-group label { font-size:12px;font-weight:600;color:var(--muted); }
    .form-group label .req { color:#E11D48;margin-left:2px; }
    .form-group input,.form-group select,.form-group textarea {
        height:38px;padding:0 12px;border:1px solid var(--border);border-radius:8px;
        font-size:13px;font-family:inherit;color:var(--text);
        background:var(--bg);outline:none;transition:border-color .2s,box-shadow .2s;
    }
    .form-group input:focus,.form-group select:focus,.form-group textarea:focus {
        border-color:var(--accent);box-shadow:0 0 0 3px rgba(74,144,217,.12);background:var(--surface);
    }
    .form-group textarea { height:72px;padding:10px 12px;resize:vertical; }
    .form-actions { padding:16px 24px;background:#F8FAFC;border-top:1px solid var(--border);
                    display:flex;gap:10px;justify-content:flex-end; }
    .btn { height:38px;padding:0 20px;border-radius:8px;font-size:13px;font-family:inherit;
           font-weight:500;cursor:pointer;border:none;display:inline-flex;align-items:center;
           gap:6px;text-decoration:none;transition:opacity .15s; }
    .btn-primary { background:var(--accent);color:white; } .btn-primary:hover { opacity:.88; }
    .btn-outline { background:var(--surface);color:var(--text);border:1px solid var(--border); }
    .btn-outline:hover { background:var(--bg); }
</style>

<main id="content">
    <div class="page-header">
        <a href="${pageContext.request.contextPath}/warehouse/list.do" class="btn-back">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
        </a>
        <div>
            <div class="page-title">
                <c:choose><c:when test="${empty warehouse}">창고 등록</c:when><c:otherwise>창고 수정</c:otherwise></c:choose>
            </div>
            <div class="page-sub">창고 정보를 입력해주세요. <span style="color:#E11D48">*</span> 표시는 필수 항목입니다.</div>
        </div>
    </div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/warehouse/<c:choose><c:when test="${empty warehouse}">insert</c:when><c:otherwise>update</c:otherwise></c:choose>.do" method="post">
            <c:if test="${not empty warehouse}">
                <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
            </c:if>

            <div class="form-section">
                <div class="section-title">기본 정보</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>창고코드 <span class="req">*</span></label>
                        <input type="text" name="warehouseCode" value="${warehouse.warehouseCode}"
                               placeholder="예: WH-001"
                               <c:if test="${not empty warehouse}">readonly style="background:#F1F5F9;color:#94A3B8"</c:if>
                               required>
                    </div>
                    <div class="form-group">
                        <label>창고명 <span class="req">*</span></label>
                        <input type="text" name="warehouseName" value="${warehouse.warehouseName}" placeholder="창고명 입력" required>
                    </div>
                    <div class="form-group">
                        <label>창고 유형 <span class="req">*</span></label>
                        <select name="type" required>
                            <option value="">유형 선택</option>
                            <option value="MAIN"    <c:if test="${warehouse.type == 'MAIN'}">selected</c:if>>MAIN (본창고)</option>
                            <option value="DEFECT"  <c:if test="${warehouse.type == 'DEFECT'}">selected</c:if>>DEFECT (불량창고)</option>
                            <option value="RETURN"  <c:if test="${warehouse.type == 'RETURN'}">selected</c:if>>RETURN (반품창고)</option>
                            <option value="TRANSIT" <c:if test="${warehouse.type == 'TRANSIT'}">selected</c:if>>TRANSIT (이동중)</option>
                        </select>
                    </div>
                    <c:if test="${not empty warehouse}">
                    <div class="form-group">
                        <label>사용여부</label>
                        <select name="isActive">
                            <option value="1" <c:if test="${warehouse.isActive == 1}">selected</c:if>>활성</option>
                            <option value="0" <c:if test="${warehouse.isActive == 0}">selected</c:if>>비활성</option>
                        </select>
                    </div>
                    </c:if>
                    <div class="form-group form-full">
                        <label>위치 (주소·동·층·구역)</label>
                        <textarea name="location" placeholder="예: 경기도 이천시 마장면 ○○로 123, 2동 3층">${warehouse.location}</textarea>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/warehouse/list.do" class="btn btn-outline">취소</a>
                <button type="submit" class="btn btn-primary">
                    <c:choose><c:when test="${empty warehouse}">등록하기</c:when><c:otherwise>수정하기</c:otherwise></c:choose>
                </button>
            </div>
        </form>
    </div>
</main>

</div>
</body>
</html>
