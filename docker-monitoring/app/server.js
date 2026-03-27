 
const express = require("express");

const app = express();
 
// Root endpoint

app.get("/", (req, res) => {

  res.send("Hello from Dockerized App ");

});
 
// Health check endpoint

app.get("/health", (req, res) => {

  res.status(200).send("OK");

});
 
// Simulate some CPU work (helps Grafana show metrics)

app.get("/load", (req, res) => {

  let total = 0;

  for (let i = 0; i < 1e7; i++) {

    total += i;

  }

  res.send(`Load generated: ${total}`);

});
 
const PORT = 3000;
 
app.listen(PORT, () => {

  console.log(`Server running on port ${PORT}`);

});
 