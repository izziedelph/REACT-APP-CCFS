const express = require('express');
const path = require('path');
const app = express();

// Serve static files from the React app
app.use(express.static(path.join(__dirname)));

// Handle React routing, return all requests to React app
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

const port = process.env.PORT || 8081;  // Elastic Beanstalk expects port 8081
app.listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});