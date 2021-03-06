package repositories.objectives;

import com.google.inject.Inject;
import io.ebean.BeanRepository;
import io.ebean.Ebean;
import models.destinations.Destination;
import models.objectives.Objective;
import models.profiles.Profile;
import models.quests.QuestAttempt;
import repositories.quests.QuestAttemptRepository;

import java.util.List;


/**
 * Handles database interaction for objectives.
 * Extends the BeanRepository containing all CRUD methods.
 */
public class ObjectiveRepository extends BeanRepository<Long, Objective> {

    private static final String DESTINATION = "destination";

    private QuestAttemptRepository questAttemptRepository;

    @Inject
    public ObjectiveRepository(QuestAttemptRepository questAttemptRepository) {
        super(Objective.class, Ebean.getDefaultServer());
        this.questAttemptRepository = questAttemptRepository;
    }


    /**
     * Retrieve all objectives that use the destination.
     *
     * @param destination   the destination being checked for usage within objectives.
     * @return              a potentially empty list of objectives that contain contain the destination parameter.
     */
    public List<Objective> findAllUsing(Destination destination) {
        return query()
                .where()
                .eq(DESTINATION, destination)
                .findList();
    }


    /**
     * Will check if a given user has solved a given objective.
     *
     * @param profile       the user to check if they have solved the objective.
     * @param objective     the objective to check the solved status of.
     * @return              true if the profile has solved the objective.
     */
    public boolean hasSolved(Profile profile, Objective objective) {

        // Find the quest attempt relating to the profile and objective.
        QuestAttempt questAttempt = questAttemptRepository.findUsing(profile, objective);

        // If the quest attempt does not exist, the profile has not attempted a quest with the objective.
        if (questAttempt == null) {
            return false;
        }

        // Check if the objective is the most recently solved in the quest attempt.
        boolean currentSolved = (questAttempt.getCurrentToCheckIn() != null
                && questAttempt.getCurrentToCheckIn().equals(objective));

        return currentSolved || questAttempt.getCheckedIn().contains(objective);
    }
}
