<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">
<title>Admin</title>
</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<body>
<div class="container" style="margin-top: 2em !important;">
	<div class="row">
		<div class="col-lg" align="center">
			<h1>Customer Service Representatives</h1>
			<p>
			<table>
				<tr>
				   <td><strong>Display Name</strong></td>
				   <td align="center"><strong>Email</strong></td>
				</tr>
				<% 
				try{
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();	
					Statement st = con.createStatement();
					
					ResultSet csDisplay = st.executeQuery("SELECT * FROM Users_CS_Rep cs JOIN Users u ON u.user_id=cs.user_id");
					ArrayList<Integer> list = new ArrayList<Integer>();
					while(csDisplay.next()){%>
				        <tr>
				            <td><%=csDisplay.getString("display_name") %></td>
				            <td><%=csDisplay.getString("email") %></td>
				        </tr>
			        <%}
					
					st.close();
					con.close();
				    
				}catch(Exception e){
					System.out.println(e);
				}
			    %>
			  </table>
			</p> 
			<p>
			<form id="registerForm">
				<table>
					<tr>
						<td><label class="isRequired" for="displayName"><b>Display Name</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="form-control" type="text" placeholder="Enter Display Name" name="displayName"  id="displayName" required></td>
					</tr>	
					<tr>
						<td><label class="isRequired" for="registerEmail"><b>Email</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="form-control" type="email" placeholder="Enter Email" name="registerEmail" id="registerEmail" required></td>
					</tr>
					<tr>
						<td><label class="isRequired" for="registerPassword"><b>Password</b></label></td>
					</tr>
					<tr class="inputItems">
						<td><input class="form-control" type="password" placeholder="Enter Password" name="registerPassword"  id="registerPassword" required></td>
					</tr>						
					<tr class="formSubmit" align="center">
						<td><button class="form-control" type="submit">Add new</button></td>
					</tr>
				</table>
			</form>
			</p>
		</div>
	</div>
</div>	
<script src="js/admin_scripts.js"></script>
</body>
</html>
