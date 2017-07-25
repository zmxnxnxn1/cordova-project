<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
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

Connection conn = null;                                        
StringBuffer sql_s = new StringBuffer();
StringBuffer sql_s2 = new StringBuffer();
StringBuffer sql_s3 = new StringBuffer();
StringBuffer sql_s4 = new StringBuffer();
StringBuffer sql_u = new StringBuffer();
StringBuffer sql_i = new StringBuffer();
PreparedStatement pstmt;
ResultSet rs;

JSONObject jsonValueOut = new JSONObject();

try{
	String url = "jdbc:mysql://doubleah.com/PACKET";      
	String id = "pol";                                                   
	String pw = "0801";                                              
	
	Class.forName("com.mysql.jdbc.Driver");                       
	conn=DriverManager.getConnection(url,id,pw);
	
	// 초대 권한이 있는지 확인한다.
	sql_s.append(" SELECT member_invite ");
	sql_s.append(" FROM ( ");
	sql_s.append(" SELECT grade_seq AS grade ");
	sql_s.append(" FROM packet_cell_userList ");
	sql_s.append(" WHERE user_seq = "+userKey+" AND joinCell_seq = "+cellSeq+" AND del_flag = 'N' ");
	sql_s.append(" ) AS A ");
	sql_s.append(" , packet_cell_grade B ");
	sql_s.append(" WHERE A.grade = B.seq ");
	
	pstmt = conn.prepareStatement(sql_s.toString());
	rs=pstmt.executeQuery();
	
	int memberInvite = 0;
	while (rs.next()) {
		memberInvite = rs.getInt(1); // 초대 권한이 있으면 1
	}
	
	// 오늘 날짜로 추가 된게 있는지 확인한다.
	sql_s2.append(" SELECT IF(today_date=last_date, '0', '1') AS inviteUpdate FROM ");
	sql_s2.append(" (SELECT (SELECT DATE_FORMAT(now(), '%Y%m%d') FROM DUAL) AS today_date, ");
	sql_s2.append(" (SELECT DATE_FORMAT(reg_date, '%Y%m%d') FROM packet_cell_inviteList ");
	sql_s2.append(" WHERE cell_seq = "+cellSeq+" ORDER BY seq DESC LIMIT 1) AS last_date ");
	sql_s2.append(" FROM DUAL ");
	sql_s2.append(" ) AS A ");
	
	pstmt = conn.prepareStatement(sql_s2.toString());
	//System.out.println(pstmt);
	rs=pstmt.executeQuery();
	
	int inviteUpdate = 0;
	while (rs.next()) {
		inviteUpdate = rs.getInt(1); // 마지막으로 등록된 날짜가 오늘이 아닐경우 1
	}
	
	if (memberInvite == 1 && inviteUpdate == 1) {
		// 기존에 있던 자료들을 삭제한다.
		sql_u.append(" UPDATE packet_cell_inviteList SET del_flag = 'Y' WHERE cell_seq = ? AND del_flag = 'N' ");
		
		pstmt = conn.prepareStatement(sql_u.toString());
		pstmt.setInt(1, cellSeq);
		pstmt.executeUpdate();
		
		// 이미 가입한 유져들을 가져온다.
		sql_s3.append(" SELECT user_seq FROM packet_cell_userList WHERE joinCell_seq = "+cellSeq+" AND del_flag = 'N' ORDER BY user_seq ");
		
		pstmt = conn.prepareStatement(sql_s3.toString());
		rs=pstmt.executeQuery();
		
		String pastUserList = "";
		while (rs.next()) {
			pastUserList += rs.getString(1)+",";
		}
		
		pastUserList = pastUserList.substring(0, pastUserList.length()-1);
		
		// 이미 가입한 유져들을 제외하고, 최신 가입한 유져 5명을 가져온다.
		sql_s4.append(" SELECT seq FROM packet_user_list WHERE seq NOT IN ("+pastUserList+") ORDER BY seq DESC LIMIT 5 ");
		
		pstmt = conn.prepareStatement(sql_s4.toString());
		rs=pstmt.executeQuery();
		
		int[] insertUserSeq = new int[5];
		int num = 0;
		while (rs.next()) {
			insertUserSeq[num] = rs.getInt(1);
			num++;
		}
		
		for (int i=0; i<insertUserSeq.length; i++) {
			sql_i.setLength(0);
			
			// 최근 가입한 유져 5명을 INSERT 한다.
			sql_i.append(" INSERT INTO packet_cell_inviteList(cell_seq, user_seq) ");
			sql_i.append(" VALUES(?, ?) ");
			
			pstmt = conn.prepareStatement(sql_i.toString());
			pstmt.setInt(1, cellSeq);
			pstmt.setInt(2, insertUserSeq[i]);
			pstmt.executeUpdate();
		}
		
		jsonValueOut.put("result", "1");
		out.println(jsonValueOut);
		
	} else {
		jsonValueOut.put("result", "0");
		out.println(jsonValueOut);
	}
	
	
	
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>