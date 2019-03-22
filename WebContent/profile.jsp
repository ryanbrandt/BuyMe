<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<title>My Profile</title>
</head>
<!-- Navigation Bar -->
<%@ include file='WEB-INF/navigation.jsp' %>
<%
	/* TODO there is a better way to handle this; redirects so people dont access this view via URL when not logged in */
	if(curSession.getAttribute("user") == null){
		response.sendRedirect("login.jsp");
	}
%>
<!-- Content -->
<body>
	<div class="container" align="center">
		HELLO WORLD, <%= curSession.getAttribute("user") %> is logged in!
	</div>
</body>
</html>