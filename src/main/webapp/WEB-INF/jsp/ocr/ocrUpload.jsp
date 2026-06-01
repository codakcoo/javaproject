<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%@include file="/WEB-INF/jsp/common/header.jsp"%><%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
.ocr-wrap { max-width:800px; }
.upload-area {
    border:2px dashed #DDDDDD; border-radius:8px; padding:40px;
    text-align:center; cursor:pointer; margin-bottom:20px; transition:border-color 0.2s;
}
.upload-area:hover { border-color:#2563EB; }
.preview-img { max-width:100%; border-radius:8px; margin-bottom:16px; display:none; }
.result-section { display:none; margin-top:24px; }
.result-title { font-size:15px; font-weight:700; margin-bottom:12px; color:var(--text); }
.receipt-preview {
    background:white; border:1px solid #DDDDDD;
    box-shadow:0 2px 8px rgba(0,0,0,0.06); margin-bottom:16px;
}
.receipt-head {
    padding:20px 24px 16px; border-bottom:2px solid #0066CC;
    display:flex; justify-content:space-between; align-items:flex-start;
}
.receipt-title-text { font-size:20px; font-weight:700; color:#222; }
.receipt-no { font-size:12px; color:#888; margin-top:4px; }
.dtype-badge {
    display:inline-block; padding:3px 10px; border-radius:3px;
    font-size:12px; font-weight:700; margin-top:6px;
}
.dtype-in  { background:#E0F2F1; color:#00796B; border:1px solid #80CBC4; }
.dtype-out { background:#E3F2FD; color:#1565C0; border:1px solid #90CAF9; }
.dtype-adj { background:#FFF3E0; color:#E65100; border:1px solid #FFCC80; }
.receipt-date { font-size:12px; color:#222; text-align:right; }
.receipt-date strong { font-size:14px; color:#0066CC; display:block; }
.info-grid {
    display:grid; grid-template-columns:1fr 1fr;
    border-bottom:1px solid #DDDDDD;
}
.info-cell { padding:10px 24px; border-right:1px solid #DDDDDD; }
.info-cell:nth-child(even) { border-right:none; }
.info-label { font-size:10px; color:#888; font-weight:600; margin-bottom:3px; }
.info-input {
    width:100%; height:28px; padding:0 8px;
    border:1px solid #DDDDDD; border-radius:3px;
    font-size:13px; font-family:inherit; outline:none;
}
.info-input:focus { border-color:#0066CC; }
.info-select {
    width:100%; height:28px; padding:0 8px;
    border:1px solid #DDDDDD; border-radius:3px;
    font-size:13px; font-family:inherit; outline:none;
}
.receipt-body { padding:16px 24px; }
.item-tbl { width:100%; border-collapse:collapse; font-size:12px; }
.item-tbl thead th {
    background:#F5F5F5; border:1px solid #CCC;
    padding:7px 8px; font-weight:600; color:#444; text-align:center;
}
.item-tbl tbody td { border:1px solid #DDDDDD; padding:5px 6px; vertical-align:middle; }
.item-tbl input {
    width:100%; height:26px; padding:0 6px;
    border:1px solid #DDDDDD; border-radius:3px;
    font-size:12px; font-family:inherit; outline:none;
}
.item-tbl input:focus { border-color:#0066CC; }
.receipt-total {
    padding:14px 24px; background:#F5F9FF;
    border-top:2px solid #0066CC;
    display:flex; justify-content:flex-end; align-items:center; gap:12px;
}
.total-label { font-size:13px; color:#555; }
.total-amount { font-size:20px; font-weight:700; color:#0066CC; }
.receipt-sign {
    padding:16px 24px; border-top:1px solid #DDDDDD;
    display:flex; justify-content:flex-end; gap:24px;
}
.sign-box { text-align:center; min-width:80px; }
.sign-label { font-size:11px; color:#888; margin-bottom:6px; }
.sign-name { font-size:13px; font-weight:600; color:#222; }
.sign-line {
    height:36px; border-bottom:1px solid #CCC;
    display:flex; align-items:flex-end; justify-content:center;
    padding-bottom:4px; margin-bottom:4px;
}
.btn-add-row {
    margin-top:8px; height:26px; padding:0 10px;
    background:#F0F6FF; color:#2563EB; border:1px solid #B8D0F0;
    border-radius:3px; font-size:11px; font-family:inherit; cursor:pointer;
}
.btn-del-row {
    height:24px; padding:0 6px; background:#FFF1F2;
    color:#E11D48; border:1px solid #FDA4AF;
    border-radius:3px; font-size:11px; font-family:inherit; cursor:pointer;
}
.loading-box { text-align:center; padding:20px; color:#94A3B8; display:none; }
.save-btn {
    width:100%; height:48px; background:#0066CC; color:white;
    border:none; border-radius:8px; font-size:15px; font-weight:600;
    font-family:inherit; cursor:pointer; margin-top:16px;
}
.save-btn:hover { background:#0055AA; }
.raw-text-box {
    background:#F8FAFC; border:1px solid #DDDDDD;
    border-radius:6px; padding:12px; font-size:12px; line-height:1.8;
    white-space:pre-wrap; color:#555; max-height:150px; overflow-y:auto;
    margin-top:12px;
}
.ocr-btn {
    display:none; width:100%; height:44px; background:#2563EB; color:white;
    border:none; border-radius:8px; font-size:14px; font-weight:600;
    font-family:inherit; cursor:pointer; margin-top:12px;
}
.ocr-btn:hover { background:#1D4ED8; }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">영수증 OCR 인식</div>
            <div class="page-sub">영수증 이미지를 업로드하고 OCR 인식 버튼을 클릭하세요.</div>
        </div>
    </div>

    <div class="table-card ocr-wrap" style="padding:24px;">

        <div class="upload-area" onclick="document.getElementById('imageFile').click()">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="#94A3B8">
                <path d="M19 7v3h-2V7h-3V5h3V2h2v3h3v2h-3zm-3 4V8h-3V5H5C3.9 5 3 5.9 3 7v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2v-8h-3c-1.1 0-2-.9-2-2z"/>
            </svg>
            <p style="color:#94A3B8; font-size:14px; margin-top:10px;">클릭하여 영수증 이미지를 업로드하세요</p>
            <p style="color:#94A3B8; font-size:12px;">(JPG, PNG, PDF 지원)</p>
            <input type="file" id="imageFile" accept="image/*,.pdf"
                   style="display:none" onchange="previewImage(this)">
        </div>

        <img id="previewImg" class="preview-img" src="" alt="미리보기">
        <div id="pdfName" style="display:none; padding:12px; color:#2563EB; font-size:14px; font-weight:600;"></div>

        <button id="ocrBtn" class="ocr-btn" onclick="doOcr()">
            🔍 OCR 인식 시작
        </button>

        <div class="loading-box" id="loading">
            🔍 OCR 인식 중... 잠시만 기다려주세요
        </div>

        <div class="result-section" id="resultSection">
            <div class="result-title">📋 인식 결과 확인 및 수정</div>

            <div class="receipt-preview">
                <div class="receipt-head">
                    <div>
                        <div class="receipt-title-text" id="docTypeTitle">입고 주문서</div>
                        <div class="receipt-no">주문번호: OCR-자동생성</div>
                        <div style="margin-top:6px">
                            <span class="dtype-badge dtype-in" id="docTypeBadge">입고 요청서</span>
                        </div>
                    </div>
                    <div class="receipt-date">
                        <div style="font-size:11px;color:#888">주문일자</div>
                        <strong id="displayDate">-</strong>
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-cell">
                        <div class="info-label">문서 유형</div>
                        <select class="info-select" id="r_docType" onchange="updateDocType()">
                            <option value="INBOUND">입고 요청서</option>
                            <option value="OUTBOUND">출고 요청서</option>
                            <option value="STOCK_ADJ">재고 조정서</option>
                        </select>
                    </div>
                    <div class="info-cell">
                        <div class="info-label">거래처 (가게명)</div>
                        <input type="text" class="info-input" id="r_partner" placeholder="가게명">
                    </div>
                    <div class="info-cell">
                        <div class="info-label">요청자</div>
                        <input type="text" class="info-input" id="r_requester"
                               value="${loginUser.name}" readonly style="background:#F5F5F5;">
                    </div>
                    <div class="info-cell">
                        <div class="info-label">합계 금액</div>
                        <input type="number" class="info-input" id="r_total" placeholder="합계 금액"
                               oninput="updateTotal()">
                    </div>
                </div>

                <div class="receipt-body">
                    <div style="font-size:12px;font-weight:700;margin-bottom:8px;">■ 상품 내역</div>
                    <table class="item-tbl">
                        <thead>
                            <tr>
                                <th style="width:32px">No</th>
                                <th>상품명</th>
                                <th style="width:60px">수량</th>
                                <th style="width:90px">단가</th>
                                <th style="width:90px">금액</th>
                                <th style="width:34px">삭제</th>
                            </tr>
                        </thead>
                        <tbody id="itemBody"></tbody>
                    </table>
                    <button type="button" class="btn-add-row" onclick="addRow()">+ 상품 추가</button>
                </div>

                <div class="receipt-total">
                    <span class="total-label">합계 금액</span>
                    <span class="total-amount" id="totalDisplay">-</span>
                </div>

                <div class="receipt-sign">
                    <div class="sign-box">
                        <div class="sign-label">요청자</div>
                        <div class="sign-line">
                            <div class="sign-name">${loginUser.name}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div style="font-size:12px;font-weight:600;color:#555;margin-top:12px;">📄 OCR 원본 텍스트</div>
            <div class="raw-text-box" id="rawText"></div>

            <button class="save-btn" onclick="saveOrder()">✅ 주문내역에 저장</button>
        </div>

    </div>
</main>

<script>
var CTX = '${pageContext.request.contextPath}';
var rowCount = 0;

// ── 미리보기 ──────────────────────────────────────────────────────
function previewImage(input) {
    if (!input.files || !input.files[0]) return;
    var file = input.files[0];
    var img = document.getElementById('previewImg');
    var pdfName = document.getElementById('pdfName');

    document.getElementById('ocrBtn').style.display = 'block';
    document.getElementById('resultSection').style.display = 'none';

    if (file.type === 'application/pdf') {
        img.style.display = 'none';
        pdfName.style.display = 'block';
        pdfName.innerText = '📄 ' + file.name + ' (미리보기 로딩 중...)';

        var fd = new FormData();
        fd.append('imageFile', file);
        fetch(CTX + '/ocr/preview.do', { method: 'POST', body: fd })
        .then(r => r.text())
        .then(base64 => {
            if (base64 && !base64.startsWith('ERROR') && !base64.startsWith('UNAUTHORIZED')) {
                img.src = 'data:image/jpeg;base64,' + base64;
                img.style.display = 'block';
            }
            pdfName.innerText = '📄 ' + file.name;
        })
        .catch(() => { pdfName.innerText = '📄 ' + file.name; });
    } else {
        pdfName.style.display = 'none';
        var reader = new FileReader();
        reader.onload = function(e) {
            img.src = e.target.result;
            img.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }
}

// ── OCR 요청 ──────────────────────────────────────────────────────
function doOcr() {
    var fileInput = document.getElementById('imageFile');
    if (!fileInput.files || fileInput.files.length === 0) return;

    document.getElementById('ocrBtn').style.display = 'none';
    document.getElementById('loading').style.display = 'block';
    document.getElementById('resultSection').style.display = 'none';

    var formData = new FormData();
    formData.append('imageFile', fileInput.files[0]);

    fetch(CTX + '/ocr/upload.do', { method: 'POST', body: formData })
    .then(r => r.text())
    .then(data => {
        document.getElementById('loading').style.display = 'none';
        try {
            var json = JSON.parse(data);
            parseOcrResult(json);
        } catch(e) {
            alert('OCR 처리 중 오류가 발생했습니다.');
            document.getElementById('ocrBtn').style.display = 'block';
        }
    })
    .catch(() => {
        document.getElementById('loading').style.display = 'none';
        document.getElementById('ocrBtn').style.display = 'block';
        alert('네트워크 오류가 발생했습니다.');
    });
}

// ── OCR 결과 파싱 진입점 ──────────────────────────────────────────
function parseOcrResult(json) {
    if (!json.images || !json.images[0] || !json.images[0].fields) return;

    var fields = json.images[0].fields;
    var fullText = fields.map(f => f.inferText).join(' ');
    document.getElementById('rawText').innerText = fullText;

    var isErp = /ORD-\d{8}|AP-\d{8}|상품코드|■\s*상품\s*내역/.test(fullText);

    if (isErp) {
        parseErpReceipt(fullText);
    } else {
        parseConvenienceStore(fields, fullText);
    }

    document.getElementById('resultSection').style.display = 'block';
}

// ── ERP 자체 영수증 파싱 ──────────────────────────────────────────
function parseErpReceipt(fullText) {
    var lines = fullText.split('\n').map(s => s.trim()).filter(s => s.length > 0);

    // 문서 유형 — 가장 먼저 나오는 "X 주문서" 기준
    var docTypeResult = 'INBOUND';
    var docPositions = [
        { key: '출고 주문서', val: 'OUTBOUND' },
        { key: '재고 조정서', val: 'STOCK_ADJ' },
        { key: '입고 주문서', val: 'INBOUND' }
    ];
    var earliest = fullText.length;
    docPositions.forEach(function(d) {
        var idx = fullText.indexOf(d.key);
        if (idx >= 0 && idx < earliest) { earliest = idx; docTypeResult = d.val; }
    });
    document.getElementById('r_docType').value = docTypeResult;
    updateDocType();

    // 날짜
    var dateMatch = fullText.match(/\d{4}-\d{2}-\d{2}/);
    document.getElementById('displayDate').innerText = dateMatch ? dateMatch[0] : '-';

    // 거래처 — 다음 키워드 전까지만
    var partnerMatch = fullText.match(/거래처\s+(.+?)\s+(?:합계|■|상품\s*내역)/);
    if (partnerMatch) {
        var p = partnerMatch[1].trim();
        document.getElementById('r_partner').value = (p === '-') ? '' : p;
    }

    // 합계 금액
    var totalMatch = fullText.match(/합계\s*금액\s*([\d,]+)원/);
    if (totalMatch) {
        var totalStr = totalMatch[1].replace(/,/g, '');
        document.getElementById('r_total').value = totalStr;
        document.getElementById('totalDisplay').innerText = Number(totalStr).toLocaleString() + '원';
    }

    // 상품 내역 — 상품코드 기준으로 찾고, 단가/금액은 앞뒤 역방향으로 탐색
    document.getElementById('itemBody').innerHTML = '';
    rowCount = 0;

    var itemPattern = /([A-Z]+-\d{3})\s+(.+?)\s+(EA|BOX|KG|L|개|박스|묶음)\s+([\d.]+)/g;
    var match;
    while ((match = itemPattern.exec(fullText)) !== null) {
        var name  = match[2].trim();
        var qty   = match[4];
        // 단가/금액은 상품코드 앞에서 역방향으로 찾기
        var before = fullText.substring(0, match.index);
        var priceMatch = before.match(/([\d,]+)원\s+금액\s+([\d,]+)원\s*$/);
        var price  = priceMatch ? priceMatch[1].replace(/,/g, '') : '';
        var amount = priceMatch ? priceMatch[2].replace(/,/g, '') : '';
        // 앞에 없으면 뒤에서 찾기
        if (!price) {
            var after = fullText.substring(match.index + match[0].length);
            var priceAfter = after.match(/^\s*([\d,]+원?)\s+([\d,]+원?)/);
            if (priceAfter) {
                price  = priceAfter[1].replace(/[,원]/g, '');
                amount = priceAfter[2].replace(/[,원]/g, '');
            }
        }
        addRowWithData(
            name, qty,
            /^\d+$/.test(price)  ? price  : '',
            /^\d+$/.test(amount) ? amount : ''
        );
    }

    if (rowCount === 0) addRow();
}

// ── 편의점/일반 영수증 파싱 ───────────────────────────────────────
function parseConvenienceStore(fields, fullText) {
    // 가게명
    var sortedByY = fields.slice().sort((a, b) =>
        a.boundingPoly.vertices[0].y - b.boundingPoly.vertices[0].y);
    document.getElementById('r_partner').value = sortedByY[0] ? sortedByY[0].inferText : '';

    // 날짜
    var dateMatch = fullText.match(/\d{4}[-./]\d{2}[-./]\d{2}/);
    document.getElementById('displayDate').innerText =
        dateMatch ? dateMatch[0].replace(/\./g, '-') : '-';

    // 합계
    var totalVal = findTotal(fields);
    document.getElementById('r_total').value = totalVal;
    document.getElementById('totalDisplay').innerText =
        totalVal ? Number(totalVal).toLocaleString() + '원' : '-';

    // 레이아웃 감지
    document.getElementById('itemBody').innerHTML = '';
    rowCount = 0;

    var items = detectColumnLayout(fields)
        ? parseColumnLayout(fields)
        : parseBlockLayout(fullText);

    if (items.length > 0) {
        items.forEach(function(item) { addRowWithData(item.name, item.qty, item.price, item.amount); });
    } else {
        addRow();
    }
}

function findTotal(fields) {
    var totalKeywords = /합[\s]*계|합[\s]*게|TOTAL/i;
    for (var i = 0; i < fields.length; i++) {
        if (totalKeywords.test(fields[i].inferText)) {
            var totalY = fields[i].boundingPoly.vertices[0].y;
            var maxX = 0, totalVal = '';
            for (var j = 0; j < fields.length; j++) {
                var fy = fields[j].boundingPoly.vertices[0].y;
                var fx = fields[j].boundingPoly.vertices[0].x;
                if (Math.abs(fy - totalY) < 15) {
                    var num = fields[j].inferText.replace(/[₩,W\s]/g, '');
                    if (/^\d+$/.test(num) && parseInt(num) > 0 && fx > maxX) {
                        maxX = fx; totalVal = num;
                    }
                }
            }
            if (totalVal) return totalVal;
        }
    }
    return '';
}

function detectColumnLayout(fields) {
    var count = 0;
    for (var i = 0; i < fields.length; i++) {
        if (!/[가-힣]/.test(fields[i].inferText)) continue;
        var y1 = fields[i].boundingPoly.vertices[0].y;
        for (var j = 0; j < fields.length; j++) {
            if (i === j) continue;
            var y2 = fields[j].boundingPoly.vertices[0].y;
            var t = fields[j].inferText.replace(/[,₩원\s]/g, '');
            if (Math.abs(y1 - y2) < 12 && /^\d{3,}$/.test(t)) count++;
        }
    }
    return count >= 2;
}

function parseColumnLayout(fields) {
    var items = [];
    var skipPattern = /합계|소계|부가세|VAT|결제|카드|현금|승인|영수증|www|주문번호|대표|매장|발급|과세|면세|TOTAL|신용|할부|전표|고객|수량|금액|단가|품목|TEL|사업자|등록번호|대표자|주소/i;
    var sorted = fields.slice().sort((a,b) => a.boundingPoly.vertices[0].y - b.boundingPoly.vertices[0].y);

    var totalY = 999999;
    for (var i = 0; i < sorted.length; i++) {
        if (/합\s*계\s*수\s*량|합\s*계\s*금\s*액|소\s*계/i.test(sorted[i].inferText.trim())) {
            totalY = sorted[i].boundingPoly.vertices[0].y; break;
        }
    }
    sorted = sorted.filter(f => f.boundingPoly.vertices[0].y < totalY);

    var allX = sorted.map(f => f.boundingPoly.vertices[0].x);
    var minX = Math.min(...allX), maxX = Math.max(...allX);
    var thresh = minX + (maxX - minX) * 0.55;

    var names = sorted.filter(f => {
        var x = f.boundingPoly.vertices[0].x, t = f.inferText.trim();
        return x < thresh && t.length >= 2 && /[가-힣a-zA-Z]/.test(t) && !skipPattern.test(t) && !/^[\d,₩\s]+$/.test(t);
    }).map(f => f.inferText.trim());

    var amounts = sorted.filter(f => {
        var x = f.boundingPoly.vertices[0].x;
        var t = f.inferText.replace(/[₩,원\s]/g, '');
        return x >= thresh && /^\d+$/.test(t) && parseInt(t) >= 100 && parseInt(t) <= 9999999 && !/[가-힣]/.test(f.inferText);
    }).map(f => parseInt(f.inferText.replace(/[₩,원\s,]/g, '')));

    var len = Math.min(names.length, amounts.length);
    for (var i = 0; i < len; i++) {
        items.push({ name: names[i], qty: 1, price: amounts[i], amount: amounts[i] });
    }
    return items.slice(0, 20);
}

function parseBlockLayout(fullText) {
    var items = [];
    var boundaryMatch = fullText.search(/합\s*계\s*수\s*량|합계수량\/금액/);
    var targetText = boundaryMatch > 0 ? fullText.substring(0, boundaryMatch) : fullText;
    var lines = targetText.split('\n').map(s => s.trim()).filter(s => s.length > 0);
    var skipPattern = /플랫폼|GS25|CU|세븐|이마트|NO:|정부방침|교환|환불|영수증|카드결제|카드와|이내|가능합니다|지참|반드시|하며|층|^\d{4}|^\d{8,}$/;

    var names = lines.filter(t =>
        /[가-힣]/.test(t) && t.length >= 2 && !/^[\d\s,]+$/.test(t) && !skipPattern.test(t)
    );
    var amounts = lines.filter(t => {
        var n = t.replace(/[,₩원\s]/g, '');
        return /^\d+$/.test(n) && parseInt(n) >= 100 && parseInt(n) <= 99999;
    }).map(t => parseInt(t.replace(/[,₩원\s]/g, '')));

    var len = Math.min(names.length, amounts.length);
    for (var i = 0; i < len; i++) {
        items.push({ name: names[i], qty: 1, price: amounts[i], amount: amounts[i] });
    }
    return items.slice(0, 20);
}

// ── 테이블 행 관리 ────────────────────────────────────────────────
function addRow() { addRowWithData('', '', '', ''); }

function addRowWithData(name, qty, price, amount) {
    rowCount++;
    var tbody = document.getElementById('itemBody');
    var tr = document.createElement('tr');
    tr.innerHTML =
        '<td align="center">' + rowCount + '</td>' +
        '<td><input type="text" class="item-name" value="' + (name||'') + '" placeholder="상품명"></td>' +
        '<td><input type="number" class="item-qty" value="' + (qty||'') + '" min="0" step="0.001" oninput="calcAmount(this)"></td>' +
        '<td><input type="number" class="item-price" value="' + (price||'') + '" min="0" oninput="calcAmount(this)"></td>' +
        '<td><input type="number" class="item-amount" value="' + (amount||'') + '" min="0"></td>' +
        '<td align="center"><button type="button" class="btn-del-row" onclick="delRow(this)">✕</button></td>';
    tbody.appendChild(tr);
    updateRowNums();
}

function calcAmount(input) {
    var tr = input.closest('tr');
    var qty = parseFloat(tr.querySelector('.item-qty').value) || 0;
    var price = parseFloat(tr.querySelector('.item-price').value) || 0;
    tr.querySelector('.item-amount').value = qty * price;
}

function delRow(btn) {
    btn.closest('tr').remove();
    updateRowNums();
}

function updateRowNums() {
    document.querySelectorAll('#itemBody tr').forEach(function(tr, i) {
        tr.cells[0].textContent = i + 1;
    });
}

// ── UI 업데이트 ───────────────────────────────────────────────────
function updateDocType() {
    var val = document.getElementById('r_docType').value;
    var titleMap = { INBOUND: '입고 주문서', OUTBOUND: '출고 주문서', STOCK_ADJ: '재고 조정서' };
    var badgeMap = { INBOUND: '입고 요청서', OUTBOUND: '출고 요청서', STOCK_ADJ: '재고 조정서' };
    var classMap = { INBOUND: 'dtype-in', OUTBOUND: 'dtype-out', STOCK_ADJ: 'dtype-adj' };
    document.getElementById('docTypeTitle').innerText = titleMap[val];
    var badge = document.getElementById('docTypeBadge');
    badge.innerText = badgeMap[val];
    badge.className = 'dtype-badge ' + classMap[val];
}

function updateTotal() {
    var total = document.getElementById('r_total').value;
    document.getElementById('totalDisplay').innerText = total ? Number(total).toLocaleString() + '원' : '-';
}

// ── 저장 ─────────────────────────────────────────────────────────
function saveOrder() {
    var docType = document.getElementById('r_docType').value;
    var partnerName = document.getElementById('r_partner').value;
    var totalAmount = document.getElementById('r_total').value;

    var items = [];
    document.querySelectorAll('#itemBody tr').forEach(function(tr) {
        items.push({
            productName: tr.querySelector('.item-name').value,
            qty: tr.querySelector('.item-qty').value,
            unitCost: tr.querySelector('.item-price').value,
            amount: tr.querySelector('.item-amount').value
        });
    });

    fetch(CTX + '/ocr/saveOrder.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ docType, partnerName, totalAmount, items })
    })
    .then(r => r.text())
    .then(result => {
        if (result.startsWith('OK')) {
            alert('주문내역에 저장되었습니다!');
            location.href = CTX + '/order/list.do';
        } else {
            alert('저장 중 오류가 발생했습니다: ' + result);
        }
    })
    .catch(() => alert('네트워크 오류가 발생했습니다.'));
}
</script>

</div>
</body>
</html>
