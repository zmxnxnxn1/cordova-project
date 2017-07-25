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

String categoryName=request.getParameter("categoryName");
String locationSeq=request.getParameter("locationSeq");
String cellName=request.getParameter("cellName");
String intro=request.getParameter("intro");
int approve=Integer.parseInt(request.getParameter("approve"));
int userKey=Integer.parseInt(request.getParameter("userKey"));

Connection conn = null;                                        
StringBuffer sql = new StringBuffer();
StringBuffer sql2 = new StringBuffer();
StringBuffer sql3 = new StringBuffer();
PreparedStatement pstmt;
ResultSet rs;

JSONObject jsonValueOut = new JSONObject();

try{
	String url = "jdbc:mysql://doubleah.com/PACKET";      
	String id = "pol";                                                   
	String pw = "0801";                                              
	
	Class.forName("com.mysql.jdbc.Driver");                       
	conn=DriverManager.getConnection(url,id,pw);              
	
	sql.append(" INSERT INTO packet_cell_list ");
	sql.append(" (category_name, location_seq, name, intro, approve) ");
	sql.append(" VALUES ( ?, ?, ?, ?, ? )" );
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, categoryName);
	pstmt.setString(2, locationSeq);
	pstmt.setString(3, cellName);
	pstmt.setString(4, intro);
	pstmt.setInt(5, approve);
	
	pstmt.executeUpdate();
	
	sql2.append(" select ");
	sql2.append(" max(seq) ");
	sql2.append(" from packet_cell_list ");
	pstmt = conn.prepareStatement(sql2.toString());
	rs=pstmt.executeQuery();
	
	JSONArray jsonArr = new JSONArray();
	int joinSeq=0;
	while(rs.next()){
		JSONObject row = new JSONObject();
		
		joinSeq = rs.getInt(1);
		row.put("seq", joinSeq);
		
		jsonArr.add(row);
	}
	
	sql3.append(" INSERT INTO packet_cell_userList ");
	sql3.append(" (user_seq, joinCell_seq, grade_seq) ");
	sql3.append(" VALUES ( ?, ?, ? )" );
	
	pstmt = conn.prepareStatement(sql3.toString());
	pstmt.setInt(1, userKey);
	pstmt.setInt(2, joinSeq);
	pstmt.setString(3, "1"); // 1=모임장
	
	pstmt.executeUpdate();
	
	jsonValueOut.put("result", jsonArr);
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>