-- Tạo cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS restaurant_db;

-- Sử dụng cơ sở dữ liệu
USE restaurant_db;

-- Tạo bảng user
CREATE TABLE IF NOT EXISTS user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
);

-- Tạo bảng rate_res
CREATE TABLE IF NOT EXISTS rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng restaurant
CREATE TABLE IF NOT EXISTS restaurant (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(255),
    image VARCHAR(255),
    description VARCHAR(255)
);

-- Tạo bảng like_res
CREATE TABLE IF NOT EXISTS like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng food_type
CREATE TABLE IF NOT EXISTS food_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(255)
);

-- Tạo bảng food
CREATE TABLE IF NOT EXISTS food (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    description VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

-- Tạo bảng order_table
CREATE TABLE IF NOT EXISTS order_table (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Tạo bảng sub_food
CREATE TABLE IF NOT EXISTS sub_food (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

INSERT INTO `user` (full_name, email, password)
VALUES
('user1', 'user1@example.com', 'password1'),
('user2', 'user2@example.com', 'password2'),
('user3', 'user3@example.com', 'password3'),
('user4', 'user4@example.com', 'password4'),
('user5', 'user5@example.com', 'password5');

INSERT INTO food_type (type_id, type_name) VALUES
(0, "Món chay"),
(0, "Món tráng miệng"),
(0, "Món hải sản"),
(0, "Món thịt"),
(0, "Món nước");


INSERT INTO food (food_id, food_name, image, price, description, type_id) VALUES
(1, "Phở chay", "pho-chay.jpg", 5.99, "Món phở chay Việt Nam", 1),
(2, "Kem dâu", "kem-dau.jpg", 3.49, "Kem tráng miệng vị dâu", 1),
(3, "Tôm hấp", "tom-hap.jpg", 12.99, "Tôm hấp ngon miệng", 2),
(4, "Bò nướng", "bo-nuong.jpg", 15.99, "Món thịt bò nướng", 3),
(5, "Nước chanh", "nuoc-chanh.jpg", 1.99, "Nước chanh tươi", 3);

INSERT INTO like_res (user_id, res_id, date_like)
VALUES
(1, 1, '2022-01-01'),
(2, 1, '2022-01-02'),
(3, 2, '2022-01-03'),
(4, 2, '2022-01-04'),
(5, 3, '2022-01-05');

INSERT INTO order_table (user_id, food_id, amount, code, arr_sub_id)
VALUES
(1, 1, 2, 'ABC123', '1,2'),
(2, 3, 1, 'DEF456', '3'),
(3, 2, 3, 'GHI789', '2,4,5'),
(4, 4, 2, 'JKL012', '3,4'),
(5, 5, 1, 'MNO345', '1');

INSERT INTO restaurant (res_name, image, description)
VALUES
('Nhà hàng A', 'restaurant_a.jpg', 'Nhà hàng sang trọng với các món ăn đa dạng'),
('Nhà hàng B', 'restaurant_b.jpg', 'Nhà hàng phục vụ các món hải sản tươi ngon'),
('Nhà hàng C', 'restaurant_c.jpg', 'Nhà hàng chuyên về món thịt nướng'),
('Nhà hàng D', 'restaurant_d.jpg', 'Nhà hàng phục vụ các món chay ngon miệng'),
('Nhà hàng E', 'restaurant_e.jpg', 'Nhà hàng chuyên về món tráng miệng và đồ uống');

INSERT INTO rate_res (user_id, res_id, amount, date_rate)
VALUES
(1, 1, 4, '2022-01-01'),
(2, 1, 5, '2022-01-02'),
(3, 2, 3, '2022-01-03'),
(4, 2, 4, '2022-01-04'),
(5, 3, 2, '2022-01-05');

INSERT INTO sub_food (sub_name, sub_price, food_id)
VALUES
('Sub 1', 2.99, 1),
('Sub 2', 3.99, 1),
('Sub 3', 4.99, 2),
('Sub 4', 2.49, 2),
('Sub 5', 3.49, 3);

--Tìm 5 người đã like nhà hàng nhiều nhất
SELECT user_id, COUNT(*) AS like_count
FROM like_res
GROUP BY user_id
ORDER BY like_count DESC
LIMIT 5;

--Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT res_name, COUNT(*) AS like_count
FROM like_res
JOIN restaurant ON like_res.res_id = restaurant.res_id
GROUP BY like_res.res_id, res_name
ORDER BY like_count DESC
LIMIT 2;

--Tìm người đã đặt hàng nhiều nhất.
SELECT user_id, COUNT(*) AS order_count
FROM order_table
GROUP BY user_id
ORDER BY order_count DESC
LIMIT 1;

--Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng).
SELECT user.user_id, user.full_name
FROM user
LEFT JOIN order_table ON user.user_id = order_table.user_id
LEFT JOIN like_res ON user.user_id = like_res.user_id
LEFT JOIN rate_res ON user.user_id = rate_res.user_id
WHERE order_table.user_id IS NULL
AND like_res.user_id IS NULL
AND rate_res.user_id IS NULL;

--Tính trung bình sub_food của một food.
SELECT food_id, AVG(sub_price) AS average_sub_price
FROM sub_food
GROUP BY food_id;
