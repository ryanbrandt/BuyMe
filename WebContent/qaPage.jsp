<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<title>Questions Center</title>
</head>
<!-- Master stylesheet -->     
<link rel="stylesheet" href="css/master.css"> 
<link rel="stylesheet" href="css/tabdisplay.css"> 
</head>   
<!-- Navigation Bar -->  
<%@ include file='WEB-INF/navigation.jsp' %>  
<body>
<div class = "container" style="margin-top: 2em !important;">	
	<form id="searchForm">
	<table>
		<tr>
			<td>
				<input class="form-control" type="text" placeholder="search question" id="questionLookup" required>
			</td>
			<td>
				<button class="form-control" type="submit" id="searchButton">Search</button>
			</td>
		</tr>
	</table>
	</form>
	<table style="margin-top: 0.5em; margin-bottom: 0.5em;">
		<tr>
			<td><button class="form-control" id="resetButton">Reset</button></td>
			<td><button class="form-control" onclick="window.location.href='questionFormPage.jsp'">Post New Question</button></td>
		</tr>
	</table>
	<div class="tab">
	  <button class="tablinks" onclick="openTab(event, 'unanswered')">Unanswered</button>
	  <button class="tablinks" onclick="openTab(event, 'answered')">Answered</button>
	</div>
	
	<div id="unanswered" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet questionTable;
			
			String questionLookup = (String) curSession.getAttribute("questionLookup");
			if( questionLookup == null ){
				questionTable = st.executeQuery("SELECT * FROM Questions WHERE isAnswered = 0");
			}else{
				questionTable = st.executeQuery("SELECT * FROM Questions WHERE isAnswered = 0 && question_subject LIKE '%"+questionLookup+"%'");
			}
				

						
			while(questionTable.next()){ 
				Statement st2 = con.createStatement();
				ResultSet from = st2.executeQuery("SELECT display_name FROM Users WHERE user_id = '"+questionTable.getString("asked_by")+"'");
				String fromUser = "(deleted user)";
				if(from.next()){
					fromUser = from.getString("display_name");
				}
			%>
				<button class="accordion">
					 	<table><tr> 
						 	<td width=100 id=<%=questionTable.getString("question_id")%>><%=fromUser%></td>
						 	<td width=200><%=questionTable.getString("question_subject")%></td>
						 	<td width=400><%=questionTable.getString("timestamp")%></td>
						 </tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td>
							"<%=questionTable.getString("question_text")%>"
						</td></tr>
						
					<%if(curSession.getAttribute("userType").equals("cs_rep")){%>
						<tr><td>
							<textarea rows="4" cols="60" id="answerText"></textarea><br>
						</td></tr>
						<tr><td>
							<button style="width: 25%;"class="answerButton form-control" id="answerButton" value="<%=questionTable.getString("question_id")%>">Answer</button>
						</td></tr>
					<%} %>
					</table>
				</div>
				
			<%}
		con.close();
		st.close();
		}catch(Exception e){
		}%>
	</div>

	<div id="answered" class="tabcontent">
		<%try{
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			Statement st = con.createStatement();
		
			ResultSet answeredTable;
			
			String questionLookup = (String) curSession.getAttribute("questionLookup");
			if( questionLookup == null ){
				answeredTable = st.executeQuery("SELECT * FROM Questions WHERE isAnswered = 1");
			}else{
				answeredTable = st.executeQuery("SELECT * FROM Questions WHERE isAnswered = 1 && question_subject LIKE '%"+questionLookup+"%'");
			}
						
			while(answeredTable.next()){ 
				Statement st2 = con.createStatement();
				ResultSet from = st2.executeQuery("SELECT display_name FROM Users WHERE user_id = '"+answeredTable.getString("asked_by")+"'");
				String fromUser = "(deleted user)";
				if(from.next()){
					fromUser = from.getString("display_name");
				}
				Statement st3 = con.createStatement();
				ResultSet answeredByTable = st3.executeQuery("SELECT display_name FROM Users WHERE user_id = '" + answeredTable.getString("answeredBy")+"'");
				String answeredBy = "(deleted user)";
				if(answeredByTable.next()){
					answeredBy = answeredByTable.getString("display_name");
				}
				
			%>
				<button class="accordion">
					 	<table><tr> 
						 	<td width=100 id=<%=answeredTable.getString("question_id")%>><%=fromUser%></td>
						 	<td width=100><%=answeredTable.getString("question_subject")%></td>
						 	<td width=400><%=answeredTable.getString("timestamp")%></td>
						 </tr></table>
				</button>
				<div class="panel">
					<table>
						<tr><td>
							&emsp;"<%=answeredTable.getString("question_text")%>"
						</td></tr>
						<tr><td>
							<b>Answered By: <%=answeredBy%></b> <br>
							&emsp;<%=answeredTable.getString("answer")%>							 
						</td></tr>
					</table>
				</div>				
		<% }
		con.close();
		st.close();
		} catch(Exception e){
		} %>
	</div>
</div>
<script src="js/communication_scripts.js"></script>
<script src="js/tabdisplay_scripts.js"></script>
<script>
	openTab(event, 'unanswered');
</script>
</body>
</html>