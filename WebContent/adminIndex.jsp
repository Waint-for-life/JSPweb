<%@page import="java.text.DateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*,java.io.*,java.util.*"%>
<%@page import="javaClassSrc.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta charset="utf-8">

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="chengouxiang">

    <title>数控系统可靠性实验</title>

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
	
	String islogin = "0";
	String username = "";
	String password = "";
	String location = "";	//location表示厂商名
	String todayDate = "";
	
	String firstDate = "0000-00-00";
	String lastDate = "0000-00-00";
	
	String beginDate = "0000-00-00";
	String endDate = "0000-00-00";
	
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
	
	int refreshtimes = 0;
	
	Vector<AdminResult> adminResultvector = new Vector<AdminResult>();
%>
<% 
	
	try {
		request.setCharacterEncoding("utf-8");
		islogin = (String)session.getAttribute("islogin");
		
		session.setAttribute("refreshtimes", refreshtimes);
		
		beginyear = request.getParameter("index-begin-date-year");
		beginmonth = request.getParameter("index-begin-date-month");
		beginday = request.getParameter("index-begin-date-day");
		
		endyear = request.getParameter("index-end-date-year");
		endmonth = request.getParameter("index-end-date-month");
		endday = request.getParameter("index-end-date-day"); 
		
		DateStruct datestruct = StringProcessUtil.processYMD(beginyear, beginmonth, beginday, endyear, endmonth, endday);
		
		if (datestruct != null){
			beginDate = datestruct.begindate;
			endDate = datestruct.enddate;
			session.setAttribute("beginDate", beginDate);
			session.setAttribute("endDate", endDate);
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
		
		
	}
	catch(Exception e){
		//
		
	}
	if (islogin==null || islogin.equals("0")) {
		System.out.println("is login null");
		response.sendRedirect("login.jsp");
	}
	else {
		
		username = (String)session.getAttribute("username");
		password = (String)session.getAttribute("password");
		location = (String)session.getAttribute("location");
		
		//URLDecoder
		location = URLDecoder.decode(location, "utf-8");

		Date d = new Date();	//今日日期获取
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
			
			lastDate = conn.getLastDate().trim();
			
			session.setAttribute("lastDate", lastDate);
			
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
			
			
			adminResultvector.clear();
			conn.fillAdminResult(adminResultvector, beginDate, endDate);
			System.out.println("size : " + adminResultvector.size());
			conn.closeStatement();
		}
		
		for (AdminResult ar : adminResultvector){
			Collections.sort(ar.resultvector);//按机床号排序
		}
		
		
		//Collections.sort(adminResultvector);		//按机床名排序
		//System.out.println("begin date :" + beginDate + " end date :" + endDate);
		
		
		
	} 
