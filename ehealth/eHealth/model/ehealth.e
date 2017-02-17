note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	EHEALTH

inherit
	ANY
		redefine
			out
		end

create {EHEALTH_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			i := 0
			output_mode := 0
			create message.make_from_string ("ok")
			create dpr_q_message.make_from_string ("")
			create prescriptions_q_message.make_from_string ("")

			create list_physician.make_equal (10)
			create list_patient.make_equal (10)
			create list_medication.make_equal (10)
			create list_interaction.make (10)
			create list_prescription.make_equal (10)
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	output_mode : INTEGER
	dpr_q_message : STRING
	prescriptions_q_message : STRING
	message : STRING

	list_physician : HASH_TABLE[PHYSICIAN,INTEGER_64]
	list_patient : HASH_TABLE[PATIENT,INTEGER_64]
	list_medication : HASH_TABLE[MEDICATION,INTEGER_64]
	list_interaction: ARRAYED_LIST[TUPLE[a:INTEGER_64; b:INTEGER_64]]
	list_prescription : HASH_TABLE[PRESCRIPTION,INTEGER_64]

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

	set_output_mode(mode: INTEGER)
		do
			output_mode := mode
		end

	set_message(m:STRING)
		do
			message := m
		end

	add_physician(id: INTEGER_64; name: STRING; kind: INTEGER_64)
		-- Create a physician object and add it to list_physcian
		require
			positive_id: id > 0
			id_is_not_used: not list_physician.has_key (id)
			valid_name: name.at (1).is_alpha
		local
			new_physician : PHYSICIAN
		do
			create new_physician.make (id, name, kind)
			list_physician.extend (new_physician, id)
		ensure
			count_increased: list_physician.count = old list_physician.count + 1
			physician_added: attached list_physician.at (id) as a implies (a.phys_name ~ name and a.phys_type = kind)
		end

	add_patient(id: INTEGER_64; name: STRING)
		-- Create a patient object and add it to list_patient
		require
			positive_id: id > 0
			id_is_not_used: not list_patient.has_key (id)
			valid_name: name.at (1).is_alpha
		local
			new_patient : PATIENT
		do
			create new_patient.make (id, name)
			list_patient.extend (new_patient, id)
		ensure
			count_increased: list_patient.count = old list_patient.count + 1
			physician_added: attached list_patient.at (id) as a implies (a.pati_name ~ name)
		end

	add_medication(id: INTEGER_64; medicine: TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE])
		-- Create a medication object and add it to list_medication
		require
			positive_id: id > 0
			id_is_not_used: not list_medication.has_key (id)
			valid_name: medicine.name.at (1).is_alpha
			name_id_not_used: not is_medication_name_in_use (medicine.name)
			valid_dose: medicine.low.is_greater (medicine.low.zero) and medicine.low.is_less_equal (medicine.hi)
		local
			new_medication : MEDICATION
		do
			create new_medication.make (id, medicine)
			list_medication.extend (new_medication, id)
		ensure
			count_increased: list_medication.count = old list_medication.count + 1
			medication_added: list_medication.has (id)
		end

	add_interaction(id1: INTEGER_64; id2: INTEGER_64)
		-- Create a interaction object and add it to list_interaction
		require
			positive_id: id1 > 0 and id2 > 0
			ids_are_different: id1 /= id2
			medication_is_registered: list_medication.has_key (id1) and list_medication.has_key (id2)
			interaction_not_exsist: not (get_interact_with (id1).has (id2))
			not_prescribed_by_generalist: not is_adding_interaction_in_generalist_prescription (id1, id2)
		local
			new_interaction : TUPLE[INTEGER_64,INTEGER_64]
		do
			create new_interaction.default_create

			if attached list_medication.at (id1) as medi_a and attached list_medication.at(id2) as medi_b then
				if medi_a.medicine.name.is_less (medi_b.medicine.name) then
					new_interaction.put_integer_64 (id1, 1)
					new_interaction.put_integer_64 (id2, 2)
				else
					new_interaction.put_integer_64 (id2, 1)
					new_interaction.put_integer_64 (id1, 2)
				end
			end
			list_interaction.extend (new_interaction)
		ensure
			count_increased: list_interaction.count = old list_interaction.count + 1
			interaction_added: get_interact_with (id1).has (id2)
		end

	new_prescription(id: INTEGER_64 ; doctor: INTEGER_64 ; patient: INTEGER_64)
		-- Create a prescription object and add it to list_prescription
		require
			positive_id: id > 0
			id_is_not_used: not list_prescription.has_key (id)
			positive_doctor_id: doctor > 0
			physician_is_registered: list_physician.has_key (doctor)
			positive_patient_id: patient > 0
			patient_is_registered: list_patient.has_key (patient)
			prescription_not_exisit: not is_prescription_exist (doctor, patient)
		local
			n_prescription : PRESCRIPTION
		do
			create n_prescription.make (id, doctor, patient)
			list_prescription.extend (n_prescription, id)
		ensure
			count_increased: list_prescription.count = old list_prescription.count + 1
			prescription_added: attached list_prescription.at (id) as a implies (a.doctor_id = doctor and a.patient_id = patient)
		end

	add_medicine (id: INTEGER_64; medicine:INTEGER_64; dose: VALUE)
		-- Create a TUPLE with medication id and dose into a prescription
		require
			positive_id: id > 0
			prescription_id_registered: list_prescription.has_key (id)
			positive_medicine_id: medicine > 0
			medication_id_registered: list_medication.has (medicine)
			medicine_not_prescripted: attached list_prescription.at (id) as pres implies (not(is_medcine_prescribed_on_patient (pres.patient_id, medicine)))
			valid_dangerouse_interaction: not not_allow_to_add_dangerous_interaction (id, medicine)
			valid_dose: is_valid_dose (dose, medicine)
		local
			new_medicine : TUPLE[INTEGER_64, VALUE]
		do
			create new_medicine.default_create
			new_medicine.put_integer_64 (medicine, 1)
			new_medicine.put (dose, 2)
			if attached list_prescription.at (id) as pres then
				pres.list_medicine.extend (new_medicine)
			end
		ensure
			count_increased: attached list_prescription.at (id) as pres implies (pres.has_medicine (medicine))
		end

	dpr_q
		local
			name_sorted_dpr_q : SORTED_TWO_WAY_LIST[DPR_Q_ITEM]
			local_dpr_q_item: DPR_Q_ITEM
		do
			create name_sorted_dpr_q.make

			from
				list_patient.start
			until
				list_patient.after
			loop
				create local_dpr_q_item.make(list_patient.item_for_iteration.id, list_patient.item_for_iteration.pati_name)
				from
					list_interaction.start
				until
					list_interaction.after
				loop
					if is_medcine_prescribed_on_patient(list_patient.item_for_iteration.id, list_interaction.item_for_iteration.a) and
					is_medcine_prescribed_on_patient(list_patient.item_for_iteration.id, list_interaction.item_for_iteration.b) then
						local_dpr_q_item.add_dangerous_interaction (list_interaction.item_for_iteration)
					end
					list_interaction.forth
				end
				if local_dpr_q_item.dpr_q_interaction.count > 0 then
					name_sorted_dpr_q.extend (local_dpr_q_item)
				end
				list_patient.forth
			end

			create dpr_q_message.make_from_string ("%N  ")
			if name_sorted_dpr_q.count > 0 then
				dpr_q_message.append ("There are dangerous prescriptions:")
				name_sorted_dpr_q.sort
				from
					name_sorted_dpr_q.start
				until
					name_sorted_dpr_q.after
				loop
					dpr_q_message.append("%N    ")
					dpr_q_message.append(name_sorted_dpr_q.item_for_iteration.out_dpr_item(list_medication))
					name_sorted_dpr_q.forth
				end
			else
				dpr_q_message.append ("There are no dangerous prescriptions")
			end

		end

	remove_medicine(id: INTEGER_64; medicine:INTEGER_64)
		-- Remove a medicine from a prescription with given id
		require
			positive_id: id > 0
			prescription_id_registered: list_prescription.has_key (id)
			positive_medicine_id: medicine > 0
			medication_id_registered: list_medication.has (medicine)
			medicine_is_in_prescription: is_medcine_in_prescription (id, medicine)
		do
			-- remove from prescription
			if attached list_prescription.at (id) as pres then
				if attached pres.list_medicine as l_medi then
					from
						l_medi.start
					until
						l_medi.after
					loop
						if medicine = l_medi.item_for_iteration.m_id then
							l_medi.remove
						end
						if not(l_medi.after) then
							l_medi.forth
						end
					end
				end
			end
		end

	prescriptions_q(medication_id: INTEGER_64)
		local
			sort_patient : SORTED_TWO_WAY_LIST[INTEGER_64]
		do
			create sort_patient.make
			create prescriptions_q_message.make_from_string ("%N  Output: ")

			from
				list_prescription.start
			until
				list_prescription.after
			loop
				from
					list_prescription.item_for_iteration.list_medicine.start
				until
					list_prescription.item_for_iteration.list_medicine.after
				loop
					if medication_id = list_prescription.item_for_iteration.list_medicine.item_for_iteration.m_id then
						sort_patient.extend (list_prescription.item_for_iteration.patient_id)
					end
					list_prescription.item_for_iteration.list_medicine.forth
				end

				list_prescription.forth
			end
			sort_patient.sort

			if sort_patient.count > 0 and attached list_medication.at (medication_id) as medi then
				prescriptions_q_message.append ("medication is " + medi.medicine.name)
			end
			from
				sort_patient.start
			until
				sort_patient.after
			loop
				if attached list_patient.at (sort_patient.item_for_iteration) as pati then
					prescriptions_q_message.append ("%N    " + pati.id.out + "->" + pati.pati_name)
				end

				sort_patient.forth
			end
		end

