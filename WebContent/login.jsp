<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<title>Welcome to BuyMe!</title>
</head>
<!-- Navigation Bar -->
<%@ include file='WEB-INF/navigation.jsp' %>
<% 
	/* if user logged in, redirect to profile  */
	if(curSession.getAttribute("user") != null){
		response.sendRedirect("NavigationServlet?location=profile");
	}  
%> 
<!-- Content -->
<body> 
<!-- Login/Registration Grid -->
<div class="container"> 
	<div class="row">
		<div class="col-lg" align="center">
			<h2>Welcome to BuyMe!</h2><br/>
			<!-- Login Form; Default is visible -->
			<form id="loginForm">     
				<table>
					<tr>      
						<td><label for="loginEmail"><b>Email</b></label></td>
					</tr>   
					<tr class="inputItems">
						<td><input class="textInput" type="email" placeholder="Enter Email" name="loginEmail" id="loginEmail" required></td>
					</tr>
						 
					<tr>
						<td><label for="loginPassword"><b>Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="password" placeholder="Enter Password" name="loginPassword"  id="loginPassword" required></td>
					</tr>
						
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Log In</button></td>
					</tr>
					
					<tr class="formSubmit">
						<td><a href="#" onclick=switchForms(true)><small>Don't have an account? Sign up today!</small></a></td>
					</tr>
					
					<tr class="formSubmit">
						<td><a href="#"><small>Forgot your password?</small></a></td>
					</tr>
				</table>
			</form>
			<!-- Registration Form; Default is Hidden -->
			<form id="registerForm" style="display: none;">
				<table>
					<tr>
						<td><label class="isRequired" for="registerEmail"><b>Email</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="email" placeholder="Enter Email" name="registerEmail" id="registerEmail" required></td>
					</tr>
						
					<tr>
						<td><label class="isRequired" for="registerPassword"><b>Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="password" placeholder="Enter Password" name="registerPassword" id="registerPassword" required></td>
					</tr>
					
					<tr>
						<td><label class="isRequired" for="displayName"><b>Display Name</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Enter Display Name" name="displayName" id="displayName" required></td>
					</tr>
					
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit" id="joinNow">Join Now</button></td>
					</tr>
					
					<tr class="loginSubmit">
						<td><a href="#" onclick=switchForms(false)><small>Already have an account? Log in now!</small></a></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</div>
<!-- JavaScript -->
<script src="js/login_scripts.js"></script>
</body>
</html>