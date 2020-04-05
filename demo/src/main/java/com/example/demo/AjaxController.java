package com.example.demo;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dao.AjaxDao;
import com.example.demo.dto.LoginDto;

@RestController
public class AjaxController {
	
	@Autowired
	AjaxDao ajaxDao;
	
	@GetMapping(value = "/rest_idchk")
	public int getAjax(Model model, @RequestParam("id") String id, @RequestParam("pw") String pwd) throws Exception {
		
		System.out.println("아이디값: " + id);
		System.out.println("비밀번호값: " + pwd);
		
		int result = ajaxDao.login(id, pwd);
		
		System.out.println("결과값: " + result );
		
		return result;
	}

	
	@PostMapping(value = "/rest_idchk")
	public String PostAjax(@RequestBody String text
			//@ModelAttribute LoginDto param
			//@ModelAttribute JSONObject param
			//@ModelAttribute Map<String, Object> paramMap 
	) throws Exception {
		
		String [] param = text.split(",");
		
		System.out.println(param[0]);
		System.out.println(param[1]);
		//System.out.println("아이디" + param.getUsername());
		//System.out.println("비밀번호" + param.getPassword());
		
		return "아이디" + param[0] + "비밀번호" + param[1];
	}
}
