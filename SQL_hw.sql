use sakila;
#1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;
#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select CONCAT (first_name, " ",last_name) as "Actor Name" from actor;
#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name = "joe";
#2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name from actor where last_name like "%GEN%";
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name from actor where last_name like "%LI%" order by last_name, first_name;
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country FROM sakila.country where country in ("Afghanistan", "Bangladesh","China");
#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
add column description blob;
select * from actor;
#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop description;
select * from actor;
#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as "Last Name Count" from actor group by last_name;
#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as "Last_Name_Count" from actor group by last_name having Last_Name_Count >= 2;
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor set first_name ="HARPO" WHERE first_name = "GROUCHO" and last_name = "WILLIAMS";
select * from actor where last_name = "Williams";
#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name ="GROUCHO" WHERE first_name = "HARPO" and last_name = "WILLIAMS";
select * from actor where last_name = "Williams";
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select staff.first_name, staff.last_name, address.address
from staff
inner join address ON address.address_id=staff.address_id;





