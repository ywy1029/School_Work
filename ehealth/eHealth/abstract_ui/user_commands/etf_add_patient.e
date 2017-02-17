note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_PATIENT
inherit
	ETF_ADD_PATIENT_INTERFACE
		redefine add_patient end
create
	make
feature -- command
	add_patient(id: INTEGER_64 ; name: STRING)
		require else
			add_patient_precond(id, name)
    	do
    		model.set_output_mode(0)

			if id < 1 then
				model.set_message ("patient id must be a positive integer")
			elseif model.list_patient.has_key (id) then
				model.set_message ("patient id already in use")
			elseif not name.at (1).is_alpha then
				model.set_message ("name must start with a letter")
			else
				model.set_message ("ok")
				model.add_patient (id, name)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
