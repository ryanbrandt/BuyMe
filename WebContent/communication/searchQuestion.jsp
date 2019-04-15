<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	HttpSession curSession = request.getSession(false); 
	if( request.getParameter("isReset").equals("0")){
		curSession.setAttribute("questionLookup", request.getParameter("questionLookup"));
	}else{
		curSession.setAttribute("questionLookup", null);
	}
%>