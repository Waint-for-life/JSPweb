<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>数控系统可靠性实验——登录</title>

    <!-- Bootstrap Core CSS -->
    <link href="./vendor/bootstrap/css/bootstrap.min.css?v=1.1" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="./vendor/metisMenu/metisMenu.min.css?v=1.1" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="./dist/css/sb-admin-2.css?v=1.1" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="./vendor/font-awesome/css/font-awesome.min.css?v=1.1" rel="stylesheet" type="text/css">
</head>
<body>
<%
	String loginflag="";
	try {
		request.setCharacterEncoding("utf-8");
		loginflag = request.getParameter("username");
		
	}
	catch(Exception e){
	//
	
	}
	if(loginflag == null)
	{
		try {
			request.setCharacterEncoding("utf-8");
			loginflag = request.getParameter("password");
			
		}
		catch(Exception e){
		//
		
		}
		if(loginflag == null)
		{
			
		}
		else if(loginflag.equals("0")){
			out.print("<script language='javaScript'> alert('密码错误请重试');</script>");
		}
	}
	else if(loginflag.equals("0")){
		out.print("<script language='javaScript'> alert('用户名不存在');</script>");
	}
%>

	<div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">请先登录</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" action="logintest.jsp">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="账号" name="username" type="username" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="密码" name="password" type="password" value="">
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <div class="form-group">
                                	<input class="btn btn-lg btn-success btn-block" type="submit" value="登录">
                                </div>
                                <!-- <a href="index.html" class="btn btn-lg btn-success btn-block">Login</a> -->
                            </fieldset>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- jQuery -->
    <script src="./vendor/jquery/jquery.min.js?v=1.1"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="./vendor/bootstrap/js/bootstrap.min.js?v=1.1"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="./vendor/metisMenu/metisMenu.min.js?v=1.1"></script>

    <!-- Custom Theme JavaScript -->
    <script src="./dist/js/sb-admin-2.js?v=1.1"></script>
</body>
</html>