%>
	 <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                
                
                <div class="row">
                	<div class="col-lg-12">
                    	<p style="font-size: 25px">今日日期：<%=todayDate %></p>
                    
                	</div>
                <!-- /.col-lg-12 -->
           		 </div>

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
                        	<a href="adminForm_generate.jsp?para=<%=username  %>"><i class="fa fa-tasks fa-fw"></i>报表生成</a>
                        </li>
                        <li></li>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>

        <div id="page-wrapper">
            <canvas width="10px" height="10px"></canvas>
            <!-- /.row -->
            <div class="row">
            	<div class="col-md-8">
            		<div class="panel panel-default">
            			<div class="panel-heading text-center">
            				请选择要查看的日期区间
            			</div>
            			<div class="panel-body"  >
            				<div class="row">
	            				<form action="adminIndex.jsp" method="post" onsubmit="disable_searchbtn();">
	            					<div class="row">
		            					<div class = "form-group col-md-3" >
			            					<label>开始日期</label>
			            					<label>年：</label>
			            					<select class="form-control" name="index-begin-date-year">
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
			                               <select class="form-control" name="index-begin-date-month">
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
			                               <select class="form-control" name="index-begin-date-day">
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
			            					<select class="form-control" name="index-end-date-year">
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
			            					<select class="form-control" name="index-end-date-month">
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
			            					<select class="form-control" name="index-end-date-day">
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
			                        	<div class="col-md-3">
		            						<canvas width="15px" height="15px"></canvas>
			            					<input id="search-btn" type="submit" class="btn btn-success btn-lg btn-block" value="搜索">				
		            					</div>
			                        </div>
			                       	
			                        	
	            				</form>
	            				
            				</div>
            			</div>
            		</div>
            	</div>
            	
            	<div class="col-lg-4">
					<div class="panel panel-default" >
						<div class="panel-heading text-center">
							图例
						</div>
			  			<div class="panel-body"  >
			  				<div class="row" id="legend-pie">
			  				</div>
			  			</div>
					</div>
				</div>
            </div>
            
            <div class="row">
            	
            	
            </div>
            <div class="row">
            	<%
            	for (AdminResult ar : adminResultvector){
            		%>
            		<div class="col-md-12">
            			<div class="panel panel-default">
            				<div class="panel-heading" style="font-size: 25px">
            					<%=ar.company %>
            				</div>
            				<div class="panel-body">
            					<%
            					if (ar.resultvector.size() == 0){
            	            		%>
            	            		<h1><%=ar.company %>在此时间区间内暂无数据！</h1>
            	            		<%
            	            	}
            					for (result res : ar.resultvector){
            	            		%>
            	            		<div class="col-md-1">
            	            			<div class="panel panel-default">
            	            				<div class="panel-heading" style="font-size: 15px">
            	            					<%=  res.sid  %>
            	            				</div>
            	            				
            	            				<div class="panel-body">
            	            					<div class="row">
            	            						
            		            					<div class="flot-chart" style="width:100px;height:100px;">
            		            						<div class="flot-chart-content" id=<%="\"" + res.id + "\"" %> >
            									            							
            									        </div>
            		            					</div>
            	            					</div> 
            	            					<div class="row">
            	            						<p>总数：<%=res.run_no %></p>
            	            					</div>
            	            					<div class="row">
            	            						<form action="adminResult.jsp" method="post" name="result">
            	            							<input type="hidden" name="result" value="<%=URLEncoder.encode(res.sid) %>">
            	            							<input type="submit" class="btn btn-outline btn-info btn-lg btn-block" value="查看详情">
            	            						</form>
            	            					</div>
            	            					
            	            				</div>
            	            			
            	            			</div>
            	            		</div>
            	            		
            	            		
            	            		<%
            	            	}
            	            	
            	            	%>
            				</div>
            			</div>
            		</div>
            		
            		<%
            	}
            	%>
            	
            	
            </div>
		</div>
			<div class="copyrights">Collect from <a href="http://www.cssmoban.com/"  title="网站模板">网站模板</a></div>
	</div>
            <!-- /.row -->


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
    
    <!-- 页面加载完成后执行 -->
    
    
    
    <script type="text/javascript">
	<%
	for (AdminResult ar : adminResultvector){
		for(result res : ar.resultvector){
			%>
			
			$(function() {

			    var data = [
			    	{
			    		label:"超时数据/超范围数据",
			    		data: <%=res.span_no + res.outrange_no %>
			    	},
			    	
			    	{
			    		label:"",
			    		data: 0
			    	},
			    	 {
			        label: "告警数",
			        data: <%=res.alarm_no %>
			    },{ 
			        label: "正常数据",
			        data: <%=res.run_no - res.alarm_no - res.span_no %>
			    }];

			    var el = document.getElementById('<%=res.id %>')
			    var plotObj = $.plot($(el), data, {
			        series: {
			            pie: {
			                show: true
			            }
			        },
			        legend:{
			        	show: true,
			        	position: "sw",
			        	container:$("#legend-pie"),
			        	labelFormatter:
			        		function (label,
			        		 series) {
			        		  return '<oo '  + 'style = "font-size: 15px;"' + '" title="' + series.label + '">' + series.label + '</oo>';
			        		}
			        },
			        grid: {
			            hoverable: true
			        },
			        tooltip: true,
			        tooltipOpts: {
			            content: "%p.0%, %s", // show percentages, rounding to 2 decimal places
			            shifts: {
			                x: 20,
			                y: 0
			            },
			            defaultTheme: false
			        }
			    });
			});
			
			<%
		}
	}
	%>
	
	</script>
	
	<script type="text/javascript">
	disable_searchbtn = function() {
		el = document.getElementById('search-btn')
		el.disabled = true;
		el.value = "正在搜索。。。"
	}
	
	</script>
	
	
</body>
</html>