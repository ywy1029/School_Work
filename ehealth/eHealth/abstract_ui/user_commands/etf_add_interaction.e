note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_INTERACTION
inherit
	ETF_ADD_INTERACTION_INTERFACE
		redefine add_interaction end
create
	make
feature -- command
	add_interaction(id1: INTEGER_64 ; id2: INTEGER_64)
		require else
			add_interaction_precond(id1, id2)
    	do
    		model.set_output_mode(0)

			if id1 < 0 or id2 < 0 then
				model.set_message ("medication ids must be positive integers")
			elseif id1 = id2 then
				model.set_message ("medication ids must be different")
			elseif  not (model.list_medication.has_key (id1)) or not (model.list_medication.has_key (id2)) then
				model.set_message ("medications with these ids must be registered")
			elseif model.get_interact_with (id1).has (id2) then
				model.set_message ("interaction already exists")
			elseif model.is_adding_interaction_in_generalist_prescription (id1, id2) then
				model.set_message ("first remove conflicting medicine prescribed by generalist")
			else
				model.set_message ("ok")
				model.add_interaction (id1, id2)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
