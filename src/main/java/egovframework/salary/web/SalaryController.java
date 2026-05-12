package egovframework.salary.web;

import egovframework.member.vo.MemberVO;
import egovframework.salary.service.SalaryService;
import egovframework.salary.vo.SalaryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/salary")
public class SalaryController {

    @Autowired
    private SalaryService salaryService;

    /** 급여 목록 (ADMIN/운영팀만) */
    @GetMapping("/list.do")
    public String salaryList(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        // ADMIN 또는 운영팀만 접근 가능
        if (!loginUser.getRole().equals("ADMIN") && !("운영팀".equals(loginUser.getDepartment()))) {
            return "redirect:/main.do";
        }
        List<SalaryVO> salaryList = salaryService.getSalaryList();
        model.addAttribute("salaryList", salaryList);
        return "salary/salaryList";
    }

    /** 내 급여 조회 (본인만) */
    @GetMapping("/my.do")
    public String mySalary(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        SalaryVO salary = salaryService.getSalaryByMemberId(loginUser.getMemberId());
        model.addAttribute("salary", salary);
        return "salary/mySalary";
    }
}