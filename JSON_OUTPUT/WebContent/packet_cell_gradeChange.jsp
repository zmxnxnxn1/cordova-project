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
int gradeChangeUserSeq=Integer.parseInt(request.getParameter("gradeChangeUserSeq"));

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
	
	// 해당 유저의 등급을 가져온다.
	sql.append(" SELECT grade_seq FROM packet_cell_userList ");
	sql.append(" WHERE user_seq = "+gradeChangeUserSeq+" AND joinCell_seq = "+cellSeq+" AND del_flag = 'N' ");
	
	pstmt = conn.prepareStatement(sql.toString());
	//System.out.println(pstmt);
	rs=pstmt.executeQuery();
	
	int userGrade = 0;
	while(rs.next()){
		userGrade = rs.getInt(1);
	}
	
	if (userGrade == 2) {
		userGrade = 3; // 일반멤버로
	} else {
		userGrade = 2; // 운영진으로
	}

	
	// 해당 유저의 등급을 변경한다.
	sql.setLength(0);
	sql.append(" UPDATE packet_cell_userList SET grade_seq = ? WHERE user_seq = ? AND joinCell_seq = ? AND del_flag = 'N' ");
	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setInt(1, userGrade);
	pstmt.setInt(2, gradeChangeUserSeq);
	pstmt.setInt(3, cellSeq);
	pstmt.executeUpdate();
	
	
	jsonValueOut.put("result", "1");
	out.println(jsonValueOut);
	
	conn.close();

}catch(Exception e){  
	e.printStackTrace();
}



%>