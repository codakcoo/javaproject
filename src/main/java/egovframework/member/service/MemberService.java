package egovframework.member.service;

import egovframework.member.vo.MemberVO;
import java.util.List;

public interface MemberService {
    void             register(MemberVO member);                           // 회원가입
    MemberVO         login(String memberId, String password);             // 로그인
    boolean          isDuplicateId(String memberId);                      // 아이디 중복체크
    List<MemberVO>   getPendingList();                                    // 가입 승인 대기 목록
    void             updateMemberStatus(String memberId, String status);  // 승인/거절 처리
    List<MemberVO> getEmpList(MemberVO member);      // 직원 목록 조회
    void           updateMember(MemberVO member);     // 직원 정보 수정
    void           deleteMember(String memberId);     // 직원 삭제
    MemberVO getMemberById(String memberId); // 직원 상세 조회
}