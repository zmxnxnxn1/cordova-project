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
	ResultSet rs2;
	ResultSet rs3;
	
	JSONObject jsonValueOut = new JSONObject();

	try{
		JSONObject jsonobj; 
		
		String url = "jdbc:mysql://doubleah.com/PACKET";      
		String id = "pol";                                                   
		String pw = "0801";                                              
		
		Class.forName("com.mysql.jdbc.Driver");                       
		conn=DriverManager.getConnection(url,id,pw);    
		
		// 미팅 만들기, 읽기 권한, 미팅 수정 권한을 가져온다.
		sql.setLength(0);
		sql.append(" SELECT meeting_create, meeting_read, meeting_admin FROM packet_cell_grade  ");
		sql.append(" WHERE seq = (SELECT grade_seq FROM packet_cell_userList WHERE user_seq = "+userKey+" AND joinCell_seq = "+cellSeq+" AND del_flag ='N') ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int userMeetingCreate = 0;
		int userMeetingRead = 0;
		int userMeetingAdmin = 0;
		while(rs.next()){
			userMeetingCreate = rs.getInt(1);
			userMeetingRead = rs.getInt(2);
			userMeetingAdmin = rs.getInt(3);
		}
		
		// 미팅 리스트를 가져온다.
		sql.setLength(0);
		sql.append(" SELECT seq, reg_user_seq, title, location, meeting_date, meeting_time ");
		sql.append(" FROM packet_meeting_list WHERE cell_seq = "+cellSeq+" AND del_flag = 'N' ORDER BY reg_date DESC ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("seq",rs.getInt(1));
			row.put("reg_user_seq",rs.getInt(2));
			row.put("title",rs.getString(3));
			row.put("location",rs.getString(4));
			row.put("meeting_date",rs.getString(5));
			row.put("meeting_time",rs.getString(6));
			
			jsonArr.add(row);
			
			// [STR] 미팅에 참가했는지 확인한다.
			sql.setLength(0);
			sql.append(" SELECT seq FROM packet_meeting_userList ");
			sql.append(" WHERE meeting_seq = "+rs.getInt(1)+" AND user_seq = "+userKey+" AND del_flag = 'N' ");
			
			pstmt = conn.prepareStatement(sql.toString());
			//System.out.println(pstmt);
			rs2=pstmt.executeQuery();
			
			int enterMeeting = 0;
			while(rs2.next()){
				enterMeeting = rs.getInt(1);
			}
			
			row.put("enterMeeting",enterMeeting);
			// [END] 미팅에 참가했는지 확인한다.
			
			// [STR] 참가자 리스트를 가져온다.
			sql.setLength(0);
			sql.append(" SELECT nickname FROM packet_user_list A INNER JOIN ");
			sql.append(" (SELECT user_seq FROM packet_meeting_userList WHERE meeting_seq = "+rs.getInt(1)+" AND del_flag = 'N') B ");
			sql.append(" ON A.seq = B.user_seq ");
			
			pstmt = conn.prepareStatement(sql.toString());
			//System.out.println(pstmt);
			rs3=pstmt.executeQuery();

			JSONArray jsonArr2 = new JSONArray();
			while(rs3.next()){
				JSONObject row2 = new JSONObject();
				
				row2.put("enterName",rs3.getString(1));
				
				jsonArr2.add(row2);
			}
			row.put("enterList",jsonArr2);
			// [END] 참가자 리스트를 가져온다.
		}
		
		jsonValueOut.put("meetingCreateGrade", userMeetingCreate);
		jsonValueOut.put("meetingReadGrade", userMeetingRead);
		jsonValueOut.put("userMeetingAdmin", userMeetingAdmin);
		jsonValueOut.put("result", jsonArr);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>