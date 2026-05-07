<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header {
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 12px; padding-bottom: 8px;
        border-bottom: 2px solid var(--blue);
    }
    .page-title { font-size: 15px; font-weight: 700; color: var(--text); }
    .page-sub   { font-size: 11px; color: var(--muted); margin-top: 2px; }

    /* ── 탭 ── */
    .tab-bar {
        display: flex; border-bottom: 2px solid var(--border);
        margin-bottom: 10px;
    }
    .tab-item {
        padding: 8px 16px; font-size: 12px; font-weight: 500;
        color: var(--muted); cursor: pointer; border: none; background: none;
        font-family: inherit; border-bottom: 2px solid transparent;
        margin-bottom: -2px; display: flex; align-items: center; gap: 5px;
        text-decoration: none; transition: color 0.15s;
    }
    .tab-item.active { color: var(--blue); border-bottom-color: var(--blue); font-weight: 700; }
    .tab-item:hover  { color: var(--text); }
    .tab-cnt {
        font-size: 10px; padding: 1px 5px; border-radius: 8px;
        font-weight: 700; color: white; background: var(--muted);
    }
    .tab-cnt.blue   { background: var(--blue); }
    .tab-cnt.orange { background: #F59E0B; }
    .tab-cnt.green  { background: #059669; }
    .tab-cnt.red    { background: #E11D48; }

    /* ── 검색 ── */
    .search-bar {
        background: var(--surface); border: 1px solid var(--border);
        padding: 8px 12px; margin-bottom: 8px;
        display: flex; gap: 6px; align-items: center; flex-wrap: wrap;
    }
    .search-bar label { font-size: 12px; color: var(--text-sm); }
    .search-bar select, .search-bar input {
        height: 26px; padding: 0 6px; border: 1px solid #BBBBBB;
        border-radius: 2px; font-size: 12px; font-family: inherit; outline: none;
    }
    .search-bar select:focus, .search-bar input:focus { border-color: var(--blue); }

    /* ── 테이블 ── */
    .tbl-wrap {
        border: 1px solid var(--border); overflow-x: auto;
        -webkit-overflow-scrolling: touch; background: var(--surface);
    }
    .tbl { min-width: 700px; } /* 모바일 가로 스와이프용 최소 너비 */

    /* ── 모달 ── */
    .modal-overlay {
        display: none; position: fixed; inset: 0; z-index: 400;
        background: rgba(0,0,0,0.5);
        align-items: center; justify-content: center;
    }
    .modal-overlay.active { display: flex; }
    .modal-box {
        background: white; width: 780px; max-width: 95vw;
        max-height: 90vh; border-radius: 4px;
        display: flex; flex-direction: column;
        box-shadow: 0 8px 40px rgba(0,0,0,0.25);
        overflow: hidden;
    }
    .modal-iframe {
        border: none; flex: 1;
        min-height: 640px;
    }

    /* ── 모바일 반응형 ── */
    @media (max-width: 768px) {
        .tab-bar { overflow-x: auto; -webkit-overflow-scrolling: touch; }
        .tab-item { white-space: nowrap; flex-shrink: 0; padding: 8px 10px; }
        .tbl { min-width: 600px; }
        .tbl thead th, .tbl tbody td { font-size: 11px; padding: 5px 6px; }
        .btn-sm { font-size: 10px; height: 20px; padding: 0 5px; }
    }
    .tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
    .tbl thead th {
        background: #F5F5F5; border: 1px solid #CCCCCC;
        padding: 6px 8px; font-weight: 600; color: #333;
        text-align: center; white-space: nowrap;
    }
    .tbl tbody td { border: 1px solid var(--border); padding: 5px 8px; vertical-align: middle; }
    .tbl tbody tr:hover { background: #F0F6FF; }
    .tbl-title { color: var(--blue); cursor: pointer; font-weight: 500; }
    .tbl-title:hover { text-decoration: underline; }

    /* ── 상태 배지 ── */
    .badge { display: inline-block; padding: 2px 7px; border-radius: 2px; font-size: 11px; font-weight: 600; }
    .badge-pending     { background: #FFF7ED; color: #D97706; border: 1px solid #FCD34D; }
    .badge-inprogress  { background: #EEF2FF; color: #4338CA; border: 1px solid #A5B4FC; }
    .badge-approved    { background: #ECFDF5; color: #059669; border: 1px solid #6EE7B7; }
    .badge-rejected    { background: #FFF1F2; color: #E11D48; border: 1px solid #FDA4AF; }
    .badge-draft       { background: #F5F5F5; color: #555;    border: 1px solid #CCC; }

    /* ── 문서유형 배지 ── */
    .dtype { display: inline-block; padding: 1px 6px; border-radius: 2px; font-size: 11px; font-weight: 600; }
    .dtype-inbound  { background: #E0F2F1; color: #00796B; border: 1px solid #80CBC4; }
    .dtype-outbound { background: #E3F2FD; color: #1565C0; border: 1px solid #90CAF9; }
    .dtype-stockadj { background: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }

    /* ── 버튼 ── */
    .btn-sm {
        height: 22px; padding: 0 8px; border-radius: 2px;
        font-size: 11px; font-family: inherit; font-weight: 500;
        cursor: pointer; border: 1px solid; white-space: nowrap;
    }
    .btn-view     { background: #EFF6FF; color: #2563EB; border-color: #93C5FD; }
    .btn-progress { background: #EEF2FF; color: #4338CA; border-color: #A5B4FC; }
    .btn-approve  { background: #ECFDF5; color: #059669; border-color: #6EE7B7; }
    .btn-reject   { background: #FFF1F2; color: #E11D48; border-color: #FDA4AF; }
    .btn-delete   { background: #F5F5F5; color: #555;    border-color: #CCC; }
</style>

<main id="content">

    <div class="page-header">
        <div>
            <div class="page-title">전자결재</div>
            <div class="page-sub">결재관리 &gt; 전자결재</div>
        </div>
        <button class="btn btn-primary" onclick="openForm()">+ 결재 문서 작성</button>
    </div>

    <!-- 탭 -->
    <div class="tab-bar">
        <a href="${pageContext.request.contextPath}/approval/list.do"
           class="tab-item ${activeTab == 'all' ? 'active' : ''}">
            전체
            <span class="tab-cnt ${activeTab == 'all' ? 'blue' : ''}">${tabCounts.total}</span>
        </a>
        <a href="${pageContext.request.contextPath}/approval/pending.do"
           class="tab-item ${activeTab == 'pending' ? 'active' : ''}">
            기안중
            <span class="tab-cnt orange">${tabCounts.pending}</span>
        </a>
        <a href="${pageContext.request.contextPath}/approval/inProgress.do"
           class="tab-item ${activeTab == 'inProgress' ? 'active' : ''}">
            진행중
            <span class="tab-cnt ${activeTab == 'inProgress' ? 'blue' : ''}">${tabCounts.inProgress}</span>
        </a>
        <a href="${pageContext.request.contextPath}/approval/rejected.do"
           class="tab-item ${activeTab == 'rejected' ? 'active' : ''}">
            반려
            <span class="tab-cnt red">${tabCounts.rejected}</span>
        </a>
        <a href="${pageContext.request.contextPath}/approval/approved.do"
           class="tab-item ${activeTab == 'approved' ? 'active' : ''}">
            결재
            <span class="tab-cnt green">${tabCounts.approved}</span>
        </a>
    </div>

    <!-- 검색 -->
    <form action="${pageContext.request.contextPath}/approval/${activeTab == 'pending' ? 'pending' : activeTab == 'inProgress' ? 'inProgress' : activeTab == 'rejected' ? 'rejected' : activeTab == 'approved' ? 'approved' : 'list'}.do" method="get">
    <div class="search-bar">
        <label>문서유형</label>
        <select name="searchDocType">
            <option value="">전체</option>
            <option value="INBOUND"   ${searchVO.searchDocType == 'INBOUND'   ? 'selected' : ''}>입고 요청서</option>
            <option value="OUTBOUND"  ${searchVO.searchDocType == 'OUTBOUND'  ? 'selected' : ''}>출고 요청서</option>
            <option value="STOCK_ADJ" ${searchVO.searchDocType == 'STOCK_ADJ' ? 'selected' : ''}>재고 조정서</option>
        </select>
        <label>제목</label>
        <input type="text" name="searchTitle" value="${searchVO.searchTitle}" placeholder="제목 검색" style="width:160px">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/approval/list.do" class="btn btn-outline">초기화</a>
        <span style="margin-left:auto;font-size:11px;color:var(--muted)">총 ${totalCount}건</span>
    </div>
    </form>

    <!-- 테이블 -->
    <div class="tbl-wrap">
        <table class="tbl">
            <thead>
                <tr>
                    <th style="width:50px">번호</th>
                    <th style="width:80px">문서번호</th>
                    <th style="width:80px">문서유형</th>
                    <th>제목</th>
                    <th style="width:70px">기안자</th>
                    <th style="width:70px">결재자</th>
                    <th style="width:80px">거래처</th>
                    <th style="width:75px">상태</th>
                    <th style="width:110px">기안일</th>
                    <th style="width:110px">처리일</th>
                    <th style="width:150px">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty docList}">
                        <tr>
                            <td colspan="11" align="center" style="padding:30px;color:var(--muted)">
                                결재 문서가 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${docList}" var="doc">
                        <tr>
                            <td align="center">${doc.docId}</td>
                            <td align="center" style="font-size:10px;color:var(--muted)">${doc.docNo}</td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${doc.docType == 'INBOUND'}">
                                        <span class="dtype dtype-inbound">입고</span>
                                    </c:when>
                                    <c:when test="${doc.docType == 'OUTBOUND'}">
                                        <span class="dtype dtype-outbound">출고</span>
                                    </c:when>
                                    <c:when test="${doc.docType == 'STOCK_ADJ'}">
                                        <span class="dtype dtype-stockadj">재고조정</span>
                                    </c:when>
                                    <c:otherwise><span class="dtype">-</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="tbl-title" onclick="viewDoc(${doc.docId})">${doc.title}</span>
                            </td>
                            <td align="center">${doc.requesterName}</td>
                            <td align="center">${empty doc.approverName ? '-' : doc.approverName}</td>
                            <td align="center" style="font-size:11px">${empty doc.partnerName ? '-' : doc.partnerName}</td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${doc.status == 'PENDING'}">
                                        <span class="badge badge-pending">기안중</span>
                                    </c:when>
                                    <c:when test="${doc.status == 'IN_PROGRESS'}">
                                        <span class="badge badge-inprogress">진행중</span>
                                    </c:when>
                                    <c:when test="${doc.status == 'APPROVED'}">
                                        <span class="badge badge-approved">결재</span>
                                    </c:when>
                                    <c:when test="${doc.status == 'REJECTED'}">
                                        <span class="badge badge-rejected">반려</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-draft">임시저장</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td align="center" style="font-size:11px">${doc.requestedAt}</td>
                            <td align="center" style="font-size:11px">${empty doc.approvedAt ? '-' : doc.approvedAt}</td>
                            <td>
                                <div style="display:flex;gap:3px;justify-content:center">
                                    <button class="btn-sm btn-view" onclick="viewDoc(${doc.docId})">보기</button>
                                    <c:if test="${doc.status == 'PENDING'}">
                                        <button class="btn-sm btn-progress" onclick="startReview(${doc.docId})">검토시작</button>
                                        <button class="btn-sm btn-reject"   onclick="rejectDoc(${doc.docId})">반려</button>
                                    </c:if>
                                    <c:if test="${doc.status == 'IN_PROGRESS'}">
                                        <button class="btn-sm btn-approve" onclick="approveDoc(${doc.docId})">승인</button>
                                        <button class="btn-sm btn-reject"  onclick="rejectDoc(${doc.docId})">반려</button>
                                    </c:if>
                                    <c:if test="${doc.status == 'DRAFT'}">
                                        <button class="btn-sm btn-delete" onclick="deleteDoc(${doc.docId})">삭제</button>
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

<!-- ── PC 모달 (결재 문서 작성) ── -->
<div class="modal-overlay" id="formModal" onclick="closeFormModal(event)">
    <div class="modal-box">
        <iframe id="formIframe" class="modal-iframe" src=""></iframe>
    </div>
</div>

<!-- ── PC 모달 (결재 문서 상세) ── -->
<div class="modal-overlay" id="detailModal" onclick="closeDetailModal(event)">
    <div class="modal-box">
        <iframe id="detailIframe" class="modal-iframe" src=""></iframe>
    </div>
</div>

<script>
const ctx = '${pageContext.request.contextPath}';
const isMobile = () => window.innerWidth <= 768;

/* ── 결재 문서 작성 ── */
function openForm() {
    if (isMobile()) {
        // 모바일: 페이지 이동
        location.href = ctx + '/approval/form.do';
    } else {
        // PC: 모달
        document.getElementById('formIframe').src = ctx + '/approval/form.do';
        document.getElementById('formModal').classList.add('active');
    }
}

/* 모달 외부 클릭 시 닫기 */
function closeFormModal(e) {
    if (e.target.id === 'formModal') {
        document.getElementById('formModal').classList.remove('active');
        document.getElementById('formIframe').src = '';
        location.reload(); // 기안 올린 경우 목록 새로고침
    }
}

/* iframe 내부(approvalForm)에서 호출: 기안 완료 후 모달 닫기 */
function onFormComplete() {
    document.getElementById('formModal').classList.remove('active');
    document.getElementById('formIframe').src = '';
    location.reload();
}

/* ── 결재 상세 보기 ── */
function viewDoc(docId) {
    if (isMobile()) {
        location.href = ctx + '/approval/detail.do?docId=' + docId;
    } else {
        document.getElementById('detailIframe').src = ctx + '/approval/detail.do?docId=' + docId;
        document.getElementById('detailModal').classList.add('active');
    }
}

function closeDetailModal(e) {
    if (e.target.id === 'detailModal') {
        document.getElementById('detailModal').classList.remove('active');
        document.getElementById('detailIframe').src = '';
        location.reload();
    }
}

/* iframe 내부(approvalDetail)에서 호출 */
function onDetailComplete() {
    document.getElementById('detailModal').classList.remove('active');
    document.getElementById('detailIframe').src = '';
    location.reload();
}

/* ESC 키로 모달 닫기 */
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.getElementById('formModal').classList.remove('active');
        document.getElementById('detailModal').classList.remove('active');
        document.getElementById('formIframe').src   = '';
        document.getElementById('detailIframe').src = '';
        location.reload();
    }
});

function startReview(docId) {
    if (!confirm('검토를 시작하시겠습니까? (기안중 → 진행중)')) return;
    fetch(ctx + '/approval/startReview.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + docId
    }).then(() => location.reload());
}

function approveDoc(docId) {
    if (!confirm('승인 처리하시겠습니까?')) return;
    fetch(ctx + '/approval/approve.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + docId
    }).then(() => location.reload());
}

function rejectDoc(docId) {
    var reason = prompt('반려 사유를 입력하세요:');
    if (!reason || !reason.trim()) return;
    fetch(ctx + '/approval/reject.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + docId + '&rejectReason=' + encodeURIComponent(reason)
    }).then(() => location.reload());
}

function deleteDoc(docId) {
    if (!confirm('삭제하시겠습니까?')) return;
    fetch(ctx + '/approval/delete.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + docId
    }).then(() => location.reload());
}
</script>

</div>
</body>
</html>
