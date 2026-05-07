package egovframework.order.mapper;

import egovframework.order.vo.OrderReceiptVO;
import egovframework.order.vo.OrderReceiptItemVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface OrderReceiptMapper {

    // 목록 조회
    List<OrderReceiptVO> selectReceiptList(OrderReceiptVO vo);
    int selectReceiptCount(OrderReceiptVO vo);

    // 상세 조회
    OrderReceiptVO selectReceipt(Long receiptId);
    List<OrderReceiptItemVO> selectReceiptItems(Long receiptId);

    // 등록
    void insertReceipt(OrderReceiptVO vo);           // useGeneratedKeys → receiptId 주입
    void insertReceiptItem(OrderReceiptItemVO vo);

    // 중복 체크 (결재 승인 시 이미 주문 생성됐는지 확인)
    int countByDocId(Long docId);
}