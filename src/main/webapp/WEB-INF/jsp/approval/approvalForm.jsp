<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    Object loginUser = session.getAttribute("loginUser");
    if (loginUser == null) {
        out.println("<script>alert('로그인이 필요합니다.'); history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결재 문서 작성</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --blue: #0066CC; --blue-h: #0055AA;
            --border: #DDDDDD; --text: #222; --muted: #888;
            --bg: #F2F3F5; --surface: #FFF;
        }
        body {
            font-family: -apple-system, "Malgun Gothic", sans-serif;
            font-size: 12px; background: var(--bg); color: var(--text);
            display: flex; flex-direction: column; min-height: 100vh;
        }

        /* ── 헤더 ── */
        .pop-head {
            background: var(--blue); padding: 10px 16px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: space-between;
        }
        .pop-head h2   { font-size: 14px; font-weight: 700; color: white; }
        .pop-head .sub { font-size: 11px; color: rgba(255,255,255,0.6); margin-top: 2px; }
        .btn-x {
            background: rgba(255,255,255,0.15); border: none; color: white;
            width: 28px; height: 28px; border-radius: 3px; font-size: 16px;
            cursor: pointer; line-height: 1;
        }

        /* ── 결재선 ── */
        .approval-line {
            background: white; border-bottom: 1px solid var(--border);
            padding: 10px 16px; display: flex; align-items: center; gap: 8px; flex-shrink: 0;
        }
        .approver-box {
            border: 1px solid var(--border); padding: 6px 12px;
            text-align: center; min-width: 70px; border-radius: 2px;
        }
        .approver-box .role  { font-size: 10px; color: var(--muted); }
        .approver-box .name  { font-size: 12px; font-weight: 700; margin-top: 2px; }
        .approver-box .stamp {
            font-size: 10px; font-weight: 700; border-radius: 2px;
            padding: 1px 5px; display: inline-block; margin-top: 3px;
        }
        .stamp-done { border: 1px solid #059669; color: #059669; }
        .stamp-wait { border: 1px solid #D97706; color: #D97706; }
        .arr { color: var(--muted); font-size: 16px; }

        /* ── 본문 ── */
        .pop-body { flex: 1; overflow-y: auto; padding: 14px 16px; }

        .section { background: white; border: 1px solid var(--border); margin-bottom: 10px; }
        .section-head {
            background: #F5F5F5; border-bottom: 1px solid var(--border);
            padding: 6px 12px; font-size: 11px; font-weight: 700; color: #444;
        }
        .section-body { padding: 10px 12px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .form-group { display: flex; flex-direction: column; gap: 3px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { font-size: 11px; color: var(--muted); font-weight: 600; }
        .form-group label .req { color: #E11D48; }
        .form-group input,
        .form-group select {
            height: 28px; padding: 0 7px; border: 1px solid #BBBBBB;
            border-radius: 2px; font-size: 12px; font-family: inherit;
            color: var(--text); outline: none; background: white;
        }
        .form-group input:focus, .form-group select:focus { border-color: var(--blue); }

        /* ── 상품 테이블 ── */
        .item-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .item-tbl th {
            background: #F5F5F5; border: 1px solid #CCC;
            padding: 5px 6px; text-align: center; font-weight: 600; color: #444;
        }
        .item-tbl td { border: 1px solid var(--border); padding: 4px 5px; }
        .item-tbl input, .item-tbl select {
            width: 100%; height: 26px; padding: 0 5px;
            border: 1px solid #BBBBBB; border-radius: 2px;
            font-size: 11px; font-family: inherit; outline: none;
        }
        .item-tbl input:focus, .item-tbl select:focus { border-color: var(--blue); }

        .btn-add-row {
            margin-top: 6px; height: 26px; padding: 0 10px;
            background: #F0F6FF; color: var(--blue); border: 1px solid #B8D0F0;
            border-radius: 2px; font-size: 11px; font-family: inherit; cursor: pointer;
        }
        .btn-del-row {
            height: 24px; padding: 0 6px; background: #FFF1F2; color: #E11D48;
            border: 1px solid #FDA4AF; border-radius: 2px; font-size: 11px;
            font-family: inherit; cursor: pointer;
        }

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
        .btn-primary { background: var(--blue); color: white; border-color: var(--blue-h); }
        .btn-outline { background: white; color: var(--text); border-color: var(--border); }

        /* ── 모바일 반응형 ── */
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: 1; }
            .form-group input, .form-group select { height: 34px; font-size: 13px; }
            .pop-body { padding: 10px 12px; }
            .section-body { padding: 8px 10px; }
            .item-tbl input, .item-tbl select { height: 30px; font-size: 11px; }
            .btn { height: 36px; font-size: 13px; }
        }

        /* ── 공통 커스텀 다이얼로그 ── */
        .dlg-overlay {
            display: none; position: fixed; inset: 0; z-index: 9999;
            background: rgba(0,0,0,0.45);
            align-items: center; justify-content: center; padding: 20px;
        }
        .dlg-overlay.show { display: flex; }
        .dlg-box {
            background: white; border-radius: 8px; padding: 24px 20px 16px;
            width: 100%; max-width: 300px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
            animation: dlgIn 0.15s ease;
            text-align: center;
        }
        @keyframes dlgIn {
            from { transform: scale(0.9); opacity: 0; }
            to   { transform: scale(1);   opacity: 1; }
        }
        .dlg-icon { font-size: 32px; margin-bottom: 10px; }
        .dlg-title { font-size: 14px; font-weight: 700; color: #222; margin-bottom: 6px; }
        .dlg-msg   { font-size: 12px; color: #666; margin-bottom: 16px; line-height: 1.6; }
        .dlg-btns  { display: flex; gap: 8px; justify-content: center; }
        .dlg-btn {
            flex: 1; height: 36px; border-radius: 4px; font-size: 13px;
            font-family: inherit; font-weight: 600; cursor: pointer;
            border: 1px solid transparent;
        }
        .dlg-btn.cancel  { background: #F5F5F5; color: #555; border-color: #CCC; }
        .dlg-btn.primary { background: #0066CC; color: white; border-color: #0055AA; }
        .dlg-btn.success { background: #059669; color: white; border-color: #047857; }
        .dlg-btn.danger  { background: #E11D48; color: white; border-color: #BE123C; }
    </style>
</head>
<body>

<!-- ── 알림 다이얼로그 (alert 대체) ── -->
<div class="dlg-overlay" id="dlgAlert">
    <div class="dlg-box">
        <div class="dlg-icon" id="dlgAlertIcon">⚠️</div>
        <div class="dlg-title" id="dlgAlertTitle">알림</div>
        <div class="dlg-msg" id="dlgAlertMsg"></div>
        <div class="dlg-btns">
            <button class="dlg-btn primary" onclick="closeDlgAlert()">확인</button>
        </div>
    </div>
</div>

<!-- ── 확인 다이얼로그 (confirm 대체) ── -->
<div class="dlg-overlay" id="dlgConfirm">
    <div class="dlg-box">
        <div class="dlg-icon">📋</div>
        <div class="dlg-title">기안 확인</div>
        <div class="dlg-msg">결재를 기안하시겠습니까?<br>기안 후에는 수정할 수 없습니다.</div>
        <div class="dlg-btns">
            <button class="dlg-btn cancel"   onclick="closeDlgConfirm(false)">취소</button>
            <button class="dlg-btn primary"  onclick="closeDlgConfirm(true)">기안 올리기</button>
        </div>
    </div>
</div>

<!-- 헤더 -->
<div class="pop-head">
    <div>
        <h2>전자결재 문서 작성</h2>
        <div class="sub">기안자: ${loginUser.name}</div>
    </div>
    <button class="btn-x" onclick="closeOrBack()">✕</button>
</div>

<!-- 결재선 -->
<div class="approval-line">
    <div class="approver-box">
        <div class="role">기안</div>
        <div class="name">${loginUser.name}</div>
        <div class="stamp stamp-done">기안</div>
    </div>
    <div class="arr">→</div>
    <div class="approver-box">
        <div class="role">결재</div>
        <div class="name" id="approverDisplay">미지정</div>
        <div class="stamp stamp-wait">대기</div>
    </div>
</div>

<!-- 본문 폼 -->
<div class="pop-body">
<form id="approvalForm">

    <!-- 문서 정보 -->
    <div class="section">
        <div class="section-head">문서 정보</div>
        <div class="section-body">
            <div class="form-grid">
                <div class="form-group">
                    <label>문서 유형 <span class="req">*</span></label>
                    <select name="docType" id="docType" required onchange="onDocTypeChange(this)">
                        <option value="">유형 선택</option>
                        <option value="INBOUND">입고 요청서</option>
                        <option value="OUTBOUND">출고 요청서</option>
                        <option value="STOCK_ADJ">재고 조정서</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>결재자 <span class="req">*</span></label>
                    <select name="approverId" id="approverId" required onchange="updateApprover(this)">
                        <option value="">결재자 선택</option>
                        <c:forEach items="${memberList}" var="m">
                            <c:if test="${m.memberId != loginUser.memberId}">
                                <option value="${m.memberId}">${m.name} (${m.memberId})</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group full">
                    <label>제목 <span class="req">*</span></label>
                    <input type="text" name="title" id="docTitle" placeholder="결재 제목을 입력하세요" required>
                </div>
                <div class="form-group" id="supplierGroup" style="display:none">
                    <label>공급업체 (입고처)</label>
                    <select name="supplierId">
                        <option value="">선택 안함</option>
                        <c:forEach items="${supplierList}" var="s">
                            <option value="${s.supplierId}">${s.supplierName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group" id="customerGroup" style="display:none">
                    <label>고객사 (출고처)</label>
                    <select name="customerId">
                        <option value="">선택 안함</option>
                        <c:forEach items="${customerList}" var="c">
                            <option value="${c.customerId}">${c.customerName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <!-- 상품 목록 -->
    <div class="section">
        <div class="section-head">상품 목록 (여러 상품 추가 가능)</div>
        <div class="section-body">
            <table class="item-tbl">
                <thead>
                    <tr>
                        <th style="width:28px">No</th>
                        <th>상품명 / 코드</th>
                        <th style="width:65px">수량</th>
                        <th style="width:80px">단가</th>
                        <th style="width:85px">비고</th>
                        <th style="width:34px">삭제</th>
                    </tr>
                </thead>
                <tbody id="itemBody">
                    <tr>
                        <td align="center">1</td>
                        <td>
                            <select name="productId">
                                <option value="">상품 선택</option>
                                <c:forEach items="${productList}" var="p">
                                    <option value="${p.productId}">${p.productCode} / ${p.productName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><input type="number" name="qty" step="0.001" min="0" value="0"></td>
                        <td><input type="number" name="unitCost" step="0.01" min="0" value="0"></td>
                        <td><input type="text" name="itemRemarks" placeholder="비고"></td>
                        <td align="center"><button type="button" class="btn-del-row" onclick="delRow(this)">✕</button></td>
                    </tr>
                </tbody>
            </table>
            <button type="button" class="btn-add-row" onclick="addRow()">+ 상품 추가</button>
        </div>
    </div>

</form>
</div>

<!-- 푸터 -->
<div class="pop-foot">
    <button class="btn btn-outline" onclick="closeOrBack()">취소</button>
    <button class="btn btn-primary" id="submitBtn" onclick="submitForm()">기안 올리기</button>
</div>

<script>

/* ── 커스텀 다이얼로그 제어 ── */
var _confirmCallback = null;

function showDlgAlert(msg, icon, title) {
    document.getElementById('dlgAlertIcon').textContent  = icon  || '⚠️';
    document.getElementById('dlgAlertTitle').textContent = title || '알림';
    document.getElementById('dlgAlertMsg').textContent   = msg;
    document.getElementById('dlgAlert').classList.add('show');
}
function closeDlgAlert() {
    document.getElementById('dlgAlert').classList.remove('show');
}
function showDlgConfirm(callback) {
    _confirmCallback = callback;
    document.getElementById('dlgConfirm').classList.add('show');
}
function closeDlgConfirm(result) {
    document.getElementById('dlgConfirm').classList.remove('show');
    if (_confirmCallback) { _confirmCallback(result); _confirmCallback = null; }
}

var CTX = '${pageContext.request.contextPath}';

// 상품 목록 JS 배열 (동적 행 추가용)
var PRODUCTS = [
    <c:forEach items="${productList}" var="p" varStatus="s">
    { id: <c:out value="${p.productId}"/>, code: '<c:out value="${p.productCode}"/>', name: '<c:out value="${p.productName}"/>' }<c:if test="${!s.last}">,</c:if>
    </c:forEach>
];

function buildProductOptions() {
    var html = '<option value="">상품 선택</option>';
    PRODUCTS.forEach(function(p) {
        html += '<option value="' + p.id + '">' + p.code + ' / ' + p.name + '</option>';
    });
    return html;
}

var rowCount = 1;

function addRow() {
    rowCount++;
    var tbody = document.getElementById('itemBody');
    var tr = document.createElement('tr');
    tr.innerHTML =
        '<td align="center">' + rowCount + '</td>' +
        '<td><select name="productId">' + buildProductOptions() + '</select></td>' +
        '<td><input type="number" name="qty" step="0.001" min="0" value="0"></td>' +
        '<td><input type="number" name="unitCost" step="0.01" min="0" value="0"></td>' +
        '<td><input type="text" name="itemRemarks" placeholder="비고"></td>' +
        '<td align="center"><button type="button" class="btn-del-row" onclick="delRow(this)">✕</button></td>';
    tbody.appendChild(tr);
    updateRowNums();
}

function delRow(btn) {
    if (document.querySelectorAll('#itemBody tr').length <= 1) {
        showDlgAlert('최소 1개 상품이 필요합니다.', '⚠️', '삭제 불가'); return;
    }
    btn.closest('tr').remove();
    updateRowNums();
}

function updateRowNums() {
    document.querySelectorAll('#itemBody tr').forEach(function(tr, i) {
        tr.cells[0].textContent = i + 1;
    });
}

function onDocTypeChange(sel) {
    document.getElementById('supplierGroup').style.display = (sel.value === 'INBOUND')  ? '' : 'none';
    document.getElementById('customerGroup').style.display = (sel.value === 'OUTBOUND') ? '' : 'none';
    var title = document.getElementById('docTitle');
    if (!title.value && sel.value) {
        var today = new Date().toLocaleDateString('ko-KR');
        var map = { INBOUND: '입고 요청서', OUTBOUND: '출고 요청서', STOCK_ADJ: '재고 조정서' };
        title.value = today + ' ' + map[sel.value] + ' - ${loginUser.name}';
    }
}

function updateApprover(sel) {
    var name = sel.value ? sel.options[sel.selectedIndex].text.split(' ')[0] : '미지정';
    document.getElementById('approverDisplay').textContent = name;
}

// 닫기: PC 모달이면 부모에 알림, 모바일이면 뒤로가기
function closeOrBack() {
    if (window.parent && window.parent !== window && typeof window.parent.onFormComplete === 'function') {
        window.parent.document.getElementById('formModal').classList.remove('active');
        window.parent.document.getElementById('formIframe').src = '';
    } else {
        history.back();
    }
}

// AJAX 제출
function submitForm() {
    var docType    = document.getElementById('docType').value;
    var approverId = document.getElementById('approverId').value;
    var title      = document.getElementById('docTitle').value.trim();

    if (!docType)    { showDlgAlert('문서 유형을 선택하세요.', '📝', '입력 확인'); return; }
    if (!approverId) { showDlgAlert('결재자를 선택하세요.', '👤', '입력 확인'); return; }
    if (!title)      { showDlgAlert('제목을 입력하세요.', '📝', '입력 확인'); return; }

    var selects = document.querySelectorAll('select[name="productId"]');
    var hasProduct = Array.from(selects).some(function(s) { return s.value !== ''; });
    if (!hasProduct) { showDlgAlert('상품을 1개 이상 선택하세요.', '📦', '입력 확인'); return; }

    showDlgConfirm(function(ok) {
        if (!ok) return;
        var form = document.getElementById('approvalForm');
        var data = new URLSearchParams(new FormData(form));
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.textContent = '처리중...';

    fetch(CTX + '/approval/insert.do', {
        method: 'POST',
        body: data
    })
    .then(function(res) { return res.text(); })
    .then(function(result) {
        if (result === 'OK') {
            showDlgAlert('기안이 정상적으로 올라갔습니다.', '✅', '기안 완료');
            // PC 모달: 부모창 함수 호출
            if (window.parent && window.parent !== window && typeof window.parent.onFormComplete === 'function') {
                window.parent.onFormComplete();
            } else {
                // 모바일: 목록 페이지로 이동
                location.href = CTX + '/approval/pending.do';
            }
        } else {
            showDlgAlert('등록 중 오류가 발생했습니다.\n다시 시도해주세요.', '❌', '오류');
            btn.disabled = false;
            btn.textContent = '기안 올리기';
        }
    })
    .catch(function() {
        showDlgAlert('네트워크 오류가 발생했습니다.', '🌐', '연결 오류');
        btn.disabled = false;
        btn.textContent = '기안 올리기';
    });
    }); // showDlgConfirm 콜백 닫기
}
</script>
</body>
</html>
