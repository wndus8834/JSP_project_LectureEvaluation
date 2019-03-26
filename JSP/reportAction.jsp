<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport" %> <!-- 이메일 사용 -->
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="util.Gmail"%> <!-- gmail 사용 -->
<%@ page import="java.util.Properties" %> <!-- 속성을 정의할때 사용하는 라이브러리 -->
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%
	UserDAO userDAO=new UserDAO();
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
	String reportTitle=null;
	String reportContent=null;
	if(request.getParameter("reportTitle")!=null){
		reportTitle=request.getParameter("reportTitle");
	}
	if(request.getParameter("reportContent")!=null){
		reportContent=request.getParameter("reportContent");
	}
	if(reportTitle.equals("") || reportContent.equals("")){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;//오류가 발생한 경우 바로 이 jsp 페이지의 작동을 종료시키도록 한다.
	}
	
	
	//인증이 안 된 회원일 경우에는 메일 인증 메세지를 보내줘야한다.
	//구글 smtp가 제공하는 양식을 사용한다.
	String host="http://localhost:8080/Lecture_Evaluation/";
	String from="ejooo8834@gmail.com";
	String to=userDAO.getUserEmail(userID);
	String subject="강의평가 사이트에서 접수된 신고 메일입니다.";
	String content="신고자: "+ userID +
					"<br>제목: " + reportTitle +
					"<br>내용: " + reportContent;
	
	//실제로 smtp에 접속하기 위한 정보를 넣어줘야 한다.
	Properties p=new Properties();
	//실제로 정보를 넣는다.
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	//위와 같이 설정함으로써 이메일을 전송할 수 있다. 아래는 이메일을 전송하는 부분이다.
	try{
		//구글 계정으로 인증을 수행해서 실제로 사용자한테 관리자의 이메일로 인증 메일이 가도록
		Authenticator auth=new Gmail();
		Session ses=Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg=new MimeMessage(ses);//MimeMessage 객체를 이용해서 실제로 메일을 보낼 수 있도록
		msg.setSubject(subject);//제목을 넣어준다.
		Address fromAddr=new InternetAddress(from);//보이는 사람의 정보를 넣어준다.
		msg.setFrom(fromAddr);
		Address toAddr=new InternetAddress(to);//받는 사람도 넣어준다.
		msg.addRecipient(Message.RecipientType.TO, toAddr);//괄호와 같이 받는 사람의 주소를 넣어준다.
		msg.setContent(content, "text/html;charset=UTF8");//메일안에 담길 내용
		Transport.send(msg);//실제로 메세지가 전송할수있도록 한다.
	}catch(Exception e){
		e.printStackTrace();
		//오류가 발생했을 경우 바로 전 페이지로 이동하도록 한다.
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	PrintWriter script=response.getWriter();
	script.println("<script>");
	script.println("alert('정상적으로 신고되었습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;	
%>