const express = require('express');
const path = require('path')
const fareUtils = require('./fareutils')
  
const app = express();

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use('/', express.static('public'))

app.post('/calcfare', (req, res) => {
    let km = parseFloat(req.body.km)
    let min = parseInt(req.body.min)
  
    let fare = fareUtils.calcFare(km, min)
  
    res.send({fare: fare})
})

function getLocalIp() {
    const os = require('os');

    for(let addresses of Object.values(os.networkInterfaces())) {
        for(let add of addresses) {
            if(add.address.startsWith('172.')) {
                return add.address;
            } else if (add.address.startsWith('192.')) {
                return add.address;
            } else if (add.address.startsWith('10.')) {
                return add.address;
            }
        }
    }
}

app.get('/', (req, res) => {
    let img = `<img src="/image-2.png" />`
    let html = `<!DOCTYPE html><html><head><title>Sample</title></head>` 
    html += `<body><p><strong>My Server IP: </strong>${getLocalIp()}</p><div style="text-align:center;">${img}</div></body></html>`

  res.send(html)
})

app.get('/rate', (req, res) => {
    res.send(fareUtils.rate)
})
  
app.listen(3003, () => console.log(
    'Server started on http://localhost:3003'))
