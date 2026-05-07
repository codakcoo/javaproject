// ── OrderReceiptServiceImpl.java ─────────────────────────────────────
package egovframework.order.service.impl;
 
import egovframework.approval.mapper.ApprovalMapper;
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import egovframework.order.mapper.OrderReceiptMapper;
import egovframework.order.service.OrderReceiptService;
import egovframework.order.vo.OrderReceiptVO;
import egovframework.order.vo.OrderReceiptItemVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
 
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
 
@Service
public class OrderReceiptServiceImpl implements OrderReceiptService {
 
    @Autowired private OrderReceiptMapper orderReceiptMapper;
    @Autowired private ApprovalMapper     approvalMapper;
 
    @Override
    public List<OrderReceiptVO> getReceiptList(OrderReceiptVO vo) {
        return orderReceiptMapper.selectReceiptList(vo);
    }
 
    @Override
    public int getReceiptCount(OrderReceiptVO vo) {
        return orderReceiptMapper.selectReceiptCount(vo);
    }
 
    @Override
    public OrderReceiptVO getReceipt(Long receiptId) {
        OrderReceiptVO receipt = orderReceiptMapper.selectReceipt(receiptId);
        if (receipt != null) {
            receipt.setItems(orderReceiptMapper.selectReceiptItems(receiptId));
        }
        return receipt;
    }
 
    @Override
    public List<OrderReceiptItemVO> getReceiptItems(Long receiptId) {
        return orderReceiptMapper.selectReceiptItems(receiptId);
    }
 
    @Override
    @Transactional
    public void createFromApproval(ApprovalDocVO doc) {
        // 이미 주문이 생성된 경우 중복 방지
        if (orderReceiptMapper.countByDocId(doc.getDocId()) > 0) return;
 
        // 주문번호 생성: ORD-YYYYMMDD-HHmmss
        String receiptNo = "ORD-" + new SimpleDateFormat("yyyyMMdd-HHmmss").format(new Date());
 
        // 상품 라인 조회 (approval_doc_item)
        List<ApprovalDocItemVO> approvalItems = approvalMapper.selectApprovalItems(doc.getDocId());
 
        // 합계 금액 계산
        double totalAmount = 0;
        for (ApprovalDocItemVO ai : approvalItems) {
            if (ai.getUnitCost() != null && ai.getQty() != null) {
                totalAmount += ai.getQty() * ai.getUnitCost();
            }
        }
 
        // 영수증 헤더 INSERT
        OrderReceiptVO receipt = new OrderReceiptVO();
        receipt.setReceiptNo(receiptNo);
        receipt.setDocId(doc.getDocId());
        receipt.setDocType(doc.getDocType());
        receipt.setPartnerName(doc.getPartnerName());
        receipt.setRequesterId(doc.getRequesterId());
        receipt.setApproverId(doc.getApproverId());
        receipt.setTotalAmount(totalAmount);
        orderReceiptMapper.insertReceipt(receipt);
 
        // 상품 라인 INSERT (approval_doc_item → order_receipt_item 복사, 상품명 비정규화)
        for (ApprovalDocItemVO ai : approvalItems) {
            OrderReceiptItemVO item = new OrderReceiptItemVO();
            item.setReceiptId(receipt.getReceiptId());
            item.setProductId(ai.getProductId());
            item.setProductCode(ai.getProductCode());
            item.setProductName(ai.getProductName());
            item.setUnit(ai.getUnit());
            item.setQty(ai.getQty());
            item.setUnitCost(ai.getUnitCost());
            if (ai.getUnitCost() != null && ai.getQty() != null) {
                item.setAmount(ai.getQty() * ai.getUnitCost());
            }
            orderReceiptMapper.insertReceiptItem(item);
        }
    }
}