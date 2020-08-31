create table achievement_tracker (
                                     id                            bigint auto_increment not null,
                                     points                        integer not null,
                                     current_streak                integer not null,
                                     owner_id                      bigint,
                                     constraint uq_achievement_tracker_owner_id unique (owner_id),
                                     constraint pk_achievement_tracker primary key (id)
);

create table badge (
                       id                            bigint auto_increment not null,
                       action_to_achieve             varchar(29) not null,
                       name                          varchar(255),
                       bronze_breakpoint             integer not null,
                       silver_breakpoint             integer not null,
                       gold_breakpoint               integer not null,
                       how_to_progress               varchar(255),
                       constraint ck_badge_action_to_achieve check ( action_to_achieve in ('DESTINATION_CREATED','TRIP_CREATED','QUEST_CREATED','HINT_CREATED','RIDDLE_SOLVED','CHECKED_IN','POINTS_GAINED','LOGIN_STREAK','INTERNATIONAL_QUEST_COMPLETED','LARGE_QUEST_COMPLETED','DISTANCE_QUEST_COMPLETED','QUEST_COMPLETED', 'HINT_UPVOTED', 'HINT_UPVOTE_REMOVED')),
                       constraint uq_badge_action_to_achieve unique (action_to_achieve),
                       constraint pk_badge primary key (id)
);

create table badge_progress (
                                id                            bigint auto_increment not null,
                                badge_id                      bigint,
                                achievement_tracker_id        bigint,
                                progress                      integer not null,
                                constraint pk_badge_progress primary key (id)
);

create table destination (
                             id                            bigint auto_increment not null,
                             name                          varchar(255),
                             type_id                       bigint,
                             district                      varchar(255),
                             latitude                      double not null,
                             longitude                     double not null,
                             country                       varchar(255),
                             owner_id                      bigint,
                             is_public                     boolean,
                             constraint pk_destination primary key (id)
);

create table destination_personal_photo (
                                            destination_id                bigint not null,
                                            personal_photo_id             bigint not null,
                                            constraint pk_destination_personal_photo primary key (destination_id,personal_photo_id)
);

create table destination_traveller_type (
                                            destination_id                bigint not null,
                                            traveller_type_id             bigint not null,
                                            constraint pk_destination_traveller_type primary key (destination_id,traveller_type_id)
);

create table destination_proposed_traveller_type_add (
                                                         destination_id                bigint not null,
                                                         traveller_type_id             bigint not null,
                                                         constraint pk_destination_proposed_traveller_type_add primary key (destination_id,traveller_type_id)
);

create table destination_proposed_traveller_type_remove (
                                                            destination_id                bigint not null,
                                                            traveller_type_id             bigint not null,
                                                            constraint pk_destination_proposed_traveller_type_remove primary key (destination_id,traveller_type_id)
);

create table hint (
                      id                            bigint auto_increment not null,
                      message                       varchar(255),
                      up_votes                      integer not null,
                      down_votes                    integer not null,
                      objective_id                  bigint,
                      creator_id                    bigint,
                      constraint pk_hint primary key (id)
);

create table hint_profile (
                              hint_id                       bigint not null,
                              profile_id                    bigint not null,
                              constraint pk_hint_profile primary key (hint_id,profile_id)
);

create table nationality (
                             id                            bigint auto_increment not null,
                             nationality                   varchar(255),
                             country                       varchar(255),
                             constraint pk_nationality primary key (id)
);

create table nationality_profile (
                                     nationality_id                bigint not null,
                                     profile_id                    bigint not null,
                                     constraint pk_nationality_profile primary key (nationality_id,profile_id)
);

create table objective (
                           id                            bigint auto_increment not null,
                           destination_id                bigint,
                           owner_id                      bigint,
                           riddle                        varchar(255),
                           radius                        double,
                           quest_using_id                bigint,
                           constraint pk_objective primary key (id)
);

create table passport (
                          id                            bigint auto_increment not null,
                          country                       varchar(255),
                          constraint pk_passport primary key (id)
);

create table passport_profile (
                                  passport_id                   bigint not null,
                                  profile_id                    bigint not null,
                                  constraint pk_passport_profile primary key (passport_id,profile_id)
);

create table personal_photo (
                                id                            bigint auto_increment not null,
                                photo_id                      bigint,
                                profile_id                    bigint,
                                is_public                     boolean,
                                constraint pk_personal_photo primary key (id)
);

create table photo (
                       id                            bigint auto_increment not null,
                       main_filename                 varchar(255),
                       thumbnail_filename            varchar(255),
                       content_type                  varchar(255),
                       upload_date                   date,
                       upload_profile_id             bigint,
                       constraint pk_photo primary key (id)
);

create table point_reward (
                              id                            bigint auto_increment not null,
                              name                          varchar(29) not null,
                              value                         integer not null,
                              constraint ck_point_reward_name check ( name in ('DESTINATION_CREATED','TRIP_CREATED','QUEST_CREATED','HINT_CREATED','RIDDLE_SOLVED_NO_HINT','RIDDLE_SOLVED_ONE_HINT','RIDDLE_SOLVED_TWO_HINT','CHECKED_IN','POINTS_GAINED','LOGIN_STREAK','INTERNATIONAL_QUEST_COMPLETED','LARGE_QUEST_COMPLETED','DISTANCE_QUEST_COMPLETED','QUEST_COMPLETED','HINT_UPVOTED','HINT_UPVOTE_REMOVED')),
                              constraint uq_point_reward_name unique (name),
                              constraint pk_point_reward primary key (id)
);

create table profile (
                         id                            bigint auto_increment not null,
                         username                      varchar(255),
                         password                      varchar(255),
                         first_name                    varchar(255),
                         middle_name                   varchar(255),
                         last_name                     varchar(255),
                         gender                        varchar(255),
                         date_of_birth                 date,
                         is_admin                      boolean default false not null,
                         last_seen_date                timestamp,
                         date_of_creation              timestamp,
                         profile_picture_id            bigint,
                         constraint uq_profile_profile_picture_id unique (profile_picture_id),
                         constraint pk_profile primary key (id)
);

create table quest (
                       id                            bigint auto_increment not null,
                       title                         varchar(255),
                       start_date                    timestamp,
                       end_date                      timestamp,
                       owner_id                      bigint,
                       constraint pk_quest primary key (id)
);

create table quest_attempt (
                               id                            bigint auto_increment not null,
                               attempted_by_id               bigint,
                               quest_attempted_id            bigint,
                               solved_current                boolean default false not null,
                               checked_in_index              integer not null,
                               completed                     boolean default false not null,
                               constraint pk_quest_attempt primary key (id)
);

create table traveller_type (
                                id                            bigint auto_increment not null,
                                traveller_type                varchar(255),
                                description                   varchar(255),
                                img_url                       varchar(255),
                                constraint pk_traveller_type primary key (id)
);

