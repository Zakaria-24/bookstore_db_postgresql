--! 1️⃣ Create a "books" table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    price NUMERIC( 10, 2 ) CHECK (price >= 0),
    stock INT CHECK (stock >= 0),
    published_year INT
);
INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 10.99, 5, 1925),
('1984', 'George Orwell', 8.50, 3, 1949),
('To Kill a Mockingbird', 'Harper Lee', 12.75, 7, 1960),
('Moby Dick', 'Herman Melville', 15.20, 4, 1851),
('War and Peace', 'Leo Tolstoy', 20.99, 10, 1869),
('Pride and Prejudice', 'Jane Austen', 9.99, 6, 1813),
('The Catcher in the Rye', 'J.D. Salinger', 11.50, 2, 1951),
('Brave New World', 'Aldous Huxley', 13.25, 8, 1932),
('The Hobbit', 'J.R.R. Tolkien', 14.99, 9, 1937),
('The Obstacle Is the Way', 'Ryan Holiday', 14.99, 8, 2014);

SELECT * FROM books;
DROP TABLE books;




--!  Create a "customers" table 
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);
INSERT INTO customers (name, email, joined_date) VALUES
('John Doe', 'johndoe1@example.com', '2024-01-01'),
('Jane Smith', 'janesmith2@example.com', '2024-01-02'),
('Michael Johnson', 'michaelj3@example.com', '2024-01-03'),
('Emily Davis', 'emilyd4@example.com', '2024-01-04'),
('Ella Brooks', 'ellab56@example.com', '2024-02-26');

SELECT * FROM customers;
DROP TABLE customers;



--! Create an "orders" table 
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id),
    book_id INT NOT NULL REFERENCES books(id),
    quantity INT CHECK (quantity > 0) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 5, 2, '2024-03-01 10:15:00'),
(3, 3, 1, '2024-03-02 11:30:00'),
(3, 5, 3, '2024-03-03 14:45:00'),
(2, 2, 5, '2024-03-04 09:00:00'),
(5, 8, 4, '2024-03-20 19:55:00');

INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 5, 2, '2024-03-01 10:15:00');

SELECT * FROM orders;
DROP TABLE orders;





--! PROBLEM && SOLVE 

--* 1️⃣ Find books that are out of stock.
SELECT * FROM books;
SELECT title FROM books
    WHERE stock = 0;




--* 2️⃣ Retrieve the most expensive book in the store.
SELECT * FROM books
    ORDER BY price DESC
    LIMIT 1;
-- or
SELECT * FROM books
    WHERE price = (SELECT MAX(price) FROM books);




--* 3️⃣ Find the total number of orders placed by each customer.
SELECT * from customers;
SELECT * from orders;
SELECT name, COUNT(o.id) AS total_orders FROM customers AS c
    Left JOIN orders AS o ON c.id = o.customer_id
    GROUP BY c.name
    ORDER BY total_orders DESC;
-- or
SELECT name, (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.id) AS total_orders FROM customers c
ORDER BY total_orders DESC;





--* 4️⃣ Calculate the total revenue generated from book sales.
 SELECT * FROM orders;
 SELECT * FROM books;
--   SELECT * FROM orders AS o
--     JOIN books AS b ON  o.book_id = b.id;
--  SELECT quantity, price FROM orders o
--     JOIN books b ON o.book_id = b.id;
--  SELECT quantity * price AS total_revenue FROM orders o
--     JOIN books b ON o.book_id = b.id;
 SELECT SUM(price * quantity) AS total_revenue FROM orders o
    JOIN books b ON o.book_id = b.id;




--* 5️⃣ List all customers who have placed more than one order.
 SELECT * FROM customers;
 SELECT * FROM orders;
--  SELECT * FROM customers AS c
--     JOIN orders AS o ON c.id = o.customer_id;

SELECT name, SUM(o.quantity) AS orders_count FROM customers AS c
    JOIN orders AS o ON c.id = o.customer_id
    GROUP BY c.name
    HAVING SUM(o.quantity) > 1
    ORDER BY orders_count DESC;





--* 6️⃣ Find the average price of books in the store.
SELECT * FROM books;
SELECT ROUND(AVG(price), 2) AS avg_book_price FROM books;




--* 7️⃣ Increase the price of all books published before 2000 by 10%.
 SELECT * FROM books;
-- SELECT * FROM books 
--     WHERE published_year < 2000;

UPDATE books 
    SET price = ROUND(price * 1.10, 2)
    WHERE published_year < 2000;




--* 8️⃣ Delete customers who haven't placed any orders.

SELECT * FROM orders;
SELECT * FROM customers;
-- SELECT DISTINCT customer_id FROM orders;
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);