package steps;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import models.profiles.Profile;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.junit.Assert;
import play.mvc.Http;
import play.mvc.Result;
import play.test.Helpers;
import repositories.hints.HintRepository;
import repositories.profiles.ProfileRepository;

import java.io.IOException;
import java.util.*;

import static org.junit.Assert.*;
import static play.test.Helpers.*;

public class AchievementTrackerTestSteps {

    /**
     * Singleton class which stores generally used variables
     */
    private TestContext testContext = TestContext.getInstance();


    /**
     * The achievement tracker URI endpoint.
     */
    private static final String ACHIEVEMENT_TRACKER_URI = "/v1/achievementTracker/";


    /**
     * The profiles uri.
     */
    private static final String PROFILE_URI = "/v1/profile";


    /**
     * The points URI endpoint
     */
    private static final String POINTS_URI = "/points";


    /**
     * The quest URI endpoint.
     */
    private static final String QUEST_URI = "/v1/quests";


    /**
     * Last seen URI endpoint
     */
    private static final String LAST_SEEN_URI = "/v1/achievementTracker/updateLastSeen";


    /**
     * The destination endpoint uri.
     */
    private static final String DESTINATION_URI = "/v1/destinations";


    /**
     * The trip endpoint uri.
     */
    private static final String TRIP_URI = "/v1/trips";


    /**
     * The badges endpoint uri.
     */
    private static final String BADGES_URI = "/v1/achievementTracker/badges";


    /**
     * Authorisation token for sessions
     */
    private static final String AUTHORIZED = "authorized";


    /**
     * The quest attempt URI endpoint.
     */
    private static final String QUEST_ATTEMPT_URI = "/attempt/";


    /**
     * The quest attempt guess URI endpoint.
     */
    private static final String GUESS_URI = "/guess/";


    /**
     * The quest attempt check in URI endpoint.
     */
    private static final String CHECK_IN_URI = "/checkIn";


    /**
     * Boolean to evaluate against the response body of a riddle guess.
     */
    private static final boolean SUCCESSFUL_GUESS = true;
    private static final boolean UNSUCCESSFUL_GUESS = false;


    private static final long TO_CHECK_IN_RIDDLE_ID = 3L;
    private static final long QUEST_ATTEMPT_ID = 4L;
    private static final long DESTINATION_TO_GUESS = 1834L;
    private static final long INCORRECT_DESTINATION_GUESS = 6024L;


    // -------------------------- IDs of users used for tests ---------------------------

    private static final long OTHER_USER_ID = 3L;


    private static final int EMPTY_LIST_RESPONSE_SIZE = 2;
    private static final String DESTINATIONS = "destinations";
    private static final String TRIPS = "trips";
    private static final String QUESTS = "quests";
    private static final String ID = "id";
    private static final String USER_POINTS = "userPoints";

    private static final String ACHIEVEMENT_TRACKER = "achievementTracker";
    private static final String BADGES = "badges";
    private static final String BADGE_NAME = "name";
    private static final String LEVEL = "level";
    private static final String PROGRESS = "progress";

    private static final String LAST_SEEN_DATE = "lastSeenDate";
    private static final String BRONZE_TEST_USER_FIRST_NAME = "bronzeTest";
    private static final String CLIENT_DATE_FIELD = "clientDate";
    private static final String CLIENT_DATE_OFFSET = "dateOffset";

    private static final String YEAR_MONTH_DAY_FORMAT = "yyyy-MM-dd";
    private static final String YEAR_MONTH_DAY_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    private static final String GUESS_RESULT = "guessResult";
    private static final Integer UTC_DATE_OFFSET = 0;

    /**
     * Assert messages if the test fails for any case.
     */
    private static final String QUEST_NOT_IN_COMPLETED_QUESTS = "Quest not in list of completed quests";
    private static final String CURRENT_POINTS_NOT_GREATER_THAN_STARTING = "Current points is not greater than starting points";
    private static final String CURRENT_POINTS_NOT_LESS_THAN_STARTING = "Current points is not less than starting points";
    private static final String POINTS_IS_NEGATIVE = "Points value is negative";
    private static final String NO_USER_POINTS = "No user points Json value";
    private static final String START_END_POINTS_NOT_EQUAL = "Starting and end point values are not equal";


