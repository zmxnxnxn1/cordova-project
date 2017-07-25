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
StringBuffer sql = new StringBuffer();
PreparedStatement pstmt;
ResultSet rs;

int userKey = Integer.parseInt(request.getParameter("userKey"));
String regPw = request.getParameter("regPw");
int subSex = Integer.parseInt(request.getParameter("subSex"));
int subAge = Integer.parseInt(request.getParameter("subAge"));

sql.setLength(0);
sql.append(" UPDATE packet_user_list SET ");
sql.append(" sex=?, age=? ");
sql.append(" WHERE seq = ?");

pstmt = conn.prepareStatement(sql.toString());
pstmt.setInt(1, subSex);
pstmt.setInt(2, subAge);
pstmt.setInt(3, userKey);

//System.out.println(pstmt);
pstmt.executeUpdate();

if (!regPw.equals("0")) {
	sql.setLength(0);
	sql.append(" UPDATE packet_user_list SET ");
	sql.append(" password = ? ");
	sql.append(" WHERE seq = ?");

	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, regPw);
	pstmt.setInt(2, userKey);

	pstmt.executeUpdate();
}

stmt.close();
conn.close();

JSONObject jsonValueOut = new JSONObject();
jsonValueOut.put("result", "1");

out.print(jsonValueOut);

%>