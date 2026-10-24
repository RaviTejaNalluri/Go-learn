-- Schema:
-- CREATE TABLE "bottle-song" (
--         start_bottles INTEGER NOT NULL,
--         take_down     INTEGER NOT NULL,
--         result        TEXT
-- );
-- Task: update bottle-song table and set the result based on the
-- start_bottles and take_down.
WITH RECURSIVE
num_to_word(n, cap, low) AS (
    VALUES 
    (10, 'Ten', 'ten'), (9, 'Nine', 'nine'), (8, 'Eight', 'eight'), 
    (7, 'Seven', 'seven'), (6, 'Six', 'six'), (5, 'Five', 'five'), 
    (4, 'Four', 'four'), (3, 'Three', 'three'), (2, 'Two', 'two'), 
    (1, 'One', 'one'), (0, 'No', 'no')
),
verses(n, txt) AS (
    SELECT curr.n,
        curr.cap || ' green bottle' || CASE WHEN curr.n = 1 THEN '' ELSE 's' END || ' hanging on the wall,
' || curr.cap || ' green bottle' || CASE WHEN curr.n = 1 THEN '' ELSE 's' END || ' hanging on the wall,
And if one green bottle should accidentally fall,
There''ll be ' || next_num.low || ' green bottle' || CASE WHEN next_num.n = 1 THEN '' ELSE 's' END || ' hanging on the wall.'
    FROM num_to_word curr
    JOIN num_to_word next_num ON next_num.n = curr.n - 1
    WHERE curr.n > 0
),
song_builder(start_b, take_d, current_n, step, lyrics) AS (
    SELECT DISTINCT
        start_bottles, 
        take_down, 
        start_bottles, 
        1, 
        v.txt
    FROM "bottle-song"
    JOIN verses v ON v.n = "bottle-song".start_bottles
    WHERE take_down > 0
    
    UNION ALL
    
    SELECT 
        b.start_b, 
        b.take_d, 
        b.current_n - 1, 
        b.step + 1, 
        b.lyrics || '

' || v.txt
    FROM song_builder b
    JOIN verses v ON v.n = b.current_n - 1
    WHERE b.step < b.take_d
)
UPDATE "bottle-song"
SET result = (
    SELECT lyrics 
    FROM song_builder b
    WHERE b.start_b = "bottle-song".start_bottles 
      AND b.take_d = "bottle-song".take_down
      AND b.step = b.take_d
);