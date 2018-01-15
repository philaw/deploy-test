const express = require('express');
const app = express();
const port = 32100;

app.get('/', function(req, res, next) {
  res.json({"hello":"world"});
  next();
});

app.get('/health', function (req, res, next) {
  res.json({'health': 'ok'});
  next();
});

app.listen(port, function() {
  console.log(`Example app listening on port ${port}!`);
});
