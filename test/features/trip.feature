Feature: Trip API Endpoint

  Scenario: Add a new trip with two destinations
    Given I have an application running
    And I am logged in with credentials
      | Username                | Password  |
      | admin@travelea.com      | admin1    |
    When the following json containing a trip is sent:
      """
        {
          "trip_name": "A Holiday Away",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : "1990-12-12",
              "end_date" : "1991-12-12"
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is Created


  Scenario: Delete a trip as the trip's owner
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I own the trip with the following data
      """
        {
          "trip_name": "Test Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I delete the trip with the following name
      | Name            |
      | Test Adventure  |
    Then the response status code is OK


  Scenario: Delete other user's trip as an admin
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | admin@travelea.com      |
    And I do not own the trip with the following data
      """
        {
          "trip_name": "Test Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I delete the trip with the following name
      | Name            |
      | Test Adventure  |
    Then the response status code is OK


  Scenario: Delete a another user's trip as a standard user
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I do not own the trip with the following data
      """
        {
          "trip_name": "Test Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I delete the trip with the following name
      | Name            |
      | Test Adventure  |
    Then the response status code is Forbidden


  Scenario: Attempt to add a trip with one destination
    Given I have an application running
    And I am logged in with credentials
      | Username                | Password  |
      | guestUser@travelea.com  | guest123  |
    When the following json containing a trip is sent:
      """
        {
          "trip_name": "Unplanned bottle store excursion",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is BadRequest


  Scenario: Attempt to add a trip with no name
    Given I have an application running
    And I am logged in with credentials
      | Username                | Password  |
      | guestUser@travelea.com  | guest123  |
    When the following json containing a trip is sent:
      """
        {
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is BadRequest


  Scenario: Attempt to add a trip with duplicate destinations in series
    Given I have an application running
    And I am logged in with credentials
      | Username                | Password  |
      | guestUser@travelea.com  | guest123  |
    When the following json containing a trip is sent:
      """
        {
          "trip_name": "There and there again.",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is BadRequest


  Scenario: Attempt to add a trip with inappropriately ordered dates
    Given I have an application running
    And I am logged in with credentials
      | Username                | Password  |
      | guestUser@travelea.com  | guest123  |
    When the following json containing a trip is sent:
      """
        {
          "trip_name": "A Holiday Away",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : "1993-12-12",
              "end_date" : "1991-12-12"
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is BadRequest


  Scenario: Edit a trip as the trip's owner with valid name
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I own the trip with the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I change the trip, "Edit Adventure" to contain the following data
      """
        {
          "trip_name": "Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is OK

  Scenario: Edit a trip as the trip's owner with valid destinations
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I own the trip with the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I change the trip, "Edit Adventure" to contain the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is OK

  Scenario: Edit a trip as the trip's owner with invalid name
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I own the trip with the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I change the trip, "Edit Adventure" to contain the following data
      """
        {
          "trip_name": "",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is BadRequest


  Scenario: Edit a trip as the trip's owner with invalid destinations
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I own the trip with the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I change the trip, "Edit Adventure" to contain the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is BadRequest


  Scenario: Edit other user's trip as an admin
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | admin@travelea.com      |
    And I do not own the trip with the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I change the trip, "Edit Adventure" to contain the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is OK


  Scenario: Edit a another user's trip as a standard user
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And I do not own the trip with the following data
      """
        {
          "trip_name": "Edit Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    When I change the trip, "Edit Adventure" to contain the following data
      """
        {
          "trip_name": "Adventure",
          "trip_destinations" : [
            {
              "destination_id" : "1155",
              "start_date" : null,
              "end_date" : null
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the response status code is Forbidden
    
  Scenario: Changing ownership of public destination not owned by me when used in a trip
    Given I have an application running
    And I am logged as the following user
      | Username                |
      | guestUser@travelea.com  |
    And the destination with id 119 exists
    When the following json containing a trip is sent:
      """
        {
          "trip_name": "A Holiday Away",
          "trip_destinations" : [
            {
              "destination_id" : "119",
              "start_date" : "1990-12-12",
              "end_date" : "1991-12-12"
            },
            {
              "destination_id" : "567",
              "start_date" : null,
              "end_date" : null
            }
          ]
        }
      """
    Then the destination with id 119 ownership changes to the user with id 1

#  Scenario: Changing ownership of public destination owned by me when used in a trip
#    Given I have an application running
#    And I am logged as the following user
#      | Username                |
#      | guestUser@travelea.com  |
#    And the destination with id 325 exists
#    When the following json containing a trip is sent:
#      """
#        {
#          "trip_name": "A Holiday Away",
#          "trip_destinations" : [
#            {
#              "destination_id" : "325",
#              "start_date" : "1990-12-12",
#              "end_date" : "1991-12-12"
#            },
#            {
#              "destination_id" : "567",
#              "start_date" : null,
#              "end_date" : null
#            }
#          ]
#        }
#      """
#    Then the destination with id 325 ownership changes to the user with id 2