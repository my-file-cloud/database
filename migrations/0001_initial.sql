create table bas_user 
(
    id          varchar(255) not null,
    name        varchar(255) not null,
    password    varchar(255) not null,
    unique (name),
    primary key (id)
);

create table bas_session (
    id            varchar(255) not null,
    refresh_token varchar(255),
    user_id       varchar(255),
    unique (refresh_token),
    primary key (id),
    foreign key (user_id) references bas_user (id)
);
