package util;

import java.security.MessageDigest;

public class SHA256 {
	//회원 가입 이후에 이메일 인증을 할 때 기존에 존재하는 이메일에 해쉬값을 적용해서 
	//그것을 인증 코드로 링크를 타고 들어와서 인증을 할 수 있도록 개발하는 것
	
	public static String getSHA256(String input) {//특정 값을 넣었을 때 그 값을 SHA256으로 해쉬값을 구하는 함수(여기서는 사용자의 이메일 값을 넣는다.)
		StringBuffer result=new StringBuffer();
		try {
			MessageDigest digest=MessageDigest.getInstance("SHA-256");//실제로 사용한 값을 SHA256을 적용할 수 있도록 하는 알고리즘
			byte[] salt="Hello! This is Salt.".getBytes();//SHA256을 사용하면 해커에 의해 해킹을 당할 가능성이 높아져서 salt값을 적용한다.
			//큰 따옴표 안에는 자신이 원하는 salt값을 넣어주면 된다.
			digest.reset();
			digest.update(salt);
			byte[] chars=digest.digest(input.getBytes("UTF-8"));//해시를 적용한 값을 char변수에 담는다.
			for(int i=0; i<chars.length; i++) {//위의 변수를 문자열로 바꾼다.
				String hex=Integer.toHexString(0xff & chars[i]);
				if(hex.length()==1) result.append("0");//자리가 한자리 수라도  0을 붙여 16진수로 만든다.
				result.append(hex);//hex값을 뒤에 차근차근히 단다.
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result.toString();//해당 해쉬값을 반환한다.
	}
}