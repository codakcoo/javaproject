package egovframework.member.service.impl;

import egovframework.member.mapper.MemberMapper;
import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;

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
        // status 상관없이 아이디 중복 체크
        return memberMapper.selectMemberById(memberId) != null;
    }

    @Override
    public List<MemberVO> getPendingList() {
        // 가입 승인 대기 목록
        return memberMapper.selectPendingList();
    }

    @Override
    public void updateMemberStatus(String memberId, String status) {
        // 승인/거절 처리
        MemberVO member = new MemberVO();
        member.setMemberId(memberId);
        member.setStatus(status);
        memberMapper.updateMemberStatus(member);
    }
    
    @Override
    public List<MemberVO> getEmpList(MemberVO member) {
        // 직원 목록 조회  -Mapper의 selectEmpList SQL 호출
        return memberMapper.selectEmpList(member);
    }

    @Override
    public void updateMember(MemberVO member) {
        // 직원 정보 수정 - Mapper의 updateMember SQL 호출
        memberMapper.updateMember(member);
    }

    @Override
    public void deleteMember(String memberId) {
        // 직원 삭제 - Mapper의 deleteMember SQL 호출
        memberMapper.deleteMember(memberId);
    }
    @Override
    public MemberVO getMemberById(String memberId) {
        return memberMapper.selectMemberById(memberId);
    }
}