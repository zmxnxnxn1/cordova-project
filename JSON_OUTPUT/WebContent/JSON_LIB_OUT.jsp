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
String url = "jdbc:mysql://doubleah.com/jclBoard?characterEncoding=UTF-8";
String id = "pol";
String pass = "0801";

Connection conn = DriverManager.getConnection(url,id,pass);
Statement stmt = conn.createStatement();

String sql = "SELECT id, password, username, title, memo, time FROM board_PAST ORDER BY id ASC";
ResultSet rs = stmt.executeQuery(sql);

JSONObject JSON_OUT = new JSONObject();

while(rs.next()) {
	String idx = rs.getString(1);
	String password = rs.getString(2);
	String username = rs.getString(3);
	String title = rs.getString(4);
	String memo = rs.getString(5);
	String time = rs.getString(6);
	
	
	JSONArray maglist = new JSONArray();
	
	JSONObject jobj = new JSONObject();
	jobj.put("password", password);
	jobj.put("username", username);
	jobj.put("title", title);
	jobj.put("memo", memo);
	jobj.put("time", time);
	maglist.add(jobj);
	
	JSON_OUT.put(idx, maglist);
	
	
}

//out.print(JSON_OUT);

 JSONArray jArr = new JSONArray();

 JSONObject obj1 = new JSONObject();
 obj1.put("name","사과");
 obj1.put("age","21");
 JSONObject obj2 = new JSONObject();
 obj2.put("name","바나나");
 obj2.put("age","27");

 jArr.add(obj1);
 jArr.add(obj2);

out.print(jArr);

%>