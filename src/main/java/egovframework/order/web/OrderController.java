package egovframework.order.web;

import egovframework.order.service.OrderReceiptService;
import egovframework.order.vo.OrderReceiptVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderReceiptService orderReceiptService;

    // ── 주문 목록 ──────────────────────────────
    @GetMapping("/list.do")
    public String orderList(@ModelAttribute OrderReceiptVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("receiptList", orderReceiptService.getReceiptList(vo));
        model.addAttribute("totalCount",  orderReceiptService.getReceiptCount(vo));
        model.addAttribute("searchVO",    vo);
        return "order/orderList";
    }

    // ── 영수증 상세 (팝업 or 페이지) ───────────
    @GetMapping("/receipt.do")
    public String orderReceipt(@RequestParam Long receiptId, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("receipt", orderReceiptService.getReceipt(receiptId));
        return "order/orderReceipt";
    }
}