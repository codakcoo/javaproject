package egovframework.approval.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

    // 결재 목록 → /approval/list.do
    @GetMapping("/list.do")
    public String approvalList(Model model) {
        return "approval/approvalList";
    }

    // 결재 팝업 폼 → /approval/form.do
    @GetMapping("/form.do")
    public String approvalForm() {
        return "approval/approvalForm";
    }
}