<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/login.css">
<title>Welcome to BuyMe!</title>
</head>
<!-- Navigation Bar -->
<%@ include file='navigation.jsp' %>
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
						<td><label for="email"><b>Email</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="userCredentials" type="email" placeholder="Enter Email" name="email" required></td>
					</tr>
						
					<tr>
						<td><label for="password"><b>Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="userCredentials" type="password" placeholder="Enter Password" name="password" required></td>
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
			<form id="registerForm">
				<table>
					<tr>
						<td><label for="email"><b>Email</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="userCredentials" type="email" placeholder="Enter Email" name="email" id="email" required></td>
					</tr>
						
					<tr>
						<td><label for="password"><b>Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="userCredentials" type="password" placeholder="Enter Password" name="password" required></td>
					</tr>
					
					<tr>
						<td><label for="displayName"><b>Display Name</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="userCredentials" type="text" placeholder="Enter Display Name" name="displayName" id="displayName" required></td>
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
<!-- End Login/Registration Grid -->
</body>
<!-- JavaScript -->
<script>
	/* Login to registration form and vice versa */
	function switchForms(isLogin){
		if(isLogin){
			document.getElementById("loginForm").style.display="none";
			document.getElementById("registerForm").style.display="block";
		} else {
			document.getElementById("registerForm").style.display="none";
			document.getElementById("loginForm").style.display="block";
		}
	}
	
	/* AJAX to check on the fly if a username/email is already taken */
	$('#email').change(function(){
		$.ajax({
			url: "check_registration_credentials.jsp",
			method: "POST",
			data: {'isEmail': true, 'data': $(this).val()},
			
			success: function(data){
				// if data not empty, unavailable, throw alert and clear input
				if($.trim(data)){
					alert('That email is already registered under an account. Log in instead?');
					$('#email').val('');
				} 
			}
		})
	});
	
	$('#displayName').change(function(){
		$.ajax({
			url: "check_registration_credentials.jsp",
			method: "POST",
			data: {'isEmail': false, 'data': $(this).val()},
			
			success: function(data){
				// if data not empty, unavailable, throw alert and clear input
				if($.trim(data)){
					alert('That display name is already taken');
					$('#displayName').val('');
				} 
			}
	
		})
	});
</script>
</html>