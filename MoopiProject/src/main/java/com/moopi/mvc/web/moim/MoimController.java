package com.moopi.mvc.web.moim;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.moopi.mvc.common.Search;
import com.moopi.mvc.service.domain.Moim;
import com.moopi.mvc.service.moim.impl.MoimServiceImpl;

@Controller
@RequestMapping("/moim/*")
public class MoimController {
	
	@Autowired
	private MoimServiceImpl moimService;

	
	//모임상세조회
	@RequestMapping("getMoim")
	public String getMoim(@RequestParam("mmNo") int mmNo, Model model) throws Exception{
		
		System.out.println("getMoim :::");
//		System.out.println(userId);
//		System.out.println(userMapper.getUser(userId));
		Moim moim = moimService.getMoim(mmNo);
		System.out.println(moim);
		
		model.addAttribute("moim", moimService.getMoim(mmNo));
		return "forward:모임상세조회페이지";
	}
	
	//모임생성페이지창, 단순네비게이션
	@RequestMapping("addMoimView")
	public String addMoimView(@RequestParam("userId") String userId, Model model) throws Exception{
		
		System.out.println("addMoimView...");
		model.addAttribute("userId", userId);
		return "forward:모임생성페이지";
}
	
	//모임생성 B/L 실행
	@RequestMapping("addMoim")
	public String addMoim(@ModelAttribute("moim") Moim moim) throws Exception{
		moimService.addMoim(moim);
		System.out.println("모임생성완료");
		return "forward:모임메인페이지로이동";
	}
	
	//모임수정페이지로 이동, 단순네비게이션
	@RequestMapping("updateMoimView")
	public String updateMoimView(@RequestParam("mmNo") int mmNo, Model model) {
		model.addAttribute("mmNO", mmNo);
		return "forward:모임수정페이지로이동";
	}
	
	//모임수정 B/L 실행
	@RequestMapping("updateMoim")
	public String updateMoim(@ModelAttribute("moim") Moim moim) throws Exception {
		
		moimService.updateMoim(moim);
		System.out.println("모임수정이완료되었습니다");
		return "forward:메인페이지로이동";
	}
	
	
	//모임리스트 가져오기 토탈카운트 포함
	@RequestMapping("listMoim")
	public String getListMoim(@ModelAttribute("search") Search search, Model model) throws Exception{
		
		System.out.println("모임리스트를 가져옵니다.");
		Map<String, Object> map = moimService.getMoimList(search);
		model.addAttribute("list", map.get("list"));
		model.addAttribute("search", search);
		return "forward:모임리스트페이지로이동";
	}
}
