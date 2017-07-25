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
int meetingEnter=Integer.parseInt(request.getParameter("meetingEnter"));

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
	
	if (meetingEnter == 1) { // 미팅에 참가한다.
		sql.append(" INSERT INTO packet_meeting_userList(meeting_seq, user_seq) ");
		sql.append(" VALUES( ?,? ) ");
		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setInt(1, meetingSeq);
		pstmt.setInt(2, userKey);
		pstmt.executeUpdate();
	} else { // 미팅참가를 취소한다.
		sql.append(" UPDATE packet_meeting_userList SET del_flag = 'Y' ");
		sql.append(" WHERE meeting_seq = ? AND user_seq = ? AND del_flag = 'N' ");
		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setInt(1, meetingSeq);
		pstmt.setInt(2, userKey);
		pstmt.executeUpdate();
	}
	

	jsonValueOut.put("result", meetingEnter);
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>