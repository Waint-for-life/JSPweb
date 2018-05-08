<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="javaClassSrc.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>注册/修改密码检查</title>
</head>
<body>
	<%!
	String islogin = "0";
	String username = "";
	String location = "";
	String password = "";
	String logup_modify_flag = "";
	
	%>
	
	<%
	islogin = (String)session.getAttribute("islogin");
	if (islogin == null || islogin.equals("0")){
		response.sendRedirect("login.jsp");
	}
	location = (String) session.getAttribute("location");
	username = (String) session.getAttribute("username");
	password = (String) session.getAttribute("password");
	logup_modify_flag = request.getParameter("logup-modify-flag");
	
	OracleDBconnect conn = null;
	try{
		conn = (OracleDBconnect) session.getAttribute("ocacleConnection");
		
	} catch(Exception e)
	{
		e.printStackTrace();
	}
	
	if (conn == null){
		System.out.println("conn is null");
		response.sendRedirect("login.jsp");
	}
	else {
		conn.openStatement();
		if (logup_modify_flag.equals("logup")){
			String new_username = request.getParameter("logup-username");
			String new_password = request.getParameter("logup-password");
			if (new_password == null || new_username == null){
				System.out.println("logup wrong then to login");
				response.sendRedirect("login.jsp");
			}
			else {
				boolean success = conn.addUser(new_username, new_password, location);
				if (success) {
					System.out.println("logup success");
					String parameterrString =  "<script language='javaScript'> alert('注册成功！');</script>";
					out.print(parameterrString);
					
					%>
					<form action="index.jsp" id="form-logup" method="post">
						<input type="hidden" name="loginStr" value="">
					</form>
					<script type="text/javascript">
						
					document.getElementById("form-logup").submit();
					
						
					</script> 
					<% 
				}
				else {
					System.out.println("logup ! success");
					String parameterrString =  "<script language='javaScript'> alert('该用户已存在！');</script>";
					out.print(parameterrString);
					
					%>
					<form action="logup.jsp?para=1" id="form-logup" method="post">
						<input type="hidden" name="loginStr" value="">
					</form>
					<script type="text/javascript">
						
					document.getElementById("form-logup").submit();
					
						
					</script> 
					<% 
				}
				
				
			}
		}
		else if (logup_modify_flag.equals("modify")) {
			String new_password = request.getParameter("modify-new-password");
			if (new_password == null){
				System.out.println("modify wrong then to login");
				response.sendRedirect("login.jsp");
			}
			else {
				conn.modifyPassword(username, new_password);
				session.setAttribute("password", new_password);
				
				String parameterrString =  "<script language='javaScript'> alert('密码修改成功！');</script>";
				out.print(parameterrString);
				
				%>
				<form action="index.jsp" id="form-logup" method="post">
					<input type="hidden" name="loginStr" value="">
				</form>
				<script type="text/javascript">
					
				document.getElementById("form-logup").submit();
				
					
				</script> 
				<% 
				
			}
		}
		conn.closeStatement();
	}
	
	
	
	%>
</body>
</html>