    /**
     * Global variable for the person's badges.
     */
    private JsonNode badgesJson;


    /**
     * Global variable for the requested badge's progress.
     */
    private int currentBadgeProgress = 0;


    /**
     * Global variable for the requested badge's level.
     */
    private int currentBadgeLevel = 0;


    /**
     * An object mapper used during tests.
     */
    private ObjectMapper mapper = new ObjectMapper();


    /**
     * Points the profile started with.
     */
    private int startingPoints;


    /**
     * Users current streak global variable.
     */
    private int currentStreak;


    /**
     * Points the profile has after an action.
     */
    private int currentPoints;


    /**
     * Profile repository injected.
     */
    private ProfileRepository profileRepository =
            testContext.getApplication().injector().instanceOf(ProfileRepository.class);


    /**
     * Hint repository injected.
     */
    private HintRepository hintRepository =
            testContext.getApplication().injector().instanceOf(HintRepository.class);


    /**
     * Sends a request to the backend using a fake request for the number of points for the given profile.
     *
     * @param userId    the id of the profile to be checked for points.
     */
    private void getPointsRequest(String userId) {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .uri(ACHIEVEMENT_TRACKER_URI + userId + POINTS_URI)
                .session(AUTHORIZED, testContext.getLoggedInId());
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setResponseBody(Helpers.contentAsString(result));
    }


    /**
     * Sends a request to the backend using a fake request for guessing the answer to a riddle.
     *
     * @param attemptId         the id of the user's current quest progress.
     * @param destinationId     the id of the guessed destination.
     */
    private void sendRiddleGuessRequest(long attemptId, long destinationId) {
        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .uri(QUEST_URI + QUEST_ATTEMPT_URI + attemptId + GUESS_URI + destinationId)
                .session(AUTHORIZED, testContext.getLoggedInId());
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setResponseBody(Helpers.contentAsString(result));
    }


    /**
     * Sends a request to the backend using a fake request for checking in to the current location in a quest.
     *
     * @param attemptId     the id of the user's current quest progress.
     */
    private void sendCheckInRequest(long attemptId) {
        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .uri(QUEST_URI + QUEST_ATTEMPT_URI + attemptId + CHECK_IN_URI)
                .session(AUTHORIZED, testContext.getLoggedInId());
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setResponseBody(Helpers.contentAsString(result));
    }


    /**
     * Calculates the requested badge progress and level for the currently logged in profile.
     *
     * @param badgeName     the requested badge.
     */
    private void getBadgeProgressAndLevelForLoggedInUser(String badgeName) {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, testContext.getLoggedInId())
                .uri(PROFILE_URI);
        Result result = route(testContext.getApplication(), request);
        try {
            ObjectNode profile = mapper.readTree(Helpers.contentAsString(result)).deepCopy();
            badgesJson = profile.get(ACHIEVEMENT_TRACKER).get(BADGES);
        } catch (Exception e) {
            fail("Unable to retrieve badges");
        }

