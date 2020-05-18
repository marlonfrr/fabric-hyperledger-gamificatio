'use strict';
//port here is causing a  lot of trouble<
const PORT = process.env.PORT || 8080;
const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.send('This is the home page');
});

app.post('/newBlock', (req, res, next) => {
  req.body;
  //THIS SERVER IS AN EXTENSION OF THE APPLICATION SERVER AND IT´S SUPOSED TO DO SOMETHING WITH THIS INFO MAYBE RETREIVE IT
  console.log(req.body);
  res.json({ state: 'Received', 'block#': req.body.block_number });
});

app.post('/newEntryLogged', (req, res, next) => {
  req.body;
  //THIS SERVER IS AN EXTENSION OF THE APPLICATION SERVER AND IT´S SUPOSED TO DO SOMETHING WITH THIS INFO MAYBE RETREIVE IT
  console.log(req.body);
  res.json({ state: 'Received', type: 'new Entry' });
});

app.post('/newTransactionWatched', (req, res, next) => {
  req.body;
  //THIS SERVER IS AN EXTENSION OF THE APPLICATION SERVER AND IT´S SUPOSED TO DO SOMETHING WITH THIS INFO MAYBE RETREIVE IT
  console.log(req.body);

  res.json({ state: 'Received', type: 'new Transaction' });
});

app.post('/newEventListenedNoHystory', (req, res, next) => {
  req.body;
  //THIS SERVER IS AN EXTENSION OF THE APPLICATION SERVER AND IT´S SUPOSED TO DO SOMETHING WITH THIS INFO MAYBE RETREIVE IT
  console.log(req.body);

  res.json({ state: 'Received', type: 'Not hystory Listener' });
});

app.listen(PORT, () => {
  console.log(`Server is up on port:${PORT}`);
});
