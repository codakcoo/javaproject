package egovframework.approval.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

    /** 결재 목록 */
    @GetMapping("/list.do")
    public String approvalList(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "approval/approvalList";
    }

    /** 결재 팝업 폼 */
    @GetMapping("/form.do")
    public String approvalForm(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "approval/approvalForm";
    }
}
