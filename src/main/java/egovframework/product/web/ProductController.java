package egovframework.product.web;

import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import egovframework.product.vo.SalesVO;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
public class ProductController {

    @Autowired
    private ProductService productService;

    // ── 상품 관리 ──────────────────────────────────
    @GetMapping("/product/list.do")
    public String productList(@ModelAttribute ProductVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("productList", productService.getProductList(vo));
        model.addAttribute("totalCount",  productService.getProductCount(vo));
        model.addAttribute("searchVO", vo);
        return "product/productList";
    }

    @PostMapping("/product/insert.do")
    public String productInsert(@ModelAttribute ProductVO vo, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        vo.setIsActive(1);
        productService.addProduct(vo);
        return "redirect:/product/list.do";
    }

    @PostMapping("/product/update.do")
    public String productUpdate(@ModelAttribute ProductVO vo, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        productService.modifyProduct(vo);
        return "redirect:/product/list.do";
    }

    @PostMapping("/product/delete.do")
    public String productDelete(@RequestParam Long productId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        productService.removeProduct(productId);
        return "redirect:/product/list.do";
    }

    @GetMapping("/product/detail.do")
    @ResponseBody
    public ProductVO productDetail(@RequestParam Long productId) {
        return productService.getProduct(productId);
    }

    // ── 판매 현황 ──────────────────────────────────
    @GetMapping("/sales/list.do")
    public String salesList(@ModelAttribute SalesVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("salesList",  productService.getSalesList(vo));
        model.addAttribute("totalCount", productService.getSalesCount(vo));
        model.addAttribute("searchVO", vo);
        return "product/salesList";
    }

    @PostMapping("/sales/insert.do")
    public String salesInsert(@ModelAttribute SalesVO vo, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        vo.setCreatedBy(loginUser.getMemberId());
        if (vo.getStatus() == null || vo.getStatus().isEmpty()) vo.setStatus("DRAFT");
        productService.addSales(vo);
        return "redirect:/sales/list.do";
    }

    // ── 재고 현황 ──────────────────────────────────
    @GetMapping("/stock/list.do")
    public String stockList(@ModelAttribute ProductVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("stockList",     productService.getStockList(vo));
        model.addAttribute("totalCount",    productService.getStockCount(vo));
        model.addAttribute("lowStockCount", productService.getLowStockCount());
        model.addAttribute("searchVO", vo);
        return "product/stockList";
    }

    @PostMapping("/stock/update.do")
    public String stockUpdate(@ModelAttribute ProductVO vo, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        productService.modifyStock(vo);
        return "redirect:/stock/list.do";
    }
}
