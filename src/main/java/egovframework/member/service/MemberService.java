package egovframework.member.service;

import egovframework.member.vo.MemberVO;

public interface MemberService {
    MemberVO login(String memberId, String password);
}