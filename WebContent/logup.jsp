<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<!-- Bootstrap Core CSS -->
    <link href="./vendor/bootstrap/css/bootstrap.min.css?v=1.1" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="./vendor/metisMenu/metisMenu.min.css?v=1.1" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="./dist/css/sb-admin-2.css?v=1.1" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="./vendor/font-awesome/css/font-awesome.min.css?v=1.1" rel="stylesheet" type="text/css">

<title>数控系统可靠性实验——注册</title>
</head>
<body>
	<%!
	String islogin = "0";
	String username = "";
	String location = "";
	String password = "";
	String mode = "1";	//mode 1 注册 mode 2 改密码
	%>
	<%
	islogin = (String)session.getAttribute("islogin");
	if (islogin == null || islogin.equals("0")){
		response.sendRedirect("login.jsp");
	}
	location = (String) session.getAttribute("location");
	username = (String) session.getAttribute("username");
	password = (String) session.getAttribute("password");
	mode = request.getParameter("para");
	%>
	<div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                <%
                if(mode.equals("1")){
                	%>
                	<div class="panel-heading">
                        <h3 class="panel-title">请填写注册信息</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" action="loguptest.jsp" onsubmit="">
                            <fieldset>
                            	<input type="hidden" value="logup" name="logup-modify-flag">
                                <div class="form-group">
                                	<label>输入注册账号：（英文字母或数字）</label>
                                    <input class="form-control" id="logup-user" placeholder="账号" name="logup-username" type="username" autofocus>
                                </div>
                                <div class="form-group">
                                	<label>输入注册密码：</label>
                                    <input class="form-control" id="logup-pw" placeholder="密码" name="logup-password" type="password" value="">
                                </div>
                                <div class="form-group">
                                	<label>请重复密码：</label>
                                    <input class="form-control" id="logup-pw-repeat" placeholder="重复密码" name="logup-password" type="password" value="">
                                </div>
                                <div class="form-group">
                                	<label>单位：</label>
                                    <input disabled="disabled" class="form-control" id="logup-com" placeholder="单位" name="logup-company" type="text" value="<%=location %>">
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <div class="form-group">
                                	<input id="logup-btn" class="btn btn-lg btn-success btn-block" type="submit" onclick="return logupsubmittest();" value="注册">
                                </div>
                                <!-- <a href="index.html" class="btn btn-lg btn-success btn-block">Login</a> -->
                            </fieldset>
                        </form>
                    </div>

                	
                	<% 
                }
                else if (mode.equals("2")){
                	%>
                	<div class="panel-heading">
                        <h3 class="panel-title">请填写密码修改信息</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" action="loguptest.jsp" onsubmit="">
                            <fieldset>
                            	<input type="hidden" value="modify" name="logup-modify-flag">
                                <div class="form-group">
                                	<label>账号：</label>
                                    <input disabled="disabled" class="form-control" id="modify-user" placeholder="账号" name="modify-username" type="username" value="<%=username %>" >
                                </div>
                                <div class="form-group">
                                	<label>输入原密码：</label>
                                    <input class="form-control" id="modify-origin-pw" placeholder="原始密码" name="modify-origin-password" type="password" value="" autofocus>
                                </div>
                                <div class="form-group">
                                	<label>请输入新密码：</label>
                                    <input class="form-control" id="modify-new-pw" placeholder="新密码" name="modify-new-password" type="password" value="">
                                </div>
                                <div class="form-group">
                                	<label>请重复新密码：</label>
                                    <input class="form-control" id="modify-new-repeat" placeholder="重复密码" name="modify-new-password" type="password" value="">
                                </div>
                                <div class="form-group">
                                	<label>单位：</label>
                                    <input disabled="disabled" class="form-control" id="logup-com" placeholder="单位" name="logup-company" type="text" value="<%=location %>">
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <div class="form-group">
                                	<input id="modify-btn" class="btn btn-lg btn-success btn-block" type="submit" onclick="return modifysubmittest();" value="提交">
                                </div>
                                <!-- <a href="index.html" class="btn btn-lg btn-success btn-block">Login</a> -->
                            </fieldset>
                        </form>
                    </div>
                	<%
                }
                %>
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
    
    <script type="text/javascript">
    	logupsubmittest = function() {
    		
			username = document.getElementById('logup-user')
			password = document.getElementById('logup-pw')
			password_repeat = document.getElementById('logup-pw-repeat')
			if (username.value == ""){
				alert('请输入账号！')
				
				return false;
			}
			else if (password.value == "") {
				alert('请输入密码！')
				
				return false;
			}
			else if (password.value != password_repeat.value) {
				alert('两次密码输入不相同！')
				password.value = "";
				password_repeat.value = "";
				return false;
			}
			logupbtn = document.getElementById('logup-btn')
    		logupbtn.value = "正在提交，请稍后！"
    		logupbtn.classList.toggle('disabled')
			return true;
		}
    	
    	modifysubmittest = function() {
    		
    		password_origin_right = '<%=password %>'
    		password_origin = document.getElementById('modify-origin-pw')
    		password_new = document.getElementById('modify-new-pw')
    		password_new_repeat = document.getElementById('modify-new-repeat')
    		if (password_origin.value == ""){
    			alert('原密码不能为空！')
    			return false
    		}
    		else if (password_new.value == ""){
    			alert('新密码不能为空！')
    			return false
    		}
    		else if (password_new_repeat.value == ""){
    			alert('请重复输入新密码！')
    			return false
    		}
    		else if (password_new.value != password_new_repeat.value){
    			alert('两次新密码输入不同！')
    			password_new.value = ""
    			password_new_repeat.value = ""
    			return false
    		}
    		else if (password_origin.value != password_origin_right){
    			alert('原密码输入错误！')
    			password_origin.value = ""
    			
    			return false
    		}
    		modifybtn = document.getElementById('modify-btn')
    		modifybtn.value = "正在提交，请稍后！"
    		modifybtn.classList.toggle('disabled')
    		
		}
    	
    </script>
    
</body>
</html>