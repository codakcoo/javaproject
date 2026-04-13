<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<title>로그인 테스트</title>
<head>
</head>
<body>
	<h2>로그인 페이지</h2>
	<p style="color:red;">${errorMsg}</p>
	
	<form action="/loginProcess.do" method="post">
		아이디: <input type="text" name="id"><br>
		비밀번호: <input type="password" name="pw"><br>
		<button type="submit">로그인</button>
	</form>
</body>
</html>