create table traveller_type_profile (
                                        traveller_type_id             bigint not null,
                                        profile_id                    bigint not null,
                                        constraint pk_traveller_type_profile primary key (traveller_type_id,profile_id)
);

create table trip (
                      id                            bigint auto_increment not null,
                      name                          varchar(255),
                      profile_id                    bigint,
                      constraint pk_trip primary key (id)
);

create table trip_destination (
                                  id                            bigint auto_increment not null,
                                  start_date                    date,
                                  end_date                      date,
                                  list_order                    integer not null,
                                  trip_id                       bigint,
                                  destination_id                bigint,
                                  constraint pk_trip_destination primary key (id)
);

create table destination_type (
                                  id                            bigint auto_increment not null,
                                  destination_type              varchar(255),
                                  constraint pk_destination_type primary key (id)
);

create table vote (
                      id                            bigint auto_increment not null,
                      voter_id                      bigint,
                      target_hint_id                bigint,
                      is_up_vote                    boolean default false not null,
                      constraint pk_vote primary key (id)
);

alter table achievement_tracker add constraint fk_achievement_tracker_owner_id foreign key (owner_id) references profile (id) on delete restrict on update restrict;

create index ix_badge_progress_badge_id on badge_progress (badge_id);
alter table badge_progress add constraint fk_badge_progress_badge_id foreign key (badge_id) references badge (id) on delete restrict on update restrict;

create index ix_badge_progress_achievement_tracker_id on badge_progress (achievement_tracker_id);
alter table badge_progress add constraint fk_badge_progress_achievement_tracker_id foreign key (achievement_tracker_id) references achievement_tracker (id) on delete restrict on update restrict;

create index ix_destination_type_id on destination (type_id);
alter table destination add constraint fk_destination_type_id foreign key (type_id) references destination_type (id) on delete restrict on update restrict;

create index ix_destination_owner_id on destination (owner_id);
alter table destination add constraint fk_destination_owner_id foreign key (owner_id) references profile (id) on delete restrict on update restrict;

create index ix_destination_personal_photo_destination on destination_personal_photo (destination_id);
alter table destination_personal_photo add constraint fk_destination_personal_photo_destination foreign key (destination_id) references destination (id) on delete restrict on update restrict;

create index ix_destination_personal_photo_personal_photo on destination_personal_photo (personal_photo_id);
alter table destination_personal_photo add constraint fk_destination_personal_photo_personal_photo foreign key (personal_photo_id) references personal_photo (id) on delete restrict on update restrict;

create index ix_destination_traveller_type_destination on destination_traveller_type (destination_id);
alter table destination_traveller_type add constraint fk_destination_traveller_type_destination foreign key (destination_id) references destination (id) on delete restrict on update restrict;

create index ix_destination_traveller_type_traveller_type on destination_traveller_type (traveller_type_id);
alter table destination_traveller_type add constraint fk_destination_traveller_type_traveller_type foreign key (traveller_type_id) references traveller_type (id) on delete restrict on update restrict;

create index ix_destination_proposed_traveller_type_add_destination on destination_proposed_traveller_type_add (destination_id);
alter table destination_proposed_traveller_type_add add constraint fk_destination_proposed_traveller_type_add_destination foreign key (destination_id) references destination (id) on delete restrict on update restrict;

create index ix_destination_proposed_traveller_type_add_traveller_type on destination_proposed_traveller_type_add (traveller_type_id);
alter table destination_proposed_traveller_type_add add constraint fk_destination_proposed_traveller_type_add_traveller_type foreign key (traveller_type_id) references traveller_type (id) on delete restrict on update restrict;

create index ix_destination_proposed_traveller_type_remove_destination on destination_proposed_traveller_type_remove (destination_id);
alter table destination_proposed_traveller_type_remove add constraint fk_destination_proposed_traveller_type_remove_destination foreign key (destination_id) references destination (id) on delete restrict on update restrict;

create index ix_destination_proposed_traveller_type_remove_traveller_t_2 on destination_proposed_traveller_type_remove (traveller_type_id);
alter table destination_proposed_traveller_type_remove add constraint fk_destination_proposed_traveller_type_remove_traveller_t_2 foreign key (traveller_type_id) references traveller_type (id) on delete restrict on update restrict;

create index ix_hint_objective_id on hint (objective_id);
alter table hint add constraint fk_hint_objective_id foreign key (objective_id) references objective (id) on delete restrict on update restrict;

create index ix_hint_creator_id on hint (creator_id);
alter table hint add constraint fk_hint_creator_id foreign key (creator_id) references profile (id) on delete restrict on update restrict;

create index ix_hint_profile_hint on hint_profile (hint_id);
alter table hint_profile add constraint fk_hint_profile_hint foreign key (hint_id) references hint (id) on delete restrict on update restrict;

create index ix_hint_profile_profile on hint_profile (profile_id);
alter table hint_profile add constraint fk_hint_profile_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_nationality_profile_nationality on nationality_profile (nationality_id);
alter table nationality_profile add constraint fk_nationality_profile_nationality foreign key (nationality_id) references nationality (id) on delete restrict on update restrict;

create index ix_nationality_profile_profile on nationality_profile (profile_id);
alter table nationality_profile add constraint fk_nationality_profile_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_objective_destination_id on objective (destination_id);
alter table objective add constraint fk_objective_destination_id foreign key (destination_id) references destination (id) on delete restrict on update restrict;

create index ix_objective_owner_id on objective (owner_id);
alter table objective add constraint fk_objective_owner_id foreign key (owner_id) references profile (id) on delete restrict on update restrict;

create index ix_objective_quest_using_id on objective (quest_using_id);
alter table objective add constraint fk_objective_quest_using_id foreign key (quest_using_id) references quest (id) on delete restrict on update restrict;

create index ix_passport_profile_passport on passport_profile (passport_id);
alter table passport_profile add constraint fk_passport_profile_passport foreign key (passport_id) references passport (id) on delete restrict on update restrict;

create index ix_passport_profile_profile on passport_profile (profile_id);
alter table passport_profile add constraint fk_passport_profile_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_personal_photo_photo_id on personal_photo (photo_id);
alter table personal_photo add constraint fk_personal_photo_photo_id foreign key (photo_id) references photo (id) on delete restrict on update restrict;

create index ix_personal_photo_profile_id on personal_photo (profile_id);
alter table personal_photo add constraint fk_personal_photo_profile_id foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_photo_upload_profile_id on photo (upload_profile_id);
alter table photo add constraint fk_photo_upload_profile_id foreign key (upload_profile_id) references profile (id) on delete restrict on update restrict;

alter table profile add constraint fk_profile_profile_picture_id foreign key (profile_picture_id) references personal_photo (id) on delete restrict on update restrict;

create index ix_quest_owner_id on quest (owner_id);
alter table quest add constraint fk_quest_owner_id foreign key (owner_id) references profile (id) on delete restrict on update restrict;

create index ix_quest_attempt_attempted_by_id on quest_attempt (attempted_by_id);
alter table quest_attempt add constraint fk_quest_attempt_attempted_by_id foreign key (attempted_by_id) references profile (id) on delete restrict on update restrict;

