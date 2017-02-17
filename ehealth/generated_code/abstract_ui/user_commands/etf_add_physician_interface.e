note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_PHYSICIAN_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_physician(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as id and then attached {STRING} etf_cmd_args[2] as name and then attached {INTEGER_64} etf_cmd_args[3] as kind
			then
				out := "add_physician(" + etf_event_argument_out("add_physician", "id", id) + "," + etf_event_argument_out("add_physician", "name", name) + "," + etf_event_argument_out("add_physician", "kind", kind) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_physician_precond(id: INTEGER_64 ; name: STRING ; kind: INTEGER_64): BOOLEAN
		do  
			Result := 
				         comment ("ID_MD = INTEGER_64")
				and then comment ("NAME = STRING")
				and then 
				is_physician_type(kind)
					-- (( kind ~ generalist ) or else ( kind ~ specialist ))
		ensure then  
			Result = 
				         comment ("ID_MD = INTEGER_64")
				and then comment ("NAME = STRING")
				and then 
				is_physician_type(kind)
					-- (( kind ~ generalist ) or else ( kind ~ specialist ))
		end 
feature -- command 
	add_physician(id: INTEGER_64 ; name: STRING ; kind: INTEGER_64)
		require 
			add_physician_precond(id, name, kind)
    	deferred
    	end
end
