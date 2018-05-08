package javaClassSrc;
import java.sql.*;
import java.util.*;


public class OracleDBconnect {
	
	Connection connection;
	Statement statement;
	ResultSet rs;
	
	
	String url;
	String username;
	String password;
	
	
	
	public OracleDBconnect() {
		connection = null;
		statement = null;
		rs = null;
		
	}
	public void openConnection(String driver, String url, String userName, String passWord) {
		if (connection == null) {
			try {
				Class.forName(driver).newInstance();
				connection = DriverManager.getConnection(url, userName, passWord);
			} catch (InstantiationException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
			catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
	}
	public void openStatement() {
		if (connection != null) {
			try {
				statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			} catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
	}
	
	public void fillAdminResult(Vector<AdminResult> adminResultvector, String begindate, String enddate) {
		
		String selectCompanyName = "SELECT DISTINCT \"tp\" FROM MACHINEDATA.\"map_table\"";
		Vector<String> companyNameArray = new Vector<String>();
		if (statement == null) {
			return;
		}
		else {
			try {
				rs = statement.executeQuery(selectCompanyName);
				while(rs.next()) {
					String tp = rs.getString("tp");
					companyNameArray.add(tp);
					
				}
				rs.close();
				for(String str : companyNameArray) {
					Vector<result> resultvector = new Vector<result>();
					fillResult(resultvector, str, begindate, enddate);
					adminResultvector.add(new AdminResult(str, resultvector));
				}
			} catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
		
		
		
	}
	
	public void fillResult(Vector<result> resultvector, String location, String begindate, String enddate) {
		
		enddate += " 23:59:59:999";
		
		String sql = "SELECT * FROM MACHINEDATA.GYX_NUMBERINFO,MACHINEDATA.\"map_table\" WHERE (MACHINEDATA.\"map_table\".\"tp\" = \'"
				+ location + "\'" + ") AND (MACHINEDATA.GYX_NUMBERINFO.SID=TRIM(MACHINEDATA.\"map_table\".\"sid\")" + ") AND (TRIM(MACHINEDATA.GYX_NUMBERINFO.TIME) >= \'"
							+ begindate + "\') AND (TRIM(MACHINEDATA.GYX_NUMBERINFO.TIME) <=  \'" + enddate +"\')";
		//System.out.println(sql);
		
		
		
		if (statement != null) {
			try {
				rs = statement.executeQuery(sql);
			} catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
			if(rs != null) {
				try {
					
					resultvector.clear();
					while(rs.next()){
						String sid = rs.getString("SID");
						boolean flag = false;
						for (result r : resultvector){
							if (sid.equalsIgnoreCase(r.sid)){
								String alarm = rs.getString("ALARM_NO");
								String run = rs.getString("RUN_NO");
								String ontime = rs.getString("ONTIME");	//上电时长
								String logintime = rs.getString("RUNTIME");	//运行时长
								String spanno = rs.getString("SPAN_NO");
								String outrangeno = rs.getString("RANGE_NO");
								
								r.alarm_no_v.add(Integer.parseInt(alarm));
								r.run_no_v.add(Integer.parseInt(run));
								r.span_no_v.add(Integer.parseInt(spanno));
								r.outrange_no_v.add(Integer.parseInt(outrangeno));
								r.login_time_v.add(logintime);
								r.on_time_v.add(ontime);
								flag = true;
							}
						}
						if (!flag){
							String alarm = rs.getString("ALARM_NO");
							String run = rs.getString("RUN_NO");
							String ontime = rs.getString("ONTIME");	//上电时长
							String logintime = rs.getString("RUNTIME");	//运行时长
							String spanno = rs.getString("SPAN_NO");
							String outrangeno = rs.getString("RANGE_NO");
							result res = new result(sid,Integer.parseInt(alarm),Integer.parseInt(run),Integer.parseInt(spanno),
									Integer.parseInt(outrangeno),logintime,ontime);
							resultvector.add(res);
						}
						
					}
					for (result r : resultvector){
						r.process_result();
					}
					rs.close();
				} catch (SQLException e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				
			}
		}
	}
	
	public void fillAlarmVector(Vector<alarmInfo> alarmVector, String sid, String begindate, String enddate) {
		
		enddate += " 23:59:59:999";
		
		String sql = "SELECT * FROM MACHINEDATA.\"alarm_table\" WHERE (TRIM(MACHINEDATA.\"alarm_table\".\"sid\") = \'"+
					sid+"\') AND (TRIM(MACHINEDATA.\"alarm_table\".\"recordtime\") BETWEEN \'" + begindate + "\' and \'" 
					+ enddate +"\')";
		//System.out.println(sql);
		if(statement == null) {
			return ;
		}
		try {
			rs = statement.executeQuery(sql);
			alarmVector.clear();
			while(rs.next()){
				String dateTemp, infoTemp, idTemp , confirmor, confirmDate, reson, isreal;
				dateTemp = rs.getString("recordtime");
				infoTemp = rs.getString("ctt");
				idTemp = rs.getString("id");
				confirmor = rs.getString("confirmor");
				confirmDate = rs.getString("comfirmdate");
				reson = rs.getString("result");
				isreal = rs.getString("isreal");
				alarmInfo ai = new alarmInfo(dateTemp, infoTemp, idTemp, confirmor, confirmDate, reson, isreal);
				alarmVector.add(ai);
			}
			//System.out.println(alarmVector.size());
			rs.close();
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
	}
	
	public boolean addUser(String username, String password, String company) {
		String search_username = "SELECT * FROM MACHINEDATA.GYX_USER WHERE MACHINEDATA.GYX_USER.USERID = \'" + 
				username + "\'";
		String sql = "INSERT INTO MACHINEDATA.GYX_USER VALUES(\'" + username + "\',\'" + password + 
					"\',\'" + "0\',\'" + company + "\',\'" + "0\')";
		if (statement == null) {
			return false;
		}
		else {
			try {
				rs = statement.executeQuery(search_username);
				if (rs.next()) {
					return false;
				}
				else {
					statement.execute(sql);
					return true;
				}
				
			} catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
		return false;
	}
	
	public void modifyPassword(String username, String password) {
		String sql = "UPDATE MACHINEDATA.GYX_USER SET PASSWORD = \'" + password + "\' WHERE USERID = \'" +
						username + "\'";
		if (statement == null) {
			return ;
		}
		else {
			try {
				statement.execute(sql);
			} catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
	}
	
	public String getLastDate() {
		String sql = "SELECT * FROM MACHINEDATA.\"GYX_lastday\"";
		if (statement == null) {
			return "";
		}
		try {
			rs = statement.executeQuery(sql);
			rs.next();
			return rs.getString("sDate");
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
		return "";
	}
	
	public void updateAlarmResult(String confirmor, String result_input, String todayDate, String sid, Vector<alarmInfo> alarmVector, int i ) {
		String sql = "UPDATE MACHINEDATA.\"alarm_table\" SET \"confirmor\" = \'" 
				+ confirmor + "\' , \"result\" = \'" + result_input + "\' , \"isreal\" = \'是\', \"comfirmdate\"=\'" 
				+ todayDate + "\' WHERE TRIM(\"sid\") = \'" + sid + "\' AND TRIM(\"recordtime\") = \'" + alarmVector.get(i).date.trim() + "\'";
		if (statement == null) {
			return ;
		}
		try {
			rs = statement.executeQuery(sql);
			//System.out.println(sid + alarmVector.get(i).date.trim() + confirmor);
			rs.close();
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
	}
	
	public void updateCommonResult(String sid, Vector<alarmInfo> alarmVector, String todayDate, String username, int i ) {
		
		
		String sql = "UPDATE MACHINEDATA.\"alarm_table\" SET \"confirmor\" = \'" 
				+ username + "\' , \"result\" = \'" + "" + "\' , \"isreal\" = \'否\', \"comfirmdate\"=\'" 
				+ todayDate + "\' WHERE TRIM(\"sid\") = \'" + sid + "\' AND TRIM(\"recordtime\") = \'" + alarmVector.get(i).date.trim() + "\'";
		if (statement == null) {
			return ;
		}
		try {
			rs = statement.executeQuery(sql);
			
			rs.close();
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
		
	}
	
	public void fillCompanySid(Vector<CompanySidStruct> vcompanysid) {
		String selectCompanyName = "SELECT * FROM MACHINEDATA.\"map_table\"";
		//System.out.println(selectCompanyName);
		Vector<String> companyNameArray = new Vector<String>();
		if (statement == null) {
			return ;
		}
		else {
			try {
				rs = statement.executeQuery(selectCompanyName);
				while (rs.next()) {
					String tp = rs.getString("tp").trim();
					//System.out.println(tp + companyNameArray.contains(tp));
					if (!companyNameArray.contains(tp)) {
						String sid = rs.getString("sid").trim();
						Vector<String> vsid = new Vector<String>();
						vsid.add(sid);
						vcompanysid.add(new CompanySidStruct(tp, vsid));
						companyNameArray.add(tp);
					}
					else {
						String sid = rs.getString("sid").trim();
						int i = companyNameArray.indexOf(tp);
						vcompanysid.get(i).vsid.add(sid);
						//System.out.println("vcompany sid size : " + vcompanysid.get(i).vsid.size());
					}
					
				}
				rs.close();
			}
		 catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
		 	}
		}
	}
	
	public void fillAdminFormResult(Vector<AdminForm_result> adminVresult, String begindate, String enddate) {
		//System.out.println("fill admin form result " + begindate + enddate);
		String selectCompanyName = "SELECT DISTINCT \"tp\" FROM MACHINEDATA.\"map_table\"";
		Vector<String> companyNameArray = new Vector<String>();
		if (statement == null) {
			return;
		}
		else {
			try {
				rs = statement.executeQuery(selectCompanyName);
				while(rs.next()) {
					String tp = rs.getString("tp").trim();
					companyNameArray.add(tp);
					
				}
				rs.close();
				for(String str : companyNameArray) {
					Vector<form_result> vresult = new Vector<form_result>();
					fillFormResult(vresult, str, begindate, enddate);
					adminVresult.add(new AdminForm_result(str, vresult));
					
				}
			} catch (SQLException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
		
		
	}
	
	public void fillFormResult(Vector<form_result> vresult, String location, String begindate, String enddate) {
		String sql = "SELECT * FROM MACHINEDATA.\"map_table\" WHERE TRIM(MACHINEDATA.\"map_table\".\"tp\") = \'"+location.trim()+"\'";
		//System.out.println(sql);
		//总条数表内容
		String run_number = "";
		String alarm_number = "";
		String span_number = "";
		String outrange_number = "";
		
		enddate += " 23:59:59:999";
		
		Statement statement_temp = null;
		
		ResultSet temp_rs = null;
		
		if (statement == null) {
			return ;
		}
		try {
			rs = statement.executeQuery(sql);
			statement_temp = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			if (rs == null) {
				System.out.println("rs is null");
			}
			while (rs.next())
			{
				//报警信息详情表内容
				Vector<String> alarm_time = new Vector<String>();
				Vector<String> alarm_id = new Vector<String>();
				Vector<String> alarm_content = new Vector<String>();
				Vector<String> alarm_isreal = new Vector<String>();
				Vector<String> alarm_confirmor = new Vector<String>();
				Vector<String> alarm_reason = new Vector<String>();
				Vector<String> alarm_confirm_date = new Vector<String>();
				
				//超时详情表内容
				Vector<String> span_time = new Vector<String>();
				Vector<String> span_interval = new Vector<String>();
				
				//超范围详情表内容
				Vector<String> outrange_time = new Vector<String>();
				Vector<String> outrange_signal = new Vector<String>();
				Vector<String> outrange_value = new Vector<String>();
				
				
				
				String sid = rs.getString("sid").trim();
				
				String temp_sql = "SELECT * FROM MACHINEDATA.GYX_NUMBERINFO WHERE (MACHINEDATA.GYX_NUMBERINFO.SID = \'" 
						+ sid + "\') AND (TRIM(MACHINEDATA.GYX_NUMBERINFO.TIME) BETWEEN \'" + begindate + "\' and \'" 
						+ enddate + "\')"; 
				//System.out.println(temp_sql);
				long runnum = 0;
				long alarmnum = 0;
				long spannum = 0;
				long outrangenum = 0;
				if(statement_temp == null) {
					System.out.println("statment temp is null");
				}
				temp_rs = statement_temp.executeQuery(temp_sql);	//查询条数信息表
				while (temp_rs.next()) {
					runnum +=  Long.parseLong(temp_rs.getString("RUN_NO"));
					alarmnum += Long.parseLong(temp_rs.getString("ALARM_NO"));
					spannum += Long.parseLong(temp_rs.getString("SPAN_NO"));
					outrangenum += Long.parseLong(temp_rs.getString("RANGE_NO"));
				}
				run_number = String.valueOf(runnum);
				alarm_number = String.valueOf(alarmnum);
				span_number = String.valueOf(spannum);
				outrange_number = String.valueOf(outrangenum);
				temp_rs.close();
				
				temp_sql = "SELECT * FROM MACHINEDATA.\"alarm_table\" WHERE (TRIM(MACHINEDATA.\"alarm_table\".\"sid\") = \'" 
						+ sid + "\') AND (TRIM(MACHINEDATA.\"alarm_table\".\"recordtime\") BETWEEN \'" 
						+ begindate + "\' and \'" + enddate + "\')" ;
				//System.out.println(temp_sql);
				temp_rs = statement_temp.executeQuery(temp_sql);	//查询报警表
				//int count = 0;
				if (temp_rs == null) {
					System.out.println("temp_rs is null in select alarm table");
				}
				while (temp_rs.next()) {
					//System.out.println(count++);
					alarm_time.add(temp_rs.getString("recordtime").trim());
					//System.out.println("record time over");
					alarm_id.add(temp_rs.getString("id").trim());
					//System.out.println("id  over");
					alarm_content.add(temp_rs.getString("ctt"));
					//System.out.println("ctt over");
					
					String isreal = temp_rs.getString("isreal");
					if (isreal == null) {
						isreal = "";
					}
					alarm_isreal.add(isreal.trim());
					//System.out.println("isreal over");
					
					String comfirmor = temp_rs.getString("confirmor");
					if (comfirmor == null) {
						comfirmor = "";
					}
					
					alarm_confirmor.add(comfirmor.trim());
					//System.out.println("confirmor over");
					
					String result = temp_rs.getString("result");
					if (result == null) {
						result = "";
					}
					
					alarm_reason.add(result.trim());
					//System.out.println("result over");
					
					String comfirmdate = temp_rs.getString("comfirmdate");
					if (comfirmdate == null) {
						comfirmdate = "";
					}
					alarm_confirm_date.add(comfirmdate.trim());
					//System.out.println("comfirmdate over");
				}
				temp_rs.close();
				
				temp_sql = "SELECT * FROM MACHINEDATA.GYX_SPANINFO WHERE (MACHINEDATA.GYX_SPANINFO.SID = \'" 
						+ sid + "\') AND (TRIM(MACHINEDATA.GYX_SPANINFO.TIME) BETWEEN \'" 
						+ begindate + "\' and \'" + enddate + "\')" ;
				//System.out.println(temp_sql);
				temp_rs = statement_temp.executeQuery(temp_sql);	//查询超时表
				while (temp_rs.next()) {
					span_time.add(temp_rs.getString("TIME"));
					span_interval.add(temp_rs.getString("INTERVAL"));
				}
				temp_rs.close();
				
				temp_sql = "SELECT * FROM MACHINEDATA.GYX_OUTRANGEINFO WHERE (MACHINEDATA.GYX_OUTRANGEINFO.SID = \'" 
						+ sid + "\') AND (TRIM(MACHINEDATA.GYX_OUTRANGEINFO.TIME) BETWEEN \'" 
						+ begindate + "\' and \'" + enddate + "\')" ;
				temp_rs = statement_temp.executeQuery(temp_sql);	//查询超范围表
				//System.out.println(temp_sql);
				while (temp_rs.next()) {
					outrange_time.add(temp_rs.getString("TIME"));
					outrange_signal.add(temp_rs.getString("SIGNAL"));
					outrange_value.add(temp_rs.getString("VALUE"));
				}
				temp_rs.close();
				
				
				form_result f = new form_result(sid, run_number, alarm_number, span_number, outrange_number, alarm_time, alarm_id, alarm_content, alarm_isreal, alarm_confirmor, alarm_reason, alarm_confirm_date, span_time, span_interval, outrange_time, outrange_signal, outrange_value, begindate, enddate);
				
				vresult.add(f);
			}
			statement_temp.close();
			rs.close();
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
	}

	public PairIntString checkLogin(String username, String password) {
		String sql = "SELECT * FROM MACHINEDATA.GYX_USER";
		String location = "";
		String grade = "0";
		if (statement == null) {
			return new PairIntString(-1, "");	//数据库未连接或statment未开启
		}
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
		
		try {
			while (rs.next()) {
				String nametemp = rs.getString("USERID");
				if (username.equals(nametemp)) {
					String passwdtemp = rs.getString("PASSWORD");
					if (password.equals(passwdtemp)) {
						location = rs.getString("COMPANY");
						grade = rs.getString("GRADE");
						if (grade.equals("1")) {
							rs.close();
							return new PairIntString(5, location);//5表示管理员登录
						}
						else {
							rs.close();
							return new PairIntString(0, location);//0表示登录成功
						}
						
					}
					else {
						rs.close();
						return new PairIntString(1, location);//1表示密码错误
					}
				}
				else {
					continue;
				}
			}
			
			rs.previous();
			if (!rs.next())
			{
				//用户名不存在
				rs.close();
				return new PairIntString(2, location);//2表示用户名不存在
			}
			
			
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}

		return new PairIntString(-2, location);	//检查出现错误
	}
	
	public void closeStatement() {
		if (statement == null) {
			return;
		}
		try {
			statement.close();
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
		statement = null;
	}
	public void closeConnect() {
		if (connection == null) {
			return;
		}
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
		connection = null;
	}
}
