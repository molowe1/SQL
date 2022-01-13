/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

select first_name, last_name, address, district, city, country
from staff
inner join address
on staff.address_id=address.address_id
inner join city
on address.city_id=city.city_id
inner join country
on city.country_id=country.country_id
Group by first_name, last_name, address, district, city.city_id, country
	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

select store_id, inventory_id, title, rating,rental_rate, replacement_cost, 
from film
inner join inventory
on film.film_id=inventory.film_id
Group by store_id, inventory_id, title, rating,rental_rate, replacement_cost 

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

select title, rating,
COUNT(CASE WHEN store_id = 1 THEN inventory_id ELSE NULL END) AS 'store 1 invent',
COUNT(CASE WHEN store_id = 2 THEN inventory_id ELSE NULL END) AS 'store 2 invent'
from film
left join inventory
on film.film_id=inventory.film_id
Group by title, rating

select rating,
count(CASE WHEN store_id = 1 THEN inventory_id ELSE NULL END) AS 'store 1 invent',
count(CASE WHEN store_id = 2 THEN inventory_id ELSE NULL END) AS 'store 2 invent'
from film
left join inventory
on film.film_id=inventory.film_id
Group by rating

select title, rating, inventory_id, store_id
from film
left join inventory
on film.film_id=inventory.film_id
Group by title, rating, inventory_id, store_id

select rating, store_id, count(inventory_id) as count_iv
from film
left join inventory
on film.film_id=inventory.film_id
Group by rating, store_id

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 


Select category.name, store_id,
count(film.film_id) as film_count,
avg(replacement_cost) as avg_replacement_cost,
sum(replacement_cost) as tot_replacement_cost
from film
left join inventory
on film.film_id=inventory.film_id
left join film_category
on film.film_id=film_category.film_id
left join category
on film_category.category_id=category.category_id
Group by category.name, store_id
order by tot_replacement_cost

/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

select customer_id, first_name, last_name, address, city, country,
COUNT(CASE WHEN active = 1 THEN customer_id ELSE null END) AS 'member status'
FROM customer
left join address
on address.address_id=customer.address_id
left join city
on address.city_id=city.city_id
left join country
on city.country_id=country.country_id
Group by customer_id, first_name, last_name, address, city, country


/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT first_name, last_name, count(rental.rental_id) as tot_rental, sum(amount) as tot_amount
FROM rental
left join customer
on rental.customer_id=customer.customer_id
left join payment
on rental.rental_id=payment.rental_id
Group by first_name, last_name
order by tot_amount desc

    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

select
'investor' as investor_id,
first_name,
last_name,
company_name
from investor
union
select 
'advisor' as advisor_id,
first_name,
last_name,
'null' as is_chairmain
from advisor

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

3 films 4/7
2 films 61/66
1 film 70/84

select first_name, last_name, awards
from actor_award

#where awards NOT IN ('Emmy, tony', 'Emmy, Oscar', 'Oscar, Tony', 'Emmy', 'tony', 'Oscar') 
#where awards in ('Emmy, tony', 'Emmy, Oscar', 'Oscar, Tony') 
#where awards in ('Emmy', 'tony', 'Oscar') 

select first_name, last_name, film_actor.actor_id, awards, title
from actor_award
left join film_actor
on actor_award.actor_id=film_actor.actor_id
left join film
on film_actor.film_id=film.film_id
group by first_name, last_name, film_actor.actor_id

SELECT awards,
	COUNT(CASE WHEN awards in ('Emmy', 'tony', 'Oscar') THEN title ELSE NULL END) AS '1 award',
    COUNT(CASE WHEN awards in ('Emmy, tony', 'Emmy, Oscar', 'Oscar, Tony') THEN title ELSE NULL END) AS '2 award',
    COUNT(CASE WHEN awards IN ('Emmy, Oscar, Tony ') THEN title ELSE NULL END) AS '3 award'
from actor_award
left join film_actor
on actor_award.actor_id=film_actor.actor_id
left join film
on film_actor.film_id=film.film_id
group by '1 award','2 award', '3 award'
*/

select first_name, last_name, awards
from actor_award
left join film_actor
on actor_award.actor_id=film_actor.actor_id
left join film
on film_actor.film_id=film.film_id
where awards in ('Emmy') and ('tony') and ('Oscar')
group by first_name, last_name
