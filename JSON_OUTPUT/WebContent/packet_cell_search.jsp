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

	String searchText=request.getParameter("searchText");

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
		
		// 글을 검색하고 결과를 가져온다.
		sql.setLength(0);
		sql.append(" SELECT seq, name FROM packet_cell_list WHERE name LIKE ('%"+searchText+"%') AND DEL_FLAG = 'N' ORDER BY reg_date DESC ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();

		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("seq",rs.getInt(1));
			row.put("cellName",rs.getString(2));
			
			jsonArr.add(row);
		}
		
		jsonValueOut.put("result", jsonArr);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>