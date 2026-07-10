extends CharacterBase
class_name Staff

@export var role: ROLE
@export var department: DEPARTMENT

enum ROLE {
	Doctor,
	Nurse,
	Driver,
	Janitor,						# 清洁工
}

enum  DEPARTMENT {
	Emergency,					# 急诊科
	Radiology,					# 放射科
	MedicalLaboratories,			# 检验科
	IntensiveCareUnit,			# 重症监护
	GeneralSurgery,				# 普外
	InternalMedicine,			# 内科
	Orthopaedy,					# 骨科
	Cardiology,					# 心脏
	Neurology,					# 神经
	InfectiousDiseases,			# 感染科
	Traumatology,				# 创伤科
	AdministrativeDepartment,	# 行政科
	Pathology,					# 病理科
	DermatologyAndVenereology,	# 皮肤科
	ENT,							# 五官科
	GynecologyAndObstetrics,		# 妇产科
	Hematology,					# 血液科
	Oncology,					# 肿瘤科
	Ophthalmology,				# 眼科
	OralAndMaxillofacial,		# 口腔科
	PlasticSurgery,				# 整形外科
	Psychiatry,					# 心理科
	UrologyAndNephrology			# 泌尿科
}
