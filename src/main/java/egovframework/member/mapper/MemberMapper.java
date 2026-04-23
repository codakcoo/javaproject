package egovframework.member.mapper;

import egovframework.member.vo.MemberVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface MemberMapper 
{
    // 아이디로 회원 단건 조회
    MemberVO selectMember(String memberId);
    // 인터페이스 매서드 추가 
    void insertMember(MemberVO member);
}