<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<title>My Auctions</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Content -->
<body>  
<div class="container">  
	<div class="row">
		<div class="col-lg" align="center">
			<h2 id="formHead">My Auctions</h2><br/>
				<a class="btn btn-outline-success my-2 my-sm-0" href="NavigationServlet?location=createAuction">Create a New Auction</a>
				<!-- Add list for auctions started and auctions bid on -->
		</div>
	</div>
</div>
</body>
</html>