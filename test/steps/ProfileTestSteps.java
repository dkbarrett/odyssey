package steps;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.cucumber.datatable.DataTable;
import models.points.AchievementTracker;
import models.profiles.Profile;
import org.junit.Assert;
import org.springframework.beans.BeansException;
import play.mvc.Http;
import play.mvc.Result;
import play.test.Helpers;
import repositories.profiles.ProfileRepository;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import static play.test.Helpers.*;

public class ProfileTestSteps {

    /**
     * Singleton class which stores generally used variables
     */
    private TestContext testContext = TestContext.getInstance();

    /**
     * Authorised string variable.
     */
    private static final String AUTHORIZED = "authorized";

    /**
     * The profiles uri.
     */
    private static final String PROFILES_URI = "/v1/profiles";

    /**
     * The profiles uri.
     */
    private static final String SINGLE_PROFILE_URI = "/v1/profile";

    /**
     * The single profile uri.
     */
    private static final String PROFILES_UPDATE_URI = "/v1/profile/";

    /**
     * The traveller types uri.
     */
    private static final String TRAVELLER_TYPES_URI = "/v1/travtypes";

    /**
     * The nationalities uri.
     */
    private static final String NATIONALITIES_URI = "/v1/nationalities";

    /**
     * The username string variable.
     */
    private static final String USERNAME = "username";

    /**
     * The password string variable.
     */
    private static final String PASS_FIELD = "password";

    /**
     * JSON variables
     */
    private static final String ID = "id";
    private static final String FIRST_NAME = "firstName";
    private static final String MIDDLE_NAME = "middleName";
    private static final String LAST_NAME = "lastName";
    private static final String DATE_OF_BIRTH = "dateOfBirth";
    private static final String PASSPORTS = "passports";

    /**
     * A valid username for login credentials for admin user.
     */
    private static final String VALID_USERNAME = "admin@travelea.com";

    /**
     * The number of traveller types expected.
     */
    private static final int NUMBER_OF_TRAVELLER_TYPES = 7;

    /**
     * The number of nationalities expected.
     */
    private static final int NUMBER_OF_NATIONALITIES = 108;

    /**
     * The number of profiles expected.
     */
    private static final int NUMBER_OF_PROFILES = 11;

    private static final String NAME = "name";
    private static final String NATIONALITY = "nationalities";
    private static final String GENDER = "gender";
    private static final String TRAVELLER_TYPE = "travellerTypes";
    private static final String RANK = "rank";
    private static final String MIN_AGE = "min_age";
    private static final String MAX_AGE = "max_age";
    private static final String MIN_POINTS = "min_points";
    private static final String MAX_POINTS = "max_points";
    private static final String SORT_BY = "sortBy";
    private static final String SORT_ORDER = "sortOrder";
    private static final String PAGE = "page";
    private static final String PAGE_SIZE = "pageSize";
    private static final String FIRST_NAME_SNAKE_CASE = "first_name";
    private static final String MIDDLE_NAME_SNAKE_CASE = "middle_name";
    private static final String LAST_NAME_SNAKE_CASE = "last_name";
    private static final String DATE_OF_BIRTH_SNAKE_CASE = "date_of_birth";
    private static final String SINGLE_NATIONALITY = "nationality";
    private static final String SINGLE_TRAVELLER_TYPE = "traveller_type";
    private static final String SINGLE_TRAVELLER_TYPE_CAMEL_CASE = "travellerType";
    private static final String SINGLE_PASSPORT = "passport_country";
    private static final String EMPTY_STRING = "";
    private static final String ZERO_STRING = "0";
    private static final String ONE_STRING = "1";
    private static final String ONE_HUNDRED_AND_TWENTY_STRING = "120";
    private static final String POINTS_STRING = "points";


    /**
     * Default page for profile searching pagination.
     */
    private static final String DEFAULT_PAGE = "0";

    /**
     * Default page size for profile searching pagination.
     */
    private static final String DEFAULT_PAGE_SIZE = "100";
    private static final String DEFAULT_PAGE_SIZE_SMALL = "5";

    /**
     * String to add the equals character (=) to build a query string.
     */
    private static final String EQUALS = "=";


    /**
     * String to add the ampersand character (&) to build a query string.
     */
    private static final String AND = "&";


    /**
     * String to add the question mark character (?) to build a query string.
     */
    private static final String QUESTION_MARK = "?";

    /**
     * Logs any errors in the tests.
     */
    private static final Logger LOGGER = Logger.getLogger( ProfileTestSteps.class.getName() );


