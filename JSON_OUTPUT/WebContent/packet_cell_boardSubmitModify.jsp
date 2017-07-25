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
int boardSeq=Integer.parseInt(request.getParameter("boardSeq"));
String title=request.getParameter("title");
String description=request.getParameter("description");

Connection conn = null;                                        
StringBuffer sql_u = new StringBuffer();
PreparedStatement pstmt;
ResultSet rs;

JSONObject jsonValueOut = new JSONObject();

try{
	String url = "jdbc:mysql://doubleah.com/PACKET";      
	String id = "pol";                                                   
	String pw = "0801";                                              
	
	Class.forName("com.mysql.jdbc.Driver");                       
	conn=DriverManager.getConnection(url,id,pw);
	
	// 게시글을 업데이트 한다.
	sql_u.append(" UPDATE packet_cell_board SET title=?, description=? WHERE seq = ? ");
	
	pstmt = conn.prepareStatement(sql_u.toString());
	pstmt.setString(1, title);
	pstmt.setString(2, description);
	pstmt.setInt(3, boardSeq);
	pstmt.executeUpdate();

	jsonValueOut.put("result", "1");
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>