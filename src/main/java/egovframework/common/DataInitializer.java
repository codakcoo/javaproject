package egovframework.common;

import egovframework.member.mapper.MemberMapper;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct;

@Component
public class DataInitializer {

    @Autowired
    private MemberMapper memberMapper;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @PostConstruct
    public void init() {
    	if (memberMapper.selectMemberById("admin") == null) {
    	    MemberVO admin = new MemberVO();
    	    admin.setMemberId("admin");
    	    admin.setPassword(encoder.encode("1234"));
    	    admin.setName("관리자");
    	    admin.setEmail("admin@erp.local");
    	    admin.setRole("ADMIN");
    	    admin.setStatus("ACTIVE");    // 관리자는 바로 활성화
    	    admin.setDepartment("인사팀"); // 부서
    	    admin.setPhone("000-0000-0000");
    	    admin.setGender("M");
    	    memberMapper.insertMember(admin);
    	}
    }
}
