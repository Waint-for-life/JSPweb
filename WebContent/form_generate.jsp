<%@page import="java.util.zip.ZipFile"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*"%>
<%@page import="javaClassSrc.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>数控系统可靠性实验——报表生成</title>

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

</head>
<body>

	<%!
	int grade = 0;
	String username = "";
	String password = "";
	String location = "";	//location表示厂商名
	String islogin = "0";
	String backString = "";
	String fileDir = "";
	
	String firstDate = "0000-00-00";
	String lastDate = "0000-00-00";
	
	String beginDate = "0000-00-00";
	String endDate = "2018-12-31";
	
	String firstyear = "0";
	String firstmonth = "0";
	String firstday = "0";
	
	String lastyear = "0";
	String lastmonth = "0";
	String lastday = "0";
	
	String beginyear = "0";
	String beginmonth = "0";
	String beginday = "0";
	
	String endyear = "0";
	String endmonth = "0";
	String endday = "0";
	
	%>
	<%
		lastDate = (String) session.getAttribute("lastDate");
		if (lastDate == null){
			System.out.println("lastday is null");
			response.sendRedirect("login.jsp");
		}
		
		
		
		ServletContext sc;
		sc = getServletContext();
		
		fileDir = sc.getInitParameter("fileDir");
		
		username = request.getParameter("para");
		password = "";
		islogin = (String)session.getAttribute("islogin");
		if (username == null)
		{
			System.out.println("username null");
			username = "";
			response.sendRedirect("login.jsp");
		}
		else if (  islogin == null )
		{
			System.out.println("login null");
			response.sendRedirect("login.jsp");
		}
		else if (islogin.equals("0"))
		{
			System.out.println("login 0");
			response.sendRedirect("login.jsp");
		}
		
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
			
			
		}
		
		Vector<form_result> vresult = null;
		
		
		beginyear = request.getParameter("form-begin-date-year");
		beginmonth = request.getParameter("form-begin-date-month");
		beginday = request.getParameter("form-begin-date-day");
		
		endyear = request.getParameter("form-end-date-year");
		endmonth = request.getParameter("form-end-date-month");
		endday = request.getParameter("form-end-date-day"); 
		
		DateStruct datestruct = StringProcessUtil.processYMD(beginyear, beginmonth, beginday, endyear, endmonth, endday);
		
		if (datestruct != null){
			beginDate = datestruct.begindate;
			endDate = datestruct.enddate;
			session.setAttribute("beginDate", beginDate);
			session.setAttribute("endDate", endDate);
			
			conn.openStatement();
			vresult = new Vector<form_result>();
			conn.fillFormResult(vresult, location, beginDate, endDate);
			session.setAttribute("form-result-vector", vresult);
			conn.closeStatement();
			
			
		}
		else {
			firstyear = "0";
			firstmonth = "0";
			firstday = "0";
			
			lastyear = "0";
			lastmonth = "0";
			lastday = "0";
			
			beginyear = "0";
			beginmonth = "0";
			beginday = "0";
			
			endyear = "0";
			endmonth = "0";
			endday = "0";
		}
		
		
		beginDate = (String) session.getAttribute("beginDate");
		endDate = (String) session.getAttribute("endDate");
		DateStruct ds = StringProcessUtil.processDateString(lastDate, beginDate, endDate);
		
		firstDate = ds.firstdate;
		firstday = ds.firstday;
		firstmonth = ds.firstmonth;
		firstyear = ds.firstyear;
		
		lastDate = ds.lastdate;
		lastday = ds.lastday;
		lastmonth = ds.lastmonth;
		lastyear = ds.lastyear;
		
		beginDate = ds.begindate;
		beginday = ds.beginday;
		beginmonth = ds.beginmonth;
		beginyear = ds.beginyear;
		
		endDate = ds.enddate;
		endday = ds.endday;
		endmonth = ds.endmonth;
		endyear = ds.endyear;
		
		
		location = (String) session.getAttribute("location");
		
		
		String[] type_checkboxs = request.getParameterValues("type-checkboxs");
		
		String[] sid_checkboxs = request.getParameterValues("sid-checkboxs");
		
		boolean is_get_file = false;
		boolean is_alarm = false;
		boolean is_outrange = false;
		boolean is_span = false;
		boolean is_repeat = false;
		boolean is_alarm_detail = false;
		boolean is_outrange_detail = false;
		boolean is_span_detail = false;
		boolean is_repeat_detail = false;
		
		
		vresult = (Vector<form_result>) session.getAttribute("form-result-vector");
		if (vresult == null){
			conn.openStatement();
			vresult = new Vector<form_result>();
			conn.fillFormResult(vresult, location, beginDate, endDate);
			session.setAttribute("form-result-vector", vresult);
			conn.closeStatement();
		}
		
		
		if (type_checkboxs != null && sid_checkboxs != null)
		{
			is_get_file = true;
			
			for(String s : sid_checkboxs)
			{
				for (form_result f : vresult)
				{
					if(s.equals(f.sid))
					{
						f.generate_file = true;
						break;
					}
				}
			}
			
			for(String s : type_checkboxs)
			{
				if (s.equals("报警"))
				{
					is_alarm = true;
					String is_detail = request.getParameter("danger-select");
					if (is_detail.equals("是"))
					{
						is_alarm_detail = true;
					}
				}
				else if (s.equals("超时"))
				{
					is_span = true;
					String is_detail = request.getParameter("span-select");
					if (is_detail.equals("是"))
					{
						is_span_detail = true;
					}
				}
				else if (s.equals("超范围"))
				{
					is_outrange = true;
					String is_detail = request.getParameter("outrange-select");
					if (is_detail.equals("是"))
					{
						is_outrange_detail = true;
					}
				}
				else if (s.equals("重复"))
				{
					is_repeat = true;
					String is_detail = request.getParameter("repeat-select");
					if (is_detail.equals("是"))
					{
						is_repeat_detail = true;
					}
				}
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
                        <%-- <li>
                            <a href="history.jsp?loginStr=<%=URLEncoder.encode(loginStr,"utf-8")%>"><i class="fa fa-line-chart fa-fw"></i> 历史信息</a>
                        </li>
                         --%>
                        
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
        			<canvas width="10px" height="10px"></canvas>
        			
        		</div>
        	</div>
        	<%
        	if (!is_get_file)
        	{
        		%>
        	
        	<div class="row">
        		<div class="col-lg-12">
        			<div class="panel panel-default">
        				<div class="panel-heading">
        					<p class="text-center" style="font-size: 25px;">请选择报表选项</p>
        				</div>
        				<div class="panel-body">
	        				<form action="form_generate.jsp" onsubmit="return disable_button();">
	        					<div class="form-group">
	        						<div class="row">
	        							<label style="font-size: 15px;">请选择报表包括的内容:</label>
	        						</div>
	        						
	        						<div class="checkbox-inline">
	        							<label>
	        								<input type="checkbox" value="报警" name="type-checkboxs" checked>报警信息
	        							</label>
	        							<label>（是否详情）
	        								<select name="danger-select">
	        									<option>是</option>
	        									<option>否</option>
	        								</select>
	        							</label>
	        						</div>
	        						<div class="checkbox-inline">
	        							<label>
	        								<input type="checkbox" value="超时" name="type-checkboxs" checked>超时间间隔信息
	        							</label>
	        							<label>（是否详情）
	        								<select name="span-select">
	        									<option>是</option>
	        									<option>否</option>
	        								</select>
	        							</label>
	        						</div>
	        						<div class="checkbox-inline">
	        							<label>
	        								<input type="checkbox" value="超范围" name="type-checkboxs" checked>超范围信息
	        							</label>
	        							<label>（是否详情）
	        								<select name="outrange-select">
	        									<option>是</option>
	        									<option>否</option>
	        								</select>
	        							</label>
	        						</div>
	        						<div class="checkbox-inline">
	        							<label>
	        								<input type="checkbox" value="重复" name="type-checkboxs" checked>重复操作信息
	        							</label>
	        							<label>（是否详情）
	        								<select name="repeat-select">
	        									<option>是</option>
	        									<option>否</option>
	        								</select>
	        							</label>
	        						</div>
	        					</div >
	        					<div class="form-group">
	        						<div class="row">
	        							<label>请选择机床号（每台机床将生成一个文件）</label>
	        						</div>
	        						<%
	        						for(form_result f : vresult)
	        						{
	        							%>
	        							<div class="checkbox-inline">
	        								<label>
	        									<input type="checkbox" value="<%=f.sid %>" name="sid-checkboxs">
	        									<%=f.sid %>
	        								</label>
	        							</div>
	        							<% 
	        						}
	        						%>
	        						<div class="checkbox">
	        							<label>
											<input type="checkbox" value="all-check" onclick="selectAll()" id="is-allcheck">
											机床全选 			
	        							</label>
	        							
	        						</div>
	        					</div>
	        					<input type="hidden" name="para" value="<%=username %>">
	            				<div class="row">
	            					<div class = "form-group col-md-3" >
		            					<label>开始日期</label>
		            					<label>年：</label>
		            					<select class="form-control" name="form-begin-date-year">
		            					<%
		            					int firstyearInt = Integer.parseInt(firstyear);
		            					int lastyearInt = Integer.parseInt(lastyear);
		            					for (int i = firstyearInt; i <= lastyearInt; i++){
		            						if (i == Integer.parseInt(beginyear)){
		            							%>
		            							<option selected="selected"><%=String.valueOf(i) %></option>
		            							<% 
		            						}
		            						else{
		            							%>
		            							<option><%=String.valueOf(i) %></option>
		            							<%
		            						}
		            					}
		            					%>
		                                   
		                               	</select>
		                               	
		                  			</div>
		                  			
		                           	<div class = "form-group col-md-3" >
		                               <label>月：</label>
		                               <select class="form-control" name="form-begin-date-month">
		                                <%
		            					for (int i = 1; i <= 12; i++){
		            						if (i == Integer.parseInt(beginmonth)){
		            							%>
		            							<option selected="selected"><%=String.valueOf(i) %></option>
		            							<% 
		            						}
		            						else{
		            							%>
		            							<option><%=String.valueOf(i) %></option>
		            							<%
		            						}
		            					}
		            					%>
		                               </select>
		                        	</div>
		                        	
		                           	<div class = "form-group col-md-3" >
		                               <label>日：</label>
		                               <select class="form-control" name="form-begin-date-day">
		                               <%
		            					for (int i = 1; i <= 31; i++){
		            						if (i == Integer.parseInt(beginday)){
		            							%>
		            							<option selected="selected"><%=String.valueOf(i) %></option>
		            							<% 
		            						}
		            						else{
		            							%>
		            							<option><%=String.valueOf(i) %></option>
		            							<%
		            						}
		            					}
		            					%>
		                            	</select>
            						</div>
            					</div>
	            				<div class="row">
	            					<div class = "form-group col-md-3">
		            					<label>终止日期</label>
		            					<label>年：</label>
		            					<select class="form-control" name="form-end-date-year">
		                                <%
		            					
		            					for (int i = firstyearInt; i <= lastyearInt; i++){
		            						if (i == Integer.parseInt(endyear)){
		            							%>
		            							<option selected="selected"><%=String.valueOf(i) %></option>
		            							<% 
		            						}
		            						else{
		            							%>
		            							<option><%=String.valueOf(i) %></option>
		            							<%
		            						}
		            					}
		            					%>
		                               </select> 
		                        	</div>
		                        	<div class = "form-group col-md-3">
		            					<label>月：</label>
		            					<select class="form-control" name="form-end-date-month">
		                                <%
		            					for (int i = 1; i <= 12; i++){
		            						if (i == Integer.parseInt(endmonth)){
		            							%>
		            							<option selected="selected"><%=String.valueOf(i) %></option>
		            							<% 
		            						}
		            						else{
		            							%>
		            							<option><%=String.valueOf(i) %></option>
		            							<%
		            						}
		            					}
		            					%>
		                               </select> 
		                        	</div>
		                        	<div class = "form-group col-md-3">
		            					<label>日：</label>
		            					<select class="form-control" name="form-end-date-day">
		                                <%
		            					for (int i = 1; i <= 31; i++){
		            						if (i == Integer.parseInt(endday)){
		            							%>
		            							<option selected="selected"><%=String.valueOf(i) %></option>
		            							<% 
		            						}
		            						else{
		            							%>
		            							<option><%=String.valueOf(i) %></option>
		            							<%
		            						}
		            					}
		            					%>
		                               </select> 
		                        	</div>
		                        </div>
	        					<%
	        					if (is_get_file)
	        					{
	        						%>
	        						<div class="col-md-3">
	        							<input type="submit" class="btn btn-success btn-block disabled" value="生成">
	        						</div>
	        						<% 
	        					}
	        					else
	        					{
	        						%>
	        						<div class="col-md-3">
	        							<input type="submit" class="btn btn-success btn-block " value="生成" id="general-button">
	        						</div>
	        						<% 
	        					}
	        					%>
	        					
	        					
	        					
	        					<div class="row">
        							<div class="col-lg-12">
        							
        							</div>
        						</div>
	        				</form>
        					
        				</div>
        			</div>
        			
        		</div>
        	</div>
        	<%
        	}
        	%>
        
        <%
        if (is_get_file)
        {
        	%>
        	<div class="huge">
        		请按需要下载：
        	</div>
        	<% 
        	Vector<File> vfile = new Vector<File>();
        	for (form_result f : vresult)
        	{
        		f.generateExcel(vfile, fileDir);
        		if(f.generate_file)
        		{
                	%>
                	<a href="<%="./outputsheet/" + f.sid + ".xls" %>" class="huge" download="<%=f.sid + ".xls" %>"><%=f.sid + ".xls" %></a>
                	<% 
        		}
        	}
        	ZIPfile zipfile = new ZIPfile();
        	String zippath = fileDir + "all.zip";
        	//String zippath = "C:\\Tomcat7\\webapps\\tomcatTest\\WebContent\\outputsheet\\" + "all.zip";
        	File outzip = new File(zippath);
        	if (outzip.exists()){
        		outzip.delete();
        		outzip.createNewFile();
        	}
        	zipfile.zipFiles(vfile, outzip);
        	%>
        	<div class="row huge">
        		<a href="<%="./outputsheet/all.zip" %>" download = "all.zip">全部下载（压缩文件.zip）</a>
        	</div>
        	
        	<%
        }
        %>
        	
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
    
    <!-- echart -->
    <script type="text/javascript" src="./echart/echarts.js?v=1.1"></script>
    
    <script type="text/javascript">
    	function selectAll() {
    		var allchecked = document.getElementById("is-allcheck");
			var all = document.getElementsByName("sid-checkboxs");
			for ( var i = 0; i < all.length; i++) {  
	            all[i].checked = allchecked.checked;  
	        }  
		}
    	function disable_button() {
    		
			var button = document.getElementById('general-button')
			//console.log(button.value)
			button.value = '正在生成文件，请稍后！'
			button.classList.toggle('disabled')
		}
    </script>
    
</body>
</html>