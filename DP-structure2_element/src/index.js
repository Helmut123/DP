import './styles/main.css';
import './Components/Header/Header.css';
import './Components/Footer/Footer.css';
import './Components/LogIn/Login.css';
import './Components/LogIn/Signup.css';
import './Components/Home/Home.css';
import './Components/Button/Button.css';
import './Components/ToDo/ToDo.css';
import './Components/ToDo/Activity.css';
import './Components/LogIn/Access.css';
import './Components/LogIn/Signedup.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

var key = "user";

var localS = localStorage.getItem(key);
var sessionS = sessionStorage.getItem(key);
function getCookie(key) {
  let name = key + "=";
  let decodedCookie = decodeURIComponent(document.cookie);
  let ca = decodedCookie.split(';');
  for(let i = 0; i <ca.length; i++) {
    let c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}
var cookiesS = getCookie("token")

if (localS != null){
  var app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: localS
  });
}
else if (sessionS != null) {
  var app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: sessionS
  });
}
else if (cookiesS != null) {
  var app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: cookiesS
  });
}
else {
  var app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: null
  });
}


app.ports.storeLocal.subscribe(function(value){
  sessionStorage.removeItem(key);
  document.cookie = "token=" + "" + ";";
  if(value === null){
    localStorage.removeItem(key);
  }
  else {
    localStorage.setItem(key, value);
  }
});

app.ports.storeSession.subscribe(function(value){
  localStorage.removeItem(key);
  document.cookie = "token=" + "" + ";";
  if(value === null){
    sessionStorage.removeItem(key);
  }
  else {
    sessionStorage.setItem(key, value);
  }
});

app.ports.storeCookies.subscribe(function(value){
  localStorage.removeItem(key);
  sessionStorage.removeItem(key);
  if(value === null){
    document.cookie = "token=" + "" + ";";
  }
  else {
    const d = new Date();
    d.setTime(d.getTime() + (1*24*60*60*1000));
    let expires = "expires=" + d.toUTCString();
    document.cookie = "token=" + value + ";" + expires + ";";
  }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
