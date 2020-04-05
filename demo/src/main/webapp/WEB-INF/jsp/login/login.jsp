<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>login page</h1>
	<% String name = request.getParameter("name");%>
	<p><%=param%></p>
	<form action="/loginResult" method="post">
		<input type="text" name="username">
		<input type="text" name="password">
		<button type=submit>확인</button>
	</form>
</body>
</html>