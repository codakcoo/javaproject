<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header {
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 20px;
    }
    .page-title { font-size: 20px; font-weight: 700; color: var(--text); letter-spacing: -0.4px; }
    .page-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; }

    .search-card {
        background: var(--surface); border: 1px solid var(--border);
        border-radius: 12px; padding: 16px 20px; margin-bottom: 16px;
        display: flex; gap: 10px; align-items: center; flex-wrap: wrap;
    }
    .search-card input, .search-card select {
        height: 36px; padding: 0 12px;
        border: 1px solid var(--border); border-radius: 8px;
        font-size: 13px; font-family: inherit; color: var(--text);
        outline: none; background: var(--bg); transition: border-color 0.2s;
    }
    .search-card input:focus, .search-card select:focus { border-color: var(--accent); }
    .search-card input  { width: 200px; }
    .search-card select { width: 130px; }

    .btn { height: 36px; padding: 0 16px; border-radius: 8px; font-size: 13px;
           font-family: inherit; font-weight: 500; cursor: pointer; border: none;
           display: inline-flex; align-items: center; gap: 6px; text-decoration: none;
           transition: opacity 0.15s, transform 0.1s; }
    .btn:active { transform: scale(0.97); }
    .btn-primary { background: var(--accent); color: white; }
    .btn-primary:hover { opacity: 0.88; }
    .btn-outline { background: var(--surface); color: var(--text); border: 1px solid var(--border); }
    .btn-outline:hover { background: var(--bg); }
    .btn-success { background: #059669; color: white; }
    .btn-success:hover { opacity: 0.88; }

    .table-card {
        background: var(--surface); border: 1px solid var(--border);
        border-radius: 12px; overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .table-card-head {
        display: flex; align-items: center; justify-content: space-between;
        padding: 14px 20px; border-bottom: 1px solid var(--border);
    }
    .table-card-head span { font-size: 14px; font-weight: 600; color: var(--text); }
    .total-badge {
        background: var(--bg); border: 1px solid var(--border);
        border-radius: 20px; padding: 2px 10px;
        font-size: 12px; color: var(--muted);
    }

    table { width: 100%; border-collapse: collapse; }
    thead th {
        background: #F8FAFC; font-size: 12px; font-weight: 600;
        color: var(--muted); text-align: left; padding: 10px 16px;
        border-bottom: 1px solid var(--border); white-space: nowrap;
    }
    tbody tr { border-bottom: 1px solid #F1F5F9; transition: background 0.1s; }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: #F8FAFF; }
    tbody td { padding: 11px 16px; font-size: 13px; color: var(--text); }

    .status-badge {
        display: inline-block; padding: 3px 9px;
        border-radius: 20px; font-size: 11px; font-weight: 600;
    }
    .status-active   { background: #ECFDF5; color: #059669; }
    .status-inactive { background: #F1F5F9; color: #94A3B8; }

    .warn-badge {
        display: inline-block; padding: 3px 9px;
        border-radius: 20px; font-size: 11px; font-weight: 600;
        background: #FFF7ED; color: #EA580C;
    }

    .action-btns { display: flex; gap: 6px; }
    .btn-edit { background: #EFF6FF; color: #2563EB; border: none;
                padding: 4px 10px; border-radius: 6px; font-size: 12px;
                font-family: inherit; cursor: pointer; font-weight: 500; transition: background 0.15s; }
    .btn-edit:hover { background: #DBEAFE; }
    .btn-del  { background: #FFF1F2; color: #E11D48; border: none;
                padding: 4px 10px; border-radius: 6px; font-size: 12px;
                font-family: inherit; cursor: pointer; font-weight: 500; transition: background 0.15s; }
    .btn-del:hover { background: #FFE4E6; }

    .empty-row td { text-align: center; padding: 48px; color: var(--muted); font-size: 14px; }
    .num { text-align: right; }
</style>

<main id="content">

    <div class="page-header">
        <div>
            <div class="page-title">상품 관리</div>
            <div class="page-sub">등록된 상품 목록을 조회하고 관리합니다.</div>
        </div>
        <a href="${pageContext.request.contextPath}/product/insertForm.do" class="btn btn-success">
            + 상품 등록
        </a>
    </div>

    <!-- 검색 -->
    <form action="${pageContext.request.contextPath}/product/list.do" method="get">
    <div class="search-card">
        <select name="category">
            <option value="">전체 카테고리</option>
            <option value="식품"      <c:if test="${searchVO.category == '식품'}">selected</c:if>>식품</option>
            <option value="전자"      <c:if test="${searchVO.category == '전자'}">selected</c:if>>전자</option>
            <option value="소모품"    <c:if test="${searchVO.category == '소모품'}">selected</c:if>>소모품</option>
            <option value="원자재"    <c:if test="${searchVO.category == '원자재'}">selected</c:if>>원자재</option>
            <option value="기타"      <c:if test="${searchVO.category == '기타'}">selected</c:if>>기타</option>
        </select>
        <select name="isActive">
            <option value="">전체 상태</option>
            <option value="1" <c:if test="${searchVO.isActive == 1}">selected</c:if>>활성</option>
            <option value="0" <c:if test="${searchVO.isActive == 0}">selected</c:if>>비활성</option>
        </select>
        <input type="text" name="keyword" value="${searchVO.keyword}" placeholder="상품명 또는 코드 검색">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/product/list.do" class="btn btn-outline">초기화</a>
    </div>
    </form>

    <!-- 테이블 -->
    <div class="table-card">
        <div class="table-card-head">
            <span>상품 목록</span>
            <span class="total-badge">총 <strong>${empty productList ? '0' : productList.size()}</strong>건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>상품코드</th>
                    <th>상품명</th>
                    <th>카테고리</th>
                    <th>단위</th>
                    <th>발주기준점</th>
                    <th>기준원가</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty productList}">
                        <tr class="empty-row"><td colspan="8">등록된 상품이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${productList}" var="p">
                        <tr>
                            <td><strong>${p.productCode}</strong></td>
                            <td>${p.productName}</td>
                            <td>${p.category}</td>
                            <td>${p.unit}</td>
                            <td class="num">
                                <fmt:formatNumber value="${p.reorderPoint}" pattern="#,##0.###"/>
                                <c:if test="${p.reorderPoint > 0}">
                                    <span class="warn-badge" style="margin-left:4px">발주주의</span>
                                </c:if>
                            </td>
                            <td class="num"><fmt:formatNumber value="${p.unitCost}" pattern="#,##0"/>원</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.isActive == 1}"><span class="status-badge status-active">활성</span></c:when>
                                    <c:otherwise><span class="status-badge status-inactive">비활성</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <button class="btn-edit"
                                        onclick="location.href='${pageContext.request.contextPath}/product/updateForm.do?productId=${p.productId}'">수정</button>
                                    <form action="${pageContext.request.contextPath}/product/delete.do" method="post" style="display:inline">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button type="submit" class="btn-del"
                                            onclick="return confirm('\'${p.productName}\' 상품을 비활성화하시겠습니까?')">삭제</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</main>

</div>
</body>
</html>
