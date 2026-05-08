package egovframework.member.mapper;

import egovframework.member.vo.MemberVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface MemberMapper {
    MemberVO       selectMember(String memberId);        // ACTIVE 상태만 조회 (로그인용)
    MemberVO       selectMemberById(String memberId);    // status 상관없이 조회 (중복체크용)
    void           insertMember(MemberVO member);        // 회원가입
    List<MemberVO> selectMemberList();                   // 결재자 목록
    List<MemberVO> selectPendingList();                  // 가입 승인 대기 목록
    void           updateMemberStatus(MemberVO member);  // 승인/거절 처리
    List<MemberVO> selectEmpList(MemberVO member);   // 직원 목록 조회 (검색 포함)
    void           updateMember(MemberVO member);     // 직원 정보 수정
    void           deleteMember(String memberId);     // 직원 삭제
}