        // Iterates through each badge in the list of the person's badgesJson.
        for (JsonNode badge: badgesJson) {
            // If the current viewing badge is the requested badge, return it's level.
            if (badge.get(BADGE_NAME).asText().equals(badgeName)) {
                currentBadgeProgress = badge.get(PROGRESS).asInt();
                currentBadgeLevel = badge.get(LEVEL).asInt();
            }
        }
    }


    /**
     * Gets the users current streak information
     * @param userId the id for the users streak check
     */
    private void getProfileStreakInformation(String userId) {
        Profile profile = profileRepository.findById(Long.valueOf(userId));
        currentStreak = profile.getAchievementTracker().getCurrentStreak();
    }


    @Given("I have some starting points")
    public void iHaveSomeStartingPoints() throws IOException {
        startingPoints = profileRepository.findById(
                Long.valueOf(
                        testContext.getLoggedInId()
                )
        ).getAchievementTracker().getPoints();
    }


    @Given("^the owner of the hint with id (\\d+) has some starting points$")
    public void theOwnerOfTheHintWithIdHasSomeStartingPoints(Integer hintId) {
        startingPoints = hintRepository.findById(hintId.longValue()).getCreator().getAchievementTracker().getPoints();
    }


    @Given("I currently have no \"(.*)\" created$")
    public void iCurrentlyHaveNoTripsCreated(String endPoint) {
        String uri = "";
        switch(endPoint) {
            case DESTINATIONS:
                uri = DESTINATION_URI;
                break;
            case TRIPS:
                uri = TRIP_URI;
                break;
            case QUESTS:
                uri = QUEST_URI;
                break;
            default:
                uri = "";
                break;
        }

        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .uri(uri + "/" + testContext.getLoggedInId())
                .session(AUTHORIZED, testContext.getLoggedInId());
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setResponseBody(Helpers.contentAsString(result));
        Assert.assertEquals(OK, testContext.getStatusCode());
        Assert.assertEquals(EMPTY_LIST_RESPONSE_SIZE, testContext.getResponseBody().length());
    }


    @Given("^the user has (\\d+) points$")
    public void theUserHasPoints(int userPoints) {
        // Write code here that turns the phrase above into concrete actions
        throw new cucumber.api.PendingException();
    }


    @Given("^my current progress towards the \"(.*)\" badge is (\\d+)$")
    public void myCurrentProgressTowardsTheBadgeIs(String badgeName, int progress) {
        getBadgeProgressAndLevelForLoggedInUser(badgeName);
        Assert.assertEquals(progress, currentBadgeProgress);
    }


    @Given("^the user with id \"(.*)\" has a current streak of (\\d+)$")
    public void theUserWithIdHasACurrentStreakOf(String id, int currentStreakTest) {
        getProfileStreakInformation(id);
        Assert.assertEquals(currentStreakTest, currentStreak);
    }


    @Given("^the user with id \"(.*)\" current progress towards the \"(.*)\" badge is (\\d+)$")
    public void theUserWithIdCurrentProgressTowardsTheBadgeIs(String id, String badgeName, int progress) {
        testContext.setLoggedInId(id);
        getBadgeProgressAndLevelForLoggedInUser(badgeName);
        Assert.assertEquals(progress, currentBadgeProgress);
    }


    @Given("^the user with id \"(.*)\" last logged in (\\d+) day ago$")
    public void theUserWithIdLastLoggedInDayAgo(String userId, Integer days) throws ParseException {

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -days);
        Date daysAgoDate = cal.getTime();

        Profile profile = profileRepository.findById(Long.valueOf(userId));
        SimpleDateFormat format = new SimpleDateFormat(YEAR_MONTH_DAY_FORMAT);
        Date clientDate = new SimpleDateFormat(YEAR_MONTH_DAY_FORMAT).parse(format.format(daysAgoDate));

        assertNotNull(profile);

        profile.setLastSeenDate(clientDate);
        profileRepository.update(profile);
        Profile profileCheck = profileRepository.findById(Long.valueOf(userId));

        assertNotNull(profileCheck);

        Assert.assertEquals(clientDate, profileCheck.getLastSeenDate());
    }


    @When("^the user with id \"(.*)\" updates their last seen to today$")
    public void theUserWithIdUpdatesTheirLastSeenToToday(String userId) {
        ObjectNode json = mapper.createObjectNode();


        String daysAgoDateString = new SimpleDateFormat(YEAR_MONTH_DAY_TIME_FORMAT)
                .format(new Date());

        json.put(CLIENT_DATE_FIELD, daysAgoDateString);
        json.put(CLIENT_DATE_OFFSET, UTC_DATE_OFFSET);

        Http.RequestBuilder request = fakeRequest()
                .method(POST)
                .uri(LAST_SEEN_URI)
                .bodyJson(json)
                .session(AUTHORIZED, userId);
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setLoggedInId(userId);

        Assert.assertEquals(OK, testContext.getStatusCode());
    }


    @When("the created user now updates their last seen date")
    public void theCreatedUserNowUpdatesTheirLastSeenDate() {

        Profile foundProfile = null;

        List<Profile> profiles = profileRepository.findAll();
        for (Profile profile: profiles) {
            if (profile.getFirstName().equals(BRONZE_TEST_USER_FIRST_NAME)) {
                foundProfile = profile;
            }
        }

        if (foundProfile != null) {
            testContext.setLoggedInId(foundProfile.getId().toString());
            ObjectNode json = mapper.createObjectNode();

            String daysAgoDateString = new SimpleDateFormat(YEAR_MONTH_DAY_TIME_FORMAT)
                    .format(new Date());

            json.put(CLIENT_DATE_FIELD, daysAgoDateString);
            json.put(CLIENT_DATE_OFFSET, UTC_DATE_OFFSET);

            Http.RequestBuilder request = fakeRequest()
                    .method(POST)
                    .uri(LAST_SEEN_URI)
                    .bodyJson(json)
                    .session(AUTHORIZED, testContext.getLoggedInId());
            Result result = route(testContext.getApplication(), request);
            testContext.setStatusCode(result.status());

            Assert.assertEquals(OK, testContext.getStatusCode());
        } else {
            fail("Profile not found");
        }
    }


    @When("^I search for profiles with (\\d+) points$")
    public void iSearchForProfilesWithPoints(int searchPoints) {
        // Write code here that turns the phrase above into concrete actions
        throw new cucumber.api.PendingException();
    }


    @When("I solve the current riddle for a Quest")
    public void iSolveTheFirstRiddleOfTheQuestWithID() throws IOException {
        sendRiddleGuessRequest(QUEST_ATTEMPT_ID, DESTINATION_TO_GUESS);
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        Assert.assertEquals(SUCCESSFUL_GUESS, responseBody.get(GUESS_RESULT).asBoolean());
    }


    @When("^I solve the current riddle for quest attempt with id (.*)$")
    public void iSolveTheFirstRiddleOfTheQuestAttemptId(Long questAttemptId) throws IOException {
        sendRiddleGuessRequest(questAttemptId, DESTINATION_TO_GUESS);
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        Assert.assertEquals(SUCCESSFUL_GUESS, responseBody.get(GUESS_RESULT).asBoolean());
    }


    @When("I request to retrieve all badges")
    public void iRequestToRetrieveAllBadges() {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .uri(BADGES_URI)
                .session(AUTHORIZED, testContext.getLoggedInId());
        Result result = route(testContext.getApplication(), request);
        testContext.setStatusCode(result.status());
        testContext.setResponseBody(Helpers.contentAsString(result));
    }


    @When("I try to view my points")
    public void iTryToViewMyPoints() {
        String userToView = testContext.getLoggedInId();
        getPointsRequest(userToView);
    }


    @When("I try to view another user's points value")
    public void iTryToViewAnotherUsersPointsValue() {
        String userToView = Long.toString(OTHER_USER_ID);
        getPointsRequest(userToView);
    }


    @When("I incorrectly guess the answer to a quest riddle")
    public void iIncorrectlyGuessTheAnswerToAQuestRiddle() throws IOException {
        sendRiddleGuessRequest(QUEST_ATTEMPT_ID, INCORRECT_DESTINATION_GUESS);
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        Assert.assertEquals(UNSUCCESSFUL_GUESS, responseBody.get(GUESS_RESULT).asBoolean());
    }


    @When("I check into a destination")
    public void iCheckIntoADestination() {
        sendCheckInRequest(TO_CHECK_IN_RIDDLE_ID);

        Assert.assertEquals(OK, testContext.getStatusCode());
    }


    @Then("^the response contains quest (\\d+)$")
    public void theResponseContainsQuest(Integer questId) throws IOException {
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        boolean hasQuest = false;
        for (JsonNode quest : responseBody) {
            if (quest.get(ID).asInt() == questId) {
                hasQuest = true;
            }
        }
        assertTrue(QUEST_NOT_IN_COMPLETED_QUESTS, hasQuest);
    }


    @Then("I have gained points")
    public void iHaveGainedPoints() throws IOException {
        String userToView = testContext.getLoggedInId();
        getPointsRequest(userToView);

        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        currentPoints = responseBody.get(USER_POINTS).asInt();
        Assert.assertTrue(CURRENT_POINTS_NOT_GREATER_THAN_STARTING,currentPoints > startingPoints);
    }


    @Then("^the owner of the hint with id (\\d+) has gained points$")
    public void theOwnerOfTheHintWithIdHasGainedPoints(Integer hintId) throws IOException {
        Profile hintOwner = hintRepository.findById(hintId.longValue()).getCreator();
        getPointsRequest(hintOwner.getId().toString());
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        currentPoints = responseBody.get(USER_POINTS).asInt();
        Assert.assertTrue(CURRENT_POINTS_NOT_GREATER_THAN_STARTING, currentPoints > startingPoints);
    }


    @Then("^the owner of the hint with id (\\d+) has lost points$")
    public void theOwnerOfTheHintWithIdHasLostPoints(Integer hintId) throws IOException {
        Profile hintOwner = hintRepository.findById(hintId.longValue()).getCreator();
        getPointsRequest(hintOwner.getId().toString());
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        currentPoints = responseBody.get(USER_POINTS).asInt();
        Assert.assertTrue(CURRENT_POINTS_NOT_LESS_THAN_STARTING, currentPoints < startingPoints);
    }


    @Then("I am given my point total")
    public void iAmGivenMyPointTotal() throws IOException {
        // Get the userPoints value from the JSON, convert it to an int and store it under current points if not null.

        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        Assert.assertNotNull(NO_USER_POINTS, responseBody.get(USER_POINTS));

        currentPoints =  responseBody.get(USER_POINTS).asInt();

        // Points should never be negative, so something has gone wrong.
        Assert.assertTrue(POINTS_IS_NEGATIVE, currentPoints >= 0);

    }


    @Then("I am given their total number of points")
    public void iAmGivenTheirTotalNumberOfPoints() throws IOException {
        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        Assert.assertNotNull(NO_USER_POINTS, responseBody.get(USER_POINTS));

        currentPoints =  responseBody.get(USER_POINTS).asInt();

        // Points should never be negative, so something has gone wrong.
        Assert.assertTrue(POINTS_IS_NEGATIVE, currentPoints >= 0);
    }


    @Then("I have not gained points")
    public void iHaveNotGainedPoints() throws IOException {
        String userToView = testContext.getLoggedInId();
        getPointsRequest(userToView);

        JsonNode responseBody = mapper.readTree(testContext.getResponseBody());
        currentPoints = responseBody.get(USER_POINTS).asInt();
        Assert.assertEquals(START_END_POINTS_NOT_EQUAL, startingPoints, currentPoints);
    }


    @Then("^I gain the \"(.*)\" badge with level (\\d+)$")
    public void iGainTheBadgeWithLevel(String obtainedBadge, int badgeLevel) {
        getBadgeProgressAndLevelForLoggedInUser(obtainedBadge);
        assertEquals(badgeLevel, currentBadgeLevel);

        // Need to reset after each test.
        currentBadgeLevel = 0;
        currentBadgeProgress = 0;
    }


    @Then("^the response contains (\\d+) badges$")
    public void theResponseContainsBadges(int numberOfBadges) throws IOException {
        // Write code here that turns the phrase above into concrete actions
        JsonNode responseJson = mapper.readTree(testContext.getResponseBody());

        Assert.assertEquals(numberOfBadges, responseJson.size());
    }


    @Then("^my current streak is (\\d+)$")
    public void myCurrentStreakIs(int currentStreakTest) {
        getProfileStreakInformation(testContext.getLoggedInId());
        assertEquals(currentStreakTest, currentStreak);
    }


    @Then("^my last login was (\\d+) days ago$")
    public void myLastLoginWasHoursAgo(int days) throws IOException {
        Http.RequestBuilder request = fakeRequest()
                .method(GET)
                .session(AUTHORIZED, testContext.getLoggedInId())
                .uri(PROFILE_URI);
        Result result = route(testContext.getApplication(), request);
        ObjectNode profile = mapper.readTree(Helpers.contentAsString(result)).deepCopy();

        Date profileLastLogin = new Date(profile.get(LAST_SEEN_DATE).asLong());

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -days);
        Date daysAgoDate = cal.getTime();

        SimpleDateFormat formatNew = new SimpleDateFormat(YEAR_MONTH_DAY_FORMAT);

        String daysAgoDateString = (formatNew.format(daysAgoDate));

        String profileLastLoginDate = (formatNew.format(profileLastLogin));

        Assert.assertEquals(daysAgoDateString, profileLastLoginDate);
    }


    @Then("^the current progress towards the \"(.*)\" badge is still (\\d+)$")
    public void theCurrentProgressTowardsTheBadgeIsStill(String obtainedBadge, int progressTest) {
        getBadgeProgressAndLevelForLoggedInUser(obtainedBadge);
        assertEquals(progressTest, currentBadgeProgress);
    }

}
