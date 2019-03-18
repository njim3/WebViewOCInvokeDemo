function jsInvokeOC() {
    window.webkit.messageHandlers.jsInvokeOCMethod.postMessage('Javascript invoke OC');
}

function getCookie() {
    var cookie = window.prompt("getCookie");
    
    document.getElementById('cookie').innerText = "cookie: " + cookie;
}

function response2JS(response) {
    document.getElementById('response').innerText = "resp: " + response;
}
