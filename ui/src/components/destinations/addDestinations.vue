<template>
    <div>
        <h4 class="page-title">{{heading}} a Destination
            <b-img id="add_destination_info" height="25%" :src="assets['information']"></b-img></h4>

        <!-- Info tooltip for public search -->
        <b-tooltip target="add_destination_info" title="" placement="bottom">
            <strong><i>How to Create a Destination</i></strong> <br><br>

            Fill out all the fields to create your new destination. <br><br>

            You may click on a location on the map and the Latitude and Longitude values will be automatically populated in the form. <br>
            Alternatively, you may click the Use Current Location button to populate the form with your current location details. <br>
            Note: Latitude and Longitude values must be numbers and you cannot have identical destinations<br><br>

            This destination will now be available in the list of Your Destinations.
        </b-tooltip>

        <b-alert dismissible v-model="showError" variant="danger"><p class="wrapWhiteSpace">{{errorMessage}}</p></b-alert>

        <!--Displays a progress bar alert on submission which ticks down time to act
        as a buffer for destination being added-->
        <b-alert
                :show="dismissCountDown"
                @dismiss-count-down="countDownChanged"
                @dismissed="dismissCountDown=0"
                dismissible
                variant="success">
            <p>Destination Successfully {{heading}}ed</p>
            <b-progress
                    :max="dismissSecs"
                    :value="dismissCountDown - 1"
                    height="4px"
                    variant="success"
            ></b-progress>
        </b-alert>

        <b-modal id="confirmEditModal" ref="confirmEditModal" size="l" title="Confirm Edit">
            <div>
                Are you sure you want to edit this destination?
                <div v-if="destinationConflicts.matching_trips !== undefined
                        && destinationConflicts.matching_trips.length > 0">
                    <p v-if="destinationConflicts.trip_count === 1">
                        This would affect the following {{destinationConflicts.trip_count}} trip:
                    </p>
                    <p v-else>
                        This would affect the following {{destinationConflicts.trip_count}} trips:
                    </p>
                    <b-list-group
                            style="overflow-y: scroll; height: 30vh;">
                        <b-list-group-item class="flex-column align-items-start"
                                           v-for="trip in destinationConflicts.matching_trips" :key="trip.id">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Name: {{trip.name}}</h5>
                            </div>
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Created by: {{trip.profile.firstName}} {{trip.profile.lastName}}</h5>
                            </div>
                        </b-list-group-item>
                    </b-list-group>
                </div>
                <div v-if="editDestinationConflicts !== undefined && editDestinationConflicts.destination_count > 0">
                    <p v-if="editDestinationConflicts.destination_count === 1">
                        This will merge the following destination:
                    </p>

                    <p v-else>
                        This will merge the following {{editDestinationConflicts.destination_count}} destinations:
                    </p>
                    <b-list-group
                            style="overflow-y: scroll; height: 30vh;">
                        <b-list-group-item class="flex-column align-items-start"
                                           v-for="destination in editDestinationConflicts.matching_destinations"
                                           :key="destination.id">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Name: {{destination.name}}</h5>
                            </div>
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Created by: {{destination.owner.firstName}}
                                    {{destination.owner.lastName}}</h5>
                            </div>
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">{{convertToPublicString(destination.public)}} Destination</h6>
                            </div>
                        </b-list-group-item>
                    </b-list-group>
                </div>
            </div>
            <template slot="modal-footer">
                <b-col>
                    <b-button @click="dismissModal('confirmEditModal')"
                              class="mr-2 float-right"
                              block
                              variant="danger">Cancel
                    </b-button>
                </b-col>
                <b-col>
                    <b-button @click="editDestination" class="mr-2 float-right" block variant="success">
                        Confirm
                    </b-button>
                </b-col>
            </template>
        </b-modal>

        <!--Form for adding a destination-->
        <div>
            <b-form>
                <b-form-group
                        id="name-field"
                        label="Destination Name:"
                        label-for="name">
                    <b-form-input id="name" @click="showError = false" v-model="inputDestination.name" type="text"
                                  required
                                  :state="destinationNameValidation">
                    </b-form-input>
                </b-form-group>
                <b-form-group
                        id="type-field"
                        label="Destination Type:"
                        label-for="type">
                    <b-form-select id="type" v-model="inputDestination.type.id" trim :state="destinationTypeValidation">
                        <option v-for="destination in destinationTypes" :value="destination.id">
                            {{destination.destinationType}}
                        </option>
                    </b-form-select>
                </b-form-group>

                <b-form-group
                        id="district-field"
                        label="District:"
                        label-for="district">
                    <b-form-input id="district"
                                  @click="showError=false"
                                  v-model="inputDestination.district"
                                  type="text"
                                  trim
                                  required
                                  :state="destinationDistrictValidation">
                    </b-form-input>
                </b-form-group>

                <b-form-group
                        id="latitude-field"
                        label="Latitude:"
                        label-for="latitude">
                    <b-form-input id="latitude"
                                  v-model="inputDestination.latitude"
                                  type="text"
                                  trim required
                                  :state="destinationLatitudeValidation"></b-form-input>
                    <b-form-invalid-feedback :state="destinationLatitudeValidation">
                        {{latitudeErrorMessage}}
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        id="longitude-field"
                        label="Longitude:"
                        label-for="longitude">
                    <b-form-input id="longitude"
                                  v-model="inputDestination.longitude"
                                  type="text"
                                  trim required
                                  :state="destinationLongitudeValidation"></b-form-input>
                    <b-form-invalid-feedback :state="destinationLongitudeValidation">
                        {{longitudeErrorMessage}}
                    </b-form-invalid-feedback>
                </b-form-group>

                <get-location-button
                        @get-current-location="currentCoordinates => setCurrentLocation(currentCoordinates)">
                </get-location-button>

                <b-form-group
                        id="country-field"
                        label="Country:"
                        label-for="country">
                    <!--Dropdown field for country types-->
                    <b-form-select id="country" trim v-model="inputDestination.country" required>
                        <option :value="country.name" v-for="country in countryList"
                                :state="destinationCountryValidation">
                            {{country.name}}
                        </option>
                    </b-form-select>
                </b-form-group>

                <b-form-checkbox
                        v-if="inputDestination.id !== null"
                        switch
                        v-model="inputDestination.public"
                        required>
                    {{isPublic}} Destination
                </b-form-checkbox>

                <b-button :disabled="!validateFields()" @click="checkDestinationFields" block variant="primary">Save
                </b-button>
            </b-form>
        </div>
    </div>
