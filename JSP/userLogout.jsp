<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate();//현재 사용자가 클러이언트에 모든 세션 정보를 다 파기시킨다.
	
%>
<script>
	location.href='index.jsp';
</script>