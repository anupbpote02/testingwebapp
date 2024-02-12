
# Webapp application Setup Guide TESTING

Test2

Test3

Test4

## Prerequisites

1. **Install Node.js:** Download and install Node.js from [nodejs.org](https://nodejs.org/).

3. **Check node Version:**

    ```bash
    node -v
    ```

3. **Check npm Version:**

    ```bash
    npm -v
    ```

4. **Install MySQL Database:** Install MySQL database. Download it from [mysql.com](https://dev.mysql.com/downloads/).

    ```sql
    mysql --version
    ```

5. **Install IDE (VSCode):** Download and install Visual Studio Code from [code.visualstudio.com](https://code.visualstudio.com/).

6. **Install Git and Setup:**
   Download and install Git from [git-scm.com](https://git-scm.com/). Set up Git configuration.

## Build and Deploy

1. **Checkout to Web Application Folder:**
   Navigate to the web application folder using the terminal/command prompt.

2. **Run npm install:**

    ```bash
    npm install
    ```

   This command downloads all the packages/dependencies used in the web application.

3. **Check .env File:**
   Ensure that the `.env` file is present in the project directory with the required configurations.

4. **Start the Application:**
   Use one of the following commands to start the application:

    ```bash
    npm start
    # or
    node check.js
    ```

5. **Test Endpoints using Postman:**
   Test the application endpoints using Postman or any API testing tool.


## References

1. [List of HTTP Status Codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
   - Information about various HTTP status codes.

2. [Sequelize - Model Basics - Timestamps](https://sequelize.org/docs/v6/core-concepts/model-basics/#timestamps)
   - Sequelize documentation on model focusing on timestamps.

3. [Sequelize - Validations and Constraints](https://sequelize.org/docs/v6/core-concepts/validations-and-constraints/)
   - Validations and constraints in Sequelize models.

4. [Sequelize - Model Querying Finders](https://sequelize.org/docs/v6/core-concepts/model-querying-finders/)
   - Sequelize querying and finders.

5. [IBM Documentation - Specifying HTTP Headers](https://www.ibm.com/docs/en/order-management-sw/9.4.0?topic=services-specifying-http-headers)
   - IBM documentation on HTTP headers.