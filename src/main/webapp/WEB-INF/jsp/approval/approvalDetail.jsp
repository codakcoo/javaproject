<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    Object loginUser = session.getAttribute("loginUser");
    if(loginUser == null) {
        out.println("<script>alert('로그인이 필요합니다.'); window.close();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결재 문서 상세</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --blue:#0066CC; --border:#DDDDDD; --text:#222; --muted:#888; }
        body {
            font-family: -apple-system, "Malgun Gothic", sans-serif;
            font-size: 12px; background: #F2F3F5; color: var(--text);
            display: flex; flex-direction: column; height: 100vh;
        }

        /* 헤더 */
        .pop-head {
            background: var(--blue); padding: 10px 16px;
            display: flex; align-items: center; justify-content: space-between; flex-shrink: 0;
        }
        .pop-head h2 { font-size: 14px; font-weight: 700; color: white; }
        .pop-head .sub { font-size: 11px; color: rgba(255,255,255,0.6); margin-top: 1px; }
        .btn-x {
            background: rgba(255,255,255,0.15); border: none; color: white;
            width: 26px; height: 26px; border-radius: 3px; font-size: 14px; cursor: pointer;
        }

        /* 결재선 */
        .approval-line {
            background: white; border-bottom: 1px solid var(--border);
            padding: 10px 16px; display: flex; align-items: center; gap: 8px; flex-shrink: 0;
        }
        .approver-box {
            border: 1px solid var(--border); padding: 6px 14px;
            text-align: center; min-width: 80px; border-radius: 2px;
        }
        .approver-box .role  { font-size: 10px; color: var(--muted); }
        .approver-box .name  { font-size: 13px; font-weight: 700; margin-top: 2px; }
        .approver-box .stamp {
            font-size: 11px; font-weight: 700; border-radius: 2px;
            padding: 2px 7px; display: inline-block; margin-top: 4px;
        }
        .stamp-done    { border: 2px solid #059669; color: #059669; }
        .stamp-pending { border: 2px solid #D97706; color: #D97706; }
        .stamp-prog    { border: 2px solid #4338CA; color: #4338CA; }
        .stamp-reject  { border: 2px solid #E11D48; color: #E11D48; }
        .arr { color: var(--muted); font-size: 18px; }

        /* 본문 */
        .pop-body { flex: 1; overflow-y: auto; padding: 14px 16px; }

        .section { background: white; border: 1px solid var(--border); margin-bottom: 10px; }
        .section-head {
            background: #F5F5F5; border-bottom: 1px solid var(--border);
            padding: 6px 12px; font-size: 11px; font-weight: 700; color: #444;
        }
        .section-body { padding: 0; }

        /* 정보 테이블 */
        .info-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .info-tbl th {
            background: #FAFAFA; border: 1px solid var(--border);
            padding: 7px 10px; font-weight: 600; color: #555;
            text-align: right; white-space: nowrap; width: 100px;
        }
        .info-tbl td {
            border: 1px solid var(--border);
            padding: 7px 10px; color: var(--text);
        }

        /* 상품 테이블 */
        .item-tbl { width: 100%; border-collapse: collapse; font-size: 12px; }
        .item-tbl th {
            background: #F5F5F5; border: 1px solid #CCC;
            padding: 6px 8px; font-weight: 600; color: #444; text-align: center;
        }
        .item-tbl td { border: 1px solid var(--border); padding: 6px 8px; vertical-align: middle; }

        /* 반려 사유 박스 */
        .reject-box {
            background: #FFF1F2; border: 1px solid #FECDD3;
            border-radius: 3px; padding: 10px 12px; margin: 10px 12px;
            font-size: 12px; color: #E11D48;
        }
        .reject-box strong { display: block; margin-bottom: 4px; }

        /* 배지 */
        .badge { display: inline-block; padding: 2px 8px; border-radius: 2px; font-size: 11px; font-weight: 600; }
        .badge-pending    { background: #FFF7ED; color: #D97706; border: 1px solid #FCD34D; }
        .badge-inprogress { background: #EEF2FF; color: #4338CA; border: 1px solid #A5B4FC; }
        .badge-approved   { background: #ECFDF5; color: #059669; border: 1px solid #6EE7B7; }
        .badge-rejected   { background: #FFF1F2; color: #E11D48; border: 1px solid #FDA4AF; }
        .dtype { display: inline-block; padding: 1px 6px; border-radius: 2px; font-size: 11px; font-weight: 600; }
        .dtype-in  { background: #E0F2F1; color: #00796B; border: 1px solid #80CBC4; }
        .dtype-out { background: #E3F2FD; color: #1565C0; border: 1px solid #90CAF9; }
        .dtype-adj { background: #FFF3E0; color: #E65100; border: 1px solid #FFCC80; }

        /* 푸터 */
        .pop-foot {
            padding: 10px 16px; background: white; border-top: 1px solid var(--border);
            display: flex; gap: 6px; justify-content: flex-end; flex-shrink: 0;
        }
        .btn {
            height: 28px; padding: 0 14px; border-radius: 2px; font-size: 12px;
            font-family: inherit; font-weight: 500; cursor: pointer;
            border: 1px solid transparent; display: inline-flex; align-items: center;
        }
        .btn-approve  { background: #ECFDF5; color: #059669; border-color: #6EE7B7; }
        .btn-progress { background: #EEF2FF; color: #4338CA; border-color: #A5B4FC; }
        .btn-reject   { background: #FFF1F2; color: #E11D48; border-color: #FDA4AF; }
        .btn-outline  { background: white; color: var(--text); border-color: var(--border); }
    </style>
</head>
<body>

<c:set var="doc" value="${doc}"/>

<!-- 헤더 -->
<div class="pop-head">
    <div>
        <h2>결재 문서 상세</h2>
        <div class="sub">${doc.docNo}</div>
    </div>
    <button class="btn-x" onclick="window.close()">✕</button>
</div>

<!-- 결재선 -->
<div class="approval-line">
    <div class="approver-box">
        <div class="role">기안</div>
        <div class="name">${doc.requesterName}</div>
        <div class="stamp stamp-done">기안</div>
    </div>
    <div class="arr">→</div>
    <div class="approver-box">
        <div class="role">결재</div>
        <div class="name">${empty doc.approverName ? '미지정' : doc.approverName}</div>
        <c:choose>
            <c:when test="${doc.status == 'APPROVED'}">
                <div class="stamp stamp-done">승인</div>
            </c:when>
            <c:when test="${doc.status == 'REJECTED'}">
                <div class="stamp stamp-reject">반려</div>
            </c:when>
            <c:when test="${doc.status == 'IN_PROGRESS'}">
                <div class="stamp stamp-prog">검토중</div>
            </c:when>
            <c:otherwise>
                <div class="stamp stamp-pending">대기</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="pop-body">

    <!-- 반려 사유 (반려일 때만 표시) -->
    <c:if test="${doc.status == 'REJECTED' && not empty doc.rejectReason}">
        <div class="reject-box">
            <strong>반려 사유</strong>
            ${doc.rejectReason}
        </div>
    </c:if>

    <!-- 문서 정보 -->
    <div class="section">
        <div class="section-head">문서 정보</div>
        <div class="section-body">
            <table class="info-tbl">
                <tr>
                    <th>문서번호</th>
                    <td>${doc.docNo}</td>
                    <th>문서유형</th>
                    <td>
                        <c:choose>
                            <c:when test="${doc.docType == 'INBOUND'}">
                                <span class="dtype dtype-in">입고 요청서</span>
                            </c:when>
                            <c:when test="${doc.docType == 'OUTBOUND'}">
                                <span class="dtype dtype-out">출고 요청서</span>
                            </c:when>
                            <c:when test="${doc.docType == 'STOCK_ADJ'}">
                                <span class="dtype dtype-adj">재고 조정서</span>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="3" style="font-weight:600">${doc.title}</td>
                </tr>
                <tr>
                    <th>기안자</th>
                    <td>${doc.requesterName} (${doc.requesterId})</td>
                    <th>결재자</th>
                    <td>${empty doc.approverName ? '-' : doc.approverName}</td>
                </tr>
                <tr>
                    <th>거래처</th>
                    <td>${empty doc.partnerName ? '-' : doc.partnerName}</td>
                    <th>주소</th>
                    <td style="font-size:11px;color:var(--muted)">${empty doc.partnerAddress ? '-' : doc.partnerAddress}</td>
                </tr>
                <tr>
                    <th>상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${doc.status == 'PENDING'}">
                                <span class="badge badge-pending">기안중</span>
                            </c:when>
                            <c:when test="${doc.status == 'IN_PROGRESS'}">
                                <span class="badge badge-inprogress">진행중</span>
                            </c:when>
                            <c:when test="${doc.status == 'APPROVED'}">
                                <span class="badge badge-approved">결재완료</span>
                            </c:when>
                            <c:when test="${doc.status == 'REJECTED'}">
                                <span class="badge badge-rejected">반려</span>
                            </c:when>
                        </c:choose>
                    </td>
                    <th>처리일</th>
                    <td>${empty doc.approvedAt ? '-' : doc.approvedAt}</td>
                </tr>
                <tr>
                    <th>기안일</th>
                    <td colspan="3">${doc.requestedAt}</td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 상품 목록 -->
    <div class="section">
        <div class="section-head">상품 목록</div>
        <div class="section-body">
            <table class="item-tbl">
                <thead>
                    <tr>
                        <th style="width:36px">No</th>
                        <th style="width:90px">상품코드</th>
                        <th>상품명</th>
                        <th style="width:60px">단위</th>
                        <th style="width:70px">수량</th>
                        <th style="width:90px">단가</th>
                        <th style="width:90px">금액</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty doc.items}">
                            <tr>
                                <td colspan="8" align="center" style="padding:20px;color:var(--muted)">
                                    상품 정보가 없습니다.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${doc.items}" var="item" varStatus="s">
                            <tr>
                                <td align="center">${s.index + 1}</td>
                                <td align="center" style="font-size:11px">${item.productCode}</td>
                                <td>${item.productName}</td>
                                <td align="center">${item.unit}</td>
                                <td align="right">${item.qty}</td>
                                <td align="right">
                                    <c:if test="${item.unitCost != null && item.unitCost > 0}">
                                        <fmt:formatNumber value="${item.unitCost}" pattern="#,###" xmlns:fmt="http://java.sun.com/jsp/jstl/fmt"/>원
                                    </c:if>
                                    <c:if test="${item.unitCost == null || item.unitCost == 0}">-</c:if>
                                </td>
                                <td align="right">
                                    <c:if test="${item.unitCost != null && item.unitCost > 0}">
                                        <fmt:formatNumber value="${item.qty * item.unitCost}" pattern="#,###" xmlns:fmt="http://java.sun.com/jsp/jstl/fmt"/>원
                                    </c:if>
                                    <c:if test="${item.unitCost == null || item.unitCost == 0}">-</c:if>
                                </td>
                                <td style="color:var(--muted)">${empty item.remarks ? '-' : item.remarks}</td>
                            </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- 푸터: 상태에 따라 버튼 다르게 -->
<div class="pop-foot">
    <c:if test="${doc.status == 'PENDING'}">
        <button class="btn btn-progress" onclick="doAction('startReview')">검토 시작</button>
        <button class="btn btn-reject"   onclick="doAction('reject')">반려</button>
    </c:if>
    <c:if test="${doc.status == 'IN_PROGRESS'}">
        <button class="btn btn-approve" onclick="doAction('approve')">승인</button>
        <button class="btn btn-reject"  onclick="doAction('reject')">반려</button>
    </c:if>
    <button class="btn btn-outline" onclick="window.close()">닫기</button>
</div>

<script>
var CTX    = '${pageContext.request.contextPath}';
var DOC_ID = '${doc.docId}';

function doAction(action) {
    var url, body;
    if (action === 'startReview') {
        if (!confirm('검토를 시작하시겠습니까?')) return;
        url  = CTX + '/approval/startReview.do';
        body = 'docId=' + DOC_ID;
    } else if (action === 'approve') {
        if (!confirm('승인 처리하시겠습니까?')) return;
        url  = CTX + '/approval/approve.do';
        body = 'docId=' + DOC_ID;
    } else if (action === 'reject') {
        var reason = prompt('반려 사유를 입력하세요:');
        if (!reason || !reason.trim()) return;
        url  = CTX + '/approval/reject.do';
        body = 'docId=' + DOC_ID + '&rejectReason=' + encodeURIComponent(reason);
    }

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body
    })
    .then(function(res) { return res.text(); })
    .then(function(result) {
        if (result === 'OK') {
            alert('처리되었습니다.');
            if (opener && !opener.closed) opener.location.reload();
            window.close();
        } else {
            alert('처리 중 오류가 발생했습니다.');
        }
    });
}
</script>
</body>
</html>