</template>

<script>
    import GetLocationButton from "../map/getLocationButton";

    export default {
        name: "addDestinations",

        components: {
            GetLocationButton
        },

        props: {
            profile: Object,
            heading: String,
            inputDestination: {
                default: function () {
                    return {
                        id: null,
                        name: "",
                        type: {
                            id: null,
                            destinationType: ""
                        },
                        district: "",
                        latitude: null,
                        longitude: null,
                        country: "",
                        public: false
                    }
                }
            }
        },

        data() {
            return {
                showError: false,
                errorMessage: "",
                dismissSecs: 3,
                dismissCountDown: 0,
                latitudeErrorMessage: "",
                longitudeErrorMessage: "",
                destinationConflicts: [],
                editDestinationConflicts: [],
                countryList: [],
                destinationTypes: []
            }
        },

        mounted() {
            this.getCountries();
            this.getDestinationTypes();
        },

        computed: {
            /**
             * Validates the name input field. Name is valid when it contains more than one character.
             *
             * @return{*}     true if input is valid.
             */
            destinationNameValidation() {
                if (this.inputDestination.name.length === 0) {
                    return null;
                } else if (this.inputDestination.name.length > 100) {
                    return false
                }
                return this.inputDestination.name.length > 0;
            },


            /**
             * Validates the type input field. Type is valid when the type has been selected.
             *
             * @return{*}     true if input is valid.
             */
            destinationTypeValidation() {
                if (this.inputDestination.type.id == null) {
                    return null;
                }
                return this.inputDestination.type.length > 0 || this.inputDestination.type !== null;
            },


            /**
             * Validates the district input field. District is valid when the district has been selected.
             *
             * @return{*}     true if input is valid.
             */
            destinationDistrictValidation() {
                if (this.inputDestination.district.length === 0) {
                    return null;
                } else if (this.inputDestination.district.length > 100) {
                    return false
                }
                return this.inputDestination.district.length > 0;
            },


            /**
             * Validates the latitude input field. Latitude is valid when it contains only numeric characters, is not
             * empty, and is within the range -90 to 90.
             *
             * @return{*}     true if input is valid.
             */
            destinationLatitudeValidation() {
                if (this.inputDestination.latitude === null || this.inputDestination.latitude.length === 0) {
                    return null;
                } else if (isNaN(this.inputDestination.latitude)) {
                    this.latitudeErrorMessage = "Latitude: '" + this.inputDestination.latitude + "' is not a number!";
                    return false;
                } else if (this.inputDestination.latitude > 90 || this.inputDestination.latitude < -90) {
                    this.latitudeErrorMessage = "Latitude: '" + this.inputDestination.latitude + "' must be between " +
                        "-90 and 90";
                    return false;
                } else {
                    return true;
                }

            },


            /**
             * Validates the longitude input field. Longitude is valid when it contains only numeric characters, is not
             * empty, and is within the range -180 to 180.
             *
             * @return{*}     true if input is valid.
             */
            destinationLongitudeValidation() {
                if (this.inputDestination.longitude === null || this.inputDestination.longitude.length === 0) {
                    return null;
                } else if (isNaN(this.inputDestination.longitude)) {
                    this.longitudeErrorMessage = "Longitude: '" + this.inputDestination.longitude + "' is not a number!";
                    return false;
                } else if (this.inputDestination.longitude > 180 || this.inputDestination.longitude < -180) {
                    this.longitudeErrorMessage = "Longitude: '" + this.inputDestination.longitude + "' must be between " +
                        "-180 and 180";
                    return false;
                } else {
                    return true;
                }
            },


            /**
             * Validates the country input field. Country is valid when it contains more than one character, and is not
             * a number.
             *
             * @return{*}     true if input is valid.
             */
            destinationCountryValidation() {
                if (this.inputDestination.country === null) {
                    return null;
                }
                return this.inputDestination.country.length > 0 || this.inputDestination.country !== null;
            },


            /**
             * Tells users editing a destination whether they've made the destination public or private.
             *
             * @return{string}    public or private depending on the input destination privacy.
             */
            isPublic() {
                if (this.inputDestination.public) {
                    return "Public";
                }
                return "Private";
            }
        },

        methods: {
            /**
             * Retrieves the different destination types from the backend.
             */
            getDestinationTypes() {
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
                    self.destinationTypes = responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Sets the countries list to the list of countries from the country api.
             */
            getCountries() {
                let self = this;
                return fetch("https://restcountries.eu/rest/v2/all", {
                    dataType: 'html'
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.countryList = responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Checks all of the input fields for valid input.
             */
            validateFields() {
                return this.destinationNameValidation && this.destinationTypeValidation
                    && this.destinationDistrictValidation && this.destinationLatitudeValidation
                    && this.destinationLongitudeValidation && this.destinationCountryValidation
            },


            /**
             * Checks that all fields are present and runs validation.
             * On fail shows errors.
             */
            checkDestinationFields() {
                if (this.validateFields()) {
                    this.showError = false;

                    if (this.inputDestination.id === null) {
                        this.addDestination();
                    } else {
                        this.validateEdit();
                    }
                    return true;
                }
                else {
                    this.errorMessage = ("Please enter in all fields!");
                    this.showError = true;
                    return false;
                }
            },


            /**
             * Sets all fields to blank.
             */
            resetDestForm() {
                this.inputDestination.name = "";
                this.inputDestination.type = {
                    id: null,
                    destinationType: "",
                };
                this.inputDestination.district = "";
                this.inputDestination.latitude = null;
                this.inputDestination.longitude = null;
                this.inputDestination.country = "";
                this.inputDestination.public = false;
            },


            /**
             * Adds new destination to database, then resets form and shows success alert.
             * Checks whether location is duplicate and displays error if so.
             */
            addDestination() {
                let self = this;
                fetch(`/v1/destinations/` + this.profile.id, {
                    method: 'POST',
                    headers: {'content-type': 'application/json'},
                    body: (JSON.stringify({
                        "name": this.inputDestination.name,
                        "type_id": this.inputDestination.type.id,
                        "district": this.inputDestination.district,
                        "latitude": parseFloat(this.inputDestination.latitude),
                        "longitude": parseFloat(this.inputDestination.longitude),
                        "country": this.inputDestination.country,
                        "is_public": this.inputDestination.public
                    }))
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.resetDestForm();
                    self.showAlert();
                    self.showRewardToast(responseBody.reward);
                    return responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Checks whether the destination being edited is present in any other parts of the application.
             * This is to display a confirmation message to the user.
             */
            validateEdit() {
                let self = this;
                fetch(`/v1/destinations/` + this.inputDestination.id + `/checkDuplicates`, {
                    accept: "application/json"
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.destinationConflicts = responseBody;
                    self.getMatchingEditedDestination();
                    self.displayConfirmation();
                    return responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Retrieves all the destinations that match the requested destination after it has been modified.
             */
            getMatchingEditedDestination() {
                let self = this;
                fetch(`/v1/destinationsCheckEdit`, {
                    method: 'POST',
                    headers: {'content-type': 'application/json'},
                    body: (JSON.stringify(this.inputDestination))
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.editDestinationConflicts = responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Displays the confirmation edit modal.
             */
            displayConfirmation() {
                this.$refs["confirmEditModal"].show();
            },


            /**
             * Sends the edited destination to the Http endpoint to be saved.
             */
            editDestination() {
                let self = this;
                let jsonBody = JSON.stringify(this.inputDestination);

                fetch(`/v1/destinations/` + this.inputDestination.id, {
                    method: 'PUT',
                    headers: {'content-type': 'application/json'},
                    body: jsonBody
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.showAlert();
                    self.dismissModal('confirmEditModal');
                    self.$emit('destination-saved', responseBody);
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Updates the latitude & longitude when emitted from the button that gets current location.
             */
            setCurrentLocation(currentCoordinates) {
                this.inputDestination.latitude = currentCoordinates.latitude;
                this.inputDestination.longitude = currentCoordinates.longitude;
            },


            /**
             * Used to allow an alert to countdown on the successful saving of a destination.
             *
             * @param dismissCountDown      the name of the alert.
             */
            countDownChanged(dismissCountDown) {
                this.dismissCountDown = dismissCountDown
            },


            /**
             * Displays the countdown alert on the successful saving of a destination.
             */
            showAlert() {
                this.dismissCountDown = this.dismissSecs
            },


            /**
             * Used to dismiss the edit a destination modal.
             *
             * @param modal, the modal that is wanting to be dismissed.
             */
            dismissModal(modal) {
                this.$refs[modal].hide();
            },


            /**
             * Converts the given boolean value to a readable string.
             *
             * @param isPublic      boolean value false if the destination is not public, true otherwise.
             * @return{string}    returns a string 'Public' or 'Private' depending on the given parameter.
             */
            convertToPublicString(isPublic) {
                if (isPublic) {
                    return "Public";
                }
                return "Private";
            }
        }
    }
</script>