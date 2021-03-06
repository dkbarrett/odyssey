package steps;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import org.junit.Assert;
import play.db.Database;
import play.db.evolutions.Evolutions;
import play.mvc.Http;
import play.mvc.Result;
import play.test.Helpers;
import repositories.profiles.ProfileRepository;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

import static org.junit.Assert.*;
import static play.test.Helpers.*;

public class GeneralTestSteps {

    /**
     * Singleton to contain the test variables
     */
    private TestContext testContext = TestContext.getInstance();


    //------------------------------------Field Names---------------------------------------------

    /**
     * The username string variable.
     */
    private static final String USERNAME = "username";

    /**
     * The password string variable.
     */
    private static final String PASS_FIELD = "password";

    //--------------------------------------URIs-------------------------------------------

    /**
     * The login uri.
     */
    private static final String LOGIN_URI = "/v1/login";

    /**
     * The logout uri.
     */
    private static final String LOGOUT_URI = "/v1/logout";

    //----------------------------------Login Details---------------------------------------------

    /**
     * Valid login credentials for an admin user.
     */
    private static final String ADMIN_USERNAME = "admin@travelea.com";
    private static final String ADMIN_AUTH_PASS = "admin1";
    private static final String ADMIN_ID = "1";


    /**
     * Valid login credentials for a regular user.
     */
    private static final String REG_USERNAME = "guestUser@travelea.com";
    private static final String REG_AUTH_PASS = "guest123";
    private static final String REG_ID = "2";


    /**
     * Valid login credentials for an alternate user.
     */
    private static final String ALT_USERNAME = "testuser1@email.com";
    private static final String ALT_AUTH_PASS = "guest123";
    private static final String ALT_ID = "3";


    /**
     * Date buffers to ensure the tests always pass.
     */
    private static final int START_DATE_BUFFER = -10;
    private static final int END_DATE_BUFFER = 10;


    /**
     * Date formats.
     */
    private static final String YEAR_MONTH_DAY_FORMAT = "yyyy-MM-dd";
    private static final String YEAR_MONTH_DAY_TIME_FORMAT = "yyyy-MM-dd hh:MM:ssZ";

    /**
     * Message part from API Error.
     */
    private static final String MESSAGE = "message";


    /**
     * Repository to access the profiles in the running application.
     */
    private ProfileRepository profileRepository;


    @Before
    public void setUp() {

        Map<String, String> configuration = new HashMap<>();
        configuration.put("play.db.config", "db");
        configuration.put("play.db.default", "default");
        configuration.put("db.default.driver", "org.h2.Driver");
        configuration.put("db.default.url", "jdbc:h2:mem:testDB;MODE=MYSQL;");
        configuration.put("travelea.photos.main", "testphotos");
        configuration.put("travelea.photos.thumbnail", "/thumb");
        configuration.put("ebean.default", "models.*");
        configuration.put("play.evolutions.db.default.enabled", "true");
        configuration.put("play.evolutions.autoApply", "false");

        //Set up the fake application to use the in memory database config
        testContext.setApplication(fakeApplication(configuration));

        testContext.setDatabase(testContext.getApplication().injector().instanceOf(Database.class));
        applyEvolutions();

        Helpers.start(testContext.getApplication());

        profileRepository = testContext.getApplication().injector().instanceOf(ProfileRepository.class);
    }


    /**
     * Applies down evolutions to the database from the test/evolutions/default directory.
     * This drops tables and data from the database.
     */
    private void applyEvolutions() {
        Evolutions.applyEvolutions(
                testContext.getDatabase(),
                Evolutions.fromClassLoader(
                        getClass().getClassLoader(),
                        "test/original/"
                )
        );
    }


    /**
     * Applies up evolutions to the database from the test/evolutions/default directory.
     *
     * This populates the database with necessary tables and values.
     */
    private void cleanEvolutions() {
        Evolutions.cleanupEvolutions(testContext.getDatabase());
    }


    /**
     * Runs after each test scenario.
     * Sends a logout request.
     * Cleans up the database by cleaning up evolutions and shutting it down.
     * Stops running the fake application.JsonNode.
     */
    @After
    public void tearDown() {
        logoutRequest();
        cleanEvolutions();
        Database database = testContext.getDatabase();
        database.shutdown();
        Helpers.stop(testContext.getApplication());
    }


    /**
     * Sends a fake request to the application to login.
     * @param username      the string of the username to complete the login with.
     * @param password      the string of the password to complete the login with.
     */
    public void loginRequest(String username, String password) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode json = mapper.createObjectNode();

