WITH    encoded AS
        (
        SELECT  fn_word_to_bigint(word) AS word
        FROM    wordle
        )
SELECT  fn_bigint_to_word(guess), fn_match_text(colors), matches
FROM    (
        SELECT  guess.word AS guess, colors, matches
        FROM    encoded guess
        CROSS JOIN LATERAL
                (
                SELECT  fn_match(guess.word, target.word) AS colors, COUNT(*) matches
                FROM    encoded target
                GROUP BY
                        colors
                ORDER BY
                        matches DESC
                LIMIT 1
                ) target
        ) q
ORDER BY
        matches;
