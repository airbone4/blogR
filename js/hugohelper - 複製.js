function parseParameter(params) {
  var keypairs = params.split('?');
  var obj = {};
  if (keypairs.length >= 2) {
    for (let i = 1; i < keypairs.length; i++) {
      let keypair = keypairs[i].split('=');
      obj[keypair[0]] = keypair[1];
    }
  }
  return obj;
};

function insertAfter(newNode, referenceNode) {
  return referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function mountToa(ds){
  let toa = document.querySelector(".toa")
  let ul=null;
  if (toa.childElementCount==0){
   ul=toa.appendChild(document.createElement("ul"));
  }else{
    ul=toa.querySelector("ul");
  }
  let li=ul.appendChild(document.createElement("li"));
  let item = li.appendChild(document.createElement("a"));
  item.href="#"+ds.posixId;
  item.innerText=ds.posixTitle;
  
}
function stataPosix() {
  let nodes = document.querySelectorAll("[data-role-posix]");
  if (nodes.length ==0 ) return;

  for (let i = 0; i < nodes.length; i++) {
    let posixnode = nodes[i];
    let dataset = posixnode.dataset;
    let parent = posixnode.closest("pre");
    let next = parent.nextSibling;
    let post = null;
    if (next &&  next.classList && next.classList.contains("post")){
      post= next;
    }else{
      post = insertAfter(document.createElement("div"),parent);
      post.classList.add("post");
    } 
    
    let link = posixnode.href || posixnode.src;
    let fileExt = link.split('.').pop();  //副檔名
    if (fileExt == "html") {   
      let label = post.appendChild(document.createElement("label"));
      label.innerText = dataset.posixTitle;
      let e = document.createElement("div");
      e.id="attach_"+i;
      e.classList.add("outTable");
      if (dataset.posixClass) e.classList.add(dataset.posixClass);
      dataset["posixId"]=e.id;
      post.appendChild(e);
      
      mountToa(dataset);
      fetch(link)
        .then(r => r.text())
        .then(t => {   
          e.innerHTML = t;
        })
    } else if(["png","jpg","gif"].includes(fileExt)){
      let e=document.createElement("img");
      e.id="attach_"+i;
      if (dataset.posixClass) e.classList.add(dataset.posixClass);
      dataset["posixId"]=e.id;
      post.appendChild(e);
      e.src=link;
      mountToa(dataset)
    } else{
      let e=document.createElement("a");
      post.appendChild(e);
      e.href=link;
      e.id="attach_"+i;
      if (dataset.posixClass)  e.classList.add(dataset.posixClass);
      dataset["posixId"]=e.id;
      e.innerText=posixnode.dataset.posixTitle + "(" + posixnode.innerText+")";
      mountToa(dataset);
    }
  }
}
function html_unescape2(s) {
  var div = document.createElement("div");
  div.innerHTML = s;
  return div.textContent || div.innerText; // IE is different
}

function html_unescape3(html) {
  var txt = document.createElement("textarea");
  txt.innerHTML = html;
  return txt.value;
}





ptn_quote = /&lt;(span)[\s]*?class[\s]*?=".*?nopre.*?"&gt;.*&lt;\/\1&gt;/g
function sdecode(str){
  var map = {amp: '&', lt: '<', gt: '>', quot: '"', '#039': "'"}
str = str.replace(/&([^;]+);/g, (m, c) => map[c])
return( str);
}
function html_unescape(str){
  rst= str.replace(ptn_quote,(c)=>{
    return(sdecode(c))
  })
  return(rst)  
}



document.addEventListener('DOMContentLoaded', (event) => {
  //var list = document.querySelectorAll("code[class^='language-.?']");
  var list = document.querySelectorAll("code[class^='language-?']");
  for (let i = 0; i < list.length; i++) {
    let obj = parseParameter(list[i].className);
    let codenode = list[i];
    codenode.className = "language-" + obj["lang"];
    if (obj["preclass"]) {
      let parent = codenode.closest("pre");
      if (parent && obj["preclass"]) {
        obj["preclass"].split(".").forEach(ee =>{
           if (ee.length>0){
            parent.classList.add(ee);
           }
        }) 
      }  
      if (parent && obj["user"]) parent.classList.add(obj["user"]);
    }
  }

  prechunks=Array.from(document.querySelectorAll("pre code:not(.language-html)"));
  prechunks= prechunks.filter(e=> !e.classList.contains("language-.html"))
    
  prechunks.forEach(precode=>{
    {
      s=html_unescape(precode.outerHTML)
      //s=s.replace(RegExp("hugocmd.*\\n.*\#>","gm"),"")
      s=s.replace(RegExp("\\n?hugocmd.*?\\n\#(>|&gt;)","gm"),"")
      
      precode.outerHTML=s
    
    }    
  });
  
  
  document.querySelectorAll('pre:not(.chroma) code').forEach((el) => {
    hljs.highlightBlock(el);
  });
});
document.addEventListener('DOMContentLoaded', (event) => {
  stataPosix();
});