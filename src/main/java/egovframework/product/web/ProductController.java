package egovframework.product.web;

import egovframework.member.vo.MemberVO;
import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import egovframework.product.vo.SalesVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@Controller
public class ProductController {

    @Autowired
    private ProductService productService;

    // 카테고리 접두어 매핑 (DB 조회 없이 Controller에서 직접 처리)
    private static final Map<String, String> PREFIX_MAP = new HashMap<String, String>() {{
        put("식품",   "FOOD");
        put("전자",   "ELEC");
        put("소모품", "CONS");
        put("원자재", "RAW");
        put("기타",   "ETC");
    }};

    private boolean isNotLoggedIn(HttpSession session) {
        return session.getAttribute("loginUser") == null;
    }

    // ── 상품 관리 ──────────────────────────────────
    @GetMapping("/product/list.do")
    public String productList(@ModelAttribute ProductVO vo, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        model.addAttribute("productList", productService.getProductList(vo));
        model.addAttribute("totalCount",  productService.getProductCount(vo));
        model.addAttribute("searchVO", vo);
        return "product/productList";
    }

    @PostMapping("/product/insert.do")
    public String productInsert(@ModelAttribute ProductVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        vo.setIsActive(1);
        productService.addProduct(vo);
        return "redirect:/product/list.do";
    }

    @PostMapping("/product/update.do")
    public String productUpdate(@ModelAttribute ProductVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        productService.modifyProduct(vo);
        return "redirect:/product/list.do";
    }

    @PostMapping("/product/delete.do")
    public String productDelete(@RequestParam Long productId, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        productService.removeProduct(productId);
        return "redirect:/product/list.do";
    }

    @GetMapping("/product/detail.do")
    @ResponseBody
    public String productDetail(@RequestParam Long productId, HttpSession session) {
        if (isNotLoggedIn(session)) return "UNAUTHORIZED";
        ProductVO p = productService.getProduct(productId);
        if (p == null) return "NOT_FOUND";
        return "{"
            + "\"productId\":"     + p.getProductId()   + ","
            + "\"productCode\":\"" + esc(p.getProductCode()) + "\","
            + "\"productName\":\"" + esc(p.getProductName()) + "\","
            + "\"category\":\""   + esc(p.getCategory())     + "\","
            + "\"unit\":\""       + esc(p.getUnit())          + "\","
            + "\"unitCost\":"     + p.getUnitCost()           + ","
            + "\"reorderPoint\":" + p.getReorderPoint()       + ","
            + "\"reorderQty\":"   + p.getReorderQty()         + ","
            + "\"isActive\":"     + p.getIsActive()
            + "}";
    }

    /**
     * 카테고리 선택 시 다음 상품코드 자동 채번
     * - DB 조회 없이 현재 목록에서 JS가 계산하도록 prefix만 반환
     * - 예외 발생 지점을 없애기 위해 완전히 단순화
     */
    @GetMapping("/product/nextCode.do")
    public void nextProductCode(@RequestParam(defaultValue = "") String category,
                                HttpSession session,
                                HttpServletResponse response) {
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = null;
        try {
            out = response.getWriter();
            if (isNotLoggedIn(session)) {
                out.print("UNAUTHORIZED");
                return;
            }
            String prefix = PREFIX_MAP.containsKey(category)
                    ? PREFIX_MAP.get(category) : "ETC";

            // DB에서 마지막 번호 조회 시도, 실패하면 001 반환
            String nextCode;
            try {
                nextCode = productService.generateNextProductCode(category);
            } catch (Exception e) {
                nextCode = prefix + "-001";
            }
            out.print(nextCode);
        } catch (Exception e) {
            response.setStatus(500);
        } finally {
            if (out != null) out.flush();
        }
    }

    // ── 판매 현황 ──────────────────────────────────
    @GetMapping("/sales/list.do")
    public String salesList(@ModelAttribute SalesVO vo, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        model.addAttribute("salesList",  productService.getSalesList(vo));
        model.addAttribute("totalCount", productService.getSalesCount(vo));
        model.addAttribute("searchVO", vo);
        return "product/salesList";
    }

    @PostMapping("/sales/insert.do")
    public String salesInsert(@ModelAttribute SalesVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        vo.setCreatedBy(loginUser.getMemberId());
        if (vo.getStatus() == null || vo.getStatus().isEmpty()) vo.setStatus("DRAFT");
        productService.addSales(vo);
        return "redirect:/sales/list.do";
    }

    // ── 재고 현황 ──────────────────────────────────
    @GetMapping("/stock/list.do")
    public String stockList(@ModelAttribute ProductVO vo,
                            @RequestParam(value = "includeDefect", required = false) String includeDefect,
                            Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        vo.setIncludeDefect(includeDefect);
        int lowStockCount  = productService.getLowStockCount();
        int normalOnlyCount = productService.getStockCount(vo); // 불량 제외 전체 (검색 조건 반영)
        if ("Y".equals(includeDefect)) {
            model.addAttribute("stockList",  productService.getStockListAll(vo));
            model.addAttribute("totalCount", productService.getStockCountAll(vo));
        } else {
            model.addAttribute("stockList",  productService.getStockList(vo));
            model.addAttribute("totalCount", normalOnlyCount);
        }
        model.addAttribute("lowStockCount",  lowStockCount);
        model.addAttribute("normalCount",    normalOnlyCount - lowStockCount); // 불량 제외 정상 재고
        model.addAttribute("searchVO", vo);
        return "product/stockList";
    }

    @PostMapping("/stock/update.do")
    public String stockUpdate(@ModelAttribute ProductVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        productService.modifyStock(vo);
        return "redirect:/stock/list.do";
    }

    private String esc(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
