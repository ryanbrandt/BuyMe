<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Emails</title>
</head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/email.css"> 
</head>   
<!-- Navigation Bar -->  
<%@ include file='WEB-INF/navigation.jsp' %>  

<body>


<div class = "container">	
	<div class="tab">
	  <button class="tablinks" onclick="openTab(event, 'compose')">Compose</button>
	  <button class="tablinks" onclick="openTab(event, 'inbox')">Inbox</button>
	  <button class="tablinks" onclick="openTab(event, 'sent')">Sent</button>
	</div>
	
	<div id="compose" class="tabcontent" align="center">
		<br>
		<h2 id="formHead"> Compose New Email </h2>
		<form id="emailForm">
			<table>
				<tr>
					<td><label class="isRequired" for="recipient"><b>To:</b></label>
				</tr>
				<tr class="inputItems">
					<td><input class ="textInput" type="text" name="recipient" id="recipient" required></td>
				</tr>
				<tr>
					<td><label class="isRequired" for="subject"><b>Subject</b></label>
				</tr>
				<tr class="inputItems">
					<td><input class ="textInput" type="text" name="subject" id="subject" required></td>
				</tr>
				<tr>
					<td><label class="isRequired" for="email"><b>Email</b></label></td>
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
					 		<td width=100><%=fromUser%></td>
					 		<td width=100><%=inboxTable.getString("email_subject")%></td>
					 		<td width=400><%=inboxTable.getString("time_stamp")%></td>
					 	</tr>
					 </table>
				</button>
				<div class="panel">
					<table>
						<tr><td>
							<button class="replyButton" id="replyButton">Reply</button>
						</td></tr>
						<tr><td>
							<%=inboxTable.getString("email_text")%>
						</td></tr>
					</table>
				</div>
		<%	}
		}catch(Exception e){
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
					 		<td width=100>To: <%=fromUser%></td>
					 		<td width=100><%=sentTable.getString("email_subject")%></td>
					 		<td><%=sentTable.getString("time_stamp")%></td>
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
	
<script> //For reply button

var reply = document.getElementsByClassName("replyButton");
var i;
for( i=0; reply.length; i++){
	reply[i].addEventListener("click", function(){
		var panel = this.parentElement.parentElement.parentElement.parentElement.parentElement;
		var user = panel.previousElementSibling.firstElementChild.firstElementChild.firstElementChild.firstElementChild;
		var subject = user.nextElementSibling;
		var content = this.parentElement.parentElement.nextElementSibling.firstElementChild;
		
		openTab(event, 'compose');
		document.getElementById('recipient').value = user.innerText;
		document.getElementById('subject').value = "Re: "+subject.innerText;
		document.getElementById('email').value = "\""+ content.innerText +"\""+"\n--\n";
	});
}

</script>		
	
<script> //For compose/inbox/sent tabs
	function openTab(evt, tabname) {
	  var i, tabcontent, tablinks;
	  tabcontent = document.getElementsByClassName("tabcontent");
	  for (i = 0; i < tabcontent.length; i++) {
	    tabcontent[i].style.display = "none";
	  }
	  tablinks = document.getElementsByClassName("tablinks");
	  for (i = 0; i < tablinks.length; i++) {
	    tablinks[i].className = tablinks[i].className.replace(" active", "");
	  }
	  document.getElementById(tabname).style.display = "block";
	  evt.currentTarget.className += " active";
	}
</script>
<script> //For inbox emails
	var acc = document.getElementsByClassName("accordion");
	var i;

	for (i = 0; i < acc.length; i++) {
  		acc[i].addEventListener("click", function() {
    		this.classList.toggle("active");
    		var panel = this.nextElementSibling;
    		if (panel.style.display === "block") {
      			panel.style.display = "none";
    		} else {
      			panel.style.display = "block";
    		}
  		});
	}
</script>



<script>
	openTab(event, 'inbox');
</script>
<script src="js/email_scripts.js"></script>

</div>
</body>
</html>