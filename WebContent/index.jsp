<%@page import="java.net.URLEncoder"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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

    <title>数控系统稳定性实验</title>

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
    
    
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<%!
	class result{
		String sid;
		
		Vector<Integer> alarm_no_v;
		Vector<Integer> run_no_v;
		Vector<Integer> span_no_v;
		Vector<String> login_time_v;
		Vector<String> on_time_v;
		
		
		int alarm_no;
		int run_no;
		int alarm_percent;
		int span_no;
		String id;
		String login_time;
		String on_time;
		String tabid;
		String tabli_id;
		String a_id;
		public result(String _sid,int _alarm_no,int _run_no,int _span_no,String _login_time,String _on_time)
		{
			sid = _sid;
			
			alarm_no_v = new Vector<Integer>();
			run_no_v = new Vector<Integer>();
			span_no_v = new Vector<Integer>();
			login_time_v = new Vector<String>();
			on_time_v = new Vector<String>();
			
			alarm_no_v.add(_alarm_no);
			run_no_v.add(_run_no);
			login_time_v.add(_login_time);
			on_time_v.add(_on_time);
			span_no_v.add(_span_no);
			
			
			
			alarm_no = 0;
			run_no = 0;
			double temp = 0.;
			alarm_percent = (int) (temp * 100);
			id = sid + "-flot-pie-chart";
			tabid = sid + "-pilltab";
			tabli_id = sid + "-litab";
			a_id = sid + "-a";
			login_time = _login_time;
			on_time = _on_time;
			span_no = 0;
		}
		public void process_result(){
			for (int i = 0 ; i < alarm_no_v.size(); i++){
				alarm_no += alarm_no_v.get(i);
				run_no += run_no_v.get(i);
				span_no += span_no_v.get(i);
			}
		}
	}
	final int numPerTab = 10;
	String forTransString = "";
