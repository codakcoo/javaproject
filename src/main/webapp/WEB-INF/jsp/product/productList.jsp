<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:16px; }
    .page-title  { font-size:18px; font-weight:700; color:var(--text); }
    .page-sub    { font-size:12px; color:var(--muted); margin-top:2px; }
    .search-bar  { background:var(--surface); border:1px solid var(--border); padding:12px 16px; margin-bottom:12px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
    .search-bar input, .search-bar select { height:32px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .search-bar input:focus, .search-bar select:focus { border-color:var(--blue); }
    .search-bar input { width:180px; }
    .search-bar select { width:130px; }
    .btn { height:32px; padding:0 14px; font-size:12px; font-family:inherit; font-weight:500; cursor:pointer; border:none; display:inline-flex; align-items:center; gap:5px; text-decoration:none; transition:opacity 0.15s; }
    .btn-primary { background:var(--blue); color:white; } .btn-primary:hover { opacity:0.85; }
    .btn-outline { background:var(--surface); color:var(--text); border:1px solid var(--border); } .btn-outline:hover { background:var(--bg); }
    .ml-auto { margin-left:auto; }
    .table-wrap { background:var(--surface); border:1px solid var(--border); overflow:hidden; }
    .table-head { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; border-bottom:1px solid var(--border); }
    .table-head span { font-size:13px; font-weight:600; }
    .cnt-badge { background:var(--bg); border:1px solid var(--border); border-radius:20px; padding:1px 9px; font-size:11px; color:var(--muted); }
    table { width:100%; border-collapse:collapse; }
    thead th { background:#F8FAFC; font-size:11px; font-weight:600; color:var(--muted); text-align:left; padding:9px 14px; border-bottom:1px solid var(--border); white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9; transition:background 0.1s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#F8FAFF; }
    tbody td { padding:10px 14px; font-size:12px; color:var(--text); }
    .badge { display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:600; }
    .badge-active { background:#ECFDF5; color:#059669; } .badge-inactive { background:#F1F5F9; color:#94A3B8; }
    .action-btns { display:flex; gap:5px; }
    .btn-edit { background:#EFF6FF; color:#2563EB; border:none; padding:3px 9px; font-size:11px; font-family:inherit; cursor:pointer; font-weight:500; }
    .btn-edit:hover { background:#DBEAFE; }
    .btn-del  { background:#FFF1F2; color:#E11D48; border:none; padding:3px 9px; font-size:11px; font-family:inherit; cursor:pointer; font-weight:500; }
    .btn-del:hover  { background:#FFE4E6; }
    .modal-bg { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:500; align-items:center; justify-content:center; }
    .modal-bg.open { display:flex; }
    .modal { background:var(--surface); width:480px; padding:24px; box-shadow:0 8px 32px rgba(0,0,0,0.18); }
    .modal-title { font-size:15px; font-weight:700; margin-bottom:18px; }
    .form-row { margin-bottom:12px; }
    .form-row label { display:block; font-size:11px; font-weight:600; color:var(--muted); margin-bottom:4px; }
    .form-row input, .form-row select { width:100%; height:34px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .form-row input:focus, .form-row select:focus { border-color:var(--blue); background:var(--surface); }
    .form-2col { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
    .form-3col { display:grid; grid-template-columns:1fr 1fr 1fr; gap:10px; }
    .modal-footer { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">상품 관리</div>
            <div class="page-sub">영업/재고 &gt; 상품 관리</div>
        </div>
        <button class="btn btn-primary" onclick="document.getElementById('insertModal').classList.add('open')">+ 상품 등록</button>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/product/list.do">
        <div class="search-bar">
            <select name="searchCategory">
                <option value="">전체 카테고리</option>
                <option value="식품"   ${searchVO.searchCategory eq '식품'   ? 'selected' : ''}>식품</option>
                <option value="전자"   ${searchVO.searchCategory eq '전자'   ? 'selected' : ''}>전자</option>
                <option value="소모품" ${searchVO.searchCategory eq '소모품' ? 'selected' : ''}>소모품</option>
                <option value="원자재" ${searchVO.searchCategory eq '원자재' ? 'selected' : ''}>원자재</option>
                <option value="기타"   ${searchVO.searchCategory eq '기타'   ? 'selected' : ''}>기타</option>
            </select>
            <input type="text" name="searchKeyword" value="${searchVO.searchKeyword}" placeholder="상품명 / 코드 검색">
            <button type="submit" class="btn btn-primary">검색</button>
            <a href="${pageContext.request.contextPath}/product/list.do" class="btn btn-outline">초기화</a>
            <span class="ml-auto" style="font-size:12px; color:var(--muted);">총 <strong>${totalCount}</strong>개</span>
        </div>
    </form>

    <div class="table-wrap">
        <div class="table-head">
            <span>상품 목록</span>
            <span class="cnt-badge">${totalCount}건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>상품코드</th><th>상품명</th><th>카테고리</th><th>단위</th>
                    <th style="text-align:right">원가</th>
                    <th style="text-align:right">발주기준점</th>
                    <th style="text-align:right">기본발주량</th>
                    <th>상태</th><th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty productList}">
                        <tr><td colspan="10" style="text-align:center; padding:30px; color:var(--muted);">등록된 상품이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${productList}">
                            <tr>
                                <td style="color:var(--muted)">${p.productId}</td>
                                <td><code style="font-size:11px; background:#F1F5F9; padding:2px 5px;">${p.productCode}</code></td>
                                <td><strong>${p.productName}</strong></td>
                                <td>${p.category}</td>
                                <td>${p.unit}</td>
                                <td style="text-align:right"><fmt:formatNumber value="${p.unitCost}" pattern="#,##0.00"/>원</td>
                                <td style="text-align:right"><fmt:formatNumber value="${p.reorderPoint}" pattern="#,##0.###"/></td>
                                <td style="text-align:right"><fmt:formatNumber value="${p.reorderQty}"   pattern="#,##0.###"/></td>
                                <td>
                                    <span class="badge ${p.isActive eq 1 ? 'badge-active' : 'badge-inactive'}">
                                        ${p.isActive eq 1 ? '판매중' : '중단'}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-edit" onclick="openUpdateModal(${p.productId},'${p.productCode}','${p.productName}','${p.category}','${p.unit}',${p.unitCost},${p.reorderPoint},${p.reorderQty},${p.isActive})">수정</button>
                                        <button class="btn-del"  onclick="doDelete(${p.productId},'${p.productName}')">삭제</button>
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

<!-- 등록 모달 -->
<div class="modal-bg" id="insertModal">
    <div class="modal">
        <div class="modal-title">상품 등록</div>
        <form method="post" action="${pageContext.request.contextPath}/product/insert.do">
            <div class="form-2col">
                <div class="form-row"><label>상품코드 *</label><input type="text" name="productCode" placeholder="예: FOOD-011" required></div>
                <div class="form-row"><label>카테고리</label>
                    <select name="category">
                        <option value="식품">식품</option><option value="전자">전자</option>
                        <option value="소모품">소모품</option><option value="원자재">원자재</option><option value="기타">기타</option>
                    </select>
                </div>
            </div>
            <div class="form-row"><label>상품명 *</label><input type="text" name="productName" required></div>
            <div class="form-2col">
                <div class="form-row"><label>단위</label>
                    <select name="unit"><option value="EA">EA</option><option value="BOX">BOX</option><option value="KG">KG</option><option value="L">L</option></select>
                </div>
                <div class="form-row"><label>원가</label><input type="number" name="unitCost" step="0.01" min="0" value="0"></div>
            </div>
            <div class="form-2col">
                <div class="form-row"><label>발주기준점</label><input type="number" name="reorderPoint" step="0.001" min="0" value="0"></div>
                <div class="form-row"><label>기본발주량</label><input type="number" name="reorderQty"   step="0.001" min="0" value="0"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="document.getElementById('insertModal').classList.remove('open')">취소</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </form>
    </div>
</div>

<!-- 수정 모달 -->
<div class="modal-bg" id="updateModal">
    <div class="modal">
        <div class="modal-title">상품 수정</div>
        <form method="post" action="${pageContext.request.contextPath}/product/update.do">
            <input type="hidden" name="productId" id="u_id">
            <div class="form-2col">
                <div class="form-row"><label>상품코드</label><input type="text" name="productCode" id="u_code"></div>
                <div class="form-row"><label>카테고리</label>
                    <select name="category" id="u_cat">
                        <option value="식품">식품</option><option value="전자">전자</option>
                        <option value="소모품">소모품</option><option value="원자재">원자재</option><option value="기타">기타</option>
                    </select>
                </div>
            </div>
            <div class="form-row"><label>상품명</label><input type="text" name="productName" id="u_name" required></div>
            <div class="form-2col">
                <div class="form-row"><label>단위</label>
                    <select name="unit" id="u_unit"><option value="EA">EA</option><option value="BOX">BOX</option><option value="KG">KG</option><option value="L">L</option></select>
                </div>
                <div class="form-row"><label>원가</label><input type="number" name="unitCost" id="u_cost" step="0.01" min="0"></div>
            </div>
            <div class="form-2col">
                <div class="form-row"><label>발주기준점</label><input type="number" name="reorderPoint" id="u_rp" step="0.001" min="0"></div>
                <div class="form-row"><label>기본발주량</label><input type="number" name="reorderQty"   id="u_rq" step="0.001" min="0"></div>
            </div>
            <div class="form-row"><label>상태</label>
                <select name="isActive" id="u_active"><option value="1">판매중</option><option value="0">중단</option></select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="document.getElementById('updateModal').classList.remove('open')">취소</button>
                <button type="submit" class="btn btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>

<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/product/delete.do">
    <input type="hidden" name="productId" id="del_id">
</form>

<script>
function openUpdateModal(id,code,name,cat,unit,cost,rp,rq,active){
    document.getElementById('u_id').value=id;
    document.getElementById('u_code').value=code;
    document.getElementById('u_name').value=name;
    document.getElementById('u_cat').value=cat;
    document.getElementById('u_unit').value=unit;
    document.getElementById('u_cost').value=cost;
    document.getElementById('u_rp').value=rp;
    document.getElementById('u_rq').value=rq;
    document.getElementById('u_active').value=active;
    document.getElementById('updateModal').classList.add('open');
}
function doDelete(id,name){
    if(!confirm('['+id+'] '+name+' 을(를) 삭제하시겠습니까?')) return;
    document.getElementById('del_id').value=id;
    document.getElementById('deleteForm').submit();
}
document.querySelectorAll('.modal-bg').forEach(bg=>{
    bg.addEventListener('click',function(e){ if(e.target===this) this.classList.remove('open'); });
});
</script>

</div><%-- layout 닫기 --%>
</body>
</html>
