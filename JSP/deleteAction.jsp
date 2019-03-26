<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDTO"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%
	String userID=null;
	if(session.getAttribute("userID")!=null){//사용자가 로그인한 상태, 즉 session이 유효한 상태일때
		userID=(String)session.getAttribute("userID");//userID에는 해당 세션값을 넣어준다.
	}
	if(userID==null){//로그인 하지 않은 상태
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	String evaluationID=null;
	if(request.getParameter("evaluationID")!=null){
		evaluationID=request.getParameter("evaluationID");
	}
	EvaluationDAO evaluationDAO=new EvaluationDAO();
	if(userID.equals(evaluationDAO.getUserID(evaluationID))){//자신이 쓴 글일때만 삭제 가능하도록
		int result=new EvaluationDAO().delete(evaluationID);
		if(result==1){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('삭제가 완료되었습니다.');");
			script.println("location.href='index.jsp';");
			script.println("</script>");
			script.close();
			return;//오류가 발생한 경우 바로 이 jsp 페이지의 작동을 종료시키도록 한다.
		} else{
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	} else{
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>