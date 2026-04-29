
-- ЛАБОРАТОРНА РОБОТА №3: ПРОЦЕДУРИ (PL/pgSQL)
-- Варіант 4: Екскурсії (Нарахування оплати)


-- 1. Процедура для нарахування оплати конкретному замовнику за вказаний місяць
-- Формула враховує кількість туристів, витрати пального та тривалість екскурсії.
CREATE OR REPLACE PROCEDURE calculate_payment_for_customer(
    p_customer_id INT,
    p_month INT,
    p_year INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_payment NUMERIC(10, 2) := 0;
    v_excursion RECORD;
BEGIN
    FOR v_excursion IN 
        SELECT e.distance_km, e.duration_hours, e.tourists_count, b.gas_per_km
        FROM excursions e
        JOIN buses b ON e.bus_id = b.bus_id
        WHERE e.customer_id = p_customer_id
          AND EXTRACT(MONTH FROM e.excursion_date) = p_month
          AND EXTRACT(YEAR FROM e.excursion_date) = p_year
    LOOP
        v_total_payment := v_total_payment + 
            (v_excursion.distance_km * v_excursion.gas_per_km * 55) + 
            (v_excursion.duration_hours * 300) + 
            (v_excursion.tourists_count * 100);
    END LOOP;

    IF v_total_payment > 0 THEN
        UPDATE customers
        SET debt_amount = debt_amount + v_total_payment
        WHERE customer_id = p_customer_id;
    END IF;
END;
$$;

-- 2. Головна процедура, яка викликає першу для всіх замовників автоматично
CREATE OR REPLACE PROCEDURE calculate_payment_for_all(
    p_month INT,
    p_year INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_record RECORD;
BEGIN
    FOR v_customer_record IN SELECT customer_id FROM customers
    LOOP
        CALL calculate_payment_for_customer(v_customer_record.customer_id, p_month, p_year);
    END LOOP;
END;
$$;


-- ТЕСТУВАННЯ ПРОЦЕДУР


-- Дивимося борги ДО нарахування
SELECT customer_id, name, debt_amount FROM customers;

-- Викликаємо головну процедуру за березень (3) 2026 року
CALL calculate_payment_for_all(3, 2026);

-- Дивимося борги ПІСЛЯ нарахування (суми мають збільшитись)
SELECT customer_id, name, debt_amount FROM customers;