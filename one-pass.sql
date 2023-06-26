SELECT  fn_match_text(fn_match(
                fn_word_to_bigint('ALOHA'),
                fn_word_to_bigint(target.word)
                )) AS colors,
        COUNT(*) matches
FROM    wordle AS target
GROUP BY
        colors
ORDER BY
        matches DESC
