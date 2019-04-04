<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="../css/master.css">
<title>Start a New Auction</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Content -->
<body>
<div class="container"> 
	<div class="row">
		<div class="col-lg" align="center">
			<h2>Tell us About What You're Selling</h2><br/>
			<!-- Create New Auction Form -->
			<form id="newProductForm">
				<table>
					<tr>
						<td><label class="isRequired" for="productTitle"><b>What are you Selling?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Name" name="productTitle" id="productTitle" required></td>
					</tr>
						
					<tr>
						<td><label class="isRequired" for="type"><b>What Type of Product is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><select name="productType" class="form-control" required>
								<option disabled selected value>--</option>
								<option value="shirt">Shirt</option>
								<option value="pants">Pants</option>
								<option value="jacket">Jacket</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label class="isRequired" for="productCondition"><b>What Condition is it In?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><select name="productCondition" class="form-control" required>
								<option disabled selected value>--</option>
								<option value="ua">Used-Acceptable</option>
								<option value="ug">Used-Good</option>
								<option value="uln">Used-Like-New</option>
								<option value="n">New</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label class="notRequired" for="productMaterial"><b>Who Makes It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Brand" name="productBrand"></td>
					</tr>
					
					<tr>
						<td><label class="notRequired" for="productSize"><b>What Size is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Size" name="productSize"></td>
					</tr>
					
					<tr>
						<td><label class="notRequired" for="productColor"><b>What Color is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Color" name="productColor"></td>
					</tr>
					
					<tr>
						<td><label class="notRequired" for="productDescription"><b>Additional Details</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class="form-control" placeholder="What Should Buyers Know About your Item?" name="productDescription" id="productDescription"></textarea></td>
					</tr>
					
					<tr>
						<td><label class="notRequired" for="productImage"><b>Upload a Picture</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input type="file" name="productImage"></td>
					</tr>
						
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Next</button></td>
					</tr>
					
				</table>
			</form>
		</div>
	</div>
</div>
<!-- JavaScript -->

</body>
</html>