    private ProfileRepository profileRepository =
            testContext.getApplication().injector().instanceOf(ProfileRepository.class);


    /**
     * Gets the response as an iterator array Node from any fake request so that you can iterate over the response data.
     *
     * @param content   the string of the result using helper content as string.
     * @return          an Array node iterator.
     */
    private Iterator<JsonNode> getTheResponseIterator(String content) {
        JsonNode arrNode = null;
        try {
            arrNode = new ObjectMapper().readTree(content);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Unable to get response iterator for fake request.", e);
        }
        Assert.assertNotNull(arrNode);
        return arrNode.elements();
    }


    /**
     * Converts given data table information and creates a profile json for creating a profile.
     *
     * @param dataTable     the data table from cucumber.
     * @return              the json formatted string of the profile.
     */
    private JsonNode convertDataTableToJsonNode(io.cucumber.datatable.DataTable dataTable) {
        //Get all input from the data table
        List<Map<String, String>> list = dataTable.asMaps(String.class, String.class);
        String username = list.get(0).get(USERNAME);
        String password = list.get(0).get(PASS_FIELD);
        String firstName = list.get(0).get(FIRST_NAME_SNAKE_CASE);
        String middleName = list.get(0).get(MIDDLE_NAME_SNAKE_CASE);
        String lastName = list.get(0).get(LAST_NAME_SNAKE_CASE);
        String gender = list.get(0).get(GENDER);
        String dateOfBirth = list.get(0).get(DATE_OF_BIRTH_SNAKE_CASE);

        // complex json
        ObjectMapper mapper = new ObjectMapper();

        //Add values to a JsonNode
        ObjectNode json = mapper.createObjectNode();

        ObjectNode nationalityNode = mapper.createObjectNode();
        nationalityNode.put(ID, Integer.valueOf(list.get(0).get(SINGLE_NATIONALITY)));

        ObjectNode travellerTypeNode = mapper.createObjectNode();
        travellerTypeNode.put(ID, Integer.valueOf(list.get(0).get(SINGLE_TRAVELLER_TYPE)));

        ObjectNode passportNode = mapper.createObjectNode();
        passportNode.put(ID, Integer.valueOf(list.get(0).get(SINGLE_PASSPORT)));

        json.put(USERNAME, username);
        json.put(PASS_FIELD, password);
        json.put(FIRST_NAME, firstName);
        json.put(MIDDLE_NAME, middleName);
        json.put(LAST_NAME, lastName);
        json.put(GENDER, gender);
        json.put(DATE_OF_BIRTH, dateOfBirth);
        json.putArray(NATIONALITY).add(nationalityNode);
        json.putArray(TRAVELLER_TYPE).add(travellerTypeNode);
        json.putArray(PASSPORTS).add(passportNode);
        return json;
    }


    /**
     * Returns a string that is either empty or containing the given value.
     * Checks if the given field matches the search field. If so, returns the given value to search.
     *
     * @param searchField       the search field name as defined by the application.
     * @param givenFields       the field name given to the test.
     * @param givenValues       the value to search for if the search and given fields match.
     * @return                  a string that contains the given value or an empty string.
     */
    private String getValue(String searchField, List<String> givenFields, List<String> givenValues) {
        int index = 0;
        for (String givenField : givenFields) {
            if (searchField.equals(givenField)){
                return givenValues.get(index);
            }
            index += 1;
        }
        return "";
    }


    /**
     * Creates a query string for the search destination request.
     * Builds this query string with empty values except for the given search value associated
     * with the given search field.
     *
     * @param givenFields       the search field names for the given values.
     * @param givenValues       the given search values for associated fields.
     * @return                  the complete query string.
     */
    private String createSearchProfileQueryString(List<String> givenFields, List<String> givenValues) {
        String name = getValue(NAME, givenFields, givenValues);
        String nationality = getValue(NATIONALITY, givenFields, givenValues);
        String gender = getValue(GENDER, givenFields, givenValues);
        String travellerType = getValue(TRAVELLER_TYPE, givenFields, givenValues);
        String minAge = getValue(MIN_AGE, givenFields, givenValues);
        String maxAge = getValue(MAX_AGE, givenFields, givenValues);
        String minPoints = getValue(MIN_POINTS, givenFields, givenValues);
        String maxPoints = getValue(MAX_POINTS, givenFields, givenValues);
        String rank = getValue(RANK, givenFields, givenValues);
        String pageSize = getValue(PAGE_SIZE, givenFields, givenValues);

        pageSize = pageSize.equals(EMPTY_STRING) ? DEFAULT_PAGE_SIZE : pageSize;
        minAge = minAge.equals(EMPTY_STRING) ? ZERO_STRING    : minAge;
        maxAge = maxAge.equals(EMPTY_STRING) ? ONE_HUNDRED_AND_TWENTY_STRING  : maxAge;

        return QUESTION_MARK
                + NATIONALITY + EQUALS + nationality
                + AND
                + GENDER + EQUALS + gender
                + AND
                + MIN_AGE + EQUALS + minAge
                + AND
                + MAX_AGE + EQUALS + maxAge
                + AND
                + TRAVELLER_TYPE + EQUALS + travellerType
                + AND
                + NAME + EQUALS + name
                + AND
                + MIN_POINTS + EQUALS + minPoints
                + AND
                + MAX_POINTS + EQUALS + maxPoints
                + AND
                + RANK + EQUALS + rank
                + AND
                + SORT_BY + EQUALS + EMPTY_STRING
                + AND
                + SORT_ORDER + EQUALS + EMPTY_STRING
                + AND
                + PAGE + EQUALS + DEFAULT_PAGE
                + AND
                + PAGE_SIZE + EQUALS + pageSize;

    }