        json.put(USERNAME, username);
        json.put(PASS_FIELD, password);

        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .bodyJson(json)
                .uri(LOGIN_URI);
        Result loginResult = route(testContext.getApplication(), request);
        testContext.setStatusCode(loginResult.status());
    }


    /**
     * Sends a fake request to the application to logout.
     */
    private void logoutRequest() {
        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .uri(LOGOUT_URI);
        Result logoutResult = route(testContext.getApplication(), request);
        testContext.setLoggedInId(null);
        testContext.setStatusCode(logoutResult.status());
    }


    /**
     * Creates a new datetime object from today's date. This is then used to ensure our tests will always pass, as a
     * buffer is used to make the start date before today and the end date after today.
     *
     * @param isStartDate   boolean value to determine if the date being changed is the start or the end date.
     * @return              the start or end date, which is modified by the necessary date buffer.
     */
    public String getDateTimeBuffer(boolean isStartDate) {
        Calendar calendar = Calendar.getInstance();

        if (isStartDate) {
            calendar.add(Calendar.DATE, START_DATE_BUFFER);
        }
        calendar.add(Calendar.DATE, END_DATE_BUFFER);
        SimpleDateFormat sdf = new SimpleDateFormat(YEAR_MONTH_DAY_TIME_FORMAT);
        return sdf.format(calendar.getTime());
    }


    /**
     * Creates a new date object from today's date. This is then used to ensure our tests will always pass, as a
     * buffer is used to make the start date before today and the end date after today.
     *
     * @param isStartDate   boolean value to determine if the date being changed is the start or the end date.
     * @param dateBuffer    the buffer value for the dates, is required because sometimes dates need to be in order.
     *                      For example, in a trip.
     * @return              the start or end date, which is modified by the necessary date buffer.
     */
    public String getDateBuffer(boolean isStartDate, int dateBuffer) {
        Calendar calendar = Calendar.getInstance();
        if (isStartDate) {
            calendar.add(Calendar.DATE, START_DATE_BUFFER + dateBuffer);
        }
        calendar.add(Calendar.DATE, END_DATE_BUFFER + dateBuffer);
        SimpleDateFormat sdf = new SimpleDateFormat(YEAR_MONTH_DAY_FORMAT);
        return sdf.format(calendar.getTime());
    }


    /**
     * Gets the response as an iterator array Node from any fake request so that you can iterate over the response data.
     *
     * @param content   the string of the result using helper content as string.
     * @return          an Array node iterator.
     */
    public Iterator<JsonNode> getTheResponseIterator(String content) {
        JsonNode arrNode = null;
        try {
            arrNode = new ObjectMapper().readTree(content);
        } catch (IOException e) {
            fail("unable to get response iterator");
        }
        return arrNode.elements();
    }


    @Given("the application is running")
    public void theApplicationIsRunning() {
        Assert.assertTrue(testContext.getApplication().isTest());
    }


    /**
     * Attempts to send a log in request with user credentials from constants VALID_USERNAME
     * and VALID_AUTH_PASS.
     *
     * Asserts the login was successful with a status code of OK (200).
     */
    @Given("I am logged in")
    public void iAmLoggedIn() {
        loginRequest(REG_USERNAME, REG_AUTH_PASS);
        assertEquals(OK, testContext.getStatusCode());
        testContext.setLoggedInId(REG_ID);
    }


    /**
     * Attempts to send a log in request with user credentials from constants ALT_USERNAME
     * and ALT_AUTH_PASS.
     *
     * Asserts the login was successful with a status code of OK (200).
     */
    @Given("I am logged in as an alternate user")
    public void iAmLoggedInAsAnAlternateUser() {
        loginRequest(ALT_USERNAME, ALT_AUTH_PASS);
        assertEquals(OK, testContext.getStatusCode());
        testContext.setLoggedInId(ALT_ID);
    }


    /**
     * Attempts to send a log in request with user credentials from constants ADMIN_USERNAME
     * and ADMIN_AUTH_PASS.
     *
     * Asserts the login was successful with a status code of OK (200).
     */
    @Given("I am logged in as an admin user")
    public void iAmLoggedInAsAnAdminUser() {
        loginRequest(ADMIN_USERNAME, ADMIN_AUTH_PASS);
        assertEquals(OK, testContext.getStatusCode());
        testContext.setLoggedInId(ADMIN_ID);
    }


    @Given("^I am logged in as user with id (\\d+)$")
    public void iAmLoggedInAsUserWithId(Integer userId) {
        // Write code here that turns the phrase above into concrete actions
        testContext.setLoggedInId(userId.toString());
    }


    /**
     * Sends a logout request to the system.
     *
     * Asserts the value of loggedInId is null.
     */
    @Given("I am not logged in")
    public void iAmNotLoggedIn() {
        logoutRequest();
        assertNull(testContext.getLoggedInId());
    }


    @Given("^a user exists with id (\\d+)$")
    public void aUserExistsWithId(Integer userId) {
        Assert.assertNotNull(profileRepository.findById(Long.valueOf(userId)));
    }


    @Given("^a user does not exist with id (\\d+)$")
    public void aUserDoesNotExistWithId(Integer userId) {
        Assert.assertNull(profileRepository.findById(Long.valueOf(userId)));
    }


    @Then("^the status code received is (\\d+)$")
    public void theStatusCodeReceivedIs(int expectedStatusCode) {
        Assert.assertEquals(expectedStatusCode, testContext.getStatusCode());
    }


    @Then("the following ApiErrors are returned")
    public void theFollowingApiErrorsAreReturned(io.cucumber.datatable.DataTable dataTable) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        List<String> expectedApiErrors = dataTable.asList();
        for(JsonNode errorMessage : objectMapper.readTree(testContext.getResponseBody())) {
            Assert.assertTrue(expectedApiErrors.contains(errorMessage.get(MESSAGE).asText()));
        }
    }


    @Then("the response is empty")
    public void theResponseIsEmpty() throws IOException {
        JsonNode arrNode = new ObjectMapper().readTree(testContext.getResponseBody());

        Assert.assertEquals(0, arrNode.size());
    }

    /**
     * Gets the profile repository that was mocked.
     *
     * @return the profile repository.
     */
    public ProfileRepository getProfileRepository() {
        return profileRepository;
    }
}
