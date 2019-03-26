<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="javax.servlet.http.*"%>

<% 	/* Log user out */
	HttpSession curSession = request.getSession(false);
	curSession.invalidate();
	response.sendRedirect("login.jsp"); 
%>