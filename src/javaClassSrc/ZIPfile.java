package javaClassSrc;
import java.io.*;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


public class ZIPfile {
	public ZIPfile(){}
	
	public void zipFiles(Vector<File> srcfiles,File zipfile){	//压缩文件
		byte[] buf  = new byte[1024];
		try{
			ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipfile));
			for(int i = 0;i<srcfiles.size();i++){
				FileInputStream in = new FileInputStream(srcfiles.get(i));
				out.putNextEntry(new ZipEntry(srcfiles.get(i).getName()));
				int len;
				while((len = in.read(buf)) > 0){
					out.write(buf,0,len);
				}
				out.closeEntry();
				in.close();
			}
			out.close();
			System.out.println("压缩完成！");
		}
		catch(Exception e ){
			e.printStackTrace();
		}
	}
}
