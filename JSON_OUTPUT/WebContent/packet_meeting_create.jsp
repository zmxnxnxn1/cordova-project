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
	sql.append(" INSERT INTO packet_meeting_list(reg_user_seq, cell_seq, title, meeting_date, meeting_time, location) ");
	sql.append(" VALUES(?,?,?,?,?,?)" );
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setInt(1, userKey);
	pstmt.setInt(2, cellSeq);
	pstmt.setString(3, meetingName);
	pstmt.setString(4, meetingDate);
	pstmt.setString(5, meetingTime);
	pstmt.setString(6, meetingLocation);
	
	pstmt.executeUpdate();
	
	// 알림을 만들기 위해 대상자를 SELECT 한다.
	sql.setLength(0);
	sql.append(" SELECT seq FROM packet_cell_userList WHERE joinCell_seq = "+cellSeq+" AND seq != "+userKey+" AND del_flag = 'N' ");
	
	pstmt = conn.prepareStatement(sql.toString());
	//System.out.println(pstmt);
	rs=pstmt.executeQuery();

	while(rs.next()){			
		// 정모를 만들었다는 알림을 만든다.
		sql.setLength(0);
		sql.append(" INSERT INTO packet_alarm_list(user_seq, name, message, function) ");
		sql.append(" VALUES(?,?,?,?)" );
		
		String alarmFunc = "moveCell("+cellSeq+")";
		String meetingAlarmMessage = meetingName + " 정모에 초대합니다. ";
		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setInt(1, rs.getInt(1));
		pstmt.setString(2, "정모 초대");
		pstmt.setString(3, meetingAlarmMessage);
		pstmt.setString(4, alarmFunc);
		
		pstmt.executeUpdate();
	}

	jsonValueOut.put("result", 1);
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>