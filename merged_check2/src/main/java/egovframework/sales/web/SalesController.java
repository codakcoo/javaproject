package egovframework.sales.web;

import egovframework.customer.service.CustomerService;
import egovframework.customer.vo.CustomerVO;
import egovframework.member.vo.MemberVO;
import egovframework.sales.service.SalesOrderService;
import egovframework.sales.vo.SalesOrderVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/sales")
public class SalesController {

    @Autowired private SalesOrderService salesOrderService;
    @Autowired private CustomerService   customerService;

    // 수주서 목록
    @GetMapping("/list.do")
    public String list(SalesOrderVO vo, Model model) {
        model.addAttribute("salesList", salesOrderService.selectSalesOrderList(vo));
        model.addAttribute("searchVO", vo);
        return "sales/salesList";
    }

    // 등록 폼
    @GetMapping("/insertForm.do")
    public String insertForm(Model model) {
        model.addAttribute("customerList", customerService.selectCustomerList(new CustomerVO()));
        return "sales/salesForm";
    }

    // 등록 처리
    @PostMapping("/insert.do")
    public String insert(@ModelAttribute SalesOrderVO vo, HttpSession session) {
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        vo.setCreatedBy(loginUser.getMemberId());
        salesOrderService.insertSalesOrder(vo);
        return "redirect:/sales/list.do";
    }

    // 수정 폼
    @GetMapping("/updateForm.do")
    public String updateForm(@RequestParam Long soId, Model model) {
        model.addAttribute("salesOrder", salesOrderService.selectSalesOrder(soId));
        model.addAttribute("customerList", customerService.selectCustomerList(new CustomerVO()));
        return "sales/salesForm";
    }

    // 수정 처리
    @PostMapping("/update.do")
    public String update(@ModelAttribute SalesOrderVO vo) {
        salesOrderService.updateSalesOrder(vo);
        return "redirect:/sales/list.do";
    }

    // 상태 변경 (Ajax)
    @PostMapping("/updateStatus.do")
    @ResponseBody
    public String updateStatus(@RequestParam Long soId, @RequestParam String status) {
        salesOrderService.updateSalesOrderStatus(soId, status);
        return "ok";
    }
}
