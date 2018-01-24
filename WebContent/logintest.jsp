<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>数控系统可靠性实验——登录</title>
</head>
<body>
<%
	String username = (String) request.getParameter("username");
	String password = (String) request.getParameter("password");
	Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
	
	String url = "jdbc:oracle:thin:@localhost:1521:orcl";
	
	String userName = "CHEN";
	String passWord = "110120";
	
	Connection connection = DriverManager.getConnection(url, userName, passWord);
	
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	String sql = "SELECT * FROM USERTABLE";
	ResultSet rs = statement.executeQuery(sql);
	
	String loginStr = "0";
	
	while (rs.next())
	{
		String nametemp = rs.getString(1);
		if (username.equals(nametemp))
		{
			String passwdtemp = rs.getString(2);
			if (password.equals(passwdtemp))
			{
				//成功登录
				String parameterrString =  "<script language='javaScript'> alert('登陆成功——欢迎你"
						+ rs.getString(3) + "的朋友');</script>";
				out.print(parameterrString);
				loginStr ="1 " + username + " " + password + " " + rs.getString(3) + " ";
				//System.out.println(loginStr);
				String paraString = "modeltest.jsp?loginStr=" + URLEncoder.encode(loginStr,"utf-8");
				//paraString = new String(paraString.getBytes("ISO-8859-1"),"UTF-8");
				
				response.sendRedirect(paraString);
				break;
			}
			else 
			{
				//密码错误
				response.sendRedirect("login.jsp?password=0");
				break;
			}
		}
		else 
		{
			continue;
		}
	}
	rs.previous();
	if (!rs.next())
	{
		//用户名不存在
		response.sendRedirect("login.jsp?username=0");
	}
	rs.close();
	statement.close();
	connection.close();
%>
</body>
</html>