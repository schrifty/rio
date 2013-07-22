insert into tenants (email) values ('john.doe@gmail.com');
insert into tenants (email) values ('jane.doe@gmail.com');

insert into agents (tenant_id, available, engaged, display_name, encrypted_password, admin) values (1, true, false, "Peter Doe", "blah", false);
insert into agents (tenant_id, available, engaged, display_name, encrypted_password, admin) values (1, true, false, "James Doe", "blah", false);
insert into agents (tenant_id, available, engaged, display_name, encrypted_password, admin) values (1, true, false, "Wendy Doe", "blah", false);

truncate conversations;
truncate customers;
truncate messages;