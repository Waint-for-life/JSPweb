<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*"%>
<%@page import="javaClassSrc.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>数控系统可靠性实验——登录</title>
</head>
<body>
<%
	String username = (String) request.getParameter("username");		//尝试获得login传来的username和password
	String password = (String) request.getParameter("password");

	String driver = "";
	String url = "";
	String userName = "";
	String passWord = "";
	String location = "";	//location表示厂商名
	
	
	ServletContext sc;
	sc = getServletContext();
	
	driver = sc.getInitParameter("driver");		//获得配置文件中的数据库连接各项参数
	url = sc.getInitParameter("url");
	userName = sc.getInitParameter("adminuser");
	passWord = sc.getInitParameter("adminpwd");
	
	//System.out.println(driver + url + userName + passWord);
	
	
	OracleDBconnect conn = null;
	try{
		conn = (OracleDBconnect) session.getAttribute("ocacleConnection");	//首先尝试从session中得到数据库连接变量
		
	} catch(Exception e)
	{
		e.printStackTrace();
	}
	
	if (conn == null){			//若session中没有连接变量，则新建连接
		conn = new OracleDBconnect();
		conn.openConnection(driver, url, userName, passWord);
		session.setAttribute("ocacleConnection", conn);
		System.out.println("connect ocacle");
	}
	
	session.setAttribute("islogin", "0");	//在登录检查之前，首先将登录标志置0
	
	conn.openStatement();
	
	PairIntString checkresult = conn.checkLogin(username, password);	//进行登录检查
	
	if (checkresult.i == -1){	//检查失败
		//数据库连接出错
	}
	else if (checkresult.i == 0){
		//登录成功
		location = checkresult.str;
		String parameterrString =  "<script language='javaScript'> alert('登录成功——欢迎你"
				+ location + "的朋友');</script>";
		out.print(parameterrString);
		session.setAttribute("username", username);		//检查成功后，设置session，登录位置1
		session.setAttribute("password", password);
		session.setAttribute("location", location);
		session.setAttribute("islogin", "1");
		%>
		<form action="index.jsp" id="form-login" method="post">
			<input type="hidden" name="loginStr" value="">
		</form>
		<script type="text/javascript">
			
		document.getElementById("form-login").submit();
		
			
		</script> 
		<% 
	}
	else if(checkresult.i == 5) {
		//管理员登录
		//登录成功
		location = checkresult.str;
		String parameterrString =  "<script language='javaScript'> alert('管理员登录——欢迎你"
				+ location + "的朋友');</script>";
		out.print(parameterrString);
		session.setAttribute("username", username);		//检查成功后，设置session，登录位置1
		session.setAttribute("password", password);
		session.setAttribute("location", location);
		session.setAttribute("islogin", "1");
		%>
		<form action="adminIndex.jsp" id="form-login-admin" method="post">
			<input type="hidden" name="loginStr" value="">
		</form>
		<script type="text/javascript">
			
		document.getElementById("form-login-admin").submit();
		
			
		</script> 
		<% 
	}
	else if(checkresult.i == 1){
		//密码错误
		response.sendRedirect("login.jsp?password=0");
	}
	else if (checkresult.i == 2){
		//账号不存在
		response.sendRedirect("login.jsp?username=0");
	}
	
	conn.closeStatement();
%>
</body>
</html>