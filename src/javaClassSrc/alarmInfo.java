package javaClassSrc;

public class alarmInfo implements Comparable<alarmInfo>{
	public String date;
	public String infoContent;
	public String id;
	public boolean is_wrong;
	
	public String confirmor;
	public String confirmDate;
	public String confirmReason;
	
	
	public alarmInfo(String _date, String _info, String _id, String _confirmor, String _confirmDate, String _confirmReason, String _isreal){
		date = _date;
		infoContent = _info;
		id = _id;
		//is_wrong = false;
		confirmor = _confirmor;
		confirmDate = _confirmDate;
		confirmReason = _confirmReason;
		
		if (confirmDate == null) {
			confirmDate = "";
		}
		
		if (confirmor == null) {
			confirmor = "";
		}
		
		
		if (confirmReason == null) {
			confirmReason = "";
		}
		
		if(_isreal == null) {
			is_wrong = false;
		}
		
		else if (_isreal.trim().equals("是")) {
			is_wrong = true;
		}
		else {
			is_wrong = false;
		}
		
	}
	@Override
	public int compareTo(alarmInfo a) {
		return this.date.compareTo(a.date);//按照时间排序
	}
}
