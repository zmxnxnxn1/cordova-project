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

String userKey = request.getParameter("userKey");

String sql = " SELECT nickname, sex, age ";
sql += " FROM packet_user_list ";
sql += " WHERE seq = " + userKey;

ResultSet rs = stmt.executeQuery(sql);

JSONObject jsonValueOut = new JSONObject();

while(rs.next()) {
	jsonValueOut.put("nickname", rs.getString(1));
	jsonValueOut.put("sex", rs.getInt(2));
	jsonValueOut.put("age", rs.getInt(3));
}


rs.close();
stmt.close();
conn.close();

out.print(jsonValueOut);

%>