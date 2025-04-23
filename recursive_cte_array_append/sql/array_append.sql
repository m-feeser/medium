WITH RECURSIVE department_hierarchy (
    department_id,
    department_name,
    parent_department_id,
    department_id_path_array,
    department_name_path_array,
    depth
)
  AS (
    SELECT
      department_id,
      department_name,
      parent_department_id,
      COALESCE(department_id::TEXT, '')::ARRAY AS department_id_path_array,
      COALESCE(department_name, '')::ARRAY AS department_name_path_array,
      1::NUMBER AS depth
    FROM departments
    WHERE parent_department_id IS NULL
    UNION ALL
    SELECT
      d.department_id,
      d.department_name,
      d.parent_department_id,
      ARRAY_APPEND(dh.department_id_path_array, COALESCE(d.department_id::TEXT,'')) AS department_id_path_array,
      ARRAY_APPEND(dh.department_name_path_array, COALESCE(d.department_name::TEXT,'')) AS department_name_path_array,
      dh.depth + 1 AS depth
    FROM departments d
    JOIN department_hierarchy dh ON d.parent_department_id = dh.department_id
  ),
parsed_path AS (
  SELECT
    department_id,
    department_name,
    parent_department_id,
    department_id_path_array,
    department_name_path_array,
    depth,
    NULLIF(department_id_path_array[0], '')::NUMBER AS department_level_1_id,
    NULLIF(department_id_path_array[1], '')::NUMBER AS department_level_2_id,
    NULLIF(department_id_path_array[2], '')::NUMBER AS department_level_3_id,
    NULLIF(department_id_path_array[3], '')::NUMBER AS department_level_4_id,
    NULLIF(department_name_path_array[0], '')::TEXT AS department_level_1_name,
    NULLIF(department_name_path_array[1], '')::TEXT AS department_level_2_name,
    NULLIF(department_name_path_array[2], '')::TEXT AS department_level_3_name,
    NULLIF(department_name_path_array[3], '')::TEXT AS department_level_4_name
  FROM department_hierarchy
)
SELECT
  department_id,
  department_name,
  depth,
  department_id_path_array,
  department_name_path_array,
  department_level_1_name,
  department_level_2_name,
  department_level_3_name,
  department_level_4_name
FROM parsed_path
WHERE ARRAY_CONTAINS(
  'Finance/Accounting'::VARIANT,
  department_name_path_array::VARIANT
);