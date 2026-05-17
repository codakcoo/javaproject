// ── OrderReceiptService.java ─────────────────────────────────────────
package egovframework.order.service;
 
import egovframework.order.vo.OrderReceiptVO;
import egovframework.order.vo.OrderReceiptItemVO;
import egovframework.approval.vo.ApprovalDocVO;
import java.util.List;
 
public interface OrderReceiptService {
    List<OrderReceiptVO> getReceiptList(OrderReceiptVO vo);
    int getReceiptCount(OrderReceiptVO vo);
    OrderReceiptVO getReceipt(Long receiptId);
    List<OrderReceiptItemVO> getReceiptItems(Long receiptId);
 
    // 결재 승인 시 자동 호출
    void createFromApproval(ApprovalDocVO doc);
}