<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
    <h2>${loginUser.name}님 환영합니다!</h2>
    <p>권한: ${loginUser.role}</p>
    <a href="/logout.do">로그아웃</a>
</body>
</html>