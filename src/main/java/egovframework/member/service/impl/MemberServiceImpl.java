package egovframework.member.service.impl;

import egovframework.member.mapper.MemberMapper;
import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public MemberVO login(String memberId, String password) {
        // DB에서 아이디로 회원 조회
        MemberVO member = memberMapper.selectMember(memberId);

        // 회원이 없거나 비밀번호 불일치 시 null 반환
        if (member == null || !member.getPassword().equals(password)) {
            return null;
        }
        return member;
    }
}