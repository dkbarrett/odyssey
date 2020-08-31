import requests
import random
import os
import math
import urllib.request
import uuid
import time
import threading
from shutil import copyfile

DIR = "/home/sengstudent/travelea/production/seng302-team-100-everyware-0.0.1-SNAPSHOT/"
OUTPUT_DIR = "output/"

PHOTO_DIR = "photos/"
THUMBNAIL_DIR = "thumbnail/"

ID_OFFSET = 30

NUMBER_PHOTO_CRAWLERS = 50

class PhotoCrawler(threading.Thread):

    def __init__(self, urlList, crawlerId):
        self.urlList = urlList
        self.finished = False
        self.output = list()
        self.id = crawlerId
        threading.Thread.__init__(self)

    def downloadImage(self, url):
        filename = str(uuid.uuid4())
        urllib.request.urlretrieve(url, OUTPUT_DIR + PHOTO_DIR + filename)
        copyfile(OUTPUT_DIR + PHOTO_DIR + filename, OUTPUT_DIR + PHOTO_DIR + THUMBNAIL_DIR + filename)
        return filename

    def run(self):
        print(f"Crawler {self.id} started.")
        for (userId, url) in self.urlList:
            self.output.append((userId, self.downloadImage(url)))
        self.finished = True
        print(f"Crawler {self.id} finished.")

def crawlersFinished(crawlers):
    for crawler in crawlers:
        if(not crawler.finished):
            return False
    return True


def chunks(list, n):
    """Yield successive n chunks from list."""
    listSize = math.ceil(len(list)/n)
    for i in range(0, len(list), listSize):
        yield list[i: i + listSize]

def downloadImages(urlList):
    crawlers = list()
    total_output = list()

    for (id, downloadList) in enumerate(chunks(urlList, NUMBER_PHOTO_CRAWLERS)):
        crawler = PhotoCrawler(downloadList, id + 1)
        crawlers.append(crawler)
        crawler.start()

    while(not crawlersFinished(crawlers)):
        time.sleep(1)



    for crawler in crawlers:
        total_output.extend(crawler.output)

    return total_output

def generateNationalityPassportsTravellerTypes(numberOfUsers):
    print("Generating nationality, passports and traveller types....")

    # SQL files to save
    traveller_type_file = open(OUTPUT_DIR + 'traveller_type_profile.sql', 'w')
    nationality_file = open(OUTPUT_DIR + 'nationality_profile.sql', 'w')
    passport_file = open(OUTPUT_DIR + 'passport_profile.sql', 'w')

    # Insert statements for each file
    traveller_type_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `traveller_type_profile` (`profile_id`, `traveller_type_id`) VALUES ')
    nationality_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `nationality_profile` (`profile_id`, `nationality_id`) VALUES ')
    passport_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `passport_profile` (`profile_id`, `passport_id`) VALUES ')

    # For each user
    for userId in range(ID_OFFSET, numberOfUsers + ID_OFFSET):

        # Define them all as sets to prevent duplicates from randint.
        nationality_ids = set()
        passport_ids = set()
        traveller_type_ids = set()

        # Add 1 - 3 nationalities
        for i in range(random.randint(1, 3)):
            nationality_ids.add(random.randint(1, 108))

        # Add 1 - 3 traveller types
        for i in range(random.randint(1, 3)):
            traveller_type_ids.add(random.randint(1, 7))

        # Add 0 - n passports where n is the number of
        for id in nationality_ids:
            if(random.randint(0, 1)):
                passport_ids.add(id)

        # Perform all the write operations
        for id in traveller_type_ids:
            traveller_type_file.write("({}, {}), ".format(userId, id))

        for id in nationality_ids:
            nationality_file.write("({}, {}), ".format(userId, id))

        for id in passport_ids:
            passport_file.write("({}, {}), ".format(userId, id))

    traveller_type_file.seek(traveller_type_file.tell() - 2, os.SEEK_SET)
    traveller_type_file.write("; SET FOREIGN_KEY_CHECKS = 1;")

    nationality_file.seek(nationality_file.tell() - 2, os.SEEK_SET)
    nationality_file.write("; SET FOREIGN_KEY_CHECKS = 1;")

    passport_file.seek(passport_file.tell() - 2, os.SEEK_SET)
    passport_file.write("; SET FOREIGN_KEY_CHECKS = 1;")

    traveller_type_file.close()
    passport_file.close()
    nationality_file.close()

    print("Done.")


