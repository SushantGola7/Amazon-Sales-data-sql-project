SELECT * FROM amazon_data.amazon;
-- sql mini capstone project on Amazon
-- adding new coloum timeofday 

alter table amazon_data.amazon
add column timeofday varchar (50) after time;

-- updating values in timeofday 
set sql_safe_updates = 0;

 update amazon_data.amazon
 set timeofday = 
  case
      when time(time) >= '00:00:00' and time(time) < '12:00:00' then 'morning'
	  when time(time) >= '12:00:00' and  time(time) < '18:00:00' then 'afternoon'
       else 'evening'
  end ;   
  
  -- adding column dayname after date
  alter table amazon_data.amazon
  add column dayname varchar (50) after date;
  
  -- adding values to dayname
  update amazon_data.amazon
  set dayname =
  case dayofweek(date)
      when 1 then "sunday"
      when 2 then "monday"
      when 3 then "tuesday"
      when 4 then "wednesday"
      when 5 then "thursday"
      when 6 then "friday"
      when 7 then "saturday"
   end;
   
-- adding monthname column
alter table amazon_data.amazon
add column monthname varchar (50) after dayname;

-- adding value to monthname
update amazon_data.amazon
set monthname = 
case month(date)
	  when 1 then "jan"
      when 2 then "feb"
      when 3 then "mar"
      when 4 then "april"
      when 5 then "may"
      when 6 then "june"
      when 7 then "july"
      when 8 then "aug"
      when 9 then "sep"
      when 10 then "oct"
      when 11 then "nov"
      when 12 then "dec"
   end;
   
   -- Business Questions
-- 1. What is the count of distinct cities in the dataset?
select distinct(city) from amazon;

-- 2.For each branch, what is the corresponding city?
select distinct branch,city from amazon;

-- 3.What is the count of distinct product lines in the dataset?
select count(distinct "product line" ) from amazon;
 
-- 4. Which payment method occurs most frequently?
select payment , count(*) as total  from amazon 
group by payment
limit 1

-- 5.Which product line has the highest sales?
select `product line`, COUNT(*) AS total_sales
from amazon
Group BY `product line`
Order BY total_sales DESC;

-- 6 How much revenue is generated each month?
SELECT monthname , sum(total) as revenue from amazon
group by monthname
order by revenue
desc;

-- 7.In which month did the cost of goods sold reach its peak?
select monthname , sum(cogs) as total_cogs from amazon
group by monthname
order by total_cogs
desc;

-- 8.Which product line generated the highest revenue?
select `product line` , sum(total) as revenue from amazon
group by `product line`
order by revenue
desc
limit 1;

-- 9.In which city was the highest revenue recorded?
select city , sum(total) as highest from amazon
group by city 
order by sum(total)
desc
limit 1

-- 10. Which product line incurred the highest Value Added Tax?
select `product line` , sum(`Tax 5%`) as highest_vat from amazon
group by `product line`
order by highest_vat
desc
limit 1;

-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select `product line`, sum(total) as total_sales,
case 
   when sum(total) > (
                      select avg(total_sales) from
                      (select `product line` , sum(total) as total_sales from amazon
                      group by `product line`) as AVG ) 
                      then 'good'
                      else 'Bad'
              end as Status
              from amazon
              group by `product line`
              order by total_sales desc;
 
 -- 12. Identify the branch that exceeded the average number of products sold.
 select branch, sum(quantity) from amazon
 group by branch
  having sum(quantity) > (select avg(quantity) from amazon);
              
-- 13. Which product line is most frequently associated with each gender?
select `product line`, gender,count(*) from amazon
group by `product line`,gender
order by count(*)
desc ;


-- 14.Calculate the average rating for each product line.
select `product line`, avg(rating) as avg_rating from amazon
group by `product line`
order by avg_rating
desc;

-- 15.Count the sales occurrences for each time of day on every weekday.
select timeofday,dayname,count(*) as occurences from amazon
where dayname in ('monday','tuesday','wednesday','thursday','friday')
group by dayname,timeofday
order by  occurences

-- 16.Identify the customer type contributing the highest revenue.
select `customer type` , sum(total) as highest_revenue from amazon
group by `customer type`
order by highest_revenue
desc

-- 17. Determine the city with the highest VAT percentage.
select city , sum(`tax 5%`) as highest_vat ,
 sum(total),(sum(`tax 5%`)/sum(total))*100  as vat_percentage from amazon
group by city
order by vat_percentage
desc

-- 18.Identify the customer type with the highest VAT payments.
select `customer type`, sum(`tax 5%`) as highest_vat from amazon
group by `customer type`
order by highest_vat
desc
limit 1;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct (`customer type`)) as distinct_cus from amazon;

-- 20. What is the count of distinct payment methods in the dataset?
select distinct(payment) as distinctpay, count(*) as totaldistinct_payment from amazon
group by distinctpay
order by totaldistinct_payment;

-- 21.Which customer type occurs most frequently?
select `customer type`,count(*)  as frequency from amazon
group by `customer type`
order by frequency
desc
limit 1;

-- 22.Identify the customer type with the highest purchase frequency.
select `customer type`, count(*) as highest_frequency from amazon
group by `customer type`
order by highest_frequency
desc 
limit 1;

-- 23.Determine the predominant gender among customers.
select gender, count(*) as dominent from amazon
group by gender
order by dominent 
desc
limit 1;

-- 24 Examine the distribution of genders within each branch.
select branch , gender , count(gender) as distribution from amazon
group by branch,gender
order by branch
desc;

-- 25 Identify the time of day when customers provide the most ratings
select timeofday, count(rating) from amazon
group by timeofday
order by count(rating)
desc ;

-- 26. Determine the time of day with the highest customer ratings for each branch.
select timeofday , branch , avg(rating) as avg_rating from amazon
group by timeofday , branch
order by avg_rating desc ;

-- 27.Identify the day of the week with the highest average ratings.
select dayname , avg(rating) as avg_rating from amazon
group by dayname
order by avg_rating
desc;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select dayname , branch , avg(rating) as avg_rating from amazon
group by branch, dayname
order by avg_rating
desc ;
