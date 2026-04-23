package egovframework.member.service;

import egovframework.member.vo.MemberVO;

public interface MemberService {
    MemberVO login(String memberId, String password);
    //인터페이스 매서드 추가
    void register(MemberVO member);
}