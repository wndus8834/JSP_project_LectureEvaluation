<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
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
<%
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
%>
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
			<li class="nav-item"><!-- active는 현재 위치한 페이지에 넣으면 된다. -->
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
					<a class="dropdown-item active" href="userJoin.jsp">회원가입</a>
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
		<form method="post" action="./userRegisterAction.jsp">
			<div class="form-group">
				<label>아이디</label>
				<input type="text" name="userID" class="form-control"><!-- form control; 입력 양식이 들어갈 수 있도록 -->
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" name="userPassword" class="form-control">
			</div>
			<div class="form-group">
				<label>이메일</label>
				<input type="email" name="userEmail" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">회원가입</button>
		</form>
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