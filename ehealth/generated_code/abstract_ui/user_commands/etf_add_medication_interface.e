note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_MEDICATION_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_medication(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as id and then attached {TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE]} etf_cmd_args[2] as medicine
			then
				out := "add_medication(" + etf_event_argument_out("add_medication", "id", id) + "," + etf_event_argument_out("add_medication", "medicine", medicine) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_medication_precond(id: INTEGER_64 ; medicine: TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE]): BOOLEAN
		do  
			Result := 
				         comment ("ID_MN = INTEGER_64")
				and then 
				is_medication(medicine)
					-- (( medicine.kind ~ pill ) or else ( medicine.kind ~ liquid ))
		ensure then  
			Result = 
				         comment ("ID_MN = INTEGER_64")
				and then 
				is_medication(medicine)
					-- (( medicine.kind ~ pill ) or else ( medicine.kind ~ liquid ))
		end 
feature -- command 
	add_medication(id: INTEGER_64 ; medicine: TUPLE[name: STRING; kind: INTEGER_64; low: VALUE; hi: VALUE])
		require 
			add_medication_precond(id, medicine)
    	deferred
    	end
end
