SELECT  target, guess,
        fn_match_text(fn_match(fn_word_to_bigint(guess), fn_word_to_bigint(target)))
FROM    (
        VALUES
        ('AAABB', 'BBAAA'),
        ('GHOTI', 'GHOTI'),
        ('REBUS', 'RUBUS'),
        ('BANAL', 'ANNAL'),
        ('BANAL', 'UNION'),
        ('BANAL', 'ALLOY'),
        ('BANAL', 'BANAL'),
        ('ABBEY', 'ABBEY'),
        ('ABBEY', 'ABYSS'),
        ('ABBEY', 'KEBAB'),
        ('ABBEY', 'BABES'),
        ('ABBEY', 'OPENS'),
        ('DUVET', 'ADDED')
        ) AS q (target, guess)
EXCEPT
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
