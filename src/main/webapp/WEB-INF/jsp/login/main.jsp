<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
/* ══════════════════════════════════════════
   대시보드 전용 스타일 (안 2 — 모던 분석형)
   ══════════════════════════════════════════ */

/* ── 환영 배너 ── */
.dash-banner {
    background: linear-gradient(135deg, #0066CC 0%, #004BA0 100%);
    padding: 16px 20px;
    margin-bottom: 14px;
    display: flex; align-items: center; justify-content: space-between;
    flex-wrap: wrap; gap: 8px;
}
.dash-banner-left h2 {
    font-size: 15px; font-weight: 700; color: white; margin-bottom: 3px;
}
.dash-banner-left p {
    font-size: 12px; color: rgba(255,255,255,0.75);
}
.dash-banner-right {
    text-align: right;
}
.dash-clock {
    font-size: 20px; font-weight: 700; color: white; letter-spacing: 1px;
}
.dash-date-str {
    font-size: 11px; color: rgba(255,255,255,0.7); margin-top: 2px;
}

/* ── KPI 카드 4개 ── */
.kpi-row {
    display: grid; grid-template-columns: repeat(4, 1fr);
    gap: 8px; margin-bottom: 12px;
}
.kpi-card {
    background: var(--surface); border: 1px solid var(--border);
    padding: 14px 16px; position: relative; overflow: hidden;
    transition: box-shadow 0.15s, border-color 0.15s;
    cursor: default;
}
.kpi-card:hover {
    border-color: var(--blue);
    box-shadow: 0 2px 12px rgba(0,102,204,0.10);
}
.kpi-card::before {
    content: ''; position: absolute; top: 0; left: 0;
    width: 3px; height: 100%;
}
.kpi-card.c-blue::before   { background: #0066CC; }
.kpi-card.c-green::before  { background: #2E7D32; }
.kpi-card.c-orange::before { background: #E65100; }
.kpi-card.c-purple::before { background: #6A1B9A; }

.kpi-top {
    display: flex; align-items: flex-start; justify-content: space-between;
    margin-bottom: 10px;
}
.kpi-icon-box {
    width: 38px; height: 38px; border-radius: 6px;
    display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.kpi-icon-box svg { width: 20px; height: 20px; fill: white; }

.kpi-trend {
    display: flex; align-items: center; gap: 2px;
    font-size: 11px; font-weight: 600; padding: 2px 6px;
    border-radius: 10px;
}
.kpi-trend.up   { color: #059669; background: #ECFDF5; }
.kpi-trend.down { color: #E11D48; background: #FFF1F2; }
.kpi-trend.flat { color: #888;    background: #F5F5F5; }

.kpi-value {
    font-size: 28px; font-weight: 700; color: var(--text); line-height: 1;
    margin-bottom: 4px;
}
.kpi-label { font-size: 12px; color: var(--muted); }

/* ── 메인 그리드 (2열) ── */
.dash-main {
    display: grid; grid-template-columns: 2fr 1fr;
    gap: 8px;
}

/* ── 섹션 카드 ── */
.d-card {
    background: var(--surface); border: 1px solid var(--border);
    display: flex; flex-direction: column;
}
.d-card-head {
    display: flex; align-items: center; justify-content: space-between;
    padding: 9px 14px; border-bottom: 1px solid var(--border);
    background: #FAFAFA; flex-shrink: 0;
}
.d-card-head h3 { font-size: 12px; font-weight: 700; color: var(--text); }
.d-card-head a  {
    font-size: 11px; color: var(--blue); text-decoration: none;
}
.d-card-head a:hover { text-decoration: underline; }
.d-card-body { padding: 0; flex: 1; }

/* ── 최근 결재 목록 ── */
.activity-list { list-style: none; }
.activity-item {
    display: flex; align-items: center; gap: 10px;
    padding: 9px 14px; border-bottom: 1px solid var(--border-lt);
    transition: background 0.1s;
}
.activity-item:last-child { border-bottom: none; }
.activity-item:hover { background: #F5F9FF; }

.act-dot {
    width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0;
}
.act-dot.pending     { background: #D97706; }
.act-dot.inprogress  { background: #4338CA; }
.act-dot.approved    { background: #059669; }
.act-dot.rejected    { background: #E11D48; }

.act-info { flex: 1; min-width: 0; }
.act-title {
    font-size: 12px; color: var(--text); font-weight: 500;
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.act-meta  { font-size: 11px; color: var(--muted); margin-top: 1px; }

.act-badge {
    font-size: 10px; font-weight: 600; padding: 2px 7px;
    border-radius: 2px; flex-shrink: 0;
}
.act-badge.pending    { background: #FFF7ED; color: #D97706; border: 1px solid #FCD34D; }
.act-badge.inprogress { background: #EEF2FF; color: #4338CA; border: 1px solid #A5B4FC; }
.act-badge.approved   { background: #ECFDF5; color: #059669; border: 1px solid #6EE7B7; }
.act-badge.rejected   { background: #FFF1F2; color: #E11D48; border: 1px solid #FDA4AF; }

.act-empty {
    padding: 28px 14px; text-align: center;
    font-size: 12px; color: var(--muted);
}

/* ── 오른쪽 패널 (빠른 메뉴 + 공지) ── */
.right-panel {
    display: flex; flex-direction: column; gap: 8px;
}

/* ── 빠른 메뉴 ── */
.quick-grid {
    display: grid; grid-template-columns: 1fr 1fr;
    gap: 0;
    border-top: 1px solid var(--border-lt);
    border-left: 1px solid var(--border-lt);
}
.quick-item {
    display: flex; align-items: center; gap: 8px;
    padding: 10px 12px;
    border-right: 1px solid var(--border-lt);
    border-bottom: 1px solid var(--border-lt);
    text-decoration: none; transition: background 0.1s;
}
.quick-item:hover { background: #F0F6FF; }
.q-icon {
    width: 28px; height: 28px; border-radius: 4px;
    display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.q-icon svg { width: 14px; height: 14px; fill: white; }
.q-label { font-size: 11px; color: var(--text-sm); font-weight: 500; }

/* ── 공지사항 ── */
.notice-list { list-style: none; }
.notice-item {
    display: flex; align-items: center; gap: 8px;
    padding: 7px 14px; border-bottom: 1px solid var(--border-lt);
    cursor: pointer; transition: background 0.1s;
}
.notice-item:last-child { border-bottom: none; }
.notice-item:hover { background: #F5F9FF; }
.n-tag {
    font-size: 10px; font-weight: 700; padding: 1px 5px;
    border-radius: 2px; flex-shrink: 0; min-width: 28px; text-align: center;
}
.n-tag.new  { background: #0066CC; color: white; }
.n-tag.imp  { background: #E65100; color: white; }
.n-tag.pub  { background: #F5F5F5; color: #555; border: 1px solid #CCC; }
.n-tag.done { background: #2E7D32; color: white; }
.n-title { font-size: 11px; color: var(--text); flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.n-date  { font-size: 10px; color: var(--muted); flex-shrink: 0; }

/* ══════════════════════════════
   반응형
   ══════════════════════════════ */
@media (max-width: 1024px) {
    .kpi-row { grid-template-columns: repeat(2, 1fr); }
    .dash-main { grid-template-columns: 1fr; }
    .right-panel { flex-direction: row; }
    .right-panel .d-card { flex: 1; }
}

@media (max-width: 768px) {
    .dash-banner { padding: 12px 14px; }
    .dash-banner-left h2 { font-size: 13px; }
    .dash-clock { font-size: 16px; }
    .kpi-row { grid-template-columns: repeat(2, 1fr); gap: 6px; }
    .kpi-value { font-size: 22px; }
    .kpi-card { padding: 10px 12px; }
    .dash-main { grid-template-columns: 1fr; }
    .right-panel { flex-direction: column; }
    .quick-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 480px) {
    .kpi-row { gap: 5px; }
    .kpi-value { font-size: 20px; }
}
</style>

<main id="content" style="padding:0;">

    <!-- ── 환영 배너 ── -->
    <div class="dash-banner">
        <div class="dash-banner-left">
            <h2>안녕하세요, ${loginUser.name}님! </h2>
            <p>오늘도 좋은 하루 되세요.</p>
        </div>
        <div class="dash-banner-right">
            <div class="dash-clock" id="dashClock">00:00</div>
            <div class="dash-date-str" id="dashDate"></div>
        </div>
    </div>

    <div style="padding: 0 14px 14px;">

    <!-- ── KPI 카드 4개 ── -->
    <div class="kpi-row">

        <!-- 직원 -->
        <div class="kpi-card c-blue">
            <div class="kpi-top">
                <div class="kpi-icon-box" style="background:#0066CC">
                    <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                </div>
                <span class="kpi-trend flat">— 유지</span>
            </div>
            <div class="kpi-value">${empty empCount ? 0 : empCount}</div>
            <div class="kpi-label">전체 직원</div>
        </div>

        <!-- 상품 -->
        <div class="kpi-card c-green">
            <div class="kpi-top">
                <div class="kpi-icon-box" style="background:#2E7D32">
                    <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4z"/></svg>
                </div>
                <span class="kpi-trend flat">— 유지</span>
            </div>
            <div class="kpi-value">${empty productCount ? 0 : productCount}</div>
            <div class="kpi-label">전체 상품</div>
        </div>

        <!-- 미결 결재 -->
        <div class="kpi-card c-orange">
            <div class="kpi-top">
                <div class="kpi-icon-box" style="background:#E65100">
                    <svg viewBox="0 0 24 24"><path d="M14 6l-1-2H5v17h2v-7h5l1 2h7V6h-6z"/></svg>
                </div>
                <c:choose>
                    <c:when test="${not empty pendingCount && pendingCount > 0}">
                        <span class="kpi-trend down">↑ ${pendingCount}건</span>
                    </c:when>
                    <c:otherwise>
                        <span class="kpi-trend flat">— 없음</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="kpi-value">${empty pendingCount ? 0 : pendingCount}</div>
            <div class="kpi-label">미결 결재</div>
        </div>

        <!-- 이번달 주문 -->
        <div class="kpi-card c-purple">
            <div class="kpi-top">
                <div class="kpi-icon-box" style="background:#6A1B9A">
                    <svg viewBox="0 0 24 24"><path d="M17 12h-5v5h5v-5zM16 1v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2h-1V1h-2z"/></svg>
                </div>
                <span class="kpi-trend up">↑ 이번달</span>
            </div>
            <div class="kpi-value">${empty monthOrderCount ? 0 : monthOrderCount}</div>
            <div class="kpi-label">이번달 주문</div>
        </div>

    </div>

    <!-- ── 메인 그리드 ── -->
    <div class="dash-main">

        <!-- 왼쪽: 최근 결재 활동 -->
        <div class="d-card">
            <div class="d-card-head">
                <h3>📋 최근 결재 현황</h3>
                <a href="${pageContext.request.contextPath}/approval/list.do">전체보기 ▶</a>
            </div>
            <div class="d-card-body">
                <ul class="activity-list">
                    <c:choose>
                        <c:when test="${empty recentApprovals}">
                            <div class="act-empty">
                                최근 결재 내역이 없습니다.<br>
                                <a href="${pageContext.request.contextPath}/approval/form.do"
                                   style="color:var(--blue);font-size:12px;margin-top:6px;display:inline-block;">
                                    + 결재 문서 작성하기
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${recentApprovals}" var="doc">
                            <li class="activity-item">
                                <c:choose>
                                    <c:when test="${doc.status == 'PENDING'}">
                                        <div class="act-dot pending"></div>
                                    </c:when>
                                    <c:when test="${doc.status == 'IN_PROGRESS'}">
                                        <div class="act-dot inprogress"></div>
                                    </c:when>
                                    <c:when test="${doc.status == 'APPROVED'}">
                                        <div class="act-dot approved"></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="act-dot rejected"></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="act-info">
                                    <div class="act-title">${doc.title}</div>
                                    <div class="act-meta">
                                        ${doc.requesterName} ·
                                        <c:choose>
                                            <c:when test="${doc.docType == 'INBOUND'}">입고</c:when>
                                            <c:when test="${doc.docType == 'OUTBOUND'}">출고</c:when>
                                            <c:when test="${doc.docType == 'STOCK_ADJ'}">재고조정</c:when>
                                        </c:choose>
                                        · ${doc.requestedAt}
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${doc.status == 'PENDING'}">
                                        <span class="act-badge pending">기안중</span>
                                    </c:when>
                                    <c:when test="${doc.status == 'IN_PROGRESS'}">
                                        <span class="act-badge inprogress">진행중</span>
                                    </c:when>
                                    <c:when test="${doc.status == 'APPROVED'}">
                                        <span class="act-badge approved">결재완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="act-badge rejected">반려</span>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <!-- 오른쪽 패널 -->
        <div class="right-panel">

            <!-- 빠른 메뉴 -->
            <div class="d-card">
                <div class="d-card-head"><h3>빠른 메뉴</h3></div>
                <div class="d-card-body">
                    <div class="quick-grid">
                        <a href="${pageContext.request.contextPath}/hr/list.do" class="quick-item">
                            <div class="q-icon" style="background:#0066CC">
                                <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                            </div>
                            <span class="q-label">직원 관리</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/hr/dept.do" class="quick-item">
                            <div class="q-icon" style="background:#00838F">
                                <svg viewBox="0 0 24 24"><path d="M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2z"/></svg>
                            </div>
                            <span class="q-label">부서 관리</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/product/list.do" class="quick-item">
                            <div class="q-icon" style="background:#2E7D32">
                                <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4z"/></svg>
                            </div>
                            <span class="q-label">상품 관리</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/approval/list.do" class="quick-item">
                            <div class="q-icon" style="background:#E65100">
                                <svg viewBox="0 0 24 24"><path d="M14 6l-1-2H5v17h2v-7h5l1 2h7V6h-6z"/></svg>
                            </div>
                            <span class="q-label">전자결재</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/sales/list.do" class="quick-item">
                            <div class="q-icon" style="background:#6A1B9A">
                                <svg viewBox="0 0 24 24"><path d="M17 12h-5v5h5v-5zM16 1v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2h-1V1h-2z"/></svg>
                            </div>
                            <span class="q-label">판매 현황</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/order/list.do" class="quick-item">
                            <div class="q-icon" style="background:#C62828">
                                <svg viewBox="0 0 24 24"><path d="M20 2H4c-1 0-2 .9-2 2v3.01c0 .72.43 1.34 1 1.72V20c0 1.1 1.1 2 2 2h14c.9 0 2-.9 2-2V8.72c.57-.38 1-.99 1-1.71V4c0-1.1-1-2-2-2z"/></svg>
                            </div>
                            <span class="q-label">주문 내역</span>
                        </a>
                    </div>
                </div>
            </div>

            <!-- 재고 부족 알림 -->
            <div class="d-card">
                <div class="d-card-head">
                    <h3>재고 부족 알림</h3>
                    <a href="${pageContext.request.contextPath}/stock/list.do">재고 현황 ▶</a>
                </div>
                <div class="d-card-body">
                    <c:choose>
                        <c:when test="${empty lowStockList}">
                            <div class="act-empty" style="padding:18px">
                                재고 부족 상품이 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <ul class="activity-list">
                                <c:forEach items="${lowStockList}" var="p">
                                <li class="activity-item">
                                    <div style="width:8px;height:8px;border-radius:50%;background:#E11D48;flex-shrink:0"></div>
                                    <div class="act-info">
                                        <div class="act-title">${p.productName}</div>
                                        <div class="act-meta">
                                            ${p.productCode} · 현재 ${p.qtyOnHand}${p.unit} / 기준 ${p.reorderPoint}${p.unit}
                                        </div>
                                    </div>
                                    <div style="text-align:right;flex-shrink:0">
                                        <div style="font-size:12px;font-weight:700;color:#E11D48">${p.qtyOnHand}${p.unit}</div>
                                        <div style="font-size:10px;color:var(--muted)">남음</div>
                                    </div>
                                </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 개발 진행 현황 -->
            <div class="d-card">
                <div class="d-card-head"><h3>개발 진행 현황</h3></div>
                <div class="d-card-body">
                    <ul class="notice-list">
                        <li class="notice-item">
                            <span class="n-tag done">완료</span>
                            <span class="n-title">로그인 / 회원 관리</span>
                            <span class="n-date">완료</span>
                        </li>
                        <li class="notice-item">
                            <span class="n-tag done">완료</span>
                            <span class="n-title">인사 / 조직 관리 모듈</span>
                            <span class="n-date">완료</span>
                        </li>
                        <li class="notice-item">
                            <span class="n-tag done">완료</span>
                            <span class="n-title">영업 / 재고 관리 모듈</span>
                            <span class="n-date">완료</span>
                        </li>
                        <li class="notice-item">
                            <span class="n-tag done">완료</span>
                            <span class="n-title">전자결재 모듈 (승인/반려)</span>
                            <span class="n-date">완료</span>
                        </li>
                        <li class="notice-item">
                            <span class="n-tag new">진행</span>
                            <span class="n-title">주문 관리 / 영수증 모듈</span>
                            <span class="n-date">진행중</span>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
    </div>

    </div><%-- /padding div --%>
</main>

<script>
function updateClock() {
    var now  = new Date();
    var days = ['일','월','화','수','목','금','토'];
    var h    = String(now.getHours()).padStart(2,'0');
    var m    = String(now.getMinutes()).padStart(2,'0');
    var s    = String(now.getSeconds()).padStart(2,'0');
    document.getElementById('dashClock').textContent = h + ':' + m + ':' + s;
    document.getElementById('dashDate').textContent  =
        now.getFullYear() + '년 ' + (now.getMonth()+1) + '월 ' +
        now.getDate() + '일 (' + days[now.getDay()] + ')';
}
updateClock();
setInterval(updateClock, 1000);
</script>

</div>
</body>
</html>
