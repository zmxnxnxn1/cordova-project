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

	int userKey=Integer.parseInt(request.getParameter("userKey"));

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
		
		sql.append(" SELECT seq, name, message, function ");
		sql.append(" FROM packet_alarm_list ");
		sql.append(" WHERE user_seq = " + userKey);
		sql.append(" AND del_flag = 'N' ORDER BY reg_date DESC ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("seq",rs.getInt(1));
			row.put("alarmName",rs.getString(2));
			row.put("message",rs.getString(3));
			row.put("function",rs.getString(4));
			
			jsonArr.add(row);
		}
		
		jsonValueOut.put("result", jsonArr);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>