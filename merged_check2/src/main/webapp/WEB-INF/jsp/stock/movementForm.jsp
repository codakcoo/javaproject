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
    .form-grid.col3 { grid-template-columns:1fr 1fr 1fr; }
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
    .help-text { font-size:11px;color:var(--muted);margin-top:3px; }

    .type-info { padding:10px 12px;border-radius:8px;font-size:12px;
                 background:#EFF6FF;color:#2563EB;display:none;margin-top:6px; }
    .type-info.show { display:block; }

    .form-actions { padding:16px 24px;background:#F8FAFC;border-top:1px solid var(--border);
                    display:flex;gap:10px;justify-content:flex-end; }
    .btn { height:38px;padding:0 20px;border-radius:8px;font-size:13px;font-family:inherit;
           font-weight:500;cursor:pointer;border:none;display:inline-flex;align-items:center;
           gap:6px;text-decoration:none;transition:opacity .15s; }
    .btn-primary { background:var(--accent);color:white; }
    .btn-primary:hover { opacity:.88; }
    .btn-outline { background:var(--surface);color:var(--text);border:1px solid var(--border); }
    .btn-outline:hover { background:var(--bg); }
</style>

<main id="content">
    <div class="page-header">
        <a href="${pageContext.request.contextPath}/stock/movement.do" class="btn-back">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
        </a>
        <div>
            <div class="page-title">입출고 등록</div>
            <div class="page-sub">재고 변동 내역을 등록합니다. <span style="color:#E11D48">*</span> 표시는 필수 항목입니다.</div>
        </div>
    </div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/stock/movementProcess.do" method="post">

            <!-- 이동 유형 -->
            <div class="form-section">
                <div class="section-title">이동 유형</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>유형 <span class="req">*</span></label>
                        <select name="movementType" id="movementType" onchange="onTypeChange(this.value)" required>
                            <option value="">유형 선택</option>
                            <option value="INBOUND">INBOUND — 입고</option>
                            <option value="OUTBOUND">OUTBOUND — 출고</option>
                            <option value="TRANSFER">TRANSFER — 창고 이동</option>
                            <option value="ADJUST">ADJUST — 실사 조정</option>
                            <option value="RETURN">RETURN — 반품 입고</option>
                        </select>
                        <div id="typeInfo" class="type-info"></div>
                    </div>
                </div>
            </div>

            <!-- 상품 / 창고 -->
            <div class="form-section">
                <div class="section-title">대상 상품 · 창고</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>상품 <span class="req">*</span></label>
                        <select name="productId" required>
                            <option value="">상품 선택</option>
                            <c:forEach items="${productList}" var="p">
                                <c:if test="${p.isActive == 1}">
                                <option value="${p.productId}">[${p.productCode}] ${p.productName} (${p.unit})</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>창고 <span class="req">*</span></label>
                        <select name="warehouseId" required>
                            <option value="">창고 선택</option>
                            <c:forEach items="${warehouseList}" var="w">
                                <c:if test="${w.isActive == 1}">
                                <option value="${w.warehouseId}">[${w.warehouseCode}] ${w.warehouseName}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 수량 / 단가 -->
            <div class="form-section">
                <div class="section-title">수량 · 단가</div>
                <div class="form-grid col3">
                    <div class="form-group">
                        <label>수량 <span class="req">*</span></label>
                        <input type="number" name="qty" step="0.001" min="0.001" placeholder="0.000" required>
                        <span class="help-text" id="qtyHelp">변동 수량을 입력하세요</span>
                    </div>
                    <div class="form-group">
                        <label>단가 (원)</label>
                        <input type="number" name="unitCost" step="0.01" min="0" placeholder="0">
                        <span class="help-text">입고 시 매입단가 / 출고 시 원가</span>
                    </div>
                    <div class="form-group">
                        <label>연결 주문 ID</label>
                        <input type="number" name="refOrderId" placeholder="PO/SO ID (선택)">
                    </div>
                </div>
            </div>

            <!-- 비고 -->
            <div class="form-section">
                <div class="section-title">비고</div>
                <div class="form-group form-full">
                    <label>비고</label>
                    <textarea name="remarks" placeholder="조정 사유, 거래처, 특이사항 등"></textarea>
                </div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/stock/movement.do" class="btn btn-outline">취소</a>
                <button type="submit" class="btn btn-primary" onclick="return confirmSubmit()">등록하기</button>
            </div>
        </form>
    </div>
</main>

<script>
const typeMessages = {
    'INBOUND':  '입고 처리 — 재고 수량이 증가합니다.',
    'OUTBOUND': '출고 처리 — 재고 수량이 감소합니다.',
    'TRANSFER': '창고 이동 — 출발 창고 감소, 도착 창고 증가합니다. (현재는 단방향 처리)',
    'ADJUST':   '실사 조정 — 양수(+) 입력 시 증가, 음수(-) 입력 시 감소합니다.',
    'RETURN':   '반품 입고 — 재고 수량이 증가합니다.',
};
const qtyHelps = {
    'INBOUND':  '입고 수량 (양수)',
    'OUTBOUND': '출고 수량 (양수로 입력, 자동으로 차감)',
    'TRANSFER': '이동 수량',
    'ADJUST':   '조정 수량 (+증가 / -감소)',
    'RETURN':   '반품 수량',
};

function onTypeChange(val) {
    const info = document.getElementById('typeInfo');
    const help = document.getElementById('qtyHelp');
    if (val && typeMessages[val]) {
        info.textContent = typeMessages[val];
        info.className = 'type-info show';
        help.textContent = qtyHelps[val];
    } else {
        info.className = 'type-info';
        help.textContent = '변동 수량을 입력하세요';
    }
}

function confirmSubmit() {
    const type = document.getElementById('movementType').value;
    const labels = { INBOUND:'입고', OUTBOUND:'출고', TRANSFER:'창고이동', ADJUST:'실사조정', RETURN:'반품' };
    return confirm((labels[type] || type) + ' 처리를 등록하시겠습니까?');
}
</script>

</div>
</body>
</html>
