package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{
	//실제로 gmail smtp를 이용하기 위해서 계정 정보를 넣는 부분이 들어갈 것이다.
	//외부 라이브러리 두가지를 사용해야한다. javamail과 activation이라는 라이브러리
	//Authenticator은 인증 수행을 도와준다.
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		// TODO Auto-generated method stub
		return new PasswordAuthentication("ejooo8834@gmail.com", "proj1234");//사용자들에게 이메일을 보낼 관리자의 실제 구글(gmail) 아이디와 비밀번호 값을 넣는다.
	}
	
}
