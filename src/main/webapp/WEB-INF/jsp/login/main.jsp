<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    /* 대시보드 전용 */
    .dash-top {
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 12px;
    }
    .dash-welcome { font-size: 14px; font-weight: 700; color: var(--text); }
    .dash-date    { font-size: 12px; color: var(--muted); }

    /* 통계 카드 */
    .stat-row {
        display: grid; grid-template-columns: repeat(4, 1fr);
        gap: 8px; margin-bottom: 12px;
    }
    .stat-card {
        background: var(--surface);
        border: 1px solid var(--border);
        padding: 12px 14px;
        display: flex; align-items: center; gap: 12px;
        transition: border-color 0.15s;
    }
    .stat-card:hover { border-color: var(--blue); }
    .stat-icon-box {
        width: 36px; height: 36px; border-radius: 4px;
        display: flex; align-items: center; justify-content: center;
        flex-shrink: 0;
    }
    .stat-icon-box svg { width: 18px; height: 18px; fill: white; }
    .stat-label { font-size: 11px; color: var(--muted); margin-bottom: 3px; }
    .stat-value { font-size: 22px; font-weight: 700; color: var(--text); line-height: 1; }
    .stat-unit  { font-size: 11px; color: var(--muted); margin-top: 2px; }

    /* 하단 2열 */
    .dash-grid {
        display: grid; grid-template-columns: 1fr 1fr; gap: 8px;
    }

    /* 바로가기 메뉴 */
    .shortcut-grid {
        display: grid; grid-template-columns: repeat(3, 1fr);
        gap: 0; border-top: 1px solid var(--border-lt);
        border-left: 1px solid var(--border-lt);
    }
    .shortcut-item {
        display: flex; flex-direction: column;
        align-items: center; justify-content: center; gap: 6px;
        padding: 14px 8px;
        border-right: 1px solid var(--border-lt);
        border-bottom: 1px solid var(--border-lt);
        text-decoration: none; cursor: pointer;
        transition: background 0.1s;
    }
    .shortcut-item:hover { background: #F0F6FF; }
    .sc-icon {
        width: 32px; height: 32px; border-radius: 4px;
        display: flex; align-items: center; justify-content: center;
    }
    .sc-icon svg { width: 16px; height: 16px; fill: white; }
    .sc-label { font-size: 11px; color: var(--text-sm); font-weight: 500; text-align: center; }

    /* 공지 테이블 */
    .notice-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
    .notice-tbl th {
        background: #F5F5F5; border: 1px solid #CCCCCC;
        padding: 5px 8px; font-weight: 600; color: #444; text-align: center;
    }
    .notice-tbl td {
        border: 1px solid var(--border); padding: 5px 8px;
        color: var(--text); vertical-align: middle;
    }
    .notice-tbl tbody tr:hover { background: #F0F6FF; }
    .notice-tbl .notice-title { cursor: pointer; color: var(--text); }
    .notice-tbl .notice-title:hover { color: var(--blue); text-decoration: underline; }
</style>

<main id="content">

    <!-- 상단 인사말 -->
    <div class="dash-top">
        <div class="dash-welcome">안녕하세요, ${loginUser.name}님! 오늘도 좋은 하루 되세요.</div>
        <div class="dash-date" id="dashDate"></div>
    </div>

    <!-- 통계 카드 -->
    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-icon-box" style="background:#0066CC">
                <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
            </div>
            <div>
                <div class="stat-label">전체 직원</div>
                <div class="stat-value">0</div>
                <div class="stat-unit">명</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon-box" style="background:#2E7D32">
                <svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4z"/></svg>
            </div>
            <div>
                <div class="stat-label">전체 상품</div>
                <div class="stat-value">0</div>
                <div class="stat-unit">개</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon-box" style="background:#E65100">
                <svg viewBox="0 0 24 24"><path d="M14 6l-1-2H5v17h2v-7h5l1 2h7V6h-6z"/></svg>
            </div>
            <div>
                <div class="stat-label">미결 결재</div>
                <div class="stat-value">0</div>
                <div class="stat-unit">건</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon-box" style="background:#6A1B9A">
                <svg viewBox="0 0 24 24"><path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61z"/></svg>
            </div>
            <div>
                <div class="stat-label">이번달 판매</div>
                <div class="stat-value">0</div>
                <div class="stat-unit">건</div>
            </div>
        </div>
    </div>

    <!-- 하단 2열 -->
    <div class="dash-grid">

        <!-- 바로가기 -->
        <div class="card">
            <div class="card-head"><h3>바로가기</h3></div>
            <div class="shortcut-grid">
                <a href="${pageContext.request.contextPath}/hr/list.do" class="shortcut-item">
                    <div class="sc-icon" style="background:#0066CC"><svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg></div>
                    <div class="sc-label">직원 관리</div>
                </a>
                <a href="${pageContext.request.contextPath}/hr/dept.do" class="shortcut-item">
                    <div class="sc-icon" style="background:#00838F"><svg viewBox="0 0 24 24"><path d="M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2z"/></svg></div>
                    <div class="sc-label">부서 관리</div>
                </a>
                <a href="${pageContext.request.contextPath}/approval/list.do" class="shortcut-item">
                    <div class="sc-icon" style="background:#E65100"><svg viewBox="0 0 24 24"><path d="M14 6l-1-2H5v17h2v-7h5l1 2h7V6h-6z"/></svg></div>
                    <div class="sc-label">전자결재</div>
                </a>
                <a href="${pageContext.request.contextPath}/product/list.do" class="shortcut-item">
                    <div class="sc-icon" style="background:#2E7D32"><svg viewBox="0 0 24 24"><path d="M20 6h-2.18c.07-.44.18-.88.18-1.35C18 2.53 15.92 1 13.5 1c-1.32 0-2.5.5-3.5 1.3C9 1.5 7.82 1 6.5 1 4.08 1 2 2.53 2 4.65c0 .47.11.91.18 1.35H0v14h24V6h-4z"/></svg></div>
                    <div class="sc-label">상품 관리</div>
                </a>
                <a href="${pageContext.request.contextPath}/sales/list.do" class="shortcut-item">
                    <div class="sc-icon" style="background:#6A1B9A"><svg viewBox="0 0 24 24"><path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85z"/></svg></div>
                    <div class="sc-label">판매 현황</div>
                </a>
                <a href="${pageContext.request.contextPath}/stock/list.do" class="shortcut-item">
                    <div class="sc-icon" style="background:#C62828"><svg viewBox="0 0 24 24"><path d="M20 2H4c-1 0-2 .9-2 2v3.01c0 .72.43 1.34 1 1.72V20c0 1.1 1.1 2 2 2h14c.9 0 2-.9 2-2V8.72c.57-.38 1-.99 1-1.71V4c0-1.1-1-2-2-2z"/></svg></div>
                    <div class="sc-label">재고 현황</div>
                </a>
            </div>
        </div>

        <!-- 공지사항 -->
        <div class="card">
            <div class="card-head">
                <h3>공지사항</h3>
                <a href="#" style="font-size:11px;color:var(--blue);text-decoration:none;">전체보기 ▶</a>
            </div>
            <div class="card-body" style="padding:0">
                <table class="notice-tbl">
                    <thead>
                        <tr>
                            <th style="width:50px">구분</th>
                            <th>제목</th>
                            <th style="width:80px">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td align="center"><span class="badge badge-blue">NEW</span></td>
                            <td><span class="notice-title">ERP 시스템 오픈 안내</span></td>
                            <td align="center" style="color:var(--muted)">2026.04.14</td>
                        </tr>
                        <tr>
                            <td align="center"><span class="badge badge-gray">공지</span></td>
                            <td><span class="notice-title">인사/조직 관리 모듈 개발 예정</span></td>
                            <td align="center" style="color:var(--muted)">2026.04.14</td>
                        </tr>
                        <tr>
                            <td align="center"><span class="badge badge-orange">중요</span></td>
                            <td><span class="notice-title">영업/재고 관리 모듈 개발 예정</span></td>
                            <td align="center" style="color:var(--muted)">2026.04.14</td>
                        </tr>
                        <tr>
                            <td align="center"><span class="badge badge-gray">공지</span></td>
                            <td><span class="notice-title">전자결재 팝업 기능 개발 예정</span></td>
                            <td align="center" style="color:var(--muted)">2026.04.14</td>
                        </tr>
                        <tr>
                            <td align="center"><span class="badge badge-green">완료</span></td>
                            <td><span class="notice-title">로그인 기능 구현 완료</span></td>
                            <td align="center" style="color:var(--muted)">2026.04.14</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<script>
function updateDate() {
    const now = new Date();
    const days = ['일','월','화','수','목','금','토'];
    document.getElementById('dashDate').innerText =
        now.getFullYear() + '년 ' + (now.getMonth()+1) + '월 ' +
        now.getDate() + '일 (' + days[now.getDay()] + ') ' +
        String(now.getHours()).padStart(2,'0') + ':' +
        String(now.getMinutes()).padStart(2,'0');
}
updateDate(); setInterval(updateDate, 1000);
</script>

</div>
</body>
</html>
