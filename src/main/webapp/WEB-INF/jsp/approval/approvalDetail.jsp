<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    Object loginUser = session.getAttribute("loginUser");
    if (loginUser == null) {
        out.println("<script>history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결재 문서 상세</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --blue:#0066CC; --border:#DDDDDD; --text:#222; --muted:#888; }
        body {
            font-family: -apple-system, "Malgun Gothic", sans-serif;
            font-size: 12px; background: #F2F3F5; color: var(--text);
            display: flex; flex-direction: column; min-height: 100vh;
        }

        /* ── 헤더 ── */
        .pop-head {
            background: var(--blue); padding: 10px 16px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: space-between;
        }
        .pop-head h2  { font-size: 14px; font-weight: 700; color: white; }
        .pop-head .sub { font-size: 11px; color: rgba(255,255,255,0.6); margin-top: 1px; }
        .btn-x {
            background: rgba(255,255,255,0.15); border: none; color: white;
            width: 28px; height: 28px; border-radius: 3px; font-size: 16px;
            cursor: pointer; line-height: 1; flex-shrink: 0;
        }

        /* ── 결재선 ── */
        .approval-line {
            background: white; border-bottom: 1px solid var(--border);
            padding: 10px 16px; display: flex; align-items: center; gap: 8px; flex-shrink: 0;
        }
        .approver-box {
            border: 1px solid var(--border); padding: 6px 14px;
            text-align: center; min-width: 80px; border-radius: 2px;
        }
        .approver-box .role { font-size: 10px; color: var(--muted); }
        .approver-box .name { font-size: 13px; font-weight: 700; margin-top: 2px; }
        .approver-box .stamp {
            font-size: 11px; font-weight: 700; border-radius: 2px;
            padding: 2px 7px; display: inline-block; margin-top: 4px;
        }
        .stamp-done    { border: 2px solid #059669; color: #059669; }
        .stamp-pending { border: 2px solid #D97706; color: #D97706; }
        .stamp-prog    { border: 2px solid #4338CA; color: #4338CA; }
        .stamp-reject  { border: 2px solid #E11D48; color: #E11D48; }
        .arr { color: var(--muted); font-size: 18px; }

        /* ── 본문 ── */
        .pop-body { flex: 1; overflow-y: auto; padding: 14px 16px; }

        .section { background: white; border: 1px solid var(--border); margin-bottom: 10px; }
        .section-head {
            background: #F5F5F5; border-bottom: 1px solid var(--border);
            padding: 6px 12px; font-size: 11px; font-weight: 700; color: #444;
        }
        .section-body { padding: 0; }

        .info-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .info-tbl th {
            background: #FAFAFA; border: 1px solid var(--border);
            padding: 7px 10px; font-weight: 600; color: #555;
            text-align: right; white-space: nowrap; width: 80px;
        }
        .info-tbl td { border: 1px solid var(--border); padding: 7px 10px; }

        .item-wrap { overflow-x: auto; -webkit-overflow-scrolling: touch; }
        .item-tbl { width: 100%; border-collapse: collapse; font-size: 12px; min-width: 500px; }
        .item-tbl th {
            background: #F5F5F5; border: 1px solid #CCC;
            padding: 6px 8px; font-weight: 600; color: #444; text-align: center;
        }
        .item-tbl td { border: 1px solid var(--border); padding: 6px 8px; vertical-align: middle; }

        .reject-box {
            background: #FFF1F2; border: 1px solid #FECDD3;
            border-radius: 3px; padding: 10px 12px; margin: 10px 12px;
            font-size: 12px; color: #E11D48;
        }
        .reject-box strong { display: block; margin-bottom: 4px; }

        .badge { display: inline-block; padding: 2px 8px; border-radius: 2px; font-size: 11px; font-weight: 600; }
        .badge-pending    { background: #FFF7ED; color: #D97706; border: 1px solid #FCD34D; }
        .badge-inprogress { background: #EEF2FF; color: #4338CA; border: 1px solid #A5B4FC; }
        .badge-approved   { background: #ECFDF5; color: #059669; border: 1px solid #6EE7B7; }
        .badge-rejected   { background: #FFF1F2; color: #E11D48; border: 1px solid #FDA4AF; }
        .dtype { display: inline-block; padding: 1px 6px; border-radius: 2px; font-size: 11px; font-weight: 600; }
        .dtype-in  { background: #E0F2F1; color: #00796B; border: 1px solid #80CBC4; }
        .dtype-out { background: #E3F2FD; color: #1565C0; border: 1px solid #90CAF9; }
        .dtype-adj { background: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }

        /* ── 푸터 ── */
        .pop-foot {
            padding: 10px 16px; background: white; border-top: 1px solid var(--border);
            display: flex; gap: 6px; justify-content: flex-end; flex-shrink: 0;
        }
        .btn {
            height: 32px; padding: 0 16px; border-radius: 2px; font-size: 12px;
            font-family: inherit; font-weight: 500; cursor: pointer;
            border: 1px solid transparent; display: inline-flex; align-items: center;
        }
        .btn-approve  { background: #ECFDF5; color: #059669; border-color: #6EE7B7; }
        .btn-progress { background: #EEF2FF; color: #4338CA; border-color: #A5B4FC; }
        .btn-reject   { background: #FFF1F2; color: #E11D48; border-color: #FDA4AF; }
        .btn-outline  { background: white;   color: var(--text); border-color: var(--border); }

        /* ════════════════════════════════════
           커스텀 확인 다이얼로그 (alert/confirm 대체)
           ════════════════════════════════════ */
        .dialog-overlay {
            display: none; position: fixed; inset: 0; z-index: 9999;
            background: rgba(0,0,0,0.45);
            align-items: center; justify-content: center;
            padding: 20px;
        }
        .dialog-overlay.show { display: flex; }

        .dialog-box {
            background: white; border-radius: 8px;
            padding: 24px 20px 16px;
            width: 100%; max-width: 320px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
            animation: dialogIn 0.15s ease;
        }
        @keyframes dialogIn {
            from { transform: scale(0.92); opacity: 0; }
            to   { transform: scale(1);   opacity: 1; }
        }

        .dialog-icon {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; margin: 0 auto 12px;
        }
        .dialog-icon.approve { background: #ECFDF5; }
        .dialog-icon.reject  { background: #FFF1F2; }
        .dialog-icon.review  { background: #EEF2FF; }

        .dialog-title {
            font-size: 14px; font-weight: 700; color: var(--text);
            text-align: center; margin-bottom: 6px;
        }
        .dialog-msg {
            font-size: 12px; color: var(--muted);
            text-align: center; margin-bottom: 16px; line-height: 1.5;
        }

        /* 반려 사유 입력 */
        .dialog-textarea {
            width: 100%; padding: 8px 10px;
            border: 1px solid #BBBBBB; border-radius: 4px;
            font-size: 13px; font-family: inherit;
            resize: none; height: 80px; outline: none;
            margin-bottom: 14px;
        }
        .dialog-textarea:focus { border-color: var(--blue); }

        .dialog-btns {
            display: flex; gap: 8px;
        }
        .dialog-btn {
            flex: 1; height: 38px; border-radius: 4px; font-size: 13px;
            font-family: inherit; font-weight: 600; cursor: pointer;
            border: 1px solid transparent;
        }
        .dialog-btn.cancel  { background: #F5F5F5; color: #555; border-color: #CCC; }
        .dialog-btn.confirm-approve { background: #059669; color: white; border-color: #047857; }
        .dialog-btn.confirm-reject  { background: #E11D48; color: white; border-color: #BE123C; }
        .dialog-btn.confirm-review  { background: #4338CA; color: white; border-color: #3730A3; }

        /* 모바일 */
        @media (max-width: 768px) {
            .info-tbl, .info-tbl tbody, .info-tbl tr,
            .info-tbl th, .info-tbl td { display: block; width: 100%; }
            .info-tbl th { text-align: left; border-bottom: none; padding: 6px 10px 2px; background: #F9F9F9; }
            .info-tbl td { border-top: none; padding: 2px 10px 8px; }
            .btn { height: 38px; font-size: 13px; padding: 0 14px; }
        }
    </style>
</head>
<body>

<c:set var="doc" value="${doc}"/>

<!-- ── 승인 확인 다이얼로그 ── -->
<div class="dialog-overlay" id="approveDialog">
    <div class="dialog-box">
        <div class="dialog-icon approve">✅</div>
        <div class="dialog-title">승인 처리</div>
        <div class="dialog-msg">이 결재 문서를 승인하시겠습니까?<br>승인 후에는 되돌릴 수 없습니다.</div>
        <div class="dialog-btns">
            <button class="dialog-btn cancel" onclick="closeDialog('approveDialog')">취소</button>
            <button class="dialog-btn confirm-approve" onclick="doApprove()">승인</button>
        </div>
    </div>
</div>

<!-- ── 검토 시작 확인 다이얼로그 ── -->
<div class="dialog-overlay" id="reviewDialog">
    <div class="dialog-box">
        <div class="dialog-icon review">🔍</div>
        <div class="dialog-title">검토 시작</div>
        <div class="dialog-msg">문서 검토를 시작하시겠습니까?<br>상태가 <b>기안중 → 진행중</b>으로 변경됩니다.</div>
        <div class="dialog-btns">
            <button class="dialog-btn cancel" onclick="closeDialog('reviewDialog')">취소</button>
            <button class="dialog-btn confirm-review" onclick="doStartReview()">검토 시작</button>
        </div>
    </div>
</div>

<!-- ── 반려 다이얼로그 (사유 입력) ── -->
<div class="dialog-overlay" id="rejectDialog">
    <div class="dialog-box">
        <div class="dialog-icon reject">❌</div>
        <div class="dialog-title">반려 처리</div>
        <div class="dialog-msg">반려 사유를 입력해 주세요.</div>
        <textarea class="dialog-textarea" id="rejectReason" placeholder="반려 사유를 입력하세요..."></textarea>
        <div class="dialog-btns">
            <button class="dialog-btn cancel" onclick="closeDialog('rejectDialog')">취소</button>
            <button class="dialog-btn confirm-reject" onclick="doReject()">반려</button>
        </div>
    </div>
</div>

<!-- 헤더 -->
<div class="pop-head">
    <div>
        <h2>결재 문서 상세</h2>
        <div class="sub">${doc.docNo}</div>
    </div>
    <button class="btn-x" onclick="closeOrBack()">✕</button>
</div>

<!-- 결재선 -->
<div class="approval-line">
    <div class="approver-box">
        <div class="role">기안</div>
        <div class="name">${doc.requesterName}</div>
        <div class="stamp stamp-done">기안</div>
    </div>
    <div class="arr">→</div>
    <div class="approver-box">
        <div class="role">결재</div>
        <div class="name">${empty doc.approverName ? '미지정' : doc.approverName}</div>
        <c:choose>
            <c:when test="${doc.status == 'APPROVED'}"><div class="stamp stamp-done">승인</div></c:when>
            <c:when test="${doc.status == 'REJECTED'}"><div class="stamp stamp-reject">반려</div></c:when>
            <c:when test="${doc.status == 'IN_PROGRESS'}"><div class="stamp stamp-prog">검토중</div></c:when>
            <c:otherwise><div class="stamp stamp-pending">대기</div></c:otherwise>
        </c:choose>
    </div>
</div>

<div class="pop-body">

    <c:if test="${doc.status == 'REJECTED' && not empty doc.rejectReason}">
        <div class="reject-box">
            <strong>반려 사유</strong>${doc.rejectReason}
        </div>
    </c:if>

    <div class="section">
        <div class="section-head">문서 정보</div>
        <div class="section-body">
            <table class="info-tbl">
                <tr>
                    <th>문서번호</th><td>${doc.docNo}</td>
                    <th>문서유형</th>
                    <td>
                        <c:choose>
                            <c:when test="${doc.docType == 'INBOUND'}"><span class="dtype dtype-in">입고 요청서</span></c:when>
                            <c:when test="${doc.docType == 'OUTBOUND'}"><span class="dtype dtype-out">출고 요청서</span></c:when>
                            <c:when test="${doc.docType == 'STOCK_ADJ'}"><span class="dtype dtype-adj">재고 조정서</span></c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr><th>제목</th><td colspan="3" style="font-weight:600">${doc.title}</td></tr>
                <tr>
                    <th>기안자</th><td>${doc.requesterName} (${doc.requesterId})</td>
                    <th>결재자</th><td>${empty doc.approverName ? '-' : doc.approverName}</td>
                </tr>
                <tr>
                    <th>거래처</th><td>${empty doc.partnerName ? '-' : doc.partnerName}</td>
                    <th>주소</th><td style="font-size:11px;color:var(--muted)">${empty doc.partnerAddress ? '-' : doc.partnerAddress}</td>
                </tr>
                <tr>
                    <th>상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${doc.status == 'PENDING'}"><span class="badge badge-pending">기안중</span></c:when>
                            <c:when test="${doc.status == 'IN_PROGRESS'}"><span class="badge badge-inprogress">진행중</span></c:when>
                            <c:when test="${doc.status == 'APPROVED'}"><span class="badge badge-approved">결재완료</span></c:when>
                            <c:when test="${doc.status == 'REJECTED'}"><span class="badge badge-rejected">반려</span></c:when>
                        </c:choose>
                    </td>
                    <th>처리일</th><td>${empty doc.approvedAt ? '-' : doc.approvedAt}</td>
                </tr>
                <tr><th>기안일</th><td colspan="3">${doc.requestedAt}</td></tr>
            </table>
        </div>
    </div>

    <div class="section">
        <div class="section-head">상품 목록</div>
        <div class="section-body">
            <div class="item-wrap">
            <table class="item-tbl">
                <thead>
                    <tr>
                        <th style="width:32px">No</th>
                        <th style="width:85px">상품코드</th>
                        <th>상품명</th>
                        <th style="width:50px">단위</th>
                        <th style="width:60px">수량</th>
                        <th style="width:85px">단가</th>
                        <th style="width:85px">금액</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty doc.items}">
                            <tr><td colspan="8" align="center" style="padding:20px;color:var(--muted)">상품 정보가 없습니다.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${doc.items}" var="item" varStatus="s">
                            <tr>
                                <td align="center">${s.index + 1}</td>
                                <td align="center" style="font-size:11px">${item.productCode}</td>
                                <td>${item.productName}</td>
                                <td align="center">${item.unit}</td>
                                <td align="right">${item.qty}</td>
                                <td align="right">
                                    <c:choose>
                                        <c:when test="${item.unitCost != null && item.unitCost > 0}"><fmt:formatNumber value="${item.unitCost}" pattern="#,###"/>원</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td align="right">
                                    <c:choose>
                                        <c:when test="${item.unitCost != null && item.unitCost > 0}"><fmt:formatNumber value="${item.qty * item.unitCost}" pattern="#,###"/>원</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color:var(--muted)">${empty item.remarks ? '-' : item.remarks}</td>
                            </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            </div>
        </div>
    </div>

</div>

<!-- 푸터 -->
<div class="pop-foot">
    <c:if test="${doc.status == 'PENDING'}">
        <button class="btn btn-progress" onclick="openDialog('reviewDialog')">검토 시작</button>
        <button class="btn btn-reject"   onclick="openDialog('rejectDialog')">반려</button>
    </c:if>
    <c:if test="${doc.status == 'IN_PROGRESS'}">
        <button class="btn btn-approve" onclick="openDialog('approveDialog')">승인</button>
        <button class="btn btn-reject"  onclick="openDialog('rejectDialog')">반려</button>
    </c:if>
    <button class="btn btn-outline" onclick="closeOrBack()">닫기</button>
</div>

<script>

function closeDlgAlertDetail() {
    var d = document.getElementById('_alertDlg');
    if (d) d.remove();
}

/* ── 알림 다이얼로그 (alert 대체) ── */
function showDlgAlert(msg, icon, title) {
    // approvalDetail에는 별도 alert overlay가 없으므로 간단 overlay 동적 생성
    var existing = document.getElementById('_alertDlg');
    if (existing) existing.remove();
    var d = document.createElement('div');
    d.id = '_alertDlg';
    d.style.cssText = 'position:fixed;inset:0;z-index:99999;background:rgba(0,0,0,0.45);display:flex;align-items:center;justify-content:center;padding:20px;';
    d.innerHTML =
        '<div style="background:white;border-radius:8px;padding:24px 20px 16px;width:100%;max-width:280px;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,0.2)">' +
        '<div style="font-size:28px;margin-bottom:10px">' + (icon||'⚠️') + '</div>' +
        '<div style="font-size:14px;font-weight:700;color:#222;margin-bottom:6px">' + (title||'알림') + '</div>' +
        '<div style="font-size:12px;color:#666;margin-bottom:16px;line-height:1.6">' + msg + '</div>' +
        '<button onclick="closeDlgAlertDetail()" ' +
        'style="width:100%;height:36px;background:#0066CC;color:white;border:none;border-radius:4px;font-size:13px;font-weight:600;cursor:pointer">확인</button>' +
        '</div>';
    document.body.appendChild(d);
}

var CTX    = '${pageContext.request.contextPath}';
var DOC_ID = '${doc.docId}';

/* ── 다이얼로그 열기/닫기 ── */
function openDialog(id) {
    document.getElementById(id).classList.add('show');
    if (id === 'rejectDialog') {
        document.getElementById('rejectReason').value = '';
        document.getElementById('rejectReason').focus();
    }
}
function closeDialog(id) {
    document.getElementById(id).classList.remove('show');
}

/* ── 오버레이 클릭으로 닫기 ── */
document.querySelectorAll('.dialog-overlay').forEach(function(overlay) {
    overlay.addEventListener('click', function(e) {
        if (e.target === overlay) overlay.classList.remove('show');
    });
});

/* ── 처리 완료 후 닫기 ── */
function closeOrBack() {
    if (window.parent && window.parent !== window &&
        typeof window.parent.onDetailComplete === 'function') {
        window.parent.onDetailComplete();
    } else {
        history.back();
    }
}

function afterAction() {
    if (window.parent && window.parent !== window &&
        typeof window.parent.onDetailComplete === 'function') {
        window.parent.onDetailComplete();
    } else {
        location.href = CTX + '/approval/list.do';
    }
}

/* ── 승인 처리 ── */
function doApprove() {
    fetch(CTX + '/approval/approve.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + DOC_ID
    })
    .then(function(res) { return res.text(); })
    .then(function(result) {
        closeDialog('approveDialog');
        if (result === 'OK') {
            afterAction();
        } else {
            showDlgAlert('처리 중 오류가 발생했습니다.', '❌', '오류');
        }
    });
}

/* ── 검토 시작 ── */
function doStartReview() {
    fetch(CTX + '/approval/startReview.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + DOC_ID
    })
    .then(function(res) { return res.text(); })
    .then(function(result) {
        closeDialog('reviewDialog');
        if (result === 'OK') {
            afterAction();
        } else {
            showDlgAlert('처리 중 오류가 발생했습니다.', '❌', '오류');
        }
    });
}

/* ── 반려 처리 ── */
function doReject() {
    var reason = document.getElementById('rejectReason').value.trim();
    if (!reason) {
        document.getElementById('rejectReason').style.borderColor = '#E11D48';
        document.getElementById('rejectReason').focus();
        return;
    }
    fetch(CTX + '/approval/reject.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'docId=' + DOC_ID + '&rejectReason=' + encodeURIComponent(reason)
    })
    .then(function(res) { return res.text(); })
    .then(function(result) {
        closeDialog('rejectDialog');
        if (result === 'OK') {
            showDlgAlert('반려 처리되었습니다.', '❌', '처리 완료');
            setTimeout(function() {
                var d = document.getElementById('_alertDlg');
                if (d) d.remove();
                afterAction();
            }, 700);
        } else {
            showDlgAlert('처리 중 오류가 발생했습니다.', '❌', '오류');
        }
    });
}
</script>
</body>
</html>
