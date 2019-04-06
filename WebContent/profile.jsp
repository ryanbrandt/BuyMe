<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link type="stylesheet" href="css/master.css">
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
		userType = <%= curSession.getAttribute("userType") %>
	</div>
	
	<br>
	<% if(curSession.getAttribute("userType").equals("admin") ){ %>
	<div class="container" align="center">
		<button type="button" id="adminButton">Admin Page</button>
	</div>
	<%} else if(curSession.getAttribute("userType").equals("cs_rep")) {%>
	<div class="container" align="center">
		<button type="button" id="csRepButton">CS Rep Page</button>
	</div>
	<% } %>
	
	<div class="container" align="center">
		<button type="button" class="btn btn-danger" onclick=logOut()>Logout</button>
	</div>
	
</body>
</html>
<!-- JS -->
<script type="text/javascript">
/*
    document.getElementById("adminButton").onclick = function () {
    	window.location.href = "adminPage.jsp";
    }
    */
</script>
<script type="text/javascript">
    document.getElementById("csRepButton").onclick = function () {
    	window.location.href = "csrepPage.jsp";
    }
</script>
