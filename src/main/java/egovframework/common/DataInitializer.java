package egovframework.common;

import egovframework.member.mapper.MemberMapper;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.DependsOn;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct;

@Component
@DependsOn("flyway")
public class DataInitializer {

    @Autowired
    private MemberMapper memberMapper;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @PostConstruct
    public void init() {
        // admin 계정
        if (memberMapper.selectMember("admin") == null) {
            MemberVO admin = new MemberVO();
            admin.setMemberId("admin");
            admin.setPassword(encoder.encode("1234"));
            admin.setName("관리자");
            admin.setRole("ADMIN");
            memberMapper.insertMember(admin);
        }

        // tmdrnjs100 계정
        if (memberMapper.selectMember("tmdrnjs100") == null) {
            MemberVO admin2 = new MemberVO();
            admin2.setMemberId("tmdrnjs100");
            admin2.setPassword(encoder.encode("1234"));
            admin2.setName("관리자");
            admin2.setRole("ADMIN");
            memberMapper.insertMember(admin2);
        }
    }
}