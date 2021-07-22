package com.moopi.mvc.web.moim;

import java.io.File;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.moopi.mvc.common.Search;
import com.moopi.mvc.service.common.impl.CommonServiceImpl;
import com.moopi.mvc.service.domain.Flash;
import com.moopi.mvc.service.domain.Moim;
import com.moopi.mvc.service.domain.Notice;
import com.moopi.mvc.service.domain.User;
import com.moopi.mvc.service.moim.impl.MoimServiceImpl;
import com.moopi.mvc.service.user.impl.UserServiceImpl;

@Controller
@RequestMapping("/moim/*")
public class MoimController {
	
	@Autowired
	private MoimServiceImpl moimService;

	@Autowired
	private UserServiceImpl userService;
	
	@Autowired
	private CommonServiceImpl commonService;
	
	public static final String saveDir = ClassLoader.getSystemResource("./static/").getPath().
			substring(0, ClassLoader.getSystemResource("./static/").getPath().lastIndexOf("bin"))
			+"src/main/resources/static/images/uploadFiles";
	
	//모임상세조회
	@RequestMapping("getMoim")
	public String getMoim(@RequestParam("mmNo") int mmNo, Model model) throws Exception{
		
		System.out.println("getMoim :::");
//		System.out.println(userId);
//		System.out.println(userMapper.getUser(userId));
		Moim moim = moimService.getMoim(mmNo);
		System.out.println(moim);
		
		model.addAttribute("moim", moimService.getMoim(mmNo));
		return "moim/getMoim";
	}
	
	//모임생성페이지창, 단순네비게이션
	@RequestMapping("addMoimView")
	public String addMoimView(@RequestParam("userId") String userId, Model model) throws Exception{
		
		System.out.println("addMoimView...");
		model.addAttribute("userId", userId);
		return "moim/addMoimView";
}
	
	//모임생성 B/L 실행 -> 생성자를 바로 모임장으로 넣어주기 위해 newApply 메서드 추가함
	@RequestMapping("addMoim")
	public String addMoim(@ModelAttribute("moim") Moim moim
			,MultipartFile uploadFile, Model model,
			@RequestParam("userId") String userId) throws Exception{
		System.out.println("모임을생성할게");
		String oriFileName = uploadFile.getOriginalFilename();
		System.out.println(oriFileName);
		long currentTime = System.currentTimeMillis();
		try {
			uploadFile.transferTo(new File(saveDir+"/"+currentTime+oriFileName));
		}catch(Exception e) {
			e.printStackTrace();
		}
		moim.setMmFile(currentTime+oriFileName);
		User user = userService.getUser(userId);
		moim.setMmConstructor(user);
		moimService.addMoim(moim);
		System.out.println("방금생성한 모임의 mmNO::::"+moim.getMmNo());
		moimService.newApplyMoim(userId, moim.getMmNo());
		System.out.println("생성자를 해당 모임의 모임장으로 설정 완료");
		System.out.println("모임생성완료");
		return "forward:/moim/listMoim";
	}
	
	//방금 모임을 생성한 유저를 그 모임의 모임장으로 만드는 메서드...
//	@RequestMapping("newApply")
//	public String newApply(Model model) throws Exception{
//		System.out.println(":::::::뉴어플라이에 도착했을까:::::::");
//		String userId = (String)model.getAttribute("userId");
//		System.out.println("유저아이디값 : "+userId);
//		String mmName = (String)model.getAttribute("mmName");
//		System.out.println("모임명:" +mmName);
//		Moim moim = moimService.getMoim2(mmName);
//		System.out.println("::::::::::::뉴어플라이에서 찾은 모임남바 : "+moim.getMmNo());
//		moimService.newAplyMoim(userId, moim.getMmNo());
//		return "redirect:/moim/listMoim";
//	}
	
	//모임수정페이지로 이동, 단순네비게이션
	@RequestMapping("updateMoimView")
	public String updateMoimView(@RequestParam("mmNo") int mmNo, Model model) {
		Moim moim = moimService.getMoim(mmNo);
		model.addAttribute("moim", moim);
		return "moim/updateMoimView";
	}
	
