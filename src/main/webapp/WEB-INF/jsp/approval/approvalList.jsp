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

    /* 탭 */
    .tab-bar {
        display: flex; gap: 0;
        border-bottom: 2px solid var(--border);
        margin-bottom: 16px;
    }
    .tab-item {
        padding: 10px 20px; font-size: 13px; font-weight: 500;
        color: var(--muted); cursor: pointer; border: none; background: none;
        font-family: inherit; border-bottom: 2px solid transparent;
        margin-bottom: -2px; transition: color 0.15s;
        display: flex; align-items: center; gap: 6px;
    }
    .tab-item.active { color: var(--accent); border-bottom-color: var(--accent); }
    .tab-item:hover  { color: var(--text); }
    .tab-count {
        background: var(--accent); color: white;
        font-size: 10px; padding: 1px 6px; border-radius: 10px; font-weight: 700;
    }
    .tab-count.gray { background: var(--muted); }

    /* 검색 */
    .search-card {
        background: var(--surface); border: 1px solid var(--border);
        border-radius: 12px; padding: 14px 18px;
        margin-bottom: 16px; display: flex; gap: 10px; align-items: center;
    }
    .search-card input, .search-card select {
        height: 36px; padding: 0 12px; border: 1px solid var(--border);
        border-radius: 8px; font-size: 13px; font-family: inherit;
        color: var(--text); background: var(--bg); outline: none;
        transition: border-color 0.2s;
    }
    .search-card input:focus, .search-card select:focus { border-color: var(--accent); }
    .search-card input { width: 200px; }

    .btn { height: 36px; padding: 0 16px; border-radius: 8px; font-size: 13px;
           font-family: inherit; font-weight: 500; cursor: pointer; border: none;
           display: inline-flex; align-items: center; gap: 5px; text-decoration: none;
           transition: opacity 0.15s; }
    .btn-primary { background: var(--accent); color: white; }
    .btn-primary:hover { opacity: 0.88; }
    .btn-outline { background: var(--surface); color: var(--text); border: 1px solid var(--border); }
    .btn-outline:hover { background: var(--bg); }
    .ml-auto { margin-left: auto; }

    /* 테이블 */
    .table-card {
        background: var(--surface); border: 1px solid var(--border);
        border-radius: 12px; overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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
    tbody td { padding: 12px 16px; font-size: 13px; color: var(--text); }

    .doc-title { font-weight: 500; color: var(--navy); cursor: pointer; }
    .doc-title:hover { text-decoration: underline; color: var(--accent); }

    .status-badge {
        display: inline-flex; align-items: center; gap: 4px;
        padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600;
    }
    .status-pending  { background: #FFF7ED; color: #D97706; }
    .status-approved { background: #ECFDF5; color: #059669; }
    .status-rejected { background: #FFF1F2; color: #E11D48; }

    .btn-view {
        background: #EFF6FF; color: #2563EB; border: none;
        padding: 4px 10px; border-radius: 6px; font-size: 12px;
        font-family: inherit; cursor: pointer; font-weight: 500;
    }
    .btn-view:hover { background: #DBEAFE; }

    .btn-approve {
        background: #ECFDF5; color: #059669; border: none;
        padding: 4px 10px; border-radius: 6px; font-size: 12px;
        font-family: inherit; cursor: pointer; font-weight: 500;
    }
    .btn-approve:hover { background: #D1FAE5; }

    .btn-reject {
        background: #FFF1F2; color: #E11D48; border: none;
        padding: 4px 10px; border-radius: 6px; font-size: 12px;
        font-family: inherit; cursor: pointer; font-weight: 500;
    }
    .btn-reject:hover { background: #FFE4E6; }
</style>

<main id="content">

    <div class="page-header">
        <div>
            <div class="page-title">전자결재</div>
            <div class="page-sub">결재 문서를 조회하고 승인/반려 처리합니다.</div>
        </div>
        <button class="btn btn-primary" onclick="openApprovalNew()">+ 결재 문서 작성</button>
    </div>

    <!-- 탭 -->
    <div class="tab-bar">
        <button class="tab-item active" onclick="switchTab(this, 'all')">
            전체 <span class="tab-count gray">3</span>
        </button>
        <button class="tab-item" onclick="switchTab(this, 'pending')">
            대기 <span class="tab-count">1</span>
        </button>
        <button class="tab-item" onclick="switchTab(this, 'approved')">승인</button>
        <button class="tab-item" onclick="switchTab(this, 'rejected')">반려</button>
    </div>

    <!-- 검색 -->
    <form action="${pageContext.request.contextPath}/approval/list.do" method="get">
    <div class="search-card">
        <select name="status">
            <option value="">전체 상태</option>
            <option value="PENDING"  <c:if test="${param.status=='PENDING'}">selected</c:if>>대기</option>
            <option value="APPROVED" <c:if test="${param.status=='APPROVED'}">selected</c:if>>승인</option>
            <option value="REJECTED" <c:if test="${param.status=='REJECTED'}">selected</c:if>>반려</option>
        </select>
        <input type="text" name="keyword" value="${param.keyword}" placeholder="제목 또는 기안자 검색">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/approval/list.do" class="btn btn-outline">초기화</a>
    </div>
    </form>

    <!-- 테이블 -->
    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th style="width:60px">번호</th>
                    <th>제목</th>
                    <th style="width:80px">기안자</th>
                    <th style="width:80px">결재자</th>
                    <th style="width:90px">결재 상태</th>
                    <th style="width:110px">기안일</th>
                    <th style="width:110px">처리일</th>
                    <th style="width:130px">관리</th>
                </tr>
            </thead>
            <tbody id="approvalTableBody">

                <c:choose>
                    <c:when test="${empty approvalList}">
                        <%-- DB 연동 전 샘플 데이터 --%>
                        <tr>
                            <td>3</td>
                            <td><span class="doc-title" onclick="viewApproval(3)">2026년 4월 연차 신청 - 홍길동</span></td>
                            <td>홍길동</td>
                            <td>김팀장</td>
                            <td><span class="status-badge status-pending">⏳ 대기</span></td>
                            <td>2026-04-22</td>
                            <td>-</td>
                            <td>
                                <div style="display:flex;gap:5px">
                                    <button class="btn-view" onclick="viewApproval(3)">보기</button>
                                    <button class="btn-approve" onclick="approveDoc(3)">승인</button>
                                    <button class="btn-reject" onclick="rejectDoc(3)">반려</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><span class="doc-title" onclick="viewApproval(2)">출장비 정산 요청 - 김철수</span></td>
                            <td>김철수</td>
                            <td>이부장</td>
                            <td><span class="status-badge status-approved">✔ 승인</span></td>
                            <td>2026-04-20</td>
                            <td>2026-04-21</td>
                            <td>
                                <div style="display:flex;gap:5px">
                                    <button class="btn-view" onclick="viewApproval(2)">보기</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td><span class="doc-title" onclick="viewApproval(1)">비품 구매 요청 - 이영희</span></td>
                            <td>이영희</td>
                            <td>박이사</td>
                            <td><span class="status-badge status-rejected">✕ 반려</span></td>
                            <td>2026-04-18</td>
                            <td>2026-04-19</td>
                            <td>
                                <div style="display:flex;gap:5px">
                                    <button class="btn-view" onclick="viewApproval(1)">보기</button>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${approvalList}" var="doc" varStatus="s">
                        <tr>
                            <td>${doc.docId}</td>
                            <td><span class="doc-title" onclick="viewApproval(${doc.docId})">${doc.title}</span></td>
                            <td>${doc.writerName}</td>
                            <td>${doc.approverName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${doc.status == 'PENDING'}"><span class="status-badge status-pending">⏳ 대기</span></c:when>
                                    <c:when test="${doc.status == 'APPROVED'}"><span class="status-badge status-approved">✔ 승인</span></c:when>
                                    <c:otherwise><span class="status-badge status-rejected">✕ 반려</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>${doc.createdAt}</td>
                            <td>${empty doc.approvedAt ? '-' : doc.approvedAt}</td>
                            <td>
                                <div style="display:flex;gap:5px">
                                    <button class="btn-view" onclick="viewApproval(${doc.docId})">보기</button>
                                    <c:if test="${doc.status == 'PENDING'}">
                                        <button class="btn-approve" onclick="approveDoc(${doc.docId})">승인</button>
                                        <button class="btn-reject" onclick="rejectDoc(${doc.docId})">반려</button>
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

<script>
// 새 결재 문서 작성 팝업
function openApprovalNew() {
    window.open(
        '${pageContext.request.contextPath}/approval/form.do',
        'approvalPopup',
        'width=720,height=640,top=100,left=300,scrollbars=yes,resizable=no'
    );
}

// 결재 문서 상세 보기 팝업
function viewApproval(docId) {
    window.open(
        '${pageContext.request.contextPath}/approval/view.do?docId=' + docId,
        'approvalView',
        'width=720,height=640,top=100,left=300,scrollbars=yes,resizable=no'
    );
}

// 승인 처리
function approveDoc(docId) {
    if(confirm('승인 처리하시겠습니까?')) {
        // DB 연동 후 fetch or form submit
        fetch('${pageContext.request.contextPath}/approval/approve.do', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'docId=' + docId
        }).then(r => r.text()).then(() => location.reload());
    }
}

// 반려 처리
function rejectDoc(docId) {
    const reason = prompt('반려 사유를 입력하세요:');
    if(reason !== null && reason.trim() !== '') {
        fetch('${pageContext.request.contextPath}/approval/reject.do', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'docId=' + docId + '&reason=' + encodeURIComponent(reason)
        }).then(r => r.text()).then(() => location.reload());
    }
}

// 탭 전환 (DB 연동 후 실제 필터링으로 교체)
function switchTab(btn, type) {
    document.querySelectorAll('.tab-item').forEach(t => t.classList.remove('active'));
    btn.classList.add('active');
}
</script>

</div>
</body>
</html>
