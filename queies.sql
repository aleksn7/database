-- Аккаунты 

-- создаем аккаунт
INSERT INTO accounts(login, password)
VALUES ($1, $2)
RETURNING id, login, password

-- проверяем есть ли такой аккаунт
SELECT id, login, password
FROM accounts
WHERE login = $1 AND password = $2

-- Выводим все аккаунты у которых нет виртуальных машин 
SELECT a.id, a.login, a.password
FROM accounts as a LEFT JOIN virtual_machines as v ON (a.id = v.account_id)
WHERE v.id IS NULL

-- Выводим всех пользователей у которых логины:
-- aaaaaaaaaaaa
-- aaaaaaaaaaab
-- аaaaaaaaaaba
-- aaaaaaaaaabb
-- aaaaaaaaabaa
-- ...
-- bbbbbbbbbbb
SELECT id, login, password
FROM accounts
WHERE login SIMILAR TO '[ab]{12}';


-- Балансы

-- Вытаскиваем балансы аккаунтов
SELECT account_id, currency, amount, address, privkey
FROM balances
WHERE account_id = $1


-- Обновление балансы аккаунтов 

-- ######## Start transaction #########
SELECT account_id, currency, amount, address, privkey
FROM balances
WHERE account_id = $1 AND currency = $2
FOR UPDATE -- Для избежание конкурентного обновления одного и того же баланса

-- if errors.Is(err, sql.NoRows)
    -- Если такого баланса нет, вставляем его
    INSERT INTO balances(account_id, currency, amount, address, privkey)
    VALUES($1, $2, $3, $4, $5)
    -- ######## Commit transaction #########
-- endif

-- Если такой баланс есть, обновляем его. 
UPDATE balances
SET amount = $1
WHERE account_id = $2 AND currency = $3
-- ######## Commit transaction #########


-- Куки

-- Создаем куку для пользователя
INSERT INTO cookies(account_id, cookie)
VALUES ($1, $2)

-- Получаем пользователя по куке
SELECT a.id, a.login, a.password
FROM accounts as a 
INNER JOIN cookies as c ON(c.account_id = a.id)
WHERE c.cookie = $1

-- Удаляем все куки пользователя по логину
DELETE FROM cookies as c USING accounts as a
WHERE c.account_id = a.id AND a.login = $1;


-- Виртуальные машины

-- Достаем виртуальные машины пользователя
SELECT id, account_id, ipv4, "user", password, expiration, city, country
FROM virtual_machines
WHERE account_id = $1

-- Создаем виртуальную машину для пользователя
INSERT INTO virtual_machines(account_id, ipv4, "user", password, expiration, city, country)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING id, account_id, ipv4, "user", password, expiration, city, country


