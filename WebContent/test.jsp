
<%@page import="java.sql.*,java.io.*,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="mystyle.css">
	<script type="text/javascript" src="myjs.js"></script>
	<title>hello world ! </title>		
</head>
<body>
	
	
	<%
	String username = (String) request.getParameter("username");
	String password = (String) request.getParameter("password");
	
	/* System.out.println(username);
	System.out.println(password);
	System.out.println(username == "chen");
	System.out.println(password == "110120");
	if (username.equals("chen")  && password.equals("110120")) {
		out.print("<script language='javaScript'> alert('登陆成功——if');</script>");
	}
	else {
		out.print("<script language='javaScript'> alert('账号错误——else');</script>");
		response.setHeader("refresh", "0;url=login.jsp");
	} */
	
	/*
	//MySQL 数据库链接
	
	//驱动程序名
	String driverName = "com.mysql.jdbc.Driver";
	//数据库用户名
	String userName = "root";
	//密码
	String userPasswd = "110120";
	//数据库名
	String dbName = "numeral";
	//表名
	String tableName = "loginTable";
	//链接字符串
	String url = "jdbc:mysql://localhost:3306/" + dbName + "?useSSL=false&user="  
            + userName + "&password=" + userPasswd;  
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection(url);
	Statement statement = connection.createStatement();
	String sql = "SELECT * FROM " + tableName;
	ResultSet rs = statement.executeQuery(sql);
	while (rs.next())
	{
		String nametemp = rs.getString(1);
		if (username.equals(nametemp))
		{
			String passwdtemp = rs.getString(2);
			if (password.equals(passwdtemp))
			{
				String parameterrString =  "<script language='javaScript'> alert('登陆成功——欢迎你"
						+ rs.getString(3) + "的朋友');</script>";
				out.print(parameterrString);
				response.setHeader("refresh", "0;url=index.jsp");
				break;
			}
			else 
			{
				out.print("<script language='javaScript'> alert('密码错误请重试');</script>");
				response.setHeader("refresh", "0;url=login.jsp");
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
		out.print("<script language='javaScript'> alert('用户名不存在');</script>");
		response.setHeader("refresh", "0;url=login.jsp");
	}
	rs.close();
	statement.close();
	connection.close();
	
	*/
	
	//Oracle 数据库链接
	
	Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
	
	String url = "jdbc:oracle:thin:@localhost:1521:orcl";
	
	String userName = "CHEN";
	String passWord = "110120";
	
	Connection connection = DriverManager.getConnection(url, userName, passWord);
	
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	String sql = "SELECT * FROM USERTABLE";
	ResultSet rs = statement.executeQuery(sql);
	
	while (rs.next())
	{
		String nametemp = rs.getString(1);
		if (username.equals(nametemp))
		{
			String passwdtemp = rs.getString(2);
			if (password.equals(passwdtemp))
			{
				String parameterrString =  "<script language='javaScript'> alert('登陆成功——欢迎你"
						+ rs.getString(3) + "的朋友');</script>";
				out.print(parameterrString);
				response.setHeader("refresh", "0;url=index.jsp");
				break;
			}
			else 
			{
				out.print("<script language='javaScript'> alert('密码错误请重试');</script>");
				response.setHeader("refresh", "0;url=login.jsp");
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
		out.print("<script language='javaScript'> alert('用户名不存在');</script>");
		response.setHeader("refresh", "0;url=login.jsp");
	}
	rs.close();
	statement.close();
	connection.close();
	
	%>

<!-- 	<div class="botCenter">
		床前明月光，
			疑是地上霜。
				举头望明月，
					低头思故乡。
		
	</div>
	<p class="botCenter">hello world </p>
	
	

	<div class="logininput">
		<p>用户名
		<input type="text" onkeyup="this.value=this.value.replace(/[^a-zA-Z]/g,'')" id="username">
		</p>
		<p>密码&nbsp;&nbsp;&nbsp;
		<input type="password" onkeyup="this.value=this.value.replace(/[^a-zA-Z]/g,'')" id="password">
		</p>
		<button type="submit"  id="submitbtn" onclick="gotoBaidu()">登录</button> 
		<button onclick="showpassword()" id="showpass">show password</button>
		
	</div>
	 -->
	</body>
</html>