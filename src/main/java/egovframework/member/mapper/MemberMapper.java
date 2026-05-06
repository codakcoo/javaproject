package egovframework.member.mapper;

import egovframework.member.vo.MemberVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface MemberMapper {
    MemberVO       selectMember(String memberId);
    void           insertMember(MemberVO member);
    List<MemberVO> selectMemberList();   // ← 추가: 결재자 목록용
}
