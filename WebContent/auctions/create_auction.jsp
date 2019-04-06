<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<title>Start a New Auction</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %> 
<!-- Content -->
<body>
<div class="container"> 
	<div class="row">
		<div class="col-lg" align="center">
			<h2 id="formHead">Tell us About What You're Selling</h2><br/>
			<!-- Create New Auction Form -->
			<form id="newProductForm">
				<table>
					<tr>
						<td><label class="isRequired" for="productTitle"><b>What are you Selling?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Name" name="productTitle" required></td>
					</tr>
						
					<tr>
						<td><label class="isRequired" for="type"><b>What Type of Product is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><select name="productType" class="form-control" id="productType" required>
								<option disabled selected value>--</option>
								<option value="s">Shirt</option>
								<option value="p">Pants</option>
								<option value="j">Jacket</option>
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
						<td><label for="productMaterial"><b>Who Makes It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Brand" name="productBrand"></td>
					</tr>
					
					<tr>
						<td><label for="productColor"><b>What Color is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Color" name="productColor"></td>
					</tr>
					
					<tr>
						<td><label for="productDescription"><b>Additional Details</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class="form-control" placeholder="What Should Buyers Know About your Item?" name="productDescription" id="productDescription"></textarea></td>
					</tr>
					
					<tr>
						<td><label for="productImage"><b>Upload a Picture</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input type="file" name="productImage"></td>
					</tr>
						
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Next</button></td>
					</tr>
				</table>
			</form>
			<!-- Shirt Form -->
			<form id="shirtForm" class="typeForm" style="display: none;">
				<table>
					<tr>
						<td><label for="shirtSize" class="isRequired"><b>Shirt Size</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="shirtSize" class="form-control" required>
								<option disabled selected value>--</option>
								<option value="s">Small</option>
								<option value="m">Medium</option>
								<option value="l">Large</option>
								<option value="xl">XL</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="shirtButtons"><b>Does it have buttons?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="shirtButtons" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Yes</option>
								<option value="0">No</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="shirtSleeves"><b>Long or Short Sleeve?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="shirtButtons" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Long</option>
								<option value="0">Short</osption>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="shirtCollar"><b>Does it Have a Collar?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="shirtButtons" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Yes</option>
								<option value="0">No</osption>
							</select>
						</td>
					</tr>
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Next</button></td>
					</tr>
				</table>
			</form>
			<!-- Pants Form -->
			<form id="pantsForm" class="typeForm" style="display: none;">
				<table>
					<tr>
						<td><label for="pantsWaist" class="isRequired"><b>Pants Waist</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<input class="textInput" type="text" name="pantsWaist" placeholder="Waist in Inches" required>
						</td>
					</tr>
					
					<tr>
						<td><label for="pantsLength" class="isRequired"><b>Pants Length</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<input class="textInput" type="text" name="pantsLength" placeholder="Length in Inches" required>
						</td>
					</tr>
					
					<tr>
						<td><label for="pantsLoops"><b>Does it have Belt Loops?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="pantsLoops" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Yes</option>
								<option value="0">No</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="pantsFit"><b>Pants Fit</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="pantsFit" class="form-control">
								<option disabled selected value>--</option>
								<option value="r">Relaxed</option>
								<option value="reg">Regular</option>
								<option value="s">Slim</option>
							</select>
						</td>
					</tr>
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Next</button></td>
					</tr>
				</table>
			</form>
			<!-- Jacket Form -->
			<form id="jacketForm" class="typeForm" style="display: none;">
				<table>
					<tr>
						<td><label for="jacketSize" class="isRequired"><b>Jacket Size</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="jacketSize" class="form-control">
								<option disabled selected value>--</option>
								<option value="s">Small</option>
								<option value="m">Medium</option>
								<option value="l">Large</option>
								<option value="xl">XL</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="jacketResistant"><b>Is it Water Resistant?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="jacketResistant" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Yes</option>
								<option value="0">No</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="jacketHood"><b>Does it Have a Hood?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="jacketHood" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Yes</option>
								<option value="0">No</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="jacketInsulated"><b>Is it Insulated?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="jacketInsulated" class="form-control">
								<option disabled selected value>--</option>
								<option value="1">Yes</option>
								<option value="0">No</option>
							</select>
						</td>
					</tr>
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Next</button></td>
					</tr>
				</table>
			</form>
			<!-- Auction Form -->
			<form id ="auctionForm" style="display: none;">
				<table>
					<tr>
						<td><label for="auctionComments"><b>Additional Comments</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class="form-control" name="auctionComments" placeholder="Enter Anything else Potential Buyers Should Know"></textarea>
					</tr>
					
					<tr>
						<td><label for="auctionRemarks"><b>Additional Condition Remarks</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class="form-control" name="auctionRemarks" placeholder="Elaborate on the Condition of Your Item"></textarea>
					</tr>
					<tr class="formSubmit">
						<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Finish</button></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</div>
<!-- JavaScript -->
<script src="js/create_auction_scripts.js"></script>
</body>
</html>