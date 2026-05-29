package egovframework.ocr.web;

import egovframework.customer.mapper.CustomerMapper;
import egovframework.customer.vo.CustomerVO;
import egovframework.member.vo.MemberVO;
import egovframework.order.mapper.OrderReceiptMapper;
import egovframework.order.vo.OrderReceiptItemVO;
import egovframework.order.vo.OrderReceiptVO;
import egovframework.product.mapper.ProductMapper;
import egovframework.product.vo.ProductVO;
import egovframework.supplier.mapper.SupplierMapper;
import egovframework.supplier.vo.SupplierVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/ocr")
public class OcrVerifyController {

    @Autowired private OrderReceiptMapper orderReceiptMapper;
    @Autowired private ProductMapper      productMapper;
    @Autowired private SupplierMapper     supplierMapper;
    @Autowired private CustomerMapper     customerMapper;

    /* ────────────────────────────────────────────────────────
     * GET /ocr/verify.do
     * PENDING 주문 전체 조회 → 자바 로직으로 오류 검증 → 화면 전달
     * ──────────────────────────────────────────────────────── */
    @GetMapping("/verify.do")
    public String verifyList(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        // 1) PENDING OCR 주문 목록
        List<OrderReceiptVO> pendingList = orderReceiptMapper.selectPendingList();

        // 2) DB 상품·거래처 목록 (검증 기준)
        List<ProductVO>  products  = productMapper.selectProductList(new ProductVO());
        List<SupplierVO> suppliers = supplierMapper.selectSupplierList();
        List<CustomerVO> customers = customerMapper.selectCustomerList();

        // 3) 주문별 검증 결과 생성
        List<Map<String, Object>> verifyResults = new ArrayList<>();

        for (OrderReceiptVO r : pendingList) {
            List<OrderReceiptItemVO> items = orderReceiptMapper.selectReceiptItems(r.getReceiptId());
            r.setItems(items);

            List<String> errors   = new ArrayList<>();  // 반드시 수정해야 하는 오류
            List<String> warnings = new ArrayList<>();  // 주의가 필요한 경고

            // ── 검증 ①: 거래처 DB 존재 여부 ──────────────────────
            boolean partnerFound = false;
            String  partnerType  = "";
            if (r.getPartnerName() == null || r.getPartnerName().trim().isEmpty()) {
                errors.add("거래처명이 없습니다.");
            } else {
                for (SupplierVO s : suppliers) {
                    if (similarName(r.getPartnerName(), s.getSupplierName())) {
                        partnerFound = true; partnerType = "SUPPLIER"; break;
                    }
                }
                if (!partnerFound) {
                    for (CustomerVO c : customers) {
                        if (similarName(r.getPartnerName(), c.getCustomerName())) {
                            partnerFound = true; partnerType = "CUSTOMER"; break;
                        }
                    }
                }
                if (!partnerFound) {
                    warnings.add("거래처 [" + r.getPartnerName() + "] 이(가) DB에 없습니다. 신규 거래처이거나 오인식일 수 있습니다.");
                }
            }

            // ── 검증 ②: 문서유형 ↔ 거래처 유형 불일치 ───────────
            if (partnerFound) {
                if ("입고".equals(r.getDocType()) && "CUSTOMER".equals(partnerType)) {
                    warnings.add("입고 문서인데 거래처가 고객사로 등록되어 있습니다. 공급업체인지 확인하세요.");
                } else if ("출고".equals(r.getDocType()) && "SUPPLIER".equals(partnerType)) {
                    warnings.add("출고 문서인데 거래처가 공급업체로 등록되어 있습니다. 고객사인지 확인하세요.");
                }
            }

            // ── 검증 ③: 상품 라인 검증 ───────────────────────────
            if (items == null || items.isEmpty()) {
                errors.add("상품 라인이 없습니다. OCR 인식 결과를 확인하세요.");
            } else {
                double itemTotal = 0;
                for (OrderReceiptItemVO item : items) {
                    // 상품명 DB 매칭 여부
                    boolean productFound = false;
                    if (item.getProductId() != null) {
                        productFound = true; // 이미 매칭됨
                    } else {
                        for (ProductVO p : products) {
                            if (similarName(item.getProductName(), p.getProductName())) {
                                productFound = true; break;
                            }
                        }
                        if (!productFound) {
                            warnings.add("상품 [" + item.getProductName() + "] 이(가) DB에 없습니다.");
                        }
                    }

                    // 수량/단가 0원 체크
                    if (item.getQty() == null || item.getQty() <= 0) {
                        errors.add("상품 [" + item.getProductName() + "] 수량이 0이거나 없습니다.");
                    }
                    if (item.getUnitCost() == null || item.getUnitCost() < 0) {
                        errors.add("상품 [" + item.getProductName() + "] 단가가 올바르지 않습니다.");
                    }

                    itemTotal += (item.getAmount() != null ? item.getAmount() : 0);
                }

                // ── 검증 ④: 합계 금액 불일치 ───────────────────
                double headerTotal = r.getTotalAmount() != null ? r.getTotalAmount() : 0;
                if (headerTotal > 0 && Math.abs(headerTotal - itemTotal) > 1) {
                    errors.add(String.format(
                        "합계 금액 불일치: 헤더 %.0f원 ≠ 상품 합계 %.0f원", headerTotal, itemTotal));
                }
            }

            // ── 검증 ⑤: 오늘 중복 주문 의심 ───────────────────
            if (r.getPartnerName() != null && r.getTotalAmount() != null) {
                int dupCount = orderReceiptMapper.countDuplicate(
                    r.getPartnerName(), r.getTotalAmount(), r.getReceiptId());
                if (dupCount > 0) {
                    warnings.add("오늘 동일 거래처·금액으로 이미 확정된 주문이 " + dupCount + "건 있습니다. 중복 입력 여부를 확인하세요.");
                }
            }

            // 결과 종합
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("receipt",  r);
            res.put("errors",   errors);
            res.put("warnings", warnings);
            // 오류 없으면 GREEN, 경고만 있으면 YELLOW, 오류 있으면 RED
            String level = errors.isEmpty()
                ? (warnings.isEmpty() ? "OK" : "WARN")
                : "ERROR";
            res.put("level", level);
            verifyResults.add(res);
        }

        model.addAttribute("verifyResults", verifyResults);
        model.addAttribute("pendingCount",  pendingList.size());
        model.addAttribute("products",      productMapper.selectProductList(new ProductVO()));
        return "ocr/ocrVerify";
    }