def generateUsers(userDict):

    print("Generating profiles...")

    # SQL file to save
    profile_file = open(OUTPUT_DIR + 'profile.sql', 'w')
    achievement_tracker_file = open(OUTPUT_DIR + 'achievement_tracker.sql', 'w')
    profile_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `profile` (`id`, `username`, `password`, `first_name`, `middle_name`, `last_name`, `gender`, `date_of_birth`, `date_of_creation`, `is_admin`, `profile_picture_id`) VALUES ');
    achievement_tracker_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `achievement_tracker` (`id`, `points`, `owner_id`, `current_streak`) VALUES ');

    for i, user in enumerate(userDict):
        id = i + ID_OFFSET
        username = user['email'].replace('\'', '\'\'')
        password = user['login']['sha256'].upper().replace('\'', '\'\'')
        firstname = user['name']['first'].capitalize().replace('\'', '\'\'')
        lastname = user['name']['last'].capitalize().replace('\'', '\'\'')
        gender = user['gender'].capitalize().replace('\'', '\'\'')
        dob = user['dob']['date'][:10].replace('\'', '\'\'')
        registered = user['registered']['date'].replace('\'', '\'\'')

        registered = registered.replace('T', ' ')
        registered = registered.replace('Z', '.579000')

        points = random.randint(0, 400)
        streak = random.randint(0, 50)

        user_sql = f"({id}, '{username}', '{password}', '{firstname}', '', '{lastname}', '{gender}', '{dob}', '{registered}', 0, {id}), "
        achievement_tracker_sql = f"({id}, '{points}', '{id}', '{streak}'), "

        profile_file.write(user_sql)
        achievement_tracker_file.write(achievement_tracker_sql)

    profile_file.seek(profile_file.tell() - 2, os.SEEK_SET)
    profile_file.write('; SET FOREIGN_KEY_CHECKS = 1;')
    profile_file.close()

    achievement_tracker_file.seek(achievement_tracker_file.tell() - 2, os.SEEK_SET)
    achievement_tracker_file.write('; SET FOREIGN_KEY_CHECKS = 1;')
    achievement_tracker_file.close()

    print("Done.")

def generateProfilePicture(userDict):
    print("Downloading and generating sql for profile pictures...")
    print("This might take a while...")

    photo_file = open(OUTPUT_DIR + 'photo.sql', 'w')
    personal_photo_file = open(OUTPUT_DIR + 'personal_photo.sql', 'w')

    photo_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `photo` (`id`, `main_filename`, `thumbnail_filename`, `upload_date`, `upload_profile_id`, `content_type`) VALUES ')
    personal_photo_file.write('SET FOREIGN_KEY_CHECKS = 0; INSERT INTO `personal_photo` (`id`, `photo_id`, `profile_id`, `is_public`) VALUES ')

    urlList = list()

    # Collate the picture urls into a list of ordered tuples (userId, pictureUrl)
    for (i, user) in enumerate(userDict):
        urlList.append((i + ID_OFFSET, user['picture']['large']))

    # Will return a list of tuples (userId, filename)
    fileList = downloadImages(urlList)

    for (id, filename) in fileList:
        photo_file.write(f"({id}, '{DIR + PHOTO_DIR + filename}', '{DIR + PHOTO_DIR + THUMBNAIL_DIR + filename}', '2019-09-19', {id}, 'image/jpeg'), ")
        personal_photo_file.write(f"({id}, {id}, {id}, 1), ")
        print(id, filename)

    photo_file.seek(photo_file.tell() - 2, os.SEEK_SET)
    photo_file.write("; SET FOREIGN_KEY_CHECKS = 1;")

    personal_photo_file.seek(personal_photo_file.tell() - 2, os.SEEK_SET)
    personal_photo_file.write("; SET FOREIGN_KEY_CHECKS = 1;")

    photo_file.close()
    personal_photo_file.close()

    print("Done.")
    pass

def main():
    url = 'https://randomuser.me/api/'
    emails = dict()

    params = dict(
        results='5000',
        password='upper,lower,number,5-15',
        exc='id,cell,phone,location,nat'
    )

    resp = requests.get(url=url, params=params)

    users = resp.json()['results']

    numberOfUsers = len(users)

    generateUsers(users)
    generateNationalityPassportsTravellerTypes(numberOfUsers)
    generateProfilePicture(users)


main()
