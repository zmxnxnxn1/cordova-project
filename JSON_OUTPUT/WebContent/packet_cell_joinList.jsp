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
		
		sql.append(" SELECT O.seq, O.name, O.category_name, P.user_cnt ");
		sql.append(" FROM ( ");
		sql.append(" SELECT A.seq, A.name, A.category_name ");
		sql.append(" FROM packet_cell_list A ");
		sql.append(" LEFT JOIN packet_category_list B ON A.category_seq = B.seq ");
		sql.append(" WHERE A.del_flag = 'N' ");
		sql.append(" ) O ");
		sql.append(" LEFT JOIN ");
		sql.append(" ( ");
		sql.append(" SELECT joinCell_seq AS seq, COUNT(joinCell_seq) AS user_cnt ");
		sql.append(" FROM packet_cell_userList C ");
		sql.append(" WHERE C.del_flag = 'N' ");
		sql.append(" GROUP BY joinCell_seq) P ON O.seq = P.seq ");
		sql.append(" INNER JOIN ( ");
		sql.append(" SELECT joinCell_seq FROM packet_cell_userList ");
		sql.append(" WHERE user_seq = "+userKey+" AND del_flag = 'N' ");
		sql.append(" ) M ON P.seq = M.joinCell_seq ");
		sql.append("  ");
		
		pstmt = conn.prepareStatement(sql.toString());
		//System.out.println(pstmt);
		rs=pstmt.executeQuery();
		
		JSONArray jsonArr = new JSONArray();
		while(rs.next()){
			JSONObject row = new JSONObject();
			
			row.put("seq",rs.getInt(1));
			row.put("cellName",rs.getString(2));
			row.put("categoryName",rs.getString(3));
			row.put("userCount",rs.getString(4));
			
			jsonArr.add(row);
		}
		
		jsonValueOut.put("result", jsonArr);
		out.println(jsonValueOut);
		
		conn.close();
	} catch(Exception e) {                                                    
		e.printStackTrace();
	}



%>