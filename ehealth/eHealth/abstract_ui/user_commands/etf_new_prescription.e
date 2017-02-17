note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_PRESCRIPTION
inherit
	ETF_NEW_PRESCRIPTION_INTERFACE
		redefine new_prescription end
create
	make
feature -- command
	new_prescription(id: INTEGER_64 ; doctor: INTEGER_64 ; patient: INTEGER_64)
		require else
			new_prescription_precond(id, doctor, patient)
    	do
    		model.set_output_mode(0)

			if id < 1 then
				model.set_message ("prescription id must be a positive integer")
			elseif model.list_prescription.has_key (id) then
				model.set_message ("prescription id already in use")
			elseif doctor < 1 then
				model.set_message ("physician id must be a positive integer")
			elseif not model.list_physician.has_key (doctor) then
				model.set_message ("physician with this id not registered")
			elseif patient < 1 then
				model.set_message ("patient id must be a positive integer")
			elseif not model.list_patient.has_key (patient) then
				model.set_message ("patient with this id not registered")
			elseif model.is_prescription_exist (doctor, patient) then
				model.set_message ("prescription already exists for this physician and patient")
			else
				model.set_message ("ok")
				model.new_prescription (id, doctor, patient)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
