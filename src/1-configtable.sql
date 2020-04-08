CREATE LANGUAGE plpython3u;

create table configuracion
(
	id int primary key, 
	_key varchar(20) not null unique,
	_value varchar(200)
);


insert into configuracion
(id,_key,_value)
values
(1,'email_user','someone@gmail.com');


insert into configuracion
(id,_key,_value)
values
(2,'email_password','somepassword');


insert into configuracion
(id,_key,_value)
values
(3,'smtp_server','smtp.gmail.com');

insert into configuracion
(id,_key,_value)
values
(4,'smtp_port','465');