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
<%@ include file='WEB-INF/navigation.jsp' %>

<body>

<br></br>
<div>Customer Service Representatives
<p>
<table>
	<tr>
	   <th>Display Name |</th>
	   <th>Email</th>
	</tr>
	<% 
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		
		ResultSet csUserID = st.executeQuery("SELECT user_id FROM Users_CS_Rep");
		
		while(csUserID.next()){
			ResultSet csDisplay = st.executeQuery( "SELECT display_name, email FROM Users WHERE user_id= '" + csUserID.getInt(1) +"'");
			while(csDisplay.next()){%>
	        <tr>
	            <td><%=csDisplay.getString("display_name") %></td>
	            <td><%=csDisplay.getString("email") %></td>
	        </tr>
        <%}

	    }
		st.close();
		con.close();
	    
	}catch(Exception e){
		
	}
    %>
  </table>
</p>
<p>
<form id="registerForm">
	<table>
		<tr>
			<td><label class="isRequired" for="displayName"><b>Display Name</b></label></td>
			<td><input type="textInput" placeholder="Enter Display Name" name="displayName"  id="displayName" required></td>
		</tr>	
		<tr>
			<td><label class="isRequired" for="registerEmail"><b>Email</b></label></td>
			<td><input type="email" placeholder="Enter Email" name="registerEmail" id="registerEmail" required></td>
		</tr>
		<tr>
			<td><label class="isRequired" for="registerPassword"><b>Password</b></label></td>
			<td><input type="password" placeholder="Enter Password" name="registerPassword"  id="registerPassword" required></td>
		</tr>						
		<tr class="formSubmit">
			<td><button type="submit">Add new</button></td>
		</tr>
	</table>
</form>
</p>
</div>

<script src="js/admin_scripts.js"></script>

</body>
</html>
