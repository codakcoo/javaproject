package egovframework.order.mapper;

import egovframework.order.vo.OrderReceiptVO;
import egovframework.order.vo.OrderReceiptItemVO;
import org.apache.ibatis.annotations.Param;
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
    void insertReceipt(OrderReceiptVO vo);
    void insertReceiptItem(OrderReceiptItemVO vo);

    // 결재 문서 중복 체크
    int countByDocId(Long docId);

    // 검증 대기 목록 (PENDING OCR 주문)
    List<OrderReceiptVO> selectPendingList();

    // 중복 의심 체크
    int countDuplicate(@Param("partnerName") String partnerName,
                       @Param("totalAmount") double totalAmount,
                       @Param("excludeId")  Long excludeId);

    // 상태만 변경 (REJECTED 용)
    void updateStatus(@Param("receiptId") Long receiptId,
                      @Param("status")    String status);

    // ★ 확정: CONFIRMED + confirmedNo 동시 저장
    void confirmReceipt(@Param("receiptId")   Long receiptId,
                        @Param("confirmedNo") String confirmedNo);

    // 상품 라인 수정
    void updateReceiptItem(OrderReceiptItemVO vo);
}