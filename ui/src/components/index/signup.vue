<template>
    <div>
        <div id="firstSignup" v-if="showFirst">

            <!--Input fields for sign-up. Validates automatically-->
            <b-form>
                <b-form-group
                        id="fname-field"
                        label="First Name(s):"
                        label-for="first_name">
                    <b-form-input :state="fNameValidation"
                                  autofocus id="first_name"
                                  required
                                  trim type="text"
                                  v-model="firstName">
                    </b-form-input>
                    <b-form-invalid-feedback :state="fNameValidation">
                        Your first name must be between 1-100 characters and contain no numbers.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        id="mname-field"
                        label="Middle Name(s):"
                        label-for="middle_name">
                    <b-form-input :state="mNameValidation"
                                  id="middle_name"
                                  placeholder="Optional"
                                  trim
                                  type="text" v-model="middleName">
                    </b-form-input>
                    <b-form-invalid-feedback :state="mNameValidation">
                        Your middle name must be less than 100 characters and contain no numbers.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        id="lname-field"
                        label="Last Name(s):"
                        label-for="last_name">
                    <b-form-input :state="lNameValidation"
                                  id="last_name"
                                  required
                                  trim
                                  type="text" v-model="lastName"></b-form-input>
                    <b-form-invalid-feedback :state="lNameValidation">
                        Your last name must be between 1-100 characters and contain no numbers.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        description="Note: this will be your username"
                        id="email-field"
                        label="Email:"
                        label-for="email">
                    <b-form-input :state="emailValidation"
                                  id="email"
                                  required
                                  trim
                                  type="text" v-model="username"></b-form-input>
                    <b-form-invalid-feedback :state="emailValidation">
                        Your email must be valid and unique, and also contain no more than 100 characters.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        id="password-field"
                        label="Password:"
                        label-for="newPassword">
                    <b-form-input :state="passwordValidation"
                                  id="newPassword"
                                  required
                                  trim
                                  type="password" v-model="password"></b-form-input>
                    <b-form-invalid-feedback :state="passwordValidation">
                        Your password must be greater than 5 characters long and password must contain two of: Uppercase,
                        Lowercase, Number.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        description="Please re-enter your password"
                        id="rePassword-field"
                        label="Retype Password:"
                        label-for="rePassword">
                    <b-form-input :state="rePasswordValidation"
                                  id="rePassword"
                                  required
                                  trim
                                  type="password" v-model="rePassword"></b-form-input>
                    <b-form-invalid-feedback :state="rePasswordValidation">
                        This must be the same as the password and your must be greater than 5 characters long and
                        password must contain two of: Uppercase, Lowercase, Number.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        id="dateOfBirth-field"
                        label="Date of Birth:"
                        label-for="dateOfBirth">
                    <b-form-input :state="dateOfBirthValidation"
                                  id="dateOfBirth"
                                  min="1900-01-01"
                                  :max="todaysDate"
                                  required
                                  trim
                                  type="date" v-model="dateOfBirth"></b-form-input>
                    <b-form-invalid-feedback :state="dateOfBirthValidation">
                        You can't be born in the future or before 01/01/1900.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-form-group
                        id="gender-field"
                        label="Gender:"
                        label-for="gender">
                    <b-form-select :options="genderOptions"
                                   :state="genderValidation"
                                   id="gender"
                                   required
                                   trim v-model="gender"></b-form-select>
                    <b-form-invalid-feedback :state="genderValidation">
                        Please select a gender.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-alert dismissible v-model="showError" variant="danger">The form contains errors! Please ensure that
                    all fields are green
                </b-alert>
                <b-button @click="checkPersonalForm" block variant="primary">Next</b-button>

            </b-form>
        </div>

        <!--Fields for inputting nationalities, passports & traveller types-->
        <div v-if="showSecond" id="secondSignup">
            <b-alert v-model="showError" variant="danger" dismissible>
                <p class="wrapWhiteSpace">{{alertMessage}}</p>
            </b-alert>
            <b-form>
                <b-row>
                    <b-col>
                        <b-form-group
                                id="nationalities-field"
                                label="Your Nationality:"
                                label-for="nationality">
                            <b-form-select :state="nationalityValidation"
                                           id="nationality"
                                           multiple
                                           trim v-model="nationalities">
                                <option :value="{id: nationality.id, nationality: nationality.nationality,
                                    country: nationality.country}"
                                        v-for="nationality in nationalityOptions">
                                    {{nationality.nationality}}
                                </option>
                            </b-form-select>
                            <b-form-invalid-feedback :state="nationalityValidation">
                                Please select at least one nationality.
                            </b-form-invalid-feedback>
                        </b-form-group>
                    </b-col>

                    <b-col>
                        <b-form-group
                                id="passports-field"
                                label="Passport Country:"
                                label-for="passports">
                            <b-form-select
                                    id="passports"
                                    multiple
                                    trim v-model="passports">
                                <option :value="{id: nationality.id, country: nationality.country}"
                                        v-for="nationality in passportsSorted">
                                    {{nationality.country}}
                                </option>
                            </b-form-select>
                        </b-form-group>
                    </b-col>
                </b-row>

                <!--Carousel which displays an image specific to each option-->
                <b-form-group
                        id="travType-field"
                        label="Traveller Type:"
                        label-for="travellerTypeCarousel">
                    <b-carousel
                            background="#ababab"
                            controls
                            id="travellerTypeCarousel"
                            img-height="1080"
                            :interval="0"
                            img-width="1920"
                            indicators
                            style="text-shadow: 1px 1px 2px #333;">
                        <b-carousel-slide :caption="travType.travellerType"
                                          :img-src="travType.imgUrl"
                                          :key="travType.id"
                                          :state="travTypeValidation"
                                          :text="travType.description"
                                          v-for="travType in travTypeOptions">
                            <b-form-checkbox size="lg" :value="{id: travType.id, travellerType: travType.travellerType}"
                                             v-model="travellerTypes">
                            </b-form-checkbox>
                        </b-carousel-slide>
                    </b-carousel>
                    <b-form-invalid-feedback :state="travTypeValidation">
                        Please select at least one traveller type.
                    </b-form-invalid-feedback>
                </b-form-group>

                <b-button @click="previousPage">Back</b-button>
                <b-button @click="checkAssociateForm" class="float-right" variant="primary">Sign Up</b-button>
            </b-form>
        </div>

    </div>
