package com.moopi.mvc.web.payment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.moopi.mvc.service.domain.Payment;
import com.moopi.mvc.service.domain.User;
import com.moopi.mvc.service.payment.impl.PaymentServiceImpl;
import com.moopi.mvc.service.user.impl.UserServiceImpl;

@Controller
@RequestMapping("/payment/*")
public class PaymentController {

	@Autowired
	private PaymentServiceImpl paymentService;
	
	@Autowired
	private UserServiceImpl userService;
	
	public PaymentController() {
		System.out.println(this.getClass());
	}
	
//	@RequestMapping("addPayment")
//	public String addPayment(@ModelAttribute("payment") 
//				Payment payment, @RequestParam("userId") String userId) throws Exception{
//		
//		System.out.println("addPayment Start::");
//		User user = new User();
//		user.setUserId(userId);
//		payment.setPaymentUserId(user);
//		
//		System.out.println("addPayment End::");
//		
//		return "payment/addPayment";
//	}
	
	@RequestMapping("addPaymentView")
	public String addPaymentView(@ModelAttribute("payment") 
				Payment payment )throws Exception{
		
		System.out.println("addPaymentView Start::");
		//model.addAttribute("userId",userId);
		
		System.out.println("addPaymentView End::");
		
		return "payment/addPayment";
	}
	
}
