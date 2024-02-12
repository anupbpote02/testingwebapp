const request = require('supertest');
const app = require('../routes/user')
const sequelize = require('../config/config');
const { User } = require('../models/usermodel');





beforeAll(async() =>{
   await sequelize.authenticate();
   await User.sync({force:true})

})
describe("Testing for creating user",() =>{
  test("testing post request",async () =>{
    const postresponse = await request(app).post('/v1/user')
    .send({
        first_name: 'John',
        last_name: 'Doe',
        password: 'password123',
        username: 'john.doe@example.com',
    });

    console.log(postresponse);
    expect(postresponse.statusCode).toBe(201);

    createdUser = postresponse.body;

    // Send a GET request to fetch the created user using basic authentication
    const getResponse = await request(app)
      .get('/v1/user/self')
      .auth(createdUser.username, 'password123'); // Use the user's password for authentication

    // Ensure the user exists and has the correct details
    expect(getResponse.status).toBe(200);
    expect(getResponse.body).toMatchObject({
      id: createdUser.id,
      first_name: 'John',
      last_name: 'Doe',
      username: 'john.doe@example.com',
    });
  })


  test("Test 2: Update the account and validate the account was updated (GET)", async () => {
    // Ensure the user details exist from the previous POST request
    expect(createdUser).toBeDefined();

    // Send a PUT request to update the user
    const putResponse = await request(app)
      .put('/v1/user/self')
      .auth(createdUser.username, 'password123')
      .send({
        first_name: 'UpdatedJohn',
        last_name: 'UpdatedDoe',
        password: 'updatedPassword456',
      });

    // Ensure the response status is 204 No Content
    expect(putResponse.status).toBe(204);

    // Send a GET request to fetch the updated user using the updated password
    const getUpdatedUserResponse = await request(app)
      .get('/v1/user/self')
      .auth(createdUser.username, 'updatedPassword456');

    // Ensure the updated user exists and has the correct details
    expect(getUpdatedUserResponse.status).toBe(200);
    expect(getUpdatedUserResponse.body).toMatchObject({
      id: createdUser.id,
      first_name: 'UpdatedJohn',
      last_name: 'UpdatedDoe',
      username: 'john.doe@example.com',
    });
  });

})