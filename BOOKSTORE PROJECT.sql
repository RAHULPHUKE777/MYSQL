USE BOOKSTORE_PROJECT;

SELECT *FROM BOOKS;
SELECT *FROM CUSTOMERS;
SELECT *FROM ORDERS;

##===========================================================================================================================================================================##

# Retrieve all books in the "Fiction" genre

SELECT BOOK_ID,TITLE,GENRE FROM BOOKS WHERE GENRE = "Fiction";

##===========================================================================================================================================================================##

# Find books published after the year 1950

SELECT BOOK_ID,TITLE,PUBLISHED_YEAR FROM BOOKS WHERE PUBLISHED_YEAR > 1950 order by PUBLISHED_YEAR;
##===========================================================================================================================================================================##

# List all customers from the Canada

select *from customers;

SELECT CUSTOMER_ID,NAME,EMAIL,COUNTRY FROM CUSTOMERS WHERE COUNTRY ="Canada";

##===========================================================================================================================================================================##

# Show orders placed in November 2023

SELECT *FROM ORDERS;

SELECT ORDER_ID, BOOK_ID, QUANTITY, ORDER_DATE
FROM ORDERS
WHERE MONTH(ORDER_DATE) = 11 AND YEAR(ORDER_DATE) = 2023;

##===========================================================================================================================================================================##

# Retrieve the total stock of books available

SELECT *FROM BOOKS;

SELECT sum(STOCK) AS TOTAL_STOCK FROM BOOKS;

##===========================================================================================================================================================================##\

#Find the details of the most expensive book

SELECT *FROM BOOKS;

SELECT BOOK_ID,TITLE,AUTHOR,GENRE,PUBLISHED_YEAR,PRICE FROM BOOKS order by PRICE DESC LIMIT 1;

#===========================================================================================================================================================================##

#  Show all customers who ordered more than 1 quantity of a book
SELECT *FROM ORDERS;

SELECT CUSTOMER_ID,QUANTITY FROM ORDERS WHERE QUANTITY >1;

#===========================================================================================================================================================================##

# Retrieve all orders where the total amount exceeds $20

SELECT *FROM ORDERS;

SELECT Order_ID,ORDER_DATE,TOTAL_AMOUNT FROM ORDERS WHERE TOTAL_AMOUNT>20 ORDER BY TOTAL_AMOUNT;

#===========================================================================================================================================================================##
# List all genres available in the Books table

SELECT *FROM BOOKS;

SELECT distinct GENRE FROM BOOKS;

#===========================================================================================================================================================================##

# Find the book with the lowest stock

SELECT *FROM BOOKS;
SELECT BOOK_ID,TITLE,AUTHOR,STOCK FROM BOOKS order by STOCK LIMIT 1;

##==========================================================================================================================================================================##
# Calculate the total revenue generated from all orders

SELECT *FROM ORDERS;

SELECT round(SUM(TOTAL_AMOUNT),2) AS "TOTAL_REVENUE($)" FROM ORDERS;

##==========================================================================================================================================================================##
# Retrieve the total number of books sold for each genre

SELECT *FROM BOOKS;
SELECT *FROM ORDERS;

SELECT B.GENRE,sum(O.QUANTITY) AS BOOKS_SOLD
FROM ORDERS AS O JOIN BOOKS AS B ON B.BOOK_ID=O.BOOK_ID
group by B.GENRE ORDER BY BOOKS_SOLD DESC;

##==========================================================================================================================================================================##

#Find the average price of books in the "Fantasy" genre

SELECT *FROM BOOKS;

SELECT GENRE,round(AVG(price),2) as AVG_PRICE FROM BOOKS WHERE GENRE= "Fantasy";

##==========================================================================================================================================================================##
# List customers who have placed at least 2 orders

SELECT *FROM ORDERS;

SELECT CUSTOMER_ID, COUNT(ORDER_ID) AS NO_OF_ORDERS
FROM ORDERS
GROUP BY CUSTOMER_ID
HAVING COUNT(ORDER_ID) >= 2;

##==========================================================================================================================================================================##

# Find the most frequently ordered book

SELECT *FROM BOOKS;
SELECT *FROM ORDERS;

SELECT B.TITLE, COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM ORDERS AS O
JOIN BOOKS AS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY B.BOOK_ID, B.TITLE
ORDER BY ORDER_COUNT DESC
LIMIT 1;

##==========================================================================================================================================================================##

# Show the top 3 most expensive books of 'Fantasy' Genre

SELECT *FROM BOOKS;

SELECT TITLE,GENRE,PRICE FROM BOOKS 
WHERE GENRE= "Fantasy" 
order by PRICE DESC LIMIT 3;

##==========================================================================================================================================================================##

# Retrieve the total quantity of books sold by each author

select *from BOOKS;
SELECT *FROM ORDERS;

select B.AUTHOR, sum(O.QUANTITY) AS BOOKS_SOLD 
FROM ORDERS AS O
JOIN BOOKS AS B ON O.BOOK_ID=B.BOOK_ID
GROUP BY B.AUTHOR 
order by BOOKS_SOLD DESC;

##==========================================================================================================================================================================##

# List the cities where customers who spent over $30 are located

SELECT *FROM CUSTOMERS;
SELECT *FROM ORDERS;

SELECT distinct C.CITY,O.TOTAL_AMOUNT 
FROM ORDERS AS O
JOIN CUSTOMERS AS C ON C.Customer_ID=O.Customer_ID
WHERE O.TOTAL_AMOUNT > 30.0 
order by O.TOTAL_AMOUNT DESC;

##=========================================================================================================================================================================##

# Find the customer who spent the most on orders

SELECT *FROM CUSTOMERS;
SELECT *FROM ORDERS;

SELECT distinct C.Customer_ID,C.Name,ROUND(sum(O.TOTAL_AMOUNT),2) AS TOTAL_SPENT
FROM ORDERS AS O
JOIN CUSTOMERS AS C ON C.Customer_ID=O.Customer_ID
group by C.CUSTOMER_ID,C.NAME
ORDER BY TOTAL_SPENT DESC LIMIT 1;

##==========================================================================================================================================================================##

#Calculate the stock remaining after fulfilling all orders

SELECT *FROM BOOKS;
SELECT *FROM ORDERS;

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

##==========================================================================================================================================================================##




























