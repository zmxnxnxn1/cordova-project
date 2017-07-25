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

String nickname = request.getParameter("nickname");

String sql = "SELECT COUNT(*) FROM packet_user_list WHERE nickname ='" + nickname + "'";
ResultSet rs = stmt.executeQuery(sql);

int result = 0;
while(rs.next()) {
	result = rs.getInt(1);
}

JSONObject jsonValueOut = new JSONObject();
jsonValueOut.put("result", result);

stmt.close();
conn.close();

out.print(jsonValueOut);

%>