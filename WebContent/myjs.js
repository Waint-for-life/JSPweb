/**
 * created by chen 2017 12/14
 */

function showpassword()
{
	element = document.getElementById("password");
	if (element.type == "password") {
		element.type = "text";
		
	}
	else
	{
		element.type = "password";
		
	}
	
}

function gotoBaidu()
{
	//window.location.href = "http://www.baidu.com";
	//window.location.href = "";
	/*element = document.getElementById('username');
	if (element.value == 'chen') {
		window.location.href = "http://www.baidu.com";
	}
	else
	{
		alert('用户名错误！');
	}*/
	alert('a');
	// document.write("<h1>hhh</h1>");
}

var exampleImg = function(){
	var img = new Image();
	var context = document.getElementById('id-canvas').getContext('2d');
	img.src = "small.png";

	var o = {
		img : img,
		context : context,

	}
	o.drawimg = function(){
		o.context.drawImage(o.img,0,0);
	}
	return o;
}

function logup() {
	var e = document.getElementById('loginform1');
//	var log = console.log.bind(console);
	
	e.action = 'logup.jsp';
//	log(e);
	e.submit();
}