<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    /* ── 대시보드 전용 스타일 ── */
    .page-title {
        font-size: 20px; font-weight: 700;
        color: var(--text); margin-bottom: 4px;
        letter-spacing: -0.4px;
    }
    .page-sub { font-size: 13px; color: var(--muted); margin-bottom: 24px; }

    /* 통계 카드 */
    .stat-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 16px;
        margin-bottom: 24px;
    }

    .stat-card {
        background: var(--surface);
        border-radius: 12px;
        padding: 20px;
        border: 1px solid var(--border);
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        display: flex; align-items: center; gap: 16px;
        transition: transform 0.15s, box-shadow 0.15s;
    }
    .stat-card:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.09); }

    .stat-icon {
        width: 48px; height: 48px; border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0;
    }
    .stat-icon svg { width: 24px; height: 24px; fill: white; }

    .stat-label { font-size: 12px; color: var(--muted); margin-bottom: 4px; }
    .stat-value { font-size: 26px; font-weight: 700; color: var(--text); line-height: 1; }
    .stat-sub   { font-size: 11px; color: var(--muted); margin-top: 4px; }

    /* 하단 카드 */
    .card-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }

    .card {
        background: var(--surface);
        border-radius: 12px;
        border: 1px solid var(--border);
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    .card-head {
        display: flex; align-items: center; justify-content: space-between;
        padding: 16px 20px;
        border-bottom: 1px solid var(--border);
    }
    .card-head h3 { font-size: 14px; font-weight: 600; color: var(--text); }
    .card-head a  { font-size: 12px; color: var(--accent); text-decoration: none; }
    .card-head a:hover { text-decoration: underline; }

    /* 빠른 메뉴 */
    .quick-grid {
        display: grid; grid-template-columns: 1fr 1fr 1fr;
        gap: 1px; background: var(--border);
    }

    .quick-item {
        background: var(--surface);
        display: flex; flex-direction: column;
        align-items: center; justify-content: center;
        gap: 8px; padding: 20px 12px;
        text-decoration: none;
        transition: background 0.15s;
        cursor: pointer;
    }
    .quick-item:hover { background: var(--bg); }

    .quick-icon {
        width: 40px; height: 40px; border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
    }
    .quick-icon svg { width: 20px; height: 20px; fill: white; }
    .quick-label { font-size: 12px; font-weight: 500; color: var(--text); text-align: center; }

    /* 공지/최근 테이블 */
    .notice-list { padding: 8px 0; }
    .notice-item {
        display: flex; align-items: center; gap: 12px;
        padding: 10px 20px;
        border-bottom: 1px solid var(--border);
        transition: background 0.12s;
    }
    .notice-item:last-child { border-bottom: none; }
    .notice-item:hover { background: var(--bg); }

    .notice-badge {
        font-size: 10px; padding: 2px 7px;
        border-radius: 10px; font-weight: 600; flex-shrink: 0;
    }
    .badge-new  { background: #EFF6FF; color: #2563EB; }
    .badge-info { background: #F0FDF4; color: #16A34A; }
    .badge-warn { background: #FFF7ED; color: #EA580C; }

    .notice-text { font-size: 13px; color: var(--text); flex: 1; }
    .notice-date { font-size: 11px; color: var(--muted); flex-shrink: 0; }

    /* 인사이트 바 */
    .insight-bar {
        background: linear-gradient(135deg, var(--navy) 0%, #2A3F8F 100%);
        border-radius: 12px; padding: 20px 24px;
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 24px; color: white;
    }
    .insight-greet { font-size: 15px; font-weight: 600; }
    .insight-sub   { font-size: 12px; opacity: 0.65; margin-top: 3px; }
    .insight-date  { font-size: 12px; opacity: 0.55; text-align: right; }
</style>

<main id="content">

    <!-- 인사이트 바 -->
    <div class="insight-bar">
        <div>
            <div class="insight-greet">👋 안녕하세요, ${loginUser.name}님!</div>
            <div class="insight-sub">오늘도 좋은 하루 되세요. 미결 결재 문서를 확인해보세요.</div>
        </div>
        <div class="insight-date" id="currentDateTime"></div>
    </div>

    <div class="page-title">대시보드</div>
    <div class="page-sub">ERP 시스템 현황을 한눈에 확인하세요.</div>

    <!-- 통계 카드 -->
    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background:#2563EB">
                <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
            </div>
            <div>
                <div class="stat-label">전체 직원</div>
                <div class="stat-value">0</div>
                <div class="stat-sub">명 재직 중</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#059669">
                <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4zM4 18V9.5h5c0 .83 1.79 1.5 3 1.5s3-.67 3-1.5h5V18H4z"/></svg>
            </div>
            <div>
                <div class="stat-label">전체 상품</div>
                <div class="stat-value">0</div>
                <div class="stat-sub">개 등록됨</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#D97706">
                <svg viewBox="0 0 24 24"><path d="M14 6l-1-2H5v17h2v-7h5l1 2h7V6h-6zm4 8h-4l-1-2H7V6h5l1 2h5v6z"/></svg>
            </div>
            <div>
                <div class="stat-label">미결 결재</div>
                <div class="stat-value">0</div>
                <div class="stat-sub">건 처리 대기</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#7C3AED">
                <svg viewBox="0 0 24 24"><path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/></svg>
            </div>
            <div>
                <div class="stat-label">이번달 판매</div>
                <div class="stat-value">0</div>
                <div class="stat-sub">건</div>
            </div>
        </div>
    </div>

    <!-- 하단 2열 -->
    <div class="card-grid">

        <!-- 빠른 메뉴 -->
        <div class="card">
            <div class="card-head">
                <h3>빠른 메뉴</h3>
            </div>
            <div class="quick-grid">
                <a href="${pageContext.request.contextPath}/hr/list.do" class="quick-item">
                    <div class="quick-icon" style="background:#2563EB">
                        <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                    </div>
                    <div class="quick-label">직원 관리</div>
                </a>
                <a href="${pageContext.request.contextPath}/hr/dept.do" class="quick-item">
                    <div class="quick-icon" style="background:#0891B2">
                        <svg viewBox="0 0 24 24"><path d="M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm10 12h-8v-2h2v-2h-2v-2h2v-2h-2V9h8v10zm-2-8h-2v2h2v-2zm0 4h-2v2h2v-2z"/></svg>
                    </div>
                    <div class="quick-label">부서 관리</div>
                </a>
                <a href="${pageContext.request.contextPath}/approval/list.do" class="quick-item">
                    <div class="quick-icon" style="background:#D97706">
                        <svg viewBox="0 0 24 24"><path d="M14 6l-1-2H5v17h2v-7h5l1 2h7V6h-6zm4 8h-4l-1-2H7V6h5l1 2h5v6z"/></svg>
                    </div>
                    <div class="quick-label">전자결재</div>
                </a>
                <a href="${pageContext.request.contextPath}/product/list.do" class="quick-item">
                    <div class="quick-icon" style="background:#059669">
                        <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4z"/></svg>
                    </div>
                    <div class="quick-label">상품 관리</div>
                </a>
                <a href="${pageContext.request.contextPath}/sales/list.do" class="quick-item">
                    <div class="quick-icon" style="background:#7C3AED">
                        <svg viewBox="0 0 24 24"><path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/></svg>
                    </div>
                    <div class="quick-label">판매 현황</div>
                </a>
                <a href="${pageContext.request.contextPath}/stock/list.do" class="quick-item">
                    <div class="quick-icon" style="background:#DC2626">
                        <svg viewBox="0 0 24 24"><path d="M20 2H4c-1 0-2 .9-2 2v3.01c0 .72.43 1.34 1 1.72V20c0 1.1 1.1 2 2 2h14c.9 0 2-.9 2-2V8.72c.57-.38 1-.99 1-1.71V4c0-1.1-1-2-2-2zm-5 12H9v-2h6v2zm5-7H4V4l16-.02V7z"/></svg>
                    </div>
                    <div class="quick-label">재고 현황</div>
                </a>
            </div>
        </div>

        <!-- 공지사항 -->
        <div class="card">
            <div class="card-head">
                <h3>공지사항</h3>
                <a href="#">전체보기</a>
            </div>
            <div class="notice-list">
                <div class="notice-item">
                    <span class="notice-badge badge-new">NEW</span>
                    <span class="notice-text">ERP 시스템 오픈 안내</span>
                    <span class="notice-date">2026.04.14</span>
                </div>
                <div class="notice-item">
                    <span class="notice-badge badge-info">공지</span>
                    <span class="notice-text">인사/조직 관리 모듈 개발 예정</span>
                    <span class="notice-date">2026.04.14</span>
                </div>
                <div class="notice-item">
                    <span class="notice-badge badge-warn">중요</span>
                    <span class="notice-text">영업/재고 관리 모듈 개발 예정</span>
                    <span class="notice-date">2026.04.14</span>
                </div>
                <div class="notice-item">
                    <span class="notice-badge badge-info">공지</span>
                    <span class="notice-text">전자결재 팝업 기능 개발 예정</span>
                    <span class="notice-date">2026.04.14</span>
                </div>
                <div class="notice-item">
                    <span class="notice-badge badge-info">공지</span>
                    <span class="notice-text">로그인 기능 구현 완료</span>
                    <span class="notice-date">2026.04.14</span>
                </div>
            </div>
        </div>

    </div>
</main>

<script>
// 현재 날짜/시간 표시
function updateTime() {
    const now = new Date();
    const days = ['일','월','화','수','목','금','토'];
    const str = now.getFullYear() + '년 ' +
                (now.getMonth()+1) + '월 ' +
                now.getDate() + '일 (' + days[now.getDay()] + ') ' +
                String(now.getHours()).padStart(2,'0') + ':' +
                String(now.getMinutes()).padStart(2,'0');
    document.getElementById('currentDateTime').innerText = str;
}
updateTime();
setInterval(updateTime, 1000);
</script>

</div><%-- #layout 닫기 --%>
</body>
</html>
