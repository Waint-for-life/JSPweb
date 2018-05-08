<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*,java.io.*,java.util.*"%>
<%@page import="javaClassSrc.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta charset="utf-8">
    <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="chengouxiang">
	<!-- Bootstrap Core CSS -->
    <link href="./vendor/bootstrap/css/bootstrap.min.css?v=1.1" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="./vendor/metisMenu/metisMenu.min.css?v=1.1" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="./dist/css/sb-admin-2.css?v=1.1" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="./vendor/morrisjs/morris.css?v=1.1" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="./vendor/font-awesome/css/font-awesome.min.css?v=1.1" rel="stylesheet" type="text/css">


	<link href="./vendor/datatables-plugins/dataTables.bootstrap.css?v=1.1" rel="stylesheet">

    <!-- DataTables Responsive CSS -->
    <link href="./vendor/datatables-responsive/dataTables.responsive.css?v=1.1" rel="stylesheet">
	<title>数控系统可靠性实验——结果详情</title>
</head>
<body>

	<%!
	String islogin = "0";
	String loginStr = "0";
	String backString = "";
	int loginFlag = 0;
	String username = "";
	String password = "";
	String location = "";
	String sid = "";
	
	String begindate = "";
	String enddate = "";

	String wrong_index = "";
	String common_index = "";
	String unchanged_index = "";
	String[] result_input = null;
	Vector<alarmInfo> alarmVector = new Vector<alarmInfo>();
	int refreshtimes = 0;
	
	%>
	
	<%
	try {
		request.setCharacterEncoding("utf-8");
		loginStr = request.getParameter("result");
		islogin = (String)session.getAttribute("islogin");
		refreshtimes = (Integer) session.getAttribute("refreshtimes");
		wrong_index = request.getParameter("wrong-index");
		common_index = request.getParameter("common-index");
		unchanged_index = request.getParameter("unchanged-index");
		
		result_input = request.getParameterValues("confirm-result");
		System.out.println(loginStr + "  and  "  + wrong_index + " and " + result_input);
	}
	catch(Exception e){
		//
		
	}
	if (result_input == null){
		
	}
	else{
		for(String s : result_input){
			System.out.println(s);
		}
		
	}
	
	if (loginStr == null || islogin == null || islogin.equals("0")) {
		loginStr = "";
		response.sendRedirect("login.jsp");
	}
	else {
		System.out.println("result : " + loginStr);

		username = (String)session.getAttribute("username");
		password = (String)session.getAttribute("password");
		location = (String)session.getAttribute("location");
		
		begindate = (String)session.getAttribute("beginDate");
		enddate = (String)session.getAttribute("endDate");
		
		//URLDecoder
		location = URLDecoder.decode(location, "utf-8");
		try{
			sid = loginStr;
			System.out.println(sid);
		}
		catch (Exception e){
			
		}
		
		backString = "1 " + username + " " + password + " " + location + " " ; 
		
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
			if (begindate == null && enddate == null){
				System.out.println("begin date and end date are not getted!");
			}
			else {
				conn.openStatement();
				conn.fillAlarmVector(alarmVector, sid, begindate, enddate);
				Collections.sort(alarmVector);
				System.out.println("alarm vector size : " + alarmVector.size());
				conn.closeStatement();
			}
			
		}
	} 
	
	
	if (wrong_index == null  || alarmVector.size() == 0)
	{

		wrong_index = "";
	}
	else {
		String[] wrong_index_vector = wrong_index.split(" ");
		String[] common_index_vector = common_index.split(" ");
		String[] unchanged_index_vector = unchanged_index.split(" ");
		String todayDate = "";
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		todayDate = sdf.format(d);

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
			
		}
		int j = 0;
		for (String str : wrong_index_vector){
			if (str == ""){
				continue;
			}
			int i = Integer.parseInt(str);
			//System.out.println(username + i + result_input[j]);
			conn.updateAlarmResult(username, result_input[j], todayDate, sid, alarmVector, i);
			alarmVector.get(i).is_wrong = true;
			j++;
		}
		
		
		for (String str : common_index_vector){
			if (str == ""){
				continue;
			}
			int i = Integer.parseInt(str);
			//System.out.println(username + i + result_input[j]);
			conn.updateCommonResult(sid, alarmVector, todayDate, username, i);
			alarmVector.get(i).is_wrong = false;
		}
		
		for (String str : unchanged_index_vector){
			if (str == ""){
				continue;
			}
			int i = Integer.parseInt(str);
			//System.out.println(username + i + result_input[j]);
			conn.updateCommonResult(sid, alarmVector, todayDate, username, i);
			alarmVector.get(i).is_wrong = false;
		}
		
		
		conn.closeStatement();
		if (refreshtimes % 2 == 0){
			String parameterrString =  "<script language='javaScript'> alert('提交成功！');window.location.reload('result.jsp?para=done');</script>";
			out.print(parameterrString);
			refreshtimes ++;
			session.setAttribute("refreshtimes", refreshtimes);
		}
		else{
			refreshtimes ++;
			session.setAttribute("refreshtimes", refreshtimes);
		}
	}
	
	%>

	<div id="wrapper">
		<!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">

               </div>
            <!-- /.navbar-header -->

            <ul class="nav navbar-top-links navbar-right">
                <!-- /.dropdown -->
                <li><strong><%=location %></strong></li>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="#"><i class="fa fa-user fa-fw"></i><%=username %> </a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="login.jsp"><i class="fa fa-sign-out fa-fw"></i> 登出 </a>
                        </li>
                        <li><a href="logup.jsp?para=1"><i class="fa fa-plus-circle fa-fw"></i> 子账号注册 </a>
                        </li>
                        <li><a href="logup.jsp?para=2"><i class="fa  fa-credit-card fa-fw"></i> 密码修改 </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->

            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                        
                        <li>
                            <a href="#"><i class="fa fa-dashboard fa-fw"></i> 功能导航</a>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-bus fa-fw"></i> 实验室建设<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="#"><i class="fa fa-microphone fa-fw"></i>视频</a>
                                </li>
                                <li>
                                    <a href="#"><i class="fa fa-photo fa-fw"></i>图片</a>
                                </li>
                                
                            </ul>
                            <!-- /.nav-second-level -->
                        </li>
                        <li>
                        	<a href="form_generate.jsp?para=<%=username  %>"><i class="fa fa-tasks fa-fw"></i>报表生成</a>
                        </li>
                        
                        <li></li>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>
        
        <div id="page-wrapper">
        	<div class="row">
        		<div class="col-lg-12">
        			<h1 class="text-center"><%=location %></h1>
        			
        			<form action="index.jsp" method="post">
						<input type="hidden" name="loginStr" value="<%=URLEncoder.encode(backString,"utf-8") %>">
						<input type="submit" class="btn btn-outline btn-info btn-lg btn-block" value="返回主页">
					</form>

        		</div>
        	</div>
        	<div class="row">
        		<div class="col-lg-12">
        			<div class="panel panel-default">
        				<div class="panel-heading">
        					<%= "设备号：" + sid %>
        				</div>
        				<div class="panel-body">
        				<form action="result.jsp?para=reload" onsubmit="process_options();" method="post" id="result-submit">
	        					<div class="table-responsive">
	        						<table class="table table-hover">
	        						<thead>
	        							<tr>
	        								<th>报警ID</th>
	        								<th>日期/时间</th>
	        								<th>报警内容</th>
	        								<th>是否故障</th>
	        								<th>确认人</th>
	        								<th>理由</th>
	        								<th>确认时间</th>
	        							</tr>
	        						</thead>
	        						<tbody>
	        							<%
	        							for(alarmInfo ai : alarmVector){
	        								%>
	        								<tr class="danger">
	        									<th><%=ai.id %></th>
	        									<th><%=ai.date.trim() %></th>
	        									<th><%=ai.infoContent %></th>
	        									<%
	        									if(ai.is_wrong){
	        										%>
	        									<th><button class="btn btn-danger" onclick="btn_trans(this);return false;" id="<%="confirm-btn-" + alarmVector.indexOf(ai) %>">是</button></th>
	        										<% 
	        									}
	        									else {
	        										%>
	        									<th><button class="btn btn-success" onclick="btn_trans(this);return false;" id="<%="confirm-btn-" + alarmVector.indexOf(ai) %>">否</button></th>
	        										<% 
	        									}
	        									%>
	        									<th><%=ai.confirmor %></th>
	        									<th><input name="confirm-result" class="form-control" id="<%="confirm-result-" + alarmVector.indexOf(ai) %>" placeholder="故障理由" disabled value="<%=ai.confirmReason %>"></th>
	        									<th><%=ai.confirmDate %></th>
	        								</tr>
	        								<% 
	        							}
	        							%>
	        						</tbody>
	        						</table>
	        					</div>
	        					
	        					<div  >
       			
				       				<div class="row">
				       					<div class="col-lg-12 text-center">
				       						<input type="hidden" name="result" value="<%=loginStr  %>">
				       						<input type="hidden" name="wrong-index" value="" id="wrong-index-id">
				       						<input type="hidden" name="common-index" value="" id="common-index-id">
				       						<input type="hidden" name="unchanged-index" value="" id="unchanged-index-id">
				       					</div>
				       				</div>
				       				<canvas width="15" height="15"></canvas>
				       				<div class="row">
				       					<div class="col-lg-12 text-center">
				       						<input type="submit" class="btn btn-info btn-block " value="提交" id="submit-danger">
				       					</div>
				       				</div>
				       			</div>
	        					
        					</form>
        					
        				</div>
        			</div>
        		</div>
        	</div>
        	
       		
        	<div>
        		<canvas width="200px" height="200px"></canvas>
        	</div>
        </div>
        
        
	</div>
	
	
	
	
	
	<!-- js src -->
	<!-- jQuery -->
    <script src="./vendor/jquery/jquery.min.js?v=1.1"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="./vendor/bootstrap/js/bootstrap.min.js?v=1.1"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="./vendor/metisMenu/metisMenu.min.js?v=1.1"></script>

    
	
    <!-- Custom Theme JavaScript -->
    <script src="./dist/js/sb-admin-2.js?v=1.1"></script>
    
    <!-- Flot Charts JavaScript -->
    <script src="./vendor/flot/excanvas.min.js?v=1.1"></script>
    <script src="./vendor/flot/jquery.flot.js?v=1.1"></script>
    <script src="./vendor/flot/jquery.flot.pie.js?v=1.1"></script>
    <script src="./vendor/flot/jquery.flot.resize.js?v=1.1"></script>
    <script src="./vendor/flot/jquery.flot.time.js?v=1.1"></script>
    <script src="./vendor/flot-tooltip/jquery.flot.tooltip.min.js?v=1.1"></script>
    <script src="./data/flot-data.js?v=1.1"></script>
    
    
    <script type="text/javascript">
    	btn_trans = function (obj) {
    		
			//console.log(obj.id)
			console.log(obj.className)
			//console.log(obj.textContent)
			if(obj.textContent == '是'){
				obj.textContent = '否'
				obj.className = 'btn btn-success'
				if (obj.classList.contains('changed')){
					
				}
				else {
					obj.classList.add('changed')
				}
				iswrong = false;
			}
			else {
				obj.textContent = '是'
				obj.className = 'btn btn-danger'
				if (obj.classList.contains('changed')){
					
				}
				else {
					obj.classList.add('changed')
				}
				iswrong = true;
			}
			var input_id = 'confirm-result-' + obj.id.split('-')[2]
			el = document.getElementById(input_id)
			//els = document.getElementsByClassName('btn btn-success')
			//console.log(els)
			/* for (var i = 0; i < els.length; i++) {
				console.log(els[i].id.split('-')[2])
			} */
			//console.log(el)
			el.disabled = !iswrong;

		}
    	process_options = function () {
			var el = document.getElementById('wrong-index-id')
			els = document.getElementsByClassName('btn btn-danger changed')
			//console.log(els)
			for (var i = 0; i < els.length; i++) {
				//console.log(els[i].id.split('-')[2])
				el.value += els[i].id.split('-')[2]
				el.value += " "
			} 
			
			var common_el = document.getElementById('common-index-id')
			common_els = document.getElementsByClassName('btn btn-success changed')
			for (var i = 0; i < common_els.length; i++) {
				//console.log(els[i].id.split('-')[2])
				common_el.value += common_els[i].id.split('-')[2]
				common_el.value += " "
			} 
			
			var unchanged_el = document.getElementById('unchanged-index-id')
			var unchanged_els = document.getElementsByClassName('btn btn-success')
			for (var i = 0; i < unchanged_els.length; i++) {
				//console.log(els[i].id.split('-')[2])
				if (unchanged_els[i].classList.contains('changed')){
					
				}
				else {
					unchanged_el.value += unchanged_els[i].id.split('-')[2]
					unchanged_el.value += " "
				}
				
			} 
			
			
			var send_btn = document.getElementById('submit-danger')
			send_btn.value = '正在提交结果，请稍后！'
			send_btn.classList.toggle('disabled')
			parent.location.reload(); 
		}
    </script>
    
    <script>
	window.onload=function(){
	/* 	url = location.href;
		 
		var para = url.split("?");
		console.log(para[1] == 'para=reload')
		
		if(para[1] == 'para=reload'){
		 
			location.href += 'done'
		 
			self.location.reload("result.jsp?para=done");
		 
		}  */
	}
</script>
    
</body>

	
    
    
</html>