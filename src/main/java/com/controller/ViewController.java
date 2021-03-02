package com.controller;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.List;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@Controller
public class ViewController {

	private static final String RECAPTCHA_SERVICE_URL = "https://www.google.com/recaptcha/api/siteverify";
	private static final String SECRET_KEY = "6Ld-qqMZAAAAACT-LRAem-n7vUtWxnTL0JMa9t-v";
	
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginPage() {
		System.out.println("welcome to my website");
		return "login";
	}

	@RequestMapping(path = "/validate", method = RequestMethod.POST)
	public @ResponseBody Boolean isValid(@RequestBody Captcha clientRecaptchaResponse, HttpServletRequest request,
			HttpServletResponse resp) throws IOException, ParseException {
		System.out.println("Validate Here..!!!!!" + clientRecaptchaResponse.getCaptchaToken());
		if (clientRecaptchaResponse.getCaptchaToken() == null || "".equals(clientRecaptchaResponse.getCaptchaToken())) {
			return null;
		}


		URL obj = new URL(RECAPTCHA_SERVICE_URL); 
		HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();

		con.setRequestMethod("POST"); 
		con.setRequestProperty("Accept-Language","en-US,en;q=0.5");

		//add client result as post parameter
		String postParams = "secret=" + SECRET_KEY + "&response=" + clientRecaptchaResponse.getCaptchaToken();

		// send post request to google recaptcha server 
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(postParams); wr.flush(); wr.close();

		int responseCode = con.getResponseCode();

		System.out.println("Post parameters: " + postParams);
		System.out.println("Response Code: " + responseCode);

		BufferedReader in = new BufferedReader(new InputStreamReader( con.getInputStream())); 
		String inputLine; 
		StringBuffer response = new StringBuffer(); 
		
		while ((inputLine = in.readLine()) != null) {
			System.out.println(inputLine); response.append(inputLine);
			}

		in.close();

		JSONParser parser = new JSONParser(); 
		JSONObject json = (JSONObject)parser.parse(response.toString());


		/*try { 
			resp.getWriter().write(json.toString()); 
		} catch (Exception e) { 
			//TODO: handle exception 
			resp.getWriter().write("Error");
			} */

		//Parse JSON-response 
		Boolean success = (Boolean) json.get("success"); 
		Double score = (Double) json.get("score");

		System.out.println("success : " + success);
		System.out.println("score : " + score);


		return success;
	}
}
