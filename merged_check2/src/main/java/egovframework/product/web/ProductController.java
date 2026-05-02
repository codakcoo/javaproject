package egovframework.product.web;

import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    // 목록
    @GetMapping("/list.do")
    public String list(ProductVO vo, Model model) {
        model.addAttribute("productList", productService.selectProductList(vo));
        model.addAttribute("searchVO", vo);
        return "product/productList";
    }

    // 등록 폼
    @GetMapping("/insertForm.do")
    public String insertForm() {
        return "product/productForm";
    }

    /**
     * 카테고리 선택 시 자동 상품코드 생성 (Ajax)
     * GET /product/generateCode.do?category=식품 → "FOOD-001"
     */
    @GetMapping("/generateCode.do")
    @ResponseBody
    public String generateCode(@RequestParam String category) {
        return productService.generateProductCode(category);
    }

    // 등록 처리
    @PostMapping("/insert.do")
    public String insert(@ModelAttribute ProductVO vo) {
        productService.insertProduct(vo);
        return "redirect:/product/list.do";
    }

    // 수정 폼
    @GetMapping("/updateForm.do")
    public String updateForm(@RequestParam Long productId, Model model) {
        model.addAttribute("product", productService.selectProduct(productId));
        return "product/productForm";
    }

    // 수정 처리
    @PostMapping("/update.do")
    public String update(@ModelAttribute ProductVO vo) {
        productService.updateProduct(vo);
        return "redirect:/product/list.do";
    }

    // 삭제 (비활성화)
    @PostMapping("/delete.do")
    public String delete(@RequestParam Long productId) {
        productService.deleteProduct(productId);
        return "redirect:/product/list.do";
    }
}
