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
int meetingSeq=Integer.parseInt(request.getParameter("meetingSeq"));

String meetingName=request.getParameter("meetingName");
String meetingDate=request.getParameter("meetingDate");
String meetingTime=request.getParameter("meetingTime");
String meetingLocation=request.getParameter("meetingLocation");

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
	
	// 정모를 생성한다.
	sql.append(" UPDATE packet_meeting_list SET ");
	sql.append(" title=?, meeting_date=?, meeting_time=?, location=? ");
	sql.append(" WHERE seq = ? ");
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, meetingName);
	pstmt.setString(2, meetingDate);
	pstmt.setString(3, meetingTime);
	pstmt.setString(4, meetingLocation);
	pstmt.setInt(5, meetingSeq);
	
	pstmt.executeUpdate();

	jsonValueOut.put("result", 1);
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>