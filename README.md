![Odyssey Logo](doc/img/full_logo.png)

[![Test_badge](https://github.com/dkbarrett/odyssey/workflows/Tests/badge.svg)](https://github.com/dkbarrett/odyssey/actions?query=workflow%3ATests)
[![Build_badge](https://github.com/dkbarrett/odyssey/workflows/Build/badge.svg)](https://github.com/dkbarrett/odyssey/actions?query=workflow%3ABuild)

## About
Odyssey is a web app built on a three tier architecture.
The app is a social media game that allows users to accumulate points and badges by creating and solving quests as they travel around the world.

## The Team
The developers of Odyssey are a group of 8 students, dubbed Everyware, from the University of Canterbury's [SENG302](https://www.canterbury.ac.nz/courseinfo/GetCourseDetails.aspx?course=SENG302&year=2019) class of 2019.
We wanted to create an application that the university could use for events such as open days.
This application was developed over the course of eight months of university work, so we hope you enjoy it!

- Cam Arnold
- Doug Barrett
- Vinnie Jamieson
- Matthew Kenny
- Hayden Morriss
- Matilda Porterfield
- Joel Ridden
- Isaac Worsley

See the [User Manual](https://github.com/dkbarrett/odyssey/wiki/User-Manual) for instructions to run the application.

## Dependencies

Everyware's Odyssey requires the following dependencies to run.
It has been tested to run on both Windows 10 and Linux Mint. 

* [sbt 1.2.8](https://www.scala-sbt.org/download.html)
* [nodejs 12.18.2 LTS](https://nodejs.org/en/)
* [JDK 1.8](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html)

## Build instructions (Windows/Linux)

```bash
git clone https://github.com/dkbarrett/odyssey.git && cd odyssey # Clone this repository
sbt dist # Build the application
```

The resulting zip file should now be in `./target/universal`

It may be extracted to your preferred install location.

## Run instructions

#### Environment variables
Connection to the database is specified via environment variables.
The application is configured to use MySQL for the database with the following variables.
- DB_HOST - Database hostname e.g. `mysqldb.odyssey.com`
- DB_NAME - Name of the database holding the odyssey data e.g. `odyssey-production`
- DB_USERNAME - Username with appropriate privileges to access the odyssey database.
- DB_PASSWORD - Password for the aforementioned user.

#### Docker
After building using `sbt dist` you may create a docker container of the application using `docker build . -t odyssey`. The resulting container may be run using:
```bash
docker run \
    -p 9000:9000 \
    -e DB_HOST=example.com \
    -e DB_NAME=odyssey_data \
    -e DB_USERNAME=odyssey_db_user \
    -e DB_PASSWORD=odyssey_db_pass \
    -v user_photos:/opt/odyssey/data/photos \
    odyssey
```

#### Windows
1. Navigate into the newly extracted `${INSTALL_LOCATION}/bin` folder
2. Execute the `odyssey-X.X.bat` file

#### Linux
1. Navigate into the newly extracted `${INSTALL_LOCATION}/bin` folder
2. Open the folder in the terminal and type `chmod +x ./odyssey-X.X`. This enables the file to be executable. 
3. Execute `./odyssey-X.X`.

The application will now be accessible at `http://127.0.0.1:9000/`

To login as an admin user use username `admin@travelea.com` and password `1nimda`.  
To login as a regular user use username `guestUser@travelea.com` and password `guest123`.

### User Manual

Click [here](https://github.com/dkbarrett/odyssey/wiki/User-Manual) for a comprehensive guide to using Odyssey.  

### Reference
* [Play Documentation](https://playframework.com/documentation/latest/Home)
* [EBean](https://www.playframework.com/documentation/latest/JavaEbean) is a Java ORM library that uses SQL.The documentation can be found [here](https://ebean-orm.github.io/).

### Licencing
All external licences can be found in the `/doc` directory in the repo or on our Wiki.
