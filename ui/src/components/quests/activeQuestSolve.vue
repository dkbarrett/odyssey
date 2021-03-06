<template>
    <div>
        <div v-if="pageDisplayed === 0">
            <b-row>
                <b-col cols="3">
                    <b-button @click="goBack" class="buttonMarginsBottom" size="sm">Back</b-button>
                </b-col>
                <b-col cols="9">
                    <div><strong>Riddle: "{{searchedRiddle}}"</strong></div>
                </b-col>
            </b-row>
            <b-button v-if="!showDestinationSearchCollapse" @click="showDestinationSearchCollapse = true;
            showSelectedDestination = false; foundDestinationsKey += 1" variant="primary" block>Search Again</b-button>
            <b-collapse v-model="showDestinationSearchCollapse" id="destinations-collapse">
                <found-destinations
                        :key="foundDestinationsKey"
                        :search-public="true"
                        :destination-types="destinationTypes" @destination-click="destinationClicked">
                </found-destinations>
            </b-collapse>

            <b-alert v-model="showError" variant="danger" class="buttonMarginsTop" dismissible>
                Incorrect, try again.
            </b-alert>

            <b-collapse v-model="showSelectedDestination" id="selected-destination-collapse">
                <b-list-group-item class="flex-column align-items-start"
                                   id="selectedDestination"
                                   :disabled="selectedDestination === {}">
                    <div class="d-flex w-100 justify-content-between">
                        <h5 class="mb-1" v-if="selectedDestination.name">
                            {{selectedDestination.name}}
                        </h5>
                        <h5 class="mb-1" v-else>Select a Destination</h5>

                        <small>
                            <div class="d-flex justify-content-right">
                                <b-button variant="primary"
                                          @click="checkGuess"
                                          v-if="selectedDestination.name">Check Guess
                                </b-button>
                            </div>
                        </small>
                    </div>
                    <p>
                        {{selectedDestination.district}}
                    </p>
                    <p>
                        {{selectedDestination.country}}
                    </p>
                </b-list-group-item>
            </b-collapse>
        </div>

        <create-hint v-else-if="pageDisplayed === 1"
                     :profile="profile"
                     :objective="objective"
                     @successCreate="successCreateHint"
                     @cancelCreate="pageDisplayed = 2">
        </create-hint>

        <div v-else>
            <!--Successful quest alert -->
            <b-alert
                    :show="dismissCountDown"
                    @dismiss-count-down="countDownChanged"
                    @dismissed="dismissCountDown=0"
                    dismissible
                    variant="success">
                <p>{{alertText}}</p>
                <b-progress
                        :max="dismissSeconds"
                        :value="dismissCountDown - 1"
                        height="4px"
                        variant="success"
                ></b-progress>
            </b-alert>

            <b-button
                    @click="$emit('show-quest-attempt', false)"
                    class="buttonMarginsBottom" size="sm" v-if="onMobile">
                    Back
            </b-button>
            <h2 class="page-title" v-if="questAttempt.questAttempted">{{questAttempt.questAttempted.title}}</h2>

            <b-alert v-model="guessSuccess" variant="success" dismissible>
                Success!
            </b-alert>

            <b-progress
                    :value="questAttempt.progress"
                    :max="100"
                    :variant="(questAttempt.completed ? 'success' : 'primary')"
                    class="mb-3">
            </b-progress>

            <b-list-group>

                <!-- List the solved objectives in the quest attempt -->
                <b-list-group-item v-for="solvedObjective in questAttempt.solved"
                                   class="flex-column align-items-start"
                                   :key="solvedObjective.id">
                    <b-col class="w-100">
                        <b-row class="pb-1">
                            <b-col md="7">
                                <span class="mobile-text font-weight-bold">{{solvedObjective.riddle}}</span>
                                <p class="mb-1 mobile-text">
                                    {{solvedObjective.destination.name}}
                                </p>
                            </b-col>
                            <b-col md="5">
                                <div class="float-right">
                                    <b-button size="sm" variant="link"
                                              @click="toggleHints(solvedObjective)">
                                              {{(objective != null) && (solvedObjective.id === objective.id) ? "Hide" : "Show"}} Hints
                                    </b-button>
                                    <b-img src="../../../static/check_mark.png" fluid></b-img>
                                </div>
                            </b-col>
                        </b-row>
                        <b-row v-if="(objective != null) && (solvedObjective.id === objective.id)">
                            <list-hints
                                    v-if="(objective != null) && (solvedObjective.id === objective.id)"
                                    :objective="objective"
                                    :profile="profile"
                                    :solved="true"
                                    @add-hint="pageDisplayed = 1"
                            >
                            </list-hints>
                        </b-row>
                    </b-col>
                </b-list-group-item>

                <!-- If we have an objective to solve, display it -->
                <b-list-group-item class="d-flex justify-content-between align-items-center"
                                   v-if="questAttempt.toSolve != null">
                    <b-col class="w-100">
                        <b-row class="pb-1">
                            <b-col md="7">
                                <span class="mobile-text font-weight-bold">{{questAttempt.toSolve.riddle}}</span>
                            </b-col>
                            <b-col md="5">
                                <div class="float-right">
                                    <b-button size="sm" variant="outline-primary"
                                              @click="toggleHints(questAttempt.toSolve)">
                                              {{(objective != null) && (questAttempt.toSolve.id === objective.id) ? "Hide" : "Show"}} Hints
                                    </b-button>
                                    <b-button size="sm" variant="warning"
                                              @click="destinationSearch(questAttempt.toSolve.riddle)">
                                              Solve
                                    </b-button>
                                </div>
                            </b-col>
                        </b-row>
                        <b-row v-if="(objective != null) && (questAttempt.toSolve.id  === objective.id)">
                            <list-hints
                                    v-if="(objective != null) && (questAttempt.toSolve.id  === objective.id)"
                                    :objective="objective"
                                    :profile="profile"
                                    :solved="false"
                                    @add-hint="pageDisplayed = 1"
                            >
                            </list-hints>
                        </b-row>
                    </b-col>
                </b-list-group-item>


                <!-- If we have an objective to check in to, display it -->
                <b-list-group-item class="d-flex justify-content-between align-items-center"
                                   v-if="questAttempt.toCheckIn != null">
                <b-col class="w-100">
                    <b-row class="pb-1">
                        <b-col md="7">
                            <span class="mobile-text font-weight-bold">{{questAttempt.toCheckIn.riddle}}</span>
                            <p class="mb-1 mobile-text">
                                {{questAttempt.toCheckIn.destination.name}}
                            </p>
                        </b-col>
                        <b-col md="5">
                            <div class="float-right">
                                <b-button class="no-wrap-text" size="sm" variant="primary"
                                          @click="toggleHints(questAttempt.toCheckIn)">
                                    {{(objective != null) && (questAttempt.toCheckIn.id === objective.id) ? "Hide" : "Show"}} Hints
                                </b-button>
                                <b-button class="no-wrap-text" size="sm" variant="warning"
                                          @click="getCurrentLocation">
                                          Check In
                                </b-button>
                            </div>
                        </b-col>
                    </b-row>
                    <b-row v-if="(objective != null) && (questAttempt.toCheckIn.id === objective.id)">
                        <list-hints
                                v-if="(objective != null) && (questAttempt.toCheckIn.id === objective.id)"
                                :objective="objective"
                                :profile="profile"
                                :solved="true"
                                @add-hint="pageDisplayed = 1">
                        </list-hints>
                    </b-row>
                </b-col>
                </b-list-group-item>

                <b-alert
                        :show="showNotValidCheckIn"
                        @dismiss-count-down="countDownChangedCheckIn"
                        @dismissed="showNotValidCheckIn=0"
                        dismissible
                        variant="warning" class="mt-2">
                    You are not at the required location, you are {{getHowClose()}} away.
                </b-alert>

                <!-- List the remaining unsolved objectives in the quest attempt -->
                <b-list-group-item v-for="objective in questAttempt.unsolved"
                                   class="d-flex justify-content-between align-items-center"
                                   :key="objective.id" disabled>
                    <span class="mobile-text font-weight-bold">{{objective.riddle}}</span>
                </b-list-group-item>
            </b-list-group>
        </div>
    </div>
