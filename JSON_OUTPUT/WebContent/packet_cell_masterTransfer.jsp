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
int masterUserSeq=Integer.parseInt(request.getParameter("masterUserSeq"));

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
	
	// 모임장을 일반멤버로 낮춘다.
	sql.append(" UPDATE packet_cell_userList SET grade_seq = 3 WHERE user_seq = ? AND joinCell_seq = ? AND del_flag = 'N' ");
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setInt(1, userKey);
	pstmt.setInt(2, cellSeq);
	pstmt.executeUpdate();
	
	// 새로운 모임장을 만든다.
	sql.setLength(0);
	sql.append(" UPDATE packet_cell_userList SET grade_seq = 1 WHERE user_seq = ? AND joinCell_seq = ? AND del_flag = 'N' ");
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setInt(1, masterUserSeq);
	pstmt.setInt(2, cellSeq);
	pstmt.executeUpdate();
	
	jsonValueOut.put("result", "1");
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>