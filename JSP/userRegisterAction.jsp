<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%
	request.setCharacterEncoding("UTF-8");//사용자로부터 입력받은 요청 정보를 utf-8로 받겠다.
	String userID=null;
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	if(userID!=null){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 된 상태입니다.');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	String userPassword=null;
	String userEmail=null;
	if(request.getParameter("userID")!=null){
		userID=request.getParameter("userID");
	}
	if(request.getParameter("userPassword")!=null){
		userPassword=request.getParameter("userPassword");
	}
	if(request.getParameter("userEmail")!=null){
		userEmail=request.getParameter("userEmail");
	}
	if(userID.equals("") || userPassword.equals("") || userEmail.equals("")){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;//오류가 발생한 경우 바로 이 jsp 페이지의 작동을 종료시키도록 한다.
	}//그렇지 않은 경우에는 실제로 회원가입을 실행한다.
	
	UserDAO userDAO=new UserDAO();
	int result=userDAO.join(new UserDTO(userID, userPassword, userEmail, SHA256.getSHA256(userEmail), false));//한명의 사용자 객체를 넣어준다.
	//회원가입이 성공적으로 끝났을 경우에는 1이 반환되고, 그렇지 않을 경우에는 -1이 반환된다.
	if(result==-1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else{
		session.setAttribute("userID", userID);//session 값으로 userID라는 이름의 값으로 userID를 넣어서 서버에서 관리할 수 있도록 한다.
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("location.href='emailSendAction.jsp';");//사용자가 회원가입을 하자마자 인증을 받을 수 있도록 페이지로 이동시킨다.
		script.println("</script>");
		script.close();
		return;
	}
%>