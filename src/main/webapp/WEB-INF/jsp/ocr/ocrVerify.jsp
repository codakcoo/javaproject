<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
.page-title  { font-size:20px; font-weight:700; color:var(--text); }
.page-sub    { font-size:13px; color:var(--muted); margin-top:3px; }
.badge-ok    { background:#ECFDF5; color:#059669; padding:2px 10px; border-radius:20px; font-size:11px; font-weight:700; }
.badge-warn  { background:#FFFBEB; color:#D97706; padding:2px 10px; border-radius:20px; font-size:11px; font-weight:700; }
.badge-error { background:#FFF1F2; color:#E11D48; padding:2px 10px; border-radius:20px; font-size:11px; font-weight:700; }

.verify-card {
    background:var(--surface); border:1px solid var(--border);
    border-radius:12px; margin-bottom:14px; overflow:hidden;
}
.verify-card.level-ERROR { border-left:4px solid #E11D48; }
.verify-card.level-WARN  { border-left:4px solid #F59E0B; }
.verify-card.level-OK    { border-left:4px solid #059669; }

.vc-head {
    display:flex; align-items:center; gap:10px; padding:12px 16px;
    background:#FAFAFA; border-bottom:1px solid var(--border);
    cursor:pointer;
}
.vc-head:hover { background:#F0F6FF; }
.vc-no   { font-size:13px; font-weight:700; color:var(--blue); }
.vc-meta { font-size:12px; color:var(--muted); }
.vc-body { padding:14px 16px; display:none; }
.vc-body.open { display:block; }

.msg-list { margin:6px 0 10px; padding:0; list-style:none; }
.msg-list li { font-size:12px; padding:3px 0 3px 14px; position:relative; }
.msg-list li::before { content:"▸"; position:absolute; left:0; }
.msg-error li { color:#E11D48; }
.msg-warn  li { color:#D97706; }

table { width:100%; border-collapse:collapse; font-size:12px; }
thead th { background:#F8FAFC; padding:7px 10px; text-align:left;
           border-bottom:1px solid var(--border); color:var(--muted); font-weight:600; }
tbody td { padding:7px 10px; border-bottom:1px solid #F1F5F9; }
tbody tr:last-child td { border-bottom:none; }

.btn { height:32px; padding:0 14px; border-radius:8px; font-size:12px;
       font-family:inherit; font-weight:500; cursor:pointer; border:none;
       display:inline-flex; align-items:center; gap:5px; transition:opacity .15s; }
.btn:active { opacity:.8; }
.btn-confirm { background:#059669; color:#fff; }
.btn-reject  { background:#FFF1F2; color:#E11D48; border:1px solid #FECDD3; }
.btn-confirm-all { background:var(--accent); color:#fff; height:36px; padding:0 18px; font-size:13px; }

.toolbar { display:flex; align-items:center; justify-content:space-between; margin-bottom:16px; }
.pending-badge { background:#EFF6FF; color:var(--blue); border:1px solid #BFDBFE;
                 border-radius:20px; padding:3px 12px; font-size:12px; font-weight:600; }
</style>

<main id="content">
    <div style="margin-bottom:20px;">
        <div class="page-title">OCR 주문 검증</div>
        <div class="page-sub">저장된 OCR 주문을 오류 검증 후 확정합니다.</div>
    </div>

    <div class="toolbar">
        <span class="pending-badge">검증 대기 ${pendingCount}건</span>
        <button class="btn btn-confirm-all" onclick="confirmAll()">
            ✓ 오류 없는 건 일괄 확정
        </button>
    </div>

    <c:choose>
        <c:when test="${empty verifyResults}">
            <div style="text-align:center; padding:60px; color:var(--muted); font-size:14px;">
                검증 대기 중인 OCR 주문이 없습니다.
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach items="${verifyResults}" var="r" varStatus="st">
            <div class="verify-card level-${r.level}" id="card-${r.receipt.receiptId}">

                <!-- 헤더 (클릭 시 펼치기) -->
                <div class="vc-head" onclick="toggleCard(${r.receipt.receiptId})">
                    <span>
                        <c:choose>
                            <c:when test="${r.level == 'OK'}">
                                <span class="badge-ok">정상</span>
                            </c:when>
                            <c:when test="${r.level == 'WARN'}">
                                <span class="badge-warn">경고</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-error">오류</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="vc-no">${r.receipt.receiptNo}</span>
                    <span class="vc-meta">${r.receipt.docType} · ${r.receipt.partnerName} · ${r.receipt.totalAmount}원</span>
                    <span class="vc-meta" style="margin-left:auto;">${r.receipt.requesterName} 등록 · ${r.receipt.createdAt}</span>
                </div>

                <!-- 바디 (기본 닫힘) -->
                <div class="vc-body" id="body-${r.receipt.receiptId}">

                    <!-- 오류/경고 메시지 -->
                    <c:if test="${not empty r.errors}">
                        <ul class="msg-list msg-error">
                            <c:forEach items="${r.errors}" var="e"><li>${e}</li></c:forEach>
                        </ul>
                    </c:if>
                    <c:if test="${not empty r.warnings}">
                        <ul class="msg-list msg-warn">
                            <c:forEach items="${r.warnings}" var="w"><li>${w}</li></c:forEach>
                        </ul>
                    </c:if>

                    <!-- 상품 라인 테이블 -->
                    <table style="margin-bottom:12px;">
                        <thead>
                            <tr>
                                <th>상품명</th><th>수량</th><th>단가</th><th>금액</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${r.receipt.items}" var="item">
                            <tr>
                                <td>${item.productName}</td>
                                <td>${item.qty}</td>
                                <td>${item.unitCost}</td>
                                <td>${item.amount}</td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- 확정 / 반려 버튼 -->
                    <div style="display:flex; gap:8px;">
                        <button class="btn btn-confirm"
                                onclick="confirmOne(${r.receipt.receiptId})"
                                <c:if test="${not empty r.errors}">disabled title="오류를 수정하세요"</c:if>>
                            확정
                        </button>
                        <button class="btn btn-reject"
                                onclick="rejectOne(${r.receipt.receiptId})">
                            반려
                        </button>
                    </div>
                </div>
            </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>

<script>
var ctx = '${pageContext.request.contextPath}';

function toggleCard(id) {
    var body = document.getElementById('body-' + id);
    body.classList.toggle('open');
}

function confirmOne(id) {
    if (!confirm('이 주문을 확정하시겠습니까?')) return;
    fetch(ctx + '/ocr/confirm.do?receiptId=' + id, { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(t) {
            if (t === 'OK') {
                document.getElementById('card-' + id).remove();
                updateCount(-1);
            }
        });
}

function rejectOne(id) {
    if (!confirm('이 주문을 반려하시겠습니까?')) return;
    fetch(ctx + '/ocr/reject.do?receiptId=' + id, { method: 'POST' })
        .then(function(r) { return r.text(); })
        .then(function(t) {
            if (t === 'OK') {
                document.getElementById('card-' + id).remove();
                updateCount(-1);
            }
        });
}

function confirmAll() {
    // 오류 없는(level-OK 또는 level-WARN) 카드의 receiptId만 수집
    var ids = [];
    document.querySelectorAll('.verify-card.level-OK, .verify-card.level-WARN')
        .forEach(function(card) {
            ids.push(parseInt(card.id.replace('card-', '')));
        });

    if (ids.length === 0) { alert('확정 가능한 주문이 없습니다.'); return; }
    if (!confirm(ids.length + '건을 일괄 확정하시겠습니까?')) return;

    fetch(ctx + '/ocr/confirmAll.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(ids)
    })
    .then(function(r) { return r.text(); })
    .then(function(t) {
        if (t.startsWith('OK')) {
            ids.forEach(function(id) {
                var card = document.getElementById('card-' + id);
                if (card) card.remove();
            });
            updateCount(-ids.length);
            alert(t.split(':')[1] + '건이 확정되었습니다.');
        }
    });
}

function updateCount(delta) {
    var badge = document.querySelector('.pending-badge');
    if (!badge) return;
    var cur = parseInt(badge.textContent.match(/\d+/)[0]) + delta;
    badge.textContent = '검증 대기 ' + Math.max(0, cur) + '건';
}
</script>