</template>

<script>
    import FoundDestinations from "../destinations/destinationSearchList";
    import CreateHint from "../hints/createHint"
    import ListHints from "../hints/listHints";

    export default {
        name: "activeQuestSolve",

        props: {
            questAttempt: Object,
            profile: Object
        },

        data() {
            return {
                destinationTypes: [],
                showDestinationSearch: false,
                selectedDestination: {},
                guessSuccess: false,
                showError: false,
                showDestinationSearchCollapse: true,
                showSelectedDestination: false,
                foundDestinationsKey: 0,
                currentLocation: {
                    latitude: null,
                    longitude: null
                },
                foundLocation: false,
                validCheckIn: false,
                showNotValidCheckIn: 0,
                totalDistance: null,
                searchedRiddle: null,
                objective: null,
                showHintAlertModal: false,
                dismissSeconds: 3,
                dismissCountDown: 0,
                alertText: "",
                pageDisplayed: 3
            }
        },

        watch: {
            /**
             * Watches the quest attempt to see if it updates and if so then hide the destination search and change
             * show or hide to show.
             */
            questAttempt() {
                this.objective = null;
                this.pageDisplayed = 3;
            },


            /**
             * Watching the found location variable to then do the checkin request once the user has been found.
             */
            foundLocation() {
                if (this.foundLocation) {
                    if (this.validCheckIn) {
                        this.sendCheckInRequest();
                    } else {
                        this.showAlertNotValidCheckIn();
                    }
                    this.foundLocation = false;
                }
            }
        },

        components: {
            ListHints,
            FoundDestinations,
            CreateHint
        },

        mounted() {
            this.getDestinationTypes();
        },

        methods: {
            /**
             * Displays the countdown alert on the successful deletion of a quest.
             */
            showAlert() {
                this.dismissCountDown = this.dismissSeconds;
            },


            /**
             * Used to countdown the progress bar on an alert to countdown.
             *
             * @param dismissCountDown      the name of the alert.
             */
            countDownChanged(dismissCountDown) {
                this.dismissCountDown = dismissCountDown;
            },


            /**
             * Sends a request to check the users guess for a given quest attempt.
             * Displays appropriate messages upon receiving a response.
             *
             * @returns {Promise <Response | never>}     the fetch method promise.
             */
            checkGuess() {
                let self = this;
                return fetch('/v1/quests/attempt/' + this.questAttempt.id + '/guess/' + this.selectedDestination.id, {
                    method: "POST",
                    accept: "application/json"
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    if (responseBody.guessResult) {
                        self.goBack();
                        self.guessSuccess = true;
                        setTimeout(function() {
                            self.guessSuccess = false;
                        }, 3000);
                        self.showRewardToast(responseBody.reward);
                        self.$emit('updated-quest-attempt', responseBody.attempt);
                    } else {
                        // If unsuccessful guess
                        self.showError = true;
                        setTimeout(function() {
                            self.showError = false;
                        }, 3000)
                    }
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Resets all the appropriate variables and hides the search destination page when searching for a correct
             * answer to an objectives' riddle.
             */
            goBack() {
                this.pageDisplayed = 3;
                this.showDestinationSearchCollapse = true;
                this.showSelectedDestination = false;
                this.selectedDestination = {};
            },


            /**
             * Gets the current location using geolocation.
             */
            getCurrentLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(this.currentPosition);
                } else {
                    this.$bvToast.toast('Unable to Get Current Location', {
                        title: `Geolocation Error`,
                        variant: "danger",
                        autoHideDelay: "3000",
                        solid: true
                    });
                }
            },


            /**
             * Helper function of getCurrentLocation that saves lat/long to appropriate variables.
             *
             * @param position  the current position on the map.
             */
            currentPosition(position) {
                this.currentLocation.latitude = position.coords.latitude;
                this.currentLocation.longitude = position.coords.longitude;
                this.checkCurrentLocation();
            },


            /**
             * Checks if the user's current location is within the required radius for the current objective.
             */
            checkCurrentLocation() {
                let destinationLocation = new google.maps.LatLng(
                    this.questAttempt.toCheckIn.destination.latitude,
                    this.questAttempt.toCheckIn.destination.longitude
                );
                let currentLocation = new google.maps.LatLng(this.currentLocation.latitude, this.currentLocation.longitude);
                this.totalDistance = google.maps.geometry.spherical.computeDistanceBetween(destinationLocation, currentLocation) * 0.001;
                this.validCheckIn = this.questAttempt.toCheckIn.radius >= this.totalDistance;
                this.foundLocation = true;
            },


            /**
             * Sends the request to check in to the current objective.
             *
             * @returns {Promise <Response | never>}     the fetch method promise.
             */
            sendCheckInRequest() {
                let self = this;
                fetch('/v1/quests/attempt/' + this.questAttempt.id + '/checkIn', {
                    method: "POST",
                    accept: "application/json"
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.$emit('updated-quest-attempt', responseBody.attempt);
                    self.showRewardToast(responseBody.reward);
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Retrieves the different destination types from the backend.
             *
             * @param updateDestinationTypes    the list to be updated with the specified destination types.
             */
            getDestinationTypes(updateDestinationTypes) {
                let self = this;
                fetch(`/v1/destinationTypes`, {
                    accept: "application/json"
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.destinationTypes =  responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Handles the emit event for when a destination is clicked in the search destination form.
             *
             * @param destination   the destination that has been clicked.
             */
            destinationClicked(destination) {
                this.selectedDestination = destination;
                this.showDestinationSearchCollapse = false;
                this.showSelectedDestination = true;
            },


            /**
             * Displays the search destination sidebar and sets the riddle to be displayed.
             *
             * @param riddle    the riddle to be displayed in the destination sidebar.
             */
            destinationSearch(riddle) {
                this.pageDisplayed = 0;
                this.searchedRiddle = riddle;
            },


            /**
             * Returns a string value for the distance from the user's current location to the location of the
             * objective destination.
             *
             * @returns a string value containing the total distance from the user to the objective destination.
             */
            getHowClose() {
                if (this.totalDistance && this.questAttempt.toCheckIn) {
                    let showDistance = this.totalDistance - this.questAttempt.toCheckIn.radius;
                    if (showDistance >= 1) {
                        return String(showDistance.toFixed(2)) + " kms";
                    }

                    return (Math.round(showDistance * 1000) + " metres");
                }
            },


            /**
             * Displays the countdown alert on being unable to check in to an objective.
             */
            showAlertNotValidCheckIn() {
                this.showNotValidCheckIn = this.dismissSeconds
            },


            /**
             * Used to allow an alert to countdown on being unable to check in to an objective.
             *
             * @param dismissCountDown      the name of the alert.
             */
            countDownChangedCheckIn(dismissCountDown) {
                this.showNotValidCheckIn = dismissCountDown
            },


            /**
             * Function from the emit of a successfully created hint and shows the rewards and resets the list hints
             * component.
             *
             * @param responseBody      the  emitted response body containing the reward.
             */
            successCreateHint(responseBody) {
                this.alertText = "Hint successfully created!";
                this.showAlert();
                this.showRewardToast(responseBody.reward);
                this.objective.numberOfHints += 1;
                this.pageDisplayed = 3;
            },


            /**
             * Toggle the showing/hiding of hints for a given objective.
             *
             * @param objectiveToToggle     objective to toggle the hints for.
             */
            toggleHints(objectiveToToggle) {
                if(this.objective === null || (this.objective.id !== objectiveToToggle.id)) {
                    this.objective = objectiveToToggle;
                } else {
                    this.objective = null;
                }
            }
        },
    }
</script>