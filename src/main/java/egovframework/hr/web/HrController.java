package egovframework.hr.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/hr")
public class HrController {

    /** 직원 목록 */
    @GetMapping("/list.do")
    public String empList(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "hr/empList";
    }

    /** 직원 등록 폼 */
    @GetMapping("/insertForm.do")
    public String insertForm(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "hr/empForm";
    }

    /** 직원 수정 폼 */
    @GetMapping("/updateForm.do")
    public String updateForm(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "hr/empForm";
    }
}
