note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_PHYSICIAN
inherit
	ETF_ADD_PHYSICIAN_INTERFACE
		redefine add_physician end
create
	make
feature -- command
	add_physician(id: INTEGER_64 ; name: STRING ; kind: INTEGER_64)
		require else
			add_physician_precond(id, name, kind)
    	do
    		model.set_output_mode(0)

			if id < 1 then
				model.set_message ("physician id must be a positive integer")
			elseif model.list_physician.has_key (id) then
				model.set_message ("physician id already in use")
			elseif not name.at (1).is_alpha then
				model.set_message ("name must start with a letter")
			else
				model.set_message ("ok")
				model.add_physician (id, name, kind)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
