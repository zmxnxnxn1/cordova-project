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
		
		// 모임 멤버 리스트를 만든다.
		sql.setLength(0);
		sql.append(" SELECT B.nickname, B.memo, C.name as grade_name, A.user_seq, A.grade_seq ");
		sql.append(" FROM packet_cell_userList A ");
		sql.append(" LEFT JOIN packet_user_list B ON A.user_seq=B.seq ");
		sql.append(" LEFT JOIN packet_cell_grade C ON A.grade_seq=C.seq ");
		sql.append(" WHERE A.joinCell_seq = " + cellSeq + " AND A.del_flag = 'N' ");
		sql.append(" ORDER BY A.seq DESC ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("userName",rs.getString(1));
			row.put("userMemo",rs.getString(2));
			row.put("userGradeName",rs.getString(3));
			row.put("seq",rs.getInt(4));
			row.put("grade_seq",rs.getInt(5));
			
			jsonArr.add(row);
		}
		
		// 멤버에 대한 권한이 있는지 확인한다.
		sql.setLength(0);
		sql.append(" SELECT seq FROM packet_cell_grade WHERE member_approve = 1 ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		String memberApprove_seq = "";
		while(rs.next()){
			memberApprove_seq += rs.getString(1)+",";
		}
		memberApprove_seq = memberApprove_seq.substring(0, memberApprove_seq.length()-1);
		
		sql.setLength(0);
		sql.append(" SELECT cell_transfer, member_gradeCtl, member_approve, member_ban FROM packet_cell_grade A WHERE ");
		sql.append(" (SELECT grade_seq FROM packet_cell_userList WHERE user_seq = "+userKey+" AND joinCell_seq = "+cellSeq+" AND del_flag = 'N') = A.seq ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr2 = new JSONArray();
		int cell_transfer = 0;
		int member_gradeCtl = 0;
		int member_approve = 0;
		int member_ban = 0;
		while(rs.next()){
			cell_transfer = rs.getInt(1);
			member_gradeCtl = rs.getInt(2);
			member_approve = rs.getInt(3);
			member_ban = rs.getInt(4);
		}
		
		JSONObject row = new JSONObject();
		
		row.put("cell_transfer",cell_transfer);
		row.put("member_gradeCtl",member_gradeCtl);
		row.put("member_approve",member_approve);
		row.put("member_ban",member_ban);
		
		jsonArr2.add(row);
		
		jsonValueOut.put("result", jsonArr);
		jsonValueOut.put("cellAdmin", jsonArr2);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>