package egovframework.login.web;

import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import egovframework.dept.service.DeptService;



@Controller
public class LoginController {
	@Autowired
	private DeptService deptService;
    @Autowired
    private MemberService memberService;

    /** 로그인 화면 */
    @GetMapping("/login.do")
    public String loginForm() {
        return "login/loginForm";
    }

    /** 로그인 처리 */
    @PostMapping("/loginProcess.do")
    public String loginProcess(@RequestParam("id") String id,
                               @RequestParam("pw") String pw,
                               HttpSession session,
                               Model model) {
        MemberVO member = memberService.login(id, pw);
        if (member != null) {
            session.setAttribute("loginUser", member);
            return "redirect:/main.do";
        }
        model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
        return "login/loginForm";
    }

    /** 메인(대시보드) */
    @GetMapping("/main.do")
    public String mainPage(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "login/main";
    }

    /** 회원가입 폼 */
    @GetMapping("/register.do")
  
    public String registerForm(Model model) {
        model.addAttribute("deptList", deptService.getDeptList());
        return "login/register";
    }

    /** 회원가입 처리 */
    @PostMapping("/registerProcess.do")
    public String registerProcess(@ModelAttribute MemberVO member, Model model) {
        if (memberService.isDuplicateId(member.getMemberId())) {
            model.addAttribute("errorMsg", "이미 사용 중인 아이디입니다.");
            return "login/register";
        }
        memberService.register(member);
        return "redirect:/login.do";
    }

    /** 로그아웃 */
    @GetMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login.do";
    }
}
