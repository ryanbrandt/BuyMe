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
	/* TODO overhaul this page to a 'user' folder and use a servlet to redirect */
	if(curSession.getAttribute("user") == null){
		response.sendRedirect("login.jsp");
	}
%>
<!-- Content -->
<body>
	<div class="container" align="center" style="margin-top: 2em !important;">
		Hello World, user_id = <%= curSession.getAttribute("user") %> is logged in!
		userType = <%= curSession.getAttribute("userType") %>
	</div>
	<br/>
	<div class="container" align="center" id="additionalButtons"></div>

<!-- JS -->
<script type="text/javascript">
	window.onload = function(){
		var userType = '<%=request.getSession().getAttribute("userType")%>';
		switch(userType){
		
		case "admin":
			document.getElementById('additionalButtons').innerHTML = "<a class='btn btn-outline-success my-2 my-sm-0' href='adminPage.jsp'>Admin Page</a>";
			break;
		case "cs_rep":
			document.getElementById('additionalButtons').innerHTML = "<a class='btn btn-outline-success my-2 my-sm-0' href='csrepPage.jsp'>CS Rep Page</a>";
		
		}
	}
</script>		
</body>
</html>

