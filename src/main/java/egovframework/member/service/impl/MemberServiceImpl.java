package egovframework.member.service.impl;

import egovframework.member.mapper.MemberMapper;
import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @Override
    public void register(MemberVO member) {
        member.setPassword(encoder.encode(member.getPassword()));
        memberMapper.insertMember(member);
    }

    @Override
    public MemberVO login(String memberId, String password) {
        MemberVO member = memberMapper.selectMember(memberId);
        if (member == null || !encoder.matches(password, member.getPassword())) {
            return null;
        }
        return member;
    }

    @Override
    public boolean isDuplicateId(String memberId) {
        return memberMapper.selectMember(memberId) != null;
    }
}
