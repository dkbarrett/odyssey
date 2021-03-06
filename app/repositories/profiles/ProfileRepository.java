package repositories.profiles;

import com.google.inject.Inject;
import io.ebean.BeanRepository;
import io.ebean.Ebean;
import io.ebean.ExpressionList;
import models.profiles.Profile;
import models.quests.Quest;

import java.util.List;


/**
 * Handles database interaction for profiles.
 * Extends the BeanRepository containing all CRUD methods.
 */
public class ProfileRepository extends BeanRepository<Long, Profile> {

    private static final String QUEST_ATTEMPTED = "questAttempts.questAttempted";

    @Inject
    public ProfileRepository() {
        super(Profile.class, Ebean.getDefaultServer());
    }

    public ExpressionList<Profile> getExpressionList() {
        return query().where();
    }


    /**
     * Fetches all the profiles that have the specified quest active
     *
     * @param usedQuest   the quest selected to be queried for associated profiles.
     * @return                  a list of all the profiles found.
     */
    public List<Profile> findAllUsing(Quest usedQuest) {

        return query().where().eq(QUEST_ATTEMPTED, usedQuest).findList();
    }


    public int findCount() {
        return query().where().findCount();
    }
}