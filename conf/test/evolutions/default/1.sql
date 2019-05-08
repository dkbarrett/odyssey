
# --- !Ups

create table destination (
  id                            bigint auto_increment not null,
  name                          varchar(255),
  type_id                       bigint,
  district                      varchar(255),
  latitude                      double not null,
  longitude                     double not null,
  country                       varchar(255),
  constraint pk_destination primary key (id)
);

create table destination_type (
  id                            bigint auto_increment not null,
  destination_type              varchar(255),
  constraint pk_destination_type primary key (id)
);

create table nationality (
  id                            bigint auto_increment not null,
  nationality                   varchar(255),
  country                       varchar(255),
  constraint pk_nationality primary key (id)
);

create table passport (
  id                            bigint auto_increment not null,
  country                       varchar(255),
  constraint pk_passport primary key (id)
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
  is_admin                      boolean,
  date_of_creation              timestamp,
  constraint pk_profile primary key (id)
);

create table profile_nationality (
  profile_id                    bigint not null,
  nationality_id                bigint not null,
  constraint pk_profile_nationality primary key (profile_id,nationality_id)
);

create table profile_traveller_type (
  profile_id                    bigint not null,
  traveller_type_id             bigint not null,
  constraint pk_profile_traveller_type primary key (profile_id,traveller_type_id)
);

create table profile_passport (
  profile_id                    bigint not null,
  passport_id                   bigint not null,
  constraint pk_profile_passport primary key (profile_id,passport_id)
);

create table traveller_type (
  id                            bigint auto_increment not null,
  traveller_type                varchar(255),
  description                   varchar(255),
  img_url                       varchar(255),
  constraint pk_traveller_type primary key (id)
);

create table trip (
  id                            bigint auto_increment not null,
  profile_id                    bigint not null,
  name                          varchar(255),
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

create index ix_destination_type_id on destination (type_id);
alter table destination add constraint fk_destination_type_id foreign key (type_id) references destination_type (id) on delete restrict on update restrict;

create index ix_profile_nationality_profile on profile_nationality (profile_id);
alter table profile_nationality add constraint fk_profile_nationality_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_profile_nationality_nationality on profile_nationality (nationality_id);
alter table profile_nationality add constraint fk_profile_nationality_nationality foreign key (nationality_id) references nationality (id) on delete restrict on update restrict;

create index ix_profile_traveller_type_profile on profile_traveller_type (profile_id);
alter table profile_traveller_type add constraint fk_profile_traveller_type_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_profile_traveller_type_traveller_type on profile_traveller_type (traveller_type_id);
alter table profile_traveller_type add constraint fk_profile_traveller_type_traveller_type foreign key (traveller_type_id) references traveller_type (id) on delete restrict on update restrict;

create index ix_profile_passport_profile on profile_passport (profile_id);
alter table profile_passport add constraint fk_profile_passport_profile foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_profile_passport_passport on profile_passport (passport_id);
alter table profile_passport add constraint fk_profile_passport_passport foreign key (passport_id) references passport (id) on delete restrict on update restrict;

create index ix_trip_profile_id on trip (profile_id);
alter table trip add constraint fk_trip_profile_id foreign key (profile_id) references profile (id) on delete restrict on update restrict;

create index ix_trip_destination_trip_id on trip_destination (trip_id);
alter table trip_destination add constraint fk_trip_destination_trip_id foreign key (trip_id) references trip (id) on delete restrict on update restrict;

create index ix_trip_destination_destination_id on trip_destination (destination_id);
alter table trip_destination add constraint fk_trip_destination_destination_id foreign key (destination_id) references destination (id) on delete restrict on update restrict;


# --- !Downs

alter table destination drop constraint if exists fk_destination_type_id;
drop index if exists ix_destination_type_id;

alter table profile_nationality drop constraint if exists fk_profile_nationality_profile;
drop index if exists ix_profile_nationality_profile;

alter table profile_nationality drop constraint if exists fk_profile_nationality_nationality;
drop index if exists ix_profile_nationality_nationality;

alter table profile_traveller_type drop constraint if exists fk_profile_traveller_type_profile;
drop index if exists ix_profile_traveller_type_profile;

alter table profile_traveller_type drop constraint if exists fk_profile_traveller_type_traveller_type;
drop index if exists ix_profile_traveller_type_traveller_type;

alter table profile_passport drop constraint if exists fk_profile_passport_profile;
drop index if exists ix_profile_passport_profile;

alter table profile_passport drop constraint if exists fk_profile_passport_passport;
drop index if exists ix_profile_passport_passport;

alter table trip drop constraint if exists fk_trip_profile_id;
drop index if exists ix_trip_profile_id;

alter table trip_destination drop constraint if exists fk_trip_destination_trip_id;
drop index if exists ix_trip_destination_trip_id;

alter table trip_destination drop constraint if exists fk_trip_destination_destination_id;
drop index if exists ix_trip_destination_destination_id;

drop table if exists destination;

drop table if exists destination_type;

drop table if exists nationality;

drop table if exists passport;

drop table if exists profile;

drop table if exists profile_nationality;

drop table if exists profile_traveller_type;

drop table if exists profile_passport;

drop table if exists traveller_type;

drop table if exists trip;

drop table if exists trip_destination;
