--------------------------------------------------------------------------------
/*				             Banking Queries           		  		          */
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
/* 1: Find all customers who have at least one loan and one deposit account. 
Include cust_id, account_number, and loan_number. Duplicated customer IDs are 
fine, so long as all customers are accounted for. Include a JOIN. */
--------------------------------------------------------------------------------

SELECT BORROWER.CUST_ID,
	ACCOUNT.ACCOUNT_NUMBER,
	BORROWER.LOAN_NUMBER
FROM BORROWER
JOIN LOAN USING (LOAN_NUMBER)
JOIN ACCOUNT USING (BRANCH_NAME);

--------------------------------------------------------------------------------
/* 2: Identify all customers who have a deposit account in the same city they 
live in. Include cust_id, customer_city, branch_city, branch_name, and 
account_number. Include a JOIN. */
--------------------------------------------------------------------------------

SELECT CUSTOMER.CUST_ID,
	CUSTOMER.CUSTOMER_CITY,
	BRANCH.BRANCH_CITY,
	BRANCH.BRANCH_NAME,
	ACCOUNT.ACCOUNT_NUMBER
FROM CUSTOMER
JOIN DEPOSITOR USING (CUST_ID)
JOIN ACCOUNT USING (ACCOUNT_NUMBER)
JOIN BRANCH USING (BRANCH_NAME)
WHERE CUSTOMER_CITY = BRANCH_CITY;

--------------------------------------------------------------------------------
/* 3: Identify customers who have at least one loan with the bank, but don't 
have deposit accounts. Include cust_id and customer_name. Use a subquery and
a SET operator. */
--------------------------------------------------------------------------------
   
SELECT CUST_ID,
	CUSTOMER_NAME
FROM CUSTOMER
WHERE CUST_ID =
		(SELECT CUST_ID
			FROM BORROWER
			WHERE BORROWER.CUST_ID = CUSTOMER.CUST_ID)
EXCEPT
SELECT CUST_ID,
	CUSTOMER_NAME
FROM CUSTOMER
JOIN DEPOSITOR USING (CUST_ID)
WHERE DEPOSITOR.CUST_ID = CUSTOMER.CUST_ID;
	
--------------------------------------------------------------------------------
/* 4: Identify all customers living on the same street and in the same city as
customer '12345'. Include customer '12345' in the results. Include cust_id and
customer_name. Include a subquery. */
--------------------------------------------------------------------------------

SELECT CUST_ID,
	CUSTOMER_NAME
FROM CUSTOMER
WHERE CUSTOMER_STREET =
		(SELECT CUSTOMER_STREET
			FROM CUSTOMER
			WHERE CUST_ID = '12345' )
	AND CUSTOMER_CITY =
		(SELECT CUSTOMER_CITY
			FROM CUSTOMER
			WHERE CUST_ID = '12345' );

--------------------------------------------------------------------------------
/* 5: Identify every branch that has at least one customer living in 'Harrison'
that has a deposit account with them. Do not duplicate branch names. Return
branch_names. Include a subquery and a JOIN. */
--------------------------------------------------------------------------------

SELECT DISTINCT BRANCH_NAME
FROM
	(SELECT *
		FROM DEPOSITOR
		JOIN CUSTOMER USING (CUST_ID)
		JOIN ACCOUNT USING (ACCOUNT_NUMBER))
WHERE CUSTOMER_CITY = 'Harrison';
    
--------------------------------------------------------------------------------
/* 6: Identify each customer (cust_id and customer_name) who has a deposit 
account at every branch located in Brooklyn. No hardcoding branch names. Include 
a subquery. */
--------------------------------------------------------------------------------

SELECT CUST_ID,
	CUSTOMER_NAME
FROM CUSTOMER
WHERE NOT EXISTS
		(SELECT BRANCH_NAME
			FROM BRANCH
			WHERE BRANCH_CITY = 'Brooklyn'
			EXCEPT
				(SELECT BRANCH_NAME
					FROM ACCOUNT
					JOIN DEPOSITOR USING (ACCOUNT_NUMBER)
					WHERE DEPOSITOR.CUST_ID = CUSTOMER.CUST_ID ));

--------------------------------------------------------------------------------
/* 7: Identify customers who have a loan at the 'Yonkahs Bankahs' branch and 
whose loan amount exceeds the average loan amount for that branch. Return
loan_number, customer_name, branch_name. Include a JOIN and a subquery. */
--------------------------------------------------------------------------------

SELECT LOAN.LOAN_NUMBER,
	CUSTOMER.CUSTOMER_NAME,
	BRANCH.BRANCH_NAME
FROM LOAN
JOIN BRANCH USING (BRANCH_NAME)
JOIN BORROWER USING (LOAN_NUMBER)
JOIN CUSTOMER USING (CUST_ID)
WHERE BRANCH.BRANCH_NAME = 'Yonkahs Bankahs'
	AND LOAN.AMOUNT::numeric >
		(SELECT AVG(AMOUNT::numeric)
			FROM LOAN);
  