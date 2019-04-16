<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<!-- Master stylesheet -->
<link type="stylesheet" href="css/master.css">
<title>My Profile</title>
</head>
<!-- Navigation Bar -->
<%@ include file='WEB-INF/navigation.jsp' %>
<%
	/* TODO overhaul this page to a 'user' folder and use a servlet to redirect */
	if(curSession.getAttribute("user") == null){
		response.sendRedirect("login.jsp");
	}
%>
<!-- Content -->
<body>
	<div class="container" id="alertData" align="center" style="margin-top: 2em !important;">
		Hello World, user_id = <%= curSession.getAttribute("user") %> is logged in!
		userType = <%= curSession.getAttribute("userType") %>
	</div>
	<br/>
	<div class="container" align="center" id="additionalButtons">
		<table class="table">
 			<thead class="thead-light">
 		 		<tr>
	 		 		<th scope="col">Received</th>
	    			<th scope="col">Subject</th>
	    			<th scope="col">Message</th>
	    			<th scope="col"></th>
 		 		</tr>
 			</thead>
 			</tbody>
	<% 
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet inboxTable = st.executeQuery("SELECT * FROM Alerts WHERE alert_for = '" + curSession.getAttribute("user") + "'");
			
			
			while(inboxTable.next()){ 
				//update alert to read status (b'1')
				Statement st2 = con.createStatement();
				System.out.println("UPDATE Alerts SET alert_read = '1' WHERE alert_id = '" + inboxTable.getString("alert_id") + "'");
				int resultCode = st2.executeUpdate("UPDATE Alerts SET alert_read = b'1' WHERE alert_id = '" + inboxTable.getString("alert_id") + "'");
			%>
				<tr>
					<th scope="col"><%=inboxTable.getString("time_stamp").substring(2, inboxTable.getString("time_stamp").length() - 2) %></th>
	 		 		<th scope="col"><%=inboxTable.getString("alert_title")%></th>
	    			<th scope="col"><%=inboxTable.getString("alert_message")%></th>
	    			<th scope="col"><% if(inboxTable.getString("alert_read").equals("0")){ %><p class="text-danger">NEW!</p><%}%></th>
 		 		</tr>
				
		<%	}
		}catch(Exception e){
			System.out.println("something broke: " + e);
		}%></tbody></table></div>

<!-- JS -->
<script type="text/javascript">
	window.onload = function(){
		var alertData = 'Hello! You have <%if (unreads.equals("")){%> 0 new alerts<%} else if (unreads.equals("1")){ %><%=unreads%> new alert<%}else{%> new alerts<%}%>.';
		document.getElementById("alertData").innerHTML = alertData;
	}
</script>		
</body>
</html>

