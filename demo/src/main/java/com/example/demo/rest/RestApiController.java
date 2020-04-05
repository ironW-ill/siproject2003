package com.example.demo.rest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RestApiController {

	private String CLIENT_ID = "0lZyJxWwzAmDj415GPZ2";
	private String CLIENT_SECRET = "bW_q2g7jsi";

	@GetMapping("/restapi")
	public String MovieResponse(String keyword, Model model) {

		String text = null;

		try {
			text = URLEncoder.encode(keyword, "UTF-8");
		} catch (Exception e) {
			throw new RuntimeException("검색어 인코딩 실패", e);
		}

		String apiURL = "https://openapi.naver.com/v1/search/movie.json?query=" + text;

		Map<String, String> requestHeaders = new HashMap<>();
		requestHeaders.put("X-Naver-Client-Id", CLIENT_ID);
		requestHeaders.put("X-Naver-Client-Secret", CLIENT_SECRET);
		
		String result = get(apiURL, requestHeaders);
		
		try {
			JSONParser jp = new JSONParser();
			JSONObject jobj = (JSONObject)jp.parse(result);
			JSONArray jarr = (JSONArray)jobj.get("items");

			List<Map<String, String>> paramList = new ArrayList<Map<String, String>>();	
			
			for (int count = 0; count < jarr.size(); count++) {
				JSONObject movieInfo = (JSONObject) jarr.get(count);

				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("title", (String) movieInfo.get("title"));
				map.put("link", (String) movieInfo.get("link"));
				map.put("image", (String) movieInfo.get("image"));
				map.put("subtitle", (String) movieInfo.get("subtitle"));
				map.put("pubDate", (String) movieInfo.get("pubDate"));
				map.put("director", (String) movieInfo.get("director"));
				map.put("actor", (String) movieInfo.get("actor"));
				map.put("userRating", (String) movieInfo.get("userRating"));
				
				paramList.add(map);
			}
			
			model.addAttribute("movie", paramList);
			System.out.println(paramList);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return "movie/result";

	}

	private static String get(String apiUrl, Map<String, String> requestHeaders) {
		HttpURLConnection con = connect(apiUrl);
		try {
			con.setRequestMethod("GET");
			for (Map.Entry<String, String> header : requestHeaders.entrySet()) {
				con.setRequestProperty(header.getKey(), header.getValue());
			}

			int responseCode = con.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
				return readBody(con.getInputStream());
			} else { // 에러 발생
				return readBody(con.getErrorStream());
			}
		} catch (IOException e) {
			throw new RuntimeException("API 요청과 응답 실패", e);
		} finally {
			con.disconnect();
		}
	}

	private static HttpURLConnection connect(String apiUrl) {
		try {
			URL url = new URL(apiUrl);
			return (HttpURLConnection) url.openConnection();
		} catch (MalformedURLException e) {
			throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
		} catch (IOException e) {
			throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
		}
	}

	private static String readBody(InputStream body) {
		InputStreamReader streamReader = new InputStreamReader(body);

		try (BufferedReader lineReader = new BufferedReader(streamReader)) {
			StringBuilder responseBody = new StringBuilder();

			String line;
			while ((line = lineReader.readLine()) != null) {
				responseBody.append(line);
			}

			return responseBody.toString();
		} catch (IOException e) {
			throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
		}
	}

}