feature -- queries
	out : STRING
		local
			sorted_list : SORTED_TWO_WAY_LIST[SORTABLE]
		do
			create Result.make_from_string ("  ")
			Result.append (i.out+": "+message)

			if output_mode = 0 then	-- normal
				Result.append ("%N  Physicians:")
				sorted_list := sort_list(list_physician)
				Result.append (out_listitem(sorted_list))

				Result.append ("%N  Patients: ")
				sorted_list := sort_list(list_patient)
				Result.append (out_listitem(sorted_list))

				Result.append ("%N  Medications: ")
				sorted_list := sort_list(list_medication)
				Result.append (out_listitem(sorted_list))

				Result.append ("%N  Interactions: ")
				Result.append (out_interaction)

				Result.append ("%N  Prescriptions:")
				sorted_list := sort_list(list_prescription)
				Result.append (out_listitem(sorted_list))
			elseif output_mode = 1 then -- dpr_q
				Result.append (dpr_q_message)
			elseif output_mode = 2 then -- prescriptions_q
				Result.append (prescriptions_q_message)
			end
		end

	out_listitem(a_list : LIST[SORTABLE]) : STRING
		do
			create Result.make_from_string ("")
			from
				a_list.start
			until
				a_list.after
			loop
				Result.append("%N    ")
				Result.append(a_list.item_for_iteration.out)
				a_list.forth
			end
		end

	sort_list(a_list: HASH_TABLE[SORTABLE, INTEGER_64]) : SORTED_TWO_WAY_LIST[SORTABLE]
		do
			create Result.make
			from
				a_list.start
			until
				a_list.after
			loop
				Result.extend (a_list.item_for_iteration)
				a_list.forth
			end
			Result.sort
		end

	out_interaction : STRING
		do
			create Result.make_from_string ("")
			from
				list_interaction.start
			until
				list_interaction.after
			loop
				Result.append("%N    ")
				if attached list_medication.at (list_interaction.item_for_iteration.a) as medi_a and attached list_medication.at(list_interaction.item_for_iteration.b) as medi_b then
					Result.append ("[")
					Result.append (medi_a.medicine.name.out)
					Result.append (",")
					Result.append (medi_a.get_kind)
					Result.append (",")
					Result.append (medi_a.id.out)
					Result.append ("]")
					Result.append ("->")
					Result.append ("[")
					Result.append (medi_b.medicine.name.out)
					Result.append (",")
					Result.append (medi_b.get_kind)
					Result.append (",")
					Result.append (medi_b.id.out)
					Result.append ("]")
				end
				list_interaction.forth
			end
		end

	is_medication_name_in_use(str : STRING) : BOOLEAN
		-- check whether medication name already in use
		do
			Result := false
			from
				list_medication.start
			until
				list_medication.after
			loop
				if str ~ list_medication.item_for_iteration.medicine.name then
					Result := true
				end
				list_medication.forth
			end
		end

	is_prescription_exist(doctor: INTEGER_64; patient :INTEGER_64) : BOOLEAN
		do
			Result := false
			from
				list_prescription.start
			until
				list_prescription.after or Result = true
			loop
				if doctor = list_prescription.item_for_iteration.doctor_id
				and patient = list_prescription.item_for_iteration.patient_id then
					Result := true
				end
				list_prescription.forth
			end
		end

	is_medcine_prescribed_on_patient(pati_id: INTEGER_64; medicine :INTEGER_64) : BOOLEAN
		do
			Result := false

			from
				list_prescription.start
			until
				list_prescription.after or Result = true
			loop
				if pati_id = list_prescription.item_for_iteration.patient_id then
					if list_prescription.item_for_iteration.has_medicine (medicine) then
						Result := true
					end
				end
				list_prescription.forth
			end
		end

	is_medcine_in_prescription(pres_id: INTEGER_64; medicine :INTEGER_64) : BOOLEAN
		do
			Result := false
			if attached list_prescription.at (pres_id) as pres then
				Result := pres.has_medicine (medicine)
			end
		end

	is_adding_dangerous_interaction(pres_id: INTEGER_64; medicine :INTEGER_64) : BOOLEAN
		local
			interact_with : ARRAYED_LIST[INTEGER_64]
			patient_id : INTEGER_64
		do
			Result := false
			interact_with := get_interact_with(medicine)

			-- get patient id by given prescription id
			if attached list_prescription.at (pres_id) as pres then
				patient_id := pres.patient_id
			end

			-- check if is adding a dangerous interaction
			if interact_with.count /= 0 then
				from
					list_prescription.start
				until
					list_prescription.after or Result = true
				loop
					if attached list_prescription.item_for_iteration as curr_pres then
						if curr_pres.patient_id = patient_id then
							from
								curr_pres.list_medicine.start
							until
								curr_pres.list_medicine.after or Result = true
							loop
								if interact_with.has (curr_pres.list_medicine.item_for_iteration.m_id) then
									Result := true
								end
								curr_pres.list_medicine.forth
							end
						end
					end
					list_prescription.forth
				end
			end
		end

	not_allow_to_add_dangerous_interaction(pres_id: INTEGER_64; medicine :INTEGER_64) : BOOLEAN
		do
			Result := is_adding_dangerous_interaction(pres_id, medicine)
			if Result = true then
				if attached list_prescription.at (pres_id) as pres then
					if attached list_physician.at (pres.doctor_id) as phys then
						if phys.phys_type = 4 then
							Result := false
						end
					end
				end
			end

		end

	is_adding_interaction_in_generalist_prescription(medi_id1: INTEGER_64; medi_id2:INTEGER_64) : BOOLEAN
		do
			Result := false

			from
				list_prescription.start
			until
				list_prescription.after or Result = true
			loop
				if attached list_prescription.item_for_iteration as curr_pres then
					if attached list_physician.at (curr_pres.doctor_id) as curr_phys then
						if curr_phys.phys_type /= 4 and curr_pres.has_medicine (medi_id1) and curr_pres.has_medicine (medi_id2) then
							Result := true
						end
					end
				end
				list_prescription.forth
			end
		end

	is_valid_dose(dose: VALUE; medicine: INTEGER_64) : BOOLEAN
		do
			Result := false
			if attached list_medication.at (medicine) as medi then
				if dose.is_greater_equal (medi.medicine.low) and dose.is_less_equal (medi.medicine.hi) then
					Result := true
				end
			end
		end

	get_interact_with(a_id: INTEGER_64) : ARRAYED_LIST[INTEGER_64]
		do
			create Result.make (10)
			from
				list_interaction.start
			until
				list_interaction.after
			loop
				if a_id = list_interaction.item_for_iteration.a then
					Result.extend (list_interaction.item_for_iteration.b)
				end
				if a_id = list_interaction.item_for_iteration.b then
					Result.extend (list_interaction.item_for_iteration.a)
				end
				list_interaction.forth
			end
		end

end




