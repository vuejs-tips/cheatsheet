var Nightmare = require('nightmare')
var nightmare = Nightmare({ show: false })
var f = 2.5
nightmare
  .goto('http://localhost:5000')
  .viewport(900*f, 300*f)
  // .screenshot('vuejs-cheatsheet.png')
  // .screenshot('vuejs-cheatsheet.jpg')
  .pdf('vuejs-cheatsheet.pdf', {landscape: false, marginsType: 1, pageSize: {width: 900 * 750, height: 300 * 750}})
  .end()
  .catch(function (error) {
    console.error(error)
  });
