<template>
    <div v-if="profile">
        <div class="pb-5">
            <!--Navigation Bar-->
            <nav-bar-main :profile="profile" @clear-profile="$emit('clear-profile')"></nav-bar-main>
            <b-navbar variant="light" class="d-none d-lg-block">
                <b-navbar-nav>
                    <b-nav-item @click="togglePage(viewProfile, 'view')" :class="{'active': viewProfile}">Profile</b-nav-item>
                    <b-nav-item @click="togglePage(editProfile, 'edit')" :class="{'active': editProfile}">Edit Profile</b-nav-item>
                </b-navbar-nav>
            </b-navbar>
            <div>
                <!--Tab Elements-->
                <view-profile
                        :destinations="destinations"
                        :nationalityOptions="nationalityOptions"
                        :profile="profile"
                        :userProfile="profile"
                        :travTypeOptions="travTypeOptions"
                        :trips="trips"
                        @edit-profile="togglePage(editProfile)"
                        v-if="viewProfile">
                </view-profile>
                <edit-profile
                        :admin-view="adminView"
                        :nationalityOptions="nationalityOptions"
                        :profile="profile"
                        :showSaved="showSaved"
                        :travTypeOptions="travTypeOptions"
                        @profile-saved="showSavedProfile"
                        v-if="editProfile">
                </edit-profile>
            </div>
        </div>
        <footer-main></footer-main>
    </div>
    <div v-else>
        <unauthorised-prompt></unauthorised-prompt>
    </div>
</template>

<script>

    import ViewProfile from "./viewProfile.vue"
    import EditProfile from "./editProfile.vue"
    import NavBarMain from '../helperComponents/navbarMain.vue'
    import FooterMain from '../helperComponents/footerMain.vue'
    import UnauthorisedPrompt from '../helperComponents/unauthorisedPromptPage'

    export default {
        name: "dashPage",

        props: ['nationalityOptions', 'travTypeOptions', 'profile', 'trips', 'adminView', 'destinations'],

        data: function () {
            return {
                viewProfile: true,
                editProfile: false,
                showSaved: false
            }
        },

        methods: {
            /**
             * Switches between tabs.
             *
             * @param viewPage page to be displayed.
             */
            togglePage: function (viewPage) {
                if (!viewPage) {
                    this.viewProfile = !this.viewProfile;
                    this.editProfile = !this.editProfile;
                }
            },


            /**
             * Shows the profile has been successfully saved alert.
             */
            showSavedProfile() {
                this.showSaved = true;
                this.togglePage(this.viewProfile);
                this.$emit('fetch-profile');
            }
        },

        components: {
            ViewProfile,
            EditProfile,
            NavBarMain,
            FooterMain,
            UnauthorisedPrompt
        }
    }
</script>