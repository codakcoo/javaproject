package egovframework.login.web;

import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;


@Controller
public class LoginController 
{
	// 서비스 주입
	@Autowired
	private MemberService memberService;
	
	

	// 1. 로그인 화면 띄우기 (Get요청)
	@GetMapping("/login.do")
	public String loginForm()
	{
		// views 폴더 안의 loginForm.jsp를 찾아 화면에 뿌림
		return "login/loginForm";
	}
	
	// 2. 로그인 버튼 눌렀을 때 처리 (Post요청)
	@PostMapping("/loginProcess.do")
	public String LoginProcess(@RequestParam("id") String id,
							@RequestParam("pw") String pw,
							HttpSession session,
							Model model)
	{
		// 테스트용
		/*
		 * if("admin".equals(id) && "1234".equals(pw)) { // 성공: 세션에 로그인 정보를 저장 (상태 유지)
		 * session.setAttribute("loginUser", id); return "redirect:/main.do"; } else {
		 * // 실패: 에러 메시지를 Model에 담앙 다시 로그인 화면으로 보냄 model.addAttribute("errorMsg",
		 * "아이디 또는 비밀번호가 틀렸습니다."); return "login/loginForm"; }
		 */
		// DB조회
		MemberVO member = memberService.login(id, pw);
		
		if(member != null)
		{
			// VO 통째로 세션 저장
			session.setAttribute("loginUser", member);
			return "redirect:/main.do";
		}
		else
		{
			model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
			return "login/loginForm";
		}
	}
	
	// 3. 로그인 성공 시 보게 될 메인 페이지
	@GetMapping("/main.do")
	public String mainPage(HttpSession session)
	{
		// 테스트용
		/*
		 * // 세션에 'loginUser' 값이 있는지 확인 String userId =
		 * (String)session.getAttribute("loginUser");
		 * 
		 * if(userId == null) { // 로그인을 안 하고 주소창에 /main.do를 치고 들어온 경우 쫓아냄 return
		 * "redirect:/login.do"; } // main.jsp로 이동 return "login/main";
		 */
		MemberVO loginUser = (MemberVO)session.getAttribute("loginUser");
		if(loginUser == null)
		{
			return "redirect:/login.do";
		}
		return "login/main";
	}
	
	// 4. 회원가입 폼 화면 (Get요청)
	@GetMapping("/register.do")
	public String registerForm()
	{
	    return "login/register";
	}

	// 5. 회원가입 처리 (Post요청)
	@PostMapping("/registerProcess.do")
	public String registerProcess(@ModelAttribute MemberVO member, Model model)
	{
	    memberService.register(member);
	    return "redirect:/login.do";
	}
	
	
	@GetMapping("/logout.do")
	public String logout(HttpSession session)
	{
		// 세션 전체 삭제
		session.invalidate();
		return "redirect:/login.do";
	}
}
