<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div id="192.168.0.100"> this is origin</div>
	<div id="188">nonono</div>
	<button onclick="changeText()">butan</button>

	<script type="text/javascript">
		changeText = function() {
			console.log('click!')
			d = document.getElementById('192.168.0.100')
			//d.innerHTML = 'changed'
			//console.log($("#192\\.168\\.0\\.100"))
			//console.log($("#188"))
			//$("#192\\.168\\.0\\.100")[0].innerHTML = 'changed!'
			//$("#188")[0].innerHTML = 'changed over!'
			$d = $(d)
			$d[0].innerHTML = 'changed!'
		}
	</script>
	<script src="./vendor/jquery/jquery.min.js?v=1.2"></script>
</body>
</html>