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
    .form-group input,.form-group select {
        height:38px;padding:0 12px;border:1px solid var(--border);border-radius:8px;
        font-size:13px;font-family:inherit;color:var(--text);
        background:var(--bg);outline:none;transition:border-color .2s,box-shadow .2s;
    }
    .form-group input:focus,.form-group select:focus {
        border-color:var(--accent);box-shadow:0 0 0 3px rgba(74,144,217,.12);background:var(--surface);
    }
    .help-text { font-size:11px;color:var(--muted);margin-top:3px; }

    /* 상품코드 자동생성 영역 */
    .code-wrap { position:relative; }
    .code-wrap input { padding-right: 80px; }
    .btn-regen {
        position:absolute; right:6px; top:50%; transform:translateY(-50%);
        height:26px; padding:0 10px; border-radius:6px;
        background:var(--accent); color:white; border:none;
        font-size:11px; font-family:inherit; font-weight:600;
        cursor:pointer; transition:opacity .15s; white-space:nowrap;
    }
    .btn-regen:hover { opacity:.85; }
    .btn-regen:disabled { background:#94A3B8; cursor:not-allowed; }
    .code-status { font-size:11px; margin-top:3px; min-height:16px; }
    .code-status.loading { color:var(--muted); }
    .code-status.ok      { color:#059669; }
    .code-status.error   { color:#E11D48; }

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
        <a href="${pageContext.request.contextPath}/product/list.do" class="btn-back">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
        </a>
        <div>
            <div class="page-title">
                <c:choose>
                    <c:when test="${empty product}">상품 등록</c:when>
                    <c:otherwise>상품 수정</c:otherwise>
                </c:choose>
            </div>
            <div class="page-sub">상품 정보를 입력해주세요. <span style="color:#E11D48">*</span> 표시는 필수 항목입니다.</div>
        </div>
    </div>

    <div class="form-card">
        <c:set var="formAction" value="${empty product ? 'insert' : 'update'}"/>
        <form action="${pageContext.request.contextPath}/product/${formAction}.do" method="post" id="productForm">

            <c:if test="${not empty product}">
                <input type="hidden" name="productId" value="${product.productId}">
            </c:if>

            <!-- 기본 정보 -->
            <div class="form-section">
                <div class="section-title">기본 정보</div>
                <div class="form-grid">

                    <!-- 카테고리 — 등록 시 먼저 선택해야 코드 생성 가능 -->
                    <div class="form-group">
                        <label>카테고리</label>
                        <select name="category" id="category"
                                <c:if test="${empty product}">onchange="onCategoryChange(this.value)"</c:if>>
                            <option value="">선택 없음</option>
                            <option value="식품"   <c:if test="${product.category == '식품'}">selected</c:if>>식품</option>
                            <option value="전자"   <c:if test="${product.category == '전자'}">selected</c:if>>전자</option>
                            <option value="소모품" <c:if test="${product.category == '소모품'}">selected</c:if>>소모품</option>
                            <option value="원자재" <c:if test="${product.category == '원자재'}">selected</c:if>>원자재</option>
                            <option value="기타"   <c:if test="${product.category == '기타'}">selected</c:if>>기타</option>
                        </select>
                    </div>

                    <!-- 상품코드 — 등록 시 자동생성, 수정 시 readonly -->
                    <div class="form-group">
                        <label>상품코드 <span class="req">*</span></label>
                        <c:choose>
                            <c:when test="${empty product}">
                                <!-- 등록: 자동생성 + 재생성 버튼 -->
                                <div class="code-wrap">
                                    <input type="text" name="productCode" id="productCode"
                                           placeholder="카테고리 선택 시 자동 생성" required>
                                    <button type="button" class="btn-regen" id="regenBtn"
                                            onclick="generateCode()" disabled>재생성</button>
                                </div>
                                <span class="code-status" id="codeStatus">카테고리를 먼저 선택하세요</span>
                            </c:when>
                            <c:otherwise>
                                <!-- 수정: 변경 불가 -->
                                <input type="text" name="productCode" value="${product.productCode}"
                                       readonly style="background:#F1F5F9;color:#94A3B8">
                                <span class="help-text">등록 후 변경 불가</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 상품명 -->
                    <div class="form-group">
                        <label>상품명 <span class="req">*</span></label>
                        <input type="text" name="productName" value="${product.productName}"
                               placeholder="상품명 입력" required>
                    </div>

                    <!-- 단위 -->
                    <div class="form-group">
                        <label>단위 <span class="req">*</span></label>
                        <select name="unit" required>
                            <option value="">단위 선택</option>
                            <option value="EA"  <c:if test="${product.unit == 'EA'}">selected</c:if>>EA (개)</option>
                            <option value="BOX" <c:if test="${product.unit == 'BOX'}">selected</c:if>>BOX (박스)</option>
                            <option value="KG"  <c:if test="${product.unit == 'KG'}">selected</c:if>>KG (킬로그램)</option>
                            <option value="L"   <c:if test="${product.unit == 'L'}">selected</c:if>>L (리터)</option>
                            <option value="M"   <c:if test="${product.unit == 'M'}">selected</c:if>>M (미터)</option>
                            <option value="SET" <c:if test="${product.unit == 'SET'}">selected</c:if>>SET (세트)</option>
                        </select>
                    </div>

                </div>
            </div>

            <!-- 재고 / 원가 -->
            <div class="form-section">
                <div class="section-title">재고 / 원가 정보</div>
                <div class="form-grid col3">
                    <div class="form-group">
                        <label>발주기준점</label>
                        <input type="number" name="reorderPoint" value="${product.reorderPoint}"
                               step="0.001" min="0" placeholder="0">
                        <span class="help-text">이 수량 이하 시 발주 알림</span>
                    </div>
                    <div class="form-group">
                        <label>자동발주수량</label>
                        <input type="number" name="reorderQty" value="${product.reorderQty}"
                               step="0.001" min="0" placeholder="0">
                        <span class="help-text">발주 시 기본 발주 수량</span>
                    </div>
                    <div class="form-group">
                        <label>기준원가 (원)</label>
                        <input type="number" name="unitCost" value="${product.unitCost}"
                               step="0.01" min="0" placeholder="0">
                        <span class="help-text">재고 평가·원가 계산용</span>
                    </div>
                </div>
            </div>

            <!-- 상태 (수정 시만) -->
            <c:if test="${not empty product}">
            <div class="form-section">
                <div class="section-title">상태</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>사용여부</label>
                        <select name="isActive">
                            <option value="1" <c:if test="${product.isActive == 1}">selected</c:if>>활성</option>
                            <option value="0" <c:if test="${product.isActive == 0}">selected</c:if>>비활성 (단종)</option>
                        </select>
                    </div>
                </div>
            </div>
            </c:if>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/product/list.do" class="btn btn-outline">취소</a>
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${empty product}">등록하기</c:when>
                        <c:otherwise>수정하기</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>

</main>

<c:if test="${empty product}">
<script>
const ctx = '${pageContext.request.contextPath}';

// 카테고리 변경 시 자동 호출
function onCategoryChange(category) {
    const codeInput  = document.getElementById('productCode');
    const regenBtn   = document.getElementById('regenBtn');
    const codeStatus = document.getElementById('codeStatus');

    if (!category) {
        codeInput.value = '';
        codeInput.placeholder = '카테고리 선택 시 자동 생성';
        regenBtn.disabled = true;
        codeStatus.textContent = '카테고리를 먼저 선택하세요';
        codeStatus.className = 'code-status';
        return;
    }

    generateCode();
}

// 코드 생성 (카테고리 변경 + 재생성 버튼 공용)
function generateCode() {
    const category   = document.getElementById('category').value;
    const codeInput  = document.getElementById('productCode');
    const regenBtn   = document.getElementById('regenBtn');
    const codeStatus = document.getElementById('codeStatus');

    if (!category) return;

    // 로딩 상태
    regenBtn.disabled = true;
    codeStatus.textContent = '생성 중...';
    codeStatus.className = 'code-status loading';

    fetch(ctx + '/product/generateCode.do?category=' + encodeURIComponent(category))
        .then(res => {
            if (!res.ok) throw new Error('서버 오류');
            return res.text();
        })
        .then(code => {
            codeInput.value = code;
            regenBtn.disabled = false;
            codeStatus.textContent = '✓ 자동 생성됨 (직접 수정 가능)';
            codeStatus.className = 'code-status ok';
        })
        .catch(() => {
            codeInput.value = '';
            regenBtn.disabled = false;
            codeStatus.textContent = '생성 실패 — 직접 입력하세요';
            codeStatus.className = 'code-status error';
        });
}
</script>
</c:if>

</div>
</body>
</html>
