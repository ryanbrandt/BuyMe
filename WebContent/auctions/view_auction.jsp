<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<title>View Auction</title>
</head> 
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<!-- Content --> 
<body>
<div class="container">   
	<div class="row">    
		<div class="col-lg" align="center">
			<h2>auction_id = <%= request.getSession().getAttribute("new_prod_id") %></h2><br/>
				auction attributes go here
		</div>
	</div>
</div>

</body>
</html>