note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_MEDICATION
inherit
	ETF_ADD_MEDICATION_INTERFACE
		redefine add_medication end
create
	make
feature -- command
	add_medication(id: INTEGER_64 ; medicine: TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE])
		require else
			add_medication_precond(id, medicine)
    	do
    		model.set_output_mode(0)

			if id < 1 then
				model.set_message ("medication id must be a positive integer")
			elseif model.list_medication.has_key (id) then
				model.set_message ("medication id already in use")
			elseif not medicine.name.at (1).is_alpha then
				model.set_message ("medication name must start with a letter")
			elseif model.is_medication_name_in_use (medicine.name)  then
				model.set_message ("medication name already in use")
			elseif not (medicine.low.is_greater (medicine.low.zero)) or not (medicine.low.is_less_equal (medicine.hi)) then
				model.set_message ("require 0 < low-dose <= hi-dose")
			else
				model.set_message ("ok")
				model.add_medication (id, medicine)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
