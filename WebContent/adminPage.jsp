<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<!-- Head -->
<head>
<title>Admin</title>
</head>
<!-- Navigation Bar -->
<%@ include file='WEB-INF/navigation.jsp' %>
<!-- Content -->

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
		
		ResultSet csTable = st.executeQuery( "SELECT display_name, email FROM Users_CS_Rep");
		
		while(csTable.next()){
	        %>
	        <tr>
	            <td><%=csTable.getString("display_name") %></td>
	            <td><%=csTable.getString("email") %></td>
	        </tr>
	        <%
	    }
	    csTable.close();
	}catch(Exception e){
		
	}
    %>
   </table>
</p>
<p>
<form>Display Name <input type="text" name="displayname"></form>
<form>Email <input type="text" name="email"> </form>
<form>Password <input type="text" name="password"> </form>
<form>Confirm Password <input type="text" name="confirmPassword"> </form>
<button type="button" id="newCSRepButton"> Add new </button> (not functional yet)
</p>
</div>

</body>
</html>

<script>
    document.getElementById("newCSRepButton").onclick = function () {
       
    }
</script>