extends Resource
class_name Disease

@export var name: String
@export var description: String
@export var category: DISEASE_CATEGORY


enum DISEASE_CATEGORY {
	Neurological,				# 神经系统急症
	Cardiovascular,				# 心血管系统急症
	Respiratory,					# 呼吸系统急症
	AcuteAbdominal,				# 消化泌尿急腹症
	MetabolicPoisoning,			# 代谢中毒
	Obstetric,					# 产科急症
	MultiOrganEndStage,			# 多器官终末期
	BluntForce,					# 钝性暴力伤
	SharpPenetrating	,			# 锐器贯穿伤
	BurnBlast,					# 烧伤爆震伤
	SpecialTraumaticComplications	# 特殊创伤并发症
}
