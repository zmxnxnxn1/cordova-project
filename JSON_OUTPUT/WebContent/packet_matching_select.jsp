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
		
		// 가입하지 않은 소모임을 찾는다. 전체 소모임에 전부 다 가입했을 경우 0이 출력된다.
		sql.append(" SELECT seq FROM packet_cell_list ");
		sql.append(" WHERE seq NOT IN (SELECT joinCell_seq FROM packet_cell_userList WHERE user_seq = "+userKey+" AND del_flag = 'N') ");
		sql.append(" AND del_flag = 'N' ORDER BY reg_date DESC limit 1 ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int cellSeq = 0;
		while(rs.next()){
			cellSeq = rs.getInt(1);
		}
		
		
		jsonValueOut.put("cellSeq", cellSeq);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>