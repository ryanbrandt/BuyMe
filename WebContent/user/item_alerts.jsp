<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	ResultSet itemAlerts = null;
	try {
		// establish DB connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement st = con.createStatement();
		// get all of users current item alerts
		itemAlerts = st.executeQuery("SELECT * FROM BuyMe.Item_Alerts WHERE user_id = " + request.getSession().getAttribute("user"));
		
	} catch(Exception e){
		System.out.println(e);
	}

%>

<!DOCTYPE html>  
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<link rel="stylesheet" href="css/viewAuction.css">
<title>My Item Alerts</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Content -->
<body>   
<div class="container" style="margin-top: 2em !important;">   
	<div class="row"> 
		<div class="col-lg" align="left"> 
			<!-- Owned Auctions List -->
			<h2>Currently Set Item Alerts</h2><hr><br/>
			<table>
			<col width="20%"> 
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<%
				int i = 0;
				while(itemAlerts.next()){ 
			%>
			<%		if(i == 0){ %> 
					<tr class="attrTable" align="center">
			<%		} %> 
						<td> 
							<div class="card h-100" style="margin-left: 2em; margin-right: 2em;">
								<div class="card-header">Alert</div>
								  <div class="card-body">
								    <h5 class="card-title"><%=itemAlerts.getString("desired_name") != null ? itemAlerts.getString("desired_name"): "<small style=font-style:italic;>No Alert Name</small>"%></h5>
								    <table style="margin-bottom: 1em !important;">
								    	<tr>
								    		<td><strong>Type: </strong><%=itemAlerts.getString("type")%></td>
								    	</tr>
								    	<tr>
								    		<td><strong>Condition: </strong><%=itemAlerts.getString("condition") != null ? itemAlerts.getString("condition"): "<small style=font-style:italic;>N/A</small>" %></td>
								    	</tr>
								    	<tr>
								    		<td><strong>Brand: </strong><%=itemAlerts.getString("brand") != null ? itemAlerts.getString("brand"): "<small style=font-style:italic;>N/A</small>" %></td>
								    	</tr>
								    	<tr>
								    		<td><strong>Color: </strong><%=itemAlerts.getString("color") != null ? itemAlerts.getString("color"): "<small style=font-style:italic;>N/A</small>" %></td>
								    	</tr>
								    </table>
								    <button value="<%=itemAlerts.getString("item_alert_id")%>" class="btn btn-outline-danger my-2 my-sm-0 del">Delete</button>
								 </div>
							</div>
						</td>
			<% i++; if(i > 3){ %>
					</tr>
			<%
				i = 0;}
				}
			%>
			</table>
			<div class="container" align="center" style="margin-top: 2em !important;">
				<a id="new" class="btn btn-outline-success my-2 my-sm-0" href="#">Create a New Item Alert</a>
			</div>
			
		</div>
	</div>
</div>
<!-- Create New Alert Popup -->
<div class="modal" align="center" tabindex="-1" role="dialog" id="newAlertModal">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Create New Item Alert</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <!-- Alert Form -->
      <form id="alertForm">
      <div class="modal-body">
      	<h4>How it Works</h4>
      	<p>
      		Fill out the fields below and we will automatically send alerts for new item postings that satisfy your criteria.
      	</p>
        <table>
        	<tr>
        		<td><label class="isRequired" for="type"><b>Item Type</b></label></td>
        	</tr>
        	<tr class="inputItems">
        		<td>
        			<select class="form-control" name="type" required>
        				<option value="Pants">Pants</option>
        				<option value="Jackets">Jackets</option>
        				<option value="Shirts">Shirts</option>
        			</select>
        		</td>
        	</tr>
       	
			<tr> 
				<td><label for="brand"><b>Desired Brand</b></label></td>
			</tr>  
			<tr class="inputItems">
				<td><input class="textInput" type="text" placeholder="Item Brand" name="brand"></td>
			</tr>
			  
			<tr>
				<td><label for="condition"><b>Desired Condition</b></label></td>
			</tr> 
			<tr class="inputItems">
				<td>
					<select class="form-control" name="condition">
						<option value="" selected disabled>--</option>
						<option value="used">Used</option>
						<option value="new">New</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<td><label for="color"><b>Desired Color</b></label></td>
			</tr>
			<tr class="inputItems">
				<td><input class="textInput" type="text" placeholder="Item Color" name="color"></td>
			</tr>
			     
			<tr>      
				<td><label for="desired_name"><b>Desired Name</b></label></td>
			</tr>
			<tr class="inputItems">
				<td><input class="textInput" type="text" placeholder="Desired Product Name" name="desired_name"></td>
			</tr>  	
        </table>
        <!-- Loader -->
        <div class="d-flex justify-content-center">
      		<div class="spinner-border text-success" style="color: #28a745; display: none;" role="status" id="alertLoad">
  				<span class="sr-only">Loading...</span>
			</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-outline-success my-2 my-sm-0">Create Alert</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal" id ="alertClose">Cancel</button>
      </div>
      </form>
    </div>
  </div>
</div>
<script src="js/item_alerts_scripts.js"></script>
</body>
</html>