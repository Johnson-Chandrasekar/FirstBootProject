<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Captcha V3</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://www.google.com/recaptcha/api.js?render=6Ld-qqMZAAAAAIs66GvE9kjiAkNDjJ4vyZHzjwPI"></script>
<script>
function validate(){
	
    grecaptcha.ready(function() {
    // do request for recaptcha token
    // response is promise with passed token
    //alert("captcha:");
        grecaptcha.execute('6Ld-qqMZAAAAAIs66GvE9kjiAkNDjJ4vyZHzjwPI', {action:'validate_captcha'})
                  .then(function(token) {
            // add token value to form
           document.getElementById('captcha').value = token;
           //alert("first "+token);
           check(token);
        });
    });
}
function check(token){
    var cToken = token;//document.getElementById('captcha').value;

   /*  var http = new XMLHttpRequest();
    var url = 'https://www.google.com/recaptcha/api/siteverify?'+'secret=6LcZ3v8UAAAAAIDSJg8rdnz19Dx7RMTOYnqeKIav&response='+cToken;
    var params = 'secret=6LcZ3v8UAAAAAIDSJg8rdnz19Dx7RMTOYnqeKIav&response='+cToken;
    console.log(url+params); */

    /* $.ajax({

 	   	   contentType: 'application/x-www-form-urlencoded',
    	   type: "POST",
    	   headers: {
               'Access-Control-Allow-Origin': 'http://localhost:8080',
               'Access-Control-Allow-Methods': 'POST, GET, OPTIONS'
           },
    	   url: 'https://www.google.com/recaptcha/api/siteverify', 
    	   data: {"secret" : "6LcZ3v8UAAAAAIDSJg8rdnz19Dx7RMTOYnqeKIav", "response" : cToken}, //, "remoteip":"localhost"
    	   success: function(data) { 
        	   console.log(data);
				alert(data);
        	    }
    	}); */
   
   
    var captcha = {
    		"captchaToken" : cToken
    	    };
	//alert(cToken);
    $.ajax({
    	   type: "POST",
    	   url: 'validate',
    	   contentType: 'application/json;', //charser=utf-8',
    	   //dataType: 'json',    	   
    	   data: JSON.stringify(captcha),
    	   success: function(response) { 
        	   //alert("response: "+response);
        	   console.log(response);
        	   if(response == true) {
        		   document.getElementById('grecaptcharesponse').style.display = "block";
            	   document.getElementById('g-recaptcha-response').innerHTML = response; 
              	  }
        	   else{
        		   document.getElementById('Error').style.display = "block";
            	   }
        	}
    	}); 
}
    
</script>
</head>
<body>
	<h1>Welcome Man...</h1>
	<input type="hidden" id="captcha" name="captcha"><br>
	<input type="text" id="uname" name="uname"><br>
	<input type="password" id="pwd" name="pwd"><br>
	<input type="button" id="johnson" value="LOGIN" onclick="validate()">
	<p id="grecaptcharesponse" style="display: none;">Captcha Validation Completed...!!!!</p>
	<p id="g-recaptcha-response"></p><br>	
	<p id="Error" style="display: none;"> Got Error...!!!!</p>
</body>
</html>