<template>
    <div v-if="profile">
        <!--Shows tabs for the quest page-->
        <navbar-main v-bind:profile="profile" v-if="!adminView"></navbar-main>
        <div class="bg-white m-2 pt-3 pl-3 pr-3 pb-5 rounded-lg d-none d-lg-block h-100">
            <h1 class="page-title">Quests</h1>
            <p class="page-title">
                <i>Here you can view and create Quests!</i>
            </p>
            <b-card>
                <b-tabs content-class="mt-3"
                        v-model="tabIndex">
                    <b-tab title="Active Quests" @click="refreshQuests = !refreshQuests" active>
                        <active-quest-page
                                :profile="profile"
                                :refresh-quests="refreshQuests"
                                :new-quest-attempt="newQuestAttempt">
                        </active-quest-page>
                    </b-tab>
                    <b-tab title="Available Quests" @click="refreshQuests = !refreshQuests">
                        <quest-list
                                :profile="profile"
                                :available-quests="true"
                                :refresh-quests="refreshQuests"
                                @start-quest-now="questAttempt => changeToActiveTab(questAttempt)"
                        ></quest-list>
                    </b-tab>
                    <b-tab title="Your Quests" @click="refreshQuests = !refreshQuests">
                        <quest-list
                                :profile="profile"
                                :your-quests="true"
                                :refresh-quests="refreshQuests"
                        ></quest-list>
                    </b-tab>
                    <b-tab title="Completed Quests" @click="refreshQuests = !refreshQuests">
                        <quest-list
                                :profile="profile"
                                :completed-quests="true"
                                :refresh-quests="refreshQuests"
                        ></quest-list>
                    </b-tab>
                    <b-tab title="Your Objectives" @click="refreshObjectives = !refreshObjectives">
                        <objective-page :profile="profile" :admin-view="false" :refresh-objectives="refreshObjectives">
                        </objective-page>
                    </b-tab>
                </b-tabs>
            </b-card>
        </div>
        <div class="show-only-mobile">
            <quests-solve-mobile
                    :profile="profile">
            </quests-solve-mobile>
        </div>
        <footer-main v-if="!adminView"></footer-main>
    </div>

    <div v-else>
        <unauthorised-prompt-page></unauthorised-prompt-page>
    </div>
</template>

<script>
    import NavbarMain from "../helperComponents/navbarMain";
    import UnauthorisedPromptPage from "../helperComponents/unauthorisedPromptPage";
    import FooterMain from "../helperComponents/footerMain";
    import QuestList from "./questList";
    import QuestsSolveMobile from "./activeQuestPageMobile";
    import QuestAttemptSolve from "./activeQuestSolve";
    import ActiveQuestPage from "./activeQuestPage";
    import ObjectiveList from "../objectives/objectiveList";
    import ObjectivePage from "../objectives/objectivePage";

    export default {
        name: "questPage",

        props: {
            profile: Object,
            adminView: {
                default: function () {
                    return false;
                }
            }
        },

        data() {
            return {
                selectedDestination: {},
                showDestinations: false,
                refreshObjectives: false,
                refreshQuests: false,
                tabIndex: 0,
                newQuestAttempt: null
            }
        },

        methods: {
            /**
             * Switches to the 'active' page and refreshes the quest list.
             * The 'active' page has an index of 0.
             *
             * @param questAttempt      the quest attempt to be displayed on the active quests page.
             */
            changeToActiveTab(questAttempt) {
                this.tabIndex = 0;
                this.newQuestAttempt = questAttempt;
                this.refreshQuests = !this.refreshQuests;
            }
        },

        components: {
            ObjectivePage,
            ObjectiveList,
            ActiveQuestPage,
            QuestAttemptSolve,
            QuestsSolveMobile,
            QuestList,
            FooterMain,
            UnauthorisedPromptPage,
            NavbarMain,
        }
    }
</script>