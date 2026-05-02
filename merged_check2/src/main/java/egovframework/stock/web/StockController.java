package egovframework.stock.web;

import egovframework.inventory.service.InventoryService;
import egovframework.inventory.vo.InventoryVO;
import egovframework.member.vo.MemberVO;
import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import egovframework.stock.service.StockService;
import egovframework.stock.vo.StockMovementVO;
import egovframework.warehouse.service.WarehouseService;
import egovframework.warehouse.vo.WarehouseVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/stock")
public class StockController {

    @Autowired private StockService     stockService;
    @Autowired private InventoryService inventoryService;
    @Autowired private ProductService   productService;
    @Autowired private WarehouseService warehouseService;

    // 재고 현황
    @GetMapping("/list.do")
    public String inventoryList(InventoryVO vo, Model model) {
        model.addAttribute("inventoryList", inventoryService.selectInventoryList(vo));
        model.addAttribute("warehouseList", warehouseService.selectWarehouseList(new WarehouseVO()));
        model.addAttribute("searchVO", vo);
        return "stock/stockList";
    }

    // 입출고 이력
    @GetMapping("/movement.do")
    public String movementList(StockMovementVO vo, Model model) {
        model.addAttribute("movementList", stockService.selectMovementList(vo));
        model.addAttribute("warehouseList", warehouseService.selectWarehouseList(new WarehouseVO()));
        model.addAttribute("searchVO", vo);
        return "stock/movementList";
    }

    // 입출고 등록 폼
    @GetMapping("/movementForm.do")
    public String movementForm(Model model) {
        model.addAttribute("productList",   productService.selectProductList(new ProductVO()));
        model.addAttribute("warehouseList", warehouseService.selectWarehouseList(new WarehouseVO()));
        return "stock/movementForm";
    }

    // 입출고 등록 처리
    @PostMapping("/movementProcess.do")
    public String movementProcess(@ModelAttribute StockMovementVO vo, HttpSession session) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        vo.setCreatedBy(loginUser.getMemberId());
        stockService.processMovement(vo);
        return "redirect:/stock/movement.do";
    }
}
