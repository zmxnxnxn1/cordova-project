<%@page import="com.sun.xml.internal.ws.Closeable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.util.*" %> 
<%
    response.addHeader("Access-Control-Allow-Origin", "*");
    response.addHeader("Access-Control-Allow-Credentials", "true");
%>
<%

String regId=request.getParameter("regId");
String regPw=request.getParameter("regPw");


Class.forName("com.mysql.jdbc.Driver");
request.setCharacterEncoding("utf-8");
String url = "jdbc:mysql://doubleah.com/PACKET";
String id = "pol";
String pass = "0801";

Connection conn = DriverManager.getConnection(url,id,pass);
Statement stmt = conn.createStatement();

// 랜덤 숫자 만들기
int keyNumber = 0;
Random rand = new Random(System.currentTimeMillis());
for (int i=0; i<30; i++) {
	keyNumber = Math.abs(rand.nextInt(99999999)+10000000);
	if ((int) (Math.log10(keyNumber)+1) == 8) break; 
}

// 중복된 아이디가 있는지 확인한다.
String sql2 = " SELECT seq FROM packet_user_list WHERE nickname = '"+regId+"' AND del_flag = 'N' " ;
ResultSet rs2 = stmt.executeQuery(sql2);

int userKey = 0;
int checkId = 0;
while(rs2.next()) {
	checkId = rs2.getInt(1);
}

if (checkId == 0) { // 중복이 없을 경우
		// 가입처리 한다.
		String sql = " INSERT INTO packet_user_list (user_key, nickname, password, reg_date, sex, age, memo) VALUES(?,?,?,now(),?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);

		pstmt.setInt(1, keyNumber);
		pstmt.setString(2, regId);
		pstmt.setString(3, regPw);
		pstmt.setInt(4, 1);
		pstmt.setInt(5, 27);
		pstmt.setString(6, "저는 "+regId+"입니다.");

		pstmt.execute();
		pstmt.close();

		
		// SEQ값을 리턴한다.
		String sql3 = " SELECT max(seq) FROM packet_user_list" ;
		ResultSet rs3 = stmt.executeQuery(sql3);

		while(rs3.next()) {
			userKey = rs3.getInt(1);
		}

		stmt.close();
		conn.close();
}

JSONObject jsonValueOut = new JSONObject();
jsonValueOut.put("userKey", userKey);

out.print(jsonValueOut);


%>