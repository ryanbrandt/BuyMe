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
						<td><label class="isRequired" for="name"><b>What are you Selling?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Name" name="name" required></td>
					</tr>
						  
					<tr>
						<td><label class="isRequired" for="type"><b>What Type of Product is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><select name="type" class="form-control" id="type" required>
								<option disabled selected value>--</option>
								<option value="Shirts">Shirt</option>
								<option value="Pants">Pants</option>
								<option value="Jackets">Jacket</option>
							</select>
						</td>  
					</tr>     
					   
					<tr>  
						<td><label class="isRequired" for="condition"><b>What Condition is it In?</b></label></td>
					</tr>
					<tr class="inputItems"> 
						<td><select name="condition" class="form-control" required>
								<option disabled selected value>--</option>
								<option value="used-acceptable">Used-Acceptable</option>
								<option value="used-good">Used-Good</option>
								<option value="used-like-new">Used-Like-New</option>
								<option value="new">New</option>
							</select>    
						</td>    
					</tr> 
					
					<tr>
						<td><label for="material"><b>What is it Made of?</b></label></td>
					</tr> 
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Brand" name="material"></td>
					</tr>
					
					<tr>
						<td><label for="brand"><b>Who Makes It?</b></label></td>
					</tr> 
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Brand" name="brand"></td>
					</tr>
					 
					<tr>
						<td><label for="color"><b>What Color is It?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="textInput" type="text" placeholder="Item Color" name="color"></td>
					</tr>
						
					<tr>
						<td><label for="image"><b>Upload a Picture</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input type="file" name="image"></td>
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
						<td><label for="size" class="isRequired"><b>Shirt Size</b></label></td>
					</tr>
					<tr class="inputItems">   
						<td>    
							<select name="size" class="form-control" required>
								<option disabled selected value>--</option>
								<option value="small">Small</option>
								<option value="medium">Medium</option>
								<option value="large">Large</option>
								<option value="xl">XL</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="buttons"><b>Does it have buttons?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="buttons" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Yes</option>
								<option value=0>No</option>
							</select>
						</td>
					</tr>
					    
					<tr> 
						<td><label for="long_sleeve"><b>Long or Short Sleeve?</b></label></td>
					</tr>   
					<tr class="inputItems"> 
						<td>         
							<select name="long_sleeve" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Long</option>
								<option value=0>Short</osption>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="collar"><b>Does it Have a Collar?</b></label></td>
					</tr>  
					<tr class="inputItems"> 
						<td>    
							<select name="collar" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Yes</option>
								<option value=0>No</osption>
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
						<td><label for="waist" class="isRequired"><b>Pants Waist</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<input class="textInput" type="text" name="waist" placeholder="Waist in Inches" required>
						</td>
					</tr>
					
					<tr>
						<td><label for="length" class="isRequired"><b>Pants Length</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<input class="textInput" type="text" name="length" placeholder="Length in Inches" required>
						</td>
					</tr>
					
					<tr>
						<td><label for="has_belt_loops"><b>Does it have Belt Loops?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="has_belt_loops" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Yes</option>
								<option value=0>No</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label for="fit"><b>Pants Fit</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="fit" class="form-control">
								<option disabled selected value>--</option>
								<option value="relaxed">Relaxed</option>
								<option value="regular">Regular</option>
								<option value="slim">Slim</option>
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
						<td><label for="size" class="isRequired"><b>Jacket Size</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>
							<select name="size" class="form-control">
								<option disabled selected value>--</option>
								<option value="small">Small</option>
								<option value="medium">Medium</option>
								<option value="large">Large</option>
								<option value="xl">XL</option>
							</select> 
						</td>
					</tr> 
					
					<tr> 
						<td><label for="water_resistant"><b>Is it Water Resistant?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td> 
							<select name="water_resistant" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Yes</option>
								<option value=0>No</option>
							</select>
						</td>
					</tr>   
					             
					<tr>      
						<td><label for="hood"><b>Does it Have a Hood?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td> 
							<select name="hood" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Yes</option>
								<option value=0>No</option>
							</select>
						</td>
					</tr>  
					
					<tr> 
						<td><label for="insulated"><b>Is it Insulated?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td>  
							<select name="insulated" class="form-control">
								<option disabled selected value>--</option>
								<option value=1>Yes</option>
								<option value=0>No</option>
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
						<td><label for="additional_comments"><b>Additional Comments</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class="form-control" name="additional_comments" placeholder="Enter Anything else Potential Buyers Should Know"></textarea>
					</tr>  
					                   
					<tr>      
						<td><label for="condition_remarks"><b>Additional Condition Remarks</b></label></td>
					</tr>     
					<tr class="inputItems">
						<td><textarea rows="7" cols="60" class="form-control" name="condition_remarks" placeholder="Elaborate on the Condition of Your Item"></textarea>
					</tr>
					
					<tr> 
						<td><label for="end_time" class="isRequired"><b>When Should your Auction End?</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input type="date" id="dateTest" class="form-control" name="end_time" required></td>
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