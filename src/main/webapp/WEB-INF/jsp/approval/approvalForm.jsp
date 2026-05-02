<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // 팝업은 별도 세션 체크 (선택)
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
    <title>전자결재 - 문서 작성</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy:   #1E2761;
            --accent: #4A90D9;
            --border: #E2E8F0;
            --text:   #1E293B;
            --muted:  #64748B;
            --bg:     #F0F4FF;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: #F8FAFC; color: var(--text);
            height: 100vh; display: flex; flex-direction: column;
        }

        /* 팝업 헤더 */
        .popup-header {
            background: var(--navy); padding: 14px 20px;
            display: flex; align-items: center; justify-content: space-between;
            flex-shrink: 0;
        }
        .popup-header h2 { font-size: 15px; font-weight: 700; color: white; }
        .popup-header .sub { font-size: 11px; color: rgba(255,255,255,0.5); margin-top: 2px; }
        .btn-close {
            width: 28px; height: 28px; border-radius: 6px;
            background: rgba(255,255,255,0.1); border: none;
            color: white; font-size: 16px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: background 0.15s;
        }
        .btn-close:hover { background: rgba(255,255,255,0.2); }

        /* 스크롤 영역 */
        .popup-body {
            flex: 1; overflow-y: auto; padding: 20px;
        }

        /* 결재선 표시 */
        .approval-line {
            background: white; border: 1px solid var(--border);
            border-radius: 10px; padding: 14px 18px; margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }
        .approver-box {
            border: 1px solid var(--border); border-radius: 8px;
            padding: 8px 14px; text-align: center; min-width: 80px;
        }
        .approver-box .role { font-size: 10px; color: var(--muted); }
        .approver-box .name { font-size: 13px; font-weight: 600; color: var(--navy); margin-top: 2px; }
        .approver-box .stamp {
            font-size: 10px; color: #059669; font-weight: 700;
            border: 1px solid #059669; border-radius: 4px;
            padding: 1px 6px; display: inline-block; margin-top: 3px;
        }
        .arrow-icon { color: var(--muted); font-size: 18px; }

        /* 폼 */
        .form-section {
            background: white; border: 1px solid var(--border);
            border-radius: 10px; padding: 16px 18px; margin-bottom: 14px;
        }
        .section-title {
            font-size: 12px; font-weight: 700; color: var(--navy);
            margin-bottom: 12px; padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
        }

        .form-row { display: flex; gap: 12px; margin-bottom: 10px; }
        .form-row:last-child { margin-bottom: 0; }
        .form-group { display: flex; flex-direction: column; gap: 4px; flex: 1; }
        .form-group label {
            font-size: 11px; font-weight: 600; color: var(--muted);
        }
        .form-group label .req { color: #E11D48; }
        .form-group input,
        .form-group select,
        .form-group textarea {
            height: 36px; padding: 0 10px;
            border: 1px solid var(--border); border-radius: 7px;
            font-size: 13px; font-family: inherit;
            color: var(--text); background: var(--bg); outline: none;
            transition: border-color 0.2s;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--accent);
            background: white;
        }
        .form-group textarea {
            height: 130px; padding: 10px; resize: vertical;
        }
        .form-group input[readonly] {
            background: #F1F5F9; color: var(--muted);
        }

        /* 파일 첨부 */
        .file-zone {
            border: 2px dashed var(--border); border-radius: 8px;
            padding: 16px; text-align: center; cursor: pointer;
            transition: border-color 0.15s;
        }
        .file-zone:hover { border-color: var(--accent); }
        .file-zone p { font-size: 12px; color: var(--muted); margin-top: 4px; }
        .file-zone svg { width: 24px; height: 24px; fill: var(--muted); }

        /* 하단 버튼 */
        .popup-footer {
            padding: 12px 20px; background: white;
            border-top: 1px solid var(--border);
            display: flex; gap: 10px; justify-content: flex-end;
            flex-shrink: 0;
        }
        .btn {
            height: 38px; padding: 0 20px; border-radius: 8px;
            font-size: 13px; font-family: inherit; font-weight: 500;
            cursor: pointer; border: none; display: inline-flex;
            align-items: center; gap: 5px; transition: opacity 0.15s;
        }
        .btn-primary { background: var(--accent); color: white; }
        .btn-primary:hover { opacity: 0.88; }
        .btn-outline { background: white; color: var(--text); border: 1px solid var(--border); }
        .btn-outline:hover { background: var(--bg); }
        .btn-danger { background: #FFF1F2; color: #E11D48; border: 1px solid #FECDD3; }
        .btn-danger:hover { background: #FFE4E6; }
    </style>
</head>
<body>

<!-- 팝업 헤더 -->
<div class="popup-header">
    <div>
        <h2>전자결재 문서 작성</h2>
        <div class="sub">기안자: ${loginUser.name} (${loginUser.role})</div>
    </div>
    <button class="btn-close" onclick="window.close()">✕</button>
</div>

<!-- 스크롤 영역 -->
<div class="popup-body">

    <!-- 결재선 -->
    <div class="approval-line">
        <div class="approver-box">
            <div class="role">기안</div>
            <div class="name">${loginUser.name}</div>
            <div class="stamp">기안</div>
        </div>
        <div class="arrow-icon">→</div>
        <div class="approver-box">
            <div class="role">결재</div>
            <div class="name" id="approverNameDisplay">미지정</div>
            <div class="stamp" style="color:#D97706;border-color:#D97706">대기</div>
        </div>
    </div>

    <form id="approvalForm" action="${pageContext.request.contextPath}/approval/insert.do" method="post">
        <input type="hidden" name="writerId" value="${loginUser.memberId}">
        <c:if test="${not empty param.empId}">
            <input type="hidden" name="relEmpId" value="${param.empId}">
        </c:if>

        <!-- 문서 기본 정보 -->
        <div class="form-section">
            <div class="section-title">문서 정보</div>
            <div class="form-row">
                <div class="form-group">
                    <label>문서 유형 <span class="req">*</span></label>
                    <select name="docType" required onchange="updateTitle(this)">
                        <option value="">유형 선택</option>
                        <option value="연차신청">연차 신청</option>
                        <option value="출장신청">출장 신청</option>
                        <option value="비품구매">비품 구매 요청</option>
                        <option value="초과근무">초과근무 신청</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>결재자 <span class="req">*</span></label>
                    <select name="approverId" required onchange="updateApproverName(this)">
                        <option value="">결재자 선택</option>
                        <%-- DB 연동 후 forEach로 교체 --%>
                        <option value="MGR001">김팀장 (개발팀장)</option>
                        <option value="MGR002">이부장 (영업부장)</option>
                        <option value="MGR003">박이사 (인사이사)</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>제목 <span class="req">*</span></label>
                    <input type="text" name="title" id="docTitle" placeholder="결재 제목을 입력하세요" required>
                </div>
            </div>
        </div>

        <!-- 문서 내용 -->
        <div class="form-section">
            <div class="section-title">결재 내용</div>
            <div class="form-row">
                <div class="form-group">
                    <label>상세 내용 <span class="req">*</span></label>
                    <textarea name="content" placeholder="결재 내용을 상세히 입력하세요." required></textarea>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group" style="flex:1">
                    <label>시작일</label>
                    <input type="date" name="startDate">
                </div>
                <div class="form-group" style="flex:1">
                    <label>종료일</label>
                    <input type="date" name="endDate">
                </div>
                <div class="form-group" style="flex:1">
                    <label>관련 금액 (원)</label>
                    <input type="number" name="amount" placeholder="해당 시 입력">
                </div>
            </div>
        </div>

        <!-- 파일 첨부 -->
        <div class="form-section">
            <div class="section-title">첨부 파일 (선택)</div>
            <div class="file-zone" onclick="document.getElementById('fileInput').click()">
                <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm4 18H6V4h7v5h5v11zM8 15.01l1.41 1.41L11 14.84V19h2v-4.16l1.59 1.59L16 15.01 12.01 11 8 15.01z"/></svg>
                <p>클릭하여 파일 첨부 (최대 10MB)</p>
            </div>
            <input type="file" id="fileInput" name="attachFile" style="display:none">
        </div>

    </form>
</div>

<!-- 하단 버튼 -->
<div class="popup-footer">
    <button class="btn btn-outline" onclick="window.close()">취소</button>
    <button class="btn btn-primary" onclick="submitForm()">결재 올리기</button>
</div>

<script>
// 결재자 이름 표시 업데이트
function updateApproverName(sel) {
    const name = sel.options[sel.selectedIndex].text.split(' ')[0];
    document.getElementById('approverNameDisplay').innerText = sel.value ? name : '미지정';
}

// 문서 유형 선택 시 제목 자동 입력
function updateTitle(sel) {
    const titleInput = document.getElementById('docTitle');
    const today = new Date().toLocaleDateString('ko-KR', { year:'numeric', month:'long', day:'numeric' });
    if(sel.value && !titleInput.value) {
        titleInput.value = today + ' ' + sel.value + ' - ${loginUser.name}';
    }
}

// 제출
function submitForm() {
    const form = document.getElementById('approvalForm');
    if(!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    if(confirm('결재를 올리시겠습니까?')) {
        form.submit();
        // 제출 후 처리: approvalComplete.jsp에서 아래 코드 실행
        // if(opener) opener.location.reload();
        // window.close();
    }
}
</script>

</body>
</html>
