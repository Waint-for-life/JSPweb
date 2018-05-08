package javaClassSrc;

public class DateStruct {
	public String firstdate;
	public String lastdate;
	public String begindate;
	public String enddate;
	
	public String firstyear;
	public String firstmonth;
	public String firstday;
	
	public String lastyear;
	public String lastmonth;
	public String lastday;
	
	public String beginyear;
	public String beginmonth;
	public String beginday;
	
	public String endyear;
	public String endmonth;
	public String endday;
	
	public DateStruct(String _firstdate, String _lastdate, String _begindate, String _enddate) {
		firstdate = _firstdate;
		lastdate = _lastdate;
		begindate = _begindate;
		enddate = _enddate;
		
		if(firstdate == null) {
			firstyear = null;
			firstmonth = null;
			firstday = null;
			
			lastyear = null;
			lastmonth = null;
			lastday = null;
			
			beginyear = null;
			beginmonth = null;
			beginday = null;
			
			endyear = null;
			endmonth = null;
			endday = null;
			
		}
		else {
			String[] temp = firstdate.split("-");
			firstyear = temp[0];
			firstmonth = temp[1];
			firstday = temp[2];
			
			temp = lastdate.split("-");
			lastyear = temp[0];
			lastmonth = temp[1];
			lastday = temp[2];
			
			temp = begindate.split("-");
			beginyear = temp[0];
			beginmonth = temp[1];
			beginday = temp[2];
			
			temp = enddate.split("-");
			endyear = temp[0];
			endmonth = temp[1];
			endday = temp[2];
			
			
			if (Integer.parseInt(beginmonth) < 10 && beginmonth.length() == 1){
				beginmonth = "0" + beginmonth;
			}
			if (Integer.parseInt(beginday) < 10 && beginday.length() == 1){
				beginday = "0" + beginday;
			}
			if (Integer.parseInt(endmonth) < 10 && endmonth.length() == 1){
				endmonth = "0" + endmonth;
			}
			if (Integer.parseInt(endday) < 10 && endday.length() == 1){
				endday = "0" + endday;
			}
			
		}
		
		
		
	}
	
	
}
