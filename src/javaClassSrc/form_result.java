package javaClassSrc;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Vector;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

import com.sun.xml.internal.ws.policy.privateutil.PolicyUtils.Collections;

public class form_result {
	public String sid;
	public boolean generate_file;
	
	String begindate;
	String enddate;
	
	//总条数表内容
	public String run_number;
	public String alarm_number;
	public String span_number;
	public String outrange_number;
	
	//报警信息详情表内容
	public Vector<String> alarm_time;
	public Vector<String> alarm_id;
	public Vector<String> alarm_content;
	public Vector<String> alarm_isreal;
	public Vector<String> alarm_confirmor;
	public Vector<String> alarm_reason;
	public Vector<String> alarm_confirm_date;
	
	//超时详情表内容
	public Vector<String> span_time;
	public Vector<String> span_interval;
	
	//超范围详情表内容
	public Vector<String> outrange_time;
	public Vector<String> outrange_signal;
	public Vector<String> outrange_value;
	
	
	public form_result(String _sid, String _run_number, String _alarm_number, String _span_number, String _outrange_number,
			Vector<String> _alarm_time, Vector<String> _alarm_id, Vector<String> _alarm_content, Vector<String> _alarm_isreal, Vector<String> _alarm_confirmor, 
			Vector<String> _alarm_reason, Vector<String> _alarm_confirm_date, Vector<String> _span_time, Vector<String> _span_interval, Vector<String> _outrange_time,
			Vector<String> _outrange_signal, Vector<String> _outrange_value, String _begindate, String _enddate)
	{
		sid = _sid;
		generate_file = false;
		
		run_number = _run_number;
		alarm_number = _alarm_number;
		span_number = _span_number;
		outrange_number = _outrange_number;
		
		alarm_time = _alarm_time;
		alarm_id = _alarm_id;
		alarm_content = _alarm_content;
		alarm_isreal = _alarm_isreal;
		alarm_confirmor = _alarm_confirmor;
		alarm_reason = _alarm_reason;
		alarm_confirm_date = _alarm_confirm_date;
		
		span_time = _span_time;
		span_interval = _span_interval;
		
		outrange_time = _outrange_time;
		outrange_signal = _outrange_signal;
		outrange_value = _outrange_value;
		

		
		begindate = _begindate;
		enddate = _enddate;
		
	}
	
	@SuppressWarnings("deprecation")
	public void generateExcel(Vector<File> vfile, String fileDir) {
		if (generate_file) {
			
			HSSFWorkbook wb = new HSSFWorkbook();  
			
			
			//设置样式
	        HSSFCellStyle cellStyle_title = wb.createCellStyle(); // 样式对象    
	        cellStyle_title.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直    
	        cellStyle_title.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 水平    
	      //  cellStyle_title.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框    
	      //  cellStyle_title.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框    
	      //  cellStyle_title.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框    
	      //  cellStyle_title.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框    
	        HSSFFont font = wb.createFont();//设置字体
	        font.setFontName("Arial");    
	        font.setFontHeightInPoints((short) 20);//设置字体大小  
	        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//加粗 
	        cellStyle_title.setFont(font);
	        
	      //设置样式
	        HSSFCellStyle cellStyle_content = wb.createCellStyle(); // 样式对象    
	        cellStyle_content.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直    
	        cellStyle_content.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 水平    
	        //cellStyle_content.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框    
	        //cellStyle_content.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框    
	       // cellStyle_content.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框    
	       // cellStyle_content.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框    
	        HSSFFont font1 = wb.createFont();//设置字体
	        font1.setFontName("Arial");    
	        font1.setFontHeightInPoints((short) 10);//设置字体大小  
	        //font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);//加粗 
	        cellStyle_content.setFont(font);
			
			
			int indexRow = 0;
			//创建HSSFWorkbook对象  
        	
        	//创建HSSFSheet对象  
        	HSSFSheet sheet = wb.createSheet("sheet0");  
        	//创建HSSFRow对象  
        	HSSFRow row0 = sheet.createRow(indexRow);  
        	row0.setHeight((short)600);
        	//创建HSSFCell对象  
        	HSSFCell cell0_0 = row0.createCell(0);  
        	
        	cell0_0.setCellStyle(cellStyle_title);
        	//CellRangeAddress cRangeAddress = new CellRangeAddress(0, 0, 0, 5);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 9));	//first row last row first col last col
        	
        	//设置单元格的值  
        	cell0_0.setCellValue("日期：" + begindate + " 至  " + enddate);  
        	
        	HSSFCell cell_sid = row0.createCell(10);  
        	cell_sid.setCellStyle(cellStyle_title);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 10, 15));
        	cell_sid.setCellValue("机床号：" + sid);
        	
        	indexRow ++;
        	
