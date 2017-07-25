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

int cellSeq=Integer.parseInt(request.getParameter("cellSeq"));
String UserList=request.getParameter("UserList");
String[] listSeqArr = UserList.split(";"); // 구분자를 ;로 하여 배열로 만듬

Connection conn = null;                                        
StringBuffer sql = new StringBuffer();

PreparedStatement pstmt;
ResultSet rs;

JSONObject jsonValueOut = new JSONObject();

try{
	String url = "jdbc:mysql://doubleah.com/PACKET";      
	String id = "pol";                                                   
	String pw = "0801";                                              
	
	Class.forName("com.mysql.jdbc.Driver");                       
	conn=DriverManager.getConnection(url,id,pw);
	
	sql.append(" SELECT name ");
	sql.append(" FROM packet_cell_list ");
	sql.append(" WHERE seq = " + cellSeq);
	
	pstmt = conn.prepareStatement(sql.toString());
	//System.out.println(pstmt);
	rs=pstmt.executeQuery();
	
	String cellName = "";
	while(rs.next()){
		cellName = rs.getString(1) + " 모임에 초대받으셨습니다.";
	}
	
	String func = "moveCell("+cellSeq+")";
	
	for (int i=0; i<listSeqArr.length; i++) {
		StringBuffer sql2 = new StringBuffer();
		StringBuffer sql3 = new StringBuffer();
		
		sql2.append(" INSERT INTO packet_alarm_list ");
		sql2.append(" (user_seq, name, message, function) ");
		sql2.append(" VALUES ( ?, ?, ?, ? )" );
		
		pstmt = conn.prepareStatement(sql2.toString());
		pstmt.setString(1, listSeqArr[i]);
		pstmt.setString(2, "모임 초대");
		pstmt.setString(3, cellName);
		pstmt.setString(4, func);
		//System.out.println(pstmt);
		
		pstmt.executeUpdate();
		
		sql3.append(" UPDATE packet_cell_inviteList SET del_flag = 'Y' ");
		sql3.append(" WHERE cell_seq = ? AND user_seq = ?");
		
		pstmt = conn.prepareStatement(sql3.toString());
		pstmt.setInt(1, cellSeq);
		pstmt.setString(2, listSeqArr[i]);
		//System.out.println(pstmt);
		
		pstmt.executeUpdate();
	}
	
	jsonValueOut.put("result", "1");
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>