
-- Table book
+---------+-----------------------+------------------+--------+--------+
| book_id | title                 | author           | price  | amount |
+---------+-----------------------+------------------+--------+--------+
| 1       | Мастер и Маргарита    | Булгаков М.А.    | 670.99 | 3      |
| 2       | Белая гвардия         | Булгаков М.А.    | 540.50 | 5      |
| 3       | Идиот                 | Достоевский Ф.М. | 460.00 | 10     |
| 4       | Братья Карамазовы     | Достоевский Ф.М. | 799.01 | 3      |
| 5       | Игрок                 | Достоевский Ф.М. | 480.50 | 10     |
| 6       | Стихотворения и поэмы | Есенин С.А.      | 650.00 | 15     |
+---------+-----------------------+------------------+--------+--------+

-- Вывести информацию (автора, название и цену) о книгах, цены которых меньше или равны средней цене книг на складе. 
-- Отсортировать по убыванию цены. Среднее вычислить как среднее по цене книги.
select 
    author, 
    title, 
    price
from book
where price <= (
    select avg(price)
    from book
    )
order by 3 desc;

-- Вывести информацию (автора, название и цену) о тех книгах, 
-- цены которых превышают минимальную цену книги на складе не более чем на 150 рублей. Отсортировать по возрастанию цены.
select
    author,
    title,
    price
from book
where price <= (
    select min(price)
    from book) + 150
order by price;

-- Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.
select
    author,
    title,
    amount
from book
where amount in (
    select count(amount)
    from book
    group by amount
    having count(amount) = 1);

-- Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора.
select
    author,
    title,
    price
from book
where price < any (
    select min(price)
    from book
    group by author);

-- Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество экземпляров каждой книги, 
-- равное значению самого большего количества экземпляров одной книги на складе. 
-- Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. 
-- В результат не включать книги, которые заказывать не нужно.
select
    title,
    author,
    amount,
    (select max(amount)
     from book) - amount as book_order
from book
where amount <> (
    select max(amount)
    from book);


-- Table trip
+---------+---------------+-----------------+----------+------------+------------+
| trip_id | name          | city            | per_diem | date_first | date_last  |
+---------+---------------+-----------------+----------+------------+------------+
| 1       | Баранов П.Е.  | Москва          | 700.00   | 2020-01-12 | 2020-01-17 |
| 2       | Абрамова К.А. | Владивосток     | 450.00   | 2020-01-14 | 2020-01-27 |
| 3       | Семенов И.В.  | Москва          | 700.00   | 2020-01-23 | 2020-01-31 |
| 4       | Ильиных Г.Р.  | Владивосток     | 450.00   | 2020-01-12 | 2020-02-02 |
| 5       | Колесов С.П.  | Москва          | 700.00   | 2020-02-01 | 2020-02-06 |
| 6       | Баранов П.Е.  | Москва          | 700.00   | 2020-02-14 | 2020-02-22 |
                          ...
| 19      | Абрамова К.А. | Владивосток     | 450.00   | 2020-07-02 | 2020-07-13 |
| 20      | Баранов П.Е.  | Воронеж         | 450.00   | 2020-07-19 | 2020-07-25 |
+---------+---------------+-----------------+----------+------------+------------+

-- Вывести информацию о самой короткой командировке сотрудника.
select
    name,
    city,
    date_first,
    date_last
from trip
where datediff(date_last, date_first) = 
            (select 
                min(datediff(date_last, date_first))
             from trip
             order by 1
             );