use sakila;

/* 1a. */ select first_name,last_name from actor;
/* 1b. */ select upper(concat(first_name,' ',last_name)) as 'Actor Name' from actor;
/* 2a. */ select actor_id,first_name,last_name from actor where upper(first_name) in ('JOE');
/* 2b. */ select * from actor where upper(last_name) like '%GEN%';
/* 2c. */ select * from actor where upper(last_name) like '%LI%' order by last_name,first_name;
/* 2d. */ select country_id, country from country  where upper(country) in ('AFGHANISTAN','BANGLADESH','CHINA');
/* 3a. */ alter table actor add column middle_name varchar(45) after first_name;
/* 3b. */ alter table actor modify column middle_name blob;
/* 3c. */ alter table actor drop column middle_name;
/* 4a. */ select last_name,count(*) `LastName count` from actor group by last_name;
/* 4b. */ select last_name,count(*) from actor group by last_name having count(*)>1;
/* 4c. */ update actor set first_name='HARPO' where upper(first_name) ='GROUCHO' and upper(last_name) = 'WILLIAMS';
/* 4d. */ update actor set first_name='MUCHO GROUCHO' where upper(first_name) = 'HARPO' and upper(last_name) ='WILLIAMS';
/* 5a. */ show create table address;

/* 6a. */ 
select a.first_name,a.last_name,b.address,b.address2,b.district,c.city 
from staff a join address b on a.address_id=b.address_id 
			 join city c on b.city_id=c.city_id;


/* 6b */
select a.first_name,a.last_name,b.amount from staff a join (
select staff_id, sum(amount) as amount from payment
where month(payment_date) =8 and year(payment_date) =2005
group by staff_id) b on a.staff_id=b.staff_id;

/* 6c */
select a.title,b.num_actors as 'number of actors' from film a 
 join(select film_id,count(actor_id) as 'num_actors' from film_actor group by film_id) b 
 on a.film_id=b.film_id;

/* 6d */
select a.title,count(*) from film a join inventory b on a.film_id=b.film_id
where a.title='Hunchback Impossible'
group by a.title;

/* 6e */
select a.first_name,a.last_name,b.Amount as 'Total Amount Paid' from customer a join (
select customer_id,sum(amount) as Amount from payment
group by customer_id) b on a.customer_id=b.customer_id
order by a.last_name,a.first_name;

/* 7a */
select title from film a join language b on a.language_id=b.language_id
where b.name='English' and (upper(title) like 'K%' or upper(title) like 'Q%') order by title desc;

/* 7b */
select a.title,c.first_name,c.last_name 
from film a join film_actor b on a.film_id=b.film_id
			join actor c on b.actor_id=c.actor_id
where upper(a.title)='ALONE TRIP';

/* 7c */
select a.first_name,a.last_name,a.email 
from customer a join (
						select address_id 
                        from address 
                        where city_id in( select city_id 
										  from city 
										  where country_id in (select country_id 
																from country 
																where upper(country)='CANADA'
                                                               )
										)
					 ) b on a.address_id=b.address_id;
                     
/*  7d */
select a.title,c.name as category
from film a join film_category b on  a.film_id=b.film_id
			join category c on b.category_id=c.category_id
where upper(c.name)='FAMILY';
                                   
/*  7e */
select x.title,y.numrental as 'Num of Times Rented' from film x join (select b.film_id,count(*) as numrental
from rental a join inventory b on a.inventory_id=b.inventory_id
group by b.film_id) y on x.film_id=y.film_id 
order by y.numrental desc;

/* 7f */
select s.store_id,sum(p.amount) 'Amount' from store s 
	join inventory i on s.store_id=i.store_id
    join rental r on i.inventory_id=r.inventory_id
    join payment p on r.rental_id=p.rental_id
group by s.store_id;
    
								
/* 7g */
select s.store_id,c.city,cc.country from store s 
	join address a on s.address_id=a.address_id
    join city c on a.city_id=c.city_id
    join country cc on c.country_id=cc.country_id;

/* 7h */
select c.name as `Film Category`,sum(p.amount) as `Gross Revenue` from category c 
			   join film_category fc on c.category_id=fc.category_id
               join inventory i on fc.film_id=i.film_id
               join rental r on i.inventory_id=r.inventory_id
               join payment p on r.rental_id=p.rental_id
group by c.category_id
order by `Gross Revenue` desc	
limit 5 ;
			
/* 8a */            
create view Top5_GrossRevenue as
select c.name as `Film Category`,sum(p.amount) as `Gross Revenue` from category c 
			   join film_category fc on c.category_id=fc.category_id
               join inventory i on fc.film_id=i.film_id
               join rental r on i.inventory_id=r.inventory_id
               join payment p on r.rental_id=p.rental_id
group by c.category_id
order by `Gross Revenue` desc	
limit 5 ;

/* 8b */
select * from     Top5_GrossRevenue;                               

/* 8c */
drop view Top5_GrossRevenue;  
