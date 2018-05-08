package javaClassSrc;

import java.util.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class StringProcessUtil {
	public static DateStruct processDateString(String lastdate, String begindate, String enddate) {
		String firstdate;
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		if(lastdate == null) {
			return new DateStruct("0000-00-00","0000-00-00","0000-00-00","0000-00-00");
		}
		else if (begindate == null && enddate == null) {
			enddate = lastdate;
			
			try {
				Date lastDate_date = format.parse(lastdate);
				firstdate = format.format(new Date(lastDate_date.getTime() - 365 * 2 * 24 * 60 * 60 * 1000L));
				Date enddate_date = format.parse(enddate);
				begindate = format.format(new Date(enddate_date.getTime() - 7 * 24 * 60 * 60 * 1000L));
				return new DateStruct(firstdate, lastdate, begindate, enddate);
			} catch (ParseException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
		else {
			Date lastDate_date;
			try {
				lastDate_date = format.parse(lastdate);
				firstdate = format.format(new Date(lastDate_date.getTime() - 365 * 2 * 24 * 60 * 60 * 1000L));
				return new DateStruct(firstdate, lastdate, begindate, enddate);
			} catch (ParseException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
			
			
		}
		return new DateStruct("0000-00-00", "0000-00-00", "0000-00-00", "0000-00-00");
	}
	
	public static DateStruct processYMD(String beginyear, String beginmonth, String beginday, String endyear,
							String endmonth, String endday) {
		if(beginyear == null) {
			return null;
		}
		else {
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
			String beginDate = beginyear + "-" + beginmonth + "-" + beginday;
			String endDate = endyear + "-" + endmonth + "-" + endday;
			return new DateStruct(beginDate, endDate, beginDate, endDate);
		}
	}
	
}
