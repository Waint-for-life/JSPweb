package javaClassSrc;

import java.util.Vector;

public class result implements Comparable<result> {

	
	public String sid;
	
	public Vector<Integer> alarm_no_v;
	public Vector<Integer> run_no_v;
	public Vector<Integer> span_no_v;
	public Vector<Integer> outrange_no_v;
	public Vector<String> login_time_v;
	public Vector<String> on_time_v;
	
	
	public int alarm_no;
	public int run_no;
	public int alarm_percent;
	public int span_no;
	public int outrange_no;
	
	public String id;
	public String login_time;
	public String on_time;
	public String tabid;
	public String tabli_id;
	public String a_id;
	public result(String _sid,int _alarm_no,int _run_no,int _span_no,int _outrange_no,String _login_time,String _on_time)
	{
		sid = _sid;
		
		alarm_no_v = new Vector<Integer>();
		run_no_v = new Vector<Integer>();
		span_no_v = new Vector<Integer>();
		outrange_no_v = new Vector<Integer>();
		login_time_v = new Vector<String>();
		on_time_v = new Vector<String>();
		
		
		alarm_no_v.add(_alarm_no);
		run_no_v.add(_run_no);
		login_time_v.add(_login_time);
		on_time_v.add(_on_time);
		span_no_v.add(_span_no);
		outrange_no_v.add(_outrange_no);
		
		
		
		alarm_no = 0;
		run_no = 0;
		outrange_no = 0;
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
			outrange_no += outrange_no_v.get(i);
		}
	}
	
	@Override
	public int compareTo(result r) {
		return this.sid.compareTo(r.sid);//按照机床设备号排序
	}

}
