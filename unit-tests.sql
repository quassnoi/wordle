SELECT  target, guess,
        CASE
        WHEN fn_match_text(fn_match(
                fn_word_to_bigint(guess),
                fn_word_to_bigint(target))
                ) = colors
        THEN
                '✅'
        ELSE    '❌'
        END
FROM    (
        VALUES
        ('AAABB', 'BBAAA', 'YYGYY'),
        ('GHOTI', 'GHOTI', 'GGGGG'),
        ('REBUS', 'RUBUS', 'GBGGG'),
        ('BANAL', 'ANNAL', 'YBGGG'),
        ('BANAL', 'UNION', 'BYBBB'),
        ('BANAL', 'ALLOY', 'YYBBB'),
        ('BANAL', 'BANAL', 'GGGGG'),
        ('ABBEY', 'ABBEY', 'GGGGG'),
        ('ABBEY', 'ABYSS', 'GGYBB'),
        ('ABBEY', 'KEBAB', 'BYGYY'),
        ('ABBEY', 'BABES', 'YYGGB'),
        ('ABBEY', 'OPENS', 'BBYBB'),
        ('DUVET', 'ADDED', 'BYBGB')
        ) AS q (target, guess, colors)


