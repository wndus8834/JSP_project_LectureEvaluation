<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDAO"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%!
	public static String getClientIP(HttpServletRequest request){//해당 사이트에 접속한 사용자의 IP주소를 알아내는 함수
		String ip=request.getHeader("X-FORWARDED-FOR");
		//프록시 서버를 사용한 클라이언트라 하더라도 ip를 정상적으로 가져오도록
		if(ip==null || ip.length()==0){
			ip=request.getHeader("Proxy-Client-IP");
		}
		if(ip==null || ip.length()==0){
			ip=request.getHeader("WL-Proxy-Client-IP");
		}
		if(ip==null || ip.length()==0){
			ip=request.getRemoteAddr();
		}
		return ip;
	}
%>
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
	LikeyDAO likeyDAO=new LikeyDAO();
	int result=likeyDAO.like(userID, evaluationID, getClientIP(request));
	if(result==1){
		result=evaluationDAO.like(evaluationID);
		if(result==1){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('추천이 완료되었습니다.');");
			script.println("location.href='index.jsp';");
			script.println("</script>");
			script.close();
			return;
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
		script.println("alert('이미 추천을 누른 글입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>