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
	StringBuffer sql2 = new StringBuffer();
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
		
		sql.append(" SELECT grade_seq ");
		sql.append(" FROM packet_cell_userList ");
		sql.append(" WHERE user_seq = " + userKey + " AND joinCell_seq = " + cellSeq + " AND del_flag = 'N' ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int userGradeSeq = 0;
		JSONArray jsonArrCellJoin = new JSONArray();
		JSONObject rowGradeSeq = new JSONObject();
		while(rs.next()){
			userGradeSeq = rs.getInt(1);
		}
		
		rowGradeSeq.put("gradeSeq", userGradeSeq);
		jsonArrCellJoin.add(rowGradeSeq);
		
		
		
		sql2.append(" SELECT cell_leave, cell_delete ");
		sql2.append(" FROM packet_cell_grade ");
		sql2.append(" WHERE seq = " + userGradeSeq + " AND del_flag = 'N' ");
		
		pstmt = conn.prepareStatement(sql2.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArrCellControl = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("cellLeave",rs.getInt(1));
			row.put("cellDelete",rs.getInt(2));
			
			jsonArrCellControl.add(row);
		}
		
		jsonValueOut.put("CellJoin", jsonArrCellJoin);
		jsonValueOut.put("CellControl", jsonArrCellControl);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>