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

    .table-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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

    .action-btns { display: flex; gap: 6px; }

    .btn-approve { background: #ECFDF5; color: #059669; border: none;
                   padding: 4px 12px; border-radius: 6px; font-size: 12px;
                   font-family: inherit; cursor: pointer; font-weight: 600;
                   transition: background 0.15s; }
    .btn-approve:hover { background: #D1FAE5; }

    .btn-reject  { background: #FFF1F2; color: #E11D48; border: none;
                   padding: 4px 12px; border-radius: 6px; font-size: 12px;
                   font-family: inherit; cursor: pointer; font-weight: 600;
                   transition: background 0.15s; }
    .btn-reject:hover { background: #FFE4E6; }

    .empty-row td { text-align: center; padding: 48px; color: var(--muted); font-size: 14px; }

    /* 모달 스타일 */
    .modal-bg {
        display: none; position: fixed; inset: 0;
        background: rgba(0,0,0,0.45); z-index: 999;
        align-items: center; justify-content: center;
    }
    .modal-bg.active { display: flex; }
    .modal {
        background: white; border-radius: 16px;
        padding: 32px; width: 400px; max-width: 90%;
        box-shadow: 0 8px 32px rgba(0,0,0,0.18);
        text-align: center;
    }
    .modal-icon { font-size: 40px; margin-bottom: 12px; }
    .modal-title { font-size: 18px; font-weight: 700; color: var(--text); margin-bottom: 8px; }
    .modal-desc  { font-size: 14px; color: var(--muted); margin-bottom: 24px; }
    .modal-btns  { display: flex; gap: 10px; justify-content: center; }
    .modal-btn-cancel {
        padding: 10px 24px; border-radius: 8px; font-size: 14px;
        font-family: inherit; cursor: pointer; font-weight: 600;
        background: #F1F5F9; color: #64748B; border: none;
        transition: background 0.15s;
    }
    .modal-btn-cancel:hover { background: #E2E8F0; }
    .modal-btn-confirm {
        padding: 10px 24px; border-radius: 8px; font-size: 14px;
        font-family: inherit; cursor: pointer; font-weight: 600;
        border: none; transition: background 0.15s;
    }

    @media (max-width: 768px) {
        table { min-width: 620px; }
        thead th { font-size: 11px; padding: 8px 10px; }
        tbody td  { font-size: 11px; padding: 8px 10px; }
    }
</style>

<!-- 승인 모달 -->
<div class="modal-bg" id="approveModal">
    <div class="modal">
        <div class="modal-icon">✅</div>
        <div class="modal-title" id="approveTitle">승인하시겠습니까?</div>
        <div class="modal-desc" id="approveDesc"></div>
        <div class="modal-btns">
            <button class="modal-btn-cancel" onclick="closeModal('approveModal')">취소</button>
            <button class="modal-btn-confirm" id="approveConfirmBtn"
                style="background:#059669; color:white;"
                onclick="submitForm('approveForm')">승인</button>
        </div>
    </div>
</div>

<!-- 거절 모달 -->
<div class="modal-bg" id="rejectModal">
    <div class="modal">
        <div class="modal-icon">❌</div>
        <div class="modal-title" id="rejectTitle">거절하시겠습니까?</div>
        <div class="modal-desc" id="rejectDesc"></div>
        <div class="modal-btns">
            <button class="modal-btn-cancel" onclick="closeModal('rejectModal')">취소</button>
            <button class="modal-btn-confirm" id="rejectConfirmBtn"
                style="background:#E11D48; color:white;"
                onclick="submitForm('rejectForm')">거절</button>
        </div>
    </div>
</div>

<!-- 숨겨진 폼들 -->
<form id="approveForm" action="${pageContext.request.contextPath}/hr/approve.do" method="post">
    <input type="hidden" id="approveMemberId" name="memberId">
</form>
<form id="rejectForm" action="${pageContext.request.contextPath}/hr/reject.do" method="post">
    <input type="hidden" id="rejectMemberId" name="memberId">
</form>

<main id="content">

    <div class="page-header">
        <div>
            <div class="page-title">가입 승인 관리</div>
            <div class="page-sub">회원가입 신청 목록을 확인하고 승인/거절 처리합니다.</div>
        </div>
    </div>

    <div class="table-card">
        <div class="table-card-head">
            <span>가입 신청 목록</span>
            <span class="total-badge">대기 <strong>${empty pendingList ? '0' : pendingList.size()}</strong>건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>부서</th>
                    <th>전화번호</th>
                    <th>성별</th>
                    <th>처리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty pendingList}">
                        <tr class="empty-row">
                            <td colspan="7">대기 중인 가입 신청이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="member" items="${pendingList}">
                            <tr>
                                <td>${member.memberId}</td>
                                <td>${member.name}</td>
                                <td>${member.email}</td>
                                <td>${member.department}</td>
                                <td>${member.phone}</td>
                                <td>${member.gender eq 'M' ? '남성' : '여성'}</td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-approve"
                                            onclick="openApproveModal('${member.memberId}', '${member.name}')">승인</button>
                                        <button class="btn-reject"
                                            onclick="openRejectModal('${member.memberId}', '${member.name}')">거절</button>
                                        <form action="${pageContext.request.contextPath}/hr/approve.do" method="post" style="display:inline">
                                            <input type="hidden" name="memberId" value="${member.memberId}">
                                            <button type="submit" class="btn-approve"
                                                onclick="return confirm('${member.name}님을 승인하시겠습니까?')">승인</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/hr/reject.do" method="post" style="display:inline">
                                            <input type="hidden" name="memberId" value="${member.memberId}">
                                            <button type="submit" class="btn-reject"
                                                onclick="return confirm('${member.name}님을 거절하시겠습니까?')">거절</button>
                                        </form> --%>
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
function openApproveModal(memberId, name) {
    document.getElementById('approveMemberId').value = memberId;
    document.getElementById('approveDesc').textContent = name + '님의 가입을 승인합니다.';
    document.getElementById('approveModal').classList.add('active');
}

function openRejectModal(memberId, name) {
    document.getElementById('rejectMemberId').value = memberId;
    document.getElementById('rejectDesc').textContent = name + '님의 가입을 거절합니다.';
    document.getElementById('rejectModal').classList.add('active');
}

function closeModal(modalId) {
    document.getElementById(modalId).classList.remove('active');
}

function submitForm(formId) {
    document.getElementById(formId).submit();
}

// 모달 바깥 클릭 시 닫기
document.getElementById('approveModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal('approveModal');
});
document.getElementById('rejectModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal('rejectModal');
});
</script>

</div>
</body>
</html>