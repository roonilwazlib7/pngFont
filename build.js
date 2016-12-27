var shell = require('shelljs');

shell.exec("coffee --inline-map --compile --output Core/ Src/");

shell.exec("electron main.js");