create index ix_quest_attempt_quest_attempted_id on quest_attempt (quest_attempted_id);
alter table quest_attempt add constraint fk_quest_attempt_quest_attempted_id foreign key (quest_attempted_id) references quest (id) on delete restrict on update restrict;

create index ix_traveller_type_profile_traveller_type on traveller_type_profile (traveller_type_id);
alter table traveller_type_profile add constraint fk_traveller_type_profile_traveller_type foreign key (traveller_type_id) references traveller_type (id) on delete restrict on update restrict;

create index ix_traveller_type_profile_profile on traveller_type_profile (profile_id);
alter table traveller_type_profile add constraint fk_traveller_type_profile_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_trip_profile_id on trip (profile_id);
alter table trip add constraint fk_trip_profile_id foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_trip_destination_trip_id on trip_destination (trip_id);
alter table trip_destination add constraint fk_trip_destination_trip_id foreign key (trip_id) references trip (id) on delete restrict on update restrict;

create index ix_trip_destination_destination_id on trip_destination (destination_id);
alter table trip_destination add constraint fk_trip_destination_destination_id foreign key (destination_id) references destination (id) on delete restrict on update restrict;

create index ix_vote_voter_id on vote (voter_id);
alter table vote add constraint fk_vote_voter_id foreign key (voter_id) references profile (id) on delete restrict on update restrict;

create index ix_vote_target_hint_id on vote (target_hint_id);
alter table vote add constraint fk_vote_target_hint_id foreign key (target_hint_id) references hint (id) on delete restrict on update restrict;

INSERT INTO `destination_type` (`id`, `destination_type`) VALUES
(1, 'Amenity Area'),
(2, 'Appellation'),
(3, 'Area'),
(4, 'Bank'),
(5, 'Basin'),
(6, 'Bay'),
(7, 'Beach'),
(8, 'Bend'),
(9, 'Bridge'),
(10, 'Building'),
(11, 'Bush'),
(12, 'Canal'),
(13, 'Canyon'),
(14, 'Cape'),
(15, 'Cave'),
(16, 'Channel'),
(17, 'Chasm'),
(18, 'City'),
(19, 'Clearing'),
(20, 'Cliff'),
(21, 'Coast Feature'),
(22, 'Conservation Park'),
(23, 'Crater'),
(24, 'Crown Protected Area'),
(25, 'Desert'),
(26, 'District'),
(27, 'Ecological Area'),
(28, 'Estuary'),
(29, 'Facility'),
(30, 'Fan'),
(31, 'Flat'),
(32, 'Ford'),
(33, 'Forest'),
(34, 'Fork'),
(35, 'Gap'),
(36, 'Glacier'),
(37, 'Government Purpose Reserve'),
(38, 'Hill'),
(39, 'Historic Reserve'),
(40, 'Historic Site'),
(41, 'Hole'),
(42, 'Ice Feature'),
(43, 'Island'),
(44, 'Isthmus'),
(45, 'Knoll'),
(46, 'Lake'),
(47, 'Ledge'),
(48, 'Local Government'),
(49, 'Locality'),
(50, 'Marine Feature'),
(51, 'Marine Reserve'),
(52, 'National Park'),
(53, 'Nature Reserve'),
(54, 'Pass'),
(55, 'Peninsula'),
(56, 'Pinnacle'),
(57, 'Place'),
(58, 'Plateau'),
(59, 'Point'),
(60, 'Pool'),
(61, 'Port'),
(62, 'Railway Crossing'),
(63, 'Railway Junction'),
(64, 'Railway Line'),
(65, 'Railway Station'),
(66, 'Range'),
(67, 'Rapid'),
(68, 'Recreation'),
(69, 'Recreation Reserve'),
(70, 'Reef'),
(71, 'Reserve (non-CPA)'),
(72, 'Ridge'),
(73, 'Road'),
(74, 'Roadstead'),
(75, 'Rock'),
(76, 'Saddle'),
(77, 'Sanctuary Area'),
(78, 'Scarp'),
(79, 'Scenic Reserve'),
(80, 'Scientific Reserve'),
(81, 'Seachannel'),
(82, 'Shelf'),
(83, 'Shoal'),
(84, 'Sill'),
(85, 'Site'),
(86, 'Spit'),
(87, 'Spring'),
(88, 'Spur'),
(89, 'Stream'),
(90, 'Suburb'),
(91, 'Town'),
(92, 'Track'),
(93, 'Trig Station'),
(94, 'Trough'),
(95, 'Valley'),
(96, 'Village'),
(97, 'Waterfall'),
(98, 'Wetland'),
(99, 'Wilderness Area'),
(100, 'Wildlife Management Area');


INSERT INTO nationality (nationality, country) VALUES
('Afghan', 'Afghanistan'),
('Albanian', 'Albania'),
('Algerian', 'Algeria'),
('Argentinian', 'Argentina'),
('Australian', 'Australia'),
('Austrian', 'Austria'),
('Belgian', 'Belgium'),
('Bolivian', 'Bolivia'),
('Batswana', 'Botswana'),
('Brazilian', 'Brazil'),
('Bulgarian', 'Bulgaria'),
('Cambodian', 'Cambodia'),
('Cameroonian', 'Cameroon'),
('Canadian', 'Canada'),
('Chilean', 'Chile'),
('Chinese', 'China'),
('Costa Rican', 'Costa Rica'),
('Croatian', 'Croatia'),
('Cuban', 'Cuba'),
('Czech', 'Czech Republic'),
('Danish', 'Denmark'),
('Dominican', 'Dominican Republic'),
('Ecuadorian', 'Ecuador'),
('Egyptian', 'Egypt'),
('Salvadorian', 'El Salvador'),
('English', 'England'),
('Estonian', 'Estonia'),
('Ethiopian', 'Ethiopia'),
('Fijian', 'Fiji'),
('Finnish', 'Finland'),
('French', 'France'),
('German', 'Germany'),
('Ghanaian', 'Ghana'),
('Greek', 'Greece'),
('Guatemalan', 'Guatemala'),
('Haitian', 'Haiti'),
('Honduran', 'Honduras'),
('Hungarian', 'Hungary'),
('Icelandic', 'Iceland'),
('Indian', 'India'),
('Indonesian', 'Indonesia'),
('Iranian', 'Iran'),
('Iraqi', 'Iraq'),
('Irish', 'Ireland'),
('Israeli', 'Israel'),
('Italian', 'Italy'),
('Jamaican', 'Jamaica'),
('Japanese', 'Japan'),
('Jordanian', 'Jordan'),
('Kenyan', 'Kenya'),
('Kuwaiti', 'Kuwait'),
('Lao', 'Laos'),
('Latvian', 'Latvia'),
('Lebanese', 'Lebanon'),
('Libyan', 'Libya'),
('Lithuanian', 'Lithuania'),
('Malaysian', 'Malaysia'),
('Malian', 'Mali'),
('Maltese', 'Malta'),
('Mexican', 'Mexico'),
('Mongolian', 'Mongolia'),
('Moroccan', 'Morocco'),
('Mozambican', 'Mozambique'),
('Namibian', 'Namibia'),
('Nepalese', 'Nepal'),
('Dutch', 'Netherlands'),
('New Zealand', 'New Zealand'),
('Nicaraguan', 'Nicaragua'),
('Nigerian', 'Nigeria'),
('Norwegian', 'Norway'),
('Pakistani', 'Pakistan'),
('Panamanian', 'Panama'),
('Paraguayan', 'Paraguay'),
('Peruvian', 'Peru'),
('Philippine', 'Philippines'),
('Polish', 'Poland'),
('Portuguese', 'Portugal'),
('Romanian', 'Romania'),
('Russian', 'Russia'),
('Saudi', 'Saudi Arabia'),
('Scottish', 'Scotland'),
('Senegalese', 'Senegal'),
('Serbian', 'Serbia'),
('Singaporean', 'Singapore'),
('Slovak', 'Slovakia'),
('South African', 'South Africa'),
('Korean', 'South Korea'),
('Spanish', 'Spain'),
('Sri Lankan', 'Sri Lanka'),
('Sudanese', 'Sudan'),
('Swedish', 'Sweden'),
('Swiss', 'Switzerland'),
('Syrian', 'Syria'),
('Taiwanese', 'Taiwan'),
('Thai', 'Thailand'),
('Tongan', 'Tonga'),
('Tunisian', 'Tunisia'),
('Turkish', 'Turkey'),
('Ukrainian', 'Ukraine'),
('Emirati', 'United Arab Emirates'),
('British', 'United Kingdom'),
('American', 'United States'),
('Uruguayan', 'Uruguay'),
('Venezuelan', 'Venezuela'),
('Vietnamese', 'Vietnam'),
('Welsh', 'Wales'),
('Zambian', 'Zambia'),
('Zimbabwean', 'Zimbabwe');


