<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="../css/master.css"> 
<title>Ask a Question</title>
</head>   
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
<body>
<div class="container" style="margin-top: 2em !important;">
	<div class="row">
		<div class ="col-lg" align="center">
			<h2 id="formHead"> Ask a Question </h2>
			<form id="questionForm" type="display: none;">
				<table>
					<tr>
						<td><label class="isRequired" for="subject"><b>Subject</b></label>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Subject" name="subject" id="subject" required></td>
					</tr>
				
					<tr>
						<td><label class="isRequired" for="details"><b>Details</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class ="form-control" placeholder="Provide additional details" name="details" id="details" required></textarea></td>
					</tr>
				
					<tr class="formSubmit" align="center">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Submit</button></td>
					</tr>
				</table>
			</form>	
		</div>
	</div>
</div>
<script src="../js/communication_scripts.js"></script>
</body>