    /* ────────────────────────────────────────────────────────
     * POST /ocr/confirm.do  (단건 확정)
     * POST /ocr/reject.do   (단건 반려)
     * POST /ocr/confirmAll.do (오류 없는 건 일괄 확정)
     * ──────────────────────────────────────────────────────── */
    @PostMapping("/confirm.do")
    @ResponseBody
    public String confirm(@RequestParam Long receiptId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "UNAUTHORIZED";
        // OCR-CONF-YYYYMMDDHHmmss-receiptId  (고유성 보장)
        String confirmedNo = "OCR-CONF-"
            + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())
            + "-" + receiptId;
        orderReceiptMapper.confirmReceipt(receiptId, confirmedNo);
        return "OK:" + confirmedNo;   // 프론트에서 confirmedNo 받아서 UI 갱신 가능
    }

    @PostMapping("/reject.do")
    @ResponseBody
    public String reject(@RequestParam Long receiptId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "UNAUTHORIZED";
        orderReceiptMapper.updateStatus(receiptId, "REJECTED");
        return "OK";
    }

    @PostMapping("/confirmAll.do")
    @ResponseBody
    public String confirmAll(@RequestBody List<Long> receiptIds, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "UNAUTHORIZED";
        String ts = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
        int count = 0;
        for (Long id : receiptIds) {
            String confirmedNo = "OCR-CONF-" + ts + "-" + id;
            orderReceiptMapper.confirmReceipt(id, confirmedNo);
            count++;
        }
        return "OK:" + count;
    }

    /* ────────────────────────────────────────────────────────
     * POST /ocr/updateItem.do  (상품 라인 수정 후 저장)
     * ──────────────────────────────────────────────────────── */
    @PostMapping("/updateItem.do")
    @ResponseBody
    public String updateItem(@RequestBody OrderReceiptItemVO vo, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "UNAUTHORIZED";
        try {
            orderReceiptMapper.updateReceiptItem(vo);
            return "OK";
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    /* ── 유사도 비교 (부분 포함 or 한글 초성 매칭) ──────────── */
    private boolean similarName(String ocrName, String dbName) {
        if (ocrName == null || dbName == null) return false;
        String a = ocrName.trim().toLowerCase().replaceAll("\\s+", "");
        String b = dbName .trim().toLowerCase().replaceAll("\\s+", "");
        // 어느 한쪽이 다른 쪽을 포함하면 매칭
        return a.contains(b) || b.contains(a);
    }
}