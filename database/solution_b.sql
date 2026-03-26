-- b. Truy vấn đơn hàng
-- 1. Liệt kê các hóa đơn của khách hàng, thông tin hiển thị gồm: mã user, tên user, mã hóa đơn
SELECT u.user_id, u.user_name, o.order_id
FROM users u
JOIN orders o ON u.user_id = o.user_id;
-- 2. Liệt kê số lượng các hóa đơn của khách hàng: mã user, tên user, số đơn hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_don_hang FROM users u LEFT JOIN orders o ON u.user_id = o.user_id GROUP BY u.user_id, u.user_name;
-- 3. Liệt kê thông tin hóa đơn: mã đơn hàng, số sản phẩm
SELECT order_id, COUNT(product_id) AS so_san_pham
FROM order_details
GROUP BY order_id;
-- 4. Liệt kê thông tin mua hàng của người dùng: mã user, tên user, mã đơn hàng, tên sản
-- phẩm. Lưu ý: gôm nhóm theo đơn hàng, tránh hiển thị xen kẻ các đơn hàng với nhau
SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id ASC; -- Sắp xếp để các sản phẩm cùng đơn đi chung với nhau
-- 5. Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất, thông tin hiển thị gồm: mã
-- user, tên user, số lượng đơn hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_luong_don
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY so_luong_don DESC
LIMIT 7;
-- 6. Liệt kê 7 người dùng mua sản phẩm có tên: Samsung hoặc Apple trong tên sản
-- phẩm, thông tin hiển thị gồm: mã user, tên user, mã đơn hàng, tên sản phẩm
 SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.product_name LIKE '%Samsung%' OR p.product_name LIKE '%Apple%'
LIMIT 7;
-- 7. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin
-- hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền
SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY o.order_id;
-- 8. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin
-- hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền. Mỗi user chỉ chọn ra 1 đơn
-- hàng có giá tiền lớn nhất. 
SELECT user_id, user_name, order_id, MAX(tong_tien_don) AS gia_lon_nhat
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien_don
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS subquery
GROUP BY user_id;
-- 9. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin
-- hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền, số sản phẩm. Mỗi user chỉ
-- chọn ra 1 đơn hàng có giá tiền nhỏ nhất. 
SELECT user_id, user_name, order_id, MIN(tong_tien_don) AS gia_nho_nhat, so_sp
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien_don, COUNT(od.product_id) AS so_sp
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS subquery
GROUP BY user_id;
-- 10. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin
-- hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền, số sản phẩm. Mỗi user chỉ
-- chọn ra 1 đơn hàng có số sản phẩm là nhiều nhất.
SELECT user_id, user_name, order_id, tong_tien_don, MAX(so_sp) AS so_sp_nhieu_nhat
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien_don, COUNT(od.product_id) AS so_sp
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS subquery
GROUP BY user_id;