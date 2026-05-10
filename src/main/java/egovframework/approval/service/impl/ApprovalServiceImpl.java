package egovframework.approval.service.impl;

import egovframework.approval.mapper.ApprovalMapper;
import egovframework.approval.service.ApprovalService;
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import egovframework.order.service.OrderReceiptService;
import egovframework.product.mapper.ProductMapper;
import egovframework.product.vo.ProductVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ApprovalServiceImpl implements ApprovalService {

    @Autowired private ApprovalMapper      approvalMapper;
    @Autowired private OrderReceiptService orderReceiptService;
    @Autowired private ProductMapper       productMapper;  // ← 주문 생성 서비스

    @Override
    public List<ApprovalDocVO> getApprovalList(ApprovalDocVO vo) {
        return approvalMapper.selectApprovalList(vo);
    }

    @Override
    public int getApprovalCount(ApprovalDocVO vo) {
        return approvalMapper.selectApprovalCount(vo);
    }

    @Override
    public Map<String, Object> getStatusCounts() {
        return approvalMapper.selectStatusCounts();
    }

    @Override
    public ApprovalDocVO getApproval(Long docId) {
        ApprovalDocVO doc = approvalMapper.selectApproval(docId);
        if (doc != null) {
            doc.setItems(approvalMapper.selectApprovalItems(docId));
        }
        return doc;
    }

    @Override
    public List<ApprovalDocItemVO> getApprovalItems(Long docId) {
        return approvalMapper.selectApprovalItems(docId);
    }

    @Override
    @Transactional
    public void addApproval(ApprovalDocVO vo) {
        String docNo = "AP-" + new SimpleDateFormat("yyyyMMdd-HHmmss").format(new Date());
        vo.setDocNo(docNo);
        approvalMapper.insertApprovalDoc(vo);
        if (vo.getItems() != null) {
            for (ApprovalDocItemVO item : vo.getItems()) {
                item.setDocId(vo.getDocId());
                approvalMapper.insertApprovalItem(item);
            }
        }
    }

    @Override
    public void changeStatus(Long docId, String status, String approverId, String reason) {
        ApprovalDocVO vo = new ApprovalDocVO();
        vo.setDocId(docId);
        vo.setStatus(status);
        vo.setApproverId(approverId);
        vo.setRejectReason(reason);
        approvalMapper.updateApprovalStatus(vo);
    }

    @Override
    @Transactional
    public void approveApproval(Long docId, String approverId) {
        // 1. 상태 APPROVED로 변경
        changeStatus(docId, "APPROVED", approverId, null);

        // 2. 결재 문서 + 상품 라인 조회
        ApprovalDocVO doc = approvalMapper.selectApproval(docId);
        if (doc == null) return;

        // 3. 주문 영수증 자동 생성
        orderReceiptService.createFromApproval(doc);
        long receiptId = 0; // 영수증 ID는 stock_movement ref용

        // 4. 재고 반영 (INBOUND: +, OUTBOUND: -, STOCK_ADJ: ±)
        applyInventory(doc, approverId);
    }

    /**
     * 결재 승인 시 inventory.qty_on_hand 반영 + stock_movement 이력 생성
     */
    private void applyInventory(ApprovalDocVO doc, String approverId) {
        if (doc.getItems() == null || doc.getItems().isEmpty()) return;

        // MAIN 창고 ID 조회
        Long mainWarehouseId = productMapper.selectMainWarehouseId();
        if (mainWarehouseId == null) return;

        // doc_type 기반 movement_type 결정
        String movementType;
        double sign;  // 입고: +1, 출고: -1
        switch (doc.getDocType() != null ? doc.getDocType() : "") {
            case "INBOUND":
                movementType = "INBOUND";  sign = 1;   break;
            case "OUTBOUND":
                movementType = "OUTBOUND"; sign = -1;  break;
            case "STOCK_ADJ":
                movementType = "ADJUST";   sign = 1;   break;
            default:
                return;
        }

        for (ApprovalDocItemVO item : doc.getItems()) {
            if (item.getProductId() == null) continue;

            double qtyDelta = item.getQty() != null ? item.getQty() * sign : 0;

            // inventory qty_on_hand 업데이트
            ProductVO pvo = new ProductVO();
            pvo.setProductId(item.getProductId());
            pvo.setWarehouseId(mainWarehouseId);
            pvo.setQtyDelta(qtyDelta);
            productMapper.updateInventoryQty(pvo);

            // stock_movement 이력 INSERT
            pvo.setMovementType(movementType);
            pvo.setUnitCost(item.getUnitCost() != null ? item.getUnitCost() : 0);
            pvo.setRefOrderType(doc.getDocType());
            pvo.setRemarks(doc.getTitle());
            pvo.setCreatedBy(approverId);
            productMapper.insertStockMovement(pvo);
        }
    }

    @Override
    public void rejectApproval(Long docId, String approverId, String reason) {
        changeStatus(docId, "REJECTED", approverId, reason);
    }

    @Override
    @Transactional
    public void removeApproval(Long docId) {
        approvalMapper.deleteApprovalItems(docId);
        approvalMapper.deleteApprovalDoc(docId);
    }
}