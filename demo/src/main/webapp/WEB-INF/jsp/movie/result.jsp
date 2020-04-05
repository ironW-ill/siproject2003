<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 조회 결과</title>
</head>
<body>
	<table border="1">
		<thead>
			<tr>
				<th>영화제목 ["title"]</th>
				<th>영화링크 ["link"]</th>
				<th>영화이미지["image"]</th>
				<th>영화부제["subtitle"]</th>
				<th>영화개봉일["pubDate"]</th>
				<th>감독이름["director"]</th>
				<th>주요배우["actor"]</th>
				<th>평점["userRating"]</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="movie" items="${movie}">
			<tr>
				<td>${movie.title}</td>
				<td>${movie.link}</td>
				<td><img src="${movie.image}" alt="${movie.title}"></td>
				<td>${movie.subtitle}</td>
				<td>${movie.pubDate}</td>
				<td>${movie.director}</td>
				<td>${movie.actor}</td>
				<td>${movie.userRating}</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>