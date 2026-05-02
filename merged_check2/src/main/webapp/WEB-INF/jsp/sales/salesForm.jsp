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
    .form-group input,.form-group select {
        height:38px;padding:0 12px;border:1px solid var(--border);border-radius:8px;
        font-size:13px;font-family:inherit;color:var(--text);
        background:var(--bg);outline:none;transition:border-color .2s,box-shadow .2s;
    }
    .form-group input:focus,.form-group select:focus {
        border-color:var(--accent);box-shadow:0 0 0 3px rgba(74,144,217,.12);background:var(--surface);
    }
    .help-text { font-size:11px;color:var(--muted);margin-top:3px; }

    .so-no-box {
        height:38px;padding:0 12px;border:1px solid var(--border);border-radius:8px;
        font-size:13px;color:#94A3B8;background:#F1F5F9;
        display:flex;align-items:center;
    }

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
        <a href="${pageContext.request.contextPath}/sales/list.do" class="btn-back">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
        </a>
        <div>
            <div class="page-title">
                <c:choose><c:when test="${empty salesOrder}">수주서 등록</c:when><c:otherwise>수주서 수정</c:otherwise></c:choose>
            </div>
            <div class="page-sub">수주서 정보를 입력해주세요. <span style="color:#E11D48">*</span> 표시는 필수 항목입니다.</div>
        </div>
    </div>

    <div class="form-card">
        <c:set var="formAction" value="${empty salesOrder ? 'insert' : 'update'}"/>
        <form action="${pageContext.request.contextPath}/sales/${formAction}.do" method="post">
            <c:if test="${not empty salesOrder}">
                <input type="hidden" name="soId" value="${salesOrder.soId}">
            </c:if>

            <!-- 수주 기본 정보 -->
            <div class="form-section">
                <div class="section-title">수주 정보</div>
                <div class="form-grid">

                    <!-- 수주번호: 등록 시 자동생성 안내, 수정 시 표시 -->
                    <div class="form-group">
                        <label>수주번호</label>
                        <div class="so-no-box">
                            <c:choose>
                                <c:when test="${empty salesOrder}">등록 시 자동 생성 (SO-YYYY-NNN)</c:when>
                                <c:otherwise>${salesOrder.soNo}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 고객 선택 -->
                    <div class="form-group">
                        <label>고객 <span class="req">*</span></label>
                        <select name="customerId" required>
                            <option value="">고객 선택</option>
                            <c:forEach items="${customerList}" var="c">
                                <c:if test="${c.isActive == 1}">
                                <option value="${c.customerId}"
                                    <c:if test="${salesOrder.customerId == c.customerId}">selected</c:if>>
                                    ${c.customerName}
                                    <c:if test="${not empty c.phone}"> (${c.phone})</c:if>
                                </option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 수주일자 -->
                    <div class="form-group">
                        <label>수주일자 <span class="req">*</span></label>
                        <input type="date" name="orderDate" value="${salesOrder.orderDate}" required>
                    </div>

                    <!-- 납기일자 -->
                    <div class="form-group">
                        <label>납기예정일</label>
                        <input type="date" name="deliveryDate" value="${salesOrder.deliveryDate}">
                        <span class="help-text">미입력 시 납기일 미정으로 처리</span>
                    </div>

                </div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/sales/list.do" class="btn btn-outline">취소</a>
                <button type="submit" class="btn btn-primary">
                    <c:choose><c:when test="${empty salesOrder}">등록하기</c:when><c:otherwise>수정하기</c:otherwise></c:choose>
                </button>
            </div>
        </form>
    </div>
</main>

</div>
</body>
</html>
