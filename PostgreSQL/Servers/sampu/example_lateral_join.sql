CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(50)
);

DROP TABLE employees;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary NUMERIC(10, 2),
    department_id INT REFERENCES departments(id)
);

INSERT INTO departments (department_name) VALUES
('Human Resources'),
('Engineering'),
('Sales');

INSERT INTO employees (name, salary, department_id) VALUES
('Alice', 60000, 1),
('Bob', 75000, 2),
('Charlie', 50000, 2),
('Diana', 65000, 1),
('Ethan', 70000, 3);


