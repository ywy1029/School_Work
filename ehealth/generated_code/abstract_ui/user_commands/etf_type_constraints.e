class
 	 ETF_TYPE_CONSTRAINTS

feature -- type queries 

	is_kind(v: INTEGER_64): BOOLEAN 
		require
			comment("v: KIND = {pill, liquid}")
		do
			 Result := 
				(( v ~ pill ) or else ( v ~ liquid ))
		ensure
			 Result = 
				(( v ~ pill ) or else ( v ~ liquid ))
		end

	is_medication(v: TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE]): BOOLEAN 
		require
			comment("v: MEDICATION = TUPLE[name: NAME = STRING; kind: KIND = {pill, liquid}; low: VALUE; hi: VALUE]")
		do
			 Result := 
				is_kind(v.kind)
		ensure
			 Result = 
				is_kind(v.kind)
		end

	is_physician_type(v: INTEGER_64): BOOLEAN 
		require
			comment("v: PHYSICIAN_TYPE = {generalist, specialist}")
		do
			 Result := 
				(( v ~ generalist ) or else ( v ~ specialist ))
		ensure
			 Result = 
				(( v ~ generalist ) or else ( v ~ specialist ))
		end

feature -- constants for enumerated items 
	pill: INTEGER =1
	liquid: INTEGER =2
	generalist: INTEGER =3
	specialist: INTEGER =4

feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
			Result.extend(1, "pill")
			Result.extend(2, "liquid")
			Result.extend(3, "generalist")
			Result.extend(4, "specialist")
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_64]
		do
			create Result.make (10)
			Result.extend("pill", 1)
			Result.extend("liquid", 2)
			Result.extend("generalist", 3)
			Result.extend("specialist", 4)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			add_physician_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			add_patient_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			add_medication_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			add_interaction_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			new_prescription_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			add_medicine_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			remove_medicine_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			prescriptions_q_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			dpr_q_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create add_physician_param_types.make (10)
			add_physician_param_types.compare_objects
			add_physician_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MD", create {ETF_INT_PARAM}), "id")
			add_physician_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("NAME", create {ETF_STR_PARAM}), "name")
			add_physician_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("PHYSICIAN_TYPE", create {ETF_ENUM_PARAM}.make(<<"generalist", "specialist">>)), "kind")
			Result.extend (add_physician_param_types, "add_physician")
			create add_patient_param_types.make (10)
			add_patient_param_types.compare_objects
			add_patient_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_PT", create {ETF_INT_PARAM}), "id")
			add_patient_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("NAME", create {ETF_STR_PARAM}), "name")
			Result.extend (add_patient_param_types, "add_patient")
			create add_medication_param_types.make (10)
			add_medication_param_types.compare_objects
			add_medication_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}), "id")
			add_medication_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MEDICATION", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("name", create {ETF_NAMED_PARAM_TYPE}.make("NAME", create {ETF_STR_PARAM})), create {ETF_PARAM_DECL}.make("kind", create {ETF_NAMED_PARAM_TYPE}.make("KIND", create {ETF_ENUM_PARAM}.make(<<"pill", "liquid">>))), create {ETF_PARAM_DECL}.make("low", create {ETF_VALUE_PARAM}), create {ETF_PARAM_DECL}.make("hi", create {ETF_VALUE_PARAM})>>)), "medicine")
			Result.extend (add_medication_param_types, "add_medication")
			create add_interaction_param_types.make (10)
			add_interaction_param_types.compare_objects
			add_interaction_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}), "id1")
			add_interaction_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}), "id2")
			Result.extend (add_interaction_param_types, "add_interaction")
			create new_prescription_param_types.make (10)
			new_prescription_param_types.compare_objects
			new_prescription_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_RX", create {ETF_INT_PARAM}), "id")
			new_prescription_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MD", create {ETF_INT_PARAM}), "doctor")
			new_prescription_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_PT", create {ETF_INT_PARAM}), "patient")
			Result.extend (new_prescription_param_types, "new_prescription")
			create add_medicine_param_types.make (10)
			add_medicine_param_types.compare_objects
			add_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_RX", create {ETF_INT_PARAM}), "id")
			add_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}), "medicine")
			add_medicine_param_types.extend (create {ETF_VALUE_PARAM}, "dose")
			Result.extend (add_medicine_param_types, "add_medicine")
			create remove_medicine_param_types.make (10)
			remove_medicine_param_types.compare_objects
			remove_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_RX", create {ETF_INT_PARAM}), "id")
			remove_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}), "medicine")
			Result.extend (remove_medicine_param_types, "remove_medicine")
			create prescriptions_q_param_types.make (10)
			prescriptions_q_param_types.compare_objects
			prescriptions_q_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}), "medication_id")
			Result.extend (prescriptions_q_param_types, "prescriptions_q")
			create dpr_q_param_types.make (10)
			dpr_q_param_types.compare_objects
			Result.extend (dpr_q_param_types, "dpr_q")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			add_physician_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			add_patient_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			add_medication_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			add_interaction_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			new_prescription_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			add_medicine_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			remove_medicine_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			prescriptions_q_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			dpr_q_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create add_physician_param_types.make
			add_physician_param_types.compare_objects
			add_physician_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MD", create {ETF_INT_PARAM}))
			add_physician_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("NAME", create {ETF_STR_PARAM}))
			add_physician_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("PHYSICIAN_TYPE", create {ETF_ENUM_PARAM}.make(<<"generalist", "specialist">>)))
			Result.extend (add_physician_param_types, "add_physician")
			create add_patient_param_types.make
			add_patient_param_types.compare_objects
			add_patient_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_PT", create {ETF_INT_PARAM}))
			add_patient_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("NAME", create {ETF_STR_PARAM}))
			Result.extend (add_patient_param_types, "add_patient")
			create add_medication_param_types.make
			add_medication_param_types.compare_objects
			add_medication_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}))
			add_medication_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MEDICATION", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("name", create {ETF_NAMED_PARAM_TYPE}.make("NAME", create {ETF_STR_PARAM})), create {ETF_PARAM_DECL}.make("kind", create {ETF_NAMED_PARAM_TYPE}.make("KIND", create {ETF_ENUM_PARAM}.make(<<"pill", "liquid">>))), create {ETF_PARAM_DECL}.make("low", create {ETF_VALUE_PARAM}), create {ETF_PARAM_DECL}.make("hi", create {ETF_VALUE_PARAM})>>)))
			Result.extend (add_medication_param_types, "add_medication")
			create add_interaction_param_types.make
			add_interaction_param_types.compare_objects
			add_interaction_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}))
			add_interaction_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}))
			Result.extend (add_interaction_param_types, "add_interaction")
			create new_prescription_param_types.make
			new_prescription_param_types.compare_objects
			new_prescription_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_RX", create {ETF_INT_PARAM}))
			new_prescription_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MD", create {ETF_INT_PARAM}))
			new_prescription_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_PT", create {ETF_INT_PARAM}))
			Result.extend (new_prescription_param_types, "new_prescription")
			create add_medicine_param_types.make
			add_medicine_param_types.compare_objects
			add_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_RX", create {ETF_INT_PARAM}))
			add_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}))
			add_medicine_param_types.extend (create {ETF_VALUE_PARAM})
			Result.extend (add_medicine_param_types, "add_medicine")
			create remove_medicine_param_types.make
			remove_medicine_param_types.compare_objects
			remove_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_RX", create {ETF_INT_PARAM}))
			remove_medicine_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}))
			Result.extend (remove_medicine_param_types, "remove_medicine")
			create prescriptions_q_param_types.make
			prescriptions_q_param_types.compare_objects
			prescriptions_q_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("ID_MN", create {ETF_INT_PARAM}))
			Result.extend (prescriptions_q_param_types, "prescriptions_q")
			create dpr_q_param_types.make
			dpr_q_param_types.compare_objects
			Result.extend (dpr_q_param_types, "dpr_q")
		end
feature -- comments for contracts
	comment(s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end