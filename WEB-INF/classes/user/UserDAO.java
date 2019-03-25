package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {

	public int login(String userID, String userPassword) {
		String SQL="SELECT userPassword FROM USER WHERE userID=?";//사용자로부터 입력받은 id의 비밀번호를 불러와 사용하겠다.
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, userID);//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			rs=pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) {//사용자가 입력한 아이디의 비밀번호가 입력한 비밀번호와 일치하는지
					return 1;//로그인 성공
				}
				else {
					return 0;//비밀번호 틀림
				}
			}
			return -1;//아이디 없음
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -2;//데이터베이스 오류
	}
	
	public int join(UserDTO user) {
		String SQL="INSERT INTO USER VALUES (?,?,?,?,false)";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
			//해당되는 문구를 실행한 결과를 바로 반환한다. 크게 총 두가지가 존재한다.
			//PreparedStatement는 executeUpdate와 executeQuery가 존재한다.
			//Query는 데이터를 조회하거나 검색할 때 쓴다. ResultSet을 이용해서 결과를 확인할 수 있다.
			//Update는 insert,update,delete를 처리할때 사용한다. update는 실질적으로 영향을 받은 데이터들의 개수를 반환한다.
			//만약에 회원가입에 성공을 하면 1이라는 값을 반환한다. -1을 반환할때는 데이터베이스 오류가 나서 회원가입에 실패한 것이다.
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//회원가입 실패
	}
	
	public String getUserEmail(String userID) {//특정 회원의 이메일을 반환하는 함수, String으로 반환한다
		String SQL="SELECT userEmail FROM USER WHERE userID=?";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, userID);//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			rs=pstmt.executeQuery();
			if(rs.next()) { //결과가 존재한다면, 즉 존재하는 사용자의 아이디일 경우
				return rs.getString(1);//괄호 안 1은 첫번째 속성, 즉 userEmailChecked을 반환하도록 해준다.
				//성공적으로 사용자의 이메일이 인증되었다면 true 값 반환
			}
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return null;//데이터베이스 오류
	}
	
	public boolean getUserEmailChecked(String userID) { //이메일 검증. 이메일 검증을 하지 않으면 사용자는 강의 평가를 작성할 수 없다.
		String SQL="SELECT userEmailChecked FROM USER WHERE userID=?";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, userID);//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			rs=pstmt.executeQuery();
			if(rs.next()) { //결과가 존재한다면, 즉 존재하는 사용자의 아이디일 경우
				return rs.getBoolean(1);//괄호 안 1은 첫번째 속성, 즉 userEmailChecked을 반환하도록 해준다.
				//성공적으로 사용자의 이메일이 인증되었다면 true 값 반환
			}
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false;//데이터베이스 오류
	}
	
	public boolean setUserEmailChecked(String userID) { //특정한 사용자가 이메일이 검증을 통해서 이메일 인증이 완료되도록 해주는
		String SQL="UPDATE USER SET userEmailChecked =true WHERE userID=?";//특정한 id를 가지는 사용자를 하여금 체크(이메일 인증)가 되도록 업데이트 해주는
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, userID);//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			pstmt.executeUpdate();
			return true;//한번 이메일을 인증한 사용자라도 추가적으로 인증이 가능하도록
			//특정한 이메일 확인 링크를 누르면 사용자에 대한 이메일 인증이 되는건데,
			//이미 인증이 되었다해도 마찬가지로 인증을 시켜줘야해서
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return false;//데이터베이스 오류
	}
}
