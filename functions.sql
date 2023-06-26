CREATE OR REPLACE FUNCTION fn_word_to_bigint(_word TEXT)
RETURNS BIGINT
IMMUTABLE PARALLEL SAFE
AS
$$

SELECT  ASCII(SUBSTRING(_word FROM 1 FOR 1))::BIGINT +
        (ASCII(SUBSTRING(_word FROM 2 FOR 1))::BIGINT << 8) +
        (ASCII(SUBSTRING(_word FROM 3 FOR 1))::BIGINT << 16) +
        (ASCII(SUBSTRING(_word FROM 4 FOR 1))::BIGINT << 24) +
        (ASCII(SUBSTRING(_word FROM 5 FOR 1))::BIGINT << 32)

$$
LANGUAGE 'sql';


CREATE OR REPLACE FUNCTION fn_bigint_to_word(_digits BIGINT)
RETURNS TEXT
IMMUTABLE PARALLEL SAFE
AS
$$

SELECT  CHR((_digits & 255)::INT) ||
        CHR(((_digits >> 8) & 255)::INT) ||
        CHR(((_digits >> 16) & 255)::INT) ||
        CHR(((_digits >> 24) & 255)::INT) ||
        CHR(((_digits >> 32) & 255)::INT)

$$
LANGUAGE 'sql';


CREATE OR REPLACE FUNCTION fn_match(_guess BIGINT, _target BIGINT, _position INT)
RETURNS INT
IMMUTABLE PARALLEL SAFE
COST 10000
AS

$$

SELECT  CASE
        WHEN ((_guess >> (8 * _position)) & 255) = ((_target >> (8 * _position)) & 255) THEN 2
        ELSE    (
                (((_guess >> (8 * _position)) & 255) = ((_target >> 0) & 255)
                        AND ((_guess >> 0) & 255) <> ((_target >> 0) & 255)
                        )::INT +
                (((_guess >> (8 * _position)) & 255) = ((_target >> 8) & 255)
                        AND ((_guess >> 8) & 255) <> ((_target >> 8) & 255)
                        )::INT +
                (((_guess >> (8 * _position)) & 255) = ((_target >> 16) & 255)
                        AND ((_guess >> 16) & 255) <> ((_target >> 16) & 255)
                        )::INT +
                (((_guess >> (8 * _position)) & 255) = ((_target >> 24) & 255)
                        AND ((_guess >> 24) & 255) <> ((_target >> 24) & 255)
                        )::INT +
                (((_guess >> (8 * _position)) & 255) = ((_target >> 32) & 255)
                        AND ((_guess >> 32) & 255) <> ((_target >> 32) & 255)
                        )::INT
                >=
                (((_guess >> (8 * _position)) & 255) = ((_guess >> 0) & 255)
                        AND ((_guess >> 0) & 255) <> ((_target >> 0) & 255)
                        )::INT +
                (_position >= 1
                        AND ((_guess >> (8 * _position)) & 255) = ((_guess >> 8) & 255)
                        AND ((_guess >> 8) & 255) <> ((_target >> 8) & 255)
                        )::INT +
                (_position >= 2
                        AND ((_guess >> (8 * _position)) & 255) = ((_guess >> 16) & 255)
                        AND ((_guess >> 16) & 255) <> ((_target >> 16) & 255)
                        )::INT +
                (_position >= 3
                        AND ((_guess >> (8 * _position)) & 255) = ((_guess >> 24) & 255)
                        AND ((_guess >> 24) & 255) <> ((_target >> 24) & 255)
                        )::INT +
                (_position >= 4
                        AND ((_guess >> (8 * _position)) & 255) = ((_guess >> 32) & 255)
                        AND ((_guess >> 32) & 255) <> ((_target >> 32) & 255)
                        )::INT
                )::INT
        END
$$
LANGUAGE 'sql';

CREATE OR REPLACE FUNCTION fn_match(_guess BIGINT, _target BIGINT)
RETURNS INT
IMMUTABLE PARALLEL SAFE
COST 50000
AS

$$

SELECT  fn_match(_guess, _target, 0) +
        fn_match(_guess, _target, 1) * 3 +
        fn_match(_guess, _target, 2) * 9 +
        fn_match(_guess, _target, 3) * 27 +
        fn_match(_guess, _target, 4) * 81

$$
LANGUAGE 'sql';


CREATE OR REPLACE FUNCTION fn_match_text(_colors INT)
RETURNS TEXT
IMMUTABLE PARALLEL SAFE
AS
$$

SELECT  CASE _colors % 3 WHEN 0 THEN 'B' WHEN 1 THEN 'Y' ELSE 'G' END ||
        CASE ((_colors / 3) % 3) WHEN 0 THEN 'B' WHEN 1 THEN 'Y' ELSE 'G' END ||
        CASE ((_colors / 9) % 3) WHEN 0 THEN 'B' WHEN 1 THEN 'Y' ELSE 'G' END ||
        CASE ((_colors / 27) % 3) WHEN 0 THEN 'B' WHEN 1 THEN 'Y' ELSE 'G' END ||
        CASE ((_colors / 81) % 3) WHEN 0 THEN 'B' WHEN 1 THEN 'Y' ELSE 'G' END

$$
LANGUAGE 'sql';

CREATE OR REPLACE FUNCTION fn_match_color(_colors TEXT)
RETURNS INTEGER
IMMUTABLE PARALLEL SAFE
AS
$$

SELECT  CASE SUBSTRING(_colors FROM 1 FOR 1) WHEN 'G' THEN 2 WHEN 'Y' THEN 1 ELSE 0 END +
        CASE SUBSTRING(_colors FROM 2 FOR 1) WHEN 'G' THEN 2 WHEN 'Y' THEN 1 ELSE 0 END * 3 +
        CASE SUBSTRING(_colors FROM 3 FOR 1) WHEN 'G' THEN 2 WHEN 'Y' THEN 1 ELSE 0 END * 9 +
        CASE SUBSTRING(_colors FROM 4 FOR 1) WHEN 'G' THEN 2 WHEN 'Y' THEN 1 ELSE 0 END * 27 +
        CASE SUBSTRING(_colors FROM 5 FOR 1) WHEN 'G' THEN 2 WHEN 'Y' THEN 1 ELSE 0 END * 81

$$
LANGUAGE 'sql';

