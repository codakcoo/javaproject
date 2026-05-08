<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - ERP 시스템</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary:   #2563EB; --primary-h: #1D4ED8;
            --bg:        #F1F5F9; --surface:   #FFFFFF;
            --border:    #E2E8F0; --text:      #1E293B;
            --muted:     #94A3B8; --error:     #EF4444;
            --radius:    12px;   --shadow:    0 4px 24px rgba(0,0,0,0.08);
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: var(--bg); min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
        }
        .card {
            background: var(--surface); border-radius: var(--radius);
            box-shadow: var(--shadow); padding: 48px 40px;
            width: 100%; max-width: 420px; animation: fadeUp 0.4s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        h1 { font-size: 22px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
        .subtitle { font-size: 13px; color: var(--muted); margin-bottom: 32px; }
        .field { margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 500; color: var(--text); margin-bottom: 6px; }
        input[type="text"], input[type="password"] {
            width: 100%; height: 46px; padding: 0 14px;
            border: 1.5px solid var(--border); border-radius: 8px;
            font-size: 14px; font-family: inherit; color: var(--text);
            outline: none; transition: border-color 0.2s, box-shadow 0.2s;
        }
        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
        }
        input::placeholder { color: var(--muted); }
        .btn {
            display: block; width: 100%; height: 48px; margin-top: 24px;
            background: var(--primary); color: white;
            font-size: 15px; font-weight: 600; font-family: inherit;
            border: none; border-radius: 8px; cursor: pointer;
            transition: background 0.2s, transform 0.1s;
        }
        .btn:hover  { background: var(--primary-h); }
        .btn:active { transform: scale(0.98); }
        .error-msg {
            background: #FEF2F2; border: 1px solid #FECACA;
            color: var(--error); font-size: 13px;
            padding: 10px 14px; border-radius: 8px; margin-bottom: 16px;
        }
        .back-link {
            display: block; text-align: center; margin-top: 20px;
            font-size: 13px; color: var(--muted); text-decoration: none;
        }
        .back-link:hover { color: var(--primary); }
        <!-- 약관 박스 스타일 -->
        .terms-box {
    border: 1px solid #ddd;
    padding: 12px;
    height: 100px;
    overflow-y: scroll;
    font-size: 13px;
    color: #555;
    margin-bottom: 8px;
    border-radius: 6px;
}
.terms-label {
    font-size: 13px;
    display: flex;
    align-items: center;
    gap: 6px;
    cursor: pointer;
}
    </style>
</head>
<body>
<div class="card">
    <h1>회원가입</h1>
    <p class="subtitle">정보를 입력하고 가입하세요.</p>

    <c:if test="${not empty errorMsg}">
        <div class="error-msg">${errorMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/registerProcess.do" method="post">
        <div class="field">
            <label>아이디</label>
            <input type="text" name="memberId" placeholder="아이디를 입력하세요" required>
        </div>
        <div class="field">
            <label>비밀번호</label>
            <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
        </div>
        <div class="field">
            <label>이름</label>
            <input type="text" name="name" placeholder="이름을 입력하세요" required>
        </div>
        <div class="field">
            <label>이메일</label>
            <input type="email" name="email" placeholder="이메일을 입력하세요" required>
        </div>
        <div class="field">
            <label>생년월일</label>
            <input type="date" name="birthDate" required>
        </div>
        <div class="field">
            <label>전화번호</label>
            <input type="text" name="phone" placeholder="010-0000-0000" required>
        </div>
        <div class="field">
            <label>성별</label>
            <select name="gender" required>
                <option value="">선택하세요</option>
                <option value="M">남성</option>
                <option value="F">여성</option>
            </select>
        </div>
    	<div class="field">
    		<label>부서</label>
    	 <select name="department" required>
        <option value="">부서를 선택하세요</option>
        <option value="개발팀">개발팀</option>
        <option value="인사팀">인사팀</option>
        <option value="영업팀">영업팀</option>
    </select>
		</div>
        <!-- 약관동의 -->
        <div class="field">
            <div class="terms-box">
                <p><strong>이용약관</strong></p>
                <p>본 ERP 시스템은 사내 업무용으로만 사용 가능합니다.</p>
                <p>개인정보는 인사팀에서 관리하며 외부에 공개되지 않습니다.</p>
                <p>가입 신청 후 인사팀 승인이 완료되어야 로그인이 가능합니다.</p>
            </div>
            <label class="terms-label">
                <input type="checkbox" id="agreeCheck" name="agree" value="true">
                위 약관에 동의합니다 (필수)
            </label>
        </div>

        <button type="submit" class="btn" id="submitBtn" disabled>가입하기</button>
    </form>
    <a href="${pageContext.request.contextPath}/login.do" class="back-link">로그인으로 돌아가기</a>
</div>

<!-- 약관 체크 시 버튼 활성화 -->
<script>
    document.getElementById('agreeCheck').addEventListener('change', function() {
        document.getElementById('submitBtn').disabled = !this.checked;
    });
</script>
</body>
</html>
