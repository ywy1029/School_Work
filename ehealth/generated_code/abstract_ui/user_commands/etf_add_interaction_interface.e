note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_INTERACTION_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_interaction(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as id1 and then attached {INTEGER_64} etf_cmd_args[2] as id2
			then
				out := "add_interaction(" + etf_event_argument_out("add_interaction", "id1", id1) + "," + etf_event_argument_out("add_interaction", "id2", id2) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_interaction_precond(id1: INTEGER_64 ; id2: INTEGER_64): BOOLEAN
		do  
			Result := 
				comment ("ID_MN = INTEGER_64")
		ensure then  
			Result = 
				comment ("ID_MN = INTEGER_64")
		end 
feature -- command 
	add_interaction(id1: INTEGER_64 ; id2: INTEGER_64)
		require 
			add_interaction_precond(id1, id2)
    	deferred
    	end
end