    /**
     * Sends the backend request to retrieve the profiles that match the given search query.
     *
     * @param searchQuery   the search query that will determine which profiles to receive.
     */
    private void retrieveProfiles(String searchQuery) {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, testContext.getLoggedInId())
                .uri(PROFILES_URI + searchQuery);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setResponseBody(Helpers.contentAsString(result));
    }


    @Given("^The following profile exists with username \"(.*)\" within the TravelEA database:$")
    public void theFollowingProfileExistsWithUsernameWithinTheTravelEADatabase(String username) {
        // Sends the fake request
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, "1")
                .uri(PROFILES_URI);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());

        // Gets the response
        Iterator<JsonNode> iterator = getTheResponseIterator(Helpers.contentAsString(result));

        // Finds profile from the iterator
        boolean foundProfile = false;
        while (iterator.hasNext() && !foundProfile) {
            JsonNode jsonProfile = iterator.next();
            if (jsonProfile.get(USERNAME).asText().equals(username)) {
                foundProfile = true;
            }
        }

        Assert.assertTrue(foundProfile);
    }


    @Given("^The following profile does not exist with the username \"(.*)\" within the TravelEA database$")
    public void theFollowingProfileDoesNotExistWithTheUsernameWithinTheTravelEADatabase(String username) {
        // Sends the fake request
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, ONE_STRING)
                .uri(PROFILES_URI);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());

        // Gets the response
        Iterator<JsonNode> iterator = getTheResponseIterator(Helpers.contentAsString(result));

        // Finds profile from the iterator
        boolean foundProfile = false;
        while (iterator.hasNext() && !foundProfile) {
            JsonNode jsonProfile = iterator.next();
            if (jsonProfile.get(USERNAME).asText().equals(username)) {
                foundProfile = true;
            }
        }

        Assert.assertFalse(foundProfile);
    }


    @Given("^a user exists in the database with the id (\\d+) and username \"(.*)\"$")
    public void aUserExistsInTheDatabaseWithTheIdAndUsername(Integer id, String username) {
        Profile profile = profileRepository.findById(id.longValue());
        Assert.assertNotNull(profile);
        Assert.assertEquals(profile.getUsername(), username);
    }


    @Given("the following users exist in the database:")
    public void theFollowingUsersExistInTheDatabase(DataTable dataTable) {
        List<Map<String, String>> list = dataTable.asMaps(String.class, String.class);

        for (int i = 0; i < list.size(); i++) {
            Long userId = Long.parseLong(list.get(i).get(ID));
            String username = list.get(i).get(USERNAME);
            Profile profile = profileRepository.findById(userId);
            Assert.assertNotNull(profile);
            Assert.assertEquals(profile.getUsername(), username);
        }
    }


    @Given("^a user does not exist with the username \"(.*)\"$")
    public void aUserDoesNotExistWithTheUsername(String username) {
        Assert.assertNull(profileRepository.getExpressionList()
                .like(USERNAME, username)
                .findOne());
    }


    @Given("^the user (\\d+) has (\\d+) points$")
    public void theUserHasPoints(Integer userId, Integer points) {
        Profile profile = profileRepository.findById(userId.longValue());
        AchievementTracker achievementTracker = profile.getAchievementTracker(); //Null profile fails test, which is fine
        achievementTracker.addPoints(points);
        profileRepository.update(profile);
        Assert.assertEquals(points.longValue(), achievementTracker.getPoints());
    }


    @Given("the users have the following points")
    public void theUsersHaveTheFollowingPoints(DataTable dataTable) {
        List<Map<String, String>> list = dataTable.asMaps(String.class, String.class);

        for (int i = 0; i < list.size(); i++) {
            long userId = Long.parseLong(list.get(i).get(ID));
            int points = Integer.parseInt(list.get(i).get(POINTS_STRING));

            Profile profile = profileRepository.findById(userId);
            // Null profile fails test, which is fine
            AchievementTracker achievementTracker = profile.getAchievementTracker();
            achievementTracker.addPoints(points);
            profileRepository.update(profile);
            Assert.assertEquals(points, achievementTracker.getPoints());
        }


    }


    @Given("^at least (\\d+) profiles exist$")
    public void profilesExist(int numberOfProfiles) {
        int count = profileRepository.findCount();
        Assert.assertTrue(count >= numberOfProfiles);
    }


    @When("I send a GET request to the profiles endpoint")
    public void iSendAGETRequestToTheProfilesEndpoint() throws BeansException {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, testContext.getLoggedInId())
                .uri(PROFILES_URI);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());

        Iterator<JsonNode> iterator = getTheResponseIterator(Helpers.contentAsString(result));

        // Checks the response for admin profile and length of 2 users
        boolean passProfiles = false;
        int count = 0;
        while (iterator.hasNext()) {
            JsonNode jsonProfile = iterator.next();
            count++;
            if (jsonProfile.get(ID).asText().equals(ONE_STRING)
                    && jsonProfile.get(USERNAME).asText().equals(VALID_USERNAME)) {
                passProfiles = true;
            }
        }
        if (count != NUMBER_OF_PROFILES) {
            passProfiles = false;
        }
        testContext.setStatusCode(result.status());
        Assert.assertTrue(passProfiles);
    }


    @When("I send a GET request to the travtypes endpoint")
    public void iSendAGETRequestToTheTravTypesEndpoint() throws BeansException {
        // Does the request to back end
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .uri(TRAVELLER_TYPES_URI);
        Result result = route(testContext.getApplication(), request);

        // Gets the response
        Iterator<JsonNode> iterator = getTheResponseIterator(Helpers.contentAsString(result));

        // Checks the response for Holidaymaker and length of 7 traveller types
        boolean passTravelTypes = false;
        int count = 0;
        while (iterator.hasNext()) {
            JsonNode jsonTravellerType = iterator.next();
            count++;
            if (jsonTravellerType.get(ID).asText().equals("5")
                    && jsonTravellerType.get(SINGLE_TRAVELLER_TYPE_CAMEL_CASE).asText().equals("Holidaymaker")) {
                passTravelTypes = true;
            }
        }
        if (count != NUMBER_OF_TRAVELLER_TYPES) {
            passTravelTypes = false;
        }
        testContext.setStatusCode(result.status());
        Assert.assertTrue(passTravelTypes);
    }


    @When("I send a GET request to the nationalities endpoint")
    public void iSendAGETRequestToTheNationalitiesEndpoint() {
        // Does the fake request to back end
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .uri(NATIONALITIES_URI);
        Result result = route(testContext.getApplication(), request);

        // Gets the response
        Iterator<JsonNode> iterator = getTheResponseIterator(Helpers.contentAsString(result));

        // Checks the response for the nationality
        boolean passNationalities = false;
        int count = 0;
        while (iterator.hasNext()) {
            JsonNode jsonTravellerType = iterator.next();
            count++;
            if (jsonTravellerType.get(ID).asText().equals("16")
                    && (jsonTravellerType.get(SINGLE_NATIONALITY).asText().equals("Chinese"))) {
                passNationalities = true;
            }
        }
        if (count != NUMBER_OF_NATIONALITIES) {
            passNationalities = false;
        }

        testContext.setStatusCode(result.status());
        Assert.assertTrue(passNationalities);
    }


    @When("A user attempts to create a profile with the following fields:")
    public void aUserAttemptsToCreateAProfileWithTheFollowingFields(io.cucumber.datatable.DataTable dataTable) {
        // Creates the json for the profile
        JsonNode json = convertDataTableToJsonNode(dataTable);

        // Sending the fake request to the back end
        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .bodyJson(json)
                .uri(PROFILES_URI);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());

    }


    @When("The user attempts to update their profile information within the TravelEA database:")
    public void theUserAttemptsToUpdateTheirProfileInformationWithinTheTravelEADatabase(DataTable dataTable) {
        // Creates the json for the profile
        JsonNode json = convertDataTableToJsonNode(dataTable);

        // Sending the fake request to the back end for updating
        Http.RequestBuilder request = fakeRequest()
                .method(PUT)
                .session(AUTHORIZED, "2")
                .bodyJson(json)
                .uri(PROFILES_UPDATE_URI + 2); // Adding the id number to the uri, which is a string
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
    }


    @When("An admin attempts to create a profile with the following fields:")
    public void anAdminAttemptsToCreateAProfileWithTheFollowingFields(io.cucumber.datatable.DataTable dataTable) {
        // Creates the json for the profile
        JsonNode json = convertDataTableToJsonNode(dataTable);

        // Sending the fake request to the back end
        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .bodyJson(json)
                .uri(PROFILES_URI);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());

    }


    @When("^I search for profiles by \"([^\"]*)\" with value \"([^\"]*)\"$")
    public void iSearchForProfilesByFieldWithValue(String searchField, String searchValue) {
        searchValue = searchValue.replace(" ", "%20");
        List<String> searchFields = new ArrayList<>();
        List<String> searchValues = new ArrayList<>();

        if (searchField.equals(RANK)) {
            searchFields.add(PAGE_SIZE);
            searchValues.add(DEFAULT_PAGE_SIZE_SMALL);
        }


        searchFields.add(searchField);
        searchValues.add(searchValue);

        String searchQuery = createSearchProfileQueryString(searchFields, searchValues);

        retrieveProfiles(searchQuery);
    }


    @When("^I search for profiles by \"(.*)\" with value \"(.*)\" and by \"(.*)\" with value \"(.*)\"$")
    public void iSearchForProfilesByWithValueAndByWithValue(String searchField1, String searchValue1, String searchField2, String searchValue2) {
        searchValue1 = searchValue1.replace(" ", "%20");
        searchValue2 = searchValue2.replace(" ", "%20");
        List<String> searchFields = new ArrayList<>();
        List<String> searchValues = new ArrayList<>();

        searchFields.add(searchField1);
        searchFields.add(searchField2);
        searchValues.add(searchValue1);
        searchValues.add(searchValue2);

        String searchQuery = createSearchProfileQueryString(searchFields, searchValues);

        retrieveProfiles(searchQuery);
    }


    @When("^I change the username of the user with id (\\d+) to \"(.*)\"$")
    public void iChangeTheUsernameOfTheUserWithIdTo(Integer idToChange, String newUsername) {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, String.valueOf(idToChange))
                .uri(SINGLE_PROFILE_URI);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());

        Assert.assertEquals(OK, testContext.getStatusCode());

        ObjectNode profileToEdit = null;

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode profileJson = mapper.readTree(Helpers.contentAsString(result));
            profileToEdit = profileJson.deepCopy();
            profileToEdit.put(USERNAME, newUsername);
            profileToEdit.put(PASS_FIELD, EMPTY_STRING);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error converting string to Json", e);
        }

        // Sending the fake request to the back end for updating
        request = fakeRequest()
                .method(PUT)
                .session(AUTHORIZED, testContext.getLoggedInId())
                .bodyJson(profileToEdit)
                .uri(PROFILES_UPDATE_URI + idToChange);

        result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
    }


    @Then("^the response contains the profile with username \"(.*)\"$")
    public void theResponseContainsProfile(String username) {
        Assert.assertTrue(testContext.getResponseBody().contains(username));
    }


    @Then("the response contains the following profiles:")
    public void theResponseContainsTheFollowingProfiles(DataTable dataTable) {
        List<Map<String, String>> list = dataTable.asMaps(String.class, String.class);
        for (int i = 0; i < list.size(); i++) {
            String username = list.get(i).get(USERNAME);
            Assert.assertTrue(testContext.getResponseBody().contains(username));
        }
    }


    @Then("the response does not contain the following profiles:")
    public void theResponseDoesNotContainsTheFollowingProfiles(DataTable dataTable) {
        List<Map<String, String>> list = dataTable.asMaps(String.class, String.class);

        for (int i = 0; i < list.size(); i++) {
            String username = list.get(i).get(USERNAME);
            Assert.assertFalse(testContext.getResponseBody().contains(username));
        }
    }


    @Then("^the response does not contain the profile with username \"(.*)\"$")
    public void theResponseDoesNotContainProfile(String username) {
        Assert.assertFalse(testContext.getResponseBody().contains(username));
    }


    @Then("^the response contains (\\d+) profiles$")
    public void theResponseContainsProfiles(int numberOfProfiles) throws IOException {
        int responseSize = new ObjectMapper().readTree(testContext.getResponseBody()).size();
        Assert.assertEquals(numberOfProfiles, responseSize);
    }
}
