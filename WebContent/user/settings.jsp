<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>  
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<title>My Settings</title>         
</head>   
<!-- Navigation Bar --> 
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Content -->
<body> 
<div class="container">
	<div class="row">
		<div class="col-lg" align="center">
			<h2 id="head">Confirm Your Password</h2><br/>
			<!-- Login Form; Default is visible -->
			<form id="confirmPass"> 
				<table>  
					<tr>
						<td><label for="pass"><b>Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="password" placeholder="Enter Password" name="pass" id="pass" required></td>
					</tr>
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Confirm</button></td>
					</tr>
				</table>
			</form>	
			<table id="actionsTable" style="display: none;">
					<tr>
						<td><label for="changePass"><b>Update Your Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="password" placeholder="Enter New Password" name="changePass" id="changePass" required></td>
					</tr>
					<tr class="formSubmit">
						<td><button value="<%=request.getSession().getAttribute("user")%>" class="btn btn-outline-success my-2 my-sm-0" id="passUpdate">Update</button></td>
					</tr>
					
					<tr class="inputItems">
						<td><button value="<%=request.getSession().getAttribute("user")%>" class="btn btn-outline-danger my-2 my-sm-0"  id="deleteAct">Delete Your Account</button></td>
					</tr>
			</table>
		</div>
	</div>
</div>
<script src="js/settings_scripts.js"></script>
</body>
</html>