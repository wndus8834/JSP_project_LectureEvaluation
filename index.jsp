<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
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
	request.setCharacterEncoding("UTF-8");
	String lectureDivide="전체";
	String searchType="최신순";
	String search="";
	int pageNumber=0;
	if(request.getParameter("lectureDivide")!=null){
		lectureDivide=request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType")!=null){
		searchType=request.getParameter("searchType");
	}
	if(request.getParameter("search")!=null){
		search=request.getParameter("search");
	}
	if(request.getParameter("pageNumber")!=null){
		try{//정수형으로 입력 안 했을 시에는 오류가 나기 때문에
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
		} catch(Exception e){
			System.out.println("검색 페이지 번호 오류");
		}
	}
	String userID=null;
	if(session.getAttribute("userID")!=null){
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
	boolean emailChecked=new UserDAO().getUserEmailChecked(userID);
	if(emailChecked==false){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("location.href='emailSendConfirm.jsp';");
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
			<li class="nav-item active"><!-- active는 현재 위치한 페이지에 넣으면 된다./현재 위치가 파란색으로 표시된다. -->
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
	<section class="container"><!-- 반응형; 특정한 요소가 알아서 작아지게 하는데 도움을 준다. -->
		<!-- get방식; 사용자가 서버에 데이터 전달하도록, mt-3;위쪽으로 3만큼 마진을 준다. -->
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2"><!-- name(여기선 lectureDivide)은 url에 포함된다. 아래 search도 -->
				<option value="전체">전체</option>
				<option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순" <% if(lectureDivide.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<!-- form-control 폼의 형식을 조절한다.(마진, 최대 길이(maxlength) 등) -->
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<!-- modal형식으로 사용사자가 강의 평가를 등록할 수 있도록; bootstrap에서 제공; 웹페이지 상단에 나타나는 하나의 등록양식-->
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a> <!-- btn-danger은 빨간색 -->
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList=new ArrayList<EvaluationDTO>();
	evaluationList=new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null)
		for(int i=0; i<evaluationList.size(); i++){
			if(i==5) break;
			EvaluationDTO evaluation=evaluationList.get(i);
%>

		<!-- 실제로 사용자가 강의평가를 등록했을때 어떻게 출력될지 -->
		<!-- 오른쪽 왼쪽 여백 생기도록 section 태그 안에 넣음 -->
		<div class="card bg-light mt-3"> <!-- 위쪽으로 3만큼 여백 -->
			<div class="card-header bg-light"> <!-- 헤더가 들어갈 수 있도록 -->
				<div class="row"> <!-- 한개의 행을 두개로 쪼갬 -->
					<div class="col-8 text-left"><%= evaluation.getLectureName() %>&nbsp;<small><%= evaluation.getProfessorName() %></small></div>
					<div class="col-4 text-right">
						종합 <span style="color: red;"><%= evaluation.getTotalScore() %></span>
					</div>
				</div>		
			</div>
			<!-- 실제 정확한 내용 -->
			<div class="card-body">
				<h5 class="card-title">
					<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getLectureYear() %>년 <%= evaluation.getSemesterDivide() %>)</small>
				</h5>
				<p class="card-text"><%= evaluation.getEvaluationContent() %>
				<!-- 실제 강의에 대한 성적 -->
				<div class="row">
					<div class="col-9 text-left">
						성적 <span style="color: red;"><%= evaluation.getCreditScore() %></span>
						널널 <span style="color: red;"><%= evaluation.getComfortableScore() %></span>
						강의 <span style="color: red;"><%= evaluation.getLectureScore() %></span>
						<span style="color: green;">(추천: <%= evaluation.getLikeCount() %>)</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">추천</a> <!-- 값 전달해줘야한다. -->
						<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">삭제</a> <!-- 사용자 본인만 삭제하도록 -->
					</div>
				</div>
			</div>
		</div>
<%
		}
%>
	</section>
	
	<!-- pagination이 사용된다. 이는 부트스트랩 웹 디자인 프레임 워크에서 제공되는 하나의 기술 중 하나로써
	여러 개의 페이지가 있는 하나의 구성 요소를 작업할때 사용하는 것이다. 일반적으로 게시판 등에서 사용되는 요소 중 하나이다. -->
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
<%
	if(pageNumber <=0) {
%>
	<a class="page-link disabled">이전</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber -1 %>">이전</a>
<%
	}
%>
		</li>	
		<li>
<%
	if(evaluationList.size() <6) { //강의평가가 6개 이상 존재한다면 다음 페이지가 존재한다는 것이기 때문에(한 페이지에 5개까지 보임)
%>
	<a class="page-link disabled">다음</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
	<%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
	<%= pageNumber +1 %>">다음</a>
<%
	}
%>
		</li>
	</ul>
	
	<!-- modal 양식 -->
	<!-- 일반적으로 class는 modal fade를 쓴다. dialog는 모달 다이얼로그창 -->
	<!-- 위의 등록하기 버튼을 누르면 나온다. -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog"><!-- 전반적으로 modal 창이다 라는 것을 알려준다. -->
			<div class="modal-content"> <!-- 모달 창이 들어가는 내용 -->
				<div class="modal-header"> <!-- 모달의 제목 -->
					<h5 class="modla-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"> <!-- data-dismiss가 모달창 닫는거 -->
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body"> <!-- 모달의 내용 -->
					<!-- 사용자가 등록 버튼 눌렀을때 사용자의 평가 등록 요청 전달 -->
					<form action="./evaluationRegisterAction.jsp" method="post">
						<!-- row는 하나의 행을 여러개의 열로 나눌때 사용 --> 
						<div class="form-row">
							<!-- 원래 하나의 행은 총 12만큼 할당되는데 6씩 나눔 -->
							<div class="form-group col-sm-6">
								<label>강의명</label>
								<!-- name은 서버로 전달된다.(url), 최대 20자까지 들어갈 수 있다. -->
								<input type="text" name="lectureName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label>
								<input type="text" name="professorName" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="form-row">
							<!-- form-group; 무언가를 선택할 때 -->
							<div class="form-group col-sm-4">
								<label>수강 연도</label>
								<select name="lectureYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018" selected>2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강 학기</label>
								<select name="semesterDivide" class="form-control">
									<option value="1학기" selected>1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label>
								<select name="lectureDivide" class="form-control">
									<option value="전공" selected>전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label>종합</label>
								<select name="totalScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>성적</label>
								<select name="creditScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>널널</label>
								<select name="comfortableScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label>강의</label>
								<select name="lectureScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="submit" class="btn btn-primary">등록하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
	
	
	<!-- 신고하기; 위에꺼 복붙 -->
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog"><!-- 전반적으로 modal 창이다 라는 것을 알려준다. -->
			<div class="modal-content"> <!-- 모달 창이 들어가는 내용 -->
				<div class="modal-header"> <!-- 모달의 제목 -->
					<h5 class="modla-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"> <!-- data-dismiss가 모달창 닫는거 -->
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body"> <!-- 모달의 내용 -->
					<!-- 사용자가 등록 버튼 눌렀을때 사용자의 평가 등록 요청 전달 -->
					<form action="./reportAction.jsp" method="post">
							<div class="form-group">
								<label>신고 제목</label>
								<input type="text" name="reportTitle" class="form-control" maxlength="30">
							</div>
							<div>
								<label>신고 내용</label>
								<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
							</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
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