package egovframework.member.service;

import egovframework.member.vo.MemberVO;

public interface MemberService {
    void     register(MemberVO member);
    MemberVO login(String memberId, String password);
    boolean  isDuplicateId(String memberId);
}
