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
<!-- Navigation Bar -->  
<%@ include file='../WEB-INF/navigation.jsp' %>  
</head>   
<body>
<div class = "container" class="col-lg" align="center" >
	<h2 id="formHead">Generate Sales Report For</h2>
	<table>
		<tr id="row1">
			<td><select id = "input1">
			  <option value="1">Total Earnings</option>
			  <option value="2">Earnings per Item</option>
			  <option value="3">Earnings per Item Type</option>
			  <option value="4">Earnings per End User</option>
			  <option value="5">Bestselling Items</option>
			  <option value="6">Best Buyers</option>
			</select></td>
			<td id=buttonCol1><button class="generateButton">Generate</button></td>
		</tr>
		
		<tr id="row2" style = "display:none">
			<td>
				<select id="input2Select">
					<option value="Jackets">Jackets</option>
			  		<option value="Shirts">Shirts</option>
			  		<option value="Pants">Pants</option>
				</select>
				<input id="input2Text" type="text"></input>
			</td>
			<td id=buttonCol2><button class="generateButton">Generate</button></td>
		</tr>
		
		<tr id="row3" style = "display:none">
			<td>
				<table>
					<tr>
						<td id="input3_text1">Condition:<td>
						<td><select id="input3_1">
							<option value="new">Small</option>
			  				<option value="used-like-new">Medium</option>
			  				<option value="used-good">Large</option>
			  				<option value="used-acceptable">Large</option>
						</select></td>
					</tr>
					<tr>
						<td id="input3_text2">Brand:<td>
						<td><input id="input3_2" type="text"></input></td>
					</tr>
					<tr>
						<td id="input3_text3">Material:<td>
						<td><input id="input3_3" type="text"></input></td>
					</tr>
					<tr>
						<td id="input3_text4">Color:<td>
						<td><input id="input3_4" type="text"></input></td>
					</tr>
					<tr><td id=buttonCol3><button class="generateButton">Generate</button></td></tr>
				</table>
			</td>
		</tr>		
	</table>
	
	<table id="result" style = "display:none">
		<tr><td><b id="heading"></b></td></tr>
		<tr><td>Total Items:</td><td id="tSold"></td></tr>
		<tr><td>Total Amount:</td><td id="tAmount"></td></tr>
	</table>

</div>
<!-- JavaScript -->
<script src="js/admin_scripts.js"></script>
</body>
</html>