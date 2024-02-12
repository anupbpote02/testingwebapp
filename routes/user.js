const express = require('express');
const router = express();
const bcrypt = require('bcrypt');
const basicAuth = require('basic-auth');
const { Sequelize } = require('sequelize');
const sequelize = require('../config/config');
const { User } = require('../models/usermodel');


router.use(express.json())

//## Common Middelwares Used 

// Middleware to check the database connectivity
const dbc = async (req, res, next) => {
  try {
    console.log("running middle ware")
    await sequelize.authenticate();
    console.log("Connection established successfully!");
    next();
  } catch (error) {
    console.error("Unable to connect to the server:", error);
    return res.status(503).set('Cache-Control', 'no-cache').send();
  }
};


// Middleware to check the presence of required keys
const validateRequestBody = (req, res, next) => {
  const requiredKeys = ['first_name', 'last_name', 'password', 'username'];
  const requestBodyKeys = Object.keys(req.body);

  
  for (const key of requiredKeys) {
//checking the value associated with the key
    if (!req.body[key]) {
      return res.status(400).json({ error: `Bad Request: Missing required key - ${key}` });
    }
  }

// checking for additional keys not in requiredKeys
   const extraKeys = [];
   for (const key of requestBodyKeys) {
     if (!requiredKeys.includes(key)) {
       extraKeys.push(key);
     }
   }

// If there are extra keys, return a 400 error with a message listing the extra keys
  if (extraKeys.length > 0) {
    return res.status(400).json({ error: `Bad Request: Invalid field(s) - ${extraKeys.join(', ')}` });
  }

// If all required keys are present, proceed to the next middleware or route handler
  next();
};

// *******************

// Middleware for Basic Authentication
const basiccheck = async (req, res, next) => {
  const credentials = basicAuth(req);

  console.log("#######Testing the credentials###########")
  console.log(credentials);

  if ( !credentials.name && !credentials.pass) {
    next();
  }
  else{

    return res.status(400).json({ error: 'You are passing creds in POST' });
  }

};

// *******************

//## Public Route (POST)

//Checking method routes for -- POST
router.all('/v1/user', (req, res, next) => {
  if (req.method !== 'POST') {
    console.log("The method requested is not POST for /v1/user");
    res.status(405).set('ALLOW', 'POST').send();
  } else {
    next();
  }
});

//!! POST method - /v1/user - Creating a new user
router.post('/v1/user',dbc,validateRequestBody, async (req, res) => {
   
  try {

// Check if credentials are present in the authorization header
      // const credentials = req.headers.authorization;
      // console.log('%%%%%%%%%')
      // console.log(credentials)
      // console.log('%%%%%%%%%')
      // if (credentials) {
      //   console.log("Credentials present in the request");
      //   return res.status(400).json({ error: 'Credentials should not be included in the request body' });
      // }
   


    const { first_name, last_name, password, username } = req.body;

    // Check if a user with the same username already exists
    const existingUser = await User.findOne({ where: { username } });
    if (existingUser) {
      return res.status(400).json({ error: 'User with the provided username already exists' });
    }

    // new user being created
    const newUser = await User.create({
      first_name,
      last_name,
      password,
      username,
    });

    // Respond with the created user
    // res.setHeader('Accept', 'application/json');
    res.status(201).set('Accept', 'application/json').json({
      id: newUser.id,
      first_name: newUser.first_name,
      last_name: newUser.last_name,
      username: newUser.username,
      account_created: newUser.account_created,
      account_updated: newUser.account_updated,
    });

  } catch (error) {

    console.error('Bad Request', error);
    return res.status(400).send();}
});






//## Protected Routes (GET and PUT)

// Middleware for Basic Authentication
const authenticate = async (req, res, next) => {
    const credentials = basicAuth(req);
 
    console.log("#######Testing the credentials###########")
    console.log(credentials);
  
    if (!credentials || !credentials.name || !credentials.pass) {
      return res.status(401).send('Unauthorized');
    }
  
    const user = await User.findOne({ where: { username: credentials.name } });
  
    if (!user || !bcrypt.compareSync(credentials.pass, user.password)) {
      return res.status(401).send('Unauthorized');
    }
  
    req.user = user;
    next();
  };
 
  


//!! GET - /v1/user/self - Get user information

  router.get('/v1/user/self',dbc, authenticate, async (req, res) => {
    try {

      if (Object.keys(req.query).length !== 0) {
        console.log("Invalid request payload present");
        res.status(400).set('Cache-Control', 'no-cache').send();
        return;
      }
    
      if (Object.keys(req.body).length !== 0 || req._body == true) {
         console.log("Request payload not allowed");
         return res.status(400).set('Cache-Control', 'no-cache').send();
        
      }
    

      const user = req.user;
  
      // Respond with the user information (excluding the password)
      res.setHeader('Accept', 'application/json');
      res.status(200).json({
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        username: user.username,
        account_created: user.account_created,
        account_updated: user.account_updated,
      });
    } catch (error) {

 
      console.error('Bad Request:', error);
      return res.status(400).send();
    
    }
  });






//!! PUT - /v1/user/self - Update user information

router.put('/v1/user/self',dbc, authenticate, async (req, res) => {
  try {
    
    // Retrieve the user object from the authentication middleware
    const user = req.user;

    //const { first_name, last_name, password, ...rest} = req.body

    const allowedKeys = ['first_name', 'last_name', 'password'];

    if (Object.keys(req.body).length <= 0) {
      console.log("Request payload not present to update");
      return res.status(400).set('Cache-Control', 'no-cache').send();      
    }

    for (const key in req.body) {
      if (!allowedKeys.includes(key) ) {
        //const errorMessage = `Bad Request: Invalid field - ${key}`;
        console.log(`Bad Request: Invalid field - ${key}`);
        return res.status(400).send();
      }
      else{
        if(req.body[key].length <= 0){
        //const errorMessage = `Bad Request: Invalid field - ${key}`;
        console.log(`Bad value Request: Invalid field - ${key}`);
        return res.status(400).send(); 
        }
      }
    }
    
// If all keys are allowed, proceed to update logic
    const { first_name, last_name, password } = req.body;
    const updateData = { first_name, last_name, password };
    await user.update(updateData);
    res.status(204).send();

  } catch (error) {
// Handling errors during the update process
    console.error('Error updating user information:', error);
    return res.status(400).send();
  }
});





//Checking GET and PUT methods - Handle all other methods for /v1/user/self
router.all('/v1/user/self', (req, res, next) => {
  console.log(`The method requested is not GET or PUT for /v1/user/self`);
  res.status(405).set('ALLOW', 'GET, PUT').send();
});





module.exports = router;

