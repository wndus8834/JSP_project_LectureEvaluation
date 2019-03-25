<!-- 사용자가 이메일 인증을 하면 그에 대한 정보를 처리하는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%
	request.setCharacterEncoding("UTF-8");//사용자로부터 입력받은 요청 정보를 utf-8로 받겠다.
	String code=null;
	if(request.getParameter("code")!=null){
		code=request.getParameter("code");
	}
	UserDAO userDAO=new UserDAO();
	String userID=null;
	if(session.getAttribute("userID")!=null){//userID가 로그인 되어있는지 session데이터를 이용해서 확인해야한다.
		userID=(String)session.getAttribute("userID");
	}
	if(userID==null){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href='userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	//현재 사용자의 이메일 주소를 받아보도록 한다.
	String userEmail=userDAO.getUserEmail(userID);
	boolean isRight=(new SHA256().getSHA256(userEmail).equals(code)) ? true:false;//현재 사용자가 보낸 코드가 정확히 해당 사용자의 이메일 주소를 해시값을 적용한 데이터와 일치하는지
	if(isRight==true){//사용자가 보낸 코드가 정상 값이라면 인증에 성공했다는 메세지 출력
		userDAO.setUserEmailChecked(userID);//실제로 해당 사용자의 이메일 인증을 처리해준다.
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
		return;
	} else{
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>