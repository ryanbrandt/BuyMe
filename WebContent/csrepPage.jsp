<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Service Rep</title>
</head>
<!-- Navigation Bar -->
<%@ include file='WEB-INF/navigation.jsp' %>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<body>
<br></br>

<div>
<form id="lookupForm">
	<label class = "isRequired" for="userLookup"><b>User Lookup</b></label>
	<input type="textInput" placeholder="Display Name or Email" name="userLookup" id="userLookup" required>
	<label class="formSubmit" for="lookupButton"></label>
	<button type="submit" id="lookupButton" name="lookupButton">Lookup</button>
</form>
</div>
<div>
	(TABLE HERE)
</div>



<script src="js/csrep_scripts.js"></script>
</body>
</html>

