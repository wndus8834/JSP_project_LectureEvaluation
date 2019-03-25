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
	
	boolean emailChecked=userDAO.getUserEmailChecked(userID);//특정한 사용자의 이메일이 인증되었는지 확인
	if(emailChecked==true){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다.');");
		script.println("location.href='index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	//인증이 안 된 회원일 경우에는 메일 인증 메세지를 보내줘야한다.
	//구글 smtp가 제공하는 양식을 사용한다.
	String host="http://localhost:8080/Lecture_Evaluation/";
	String from="ejooo8834@gmail.com";
	String to=userDAO.getUserEmail(userID);
	String subject="강의평가를 위한 이메일 인증 메일입니다.";
	String content="다음 링크에 접속하여 이메일 인증을 진행하세요."+
		"<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";
	
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
		
%>

<!-- 성공적으로 이메일을 보낸 뒤, 이메일을 보냈다는 메세지 출력 -->
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content_Type" content="text/html" charset="UTF-8">
	<!-- 자동형 웹 -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>강의평가 웹 사이트</title>
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
	<!-- bootstrap에서 제공하는 api - navbar -->
	<nav class="navbar navbar-expand-lg navbar-light bg-light"> <!-- bg-light;배경이 하얗게 보인다. -->
	<!-- navbar-brand는 부트스틀랩 안에서 로고같은거 출력할때 사용하는거 -->
	<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a> 
	<!-- 버튼을 누르면 navbar를 가진 요소가 보였다 안 보였다 함. 아래 div id에 정의함 -->
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
		<span class="navbar-toggler-icon"></span> <!-- navbar-toggler-icon; 작대기가 세줄 그어진 아이콘 -->
	</button>
	<div id="navbar" class="collapse navbar-collapse">
		<ul class="navbar-nav mr-auto">
			<li class="nav-item active"><!-- active는 현재 위치한 페이지에 넣으면 된다. -->
				<a class="nav-link" href="index.jsp">메인</a>
			</li>
			<li class="nav-item dropdown"><!-- 눌렀을때 아래쪽으로 목록 나오게 하는 것 -->
				<!-- 한번 눌렀을때 요소가 나오고 다시 누르면 사라진다. -->
				<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
					회원 관리
				</a>
				<!-- 실질적으로 회원들이 눌렀을때 나오는 정보 -->
				<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID==null){
%>
					<a class="dropdown-item" href="userLogin.jsp">로그인</a>
					<a class="dropdown-item" href="userJoin.jsp">회원가입</a>
<%
	} else {
%>
					<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
	}
%>
				</div>
			</li>
		</ul>
		<!-- 검색창 -->
		<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
			<!-- 검색했을때 특정한 검색 url로 변경된다. -->
			<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="search">
			<!-- outline이 초록색? my-2;위쪽으로 마진을 준다? -->
			<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
		</form>
	</div>
	</nav><!-- 상단바 -->
	<!-- 반응형; 특정한 요소가 알아서 작아지게 하는데 도움을 준다. -->
	<!-- mt-3; 위쪽으로 3만큼 마진을 준다.(네비게이션과 폼의 거리; 맨 윗 창과 로그인 형식의 거리) -->
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-success mt-4" role="alert"><!-- 알림창 -->
			이메일 주소 인증 메일이 전송되었습니다. 회원가입시 입력했던 이메일에 들어가셔서 인증해주세요.
		</div>
	</section>
	
	<!-- 가장 아래쪽에 들어가는 내용 -->
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
	<!-- 저작권 표시 -->
		Copyright &copy; 2018 이주연 All Rights Reserved.
	</footer>
	
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>

</body>
</html>