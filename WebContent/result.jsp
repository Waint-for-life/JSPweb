<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*,java.io.*,java.util.*"%>
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
	<title>结果详情</title>
</head>
<body>

	<%!
	String loginStr = "0";
	String backString = "";
	int loginFlag = 0;
	String username = "";
	String password = "";
	String location = "";
	String sid = "";
	Vector<alarmInfo> alarmVector = new Vector<alarmInfo>();
	class alarmInfo{
		String date;
		String infoContent;
		public alarmInfo(String _date,String _info){
			date = _date;
			infoContent = _info;
		}
	}
	%>
	
	<%
	try {
		request.setCharacterEncoding("utf-8");
		loginStr = request.getParameter("loginStr");
		
		//System.out.println(loginStr);
	}
	catch(Exception e){
		//
		
	}
	if (loginStr==null) {
		String loginstr = "1 chen 110120 北京机床厂 bj002 ";
		
		response.sendRedirect("result.jsp?loginStr=" + URLEncoder.encode(loginstr,"utf-8"));
	}
	else {
		
		String[] loginInfo = loginStr.split(" ");
		//System.out.println(loginInfo.length);
		loginFlag = Integer.parseInt(loginInfo[0]);
		username = loginInfo[1];
		password = loginInfo[2];
		location = loginInfo[3];
		try{
			sid = loginInfo[4];
			System.out.println(sid);
		}
		catch (Exception e){
			
		}
		
		backString = "1 " + username + " " + password + " " + location + " " ; 
		loginStr += " ";
		//数据库链接
		Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
		
		String url = "jdbc:oracle:thin:@localhost:1521:orcl";
		
		String userName = "CHEN";
		String passWord = "110120";
		
		Connection connection = DriverManager.getConnection(url, userName, passWord);
		
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		
		String sql = "SELECT * FROM ALARMTABLE WHERE ALARMTABLE.SID = \'"+sid+"\'";
		System.out.println(sql);
		ResultSet rs = statement.executeQuery(sql);
		alarmVector.clear();
		while(rs.next()){
			String dateTemp, infoTemp;
			dateTemp = rs.getString(1);
			infoTemp = rs.getString(4);
			alarmInfo ai = new alarmInfo(dateTemp,infoTemp);
			alarmVector.add(ai);
		}
		
		rs.close();
		statement.close();
		connection.close();
	} 
	%>

	<div id="wrapper">
		<!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="modeltest.jsp?loginStr=<%=loginStr %>" title="回到主页">主页</a>
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
                        <li><a href="#"><i class="fa fa-user fa-fw"></i><%=location %> </a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="login.jsp"><i class="fa fa-sign-out fa-fw"></i> 登出 </a>
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
                            <a href="#l"><i class="fa fa-line-chart fa-fw"></i> 历史信息</a>
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
        			<a href="index.jsp?loginStr=<%=URLEncoder.encode(backString,"utf-8")%> ">
        				
        				<button type="button" class="btn btn-outline btn-danger btn-lg btn-block">返回主页</button>
        			</a>
        		</div>
        	</div>
        	<div class="row">
        		<div class="col-lg-12">
        			<div class="panel panel-default">
        				<div class="panel-heading">
        					<%= "设备号：" + sid %>
        				</div>
        				<div class="panel-body">
        					<div class="table-responsive">
        						<table class="table table-hover">
        						<thead>
        							<tr>
        								<th>序号</th>
        								<th>日期/时间</th>
        								<th>报警内容</th>
        							</tr>
        						</thead>
        						<tbody>
        							<%
        							for(alarmInfo ai : alarmVector){
        								%>
        								<tr class="danger">
        									<th><%=alarmVector.indexOf(ai) %></th>
        									<th><%=ai.date %></th>
        									<th><%=ai.infoContent %></th>
        								</tr>
        								<% 
        							}
        							%>
        						</tbody>
        						</table>
        					</div>
        				</div>
        			</div>
        		</div>
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
</body>

	
    
    
</html>