<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Email Center</title>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/tabdisplay.css"> 
</head>   
<!-- Navigation Bar -->  
<%@ include file='WEB-INF/navigation.jsp' %>  
<!-- Content -->
<body>
<div class="container">	
	<div class="tab">
	  <button class="tablinks" onclick="openTab(event, 'compose')">Compose</button>
	  <button class="tablinks" onclick="openTab(event, 'inbox')">Inbox</button>
	  <button class="tablinks" onclick="openTab(event, 'sent')">Sent</button>
	</div>
	<div id="compose" class="tabcontent" align="center">
		<br>
		<h2 id="formHead">Compose New Email</h2>
		<form id="emailForm">
			<table>
				<tr>
					<td><label class="isRequired" for="recipient"><b>To:</b></label>
				</tr>
				<tr class="inputItems">
					<td><input class ="textInput" type="text" name="recipient" id="recipient" required></td>
				</tr>
				<tr>
					<td><label class="isRequired" for="subject"><b>Subject:</b></label>
				</tr>
				<tr class="inputItems">
					<td><input class ="textInput" type="text" name="subject" id="subject" required></td>
				</tr>
				<tr>
					<td><label class="isRequired" for="email"><b>Email:</b></label></td>
				</tr>
				<tr class="inputItems">
					<td><textarea rows="7" cols="60" class ="form-control" name="email" id="email" required></textarea></td>
				</tr>
				<tr class="formSubmit">
					<td><button class="btn btn-outline-success my-2 my-sm-0" type="submit">Send</button></td>
				</tr>
			</table>
		</form>	
	</div>
	<div id="inbox" class="tabcontent">
		<% 
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet inboxTable = st.executeQuery("SELECT * FROM Emails WHERE receiver_id = '" + curSession.getAttribute("user") + "'");
			
			
			while(inboxTable.next()){ 
				Statement st2 = con.createStatement();
				ResultSet from = st2.executeQuery("SELECT display_name FROM Users WHERE user_id = '"+inboxTable.getString("sender_id")+"'");
				String fromUser = "(deleted user)";
				if(from.next()){
					fromUser = from.getString("display_name");
				}
			%>
				<button class="accordion">
					 <table>
					 	<tr>
					 		<td width=100><strong>From: </strong><%=fromUser%></td>
					 		<td width=200 style="font-style: italic; padding-left: 5em;"><%=inboxTable.getString("email_subject")%></td>
					 		<td width=400><strong>Timestamp: </strong><%=inboxTable.getString("time_stamp")%></td>
					 	</tr>
					 </table>
				</button>
				<div class="panel">
					<table>
						<tr>
							<td><p><%=inboxTable.getString("email_text")%></p></td>
						</tr>
						<tr>
							<td><button class="btn btn-outline-success my-2 my-sm-0 replyButton" value="<%=fromUser%>,<%=inboxTable.getString("email_subject")%>,<%=inboxTable.getString("email_text")%>">Reply</button></td>
						</tr>
					</table>
				</div>
		<%	}
		} catch(Exception e){
			System.out.println("something broke");
		}%>
	</div>
	<div id="sent" class="tabcontent">
		<% 
		try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet sentTable = st.executeQuery("SELECT * FROM Emails WHERE sender_id = '" + curSession.getAttribute("user") + "'");
			
			
			while(sentTable.next()){ 
				Statement st2 = con.createStatement();
				ResultSet from = st2.executeQuery("SELECT display_name FROM Users WHERE user_id = '"+sentTable.getString("receiver_id")+"'");
				String fromUser = "(deleted user)";
				if(from.next()){
					fromUser = from.getString("display_name");
				}
			%>
				<button class="accordion">
					 <table>
					 	<tr>
					 		<td width=100><strong>To: </strong><%=fromUser%></td>
					 		<td width=200 style="font-style: italic; padding-left: 5em;"><%=sentTable.getString("email_subject")%></td>
					 		<td width=400><strong>Timestamp: </strong><%=sentTable.getString("time_stamp")%></td>
					 	</tr>
					 </table>
				</button>
				<div class="panel">
					<%=sentTable.getString("email_text")%>
				</div>
		<%	}
		}catch(Exception e){
			System.out.println("something broke");
		}%>
	</div>
</div>
<script src="js/tabdisplay_scripts.js"></script>
<script src="js/communication_scripts.js"></script>	
<script> //For reply button
$('.replyButton').on('click', function(){
	openTab(event, 'compose');
	var arr = $(this).val().split(",");
	document.getElementById('recipient').value = arr[0];
	document.getElementById('subject').value = "RE: " + arr[1];
	document.getElementById('email').value = "\"" + arr[2] + "\"" + "\n--\n";
});
window.onload = function(){
	openTab(event, 'inbox');
}
</script>			
</body>
</html>