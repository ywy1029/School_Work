note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_MEDICINE
inherit
	ETF_ADD_MEDICINE_INTERFACE
		redefine add_medicine end
create
	make
feature -- command
	add_medicine(id: INTEGER_64 ; medicine: INTEGER_64 ; dose: VALUE)
		require else
			add_medicine_precond(id, medicine, dose)
    	do
    		model.set_output_mode(0)

			if id < 1 then
				model.set_message ("prescription id must be a positive integer")
			elseif not (attached model.list_prescription.at (id) as pres) then
				model.set_message ("prescription with this id does not exist")
			elseif medicine < 1 then
				model.set_message ("medication id must be a positive integer")
			elseif not model.list_medication.has (medicine)  then
				model.set_message ("medication id must be registered")
			elseif model.is_medcine_prescribed_on_patient (pres.patient_id, medicine) then
				model.set_message ("medication is already prescribed")
			elseif model.not_allow_to_add_dangerous_interaction (id, medicine) then
				model.set_message ("specialist is required to add a dangerous interaction")
			elseif not model.is_valid_dose (dose, medicine) then
				model.set_message ("dose is outside allowed range")
			else
				model.set_message ("ok")
				model.add_medicine (id, medicine, dose)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
