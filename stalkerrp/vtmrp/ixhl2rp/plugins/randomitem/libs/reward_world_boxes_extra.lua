ix.randomitems = ix.randomitems or {}
ix.randomitems.tables = ix.randomitems.tables or {}

-- Дополнительные группы для мировых ломаемых ящиков.

ix.randomitems.tables["loot_foodstash"] = {
	{2600, {"food_galets"}},
	{2400, {"food_can_beans_custom"}},
	{2200, {"food_condensed_milk"}},
	{2000, {"food_baton"}},
	{1800, {"drink_water_gurzhomi"}},
	{1600, {"drink_beer_flask"}},
	{1500, {"garlic"}},
	{1450, {"salt"}},
	{1400, {"flour"}},
	{1200, {"edible_mushroom"}},
	{900, {"mukhomor"}},
	{700, {"chocolate_alenka"}},
	{500, {"fire_fuel"}},
	{350, {"repairkit1"}},
}

ix.randomitems.tables["loot_medicalstash"] = {
	{2200, {"medic_bandagepack"}},
	{1800, {"medic_iodine"}},
	{1400, {"medic_vicasol"}},
	{1200, {"gasmask_filter"}},
	{1000, {"chemical_reagent"}},
	{900, {"broken_dosimeter"}},
	{750, {"drink_water_gurzhomi"}},
	{600, {"food_condensed_milk"}},
	{450, {"book"}},
	{300, {"document_case1"}},
}

ix.randomitems.tables["loot_techstash"] = {
	{2200, {"weapon_parts"}},
	{2000, {"armor_scraps"}},
	{1800, {"copper_wire"}},
	{1700, {"textolite"}},
	{1600, {"transistor"}},
	{1500, {"kondensatory"}},
	{1400, {"circuit_board"}},
	{1200, {"repairkit1"}},
	{1000, {"gun_maslo"}},
	{850, {"multiknife"}},
	{750, {"multitool"}},
	{650, {"controller"}},
	{550, {"data_disc"}},
	{480, {"small_engine"}},
	{360, {"weapon_clearkit"}},
	{240, {"armor_plate"}},
	{160, {"toolkit_rough"}},
	{120, {"toolkit_fine"}},
	{80, {"toolkit_calib"}},
	{60, {"chemical_reagent"}},

    -- Редкие детали/чертежи уникального оружейного крафта. Без самих оружий.
    {55, {"northern_long_pipe_barrel"}},
    {45, {"northern_homemade_lock"}},
    {24, {"mp18_old_receiver"}},
    {20, {"mp18_snail_mag"}},
    {16, {"volks_rough_receiver"}},
    {14, {"volks_bolt_group"}},
    {9, {"nock_reinforced_stock"}},
    {5, {"nock_seven_barrel_block"}},
    {5, {"note_blueprint_northern_nail"}},
    {4, {"note_blueprint_mp18_okopnik"}},
    {3, {"note_blueprint_volks_last_line"}},
    {2, {"note_blueprint_nock_gromoboy"}},
}

-- Отдельный специализированный техно-оружейный тайник.
ix.randomitems.tables["loot_weaponcraftstash"] = {
    {2600, {"weapon_parts"}},
    {1400, {"weapon_clearkit"}},
    {1200, {"gun_maslo"}},
    {900, {"multitool"}},
    {700, {"military_battery"}},
    {480, {"northern_long_pipe_barrel"}},
    {400, {"northern_homemade_lock"}},
    {240, {"mp18_old_receiver"}},
    {200, {"mp18_snail_mag"}},
    {150, {"volks_rough_receiver"}},
    {130, {"volks_bolt_group"}},
    {80, {"nock_reinforced_stock"}},
    {45, {"nock_seven_barrel_block"}},
    {35, {"note_blueprint_northern_nail"}},
    {24, {"note_blueprint_mp18_okopnik"}},
    {16, {"note_blueprint_volks_last_line"}},
    {9, {"note_blueprint_nock_gromoboy"}},
}
