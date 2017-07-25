<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
<%@ page import="org.json.simple.JSONObject"%> 
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.*"%>
<%
	response.addHeader("Access-Control-Allow-Origin", "*");
	response.addHeader("Access-Control-Allow-Credentials", "true");
 %>       
          
<%

int userKey=Integer.parseInt(request.getParameter("userKey"));
int cellSeq=Integer.parseInt(request.getParameter("cellSeq"));

String cellName=request.getParameter("cellName");
String intro=request.getParameter("intro");
String locationSeq=request.getParameter("locationSeq");
String categoryName=request.getParameter("categoryName");
int approve=Integer.parseInt(request.getParameter("approve"));


Connection conn = null;                                        
StringBuffer sql = new StringBuffer();
PreparedStatement pstmt;
ResultSet rs;

JSONObject jsonValueOut = new JSONObject();

try{
	String url = "jdbc:mysql://doubleah.com/PACKET";      
	String id = "pol";                                                   
	String pw = "0801";                                              
	
	Class.forName("com.mysql.jdbc.Driver");                       
	conn=DriverManager.getConnection(url,id,pw);              
	
	sql.append(" UPDATE packet_cell_list SET ");
	sql.append(" category_name=?, location_seq=?, name=?, intro=?, approve=? ");
	sql.append(" WHERE seq = ?");
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, categoryName);
	pstmt.setString(2, locationSeq);
	pstmt.setString(3, cellName);
	pstmt.setString(4, intro);
	pstmt.setInt(5, approve);
	pstmt.setInt(6, cellSeq);
	
	pstmt.executeUpdate();
	
	jsonValueOut.put("result", 1);
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>