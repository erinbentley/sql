# Erin Bentley - SQL homework (due 2/1/2020)


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

update actor set first_name ="GROUCHO" WHERE first_name = "HARPO" and last_name = "WILLIAMS";
select * from actor where last_name = "Williams";

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select staff.first_name, staff.last_name, address.address
from staff
inner join address ON address.address_id=staff.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
select s.first_name, s.last_name, sum(p.amount) as "payment_amount" from payment p
inner join staff s on s.staff_id = p.staff_id
where p.payment_date between "2005-08-01" and "2005-09-01"
group by s.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, count(actor_id) from film
inner join film_actor fa on fa.film_id = film.film_id
group by title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select title, count(inv.film_id) as "copies" from inventory inv
inner join film f ON inv.film_id = f.film_id
where title = 'Hunchback Impossible';

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select CONCAT (last_name, ", ",first_name) as "Name", sum(p.amount) as "Total Amount Paid (Dollars)" from customer c
inner join payment p on c.customer_id = p.customer_id
group by p.customer_id order by last_name asc;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title
 from film f
 where title like ("K%") or f.title like ("Q%")
 and language_id in
 (
  SELECT language_id
  FROM language
  WHERE name = "English");


# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
 from actor a
 where actor_id in
 (
  SELECT actor_id
  FROM film_actor
  WHERE film_id in
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'));


# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email from customer
join address a on a.address_id = customer.address_id
join city c on c.city_id = a.city_id
join country co on co.country_id = c.country_id
where co.country_id = "20";

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
from film f
join film_category fc on fc.film_id= f.film_id
where fc.category_id = 8;

# 7e. Display the most frequently rented movies in descending order.
select f.title, count(f.title) as "Rental Count" from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by title order by count(f.title) desc;

# 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) as "Payment Amount (Dollars)" from payment p
inner join staff on staff.staff_id = p.staff_id
inner join store s on staff.store_id = s.store_id
group by s.store_id;


# 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, co.country from store s
join address a on a.address_id = s.address_id
join city c on c.city_id = a.city_id
join country co on co.country_id = c.country_id
group by s.store_id;

# 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name, sum(p.amount) as "Total Sales (Dollars)" from category c 
join film_category fc on fc.category_id = c.category_id
join inventory i on i.film_id = fc.film_id
join rental r on r.inventory_id = i.inventory_id
join payment p on p.rental_id = r.rental_id
group by c.name order by sum(p.amount) desc limit 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
drop view Sales_by_Category;
create view Sales_by_Category as
select c.name, sum(p.amount) as "Total Sales (Dollars)" from category c 
join film_category fc on fc.category_id = c.category_id
join inventory i on i.film_id = fc.film_id
join rental r on r.inventory_id = i.inventory_id
join payment p on p.rental_id = r.rental_id
group by c.name order by sum(p.amount) desc limit 5;

# 8b. How would you display the view that you created in 8a?
select * from Sales_by_Category;

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view Sales_by_Category;


	# Uploading Homework // To submit this homework using BootCampSpot:
	# Create a GitHub repository.
	# Upload your .sql file with the completed queries.
	# Submit a link to your GitHub repo through BootCampSpot.



