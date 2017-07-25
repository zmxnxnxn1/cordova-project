<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %>   
<%@page import = "java.net.*" %> 
<%@ page import="org.json.simple.JSONObject"%> 
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.*"%>
<%
	response.addHeader("Access-Control-Allow-Origin", "*");
	response.addHeader("Access-Control-Allow-Credentials", "true");
 %>

<%

	String loginId=request.getParameter("loginId");
	String loginPw=request.getParameter("loginPw");

	response.setCharacterEncoding("utf-8");
	Connection conn = null;                                        
	StringBuffer sql = new StringBuffer();
	PreparedStatement pstmt;
	ResultSet rs;
	
	JSONObject jsonValueOut = new JSONObject();

	try{
		JSONObject jsonobj; 
		
		String url = "jdbc:mysql://doubleah.com/PACKET";      
		String id = "pol";                                                   
		String pw = "0801";                                              
		
		Class.forName("com.mysql.jdbc.Driver");                       
		conn=DriverManager.getConnection(url,id,pw);
		
		// 아이디와 비밀번호가 맞는지 확인한다.
		sql.setLength(0);
		sql.append(" SELECT * FROM packet_user_list WHERE nickname = '"+loginId+"' AND password = '"+loginPw+"' AND del_flag = 'N' ");
		
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int loginResult = 0;
		while(rs.next()){
			loginResult = rs.getInt(1);
		}
		
		jsonValueOut.put("result", loginResult);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>