INSERT INTO `traveller_type` (`id`, `traveller_type`, `description`, `img_url`) VALUES
(1, 'Groupie', 'You love following a band/artist around while they''re on tour.', '../../../static/traveller_types/groupie.png'),
(2, 'Thrillseeker', 'You''re an adrenaline junkie and love taking part in extreme sport that put you at physical risk.', '../../../static/traveller_types/thrillseeker.png'),
(3, 'Gap Year', 'You''ve just graduated and are ready to see the world before your get into the working sector.', '../../../static/traveller_types/gapYear.png'),
(4, 'Frequent Weekender', 'You''re a hard worker during the weekdays, but enjoy a quick weekend away to escape.', '../../../static/traveller_types/frequentWeekender.png'),
(5, 'Holidaymaker', 'You''re the stereotypical tourist.', '../../../static/traveller_types/holidayMaker.png'),
(6, 'Functional/Business', 'You travel for work, often spending short periods of time in one place.', '../../../static/traveller_types/business.png'),
(7, 'Backpacker', 'You don''t mind going rough and love seeing the outdoors.', '../../../static/traveller_types/backpacker.png');


INSERT INTO passport (`id`, `country`) VALUES
(1, 'Afghanistan'),
(2, 'Albania'),
(3, 'Algeria'),
(4, 'Argentina'),
(5, 'Australia'),
(6, 'Austria'),
(7, 'Belgium'),
(8, 'Bolivia'),
(9, 'Botswana'),
(10, 'Brazil'),
(11, 'Bulgaria'),
(12, 'Cambodia'),
(13, 'Cameroon'),
(14, 'Canada'),
(15, 'Chile'),
(16, 'China'),
(17, 'Costa Rica'),
(18, 'Croatia'),
(19, 'Cuba'),
(20, 'Czech Republic'),
(21, 'Denmark'),
(22, 'Dominican Republic'),
(23, 'Ecuador'),
(24, 'Egypt'),
(25, 'El Salvador'),
(26, 'England'),
(27, 'Estonia'),
(28, 'Ethiopia'),
(29, 'Fiji'),
(30, 'Finland'),
(31, 'France'),
(32, 'Germany'),
(33, 'Ghana'),
(34, 'Greece'),
(35, 'Guatemala'),
(36, 'Haiti'),
(37, 'Honduras'),
(38, 'Hungary'),
(39, 'Iceland'),
(40, 'India'),
(41, 'Indonesia'),
(42, 'Iran'),
(43, 'Iraq'),
(44, 'Ireland'),
(45, 'Israel'),
(46, 'Italy'),
(47, 'Jamaica'),
(48, 'Japan'),
(49, 'Jordan'),
(50, 'Kenya'),
(51, 'Kuwait'),
(52, 'Laos'),
(53, 'Latvia'),
(54, 'Lebanon'),
(55, 'Libya'),
(56, 'Lithuania'),
(57, 'Malaysia'),
(58, 'Mali'),
(59, 'Malta'),
(60, 'Mexico'),
(61, 'Mongolia'),
(62, 'Morocco'),
(63, 'Mozambique'),
(64, 'Namibia'),
(65, 'Nepal'),
(66, 'Netherlands'),
(67, 'New Zealand'),
(68, 'Nicaragua'),
(69, 'Nigeria'),
(70, 'Norway'),
(71, 'Pakistan'),
(72, 'Panama'),
(73, 'Paraguay'),
(74, 'Peru'),
(75, 'Philippines'),
(76, 'Poland'),
(77, 'Portugal'),
(78, 'Romania'),
(79, 'Russia'),
(80, 'Saudi Arabia'),
(81, 'Scotland'),
(82, 'Senegal'),
(83, 'Serbia'),
(84, 'Singapore'),
(85, 'Slovakia'),
(86, 'South Africa'),
(87, 'South Korea'),
(88, 'Spain'),
(89, 'Sri Lanka'),
(90, 'Sudan'),
(91, 'Sweden'),
(92, 'Switzerland'),
(93, 'Syria'),
(94, 'Taiwan'),
(95, 'Thailand'),
(96, 'Tonga'),
(97, 'Tunisia'),
(98, 'Turkey'),
(99, 'Ukraine'),
(100, 'United Arab Emirates'),
(101, 'United Kingdom'),
(102, 'United States'),
(103, 'Uruguay'),
(104, 'Venezuela'),
(105, 'Vietnam'),
(106, 'Wales'),
(107, 'Zambia'),
(108, 'Zimbabwe');


INSERT INTO `point_reward`(`id`, `name`, `value`) VALUES
(1, 'RIDDLE_SOLVED_NO_HINT', 5),
(2, 'RIDDLE_SOLVED_ONE_HINT', 3),
(3, 'RIDDLE_SOLVED_TWO_HINT', 1),
(4, 'CHECKED_IN', 10),
(5, 'DESTINATION_CREATED', 2),
(6, 'QUEST_CREATED', 3),
(7, 'TRIP_CREATED', 3),
(8, 'QUEST_COMPLETED', 20),
(9, 'HINT_CREATED', 1),
(10, 'HINT_UPVOTED', 1),
(11, 'HINT_UPVOTE_REMOVED', -1);