</template>

<script>
    export default {
        name: "Signup",

        props: {
            nationalityOptions: Array,
            travTypeOptions: Array,
            createdByAdmin: {
                default() {
                    return false;
                }
            }
        },

        data: function () {
            return {
                showError: false,
                firstName: '',
                middleName: '',
                lastName: '',
                username: '',
                password: '',
                rePassword: '',
                dateOfBirth: '',
                gender: '',
                genderOptions: [
                    {value: 'Male', text: 'Male'},
                    {value: 'Female', text: 'Female'},
                    {value: 'Other', text: 'Other'}
                ],
                showFirst: true,
                showSecond: false,
                nationalities: [],
                passports: [],
                travellerTypes: [],
                validEmail: false,
                showSuccess: false,
                alertMessage: "",
                successMessage: ""
            }
        },

        computed: {
            /**
             * Validates a firstname input from the user.
             *
             * @returns {*} true if input is valid.
             */
            fNameValidation() {
                if (this.firstName.length === 0) {
                    return null;
                } else if (this.firstName.length > 100) {
                    return false;
                }
                let nameRegex = new RegExp("^(?=.{1,100}$)([a-zA-Z]+((-|'| )[a-zA-Z]+)*)$");
                return nameRegex.test(this.firstName);
            },


            /**
             * Validates a middlename input from the user.
             *
             * @returns {*} true if input is valid.
             */
            mNameValidation() {
                if (this.middleName.length > 100) {
                    return false;
                }
                let nameRegex = new RegExp("^(?=.{0,100}$)([a-zA-Z]+((-|'| )[a-zA-Z]+)*)$");
                return nameRegex.test(this.middleName) || this.middleName.length === 0;
            },


            /**
             * Validates a lastname input from the user.
             *
             * @returns {*} true if input is valid.
             */
            lNameValidation() {
                if (this.lastName.length === 0) {
                    return null;
                } else if (this.lastName.length > 100) {
                    return false;
                }
                let nameRegex = new RegExp("^(?=.{1,100}$)([a-zA-Z]+((-|'| )[a-zA-Z]+)*)$");
                return nameRegex.test(this.lastName);
            },


            /**
             * Validates a email input from the user.
             *
             * @returns {*} true if input is valid.
             */
            emailValidation() {
                if (this.username.length === 0) {
                    return null;
                } else if (this.username.length > 100) {
                    return false;
                }
                let emailRegex = new RegExp("^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$");
                this.checkUsername();
                return (emailRegex.test(this.username) && this.validEmail);
            },


            /**
             * Validates a users password.
             *
             * @returns {*} true if input is valid.
             */
            passwordValidation() {
                if (this.password.length === 0) {
                    return null;
                }
                let passwordRegex =
                    new RegExp("^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{5,})");
                return passwordRegex.test(this.password)
            },


            /**
             * Ensures the retyped password is non empty and equal to the first typed password.
             *
             * @returns {*} true if input is valid.
             */
            rePasswordValidation() {
                if (this.rePassword.length === 0) {
                    return null;
                }
                let passwordRegex =
                    new RegExp("^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{5,})");
                return this.password.length > 0 && this.rePassword === this.password && passwordRegex.test(this.rePassword);
            },


            /**
             * Validates a date of birth input from the user.
             *
             * @returns {*} true if input is valid.
             */
            dateOfBirthValidation() {
                if (this.dateOfBirth.length === 0) {
                    return null;
                }
                let minDate = "1900-01-01";
                return this.dateOfBirth.length > 0 && this.dateOfBirth <= this.todaysDate && this.dateOfBirth >= minDate;
            },


            /**
             * Validates a gender selection from the user.
             *
             * @returns {*} true if input is valid.
             */
            genderValidation() {
                if (this.gender.length === 0) {
                    return null;
                }
                return this.gender.length > 0;
            },


            /**
             * Validates the nationality selection input from the user.
             *
             * @returns {*} true if input is valid.
             */
            nationalityValidation() {
                if (this.nationalities.length === 0) {
                    return null;
                }
                return this.nationalities.length > 0;
            },


            /**
             * Validates the traveller type input from the user.
             *
             * @returns {*} true if input is valid.
             */
            travTypeValidation() {
                if (this.travellerTypes.length === 0) {
                    return null;
                }
                return this.travellerTypes.length > 0;
            },


            /**
             * Get the current date and return it in the format.
             * yyyy-mm-dd.
             *
             * @returns the current date in format yyyy-mm-dd
             */
            todaysDate() {
                let today = new Date();
                let dd = today.getDate();
                let mm = today.getMonth() + 1; //January is 0!
                let yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = yyyy + '-' + mm + '-' + dd;
                return today
            },


            /**
             * Sorts nationality options by their country value for passports.
             *
             * @returns a list of sorted nationalities.
             */
            passportsSorted() {
                let passportOptions = JSON.parse(JSON.stringify(this.nationalityOptions));
                return passportOptions.sort((a, b) => (a.country > b.country) ? 1 : -1)
            }

        },

        methods: {
            /**
             * Runs validation for all fields on first page.
             */
            checkPersonalForm() {
                if (this.fNameValidation && this.mNameValidation && this.lNameValidation
                    && this.emailValidation && this.passwordValidation && this.rePasswordValidation
                    && this.dateOfBirthValidation && this.genderValidation) {
                    this.showError = false;
                    this.nextPage();
                } else {
                    this.showError = true;
                    return false
                }
            },


            /**
             * Runs second page validation and creates an object using all inputs.
             */
            checkAssociateForm() {
                if (this.nationalityValidation && this.travTypeValidation) {
                    let profile = {
                        firstName: this.firstName,
                        middleName: this.middleName,
                        lastName: this.lastName,
                        username: this.username.toLowerCase(),
                        password: this.password,
                        dateOfBirth: this.dateOfBirth,
                        gender: this.gender,
                        nationalities: this.nationalities,
                        passports: this.passports,
                        travellerTypes: this.travellerTypes
                    };
                    this.saveProfile(profile);
                } else {
                    this.showError = true;
                    this.alertMessage = "You must select a Nationality and a Traveller Type";
                }
            },


            /**
             * Checks that user does not already exist in database.
             */
            checkUsername() {
                let self = this;
                fetch(`/v1/checkUsername`, {
                    method: 'POST',
                    headers: {'content-type': 'application/json'},
                    body: JSON.stringify({'username': this.username.toLowerCase()})

                }).then(function (response) {
                    self.validEmail = response.ok;
                })

            },


            /**
             * Transfers to second page of sign-up.
             */
            nextPage() {
                this.showFirst = false;
                this.showSecond = true;
            },


            /**
             * Transfers to first page of sign-up.
             */
            previousPage() {
                this.showFirst = true;
                this.showSecond = false;
            },


            /**
             * Adds user to database. If the person creating the profile is an administrator, then the page is not
             * automatically redirected to the dash.
             *
             * @param profile   object created with all input values.
             */
            saveProfile(profile) {
                let self = this;
                fetch('/v1/profiles', {
                    method: 'POST',
                    headers: {'content-type': 'application/json'},
                    body: JSON.stringify(profile)
                }).then(function (response) {
                    if (!response.ok) {
                        throw response;
                    } else {
                        return response;
                    }
                }).then(function (response) {
                    if (response.status === 201 && !self.createdByAdmin) {
                        self.updateActivity();
                        self.$router.push('/profile');
                    } else if (response.status === 201 && self.createdByAdmin) {
                        self.updateActivity();
                        self.$emit('profile-created', true);
                    }
                }).catch(function (response) {
                    self.handleErrorResponse(response);
                });
            }
        }
    }
</script>