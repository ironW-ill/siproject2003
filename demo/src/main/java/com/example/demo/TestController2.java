package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dao.InfoDao;
import com.example.demo.dto.LawMakerDto;

@Controller
public class TestController2 {
	
	@Autowired
	InfoDao infodao;
	
	@RequestMapping("/testjsp")
	public String root() throws Exception {
		
		int testno = infodao.test();
		System.out.println("testno:" + testno);
		System.out.println("testno2:" + testno);
		System.out.println("testno3:" + testno);
		
		return "testjsp";
	}

	@RequestMapping(value = "/committee")
	public String committee(Model model) throws Exception {
		
		System.out.println("committee");
		
		return "committee/committee";
	}

	@RequestMapping(value = "/committeeDb")
	public String committeeDb(Model model) throws Exception {
		
		System.out.println("committeeDb");
		
		ArrayList<LawMakerDto> alist = infodao.selectLawmaker();
		List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();		
		
		for (int i = 0; i < alist.size(); i++) {
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			
			map.put("name", alist.get(i).getName());
			map.put("evaluation", alist.get(i).getEvaluation());
			map.put("party", alist.get(i).getParty());
			map.put("election", alist.get(i).getElection());
			map.put("electioncnt", alist.get(i).getElectioncnt());
			map.put("committee", alist.get(i).getCommittee());
			
			paramList.add(map);
		}
		
		JSONArray jarr = new JSONArray();
		jarr = getJsonArrayFromList(paramList);
		
		model.addAttribute("paramList", jarr);
		
		return "committee/committeeDb";
	}
	
	public JSONArray getJsonArrayFromList(List<Map<String, Object>> list) {
		JSONArray jsonArray = new JSONArray();

		for (Map<String, Object> map : list) {
			jsonArray.add(getJsonStringFromMap(map));
		}
		return jsonArray;
	}

	public JSONObject getJsonStringFromMap(Map<String, Object> map) {
		JSONObject jsonObject = new JSONObject();
		for (Map.Entry<String, Object> entry : map.entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();
			jsonObject.put(key, value);
		}
		return jsonObject;
	}
	
}
