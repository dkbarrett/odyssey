<template>
    <div>
        <b-alert dismissible v-model="showError" variant="danger">
            <p class="wrapWhiteSpace">
                {{alertMessage}}
            </p>
        </b-alert>

        <b-form @submit.prevent="searchProfiles">
            <!--Input fields for searching for destinations-->
            <b-form-group
                    id="name-field"
                    label="Name:"
                    label-for="name">
                <b-form-input id="name"
                              v-model="searchParameters.name">
                </b-form-input>
            </b-form-group>
            <b-form-row>
                <b-col>
                    <b-form-group
                            id="nationalities-field"
                            label="Nationality:"
                            label-for="nationality">
                        <b-form-select id="nationality" trim v-model="searchParameters.nationality">
                            <template slot="first">
                                <option :value="''">-- Any --</option>
                            </template>
                            <option :value="nationality.nationality"
                                    v-for="nationality in nationalityOptions">
                                {{nationality.nationality}}
                            </option>
                        </b-form-select>
                    </b-form-group>
                </b-col>
                <b-col>
                    <b-form-group
                            id="gender-field"
                            label="Gender:"
                            label-for="gender">
                        <b-form-select :options="genderOptions" id="gender" trim v-model="searchParameters.gender">
                            <template slot="first">
                                <option :value="''">-- Any --</option>
                            </template>
                        </b-form-select>
                    </b-form-group>
                </b-col>
            </b-form-row>
            <b-form-row>
                <b-col>

                    <b-form-group
                            id="travType-field"
                            label="Traveller Type:"
                            label-for="travType">
                        <b-form-select id="travType" trim v-model="searchParameters.travellerType">
                            <template>
                                <option :value="''" selected="selected">-- Any --</option>
                            </template>
                            <option :value="travType.travellerType"
                                    v-for="travType in travellerTypeOptions">
                                {{travType.travellerType}}
                            </option>
                        </b-form-select>
                    </b-form-group>
                </b-col>
                <b-col>
                    <b-form-group
                            label="Rank:">
                        <b-input-group>
                            <b-form-input v-model="searchParameters.rank"
                                          type="number">
                            </b-form-input>
                            <b-input-group-append>
                                <b-button variant="outline-info" @click="searchParameters.rank = userProfile.achievementTracker.rank" size="sm">My Rank</b-button>
                            </b-input-group-append>
                        </b-input-group>
                    </b-form-group>
                </b-col>
            </b-form-row>
            <b-form-group id="age-field" label="Age Range:" label-for="age-slider">
                <small>{{searchParameters.age[0]}} - {{searchParameters.age[1]}}</small>
                <vue-slider id="age-slider" :max=120 v-model="searchParameters.age"></vue-slider>
            </b-form-group>

            <b-button @click="searchProfiles" block variant="primary" type="submit">Search</b-button>
            <b-button class="show-only-desktop" @click="clearForm" block variant="outline-primary" size="sm">Clear Form</b-button>
        </b-form>
    </div>
</template>

<script>
    export default {
        name: "profileSearchForm",

        props: {
            userProfile: Object
        },

        data() {
            return {
                searchParameters: {
                    name: "",
                    nationality: "",
                    gender: "",
                    age: [0, 120],
                    travellerType: "",
                    rank: ""
                },
                travellerTypeOptions: [],
                nationalityOptions: [],
                showError: false,
                alertMessage: "",
                genderOptions: [
                    {value: 'Male', text: 'Male'},
                    {value: 'Female', text: 'Female'},
                    {value: 'Other', text: 'Other'}
                ]
            }
        },

        mounted() {
            this.getTravellerTypes();
            this.getNationalities();
        },

        methods: {
            /**
             * Changes fields so that they can be used in searching.
             * Runs validation on range fields.
             */
            searchProfiles() {
                this.searchParameters.age[0] = parseInt(this.searchParameters.age[0]);
                this.searchParameters.age[1] = parseInt(this.searchParameters.age[1]);
                if (isNaN(this.searchParameters.age[0]) || isNaN(this.searchParameters.age[1])) {
                    this.showError = true;
                    this.alertMessage = "Min or Max Age are not numbers";
                } else if (this.searchParameters.age[0] > this.searchParameters.age[1]) {
                    this.showError = true;
                    this.alertMessage = "Min age is greater than max age";
                }  else if (this.searchParameters.name.length > 100) {
                    this.showError = true;
                    this.alertMessage = "Input length must be less than 100 characters";
                }   else if (this.searchParameters.rank.length > 9) {
                    this.showError = true;
                    this.alertMessage = "Rank cannot be greater than 999,999,999";
                } else {
                    this.showError = false;
                    this.$emit('search', this.searchParameters);
                }
            },


            /**
             * Retrieves all the traveller types.
             *
             * @returns {Promise <Response | never>}     the fetch method promise.
             */
            getTravellerTypes() {
                let self = this;
                return fetch(`/v1/travtypes`, {
                    accept: "application/json"
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.travellerTypeOptions = responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Retrieves all the nationalities.
             *
             * @returns {Promise <Response | never>}     the fetch method promise.
             */
            getNationalities() {
                let self = this;
                return fetch(`/v1/nationalities`, {
                    accept: "application/json"
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response.json();
                    }
                }).then(function (responseBody) {
                    self.nationalityOptions = responseBody;
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            },


            /**
             * Clears the search profile form and researches for profiles.
             */
            clearForm() {
                this.searchParameters = {
                    name: "",
                    nationality: "",
                    gender: "",
                    age: [0, 120],
                    travellerType: "",
                    rank: ""
                };
                this.$emit('cleared-form');
            }
        }

    }
</script>