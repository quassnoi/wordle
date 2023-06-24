WITH    guesses (guess, colors) AS
        (
        VALUES
        ('SERAI', 'BBBYB')
        ),
        valid AS MATERIALIZED
        (
        SELECT  fn_word_to_bigint(word) AS word
        FROM    wordle
        WHERE   (
                SELECT  BOOL_AND(fn_match(fn_word_to_bigint(guess), fn_word_to_bigint(word)) = fn_match_color(colors))
                FROM    guesses
                )
        )
SELECT  fn_bigint_to_word(guess), fn_match_text(colors), matches
FROM    (
        SELECT  guess.word AS guess, colors, matches
        FROM    valid guess
        CROSS JOIN LATERAL
                (
                SELECT  fn_match(guess.word, target.word) AS colors, COUNT(*) matches
                FROM    valid target
                GROUP BY
                        colors
                ORDER BY
                        matches DESC
                LIMIT 1
                ) target
        ) q
ORDER BY
        matches
LIMIT 1