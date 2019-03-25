package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {
	
	public int write(EvaluationDTO evaluationDTO) {
		//evaluationID값 같은 경우는 자동으로 1씩 증가하는 auto_increment가 적용되어 있어서 null을 쓴다, 마지막(likeCount) 0은 좋아요 수가 처음에는 0이기 때문에
		String SQL="INSERT INTO EVALUATION VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,0)";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			pstmt.setString(2, evaluationDTO.getLectureName().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(3, evaluationDTO.getProfessorName().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setInt(4, evaluationDTO.getLectureYear());//int형은 따로 보안 안 해도 된다.
			pstmt.setString(5, evaluationDTO.getSemesterDivide().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(6, evaluationDTO.getLectureDivide().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(7, evaluationDTO.getEvaluationTitle().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(8, evaluationDTO.getEvaluationContent().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(9, evaluationDTO.getTotalScore().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(10, evaluationDTO.getCreditScore().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(11, evaluationDTO.getComfortableScore().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(12, evaluationDTO.getLectureScore().replaceAll("<","&lt;").replaceAll(">",  "&gt;").replaceAll("\r\n", "<br>"));
			return pstmt.executeUpdate();//하나의 게시글이 성공적으로 올라갔으면 1 반환
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//데이터베이스 오류
	}

	public ArrayList<EvaluationDTO> getList (String lectureDivide, String searchType, String search, int pageNumber){
		if(lectureDivide.equals("전체")) {
			lectureDivide="";
		}
		ArrayList<EvaluationDTO> evaluationList=null;
		String SQL="";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			if(searchType.equals("최신순")) {
				//여기서 LIKE는 mysql문법 중 하나인데, 특정한 문자열을 포함하는지 물어볼때 사용
				//강의명, 교수명, 평가 제목, 평가 내용을 모두 합친 문자열에 어떠한 문자열을 포함하고 있는지 물어본다.
				//한 페이지에 궁극적으로 5개의 게시글이 올라가도록 LIMIT
				SQL="SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE " + 
						"? ORDER BY evaluationID DESC LIMIT " + pageNumber*5 + ", " + pageNumber*5 + 6;
			} else if(searchType.equals("추천순")) {//order by 뒤 변수만 바꿔주면 된다.
				SQL="SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE " + 
						"? ORDER BY likeCount DESC LIMIT " + pageNumber*5 + ", " + pageNumber*5 + 6;
			}
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			//%를 넣어주는건 mysql 문법 중 하나인데 like 다음에 % 하고 어떠한 문자열이 들어가면 그 문자열이 포함하는지 물어보는 것
			pstmt.setString(1, "%" + lectureDivide + "%");//lecturDivide는 전체, 전공, 교양, 기타
			pstmt.setString(2, "%" + search + "%");//search는 사용자가 입력한 검색어
			rs=pstmt.executeQuery();
			evaluationList=new ArrayList<EvaluationDTO>();//결과를 list 형태로 담아준다.
			while(rs.next()) {//모든 게시물이 존재할 때마다 list에 담을수있도록 만들어준다.
				//특정한 결과가 나올때마다 결과를 이용해서 초기화를 해준다.
				//위의 SQL문에서 모든 속성이 출력되도록 만들어줬기 때문에 차례대로 넣으면 된다.
				EvaluationDTO evaluation=new EvaluationDTO(
						rs.getInt(1),
						rs.getString(2),
						rs.getString(3),
						rs.getString(4),
						rs.getInt(5),
						rs.getString(6),
						rs.getString(7),
						rs.getString(8),
						rs.getString(9),
						rs.getString(10),
						rs.getString(11),
						rs.getString(12),
						rs.getString(13),
						rs.getInt(14)
				);//이렇게 현재 나온 결과물을 하나의 강의 평가 데이터에 담아준뒤 리스트에 추가해서
				evaluationList.add(evaluation);//모든 강의 평가 데이터를 리스트로 담을 수 있게 한다.
			}
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return evaluationList;
	}
	
	public int like(String evaluationID) {
		String SQL="UPDATE EVALUATION SET likeCount = likeCount+1 WHERE evaluationID=?";//특정한 강의 평가 글이 likeCount를 1 증가시키는
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//데이터베이스 오류
	}
	
	public int delete(String evaluationID) {
		String SQL="DELETE FROM EVALUATION WHERE evaluationID=?";//특정한 강의 평가 글이 likeCount를 1 증가시키는
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;//데이터베이스 오류
	}
	
	public String getUserID(String evaluationID) {
		String SQL="SELECT userID FROM EVALUATION WHERE evaluationID=?";
		Connection conn=null;
		PreparedStatement pstmt=null;//특정한 sql문장을 성공적으로 수행할 수 있도록
		ResultSet rs=null;//특정한 sql문장을 실행한 후의 결과를 가지고 처리를 해주고자 할 때
		try {
			conn=DatabaseUtil.getConnection();//DB 접근; 안정적으로 접근하기 위해 따로 모듈화를 해주었다.
			pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));//sql문 안에 있는 ?(물음표)에 사용자가 입력한 값을 set시킨다.
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch(Exception e){
			e.printStackTrace();
		} finally { //종료를 한 후에는 접근한 자원을 해제해 주어야 한다.
			try {if(conn!=null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt!=null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs!=null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return null;//존재하지 않는 강의 평가글
	}
}
