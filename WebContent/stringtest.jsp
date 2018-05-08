<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.sql.*,java.io.*,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%
	String date1 = "2018-01-01";
	String date2 = "2018-01-02 23:59:59:999";
	String date3 = "2018-01-03";
	String url = "jdbc:oracle:thin:@localhost:1521:orcl";
	String driver = "oracle.jdbc.driver.OracleDriver";
	String userName = "OUTRANGE";
	String passWord = "110120";
	Connection connection;
	Statement statement;
	ResultSet rs;

	try {
	    Class.forName(driver).newInstance();
	    connection = DriverManager.getConnection(url, userName, passWord);
	
	    statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		//String sql = "SELECT * FROM CHEN.TEST";
	    String sql = "SELECT * FROM INFODB.G_NUMBERINFO WHERE INFODB.G_NUMBERINFO.\"time\" BETWEEN \'" + date1 + "\' AND \'" + date2 + "\'";
		System.out.println(sql);
	    rs = statement.executeQuery(sql);
	    if (rs.next()){
	    	System.out.println("has data");
	        System.out.println(rs.getString("time"));
	    } 
	    
	    rs.close();
	    statement.close();
	    connection.close();
	} catch(Exception e) {
	   	e.printStackTrace();
	}

%>



</body>
</html>