	//모임수정 B/L 실행
	@RequestMapping("updateMoim")
	public String updateMoim(@ModelAttribute("moim") Moim moim,
							MultipartFile uploadFile,
							@RequestParam("userId") String userId) throws Exception {
		
		System.out.println("모임을수정할게");
		long currentTime = System.currentTimeMillis();
		if(uploadFile.getSize() > 0) {
			try {
				System.out.println("수정할파일이있는경우");
				String oriFileName = uploadFile.getOriginalFilename();
				System.out.println("오리지널파일명::::::: "+oriFileName);
				moim.setMmFile(currentTime+oriFileName);	
				uploadFile.transferTo(new File(saveDir+"/"+currentTime+oriFileName));
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
			User user = new User();
			user.setUserId(userId);
			moim.setMmConstructor(user);
			moimService.updateMoim(moim);
			System.out.println("모임수정완료");
			return "redirect:/moim/listMoim";
	}
	
	
	//모임리스트 가져오기 토탈카운트 포함
	@RequestMapping("listMoim")
	public String getListMoim(@ModelAttribute("search") Search search, Model model) throws Exception{
		
		System.out.println("모임리스트를 가져옵니다.");
		Map<String, Object> map = moimService.getMoimList(search);
		model.addAttribute("list", map.get("list"));
		model.addAttribute("search", search);
		System.out.println("forward:/moim/moimMain 으로 이동합니다.");
		return "moim/moimMain";
	}
	
	
	@RequestMapping("myListMoim")
	public String getMyListMoim(@RequestParam("userId") String userId, Model model) throws Exception{
		
		System.out.println("내가 가입한 모임리스트를 가져옵니다.");
		Map<String, Object> map = moimService.getMyMoimList(userId);
		model.addAttribute("list", map.get("list"));
		
		System.out.println("forward:/moim/myMoimMain 으로 이동합니다.");
		return "moim/myMoimMain";
	}
	
	
	//초대리스트 가져오기 
		@RequestMapping("listInvite")
		public String getListInvite(Search search, Model model) throws Exception{
			
			System.out.println("초대리스트를 가져옵니다.");
			//Map<String, Object> map = moimService.getMoimList(search);
			search.setSearchCondition(1);
			search.setSearchKeyword("중구");
			System.out.println(search);
			Map<String, Object> map = userService.getUserList(search, 1);
			model.addAttribute("list", map.get("list"));
			model.addAttribute("search", search);
			return "moim/listInvite";
		}
	
	
	
	//모임 가입신청하기
	@RequestMapping("applyMoim")
	public String applyMoim(@RequestParam("userId") String userId,
	@RequestParam("mmNo") int mmNo) throws Exception {
		System.out.println("모임 가입신청을 합니다.");
		moimService.applyMoim(userId, mmNo);
		return "forward:/moim/getMoim";
	}
	
	//모임 탈퇴하기
	@RequestMapping("leaveMoim")
	public String leaveMoim(@RequestParam("userId") String userId,
	@RequestParam("mmNo") int mmNo) throws Exception {
		System.out.println("모임 가입탈퇴를 합니다.");
		moimService.leaveMoim(userId, mmNo);
		return "forward:모임상세조회페이지";
	}
	
	//가입신청 거절하기
	@RequestMapping("refuseApply")
	public String refuseApply(@RequestParam("memberNo") int memberNo,
			@RequestParam("mmNo") int mmNo) throws Exception {
		System.out.println("가입신청을 거절 합니다.");
		moimService.refuseApply(memberNo);
		return "redirect:/moim/listMember?mmNo="+mmNo+"&status=1";
	}
	
	//멤버 권한변경(가입신청수락, 매니저권한위임및박탈)
	@RequestMapping("updateMember")
	public String updateMember(@RequestParam("userId") String userId,
	@RequestParam("mmNo") int mmNo,
	@RequestParam("status") int status) throws Exception {
		System.out.println("멤버 권한변경을 합니다.");
		moimService.updateMemeber(userId, mmNo, status);
		
		// 알림
		System.out.println("moim Notice");
		Notice notice = new Notice();
		Moim moim = new Moim();
		moim.setMmNo(mmNo);
		notice.setToUserId(userId); // 알림대상
		notice.setNoticeContent("가입되었습니다");
		notice.setMoim(moim);
		notice.setNoticeType("4");
		commonService.addNotice(notice);
		//
		
		return "redirect:/moim/listMember?mmNo="+mmNo+"&status="+status;
	}
	
	//멤버 리스트 조회하기
	@RequestMapping("listMember")
	public String getListMember(@RequestParam("mmNo") int mmNo,
			@RequestParam("status") int status, Model model) throws Exception{
		
		System.out.println("멤버리스트를 가져옵니다.");
		Map<String, Object> map = moimService.getMemberList(mmNo, status);
		model.addAttribute("list", map.get("list"));
		if(status == 1) {
			return "moim/listApply";
		}else {
			return "moim/listMember";	
		}
	}
	
	@RequestMapping("map")
	public String getMap() throws Exception{
		
		System.out.println("맵을 연다.");
			return "moim/map";	
	}
	
	
}
