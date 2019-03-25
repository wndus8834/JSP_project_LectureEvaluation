<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%
	request.setCharacterEncoding("UTF-8");//사용자로부터 입력받은 요청 정보를 utf-8로 받겠다.
	String userID=null;
	String userPassword=null;
	if(request.getParameter("userID")!=null){
		userID=request.getParameter("userID");
	}
	if(request.getParameter("userPassword")!=null){
		userPassword=request.getParameter("userPassword");
	}
	if(userID.equals("") || userPassword.equals("")){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;//오류가 발생한 경우 바로 이 jsp 페이지의 작동을 종료시키도록 한다.
	}//그렇지 않은 경우에는 실제로 회원가입을 실행한다.
	
	UserDAO userDAO=new UserDAO();
	int result=userDAO.login(userID, userPassword);
	
	if(result==1){//로그인 성공
		session.setAttribute("userID", userID);//세션값 설정
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
		return;
	} else if (result==0){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}else if (result==-1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}else if (result==-2){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>