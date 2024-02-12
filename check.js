const express = require('express');
const { Sequelize } = require('sequelize');
const userRoutes = require('./routes/user');
const sequelize = require('./config/config');
const User = require('./models/usermodel');

const check = express();
const PORT = 3000;


const initializeDatabase = async () => {
  try {
    // syncs model 
    await sequelize.sync();
    console.log("**Database bootstrap completed**");

  } catch (error) {
    console.error("Error during database initialization:", error);
    // Handle errors - stop the application
    // Exit the application with an error code
    process.exit(1); 
  }
};

// Middelware to handle the database connectivity
const dbc = async (req, res, next) => {
  try {
    await sequelize.authenticate();
    console.log("Connection established successfully!");
    next();
  } catch (error) {
    console.error("Unable to connect to the server:", error);
    res.status(503).set('Cache-Control', 'no-cache').send();
  }
};


check.use(express.json());

check.use(userRoutes);


// Health check endpoints
// Checking for methods other than GET 
check.all('/healthz', (req, res, next) => {
  if (req.method !== 'GET') {
    console.log("The method requested is not GET");
    res.status(405).set('ALLOW', 'GET').send();
  } else {
    next();
  }
});

// Checking for Payload as Parameters and Body
check.get('/healthz', async (req, res) => {
  if (Object.keys(req.query).length !== 0) {
    console.log("Invalid request payload present");
    res.status(400).set('Cache-Control', 'no-cache').send();
    return;
  }

  if (Object.keys(req.body).length !== 0 || req._body == true) {
    console.log("Request payload not allowed");
    res.status(400).set('Cache-Control', 'no-cache').send();
    return;
  }

  try {
    await sequelize.authenticate();
    console.log("Connection established successfully!");
    res.status(200).set('Cache-Control', 'no-cache').send();
  } catch (error) {
    console.log("Unable to connect to the server");
    res.status(503).set('Cache-Control', 'no-cache').send();
  }
});


//404-Not Found Handling
check.use((req, res) => {
  console.log("404 - Not Found!!");
  res.status(404).set('Cache-Control', 'no-cache').send();
});

// Initializing the database and starting the server
(async () => {
  await initializeDatabase();
  check.listen(PORT, () => {
    console.log(`Server is listening on PORT ${PORT}`);
  });
})();



module.exports = check;