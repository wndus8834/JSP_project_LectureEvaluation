package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class LikeyDAO {

	public int like(String userID, String evaluationID, String userIP) {
		String SQL="INSERT INTO LIKEY VALUES (?,?,?)";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, userID);//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			pstmt.setString(2, evaluationID);
			pstmt.setString(3, userIP);
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//추천 중복 오류
	}
}
