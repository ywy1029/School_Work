note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_PATIENT_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_patient(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as id and then attached {STRING} etf_cmd_args[2] as name
			then
				out := "add_patient(" + etf_event_argument_out("add_patient", "id", id) + "," + etf_event_argument_out("add_patient", "name", name) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_patient_precond(id: INTEGER_64 ; name: STRING): BOOLEAN
		do  
			Result := 
				         comment ("ID_PT = INTEGER_64")
				and then comment ("NAME = STRING")
		ensure then  
			Result = 
				         comment ("ID_PT = INTEGER_64")
				and then comment ("NAME = STRING")
		end 
feature -- command 
	add_patient(id: INTEGER_64 ; name: STRING)
		require 
			add_patient_precond(id, name)
    	deferred
    	end
end