INSERT INTO `badge` (`id`, `action_to_achieve`, `name`, `bronze_breakpoint`, `silver_breakpoint`, `gold_breakpoint`, `how_to_progress`) VALUES
(1,'TRIP_CREATED', 'Planner', 1, 10, 30, 'You need to create %s more trips to achieve %s'),
(2,'DESTINATION_CREATED', 'Cartographer', 1, 10, 50, 'You need to create %s more destinations to achieve %s'),
(3,'QUEST_CREATED', 'Writer', 1, 15, 50, 'You need to create %s more quests to achieve %s'),
(4,'QUEST_COMPLETED', 'Solver', 1, 20, 50, 'You need to complete %s more quests to achieve %s'),
(5,'INTERNATIONAL_QUEST_COMPLETED', 'Explorer', 1, 5, 10, 'You need to complete %s more international quests to achieve %s'),
(6,'LARGE_QUEST_COMPLETED', 'Adventurer', 1, 10, 30, 'You need to complete %s more large quests to achieve %s'),
(7,'DISTANCE_QUEST_COMPLETED', 'Wayfarer', 100000, 500000, 1000000, 'You need to travel %s more metres in quests to achieve %s'),
(8,'POINTS_GAINED', 'Overachiever', 100, 1000, 10000, 'You need to earn %s more points to achieve %s'),
(9,'LOGIN_STREAK', 'Streaker', 1, 7, 31, 'You need to login each day %s more times to achieve %s');

INSERT INTO `profile` (`id`, `username`, `password`, `first_name`, `middle_name`, `last_name`, `gender`, `date_of_birth`, last_seen_date, `date_of_creation`, `is_admin`, `profile_picture_id`) VALUES
(1, 'admin@travelea.com', '25F43B1486AD95A1398E3EEB3D83BC4010015FCC9BEDB35B432E00298D5021F7', 'Default', '', 'Admin', 'Male', '2018-01-01', '2019-01-01', '2019-01-01 13:00:00.000000', 1, NULL),
(2, 'guestUser@travelea.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Dave', 'John', 'McInloch', 'Other', '1998-10-18', '2019-04-17', '2019-04-17 15:31:19.579000', 0, NULL),
(3, 'testuser1@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserOne', 'Other', '1973-02-18', '2019-01-05', '2019-01-05 15:31:19.579000', 0, NULL),
(4, 'testuser2@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserTwo', 'Other', '1982-05-12', '2019-02-04', '2019-02-04 15:31:19.579000', 0, NULL),
(5, 'testuser3@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserThree', 'Other', '1971-01-23', '2019-03-03', '2019-03-03 15:31:19.579000', 0, NULL),
(6, 'testuser4@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserFour', 'Other', '1986-11-03', '2019-04-02', '2019-04-02 15:31:19.579000', 0, NULL),
(7, 'testuser5@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserFour', 'Other', '1986-11-03', '2019-04-02', '2019-04-02 15:31:19.579000', 0, NULL),
(8, 'testuser6@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserFour', 'Other', '1986-11-03', '2019-04-02', '2019-04-02 15:31:19.579000', 0, NULL),
(9, 'testuser7@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserFour', 'Other', '1986-11-03', '2019-04-02', '2019-04-02 15:31:19.579000', 0, NULL),
(10, 'testuser8@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserFour', 'Other', '1986-11-03', '2019-04-02', '2019-04-02 15:31:19.579000', 0, NULL),
(11, 'testuser9@email.com', '6B93CCBA414AC1D0AE1E77F3FAC560C748A6701ED6946735A49D463351518E16', 'Test', '', 'UserFour', 'Other', '1986-11-03', '2019-04-02', '2019-04-02 15:31:19.579000', 0, NULL);


INSERT INTO `nationality_profile` (`profile_id`, `nationality_id`) VALUES
(1, 67),
(2, 4),
(2, 5),
(3, 65),
(3, 42),
(4, 34),
(5, 23),
(6, 49),
(7, 49),
(8, 49),
(9, 49),
(10, 49),
(11, 49);


INSERT INTO `traveller_type_profile` (`profile_id`, `traveller_type_id`) VALUES
(1, 6),
(2, 1),
(2, 2),
(3, 3),
(3, 5),
(4, 2),
(4, 6),
(5, 1),
(6, 7),
(6, 2),
(6, 4),
(7, 4),
(8, 4),
(9, 4),
(10, 4),
(11, 4);


INSERT INTO `passport_profile` (`profile_id`, `passport_id`) VALUES
(2, 3),
(2, 4),
(2, 5),
(3, 65),
(5, 23),
(6, 49);
INSERT INTO `achievement_tracker` (`id`, `points`, `owner_id`, `current_streak`) VALUES
(1, 0, 1, 0),
(2, 0, 2, 0),
(3, 0, 3, 0),
(4, 0, 4, 0),
(5, 0, 5, 0),
(6, 0, 6, 0),
(7, 99, 7, 3),
(8, 999, 8, 6),
(9, 9999, 9, 30),
(10, 0, 10, 30),
(11, 0, 11, 30);


INSERT INTO `badge_progress` (`id`, `badge_id`, `achievement_tracker_id`, `progress`) VALUES
(1, 1, 7, 0),
(2, 1, 8, 9),
(3, 1, 9, 29),
(4, 2, 7, 0),
(5, 2, 8, 9),
(6, 2, 9, 49),
(7, 3, 7, 0),
(8, 3, 8, 14),
(9, 3, 9, 49),
(10, 4, 7, 0),
(11, 4, 8, 19),
(12, 4, 9, 49),
(13, 5, 7, 0),
(14, 5, 8, 4),
(15, 5, 9, 9),
(16, 6, 7, 0),
(17, 6, 8, 9),
(18, 6, 9, 29),
(19, 7, 7, 99999),
(20, 7, 8, 499999),
(21, 7, 9, 999999),
(22, 8, 7, 99),
(23, 8, 8, 999),
(24, 8, 9, 9999),
(25, 9, 7, 3),
(26, 9, 8, 6),
(27, 9, 9, 30),
(28, 5, 11, 0);


