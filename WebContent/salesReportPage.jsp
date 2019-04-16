<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<title>Sales Report</title>
</head>   
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<body>
<div class = "container" >
	<div class="col-lg" align="center">
		<h2 id="formHead">Generate Sales Report For</h2><br/>
		<select>
		  <option value="total">Total earnings</option>
		  <option value="earnings_by">Earnings per</option>
		  <option value="bestselling">Bestselling Items</option>
		  <option value="best_buyers">Best Buyers</option>
		</select>
	</div>
</div>
</body>