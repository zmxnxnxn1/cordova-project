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
	int boardSeq=Integer.parseInt(request.getParameter("boardSeq"));

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
		
		// 글 관리 권한을 가져온다.
		sql.setLength(0);
		sql.append(" SELECT ");
		sql.append(" if((SELECT seq FROM packet_cell_board WHERE seq = "+boardSeq+" AND reg_user_seq = "+userKey+"),'1','0') as writer, ");
		sql.append(" (SELECT board_admin FROM packet_cell_grade ");
		sql.append(" WHERE seq = (SELECT grade_seq FROM packet_cell_userList WHERE user_seq = "+userKey+" AND joinCell_seq = "+cellSeq+")) as board_admin ");
		sql.append(" FROM DUAL ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();

		int writer = 0;
		int board_admin = 0;
		while(rs.next()){			
			writer = rs.getInt(1);
			board_admin = rs.getInt(2);
		}
		
		// 게시글 정보를 가져온다.
		sql.setLength(0);
		sql.append(" SELECT B.seq, ");
		sql.append(" (SELECT nickname FROM packet_user_list A WHERE A.seq = B.reg_user_seq) as reg_name, ");
		sql.append(" date_format(reg_Date, '%Y.%m.%d') as reg_date, ");
		sql.append(" B.title, B.description ");
		sql.append(" FROM packet_cell_board B WHERE B.seq = "+boardSeq);
		
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("seq",rs.getInt(1));
			row.put("reg_name",rs.getString(2));
			row.put("reg_date",rs.getString(3));
			row.put("title",rs.getString(4));
			row.put("description",rs.getString(5));
			
			jsonArr.add(row);
		}
		
		jsonValueOut.put("result", jsonArr);
		jsonValueOut.put("writer", writer);
		jsonValueOut.put("board_admin", board_admin);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>