INSERT INTO `destination` (`id`, `name`, `type_id`, `district`, `latitude`, `longitude`, `country`, `is_public`, `owner_id`) VALUES
(119, 'Angus Flat', 31, 'Canterbury', -43.65598, 170.48378, 'New Zealand', true, 5),
(325, 'Baylys Beach Post Office', 10, 'North Auckland', -35.953527, 173.74573, 'New Zealand', false, 2),
(567, 'Bow Alley Creek', 89, 'Otago', -45.239576, 170.851946, 'New Zealand', true, 2),
(733, 'Cameron Stream', 89, 'Canterbury', -42.23865, 173.046403, 'New Zealand', true, 1),
(858, 'Cerberus', 38, 'Wellington', -40.512442, 176.213727, 'New Zealand', true, 1),
(1031, 'Courtenay Peak', 38, 'Otago', -44.529264, 168.195041, 'New Zealand', true, 1),
(1155, 'Demon Gap Icefall', 42, 'Otago', -44.392145, 168.361981, 'New Zealand', true, 1),
(1465, 'Feldspar Stream', 89, 'Southland', -45.03797, 167.347403, 'New Zealand', true, 1),
(1526, 'Flat Stream', 89, 'Marlborough', -41.940145, 173.111533, 'New Zealand', true, 1),
(1797, 'Greenstone Stream', 89, 'Canterbury', -42.590148, 172.745206, 'New Zealand', true, 1),
(1834, 'Haines Stream', 89, 'Nelson', -41.295971, 172.664481, 'New Zealand', true, 1),
(1894, 'Hart Creek', 89, 'Wellington', -40.729439, 175.430851, 'New Zealand', true, 1),
(1940, 'Headlong Peak', 38, 'Otago', -44.539752, 168.591617, 'New Zealand', true, 1),
(2035, 'Hitchin Range', 66, 'Westland', -43.111555, 170.824539, 'New Zealand', true, 1),
(2194, 'Iris Stream', 89, 'North Auckland', -36.970301, 174.530236, 'New Zealand', true, 1),
(2275, 'Johnstone Mount', 38, 'Canterbury', -43.37552, 170.857361, 'New Zealand', true, 1),
(2426, 'Kaurimu Stream', 89, 'North Auckland', -36.911035, 174.623382, 'New Zealand', true, 1),
(2439, 'Kawaunui Stream', 89, 'South Auckland', -38.353659, 176.310498, 'New Zealand', true, 1),
(2461, 'Kelleher', 38, 'Wellington', -40.784535, 175.376598, 'New Zealand', true, 1),
(2593, 'Krushen Stream', 89, 'Marlborough', -41.825296, 173.260128, 'New Zealand', true, 1),
(2631, 'Lake Rotoroa (Hamilton Lake)', 46, 'South Auckland', -37.798629, 175.27484, 'New Zealand', true, 1),
(2657, 'Lake Donne', 46, 'Canterbury', -43.608439, 171.115709, 'New Zealand', true, 1),
(2775, 'Lathrop Saddle', 54, 'Westland', -42.91523, 171.277535, 'New Zealand', true, 1),
(2822, 'Lily Creek', 89, 'Westland', -44.032015, 169.474478, 'New Zealand', true, 1),
(2921, 'Long Spur Stream', 89, 'Canterbury', -43.060244, 172.219981, 'New Zealand', true, 1),
(2962, 'Lumber Flat', 31, 'Westland', -44.224114, 168.659968, 'New Zealand', true, 1),
(3218, 'Maraeweka Stream', 89, 'Otago', -45.150038, 170.741188, 'New Zealand', true, 1),
(3338, 'Maungawhiorangi', 93, 'Gisborne', -38.174833, 177.243242, 'New Zealand', true, 1),
(3360, 'McCallum Stream', 89, 'Marlborough', -41.797334, 173.260076, 'New Zealand', true, 1),
(3558, 'Morgan Stream', 89, 'Canterbury', -43.59628, 171.339142, 'New Zealand', true, 1),
(3577, 'Bern', 18, 'Bern', 46.947832, 7.447618, 'Switzerland', true, 1),
(3580, 'Mother Millers Spring', 87, 'Canterbury', -43.358825, 171.288873, 'New Zealand', true, 1),
(3594, 'Motukauatirahi/Cass Bay', 6, 'Canterbury', -43.607459, 172.692363, 'New Zealand', true, 1),
(3607, 'Motuoapa Peninsula', 55, 'South Auckland', -38.924214, 175.859163, 'New Zealand', true, 1),
(3769, 'Mount Meehan', 38, 'Canterbury', -42.919966, 172.300892, 'New Zealand', true, 1),
(3852, 'Mount William Grant', 38, 'Canterbury', -43.704591, 170.32112, 'New Zealand', true, 1),
(3973, 'Nga Tamahineapani', 75, 'Nelson', -40.689108, 173.948723, 'New Zealand', true, 1),
(4087, 'Nym Peak', 38, 'Canterbury', -43.34196, 170.843819, 'New Zealand', true, 1),
(4109, 'Ogilvie Creek', 89, 'Westland', -42.559882, 171.326201, 'New Zealand', true, 1),
(4186, 'Omahuri', 59, 'North Auckland', -34.822269, 173.414253, 'New Zealand', true, 1),
(4216, 'Onetohunga Stream', 89, 'Gisborne', -38.114435, 178.219536, 'New Zealand', true, 1),
(4239, 'Orau Gorge', 95, 'North Auckland', -36.182429, 175.084831, 'New Zealand', true, 1),
(4357, 'Pacific Bay', 6, 'North Auckland', -35.618672, 174.536016, 'New Zealand', true, 1),
(4515, 'Patuki Mountain', 38, 'Southland', -44.669468, 168.021972, 'New Zealand', true, 1),
(4634, 'Pioke', 38, 'Taranaki', -39.167798, 173.967902, 'New Zealand', true, 1),
(4659, 'Plumbago Stream', 89, 'Wellington', -41.390123, 174.895805, 'New Zealand', true, 1),
(4741, 'Poututu Rural Sections', 2, 'Hawke''s Bay', -39.056581, 177.309005, 'New Zealand', true, 1),
(4775, 'Puffer Saddle', 54, 'Wellington', -41.073802, 175.242171, 'New Zealand', true, 1),
(4873, 'Putataua Bay', 6, 'North Auckland', -35.026401, 173.913905, 'New Zealand', true, 1),
(4977, 'Rat Island', 43, 'Southland', -47.133218, 167.567966, 'New Zealand', true, 1),
(5041, 'Refuge Island', 43, 'Southland', -46.949355, 168.127885, 'New Zealand', true, 1),
(5084, 'Ribbonwood Stream', 89, 'Canterbury', -43.136267, 172.227991, 'New Zealand', true, 1),
(5137, 'Rocky Knob', 38, 'Canterbury', -43.808197, 170.089933, 'New Zealand', true, 1),
(5150, 'Rollover Glacier', 36, 'Canterbury', -43.375889, 170.726508, 'New Zealand', true, 1),
(5201, 'Ruapake Stream', 89, 'Marlborough', -41.297087, 173.697105, 'New Zealand', true, 1),
(5234, 'Ryde Stream', 89, 'Canterbury', -44.846356, 170.942726, 'New Zealand', true, 1),
(5321, 'Seagull Lake', 46, 'Canterbury', -43.51051, 171.246743, 'New Zealand', true, 1),
(5375, 'Sherwood Range', 66, 'Canterbury', -43.796768, 170.798736, 'New Zealand', true, 1),
(5405, 'Sisters Stream', 89, 'Canterbury', -42.69284, 173.260088, 'New Zealand', true, 1),
(5418, 'Slip Gully', 95, 'Canterbury', -43.685145, 170.49254, 'New Zealand', true, 1),
(5439, 'Smylies Arm', 6, 'Nelson', -40.864706, 173.825993, 'New Zealand', true, 1),
(5543, 'Stag Pool', 60, 'Wellington', -39.013089, 175.8162, 'New Zealand', true, 1),
(5645, 'Sunshine', 90, 'Otago', -45.895673, 170.518723, 'New Zealand', true, 1),
(5909, 'Te Apu', 38, 'South Auckland', -38.577813, 176.771558, 'New Zealand', true, 1),
(5938, 'Te Henga (Bethells Beach)', 49, 'North Auckland', -36.882985, 174.452852, 'New Zealand', true, 1),
(6002, 'Te Moenga Bay', 6, 'South Auckland', -38.702123, 176.036604, 'New Zealand', true, 1),
(6011, 'Te Nunuhe Rock', 70, 'North Auckland', -35.18988, 174.20015, 'New Zealand', true, 1),
(6024, 'Te Pari o Te Mataahua', 59, 'Otago', -45.79335, 170.742656, 'New Zealand', true, 1),
(6087, 'Te Waha Point', 59, 'North Auckland', -36.93456, 174.453718, 'New Zealand', true, 1),
(6154, 'The Cathedrals', 75, 'Canterbury', -42.868175, 173.299436, 'New Zealand', true, 1),
(6304, 'Tiriwa Point', 59, 'North Auckland', -37.008989, 174.485523, 'New Zealand', true, 1),
(6447, 'Tui Stream', 89, 'Canterbury', -42.580916, 172.342799, 'New Zealand', true, 1),
(6611, 'Waiari Settlement', 2, 'South Auckland', -37.831616, 176.325227, 'New Zealand', true, 1),
(6723, 'Waingaro Road', 73, 'South Auckland', -37.660886, 175.014631, 'New Zealand', true, 1),
(6747, 'Waiopehu Stream', 89, 'Wellington', -40.741124, 175.364559, 'New Zealand', true, 1),
(6783, 'Waipaua Stream', 89, 'South Auckland', -38.315448, 174.717256, 'New Zealand', true, 1),
(6918, 'Webb Ridge', 72, 'Nelson', -41.476017, 172.218452, 'New Zealand', true, 1),
(6969, 'Whakapapa', 93, 'Wellington', -40.820868, 175.54942, 'New Zealand', true, 1),
(7159, 'Woodlands Stream', 89, 'North Auckland', -36.954632, 174.63239, 'New Zealand', true, 1),
(7267, 'Otiria-Okaihau Industrial Railway', 64, 'North Auckland', -35.44978, 173.811428, 'New Zealand', true, 1),
(7336, 'Mount Herbert/Te Ahu Patiki', 38, 'Canterbury', -43.689391, 172.741594, 'New Zealand', true, 1),
(7347, 'Kotukutuku Bay', 6, 'South Auckland', -38.205466, 176.381278, 'New Zealand', true, 1),
(7419, 'Punawhakareia Bay', 6, 'South Auckland', -38.053039, 176.442401, 'New Zealand', true, 1),
(7435, 'Selwyn River/Waikirikiri', 89, 'Canterbury', -43.615271, 172.126066, 'New Zealand', true, 1),
(7443, 'Stewart Island/Rakiura', 43, 'Southland', -47.000818, 167.999849, 'New Zealand', true, 1),
(7628, 'Awakino Government Purpose Wildlife Management Reserve', 37, 'North Auckland', -35.878333, 173.855833, 'New Zealand', true, 1),
(7899, 'Elaine Bay Recreation Reserve', 69, 'Nelson', -41.055, 173.769444, 'New Zealand', true, 1),
(8096, 'Hokonui Scenic Reserve', 79, 'Southland', -46.152222, 168.556389, 'New Zealand', true, 1),
(8115, 'Howdens Bush Scenic Reserve', 79, 'Marlborough', -41.09, 174.198889, 'New Zealand', true, 1),
(8133, 'Hutchinson Scenic Reserve', 79, 'Hawke''s Bay', -39.271111, 176.546111, 'New Zealand', true, 1),
(8279, 'Kerikeri Basin Recreation Reserve', 69, 'North Auckland', -35.215833, 173.959722, 'New Zealand', true, 1),
(8451, 'Long Bay Scenic Reserve', 79, 'Canterbury', -43.859722, 172.871389, 'New Zealand', true, 1),
(8519, 'Makuri Gorge Scenic Reserve', 79, 'Wellington', -40.546389, 175.978056, 'New Zealand', true, 1),
(8776, 'Motutangi Scenic Reserve', 79, 'North Auckland', -34.885833, 173.157778, 'New Zealand', true, 1),
(8923, 'Okaharau Road Scenic Reserve', 79, 'North Auckland', -35.713889, 173.820556, 'New Zealand', true, 1),
(8966, 'Onaero River Scenic Reserve', 79, 'Taranaki', -38.998611, 174.365556, 'New Zealand', true, 1),
(9241, 'Pukerau Red Tussock Scientific Reserve', 80, 'Southland', -46.09692, 169.077353, 'New Zealand', true, 1),
(9293, 'Raincliff Historic Reserve', 39, 'Canterbury', -44.1625, 170.993056, 'New Zealand', true, 1),
(9355, 'Ripapa Island Historic Reserve', 39, 'Canterbury', -43.620528, 172.754173, 'New Zealand', false, 1),
(9376, 'Rotokahu Scenic Reserve', 79, 'Wellington', -39.154167, 175.188056, 'New Zealand', true, 1),
(9487, 'Station Creek Scenic Reserve', 79, 'Nelson', -42.211389, 172.2625, 'New Zealand', false, 2),
(9488, 'Station Creek Scenic Reserve', 79, 'Nelson', -42.211389, 172.2625, 'New Zealand', false, 3),
(9489, 'Station Creek Scenic Reserve', 79, 'Nelson', -42.211389, 172.2625, 'New Zealand', false, 4),
(9490, 'Station Creek Scenic Reserve', 79, 'Nelson', -42.211389, 172.2625, 'New Zealand', false, 5),
(9491, 'Station Creek Scenic Reserve', 79, 'Nelson', -42.211389, 172.2625, 'New Zealand', false, 6),
(9001, 'Private Glade', 39, 'Canterbury', -44.1625, 170.993056, 'New Zealand', false, 3),
(9000, 'Japan', 39, 'Japan', -44.1625, 170.993056, 'Japan', true, 1),
(10000, 'Canterbury University', 3, 'Christchurch', -43.523434, 172.581681, 'New Zealand', false, 3);


