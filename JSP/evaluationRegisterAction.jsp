<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="java.io.PrintWriter"%><!-- 특정한 스크립트 구문을 출력하고자 할 때 사용 -->
<%
	request.setCharacterEncoding("UTF-8");//사용자로부터 입력받은 요청 정보를 utf-8로 받겠다.
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
	//evaluationID는 자동으로 증가하기 때문에 안 씀
	//userID는 위에서 정의했기 때문에 다시 안 씀
	//likeCount는 0이 들어가있어서 안 씀
	String lectureName=null;
	String professorName=null;
	int lectureYear=0;
	String semesterDivide=null;
	String lectureDivide=null;
	String evaluationTitle=null;
	String evaluationContent=null;
	String totalScore=null;
	String creditScore=null;
	String comfortableScore=null;
	String lectureScore=null;

	if(request.getParameter("lectureName")!=null){
		lectureName=request.getParameter("lectureName");
	}
	if(request.getParameter("professorName")!=null){
		professorName=request.getParameter("professorName");
	}
	if(request.getParameter("lectureYear")!=null){
		try{//lectureYear는 int형이기 때문에
			lectureYear=Integer.parseInt(request.getParameter("lectureYear"));
			
		} catch(Exception e){
			System.out.println("강의 연도 데이터 오류");
		}
	}
	if(request.getParameter("semesterDivide")!=null){
		semesterDivide=request.getParameter("semesterDivide");
	}
	if(request.getParameter("lectureDivide")!=null){
		lectureDivide=request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle")!=null){
		evaluationTitle=request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent")!=null){
		evaluationContent=request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore")!=null){
		totalScore=request.getParameter("totalScore");
	}
	if(request.getParameter("creditScore")!=null){
		creditScore=request.getParameter("creditScore");
	}
	if(request.getParameter("comfortableScore")!=null){
		comfortableScore=request.getParameter("comfortableScore");
	}
	if(request.getParameter("lectureScore")!=null){
		lectureScore=request.getParameter("lectureScore");
	}

	if(lectureName==null || professorName==null || lectureYear==0 || semesterDivide==null || lectureDivide==null || evaluationTitle==null
			|| evaluationContent==null || totalScore==null || creditScore==null || comfortableScore==null || lectureScore==null
			|| evaluationTitle.equals("") || evaluationContent.equals("")){//반드시 제목과 내용은 공백이 들어가면 안되기 때문에
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;//오류가 발생한 경우 바로 이 jsp 페이지의 작동을 종료시키도록 한다.
	}//그렇지 않은 경우에는 실제로 회원가입을 실행한다.


	
	EvaluationDAO evaluationDAO=new EvaluationDAO();
	int result=evaluationDAO.write(new EvaluationDTO(0, userID, lectureName, professorName, 
			lectureYear, semesterDivide, lectureDivide, evaluationTitle, evaluationContent, 
			totalScore, creditScore, comfortableScore, lectureScore, 0));//한명의 사용자 객체를 넣어준다.
	//회원가입이 성공적으로 끝났을 경우에는 1이 반환되고, 그렇지 않을 경우에는 -1이 반환된다.

	if(result==-1){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else{
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("location.href='index.jsp';");//사용자가 회원가입을 하자마자 인증을 받을 수 있도록 페이지로 이동시킨다.
		script.println("</script>");
		script.close();
		return;
	}
%>