WITH RECURSIVE department_hierarchy (
    department_id,
    department_name,
    parent_department_id,
    department_id_path,
    department_name_path,
    depth
)
  AS (
    SELECT
      department_id,
      department_name,
      parent_department_id,
      '/' || department_id::TEXT AS department_id_path,
      '/' || department_name::TEXT AS department_name_path,
      1::NUMBER AS depth
    FROM departments
    WHERE parent_department_id IS NULL
    UNION ALL
    SELECT
      d.department_id,
      d.department_name,
      d.parent_department_id,
      dh.department_id_path || '/' || d.department_id::TEXT AS department_id_path,
      dh.department_name_path || '/' || d.department_name::TEXT AS department_name_path,
      dh.depth + 1 AS depth
    FROM departments d
    JOIN department_hierarchy dh ON d.parent_department_id = dh.department_id
  ),
parsed_path AS (
  SELECT
    department_id,
    department_name,
    parent_department_id,
    department_id_path,
    department_name_path,
    depth,
    REGEXP_SUBSTR(department_id_path, '[^/]+', 1, 1) AS department_level_1_id,
    REGEXP_SUBSTR(department_id_path, '[^/]+', 1, 2) AS department_level_2_id,
    REGEXP_SUBSTR(department_id_path, '[^/]+', 1, 3) AS department_level_3_id,
    REGEXP_SUBSTR(department_id_path, '[^/]+', 1, 4) AS department_level_4_id,
    REGEXP_SUBSTR(department_name_path, '[^/]+', 1, 1) AS department_level_1_name,
    REGEXP_SUBSTR(department_name_path, '[^/]+', 1, 2) AS department_level_2_name,
    REGEXP_SUBSTR(department_name_path, '[^/]+', 1, 3) AS department_level_3_name,
    REGEXP_SUBSTR(department_name_path, '[^/]+', 1, 4) AS department_level_4_name
  FROM department_hierarchy
)
SELECT
  department_id,
  department_name,
  depth,
  department_id_path,
  department_name_path,
  department_level_1_name,
  department_level_2_name,
  department_level_3_name,
  department_level_4_name
FROM parsed_path
WHERE department_name_path ILIKE '%finance/accounting%';