INSERT INTO `photo` (`id`, `main_filename`, `thumbnail_filename`, `upload_date`, `upload_profile_id`, `content_type`) VALUES
(1, 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e315', 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e315', '2019-05-25', 1, 'image/png'),
(2, 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e317', 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e317', '2019-05-25', 2, 'image/png'),
(3, 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e318', 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e318', '2019-05-25', 2, 'image/png'),
(4, 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e319', 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e319', '2019-05-25', 3, 'image/png'),
(5, 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e316', 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e316', '2019-05-25', 2, 'image/png'),
(6, 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e316', 'temp/935330b4-1adb-4d4c-9b2b-2e2a5638e316', '2019-05-25', 3, 'image/png');


INSERT INTO `personal_photo` (`id`, `photo_id`, `profile_id`, `is_public`) VALUES
(1, 1, 1, true),
(2, 2, 2, true),
(3, 3, 2, true),
(4, 4, 1, true),
(5, 5, 2, true),
(6, 6, 3, true);


INSERT INTO `destination_personal_photo` (`destination_id`, `personal_photo_id`) VALUES
(119, 3),
(119, 4),
(119, 5);


INSERT INTO `quest` (`id`, `title`, `start_date`, `end_date`, `owner_id`) VALUES
(1, 'Journey to the centre of the Earth', '2019-08-16 03:02:00', '2020-08-16 11:59:00', 1),
(2, 'My new quest', '2019-08-15 22:47:00', '2030-08-16 11:59:00', 6),
(3, 'I am your father', '2019-08-16 03:02:00', '2030-08-16 11:59:00', 2),
(4, 'Use the force Luke', '2019-08-15 04:04:00', '2030-08-16 11:59:00', 2),
(5, 'Energise', '2019-08-15 04:09:00', '2030-08-16 11:59:00', 1),
(6, 'Urlaub in Europa', '1998-05-21 12:00:01', '2030-06-21 23:59:59', 1),
(7, 'International Quest', '1998-05-21 12:00:01', '2030-06-21 23:59:59', 10),
(8, 'Quest with objective to delete', '1998-05-21 12:00:01', '2030-06-21 23:59:59', 2),
(9, 'Odyssey Quest', '1998-05-21 12:00:01', '2030-06-21 23:59:59', 2);


INSERT INTO `objective` (`id`, `destination_id`, `riddle`, `radius`, `owner_id`, `quest_using_id`) VALUES
(1, 567, 'Gully that *may* have killed its family', 1, 2, 1),
(12, 1834, 'I am the capital of Australia', 1, 2, 1),
(2, 733, 'The hive of activity in NZ', 1, 2, 1),
(3, 858, 'Second Home of Computer Scientists', 1, 1, 2),
(13, 1834, 'I like to move it, move it!', 0.02, 2, 2),
(4, 1031, 'What Rhymes with "sniff cream file week"?', 1, 2, 3),
(5, 1465, 'What is your favourite colour', 1, 2, 3),
(6, 1526, 'Where does santa live?', 1, 2, 3),
(7, 1797, 'I am the place of government in russia', 1, 2, 3),
(8, 1834, 'My radius riddle', 1, 2, 4),
(9, 1834, 'Under the seeeeeeeeaaaaaaaa', 1, 2, 4),
(10, 1834, 'In german I am named Koeln', 1, 2, 5),
(11, 119, 'I am the capital of Switzerland', 1, 2, 5),
(14, 1834, 'The better engineering university', 1, 2, null),
(15, 1834, 'One small step for man, one giant leap for mankind', 1, 2, null),
(16, 1834, 'Gully that *may* have killed its family', 1, 2, null),
(17, 1834, 'What rhymes with smangus fat?', 0.005, 2, null),
(18, 9000, 'Earthquake prone country that has had a nuclear bomb.', 10, 10, 7),
(19, 9000, 'Earthquake 3.', 10, 2, 8),
(20, 9000, 'Earthquake 4', 10, 2, 9),
(21, 9000, 'Earthquake 5', 10, 2, 9),
(22, 9000, 'Earthquake 6', 10, 2, 9),
(23, 9000, 'Earthquake 7', 10, 2, 9),
(24, 9000, 'Earthquake 8', 10, 2, 9),
(25, 9000, 'Earthquake 9', 10, 2, 9),
(26, 9000, 'Earthquake 10', 10, 2, 9),
(27, 9000, 'Earthquake 11', 10, 2, 9),
(28, 9000, 'Earthquake 12', 10, 2, 9),
(29, 9000, 'Earthquake 13', 10, 2, 9),
(30, 1031, 'What Rhymes with "sniff cream file week"?', 1, 2, 7),
(31, 119, 'I am the capital of Switzerland', 1, 2, 6),
(32, 119, 'I am the capital of Switzerland', 1, 2, 7);


INSERT INTO `quest_attempt` (`id`, `attempted_by_id`, `quest_attempted_id`, `solved_current`, `checked_in_index`, `completed`) VALUES
(1, 1, 1, 0, 0, 0),
(2, 1, 3, 1, 3, 0),
(3, 2, 3, 1, 1, 0),
(4, 2, 4, 0, 1, 0),
(5, 3, 5, 0, 2, 1),
(6, 4, 2, 0, 2, 1),
(7, 7, 6, 1, 0, 0),
(8, 7, 5, 1, 1, 0),
(9, 8, 5, 1, 1, 0),
(10, 9, 5, 1, 1, 0),
(11, 7, 7, 1, 2, 0),
(12, 8, 7, 1, 2, 0),
(13, 9, 7, 1, 2, 0),
(14, 7, 9, 1, 9, 0),
(15, 8, 9, 1, 9, 0),
(16, 9, 9, 1, 9, 0),
(17, 8, 6, 1, 0, 0),
(18, 9, 6, 1, 0, 0),
(19, 5, 4, 0, 1, 0),
(20, 2, 8, 0, 1, 1);


INSERT INTO `hint` (`id`, `message`, `up_votes`, `down_votes`, `objective_id`, `creator_id`) VALUES
(1, 'This is a hint', 10, 3, 18, 7),
(2, 'This is also a hint', 4, 10, 24, 7),
(3, 'Think about the first word carefully', 45, 38, 31, 8),
(4, 'The most up-voted hint', 100, 1, 18, 7),
(5, 'The second most up-voted hint', 99, 1, 18, 7),
(6, 'The second-equal up-voted hint', 100, 2, 18, 7),
(7, 'First requested hint', 70, 2, 9, 7),
(8, 'Second requested hint', 60, 2, 9, 7),
(9, 'Third requested hint', 50, 2, 9, 7),
(10, 'Fourth requested hint', 40, 2, 9, 7),
(11, 'Fourth requested hint', 40, 2, 29, 7),
(12, 'Fourth requested hint', 40, 2, 29, 7);


INSERT INTO `vote` (`id`, `voter_id`, `target_hint_id`, `is_up_vote`) VALUES
(1, 9, 2, false),
(2, 7, 3, true);

INSERT INTO `hint_profile` (`hint_id`, `profile_id`) VALUES
(2, 2),
(2, 3),
(4, 8),
(4, 7),
(3, 3);
