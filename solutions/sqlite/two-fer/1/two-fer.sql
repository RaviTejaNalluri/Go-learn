-- Schema: CREATE TABLE "twofer" ("input" TEXT, "response" TEXT);
-- Task: update the twofer table and set the response based on the input.
UPDATE twofer SET response = case
    WHEN input is NULL OR input='' THEN 'One for you, one for me.'
    ELSE concat('One for ', input, ', one for me.')
END;