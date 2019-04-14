<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Service Rep</title>

</head>
<!-- Navigation Bar -->
<%@ include file='../WEB-INF/navigation.jsp' %>
<!-- Master stylesheet -->
<link rel="stylesheet" href="css/master.css">


<script> 
document.getElementById("lookupButton").onclick = function(){
		<%curSession.setAttribute("userLookup", request.getParameter("userLookup"));%>
		location.reload();
	}
</script>


<body>
<br></br>

<div>
<form id="lookupForm">
	<label class = "isRequired" for="userLookup"><b>User Lookup</b></label>
	<input type="textInput" placeholder="Display Name or Email or *" name="userLookup" id="userLookup" required>
	<label class="formSubmit" for="lookupButton"></label>
	<button type="submit" id="lookupButton" name="lookupButton">Lookup</button>
</form>
</div>

<div>
<table>
	<tr>
	   <th>Display Name |</th>
	   <th>Email</th>
	</tr>
	<% 
	String user = (String) curSession.getAttribute("userLookup");
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		Statement st = con.createStatement();
		ResultSet csTable;
		
		if(user == null || user.equals("*")){
			csTable = st.executeQuery( "SELECT display_name, email FROM Users");
		}else{
			csTable = st.executeQuery("SELECT display_name, email "+
									"FROM Users " +
									"WHERE display_name = '" + user +"' OR email = '" + user +"'");
		}
		
		if( csTable.next()){
			do{%>
			 <tr>
	            <td><%=csTable.getString("display_name") %></td>
	            <td><%=csTable.getString("email") %></td>
	        </tr>
			<%}while(csTable.next());
		}else{
			curSession.setAttribute("userLookup", null);%>
			<tr><td>no users found</td></tr>
			
		<%}
		con.close();
	}catch(Exception e){}%>

</table>
</div>

<div>
<%if( curSession.getAttribute("userLookup") != null && !curSession.getAttribute("userLookup").equals("*") ){%>
	<p>
	<button id="resetPassword">Reset Password</button>
	</p>
	<p>
	(Table of bids)
	</p>
	<p>
	(Table of auction listings)
	</p>
<%}%>
</div>


<script src="../js/csrep_scripts.js"></script>

</body>
</html>

