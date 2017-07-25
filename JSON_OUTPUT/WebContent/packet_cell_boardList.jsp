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
		
		// 글 읽기 권한이 있는지 확인한다.
		sql.append(" SELECT board_read FROM packet_cell_grade ");
		sql.append(" WHERE seq = (SELECT grade_seq FROM packet_cell_userList WHERE user_seq = "+userKey+" AND joinCell_seq = "+cellSeq+" AND del_flag ='N') ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int board_read = 0;
		while(rs.next()){
			board_read = rs.getInt(1);
		}
		
		// 게시글 리스트를 가져온다.
		sql.setLength(0);
		sql.append(" SELECT B.seq, (SELECT nickname FROM packet_user_list A WHERE A.seq = B.reg_user_seq) as reg_name, ");
		sql.append(" date_format(reg_Date, '%Y.%m.%d') as reg_date, title, ");
		sql.append(" (SELECT count(*) FROM packet_cell_reply C WHERE B.seq = C.board_seq AND del_flag = 'N') as reply_count ");
		sql.append(" FROM packet_cell_board B WHERE cell_seq = "+cellSeq);
		sql.append(" AND del_flag = 'N' ");
		sql.append(" ORDER BY B.seq DESC ");
		
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
			row.put("reply_count",rs.getInt(5));
			
			jsonArr.add(row);
		}
		
		jsonValueOut.put("board_read", board_read);
		jsonValueOut.put("result", jsonArr);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>