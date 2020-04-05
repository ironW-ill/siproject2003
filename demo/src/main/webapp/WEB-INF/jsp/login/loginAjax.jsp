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

<input id="tid" type="text" name="username"> 
<input id="pwd" type="text" name="password">
<button type="submit" onclick="idchkbtnPost()">확인</button>

<script>
var ajax = new XMLHttpRequest();

function idchkbtnPost() {
	fid = document.getElementById('tid');
	fpwd = document.getElementById('pwd');

	//console.log(fid.value);

	//data = {'username':fid.value, 'password':fpwd.value};

	//data = fid.value;
	
	data = fid.value + "," + fpwd.value;
	
	//console.table("아이디 = " + data.username + " 비번 = " + data.password);
	console.table(data);

	ajax.onreadystatechange = callbackajaxPost;

	ajax.open('POST', 'rest_idchk');
	//ajax.setRequestHeader("Accept", "application/text/plain");
	//ajax.setRequestHeader("Content-Type", "application/json");
	//ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	//ajax.send(JSON.stringify(data));
	ajax.send(data);
}

//텍스트로 인식 <-> 이름:값 (객체)로 인식하느냐
function callbackajaxPost() {
	if (ajax.readyState == 4) {
		alert(ajax.responseText);
	}
}

function idchkbtnGet() {
	fid = document.getElementById('tid');
	fpwd = document.getElementById('pwd');

	console.log(fid.value);

	ajax.onreadystatechange = callbackajax;

	ajax.open('GET', 'rest_idchk?id=' + fid.value + '&pw=' + fpwd.value);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send();
}


//텍스트로 인식 <-> 이름:값 (객체)로 인식하느냐
function callbackajax() {
	if (ajax.readyState == 4) {
		if (ajax.responseText == 0) {
			alert("로그인 실패");
		} 
		
		if (ajax.responseText == 1) {
			alert("로그인 성공");
		}
	}
}
</script>

</body>
</html>