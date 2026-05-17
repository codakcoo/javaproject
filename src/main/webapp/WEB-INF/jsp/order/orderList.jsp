<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header {
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 10px; padding-bottom: 8px;
        border-bottom: 2px solid var(--blue);
        flex-wrap: wrap; gap: 8px;
    }
    .page-title { font-size: 15px; font-weight: 700; color: var(--text); }
    .page-sub   { font-size: 11px; color: var(--muted); margin-top: 2px; }

    .search-bar {
        background: var(--surface); border: 1px solid var(--border);
        padding: 8px 12px; margin-bottom: 8px;
        display: flex; gap: 6px; align-items: center; flex-wrap: wrap;
    }
    .search-bar label { font-size: 12px; color: var(--text-sm); white-space: nowrap; }
    .search-bar select, .search-bar input {
        height: 26px; padding: 0 6px; border: 1px solid #BBBBBB;
        border-radius: 2px; font-size: 12px; font-family: inherit; outline: none;
    }
    .search-bar select:focus, .search-bar input:focus { border-color: var(--blue); }

    .tbl-wrap { border: 1px solid var(--border); overflow-x: auto; -webkit-overflow-scrolling: touch; background: var(--surface); }
    .tbl { width: 100%; border-collapse: collapse; font-size: 12px; min-width: 620px; }
    .tbl thead th {
        background: #F5F5F5; border: 1px solid #CCC;
        padding: 6px 8px; font-weight: 600; color: #333; text-align: center;
        white-space: nowrap;
    }
    .tbl tbody td { border: 1px solid var(--border); padding: 6px 8px; vertical-align: middle; }
    .tbl tbody tr:hover { background: #F0F6FF; }
    .tbl-link { color: var(--blue); cursor: pointer; font-weight: 500; }
    .tbl-link:hover { text-decoration: underline; }

    .dtype { display: inline-block; padding: 1px 6px; border-radius: 2px; font-size: 11px; font-weight: 600; }
    .dtype-in  { background: #E0F2F1; color: #00796B; border: 1px solid #80CBC4; }
    .dtype-out { background: #E3F2FD; color: #1565C0; border: 1px solid #90CAF9; }
    .dtype-adj { background: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }

    .btn-sm {
        height: 22px; padding: 0 8px; border-radius: 2px; font-size: 11px;
        font-family: inherit; font-weight: 500; cursor: pointer;
        border: 1px solid; white-space: nowrap;
    }
    .btn-view { background: #EFF6FF; color: #2563EB; border-color: #93C5FD; }

    /* ── PC 모달 ── */
    .modal-overlay {
        display: none; position: fixed; inset: 0; z-index: 400;
        background: rgba(0,0,0,0.5);
        align-items: center; justify-content: center;
    }
    .modal-overlay.active { display: flex; }
    .modal-box {
        background: white; width: 740px; max-width: 95vw;
        max-height: 90vh; border-radius: 4px;
        display: flex; flex-direction: column;
        box-shadow: 0 8px 40px rgba(0,0,0,0.25); overflow: hidden;
    }
    .modal-iframe { border: none; flex: 1; min-height: 580px; }

    @media (max-width: 768px) {
        .tbl thead th, .tbl tbody td { font-size: 11px; padding: 5px 6px; }
    }
</style>

<main id="content">

    <div class="page-header">
        <div>
            <div class="page-title">주문 관리</div>
            <div class="page-sub">주문관리 &gt; 영수증</div>
        </div>
    </div>

    <!-- 검색 -->
    <form action="${pageContext.request.contextPath}/order/list.do" method="get">
    <div class="search-bar">
        <label>문서유형</label>
        <select name="searchDocType">
            <option value="">전체</option>
            <option value="INBOUND"   ${searchVO.searchDocType == 'INBOUND'   ? 'selected' : ''}>입고 요청서</option>
            <option value="OUTBOUND"  ${searchVO.searchDocType == 'OUTBOUND'  ? 'selected' : ''}>출고 요청서</option>
            <option value="STOCK_ADJ" ${searchVO.searchDocType == 'STOCK_ADJ' ? 'selected' : ''}>재고 조정서</option>
        </select>
        <label>검색</label>
        <input type="text" name="searchKeyword" value="${searchVO.searchKeyword}"
               placeholder="주문번호 / 거래처 검색" style="width:160px">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/order/list.do" class="btn btn-outline">초기화</a>
        <span style="margin-left:auto;font-size:11px;color:var(--muted)">총 ${totalCount}건</span>
    </div>
    </form>

    <!-- 테이블 -->
    <div class="tbl-wrap">
        <table class="tbl">
            <thead>
                <tr>
                    <th style="width:50px">번호</th>
                    <th style="width:130px">주문번호</th>
                    <th style="width:80px">문서유형</th>
                    <th style="width:120px">원본 결재번호</th>
                    <th style="width:70px">요청자</th>
                    <th style="width:70px">결재자</th>
                    <th style="width:90px">거래처</th>
                    <th style="width:90px">합계금액</th>
                    <th style="width:120px">주문일자</th>
                    <th style="width:60px">보기</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty receiptList}">
                        <tr>
                            <td colspan="10" align="center" style="padding:30px;color:var(--muted)">
                                주문 내역이 없습니다. 결재 승인 시 자동으로 생성됩니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${receiptList}" var="r" varStatus="s">
                        <tr>
                            <td align="center">${s.index + 1}</td>
                            <td align="center" style="font-size:11px">
                                <span class="tbl-link" onclick="viewReceipt(${r.receiptId})">${r.receiptNo}</span>
                            </td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${r.docType == 'INBOUND'}"><span class="dtype dtype-in">입고</span></c:when>
                                    <c:when test="${r.docType == 'OUTBOUND'}"><span class="dtype dtype-out">출고</span></c:when>
                                    <c:when test="${r.docType == 'STOCK_ADJ'}"><span class="dtype dtype-adj">재고조정</span></c:when>
                                </c:choose>
                            </td>
                            <td align="center" style="font-size:11px;color:var(--muted)">${r.docNo}</td>
                            <td align="center">${r.requesterName}</td>
                            <td align="center">${empty r.approverName ? '-' : r.approverName}</td>
                            <td align="center" style="font-size:11px">${empty r.partnerName ? '-' : r.partnerName}</td>
                            <td align="right">
                                <c:if test="${r.totalAmount != null && r.totalAmount > 0}">
                                    <fmt:formatNumber value="${r.totalAmount}" pattern="#,###"/>원
                                </c:if>
                                <c:if test="${r.totalAmount == null || r.totalAmount == 0}">-</c:if>
                            </td>
                            <td align="center" style="font-size:11px">${r.orderDate}</td>
                            <td align="center">
                                <button class="btn-sm btn-view" onclick="viewReceipt(${r.receiptId})">보기</button>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</main>

<!-- PC 모달 -->
<div class="modal-overlay" id="receiptModal" onclick="closeReceiptModal(event)">
    <div class="modal-box">
        <iframe id="receiptIframe" class="modal-iframe" src=""></iframe>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';

function viewReceipt(receiptId) {
    var url = ctx + '/order/receipt.do?receiptId=' + receiptId;
    if (window.innerWidth <= 768) {
        // 모바일: 페이지 이동
        location.href = url;
    } else {
        // PC: 모달
        document.getElementById('receiptIframe').src = url;
        document.getElementById('receiptModal').classList.add('active');
    }
}

function closeReceiptModal(e) {
    if (e.target.id === 'receiptModal') {
        document.getElementById('receiptModal').classList.remove('active');
        document.getElementById('receiptIframe').src = '';
    }
}

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.getElementById('receiptModal').classList.remove('active');
        document.getElementById('receiptIframe').src = '';
    }
});

// iframe에서 호출
function onReceiptClose() {
    document.getElementById('receiptModal').classList.remove('active');
    document.getElementById('receiptIframe').src = '';
}
</script>

</div>
</body>
</html>