        	HSSFRow row1 = sheet.createRow(indexRow);
        	row1.setHeight((short) 600);
        	HSSFCell cell1_0 = row1.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 7));
        	cell1_0.setCellStyle(cellStyle_title);
        	cell1_0.setCellValue("总条数表");
        	
        	indexRow ++;
        	
        	
        	HSSFRow row2 = sheet.createRow(indexRow);
        	row2.setHeight((short) 600);
        	HSSFCell cell2_0 = row2.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 1));
        	cell2_0.setCellStyle(cellStyle_content);
        	cell2_0.setCellValue("运行条数");
        	
        	
        	HSSFCell cell2_2 = row2.createCell(2);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 2, 3));
        	cell2_2.setCellStyle(cellStyle_content);
        	cell2_2.setCellValue("报警总数");
        	
        	HSSFCell cell2_4 = row2.createCell(4);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 4, 5));
        	cell2_4.setCellStyle(cellStyle_content);
        	cell2_4.setCellValue("超时总数");
        	
        	HSSFCell cell2_6 = row2.createCell(6);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 7));
        	cell2_6.setCellStyle(cellStyle_content);
        	cell2_6.setCellValue("超范围总数");
        	
        	indexRow ++;
        	
        	HSSFRow row3 = sheet.createRow(indexRow);
        	row3.setHeight((short) 600);
        	HSSFCell cell3_0 = row3.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 1));
        	cell3_0.setCellStyle(cellStyle_content);
        	cell3_0.setCellValue(run_number);
        	
        	HSSFCell cell3_2 = row3.createCell(2);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 2, 3));
        	cell3_2.setCellStyle(cellStyle_content);
        	cell3_2.setCellValue(alarm_number);
        	
        	HSSFCell cell3_4 = row3.createCell(4);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 4, 5));
        	cell3_4.setCellStyle(cellStyle_content);
        	cell3_4.setCellValue(span_number);
        	
        	HSSFCell cell3_6 = row3.createCell(6);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 7));
        	cell3_6.setCellStyle(cellStyle_content);
        	cell3_6.setCellValue(outrange_number);
        	
        	indexRow ++;
        	//上部分代码为总条数表全部，下方为报表详情表
        	
        	//row index = 4 此时行号为4
        	
        	indexRow ++;
        	indexRow ++;//空两行
        	
        	HSSFRow row6 = sheet.createRow(indexRow);
        	row6.setHeight((short) 600);
        	HSSFCell cell6_0 = row6.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 28));
        	cell6_0.setCellStyle(cellStyle_title);
        	cell6_0.setCellValue("报警信息详情表");
        	indexRow ++;
        	
        	HSSFRow row7 = sheet.createRow(indexRow);
        	HSSFCell cell7_0 = row7.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 5));
        	cell7_0.setCellStyle(cellStyle_content);
        	cell7_0.setCellValue("报警时间");
        	
        	HSSFCell cell7_2 = row7.createCell(6);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 7));
        	cell7_2.setCellStyle(cellStyle_content);
        	cell7_2.setCellValue("报警ID");
        	
        	HSSFCell cell7_4 = row7.createCell(8);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 8, 13));
        	cell7_4.setCellStyle(cellStyle_content);
        	cell7_4.setCellValue("报警内容");
        	
        	HSSFCell cell7_6 = row7.createCell(14);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 14, 15));
        	cell7_6.setCellStyle(cellStyle_content);
        	cell7_6.setCellValue("是否故障");
        	
        	HSSFCell cell7_8 = row7.createCell(16);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 16, 19));
        	cell7_8.setCellStyle(cellStyle_content);
        	cell7_8.setCellValue("确认人");
        	
        	HSSFCell cell7_10 = row7.createCell(20);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 20, 25));
        	cell7_10.setCellStyle(cellStyle_content);
        	cell7_10.setCellValue("确认理由");
        	
        	HSSFCell cell7_12 = row7.createCell(26);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 26, 28));
        	cell7_12.setCellStyle(cellStyle_content);
        	cell7_12.setCellValue("确认时间");
        	indexRow ++;
        	
        	for(int i = 0 ; i < alarm_time.size(); i++) {
        		HSSFRow row = sheet.createRow(indexRow);
        		row.setHeight((short) 600);
        		
        		
            	HSSFCell cell0 = row.createCell(0);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 5));
            	cell0.setCellStyle(cellStyle_content);
            	cell0.setCellValue(alarm_time.get(i));
            	
            	HSSFCell cell2 = row.createCell(6);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 7));
            	cell2.setCellStyle(cellStyle_content);
            	cell2.setCellValue(alarm_id.get(i));
            	
            	HSSFCell cell4 = row.createCell(8);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 8, 13));
            	cell4.setCellStyle(cellStyle_content);
            	cell4.setCellValue(alarm_content.get(i));
            	
            	HSSFCell cell6 = row.createCell(14);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 14, 15));
            	cell6.setCellStyle(cellStyle_content);
            	cell6.setCellValue(alarm_isreal.get(i));
            	
            	HSSFCell cell8 = row.createCell(16);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 16, 19));
            	cell8.setCellStyle(cellStyle_content);
            	cell8.setCellValue(alarm_confirmor.get(i));
            	
            	HSSFCell cell10 = row.createCell(20);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 20, 25));
            	cell10.setCellStyle(cellStyle_content);
            	cell10.setCellValue(alarm_reason.get(i));
            	
            	HSSFCell cell12 = row.createCell(26);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 26, 28));
            	cell12.setCellStyle(cellStyle_content);
            	cell12.setCellValue(alarm_confirm_date.get(i));
            	
            	indexRow ++;
        	}
        	
        	//报警详情结束。
        	//空两行开始span超时详情
        	
        	indexRow++;
        	indexRow++;
        	
        	
        	HSSFRow row8 = sheet.createRow(indexRow);
        	row8.setHeight((short) 600);
        	HSSFCell cell8_0 = row8.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 9));
        	cell8_0.setCellStyle(cellStyle_title);
        	cell8_0.setCellValue("超时信息详情表");
        	indexRow ++;
        	
        	HSSFRow row9 = sheet.createRow(indexRow);
        	HSSFCell cell9_0 = row9.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 5));
        	cell9_0.setCellStyle(cellStyle_content);
        	cell9_0.setCellValue("超时发生时间");
        	
        	HSSFCell cell9_6 = row9.createCell(6);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 9));
        	cell9_6.setCellStyle(cellStyle_content);
        	cell9_6.setCellValue("超时间隔");
        	
        	indexRow++;
        	
        	for(int i = 0 ; i < span_time.size(); i++) {
        		
        		HSSFRow row = sheet.createRow(indexRow);
        		row.setHeight((short) 600);
            	HSSFCell cell0 = row.createCell(0);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 5));
            	cell0.setCellStyle(cellStyle_title);
            	cell0.setCellValue(span_time.get(i));
            	
            	HSSFCell cell6 = row.createCell(6);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 9));
            	cell6.setCellStyle(cellStyle_title);
            	cell6.setCellValue(span_interval.get(i));
            	
            	indexRow ++;
        	}
        	
        	//span 结束，空两行开始outrange
        	
        	indexRow++;
        	indexRow++;
        	
        	HSSFRow row10 = sheet.createRow(indexRow);
        	row10.setHeight((short) 600);
        	HSSFCell cell10_0 = row10.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 13));
        	cell10_0.setCellStyle(cellStyle_title);
        	cell10_0.setCellValue("超范围信息详情表");
        	indexRow ++;
        	
        	HSSFRow row11 = sheet.createRow(indexRow);
        	HSSFCell cell11_0 = row11.createCell(0);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 5));
        	cell11_0.setCellStyle(cellStyle_content);
        	cell11_0.setCellValue("超范围发生时间");
        	
        	HSSFCell cell11_6 = row11.createCell(6);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 9));
        	cell11_6.setCellStyle(cellStyle_content);
        	cell11_6.setCellValue("超范围信号");
        	
        	HSSFCell cell11_10 = row11.createCell(10);
        	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 10, 13));
        	cell11_10.setCellStyle(cellStyle_content);
        	cell11_10.setCellValue("超范围值");
        	
        	indexRow++;
        	
        	for(int i = 0 ; i < outrange_time.size(); i ++) {
        		HSSFRow row = sheet.createRow(indexRow);
        		row.setHeight((short) 600);
            	HSSFCell cell0 = row.createCell(0);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 0, 5));
            	cell0.setCellStyle(cellStyle_title);
            	cell0.setCellValue(outrange_time.get(i));
            	
            	HSSFCell cell6 = row.createCell(6);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 6, 9));
            	cell6.setCellStyle(cellStyle_title);
            	cell6.setCellValue(outrange_signal.get(i));
            	
            	HSSFCell cell10 = row.createCell(10);
            	sheet.addMergedRegion(new CellRangeAddress(indexRow, indexRow, 10, 13));
            	cell10.setCellStyle(cellStyle_title);
            	cell10.setCellValue(outrange_value.get(i));
            	
            	indexRow ++;
        	}
        	
        	//输出Excel文件  
        	String filepath = fileDir + sid + ".xls";
        	//String filepath = "C:\\Tomcat7\\webapps\\tomcatTest\\WebContent\\outputsheet\\" + f.sid + ".xls";
        	FileOutputStream output;
			try {
				output = new FileOutputStream(filepath);
				wb.write(output);  
	        	output.flush();  
	        	output.close();
	        	File file = new File(filepath);
	        	vfile.add(file);
			} catch (IOException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}  
        	
			try {
				wb.close();
			} catch (IOException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
        	
        	
		}
	}
	
	
}
