var getCookies = function(){
  var pairs = document.cookie.split(";");
  var cookies = {};
  for (var i=0; i<pairs.length; i++){
    var pair = pairs[i].split("=");
    cookies[(pair[0]+'').trim()] = unescape(pair.slice(1).join('='));
  }
  return cookies;
}
function loginfo(){
	cookies = getCookies()
	if(cookies && cookies.userinfo){
	userinfo = JSON.parse(cookies.userinfo)
    let logBtn = document.querySelector("#avator");
    logBtn.setAttribute("title",  userinfo.name); 
    logBtn.querySelector("img").src=userinfo.avator;
    logBtn.classList.toggle("d-none")
	//document.querySelector("#avator img").src=userinfo.avator;
  }
}
jQuery(document).ready(function() {
loginfo()
})
/*
read api
 <img id="head" >
 <script>
 const userInfo = async () => {
  const response = await fetch('/whoami');
  const myJson = await response.json(); //extract JSON from the http response
  document.querySelector("#head").src=myJson.user.image;
  // do something with myJson
}
userInfo()	
*/