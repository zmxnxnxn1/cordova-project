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
StringBuffer sql = new StringBuffer();
StringBuffer sql2 = new StringBuffer();
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
	
	sql.append(" SELECT approve, name ");
	sql.append(" FROM packet_cell_list ");
	sql.append(" WHERE seq = " + cellSeq);
	
	pstmt = conn.prepareStatement(sql.toString());
	//System.out.println(pstmt);
	rs=pstmt.executeQuery();
	
	int approve = 0;
	String cellName = "";
	while(rs.next()){
		approve = rs.getInt(1);
		cellName = rs.getString(2);
	}
	
	if (approve != 1) { // 승인이 필요 없을 경우
		approve = 3;
	} else { // 승인이 필요할 경우
		approve = 4;
	
		// 모임 승인 권한이 있는 SEQ 번호를 가져온다.
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
		
		// 알람을 보낼 SEQ 번호를 가져온다.
		sql.setLength(0);
		sql.append(" SELECT count(*) FROM packet_cell_userList ");
		sql.append(" WHERE joinCell_seq = "+cellSeq+" AND grade_seq IN ("+memberApprove_seq+") ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int columnCnt = 0;
		while (rs.next()) {
			columnCnt = rs.getInt(1);
		}
		
		sql.setLength(0);
		sql.append(" SELECT user_seq FROM packet_cell_userList ");
		sql.append(" WHERE joinCell_seq = "+cellSeq+" AND grade_seq IN ("+memberApprove_seq+") ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		int[] sendAlarm_seq = new int[columnCnt];
		int num = 0;
		while (rs.next()) {
			sendAlarm_seq[num] = rs.getInt(1);
			num++;
		}
		
		String func = "moveCell("+cellSeq+")";
		
		for (int i=0; i<sendAlarm_seq.length; i++) {
			// 모임장에게 승인요청 알람을 보낸다.
			sql_i.setLength(0);
			sql_i.append(" INSERT INTO packet_alarm_list ");
			sql_i.append(" (user_seq, name, message, function) ");
			sql_i.append(" VALUES ( ?, ?, ?, ? )" );
			
			pstmt = conn.prepareStatement(sql_i.toString());
			pstmt.setInt(1, sendAlarm_seq[i]);
			pstmt.setString(2, "모임 가입 승인");
			pstmt.setString(3, cellName + " 모임 가입 요청이 왔습니다.");
			pstmt.setString(4, func);
			//System.out.println(pstmt);
			
			pstmt.executeUpdate();
		}
	
		
	}
	
	sql2.append(" INSERT INTO packet_cell_userList ");
	sql2.append(" (user_seq, joinCell_seq, grade_seq) ");
	sql2.append(" VALUES ( ?, ?, ? )" );
	
	pstmt = conn.prepareStatement(sql2.toString());
	pstmt.setInt(1, userKey);
	pstmt.setInt(2, cellSeq);
	pstmt.setInt(3, approve);
	
	pstmt.executeUpdate();
	
	jsonValueOut.put("result", approve);
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>