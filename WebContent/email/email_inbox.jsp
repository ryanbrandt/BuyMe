<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Emails</title>
</head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/email.css"> 
</head>   
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<body>


<div class = "container">	
	<div class="tab">
	  <button class="tablinks" onclick="openTab(event, 'compose')">Compose</button>
	  <button class="tablinks" onclick="openTab(event, 'inbox')">Inbox</button>
	  <button class="tablinks" onclick="openTab(event, 'sent')">Sent</button>
	</div>
	
	<div id="compose" class="tabcontent">
		<br>
		<h2 id="formHead"> Compose New Email </h2>
		<form id="questionForm" type="display: none;">
			<table>
				<tr>
					<td><label class="isRequired" for="recipient"><b>To:</b></label>
				</tr>
				<tr class="inputItems">
					<td><input class ="textInput" type="text" name="recipient" required></td>
				</tr>
				<tr>
					<td><label class="isRequired" for="subject"><b>Subject</b></label>
				</tr>
				<tr class="inputItems">
					<td><input class ="textInput" type="text" name="subject" required></td>
				</tr>
				<tr>
					<td><label class="isRequired" for="email"><b>Email</b></label></td>
				</tr>
				<tr class="inputItems">
					<td><textarea rows="7" cols="60" class ="form-control" name="email" required></textarea></td>
				</tr>
			
				<tr class="formSubmit">
					<td><button class="btn btn-outline-success my-2 my-sm-0" type="Send">Submit</button></td>
				</tr>
				
			</table>
		</form>
	</div>
	
	<div id="inbox" class="tabcontent">
		inbox
	</div>
	
	<div id="sent" class="tabcontent">
		sent
	</div>
	
<script>
	function openTab(evt, tabname) {
	  var i, tabcontent, tablinks;
	  tabcontent = document.getElementsByClassName("tabcontent");
	  for (i = 0; i < tabcontent.length; i++) {
	    tabcontent[i].style.display = "none";
	  }
	  tablinks = document.getElementsByClassName("tablinks");
	  for (i = 0; i < tablinks.length; i++) {
	    tablinks[i].className = tablinks[i].className.replace(" active", "");
	  }
	  document.getElementById(tabname).style.display = "block";
	  evt.currentTarget.className += " active";
	}
</script>
<script>
	openTab(event, 'inbox');
</script>

</div>
</body>





</html>