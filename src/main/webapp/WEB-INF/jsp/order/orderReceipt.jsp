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
    <title>주문 영수증</title>
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
        .head-right { display: flex; align-items: center; gap: 6px; }
        .btn-print {
            height: 26px; padding: 0 10px; border-radius: 2px;
            background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.3);
            color: white; font-size: 11px; font-family: inherit; cursor: pointer;
            display: flex; align-items: center; gap: 4px;
        }
        .btn-x {
            background: rgba(255,255,255,0.15); border: none; color: white;
            width: 28px; height: 28px; border-radius: 3px; font-size: 16px;
            cursor: pointer; line-height: 1;
        }

        /* ── 본문 ── */
        .pop-body { flex: 1; overflow-y: auto; padding: 16px; }

        /* ── 영수증 카드 ── */
        .receipt-card {
            background: white; border: 1px solid var(--border);
            max-width: 680px; margin: 0 auto;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        /* ── 영수증 상단 ── */
        .receipt-head {
            padding: 20px 24px 16px;
            border-bottom: 2px solid var(--blue);
            display: flex; justify-content: space-between; align-items: flex-start;
        }
        .receipt-title { font-size: 20px; font-weight: 700; color: var(--text); }
        .receipt-no    { font-size: 12px; color: var(--muted); margin-top: 4px; }
        .receipt-date  { font-size: 12px; color: var(--text); text-align: right; }
        .receipt-date strong { font-size: 14px; color: var(--blue); display: block; }

        .dtype-badge {
            display: inline-block; padding: 3px 10px; border-radius: 3px;
            font-size: 12px; font-weight: 700; margin-top: 6px;
        }
        .dtype-in  { background: #E0F2F1; color: #00796B; border: 1px solid #80CBC4; }
        .dtype-out { background: #E3F2FD; color: #1565C0; border: 1px solid #90CAF9; }
        .dtype-adj { background: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }

        /* ── 정보 그리드 ── */
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 0; border-bottom: 1px solid var(--border);
        }
        .info-cell {
            padding: 10px 24px; border-right: 1px solid var(--border);
        }
        .info-cell:nth-child(even) { border-right: none; }
        .info-label { font-size: 10px; color: var(--muted); font-weight: 600; margin-bottom: 3px; }
        .info-value { font-size: 13px; color: var(--text); font-weight: 500; }

        /* ── 상품 테이블 ── */
        .receipt-body { padding: 16px 24px; }
        .item-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .item-tbl thead th {
            background: #F5F5F5; border: 1px solid #CCC;
            padding: 7px 8px; font-weight: 600; color: #444; text-align: center;
        }
        .item-tbl tbody td {
            border: 1px solid var(--border); padding: 7px 8px; vertical-align: middle;
        }
        .item-tbl tfoot td {
            border: 1px solid #CCC; padding: 8px;
            background: #F9F9F9; font-weight: 700;
        }

        /* ── 합계 ── */
        .receipt-total {
            padding: 14px 24px; background: #F5F9FF;
            border-top: 2px solid var(--blue);
            display: flex; justify-content: flex-end; align-items: center; gap: 12px;
        }
        .total-label { font-size: 13px; color: var(--text-sm); }
        .total-amount { font-size: 20px; font-weight: 700; color: var(--blue); }

        /* ── 서명란 ── */
        .receipt-sign {
            padding: 16px 24px; border-top: 1px solid var(--border);
            display: flex; justify-content: flex-end; gap: 24px;
        }
        .sign-box {
            text-align: center; min-width: 80px;
        }
        .sign-label { font-size: 11px; color: var(--muted); margin-bottom: 6px; }
        .sign-name  { font-size: 13px; font-weight: 600; color: var(--text); }
        .sign-line  {
            height: 36px; border-bottom: 1px solid #CCC;
            display: flex; align-items: flex-end; justify-content: center;
            padding-bottom: 4px; margin-bottom: 4px; min-width: 80px;
        }

        /* ── 푸터 ── */
        .pop-foot {
            padding: 10px 16px; background: white; border-top: 1px solid var(--border);
            display: flex; gap: 6px; justify-content: flex-end; flex-shrink: 0;
        }
        .btn {
            height: 32px; padding: 0 16px; border-radius: 2px; font-size: 12px;
            font-family: inherit; font-weight: 500; cursor: pointer;
            border: 1px solid transparent; display: inline-flex; align-items: center; gap: 4px;
        }
        .btn-primary { background: var(--blue); color: white; border-color: #0055AA; }
        .btn-outline { background: white; color: var(--text); border-color: var(--border); }

        /* ── 모바일 ── */
        @media (max-width: 768px) {
            .pop-body { padding: 10px; }
            .receipt-head { flex-direction: column; gap: 8px; }
            .receipt-date { text-align: left; }
            .info-grid { grid-template-columns: 1fr; }
            .info-cell { border-right: none; border-bottom: 1px solid var(--border-lt); padding: 8px 16px; }
            .receipt-body { padding: 12px 16px; }
            .receipt-sign { gap: 12px; }
            .btn { height: 36px; font-size: 13px; }
        }

        /* ── 인쇄 스타일 ── */
        @media print {
            body { background: white; }
            .pop-head, .pop-foot, .btn-print, .btn-x { display: none !important; }
            .pop-body { padding: 0; overflow: visible; }
            .receipt-card { box-shadow: none; border: 1px solid #CCC; max-width: 100%; }
            .receipt-total { background: #F5F9FF !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

<c:set var="r" value="${receipt}"/>

<!-- 헤더 -->
<div class="pop-head">
    <div>
        <h2>주문 영수증</h2>
        <div class="sub">${r.receiptNo}</div>
    </div>
    <div class="head-right">
        <button class="btn-print" onclick="window.print()">🖨 인쇄</button>
        <button class="btn-x" onclick="closeOrBack()">✕</button>
    </div>
</div>

<!-- 본문 -->
<div class="pop-body">
<div class="receipt-card">

    <!-- 영수증 상단 -->
    <div class="receipt-head">
        <div>
            <div class="receipt-title">
                <c:choose>
                    <c:when test="${r.docType == 'INBOUND'}">입고 주문서</c:when>
                    <c:when test="${r.docType == 'OUTBOUND'}">출고 주문서</c:when>
                    <c:when test="${r.docType == 'STOCK_ADJ'}">재고 조정서</c:when>
                    <c:otherwise>주문 영수증</c:otherwise>
                </c:choose>
            </div>
            <div class="receipt-no">주문번호: ${r.receiptNo}</div>
            <div class="receipt-no" style="margin-top:2px">원본 결재: ${r.docNo}</div>
            <div style="margin-top:6px">
                <c:choose>
                    <c:when test="${r.docType == 'INBOUND'}"><span class="dtype-badge dtype-in">입고 요청서</span></c:when>
                    <c:when test="${r.docType == 'OUTBOUND'}"><span class="dtype-badge dtype-out">출고 요청서</span></c:when>
                    <c:when test="${r.docType == 'STOCK_ADJ'}"><span class="dtype-badge dtype-adj">재고 조정서</span></c:when>
                </c:choose>
            </div>
        </div>
        <div class="receipt-date">
            <div style="font-size:11px;color:var(--muted)">주문일자</div>
            <strong>${r.orderDate}</strong>
        </div>
    </div>

    <!-- 기본 정보 -->
    <div class="info-grid">
        <div class="info-cell">
            <div class="info-label">요청자</div>
            <div class="info-value">${r.requesterName} (${r.requesterId})</div>
        </div>
        <div class="info-cell">
            <div class="info-label">결재자</div>
            <div class="info-value">${empty r.approverName ? '-' : r.approverName}</div>
        </div>
        <div class="info-cell">
            <div class="info-label">거래처</div>
            <div class="info-value">${empty r.partnerName ? '-' : r.partnerName}</div>
        </div>
        <div class="info-cell">
            <div class="info-label">합계 금액</div>
            <div class="info-value" style="color:var(--blue);font-weight:700">
                <c:if test="${r.totalAmount != null && r.totalAmount > 0}">
                    <fmt:formatNumber value="${r.totalAmount}" pattern="#,###"/>원
                </c:if>
                <c:if test="${r.totalAmount == null || r.totalAmount == 0}">-</c:if>
            </div>
        </div>
    </div>

    <!-- 상품 목록 -->
    <div class="receipt-body">
        <div style="font-size:12px;font-weight:700;margin-bottom:8px;color:var(--text)">■ 상품 내역</div>
        <table class="item-tbl">
            <thead>
                <tr>
                    <th style="width:32px">No</th>
                    <th style="width:80px">상품코드</th>
                    <th>상품명</th>
                    <th style="width:45px">단위</th>
                    <th style="width:60px">수량</th>
                    <th style="width:90px">단가</th>
                    <th style="width:100px">금액</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty r.items}">
                        <tr>
                            <td colspan="7" align="center" style="padding:16px;color:var(--muted)">
                                상품 정보가 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${r.items}" var="item" varStatus="s">
                        <tr>
                            <td align="center">${s.index + 1}</td>
                            <td align="center" style="font-size:11px">${item.productCode}</td>
                            <td>${item.productName}</td>
                            <td align="center">${item.unit}</td>
                            <td align="right">${item.qty}</td>
                            <td align="right">
                                <c:if test="${item.unitCost != null && item.unitCost > 0}">
                                    <fmt:formatNumber value="${item.unitCost}" pattern="#,###"/>원
                                </c:if>
                                <c:if test="${item.unitCost == null || item.unitCost == 0}">-</c:if>
                            </td>
                            <td align="right" style="font-weight:600">
                                <c:if test="${item.amount != null && item.amount > 0}">
                                    <fmt:formatNumber value="${item.amount}" pattern="#,###"/>원
                                </c:if>
                                <c:if test="${item.amount == null || item.amount == 0}">-</c:if>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 합계 -->
    <div class="receipt-total">
        <span class="total-label">합계 금액</span>
        <span class="total-amount">
            <c:if test="${r.totalAmount != null && r.totalAmount > 0}">
                <fmt:formatNumber value="${r.totalAmount}" pattern="#,###"/>원
            </c:if>
            <c:if test="${r.totalAmount == null || r.totalAmount == 0}">-</c:if>
        </span>
    </div>

    <!-- 서명란 -->
    <div class="receipt-sign">
        <div class="sign-box">
            <div class="sign-label">요청자</div>
            <div class="sign-line"><div class="sign-name">${r.requesterName}</div></div>
        </div>
        <div class="sign-box">
            <div class="sign-label">결재자</div>
            <div class="sign-line"><div class="sign-name">${empty r.approverName ? '' : r.approverName}</div></div>
        </div>
    </div>

</div>
</div>

<!-- 푸터 -->
<div class="pop-foot">
    <button class="btn btn-primary" onclick="window.print()">🖨 인쇄</button>
    <button class="btn btn-outline" onclick="closeOrBack()">닫기</button>
</div>

<script>
function closeOrBack() {
    if (window.parent && window.parent !== window &&
        typeof window.parent.onReceiptClose === 'function') {
        window.parent.onReceiptClose();
    } else {
        history.back();
    }
}
</script>
</body>
</html>
