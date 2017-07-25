<%@page import="com.sun.xml.internal.ws.Closeable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Credentials", "true");
%>
<%

Class.forName("com.mysql.jdbc.Driver");
request.setCharacterEncoding("utf-8");
String url = "jdbc:mysql://doubleah.com/PACKET";
String id = "pol";
String pass = "0801";

Connection conn = DriverManager.getConnection(url,id,pass);
Statement stmt = conn.createStatement();

int userKey = Integer.parseInt(request.getParameter("userKey"));
int subAge = Integer.parseInt(request.getParameter("subAge"));
int subSex = Integer.parseInt(request.getParameter("subSex"));

//중복된 닉네임이 있는지 확인한다.
int checkNickname = 0;

if (checkNickname == 0) { // 중복 닉네임이 없을 때
	String sql = " UPDATE packet_user_list SET age=?, sex=? ";
	sql += " WHERE seq = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);

	pstmt.setInt(1, subAge);
	pstmt.setInt(2, subSex);
	pstmt.setInt(3, userKey);
	
	//System.out.println(pstmt);

	pstmt.execute();
	pstmt.close();
	
}


stmt.close();
conn.close();

JSONObject jsonValueOut = new JSONObject();
jsonValueOut.put("result", checkNickname);

out.print(jsonValueOut);




%>