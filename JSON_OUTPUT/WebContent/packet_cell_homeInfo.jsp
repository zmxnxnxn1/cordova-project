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
	int cellSeq=Integer.parseInt(request.getParameter("cellSeq"));


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
		
		sql.append(" SELECT A.name, A.intro, B.name ");
		sql.append(" FROM packet_cell_list A ");
		sql.append(" LEFT JOIN packet_location_list B ON A.location_seq=B.location_number ");
		sql.append(" WHERE A.seq = " + cellSeq + " AND A.del_flag = 'N' ");
		
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("cellName",rs.getString(1));
			row.put("cellIntro",rs.getString(2));
			row.put("locationName",rs.getString(3));
			
			jsonArr.add(row);
		}
		
		// 모임 정보 수정 속성을 가져온다.
		sql.setLength(0);
		sql.append(" SELECT cell_modify FROM packet_cell_grade ");
		sql.append(" WHERE seq = (SELECT grade_seq FROM packet_cell_userList WHERE user_seq = "+userKey+" AND joinCell_seq = "+cellSeq+") ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();

		int cell_modify = 0;
		while(rs.next()){			
			cell_modify = rs.getInt(1);
		}
		
		jsonValueOut.put("result", jsonArr);
		jsonValueOut.put("cell_modify", cell_modify);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>