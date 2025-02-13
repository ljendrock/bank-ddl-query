--------------------------------------------------------------------------------
/*				                 Banking DDL           		  		          */
--------------------------------------------------------------------------------

/* Create a table of branches. All branches have assets, and asset amounts cannot be negative. */
CREATE TABLE branch (
	branch_name varchar(40),
	branch_city varchar(40) CONSTRAINT city_check 
	CHECK (branch_city IN ('Brooklyn', 'Bronx', 'Manhattan', 'Yonkers')),
	assets money NOT NULL,
	CONSTRAINT branch_key PRIMARY KEY (branch_name),
	CONSTRAINT assets_check CHECK (assets >= '0')
);

/* Create a table of customers. Names and street addresses are required, but city is optional. */
CREATE TABLE customer (
	cust_ID varchar(40) CONSTRAINT cust_key PRIMARY KEY,
	customer_name varchar(40) NOT NULL,
	customer_street varchar(40) NOT NULL,
	customer_city varchar(40)
);

/* Create a table of loans held. Loans must have an amount, and default is $0.00. Loan amounts cannot be negative. Any changes to the branch names or branch closures should be reflected here. */
CREATE TABLE loan (
	loan_number varchar(40) CONSTRAINT loan_key PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch (branch_name) 
	ON UPDATE CASCADE ON DELETE CASCADE,
	amount money NOT NULL CONSTRAINT default_amount DEFAULT '0.00' 
	CONSTRAINT amount_check CHECK (amount >= '0.00')	
);

/* Create a table of customers with loans. Changes to customers or loans should be reflected here. */
CREATE TABLE borrower (
	cust_id varchar(40) REFERENCES customer (cust_id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	loan_number varchar(40) REFERENCES loan (loan_number)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT borrower_key PRIMARY KEY (cust_id, loan_number)
);

/* Create a table of bank accounts. Accounts must have an amount, and default is $0.00. Any changes to the branch should be reflected here. */
CREATE TABLE account (
	account_number varchar(40) CONSTRAINT account_key PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch (branch_name)
	ON UPDATE CASCADE ON DELETE CASCADE,
	balance money NOT NULL CONSTRAINT default_balance DEFAULT '0.00'
);

/* Create a table of customers with bank accounts. Changes to customers and accounts should be reflected here. */
CREATE TABLE depositor (
	cust_id varchar(40) REFERENCES customer (cust_id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	account_number varchar(40) REFERENCES account (account_number)
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT depositor_key PRIMARY KEY (cust_id, account_number)
);