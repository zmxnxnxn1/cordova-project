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
		
		sql.append(" SELECT B.member_invite ");
		sql.append(" FROM ( ");
		sql.append(" SELECT grade_seq ");
		sql.append(" FROM packet_cell_userList ");
		sql.append(" WHERE user_seq = " + userKey + " AND joinCell_seq = " + cellSeq + " AND del_flag = 'N') A ");
		sql.append(" LEFT JOIN packet_cell_grade B ON A.grade_seq = B.seq ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArrInvite = new JSONArray();
		JSONObject rowMemberInvite = new JSONObject();
		int memberInvite = 0;
		while(rs.next()){		
			memberInvite = rs.getInt(1);
		}
		rowMemberInvite.put("memberInvite", memberInvite);
		jsonArrInvite.add(rowMemberInvite);
		
	
		sql2.append(" SELECT A.user_seq, B.nickname ");
		sql2.append(" FROM packet_cell_inviteList A ");
		sql2.append(" LEFT JOIN packet_user_list B ON A.user_seq = B.seq ");
		sql2.append(" WHERE cell_seq = " + cellSeq + " AND A.del_flag = 'N' ");
		
		pstmt = conn.prepareStatement(sql2.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("userSeq",rs.getInt(1));
			row.put("userName",rs.getString(2));
			
			jsonArr.add(row);
		}
		
		jsonValueOut.put("invite", jsonArrInvite);
		jsonValueOut.put("result", jsonArr);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>