%>
<% 
	int tab_index = 0;//标签页（panel）的总数
	int remain_index = 0;//10整除余下的标签页
	
	String loginStr = "0";
	int loginFlag = 0;
	String username = "";
	String password = "";
	String location = "";
	String todayDate = "";
	Vector<result> resultvector = new Vector<result>();
	
	try {
		request.setCharacterEncoding("utf-8");
		loginStr = request.getParameter("loginStr");
		
		//System.out.println(loginStr);
	}
	catch(Exception e){
		//
		
	}
	if (loginStr==null) {
		String loginstr = "1 chen 110120 北京机床厂 ";
		forTransString = loginstr;
		response.sendRedirect("index.jsp?loginStr=" + URLEncoder.encode(loginstr,"utf-8"));
	}
	else {
		forTransString = loginStr;
		String[] loginInfo = loginStr.split(" ");
		//System.out.println(loginInfo.length);
		loginFlag = Integer.parseInt(loginInfo[0]);
		username = loginInfo[1];
		password = loginInfo[2];
		location = loginInfo[3];
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		todayDate = sdf.format(d);
		
		//数据库链接
		Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
		
		String url = "jdbc:oracle:thin:@localhost:1521:orcl";
		
		String userName = "CHEN";
		String passWord = "110120";
		
		Connection connection = DriverManager.getConnection(url, userName, passWord);
		
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		
		String sql = "SELECT * FROM INFONUMBER,DEVICETABLE WHERE INFONUMBER.SID = DEVICETABLE.SID AND DEVICETABLE.USERNAME=\'"+username+"\'";
		System.out.println(sql);
		ResultSet rs = statement.executeQuery(sql);
		/* System.out.println(rs.getMetaData().getColumnCount());
		rs.last();
		System.out.println(rs.getRow());
		rs.first();
		System.out.println(rs.getString(1));
		System.out.println(rs.getString(2));
		System.out.println(rs.getString(3));
		rs.next();
		System.out.println(rs.getString(1));
		System.out.println(rs.getString(2));
		System.out.println(rs.getString(3));  */
		while(rs.next()){
			String sid = rs.getString(2);
			boolean flag = false;
			for (result r : resultvector){
				if (sid.equalsIgnoreCase(r.sid)){
					String alarm = rs.getString(5);
					String run = rs.getString(8);
					String ontime = rs.getString(4);
					String logintime = rs.getString(3);
					String spanno = rs.getString(7);
					
					r.alarm_no_v.add(Integer.parseInt(alarm));
					r.run_no_v.add(Integer.parseInt(run));
					r.span_no_v.add(Integer.parseInt(spanno));
					r.login_time_v.add(logintime);
					r.on_time_v.add(ontime);
					flag = true;
				}
			}
			if (!flag){
				String alarm = rs.getString(5);
				String run = rs.getString(8);
				String ontime = rs.getString(4);
				String logintime = rs.getString(3);
				String spanno = rs.getString(7);
				result res = new result(sid,Integer.parseInt(alarm),Integer.parseInt(run),Integer.parseInt(spanno),
						logintime,ontime);
				resultvector.add(res);
			}
			
		}
		for (result r : resultvector){
			r.process_result();
		}
		rs.close();
		statement.close();
		connection.close();
		
		System.out.println(resultvector.size());
		remain_index = resultvector.size() % numPerTab;
		if(remain_index == 0) {
			tab_index = resultvector.size()/numPerTab;
			remain_index = numPerTab;
		}
		else {
			tab_index = resultvector.size()/numPerTab +1;
		}
		/* System.out.println(tab_index);
		System.out.println(remain_index); */
		
		
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
                    <h1 class="page-header">功能导航</h1>
                    <h2 >今日日期：<%=todayDate %></h2>
                    <p>只显示昨日信息，更多信息请参见历史数据！</p>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-eye fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    
                                    <div class="huge">历史数据</div>
                                </div>
                            </div>
                        </div>
                        <a href="#">
                            <div class="panel-footer">
                                <span class="pull-left">点击此处查看历史数据！</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-green">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-tasks fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    
                                    <div class="huge">预留</div>
                                </div>
                            </div>
                        </div>
                        <a href="#">
                            <div class="panel-footer">
                                <span class="pull-left">点击此处查看信息总数！</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-yellow">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-bell fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    
                                    <div class="huge">预留</div>
                                </div>
                            </div>
                        </div>
                        <a href="#">
                            <div class="panel-footer">
                                <span class="pull-left">点击此处查看间隔节点！</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-sign-out fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    
                                    <div class="huge">登出</div>
                                </div>
                            </div>
                        </div>
                        <a href="login.jsp">
                            <div class="panel-footer">
                                <span class="pull-left">点击此处登出账号！</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="row">
            	<%
            	for (result res : resultvector){
            		%>
            		<div class="col-lg-3">
            			<div class="panel panel-default">
            				<div class="panel-heading">
            					<%= "设备号:" + res.sid %>
            				</div>
            				<div class="panel-body">
            					<div class="row">
	            					<div class="flot-chart">
	            						<div class="flot-chart-content" id=<%="\"" + res.id + "\"" %>>
								            							
								        </div>
	            					</div>
            					</div> 
            					<div class="row">
            						<a href=<%="\"" + "result.jsp?loginStr=" + forTransString + res.sid +" " + " \"" %>>
						            	<button type="button" class="btn btn-outline btn-info btn-lg btn-block">查看详情</button>
						            </a>
            					</div>
            					
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
    
    <script type="text/javascript" >
    	<%-- window.onload = function virtual_click () {
    		<%
    		if (resultvector.size() <= 1)
    		{
    			
    		}
    		else {
    			for (int i = 0; i < tab_index; i++){
        			%>
        			//var log = console.log.bind(console)
        			<%
        			if ((i * numPerTab + 1) > (resultvector.size() - 1) ){
        				
        			}
        			else {
        				%>
        				 var d = document.getElementById(<%="\"" + resultvector.get(i * numPerTab + 1).a_id + "\"" %>)
                		//log(d)
                		d.click()
        				d = document.getElementById(<%="\"" + resultvector.get(i * numPerTab ).a_id + "\"" %>)
        				d.click() 
        			<%	
        			}
        		}
    		}
    		
    		%>
    		
		} --%>
    	
    </script>
    
    
    
    <script type="text/javascript">
	<%
		for(result res : resultvector){
			%>
			
			$(function() {

			    var data = [
			    	{
			    		label:"超时数据",
			    		data: <%=res.span_no %>
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
			        data: <%=res.run_no - res.alarm_no %>
			    }];

			    var plotObj = $.plot($(<%="\"#" + res.id + "\"" %>), data, {
			        series: {
			            pie: {
			                show: true
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
	%>
	
	</script>
    
    
    

</body>
</html>