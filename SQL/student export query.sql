SELECT
  s.student_number,
  s.last_name,
  s.first_name,
  s.grade_level true_grade,
  sch.abbreviation school,
  s.home_room,
  ps_customfields.getcf('students', s.id, 'LA_SPED') la_sped,
  se.iep_speech_only,
  se.laa1,
  se.ELL_Newcomer,
	CASE
	WHEN se.benchmark_grade_level_ela IS NOT NULL
	THEN CAST(se.benchmark_grade_level_ela AS VARCHAR2(10))
	ELSE CAST(s.grade_level AS VARCHAR2(10))
	END ela_benchmark_grade,
	CASE
	WHEN se.benchmark_grade_level_math IS NOT NULL
	THEN CAST(se.benchmark_grade_level_math AS VARCHAR2(10))
	ELSE CAST(s.grade_level AS VARCHAR2(10))
	END math_benchmark_grade,
	CASE
	WHEN se.benchmark_grade_level_sci IS NOT NULL
	THEN CAST(se.benchmark_grade_level_sci AS VARCHAR2(10))
	ELSE CAST(s.grade_level AS VARCHAR2(10))
	END sci_benchmark_grade,
	CASE
	WHEN se.benchmark_grade_level_ss IS NOT NULL
	THEN CAST(se.benchmark_grade_level_ss AS VARCHAR2(10))
	ELSE CAST(s.grade_level AS VARCHAR2(10))
	END soc_benchmark_grade,
  s.entrydate entry_date
FROM students s
LEFT JOIN u_def_ext_students se ON se.studentsdcid = s.dcid
JOIN schools sch ON s.schoolid = sch.school_number
WHERE s.grade_level > -3
AND sch.school_number IN (1,2,3,6,369701)
AND s.enroll_status = 0