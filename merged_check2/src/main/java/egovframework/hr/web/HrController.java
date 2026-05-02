package egovframework.hr.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/hr")
public class HrController {

    // 직원 목록 → /hr/list.do
    @GetMapping("/list.do")
    public String empList(Model model) {
        // DB 연동 전까지는 빈 Model만 넘김
        // model.addAttribute("empList", hrService.selectEmpList());
        return "hr/empList";
    }

    // 직원 등록 폼 → /hr/insertForm.do
    @GetMapping("/insertForm.do")
    public String insertForm() {
        return "hr/empForm";
    }

    // 직원 수정 폼 → /hr/updateForm.do?empId=EMP001
    @GetMapping("/updateForm.do")
    public String updateForm() {
        // model.addAttribute("emp", hrService.selectEmployee(empId));
        return "hr/empForm";
    }
}