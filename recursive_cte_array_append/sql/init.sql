CREATE OR REPLACE TEMPORARY TABLE departments (
  department_id         NUMBER,
  department_name       TEXT,
  parent_department_id  NUMBER
);

INSERT INTO departments
VALUES 
  (1, 'Organization', NULL),
  (2, 'Human Resources', 1),
  (3, 'Sales', 1),
  (4, 'Information Technology',1),
  (5, 'Finance/Accounting', 1),
  (6, 'Research & Development', 1),
  (7, 'Payroll', 2),
  (8, 'Benefits', 2),
  (9, 'Recruiting', 2),
  (10, 'North America', 3),
  (11, 'EMEA', 3),
  (12, 'LATAM', 3),
  (13, 'APAC', 3),
  (14, 'Help Desk/Support', 4),
  (15, 'System Administration', 4),
  (16, 'Financial Planning', 5),
  (17, 'Accounting', 5),
  (18, 'Analytics', 5),
  (19, 'Engineering', 6),
  (20, 'Platform', 6),
  (21, 'Project Management', 6),
  (22, 'United States', 10),
  (23, 'Canada', 10),
  (24, 'Mexico', 10);
